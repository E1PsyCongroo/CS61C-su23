.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
# t0, t1 store *a0, *a1; t2 store the intermediate number; t3 store the result
# t4 store step
dot:

    # Prologue


loop_start:
    li t0 1
    blt a2 t0 number_less_1
    blt a3 t0 stride_less_1
    blt a4 t0 stride_less_1
    li t3 0                         # init t3 = 0
    j   loop_continue
number_less_1:
    li a0 36
    j exit
stride_less_1:
    li a0 37
    j exit
loop_continue:
    lw t0 0(a0)                     # t0 = *a0
    lw t1 0(a1)                     # t1 = *a1
    mul t2 t0 t1                    # t2 = t0 * t1
    add t3 t3 t2                    # t3 += t2

    addi a2 a2 -1
    beq a2 x0 loop_end              # if (--a2 == 0) break

    mv t4 a3
    slli t4 t4 2                    # t4 = 4 * a3 = step
    add a0 t4 a0                    # a0 += t4(step)

    mv t4 a4
    slli t4 t4 2
    add a1 t4 a1                    # a1 += step

    j loop_continue
loop_end:
    mv a0 t3                        # return t3
    # Epilogue


    jr ra
