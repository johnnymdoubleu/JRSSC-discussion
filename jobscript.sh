#!/bin/sh
# Grid Engine options (lines prefixed with #$)
#$ -N runEx2
#$ -cwd
#$ -l h_rt=23:59:59 
#$ -l h_vmem=64G

#  These options are:
#  job name: -N
#  use the current working directory: -cwd
#  runtime limit of 5 minutes: -l h_rt
#  memory limit of 1 Gbyte: -l h_vmem

#$ -m e
#$ -M s1687781@ed.ac.uk

#$ -t 1-25
#$ -tc 50

# Initialise the environment modules
. /etc/profile.d/modules.sh

# Load R modules
module load R/4.3.0

cd /home/s1687781/discussion/
R_LIBS=/home/s1687781/R/x86_64-pc-linux-gnu-library/4.3/

# Run the program
Rscript ./work_ex2.R $SGE_TASK_ID
