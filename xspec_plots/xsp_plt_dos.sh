#!/bin/bash -x

# This is G3, epoch 3, with pn and with T=Tx.
# For illustrative purposes

cd /Users/silver/box/phd/pro/87a/nus/plt/dos/

# printf "
# data 1:1 g3.grp
# data 2:2 g3.grp
# data 3:3 g3.grp
# data 4:4 g3.grp
# data 5:5 g3.grp
# @dos_em10_013_pl0_g3.xcm
# data 1 none/
# data 1 none/
# data 1 none/
# data 1 none/
# newpar 13 1.0727917277486911
# ignore **-3. 65.-**

# abund wilm
# setpl ene
# setpl rebin 999999 2

# tclout plot lda x
# echo \$xspec_tclout > nus_lda_xx.txt
# tclout plot lda y
# echo \$xspec_tclout > nus_lda_yy.txt
# tclout plot lda xerr
# echo \$xspec_tclout > nus_lda_xe.txt
# tclout plot lda yerr
# echo \$xspec_tclout > nus_lda_ye.txt

# tclout plot euf x
# echo \$xspec_tclout > nus_euf_xx.txt
# tclout plot euf y
# echo \$xspec_tclout > nus_euf_yy.txt
# tclout plot euf xerr
# echo \$xspec_tclout > nus_euf_xe.txt
# tclout plot euf yerr
# echo \$xspec_tclout > nus_euf_ye.txt

# tclout plot lda model
# echo \$xspec_tclout > nus_lda_mo.txt
# tclout plot euf model
# echo \$xspec_tclout > nus_euf_mo.txt

# exit" > nus.xcm
# xspec < nus.xcm > nus.log

# printf "
# @dos_em10_013_pl0_g3.xcm
# data 0690510101_pn_spec_grp_pup.fits
# ignore 1: **-0.3 10.-**
# newpar 13 1.06430

# abund wilm
# setpl ene
# setpl rebin 30 5

# tclout plot lda x
# echo \$xspec_tclout > xmm_lda_xx.txt
# tclout plot lda y
# echo \$xspec_tclout > xmm_lda_yy.txt
# tclout plot lda xerr
# echo \$xspec_tclout > xmm_lda_xe.txt
# tclout plot lda yerr
# echo \$xspec_tclout > xmm_lda_ye.txt

# tclout plot euf x
# echo \$xspec_tclout > xmm_euf_xx.txt
# tclout plot euf y
# echo \$xspec_tclout > xmm_euf_yy.txt
# tclout plot euf xerr
# echo \$xspec_tclout > xmm_euf_xe.txt
# tclout plot euf yerr
# echo \$xspec_tclout > xmm_euf_ye.txt

# tclout plot lda model
# echo \$xspec_tclout > xmm_lda_mo.txt
# tclout plot euf model
# echo \$xspec_tclout > xmm_euf_mo.txt

# exit" > xmm.xcm
# xspec < xmm.xcm > xmm.log

# printf "
# @dos_em10_013_pl0_g3.xcm

# data 0690510101_r1o1_grp.fits 
# ignore **-0.45  1.95-**
# ignore 0.9-1.18

# abund wilm
# setpl ene
# setpl rebin 9999999 3

# tclout plot lda x
# echo \$xspec_tclout > rgs_lda_xx.txt
# tclout plot lda y
# echo \$xspec_tclout > rgs_lda_yy.txt
# tclout plot lda xerr
# echo \$xspec_tclout > rgs_lda_xe.txt
# tclout plot lda yerr
# echo \$xspec_tclout > rgs_lda_ye.txt

# tclout plot euf x
# echo \$xspec_tclout > rgs_euf_xx.txt
# tclout plot euf y
# echo \$xspec_tclout > rgs_euf_yy.txt
# tclout plot euf xerr
# echo \$xspec_tclout > rgs_euf_xe.txt
# tclout plot euf yerr
# echo \$xspec_tclout > rgs_euf_ye.txt

# tclout plot lda model
# echo \$xspec_tclout > rgs_lda_mo.txt
# tclout plot euf model
# echo \$xspec_tclout > rgs_euf_mo.txt

# exit" > rgs.xcm
# xspec < rgs.xcm > rgs.log

# printf "
# abund wilm
# setpl ene
# energies 0.01 100 10000 log

# @dos_em10_013_pl0_g3.xcm
# tclout plot emo x
# echo \$xspec_tclout > mod_x.txt
# tclout plot emo model
# echo \$xspec_tclout > mod_y.txt

# exit" > mod.xcm
# xspec < mod.xcm > mod.log


python -c "
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec

hh = 6.6260755e-27 # erg s
kev2erg = 1.60218e-9 # erg keV-1
hz2kev = hh/kev2erg

plt.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
plt.rc('text', usetex=True)


