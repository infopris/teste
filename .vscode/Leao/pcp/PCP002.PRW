#include "rwmake.ch"

User Function PCP002()   // Pedidos aptos a faturar

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PCP002    ³ Autor ³ Luiz Eduardo Tapajos  ³ Data ³ 31.10.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtra OPs para Programacao da producao                     ³±±
±±³Telas     ³oDlg  - Tela Inicial do sistema de movimentacao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa  ³Especifico Espelhos Leao  o@&L2004                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Versao/Prg³Descricao                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³1.0 Luiz  ³Desenvolvimento do programa                        31.10.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Private cCod,nRes,cLoc
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas Selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas p/ Parametros :                         ³
//³                                                              ³
//³ mv_par01  // Emissao Pedidos de                              ³
//³ mv_par02  // Emissao Pedidos ate                             ³
//³ mv_par03  // Entrega de                                      ³
//³ mv_par04  // Entrega Ate                                     ³
//³ mv_par05  // Cliente de                                      ³
//³ mv_par06  // Cliente ate                                     ³
//³ mv_par07  // Somente liberados ?                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//if !Pergunte("PCP015", .t.)
//   Return
//Endif

// Buscar pedidos em aberto

AbreArq()

Static Function AbreArq()

aCamposA := {}
AADD(aCamposA,{ "NUM"     , "C",06,0})
AADD(aCamposA,{ "ITEM"    , "C",02,0})
AADD(aCamposA,{ "CLIENTE" , "C",08,0})
AADD(aCamposA,{ "NOME"    , "C",30,0})
AADD(aCamposA,{ "EMISSAO" , "D",08,0})
AADD(aCamposA,{ "ENTREGA" , "D",08,0})
AADD(aCamposA,{ "COD"     , "C",15,0})
AADD(aCamposA,{ "DESC"    , "C",30,0})
AADD(aCamposA,{ "QUANT"   , "N",12,2})
AADD(aCamposA,{ "QTDPED"  , "N",12,2})
AADD(aCamposA,{ "VALOR"   , "N",12,2})
AADD(aCamposA,{ "PERC"    , "N",08,2})
AADD(aCamposA,{ "PRONTAS" , "N",12,2})
AADD(aCamposA,{ "FAZER"   , "N",12,2})
AADD(aCamposA,{ "LIB"     , "C",02,0})
AADD(aCamposA,{ "UM"      , "C",02,0})
AADD(aCamposA,{ "SALDO"   , "N",12,2})
AADD(aCamposA,{ "COND"    , "C",15,0})
AADD(aCamposA,{ "FATOR"   , "C",01,0})
AADD(aCamposA,{ "OK"      , "C",02,0})

nNumTmp1 := 2
nNumTmp2 := 3
if select("trb") # 0
	trb->(dbclosearea())
endif

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCamposA)
dbUseArea( .T.,,cTemp, "TRB", Nil, .F. )
//Index on Num to &cTemp
IndRegua("TRB", cTemp, "Num", , , "Selecionando Registros...")

if select("trb1") # 0
	trb1->(dbclosearea())
endif
cTemp1:= CriaTrab(nil,.f.)
copy to &cTemp1
dbUseArea( .T.,,cTemp1, "TRB1", Nil, .F. )
//Index on Num to &cTemp1
IndRegua("TRB1", cTemp1, "Num", , , "Selecionando Registros...")

Processa( {|| RunProc() } )

if select("trb") # 0
	trb->(dbclosearea())
endif

if select("trb1") # 0
	trb1->(dbclosearea())
endif

Return


************************
Static Function RunProc()  // Executa o processamento
*************************

if select("trb") = 0
	Return
endif

