'''
2020-08-17, Dennis Alp, dalp@kth.se

Extract fluxes from XSPEC logs and make light curves.
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
from scipy.interpolate import CubicSpline


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
    return [10**float(ll[5]), 10**float(ll[6])]

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
def merg2(mu, sig):
    # old, looks bugged
    mu = np.array(mu)
    sig = np.array(sig)
    ww = (1e-12/np.average(sig, 1))**2
    tmp = np.array([np.average(mu, weights=ww)])
    tm2 = np.average(sig, 0, weights=ww)
    tm2 = (tm2-tmp)/np.sqrt(ww.size-1)
    return np.concatenate((tmp, tm2))

def x2dat(dat):
    # Format the crosses from pendleton into x y -xerr +xerr -yerr +yerr.
    nn = dat.shape[0]//4
    out = np.zeros((nn, 6))
    for ii in range(nn):
        jj = ii*4
        out[ii, 0] = np.mean((dat[jj+2, 0], dat[jj+3, 0]))
        out[ii, 1] = np.mean((dat[jj+0, 1], dat[jj+1, 1]))
        out[ii, 2] = dat[jj+0, 0]-out[ii,0]
        out[ii, 3] = dat[jj+1, 0]-out[ii,0]
        out[ii, 4] = dat[jj+3, 1]-out[ii,1]
        out[ii, 5] = dat[jj+2, 1]-out[ii,1]
    return out

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

def fix_cti(x):
    x[18] = 1.10*x[18]
    x[19] = 1.10*x[19]
    x[20] = 1.08*x[20]
    return x

def get_rat(soft, hard):
    soft_mu   = soft[:,0]
    soft_stat = np.average(np.abs(soft[:,1:]), 1)
    soft_sys  = sys*soft_mu

    hard_mu   = hard[:,0]
    hard_stat = np.average(np.abs(hard[:,1:]), 1)
    hard_sys  = sys*hard_mu

    num = hard_mu-soft_mu
    den = hard_mu+soft_mu
    rat_mu = num/den
    
    # https://en.wikipedia.org/wiki/Ratio_distribution#Uncorrelated_noncentral_normal_ratio
    rat_sig = (hard_stat**2+soft_stat**2)
    rat_sig = rat_sig/num**2+rat_sig/den**2
    rat_sig = rat_mu**2*rat_sig
    rat_sig = np.sqrt(rat_sig)

    ra2_mu = hard_mu/soft_mu
    ra2_sig = hard_stat**2/hard_mu**2+soft_stat**2/soft_mu**2
    ra2_sig = ra2_mu**2*ra2_sig
    ra2_sig = np.sqrt(ra2_sig)

    return ra2_mu, ra2_sig
    
def mk_line(xx, yy, ye, cc, aa, ax):
    t2_range = np.linspace(xx.min(), xx.max(), 1000)
    ww = 1/np.average(ye,0)
    coef = np.polyfit(xx, yy, 1, w=ww)
    ax.plot(t2_range, np.polyval(coef, t2_range), color=cc, lw=0.75, ls='--')

def mk_spline(xx, yy, cc, aa, order, ax):
    ii = xx > t_min
    t2_range = np.linspace(xx.min(), xx.max(), 1000)
    coef = np.polyfit(xx[ii], yy[ii], order)
    ax.plot(t2_range, np.polyval(coef, t2_range), color=cc, lw=0.75, ls='--')
    

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
s1 = 4
s2 = 3
ms = 4
alp = 0.2
sys = 0.08
off = 0.000*10000
t_min = 5500
t_max = 12365
y_max = 3.e-12
years = [2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020]

v2_scale = 1e12

logs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/g?_flx.txt'))
groups = [x.split('/')[-1][:2] for x in logs]
tt = np.empty(len(groups))
for ii, gg in enumerate(groups):
    tt[ii] = get_yrs(dates[gg])


nus_soft = []
nus_full = []
nus_hard = []
for pp in logs:
    print(pp)
    mu_soft = []
    sig_soft = []
    mu_full = []
    sig_full = []
    mu_hard = []
    sig_hard = []
    
    ff = open(pp)
    for line in list(ff):
        if line[2:21] == ' myflux soft param ':
            mu_soft.append(10**float(line.split()[5]))
        elif line[2:21] == ' myflux soft error ':
            sig_soft.append(hlp(line))

        elif line[2:21] == ' myflux full param ':
            mu_full.append(10**float(line.split()[5]))
        elif line[2:21] == ' myflux full error ':
            sig_full.append(hlp(line))

        elif line[2:21] == ' myflux hard param ':
            mu_hard.append(10**float(line.split()[5]))
        elif line[2:21] == ' myflux hard error ':
            sig_hard.append(hlp(line))

    nus_soft.append(merge(mu_soft, sig_soft))
    nus_full.append(merge(mu_full, sig_full))
    nus_hard.append(merge(mu_hard, sig_hard))

nus_soft = np.array(nus_soft)*v2_scale
nus_full = np.array(nus_full)*v2_scale
nus_hard = np.array(nus_hard)*v2_scale


################################################################
# XMM
xogs = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/0*_flx.txt'))
obs = [x.split('/')[-1][:10] for x in xogs]
xt = np.empty(len(obs))
for ii, oo in enumerate(obs):
    xt[ii] = get_yrs(dates[oo])


xmm_soft = []
xmm_esft = []
xmm_vsft = []
xmm_full = []
xmm_hard = []
for pp in xogs:
    print(pp)
    mu_soft = []
    sig_soft = []
    mu_esft = []
    sig_esft = []
    mu_vsft = []
    sig_vsft = []
    mu_full = []
    sig_full = []
    mu_hard = []
    sig_hard = []
    
    ff = open(pp)
    for line in list(ff):
        if line[10:29] == ' myflux soft param ':
            mu_soft.append(10**float(line.split()[5]))
        elif line[10:29] == ' myflux soft error ':
            sig_soft.append(hlp(line))

        if line[10:29] == ' myflux esft param ':
            mu_esft.append(10**float(line.split()[5]))
        elif line[10:29] == ' myflux esft error ':
            sig_esft.append(hlp(line))

        if line[10:29] == ' myflux vsft param ':
            mu_vsft.append(10**float(line.split()[5]))
        elif line[10:29] == ' myflux vsft error ':
            sig_vsft.append(hlp(line))

        elif line[10:29] == ' myflux full param ':
            mu_full.append(10**float(line.split()[5]))
        elif line[10:29] == ' myflux full error ':
            sig_full.append(hlp(line))

        elif line[10:29] == ' myflux hard param ':
            mu_hard.append(10**float(line.split()[5]))
        elif line[10:29] == ' myflux hard error ':
            sig_hard.append(hlp(line))

    xmm_soft.append(merge(mu_soft, sig_soft))
    xmm_esft.append(merge(mu_esft, sig_esft))
    xmm_vsft.append(merge(mu_vsft, sig_vsft))
    xmm_full.append(merge(mu_full, sig_full))
    xmm_hard.append(merge(mu_hard, sig_hard))

xmm_soft = np.array(xmm_soft)*v2_scale
xmm_esft = np.array(xmm_esft)*v2_scale
xmm_vsft = np.array(xmm_vsft)*v2_scale
xmm_full = np.array(xmm_full)*v2_scale
xmm_hard = np.array(xmm_hard)*v2_scale



################################################################
# Spitzer
dat = np.loadtxt('/Users/silver/box/sci/lib/a/arendt20/tab1_4p5micron.txt')
st = dat[:,0]
spi = dat[:,1]



################################################################
# HST
dat = np.loadtxt('/Users/silver/box/sci/lib/l/larsson19b/ring_lc_corr_r.txt')
ht = dat[:,0]
ht = np.array([yr2d(x) for x in ht])
hst = fix_cti(dat[:,1])*v2_scale



################################################################
# Chandra
dat = np.loadtxt('/Users/silver/box/sci/lib/f/frank16/cxo_flx.txt')
ct = dat[:,0]
cxo_soft = dat[:,1:4]*1e-13*v2_scale
cxo_hard = dat[:,4:7]*1e-13*v2_scale

dat = np.loadtxt('/Users/silver/box/sci/lib/f/frank16/xmm_flx.txt')
xm2_t = dat[:,0]
xm2_soft = dat[:,1:4]*1e-13*v2_scale
xm2_hard = dat[:,4:7]*1e-13*v2_scale




################################################################
# Fermi
dat = np.loadtxt('/Users/silver/box/sci/lib/m/malyshev19/malyshev19_fig1.txt')
mal = x2dat(dat)
dat = np.loadtxt('/Users/silver/box/sci/lib/p/petruk20/petruk20_fig5.txt')
pet = x2dat(dat)




################################################################
# Radio
cen = np.loadtxt('/Users/silver/box/sci/lib/c/cendes18/cendes18_tab2.txt')




################################################################
# Print table
for ii, gg in enumerate(groups):
    tmp =  '  {9:<1s} & {10:>6s} & ${0:.1f}_{{{1:.1f}}}^{{+{2:.1f}}}\pm{11:.1f}$'
    tmp += ' & ${3:.2f}_{{{4:.2f}}}^{{+{5:.2f}}}\pm{12:.2f}$'
    tmp += ' & ${6:.1f}_{{{7:.1f}}}^{{+{8:.1f}}}\pm{13:.1f}$ \\\\'
    aa = nus_soft[ii,:]*1.e13
    bb = nus_hard[ii,:]*1.e13
    cc = nus_full[ii,:]*1.e13
    dd = gg[1]
    ee = int(tt[ii])
    ee = str(ee)[:2] + ',' + str(ee)[2:] if ee >= 10000 else str(ee)
    ff = sys*nus_soft[ii,0]*1.e13
    gg = sys*nus_hard[ii,0]*1.e13
    hh = sys*nus_full[ii,0]*1.e13
    tmp = tmp.format(*aa, *bb, *cc, dd, ee, ff, gg, hh)
    if ii == len(groups)-1:
        tmp += '\n\n\n'
    print(tmp)

for ii, oo in enumerate(obs):
    tmp =  '  {9:<10s} & {10:>6s} & ${14:.2f}_{{{15:.2f}}}^{{+{16:.2f}}}\pm{17:.2f}$'
    tmp += ' & ${0:.1f}_{{{1:.1f}}}^{{+{2:.1f}}}\pm{11:.1f}$'
    tmp += ' & ${3:.2f}_{{{4:.2f}}}^{{+{5:.2f}}}\pm{12:.2f}$'
    tmp += ' & ${6:.1f}_{{{7:.1f}}}^{{+{8:.1f}}}\pm{13:.1f}$ \\\\'
    aa = xmm_soft[ii,:]*1.e13
    bb = xmm_hard[ii,:]*1.e13
    cc = xmm_full[ii,:]*1.e13
    dd = oo
    ee = int(xt[ii])
    ee = str(ee)[:2] + ',' + str(ee)[2:] if ee >= 10000 else str(ee)
    ff = sys*xmm_soft[ii,0]*1.e13
    gg = sys*xmm_hard[ii,0]*1.e13
    hh = sys*xmm_full[ii,0]*1.e13
    jj = xmm_esft[ii,:]*1.e13
    kk = sys*xmm_esft[ii,0]*1.e13
    tmp = tmp.format(*aa, *bb, *cc, dd, ee, ff, gg, hh, *jj, kk)
    print(tmp)
    



################################################################
# Hardness
# NuSTAR
nus_rat = get_rat(nus_soft, nus_hard)
xmm_rat = get_rat(xmm_soft, xmm_hard)


fig = plt.figure(figsize=(10, 3.75))
plt.errorbar(tt, nus_rat[0], yerr=nus_rat[1], fmt='o', lw=1.5, ms=ms, color=c0, label='NuSTAR')
plt.errorbar(xt, xmm_rat[0], yerr=xmm_rat[1], fmt='s', lw=1.5, ms=ms, color=c1, label='XMM')

plt.ylabel('Hardness ratio')
plt.xlabel('Time since explosion (d)')
plt.grid(True, which='both', ls=":")
plt.legend()

ax1 = plt.gca()
ax1.set_xlim(left=t_min, right=t_max)
ax2 = ax1.twiny()
ax2.set_xlim(ax1.get_xlim())
loc = [yr2d(x) for x in years]
ax2.set_xticks(loc)
ax2.set_xticklabels(['{:d}'.format(int(d2yr(x))) for x in loc])
ax2.set_xlabel('Year')

out = '/Users/silver/box/phd/pro/87a/nus/art/fig/hardness_v2.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)

ax1.legend(loc='lower left')
plt.ylim(bottom=0)
out = '/Users/silver/box/phd/pro/87a/nus/art/fig/hardness_0_v2.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)
# plt.show()




################################################################
# Light curve
# NuSTAR
ms = 6
fig = plt.figure(figsize=(10, 7.5))
ax1 = plt.gca()
ax2 = ax1.twinx()
ax2.set_ylabel('$F_\\nu$ (mJy)')


yerr = np.abs(nus_soft[:,1:]).T
tmp = np.sqrt(yerr**2+(sys*nus_soft[:,0])**2)
ax1.errorbar(tt, nus_soft[:,0], yerr=tmp, fmt='v', lw=1.5, ms=ms, color=c0, alpha=alp)
ax1.errorbar(tt, nus_soft[:,0], yerr=yerr, fmt='v', lw=1.5, ms=ms, color=c0, label='NuS. 3--8~keV')
mk_line(tt, nus_soft[:,0], yerr, c0, alp, ax1)

s1 = 3
yerr = np.abs(nus_hard[:,1:]).T
tmp = np.sqrt(yerr**2+(sys*nus_hard[:,0])**2)
ax1.errorbar(tt+off, s1*nus_hard[:,0], yerr=s1*tmp, fmt='^', lw=1.5, ms=ms, color=c7, alpha=alp)
ax1.errorbar(tt+off, s1*nus_hard[:,0], yerr=s1*yerr, fmt='^', lw=1.5, ms=ms, color=c7, label='NuS. 10--24~keV~$\\times{}$~'+str(s1))
mk_line(tt, s1*nus_hard[:,0], s1*yerr, c7, alp, ax1)

# yerr = np.abs(nus_full[:,1:]).T
# tmp = np.sqrt(yerr**2+(sys*nus_full[:,0])**2)
# ax1.errorbar(tt+2*off, nus_full[:,0], yerr=tmp, fmt='o', lw=1.5, ms=ms, color=c2, alpha=alp)
# ax1.errorbar(tt+2*off, nus_full[:,0], yerr=yerr, fmt='o', lw=1.5, ms=ms, color=c2, label='NuS. 3--24~keV')


# XMM
yerr = np.abs(xmm_soft[:,1:]).T
tmp = np.sqrt(yerr**2+(sys*xmm_soft[:,0])**2)
ax1.errorbar(xt, xmm_soft[:,0]/s2, yerr=tmp/s2, fmt='s', lw=1.5, ms=ms, color=c2, alpha=alp)
ax1.errorbar(xt, xmm_soft[:,0]/s2, yerr=yerr/s2, fmt='s', lw=1.5, ms=ms, color=c2, label='XMM 0.5--2~keV~$/$~'+str(s2))
mk_spline(xt, xmm_soft[:,0]/s2, c2, alp, 5, ax1)

se = 1
yerr = np.abs(xmm_esft[:,1:]).T
tmp = np.sqrt(yerr**2+(sys*xmm_esft[:,0])**2)
ax1.errorbar(xt, xmm_esft[:,0]*se, yerr=tmp*se, fmt='s', lw=1.5, ms=ms, color=c5, alpha=alp)
# ax1.errorbar(xt, xmm_esft[:,0]*se, yerr=yerr*se, fmt='s', lw=1.5, ms=ms, color=c5, label='XMM 0.45--0.7~keV~$\\times{}$~'+str(se))
ax1.errorbar(xt, xmm_esft[:,0], yerr=yerr, fmt='s', lw=1.5, ms=ms, color=c5, label='XMM 0.45--0.7~keV')
np.savetxt('/Users/silver/box/phd/pro/87a/nus/art/fig/0p45-0p7_kev.txt', np.c_[xt, xmm_esft])
mk_spline(xt, xmm_esft[:,0]*se, c5, alp, 4, ax1)

# yerr = np.abs(xmm_vsft[:,1:]).T
# tmp = np.sqrt(yerr**2+(sys*xmm_vsft[:,0])**2)
# # ax1.errorbar(xt, xmm_vsft[:,0]/s2, yerr=tmp/s2, fmt='s', lw=1.5, ms=ms, color=c5, alpha=alp)
# ax1.errorbar(xt, xmm_vsft[:,0]/s2, yerr=yerr/s2, fmt='s', lw=1.5, ms=ms, color=c5, label='XMM 0.7--2~keV~$/$~'+str(s2))
np.savetxt('/Users/silver/box/phd/pro/87a/nus/art/fig/0p7-2_kev.txt', np.c_[xt, xmm_vsft])

yerr = np.abs(xmm_hard[:,1:]).T
tmp = np.sqrt(yerr**2+(sys*xmm_hard[:,0])**2)
ax1.errorbar(xt+off, xmm_hard[:,0], yerr=tmp, fmt='s', lw=1.5, ms=ms, color=c4, alpha=alp)
ax1.errorbar(xt+off, xmm_hard[:,0], yerr=yerr, fmt='s', lw=1.5, ms=ms, color=c4, label='XMM 3--8~keV')
# mk_line(xt, xmm_hard[:,0], yerr, c4, alp, ax1)
mk_spline(xt, xmm_hard[:,0], c4, alp, 4, ax1)

# yerr = np.abs(xmm_full[:,1:]).T
# tmp = np.sqrt(yerr**2+(sys*xmm_full[:,0])**2)
# ax1.errorbar(xt+2*off, xmm_full[:,0]/s2, yerr=tmp/s2, fmt='o', lw=1.5, ms=ms, color=c5, alpha=alp)
# ax1.errorbar(xt+2*off, xmm_full[:,0]/s2, yerr=yerr/s2, fmt='o', lw=1.5, ms=ms, color=c5, label='XMM 0.5--8~keV~$/$~'+str(s2))

# Spitzer
ax2.plot(st, spi, 'p', ms=ms, color=c6, label='Spitzer 4.5~$\mu$m', mfc='none')
mk_spline(st, spi, c6, alp, 4, ax2)

# HST
ax1.plot(ht, hst, 'o', ms=ms, color=c3, label='HST R-band', mfc='none')
# db()
mk_spline(ht, hst, c3, alp, 5, ax1)

# CXO
# yerr = np.abs(cxo_soft[:,1:]).T
# tmp = np.sqrt(yerr**2+(sys*cxo_soft[:,0])**2)
# ax1.errorbar(ct, cxo_soft[:,0]/s2, yerr=tmp/s2, fmt='s', lw=1.5, ms=ms, color=c4, alpha=alp)
# ax1.errorbar(ct, cxo_soft[:,0]/s2, yerr=yerr/s2, fmt='s', lw=1.5, ms=ms, color=c4, label='CXO 0.5--2~keV~$/$~'+str(s2))

# yerr = np.abs(cxo_hard[:,1:]).T
# tmp = np.sqrt(yerr**2+(sys*cxo_hard[:,0])**2)
# ax1.errorbar(ct+off, cxo_hard[:,0], yerr=tmp, fmt='o', lw=1.5, ms=ms, color=c5, alpha=alp)
# ax1.errorbar(ct+off, cxo_hard[:,0], yerr=yerr, fmt='o', lw=1.5, ms=ms, color=c5, label='CXO 3--8~keV')

# yerr = np.abs(xm2_soft[:,1:]).T
# tmp = np.sqrt(yerr**2+(sys*xm2_soft[:,0])**2)
# ax1.errorbar(xm2_t, xm2_soft[:,0]/s2, yerr=tmp/s2, fmt='s', lw=1.5, ms=ms, color=c6, alpha=alp)
# ax1.errorbar(xm2_t, xm2_soft[:,0]/s2, yerr=yerr/s2, fmt='s', lw=1.5, ms=ms, color=c6, label='AAXMM 0.5--2~keV~$/$~'+str(s2))

# yerr = np.abs(xm2_hard[:,1:]).T
# tmp = np.sqrt(yerr**2+(sys*xm2_hard[:,0])**2)
# ax1.errorbar(xm2_t, xm2_hard[:,0], yerr=tmp, fmt='o', lw=1.5, ms=ms, color=c7, alpha=alp)
# ax1.errorbar(xm2_t, xm2_hard[:,0], yerr=yerr, fmt='o', lw=1.5, ms=ms, color=c7, label='AAXMM 3--8~keV')


# Fermi
# ft = Time(mal[:,0], format='mjd').datetime
# ft = np.array([(x.date()-SNDATE).days for x in ft])
# pet[:,0] = [yr2d(x) for x in pet[:,0]]
# pet[:,2] = pet[:,2]*365.26
# pet[:,3] = pet[:,3]*365.26

# sm = 1.e-13
# xerr = (np.abs(mal[:,2]), mal[:,3])
# yerr = (np.abs(mal[:,4])*sm, np.abs(mal[:,5])*sm)
# ax1.errorbar(ft, mal[:,1]*sm, xerr=xerr, yerr=yerr, fmt='v', lw=1.5, ms=ms, color=c8, label='Fermi 1')

# sp = 1.e-3
# xerr = (np.abs(pet[:,2]), pet[:,3])
# yerr = (np.abs(pet[:,4])*sp, np.abs(pet[:,5])*sp)
# ax1.errorbar(pet[:,0], pet[:,1]*sp, xerr=xerr, yerr=yerr, fmt='v', lw=1.5, ms=ms, color=c9, label='Fermi 2')

# Radio
sc = 0.01
yerr = (np.abs(cen[:,2])*sc, np.abs(cen[:,3])*sc)
# ax1.errorbar(cen[:,0], cen[:,1]*sc, yerr=yerr, fmt='d', lw=1.5, ms=ms, color=c1, label='9 GHz $\\times 8\\times 10^{{-15}}/$mJy'.format(sc))
# ax1.errorbar(cen[:,0], cen[:,1]*sc, yerr=yerr, fmt='d', lw=1.5, ms=ms, color=c1, label='9 GHz', mfc='none')
ax2.plot(cen[:,0], cen[:,1]*sc, 'd', lw=1.5, ms=ms, color=c1, label='9 GHz~$/$~100', mfc='none')
# mk_line(cen[:,0], cen[:,1]*sc, yerr, c1, alp, ax1)
mk_spline(cen[:,0], cen[:,1]*sc, c1, alp, 4, ax2)



################################################################
# Cosmetics
ax1.set_ylabel('$F$ ($10^{-12}$~erg~cm$^{-2}$~s$^{-1}$)')
ax1.set_xlabel('Time since explosion (d)')

h, l = ax1.get_legend_handles_labels()
h2, l2 = ax2.get_legend_handles_labels()

# sort both labels and handles by labels
h = [h[2], h[1], h[0], h2[0], h[5], h[3], h[4], h2[1]]
l = [l[2], l[1], l[0], l2[0], l[5], l[3], l[4], l2[1]]
ax1.legend(h,l, ncol=2, loc='upper left')

yy = [d2yr(x) for x in tt]
dd = [yr2d(x) for x in yy]
# ax3 = ax1.secondary_xaxis('top', functions=(d2yr, yr2d))

ax1.set_xlim(left=t_min, right=t_max)
ax3 = ax1.twiny()
ax3.set_xlim(ax1.get_xlim())
loc = [yr2d(x) for x in years]
ax3.set_xticks(loc)
ax3.set_xticklabels(['{:d}'.format(int(d2yr(x))) for x in loc])
ax3.set_xlabel('Year')
# ax3.xticks(rotation=70)

ax1.grid(True, which='both', ls=":")
ymax = y_max*v2_scale
ax1.set_ylim(bottom=0, top=ymax)
ax2.set_ylim(bottom=0, top=3)

# ax1.set_zorder(1)  # default zorder is 0 for ax1 and ax2
# ax1.patch.set_visible(False)  # prevents ax1 from hiding ax2

out = '/Users/silver/box/phd/pro/87a/nus/art/fig/lc_lin_v2.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)
# plt.show()

ax1.set_ylim(bottom=1.e-13*v2_scale)
ax1.set_yscale('log')
ax2.set_ylim(bottom=0.1*v2_scale)
ax2.set_yscale('log')
ax1.legend(h,l, ncol=2, loc='lower right')
out = '/Users/silver/box/phd/pro/87a/nus/art/fig/lc_log_v2.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)
# plt.show()



# db()
