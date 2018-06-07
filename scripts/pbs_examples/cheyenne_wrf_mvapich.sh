#!/bin/bash
### Job Name
#PBS -N cheyenne_wrf
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

export TMPDIR=/glade/scratch/$USER/temp
mkdir -p $TMPDIR

ml reset
ml rm mpt/2.15f

export PATH=/glade/u/apps/ch/opt/mvapich2/2.2/gnu/7.1.0/bin/:$PATH

### Run the executable
mpirun_rsh -hostfile $PBS_NODEFILE -n 72 ./wrf.exe
