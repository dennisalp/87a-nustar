'''
2020-10-12, Dennis Alp, dalp@kth.se

Extract distribution of shocks from XSPEC logs and plot distributions.
'''

from __future__ import division, print_function
import os
from pdb import set_trace as db
import sys
from glob import glob
import time
from datetime import date
from datetime import timedelta
from tqdm import tqdm

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as md
from astropy.coordinates import SkyCoord
from astropy.wcs import WCS
from astropy.io import fits
from astropy import units
from astropy.time import Time

#For LaTeX style font in plots
plt.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
plt.rc('text', usetex=True)

# Constants, cgs
cc = 2.99792458e10 # cm s-1
GG = 6.67259e-8 # cm3 g-1 s-2
hh = 6.6260755e-27 # erg s
DD = 51.2 # kpc
pc = 3.086e18 # cm
kpc = 3.086e21 # cm
mpc = 3.086e24 # cm
kev2erg = 1.60218e-9 # erg keV-1
Msun = 1.989e33 # g
Lsun = 3.828e33 # erg s-1
Rsun = 6.957e10 # cm
Tsun = 5772 # K
uu = 1.660539040e-24 # g
SBc = 5.670367e-5 # erg cm-2 K-4 s-1
kB = 1.38064852e-16 # erg K-1
mp = 1.67262192369e-24 # g


################################################################


# Days for scaling
SNDATE = date(1987, 2, 23)
def get_yrs(dd):
    return (date(dd[0], dd[1], dd[2])-SNDATE).days

def d2yr(d):
    d = SNDATE+timedelta(d)
    y = d.year
    r = (d-date(y, 1, 1)).total_seconds()
    return y + r/(date(y+1, 1, 1)-date(y, 1, 1)).total_seconds()

def yr2d(y):
    ye = int(y)
    r = y - ye
    b = date(ye, 1, 1)
    b += timedelta(seconds=np.ceil((b.replace(year=b.year+1)-b).total_seconds()*r))
    return (b-SNDATE).days

def get_em(pp):
    ff = open(pp, 'r')
    ff = ff.readlines()

    par = []
    con = []
    em = []
    ts = []
    chi = dof = -1

    for ll in reversed(ff):
        if ll == '                           Data group: 5\n':
            break # Stop before going into the 4 RGS spectra
        elif '                           Data group: ' in ll:
            par = []
            em = []
            ts = []
        elif ll[12:43] == 'vpshock    norm                ':
            em.append(float(ll.split()[4]))
        elif ll[12:43] == 'vpshock    kT         keV      ':
            ts.append(float(ll.split()[5]))
        elif ll[4:43] == '   12   constant   factor              ':
            con.append(float(ll.split()[4]))
        elif ll[12:43] == 'constant   factor              ':
            par.append(float(ll.split()[4]))
        elif ll[:40] == 'Total fit statistic                     ':
            chi = float(ll.split()[3])
            dof = int(ll.split()[5])

    par = np.array(par[::-1])
    em = np.array(em[::-1])
    ts = np.array(ts[::-1])
    con = np.array(con[::-1])
    em = em*n2em*np.average(con)
    return par, con, ts, em, chi, dof

def get_title(pp):
    pl = 'no ' if 'pl0' in pp else ''
    title = '$T_\mathrm{{max}} = {0:d}$~keV, ' + pl + 'extra PL'

    em = pp.split('/')[-1]
    em = em.split('_')[1][2:]
    em = int(em)
    return title.format(em)

def get_lab(chi, dof, ii):
    tmp = '{3:d}: ${0:.0f}/{1:d}={2:.2f}$'
    tmp = tmp.format(chi, dof, chi/dof, ii)
    return tmp

def plt_tau(ax1, d2, p2, pp, hh, ll):
    c = 'tab:olive'
    ax2 = ax1.twinx()
    ax2.set_ylabel('$\\tau$ (s~cm$^{-3}$)', color='k')
    print('\n' + pp)

    # tmp = 'OLD std(d2): {0:.3e}, std(pp): {1:.3e}'
    # tmp = tmp.format(np.std(d2), np.std(p2))
    # print(tmp)
    tmp = 'min(d2): {0:.3e}, min(pp): {1:.3e}, max(d2): {2:.3e}, max(pp): {3:.3e}'
    d2_min, p2_min, d2_max, p2_max = np.min(d2), np.min(p2), np.max(d2), np.max(p2)
    tmp = tmp.format(d2_min, p2_min, d2_max, p2_max)
    print(tmp)

    e_peaks = np.array([0.3, 0.9, 4])[np.newaxis,:]
    epoch = 1e4*24*3600
    den = d2[:,np.newaxis]*e_peaks**p2[:,np.newaxis]/epoch
    den_max = np.amax(den, axis=0)
    den_avg = np.mean(den, axis=0)
    den_min = np.amin(den, axis=0)
    den_low = den_min-den_avg
    den_hig = den_max-den_avg
    tmp = 'den: ${0:.3e}_{1:.3e}^{2:.3e}$'
    print(tmp.format(den_avg[0], den_low[0], den_hig[0]))
    print(tmp.format(den_avg[1], den_low[1], den_hig[1]))
    print(tmp.format(den_avg[2], den_low[2], den_hig[2]))

    d2 = np.average(d2)
    p2 = np.average(p2)
    tmp = 'E(d2): ${0:.3e}_{1:.3e}^{2:.3e}$, E(pp): ${3:.3e}_{4:.3e}^{5:.3e}$'
    tmp = tmp.format(d2, d2_min-d2, d2_max, p2, p2_min-p2, p2_max-p2)
    print(tmp)

    ts = np.array([tmin, tmax])
    ax2.plot(ts, d2*ts**p2, '--', color=c, zorder=1)
    ax2.set_yscale('log')
    ax2.tick_params(axis='y', labelcolor='k')

    ax2.plot(t1[::2], tau1[::2], color='tab:blue', zorder=850, marker='o', ls='None')
    ax2.plot(t1[1::2], tau1[1::2], color='tab:blue', zorder=900, marker='^', ls='None')
    ax2.plot(t8[2:], tau8[2:], color='tab:gray', zorder=800, marker='o', ls='None')
    ax2.plot(t8[:2], tau8[:2], color='tab:gray', zorder=890, marker='^', ls='None')
    for t in t1: ax2.axvline(t, ls=':', color='tab:blue', zorder=2)
    for t in t8: ax2.axvline(t, ls=':', color='tab:gray', zorder=3)
    ax2.set_zorder(2)  # default zorder is 0 for ax1 and ax2

    legend = ax2.legend(hh, ll, handlelength=0.6, framealpha=0.8, loc='upper right').set_zorder(20002)
    
