#include "ex2.h"

double dotp_naive(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    for (int i = 0; i < arr_size; i++)
        global_sum += x[i] * y[i];
    return global_sum;
}

// Critical Keyword
double dotp_critical(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Use the critical keyword here!
    #pragma omp parallel
    {
        #pragma omp for
        for (int i = 0; i < arr_size; i++) {
            #pragma omp critical
            {
                global_sum += x[i] * y[i];
            }
        }
    }
    return global_sum;
}

// Reduction Keyword
double dotp_reduction(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Use the reduction keyword here!
    #pragma omp parallel reduction(+ : global_sum)
    {
        #pragma omp for
        for (int i = 0; i < arr_size; i++) {
            global_sum += x[i] * y[i];
        }
    }
    return global_sum;
}

// Manual Reduction
double dotp_manual_reduction(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Do NOT use the `reduction` directive here!
    #pragma omp parallel
    {
        double native_sum = 0;
        #pragma omp for
        for (int i = 0; i < arr_size; i++) {
            native_sum += x[i] * y[i];
        }
        #pragma omp critical
        {
            global_sum += native_sum;
        }
    }
    return global_sum;
}
