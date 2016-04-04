@ LAB1
@ Somesh Arora
@ CSE 2312
@ 1001083238
@ Simple Calculator

 
    .global main
    .func main
   
main:
    BL  _prompt       @ branch to prompt procedure with return
    BL  _scanf        @ branch to scanf procedure with return
    MOV R4, R0	      @ Move the value of R0 in R4 register temporarily

    BL  _prompt1      @ branch to prompt1 procedure with return           
    BL  _getchar      @ branch to getchar procedure with return        
    MOV R5, R0	      @ Move the value of R0 in R5 register temporarily

    BL _prompt	      @ branch to prompt procedure with return
    BL _scanf	      @ branch to scanf procedure with return
    MOV R6, R0	      @ Move the value of R0 in R5 register temporarily

    MOV R1, R4	      @ Moving value of R4 in R1 register 
    MOV R2, R5	      @ Moving value of R5 in R2 register
    MOV R3, R6	      @ Moving value of R6 in R3 register

    BL _compare	      @ Branch to compare procedure with return
    MOV R1, R0	      @ Moving value of R0 in R1 register because printf takes R1 as argument by default
    BL _printf	      @ Branch to printf with return
		      
    B   main          @ Branching again to main

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_printf:
    MOV R7, LR
    MOV R2, #17
    LDR R0, =final_str
    MOV R1, R1
    BL printf
    MOV PC, R7		    @ return
       
_prompt1:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #28             @ print string length
    LDR R1, =prompt1_str    @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_compare:  
    CMP R2, #'+'      @ compare against the constant char '+'
    BEQ _SUM	      @ If the comparision is true then Branching to _SUM procedure
    CMP R2, #'-'      @ compare against the constant char '-'
    BEQ _DIFFERENCE   @ If the comparision is true then Branching to _DIFFERENCE procedure
    CMP R2, #'*'      @ compare against the constant char '*'
    BEQ _PRODUCT      @ If the comparision is true then Branching to _PRODUCT procedure
    CMP R2, #'M'      @ compare against the constant char 'M'
    BEQ _MAX          @ If the comparision is true then Branching to _MAX procedure
    MOV PC, LR	      @ return
 
_SUM:
    MOV R7, LR        @ store LR since printf call overwrites
    ADD R0, R1, R3    @ adding values in R1 and R3 registers and storing result in R0 register 	 
    MOV PC, R7        @ return
    
_DIFFERENCE:
    MOV R7, LR        @ store LR since printf call overwrites
    SUB R0, R1, R3    @ subtracting value of R1 with value in R3 register and storing result in R0 register
    MOV PC, R7        @ return
    
_PRODUCT:
    MOV R7, LR        @ store LR since printf call overwrites
    MUL R0, R1, R3    @ multiplying values in R1 and R3 registers and storing result in R0 register
    MOV PC, R7        @ return
 
_MAX:
    MOV R7, LR        @ store LR since printf call overwrites
    CMP R1, R3	      @ comparing values in R1 and R3 registers
    MOVLE R1, R3      @ overwrites R1 with R3 if R3 is greater than or equal to R1
    MOV R0, R1        @ moving value of R1 in R0 register
    MOV PC, R7        @ return
 
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return
 
_scanf:
    MOV R7, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R7              @ return

.data
format_str:     .asciz      "%d"
read_char:      .ascii      " "
prompt1_str:    .ascii      "Enter a character[+,-,*,M]: "
prompt_str:     .ascii      "Enter a number and hit return: "
final_str: 	.asciz	    "The answer is: %d\n\n"