dbSelectArea("SC0")
dbGoTop()
ProcRegua(recCount())
//set filter to left(c0_produto,4)='1013' .and. substr(c0_produto,9,2)='MF'
While !eof()
	
	IncProc()
	if sc0->c0_num="036361"
		x:=1
	endif
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+sc0->c0_num+left(sc0->c0_docres,2)
	if sc6->c6_qtdent>=sc6->c6_qtdven .or. sc6->c6_blq=="R "
		Select SC0
		skip
		loop
	Endif
	
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+SC6->C6_NUM
	Select SE4
	dbSetOrder(1)
	Seek xFilial()+SC5->C5_CONDPAG
	Select SA1
	dbSetOrder(1)
	Seek xFilial()+SC5->(C5_CLIENTE+C5_LOJACLI)
	if sa1->a1_codbar#'S'
		cLoc := "01"
	else
		cLoc := "CB"
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acumular os valores dos pedidos.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPerc1 := nPerc2 := 0
	
	cCod := left(sc6->c6_produto,15)
	
	
	if left(cCod,1)=="0"
		cCod := "1"+substr(cCod,2,14)
	endif
	Select SB1
	Seek xFilial()+cCod
	nRes := 0
	if sb1->b1_grupo>"20"
		cCod := sc6->c6_produto
		Select SC0
		nRec := recno()
		dbSetOrder(2)
		Seek xFilial()+cCod // SC6->C6_PRODUTO
		Verres("1")
	Else // Espelhos (A/B/C)
		cPos := at(".",sc6->c6_produto)
		if (substr(cCod,cPos+1,1)=="1" .or. substr(cCod,cPos+1,1)=="2") .and. substr(cCod,cPos,1)=='.'
			cCod := left(cCod,cPos-1)+".0"+substr(ccod,cPos+2,14)
		endif
		
		Select SC0
		nRec := recno()
		dbSetOrder(2)
		Seek xFilial()+left(cCod,5) // SC6->C6_PRODUTO
		Verres("2")
	endif
	
	Select SC0
	dbSetOrder(1)
	goto nRec
	
	Select SB2
	seek xFilial()+cCod+sc0->c0_local
	do case
		Case Sb2->b2_qatu - nRes <= 0
			nPronta := 0
		Case sb2->b2_qatu - nRes > 0
			if (sb2->b2_qatu - nRes)>=(SC6->C6_QTDVEN-SC6->C6_QTDENT)
				nPronta := SC6->C6_QTDVEN-SC6->C6_QTDENT
			else
				nPronta := (sb2->b2_qatu - nRes)
			endif
	endcase
	Select TRB
	RecLock("TRB",.T.)
	TRB->NUM        := SC5->C5_NUM
	TRB->ITEM       := SC6->C6_ITEM
	TRB->CLIENTE    := SC5->C5_CLIENTE+SC5->C5_LOJACLI
	TRB->NOME       := SA1->A1_NOME
	TRB->COND       := SE4->E4_DESCRI
	TRB->EMISSAO    := SC5->C5_EMISSAO
	TRB->ENTREGA    := SC6->C6_ENTREG
	TRB->QTDPED     := SC6->C6_QTDVEN-SC6->C6_QTDENT
	TRB->COD        := cCod
	TRB->DESC       := Sb1->b1_desc
	TRB->QUANT      := SC6->C6_QTDVEN
	TRB->VALOR      := SC6->C6_VALOR
	TRB->UM         := Sb1->b1_um
	TRB->saldo      := Sb2->b2_qatu - nRes
	TRB->prontas    := nPronta
	TRB->fazer      := SC6->C6_QTDVEN-SC6->C6_QTDENT-nPronta
	TRB->fator      := SC5->C5_Fator
	TRB->perc       := (Sb2->b2_qatu-nRes)/(SC6->C6_QTDVEN-SC6->C6_QTDENT)
	TRB->ok         := iif(!empty(sc0->c0_codant)," ","OK")
	MsUnLock()
	
	dbSelectArea("SC0")
	dbSkip()
End

Select TRB
dbGoTop()
Do while !eof()
	nReg := recno()
	cNum := trb->Num
	cOk  := trb->Ok
	nQt1 := nQT2 := nQt3 := nQt4 := nQt5 := nQt6 := 0
	Do while !eof() .and. trb->Num==cNum
		nQt1 := nQt1 + trb->Qtdped
		nQt2 := nQt2 + trb->Valor
		nQt3 := nQt3 + iif(trb->Saldo>trb->Qtdped,trb->Qtdped,trb->Saldo)
		nQt5 := nQt5 + trb->Prontas
		nQt6 := nQt6 + trb->Fazer
		skip
	Enddo
	nReg1 := recno()
	goto nReg
	Select TRB1
	RecLock("TRB1",.T.)
	TRB1->NUM        := trb->Num
	TRB1->ITEM       := " "
	TRB1->LIB        := " "
	TRB1->CLIENTE    := trb->Cliente
	TRB1->NOME       := trb->Nome
	TRB1->COND       := trb->Cond
	TRB1->EMISSAO    := trb->emissao
	TRB1->ENTREGA    := trb->entrega
	TRB1->VALOR      := nQt2
	TRB1->UM         := trb->um
	TRB1->fator      := trb->fator
	TRB1->QTDPED     := nQt1
	TRB1->saldo      := nQt3
	TRB1->prontas    := nQt5
	TRB1->fazer      := nQt6
	TRB1->perc       := nQt5/nQt1 // if(nQt3>nQt1,100,iif(nQt3>0,nQt3/nQt1,0))
	TRB1->ok         := cOk
	MsUnLock()
	Select TRB
	goto nReg1
	
