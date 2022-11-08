#!/bin/bash -x

# This actually does not get the limit.
# It compares the goodness of fit between the three component shock model and
# two component model plus a cutoff pl with Gamma=2. This is like replacing the
# thermal shock with a non-thermal pl. This also needs to thaw the Fe abundance
# that it can be fitted.

cd /Users/silver/box/phd/pro/87a/nus/xsp

# Prepare python script for shifting the ties
printf "
import sys
import matplotlib.pyplot as plt
import numpy as np

shift = int(sys.argv[1])

fe = '       0.389731      -0.01          0          0       1000      10000'
ff = open('tmp_lim.xcm', 'r')
out = ''
for f in ff.readlines():
  if f[:3] == '= p':
    tmp = str(int(f[3:-1])+shift) + '\\\n'
    f = f[:3] + tmp
  f = f.replace(fe, '= p17')  
  out += f

ff.close()

ff = open('tmp_lim.xcm', 'w')
ff.write(out)
ff.close()
" > tmp_lim.py

# 384+np.arange(0,7)*256
gg=(g2 g3 g4 g5 g6 g7 g8)
sft=(384 640 896 1152 1408 1664 1920)

# Concatenate the XSPEC models into an all NuSTAR model
ghead -n -257 com_g1.xcm > lim.xcm
for i in {0..6}
do
    echo ${gg[$i]} ${sft[$i]}
    ghead -n -257 com_${gg[$i]}.xcm | tail -n +8 > tmp_lim.xcm
    python tmp_lim.py ${sft[$i]}
    cat tmp_lim.xcm >> lim.xcm
done
echo "bayes off" >> lim.xcm

# Freeze the 1st shock component
python -c "
import numpy as np

ff = open('tmp_lim.xcm', 'w')
out = 'thaw 17\n'
out += 'freeze 5 20 22 '

for i in 5+384+np.arange(0,7)*256:
  out += str(i) + ' '
for i in 20+384+np.arange(0,7)*256:
  out += str(i) + ' '  
for i in 22+384+np.arange(0,7)*256:
  out += str(i) + ' '

ff.write(out)
ff.close()
"
cat tmp_lim.xcm >> lim.xcm

# XSPEC: Load data and perform fit
printf "
abund wilm
setpl ene
query yes
parallel error 3

data  1:1  nu40001014002A01_bc_sr_grp.pha
data  2:2  nu40001014002B01_bc_sr_grp.pha
data  3:3  nu40001014003A01_bc_sr_grp.pha
data  4:4  nu40001014003B01_bc_sr_grp.pha
data  5:5  nu40001014004A01_bc_sr_grp.pha
data  6:6  nu40001014004B01_bc_sr_grp.pha
data  7:7  nu40001014006A01_bc_sr_grp.pha
data  8:8  nu40001014006B01_bc_sr_grp.pha
data  9:9  nu40001014007A01_bc_sr_grp.pha
data 10:10  nu40001014007B01_bc_sr_grp.pha
data 11:11  nu40001014009A01_bc_sr_grp.pha
data 12:12  nu40001014009B01_bc_sr_grp.pha
data 13:13  nu40001014010A01_bc_sr_grp.pha
data 14:14  nu40001014010B01_bc_sr_grp.pha
data 15:15  nu40001014012A01_bc_sr_grp.pha
data 16:16  nu40001014012B01_bc_sr_grp.pha
data 17:17  nu40001014013A01_bc_sr_grp.pha
data 18:18  nu40001014013B01_bc_sr_grp.pha
data 19:19  nu40001014015A01_bc_sr_grp.pha
data 20:20  nu40001014015B01_bc_sr_grp.pha
data 21:21  nu40001014016A01_bc_sr_grp.pha
data 22:22  nu40001014016B01_bc_sr_grp.pha
data 23:23  nu40001014018A01_bc_sr_grp.pha
data 24:24  nu40001014018B01_bc_sr_grp.pha
data 25:25  nu40001014020A01_bc_sr_grp.pha
data 26:26  nu40001014020B01_bc_sr_grp.pha
data 27:27  nu40001014022A01_bc_sr_grp.pha
data 28:28  nu40001014022B01_bc_sr_grp.pha
data 29:29  nu40001014023A01_bc_sr_grp.pha
data 30:30  nu40001014023B01_bc_sr_grp.pha
data 31:31  nu40501004002A01_bc_sr_grp.pha
data 32:32  nu40501004002B01_bc_sr_grp.pha
data 33:33  nu40501004004A01_bc_sr_grp.pha
data 34:34  nu40501004004B01_bc_sr_grp.pha

notice all
ignore bad
ignore 1-34: **-3. 24.00-**

@lim.xcm
fit

editmo con(tba(gsm(vps))+tba(gsm(vps))+gsm(vps))
editmo con(tba(gsm(vps))+tba(gsm(vps))+vps)
editmo con(tba(gsm(vps))+tba(gsm(vps+cutoffpl)))
2 0
15
3e-5















2 0
15
3e-5

=p321
=p322

=p321
=p322

=p321
=p322
2 0
15
3e-5

=p505
=p506

=p505
=p506

=p505
=p506
2 0
15
3e-5

=p689
=p690

=p689
=p690

=p689
=p690
2 0
15
3e-5

=p873
=p874

=p873
=p874

=p873
=p874
2 0
15
3e-5

=p1057
=p1058

=p1057
=p1058

=p1057
=p1058
2 0
15
3e-5

=p1241
=p1242

=p1241
=p1242

=p1241
=p1242
2 0
15
3e-5

=p1425
=p1426

=p1425
=p1426

=p1425
=p1426

fit

save model lim_co2
y

error 2.706 17
tclout param 17
echo limit param \$xspec_tclout
tclout error 17
echo limit error \$xspec_tclout

" > tmp_lim_co2.xcm

xspec < tmp_lim_co2.xcm > log/lim_co2.txt
