#!/bin/sh
set -e
CASE_NAME=katrina1km # or katrina3km or katrina-ex
DATA_DIR=~/work/tutorial_data/Katrina
CASE_DIR=~/WRF_benchmarks/cases/$CASE_NAME
RUN_DIR=~/work/case_data/$CASE_NAME
WPS_DIR=~/work/WPSV3.9.1-intel18.0.1
WRF_DIR=~/work/WRFs/WRFV3.9.1.1-intel18.0.1-mpt2.18
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

$WPS_DIR/link_grib.csh $DATA_DIR/avn

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
