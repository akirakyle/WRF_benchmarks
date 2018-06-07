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

WRF_NAME=WRFV3.9.1.1-intel-dmpar-mpt2.18
RUN_DIR=~/work/run/conus12km/$WRF_NAME/2nodes
mkdir -p $RUN_DIR
cd $RUN_DIR

# link the necessary files into the run directory
ln -s ~/work/cases/conus12km/* .
ln -s ~/work/WRFs/$WRF_NAME/run/* .

module load $WRF_NAME

### Run the executable
mpiexec_mpt ./wrf.exe

