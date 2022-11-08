#!/bin/bash -x

################################################################
# Parameters
################################################################
     
coo="5:35:27.9884 -69:16:11.1132"
id="0804980201"
pn_exp=1
m1_exp=1
m2_exp=1
rate_pn=0.45
rate_m1=0.16
rate_m2=0.20
rate_r1=0.12
rate_r2=0.12

tbin=60
tbpy=4
pn_src="circle(25720.195,23936.805,600)"
pn_ann="annulus(25720.195,23936.805,150,800)"
m1_src="circle(25720.195,23936.805,600)"
m2_src="circle(25720.195,23936.805,600)"
pn_bkg="circle(22983.629,25789.95,1219.9824)"
m1_bkg="circle(30073.869,23080.955,2110.8633)"
m2_bkg="circle(30073.869,23080.955,2110.8633)"

################################################################
# Help functions
################################################################
print_src () {
  printf "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=2 font=\"helvetica 10 normal roman\" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
detector
${2}" > ${1}
}
print_bkg () {
  printf "# Region file format: DS9 version 4.1
global color=white dashlist=8 3 width=2 font=\"helvetica 10 normal roman\" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
detector
${2}" > ${1}
}

# Add coordinate system and equinox (DS9 requires this)
fmt_wcs () {
    fthedit ${1} EQUINOX add 2000
    fthedit ${1} RADESYS add FK5
}



################################################################
# Some preparation
################################################################
wrk="/Users/silver/dat/xmm/87a/${id}_repro_old"
dat="/Users/silver/dat/xmm/87a/${id}"

if [[ $wrk =~ " " ]]
then
    echo "Path to working is not allowed to contain spaces! (SAS issue)"
    exit 1
fi

ds9='/Applications/SAOImageDS9.app/Contents/MacOS/ds9'
export SAS_DIR="/Users/silver/sas_18.0.0-Darwin-16.7.0-64/xmmsas_20190531_1155"
export SAS_CCFPATH="/Users/silver/ccf"
export SAS_ODF="${dat}/ODF"
export SAS_CCF="${wrk}/ccf.cif"
mkdir -p ${wrk}
cd ${wrk}

. ${SAS_DIR}/setsas.sh



################################################################
# Make raw event lists
################################################################
# cifbuild
# odfingest
export SAS_ODF=$(ls -1 *SUM.SAS)
# epproc pileuptempfile=yes runepxrlcorr=yes
# rgsproc


################################################################
# Make background flare light curves
################################################################
# evselect table=$(ls *EPN*ImagingEvts.ds) withrateset=Y rateset=${id}_pn_bkg_flare.fits \
#          maketimecolumn=Y timebinsize=100 makeratecolumn=Y \
#          expression="#XMMEA_EP && (PI>10000&&PI<12000) && (PATTERN==0)"
# dsplot table=${id}_pn_bkg_flare.fits x=TIME y=RATE

# evselect table=$(ls P${id}R1*EVENLI0000.FIT) \
#          timebinsize=100 \
#          rateset=${id}_r1_bkg_lc.fits \
#          makeratecolumn=yes \
#          maketimecolumn=yes \
#          expression="(CCDNR==9)&&(REGION($(ls P${id}R1*SRCLI_0000.FIT):RGS1_BACKGROUND,M_LAMBDA,XDSP_CORR))"
# evselect table=$(ls P${id}R2*EVENLI0000.FIT) \
#          timebinsize=100 \
#          rateset=${id}_r2_bkg_lc.fits \
#          makeratecolumn=yes \
#          maketimecolumn=yes \
#          expression="(CCDNR==9)&&(REGION($(ls P${id}R2*SRCLI_0000.FIT):RGS2_BACKGROUND,M_LAMBDA,XDSP_CORR))"

# dsplot table=${id}_r1_bkg_lc.fits x=TIME y=RATE
# dsplot table=${id}_r2_bkg_lc.fits x=TIME y=RATE


################################################################
# Make filtered event lists and images
# Need to set background flare conditions
################################################################
# tabgtigen table=${id}_pn_bkg_flare.fits expression="RATE<=${rate_pn}" gtiset=${id}_pn_gti.fits

# evselect table=$(ls *EPN*ImagingEvts.ds) withfilteredset=Y \
#         filteredset=${id}_pn_clean_evt.fits \
#         destruct=Y keepfilteroutput=T \
#         expression="#XMMEA_EP && gti(${id}_pn_gti.fits,TIME) && (PI in [300:10000]) && (PATTERN<=4)"
# evselect table=${id}_pn_clean_evt.fits imagebinning=binSize \
#         imageset=${id}_pn_clean_img.fits withimageset=yes \
#         xcolumn=X ycolumn=Y ximagebinsize=80 yimagebinsize=80


