#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];       // dst[x][y] = src[y][x]
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
    const int block_module = n % blocksize;
    const int block_num = n / blocksize + (block_module == 0 ? 0 : 1);
    for (int i = 0; i < block_num; i++) {
        for (int j = 0; j < block_num; j++) {
            const int actual_block_row = ((block_module != 0) && (i == block_num - 1)) ? block_module : blocksize;
            const int actual_block_col = ((block_module != 0) && (j == block_num - 1)) ? block_module : blocksize;
            for (int x = 0; x < actual_block_row; x++) {
                for (int y = 0; y < actual_block_col; y++) {
                    dst[(y + j * blocksize) + ((x + i * blocksize) * n)] = src[(x + i * blocksize) + ((y + j * blocksize) * n)];
                    // dst[x + i * blocksize][y + j * blocksize] =  src[x + i * blocksize][y + j * blocksize]
                }
            }
        }
    }
}
