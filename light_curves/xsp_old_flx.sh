#!/bin/bash

# Get fluxes but using components from the density of shock fits

cd /Users/silver/box/phd/pro/87a/nus/xsp


get_flx () {
    printf "
abund wilm
setpl ene
query yes
parallel error 3
energies 0.1 100 10000 log

@${1}
newpar  34 0 
newpar  52 0 
newpar  70 0 
newpar  88 0 
newpar 106 0 
newpar 124 0
newpar 142 0
newpar 160 0
newpar 178 0
flux 0.1 80

@${1}
newpar 196 0
newpar 214 0
newpar 232 0
newpar 250 0
newpar 268 0
newpar 286 0
newpar 304 0
newpar 322 0
newpar 340 0
newpar 358 0
newpar 376 0
newpar 394 0
newpar 412 0
newpar 430 0
newpar 448 0
newpar 466 0
newpar 484 0
newpar 502 0
newpar 520 0
flux 0.1 80

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
