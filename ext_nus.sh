#!/bin/bash

wrk_dir=/Volumes/pow/dat/nus/87a/
ver=pro
# ver=boggs15

################################################################

cd $wrk_dir
ids=($(ls -d */ | sed 's#/##'))
# ids=(40001014006)
nid=${#ids[*]}
ra=83.86661853961974
dec=-69.26975365456684

for id in $(seq 0 $(($nid-1)))
do
    cd ${ids[id]}
    echo ${ids[id]}
    
    nupipeline indir=. steminputs=nu${ids[id]} outdir=./${ver} obsmode=SCIENCE saacalc=1 saamode=strict tentacle=yes

    barycorr infile=./${ver}/nu${ids[id]}A01_cl.evt outfile=./${ver}/nu${ids[id]}A01_bc.evt orbitfiles=./auxil/nu${ids[id]}_orb.fits ra=${ra} dec=${dec} refframe=ICRS
    barycorr infile=./${ver}/nu${ids[id]}B01_cl.evt outfile=./${ver}/nu${ids[id]}B01_bc.evt orbitfiles=./auxil/nu${ids[id]}_orb.fits ra=${ra} dec=${dec} refframe=ICRS
    
# THIS IS FOR SUBTRACTING BACKGROUND
    nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}A01_bc.evt instrument=FPMA steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=srcA.reg bkgregionfile=bkgA.reg rungrppha=yes grpmincounts=25 grppibadlow=35 grppibadhigh=1909 binsize=5808
    nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}B01_bc.evt instrument=FPMB steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=srcB.reg bkgregionfile=bkgB.reg rungrppha=yes grpmincounts=25 grppibadlow=35 grppibadhigh=1909 binsize=5808

    # # THIS IS FOR FITTING BACKGROUND
    # # First, extract the source
    # nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}A01_bc.evt instrument=FPMA steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=nu${ids[id]}A01_src.reg rungrppha=yes grpmincounts=25 grppibadlow=35 grppibadhigh=1909 binsize=512 pilow=1460 imagefile=NONE lcfile=NONE bkgextract=no
    # nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}B01_bc.evt instrument=FPMB steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=nu${ids[id]}B01_src.reg rungrppha=yes grpmincounts=25 grppibadlow=35 grppibadhigh=1909 binsize=512 pilow=1460 imagefile=NONE lcfile=NONE bkgextract=no

    # # Second, extract the background
    # nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}A01_bc.evt instrument=FPMA steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=nu${ids[id]}A01_bkg.reg rungrppha=yes grpmincounts=25 grppibadlow=35 grppibadhigh=1909 binsize=512 pilow=1460 imagefile=NONE lcfile=NONE bkgextract=no extended=yes boxsize=20 phafile=nu${ids[id]}A01_bk.pha outarffile=nu${ids[id]}A01_bk.arf outrmffile=nu${ids[id]}A01_bk.rmf grpphafile=nu${ids[id]}A01_bk_grp.pha vignflag=no apstopflag=no detabsflag=no psfflag=no grflag=no
    # nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}B01_bc.evt instrument=FPMB steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=nu${ids[id]}B01_bkg.reg rungrppha=yes grpmincounts=25 grppibadlow=35 grppibadhigh=1909 binsize=512 pilow=1460 imagefile=NONE lcfile=NONE bkgextract=no extended=yes boxsize=20 phafile=nu${ids[id]}B01_bk.pha outarffile=nu${ids[id]}B01_bk.arf outrmffile=nu${ids[id]}B01_bk.rmf grpphafile=nu${ids[id]}B01_bk_grp.pha vignflag=no apstopflag=no detabsflag=no psfflag=no grflag=no
    
    /Applications/SAOImageDS9.app/Contents/MacOS/ds9 ./${ver}/nu${ids[id]}A01_bc.evt -scale linear -cmap Heat -regions ./srcA.reg -regions ./bkgA.reg -print destination file -print filename ./${ver}/nu${ids[id]}A01_img_${ver}.ps -print -exit
    /Applications/SAOImageDS9.app/Contents/MacOS/ds9 ./${ver}/nu${ids[id]}B01_bc.evt -scale linear -cmap Heat -regions ./srcB.reg -regions ./bkgB.reg -print destination file -print filename ./${ver}/nu${ids[id]}B01_img_${ver}.ps -print -exit
    
    for ff in ./${ver}/*.ps
    do
        ps2pdf ${ff}
    done
    rm ./${ver}/*.ps

    cd $wrk_dir
done

echo "EOF"
