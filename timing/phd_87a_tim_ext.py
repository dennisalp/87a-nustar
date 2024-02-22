# This just extracts data from .fits files and dumps it into a .npy file

from __future__ import division, print_function
import os
import pdb
import sys
from glob import glob

import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
from scipy.ndimage import gaussian_filter
from scipy.interpolate import griddata
from scipy.optimize import curve_fit
import scipy.stats as sts

#For LaTeX style font in plots
plt.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
plt.rc('text', usetex=True)

def kev2pi(kev):
    return (kev-1.6)/0.04

# parameters
files = glob('/Users/silver/dat/nus/87a/*/pro/*_bc.evt')
wd = '/Users/silver/box/phd/pro/87a/nus/'
sig = 10
subnx = 32
subny = 32
subx2 = 256
suby2 = 256
ene_lim = 35 # 3 keV
ene_lim = 460 # 20 keV
ene_lim = 1500 # 61.6 keV
ene_lim = 835 # 35 keV
ene_max = 1585 # 65 keV
ene_lim = 335 # 15 keV
ene_lim = 210 # 10 keV
ene_max = 1909

ene_max = kev2pi(20)
ene_lim = kev2pi(10)
#
#ene_lim = 970
#ene_max = 1080

# alloc
out = np.zeros((9999999, 4))
os.chdir(wd)

################################################################
# help functions
def help_gauss(dummy, x0, y0, aa, sig):
#    print(x0, y0, aa, sig)
    xx = np.arange(0,subnx)
    yy = np.arange(0,subny)[:,None]
    xx = xx-x0
    yy = yy-y0
    rr = xx**2+yy**2
    return np.reshape(aa*np.exp(-0.5*rr/sig**2), subnx*subny)

def help_gauss_const(dummy, x0, y0, aa, sig, aa2, sig2, cc):
    print(x0, y0, aa, sig, aa2, sig2, cc)
    xx = np.arange(0, nx)
    yy = np.arange(0, ny)[:,None]
    xx = xx-x0
    yy = yy-y0
    rr = xx**2+yy**2
    rr = np.where(rr > 30**2, np.inf, rr)
    global last
    last = aa*np.exp(-0.5*rr/sig**2)+aa2*np.exp(-0.5*rr/sig2**2)+cc
    return np.reshape(last, nx*ny)

