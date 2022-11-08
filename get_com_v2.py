
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
n2em = 1e14*4*np.pi*(51.2*kpc)**2 # norm to emission measure, xspec vpshock norm
logs = ['co2_v2_no_pn',
        'co2_v2_no_rgs',
        'co2_v2_no_nus',
        'co2_v2_no_err',
        'com_v2_no_pn',
        'com_v2_no_rgs',
        'com_v2_no_nus',
        'com_v2_no_err',
        'com_v2_0p88',
        'com_v2_0p8b',
        'com_v2_untie_t',
        'com_v2_untie_t+em']

for ll in logs:
    ll = sorted(glob('/Users/silver/box/phd/pro/87a/nus/xsp/log/' + ll + '_g?.txt'))
    groups = [x.split('/')[-1][4:6] for x in logs]


    kbt1 = []
    tau1 = []
    em1 = []
    kbt2 = []
    tau2 = []
    em2 = []
    kbt3 = []
    kbt3_2nd = []
    tau3 = []
    em3 = []
    con = []
    chi = []
    dof = []
    for pp in ll:
        
        print(pp)
        ff = open(pp, 'r')
        need_cd = True
        need_t3 = True
        need_t2 = True
        need_t1 = True
        need_n3 = True
        need_n2 = True
        need_n1 = True
        need_i3 = True
        need_i2 = True
        need_i1 = True
        
        for line in reversed(ff.readlines()):
            if '                          Data group:' in line:
                need_t1 = need_n1 = need_i1 = False
                
            elif line[:40] == 'Total fit statistic                     ' and need_cd:
                chi.append(float(line.split()[3]))
                dof.append(int(line.split()[5]))
                need_cd = False

            elif '   vpshock    kT         keV      ' in line and need_t3:
                kbt3.append(float(line.split()[5]))
                need_t3 = False

            elif '   vpshock    kT         keV      ' in line and need_t2:
                kbt2.append(float(line.split()[5]))
                need_t2 = False

            elif '   vpshock    kT         keV      ' in line and need_t1:
                kbt1.append(float(line.split()[5]))
                need_t1 = False

            elif '   vpshock    kT         keV      ' in line:
                kbt3_2nd.append(float(line.split()[5]))
                break

            # Emission measure/normalizations
            elif '  vpshock    norm               ' in line and need_n3:
                em3.append(float(line.split()[4]))
                need_n3 = False

            elif '  vpshock    norm               ' in line and need_n2:
                em2.append(float(line.split()[4]))
                need_n2 = False

            elif '  vpshock    norm               ' in line and need_n1:
                em1.append(float(line.split()[4]))
                need_n1 = False

                
            # Ionization ages/tau
            elif '  vpshock    Tau_u      s/cm^3  ' in line and need_i3:
                tau3.append(float(line.split()[5]))
                need_i3 = False

            elif '  vpshock    Tau_u      s/cm^3  ' in line and need_i2:
                tau2.append(float(line.split()[5]))
                need_i2 = False

            elif '  vpshock    Tau_u      s/cm^3  ' in line and need_i1:
                tau1.append(float(line.split()[5]))
                need_i1 = False

                
        # kbt1.append(merge(kbt1, kbt1))
        # tau1.append(merge(tau1, tau1))
        # em1.append(merge(em1, em1))
        # kbt2.append(merge(kbt2, kbt2))
        # tau2.append(merge(tau2, tau2))
        # em2.append(merge(em2, em2))
        # kbt3.append(merge(kbt3, kbt3))
        # tau3.append(merge(tau3, tau3))
        # em3.append(merge(em3, em3))
    
        # con.append(merge(con, con))
        # chi.append(chi_tmp)
        # dof.append(dof_tmp)
        
    kbt1 = np.array(kbt1)
    tau1 = np.array(tau1)
    em1 = np.array(em1)
    kbt2 = np.array(kbt2)
    tau2 = np.array(tau2)
    em2 = np.array(em2)
    kbt3 = np.array(kbt3)
    tau3 = np.array(tau3)
    em3 = np.array(em3)
    kbt3_2nd = np.array(kbt3_2nd)
    
    chi = np.array(chi)
    dof = np.array(dof)


    print('\nTemperatures (keV)')
    for ii in range(0,kbt3.size):
        if kbt1.size > 0:
            print('{0:.4f} {1:.4f} {2:.4f} {3:.4f}'.format(kbt1[ii], kbt2[ii], kbt3[ii], kbt3_2nd[ii]))
        else:
            print('{0:.4f} {1:.4f} {2:.4f}'.format(kbt2[ii], kbt3[ii], kbt3_2nd[ii]))

    print('Average')
    if len(kbt1) > 0:
        print('{0:.4f} {1:.4f} {2:.4f} {3:.4f}'.format(kbt1.mean(), kbt2.mean(), kbt3.mean(), kbt3_2nd.mean()))
    else:
        print('{0:.4f} {1:.4f} {2:.4f}'.format(kbt2.mean(), kbt3.mean(), kbt3_2nd.mean()))

 
    print('\nIonization ages (s cm-3)')
    for ii in range(0,tau3.size):
        if tau1.size > 0:
            print('{0:.4e} {1:.4e} {2:.4e}'.format(tau1[ii], tau2[ii], tau3[ii]))
        else:
            print('{0:.4e} {1:.4e}'.format(tau2[ii], tau3[ii]))
    print('Average')
    if len(tau1) > 0:
        print('{0:.4e} {1:.4e} {2:.4e}'.format(tau1.mean(), tau2.mean(), tau3.mean()))
    else:
        print('{0:.4e} {1:.4e}'.format(tau2.mean(), tau3.mean()))


    print('\nStats')
    for ii in range(0,tau3.size):
        print('{0:.3f}/{1:d}={2:.4f}'.format(chi[ii], dof[ii], chi[ii]/dof[ii]))
    print('Sum')
    print('{0:.3f}/{1:d}={2:.4f}'.format(np.sum(chi), np.sum(dof), np.sum(chi)/np.sum(dof)))
    
    print('\n\n')
    
    