################################################################
# Make light curves
# Need to set tbin
# Need to set spatial source and background regions
################################################################
# print_src "${id}_pn_src.reg" ${pn_src}
# print_bkg "${id}_pn_bkg.reg" ${pn_bkg}

# evselect table=$(ls *EPN*ImagingEvts.ds) \
#          withfilteredset=yes \
#          filteredset=${id}_pn_pup_evt.fits \
#          keepfilteroutput=yes \
#          expression="((X,Y) in ${pn_src}) && gti(${id}_pn_gti.fits,TIME)"
# evselect table=$(ls *EPN*ImagingEvts.ds) \
#          withfilteredset=yes \
#          filteredset=${id}_pn_pup_ann.fits \
#          keepfilteroutput=yes \
#          expression="((X,Y) in ${pn_ann}) && gti(${id}_pn_gti.fits,TIME)"

# epatplot set=${id}_pn_pup_evt.fits plotfile="${id}_pn_pat.ps"
# epatplot set=${id}_pn_pup_ann.fits plotfile="${id}_pn_ann.ps"


# evselect table=$(ls *EPN*ImagingEvts.ds) withfilteredset=Y \
#         filteredset=${id}_pn_clean_evt.fits \
#         destruct=Y keepfilteroutput=T \
#         expression="#XMMEA_EP && gti(${id}_pn_gti.fits,TIME) && (PI in [300:10000]) && (PATTERN<=4)"
# evselect table=${id}_pn_clean_evt.fits imagebinning=binSize \
#         imageset=${id}_pn_clean_img.fits withimageset=yes \
#         xcolumn=X ycolumn=Y ximagebinsize=80 yimagebinsize=80

# evselect table=${id}_pn_clean_evt.fits energycolumn=PI \
#         expression="(X,Y) IN ${pn_src}" \
#         withrateset=yes rateset=${id}_pn_raw_src_lc.fits timebinsize=${tbin} \
#         maketimecolumn=yes makeratecolumn=yes
# evselect table=${id}_pn_clean_evt.fits energycolumn=PI \
#         expression="(X,Y) IN ${pn_bkg}" \
#         withrateset=yes rateset=${id}_pn_raw_bkg_lc.fits timebinsize=${tbin} \
#         maketimecolumn=yes makeratecolumn=yes
# epiclccorr srctslist=${id}_pn_raw_src_lc.fits eventlist=${id}_pn_clean_evt.fits \
#           outset=${id}_pn_lccorr.fits bkgtslist=${id}_pn_raw_bkg_lc.fits \
#           withbkgset=yes applyabsolutecorrections=yes

# python -c "
# import matplotlib.pyplot as plt
# from astropy.io import fits
# pn = fits.open('${id}_pn_lccorr.fits')[1].data
# plt.plot(pn['TIME'], pn['RATE'])
# plt.title('${id}_ep_lccorr')
# plt.xlabel('Time (s)')
# plt.ylabel('Rate (cts/s)')
# # plt.show()
# "

# ${ds9} ${id}_pn_clean_img.fits -scale log -cmap Heat -regions ${id}_pn_src.reg -pan to ${coo} wcs -zoom 2 -regions ${id}_pn_bkg.reg -print destination file -print filename ${id}_pn_clean_img.ps -print -exit
# for ff in *.ps
# do
#     ps2pdf ${ff}
# done
# rm *.ps


# evselect table=${id}_pn_clean_evt.fits withspectrumset=yes \
#          spectrumset=${id}_pn_spec_src.fits energycolumn=PI spectralbinsize=5 \
#          withspecranges=yes specchannelmin=0 specchannelmax=20479 \
#          expression="(FLAG==0)&&((X,Y) IN ${pn_src})"
# evselect table=${id}_pn_clean_evt.fits withspectrumset=yes \
#          spectrumset=${id}_pn_spec_bkg.fits energycolumn=PI spectralbinsize=5 \
#          withspecranges=yes specchannelmin=0 specchannelmax=20479 \
#          expression="(FLAG==0)&&((X,Y) IN ${pn_bkg})"
# backscale spectrumset=${id}_pn_spec_src.fits badpixlocation=${id}_pn_clean_evt.fits
# backscale spectrumset=${id}_pn_spec_bkg.fits badpixlocation=${id}_pn_clean_evt.fits
# rmfgen spectrumset=${id}_pn_spec_src.fits rmfset=${id}_pn_spec_rmf.fits
# arfgen spectrumset=${id}_pn_spec_src.fits arfset=${id}_pn_spec_arf.fits withrmfset=yes \
#        rmfset=${id}_pn_spec_rmf.fits badpixlocation=${id}_pn_clean_evt.fits \
#        detmaptype=psf
# specgroup spectrumset=${id}_pn_spec_src.fits mincounts=25 oversample=3 \
#           rmfset=${id}_pn_spec_rmf.fits arfset=${id}_pn_spec_arf.fits \
#           backgndset=${id}_pn_spec_bkg.fits groupedset=${id}_pn_spec_grp.fits
# fthedit "${id}_pn_spec_src.fits" BACKFILE add "${id}_pn_spec_bkg.fits"
# fthedit "${id}_pn_spec_src.fits" RESPFILE add "${id}_pn_spec_rmf.fits"
# fthedit "${id}_pn_spec_src.fits" ANCRFILE add "${id}_pn_spec_arf.fits"


