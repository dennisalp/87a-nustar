#!/bin/bash -x

# Compare fits to quantify systematics



cd /Users/silver/box/phd/pro/87a/nus/plt/cal/


declare -a arr=("co2_v2_no_nus_g3.xcm" "co2_v2_no_pn_g3.xcm" "co2_v2_no_rgs_g3.xcm" "com_v2_0p88_g3.xcm" "com_v2_no_err_g3.xcm" "com_v2_no_nus_g3.xcm" "com_v2_no_pn_g3.xcm" "com_v2_no_rgs_g3.xcm" "com_v2_untie_t_g3.xcm" "com_v2_untie_t+em_g3.xcm")
# declare -a arr=("co2_v2_no_nus_g3.xcm")

# for i in "${arr[@]}"
# do
#     printf "
# abund wilm
# setpl ene
# energies 0.01 100 10000 log

# @${i}
# tclout plot emo x
# echo \$xspec_tclout > mod_x.txt
# tclout plot emo model
# echo \$xspec_tclout > ${i%.xcm}.txt

# exit" > ${i%.xcm}.inp
# xspec < ${i%.xcm}.inp > ${i%.xcm}.log

# done



################################################################


for i in "${arr[@]}"
do
    v=${i%.xcm}
#     printf "
# @${i}
# data g3.grp
# ignore 1: **-3. 65.-**

# abund wilm
# setpl ene

# tclout plot lda x
# echo \$xspec_tclout > nus_lda_xx_${v}.txt
# tclout plot lda y
# echo \$xspec_tclout > nus_lda_yy_${v}.txt
# tclout plot lda xerr
# echo \$xspec_tclout > nus_lda_xe_${v}.txt
# tclout plot lda yerr
# echo \$xspec_tclout > nus_lda_ye_${v}.txt

# tclout plot euf x
# echo \$xspec_tclout > nus_euf_xx_${v}.txt
# tclout plot euf y
# echo \$xspec_tclout > nus_euf_yy_${v}.txt
# tclout plot euf xerr
# echo \$xspec_tclout > nus_euf_xe_${v}.txt
# tclout plot euf yerr
# echo \$xspec_tclout > nus_euf_ye_${v}.txt

# tclout plot lda model
# echo \$xspec_tclout > nus_lda_mo_${v}.txt
# tclout plot euf model
# echo \$xspec_tclout > nus_euf_mo_${v}.txt

# exit" > nus_${v}.xcm
#     xspec < nus_${v}.xcm > nus_${v}.log

#     printf "
# @${i}

# data 0690510101_r1o1_grp.fits 
# ignore **-0.45  1.95-**
# ignore 0.9-1.18

# abund wilm
# setpl ene
# setpl rebin 9999999 3

# tclout plot lda x
# echo \$xspec_tclout > rgs_lda_xx_${v}.txt
# tclout plot lda y
# echo \$xspec_tclout > rgs_lda_yy_${v}.txt
# tclout plot lda xerr
# echo \$xspec_tclout > rgs_lda_xe_${v}.txt
# tclout plot lda yerr
# echo \$xspec_tclout > rgs_lda_ye_${v}.txt

# tclout plot euf x
# echo \$xspec_tclout > rgs_euf_xx_${v}.txt
# tclout plot euf y
# echo \$xspec_tclout > rgs_euf_yy_${v}.txt
# tclout plot euf xerr
# echo \$xspec_tclout > rgs_euf_xe_${v}.txt
# tclout plot euf yerr
# echo \$xspec_tclout > rgs_euf_ye_${v}.txt

# tclout plot lda model
# echo \$xspec_tclout > rgs_lda_mo_${v}.txt
# tclout plot euf model
# echo \$xspec_tclout > rgs_euf_mo_${v}.txt

# exit" > rgs_${v}.xcm
#     xspec < rgs_${v}.xcm > rgs_${v}.log

#     printf "
# @${i}

# data 0690510101_pn_spec_grp_pup.fits
# ignore **-0.8  10.-**

