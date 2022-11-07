				org			$4
Vector_001		dc.l		Main
				org			$500
Main			movea.l		#String1,a0
				jsr 		GetNum

StrLen 			move.l 		a0,-(a7)
				clr.l 		d0
\loop 			tst.b 		(a0)+
				beq 		\quit
				addq.l 		#1,d0
				bra 		\loop
\quit 			movea.l 	(a7)+,a0
				rts

IsMaxError
				movem.l 	d0/a0,-(a7)
				jsr 		StrLen
				cmpi.l 		#5,d0
				bhi 		\true
				blo 		\false
				cmpi.b 		#'3',(a0)+
				bhi 		\true
				blo 		\false
				cmpi.b 		#'2',(a0)+
				bhi 		\true
				blo 		\false
				cmpi.b 		#'7',(a0)+
				bhi 		\true
				blo 		\false
				cmpi.b 		#'6',(a0)+
				bhi 		\true
				blo 		\false
				cmpi.b 		#'7',(a0)
				bhi 		\true
\false
				andi.b 		#%11111011,ccr
				bra 		\quit
\true
				ori.b 		#%00000100,ccr
\quit
				movem.l 	(a7)+,d0/a0
				rts

IsCharError
				movem.l 	d0/a0,-(a7)
\loop 
				move.b 		(a0)+,d0
				beq 		\false

				cmpi.b 		#'0',d0
				blo 		\true

				cmpi.b 		#'9',d0
				bls 		\loop
\true 
				ori.b 		#%00000100,ccr
				bra 		\quit
\false
				andi.b 		#%11111011,ccr
\quit
				movem.l 	(a7)+,d0/a0
				rts

Atoui			movem.l 	d1/a0,-(a7)
				clr.l		d0
				clr.l		d1
\loop
				move.b 		(a0)+,d1
				beq 		\quit
				subi.b 		#'0',d1
				mulu.w 		#10,d0
				add.l 		d1,d0
				bra 		\loop
\quit
				movem.l 	(a7)+,d1/a0
				rts

Convert
				tst.b 		(a0)
				beq 		\false
				jsr 		IsCharError
				beq 		\false
				jsr 		IsMaxError
				beq 		\false
				jsr 		Atoui
\true
				ori.b 		#%00000100,ccr
				rts
\false
				andi.b 		#%11111011,ccr
				rts
				
NextOp			tst.b		(a0)
				beq			\quit
				cmpi.b 		#'+',(a0)
				beq 		\quit
				cmpi.b 		#'-',(a0)
				beq 		\quit
				cmpi.b 		#'*',(a0)
				beq 		\quit
				cmpi.b 		#'/',(a0)
				beq 		\quit
				addq.l 		#1,a0
				bra 		NextOp
\quit			rts

GetNum			movem.l		a1/a2/d0,-(a7)
				clr.l		d0
				clr.l		d1
\loop			
				jsr			NextOp
				move.l		(a0),d1
				move.l		#0,(a0)
				
				jsr			Convert
				tst.l		a7
				beq			#%11111011,ccr
				jsr			\false
				move.l		d1,(a0)
				

\true			addq.l		#1,a7
				ori.b 		#%00000100,ccr 
				rts
\false			movem.l		(a7)+,a0/d0
				andi.b 		#%11111011,ccr 
				rts
					
String1 		dc.b 		"104+9*2-3",0
