#!/bin/bash -x

# Plot models (Group 1 and 8 for all):
# Three shock components
# Continuous temperature distribution
# Two shock and cut-off power law

cd /Users/silver/box/phd/pro/87a/nus/plt/mod/

mod=(lim_co2_g1 \
     lim_co2_g8 \
     com_g8 \
     dos_em10_013_pl0_g8 \
     com_g1 \
     dos_em10_013_pl0_g1)

# for mm in ${mod[@]}; do
#     printf "
# @${mm}.xcm
# abund wilm
# setpl ene
# energies 0.01 100 10000 log

# tclout plot eemo x
# echo \$xspec_tclout > ${mm}_xx.txt
# tclout plot eemo model
# echo \$xspec_tclout > ${mm}_yy.txt

# exit" > ${mm}_commands.xcm
# xspec < ${mm}_commands.xcm > ${mm}.log
# done



# printf "
# @lim_co2_g1.xcm
# abund wilm
# setpl ene
# energies 0.01 100 10000 log

# newpar 22 0
# newpar 43 0

# tclout plot eemo model
# echo \$xspec_tclout > lim_co2_g1_pl_yy.txt

# exit" > lim_co2_g1_pl_commands.xcm
# xspec < lim_co2_g1_pl_commands.xcm > lim_co2_g1_pl.log

# printf "
# @lim_co2_g8.xcm
# abund wilm
# setpl ene
# energies 0.01 100 10000 log

# newpar 22 0
# newpar 43 0

# tclout plot eemo model
# echo \$xspec_tclout > lim_co2_g8_pl_yy.txt

# exit" > lim_co2_g8_pl_commands.xcm
# xspec < lim_co2_g8_pl_commands.xcm > lim_co2_g8_pl.log



python -c "
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec

hh = 6.6260755e-27 # erg s
kev2erg = 1.60218e-9 # erg keV-1
hz2kev = hh/kev2erg

plt.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
plt.rc('text', usetex=True)

xx                  = np.loadtxt('lim_co2_g1_xx.txt')
lim_co2_g1          = np.loadtxt('lim_co2_g1_yy.txt')*kev2erg
lim_co2_g8          = np.loadtxt('lim_co2_g8_yy.txt')*kev2erg
com_g8              = np.loadtxt('com_g8_yy.txt')*kev2erg
dos_em10_013_pl0_g8 = np.loadtxt('dos_em10_013_pl0_g8_yy.txt')*kev2erg
com_g1              = np.loadtxt('com_g1_yy.txt')*kev2erg
dos_em10_013_pl0_g1 = np.loadtxt('dos_em10_013_pl0_g1_yy.txt')*kev2erg
g1_pl               = np.loadtxt('lim_co2_g1_pl_yy.txt')*kev2erg
g8_pl               = np.loadtxt('lim_co2_g8_pl_yy.txt')*kev2erg

fig = plt.figure(figsize=(10, 3.75))
ax1 = plt.gca()

ax1.plot(xx, g1_pl              ,  '-', c='tab:gray'  , lw=0.5)
ax1.plot(xx, g8_pl              , '--', c='tab:gray'  , lw=0.5)
ax1.plot(xx, com_g1             ,  '-', c='tab:blue'  , lw=1.0, label='First obs., three shocks')
ax1.plot(xx, dos_em10_013_pl0_g1,  '-', c='tab:orange', lw=1.0, label='First obs., continuous')
ax1.plot(xx, lim_co2_g1         ,  '-', c='tab:green' , lw=1.0, label='First obs., cutoff PL')
ax1.plot(xx, com_g8             , '--', c='tab:blue'  , lw=1.0, label='Last obs., three shocks')
ax1.plot(xx, dos_em10_013_pl0_g8, '--', c='tab:orange', lw=1.0, label='Last obs., continuous')
ax1.plot(xx, lim_co2_g8         , '--', c='tab:green' , lw=1.0, label='Last obs., cutoff PL')

ax1.legend(ncol=2, loc='best')
ax1.set_xscale('log')
ax1.set_yscale('log')

ax1.set_xlim(left=0.45, right=24)
ax1.set_ylim(bottom=1.e-14, top=3.e-10)
ax1.set_ylabel('\$EF_E\$ (keV erg s\$^{-1}\$ cm\$^{-2}\$ keV\$^{-1}\$)')
ax1.set_xlabel('Energy (keV)')

plt.savefig('/Users/silver/box/phd/pro/87a/nus/art/fig/mod.pdf', bbox_inches='tight', pad_inches=0.1, dpi=300)
"
