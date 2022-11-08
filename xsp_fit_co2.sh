#!/bin/bash -x

# Fit the standard 3 shock components model

co2_g1 () {
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

@flx_xmm.xcm

untie 291
untie 349
untie 407
untie 465
untie 523
thaw 291
thaw 349
thaw 407
thaw 465
thaw 523

editmo con(tba(gsmo(vps+vps)))
fit
save model co2_g1
" > tmp_co2.xcm

    xspec < tmp_co2.xcm > log/co2_g1.txt
}

co2_gg () {
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
ignore 1-2: **-0.45  1.95-**
ignore 3-4: **-0.70  1.95-**
ignore   1: 0.9-1.18
ignore   2: 0.52-0.62
ignore   3: 1.8-2.36
ignore   4: 1.04-1.14
ignore 5-8: **-3. 24.-**

@flx_xmm.xcm

untie 291
untie 349
untie 407
thaw 291
thaw 349
thaw 407

editmo con(tba(gsmo(vps+vps)))
fit
save model co2_${4}
" > tmp_co2.xcm

    xspec < tmp_co2.xcm > log/co2_${4}.txt
}

cd /Users/silver/box/phd/pro/87a/nus/xsp
# co2_g1
# co2_gg 0690510101 40001014006 40001014007 g2
# co2_gg 0690510101 40001014009 40001014010 g3
# co2_gg 0690510101 40001014012 40001014013 g4
# co2_gg 0743790101 40001014015 40001014016 g5
# co2_gg 0743790101 40001014018 40001014020 g6
# co2_gg 0743790101 40001014022 40001014023 g7
# co2_gg 0804980201 40501004002 40501004004 g8
co2_gg 0831810101 40501004002 40501004004 g8
