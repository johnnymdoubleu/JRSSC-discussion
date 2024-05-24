#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N test                               
#$ -l h_rt=2:00:00 
#$ -l h_vmem=20G

#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 5 minutes: -l h_rt
#  memory limit of 1 Gbyte: -l h_vmem

#$ -o /exports/eddie/scratch/jricha3/Discussion/Err_out/$JOB_NAME/$JOB_ID/$TASK_ID.out
#$ -e /exports/eddie/scratch/jricha3/Discussion/Err_out/$JOB_NAME/$JOB_ID/$TASK_ID.err

#$ -M jricha3@ed.ac.uk

#$ -t 1-50

#$ -tc 50

# Initialise the environment modules
. /etc/profile.d/modules.sh


# Load 
module load R/4.3.0
cd /exports/eddie/scratch/jricha3/Discussion/
R_LIBS=../R/x86_64-pc-linux-gnu-library/4.3/

# Run the program
Rscript work_ex4.R $SGE_TASK_ID
