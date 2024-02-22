'''
2020-08-18, Dennis Alp, dalp@kth.se

Some intuition builders for weighted averages.

Things should be weighted by variance.
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

# 0pm4
# 5pm1
# (5/1+0/4)/2
# (5/1+0/16)/2
# (5/1+0/4)/1.25
# (5/1+0/16)/(1.+1/16)
# 4.705882352941177

# (5/1+0/16)/(1.+1/4)
# 4.0
# 0.3**2+(4.705/4)**2
# 1.4735640625000002


xx = np.linspace(0, 10, 1000)
plt.plot(xx, np.sqrt(((5-xx)/1)**2+((0-xx)/4)**2))
plt.axvline((5/1+0/16)/(1.+1/16))
plt.show()
