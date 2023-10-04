.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
# s0: filename, s1: a1(&rows), s2: a2(&cols), s3: matrix, s4: rows, s5:cols, s6:file
read_matrix:

    # Prologue
    addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)

    # initialize s register
    mv s0 a0
    mv s1 a1
    mv s2 a2

    # fopen
    mv a1 x0
    jal ra fopen
    mv s6 a0
    li t0 -1
    beq s6 t0 open_fail                 # if open_fail goto open_fail exit(27)

    # fread: read rows
    mv a0 s6
    mv a1 s1
    li a2 4
    jal ra fread
    mv t0 a0                            # save return value in t0
    li t1 4
    bne t0 t1 fread_fail                # if return value != 4 goto fread_fail exit(29)
    # fread: read cols
    mv a0 s6
    mv a1 s2
    li a2 4
    jal ra fread
    mv t0 a0
    li t1 4
    bne t0 t1 fread_fail

    # malloc matrix
    lw s4 0(s1)
    lw s5 0(s2)
    mul a0 s4 s5
    slli a0 a0 2
    jal ra malloc
    mv s3 a0
    beq s3 x0 malloc_fail               # if return value == 0 goto malloc_fail exit(26)

    # fread matrix
    mul s4 s4 s5                        # for (s4 = size of matrix, s5 = 0; s5 < s4; s5++)
    mv s5 x0
fread_loop:                             # fread(s6(file), s3+sizeof(int)*s5, 4)
    mv a0 s6
    slli t0 s5 2
    add a1 s3 t0
    li a2 4
    jal ra fread
    li t0 4
    bne a0 t0 fread_fail

    addi s5 s5 1                        # condition s5 < s4
    blt s5 s4 fread_loop

    # fclose
    mv a0 s6
    jal ra fclose
    li t0 -1
    beq t0 a0 fclose_fail               # if return value == -1 goto fclose_fail exit(28)

    mv a0 s3                            # return s3(matrix)
    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32

    jr ra

open_fail:
    li a0 27
    jal ra exit
fread_fail:
    li a0 29
    j exit
malloc_fail:
    li a0 26
    j exit
fclose_fail:
    li a0 28
    j exit