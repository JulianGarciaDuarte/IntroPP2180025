// From https://www.programiz.com/c-programming/c-for-loop 
// Modified by C. Barrios for training purposes 2023
// Simple Program to calculate the sum of first n natural numbers
// Positive integers 1,2,3...n are known as natural numbers
#include <stdio.h>
#include <mpi.h>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    double startTime = MPI_Wtime();

    int localSum = 0;
    int start = rank * (100 / size) + 1;  // Calculate the starting number for each process
    int end = (rank + 1) * (100 / size);  // Calculate the ending number for each process

    for (int i = start; i <= end; i++) {
        localSum += i;  // Calculate the local sum for each process
    }

    int globalSum = 0;
    MPI_Reduce(&localSum, &globalSum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    double endTime = MPI_Wtime();

    if (rank == 0) {
        FILE* file = fopen("result.txt", "w");
        if (file != NULL) {
            fprintf(file, "Sum: %d\n", globalSum);
            fprintf(file, "Execution time: %f seconds\n", endTime - startTime);
            fclose(file);
        } else {
            printf("Error opening the file for writing.\n");
        }
    }

    MPI_Finalize();
    return 0;
}
