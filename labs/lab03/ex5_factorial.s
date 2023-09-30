.globl factorial

.data
n: .word 8

.text
# Don't worry about understanding the code in main
# You'll learn more about function calls in lecture soon
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

# factorial takes one argument:
# a0 contains the number which we want to compute the factorial of
# The return value should be stored in a0
factorial:
    # YOUR CODE HERE
    # iteraotor solution
    addi t0 x0 1
    addi t1 x0 0
    factorial_loop:
        addi t1 t1 1
        mul t0 t0 t1
        blt t1 a0 factorial_loop
    mv a0 t0
    # recursive solution
    # blt x0 a0 factorial_recursive
    # addi a0 x0 1
    # jr ra
    # factorial_recursive:
    #     addi t0 a0 0
    #     addi a0 a0 -1
    #     addi sp sp -8
    #     sw ra 0(sp)
    #     sw t0 4(sp)
    #     jal ra, factorial
    #     lw ra 0(sp)
    #     lw t0 4(sp)
    #     addi sp sp 8
    #     mul a0 a0 t0

    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra
