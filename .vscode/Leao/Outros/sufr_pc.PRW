#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 24/11/01

User Function sufr_pc()        // Corrige valor Pis/Cofins Suframa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6")

cResp := '000000'
cPref := '1  '
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Ajusta PIS Cofins Suframa da NF"
@ 05,010 TO 45,180
@ 16,030 Say 'Nota Fiscal : '
@ 16,100 get cresp pict '@!' SIZE 40,20  VALID .t.
@ 28,030 Say 'Prefixo     : '
@ 28,100 get cPref pict '@!' SIZE 40,20  VALID .t.
@ 50,150 BUTTON "Confirma" Size 40,15  ACTION imped()// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==> @ 50,150 BUTTON "Confirma" Size 40,15  ACTION Execute(R01Imp)
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
return

*---------------*
Static Function Imped()
*---------------*

Select SF2
dbSetOrder(1)
Seek xFilial()+cResp+"   "+cPref
if eof()
	MsgBox ("Nota Fiscal nao encontrada !!","Informa‡ao","INFO")
	Return
endif
Close(oDlg1)

Select SD2
dbSetOrder(3)
Seek xFilial()+cResp+"   "+cPref
if eof() .or. d2_emissao <date()-5
	do while !eof() .and. d2_doc=cResp
		if d2_emissao >= date()-5
			exit
		endif
		skip
	enddo
	if eof() .or. d2_emissao <date()-5
		MsgBox ("Nota Fiscal nao encontrada !!","Informa‡ao","INFO")
		Return
	endif
endif

Select SD2
dbSetOrder(3)
Seek xFilial()+cResp+"   "+cPref
if eof() .or. d2_emissao >date()-5
	do while !eof() .and. d2_doc=cResp .and. d2_serie=cPref
		if d2_cf='6109'
		reclock("SD2",.f.)
		SD2->D2_DESCZFP := D2_BASIMP6 * .03
		SD2->D2_DESCZFC := D2_BASIMP6 * .0765
		MsunLock()
		endif
		skip
	enddo
endif

Close(oDlg1)
Return
