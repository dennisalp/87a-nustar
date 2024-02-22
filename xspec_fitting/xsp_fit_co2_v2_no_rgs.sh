#!/bin/bash -x

# Fit the standard 2 shock components model

com_g1 () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data 1:1  nu40001014002A01_bc_sr_grp.pha
data 2:2  nu40001014002B01_bc_sr_grp.pha
data 3:3  nu40001014003A01_bc_sr_grp.pha
data 4:4  nu40001014003B01_bc_sr_grp.pha
data 5:5  nu40001014004A01_bc_sr_grp.pha
data 6:6  nu40001014004B01_bc_sr_grp.pha
data 7:7  0690510101_pn_spec_grp_pup.fits

notice all
ignore bad
ignore 1-6: **-3. 24.-**
ignore   7: **-0.8 10.-**

@co2_v2.xcm

fit
save model co2_v2_no_rgs_g1
" > tmp_co2_v2_no_rgs.xcm

    xspec < tmp_co2_v2_no_rgs.xcm > log/co2_v2_no_rgs_g1.txt
}


com_gg () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data   1:1 nu${2}A01_bc_sr_grp.pha
data   2:2 nu${2}B01_bc_sr_grp.pha
data   3:3 nu${3}A01_bc_sr_grp.pha
data   4:4 nu${3}B01_bc_sr_grp.pha
data   5:5 ${1}_pn_spec_grp_pup.fits

notice all
ignore bad
ignore 1-4: **-3. 24.-**
ignore   5: **-0.8 10.-**

@co2_v2.xcm

fit
save model co2_v2_no_rgs_${4}
" > tmp_co2_v2_no_rgs.xcm

    xspec < tmp_co2_v2_no_rgs.xcm > log/co2_v2_no_rgs_${4}.txt
}

cd /Users/silver/box/phd/pro/87a/nus/xsp
# rm co2_v2_no_rgs_g?.xcm
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8
