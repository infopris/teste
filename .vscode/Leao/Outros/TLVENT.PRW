#include "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TMKCLI   ³ Autor ³   Alexandro Dias      ³ Data ³25.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava setor de vendas.                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TLVENT(oTpMidia, cTpMidia, aTpMidia, aCodMidia, ;
oTipMar, cTipMar, aTipMar, ;
oVend, cVend, ;
oTipOpe, cTipOpe, ; 
oCampaV, cCampaV, aCampaV, aCodCampaV, ;
oLigacao, cLigacao, aLigacao, aCodLiga, ;
cDesc, oDesc, cContato,oContato, cCodCont,lFim)

Local _xAlias   := GetArea()
Local _aSetor   := {"C=Setor C","B=Setor B","A=Setor A","S=Setor S"}
Local _aTpFrete := {"C=CIF","F=FOB"}
Local _aRepres  := {"S=Sim","N=Nao"}
Local _aPagto   := {"A=Tab1-A Vista","B=Tab2-14DD","C=Tab3-30DD","D=Tab4-45DD","E=Tab5-60DD","F=Tab6-75DD","G=Tab7-90DD"}
Local _aCalcPrc := {"N=Nao","S=Sim"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis publicas seram utilizadas no TMKVFIM ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Select SC5
dbSetOrder(1)
Seek xFilial()+sua->ua_numsc5

Public _cCalcPrc  := ""
Public _cRepres   := ""
Public _cPagto    := ""
Public _cSetor    := sc5->c5_fator
Public _cTpFrete  := sc5->c5_TPFRETE
Public _cNumPed   := sc5->c5_PEDCLI
Public _dDataEmis := DATE()
Public _cCli      := sa1->(A1_Cod+A1_Loja)

Return   // Para nao executar mesmo

//IF !lFim
	
	@ 000,000 TO 240,250 DIALOG oDlg TITLE "Dados Complementares."
	
	@ 015,005 SAY "Setor:"      SIZE 30,10
	@ 015,055 COMBOBOX _cSetor ITEMS _aSetor SIZE 50,20
	
	@ 030,005 SAY "Tipo Frete:" SIZE 30,10
	@ 030,055 COMBOBOX _cTpFrete ITEMS _aTpFrete SIZE 50,20
	
	@ 045,005 SAY "Pedido Cliente:" SIZE 50,10
	@ 045,055 Get _cNumPed Picture "@!" SIZE 50,20

	@ 060,005 SAY "Calcula Preco ?" SIZE 50,10
	@ 060,055 COMBOBOX _cCalcPrc ITEMS _aCalcPrc  SIZE 50,20

//	@ 075,005 SAY "Representante :" SIZE 50,10
//	@ 075,055 COMBOBOX _cRepres ITEMS _aRepres  SIZE 50,20

	@ 075,005 SAY "Pedido Cliente:" SIZE 50,10
	@ 075,055 COMBOBOX _cPagto  ITEMS _aPagto   SIZE 50,20
 
	@ 090,080 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	
	ACTIVATE DIALOG oDlg CENTER
//EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa combo do operador   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SU7")
DbSetOrder(3)
If DbSeek(xFilial("SU7") + Alltrim(Substr(cUsuario,7,15)))
	cOperador:=U7_NOME
//	oOperador:Refresh()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa combo de midia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SUH")
dbSetOrder(1)
If dbSeek(xFilial("SUH") + "000001" )
	cTpMidia := UH_DESC
//	oTpMidia:Refresh()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa combo de marketing ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipMar := "ATIVO"
//oTipMar:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona cadastro de vendedores ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3") + SA1->A1_VEND)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa campo de vendedor ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cVend := A3_COD
//	oVend:Refresh()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa campo de vendedor ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cVend := Space(06)
//	oVend:Refresh()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa combo de operacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipOpe := "FATURAMENTO"
//oTipOpe:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa combo de ocorrencia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea("SU9")
//dbSetOrder(2)
//If dbSeek(xFilial("SU9") + GetMV("MV_OCOPAD"))
//    cLigacao := U9_DESC
//    oLigacao:Refresh()
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve estado inicial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//m->UA_TPFRETE := _aTpFrete

RestArea(_xAlias)

Return()
                   