.data
	fs1: .asciz "%d"
	fs2: .asciz "%d "
	fs3: .asciz "%d \n"
	dimensiune: .space 4
.text

matrix_mult:
	pushl %ebp
	mov %esp, %ebp
	
	mov 20(%ebp), %eax
	mul %eax
	mov 20(%ebp), %edx
	mov %eax, %ecx
	mov 8(%ebp), %edi
	mov 12(%ebp), %esi
	mov 16(%ebp), %ebx
	
multi:
	cmp $0, %ecx
	je proc_fin
	pushl %ecx
elements:
	cmp $0, %edx
	je next_el
	pushl %edx
	xor %edx, %edx
	mov (%edi), %eax
	mov (%esi), %ecx
	mul %ecx
	add %eax, (%ebx)
	
	mov 20(%ebp), %eax
	xor %edx, %edx
	mov $4, %ecx
	mul %ecx
	xor %edx, %edx
	
	add %eax, %esi
	add %ecx, %edi
	
	popl %edx
	subl $1, %edx
	jmp elements
	
next_el:	
	add $4, %ebx
	popl %ecx
	subl $1, %ecx
	pushl %ecx
	xor %edx, %edx
	mov %ecx, %eax
	mov 20(%ebp), %ecx
	div %ecx
	cmp $0, %edx
	je change_l
	
	xor %edx, %edx
	mov 20(%ebp), %eax
	mov $4, %ecx
	mul %ecx
	sub %eax, %edi
	mov 20(%ebp), %eax
	mul %eax
	mul %ecx
	sub %eax, %esi
	add $4, %esi
	
	mov 20(%ebp), %edx
	popl %ecx
	
	jmp multi

change_l:
	mov 20(%ebp), %eax
	mov $4, %ecx
	xor %edx, %edx
	mul %eax
	mul %ecx
	sub %eax, %esi
	mov 20(%ebp), %eax
	sub $1, %eax
	mov $4, %ecx
	mul %ecx
	sub %eax, %esi
	
	mov 20(%ebp), %edx
	popl %ecx
	
	jmp multi
	
proc_fin:
	mov 20(%ebp), %eax
	mov $4, %ecx
	mul %eax
	mul %ecx
	sub %eax, %ebx
	sub %eax, %edi
	

	mov %ebx, %eax
proc_exit:
	popl %ebp
	ret

.global main
main:
	subl $4, %esp
	
	lea -4(%ebp), %eax
	
	pushl %eax
	pushl $fs1
	call scanf
	addl $8, %esp
	
	
	addl $4, %esp
	
	mov -4(%ebp), %eax
	
	subl $8, %esp
	lea -8(%ebp), %ecx
	
	pusha
	pushl %ecx
	pushl $fs1
	call scanf
	addl $8, %esp
	popa
	
	addl $8, %esp
	
	mov -8(%ebp), %ecx
	
	mov %ecx, %edi
	mov %ecx, %eax
	mul %ecx
	mov %eax, %ecx
	mov $1, %eax
	subl $8, %esp
	
main_array:
	cmp $0, %ecx
	je next
	
	push $0
	
	subl $1, %ecx
	jmp main_array
next:
	mov %edi, %ecx
	xor %edx, %edx
	xor %edi, %edi
	xor %esi, %esi
	xor %edx, %edx
	
	lea (%esp), %edi
	
	mov $4, %edx
	mov %ecx, %eax
	mul %edx
	mov %eax, %ecx
	mov $1, %eax
	
	
	mov %esp, %esi
	mov %esp, %eax
	sub %ecx, %eax
	mov %eax, %esp
con_array:
	cmp %eax, %esi
	je interm
	
	lea (%eax), %ebx
	
	pusha
	pushl %ebx
	pushl $fs1
	call scanf
	popl %edx
	popl %edx
	popa
	
	add $4, %eax
	jmp con_array
interm:
	lea (%esp), %esi
	sub $4, %esp
	mov %edi, %ecx

connections:
	mov (%esi), %edx
	cmp $0, %edx
	je next2
	
	lea (%esp), %ebx
	
	pusha
	pushl %ebx
	pushl $fs1
	call scanf
	popl %edx
	popl %edx
	popa
	
	mov (%esp), %eax
	mov $4, %ebx
	mul %ebx
	add %eax, %edi
	movl $1, (%edi)
	sub %eax, %edi
	xor %eax, %eax
	
	subl $1, (%esi)
	jmp connections
	
