#!/bin/bash -x



get_var () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data   1:1 nu40001014002A01_bc_sr_grp.pha
data   2:2 nu40001014002B01_bc_sr_grp.pha
data   3:3 nu40001014003A01_bc_sr_grp.pha
data   4:4 nu40001014003B01_bc_sr_grp.pha
data   5:5 nu40001014004A01_bc_sr_grp.pha
data   6:6 nu40001014004B01_bc_sr_grp.pha
data   7:7 nu40001014006A01_bc_sr_grp.pha
data   8:8 nu40001014006B01_bc_sr_grp.pha
data   9:9 nu40001014007A01_bc_sr_grp.pha
data 10:10 nu40001014007B01_bc_sr_grp.pha
data 11:11 nu40001014009A01_bc_sr_grp.pha
data 12:12 nu40001014009B01_bc_sr_grp.pha
data 13:13 nu40001014010A01_bc_sr_grp.pha
data 14:14 nu40001014010B01_bc_sr_grp.pha

notice all
ignore bad
ignore 1-14: **-3. 8.-**

@var_nus.xcm

fit
free 7 22 24 25 40 42 43 58
fit
error 3 63 123 183 243 303 363 423 483 543 603 663 723 783



model clear
data none
data   1:1 nu40001014015A01_bc_sr_grp.pha
data   2:2 nu40001014015B01_bc_sr_grp.pha
data   3:3 nu40001014016A01_bc_sr_grp.pha
data   4:4 nu40001014016B01_bc_sr_grp.pha
data   5:5 nu40001014018A01_bc_sr_grp.pha
data   6:6 nu40001014018B01_bc_sr_grp.pha
data   7:7 nu40001014020A01_bc_sr_grp.pha
data   8:8 nu40001014020B01_bc_sr_grp.pha
data   9:9 nu40001014022A01_bc_sr_grp.pha
data 10:10 nu40001014022B01_bc_sr_grp.pha
data 11:11 nu40001014023A01_bc_sr_grp.pha
data 12:12 nu40001014023B01_bc_sr_grp.pha

notice all
ignore bad
ignore 1-12: **-3. 8.-**

@var_nus.xcm

fit
free 7 22 24 25 40 42 43 58
fit
error 3 63 123 183 243 303 363 423 483 543 603 663

" > tmp_var.xcm

    xspec < tmp_var.xcm > log/var_flx.txt

}


cd /Users/silver/box/phd/pro/87a/nus/xsp
get_var
