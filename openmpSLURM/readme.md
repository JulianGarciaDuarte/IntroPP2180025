# Codigo para ejecutar la suma simple paralelizada en guane (servidor remoto UIS)

## Para ejecutar
1. Ejecutar el archivo run.sh.
2. Digitar un entero.

run.sh guarda los archivos slurm que existan de previas ejecuciones en bk_slurm, envia el trabajo a guane de compilar el codigo para summaSimple.c mediante un script sbatch y ejecuta el resultado de la compilacion.

## Descripcion de carpetas

- ejecutables: Carpeta que contiene el output de la compilacion para el archivo de sumaSimple.

- codigo_fuente: Contiene el codigo fuente tanto del archivo a compilar de summaSimple.c como el script para compilarlo sobre la infraestructura de Guane.

- bk_slurm: Contiene todos los archivos slurm que son obtenidos luego de enviar el script run.sbatch (Excepto el de la ultima ejecucion, el cual esta al nivel del directorio raiz del proyecto.
