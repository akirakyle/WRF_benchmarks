#!/bin/bash
### Job Name
#PBS -N WRFV3.9.1.1-intel-dmpar-mpt2.18-conus12km
### Project code
#PBS -A SCSG0002
#PBS -l walltime=00:20:00
#PBS -q regular
### Merge output and error files
#PBS -j oe
### Select 2 nodes with 36 CPUs each for a total of 72 MPI processes
#PBS -l select=2:ncpus=36:mpiprocs=36
### Send email on abort, begin and end
#PBS -m abe
### Specify mail recipient
#PBS -M akirak@ucar.edu

set -e

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

WRF_NAME=WRFV3.8.1-intel-dmpar-mpt2.18
CASE_NAME=conus12km

RUN_DIR=~/work/run/$CASE_NAME/$WRF_NAME/test
mkdir -p $RUN_DIR
cd $RUN_DIR

ln -s ~/work/cases/$CASE_NAME/* .
ln -s ~/work/WRFs/$WRF_NAME/run/* .

### Run the executable
./mpirun_wrf

