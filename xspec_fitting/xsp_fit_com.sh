#!/bin/bash -x

# Fit the standard 3 shock components model

com_g1 () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data   1:1 0690510101_r1o1_grp.fits
data   2:2 0690510101_r2o1_grp.fits
data   3:3 0690510101_r1o2_grp.fits
data   4:4 0690510101_r2o2_grp.fits
data   5:5 nu40001014002A01_bc_sr_grp.pha
data   6:6 nu40001014002B01_bc_sr_grp.pha
data   7:7 nu40001014003A01_bc_sr_grp.pha
data   8:8 nu40001014003B01_bc_sr_grp.pha
data   9:9 nu40001014004A01_bc_sr_grp.pha
data 10:10 nu40001014004B01_bc_sr_grp.pha

notice all
ignore bad
ignore  1-2: **-0.45  1.95-**
ignore  3-4: **-0.70  1.95-**
ignore    1: 0.9-1.18
ignore    2: 0.52-0.62
ignore    3: 1.8-2.36
ignore    4: 1.04-1.14
ignore 5-10: **-3. 24.-**

@com.xcm

fit
save model com_g1
error 5 20 22 26 41 43 47 62 64

tclout param 5
echo g1 temp1 param \$xspec_tclout
tclout param 20
echo g1 tau1 param \$xspec_tclout
tclout param 22
echo g1 em1 param \$xspec_tclout
tclout param 26
echo g1 temp2 param \$xspec_tclout
tclout param 41
echo g1 tau2 param \$xspec_tclout
tclout param 43
echo g1 em2 param \$xspec_tclout
tclout param 47
echo g1 temp3 param \$xspec_tclout
tclout param 62
echo g1 tau3 param \$xspec_tclout
tclout param 64
echo g1 em3 param \$xspec_tclout

tclout error 5
echo g1 temp1 error \$xspec_tclout
tclout error 20
echo g1 tau1 error \$xspec_tclout
tclout error 22
echo g1 em1 error \$xspec_tclout
tclout error 26
echo g1 temp2 error \$xspec_tclout
tclout error 41
echo g1 tau2 error \$xspec_tclout
tclout error 43
echo g1 em2 error \$xspec_tclout
tclout error 47
echo g1 temp3 error \$xspec_tclout
tclout error 62
echo g1 tau3 error \$xspec_tclout
tclout error 64
echo g1 em3 error \$xspec_tclout

energies 0.01 20 10000 log
editmo con(cflux(tba(gsm(vps)))+tba(gsm(vps))+tba(gsm(vps)))
0.01
20
-11.43



























editmo con(cflux(tba(gsm(vps)))+cflux(tba(gsm(vps)))+tba(gsm(vps)))
0.01
20
-11.43



























editmo con(cflux(tba(gsm(vps)))+cflux(tba(gsm(vps)))+cflux(tba(gsm(vps))))
0.01
20
-11.54



























freeze 25 49 73
freeze 8 23 32 47 56 71 74 147 220 293 366 439 512 585 658
fit
thaw 8 23 32 47 56 71 74 147 220 293 366 439 512 585 658
fit
error 4 28 52 74 147 220 293 366 439 512 585 658

tclout param 4 
echo g1 flx1 0 param \$xspec_tclout
tclout param 28 
echo g1 flx2 0 param \$xspec_tclout
tclout param 52 
echo g1 flx3 0 param \$xspec_tclout
tclout param 74 
echo g1 flx0 1 param \$xspec_tclout
tclout param 147 
echo g1 flx0 2 param \$xspec_tclout
tclout param 220 
echo g1 flx0 3 param \$xspec_tclout
tclout param 293 
echo g1 flx0 4 param \$xspec_tclout
tclout param 366 
echo g1 flx0 5 param \$xspec_tclout
tclout param 439 
echo g1 flx0 6 param \$xspec_tclout
tclout param 512 
echo g1 flx0 7 param \$xspec_tclout
tclout param 585 
echo g1 flx0 8 param \$xspec_tclout
tclout param 658 
echo g1 flx0 9 param \$xspec_tclout

tclout error 4 
echo g1 flx1 0 error \$xspec_tclout
tclout error 28 
echo g1 flx2 0 error \$xspec_tclout
tclout error 52 
echo g1 flx3 0 error \$xspec_tclout
tclout error 74 
echo g1 flx0 1 error \$xspec_tclout
tclout error 147 
echo g1 flx0 2 error \$xspec_tclout
tclout error 220 
echo g1 flx0 3 error \$xspec_tclout
tclout error 293 
echo g1 flx0 4 error \$xspec_tclout
tclout error 366 
echo g1 flx0 5 error \$xspec_tclout
tclout error 439 
echo g1 flx0 6 error \$xspec_tclout
tclout error 512 
echo g1 flx0 7 error \$xspec_tclout
tclout error 585 
echo g1 flx0 8 error \$xspec_tclout
tclout error 658 
echo g1 flx0 9 error \$xspec_tclout
" > tmp_com.xcm

    xspec < tmp_com.xcm > log/com_g1.txt
}

