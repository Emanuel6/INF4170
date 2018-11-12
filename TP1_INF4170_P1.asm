# Auteurs : Patrick Nolin NOLP18059508
#           Emanuel Gonthier
.data 				
msg_t:		.asciiz "Veuillez entrer le taille de votre tableau (entre 1 et 20): "
msg_t_err:	.asciiz "\nTaille invalide.\n"
msg_e:		.asciiz "Veuillez entrer les éléments du tableau : "
.text 				
main: 	# initialisation du tableau
	li	$v0,4
	la 	$a0, msg_t
	syscall
	addi 	$v0,$0,5 	# recupérer saisi utilisateur
	syscall
	add	$s1,$0,$v0	# nb element
	sle	$s2, $s1, $0
	bne	$s2, 1, trop
	li	$v0, 4
	la 	$a0, msg_t_err
	syscall
	j	main
trop:	sgt	$s2, $s1, 20
	bne	$s2, 1, ok
	li	$v0, 4
	la 	$a0, msg_t_err
	syscall
	j	main
ok:	lui 	$s0,0x1004 	# adresse de base du tableau NE PAS MODIFIER
	ori 	$s0,$s0,0x0000	# charger adresse tableau
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
	j loop1
done1:	#test de swap
	addi 	$a0,$0, 1 	# i = 1
	addi	$a1,$0, 2 	# j = 2
	jal 	swap
	#test de getLeftChildIndex
	addi 	$a0,$0, 1 	# index = 1
	jal 	gLci
	add 	$t0,$0,$v0
	li 	$v0, 1
	add 	$a0,$t0,$zero
	syscall
	#test de getRightChildIndex
	addi 	$a0,$0, 1 	# index = 1
	jal 	gRci
	add 	$t0,$0,$v0
	li 	$v0, 1
	add 	$a0,$t0,$zero
	syscall
	#terminer le programme
	addi 	$v0, $0, 10 	
	syscall
	
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













