.section .data
_temp:          .int 0
_n:             .int 0
_dNum:          .double 0.0
_sum:           .double 0.0
_avg:           .double  0.0     

#input/output formats

_input:         .asciz "%d\0"    
_inputDouble:   .asciz "%lf\0"    
_outputSum:     .asciz "Sum: %lf \0"
_outputAvg:     .asciz "Average: %lf\0" 

.section .text
.globl _main

_main: 
    pushl	$_n 		     # pushs the value of _n to the stack
	pushl	$_input          # pushs the value of _input to the stack
	call	_scanf           # calls scanf, duuh
    add $8, %esp             # pop the 2 parameters

    movl _n, %eax            # moves _n to the register eax
    movl %eax, _temp         # then moves it to _temp 

    jmp compare              # jump to check the comparesion condition, which is on line 38

input_loop:
    movl	$_dNum, 4(%esp)	 # pushs the value of _dNum, put it first in the stack  
	movl	$_inputDouble, (%esp) # pushs the value of _inputDouble, put it second in the stack, this is reveres of the natural order as the stack is a LIFO data structure
	call	_scanf           # as it is inserted in the reverse order, it will be popped off in the natural order, and on this line the scanf function is called
    fldl    _dNum            # pushes _dNum on the floating point stack.
    faddl   _sum             # pops top 2 stack elements the floating point stack and adds them, then pushs the result to the stack
    fstpl   _sum             # pops top element of the floating point stack 


    movl _temp, %eax         # moves temp to the eax register
    subl $1, %eax            # decrement eax
    movl %eax, _temp         # moves the eax back to to temp, in short temp = temp - 1 
compare:
    movl _temp, %eax
    testl	%eax, %eax       # checks whether %eax is 0, above, or below, 
    jne input_loop           # the jump is not taken if eax is == 0.
    
    fildl _n                 # convert _n to double and push it to stack
    fldl _sum                # convert _sum to double and push it to stack
    fdivp %st(0), %st(1)     # Divides the two items on stack top and pops them and pushes the result
    fstpl _avg               # pop the average.


    pushl _sum+4             # push to stack the high 32-bits of the second parameter to printf
    pushl _sum               # push to stack the low 32-bits of the second parameter to printf 
    pushl $_outputSum        # push to stack the first parameter to printf
    call _printf             # call printf
    add $12, %esp            # pop the 3 parameters

    pushl _avg +4            # push to stack the high 32-bits of the second parameter to printf 
    pushl _avg               # push to stack the low 32-bits of the second parameter to printf 
    pushl $_outputAvg        # push to stack the first parameter to printf
    call _printf             # call printf
    add $12, %esp            # pop the 3 parameters


    ret
