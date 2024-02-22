#!/bin/bash

wrk_dir=/Volumes/pow/dat/nus/87a/
ver=v4

################################################################

cd $wrk_dir
ids=($(ls -d */ | sed 's#/##'))
ids=(40001014013)
nid=${#ids[*]}
ra=83.86661853961974
dec=-69.26975365456684

for id in $(seq 0 $(($nid-1)))
do
    cd ${ids[id]}
    echo ${ids[id]}
    
    
# THIS IS FOR SUBTRACTING BACKGROUND
    nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}A01_bc.evt instrument=FPMA steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=srcA.reg bkgregionfile=bkgA.reg rungrppha=yes grpmincounts=25 pilow=210 pihigh=460 binsize=5808 phafile=NONE imagefile=NONE lcpsfflag=no lcvignflag=no
    nuproducts indir=./${ver} infile=./${ver}/nu${ids[id]}B01_bc.evt instrument=FPMB steminputs=nu${ids[id]} outdir=./${ver} srcregionfile=srcB.reg bkgregionfile=bkgB.reg rungrppha=yes grpmincounts=25 pilow=210 pihigh=460 binsize=5808 phafile=NONE imagefile=NONE lcpsfflag=no lcvignflag=no

    

    cd $wrk_dir
done

echo "EOF"
