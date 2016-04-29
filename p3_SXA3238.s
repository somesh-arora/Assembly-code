 
    .global main
    .func main
   
main:
    MOV R0, #0		    @ initialze index variable

_scanf:
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV R7, R0		    @ moving value stored in R0 register to R7 register
    MOV R0, #0		    @ settig vale of R0 register back to 0 
    B _generate		    @ branch to next loop iteration

_generate:
    CMP R0, #20		    @ check to see if we are done iterating
    BEQ _generatedone	    @ exit loop if done
    LDR R1, =array_a	    @ get address of array_a
    LSL R2, R0, #2  	    @ multiply index*4 to get array offset
    ADD R2, R1, R2	    @ adding value stored in R2 and R1 and storing in R2
    ADD R8, R7, R0	    @ adding value stored in R0 and R7 and storing in R8
    STR R8, [R2]	    @ write the address of a[i] to a[i]
    ADD R2, R2, #4	    @ adding 4 to to move to next index
    ADD R8, R8, #1	    @ increment index
    NEG R8, R8		    @ making the number negative
    STR R8, [R2]	    @ write the address of a[i] to a[i]
    ADD R0, R0, #2	    @ increment index
    B _generate		    @ branch to next loop iteration

_generatedone:
    MOV R0, #0		    @ initialze index variable
    B _copyval		    @ branch to next loop iteration

_copyval:
    CMP R0, #20		    @ check to see if we are done iterating
    BEQ _copydone	    @ exit loop if done
    LDR R1, =array_a	    @ get address of array_a
    LDR R2, =array_b	    @ get address of array_b
    LSL R3, R0, #2	    @ multiply index*4 to get array offset
    ADD R4, R1, R3	    @ adding value stored in R3 and R1 and storing in R3
    ADD R5, R2, R3	    @ adding value stored in R3 and R2 and storing in R5
    LDR R6, [R4]	    @ read the array at address 
    STR R6, [R5]	    @ write the address of a[i] to a[i]
    ADD R0, R0, #1	    @ increment index
    B _copyval		    @ branch to next loop iteration

_copydone:
    MOV R0, #0		    @ initialze index variable
    B _sortelements	    @ branch to next loop iteration

_sortelements:
    CMP R0, #19		    @ check to see if we are done iterating
    BEQ _sortdone	    @ exit loop if done
    MOV R1, #0		    @ initialze index variable
    SUB R3, R0, #19	    @ subtracting 19 from R0 and storing value in R3
    NEG R3, R3		    @ making the number negative
    B _loop		    @ branch to next loop iteration

_loop:
    CMP R1, R3	 	    @ check to see if we are done iterating
    ADDEQ R0, R0, #1	    @ increment the index if the values are same
    BEQ _sortelements	    @ exit loop if done
    LDR R4, =array_b	    @ get address of array_b
    LSL R5, R1, #2	    @ multiply index*4 to get array offset
    ADD R5, R4, R5	    @ adding value stored in R4 and R5 and storing in R5
    LDR R6, [R5]	    @ read the array at address 
    ADD R7, R5, #4 	    @ increment index
    LDR R8, [R7]	    @ read the array at address 
    CMP R8, R6	 	    @ comparing vales of R8 and R6
    STRLT R6, [R7]	    @ write the address of a[i] to a[i] if R7 is less than R6
    STRLT R8, [R5]     	    @ write the address of a[i] to a[i] if R5 is less than R8
    ADDLT R1, R1, #1	    @ increment the index if the value is small
    BLT _loop		    @ branching to _loop procedure 
    ADD R1, R1, #1 	    @ increment index
    B _loop		    @ branch to next loop iteration

_sortdone:
    MOV R0, #0		    @ initialze index variable
    B _readloop	 	    @ branch to next loop iteration

_readloop:
    CMP R0, #20		    @ check to see if we are done iterating
    BEQ _readdone	    @ exit loop if done
    LDR R1, =array_a	    @ get address of array_a
    LDR R2, =array_b	    @ get address of array_b
    LSL R3, R0, #2 	    @ multiply index*4 to get array offset
    ADD R4, R1, R3	    @ R4 now has the element address
    ADD R5, R2, R3 	    @ R5 has the other element address
    LDR R1, [R4]	    @ read the array at address 
    LDR R2, [R5]	    @ read the array at address 
    PUSH {R0}		    @ backup register before printf
    PUSH {R1}		    @ backup register before printf
    PUSH {R2}		    @ backup register before printf
    PUSH {R3}		    @ backup register before printf
    MOV R3, R2		    @ move array value to R3 for printf
    MOV R2, R1		    @ move array value to R2 for printf
    MOV R1, R0		    @ move array value to R1 for printf
    BL _printf		    @ branch to print procedure with return
    POP {R3}		    @ restore register
    POP {R2}		    @ restore register
    POP {R1}		    @ restore register
    POP {R0}		    @ restore register
    ADD R0, R0, #1	    @ increment index
    B _readloop		    @ branch to next loop iteration

_readdone:
    B _exit		    @ exit if done

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   

.data
.balign 4
array_a: 		    .skip 400
array_b: 		    .skip 400
format_str:     .asciz      "%d"
printf_str:     .asciz      "array_a[%d] = %d, array_b = %d \n"
exit_str:       .ascii      "Terminating program.\n"