# aa=['4', '28', '52', '74', '147', '220', '293', '366', '439', '512', '585', '658']
# for i,a in enumerate(aa): j=np.mod(i, 3)+1; d=np.max((i-2,0)); print('tclout param', a, '\necho g1 flx{0:d} {1:d} param \$xspec_tclout'.format(j,d))
# for i,a in enumerate(aa): j=np.mod(i, 3)+1; d=np.max((i-2,0)); print('tclout error', a, '\necho g1 flx{0:d} {1:d} error \$xspec_tclout'.format(j,d))

com_gg () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data   1:1 ${1}_r1o1_grp.fits
data   2:2 ${1}_r2o1_grp.fits
data   3:3 ${1}_r1o2_grp.fits
data   4:4 ${1}_r2o2_grp.fits
data   5:5 nu${2}A01_bc_sr_grp.pha
data   6:6 nu${2}B01_bc_sr_grp.pha
data   7:7 nu${3}A01_bc_sr_grp.pha
data   8:8 nu${3}B01_bc_sr_grp.pha

notice all
ignore bad
ignore  1-2: **-0.45  1.95-**
ignore  3-4: **-0.70  1.95-**
ignore    1: 0.9-1.18
ignore    2: 0.52-0.62
ignore    3: 1.8-2.36
ignore    4: 1.04-1.14
ignore 5-8: **-3. 24.-**

@com.xcm

fit
save model com_${4}
error 5 20 22 26 41 43 47 62 64

tclout param 5
echo ${4} temp1 param \$xspec_tclout
tclout param 20
echo ${4} tau1 param \$xspec_tclout
tclout param 22
echo ${4} em1 param \$xspec_tclout
tclout param 26
echo ${4} temp2 param \$xspec_tclout
tclout param 41
echo ${4} tau2 param \$xspec_tclout
tclout param 43
echo ${4} em2 param \$xspec_tclout
tclout param 47
echo ${4} temp3 param \$xspec_tclout
tclout param 62
echo ${4} tau3 param \$xspec_tclout
tclout param 64
echo ${4} em3 param \$xspec_tclout

tclout error 5
echo ${4} temp1 error \$xspec_tclout
tclout error 20
echo ${4} tau1 error \$xspec_tclout
tclout error 22
echo ${4} em1 error \$xspec_tclout
tclout error 26
echo ${4} temp2 error \$xspec_tclout
tclout error 41
echo ${4} tau2 error \$xspec_tclout
tclout error 43
echo ${4} em2 error \$xspec_tclout
tclout error 47
echo ${4} temp3 error \$xspec_tclout
tclout error 62
echo ${4} tau3 error \$xspec_tclout
tclout error 64
echo ${4} em3 error \$xspec_tclout

energies 0.01 20 10000 log
editmo con(cflux(tba(gsm(vps)))+tba(gsm(vps))+tba(gsm(vps)))
0.01
20
-11.43





















editmo con(cflux(tba(gsm(vps)))+cflux(tba(gsm(vps)))+tba(gsm(vps)))
0.01
20
-11.43





















editmo con(cflux(tba(gsm(vps)))+cflux(tba(gsm(vps)))+cflux(tba(gsm(vps))))
0.01
20
-11.54





















freeze 25 49 73
freeze 8 23 32 47 56 71 74 147 220 293 366 439 512
fit
thaw 8 23 32 47 56 71 74 147 220 293 366 439 512
fit
error 4 28 52 74 147 220 293 366 439 512

tclout param 4 
echo ${4} flx1 0 param \$xspec_tclout
tclout param 28 
echo ${4} flx2 0 param \$xspec_tclout
tclout param 52 
echo ${4} flx3 0 param \$xspec_tclout
tclout param 74 
echo ${4} flx0 1 param \$xspec_tclout
tclout param 147 
echo ${4} flx0 2 param \$xspec_tclout
tclout param 220 
echo ${4} flx0 3 param \$xspec_tclout
tclout param 293 
echo ${4} flx0 4 param \$xspec_tclout
tclout param 366 
echo ${4} flx0 5 param \$xspec_tclout
tclout param 439 
echo ${4} flx0 6 param \$xspec_tclout
tclout param 512 
echo ${4} flx0 7 param \$xspec_tclout

tclout error 4 
echo ${4} flx1 0 error \$xspec_tclout
tclout error 28 
echo ${4} flx2 0 error \$xspec_tclout
tclout error 52 
echo ${4} flx3 0 error \$xspec_tclout
tclout error 74 
echo ${4} flx0 1 error \$xspec_tclout
tclout error 147 
echo ${4} flx0 2 error \$xspec_tclout
tclout error 220 
echo ${4} flx0 3 error \$xspec_tclout
tclout error 293 
echo ${4} flx0 4 error \$xspec_tclout
tclout error 366 
echo ${4} flx0 5 error \$xspec_tclout
tclout error 439 
echo ${4} flx0 6 error \$xspec_tclout
tclout error 512 
echo ${4} flx0 7 error \$xspec_tclout
" > tmp_com.xcm

    xspec < tmp_com.xcm > log/com_${4}.txt
}

cd /Users/silver/box/phd/pro/87a/nus/xsp
# rm com_g?.xcm
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0804980201 40501004002 40501004004 g8
com_gg 0831810101 40501004002 40501004004 g8
