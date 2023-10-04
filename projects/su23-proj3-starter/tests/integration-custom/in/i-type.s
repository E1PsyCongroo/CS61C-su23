addi t0 x0 100
addi t0 x0 -100
#-----------------
addi t0 x0 100
slli t0 t0 4
#-----------------
addi t0 x0 100
slti t1 t1 101
slti t1 t1 -10
#-----------------
addi t0 x0 100
xori t1 t0 100
xori t0 t0 99
#-----------------
addi t0 x0 -100
srli t0 t0 2
#-----------------
addi t0 x0 -100
srai t0 t0 2
#-----------------
addi t0 x0 100
ori t1 t0 1023
ori t0 t0 23
#-----------------
addi t0 x0 100
andi t1 x0 0
andi t0 t0 100