next2:
	add $4, %esi
	
	mov -8(%ebp), %eax
	mov $4, %ebx
	mul %ebx
	add %eax, %edi
	
	cmp %ecx, %esi
	je interm2
	
	jmp connections
	
interm2:
	mov -8(%ebp), %eax
	mov $4, %ebx
	mul %eax
	mul %ebx
	mov %edi, %esi
	sub %eax, %edi
	mov $1, %ecx
	mov -8(%ebp), %edx
task_check:
	mov -4(%ebp), %eax
	cmp $1, %eax
	jne next3
output:
	cmp %edi, %esi
	je next3
	mov (%edi), %eax
	
	pusha
	pushl %eax
	pushl $fs2
	call printf
	popl %edx
	popl %edx
	popa
	
	pusha
	pushl $0
	call fflush
	popl %edx
	popa
	
	add $4, %edi
	add $1, %ecx
	cmp %edx, %ecx
	je output_f
	jmp output
output_f:
	mov (%edi), %eax
	
	pusha
	pushl %eax
	pushl $fs3
	call printf
	popl %edx
	popl %edx
	popa
	
	add $4, %edi
	mov $1, %ecx
	jmp output
next3:
	mov -4(%ebp), %eax
	cmp $1, %eax
	je exit
	add $4, %esp
	mov -8(%ebp), %eax
	mov $4, %ebx
	mul %ebx
	add %eax, %esp
	mov -8(%ebp), %eax
	mul %eax
	mov %esp, %esi
	mov %esi, %ecx
sec_array:
	mov %esp, %edi
	cmp $0, %eax
	je copy_m
	
	pushl $0
	subl $1, %eax
	jmp sec_array
copy_m:
	mov (%ecx), %ebx
	mov %ebx, (%edi)
	
	add $4, %ecx
	add $4, %edi
	
	cmp %edi, %esi
	je proc
	
	jmp copy_m
proc:
	mov -8(%ebp), %eax
	mov $4, %ebx
	mul %eax
	mul %ebx
	sub %eax, %edi

res_array_interm:

	mov -8(%ebp), %eax
	mul %eax
res_array:

	cmp $0, %eax
	je next4
	
	pushl $0
	
	mov $1, %ecx
	subl %ecx, %eax
	jmp res_array
next4:
	mov %esp, %ebx

distance:
	sub $4, %esp
	
	lea (%esp), %ecx
	
	pusha
	pushl %ecx
	pushl $fs1
	call scanf
	popl %edx
	popl %edx
	popa
	
	mov (%esp), %edx
task_check2:
	mov -4(%ebp), %eax
	cmp $3, %eax
	jne exit
	mov -8(%ebp), %eax
	mul %eax
	mov $4, %ecx
	mul %ecx
	mov %eax, dimensiune
	
matrix_aloc:
	push %ebp
	push %ebx
	push %esi
	push %edi
	
	movl $192, %eax  #codul pentru mmap
	xorl %ebx, %ebx
	mov dimensiune, %ecx  #dimensiunea calculata pentru alocare
	movl $0x3, %edx	#protectie pentru scriere si pentru citire
	movl $0x22, %esi  #mapare privata si anonima
	movl $-1, %edi  #nu exista atunci cand maparea este anonima
	movl $0, %ebp
	int $0x80
	
	pop %edi
	pop %esi
	pop %ebx
	pop %ebp
	
	movl -8(%ebp), %ecx
	push %eax
	mov %ecx, %eax
	mul %eax
	mov %eax, %ecx
	pop %eax

matrix_move0:
	cmp $0, %ecx
	je next5
	
	mov (%edi), %edx
	mov %edx, (%eax)
	
	add $4, %edi
	add $4, %eax
	
	subl $1, %ecx
	jmp matrix_move0

next5:
	push %eax
	mov -8(%ebp), %eax
	mul %eax
	mov $4, %ecx
	mul %ecx
	mov %eax, %ecx
	pop %eax
	sub %ecx, %eax
	mov %eax, %edi
	
