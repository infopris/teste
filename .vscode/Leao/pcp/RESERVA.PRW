#include "rwmake.ch"

User Function RESERVA()    // Acerto de Reservas


SetPrvt("CRESP,XTOT,XCONTA,CRESP1,NQUANT,")

if !MsgBox ("Confirma acerto de reservas ?","Escolha","YESNO")
	Return
endif
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 13/08/01 ==> Processa( {|| Execute(RunProc) } )
Return

Static Function RunProc()

ProcRegua(reccount())


cQuery  := " UPDATE "+ RetSqlName("SB2") + " SET B2_RESERVA = 0 "
cQuery  += " WHERE B2_RESERVA<>0 " 

nRet    := TCSQLExec(cQuery)

select SB2
set order to 1
dbgotop()
xConta := 1
While !Eof()
	IncProc()
//	goto xConta
	Select SB1
	dbsetOrder(1)
	Seek xFilial()+sb2->b2_cod
	Select SB2
	if !sb1->b1_tipo$"PA*RV"
		xConta := xConta + 1
		skip
		loop
	endif
	nQuant := 0
	// Para Quadros
	if sb1->b1_grupo>"20"
		VerQtd(sb2->b2_cod)
	Else // Espelhos (A/B/C)
		if substr(sb2->b2_cod,at(".",sb2->b2_cod)+1,1)<>"0"
			//			xConta := xConta + 1
			//			loop
			nQuant := 0
		else
			VerQtd(sb2->b2_cod)
			cProd := left(sb2->b2_cod,at(".",sb2->b2_cod))+"1"+substr(sb2->b2_cod,at(".",sb2->b2_cod)+2,10)
			VerQtd(cProd)
			cProd := left(sb2->b2_cod,at(".",sb2->b2_cod))+"2"+substr(sb2->b2_cod,at(".",sb2->b2_cod)+2,10)
			VerQtd(cProd)
		endif
	Endif
	select SB2
	if B2_Reserva #nQuant
		Reclock("SB2",.f.)
		SB2->B2_Reserva := nQuant
		MsUnlock()
	endif
	skip
	xConta := xConta + 1
End

RETURN

************************
Static Function VerQtd(cCod)
************************

select SC0
set order to 2
seek xFilial()+cCod+sb2->b2_local
do while sc0->(c0_produto+c0_local) == cCod+sb2->b2_local .and. !eof()
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+sc0->c0_num+left(sc0->c0_docres,2)
	nSaldo := sc6->(c6_qtdven-c6_qtdent)
	Select SC0
	if nSaldo<=0 .or. trim(sc6->c6_blq)=="R"
		RecLock("SC0",.F.)
		Delete
		MsUnlock()
	else
		reclock("SC0",.F.)
		SC0->C0_Quant := nSaldo
		MsUnlock()
	endif
	Select SC0
	nQuant := nQuant + nSaldo
	skip
enddo
Select SB2
Return
