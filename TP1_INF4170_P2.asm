# Auteurs : Patrick Nolin NOLP18059508
#           Emanuel Gonthier
.data
msg_t:		.asciiz "Veuillez entrer le taille de votre tableau : "
msg_e:		.asciiz "Veuillez entrer les éléments du tableau : "
msg_tri:		.asciiz	"Les éléments triés : "
msg_virg:		.asciiz ", "
.text
main: 	# initialisation du tableau
	li	$v0,4
	la 	$a0, msg_t
	syscall
	addi 	$v0,$0,5 	# recupérer saisi utilisateur
	syscall
	lui 	$s0,0x1004 	# adresse de base du tableau NE PAS MODIFIER
	ori 	$s0,$s0,0x0000	# charger adresse tableau
	add	$s1,$0,$v0	# nb element
	addi 	$s2,$0,0	# compteur
	li	$v0,4
	la 	$a0, msg_e
	syscall
	add 	$t0, $t0, $s0	# charger adresse tableau dans $t0
loop1:	beq	$s1,$s2,done1	# nb elem == compteur => done
	addi 	$v0,$0,5 	# recupérer saisi utilisateur
	syscall
	sw 	$v0,0($t0)	#mettre valeur dans la case
	addi	$t0,$t0,4	#déplacement d'une case
	addi	$s2,$s2,1	#incrementer compteur
	j 	loop1
done1:	add	$a0,$0,$s0
	add	$a1,$0,$s2
	jal 	sort
	#terminer le programme
	li	$v0, 4
	la 	$a0, msg_tri
	syscall
	add	$s3, $0, $0
show:	lw	$s4, 0($s0)
	li	$v0, 1
	add 	$a0, $0, $s4
	syscall
	addi	$s3, $s3, 1
	addi	$s0, $s0, 4
	beq	$s3, $s2, end
	li	$v0, 4
	la 	$a0, msg_virg
	syscall
	j	show
	syscall
end:	addi 	$v0, $0, 10
	syscall

# void sort(int [], int par_taille) :trie un tableau de taille par_taille en utilisant l'algorithme
# du heapsort
sort:	addi 	$sp, $sp, -28
	sw 	$a0, 0($sp)
	sw 	$a1, 4($sp)
	sw 	$ra, 8($sp)
	add	$t0, $0, $a1
	subi	$t0, $t0, 1	# n = par_taille - 1
	add	$t1, $0, $t0
	subi 	$t1, $t1, 1
	srl	$t1, $t1, 1	# i = (n - 1) / 2
	add	$t3, $0, $a0
for:	sge	$t2, $t1, $0
	bne	$t2, 1, finFor
	add	$a1, $0, $t1
	add	$a2, $0, $t0
	sw 	$t0, 12($sp)
	sw 	$t1, 16($sp)
	sw 	$t2, 20($sp)
	sw 	$t3, 24($sp)
	jal	fix
	lw 	$t3, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t1, 16($sp)
	lw 	$t0, 12($sp)
	subi	$t1, $t1, 1
	j	for
finFor: sgt	$t2, $t0, $0
	bne	$t2, 1, finSort
	add 	$a0, $0, $0
	add	$a1, $0, $t0
	sw 	$t0, 12($sp)
	sw 	$t1, 16($sp)
	sw 	$t2, 20($sp)
	sw 	$t3, 24($sp)
	jal	swap
	lw 	$t3, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t1, 16($sp)
	lw 	$t0, 12($sp)
	subi	$t0, $t0, 1
	add 	$a0, $0, $t3
	add	$a1, $0, $0
	add	$a2, $0, $t0
	sw 	$t0, 12($sp)
	sw 	$t1, 16($sp)
	sw 	$t2, 20($sp)
	sw 	$t3, 24($sp)
	jal	fix
	lw 	$t3, 24($sp)
	lw	$t2, 20($sp)
	lw 	$t1, 16($sp)
	lw 	$t0, 12($sp)
	j	finFor
finSort:lw 	$ra, 8($sp)
	lw 	$a1, 4($sp)
	lw 	$a0, 0($sp)
	addi 	$sp, $sp, 28
	jr	$ra

# void fixHeap(int[], int rootIndex, int lastIndex) :corrige un tas pour les éléments plus petits soient promus vers le
# haut du tas
fix:	addi 	$sp, $sp, -40
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw 	$s0, 8($sp)
	add	$t0, $0, $a0	# t0 contient adresse du tableau.
	add	$t1, $0, $a1	# index = rootIndex
	sll	$t1, $t1, 2
	add 	$t0, $t0, $t1
	lw	$t2, 0($t0)	# rootValue = a[rootIndex]
	sub	$t0, $t0, $t1
	srl	$t1, $t1, 2
	addi	$t3, $0, 1	# more = true
