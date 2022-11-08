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
data   5:5 0690510101_pn_spec_grp_pup.fits

notice all
ignore bad
ignore  1-2: **-0.45  1.95-**
ignore  3-4: **-0.70  1.95-**
ignore    1: 0.9-1.18
ignore    2: 0.52-0.62
ignore    3: 1.8-2.36
ignore    4: 1.04-1.14
ignore    5: **-0.8 10.-**

@com_v2.xcm

fit
save model com_v2_no_nus_g1
" > tmp_com_v2_no_nus.xcm

    xspec < tmp_com_v2_no_nus.xcm > log/com_v2_no_nus_g1.txt
}

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
data   5:5 ${1}_pn_spec_grp_pup.fits

notice all
ignore bad
ignore  1-2: **-0.45  1.95-**
ignore  3-4: **-0.70  1.95-**
ignore    1: 0.9-1.18
ignore    2: 0.52-0.62
ignore    3: 1.8-2.36
ignore    4: 1.04-1.14
ignore    5: **-0.8 10.-**

@com_v2.xcm

fit
save model com_v2_no_nus_${4}
" > tmp_com_v2_no_nus.xcm

    xspec < tmp_com_v2_no_nus.xcm > log/com_v2_no_nus_${4}.txt
}

cd /Users/silver/box/phd/pro/87a/nus/xsp
# rm com_v2_no_nus_g?.xcm
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8
