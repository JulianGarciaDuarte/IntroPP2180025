#include <stdio.h>


__global__ void sumParallel(int *dev_sum, int num)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    while (tid <= num)
    {

	/* se usa la función atomicAdd para realizar la sumatoria y  garantizar que varios hilos no vayan a escribir simultáneamente en la misma ubicación de memoria. */
        atomicAdd(dev_sum, tid);
        tid += stride; //coge el identificado unico de cada hilo y le agrega el paso para pasar al siguiente hilo
    }
}

int main()
{
    int num, sum = 0;
    int *dev_sum; //referencia de la variable que se ubicara en el device

     /*Inicializamos las variables con las cuales tomaremos el tiempo */
    cudaEvent_t start, stop;
    float elapsedTime;
   
    printf("Enter a positive integer: ");
    scanf("%d", &num);

    cudaMalloc((void**)&dev_sum, sizeof(int)); //reservamos espacio de memoria
    cudaMemcpy(dev_sum, &sum, sizeof(int), cudaMemcpyHostToDevice); //copaimos la variable desde el host al sum

    int blockSize = 256;
    int gridSize = (num + blockSize - 1) / blockSize;

    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0); //comienza a tomar el tiempo

    sumParallel<<<gridSize, blockSize>>>(dev_sum, num); //invocamos el kernel sumParallel que es el que se encarga de realizar la suma
    
    cudaEventRecord(stop, 0); //para de tomar el tiempo
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime, start, stop);

    cudaMemcpy(&sum, dev_sum, sizeof(int), cudaMemcpyDeviceToHost); //copiamos el resultado ahora en sentido contrario, es decir desde el device hasta el host
    cudaFree(dev_sum); //liberamos la memoria reservada

    printf("\nSum = %d\n", sum); //imprimimos el resultado de la suma

    printf("Elapsed Time: %.6f segundos\n", elapsedTime/1000); //me imprime el tiempo que demoro

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
