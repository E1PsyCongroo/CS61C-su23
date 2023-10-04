.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
# s0: dot value, s1: A dot step, s2: B dot step, s3: row of A, s4 col of B
matmul:
    # prologue
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    # Error checks
    li t0 1
    blt a1 t0 less_then_1               # if rows of A < 1
    blt a2 t0 less_then_1               # if cols of A < 1
    blt a4 t0 less_then_1               # if rows of B < 1
    blt a5 t0 less_then_1               # if cols of B < 1
    bne a2 a4 cant_mul                  # if cols of A not equal rows of B
    li s1 1                             # initialize step
    mv s2 a5
    li s3 0
    j outer_loop_start
less_then_1:
cant_mul:
    li a0 38                            # exit(36)
    j exit
outer_loop_start:
    beq s3 a1 outer_loop_end            # for (s3 = 0; s3 < rows of A; s3++)
    li s4 0
inner_loop_start:
    beq s4 a5 inner_loop_end            # for (s4 = 0; s4 < cols of B; s4++)
    # prologue
    addi sp sp -28
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw a3 12(sp)
    sw a4 16(sp)
    sw a5 20(sp)
    sw a6 24(sp)

    mul t0 s3 a2
    slli t0 t0 2
    add a0 a0 t0
    slli t0 s4 2
    add a1 a3 t0
    mv a2 a4
    mv a3 s1
    mv a4 s2
    jal ra dot                          # call dot(a0[s3:], a3[:s4], a4, s1, s2)
    mv s0 a0                            # store the return value in s0

    # epilogue
    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    lw a3 12(sp)
    lw a4 16(sp)
    lw a5 20(sp)
    lw a6 24(sp)
    addi sp sp 28

    sw s0 0(a6)                         # *a6 = s0 (the return)
    addi a6 a6 4                        # a6 += 4, next elem place

    addi s4 s4 1                        # s4++
    j inner_loop_start
inner_loop_end:
    addi s3 s3 1                        # s3++
    j outer_loop_start
outer_loop_end:
    # epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 24

    li a0 0                             # return None
    jr ra
