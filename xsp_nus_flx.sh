#!/bin/bash -x



get_flx_g1 () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data 1:1 nu40001014002A01_bc_sr_grp.pha
data 2:2 nu40001014002B01_bc_sr_grp.pha
data 3:3 nu40001014003A01_bc_sr_grp.pha
data 4:4 nu40001014003B01_bc_sr_grp.pha
data 5:5 nu40001014004A01_bc_sr_grp.pha
data 6:6 nu40001014004B01_bc_sr_grp.pha

notice all
ignore bad
ignore 1-6: **-3. 24.00-**

@flx_nus_x1.xcm

fit


################################################################


editmo cflux(tba(gsm(vps+vps+vps)))
3.
8.
-12


-12


-12


-12


-12


-12
freeze 42 60

fit
error 3 63 123 183 243 303

tclout param 3
echo g1 myflux soft param 40001014002A01 \$xspec_tclout
tclout param 63
echo g1 myflux soft param 40001014002B01 \$xspec_tclout
tclout param 123
echo g1 myflux soft param 40001014003A01 \$xspec_tclout
tclout param 183
echo g1 myflux soft param 40001014003B01 \$xspec_tclout
tclout param 243
echo g1 myflux soft param 40001014004A01 \$xspec_tclout
tclout param 303
echo g1 myflux soft param 40001014004B01 \$xspec_tclout

tclout error 3
echo g1 myflux soft error 40001014002A01 \$xspec_tclout
tclout error 63
echo g1 myflux soft error 40001014002B01 \$xspec_tclout
tclout error 123
echo g1 myflux soft error 40001014003A01 \$xspec_tclout
tclout error 183
echo g1 myflux soft error 40001014003B01 \$xspec_tclout
tclout error 243
echo g1 myflux soft error 40001014004A01 \$xspec_tclout
tclout error 303
echo g1 myflux soft error 40001014004B01 \$xspec_tclout


################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
3.
24.
-11.9


-11.9


-11.9


-11.9


-11.9


-11.9
fit
error 3 63 123 183 243 303

tclout param 3
echo g1 myflux full param 40001014002A01 \$xspec_tclout
tclout param 63
echo g1 myflux full param 40001014002B01 \$xspec_tclout
tclout param 123
echo g1 myflux full param 40001014003A01 \$xspec_tclout
tclout param 183
echo g1 myflux full param 40001014003B01 \$xspec_tclout
tclout param 243
echo g1 myflux full param 40001014004A01 \$xspec_tclout
tclout param 303
echo g1 myflux full param 40001014004B01 \$xspec_tclout

tclout error 3
echo g1 myflux full error 40001014002A01 \$xspec_tclout
tclout error 63
echo g1 myflux full error 40001014002B01 \$xspec_tclout
tclout error 123
echo g1 myflux full error 40001014003A01 \$xspec_tclout
tclout error 183
echo g1 myflux full error 40001014003B01 \$xspec_tclout
tclout error 243
echo g1 myflux full error 40001014004A01 \$xspec_tclout
tclout error 303
echo g1 myflux full error 40001014004B01 \$xspec_tclout


################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
10.
24.
-12.75


-12.75


-12.75


-12.75


-12.75


-12.75
fit
error 3 63 123 183 243 303

tclout param 3
echo g1 myflux hard param 40001014002A01 \$xspec_tclout
tclout param 63
echo g1 myflux hard param 40001014002B01 \$xspec_tclout
tclout param 123
echo g1 myflux hard param 40001014003A01 \$xspec_tclout
tclout param 183
echo g1 myflux hard param 40001014003B01 \$xspec_tclout
tclout param 243
echo g1 myflux hard param 40001014004A01 \$xspec_tclout
tclout param 303
echo g1 myflux hard param 40001014004B01 \$xspec_tclout