enddo

Select TRB
//copy to \x

Go Top


Tela1()

//Select TRB
//Use

Return

*************************
Static Function Tela1()
*************************

Select TRB1
dbGoTop()

aCampos1:= {}
//AADD(aCampos1,{"OK" ,"Fat","@!"})
AADD(aCampos1,{"NUM","Pedido","@!"})
AADD(aCampos1,{"NOME","Nome Cliente"})
AADD(aCampos1,{"COD","Produto","@!"})
AADD(aCampos1,{"QTDPED","Qtde","@E 999,999.99"})
AADD(aCampos1,{"ENTREGA","Entrega"})
AADD(aCampos1,{"SALDO","Estq","@E 999,999"})
AADD(aCampos1,{"PERC"   ,"% Estq"})
AADD(aCampos1,{"PRONTAS","Prontas"})
AADD(aCampos1,{"FAZER"  ,"Fazer"})
AADD(aCampos1,{"VALOR","Valor","@E 999,999.99"})
AADD(aCampos1,{"COND","Cond.Pgto"})
AADD(aCampos1,{"FATOR","Fator"})
AADD(aCampos1,{"CLIENTE","Cliente"})
AADD(aCampos1,{"EMISSAO","Emissao"})
AADD(aCampos1,{"LIB"    ,"Liberado"})
AADD(aCampos1,{"QTDPED","Sld Ped","@E 999,999.99"})

@ 010,1 TO 500,950 DIALOG oDlg2 TITLE "Pedidos aptos a faturar"

@ 005,5 TO 215,460 BROWSE "TRB1" FIELDS aCampos1 ENABLE "!OK"


//@ 225,040 BUTTON "_Totaliza"       SIZE 50,15 ACTION TotPed()
//@ 225,085 BUTTON "_Faturar "       SIZE 50,15 ACTION FatPed()
//@ 225,130 BUTTON "_Inclui Pedido"  SIZE 50,15 ACTION IncPed()
//@ 225,175 BUTTON "_Pedidos Seleci." SIZE 50,15 ACTION PedSel()
//@ 225,220 BUTTON "_Atualiza Saldo"  SIZE 50,15 ACTION AtuSal()

@ 225,060 BUTTON "_Visualiza Pedido"  SIZE 50,15 ACTION VerPed()
@ 225,120 BUTTON "_Faturar Pedido"    SIZE 50,15 ACTION FatPed()
@ 225,180 BUTTON "_Estorna Faturam."  SIZE 50,15 ACTION EstPed()
@ 225,240 BUTTON "_Imprime a Faturar" SIZE 50,15 ACTION ImpFat()
//@ 225,300 BUTTON "_Pesquisa"        SIZE 50,15 ACTION Pesq()
@ 225,360 BUTTON "_Sai" SIZE 40,15 ACTION Close(oDlg2)

ACTIVATE DIALOG oDlg2 CENTERED
Return

******************************************************************************
* Parei aqui, falta fazer :
* - mostrar valor total a faturar e total de pecas
******************************************************************************

****************************
Static Function VerPed()
****************************
Select TRB
seek trb1->Num
cTemp2 := CriaTrab(nil,.f.)
copy to &cTemp2 next 100 for trb->Num==trb1->Num
dbUseArea( .T.,,cTemp2,"TRB2", Nil, .F. )


aCampos := {}
//AADD(aCampos,{"OK","OK"})
AADD(aCampos,{"Num","Pedido","@!"})
AADD(aCampos,{"COD","Produto","@!"})
AADD(aCampos,{"QTDPED","Sld Ped","@E 999,999.99"})
AADD(aCampos,{"SALDO","Estq","@E 999,999"})
AADD(aCampos,{"Valor","Valor","@E 999,999.99"})
AADD(aCampos,{"PERC"   ,"% Estq"})
AADD(aCampos,{"PRONTAS","Prontas"})
AADD(aCampos,{"FAZER"  ,"Fazer"})
AADD(aCampos,{"quant" ,"Qtde Pedido","@E 999,999"})
AADD(aCampos,{"Cliente","Nome do Cliente"})
AADD(aCampos,{"Entrega","Prev.Entr."})
AADD(aCampos,{"Fator","Fator"})

