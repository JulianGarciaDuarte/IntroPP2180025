#include <stdio.h>


__global__ void sumParallel(int *dev_sum, int num)
{
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    while (tid <= num)
    {

	    // Se calcula el identificador único del hilo sumando el índice del hilo en el bloque con el índice del bloque en la rejilla multiplicado por el tamaño del bloque.
        // Este identificador único se utiliza para determinar qué datos procesa cada hilo.
        // Cada hilo procesará una parte de los datos de entrada.
        // Cada hilo calculará la suma parcial de sus datos asignados.
        // Dependiendo del tamaño del bloque y la rejilla, varios hilos pueden procesar datos diferentes en paralelo.
        // Esta técnica se utiliza para realizar operaciones de suma en paralelo y mejorar el rendimiento en GPUs.
        atomicAdd(dev_sum, (int)tid);

        // Se actualiza el identificador único del hilo sumándole el stride.
        // Esto permite que cada hilo pase al siguiente conjunto de datos que debe procesar.
        tid += stride;
    }
}

int cuda_suma_simple(int num){
    int sum = 0; // Variable para almacenar la suma

    int *dev_sum; // Puntero a la variable de suma en el dispositivo (GPU)

    // Asignar memoria en el dispositivo (GPU) para la variable de suma
    cudaMalloc((void**)&dev_sum, sizeof(int));

    // Copiar el valor inicial de la suma desde el host (CPU) al dispositivo (GPU)
    cudaMemcpy(dev_sum, &sum, sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256; // Número de hilos en un bloque
    int gridSize = (num + blockSize - 1) / blockSize; // Número de bloques en la cuadrícula

    // Ejecutar el kernel sumParallel para realizar la suma en paralelo en el GPU
    sumParallel<<<gridSize, blockSize>>>(dev_sum, num);

    // Copiar el resultado de la suma desde el dispositivo (GPU) al host (CPU)
    cudaMemcpy(&sum, dev_sum, sizeof(int), cudaMemcpyDeviceToHost);

    // Liberar la memoria asignada en el dispositivo (GPU)
    cudaFree(dev_sum);

    return sum; // Devolver la suma calculada
}

int sec_suma_simple(int num){
    int resultado = 0; // Variable para almacenar la suma

    // Ciclo de suma secuencial
    for(int i = 0; i <= num; i++){
         resultado += i; // Sumar el valor de i al resultado
    }

    return resultado; // Devolver la suma calculada
}

float run_cuda_suma_simple(int num){

    cudaEvent_t start, stop; // Variables para medir el tiempo de ejecución
    float elapsedTime; // Variable para almacenar el tiempo transcurrido
 
    cudaEventCreate(&start); // Crear el evento de inicio
    cudaEventCreate(&stop); // Crear el evento de fin
    cudaEventRecord(start, 0); // Registrar el inicio de la medición del tiempo

    int result = cuda_suma_simple(num); // Llamar a la función para calcular la suma en GPU
    printf("Resultado Cuda = %d\n", result); // Imprimir el resultado de la suma calculada en GPU

    cudaEventRecord(stop, 0); // Registrar el fin de la medición del tiempo
    cudaEventSynchronize(stop); // Sincronizar los eventos para asegurar la finalización
    cudaEventElapsedTime(&elapsedTime, start, stop); // Calcular el tiempo transcurrido

    cudaEventDestroy(start); // Destruir el evento de inicio
    cudaEventDestroy(stop); // Destruir el evento de fin
    return elapsedTime; // Devolver el tiempo transcurrido
}

float run_sec_suma_simple(int num){
 
    cudaEvent_t start, stop; // Variables para medir el tiempo de ejecución
    float elapsedTime; // Variable para almacenar el tiempo transcurrido

    cudaEventCreate(&start); // Crear el evento de inicio
    cudaEventCreate(&stop); // Crear el evento de fin
    cudaEventRecord(start, 0); // Registrar el inicio de la medición del tiempo

    int result = sec_suma_simple(num); // Llamar a la función para calcular la suma de forma secuencial
    printf("Resultado Secu = %d\n", result); // Imprimir el resultado de la suma calculada de forma secuencial

    cudaEventRecord(stop, 0); // Registrar el fin de la medición del tiempo
    cudaEventSynchronize(stop); // Sincronizar los eventos para asegurar la finalización
    cudaEventElapsedTime(&elapsedTime, start, stop); // Calcular el tiempo transcurrido

    cudaEventDestroy(start); // Destruir el evento de inicio
    cudaEventDestroy(stop); // Destruir el evento de fin
    return elapsedTime; // Devolver el tiempo transcurrido
}

int main() {
    float run_time_sec, run_time_cuda;
    int num = 0;

    for (int i = 0; i <= 10; i++) {
        printf("\n\n");
	    printf("Comparacion para n = %d\n", num);	

        num = pow(10, i);

        // Ejecutar cálculo de la suma utilizando CUDA
        run_time_cuda = run_cuda_suma_simple(num);

        // Ejecutar cálculo de la suma de forma secuencial
        run_time_sec = run_sec_suma_simple(num);

        printf("Tiempo Cuda (milisegundos)       = %f\n", run_time_cuda); 
        printf("Tiempo Secuencial (milisegundos) = %f\n", run_time_sec); 

        int blockSize = 256;
        int gridSize = (num + blockSize - 1) / blockSize;
        int numThreads = gridSize * blockSize;

        // Calcular el speedup y la escalabilidad
        double speedup = run_time_sec / run_time_cuda;
        double scalability = run_time_sec / (run_time_cuda * numThreads);

        printf("Speedup: %.2f\n", speedup);
        printf("Escalabilidad: %.2f\n", scalability);

        int numOperations = num - 1;  // Número de operaciones de punto flotante realizadas
        double performance = numOperations / (run_time_cuda * 1e6);  // Rendimiento computacional en FLOPS

        printf("Performance: %.2f FLOPS\n", performance);
    }
}

