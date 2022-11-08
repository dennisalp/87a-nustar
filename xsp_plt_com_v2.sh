#!/bin/bash -x

# Fit the standard 2 shock components model



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha
# data 11:11 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**
# ignore   11: **-0.8 10.-**

# @co2_v2_no_err_g1.xcm
# cpd co2_v2_no_err_g1.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_err.xcm

#     xspec < tmp_co2_v2_no_err.xcm > log/co2_v2_no_err_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha
# data   9:9 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**
# ignore   9: **-0.8 10.-**

# @co2_v2_no_err_${4}.xcm
# cpd co2_v2_no_err_${4}.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_err.xcm

#     xspec < tmp_co2_v2_no_err.xcm > log/co2_v2_no_err_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore    5: **-0.8 10.-**

# @co2_v2_no_nus_g1.xcm
# cpd co2_v2_no_nus_g1.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_nus.xcm

#     xspec < tmp_co2_v2_no_nus.xcm > log/co2_v2_no_nus_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore    5: **-0.8 10.-**

# @co2_v2_no_nus_${4}.xcm
# cpd co2_v2_no_nus_${4}.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_nus.xcm

#     xspec < tmp_co2_v2_no_nus.xcm > log/co2_v2_no_nus_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**

# @co2_v2_no_pn_g1.xcm
# cpd co2_v2_no_pn_g1.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_pn.xcm

#     xspec < tmp_co2_v2_no_pn.xcm > log/co2_v2_no_pn_g1.txt
# }

# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**

# @co2_v2_no_pn_${4}.xcm
# cpd co2_v2_no_pn_${4}.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_pn.xcm

#     xspec < tmp_co2_v2_no_pn.xcm > log/co2_v2_no_pn_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data 1:1  nu40001014002A01_bc_sr_grp.pha
# data 2:2  nu40001014002B01_bc_sr_grp.pha
# data 3:3  nu40001014003A01_bc_sr_grp.pha
# data 4:4  nu40001014003B01_bc_sr_grp.pha
# data 5:5  nu40001014004A01_bc_sr_grp.pha
# data 6:6  nu40001014004B01_bc_sr_grp.pha
# data 7:7  0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore 1-6: **-3. 24.-**
# ignore   7: **-0.8 10.-**

# @co2_v2_no_rgs_g1.xcm
# cpd co2_v2_no_rgs_g1.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_rgs.xcm

#     xspec < tmp_co2_v2_no_rgs.xcm > log/co2_v2_no_rgs_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 nu${2}A01_bc_sr_grp.pha
# data   2:2 nu${2}B01_bc_sr_grp.pha
# data   3:3 nu${3}A01_bc_sr_grp.pha
# data   4:4 nu${3}B01_bc_sr_grp.pha
# data   5:5 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore 1-4: **-3. 24.-**
# ignore   5: **-0.8 10.-**

# @co2_v2_no_rgs_${4}.xcm
# cpd co2_v2_no_rgs_${4}.ps/cps
# pl lda del rat
# " > tmp_co2_v2_no_rgs.xcm

#     xspec < tmp_co2_v2_no_rgs.xcm > log/co2_v2_no_rgs_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha
# data 11:11 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**
# ignore   11: **-0.8 10.-**

# @com_v2_0p88_g1.xcm
# cpd com_v2_0p88_g1.ps/cps
# pl lda del rat

# " > tmp_com_v2_0p88.xcm

#     xspec < tmp_com_v2_0p88.xcm > log/com_v2_0p88_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha
# data   9:9 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**
# ignore   9: **-0.8 10.-**

# @com_v2_0p88_${4}.xcm
# cpd com_v2_0p88_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_0p88.xcm

#     xspec < tmp_com_v2_0p88.xcm > log/com_v2_0p88_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8

# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha
# data 11:11 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**
# ignore   11: **-0.8 10.-**

# @com_v2_0p8b_g1.xcm
# cpd com_v2_0p8b_g1.ps/cps
# pl lda del rat