@ 001,000 TO 300,650 DIALOG oDlgFat TITLE "Visualiza Pedido"

//@ 6,5 TO 210,350 BROWSE "TRB1" FIELDS aCampos ENABLE "OK" MARK "OK"
@ 10,05 TO 100,300 BROWSE "TRB2" FIELDS aCampos

@ 120,150 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlgFat)

ACTIVATE DIALOG oDlgFat CENTERED
Select TRB2
use
Select TRB
Return

*-------------------------*
Static Function FatPed()      // Escolhe Pedidos Para Faturar
*-------------------------*
dFat := dDataBase
@ 050,50 TO 180,450 DIALOG oDlg1 TITLE "Confirma"
@ 05,005 TO 60,150
@ 15,010 say "Faturar Pedido "+trb1->Num
@ 30,010 say "Cliente " +trb1->Nome
@ 45,010 say "Data do Faturamento"
@ 45,070 get dFat  SIZE 40,20  VALID .t.
@ 10,160 BMPBUTTON TYPE 1 ACTION FatPed1()
@ 25,160 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

*-------------------------*
Static Function FatPed1()
*-------------------------*
Close(oDlg1)
Close(oDlg2)   // Luiz - 30-07-12

Select SC5
dbSetOrder(1)
seek xFilial()+trb1->Num
RecLock("SC5",.f.)
sc5->c5_os     := substr(dtos(dFat),3,6)
MsUnLock()

Select SC0
dbSetOrder(1)
seek xFilial()+trb1->Num
do while !eof() .and. c0_num==trb1->Num
	RecLock("SC0",.F.)
	sc0->c0_codant := substr(dtos(dFat),3,6)
	MsUnlock()
	skip
enddo

Select TRB1
RecLock("TRB1",.f.)
TRB1->ok := "  "
//dele
MsUnLock()
Select TRB
dbgotop()
use
Select TRB1
dbgotop()
use

AbreArq()

RunProc() //// Luiz - 30-07-12 Reativei o novo processamento

Return

// Desativei esse processamento
Close(oDlg2)
Select TRB
Use
Select TRB1
Use

cTemp2 := CriaTrab(nil,.f.)
dbCreate(cTemp,aCamposA)
dbUseArea( .T.,,cTemp, "TRB", Nil, .F. )
//Index on Num to &cTemp2
IndRegua("TRB", cTemp2, "Num", , , "Selecionando Registros...")

cTemp3 := CriaTrab(nil,.f.)
copy to &cTemp1
dbUseArea( .T.,,cTemp1, "TRB1", Nil, .F. )
//Index on Num to &cTemp3
IndRegua("TRB1", cTemp3, "Num", , , "Selecionando Registros...")

RunProc()

Return

*-------------------------*
Static Function EstPed()      // Estorna Pedidos a Faturar
*-------------------------*
if !MsgBox ("Cancela o faturamento ? "+trb1->Num,"Escolha","YESNO")
	Return
endif
Select SC5
dbSetOrder(1)
seek xFilial()+trb1->Num
RecLock("SC5",.f.)
sc5->c5_os     := " "
MsUnLock()

Select SC0
dbSetOrder(1)
seek xFilial()+trb1->Num
do while !eof() .and. c0_num==trb1->Num
	RecLock("SC0",.f.)
	sc0->c0_codant := " "
	MsUnLock()
	skip
enddo

Select TRB1
RecLock("TRB1",.f.)
TRB1->ok := "OK"
//dele
MsUnLock()

Close(oDlg2)
Select TRB
Use
Select TRB1
Use

AbreArq()

RunProc() // Luiz - 30-07-12 Reativei o novo processamento

Return

cTemp2 := CriaTrab(nil,.f.)
dbCreate(cTemp,aCamposA)
dbUseArea( .T.,,cTemp, "TRB", Nil, .F. )
//Index on Num to &cTemp2
IndRegua("TRB", cTemp2, "Num", , , "Selecionando Registros...")

cTemp3 := CriaTrab(nil,.f.)
copy to &cTemp1
dbUseArea( .T.,,cTemp1, "TRB1", Nil, .F. )
//Index on Num to &cTemp3
IndRegua("TRB1", cTemp3, "Num", , , "Selecionando Registros...")

RunProc()

Return


