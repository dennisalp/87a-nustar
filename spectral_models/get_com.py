'''
2020-08-17, Dennis Alp, dalp@kth.se

Extract spectral component parameters from XSPEC logs and make temperature evolution plots and parameter table.
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

def hlp(ll):
    ll = ll.split()
    try:
        return [float(ll[3]), float(ll[4])]
    except:
        return [float(ll[4]), float(ll[5])]

def merge(mu, sig):
    if len(mu) == 1:
        return np.concatenate((mu, np.array(sig[0])-mu))
    mu = np.array(mu)
    sig = np.array(sig)
    ww = sig-mu[:,np.newaxis]
    ww = np.abs(ww)
    ww = np.average(ww, 1)
    ww = (1/ww)**2
    tmp = np.array([np.average(mu, weights=ww)])
    tm2 = np.average(sig, 0, weights=ww)
    tm2 = (tm2-tmp)/np.sqrt(ww.size-1)
    return np.concatenate((tmp, tm2))

def delog(ff):
    ff = 10**np.array([ff[0], ff[0]+ff[1], ff[0]+ff[2]])
    ff[1] = ff[1]-ff[0]
    ff[2] = ff[2]-ff[0]
    return ff

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

def mk_line(xx, yy, ye, cc, aa):
    ww = 1/np.average(ye,0)
    coef = np.polyfit(xx, yy, 1, w=ww)
    plt.plot(t_range, np.polyval(coef, t_range), color=cc, lw=0.75)


################################################################
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
ms = 5
t_range = np.linspace(9000, 12250, 1000)
n2em = 1e14*4*np.pi*(51.2*kpc)**2 # norm to emission measure, xspec vpshock norm

logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/com_g?.txt'))
groups = [x.split('/')[-1][4:6] for x in logs]
tt = np.empty(len(groups))
for ii, gg in enumerate(groups):
    tt[ii] = get_yrs(dates[gg])


kbt1 = []
tau1 = []
em1 = []
kbt2 = []
tau2 = []
em2 = []
kbt3 = []
tau3 = []
em3 = []
flx1 = []
flx2 = []
flx3 = []
con = []
chi = []
dof = []
for pp in logs:
    print(pp)
    mu_kbt1 = []
    sig_kbt1 = []
    mu_tau1 = []
    sig_tau1 = []
    mu_em1 = []
    sig_em1 = []
    mu_kbt2 = []
    sig_kbt2 = []
    mu_tau2 = []
    sig_tau2 = []
    mu_em2 = []
    sig_em2 = []
    mu_kbt3 = []
    sig_kbt3 = []
    mu_tau3 = []
    sig_tau3 = []
    mu_em3 = []
    sig_em3 = []
    mu_flx1 = []
    sig_flx1 = []
    mu_flx2 = []
    sig_flx2 = []
    mu_flx3 = []
    sig_flx3 = []
    mu_con = []
    sig_con = []
    
    chi_tmp = dof_tmp = -1
    ff = open(pp)
    for line in list(ff):
        if line[3:14] == 'temp1 param':
            mu_kbt1.append(float(line.split()[3]))
        elif line[3:14] == 'temp1 error':
            sig_kbt1.append(hlp(line))

        elif line[3:14] == 'temp2 param':
            mu_kbt2.append(float(line.split()[3]))
        elif line[3:14] == 'temp2 error':
            sig_kbt2.append(hlp(line))

        elif line[3:14] == 'temp3 param':
            mu_kbt3.append(float(line.split()[3]))
        elif line[3:14] == 'temp3 error':
            sig_kbt3.append(hlp(line))

        elif line[3:13] == 'tau1 param':
            mu_tau1.append(float(line.split()[3]))
        elif line[3:13] == 'tau1 error':
            sig_tau1.append(hlp(line))

        elif line[3:13] == 'tau2 param':
            mu_tau2.append(float(line.split()[3]))
        elif line[3:13] == 'tau2 error':
            sig_tau2.append(hlp(line))

        elif line[3:13] == 'tau3 param':
            mu_tau3.append(float(line.split()[3]))
        elif line[3:13] == 'tau3 error':
            sig_tau3.append(hlp(line))

        elif line[3:12] == 'em1 param':
            mu_em1.append(float(line.split()[3]))
        elif line[3:12] == 'em1 error':
            sig_em1.append(hlp(line))

        elif line[3:12] == 'em2 param':
            mu_em2.append(float(line.split()[3]))
        elif line[3:12] == 'em2 error':
            sig_em2.append(hlp(line))

        elif line[3:12] == 'em3 param':
            mu_em3.append(float(line.split()[3]))
        elif line[3:12] == 'em3 error':
            sig_em3.append(hlp(line))

        elif line[3:7] == 'flx1' and line[10:15] == 'param' and line[8:9] == '0':
            mu_flx1.append(float(line.split()[4]))
        elif line[3:7] == 'flx1' and line[10:15] == 'error' and line[8:9] == '0':
            sig_flx1.append(hlp(line))
        elif line[3:7] == 'flx2' and line[10:15] == 'param' and line[8:9] == '0':
            mu_flx2.append(float(line.split()[4]))
        elif line[3:7] == 'flx2' and line[10:15] == 'error' and line[8:9] == '0':
            sig_flx2.append(hlp(line))
        elif line[3:7] == 'flx3' and line[10:15] == 'param' and line[8:9] == '0':
            mu_flx3.append(float(line.split()[4]))
        elif line[3:7] == 'flx3' and line[10:15] == 'error' and line[8:9] == '0':
            sig_flx3.append(hlp(line))
        elif line[3:7] == 'flx0' and line[10:15] == 'param' and int(line[8:9]) >= 4:
            mu_con.append(float(line.split()[4]))
        elif line[3:7] == 'flx0' and line[10:15] == 'error' and int(line[8:9]) >= 4:
            sig_con.append(hlp(line))

        elif line[:40] == 'Total fit statistic                     ':
            chi_tmp = float(line.split()[3])
            dof_tmp = int(line.split()[5])


    kbt1.append(merge(mu_kbt1, sig_kbt1))
    tau1.append(merge(mu_tau1, sig_tau1))
    em1.append(merge(mu_em1, sig_em1))
    kbt2.append(merge(mu_kbt2, sig_kbt2))
    tau2.append(merge(mu_tau2, sig_tau2))
    em2.append(merge(mu_em2, sig_em2))
    kbt3.append(merge(mu_kbt3, sig_kbt3))
    tau3.append(merge(mu_tau3, sig_tau3))
    em3.append(merge(mu_em3, sig_em3))

    flx1.append(delog(merge(mu_flx1, sig_flx1)))
    flx2.append(delog(merge(mu_flx2, sig_flx2)))
    flx3.append(delog(merge(mu_flx3, sig_flx3)))
    con.append(merge(mu_con, sig_con))
    chi.append(chi_tmp)
    dof.append(dof_tmp)

kbt1 = np.array(kbt1)
tau1 = np.array(tau1)
em1 = np.array(em1)
kbt2 = np.array(kbt2)
tau2 = np.array(tau2)
em2 = np.array(em2)
kbt3 = np.array(kbt3)
tau3 = np.array(tau3)
em3 = np.array(em3)

flx1 = np.array(flx1)
flx2 = np.array(flx2)
flx3 = np.array(flx3)
con = np.array(con)
chi = np.array(chi)
dof = np.array(dof)

for cc in con:
    em1 = cc[0]*em1
    em2 = cc[0]*em2
    em3 = cc[0]*em3
    flx1 = cc[0]*flx1
    flx2 = cc[0]*flx2
    flx3 = cc[0]*flx3
    
################################################################
# Print table
print('\n\n\n')
for ii, gg in enumerate(groups):
    tmp =  '{27:<1s} & {28:>6s}'
    tmp += ' & ${0:.2f}_{{{1:.2f}}}^{{+{2:.2f}}}$'
    tmp += ' & ${3:.2f}_{{{4:.2f}}}^{{+{5:.2f}}}$'
    tmp += ' & ${6:.1f}_{{{7:.1f}}}^{{+{8:.1f}}}$'
    tmp += ' & ${9:.2f}_{{{10:.2f}}}^{{+{11:.2f}}}$'
    tmp += ' & ${12:.2f}_{{{13:.2f}}}^{{+{14:.2f}}}$'
    tmp += ' & ${15:.2f}_{{{16:.2f}}}^{{+{17:.2f}}}$'
    tmp += ' & ${18:.1f}_{{{19:.1f}}}^{{+{20:.1f}}}$'
    tmp += ' & ${21:.1f}_{{{22:.1f}}}^{{+{23:.1f}}}$'
    tmp += ' & ${24:.1f}_{{{25:.1f}}}^{{+{26:.1f}}}$ \\\\'

    aa = kbt1[ii,:]
    bb = kbt2[ii,:]
    cc = kbt3[ii,:]
    dd = tau1[ii,:]/1e12
    ee = tau2[ii,:]/1e12
    ff = tau3[ii,:]/1e12
    hh = em1[ii,:]*n2em/1e58
    jj = em2[ii,:]*n2em/1e58
    kk = em3[ii,:]*n2em/1e58
    

    gr = gg[1]
    t0 = int(tt[ii])
    t0 = str(t0)[:2] + ',' + str(t0)[2:] if t0 >= 10000 else str(t0)

    tmp = tmp.format(*aa, *bb, *cc, *dd, *ee, *ff, *hh, *jj, *kk, gr, t0)
    print(tmp)

print('\n\n\n')
for ii, gg in enumerate(groups):
    gr = gg[1]
    t0 = int(tt[ii])
    t0 = str(t0)[:2] + ',' + str(t0)[2:] if t0 >= 10000 else str(t0)

    tm2 =  '{0:<1s} & {1:>6s}'
    tm2 += ' & ${2:.1f}_{{{3:.1f}}}^{{+{4:.1f}}}$'
    tm2 += ' & ${5:.1f}_{{{6:.1f}}}^{{+{7:.1f}}}$'
    tm2 += ' & ${8:.1f}_{{{9:.1f}}}^{{+{10:.1f}}}$'
    tm2 += ' & ${11:.0f}/{12:d}={13:.2f}$ \\\\'

    aa = flx1[ii,:]/1e-13
    bb = flx2[ii,:]/1e-13
    cc = flx3[ii,:]/1e-13
    
    ch = chi[ii]
    do = dof[ii]
    go = ch/do
    tm2 = tm2.format(gr, t0, *aa, *bb, *cc, ch, do, go)
    print(tm2)




################################################################
# Temperature and flux
fig = plt.figure(figsize=(5, 3.75))
ax1 = plt.gca()    
# ax2 = ax1.twinx()

ax1.errorbar(tt, kbt1[:,0], yerr=np.abs(kbt1[:,1:].T), fmt='o', lw=1.5, ms=ms, label='$k_\mathrm{B}T_1$')
ax1.errorbar(tt, kbt2[:,0], yerr=np.abs(kbt2[:,1:].T), fmt='o', lw=1.5, ms=ms, label='$k_\mathrm{B}T_2$')
ax1.errorbar(tt, kbt3[:,0], yerr=np.abs(kbt3[:,1:].T), fmt='o', lw=1.5, ms=ms, label='$k_\mathrm{B}T_3$')

# ax2.errorbar(tt, flx1[:,0], yerr=np.abs(flx1[:,1:].T), fmt='s', lw=1.5, ms=ms, label='$F_1$', mfc='none')
# ax2.errorbar(tt, flx2[:,0], yerr=np.abs(flx2[:,1:].T), fmt='s', lw=1.5, ms=ms, label='$F_2$', mfc='none')
# ax2.errorbar(tt, flx3[:,0], yerr=np.abs(flx3[:,1:].T), fmt='s', lw=1.5, ms=ms, label='$F_3$', mfc='none')
    
# mk_line(tt, kbt[:,0], yerr, c0, alp)


################################################################
# Cosmetics

yy = [d2yr(x) for x in tt]
dd = [yr2d(x) for x in yy]

# Tick labels
ax1.set_xlim(left=t_range.min(), right=t_range.max())
ax3 = ax1.twiny()
ax3.set_xlim(ax1.get_xlim())
loc = [yr2d(x) for x in [2012, 2014, 2016, 2018, 2020]]
ax3.set_xticks(loc)
ax3.set_xticklabels(['{:d}'.format(int(d2yr(x))) for x in loc])
# ax3.xticks(rotation=70)

ax1.set_zorder(1)  # default zorder is 0 for ax1 and ax2
ax1.patch.set_visible(False)  # prevents ax1 from hiding ax2

# Limits
ylim = ax1.get_ylim()
ax1.set_ylim(bottom=0, top=1.*ylim[1])
ax1.set_ylim(bottom=0, top=1.3*ylim[1])
ax1.set_ylim(bottom=0, top=6)
# ylim = ax2.get_ylim()
# ax2.set_ylim(bottom=0, top=1.3*ylim[1])
# ax2.set_ylim(bottom=0, top=6.e-12)

# Labels
ax1.set_ylabel('$k_\mathrm{B}T$ (keV)')
ax1.set_xlabel('Time since explosion (d)')
# ax2.set_ylabel('$F$ (erg~s$^{-1}$~cm$^{-2}$)')
ax3.set_xlabel('Year')

# Legends
h1, l1 = ax1.get_legend_handles_labels()
# h2, l2 = ax2.get_legend_handles_labels()

# ax1.legend(h1+h2, l1+l2, handlelength=0.6, ncol=2, loc='upper left')
ax1.legend(ncol=1)
ax1.legend(ncol=1, loc='upper right')
# ax2.legend(handlelength=0.6)
# ax2.legend(ncol=1, loc='upper right')
ax1.grid(True, which='both', ls=":")

# Save
out = '/Users/silver/box/phd/pro/87a/nus/art/fig/com.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)


db()
