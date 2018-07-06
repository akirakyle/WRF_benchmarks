#!/bin/sh
set -e
CASE_NAME=new_conus12km # or new_conus2.5km or maria1km or maria3km
DATA_PREFIX=/glade2/collections/rda/data/ds084.1/2018/20180617/gfs.0p25.2018061700 # for new_conus cases
# DATA_PREFIX=/glade2/collections/rda/data/ds084.1/2017/20170920/gfs.0p25.2017092000 # for maria cases
CASE_DIR=~/WRF_benchmarks/cases/$CASE_NAME
RUN_DIR=~/work/case_data/$CASE_NAME
WPS_DIR=~/work/WPSs/WPSV4.0-intel18.0.1
WRF_DIR=~/work/WRFs/WRFV4.0-intel18.0.1-mpt2.18
N=4
JOB_NAME=$CASE_NAME-real

cd $CASE_DIR
ln -sf $RUN_DIR/wrfbdy_d01 .
ln -sf $RUN_DIR/wrfinput_d01 .

mkdir -p $RUN_DIR
cd $RUN_DIR

ln -sf $CASE_DIR/namelist.* .
ln -sf $WPS_DIR/*.exe .
ln -sf $WPS_DIR/ungrib/Variable_Tables/Vtable.GFS Vtable
ln -sf $WRF_DIR/main/real.exe .
sed 's/\.\/wrf\.exe/\.\/real\.exe/' $WRF_DIR/run/mpirun_wrf > mpirun_real
chmod a+x mpirun_real

ln -sf $DATA_PREFIX.f000.grib2 GRIBFILE.AAA
ln -sf $DATA_PREFIX.f003.grib2 GRIBFILE.AAB
ln -sf $DATA_PREFIX.f006.grib2 GRIBFILE.AAC
ln -sf $DATA_PREFIX.f009.grib2 GRIBFILE.AAD
ln -sf $DATA_PREFIX.f012.grib2 GRIBFILE.AAE

./run_wps.exe

envsubst '${N},${JOB_NAME}' > $JOB_NAME.pbs << EOF
#!/bin/bash
#PBS -N ${JOB_NAME}
#PBS -A SCSG0002
#PBS -l walltime=00:30:00
#PBS -q regular
#PBS -j oe
#PBS -l select=${N}:ncpus=36:mpiprocs=36
#PBS -m abe
#PBS -M akirak@ucar.edu

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

./mpirun_real $((${N} * 36))
EOF
qsub $JOB_NAME.pbs
