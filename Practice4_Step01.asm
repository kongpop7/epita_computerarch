				; ==============================
				; Vector Initialization
				; ==============================
				
				org 		$4
vector_001 		dc.l 		Main

				; ==============================
				; Main Program
				; ==============================
				
				org 		$500
				
Main 			move.l 		#String1,a0
				jsr 		RemoveSpace
				illegal
				
				; ==============================
				; Subroutines
				; ==============================
				
RemoveSpace 	movem.l		a0/a1,-(a7)
				movea.l		a0,a1

\loop			tst.b		(a0)
				beq			\quit

				cmp.b 		#' ',d1
				bne			\rmspce
				
				move.b		(a0)+,(a1)+
				bra			\loop


\rmspce			tst.b		(a0)+
				bra			\loop
							
\quit			rts


String1 		dc.b 		" 5 +  12 ",0
