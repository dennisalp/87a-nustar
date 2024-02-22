#!/bin/bash

# Get fluxes but using components from the density of shock fits

cd /Users/silver/box/phd/pro/87a/nus/xsp


get_flx () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3
energies 0.01 100 10000 log


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

@com_g1.xcm

################################################################


editmo cflux(tba(gsm(vps+vps+vps)))
0.01
100.
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
" > tmp_com.xcm
    
    xspec < tmp_com.xcm > log/${1/.xcm/}_flx.txt
}

ids=($(ls dos_em10_013_pl0_g?.xcm))
nid=${#ids[*]}

for id in $(seq 0 $(($nid-1)))
do
    echo ${ids[id]}
    get_flx ${ids[id]}
done

# grep 'Flux' ../xsp/log/dos_em10_013_pl0_g?_flx.txt
# g1 8.4629e-12 ergs/cm^2/s
# g2 8.5297e-12 ergs/cm^2/s
# g3 8.3762e-12 ergs/cm^2/s
# g4 8.4016e-12 ergs/cm^2/s
# g5 9.1659e-12 ergs/cm^2/s
# g6 9.2188e-12 ergs/cm^2/s
# g7 9.1435e-12 ergs/cm^2/s
# g8 9.5476e-12 ergs/cm^2/s

# g1 1.8387e-12 ergs/cm^2/s
# g2 1.8162e-12 ergs/cm^2/s
# g3 1.8480e-12 ergs/cm^2/s
# g4 1.7992e-12 ergs/cm^2/s
# g5 1.1826e-12 ergs/cm^2/s
# g6 1.1528e-12 ergs/cm^2/s
# g7 1.1798e-12 ergs/cm^2/s
# g8 1.0664e-12 ergs/cm^2/s

# tt = np.array([9423, 10141, 11192])
# a = (8.4629e-12+8.5297e-12+8.3762e-12+8.4016e-12)/4
# b = (9.1659e-12+9.2188e-12+9.1435e-12)/3
# hi = np.array([a, b, 9.5476e-12])

# a = (1.8387e-12+1.8162e-12+1.8480e-12+1.7992e-12)/4
# b = (1.1826e-12+1.1528e-12+1.1798e-12)/3
# lo = np.array([a, b, 1.0664e-12])
# plt.plot(tt, lo*5, 'o')
# plt.plot(tt, hi, 'o')
# plt.xlabel('Time (d)')
# plt.ylim(bottom=0)
# plt.show()
