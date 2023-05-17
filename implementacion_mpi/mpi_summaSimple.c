// From https://www.programiz.com/c-programming/c-for-loop 
// Modified by C. Barrios for training purposes 2023
// Simple Program to calculate the sum of first n natural numbers
// Positive integers 1,2,3...n are known as natural numbers

#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv[])
{
    FILE *saving_file;
    int num, count, globalSum= 0;
    double exec_time, start_timer, end_timer;
    
    // Asks for the number
    printf("Digite un numero entero positivo ");
    scanf("%d", &num);

    //Starts running time
    start_timer=omp_get_wtime();

    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int localSum = 0;
    int start = rank * (num / size) + 1;  // Calculate the starting number for each process
    int end = (rank + 1) * (num / size);  // Calculate the ending number for each process

    for (count = start; i <= end; i++) {
        localSum += i;  // Calculate the local sum for each process
    }

    MPI_Reduce(&localSum, &globalSum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Sum: %d\n", globalSum);
    }

    MPI_Finalize();

    // Ends time
    end_timer=omp_get_wtime();
    exec_time=(end_timer - start_timer);

    printf("\nSum = %d\n", sum);

    // Saves the results into a text file
    saving_file=fopen("output_summaSimple.txt", "w");
    fprintf(saving_file, "Calculo de la suma de los %d primero numeros naturales", num);
    fprintf(saving_file, "\nResultado: %d", sum);
    fprintf(saving_file, "\nEl tiempo de ejecucion del procedimiento fue: %d microsegundos\n", (int) (exec_time*1000000));
    fclose(saving_file);

    return 0;
}
