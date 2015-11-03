
#include <stdio.h>
#define N 2048 * 2048
#define THREADS_PER_BLOCK 512


__global__ void add_integers(int* a, int* b, int* c)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    c[index] = a[index] + b[index];
}

void random_ints(int* arr, const int n_elements)
{
    for ( int i = 0; i < n_elements; ++i)
    {
        arr[i] = i;
    }
}


int main(void) {
    int *a, *b, *c;
    int *d_a, *d_b, *d_c;
    int size = N * sizeof(int);

    cudaMalloc((void **) &d_a, size);
    cudaMalloc((void **) &d_b, size);
    cudaMalloc((void **) &d_c, size);

    a = (int *)malloc(size); random_ints(a, N);
    b = (int *)malloc(size); random_ints(b, N);
    c = (int *)malloc(size); random_ints(c, N);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
    printf("Starting Kernel\n");
    add_integers<<<N/ THREADS_PER_BLOCK, THREADS_PER_BLOCK>>>(d_a, d_b, d_c);
    printf("Kernel Complete!\n");
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    printf("Iterating\n");
    for ( int i = 0; i < N; ++i)
    {
        c[i] = a[i] + b[i];
    }
    printf("Iterating Complete\n");
    free(a);
    free(b);
    free(c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return 0;
}
