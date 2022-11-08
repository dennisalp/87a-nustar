#!/bin/bash -x

# Make continuum plot

cd /Users/silver/box/phd/pro/87a/nus/plt/con/

printf "
@com_g1.xcm
data g1.grp
ignore 1: **-3. 65.-**

abund wilm
setpl ene

tclout plot lda x
echo \$xspec_tclout > nus_lda_xx.txt
tclout plot lda y
echo \$xspec_tclout > nus_lda_yy.txt
tclout plot lda xerr
echo \$xspec_tclout > nus_lda_xe.txt
tclout plot lda yerr
echo \$xspec_tclout > nus_lda_ye.txt

tclout plot euf x
echo \$xspec_tclout > nus_euf_xx.txt
tclout plot euf y
echo \$xspec_tclout > nus_euf_yy.txt
tclout plot euf xerr
echo \$xspec_tclout > nus_euf_xe.txt
tclout plot euf yerr
echo \$xspec_tclout > nus_euf_ye.txt

tclout plot lda model
echo \$xspec_tclout > nus_lda_mo.txt
tclout plot euf model
echo \$xspec_tclout > nus_euf_mo.txt

exit" > nus.xcm
xspec < nus.xcm > nus.log

printf "
@com_g1.xcm

data 0690510101_r1o1_grp.fits 
ignore **-0.45  1.95-**
ignore 0.9-1.18

abund wilm
setpl ene
setpl rebin 9999999 3

tclout plot lda x
echo \$xspec_tclout > rgs_lda_xx.txt
tclout plot lda y
echo \$xspec_tclout > rgs_lda_yy.txt
tclout plot lda xerr
echo \$xspec_tclout > rgs_lda_xe.txt
tclout plot lda yerr
echo \$xspec_tclout > rgs_lda_ye.txt

tclout plot euf x
echo \$xspec_tclout > rgs_euf_xx.txt
tclout plot euf y
echo \$xspec_tclout > rgs_euf_yy.txt
tclout plot euf xerr
echo \$xspec_tclout > rgs_euf_xe.txt
tclout plot euf yerr
echo \$xspec_tclout > rgs_euf_ye.txt

tclout plot lda model
echo \$xspec_tclout > rgs_lda_mo.txt
tclout plot euf model
echo \$xspec_tclout > rgs_euf_mo.txt

exit" > rgs.xcm
xspec < rgs.xcm > rgs.log

printf "
abund wilm
setpl ene
energies 0.01 100 10000 log

@com_g1.xcm
newpar 43 0
newpar 64 0
tclout plot emo x
echo \$xspec_tclout > mod_x.txt
tclout plot emo model
echo \$xspec_tclout > mod_1.txt

@com_g1.xcm
newpar 22 0
newpar 64 0
tclout plot emo model
echo \$xspec_tclout > mod_2.txt

@com_g1.xcm
newpar 22 0
newpar 43 0
tclout plot emo model
echo \$xspec_tclout > mod_3.txt

exit" > mod.xcm
xspec < mod.xcm > mod.log

printf "
abund wilm
setpl ene
energies 0.01 100 10000 log

@lim_co2.xcm
tclout plot emo model
echo \$xspec_tclout > mod_pow.txt

exit" > mod_pow.xcm
xspec < mod_pow.xcm > mod_pow.log

printf "
abund wilm
setpl ene
energies 0.01 100 10000 log

@com_g1.xcm
editmo tba(gsm(vps))+tba(gsm(vps))+tba(gsm(vps))
editmo tba(gsm(vps))+tba(gsm(vps))+tba(vps)
editmo tba(gsm(vps))+tba(gsm(vps))+vps
editmo tba(gsm(vps))+tba(gsm(vps))
editmo tba(gsm(vps))+gsm(vps)
editmo tba(gsm(vps))+vps
editmo tba(gsm(vps))
editmo tba(vps)
editmo tba(pow)
2
1
tclout plot emo model
echo \$xspec_tclout > abs_1.txt
editmo pow
tclout plot emo model
echo \$xspec_tclout > abs_2.txt

exit" > abs.xcm
xspec < abs.xcm > abs.log

python -c "
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec

hh = 6.6260755e-27 # erg s
kev2erg = 1.60218e-9 # erg keV-1
hz2kev = hh/kev2erg

plt.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
plt.rc('text', usetex=True)

# Read berezhko15
ber = np.loadtxt('/Users/silver/box/sci/lib/b/berezhko15/9280d.txt')
nu = ber[:,0]
nuSnu = ber[:,1]
Snu = nuSnu/nu
Fnu = Snu*1e-3*kev2erg
FE = Fnu/hz2kev
kev = nu*hz2kev

# Rescale the NuSTAR data so it can be plotted alongside RGS.
# I copy pasted from com_g1.xcm
rgs2nus = np.array([0.908596, 0.899799, 0.905701, 0.939113, 0.91116, 0.977323])
rgs2nus = np.average(rgs2nus)

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
mod_1 = np.loadtxt('mod_1.txt')*kev2erg
mod_2 = np.loadtxt('mod_2.txt')*kev2erg
mod_3 = np.loadtxt('mod_3.txt')*kev2erg
pow_0 = np.loadtxt('mod_pow.txt')*kev2erg

abs_1 = np.loadtxt('abs_1.txt')
abs_2 = np.loadtxt('abs_2.txt')
FE = np.interp(kev, mod_x, abs_1/abs_2)*FE

