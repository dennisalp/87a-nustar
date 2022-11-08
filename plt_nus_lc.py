
'''
2021-04-15, Dennis Alp, dalp@kth.se

Just plot a NuSTAR light curve.
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



################################################################
bs = 96.8*60*5/1e3 # ks (96.8*60 s = orbit)
dd = np.loadtxt('../old/dat/87a_slice4.dat') # 10-20 keV, epoch 5
tt = dd[:,0]/1e3
tt = tt-tt[0]

lc, tb = np.histogram(tt, np.arange(0, tt.max(), bs))
ss = np.sqrt(lc)

fig = plt.figure(figsize=(10, 3.))
plt.errorbar(tb[:-1]+bs/2., lc, xerr=bs/2., yerr=ss, ls='none')
plt.axhline(lc.mean(), color='k')
print('chi2', np.sum((lc-lc.mean())**2/ss**2))

plt.ylabel('Photons')
plt.xlabel('Time (ks)')
out = '/Users/silver/box/phd/pro/87a/nus/art/fig/nus_lc.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)
plt.show()
db()