# Rescale the NuSTAR data so it can be plotted alongside RGS.
# I copy pasted from dos_em10_013_pl0_g3.xcm
wei = np.array([1., 1., 6.64, 6.64])
rgs2nus = np.array([0.872018, 1.00759, 1.09984, 1.0858])
rgs2nus = np.average(rgs2nus, weights=wei)
rgs2nus = 1. # fixed in xspec: newpar 1 1.0727917277486911
rgs2xmm = 1. # fixed in xspec: newpar 13 1.06430

nus_lda_ye = np.loadtxt('nus_lda_ye.txt')/rgs2nus
nus_lda_xe = np.loadtxt('nus_lda_xe.txt')
nus_lda_yy = np.loadtxt('nus_lda_yy.txt')/rgs2nus
nus_lda_xx = np.loadtxt('nus_lda_xx.txt')

nus_euf_ye = np.loadtxt('nus_euf_ye.txt')*kev2erg/rgs2nus
nus_euf_xe = np.loadtxt('nus_euf_xe.txt')
nus_euf_yy = np.loadtxt('nus_euf_yy.txt')*kev2erg/rgs2nus
nus_euf_xx = np.loadtxt('nus_euf_xx.txt')

nus_lda_mo = np.loadtxt('nus_lda_mo.txt')
nus_euf_mo = np.loadtxt('nus_euf_mo.txt')*kev2erg

xmm_lda_ye = np.loadtxt('xmm_lda_ye.txt')/rgs2xmm
xmm_lda_xe = np.loadtxt('xmm_lda_xe.txt')
xmm_lda_yy = np.loadtxt('xmm_lda_yy.txt')/rgs2xmm
xmm_lda_xx = np.loadtxt('xmm_lda_xx.txt')

xmm_euf_ye = np.loadtxt('xmm_euf_ye.txt')*kev2erg/rgs2xmm
xmm_euf_xe = np.loadtxt('xmm_euf_xe.txt')
xmm_euf_yy = np.loadtxt('xmm_euf_yy.txt')*kev2erg/rgs2xmm
xmm_euf_xx = np.loadtxt('xmm_euf_xx.txt')

xmm_lda_mo = np.loadtxt('xmm_lda_mo.txt')
xmm_euf_mo = np.loadtxt('xmm_euf_mo.txt')*kev2erg


rgs_lda_ye = np.loadtxt('rgs_lda_ye.txt')[::-1]
rgs_lda_xe = np.loadtxt('rgs_lda_xe.txt')[::-1]
rgs_lda_yy = np.loadtxt('rgs_lda_yy.txt')[::-1]
rgs_lda_xx = np.loadtxt('rgs_lda_xx.txt')[::-1]

rgs_euf_ye = np.loadtxt('rgs_euf_ye.txt')[::-1]*kev2erg
rgs_euf_xe = np.loadtxt('rgs_euf_xe.txt')[::-1]
rgs_euf_yy = np.loadtxt('rgs_euf_yy.txt')[::-1]*kev2erg
rgs_euf_xx = np.loadtxt('rgs_euf_xx.txt')[::-1]

rgs_lda_mo = np.loadtxt('rgs_lda_mo.txt')[::-1]
rgs_euf_mo = np.loadtxt('rgs_euf_mo.txt')[::-1]*kev2erg


mod_x = np.loadtxt('mod_x.txt')
mod_y = np.loadtxt('mod_y.txt')*kev2erg

def hlp(aa, cc=0):
  # from pdb import set_trace as db
  # db()
  mm = np.empty(2*aa.size)
  mm[:-1:2] = aa-cc
  mm[1::2] = aa+cc
  return mm

nus_lda_xx2 = hlp(nus_lda_xx, nus_lda_xe)
nus_euf_xx2 = hlp(nus_euf_xx, nus_euf_xe)
xmm_lda_xx2 = hlp(xmm_lda_xx, xmm_lda_xe)
xmm_euf_xx2 = hlp(xmm_euf_xx, xmm_euf_xe)
rgs_lda_xx2 = hlp(rgs_lda_xx, rgs_lda_xe)
rgs_euf_xx2 = hlp(rgs_euf_xx, rgs_euf_xe)

nus_lda_mo2 = hlp(nus_lda_mo)
nus_euf_mo2 = hlp(nus_euf_mo)
xmm_lda_mo2 = hlp(xmm_lda_mo)
xmm_euf_mo2 = hlp(xmm_euf_mo)
rgs_lda_mo2 = hlp(rgs_lda_mo)
rgs_euf_mo2 = hlp(rgs_euf_mo)



fig = plt.figure(figsize=(6, 4.5))
gs = gridspec.GridSpec(3, 1, height_ratios=[0.5, 0.25, 0.25], hspace=0.0)
a1 = fig.add_subplot(gs[0])
a2 = fig.add_subplot(gs[1], sharex=a1)
a3 = fig.add_subplot(gs[2], sharex=a1)
plt.setp(a1.get_xticklabels(), visible=False)
plt.setp(a2.get_xticklabels(), visible=False)

a1.errorbar(nus_euf_xx, nus_euf_yy, xerr=nus_euf_xe, yerr=nus_euf_ye, c='tab:blue', fmt='none', lw=1, zorder=11)
a1.errorbar(nus_euf_xx2, nus_euf_mo2, c='k', lw=1)