matrix_aloc2:
	push %ebp
	push %ebx
	push %esi
	push %edi
	
	movl $192, %eax  #codul pentru mmap
	xorl %ebx, %ebx
	mov dimensiune, %ecx  #dimensiunea calculata pentru alocare
	movl $0x3, %edx	#protectie pentru scriere si pentru citire
	movl $0x22, %esi  #mapare privata si anonima
	movl $-1, %edi  #nu exista atunci cand maparea este anonima
	movl $0, %ebp
	int $0x80
	
	pop %edi
	pop %esi
	pop %ebx
	pop %ebp
	
	push %eax
	mov -8(%ebp), %eax
	mul %eax
	mov %eax, %ecx
	pop %eax

matrix_move1:
	cmp $0, %ecx
	je next6
	
	mov (%esi), %edx
	mov %edx, (%eax)
	
	add $4, %esi
	add $4, %eax
	
	subl $1, %ecx
	jmp matrix_move1

next6:
	push %eax
	mov dimensiune, %ecx
	pop %eax
	sub %ecx, %eax
	mov %eax, %esi

matrix_aloc3:
	push %ebp
	push %ebx
	push %esi
	push %edi
	
	movl $192, %eax  #codul pentru mmap
	xorl %ebx, %ebx
	mov dimensiune, %ecx  #dimensiunea calculata pentru alocare
	movl $0x3, %edx	#protectie pentru scriere si pentru citire
	movl $0x22, %esi  #mapare privata si anonima
	movl $-1, %edi  #nu exista atunci cand maparea este anonima
	movl $0, %ebp
	int $0x80
	
	pop %edi
	pop %esi
	pop %ebx
	pop %ebp
	
	mov %eax, %ebx
	
	mov (%esp), %ecx
	subl $1, %ecx
	cmp $0, %ecx
	je d_nodes
proc2:	
	
	push %ecx
	
	pushl -8(%ebp)
	pushl %ebx
	pushl %esi
	pushl %edi
	call matrix_mult
	popl %edx
	popl %edx
	popl %edx
	popl %edx
	
	pop %ecx
	subl $1, %ecx
	cmp $0, %ecx
	je d_nodes
	jmp matrix_replace

matrix_replace:
	mov -8(%ebp), %eax
	mul %eax
	
element_replace:
	cmp $0, %eax
	je next7
	
	mov (%ebx), %edx
	mov %edx, (%esi)
	movl $0, (%ebx)
	
	add $4, %ebx
	add $4, %esi
	
	subl $1, %eax
	jmp element_replace
	
next7:
	mov dimensiune, %eax
	sub %eax, %esi
	sub %eax, %ebx
	jmp proc2


d_nodes:
	mov $0, %edx
	lea (%esp), %eax
	
	pusha
	
	pushl %eax
	pushl $fs1
	call scanf
	popl %edx
	popl %edx
	
	popa
	
	mov (%esp), %eax
	mov -8(%ebp), %ecx
	mul %ecx
	mov $4, %ecx
	mul %ecx
	
	add %eax, %ebx
	add %eax, %edx
	
	lea (%esp), %eax
	
	pusha
	
	pushl %eax
	pushl $fs1
	call scanf
	popl %edx
	popl %edx
	
	popa
	
	mov (%esp), %eax
	mov $4, %ecx
	mul %ecx
	
	add %eax, %ebx
	add %eax, %edx
	
	pusha
	
	pushl (%ebx)
	pushl $fs1
	call printf
	popl %edx
	popl %edx

	popa
	
	subl %edx, %ebx
	
	pushl $0
	call fflush
	popl %edx
	

exit:
	mov $91, %eax #codul pentru munmap
	mov dimensiune, %ecx #in %ebx se afla deja adresa uneia dintre matrici, o vom dezaloca mai intai pe aceea, dimensiunea calculata pentru alocare a fost folosita si pentru dezalocare
	int $0x80
	
	mov $91, %eax #codul pentru munmap
	mov %edi, %ebx #adresa primei matrice
	mov dimensiune, %ecx #dimensiunea calculata anterior pentru alocare
	int $0x80
	
	mov $91, %eax #codul pentru munmap
	mov %esi, %ebx #adresa celei de-a doua matrice
	mov dimensiune, %ecx #dimensiunea calculata anterior pentru alocare
	int $0x80

	mov $1, %eax
	xor %ebx, %ebx
	int $0x80
