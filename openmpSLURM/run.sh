#! /bin/bash 
OUTPUT_FILE=ejecutables/sumaSimple
INPUT_FILE=codigo_fuente/summaSimple.c
BK_DIR="bk_slurm"
SBATCH_PATH=codigo_fuente/run.sbatch

# Takes the input number 
#read -p "Digite un numero entero " number
#echo $number

# Makes the dir to store the slurm files if not exists already
if [[ ! -d "$BK_DIR" ]]; then  
  echo "Intenta crear el archivo de backup"
  mkdir "$BK_DIR"
fi

# Checks if the dir was successfully created
if [[ -d "$BK_DIR" ]]; then  
  echo "Removiendo archivos slurm"
  mv $(find . -maxdepth 1 -name "slurm*") -t  "$BK_DIR"

else
  echo "Failed to remove slurm files, please delete them and try again."
  exit 1
fi

echo "Compilando archivo..."
sbatch $SBATCH_PATH $INPUT_FILE $OUTPUT_FILE 

while :
do 
  echo "Esperando respuesta de guane..."
  resultados=$(find . -maxdepth 1 -name "slurm*")
  if [[ ! -z $resultados ]]; then
    printf "\n\n"
    echo "##########################################"
    echo "########### EJECUCION PROGRAMA ###########"
    echo "##########################################"
    printf "\n\n"
    #cat $resultados
    ./"$OUTPUT_FILE"
    break
  fi
  sleep 1
done

