.section .data
    mensaje: 
        .asciz "El resultado es %d \n"
    
.section .text
.global _start
_start:
    #RESET DE LOS REGISTROS
    xor %eax, %eax
    xor %ebx, %ebx
    xor %ecx, %ecx
    xor %edx, %edx
    #----------------------
    mov 8(%esp), %eax   #argv[1] base
    mov 12(%esp), %ebx  #argv[2] exponente   
    movb (%eax),%cl #base
    movb (%ebx),%dl #exponente
    subl $0x30,%ecx  
    subl $0x30,%edx
    pushl %edx   #exponente
    pushl %ecx   #base
    call power #llamada a la subrutina power
    pushl %edx #
    push $mensaje
    call printf
    movl $1, %eax #codigo del llamada al sistema operativo (llamada exit)
    int $0x80 #interrumpir S.O.
    
    
    
.type potencia, @function

power:
    pushl %ebp  #salvar el frame pointer antiguo
    movl %esp, %ebp #actualizar el nuevo frame pointer
    subl $4, %esp  #reservamos una palabra 
    movl  8(%ebp), %ebx #put first argument in %ebx (base)
    movl  12(%ebp), %ecx #put second argument in %ecx (exponente)
    movl $1, %edx #empleo edx para guardar el resultado de la potencia
bucle:
    imull %ebx, %edx #multiplicamos por la base en cada iteracion
    sub $1, %ecx #restamos uno al exponente para poder llegar a la condicion de salida
    cmpl $0, %ecx  #cuando el exponente es 0 salimos del bucle
    je final #salto a la parte final de la subrutina
    jmp bucle #vuelta al bucle
final:
    movl  %ebp, %esp      #restore the stack pointer
    popl  %ebp            #restore the frame pointer
    ret
    .end
    
    
    
    
    
    
    
    
    
