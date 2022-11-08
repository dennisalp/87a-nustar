'''
2021-02-16, Dennis Alp, dalp@kth.se

Plot the evolution of the Gaussian blurring sigma.
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

    

################################################################
# Parameters
dates = {
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

################################################################
# Data
obs = ['0144530101', '0406840301','0506220101','0556350101','0601200101','0650420101','0671080101','0690510101','0743790101','0763620101','0783250201','0804980201','0831810101']
xt = np.empty(len(obs))
for ii, oo in enumerate(obs):
    xt[ii] = get_yrs(dates[oo])

#   2    2   gsmooth    Sig_6keV   keV      2.56034E-02  +/-  2.20513E-03  
#  41    2   gsmooth    Sig_6keV   keV      5.48438E-03  +/-  6.20752E-04  
#  80    2   gsmooth    Sig_6keV   keV      5.87644E-03  +/-  4.46914E-04  
# 119    2   gsmooth    Sig_6keV   keV      6.90853E-03  +/-  4.31153E-04  
# 158    2   gsmooth    Sig_6keV   keV      5.63375E-03  +/-  4.26192E-04  
# 197    2   gsmooth    Sig_6keV   keV      6.50591E-03  +/-  4.78611E-04  
# 236    2   gsmooth    Sig_6keV   keV      5.27111E-03  +/-  4.61657E-04  
# 275    2   gsmooth    Sig_6keV   keV      6.26678E-03  +/-  4.68743E-04  
# 314    2   gsmooth    Sig_6keV   keV      5.58470E-03  +/-  5.18861E-04  
# 353    2   gsmooth    Sig_6keV   keV      7.46415E-03  +/-  5.48717E-04  
# 392    2   gsmooth    Sig_6keV   keV      9.37623E-03  +/-  5.28516E-04  
# 431    2   gsmooth    Sig_6keV   keV      8.50681E-03  +/-  6.09948E-04  
# 470    2   gsmooth    Sig_6keV   keV      9.60046E-03  +/-  1.17553E-03  
sig = np.array([2.56034E-02, 5.48438E-03, 5.87644E-03, 6.90853E-03, 5.63375E-03, 6.50591E-03, 5.27111E-03, 6.26678E-03, 5.58470E-03, 7.46415E-03, 9.37623E-03, 8.50681E-03, 9.60046E-03])
#   2    0.0200354    0.0307842    (-0.00556804,0.00518079)
#  41   0.00437501   0.00652764    (-0.00110937,0.00104326)
#  80   0.00508539   0.00665042    (-0.000791053,0.000773972)
# 119    0.0061136   0.00769652    (-0.000794935,0.000787988)
# 158   0.00491053   0.00685763    (-0.000723224,0.00122387)
# 197   0.00567528   0.00731374    (-0.000830629,0.00080783)
# 236   0.00445022   0.00603827    (-0.000820882,0.000767162)
# 275   0.00542326   0.00710338    (-0.000843526,0.000836599)
# 314   0.00430058   0.00650416    (-0.00128413,0.000919458)
# 353   0.00648989   0.00842991    (-0.00097426,0.000965758)
# 392   0.00838281    0.0103815    (-0.000993416,0.00100531)
# 431   0.00733568   0.00998956    (-0.00117112,0.00148276)
# 470   0.00718935    0.0120471    (-0.00241111,0.00244662)
low = np.array([0.0200354, 0.00437501, 0.00508539,  0.0061136, 0.00491053, 0.00567528, 0.00445022, 0.00542326, 0.00430058, 0.00648989, 0.00838281, 0.00733568, 0.00718935])
hig = np.array([0.0307842, 0.00652764, 0.00665042, 0.00769652, 0.00685763, 0.00731374, 0.00603827, 0.00710338, 0.00650416, 0.00842991,  0.0103815, 0.00998956,  0.0120471])

sig = sig*6**-1*1e3
low = low*6**-1*1e3
hig = hig*6**-1*1e3

low = sig-low
hig = hig-sig

yerr = np.r_[low[np.newaxis,:], hig[np.newaxis,:]]


################################################################
# Plot


fig = plt.figure(figsize=(10, 3.75))
plt.errorbar(xt, sig, yerr=yerr, fmt='o', lw=1.5, ms=ms)

plt.ylabel('$\sigma$ (eV)')
plt.xlabel('Time since explosion (d)')
plt.grid(True, which='both', ls=":")

ax1 = plt.gca()
ax1.set_xlim(left=t_min, right=t_max)
ax2 = ax1.twiny()
ax2.set_xlim(ax1.get_xlim())
loc = [yr2d(x) for x in years]
ax2.set_xticks(loc)
ax2.set_xticklabels(['{:d}'.format(int(d2yr(x))) for x in loc])
ax2.set_xlabel('Year')

out = '/Users/silver/box/phd/pro/87a/nus/art/fig/sig.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)

plt.ylim(bottom=0)
out = '/Users/silver/box/phd/pro/87a/nus/art/fig/sig_0.pdf'
plt.savefig(out, bbox_inches='tight', pad_inches=0.1, dpi=300)
plt.show()





# db()
