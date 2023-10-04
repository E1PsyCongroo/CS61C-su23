addi t0 x0 100
addi s0 x0 1280
#--------------
sw t0 0(s0)
lw t1 0(s0)
#--------------
addi t0 x0 50
sh t0 0(s0)
lh t1 0(s0)
lw t1 0(s0)
sh t0 2(s0)
#-------------
addi t0 x0 0b00001110
sb t0 1(s0)
lb t1 1(s0)
