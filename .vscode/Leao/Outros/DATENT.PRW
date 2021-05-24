#include "rwmake.ch"   

User Function DATENT()        // Data de Entrada da Nota Fiscal

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")
 
cDoc  	:= '000000000'
cSerie 	:= 'UNI'
cForn	:= "000000"
cLoja	:= "01"
dDt 	:= ctod("0")
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Data da Entrada da NF"
@ 05,010 TO 54,180 
@ 16,030 Say 'Prefixo+Nota: '
@ 16,070 get cSerie pict '@!' SIZE 30,20  VALID .t.
@ 16,110 get cDoc  pict '@!' SIZE 40,20  VALID .t.
@ 28,030 Say 'Fornecedor  : '
@ 28,070 get cForn pict '@!' SIZE 40,20  VALID .t. F3 "SA2"
@ 28,110 get cLoja pict '@!' SIZE 20,20  VALID vernota()
@ 40,030 Say 'Digitacao   : '
@ 40,110 get dDt SIZE 40,20  VALID .t.
@ 60,110 BUTTON "Confirma" Size 40,15  ACTION Conf()
@ 60,160 BUTTON "Cancela"  Size 40,15  ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
return

*---------------*
Static Function Conf()
*---------------*

Select SD1
dbSetOrder(1)
Seek xFilial()+cDoc+cSerie+cForn+cLoja
if eof()
	MsgAlert("Nota nao cadastrada para esse fornecedor")
	Return
endif

if sd1->d1_dtdigit<GetMv("MV_ULMES")
	MsgAlert("Periodo fechado, nao eh possivel alterar a data")
	Return
endif
Do while !eof() .and. sd1->(d1_doc+d1_serie+d1_fornece+d1_loja)==cDoc+cSerie+cForn+cLoja
	if rlock()
		if empty(sd1->d1_chassi)
			sd1->d1_chassi := dtoc(sd1->d1_dtdigit)
		endif
		sd1->d1_dtdigit := dDt
	endif
	skip
enddo


Select SF1
dbSetOrder(1)
Seek xFilial()+cDoc+cSerie+cForn+cLoja
if rlock()
	sf1->f1_dtdigit := dDt
endif

Select SF3
dbSetOrder(5)
Seek xFilial()+cSerie+cDoc+cForn+cLoja
Do while !eof() .and. sf3->(f3_serie+f3_nfiscal+f3_cliefor+f3_loja)==cSerie+cDoc+cForn+cLoja
	if rlock()
		sf3->f3_entrada := dDt
	endif
	skip
Enddo

//Select SE2
//dbSetOrder(1)
//Seek xFilial()+cForn+cLoja+cSerie+cDoc
//if rlock()
//	se2->e2_emis1 := dDt
//endif


Close(oDlg1)

return

*---------------*
Static Function VerNota()
*---------------*
Select SD1
dbSetOrder(1)
Seek xFilial()+cDoc+cSerie+cForn+cLoja
if eof()
	MsgAlert("Nota nao cadastrada para esse fornecedor")
	Return
endif

if sd1->d1_dtdigit<GetMv("MV_ULMES")
	MsgAlert("Periodo fechado, nao eh possivel alterar a data")
	Return
endif

dDt := sd1->d1_dtdigit
