 
    .global main
    .func main
   
main:
    BL  _promptn             @ branch to promptn procedure with return
    BL  _scanf               @ branch to scanf procedure with return
    MOV R10, R0              @ move return value R0 to argument register R10
    
    BL  _promptm             @ branch to promptm procedure with return
    BL  _scanf               @ branch to scanf procedure with return
    MOV R11, R0              @ move return value R0 to argument register R11
   
    MOV R1, R10              @ move the value of R10 register to R1 register
    MOV R2, R11              @ move the value of R11 register to R2 register
    BL  _count_partitions    @ branch to count_partitions procedure with return
    
    MOV R1, R0               @ move return value R0 register to register R1
    MOV R2, R10              @ move value of R10 register to register R2
    MOV R3, R11              @ move value of R11 register to register R3
    BL  _printf              @ branch to printf procedure with return

    B main                   @ branching back to main

_count_partitions:
    PUSH {LR}               @ store the return address
    
    CMP R1, #0              @ compare the input argument to 0
    MOVEQ R0, #1            @ set return value to 1 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
   
    CMP R1, #0              @ compare the input argument to 0
    MOVLT R0, #0            @ set return value to 0 if less than
    POPLT {PC}              @ restore stack pointer and return if less than
   
    CMP R2, #0              @ compare the input argument to 0
    MOVEQ R0, #0            @ set return value to 1 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
   
    PUSH {R1}               @ backup input argument value 
    PUSH {R2}               @ backup input argument value  
    SUB R1, R1, R2          @ subtracting value stored in register R1 from value stored in register R2 and storing result in R1
    SUB R2, R2, #0          @ subtracting value stored in register R2 with 0 and storing result in R2
    BL _count_partitions    @ branching to count_partitions procedure with return
    POP {R2}                @ restore input argument
    POP {R1}                @ restore input argument
    
    PUSH {R0}               @ backing up value of register R0
    SUB R1, R1, #0          @ subtracting value stored in register R1 with 0 and storing result in R1      
    SUB  R2, R2, #1         @ subtracting value stored in register R2 with 1 and storing result in R2
    BL _count_partitions    @ branching to count_partitions procedure with return
    POP {R5}                @ restoring the value pushed earlier to stack
    ADD R0, R0, R5          @ adding the values stored in registers R0 and R5 and storing result in R0 register
    
    POP  {PC}               @ restore the stack pointer and return
 
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    @MOV R1, R1             @ R1 contains printf argument 1 (redundant line)
    @MOV R2, R2             @ R2 contains printf argument 2 (redundant line)
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
  

_promptm:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #37             @ print string length
    LDR R1, =promptm_str    @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_promptn:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #37             @ print string length
    LDR R1, =promptn_str    @ string at label prompt_str:
    SWI 0                   @ execute syscall
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
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d\n\n"
format_str:     .asciz      "%d"
promptn_str:    .ascii      "Enter the value of n and hit return: "
promptm_str:    .ascii      "Enter the value of m and hit return: "
