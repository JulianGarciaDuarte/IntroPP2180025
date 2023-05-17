// From https://www.programiz.com/c-programming/c-for-loop 
// Modified by C. Barrios for training purposes 2023
// Simple Program to calculate the sum of first n natural numbers
// Positive integers 1,2,3...n are known as natural numbers

#include <stdio.h>
#include <omp.h>

int main(int argc, char *argv[])
{
    int num, count, sum = 0;

    printf("Enter a positive integer: ");
    scanf("%d", &num);
    // num =(int) *argv[0];
    //printf("%d", num);

    // for loop terminates when num is less than count
    #pragma omp parallel for reduction(+:sum) 
    for(count = 1; count <= num; ++count)
    {
        sum += count;
	//printf("%d\n", sum);
    }

    printf("\nSum = %d\n", sum);

    return 0;
}