def radial_profile(dat, wei, bkg):
    x0 = subx2//2
    y0 = suby2//2
    xx, yy = np.indices((dat.shape))
    rr = np.sqrt((xx - x0)**2 + (yy - y0)**2)

    nn = 1000
    steps = np.linspace(1, subx2//2, nn)
    snr = np.zeros(nn)
    src = np.zeros(nn)
    
#   the weights makes the tail of the radial profile flat
    for ii, step in enumerate(steps):
        ind = rr < step
        src[ii] = np.sum((dat[ind]-bkg)*wei[ind])
        snr[ii] = src[ii]/np.sqrt(np.sum(dat[ind]*wei[ind]**2))
    return steps, snr

def get_Pn(tt, ww, k2, nn):
    walk = ww*np.exp((-2*np.pi*1j*nn)*tt) # map to complex numbers
    walk = np.sum(walk) # sum all complex numbers
    walk = np.real(walk)**2+np.imag(walk)**2 # distance from origin
    walk = walk/k2 # normalize
    return walk

def h_statistic(tt, ww, k2):
    mmax = 20
    mm = np.arange(mmax)+1
    Z2 = np.zeros(mmax)
    HH = np.zeros(mmax)
    for nn in mm:
        Z2[nn-1] = get_Pn(tt, ww, k2, nn)

    for ii in range(0, mmax):
        HH[ii] = np.sum(Z2[:ii+1])-4*(ii+1)+4
    return np.max(HH)


################################################################
# main
cou = 0
for ff in files[:]:
    print(ff)

    # load and label
    dat = fits.open(ff)[1].data
    tt = dat['TIME']
    pi = dat['PI']
    xx = dat['X']
    yy = dat['Y']

    # filter dummies
    valid = (xx > 1) & (yy > 1)
    tt = tt[valid]
    pi = pi[valid]
    xx = xx[valid]
    yy = yy[valid]

    # make image
    nx = np.max(xx)-np.min(xx)+1
    ny = np.max(yy)-np.min(yy)+1
    img, xedges, yedges = np.histogram2d(xx, yy, [nx, ny])

    # find center
    smo = gaussian_filter(img, sig, order=0, mode='constant', cval=0.0, truncate=4.0)
    x0, y0 = np.unravel_index(smo.argmax(), smo.shape)
#    plt.imshow(smo, interpolation='nearest', origin='low')
#    plt.plot(y0, x0, 'ok')
#    plt.show()

    guess = [subnx/2, subny/2, 10, sig]
    pars, covar = curve_fit(help_gauss, np.arange(0, subnx*subny), img[x0-subnx//2:x0+subnx//2, y0-subny//2:y0+subny//2].ravel(), guess)
#    plt.imshow(img, interpolation='nearest', origin='low')
#    plt.plot(y0-subny//2+np.int(np.round(pars[1])), x0-subnx//2+np.int(np.round(pars[0])), 'ok')
#    plt.show()
    
    # shift
    xx = xx-(np.min(xx)+x0-subnx//2+np.int(np.round(pars[0])))
    yy = yy-(np.min(yy)+y0-subny//2+np.int(np.round(pars[1])))

    # save and move on
    nn = tt.size
    out[cou:cou+nn, :] = np.vstack((tt, pi, xx, yy)).T
    cou += nn


    
################################################################
# energy filter
out = out[:cou, :]
ene_cut = (out[:, 1] > ene_lim) & (out[:, 1] <= ene_max)
out = out[ene_cut, :]

# make the stacked image
nx = subx2+1
ny = suby2+1
img, xedges, yedges = np.histogram2d(out[:,2], out[:,3], bins=[nx, ny], range=[[-subx2//2, subx2//2], [-suby2//2, suby2//2]])
#plt.imshow(gaussian_filter(img, 6, order=0, mode='constant', cval=0.0, truncate=4.0), origin='lower')
#plt.show()
#pdb.set_trace()

# fit gaussian to it to get background level and weights map
guess = [nx/2, ny/2, 10, sig, 15, sig/5, 10]
pars, covar = curve_fit(help_gauss_const, np.arange(0, nx*ny), img.ravel(), guess)
bkg = pars[-1]
src = img-bkg
wei = src/bkg-1 # if high snr, empirical weights
wei = last/bkg-1 # if low snr, modeled weights

# s/n
rr, snr = radial_profile(img, wei, bkg)
#plt.plot(rr, snr)
#plt.show()
snr_max = np.argmax(snr)
snr_max = rr[snr_max]
snr_max = snr_max if snr_max < 30 else 30
print('Maximum S/R at radius:', snr_max)
plt.plot(rr, snr)

# find optimal radius for upper limit of non-detection
def dbl_gau(rr, a1, s1, a2, s2):
    fun = rr*(a1*np.exp(-0.5*rr**2/s1**2)+a2*np.exp(-0.5*rr**2/s2**2))
    return np.cumsum(fun)
rr = np.linspace(0.0001, 50, 1000)
fpsf = dbl_gau(rr, pars[2], pars[3], pars[4], pars[5])
fpsf /= fpsf[-1]
hard_bkg = 6.87918869
variance = rr**2*hard_bkg/fpsf**2
plt.loglog(rr, variance)

# spatial filter
r_lim = out[:,2]**2+out[:,3]**2 < snr_max**2
out = out[r_lim, :]

# get weights list
wei = wei[(out[:, 2]+subx2//2).astype(int), (out[:, 3]+suby2//2).astype(int)]
out = np.hstack((out, wei[:, np.newaxis]))

sub = np.sum((img-last)[nx//2-20: nx//2+20, ny//2-20: ny//2+20])
tot = np.sum((img-bkg)[nx//2-20: nx//2+20, ny//2-20: ny//2+20])
print('Residual:', np.abs(sub/tot))

# Group the observations
#cuts = np.argwhere(np.diff(out[:,0]) > 1e6)[:,0]
#cuts = np.append(cuts, out.shape[0])+1
#cuts = np.insert(cuts, 0, 0)

org = out.copy()
order = np.argsort(out[:,0])
out = out[order,:]
low_lim = np.argmin(out[:,0])
ii = 0
cuts = [0]
while (True):
    idx = np.where(out[:,0] < out[low_lim,0]+128000.)[0]
#    np.savetxt('dat/87a_g' + str(ii).zfill(2) + '.dat', out[idx, :])
    cuts.append(idx.size+cuts[-1])

    print(out[idx[0],0], out[idx[-1],0], out[idx[-1],0]-out[idx[0],0], idx.size)
    
    out[idx,0] = np.inf
    if (np.min(out[:,0]) == np.inf): break
    low_lim = np.argmin(out[:,0])
    ii += 1

cuts = np.array(cuts)
pdb.set_trace()  

########
# Simulate observations
np.random.seed(31526)
nh = 1
HH = np.zeros((nh, len(glob('dat/87a_g*.dat'))))
for ii in range(0, nh):
    if np.mod(ii, 100) == 0: print(ii/nh)
    xtra = 2
    nn = xtra*out.shape[0]
    cutoff = pars[2]*np.exp(-0.5*snr_max**2/pars[3]**2)+pars[4]*np.exp(-0.5*snr_max**2/pars[5]**2)+pars[6]
    rad = np.ceil(snr_max).astype(np.int)
    wei_map = last[-rad+subx2//2:rad+subx2//2, -rad+suby2//2:rad+suby2//2]
    wei_map = np.where(wei_map > cutoff, last[-rad+subx2//2:rad+subx2//2, -rad+suby2//2:rad+suby2//2]/bkg-1, 0)
    wei_map = wei_map.ravel()

    pf = 0.15
    bkg_cts = np.int(np.round(np.sum(wei_map > 0)*xtra*bkg))
    src_cts = np.int(np.round(pf*(nn-bkg_cts)))
    eje_cts = np.int(np.round((1-pf)*(nn-bkg_cts)))
    
    # Generate the events
    fwhm = 0.2
    sig = fwhm/(2*np.sqrt(2*np.log(2)))
    src_evt = np.random.normal(0.5, sig, src_cts)
    src_evt = np.mod(src_evt, 1)
    src_wei = np.random.choice(wei_map, size=src_cts, p=wei_map/np.sum(wei_map))
    
    eje_evt = np.random.uniform(0, 1, eje_cts)
    eje_wei = np.random.choice(wei_map, size=eje_cts, p=wei_map/np.sum(wei_map))
    
    bkg_evt = np.random.uniform(0, 1, bkg_cts)
    bkg_wei = np.random.choice(wei_map, size=bkg_cts, p=np.where(wei_map > 0, 1, 0)/np.sum(wei_map>0))
    
    all_evt = np.concatenate((src_evt, eje_evt, bkg_evt))
    all_wei = np.concatenate((src_wei, eje_wei, bkg_wei))

    rng_state = np.random.get_state()
    np.random.shuffle(all_evt)
    np.random.set_state(rng_state)
    np.random.shuffle(all_wei)
    
    # Compute the H stat
    counter = 0
    for jj in range(0, cuts.size-1):
        rand_cts = sts.poisson.rvs(cuts[jj+1]-cuts[jj])+counter
        k2 = 0.5*np.sum(all_wei[counter:rand_cts]**2)
        HH[ii, jj] = h_statistic(all_evt[counter:rand_cts], all_wei[counter:rand_cts], k2)
        counter = rand_cts
        
KK = np.sum(HH, axis=1)
#plt.hist(KK)
#plt.show()
if nh > 99999:
    np.save('bin_87a/pdc/fake_kk_poi', KK)

fig = plt.figure(figsize=(5, 3.75))
nb = 32
plt.hist(all_evt[:rand_cts], nb, alpha=0.25, color='gray', weights=all_wei[:rand_cts])
plt.hist(all_evt[:rand_cts], nb, alpha=0.75, color='gray')
xx = np.linspace(0, 1, 10000)

bkg_amp = bkg_cts/nb*rand_cts/nn
eje_amp = eje_cts/nb*rand_cts/nn
src_amp = src_cts/nb*rand_cts/nn/np.sqrt(np.pi/(0.5/sig**2))
plt.plot(xx, src_amp*np.exp(-0.5*(xx-0.5)**2/sig**2)+bkg_amp+eje_amp)
plt.gca().axhline(bkg_amp, c='#2ca02c')
plt.gca().axhline(eje_amp+bkg_amp, c='#ff7f0e')
plt.xlim([0, 1])
plt.xlabel('Normalized Phase')
plt.ylabel('Counts')
fig.savefig('/Users/silver/box/phd/pro/87a/nus/art/fig/sim.pdf', bbox_inches='tight', pad_inches=0.1, dpi=300)
plt.show()

pdb.set_trace()
