#!/bin/bash

#SBATCH -J cpujob
#SBATCH -A VENDRUSCOLO-SL3-CPU
#SBATCH -p skylake
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --mail-type=ALL
##SBATCH --no-requeue


module purge
module load openmpi/gcc/9.2/4.0.2 fftw-3.3.8-gcc-9.2.0-fdmsymx cmake-3.19.7-gcc-5.4-5gbsejo

export PATH=/home/al2108/rds/hpc-work/opt/plumed-2.7.4/bin:$PATH
export LD_LIBRARY_PATH=/home/al2108/rds/hpc-work/opt/plumed-2.7.4/lib:$LD_LIBRARY_PATH
export PATH=/home/al2108/rds/hpc-work/opt/gromacs-2018.8-eef/bin:$PATH
export PLUMED_NUM_THREADS=${SLURM_CPUS_PER_TASK}



#mpirun -n 32 gmx_mpi mdrun -s topol -cpi state -multidir conf{0..31} -plumed ../plumed.dat -v -maxh 12 -cpt 60 -cpnum -noappend -nb gpu -ntomp ${SLURM_CPUS_PER_TASK} &>> log

mpiexec --mca btl '^openib' -np 32 gmx_mpi mdrun -s topol.tpr -multidir conf{0..31} -plumed ../plumed.dat -v -nsteps -1 -maxh .1 -ntomp ${SLURM_CPUS_PER_TASK} &> log

