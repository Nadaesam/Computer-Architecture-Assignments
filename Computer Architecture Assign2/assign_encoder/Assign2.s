
# To compile this assembly program on windows:
# gcc -O3 -o Assign2.exe Assign2.s
# After running the program, enter a positive integer and press Enter
# The program implement series: (1 + 1/1) + (2 + 1/4) + (3 + 1/9) + (4 + 1/16) + ... + (n + 1/(n^2)).


.intel_syntax noprefix        # use the intel syntax, not AT&T syntax. do not prefix registers with %

.section .data                # memory variables

input: .asciz "%d"            # string terminated by 0 that will be used for scanf parameter
output: .asciz "The sum is: %f\n"     # string terminated by 0 that will be used for printf parameter

n: .int 0             # the variable n which we will get from user using scanf
s: .double 0.0        # the variable s=(1 + 1/1) + (2 + 1/4) + (3 + 1/9) + (4 + 1/16) + ... + (n + 1/(n^2)) that will be calculated by the program and will be printed by printf, s is initialized to 0
one: .double 1.0      # for adding 1 on denominator and represent numerator
r: .double 1.0        # this represent denominator
rr: .double 1.0       #



.section .text        # instructions
.globl _main          # make _main accessible from external

_main:                # the label indicating the start of the program
  push OFFSET n      # push to stack the second parameter to scanf (the address of the integer variable n)
  push OFFSET input  # push to stack the first parameter to scanf
  call _scanf        # call scanf, it will use the two parameters on the top of the stack in the reverse order
  add esp, 8         # pop the above two parameters from the stack (the esp register keeps track of the stack top, 8=2*4 bytes popped as param was 4 bytes)

  mov ecx, n         # ecx <- n (the number of iterations)
loop1:
  # the following 5 instructions increase s by 1/r*r
  fld qword ptr one            # push 1 to the floating point stack
  fdiv qword ptr r             # pop the floating point stack top (1), divide it over r and push the result (1/r)
  fdiv qword ptr r             # pop the floating point stack top (1), divide it over r and push the result (1/r) so we get r*r

  fadd qword ptr s             # pop the floating point stack top (1/r*r), add it to s, and push the result (s+(1/r*r))
  fstp qword ptr s             # pop the floating point stack top (s+(1/r*r)) into the memory variable s

  # the following 3 instructions increase r by 1   
  fld qword ptr r              # push 1 to the floating point stack
  fadd qword ptr one           # pop the floating point stack top (1), add it to r and push the result (r+1)
  fstp qword ptr r             # pop the floating point stack top (r+1) into the memory variable r

loop loop1                     # ecx -=1 , then goto loop1 only if ecx is not zero
  mov ecx, n                   #  assign ecx : n and decrease it overall loop ecx <- n (the number of iterations)
loop2:
  # the following 2 instructions increase s by absoult num -> rr ( 1  + 2 + 3 + 4 +  ... + n )
  fld qword ptr rr             # push rr to the floating point stack
  fadd qword ptr s             # pop the floating point stack top (rr), add it to s, and push the result (s+ rr)
  
  fstp qword ptr s             # pop the floating point stack top (s+ rr)) into the memory variable s

  # the following 3 instructions increase rr by 1   
  fld qword ptr rr              # push rr to the floating point stack
  fadd qword ptr one            # pop the floating point stack top (1), add it to rr and push the result (rr+1)
  fstp qword ptr rr         

loop loop2         # # ecx -=1 , then goto loop1 only if ecx is not zero
push [s+4]         # push to stack the high 32-bits of the second parameter to printf (the double at label s)
push s             # push to stack the low 32-bits of the second parameter to printf (the double at label s)
push OFFSET output # push to stack the first parameter to printf
call _printf       # call printf
add esp, 12        # pop the two parameters

ret                # end the main function
