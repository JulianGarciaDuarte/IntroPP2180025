include <stdio.h>

__global__ void sumaSimple(int n, int *result) {
    int tid=threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;
    int partialSum = 0;

    for (int i = tid + 1; i <= n; i += stride){
     	partialSum += 1;
    }

    atomicAdd(result, partialSum);
}

int main() {
    float hostResult = 0;

    // Sets the size of the numbers
    int n = 100000;

    // Declara y ubica la memoria del lado del host
    int *devResult;
    cudaMalloc((void**)&devResult, sizeof(int));
    
    // Copia los datos de entrada del host al dispositivo
    cudaMemcpy(devResult, &hostResult, sizeof(int), cudaMemcpyHostToDevice);
    
    // Set block and grid dimentions
    int blocksize=256;
    int gridSize = (n + blockSize - 1)/blockSize;
    
    // Lanza el kernel
    sumaSimple<<<gridSize, blockSize>>>(n, devResult);

    // Copia el resultado de regreso a la memoria del host
    cudaMemcpy(&hostResult, devResult, sizeof(int), cudaMemcpyDeviceToHost);
    
    // Libera la memoria del dispositivo
    cudaFree(devResult);
    
    // Muestra el resultado
    printf("La suma de los primeros %d numeros naturales is %d/n", n, hostResult);
    return 0;
}

