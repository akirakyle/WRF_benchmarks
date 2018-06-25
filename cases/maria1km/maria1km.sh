#!/bin/sh
NAMELIST_DIR=$(pwd)
RUN_DIR=~/work/case_data/maria1km
WPS_DIR=~/work/WPSV3.8.1-gnu8.1.0
WRF_DIR=~/work/WRFs/WRFV4.0-intel18.0.1-mpt2.18
N=8
JOB_NAME=maria1km-real

ln -sf $RUN_DIR/wrfbdy_d01 .
ln -sf $RUN_DIR/wrfinput_d01 .

mkdir -p $RUN_DIR
cd $RUN_DIR

ln -sf $NAMELIST_DIR/namelist.* .
ln -sf $WPS_DIR/*.exe .
ln -sf $WPS_DIR/ungrib/Variable_Tables/Vtable.GFS Vtable
ln -sf $WRF_DIR/main/real.exe .
sed 's/\.\/wrf\.exe/\.\/real\.exe/' $WRF_DIR/run/mpirun_wrf > mpirun_real

ln -sf /glade2/collections/rda/data/ds084.1/2018/20180617/gfs.0p25.2018061700.f000.grib2 GRIBFILE.AAA
ln -sf /glade2/collections/rda/data/ds084.1/2018/20180617/gfs.0p25.2018061700.f003.grib2 GRIBFILE.AAB
ln -sf /glade2/collections/rda/data/ds084.1/2018/20180617/gfs.0p25.2018061700.f006.grib2 GRIBFILE.AAC
ln -sf /glade2/collections/rda/data/ds084.1/2018/20180617/gfs.0p25.2018061700.f009.grib2 GRIBFILE.AAD
ln -sf /glade2/collections/rda/data/ds084.1/2018/20180617/gfs.0p25.2018061700.f012.grib2 GRIBFILE.AAE


./run_wps.exe

envsubst '${N},${JOB_NAME}' > $JOB_NAME.pbs << EOF
#!/bin/bash
#PBS -N ${JOB_NAME}
#PBS -A SCSG0002
#PBS -l walltime=00:30:00
#PBS -q regular
#PBS -j oe
#PBS -l select=8:ncpus=36:mpiprocs=36
#PBS -m abe
#PBS -M akirak@ucar.edu

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

./mpirun_real $((${N} * 36))
EOF
qsub $JOB_NAME.pbs