while:	bne	$t3, 1, finFix
	sw 	$t0, 12($sp)
	sw 	$t1, 16($sp)
	sw	$t2, 20($sp)
	sw	$t3, 24($sp)
	add	$a0, $0, $t1
	jal	gLci
	lw 	$t3, 24($sp)
	lw	$t2, 20($sp)
	lw	$t1, 16($sp)
	lw	$t0, 12($sp)
	add	$t4, $0, $v0	# int childIndex = getLeftChildIndex(index)
	add	$t5, $0, $a2 	# t5 = lastIndex
	sgt	$t6, $t4, $t5
	beq	$t6, 1, fWhile
	sll	$t4, $t4, 2
	add 	$t0, $t0, $t4
	lw	$t7, 0($t0)	# t7 = a[childIndex]
	sub	$t0, $t0, $t4
	srl	$t4, $t4, 2
	sw 	$t7, 12($sp)
	sw 	$t6, 16($sp)
	sw	$t5, 20($sp)
	sw	$t4, 24($sp)
	sw 	$t3, 28($sp)
	sw	$t2, 32($sp)
	sw	$t1, 36($sp)
	sw	$t0, 40($sp)
	add	$a0, $0, $t1
	jal	gRci
	lw	$t0, 40($sp)
	lw	$t1, 36($sp)
	lw 	$t2, 32($sp)
	lw 	$t3, 28($sp)
	lw	$t4, 24($sp)
	lw 	$t5, 20($sp)
	lw	$t6, 16($sp)
	lw	$t7, 12($sp)
	add	$t8, $0, $v0	# int rightChildIndex = getRightChildIndex(index)
	sll	$t8, $t8, 2
	add 	$t0, $t0, $t8
	lw	$t9, 0($t0)	# t9 = a[rightChildIndex]
	sub	$t0, $t0, $t8
	srl	$t8, $t8, 2
	sgt	$s0, $t8, $t5
	beq	$s0, 1, lci
	sgt	$s0, $t9, $t7
	bne	$s0, 1, lci
	add	$t4, $0, $t8
lci:	sll	$t4, $t4, 2
	add 	$t0, $t0, $t4
	lw	$t9, 0($t0)
	sub	$t0, $t0, $t4
	srl	$t4, $t4, 2
	sgt	$s0, $t9, $t2
	bne	$s0, 1, fWhile
	sll	$t1, $t1, 2
	add 	$t0, $t0, $t1
	sw	$t9, 0($t0)	# a[index] = a[childIndex]
	sub	$t0, $t0, $t1
	srl	$t1, $t1, 2
	add	$t1, $0, $t4
	j 	while
fWhile: addi	$t3, $0, 0
	j	while
finFix: sll	$t1, $t1, 2
	add 	$t0, $t0, $t1
	sw	$t2, 0($t0)	# rootValue = a[rootIndex]
	sub	$t0, $t0, $t1
	srl	$t1, $t1, 2
	lw 	$s0, 8($sp)
	lw	$a0, 4($sp)
	lw	$ra, 0($sp)
	addi 	$sp, $sp, 40
	jr 	$ra

# void swap(int i, int j) :échange le contenu de deux éléments du tableau avec les indices i et j
swap:	# enregistrer sur la pile les registre utilisé dans la fonction
	addi 	$sp, $sp, -16
	sw 	$s1, 12($sp)
	sw 	$s0, 8($sp)
	sw	$t1, 4($sp)
	sw 	$t0, 0($sp)
	#nb déplacement
	sll	$t0,$a0,2	# déplacement i
	add	$t0,$t0,$s0	# adresse de a[i] = deplacement i + adresse de base du tableau
	sll	$t1,$a1,2	# déplacement j
	add	$t1,$t1,$s0	# adresse de a[j] = deplacement j + adresse de base du tableau
	#récuperer valeurs
	lw	$s0,0($t0)	#int temp = a[i]
	lw 	$s1,0($t1)	#int temp2 = a[j]
	# swap
	sw	$s1,0($t0)	#a[i] = temp2
	sw	$s0,0($t1)	#a[j] = temp
	# restorer les registres
	lw 	$t0, 0($sp)
	lw 	$t1, 4($sp)
	lw 	$s0, 8($sp)
	lw 	$s1, 12($sp)
	addi 	$sp, $sp, 16
	jr 	$ra

# int getLeftChildIndex(int index) : retourne l'indice de l'enfant de gauche
gLci:	# enregistrer sur la pile les registre utilisé dans la fonction
	addi 	$sp, $sp, -4
	sw 	$t0, 0($sp)
	addi	$t0,$0,0	# $t0 = 0
	sll 	$t0,$a0,1	# index * 2
	addi	$t0,$t0,1	# index + 1
	add	$v0,$0,$t0	# return
	# restorer les registres
	lw 	$t0, 0($sp)
	addi 	$sp, $sp, 4
	jr	$ra

# int getRightChildIndex(int index) : retourne l'indice de l'enfant de droite
gRci:	# enregistrer sur la pile les registre utilisé dans la fonction
	addi 	$sp, $sp, -4
	sw 	$t0, 0($sp)
	addi	$t0,$0,0	# $t0 = 0
	sll 	$t0,$a0,1	# index * 2
	addi	$t0,$t0,2	# index + 2
	add	$v0,$0,$t0	# return
	# restorer les registres
	lw 	$t0, 0($sp)
	addi 	$sp, $sp, 4
	jr	$ra
