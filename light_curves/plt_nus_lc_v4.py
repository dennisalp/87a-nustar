
'''
2021-05-24, Dennis Alp, dalp@kth.se

Just plot a NuSTAR light curve, actually using a properly prepared light curve.
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


def pi2kev(pi):
    return pi*0.04+1.6
def kev2pi(kev):
    return (kev-1.6)/0.04

################################################################
nn = 1
bs = nn*5808/1e3

a1 = fits.open('/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013A01_bc_sr.lc')[1].data
b1 = fits.open('/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013B01_bc_sr.lc')[1].data
a2 = fits.open('/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013A01_bc_bk.lc')[1].data
b2 = fits.open('/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013B01_bc_bk.lc')[1].data

bkg = '/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013A01_bc_bk.pha'
src = '/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013A01_bc_sr.pha'
asc = fits.open(src)[1].header['BACKSCAL']/fits.open(bkg)[1].header['BACKSCAL']
bkg = '/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013B01_bc_bk.pha'
src = '/Users/silver/Box Sync/phd/pro/87a/nus/dat/lc/nu40001014013B01_bc_sr.pha'
bsc = fits.open(src)[1].header['BACKSCAL']/fits.open(bkg)[1].header['BACKSCAL']

tt = a1['TIME']/1e3
rr = a1['RATE']+b1['RATE']
ee = np.sqrt(a1['ERROR']**2+b1['ERROR']**2)
bk = asc*a2['RATE']+bsc*b2['RATE']
be = np.sqrt((asc*a2['ERROR'])**2+(bsc*b2['ERROR'])**2)


print(bk.sum()/rr.sum(), 'should be close to (average all epochs)', 10/22.4)
print('the following is for ...13', (0.774+0.674)/2.)
print('vignette not included in the lc now, so bit lower might be ok (effect of vignette)')

# Plot
fig = plt.figure(figsize=(10, 3.))
plt.errorbar(tt+bs/2., rr, xerr=bs/2., yerr=ee, ls='none')
# plt.errorbar(tt+bs/2., bk, xerr=bs/2., yerr=be, ls='none')
plt.axhline(rr.mean(), color='k')
print('chi2', np.sum((rr-rr.mean())**2/ee**2), tt.size, 'DoF')
plt.gca().set_ylim(bottom=0)
plt.gca().set_xlim(left=0, right=tt[-1]+bs)

plt.ylabel('Rate (photons~s$^{-1}$)')
plt.xlabel('Time (ks)')
out = '/Users/silver/box/phd/pro/87a/nus/art/fig/nus_lc_v4.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)
plt.show()
db()