# abund wilm
# setpl ene
# setpl rebin 9999999 3

# tclout plot lda x
# echo \$xspec_tclout > xmm_lda_xx_${v}.txt
# tclout plot lda y
# echo \$xspec_tclout > xmm_lda_yy_${v}.txt
# tclout plot lda xerr
# echo \$xspec_tclout > xmm_lda_xe_${v}.txt
# tclout plot lda yerr
# echo \$xspec_tclout > xmm_lda_ye_${v}.txt

# tclout plot euf x
# echo \$xspec_tclout > xmm_euf_xx_${v}.txt
# tclout plot euf y
# echo \$xspec_tclout > xmm_euf_yy_${v}.txt
# tclout plot euf xerr
# echo \$xspec_tclout > xmm_euf_xe_${v}.txt
# tclout plot euf yerr
# echo \$xspec_tclout > xmm_euf_ye_${v}.txt

# tclout plot lda model
# echo \$xspec_tclout > xmm_lda_mo_${v}.txt
# tclout plot euf model
# echo \$xspec_tclout > xmm_euf_mo_${v}.txt

# exit" > xmm_${v}.xcm
#     xspec < xmm_${v}.xcm > xmm_${v}.log
done




###############################################################

# Fit statistic  : Chi-Squared                  482.71     using 419 bins.
#                  Chi-Squared                  644.78     using 566 bins.
#                  Chi-Squared                  261.15     using 229 bins.
#                  Chi-Squared                  187.03     using 211 bins.
#                  Chi-Squared                   12.76     using 12 bins.
#                  Chi-Squared                   18.12     using 15 bins.
#                  Chi-Squared                   75.56     using 93 bins.
#                  Chi-Squared                   89.26     using 91 bins.
# Total fit statistic                          1771.37     with 1620 d.o.f.

# Adding an additional PL to G3.
# Fit statistic  : Chi-Squared                  481.37     using 419 bins.
#                  Chi-Squared                  640.20     using 566 bins.
#                  Chi-Squared                  264.19     using 229 bins.
#                  Chi-Squared                  186.12     using 211 bins.
#                  Chi-Squared                   11.85     using 12 bins.
#                  Chi-Squared                   17.24     using 15 bins.
#                  Chi-Squared                   71.95     using 93 bins.
#                  Chi-Squared                   87.96     using 91 bins.
# Total fit statistic                          1760.88     with 1619 d.o.f.

for i in "${arr[@]}"
do
    python -c "
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec

hh = 6.6260755e-27 # erg s
kev2erg = 1.60218e-9 # erg keV-1
hz2kev = hh/kev2erg

plt.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
plt.rc('text', usetex=True)

ver = '${i%.xcm}'

################################################################
# Rescale the NuSTAR data so it can be plotted alongside RGS.
# I copy pasted from com_g1.xcm

wei = np.array([1., 1., 6.64, 6.64])
if ver == 'com_v2_no_err_g3':
    rgs = True
    rgs2nus = np.average(np.array([0.763888, 0.88567, 0.96791, 0.951039]), weights=wei)
    rgs2xmm = 1.06266

elif ver == 'com_v2_no_pn_g3':
    rgs = True
    rgs2nus = np.average(np.array([0.768661, 0.892938, 0.974751, 0.960792]), weights=wei)
    rgs2xmm = 1.
    
elif ver == 'com_v2_no_rgs_g3':
    rgs = False
    rgs2nus = np.average(np.array([1., 1.16008, 1.26901, 1.24901]), weights=wei)
    rgs2xmm = 1.38348
    
elif ver == 'com_v2_no_nus_g3':
    rgs = True
    rgs2nus = 1.
    rgs2xmm = 1.06998
    
    
elif ver == 'co2_v2_no_err_g3':
    rgs = True
    rgs2nus = np.average(np.array([0.791271, 0.918577, 1.00164, 0.983474]), weights=wei)
    rgs2xmm = 1.09901
    
