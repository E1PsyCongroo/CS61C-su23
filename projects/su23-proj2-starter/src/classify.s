.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
# s0: a1, s1: matrix0, s2: matrix1, s3: input_matrix, s4: output_matrix, s5: output_file
# s6: a2(mode), s7: matrix h, s8: matrix sixe array
classify:
    # prologue
    addi sp sp -40
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)

    # judge argc
    li t0 5
    bne t0 a0 argc_error

    # init s0, s6
    mv s0 a1
    mv s6 a2
    lw s5 16(s0)

    # init s8
    addi a0 x0 40
    call malloc
    mv s8 a0
    beq s8 x0 malloc_fail

    # Read pretrained m0
    ebreak
    lw a0 4(s0)
    addi a1 s8 0
    addi a2 s8 4
    call read_matrix
    mv s1 a0

    # Read pretrained m1
    ebreak
    lw a0 8(s0)
    addi a1 s8 8
    addi a2 s8 12
    call read_matrix
    mv s2 a0

    # Read input matrix
    ebreak
    lw a0 12(s0)
    addi a1 s8 16
    addi a2 s8 20
    call read_matrix
    mv s3 a0

    # malloc matrix h
    lw t0 0(s8)                         # t0 = rows of matrix0
    lw t1 20(s8)                        # t1 = cols of input_matrix
    sw t0 24(s8)
    sw t1 28(s8)
    mul a0 t0 t1                        # a1 = t0 * t1 = size of (matrix0 * input_matrix)
    slli a0 a0 2
    call malloc
    mv s7 a0
    beq s7 x0 malloc_fail

    # Compute h = matmul(m0, input)
    ebreak
    mv a0 s1                            # a0 = matrix0
    lw a1 0(s8)                         # a1 = rows of matrix0
    lw a2 4(s8)                         # a2 = cols of matrix0
    mv a3 s3                            # a3 = input_matrix
    lw a4 16(s8)                        # a4 = rows of input_matrix
    lw a5 20(s8)                        # a5 = cols of input_matrix
    mv a6 s7                            # a6 = matrix h
    call matmul                         # matmul(matrix0, rof0, cof0, input_matrix, rofi, cofi, matrixh)

    # Compute h = relu(h)
    ebreak
    mv a0 s7                            # a0 = s7
    lw t0 24(s8)
    lw t1 28(s8)
    mul a1 t0 t1
    call relu

    # malloc output_matrix
    lw t0 8(s8)                         # t0 = rows of matrix1
    lw t1 28(s8)                        # t1 = cols of matrixh
    sw t0 32(s8)
    sw t1 36(s8)
    mul a0 t0 t1                        # a1 = t0 * t1 = size of (matrix1 * matrixh)
    slli a0 a0 2
    call malloc
    mv s4 a0
    beq s4 x0 malloc_fail

    # Compute o = matmul(m1, h)
    ebreak
    mv a0 s2
    lw a1 8(s8)
    lw a2 12(s8)
    mv a3 s7
    lw a4 24(s8)
    lw a5 28(s8)
    mv a6 s4
    call matmul

    # Write output matrix o
    ebreak
    mv a0 s5
    mv a1 s4
    lw a2 32(s8)
    lw a3 36(s8)
    call write_matrix

    # Compute and return argmax(o)
    ebreak
    mv a0 s4
    lw t0 32(s8)
    lw t1 36(s8)
    mul a1 t0 t1
    call argmax
    mv s0 a0                            # store return value in s0

    # If enabled, print argmax(o) and newline
    ebreak
    bne s6 x0 jump
    mv a0 s0
    call print_int
    li a0 '\n'
    call print_char
jump:
    # free
    mv a0 s4
    call free
    mv a0 s7
    call free
    mv a0 s8
    call free

    mv a0 s0                            # return result
    # epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    addi sp sp 40

    ebreak
    jr ra

malloc_fail:
    li a0 26
    j exit
argc_error:
    li a0 31
    j exit