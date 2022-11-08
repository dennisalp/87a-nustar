#!/bin/bash -x

dos_gg () {
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

@dos_em10_013_pl0_${4}.xcm

fit

error 1-10

save model ${dos}_${4}
" > tmp_${dos}.xcm

    xspec < tmp_${dos}.xcm > log/${dos}_${4}.txt
}

dos=dos_v2_${1}
echo ${dos}
cd /Users/silver/box/phd/pro/87a/nus/xsp
dos_gg 0690510101 40001014009 40001014010 g3