elif ver == 'co2_v2_no_pn_g3':
    rgs = True
    rgs2nus = np.average(np.array([0.605003, 0.707591, 0.769481, 0.756154]), weights=wei)
    rgs2xmm = 1.
    
elif ver == 'co2_v2_no_rgs_g3':
    rgs = False
    rgs2nus = np.average(np.array([1., 1.16052, 1.26693, 1.24471]), weights=wei)
    rgs2xmm = 1.3906

elif ver == 'co2_v2_no_nus_g3':
    rgs = True
    rgs2nus = 1.
    rgs2xmm = 1.10567

else:
    rgs = True
    rgs2nus = 1.
    rgs2xmm = 1.

################################################################
nus_lda_ye = np.loadtxt('nus_lda_ye_' + ver + '.txt')/rgs2nus
nus_lda_xe = np.loadtxt('nus_lda_xe_' + ver + '.txt')
nus_lda_yy = np.loadtxt('nus_lda_yy_' + ver + '.txt')/rgs2nus
nus_lda_xx = np.loadtxt('nus_lda_xx_' + ver + '.txt')

nus_euf_ye = np.loadtxt('nus_euf_ye_' + ver + '.txt')*kev2erg/rgs2nus
nus_euf_xe = np.loadtxt('nus_euf_xe_' + ver + '.txt')
nus_euf_yy = np.loadtxt('nus_euf_yy_' + ver + '.txt')*kev2erg/rgs2nus
nus_euf_xx = np.loadtxt('nus_euf_xx_' + ver + '.txt')

nus_lda_mo = np.loadtxt('nus_lda_mo_' + ver + '.txt')
nus_euf_mo = np.loadtxt('nus_euf_mo_' + ver + '.txt')*kev2erg


xmm_lda_ye = np.loadtxt('xmm_lda_ye_' + ver + '.txt')/rgs2xmm
xmm_lda_xe = np.loadtxt('xmm_lda_xe_' + ver + '.txt')
xmm_lda_yy = np.loadtxt('xmm_lda_yy_' + ver + '.txt')/rgs2xmm
xmm_lda_xx = np.loadtxt('xmm_lda_xx_' + ver + '.txt')

xmm_euf_ye = np.loadtxt('xmm_euf_ye_' + ver + '.txt')*kev2erg/rgs2xmm
xmm_euf_xe = np.loadtxt('xmm_euf_xe_' + ver + '.txt')
xmm_euf_yy = np.loadtxt('xmm_euf_yy_' + ver + '.txt')*kev2erg/rgs2xmm
xmm_euf_xx = np.loadtxt('xmm_euf_xx_' + ver + '.txt')

xmm_lda_mo = np.loadtxt('xmm_lda_mo_' + ver + '.txt')
xmm_euf_mo = np.loadtxt('xmm_euf_mo_' + ver + '.txt')*kev2erg


rgs_lda_ye = np.loadtxt('rgs_lda_ye_' + ver + '.txt')[::-1]
rgs_lda_xe = np.loadtxt('rgs_lda_xe_' + ver + '.txt')[::-1]
rgs_lda_yy = np.loadtxt('rgs_lda_yy_' + ver + '.txt')[::-1]
rgs_lda_xx = np.loadtxt('rgs_lda_xx_' + ver + '.txt')[::-1]

rgs_euf_ye = np.loadtxt('rgs_euf_ye_' + ver + '.txt')[::-1]*kev2erg
rgs_euf_xe = np.loadtxt('rgs_euf_xe_' + ver + '.txt')[::-1]
rgs_euf_yy = np.loadtxt('rgs_euf_yy_' + ver + '.txt')[::-1]*kev2erg
rgs_euf_xx = np.loadtxt('rgs_euf_xx_' + ver + '.txt')[::-1]

rgs_lda_mo = np.loadtxt('rgs_lda_mo_' + ver + '.txt')[::-1]
rgs_euf_mo = np.loadtxt('rgs_euf_mo_' + ver + '.txt')[::-1]*kev2erg


mod_x = np.loadtxt('mod_x.txt')
mod_y = np.loadtxt(ver + '.txt')*kev2erg

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



