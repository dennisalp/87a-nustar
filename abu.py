'''
2020-08-12, Dennis Alp, dalp@kth.se

Stuff related to abundances. Gathers some data from the literature, parses output from XSPEC fits, and print the final table.
'''

from __future__ import division, print_function
import os
from pdb import set_trace as db
import sys
from glob import glob
import time
from datetime import date
from tqdm import tqdm

import numpy as np
import matplotlib.pyplot as plt
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



lab = np.array([    1,     2,    6,    7,    8,   10,   12,   14,   16,   18,   20,   26,   28])
ang = np.array([12.00, 10.99, 8.56, 8.05, 8.93, 8.09, 7.58, 7.55, 7.21, 6.56, 6.36, 7.67, 6.25])
wil = np.array([12.00, 10.99, 8.38, 7.88, 8.69, 7.94, 7.40, 7.27, 7.09, 6.41, 6.20, 7.43, 6.05])
lmc = np.array([12.00, 10.94, 8.04, 7.14, 8.35, 7.61, 7.47, 7.81, 6.70, 6.29, 5.89, 7.23, 6.04])


# #russell90, kurt98
# He = np.average(np.array([10.96, 10.91]), weights=1/np.array([0.06, 0.05]))
# #hunter07b, russell89, russell90, kurt98
# C = np.average(np.array([7.75, 8.04, 7.66, 7.81]))
# #hunter07b, kurt98, russell89, russell90, russell92, trundle07
# N = np.average(np.array([6.90, 6.92, 7.07, 7.45, 7.14, 7.54, 7.33]))
# #kurt98, 2*russell90, 2*trundle07, hunter07b
# O = np.average(np.array([8.37, 8.37, 8.25, 8.33, 8.40, 8.35]))
# #kurt98, 2*russell90
# Ne = np.average(np.array([7.55, 7.68, 7.50]))
# #2*trundle07, hunter07b
# Mg = np.average(np.array([7.06, 7.08, 7.05]))
# #2*trundle07, hunter07b
# Si = np.average(np.array([7.19, 7.21, 7.20]))
# #2*russell90
# S = np.average(np.array([6.87, 6.62]), weights=1/np.array([0.14, 0.23]))
# #2*russell90
# Ar = np.average(np.array([6.07, 6.59]), weights=1/np.array([0.25, 0.07]))
# #russell89, russell90
# Ca = np.average(np.array([5.89, 6.05]), weights=1/np.array([0.16, 0.03]))
# #russell89, russell90, 2*trundle07
# Fe = np.average(np.array([7.23, 7.22, 7.23, 7.24]), weights=1/np.array([0.17, 0.09, 0.10, 0.12]))
# #russell89, russell90, russel92
# Ni = np.average(np.array([6.04, 5.87, 6.04]))
# lmc = np.array([12, He, C, N, O, Ne, Mg, Si, S, Ar, Ca, Fe, Ni])


################################################################



# lundqvist96, Sect. 3.1
lHe = np.log10(0.25)+12
matilla10 = 11.23 # 1.0715
# lHe = matilla10
AHe = 10**(lHe-wil[1])
LMCHe = 10**(lHe-lmc[1])
print('    He {0:.4f} {1:.4f}'.format(lHe, AHe))

lC = np.log10(3.2e-5)+12
AC = 10**(lC-wil[2])
LMCC = 10**(lC-lmc[2])
print('    C  {0:.4f} {1:.4f}'.format(lC, AC))


my_fit = 3.21345    
lN = np.log10(1.8e-4)+12
AN = 10**(lN-wil[3])
LMCN = 10**(lN-lmc[3])
print('    N: {0:.4f} {1:.4f}'.format(lN, AN))



my_fit = 0.444425   
lO = np.log10(1.6e-4)+12
AO = 10**(lO-wil[4])
LMCO = 10**(lO-lmc[4])
print('    O: {0:.4f} {1:.4f}'.format(lO, AO))



my_fit = 0.865080
lNe = np.log10(5.5e-5)+12
ANe = 10**(lNe-wil[5])
LMCNe = 10**(lNe-lmc[5])
print('    Ne: {0:.4f} {1:.4f}'.format(lNe, ANe))



