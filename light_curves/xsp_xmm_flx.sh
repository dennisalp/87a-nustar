#!/bin/bash

cd /Users/silver/box/phd/pro/87a/nus/xsp


get_flx () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3

data 1:1 ${1}_r1o1_grp.fits
data 2:2 ${1}_r2o1_grp.fits
data 3:3 ${1}_r1o2_grp.fits
data 4:4 ${1}_r2o2_grp.fits
data 5:5 ${1}_pn_spec_grp_pup.fits

notice all
ignore bad
ignore 1-2: **-0.45  1.95-**
ignore 3-4: **-0.70  1.95-**
ignore 5: **-0.80 10.00-**
ignore 1: 0.9-1.18
ignore 2: 0.52-0.62
ignore 3: 1.8-2.36
ignore 4: 1.04-1.14

@flx_xmm.xcm

fit
save model flx_${1}

################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
0.5
2.
-11.15


-11.15


-11.15


-11.15


-11.15
freeze 24 42 60

fit
error 3 63 123 183 243

tclout param 3
echo ${1} myflux soft param r1o1 \$xspec_tclout
tclout param 63
echo ${1} myflux soft param r2o1 \$xspec_tclout
tclout param 123
echo ${1} myflux soft param r1o2 \$xspec_tclout
tclout param 183
echo ${1} myflux soft param r2o2 \$xspec_tclout
tclout param 243
echo ${1} myflux soft param pn \$xspec_tclout

tclout error 3
echo ${1} myflux soft error r1o1 \$xspec_tclout
tclout error 63
echo ${1} myflux soft error r2o1 \$xspec_tclout
tclout error 123
echo ${1} myflux soft error r1o2 \$xspec_tclout
tclout error 183
echo ${1} myflux soft error r2o2 \$xspec_tclout
tclout error 243
echo ${1} myflux soft error pn \$xspec_tclout


################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
0.45
0.70
-12


-12


-12


-12


-12
freeze 24 42 60

fit
error 3 63 123 183 243

tclout param 3
echo ${1} myflux esft param r1o1 \$xspec_tclout
tclout param 63
echo ${1} myflux esft param r2o1 \$xspec_tclout
tclout param 123
echo ${1} myflux esft param r1o2 \$xspec_tclout
tclout param 183
echo ${1} myflux esft param r2o2 \$xspec_tclout
tclout param 243
echo ${1} myflux esft param pn \$xspec_tclout

tclout error 3
echo ${1} myflux esft error r1o1 \$xspec_tclout
tclout error 63
echo ${1} myflux esft error r2o1 \$xspec_tclout
tclout error 123
echo ${1} myflux esft error r1o2 \$xspec_tclout
tclout error 183
echo ${1} myflux esft error r2o2 \$xspec_tclout
tclout error 243
echo ${1} myflux esft error pn \$xspec_tclout


################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
0.7
2.0
-11.20


-11.20


-11.20


-11.20


-11.20
freeze 24 42 60

fit
error 3 63 123 183 243

tclout param 3
echo ${1} myflux vsft param r1o1 \$xspec_tclout
tclout param 63
echo ${1} myflux vsft param r2o1 \$xspec_tclout
tclout param 123
echo ${1} myflux vsft param r1o2 \$xspec_tclout
tclout param 183
echo ${1} myflux vsft param r2o2 \$xspec_tclout
tclout param 243
echo ${1} myflux vsft param pn \$xspec_tclout

tclout error 3
echo ${1} myflux vsft error r1o1 \$xspec_tclout
tclout error 63
echo ${1} myflux vsft error r2o1 \$xspec_tclout
tclout error 123
echo ${1} myflux vsft error r1o2 \$xspec_tclout
tclout error 183
echo ${1} myflux vsft error r2o2 \$xspec_tclout
tclout error 243
echo ${1} myflux vsft error pn \$xspec_tclout


################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
0.5
8.
-11.


-11.


-11.


-11.


-11.

fit
error 3 63 123 183 243

tclout param 3
echo ${1} myflux full param r1o1 \$xspec_tclout
tclout param 63
echo ${1} myflux full param r2o1 \$xspec_tclout
tclout param 123
echo ${1} myflux full param r1o2 \$xspec_tclout
tclout param 183
echo ${1} myflux full param r2o2 \$xspec_tclout
tclout param 243
echo ${1} myflux full param pn \$xspec_tclout

tclout error 3
echo ${1} myflux full error r1o1 \$xspec_tclout
tclout error 63
echo ${1} myflux full error r2o1 \$xspec_tclout
tclout error 123
echo ${1} myflux full error r1o2 \$xspec_tclout
tclout error 183
echo ${1} myflux full error r2o2 \$xspec_tclout
tclout error 243
echo ${1} myflux full error pn \$xspec_tclout

################################################################


editmo tba(gsm(vps+vps+vps))
editmo cflux(tba(gsm(vps+vps+vps)))
3.
8.
-12.


-12.


-12.


-12.


-12.

data 1 none/
data 1 none/
data 1 none/
data 1 none/
free 7 22 25 40 43 58

fit
error 3

tclout param 3
echo ${1} myflux hard param pn \$xspec_tclout
tclout error 3
echo ${1} myflux hard error pn \$xspec_tclout
" > tmp_xmm.xcm
    
    xspec < tmp_xmm.xcm > log/${1}_flx.txt
}

ids=(0690510101 0743790101 0804980201)
ids=(0144530101 0406840301 0506220101 0556350101 0601200101 0650420101 0671080101 0763620101 0783250201 0831810101)
nid=${#ids[*]}

for id in $(seq 0 $(($nid-1)))
do
    echo ${ids[id]}
    get_flx ${ids[id]}
done
