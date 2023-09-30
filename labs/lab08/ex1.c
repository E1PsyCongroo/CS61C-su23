#include "ex1.h"

void v_add_naive(double* x, double* y, double* z) {
    #pragma omp parallel
    {
        for(int i=0; i<ARRAY_SIZE; i++)
            z[i] = x[i] + y[i];
    }
}

// Adjacent Method
void v_add_optimized_adjacent(double* x, double* y, double* z) {
    // TODO: Implement this function
    // Do NOT use the `for` directive here!
    #pragma omp parallel
    {
        for (int i = omp_get_thread_num(); i < ARRAY_SIZE; i += omp_get_num_threads()) {
            z[i] = x[i] + y[i];
        }
    }
}

// Chunks Method
void v_add_optimized_chunks(double* x, double* y, double* z) {
    // TODO: Implement this function
    // Do NOT use the `for` directive here!
    const int threads_num = omp_get_num_threads();
    const int block_size = ARRAY_SIZE / threads_num;
    #pragma omp parallel
    {
        for (int i = block_size * omp_get_thread_num(); i < block_size; i++) {
            z[i] = x[i] + y[i];
        }
    }
    for (int i = ARRAY_SIZE / threads_num * threads_num; i < ARRAY_SIZE; i++) {
        z[i] = x[i] + y[i];
    }
}