tclout error 3
echo g1 myflux hard error 40001014002A01 \$xspec_tclout
tclout error 63
echo g1 myflux hard error 40001014002B01 \$xspec_tclout
tclout error 123
echo g1 myflux hard error 40001014003A01 \$xspec_tclout
tclout error 183
echo g1 myflux hard error 40001014003B01 \$xspec_tclout
tclout error 243
echo g1 myflux hard error 40001014004A01 \$xspec_tclout
tclout error 303
echo g1 myflux hard error 40001014004B01 \$xspec_tclout
" > tmp_nus.xcm

    xspec < tmp_nus.xcm > log/g1_flx.txt

}

get_flx () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data 1:1 nu${2}A01_bc_sr_grp.pha
data 2:2 nu${2}B01_bc_sr_grp.pha
data 3:3 nu${3}A01_bc_sr_grp.pha
data 4:4 nu${3}B01_bc_sr_grp.pha

notice all
ignore bad
ignore 1-4: **-3. 24.00-**

@flx_nus_${4}.xcm

fit


################################################################


editmo cflux(tba(gsm(vps+vps+vps)))
3.
8.
-12


-12


-12


-12
freeze 42 60

fit
error 3 63 123 183

tclout param 3
echo ${1} myflux soft param ${2}A01 \$xspec_tclout
tclout param 63
echo ${1} myflux soft param ${2}B01 \$xspec_tclout
tclout param 123
echo ${1} myflux soft param ${3}A01 \$xspec_tclout
tclout param 183
echo ${1} myflux soft param ${3}B01 \$xspec_tclout

tclout error 3
echo ${1} myflux soft error ${2}A01 \$xspec_tclout
tclout error 63
echo ${1} myflux soft error ${2}B01 \$xspec_tclout
tclout error 123
echo ${1} myflux soft error ${3}A01 \$xspec_tclout
tclout error 183
echo ${1} myflux soft error ${3}B01 \$xspec_tclout


################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
10.
24.
-12.75


-12.75


-12.75


-12.75
fit
error 3 63 123 183

tclout param 3
echo ${1} myflux hard param ${2}A01 \$xspec_tclout
tclout param 63
echo ${1} myflux hard param ${2}B01 \$xspec_tclout
tclout param 123
echo ${1} myflux hard param ${3}A01 \$xspec_tclout
tclout param 183
echo ${1} myflux hard param ${3}B01 \$xspec_tclout

tclout error 3
echo ${1} myflux hard error ${2}A01 \$xspec_tclout
tclout error 63
echo ${1} myflux hard error ${2}B01 \$xspec_tclout
tclout error 123
echo ${1} myflux hard error ${3}A01 \$xspec_tclout
tclout error 183
echo ${1} myflux hard error ${3}B01 \$xspec_tclout


################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
3.
24.
-11.9


-11.9


-11.9


-11.9
fit
error 3 63 123 183

tclout param 3
echo ${1} myflux full param ${2}A01 \$xspec_tclout
tclout param 63
echo ${1} myflux full param ${2}B01 \$xspec_tclout
tclout param 123
echo ${1} myflux full param ${3}A01 \$xspec_tclout
tclout param 183
echo ${1} myflux full param ${3}B01 \$xspec_tclout

tclout error 3
echo ${1} myflux full error ${2}A01 \$xspec_tclout
tclout error 63
echo ${1} myflux full error ${2}B01 \$xspec_tclout
tclout error 123
echo ${1} myflux full error ${3}A01 \$xspec_tclout
tclout error 183
echo ${1} myflux full error ${3}B01 \$xspec_tclout
" > tmp_nus.xcm

    xspec < tmp_nus.xcm > log/${1}_flx.txt

}

cd /Users/silver/box/phd/pro/87a/nus/xsp
# get_flx_g1
# get_flx g2 40001014006 40001014007 x1
# get_flx g3 40001014009 40001014010 x1
# get_flx g4 40001014012 40001014013 x1
# get_flx g5 40001014015 40001014016 x2
# get_flx g6 40001014018 40001014020 x2
# get_flx g7 40001014022 40001014023 x2
get_flx g8 40501004002 40501004004 x3