my_fit = 0.826377
russell92 = 7.47
lMg = russell92
AMg = 10**(lMg-wil[6])
LMCMg = 10**(lMg-lmc[6])
print('    Mg: {0:.4f} {1:.4f}'.format(lMg, AMg))


my_fit = 1.05077
lSi = np.log10(1.7e-5)+12
ASi = 10**(lSi-wil[7])
LMCSi = 10**(lSi-lmc[7])
print('    Si: {0:.4f} {1:.4f}'.format(lSi, ASi))



my_fit = 0.851122
lS = np.log10(5.6e-6)+12
AS = 10**(lS-wil[8]) # 0.46
matilla10 = 7.12 # 1.0715
adopt = 7.
lS = adopt
AS = 10**(lS-wil[8])
LMCS = 10**(lS-lmc[8])
print('    S: {0:.4f} {1:.4f}'.format(lS, AS))

matilla10 = 6.23
russell92 = 6.29
lAr = matilla10
AAr = 10**(lAr-wil[9])
LMCAr = 10**(lAr-lmc[9])
print('    Ar: {0:.4f} {1:.4f}'.format(lAr, AAr))


matilla10 = 6.51
russell92 = 5.89
lCa = russell92
ACa = 10**(lCa-wil[10])
LMCCa = 10**(lCa-lmc[10])
print('    Ca: {0:.4f} {1:.4f}'.format(lCa, ACa))


my_fit = 0.404673
matilla10 = 6.98
lFe = np.log10(3e-5)+12
lFe = matilla10
AFe = 10**(lFe-wil[11])
LMCFe = 10**(lFe-lmc[11])
print('    Fe: {0:.4f} {1:.4f}'.format(lFe, AFe))

russell92 = 6.04
lNi = russell92
ANi = 10**(lNi-wil[12])
LMCNi = 10**(lNi-lmc[12])
print('    Ni: {0:.4f} {1:.4f}'.format(lNi, ANi))



################################################################



def get_par(ll):
    low = float(ll.split()[1])
    upp = float(ll.split()[2])
    mid = low-float(ll.split()[-1].split(',')[0][1:])
    return np.array([mid, low-mid, upp-mid])
    
ff = open('/Users/silver/box/phd/pro/87a/nus/xsp/log/xmm_all_par.txt')
for line in list(ff):
    if line[:8] == '    21  ':
        zz = get_par(line)
    elif line[:8] == '    17  ':
        fe = get_par(line)
    elif line[:8] == '    14  ':
        s = get_par(line)
    elif line[:8] == '    13  ':
        si = get_par(line)
    elif line[:8] == '    12  ':
        mg = get_par(line)
    elif line[:8] == '    11  ':
        ne = get_par(line)
    elif line[:8] == '    10  ':
        o = get_par(line)
    elif line[:8] == '     9  ':
        n = get_par(line)
    elif line[:8] == '     3  ':
        sig = get_par(line)
    elif line[:8] == '     2  ':
        nh = get_par(line)


def fix_par(ll, nn):
    l2 = np.array([ll[0], ll[0]+ll[1], ll[0]+ll[2]])
    lw = np.log10(l2*10**wil[nn])
    lw = np.array([lw[0], lw[1]-lw[0], lw[2]-lw[0]])
    lm = l2*10**(wil[nn]-lmc[nn])
    lm = np.array([lm[0], lm[1]-lm[0], lm[2]-lm[0]])
    return np.concatenate((lw, ll, lm))
        
print('  H  &           $\equiv{}12$ &            $\equiv{}1$ &            $\equiv{}1$ & \\nodata{} \\\\')

print('  He &                ${0:2.2f}$ &                 ${1:1.2f}$ &                 ${2:1.2f}$ & 1 \\\\'.format(lHe, AHe, LMCHe))

print('  C  &                 ${0:1.2f}$ &                 ${1:1.2f}$ &                 ${2:1.2f}$ & 1 \\\\'.format(lC, AC, LMCC))

