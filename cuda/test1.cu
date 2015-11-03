
#include <stdio.h>


__global__ void add_integers(int* a, int* b, int* c)
{
  *c = *a + *b;
}

__global__ void mykernel(void) {
}

int main(void) {
    int a, b, c;
    int *d_a, *d_b, *d_c;
    int size = sizeof(int);

    cudaMalloc((void **) &d_a, size);
    cudaMalloc((void **) &d_b, size);
    cudaMalloc((void **) &d_c, size);

    a = 2;
    b = 7;

    cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice);
    add_integers<<<1,1>>>(d_a, d_b, d_c);
    cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost);
    
    printf("The answer is %d\n", c);
    return 0;
}
