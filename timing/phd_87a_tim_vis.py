from __future__ import division, print_function
import os
import pdb
import time
import sys

import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import griddata
from scipy.integrate import simps
from astropy.io import fits
import scipy.stats as sts

from joblib import Parallel, delayed
import multiprocessing



################################################################
# Search for phase peaks
def get_PP():
#    uu = np.arange(1e-1, 1e2/3, sparse/(10*tt[-1]))
    uu = np.arange(1e-1, 2e1, sparse/(10*tt[-1]))
    return 1/uu[::-1]

def fold(ii):
    dist = np.sort(np.mod(tt, PP[ii]))/PP[ii]
    cdf = griddata(dist, cp, cp, method='linear', fill_value=1)
    cvm = simps((cdf-cp)**2, cp, even='first')
    
    if np.mod(ii, 100000) == 0:
        print(ii/PP.size)
        sys.stdout.flush()
        
    return cvm

def lat_fold(ii):
    walk = np.exp(-2*np.pi*1j/PP[ii]*tt)
    walk = np.sum(walk)
    walk = np.real(walk)**2+np.imag(walk)**2
    walk = 2*walk/tt.size

    if np.mod(ii, 100000) == 0:
        print(ii/PP.size)
        sys.stdout.flush()
        
    return walk

def vis_che(stat):
    dist, bins = np.histogram(stat, 1000, normed=True)
    plt.semilogy(bins[:-1], dist+dist[-1]/10)
    plt.semilogy(bins[:-1], sts.chi2.pdf(bins[:-1], 2))

    plt.show()
    pdb.set_trace()


################################################################
# Load data
wor_dir = '/Users/silver/Dropbox/phd/projects/87a/nus_tim/red/'
os.chdir(wor_dir)
dat = fits.open('nu40001014013B01_cl.evt')[1].data
times = dat['TIME']
grade = dat['GRADE']
xx = dat['X'].astype('float')
yy = dat['Y'].astype('float')
pi = dat['PI']

# Filters
reject = (grade <= 26) # Science grade
reg = [470, 530, 475, 535]
har = (pi > 135)
src = (xx >= reg[0]) & (xx < reg[1]) & (yy >= reg[2]) & (yy < reg[3])
src_cl = np.logical_and(src, reject)
src_cl = np.logical_and(src_cl, har)

# Make an image
nx = np.max(xx)-np.min(xx)+1
ny = np.max(yy)-np.min(yy)+1
sx = int(-np.min(xx))
sy = int(-np.min(yy))
img, xedges, yedges = np.histogram2d(xx[reject], yy[reject], [nx, ny])
#plt.imshow(img[reg[0]+sx:reg[1]+sx, reg[2]+sy:reg[3]+sy], interpolation='nearest', origin='low', vmax=100)
#plt.show()

########
# Prep the data
tt = times[src_cl]
tt = tt - tt[0]
sparse = 1 # For testing
PP = get_PP()
# cumulative probability
cp = np.arange(tt.size)/(tt.size-1)
xx = np.linspace(0, 1, 101)

########
# Main part
Pn = np.load('Pn.npy')
vis_che(Pn)