def hlp(aa, cc=0):
  mm = np.empty(2*aa.size)
  mm[:-1:2] = aa-cc
  mm[1::2] = aa+cc
  return mm

nus_lda_xx2 = hlp(nus_lda_xx, nus_lda_xe)
nus_euf_xx2 = hlp(nus_euf_xx, nus_euf_xe)
rgs_lda_xx2 = hlp(rgs_lda_xx, rgs_lda_xe)
rgs_euf_xx2 = hlp(rgs_euf_xx, rgs_euf_xe)

nus_lda_mo2 = hlp(nus_lda_mo)
nus_euf_mo2 = hlp(nus_euf_mo)
rgs_lda_mo2 = hlp(rgs_lda_mo)
rgs_euf_mo2 = hlp(rgs_euf_mo)

# y3 = np.where(yy < 1e-9, 1e-9, yy)
# y2 = np.array(ye)
# y2 = np.where(y2 > y3, 0.9999*y3, y2)
# y4 = np.where(yy < 1e-9, ye+yy, ye)
# y4 = np.where(y4 < 1e-9, 1e-9, y4)

fig = plt.figure(figsize=(10, 5.2))
gs = gridspec.GridSpec(2, 1, height_ratios=[0.7, 0.3], hspace=0.0)
a1 = fig.add_subplot(gs[0])
a2 = fig.add_subplot(gs[1], sharex=a1)
plt.setp(a1.get_xticklabels(), visible=False)

a1.errorbar(nus_euf_xx, nus_euf_yy, xerr=nus_euf_xe, yerr=nus_euf_ye, c='tab:blue', fmt='none', lw=1, zorder=10)
a1.errorbar(nus_euf_xx2, nus_euf_mo2, c='k', lw=1)

ii = np.argmax(rgs_euf_xx>1)
i2 = np.argmax(rgs_euf_xx2>1)
a1.errorbar(rgs_euf_xx[:ii], rgs_euf_yy[:ii], xerr=rgs_euf_xe[:ii], yerr=rgs_euf_ye[:ii], c='tab:orange', fmt='none', lw=1, zorder=10)
a1.errorbar(rgs_euf_xx2[:i2], rgs_euf_mo2[:i2], c='k', lw=1)
a1.errorbar(rgs_euf_xx[ii:], rgs_euf_yy[ii:], xerr=rgs_euf_xe[ii:], yerr=rgs_euf_ye[ii:], c='tab:orange', fmt='none', lw=1, zorder=10)
a1.errorbar(rgs_euf_xx2[i2:], rgs_euf_mo2[i2:], c='k', lw=1)

a1.plot(mod_x, mod_1, '--', c='lightgray', lw=0.5)
a1.plot(mod_x, mod_2, '--', c='darkgray', lw=0.5)
a1.plot(mod_x, mod_3, '--', c='gray', lw=0.5)
# a1.plot(mod_x, pow_0, '--', c='gray', lw=2)

a1.plot(kev, FE, ':', c='tab:green', lw=1)

a1.set_xscale('log')
a1.set_yscale('log')
ymax = 2*(nus_euf_yy+nus_euf_ye).max()
ymax = np.max((2*(rgs_euf_yy+rgs_euf_ye).max(), ymax))
a1.set_ylim([1.e-15, ymax])
a1.set_ylabel('\$F_E\$ (erg s\$^{-1}\$ cm\$^{-2}\$ keV\$^{-1}\$)')

a2.axhline(0., c='k', label=None, lw=1, zorder=-10)
a2.errorbar(nus_lda_xx, (nus_lda_yy-nus_lda_mo)/nus_lda_ye, xerr=nus_lda_xe, c='tab:blue', yerr=1, fmt='none', label='\$M-D\$', lw=1)
ii = np.argmax(rgs_lda_xx>1)
a2.errorbar(rgs_lda_xx[:ii], (rgs_lda_yy[:ii]-rgs_lda_mo[:ii])/rgs_lda_ye[:ii], xerr=rgs_lda_xe[:ii], c='tab:orange', yerr=1, fmt='none', label='\$M-D\$', lw=1)
a2.errorbar(rgs_lda_xx[ii:], (rgs_lda_yy[ii:]-rgs_lda_mo[ii:])/rgs_lda_ye[ii:], xerr=rgs_lda_xe[ii:], c='tab:orange', yerr=1, fmt='none', label='\$M-D\$', lw=1)

a2.set_ylabel('\$(D-M)/\sigma\$')
a2.set_xlabel('Energy (keV)')
a2.set_xlim([0.45, 100.])
a2.set_ylim([-3.5, 3.5])
plt.savefig('/Users/silver/box/phd/pro/87a/nus/art/fig/con.pdf', bbox_inches='tight', pad_inches=0.1, dpi=300)

print('berezhko15 fluxes')
FE = np.interp(mod_x, kev, FE)
kev = np.interp(mod_x, kev, kev)

ii = (kev > 3) & (kev < 8)
print('3-8 keV', np.trapz(FE[ii], kev[ii]), 'erg s-1 cm-2')
ii = (kev > 10) & (kev < 24)
print('10-24 keV', np.trapz(FE[ii], kev[ii]), 'erg s-1 cm-2')
ii = (kev > 35) & (kev < 65)
print('35-65 keV', np.trapz(FE[ii], kev[ii]), 'erg s-1 cm-2')
"