# evselect table=${id}_pn_clean_evt.fits withspectrumset=yes \
#          spectrumset=${id}_pn_spec_src_ann.fits energycolumn=PI spectralbinsize=5 \
#          withspecranges=yes specchannelmin=0 specchannelmax=20479 \
#          expression="(FLAG==0)&&((X,Y) IN ${pn_ann})"
# backscale spectrumset=${id}_pn_spec_src_ann.fits badpixlocation=${id}_pn_clean_evt.fits
# rmfgen spectrumset=${id}_pn_spec_src_ann.fits rmfset=${id}_pn_spec_rmf_ann.fits
# arfgen spectrumset=${id}_pn_spec_src_ann.fits arfset=${id}_pn_spec_arf_ann.fits withrmfset=yes \
#        rmfset=${id}_pn_spec_rmf_ann.fits badpixlocation=${id}_pn_clean_evt.fits \
#        detmaptype=psf
# specgroup spectrumset=${id}_pn_spec_src_ann.fits mincounts=25 oversample=3 \
#           rmfset=${id}_pn_spec_rmf_ann.fits arfset=${id}_pn_spec_arf_ann.fits \
#           backgndset=${id}_pn_spec_bkg.fits groupedset=${id}_pn_spec_grp_ann.fits
# fthedit "${id}_pn_spec_src_ann.fits" BACKFILE add "${id}_pn_spec_bkg.fits"
# fthedit "${id}_pn_spec_src_ann.fits" RESPFILE add "${id}_pn_spec_rmf_ann.fits"
# fthedit "${id}_pn_spec_src_ann.fits" ANCRFILE add "${id}_pn_spec_arf_ann.fits"


# cp ${id}_pn_spec_src.fits ${id}_pn_spec_src_pup.fits
# rmfgen spectrumset=${id}_pn_spec_src_pup.fits rmfset=${id}_pn_spec_rmf_pup.fits \
#        correctforpileup=yes raweventfile=$(ls *EPN*_04_PileupEvts.ds)
# arfgen spectrumset=${id}_pn_spec_src_pup.fits arfset=${id}_pn_spec_arf_pup.fits withrmfset=yes \
#        rmfset=${id}_pn_spec_rmf_pup.fits badpixlocation=${id}_pn_clean_evt.fits \
#        detmaptype=psf
# specgroup spectrumset=${id}_pn_spec_src_pup.fits \
#           mincounts=25 \
#           oversample=3 \
#           rmfset=${id}_pn_spec_rmf_pup.fits \
#           arfset=${id}_pn_spec_arf_pup.fits \
#           backgndset=${id}_pn_spec_bkg.fits \
#           groupedset=${id}_pn_spec_grp_pup.fits
# fthedit "${id}_pn_spec_src_pup.fits" BACKFILE add "${id}_pn_spec_bkg.fits"
# fthedit "${id}_pn_spec_src_pup.fits" RESPFILE add "${id}_pn_spec_rmf_pup.fits"
# fthedit "${id}_pn_spec_src_pup.fits" ANCRFILE add "${id}_pn_spec_arf_pup.fits"





################################################################
# RGS
################################################################
# tabgtigen table=${id}_r1_bkg_lc.fits gtiset=${id}_r1_gti.fits expression="(RATE<${rate_r1})"
# tabgtigen table=${id}_r2_bkg_lc.fits gtiset=${id}_r2_gti.fits expression="(RATE<${rate_r2})"
# rgsproc entrystage=3:filter auxgtitables="${id}_r1_gti.fits ${id}_r2_gti.fits"

evselect table="$(ls P${id}R1*EVENLI0000.FIT):EVENTS" \
         imageset="${id}_r1_xd.fits" xcolumn="M_LAMBDA" ycolumn="XDSP_CORR"
