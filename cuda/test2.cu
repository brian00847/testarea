
#include <stdio.h>
#define N 512


__global__ void add_integers(int* a, int* b, int* c)
{
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
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
    c = (int *)malloc(size);random_ints(c, N);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
    add_integers<<<N,1>>>(d_a, d_b, d_c);
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
    
    for ( int i = 0; i < N; ++i)
    {
        printf("%d + %d = %d\n", a[i], b[i], c[i]);
    }
    free(a);
    free(b);
    free(c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return 0;
}