# ################################################################
# # Print table
# print('\n\n\n')
# for ii, gg in enumerate(groups):
#     tmp =  '{27:<1s} & {28:>6s}'
#     tmp += ' & ${0:.2f}_{{{1:.2f}}}^{{+{2:.2f}}}$'
#     tmp += ' & ${3:.2f}_{{{4:.2f}}}^{{+{5:.2f}}}$'
#     tmp += ' & ${6:.1f}_{{{7:.1f}}}^{{+{8:.1f}}}$'
#     tmp += ' & ${9:.2f}_{{{10:.2f}}}^{{+{11:.2f}}}$'
#     tmp += ' & ${12:.2f}_{{{13:.2f}}}^{{+{14:.2f}}}$'
#     tmp += ' & ${15:.2f}_{{{16:.2f}}}^{{+{17:.2f}}}$'
#     tmp += ' & ${18:.1f}_{{{19:.1f}}}^{{+{20:.1f}}}$'
#     tmp += ' & ${21:.1f}_{{{22:.1f}}}^{{+{23:.1f}}}$'
#     tmp += ' & ${24:.1f}_{{{25:.1f}}}^{{+{26:.1f}}}$ \\\\'

#     aa = kbt1[ii,:]
#     bb = kbt2[ii,:]
#     cc = kbt3[ii,:]
#     dd = tau1[ii,:]/1e12
#     ee = tau2[ii,:]/1e12
#     ff = tau3[ii,:]/1e12
#     hh = em1[ii,:]*n2em/1e58
#     jj = em2[ii,:]*n2em/1e58
#     kk = em3[ii,:]*n2em/1e58
    

#     gr = gg[1]
#     t0 = int(tt[ii])
#     t0 = str(t0)[:2] + ',' + str(t0)[2:] if t0 >= 10000 else str(t0)

#     tmp = tmp.format(*aa, *bb, *cc, *dd, *ee, *ff, *hh, *jj, *kk, gr, t0)
#     print(tmp)

# print('\n\n\n')
# for ii, gg in enumerate(groups):
#     gr = gg[1]
#     t0 = int(tt[ii])
#     t0 = str(t0)[:2] + ',' + str(t0)[2:] if t0 >= 10000 else str(t0)

#     tm2 =  '{0:<1s} & {1:>6s}'
#     tm2 += ' & ${2:.1f}_{{{3:.1f}}}^{{+{4:.1f}}}$'
#     tm2 += ' & ${5:.1f}_{{{6:.1f}}}^{{+{7:.1f}}}$'
#     tm2 += ' & ${8:.1f}_{{{9:.1f}}}^{{+{10:.1f}}}$'
#     tm2 += ' & ${11:.0f}/{12:d}={13:.2f}$ \\\\'

#     ch = chi[ii]
#     do = dof[ii]
#     go = ch/do
#     tm2 = tm2.format(gr, t0, ch, do, go)
#     print(tm2)