fig = plt.figure(figsize=(10, 5.2))
gs = gridspec.GridSpec(2, 1, height_ratios=[0.7, 0.3], hspace=0.0)
a1 = fig.add_subplot(gs[0])
a2 = fig.add_subplot(gs[1], sharex=a1)
plt.setp(a1.get_xticklabels(), visible=False)

a1.errorbar(nus_euf_xx, nus_euf_yy, xerr=nus_euf_xe, yerr=nus_euf_ye, c='tab:blue', fmt='none', lw=1, zorder=10)
a1.errorbar(nus_euf_xx2, nus_euf_mo2, c='k', lw=1)

a1.errorbar(xmm_euf_xx, xmm_euf_yy, xerr=xmm_euf_xe, yerr=xmm_euf_ye, c='tab:green', fmt='none', lw=1, zorder=10)
a1.errorbar(xmm_euf_xx2, xmm_euf_mo2, c='k', lw=1)

ii = np.argmax(rgs_euf_xx>1)
i2 = np.argmax(rgs_euf_xx2>1)
a1.errorbar(rgs_euf_xx[:ii], rgs_euf_yy[:ii], xerr=rgs_euf_xe[:ii], yerr=rgs_euf_ye[:ii], c='tab:orange', fmt='none', lw=1, zorder=10)
a1.errorbar(rgs_euf_xx2[:i2], rgs_euf_mo2[:i2], c='k', lw=1)
a1.errorbar(rgs_euf_xx[ii:], rgs_euf_yy[ii:], xerr=rgs_euf_xe[ii:], yerr=rgs_euf_ye[ii:], c='tab:orange', fmt='none', lw=1, zorder=10)
a1.errorbar(rgs_euf_xx2[i2:], rgs_euf_mo2[i2:], c='k', lw=1)

a1.plot(mod_x, mod_y, '--', c='lightgray', lw=0.5)
    
a1.set_xscale('log')
a1.set_yscale('log')
ymax = 2*(nus_euf_yy+nus_euf_ye).max()
ymax = np.max((2*(rgs_euf_yy+rgs_euf_ye).max(), ymax))
a1.set_ylim([1.e-15, ymax])
a1.set_ylabel('\$F_E\$ (erg s\$^{-1}\$ cm\$^{-2}\$ keV\$^{-1}\$)')

a2.axhline(0., c='k', label=None, lw=1, zorder=-10)
a2.errorbar(nus_lda_xx, (nus_lda_yy-nus_lda_mo)/nus_lda_ye, xerr=nus_lda_xe, c='tab:blue', yerr=1, fmt='none', label='\$M-D\$', lw=1)
a2.errorbar(xmm_lda_xx, (xmm_lda_yy-xmm_lda_mo)/xmm_lda_ye, xerr=xmm_lda_xe, c='tab:green', yerr=1, fmt='none', label='\$M-D\$', lw=1)
ii = np.argmax(rgs_lda_xx>1)
a2.errorbar(rgs_lda_xx[:ii], (rgs_lda_yy[:ii]-rgs_lda_mo[:ii])/rgs_lda_ye[:ii], xerr=rgs_lda_xe[:ii], c='tab:orange', yerr=1, fmt='none', label='\$M-D\$', lw=1)
a2.errorbar(rgs_lda_xx[ii:], (rgs_lda_yy[ii:]-rgs_lda_mo[ii:])/rgs_lda_ye[ii:], xerr=rgs_lda_xe[ii:], c='tab:orange', yerr=1, fmt='none', label='\$M-D\$', lw=1)

a2.set_ylabel('\$(D-M)/\sigma\$')
a2.set_xlabel('Energy (keV)')
a2.set_xlim([0.45, 100.])
a2.set_ylim([-3.5, 3.5])
plt.savefig('/Users/silver/box/phd/pro/87a/nus/art/fig/' + ver + '.pdf', bbox_inches='tight', pad_inches=0.1, dpi=300)
"

done


