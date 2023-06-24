#include <stdio.h>


__global__ void sumParallel(int *dev_sum, int num)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    while (tid <= num)
    {

	/* se usa la función atomicAdd para realizar la sumatoria y  garantizar que varios hilos no vayan a escribir simultáneamente en la misma ubicación de memoria. */
        atomicAdd(dev_sum, (int)tid);
        tid += stride; //coge el identificado unico de cada hilo y le agrega el paso para pasar al siguiente hilo
    }
}

int cuda_suma_simple(int num)
{
    int sum = 0;

    int *dev_sum; //referencia de la variable que se ubicara en el device

  
    cudaMalloc((void**)&dev_sum, sizeof(int)); //reservamos espacio de memoria
    cudaMemcpy(dev_sum, &sum, sizeof(int), cudaMemcpyHostToDevice); //copaimos la variable desde el host al sum

    int blockSize = 256;
    int gridSize = (num + blockSize - 1) / blockSize;

    sumParallel<<<gridSize, blockSize>>>(dev_sum, num); //invocamos el kernel sumParallel que es el que se encarga de realizar la suma
    
    cudaMemcpy(&sum, dev_sum, sizeof(int), cudaMemcpyDeviceToHost); //copiamos el resultado ahora en sentido contrario, es decir desde el device hasta el host
    cudaFree(dev_sum); //liberamos la memoria reservada

    return sum;
}
int sec_suma_simple(int num){
    int resultado = 0;
    for(int i=0; i<=num; i++){
         resultado+=i;
    }
    return resultado;
}
float run_cuda_suma_simple(int num){

     /*Inicializamos las variables con las cuales tomaremos el tiempo */
    cudaEvent_t start, stop;
    float elapsedTime;
 
    // Toma el tiempo del acelerado por gpu
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0); //comienza a tomar el tiempo

    int result = cuda_suma_simple(num);
    printf("Resultado Cuda = %d\n", result);

    cudaEventRecord(stop, 0); //para de tomar el tiempo
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime, start, stop);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    return elapsedTime;
}

float run_sec_suma_simple(int num){
 
     /*Inicializamos las variables con las cuales tomaremos el tiempo */
    cudaEvent_t start, stop;
    float elapsedTime;
 
    // Toma el tiempo del acelerado por gpu
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0); //comienza a tomar el tiempo


    int result = sec_suma_simple(num);
    printf("Resultado Secu = %d\n", result);

    cudaEventRecord(stop, 0); //para de tomar el tiempo
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime, start, stop);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    return elapsedTime;
}   

int main(){
    float run_time_sec, run_time_cuda;
    int num = 0;
    for (int i=0; i<=10; i++){
        printf("\n\n");
        num = pow(10, i);
        run_time_cuda = run_cuda_suma_simple(num);
        run_time_sec = run_sec_suma_simple(num);

        printf("Comparacion para n = %d\n", num);	
        printf("Tiempo Cuda (milisegundos)       = %f\n", run_time_cuda); 
        printf("Tiempo Secuencial (milisegundos) = %f\n", run_time_sec); 


        int blockSize = 256;
        int gridSize = (num + blockSize - 1) / blockSize;
        int numThreads = gridSize * blockSize;
        double speedup = run_time_cuda / run_time_sec;
        double scalability = run_time_sec / (run_time_cuda * numThreads);

        printf("Speedup: %.2f\n", speedup);
        printf("Escalabilidad: %.2f\n", scalability);

        int numOperations = num - 1;  // Número de operaciones de punto flotante realizadas
        double performance = numOperations / (run_time_cuda * 1e6);  // Rendimiento computacional en FLOPS
        printf("Performance: %.2f FLOPS\n", performance);
  
  
   }

}
