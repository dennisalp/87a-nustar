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




################################################################
# Parameters
nd = 11 # Number of data sets, doesn't really matter if too many are printed. XSPEC truncates.
nn, pl = 5*4, True # Number of bins for 0.125-4 keV
nn, pl = 5*4, False # Number of bins for 0.125-4 keV
nn, pl = 6*4, False # Number of bins for 0.125-8 keV
nn, pl = 7*4, False # Number of bins for 0.125-10 keV
# nn, pl = 8*4, False # Number of bins for 0.125-12 keV
# nn, pl = 8*4, True # Number of bins for 0.125-12 keV
# nn, pl = 9*4, False # Number of bins for 0.125-14 keV
# nn, pl = 10*4, False # Number of bins for 0.125-16 keV
nc = 6 # Number of Chebyshev polynomials, basically has to be 4 or 6.

if nn == 20:
    em = 4
elif nn == 24:
    em = 8
elif nn == 28:
    em = 10
elif nn == 32:
    em = 12
elif nn == 36:
    em = 14
elif nn == 40:
    em = 16
else:
    gg=wp

ee = np.logspace(np.log10(0.125), np.log10(em), nn+1)
bb = 10**((np.log10(ee[:-1])+np.log10(ee[1:]))/2)




################################################################
# Prepare some string chunks
hh = "query yes\nmethod leven 20 0.01\nabund wilm\nxsect vern\ncosmo 70 0 0.73\nxset delta 0.01\nsystematic 0\nmodel  "
hh += (3+nc+1)*"constant("
hh += "pow" + (3+nc+1)*")" + " + "
hh += "constant(TBabs(gsmooth("
hh += (nn * "vpshock + ")
hh += "pow)))\n"


con_tba_gsm = "              1      -0.01          0          0      1e+10      1e+10\n       0.259786     -0.001          0          0     100000      1e+06\n     0.00685543      -0.05          0          0         10         20\n              1      -0.01         -1         -1          1          1\n"

vps = "              1      -0.01          0          0          1          1\n         2.5582      -0.01          0          0       1000      10000\n         0.1334      -0.01          0          0       1000      10000\n        2.65295      -0.01          0          0       1000      10000\n        0.37304      -0.01          0          0       1000      10000\n       0.761212      -0.01          0          0       1000      10000\n       0.761994      -0.01          0          0       1000      10000\n        1.02986      -0.01          0          0       1000      10000\n       0.847071      -0.01          0          0       1000      10000\n         0.6607      -0.01          0          0       1000      10000\n         0.4898      -0.01          0          0       1000      10000\n       0.389731      -0.01          0          0       1000      10000\n         0.9772      -0.01          0          0       1000      10000\n              0     -1e+08          0          0      5e+13      5e+13\n = p1*p{0:d}^p2\n    0.000881197      -0.01     -0.999     -0.999         10         10\n"

# Here are the Chebyshev polynomials
tr = "((p{0:d}-0.125)/((" + str(float(em)) + "-0.125)/2.)-1.)"
tr = "((log(p{0:d})-log(0.125))/((log(" + str(float(em)) + ")-log(0.125))/2.)-1.)"
if nc > 3:
    vps += " = p3*exp(p4 + p5*" + tr
    vps += " + p6*(2.*" + tr + "^2.-1.)"
    vps += " + p7*(4.*" + tr + "^3.-3.*" + tr + ")"
    vps += " + p8*(8.*" + tr + "^4.-8.*" + tr + "^2.+1.)"
if nc > 4:
    vps += " + p9*(16.*" + tr + "^5.-20.*" + tr + "^3.+5.*" + tr + ")"
    vps += " + p10*(32.*" + tr + "^6.-48.*" + tr + "^4.+18.*" + tr + "^2.-1.)"
if nc > 6:
    gg=wp
vps += ")\n"




################################################################
# Piece together the chunks
out = hh

# Ionization age magnitude
out += "          1e+13      1e+08      1e+08      1e+08      5e+13      5e+13\n"
# Ionization age slope
out += "           -0.5       0.01         -2         -2          2          2\n"
# Chebyshev magnitude
out += "          3e-04       0.01          0          0      1e+01      1e+01\n"
# Chebyshev polynomial weights
for ii in range(0,nc+1):
    out += "              0       0.01     -1e+03     -1e+03      1e+03      1e+03\n"
# Dummy power law
out += "              1      -0.01         -3         -2          9         10\n"
out += "              0      -0.01          0          0      1e+20      1e+24\n"

# Plasma components
out += con_tba_gsm
for ii, tt in enumerate(bb):
    out += "{0:15.6f}      -0.01     0.0808     0.0808       79.9       79.9\n".format(tt)
    out += vps.format(ii*18+5+(3+nc+1)+2)

# Non-thermal PL
if pl:
    out += "              2       0.01         -3         -2          9         10\n"
    out += "          1e-04       0.01          0          0      1e+20      1e+24\n"
else:
    out += "              1      -0.01         -3         -2          9         10\n"
    out += "              0      -0.01          0          0      1e+20      1e+24\n"

    
out += "bayes off\n"
# out += "freeze {0:d}".format((3+nc+1)+2+1)

for ii in range(1,nd):
    ii = ii*(bb.size*18+(3+nc+1)+2+4+2)+(3+nc+1)+2+1
    out += "untie {0:d}\nthaw {0:d}\n".format(ii)

op = "/Users/silver/box/phd/pro/87a/nus/xsp/"
on = "dos_em" + str(em) + "_pl" + str(int(pl)) + ".xcm"
ff = open(op + on, "w")
ff.write(out)
ff.close()

db()

# em = np.array([1.89121E-04, 2.18227E-04, 2.56769E-04, 3.08247E-04, 3.77341E-04, 4.69928E-04, 5.92387E-04, 7.49183E-04, 9.37165E-04, 1.13548E-03, 1.29461E-03, 1.33914E-03, 1.20646E-03, 9.13641E-04, 5.75537E-04, 3.16441E-04, 1.76496E-04, 1.32184E-04, 1.86816E-04, 5.24218E-04, 9.56903E-04, 3.56518E-05, 5.91743E-10, 5.99412E-10])