************************
Static Function ImpFat()
************************
dFat := dDataBase
cMostra := "N"
@ 050,50 TO 180,450 DIALOG oDlg1 TITLE "Confirma"
@ 05,005 TO 60,150

@ 30,010 say "Data do Faturamento"
@ 30,070 get dFat  SIZE 40,20  VALID .t.
@ 45,010 say "Mostra Valores ?"
@ 45,070 get cMostra SIZE 40,20  VALID cMostra$"S*N" PICTURE "@!"
@ 10,160 BMPBUTTON TYPE 1 ACTION ImpFat1()
@ 25,160 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

************************
Static Function ImpFat1()
************************

Close(oDlg1)

mv_par01 := dFat

// MV_PAR01 - Data do Faturamento

cString:="SC0"
cDesc1:= "Pedidos a Faturar"
cDesc2:= ""
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="PCP002"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Pedidos a Faturar "+DTOC(dDataBase)
cabec1      :="Pedido    Cliente                             Valor    Faturar "
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0

wnrel:="PCP002"            //Nome Default do relatorio em Disco

SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| RptFat() })
Return

***************************
Static Function RptFat()
***************************

Select SC0
go top
SetRegua(RecCount())
nLin := 80
nVal := 0
Do while !eof()
	IncRegua()
	if sc0->c0_codant # substr(dtos(dFat),3,6)
		Skip
		Loop
	Endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 8
	Endif
	Select SC5
	Seek xFilial()+sc0->c0_Num
	Select SA1
	seek xFilial()+sc5->(c5_cliente+c5_lojacli)
	Select SC6
	seek xFilial()+sc0->c0_num
	nValPed := nQtdPed := 0
	dEnt := sc6->c6_entreg
	do while !eof() .and. sc6->c6_num == sc0->c0_num
		nValPed := nValPed +sc6->c6_valor
		nQtdPed := nQtdPed +sc6->c6_qtdven - sc6->c6_qtdent
		Skip
	enddo
	Select SC0
	@ nLin,000 PSAY sc0->c0_Num
	@ nLin,010 PSAY left(sa1->a1_nome,30)
	if cMostra=="S"
		@ nLin,042 PSAY nValPed  PICTURE "@E 999,999.99"
	endif
	@ nLin,055 PSAY mv_par01
	@ nLin,065 PSAY sc5->c5_nota
	nVal := nVal + nValPed
	nLin := nLin + 1
	cNum := sc0->c0_num
	Do while !eof() .and. sc0->c0_num == cNum
		Skip
	Enddo
Enddo
if nLin#80
	if cMostra=="S"
		@ nLin+1,042 PSAY nVal PICTURE "@E 999,999.99"
	endif
	
	Roda(0,"","P")
	Set Filter To
	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
Endif
MS_FLUSH()


Return

*****************************
Static Function Verres(cTipo)
*****************************
if cTipo='1'
	do while !eof() // .and. SC6->C6_PRODUTO==SC0->C0_PRODUTO
		if sb1->b1_grupo >"20" .and. SC6->C6_PRODUTO<>SC0->C0_PRODUTO
			exit
		endif
		if sb1->b1_grupo <="20" .and. left(cCod,at(".",cCod))<>left(sc0->c0_produto,at(".",sc0->c0_produto));
			.and. substr(cCod,at(".",cCod)+2,10)<>substr(sc0->c0_produto,at(".",sc0->c0_produto)+2,10)
			exit
		endif
		if empty(c0_codant)
			skip
			loop
		endif
		Select SD2
		dbSetOrder(8)
		Seek xFilial()+sc6->C6_Num+sc6->c6_Item
		if eof()
			nRes := nRes + sc0->c0_quant
		endif
		Select SC0
		skip
	enddo
else
	Select SC0
	cCod1 := left(cCod,at(".",cCod))
	do while !eof()  .and. left(sc0->c0_produto,at(".",sc0->c0_produto))==cCod1
		if left(cCod,at(".",cCod))<>left(sc0->c0_produto,at(".",sc0->c0_produto));
			.or. substr(cCod,at(".",cCod)+2,10)<>substr(sc0->c0_produto,at(".",sc0->c0_produto)+2,10)
			skip
			loop
		endif
		if empty(c0_codant)
			skip
			loop
		endif
		Select SD2
		dbSetOrder(8)
		Seek xFilial()+sc0->C0_Num+left(sc0->c0_docres,2)
		if eof() .and. sc0->c0_local == cLoc
			nRes := nRes + sc0->c0_quant
		endif
		Select SC0
		skip
	enddo
endif
