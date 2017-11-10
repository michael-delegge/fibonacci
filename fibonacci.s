    extern    printf            ; external c functions
        
    extern    strtoul            

    global    main              ; global entry        

    section   .data            

Echo:
    db "You entered: %s %s", 10, 0

Usage:
    db "Usage: %s arg1", 10
    db "Where arg1 is an interger between 0 and 500", 10, 0

Fib_num:
    db "%016lx%016lx%016lx%016lx%016lx%016lx", 10, 0        ; print string for fibonacci 

; array of qwords to store large fibonacci number
Huge_numA:
    dq  0x0000000000000000
    dq  0
    dq  0
    dq  0
    dq  0
    dq  0

Huge_numB:
    dq  0x0000000000000001      ; starting value of 1 for fibonacci sequence
    dq  0
    dq  0
    dq  0
    dq  0
    dq  0

    section .bss
temp:       resq    1           ; used for Echo
x:          resq    1           ; command line arg1

    section .text

main:
    push    r15
    mov     r15, rsi
    cmp     edi, 2              ; ensure there are 2 entries on the command line
    jne     Usage_Error         ; if not 2 entries, print usage text

    mov     qword[temp], rsi    ; save rsi to echo command line 
    mov     rdi, Echo           ; 1st paramater
    mov     rsi, [r15]          ; 2nd parameter is rsi (command)
    mov     rdx, [r15 + 8]      ; 3rd paramater (first argument after command)
    xor     rax, rax            ; clear rax for printf
    call    printf
    mov     rsi, qword[temp]    ; restore rsi

    mov     rdi, [r15 + 8]      ; convert first argument to long integer and store return value in x.
    mov     rdx, 10
    call    strtoul
    mov     qword[x], rax       ; copy strtoul return value in x

    cmp     qword[x], 0         ; if user entered zero
    je      Print_zero

; loop to calculate fibonacci number
Fib_loop:
    dec     qword[x]            ; value from command line stored as x, and decriment 
    cmp     qword[x], 0         ; until x reaches 0
    je      Print_fib           ; if x equals 0 then jump to Print_fib function

    mov     r8, [Huge_numB]
    mov     r12, [Huge_numA]
    
    mov     r9, [Huge_numB+8]
    mov     r13, [Huge_numA+8]
    
    mov     r10, [Huge_numB+16]
    mov     r14, [Huge_numA+16]
   
    mov     r11, [Huge_numB+24]
    mov     r15, [Huge_numA+24]
    
    mov     rax, [Huge_numB+32]
    mov     rcx, [Huge_numA+32]
    
    mov     rbx, [Huge_numB+40]
    mov     rdx, [Huge_numA+40]

    add     [Huge_numA], r8
    adc     [Huge_numA+8], r9
    adc     [Huge_numA+16], r10
    adc     [Huge_numA+24], r11
    adc     [Huge_numA+32], rax
    adc     [Huge_numA+40], rbx

    add     [Huge_numB], r12
    adc     [Huge_numB+8], r13
    adc     [Huge_numB+16], r14
    adc     [Huge_numB+24], r15
    adc     [Huge_numB+32], rcx
    adc     [Huge_numB+40], rdx

    mov     [Huge_numA], r8
    mov     [Huge_numA+8], r9
    mov     [Huge_numA+16], r10
    mov     [Huge_numA+24], r11
    mov     [Huge_numA+32], rax
    mov     [Huge_numA+40], rbx

    jmp     Fib_loop

Print_fib:                          ; prints fibonacci number after loop completes
    mov     rdi, Fib_num
    mov     rsi, [Huge_numB+40]
    mov     rdx, [Huge_numB+32]
    mov     rcx, [Huge_numB+24]
    mov     r8, [Huge_numB+16]
    mov     r9, [Huge_numB+8]
    push    qword[Huge_numB]
    xor     rax, rax
    call    printf
    pop     qword[Huge_numB]
    jmp     Return

Print_zero:                         ; print all 0's if user entered a 0
    mov     rdi, Fib_num            ; there is probably a better way to handle this
    mov     rsi, [Huge_numA+40]     
    mov     rdx, [Huge_numA+32]
    mov     rcx, [Huge_numA+24]
    mov     r8, [Huge_numA+16]
    mov     r9, [Huge_numA+8]
    push    qword[Huge_numA]
    xor     rax, rax
    call    printf
    pop     qword[Huge_numA]
    jmp     Return
  
    
Return:
    pop     r15                   ; restore r15 for whoever calls main
    ret

Usage_Error:
    mov     rdi, Usage            ; 1st parameter
    mov     rsi, [r15]            ; 2nd parameter
    xor     rax, rax              ; zero out rax for printf
    call    printf                ; print error message
    mov     rax, 1                ; return value to whoever calls main is 1 (error)
    jmp     Return
    
; nasm -felf64 fibonacci.asm && gcc fibonacci.o -s -o fibonacci && ./fibonacci
