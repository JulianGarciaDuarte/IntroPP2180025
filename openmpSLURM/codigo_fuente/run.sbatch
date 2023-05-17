#!/bin/bash

## Parametros de configuracion
#SBATCH --partition=normal
#SBATCH --ntasks=2
#SBATCH --gres=gpu:1
#
## Modulos de ambiente
#
## Ejecucion
#

source_file=$1
destination_file=$2

gcc -fopenmp "$source_file" -o "$destination_file" -lm
./"$destination_file" 