evselect table="$(ls P${id}R1*EVENLI0000.FIT):EVENTS" \
         imageset="${id}_r1_pi.fits" xcolumn="M_LAMBDA" ycolumn="PI"\
         yimagemin=0 yimagemax=3000 \
         expression="REGION($(ls P${id}R1*SRCLI_0000.FIT):RGS1_SRC1_SPATIAL,M_LAMBDA,XDSP_CORR)"
rgsimplot endispset="${id}_r1_pi.fits" spatialset="${id}_r1_xd.fits" \
          srcidlist="1" srclistset="$(ls P${id}R1*SRCLI_0000.FIT)" \
          device=/cps plotfile=r1.ps
evselect table="$(ls P${id}R2*EVENLI0000.FIT):EVENTS" \
         imageset="${id}_r2_xd.fits" xcolumn="M_LAMBDA" ycolumn="XDSP_CORR"
evselect table="$(ls P${id}R2*EVENLI0000.FIT):EVENTS" \
         imageset="${id}_r2_pi.fits" xcolumn="M_LAMBDA" ycolumn="PI"\
         yimagemin=0 yimagemax=3000 \
         expression="REGION($(ls P${id}R2*SRCLI_0000.FIT):RGS2_SRC1_SPATIAL,M_LAMBDA,XDSP_CORR)"
rgsimplot endispset="${id}_r2_pi.fits" spatialset="${id}_r2_xd.fits" \
          srcidlist="1" srclistset="$(ls P${id}R2*SRCLI_0000.FIT)" \
          device=/cps plotfile=r2.ps
for ff in *.ps
do
    ps2pdf ${ff}
done
rm *.ps

# grppha "$(ls P${id}R1*SRSPEC1001.FIT)" \
#        "!${id}_r1o1_grp.fits" \
#        << EOF
# chkey BACKFILE $(ls P${id}R1*BGSPEC1001.FIT)
# chkey RESPFILE $(ls P${id}R1*RSPMAT1001.FIT)
# group min 25
# exit
# EOF
# grppha "$(ls P${id}R2*SRSPEC1001.FIT)" \
#        "!${id}_r2o1_grp.fits" \
#        << EOF
# chkey BACKFILE $(ls P${id}R2*BGSPEC1001.FIT)
# chkey RESPFILE $(ls P${id}R2*RSPMAT1001.FIT)
# group min 25
# exit
# EOF
# grppha "$(ls P${id}R1*SRSPEC2001.FIT)" \
#        "!${id}_r1o2_grp.fits" \
#        << EOF
# chkey BACKFILE $(ls P${id}R1*BGSPEC2001.FIT)
# chkey RESPFILE $(ls P${id}R1*RSPMAT2001.FIT)
# group min 25
# exit
# EOF
# grppha "$(ls P${id}R2*SRSPEC2001.FIT)" \
#        "!${id}_r2o2_grp.fits" \
#        << EOF
# chkey BACKFILE $(ls P${id}R2*BGSPEC2001.FIT)
# chkey RESPFILE $(ls P${id}R2*RSPMAT2001.FIT)
# group min 25
# exit
# EOF

# rgscombine pha="$(ls P${id}R1*SRSPEC1001.FIT) $(ls P${id}R2*SRSPEC1001.FIT)" \
#            rmf="$(ls P${id}R1*RSPMAT1001.FIT) $(ls P${id}R2*RSPMAT1001.FIT)" \
#            bkg="$(ls P${id}R1*BGSPEC1001.FIT) $(ls P${id}R2*BGSPEC1001.FIT)" \
#            filepha="${id}_o1_pha.fits" \
#            filermf="${id}_o1_rmf.fits" \
#            filebkg="${id}_o1_bkg.fits"
# grppha "${id}_o1_pha.fits" \
#        "!${id}_o1_grp.fits" \
#        "group min 25" \
#        "exit"

# rgscombine pha="$(ls P${id}R1*SRSPEC2001.FIT) $(ls P${id}R2*SRSPEC2001.FIT)" \
#            rmf="$(ls P${id}R1*RSPMAT2001.FIT) $(ls P${id}R2*RSPMAT2001.FIT)" \
#            bkg="$(ls P${id}R1*BGSPEC2001.FIT) $(ls P${id}R2*BGSPEC2001.FIT)" \
#            filepha="${id}_o2_pha.fits" \
#            filermf="${id}_o2_rmf.fits" \
#            filebkg="${id}_o2_bkg.fits"
# grppha "${id}_o2_pha.fits" \
#        "!${id}_o2_grp.fits" \
#        "group min 25" \
#        "exit"
