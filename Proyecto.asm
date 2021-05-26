%include "io.mac"
.DATA
	welcomemsg db 'BIENVENIDO A ESTE JUEGO DE TRIVIA',0Ah,0Dh,'Por Luis Araya y Josue Gutierrez',0
	gamemode db 'Un jugador(1) o  dos jugadores(2): ',0
	puntajemsg db ' su puntaje es de: ',0
	inputname1 db 'Ingrese su nombre jugador1: ',0
	inputname2 db 'Ingrese su nombre jugador2: ',0
	inputans db 'Ingrese su respuesta: ',0
	turnomsg db 'Es el turno de ',0
	error db 'ACA',0
	;formato pregunta+respCorrecta+resp1+resp2+respN-
	preguntas db 'Cual no es una provincia?+1+Cartagena+Cartago-Cual no es simbolo nacional?+1+Perro+Colibri-',0
.UDATA
	namep1 resb 10
	namep2 resb 10
	respCorrecta resb 1
	puntajeP1 resb 1
	puntajeP2 resb 1
	turno resb 1
	numPreguntas resb 30
.CODE
	.STARTUP
	PutStr welcomemsg
	nwln
	PutStr gamemode
	GetCh AL
	xor CL,CL
	cmp AL,'1'
	je solo
	jmp multi


	solo:
		PutStr inputname1
		GetStr namep1,10
		xor ESI,ESI
		mov DL,1
		soloInicio:
			cmp CL,2
			je doneSolo
		
			call imprimir
			inc CL
			PutStr inputans
			GetCh AL
			
			cmp AL, [respCorrecta]
			jne noPointsSolo
			add [puntajeP1],DL
			
			noPointsSolo:
				jmp soloInicio


		

	multi:
		
		mov DL,1
		PutStr inputname1
		GetStr namep1,10
		PutStr inputname2
		GetStr namep2,10

		cambio:
			cmp CL,2
			je doneMulti

			mov BL,[turno]
			cmp BL,0
			je turnoP1
			jmp turnoP2


			turnoP1:
				PutStr turnomsg
				PutStr namep1
				nwln
				inc BL
				mov[turno],BL
				call imprimir
				inc CL
				PutStr inputans
				GetCh AL
				
				cmp AL, [respCorrecta]
				jne noPointsMulti
				add [puntajeP1],DL
				jmp noPointsMulti
			turnoP2:
				PutStr turnomsg
				PutStr namep2
				nwln
				
				dec BL
				mov[turno],BL
				call imprimir
				inc CL
				PutStr inputans
				GetCh AL
				cmp AL, [respCorrecta]
				jne noPointsMulti
				add [puntajeP2],DL
			noPointsMulti:
				jmp cambio

doneSolo:
	PutStr namep1
	PutStr puntajemsg
	PutInt [puntajeP1]
	nwln
	jmp done

doneMulti:
	xor CX,CX
	PutStr namep1
	PutStr puntajemsg
	mov CL,[puntajeP1]
	PutInt CX
	nwln
	xor CX,CX
	PutStr namep2
	PutStr puntajemsg
	mov CL,[puntajeP2]
	PutInt CX
	nwln
done:
	
	.EXIT

;---------------------------------PROCEDIMIENTOS------------------------------
;--------------------------------Imprimir pregunta----------------------------
imprimir:
	impPregunta:
		mov AL,[preguntas+ESI]
		cmp AL,'+'
		je setRespCorr
		PutCh AL
		inc ESI
		jmp impPregunta
	setRespCorr:
		inc ESI
		mov AL, [preguntas+ESI]
		mov [respCorrecta],AL
		
		inc ESI
		
	impResps:
	 	nwln
		inc ESI
		impResp:
			mov AL,[preguntas+ESI]
			cmp AL,'+'
			je impResps
			cmp AL,'-'
			je impDone
			PutCh AL
			inc ESI
			jmp impResp

	impDone:
		nwln
		inc ESI
		ret
;-----------------GENERAR RANDOM---------------------
;------------------Select Menos----------------------
;suponemos que el numero del - se guarda en el AL
menosNum:
	xor AH,AH
	xor ESI,ESI
	contarMenos:
		cmp AL,AH
		je doneMenos

			moverPunt:
				mov DL,[preguntas+ESI]
				cmp DL,'-'
				je validarMenos
				inc ESI
				jmp moverPunt
			validarMenos:
				inc AH
				inc ESI
				jmp contarMenos

	doneMenos:
		ret