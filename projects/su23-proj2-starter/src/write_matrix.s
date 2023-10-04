.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
# s0: a1(matrix), s1: a2(rows), s2:a3(cols), s3:file(return of fopen)
write_matrix:

    # Prologue
    addi sp sp -20
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)

    # init
    mv s0 a1
    mv s1 a2
    mv s2 a3

    # fopen
    li a1 1
    call fopen
    mv s3 a0
    li t0 -1                        # s3 = fopen(a0, 1)
    beq s3 t0 fopen_fail            # if return value == -1 goto fopen_fail


    # fwrite rows and cols
    addi sp sp -8
    sw s1 0(sp)
    sw s2 4(sp)
    mv a0 s3
    mv a1 sp
    li a2 2
    li a3 4
    call fwrite
    li t0 2
    bne a0 t0 fwrite_fail
    addi sp sp 8

    # fwrite matrix
    mv a0 s3
    mv a1 s0
    mul a2 s1 s2
    li a3 4
    call fwrite                     # fwrite(s3(file), s0(matrix), s2*s3(rows * cols), s3(4:sizeof(int)))
    mv t0 a0
    mul t1 s1 s2
    bne t0 t1 fwrite_fail           # if return value != rows * cols goto fwrite_fail

    # fclose
    mv a0 s3
    call fclose
    bne a0 x0 fclose_fail           # if return value != 0 goto fclose_fail

    # return value                  return None
    mv a0 x0

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    addi sp sp 20

    jr ra

fopen_fail:
    li a0 27
    j exit
fwrite_fail:
    li a0 30
    j exit
fclose_fail:
    li a0 28
    j exit