a1.errorbar(xmm_euf_xx, xmm_euf_yy, xerr=xmm_euf_xe, yerr=xmm_euf_ye, c='tab:green', fmt='none', lw=1, zorder=12)
a1.errorbar(xmm_euf_xx2, xmm_euf_mo2, c='k', lw=1)

ii = np.argmax(rgs_euf_xx>1)
i2 = np.argmax(rgs_euf_xx2>1)
a1.errorbar(rgs_euf_xx[:ii], rgs_euf_yy[:ii], xerr=rgs_euf_xe[:ii], yerr=rgs_euf_ye[:ii], c='tab:orange', fmt='none', lw=1, zorder=10)
a1.errorbar(rgs_euf_xx2[:i2], rgs_euf_mo2[:i2], c='k', lw=1)
a1.errorbar(rgs_euf_xx[ii:], rgs_euf_yy[ii:], xerr=rgs_euf_xe[ii:], yerr=rgs_euf_ye[ii:], c='tab:orange', fmt='none', lw=1, zorder=10)
a1.errorbar(rgs_euf_xx2[i2:], rgs_euf_mo2[i2:], c='k', lw=1)

# a1.plot(mod_x, mod_y, '--', c='lightgray', lw=0.5)

a1.set_xscale('log')
a1.set_yscale('log')
ymax = 2*(nus_euf_yy+nus_euf_ye).max()
ymax = np.max((2*(rgs_euf_yy+rgs_euf_ye).max(), ymax))
a1.set_ylim([1.1e-15, ymax])
a1.set_ylabel('\$F_E\$ (erg s\$^{-1}\$ cm\$^{-2}\$ keV\$^{-1}\$)')

a2.axhline(0., c='k', label=None, lw=1, zorder=-10)
a2.errorbar(nus_lda_xx, (nus_lda_yy-nus_lda_mo)/nus_lda_ye, xerr=nus_lda_xe, c='tab:blue', yerr=1, fmt='none', label='\$D-M\$', lw=1, zorder=11)
a2.errorbar(xmm_lda_xx, (xmm_lda_yy-xmm_lda_mo)/xmm_lda_ye, xerr=xmm_lda_xe, c='tab:green', yerr=1, fmt='none', label='\$D-M\$', lw=1, zorder=12)
ii = np.argmax(rgs_lda_xx>1)
a2.errorbar(rgs_lda_xx[:ii], (rgs_lda_yy[:ii]-rgs_lda_mo[:ii])/rgs_lda_ye[:ii], xerr=rgs_lda_xe[:ii], c='tab:orange', yerr=1, fmt='none', label='\$D-M\$', lw=1)
a2.errorbar(rgs_lda_xx[ii:], (rgs_lda_yy[ii:]-rgs_lda_mo[ii:])/rgs_lda_ye[ii:], xerr=rgs_lda_xe[ii:], c='tab:orange', yerr=1, fmt='none', label='\$D-M\$', lw=1)

a2.set_ylabel('\$(D-M)/\sigma\$')
a2.set_ylim([-8, 8])

a3.axhline(1., c='k', label=None, lw=1, zorder=-10)
a3.errorbar(nus_lda_xx, nus_lda_yy/nus_lda_mo, xerr=nus_lda_xe, c='tab:blue',  yerr=nus_lda_ye/nus_lda_mo, fmt='none', label='\$D-M\$', lw=1, zorder=11)
a3.errorbar(xmm_lda_xx, xmm_lda_yy/xmm_lda_mo, xerr=xmm_lda_xe, c='tab:green', yerr=xmm_lda_ye/xmm_lda_mo, fmt='none', label='\$D-M\$', lw=1, zorder=12)
ii = np.argmax(rgs_lda_xx>1)
a3.errorbar(rgs_lda_xx[:ii], rgs_lda_yy[:ii]/rgs_lda_mo[:ii], xerr=rgs_lda_xe[:ii], c='tab:orange', yerr=rgs_lda_ye[:ii]/rgs_lda_mo[:ii], fmt='none', label='\$D-M\$', lw=1)
a3.errorbar(rgs_lda_xx[ii:], rgs_lda_yy[ii:]/rgs_lda_mo[ii:], xerr=rgs_lda_xe[ii:], c='tab:orange', yerr=rgs_lda_ye[ii:]/rgs_lda_mo[ii:], fmt='none', label='\$D-M\$', lw=1)

a3.set_ylim([0.5, 1.5])
a3.set_ylabel('\$D/M\$')
a3.set_xlabel('Energy (keV)')
a3.set_xlim([0.3, 65.])

a1.annotate('\$\chi^{2}/\mathrm{DoF}=1741/1619=1.09\$', (7.8, 5e-11))
plt.savefig('/Users/silver/box/phd/pro/87a/nus/art/fig/dos_wo_pn_g3.pdf', bbox_inches='tight', pad_inches=0.1, dpi=300)
"
