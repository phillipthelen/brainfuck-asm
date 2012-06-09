	section .text

	global _brainfuck
	extern output
	extern input

_brainfuck:
	push rbp
	mov rbp,rsp
	
	push rsi
	push rbx
	sub rsp,64
	jmp cmp
cmploop:
	inc rdi
cmp:
	cmp byte [rdi], '+'
	je increment
	cmp byte [rdi], '-'
	je decrement
	cmp byte [rdi], '>'
	je next
	cmp byte [rdi], '<'
	je prev
	cmp byte [rdi], '.'
	je printChar
	cmp byte [rdi], ','
	je readChar
	cmp byte [rdi], '['
	je loop_start
	cmp byte [rdi], ']'
	je loop_end
	cmp byte [rdi], 0
	je end
	jmp cmploop



increment:
	inc long [rsi]
	jmp cmploop

decrement:
	dec long [rsi]
	jmp cmploop

next:
	add rsi, 8
	jmp cmploop

prev:
	sub rsi, 8
	jmp cmploop

printChar:
	mov [rbp-8], rdi
	mov [rbp-16], rsi
	mov rdi, [rsi]
	call output
	mov rax, 0
	mov rdi, [rbp-8]
	mov rsi, [rbp-16]
	jmp cmploop

readChar:
	mov [rbp-8], rdi
	mov [rbp-16], rsi
	call input
	
	mov rdi, [rbp-8]
	mov rsi, [rbp-16]
	mov [rsi], rax
	jmp cmploop


loop_start:
	cmp long [rsi], 0
	jne cmploop
	mov byte [rbp-24], 0

loop_start_skip:
	inc rdi
	cmp byte [rdi], "["
	je loop_start_inc
	cmp byte [rdi], "]"
	je loop_start_check
	jmp loop_start_skip

loop_start_inc:
	inc byte [rbp-24]
	jmp loop_start_skip

loop_start_check:
	cmp byte [rbp-24], 0
	je cmploop
	dec byte [rbp-24]
	jmp loop_start_skip

loop_end:
	mov byte [rbp-24], 0

loop_end_skip:
	dec rdi
	cmp byte [rdi], "["
	je loop_end_check
	cmp byte [rdi], "]"
	je loop_end_inc
	jmp loop_end_skip

loop_end_check:
	
	cmp byte [rbp-24], 0
	je loop_start
	dec byte [rbp-24]
	jmp loop_end_skip

loop_end_inc:
	inc byte [rbp-24]
	jmp loop_end_skip

end:
	add rsp,64
	pop rbx
	pop rsi
	
	pop rbp
	ret