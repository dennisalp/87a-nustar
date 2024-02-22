#!/bin/bash -x

# Get iron line plot

cd /Users/silver/box/phd/pro/87a/nus/plt/til/

printf "
@grp2_ab.xcm
data ab.pha
ignore **: **-55. 82.-**
abund wilm
setpl ene
setpl rebin 9999 10
pl da

tclout plot da x
echo \$xspec_tclout > xx.txt
tclout plot da y
echo \$xspec_tclout > yy.txt
tclout plot da xerr
echo \$xspec_tclout > xe.txt
tclout plot da yerr
echo \$xspec_tclout > ye.txt

tclout plot da model
echo \$xspec_tclout > mm.txt

exit" > til.xcm
xspec < til.xcm > til.log

python -c "
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.gridspec as gridspec

plt.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
plt.rc('text', usetex=True)

v2_scale = 1e5

xx = np.loadtxt('xx.txt')
xe = np.loadtxt('xe.txt')
yy = np.loadtxt('yy.txt')
ye = np.loadtxt('ye.txt')
mm = np.loadtxt('mm.txt')

def hlp(aa, cc=0):
  mm = np.empty(2*xx.size)
  mm[:-1:2] = aa-cc
  mm[1::2] = aa+cc
  return mm
x2 = hlp(xx, xe)
b2 = hlp(mm)

# Prevents negatives for log scales
# y3 = np.where(yy < 1e-9, 1e-9, yy)
# y2 = np.array(ye)
# y2 = np.where(y2 > y3, 0.9999*y3, y2)
# y4 = np.where(yy < 1e-9, ye+yy, ye)
# y4 = np.where(y4 < 1e-9, 1e-9, y4)
y3 = yy
y2 = np.array(ye)
y2 = y2
y4 = y2

fig = plt.figure(figsize=(5, 3.75))
gs = gridspec.GridSpec(2, 1, height_ratios=[0.6, 0.4], hspace=0.0)
a1 = fig.add_subplot(gs[0])
a2 = fig.add_subplot(gs[1], sharex=a1)
plt.setp(a1.get_xticklabels(), visible=False)
a1.errorbar(xx, y3*v2_scale, xerr=xe, yerr=[y2*v2_scale,y4*v2_scale], c='tab:blue', fmt='none', lw=1.5, zorder=10, label='NuSTAR')
a1.errorbar(x2, b2*v2_scale, c='k', lw=1, zorder=4)


# a1.set_ylim([0.7e-5*v2_scale, 2.5e-5*v2_scale])
# a1.ticklabel_format(scilimits=(-3,3))
a1.set_ylabel('\$N_E\$ (\$10^{-5}\$ ph.\ s\$^{-1}\$ keV\$^{-1}\$)')


a2.axhline(0., c='k', label=None, lw=1, zorder=-10)
a2.errorbar(xx, (yy-mm)/ye, xerr=xe, c='tab:blue', yerr=1, fmt='none', label='\$M-D\$', lw=1.5, zorder=12)
a2.set_ylabel('\$(D-M)/\sigma\$')
a2.set_xlabel('Energy (keV)')
a2.set_xlim([55, 82])
a2.set_ylim([-3.5, 3.5])
plt.savefig('/Users/silver/box/phd/pro/87a/nus/art/fig/til_v2.pdf', bbox_inches='tight', pad_inches=0.1, dpi=300)
"