# " > tmp_com_v2_0p8b.xcm

#     xspec < tmp_com_v2_0p8b.xcm > log/com_v2_0p8b_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha
# data   9:9 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**
# ignore   9: **-0.8 10.-**

# @com_v2_0p8b_${4}.xcm
# cpd com_v2_0p8b_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_0p8b.xcm

#     xspec < tmp_com_v2_0p8b.xcm > log/com_v2_0p8b_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha
# data 11:11 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**
# ignore   11: **-0.8 10.-**

# @com_v2_no_err_g1.xcm
# cpd com_v2_no_err_g1.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_err.xcm

#     xspec < tmp_com_v2_no_err.xcm > log/com_v2_no_err_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha
# data   9:9 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**
# ignore   9: **-0.8 10.-**

# @com_v2_no_err_${4}.xcm
# cpd com_v2_no_err_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_err.xcm

#     xspec < tmp_com_v2_no_err.xcm > log/com_v2_no_err_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore    5: **-0.8 10.-**

# @com_v2_no_nus_g1.xcm
# cpd com_v2_no_nus_g1.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_nus.xcm

#     xspec < tmp_com_v2_no_nus.xcm > log/com_v2_no_nus_g1.txt
# }

# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore    5: **-0.8 10.-**

# @com_v2_no_nus_${4}.xcm
# cpd com_v2_no_nus_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_nus.xcm

#     xspec < tmp_com_v2_no_nus.xcm > log/com_v2_no_nus_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**

# @com_v2_no_pn_g1.xcm
# cpd com_v2_no_pn_g1.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_pn.xcm

#     xspec < tmp_com_v2_no_pn.xcm > log/com_v2_no_pn_g1.txt
# }

# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**

# @com_v2_no_pn_${4}.xcm
# cpd com_v2_no_pn_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_pn.xcm

#     xspec < tmp_com_v2_no_pn.xcm > log/com_v2_no_pn_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data 1:1  nu40001014002A01_bc_sr_grp.pha
# data 2:2  nu40001014002B01_bc_sr_grp.pha
# data 3:3  nu40001014003A01_bc_sr_grp.pha
# data 4:4  nu40001014003B01_bc_sr_grp.pha
# data 5:5  nu40001014004A01_bc_sr_grp.pha
# data 6:6  nu40001014004B01_bc_sr_grp.pha
# data 7:7  0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore 1-6: **-3. 24.-**
# ignore   7: **-0.8 10.-**

# @com_v2_no_rgs_g1.xcm
# cpd com_v2_no_rgs_g1.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_rgs.xcm

#     xspec < tmp_com_v2_no_rgs.xcm > log/com_v2_no_rgs_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 nu${2}A01_bc_sr_grp.pha
# data   2:2 nu${2}B01_bc_sr_grp.pha
# data   3:3 nu${3}A01_bc_sr_grp.pha
# data   4:4 nu${3}B01_bc_sr_grp.pha
# data   5:5 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore 1-4: **-3. 24.-**
# ignore   5: **-0.8 10.-**

# @com_v2_no_rgs_${4}.xcm
# cpd com_v2_no_rgs_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_no_rgs.xcm

#     xspec < tmp_com_v2_no_rgs.xcm > log/com_v2_no_rgs_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha
# data 11:11 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**
# ignore   11: **-0.8 10.-**

# @com_v2_untie_t+em_g1.xcm
# cpd com_v2_untie_t+em_g1.ps/cps
# pl lda del rat

# " > tmp_com_v2_untie_t+em.xcm

#     xspec < tmp_com_v2_untie_t+em.xcm > log/com_v2_untie_t+em_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha
# data   9:9 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**
# ignore   9: **-0.8 10.-**

# @com_v2_untie_t+em_${4}.xcm
# cpd com_v2_untie_t+em_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_untie_t+em.xcm

#     xspec < tmp_com_v2_untie_t+em.xcm > log/com_v2_untie_t+em_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8



# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha
# data 11:11 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**
# ignore   11: **-0.8 10.-**

# @com_v2_untie_t_g1.xcm
# cpd com_v2_untie_t_g1.ps/cps
# pl lda del rat

# " > tmp_com_v2_untie_t.xcm

#     xspec < tmp_com_v2_untie_t.xcm > log/com_v2_untie_t_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha
# data   9:9 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**
# ignore   9: **-0.8 10.-**

# @com_v2_untie_t_${4}.xcm
# cpd com_v2_untie_t_${4}.ps/cps
# pl lda del rat
# " > tmp_com_v2_untie_t.xcm

#     xspec < tmp_com_v2_untie_t.xcm > log/com_v2_untie_t_${4}.txt
# }

# cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8


# com_g1 () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 0690510101_r1o1_grp.fits
# data   2:2 0690510101_r2o1_grp.fits
# data   3:3 0690510101_r1o2_grp.fits
# data   4:4 0690510101_r2o2_grp.fits
# data   5:5 nu40001014002A01_bc_sr_grp.pha
# data   6:6 nu40001014002B01_bc_sr_grp.pha
# data   7:7 nu40001014003A01_bc_sr_grp.pha
# data   8:8 nu40001014003B01_bc_sr_grp.pha
# data   9:9 nu40001014004A01_bc_sr_grp.pha
# data 10:10 nu40001014004B01_bc_sr_grp.pha
# data 11:11 0690510101_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-10: **-3. 24.-**
# ignore   11: **-0.8 10.-**

# @dos_em10_013_pl0_g1.xcm
# cpd dos_em10_013_pl0_g1.ps/cps
# pl lda del rat

# " > tmp_plt_dos_em10_013_pl0_g1.xcm

#     xspec < tmp_plt_dos_em10_013_pl0_g1.xcm > log/plt_dos_em10_013_pl0_g1.txt
# }


# com_gg () {
#     printf "
# abund wilm
# setpl ene
# query yes
# parallel error 3

# data   1:1 ${1}_r1o1_grp.fits
# data   2:2 ${1}_r2o1_grp.fits
# data   3:3 ${1}_r1o2_grp.fits
# data   4:4 ${1}_r2o2_grp.fits
# data   5:5 nu${2}A01_bc_sr_grp.pha
# data   6:6 nu${2}B01_bc_sr_grp.pha
# data   7:7 nu${3}A01_bc_sr_grp.pha
# data   8:8 nu${3}B01_bc_sr_grp.pha
# data   9:9 ${1}_pn_spec_grp_pup.fits

# notice all
# ignore bad
# ignore  1-2: **-0.45  1.95-**
# ignore  3-4: **-0.70  1.95-**
# ignore    1: 0.9-1.18
# ignore    2: 0.52-0.62
# ignore    3: 1.8-2.36
# ignore    4: 1.04-1.14
# ignore 5-8: **-3. 24.-**
# ignore   9: **-0.8 10.-**

# @dos_em10_013_pl0_${4}.xcm
# cpd dos_em10_013_pl0_${4}.ps/cps
# pl lda del rat
# " > tmp_plt_dos_em10_013_pl0_${4}.xcm

#     xspec < tmp_plt_dos_em10_013_pl0_${4}.xcm > log/plt_dos_em10_013_pl0_${4}.txt
# }

cd /Users/silver/box/phd/pro/87a/nus/xsp
# com_g1
# com_gg 0690510101 40001014006 40001014007 g2
# com_gg 0690510101 40001014009 40001014010 g3
# com_gg 0690510101 40001014012 40001014013 g4
# com_gg 0743790101 40001014015 40001014016 g5
# com_gg 0743790101 40001014018 40001014020 g6
# com_gg 0743790101 40001014022 40001014023 g7
# com_gg 0831810101 40501004002 40501004004 g8


mv *.ps plt/
cd plt/
for ff in *.ps
do
    ps2pdf ${ff}
done
rm *.ps