tmp = '  N  & ${0:1.2f}_{{{1:1.2f}}}^{{+{2:1.2f}}}$ & ${3:1.2f}_{{{4:1.2f}}}^{{+{5:1.2f}}}$ & ${6:1.2f}_{{{7:1.2f}}}^{{+{8:1.2f}}}$ & \\nodata{{}} \\\\'
tmp = tmp.format(*fix_par(n,  3))
print(tmp)

tmp = '  O  & ${0:1.2f}_{{{1:1.2f}}}^{{+{2:1.2f}}}$ & ${3:1.2f}_{{{4:1.2f}}}^{{+{5:1.2f}}}$ & ${6:1.2f}_{{{7:1.2f}}}^{{+{8:1.2f}}}$ & \\nodata{{}} \\\\'
tmp = tmp.format(*fix_par(o,  4))
print(tmp)

tmp = '  Ne & ${0:1.2f}_{{{1:1.2f}}}^{{+{2:1.2f}}}$ & ${3:1.2f}_{{{4:1.2f}}}^{{+{5:1.2f}}}$ & ${6:1.2f}_{{{7:1.2f}}}^{{+{8:1.2f}}}$ & \\nodata{{}} \\\\'
tmp = tmp.format(*fix_par(ne, 5))
print(tmp)

tmp = '  Mg & ${0:1.2f}_{{{1:1.2f}}}^{{+{2:1.2f}}}$ & ${3:1.2f}_{{{4:1.2f}}}^{{+{5:1.2f}}}$ & ${6:1.2f}_{{{7:1.2f}}}^{{+{8:1.2f}}}$ & \\nodata{{}} \\\\'
tmp = tmp.format(*fix_par(mg, 6))
print(tmp)

tmp = '  Si & ${0:1.2f}_{{{1:1.2f}}}^{{+{2:1.2f}}}$ & ${3:1.2f}_{{{4:1.2f}}}^{{+{5:1.2f}}}$ & ${6:1.2f}_{{{7:1.2f}}}^{{+{8:1.2f}}}$ & \\nodata{{}} \\\\'
tmp = tmp.format(*fix_par(si, 7))
print(tmp)

tmp = '  S  & ${0:1.2f}_{{{1:1.2f}}}^{{+{2:1.2f}}}$ & ${3:1.2f}_{{{4:1.2f}}}^{{+{5:1.2f}}}$ & ${6:1.2f}_{{{7:1.2f}}}^{{+{8:1.2f}}}$ & \\nodata{{}} \\\\'
tmp = tmp.format(*fix_par(s,  8))
print(tmp)

print('  Ar &                 ${0:1.2f}$ &                 ${1:1.2f}$ &                 ${2:1.2f}$ & 2 \\\\'.format(lAr, AAr, LMCAr))

print('  Ca &                 ${0:1.2f}$ &                 ${1:1.2f}$ &                 ${2:1.2f}$ & 3 \\\\'.format(lCa, ACa, LMCCa))

tmp = '  Fe & ${0:1.2f}_{{{1:1.3f}}}^{{+{2:1.2f}}}$ & ${3:1.2f}_{{{4:1.3f}}}^{{+{5:1.2f}}}$ & ${6:1.2f}_{{{7:1.2f}}}^{{+{8:1.2f}}}$ & \\nodata{{}} \\\\'
tmp = tmp.format(*fix_par(fe, 11))
print(tmp)

print('  Ni &                 ${0:1.2f}$ &                 ${1:1.2f}$ &                 ${2:1.2f}$ & 3 \\\\'.format(lNi, ANi, LMCNi))


tmp = '${0:1.6f}_{{{1:1.6f}}}^{{+{2:1.6f}}}$'
tmp = tmp.format(*zz)
print(tmp)
print(np.array([zz[0], zz[0]+zz[1], zz[0]+zz[2]])*cc/1e5, 'km s-1')

tmp = '${0:1.6f}_{{{1:1.6f}}}^{{+{2:1.6f}}}$'
tmp = tmp.format(*nh)
print(tmp, '10^22 cm^-2')

tmp = '${0:1.6f}_{{{1:1.6f}}}^{{+{2:1.6f}}}$'
tmp = tmp.format(*sig)
print(tmp, 'keV')



db()
