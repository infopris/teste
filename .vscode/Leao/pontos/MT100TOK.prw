#include "rwmake.ch"  
/**************************************************************************************
.Programa  : MT100TOK
.Autor     : Luiz Eduardo
.Data      : 20/01/21
.Descricao : Ponto de entrada para verificar se o Energia/Telefone com Tipo correto
**************************************************************************************/
User Function MT100TOK()

Local lRet:= .t.
Local _Rotina := FunName()
Local _x      := 0
Local _Valida := .F.
Local _TES    := ""

cAlias := Alias()
cInd   := IndexOrd()
nRec1  := recno()   

If Trim(Upper(_Rotina)) $ "MATA103/MATA100/CALL103" .and. sa2->a2_tipo="F"
	
	If lRet .And. Len(aCols) > 0
		
		For _x := 1 To Len(aCols)
			
			// Verifica se a linha esta deletada
			// Verifica tambem se os campos D1_TES e D1_NATUREZ existem.
			If !GdDeleted(_x) .And. GdFieldPos("D1_COD",_x) > 0 
				_COD    := aCols[ _x , AScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD" }) ]
				_Desc := Posicione("SB1",1,xFilial("SB1")+_COD,"B1_DESC")
				If ("TELEFONE"$_Desc) .AND. cEspecie<>"NTST"
					MsgAlert("Nota fiscal de telefonia, utilizar a espécie NTST")
					lRet := .F.
				EndIf
				If ("ENERGIA"$_Desc) .AND. cEspecie<>"NFCEE"
					MsgAlert("Nota fiscal de Energia, utilizar a espécie NFCEE")
					lRet := .F.
				EndIf
			EndIf
		Next _x
	EndIf
EndIf
IF !lRet
	Return lRet
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MT100TOK  ³ Autor ³ Luiz Eduardo Santos   ³ Data ³20/01/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Altera o numero da nota fiscal, inclui zeros à esq do número³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³#MT100TOK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/                


cNFiscal := strzero(val(cNFiscal),9)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MT100TOK  ³ Autor ³ Luiz Eduardo Santos   ³ Data ³08/12/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualiza peso e volume na NFe                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³#MT100TOK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/                

** Abertura dos arquivos

dbSelectArea("SF1")
dbSetOrder(1)
MsSeek(xFilial("SF1")+TRIM(M->CNFISCAL)+TRIM(M->CSERIE)+TRIM(M->CA100FOR)+TRIM(M->CLOJA))

dReceb := SF1->F1_RECBMTO
@ 96,42 to 323,505 dialog oDlg2 title "Recebimento "+sf1->f1_doc
@ 8,10 to 84,222
@ 47,015 say "Data Rec. :"
@ 47,045 get dReceb  size 60,20

@ 91,109 BUTTON "Ok " SIZE 50,10 ACTION CLOSE(ODLG2)
activate dialog odlg2 centered
Select SF1
if rlock()
	SF1->F1_RECBMTO := dReceb
endif

dbSelectArea(cAlias)
dbSetOrder(cInd)
dbGoto(nRec1)


lRet:= .t.

Return( lRet )


