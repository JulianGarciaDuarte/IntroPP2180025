#include <stdio.h>
#include <math.h>
#include <mpi.h>

/* Define the function to be integrated here: */
double f(double x){
  return x*x;
}

/*Program begins*/
int main(int argc, char** argv){
  int rank, size, i, n;
  double a, b, h, x, local_sum=0, total_sum;
  double start, end, elapsedTime;
  double speedup, scalability, performance;
  double integral;

  // MPI initialization
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  if(rank == 0){ // Input data provided by rank 0
    printf("\nEnter the no. of sub-intervals: ");
    scanf("%d",&n);
    printf("\nEnter the initial limit: ");
    scanf("%lf",&a);
    printf("\nEnter the final limit: ");
    scanf("%lf",&b);
  }

  // Broadcast input data to all ranks
  MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast(&a, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(&b, 1, MPI_DOUBLE, 0, MPI_COMM_WORLD);

  // Calculate the width of each sub-interval
  h = fabs(b-a)/n;

  start = MPI_Wtime();

  for(i = rank + 1; i < n; i+=size){ // Perform the local sum calculation for each rank
    x = a + i*h;
    local_sum = local_sum + f(x);
  }

  // Reduce the local sums to obtain the total sum
  MPI_Reduce(&local_sum, &total_sum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

  end = MPI_Wtime();
  elapsedTime = end - start;

  if(rank == 0){ // Rank 0 calculates and prints the final result
    integral = (h/2)*(f(a)+f(b)+2*total_sum);
    printf("\nThe integral is: %lf\n", integral);
  }

  // MPI finalization
  MPI_Finalize();

  // Calculate performance metrics
  double sequentialTime = integral;
  double parallelTime = elapsedTime;
  speedup = sequentialTime / parallelTime;
  scalability = sequentialTime / (parallelTime * size);
  performance = (n * 4) / elapsedTime;  // Number of floating point operations (2 multiplications and 2 additions) per iteration

  // Print performance metrics
  if(rank == 0) {
    printf("Elapsed Time: %.6f seconds\n", elapsedTime);
    printf("Speedup: %.2f\n", speedup);
    printf("Scalability: %.2f\n", scalability);
    printf("Performance: %.2f flops/sec\n", performance);
  }

  return 0;
}