.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue

loop_start:
    li t0 1
    bge a1 t0 loop_continue # if a1 < 1
    li a0 36                # exit(36)
    j exit
loop_continue:
    addi a1 a1 -1           # a1 -= 1
    lw t0 0(a0)             # t0 = *a0
    bge t0 x0 else          # if t0 < 0
    sw x0 0(a0)             # *a0 = 0
else:
    addi a0 a0 4            # a0 += 4 (next elem)
    bne a1 x0 loop_continue # if a1 == x0 break
loop_end:
    li a0 0

    # Epilogue


    jr ra
