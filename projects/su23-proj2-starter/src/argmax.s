.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue


loop_start:
    li t0 0                 # t0 = 0; result in t0, set t0 to 0
    li t3 0                 # cur index
    lw t1 0(a0)             # cur_max Astore in t1, set t1 to a0[0]
    li t2 1
    bge a1 t2 loop_continue # if a1 < 1
    li a0 36                # exit(36)
    j exit
loop_continue:
    addi t3 t3 1            # t3 += 1, cur index ++
    beq t3 a1 loop_end      # if cur index == size break
    addi a0 a0 4            # a0 += 4 (next elem)
    lw t2 0(a0)             # t2 = *a0, store next a0 elem in t2
    bge t1 t2 else          # if t1 < t2
    mv t1 t2                # t1 = t2, change cur_max
    mv t0 t3                # t0 = t3, change cur_max's index
else:
    j loop_continue
loop_end:
    # Epilogue
    mv a0 t0                # return t0
    jr ra