def plt_plasma(logs):
    ax1 = plt.gca()    
    d2 = np.empty(len(logs))
    p2 = np.empty(len(logs))

    for ii, pp in enumerate(logs):
        print(pp)
        par, con, ts, em, chi, dof = get_em(pp)

        d2[ii] = par[0]
        p2[ii] = par[1]
        tmp = get_lab(chi, dof, ii+1)
        save_dof.append(dof)
        tmp = '\phantom{0,}' if tt[ii] < 10000 else ''
        tmp += str(int(tt[ii])) + '~d'
        if tt[ii] >= 10000: tmp = tmp[:2] + ',' + tmp[2:]
        plt.semilogx(ts, em/1e58, label=tmp)

        # if ii == 0:
        #     for t in t1:
        #         plt.axvline(t, ls=':', color='tab:blue', zorder=2)
        # elif ii == 7:
        #     for t in t8:
        #         plt.axvline(t, ls=':', color='tab:gray', zorder=3)
    
    plt.ylabel('EM ($10^{58}$~cm$^{-3}$)')
    plt.xlabel('$T$ (keV)')
    title = get_title(pp)
    # plt.title(title)

    hh, ll = ax1.get_legend_handles_labels()
    plt_tau(ax1, d2, p2, pp, hh, ll)

    ylim = ax1.get_ylim()
    ax1.set_ylim(bottom=0, top=1.3*ylim[1])
    ax1.set_xlim(left=tmin, right=tmax)

    ax1.set_zorder(1)  # default zorder is 0 for ax1 and ax2
    ax1.patch.set_visible(False)  # prevents ax1 from hiding ax2



################################################################
# Temperatures from 3-component model
tmin = 0.1
tmax = 10.
# temperatures for g1 and g8, they are hard coded, get them from com_g?.xcm
t1 = np.array([0.517015, 0.984855, 4.08498])
t8 = np.array([0.499579, 0.9798, 3.49364])
# com_g?_get_lim.txt for limits
tau1 = np.array([9.16303e+11, 1.728114185e+12, 3.27369e+11]) 
tau8 = np.array([7.81920458e+11, 1.842678024e+12, 5.10541e+11])

# NuSTAR
dates = {
    'g1': [2012,  9, 10],
    'g2': [2012, 10, 21],
    'g3': [2012, 12, 12],
    'g4': [2013,  6, 29],
    'g5': [2014,  4, 22],
    'g6': [2014,  6, 17],
    'g7': [2014,  8,  1],
    'g8': [2020,  5, 20],
    '0144530101': [2003,  5, 10],
    '0406840301': [2007,  1, 17],
    '0506220101': [2008,  1, 11],
    '0556350101': [2009,  1, 30],
    '0601200101': [2009, 12, 11],
    '0650420101': [2010, 12, 12],
    '0671080101': [2011, 12,  2],
    '0690510101': [2012, 12, 11],
    '0743790101': [2014, 11, 29],
    '0763620101': [2015, 11, 15],
    '0783250201': [2016, 11,  2],
    '0804980201': [2017, 10, 15],
    '0831810101': [2019, 11, 27]
    }

c0, c1, c2, c3, c4, c5, c6, c7, c8, c9 = '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf'
s1 = 4
s2 = 4
ms = 4
n2em = 1e14*4*np.pi*(51.2*kpc)**2 # norm to emission measure, xspec vpshock norm
t_range = np.linspace(9000, 12250, 1000)
save_dof = []

###############################################################
# Plots
logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em4_pl1_g?.txt'))
groups = [x.split('/')[-1][-6:-4] for x in logs]
tt = np.empty(len(groups))
for ii, gg in enumerate(groups):
    tt[ii] = get_yrs(dates[gg])
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em4_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em4_pl1_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em12_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em12_pl1_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em13_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em14_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em16_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_004_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_005_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_006_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_007_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_007_pl1_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_008_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_008_pl1_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_009_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_010_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# this is the one with xmm
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_011_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

# #
# logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_012_pl0_g?.txt'))
# plt.figure(figsize=(5, 3.75))
# plt_plasma(logs)

#
logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/dos_em10_013_pl0_g?.txt'))
plt.figure(figsize=(5, 3.75))
plt_plasma(logs)

out = '/Users/silver/box/phd/pro/87a/nus/art/fig/dos.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)

# plt.show()

print(np.average(np.array(save_dof)))
db()
