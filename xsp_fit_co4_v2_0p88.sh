#!/bin/bash -x

# Fit the standard 3 shock components model, with temperatures XMM=0.88*NuSTAR

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
data 11:11 0690510101_pn_spec_grp_pup.fits

notice all
ignore bad
ignore  1-2: **-0.45  1.95-**
ignore  3-4: **-0.70  1.95-**
ignore    1: 0.9-1.18
ignore    2: 0.52-0.62
ignore    3: 1.8-2.36
ignore    4: 1.04-1.14
ignore 5-10: **-3. 24.-**
ignore   11: **-0.8 10.-**

@com_v2_0p88_g1
editmo con(tba(gsm(vps))+tba(gsm(vps))+tba(gsm(vps+vps)))
6
1.00000
2.55820
0.133400
2.65295
0.373040    
0.761212    
0.761994    
1.02986     
0.847071    
0.660700    
0.489800    
0.389731    
0.977200    


8.81197E-04 
1e-4
/*

fit
save model co4_v2_0p88_g1
" > tmp_co4_v2_0p88.xcm

    xspec < tmp_co4_v2_0p88.xcm > log/co4_v2_0p88_g1.txt
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
data   9:9 ${1}_pn_spec_grp_pup.fits

notice all
ignore bad
ignore  1-2: **-0.45  1.95-**
ignore  3-4: **-0.70  1.95-**
ignore    1: 0.9-1.18
ignore    2: 0.52-0.62
ignore    3: 1.8-2.36
ignore    4: 1.04-1.14
ignore 5-8: **-3. 24.-**
ignore   9: **-0.8 10.-**

@com_v2_0p88_${4}
editmo con(tba(gsm(vps))+tba(gsm(vps))+tba(gsm(vps+vps)))
6
1.00000
2.55820
0.133400
2.65295
0.373040    
0.761212    
0.761994    
1.02986     
0.847071    
0.660700    
0.489800    
0.389731    
0.977200    


8.81197E-04 
1e-4
/*

fit
save model co4_v2_0p88_${4}
" > tmp_co4_v2_0p88.xcm

    xspec < tmp_co4_v2_0p88.xcm > log/co4_v2_0p88_${4}.txt
}

cd /Users/silver/box/phd/pro/87a/nus/xsp
rm co4_v2_0p88_g?.xcm
com_g1
com_gg 0690510101 40001014006 40001014007 g2
com_gg 0690510101 40001014009 40001014010 g3
com_gg 0690510101 40001014012 40001014013 g4
com_gg 0743790101 40001014015 40001014016 g5
com_gg 0743790101 40001014018 40001014020 g6
com_gg 0743790101 40001014022 40001014023 g7
com_gg 0831810101 40501004002 40501004004 g8
