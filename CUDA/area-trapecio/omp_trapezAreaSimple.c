#include<stdio.h>
#include<math.h>
#include<omp.h>
#include<sys/time.h>

/* Define the function to be integrated here: */
double f(double x) {
  return x * x;
}

int main() {
  int n, i;
  double a, b, h, x, sum = 0, integral;
  struct timeval start, end;

  /* Ask the user for necessary input */
  printf("\nEnter the number of sub-intervals: ");
  scanf("%d", &n);
  printf("\nEnter the initial limit: ");
  scanf("%lf", &a);
  printf("\nEnter the final limit: ");
  scanf("%lf", &b);

  /* Begin Trapezoidal Method */
  h = fabs(b - a) / n;

  gettimeofday(&start, NULL);  // Start timing

#pragma omp parallel for private(i, x) reduction(+:sum)
  for (i = 1; i < n; i++) {
    x = a + i * h;
    sum += f(x);
  }

  integral = (h / 2) * (f(a) + f(b) + 2 * sum);

  gettimeofday(&end, NULL);  // Stop timing

  /* Calculate elapsed time in seconds */
  double elapsedTime = (end.tv_sec - start.tv_sec) + (end.tv_usec - start.tv_usec) / 1000000.0;

  /* Calculate metrics */
  double speedup = elapsedTime / 0.000318;
  double scalability = speedup / omp_get_max_threads();
  double flops = (double)n * 4;  // 4 floating-point operations per iteration
  double performance = flops / elapsedTime;

  /* Print the answer and metrics */
  printf("\nThe integral is: %lf\n", integral);
  printf("Elapsed Time: %.6f seconds\n", elapsedTime);
  printf("Speedup: %.2f\n", speedup);
  printf("Scalability: %.2f\n", scalability);
  printf("Performance: %.2f FLOPS/sec\n", performance);

  return 0;
}