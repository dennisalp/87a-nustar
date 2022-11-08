
'''
2020-09-17, Dennis Alp, dalp@kth.se

Make an .xcm file corresponding to the distribution of shocks model of zhekov06.
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

c1 = [-2.24736, -5.98606,  4.56628,  6.66289,  2.02443, -2.82237, -3.33499]
c2 = [-2.27539, -6.04410,  4.59240,  6.69762,  1.99601, -2.88049, -3.36360]
c3 = [-2.56622,2.58912,-15.35,2.49431,-8.6608,0.100346,-3.2144]

c1 = [-2.56622,2.58912,-15.35,2.49431,-8.6608,0.100346,-3.2144]
c2 = [-2.56622,2.58912,-5.35,2.49431,-4.6608,0.100346,-2.2144]
c3 = [0., 0., -2,  2., -2, 0., -2.]
c4 = [0., 0., 0.,  0., 0., 0., -3.]

c1 = [-10.7352,  12.8018        ,  -32.3955       ,  8.92623        ,  -17.8791       ,  1.90037        ,  -6.03358   ]
 
c2 = [-20.8736    , 8.02513     , -21.0847    , 6.09151     , -11.7809    , 1.20913      , -4.27528    ]

nn = 1000
xx = np.linspace(-1, 1, nn)

nn = 28
ee = np.logspace(np.log10(0.125), np.log10(10), nn+1)
bb = 10**((np.log10(ee[:-1])+np.log10(ee[1:]))/2)
xx = (np.log10(bb)-np.log10(0.125))/((np.log10(10) - np.log10(0.125))/2.) - 1.

y1 = np.polynomial.chebyshev.chebval(xx, c1)
y2 = np.polynomial.chebyshev.chebval(xx, c2)
# y3 = np.polynomial.chebyshev.chebval(xx, c3)
# y4 = np.polynomial.chebyshev.chebval(xx, c4)
# xx = np.linspace(0, 1, nn)
fig = plt.figure(figsize=(5, 3.75))
plt.semilogx(bb, 6.46851E-08*np.exp(y1), label='fit')
plt.semilogx(bb, 1.64500*np.exp(y2), label='error')
plt.xlabel('Temperature ($k_\mathrm{B}T$)')
plt.ylabel('vpshock normalization')
plt.legend()
fig.savefig('/Users/silver/box/phd/pro/87a/nus/art/fig/compare_fit_error.pdf',bbox_inches='tight', pad_inches=0.03)
# plt.plot(xx, np.exp(y3))
# plt.plot(xx, np.exp(y4))
# plt.ylim(-100, 100)
plt.show()

