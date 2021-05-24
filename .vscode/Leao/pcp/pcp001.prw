#include "rwmake.ch"

User Function PCP001()   // Programar producao (Final)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PCP015    ³ Autor ³ Luiz Eduardo Tapajos  ³ Data ³ 19.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtra OPs para Programacao da producao                     ³±±
±±³Telas     ³oDlg  - Tela Inicial do sistema de movimentacao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa  ³Especifico Espelhos Leao  o@&L2004                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³25-08-06 ³ Impressao da OP quando incluir na programacao    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

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
if !Pergunte("PCP015", .t.)
	Return
Endif

if select("TRBA")<>0
	dbCloseArea("Trba")
Endif
if select("TRBB")<>0
	dbCloseArea("Trbb")
Endif


// Buscar nas OPs do programa SZL
aCampos := {}
AADD(aCampos,{ "OP"      , "C",11,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "QUANT"   , "N",12,2})
AADD(aCampos,{ "CLIENTE" , "C",08,0})
AADD(aCampos,{ "NOME"    , "C",30,0})
AADD(aCampos,{ "ENTREGA" , "D",8,0})
AADD(aCampos,{ "STATUS"  , "C",1,0})
AADD(aCampos,{ "SEQ"     , "N",6,0})
AADD(aCampos,{ "PEDIDO"  , "C",6,0})
AADD(aCampos,{ "ITEMPV"  , "C",2,0})
AADD(aCampos,{ "OK"      , "C",1,0})
cTempA := CriaTrab(nil,.f.)
dbCreate(cTempA,aCampos)
dbUseArea( .T.,,cTempA, "TRBA", Nil, .F. )
//Index on Op to &cTempA
IndRegua("TRBA", cTempA, "Op", , , "Selecionando Registros...")

// Buscar nas OPs do em Aberto SC2
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
AADD(aCamposA,{ "LIB"     , "C",02,0})
AADD(aCamposA,{ "UM"      , "C",02,0})
AADD(aCamposA,{ "SALDO"   , "N",12,2})
AADD(aCamposA,{ "COND"    , "C",15,0})
AADD(aCamposA,{ "PARCIAL" , "C",1,0})
AADD(aCamposA,{ "FATOR"   , "C",1,0})

// Declaracao de Variaveis
cNumPed := "000000"

cTempB := CriaTrab(nil,.f.)
dbCreate(cTempB,aCamposA)
dbUseArea( .T.,,cTempB, "TRBB", Nil, .F. )
//Index on Cod+Dtos(Entrega)+Cliente to &cTempB
IndRegua("TRBB", cTempB, "Cod+Dtos(Entrega)+Cliente", , , "Selecionando Registros...")

Processa( {|| RunProc() } )
Return


************************
Static Function RunProc()  // Executa o processamento
*************************

Select SC2
dbSetOrder(1)
go top
ProcRegua(recCount())
nQtdEsp := nValTot := 0
Do while !eof()
	IncProc()
	lAlt := .f.
	if sc2->c2_apfiff4==0 .and. c2_status#"S"  // Liberacao parcial
		VerAlt1()    //  Verifica se houve alteracao na OP
	endif
	
	Select SC2
	if deleted() .or. sc2->(c2_quant-c2_quje)<=0 .or. sc2->c2_datrf#ctod("0")
		skip
		loop
	endif
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+sc2->(c2_pedido+c2_itempv)
	Select SA1
	dbSetOrder(1)
	Seek xFilial()+SC6->(C6_CLI+C6_LOJA)
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+sc2->c2_produto
	reclock("TRBA",.t.)
	trba->Op     := sc2->(c2_num+c2_item+c2_sequen)
	trba->Cod    := sc2->c2_produto
	trba->Pedido := sc2->c2_pedido
	trba->Itempv := sc2->c2_itempv
	trba->Cliente:= sc6->(c6_cli+c6_loja)
	trba->Nome   := sa1->a1_nome
	trba->Quant  := sc2->(c2_quant-c2_quje)
	trba->Entrega:= sc2->c2_datprf
	msunlock()
	nValTot := nValTot + sc6->c6_valor
	if trim(sb1->b1_grupo)$"10*20" // .and. !left(trba->Cod,4)$"1004*1006*1010*1020*1021*1065"
		nQtdEsp := nQtdEsp + trba->Quant
	endif
	Select SC2
	Skip
Enddo
Select TRBA
cTemp12a := CriaTrab(nil,.f.)
//Index on Pedido to &cTemp12a //cTempA
IndRegua("TRBA", cTemp12a, "Pedido", , , "Selecionando Registros...")

Go Top

****************************
* Processa SC6
****************************
Processa( {|| ProcSC6() } )
Return


************************
Static Function ProcSC6()  // Executa o processamento
*************************

dbSelectArea("SC5")
dbSetOrder(2)  // C5_FILIAL+DTOS(C5_EMISSAO)+C5_NUM
dbSeek( xFilial("SC5") + Dtos(mv_par01),.T.)

cQuery := "SELECT C6_NUM,C6_QTDVEN,C5_EMISSAO,C6_PRODUTO,C6_ITEM, "
cQuery += "C6_ENTREG,C6_CHASSI,C6_LOCAL,C6_QTDEMP,C6_VALOR,C6_QTDENT "
cQuery += " FROM SC6010 SC6"
cQuery += " INNER JOIN SC5010 SC5"
cQuery += " ON C5_NUM=C6_NUM "
cQuery += " WHERE SC5.D_E_L_E_T_=' ' "
cQuery += " AND   SC6.D_E_L_E_T_=' ' "
cQuery += " AND C5_EMISSAO>='"+dtos(mv_par01)+"' "
cQuery += " AND C5_EMISSAO<='"+dtos(mv_par02)+"' "
cQuery += " AND C5_CLIENTE>='"+(mv_par05)+"' "
cQuery += " AND C5_CLIENTE<='"+(mv_par06)+"' "
cQuery += " AND C6_ENTREG>='"+dtos(mv_par03)+"' "
cQuery += " AND C6_QTDENT<C6_QTDVEN "
cQuery += " AND C6_BLQ<>'R' "
cQuery += " ORDER By C5_EMISSAO "


//	cQuery += " AND D1_TES<>'016' "

cQuery := ChangeQuery(cQuery)
IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP", .F., .T.)

Select Tmp
//COPY TO \X
ProcRegua(1200)//recCount())
dbgotop()

While !Eof()
	
	IncProc(C5_EMISSAO)
	
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+tmp->c6_num
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acumular os valores dos pedidos.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("Tmp")
	lIni := .t.
	lAlt := .f.
	While SC5->C5_NUM == Tmp->C6_NUM .And. !Eof()
		// Incluido para nao repetir pedidos com reserva no sistema - 05-05-2005
		dbSelectArea("SC0")
		dbSeek( xFilial("SC0")+SC5->C5_NUM+Tmp->C6_PRODUTO )
		dbSelectArea("SC6")
		if SC5->C5_NUM+tmp->C6_PRODUTO==SC0->C0_NUM+SC0->C0_PRODUTO
			dbSelectArea("SC2")
			Seek xFilial()+tmp->(c6_num+c6_item)
			if sc2->c2_apfiff4==0
				lAlt := .t. // Caso tenha um produto novo o sistema ira dar o alerta de pedido alterado
				dbSelectArea("TMP")
				dbSkip()
				Loop
			endif
		endif
		
		if left(TMP->c6_chassi,6)#space(6)  // Ignora se nÆo existir a OP - 05-05-2005
			dbSelectArea("SC2")  // Ignora se for Op parcial (c2_apfiff4#0) 09-11-05
			dbSetOrder(1)
			Seek xFilial()+trim(TMP->c6_chassi)
			dbSelectArea("SB1")
			dbSetOrder(1)
			Seek xFilial()+TMP->c6_produto
			dbSelectArea("TMP")
			if trim(sb1->b1_grupo)$"10*20"
				cProd := left(c6_produto,at(".",c6_produto))+"0"+substr(c6_produto,at(".",c6_produto)+2,10)
			else
				cProd := TMP->c6_produto
			endif
			cProd := left(cProd,15)
			if trim(cProd)==trim(sc2->c2_produto) .and. sc2->c2_apfiff4==0
				dbSkip()
				Loop
			endif
		endif
		If mv_par07==1
			dbSelectArea("SC9")
			dbsetorder(1)
			dbSeek( xFilial("SC9")+TMP->(C6_NUM+C6_ITEM))
			dbSelectArea("TMP")
			IF sc9->c9_blcred# '  '
				dbSkip()
				Loop
			Endif
			If sc9->c9_pedido#TMP->c6_num
				dbSkip()
				Loop
			Endif
		Endif
		Select SB1
		dbSetOrder(1)
		seek xFilial()+TMP->c6_produto
		Select TMP
		if trim(sb1->b1_grupo)$"10*20"
			cCod := left(c6_produto,at(".",c6_produto))+"0"+substr(c6_produto,at(".",c6_produto)+2,10)
		else
			cCod := TMP->c6_produto
		endif
		
		if left(cCod,1)=="0"
			cCod := "1"+substr(cCod,2,14)
		endif
		
		Select SE4
		dbSetOrder(1)
		Seek xFilial()+SC5->C5_CONDPAG
		Select SA1
		dbSetOrder(1)
		Seek xFilial()+SC5->(C5_CLIENTE+C5_LOJACLI)
		cLoc := TMP->c6_local
		dbSelectArea("SC2")  // Ignora se for Op parcial (c2_apfiff4#0) 09-11-05
		dbSetOrder(1)
		Seek xFilial()+left(TMP->c6_chassi,6)
		if sc2->c2_num<>left(TMP->C6_CHASSI,6)
			nQtdOp := 0
		else
			nQtdOp := sc2->c2_quant
		endif
		lParcial := .f.
		if !eof() .and. sc2->c2_apfiff4#0 .and. sc2->c2_num=left(TMP->C6_CHASSI,6)
			lParcial := .t.
		endif
		Seek xFilial()+trim(TMP->c6_chassi)
		Select SB1
		Seek xFilial()+cCod
		if !empty(sb1->b1_base)
			lAlt := .f.
			lParcial := .t.
		endif
		Select SB2
		Seek xFilial()+cCod+cLoc
		Select TRBA
		Seek TRIM(SC5->C5_NUM+substr(TMP->C6_CHASSI,7,2))
		cNumOp := Op
		if lAlt
			lAlt := .f.
			MsgBox ("Incluir item do Pedido "+TMP->c6_produto+" "+TMP->c6_num+" na programacao ? ","Informa‡ao","INFO")
		endif
		If !empty(sb1->b1_base)
			lParcial := .t.
		endif
		if (!eof() .and. lIni .and. !lParcial .and. sc2->c2_apfiff5#TMP->c6_qtdven .and. TRIM(SC5->C5_NUM+substr(TMP->C6_CHASSI,7,2))==left(trba->Op,8)) // Alterado em 31/08/05 ->Verif.Inclusoes de produtos no PV
			lIni := .f.
			if MsgBox ("Pedido "+TMP->c6_num+" de "+sa1->a1_nome+" Alterado deseja tirar da programacao ? ","Escolha","YESNO")
				Do while !eof() .and. Pedido==sc5->c5_num
					if rlock()
						Dele
					endif
					Skip
				Enddo
				Select SC2
				dbSetOrder(1)
				dbSeek( xFilial("SC2")+cNumOp)
				do while !eof() .and. c2_num==left(cNumOp,6)
					if rlock()
						dele
					endif
					Skip
				enddo
				Select SC6
				dbSetOrder(1)
				Seek xFilial()+tmp->(c6_num+c6_item)
				do while !eof() .and. c6_num==sc5->c5_num
					reclock("SC6",.f.)
					sc6->c6_chassi:=" "
					msunlock()
					Skip
				enddo
				Select SC0
				dbSeek( xFilial("SC0")+SC5->C5_NUM)
				do while !eof() .and. c0_num==sc5->c5_num
					Select SB1
					dbSetOrder(1)
					seek xFilial()+sc0->c0_produto
					Select SC0
					if trim(sb1->b1_grupo)$"10*20"
						cProd := left(c0_produto,at(".",c0_produto))+"0"+substr(c0_produto,at(".",c0_produto)+2,10)
					else
						cProd := c0_produto
					endif
					cProd := left(cProd,15)
					select SB2
					set order to 1
					seek xFilial()+cProd+sc0->c0_local
					reclock("SB2",.f.)
					sb2->B2_Reserva := sb2->B2_Reserva - sc0->c0_quant
					msunlock()
					Select SC0
					if rlock()
						dele
					endif
					Skip
				enddo
//				Select SC6
//				Seek xFilial()+sc5->c5_num
//				loop
			endif
		endif  // Final da Alteracao de 31/08 -> Luiz Eduardo
		Select TRBB
		RecLock("TRBB",.T.)
		TRBB->NUM        := tmp->C6_NUM
		TRBB->ITEM       := tmp->C6_ITEM
		TRBB->LIB        := sc9->c9_blcred
		TRBB->CLIENTE    := SC5->C5_CLIENTE+SC5->C5_LOJACLI
		TRBB->NOME       := SA1->A1_NOME
		TRBB->COND       := SE4->E4_DESCRI
		TRBB->EMISSAO    := SC5->C5_EMISSAO
		TRBB->ENTREGA    := stod(tmp->C6_ENTREG)
		If mv_par07#1
			TRBB->QTDPED     := tmp->C6_QTDVEN-tmp->C6_QTDENT-nQtdOp
		else
			TRBB->QTDPED     := tmp->C6_QTDEMP
		endif
		TRBB->COD        := cCod
		TRBB->DESC       := Sb1->b1_desc
		TRBB->QUANT      := tmp->C6_QTDVEN
		TRBB->VALOR      := tmp->C6_VALOR
		TRBB->UM         := Sb1->b1_um
		TRBB->saldo      := Sb2->b2_qatu - sb2->b2_reserva
		TRBB->fator      := SC5->C5_Fator
		MsUnLock()
		
		dbSelectArea("tmp")
		dbSkip()
	End
	Select SA1
	dbSetOrder(1)
	Seek xFilial()+SC5->(C5_CLIENTE+C5_LOJACLI)
	//	if sa1->a1_codbar#'S'
	//		cLoc := "01"
	//	else
	//		cLoc := "CB"
	//	endif
	
	Select SC0
	dbSetOrder(1)
	Seek xFilial()+sc5->c5_num
	cReserva := sc0->c0_num
	do while !eof() .and. cReserva == sc0->c0_num
		Select SC6
		dbsetorder(1)
		seek xFilial()+sc0->(c0_num+left(c0_docres,2))
		cLoc := TMP->c6_local
		Select sc2
		seek xFilial()+sc0->(c0_num+left(c0_docres,2))
		Select SC0
		if !empty(sc5->c5_nota) .and. sc2->c2_apfiff4==0
			Select SB2
			dbsetOrder(1)
			Seek xFilial()+sc0->c0_produto+cLoc
			if !eof()
				RecLock("SB2",.F.)
				sb2->b2_reserva := sb2->b2_reserva - sc0->c0_quant
				MsunLock()
			endif
			if sb2->b2_reserva<0
				RecLock("SB2",.F.)
				sb2->b2_reserva := 0
				MsUnLock()
			endif
			Select SC0
			if rlock()
				Dele
			Endif
		Endif
		Select SC0
		Skip
	enddo
	
	dbSelectArea("TMP")
//	dbSkip()
End

dbSelectArea("SC5")
dbSetOrder(1)  // C5_FILIAL+C5_NUM

Select TRBA
Go Top
Select TRBB
Go Top


Tela1()

Select TRBA
Use
Select TRBB
Use
Select SC2
Return

*************************
Static Function Tela1()
*************************

aCampos := {}
AADD(aCampos,{"OP","OP","@!"})
AADD(aCampos,{"COD","Produto","@!"})
AADD(aCampos,{"QUANT","Qtde"})
AADD(aCampos,{"ENTREGA","Entrega"})
AADD(aCampos,{"PEDIDO","Pedido"})
AADD(aCampos,{"NOME","Cliente"})

aCampos1:= {}
AADD(aCampos1,{"NUM","Pedido","@!"})
AADD(aCampos1,{"NOME","Nome Cliente"})
AADD(aCampos1,{"COD","Produto","@!"})
AADD(aCampos1,{"QUANT","Qtde","@E 999,999.99"})
AADD(aCampos1,{"ENTREGA","Entrega"})
AADD(aCampos1,{"SALDO","Estq","@E 999,999"})
AADD(aCampos1,{"VALOR","Valor","@E 999,999.99"})
AADD(aCampos1,{"COND","Cond.Pgto"})
AADD(aCampos1,{"FATOR","Fator"})
AADD(aCampos1,{"CLIENTE","Cliente"})
AADD(aCampos1,{"EMISSAO","Emissao"})
AADD(aCampos1,{"LIB"    ,"Liberado"})
AADD(aCampos1,{"QTDPED","Sld Ped","@E 999,999.99"})

@ 010,1 TO 500,750 DIALOG oDlg2 TITLE "Programa Producao"

@ 005,5 TO 090,360 BROWSE "TRBA" FIELDS aCampos

@ 095,265 BUTTON "_Pesquisa"       SIZE 40,15 ACTION Pesq2()
@ 095,310 BUTTON "_Exclui Pedido"  SIZE 40,15 ACTION Exclui2()

@ 095,005 say "Quantidade de Espelhos "  // str(nQtdEsp,6)
@ 095,075 get  nQtdEsp picture "@E 999,999" SIZE 040,20
@ 095,125 say "Valor Total a Faturar "  // +str(nValTot,6)
@ 095,200 get  nValTot picture "@E 9,999,999.99" SIZE 040,20

@ 115,5 TO 215,360 BROWSE "TRBB" FIELDS aCampos1

@ 225,040 BUTTON "_Totaliza"       SIZE 40,15 ACTION TotPed()
@ 225,085 BUTTON "_Faturar "       SIZE 40,15 ACTION FatPed()
@ 225,130 BUTTON "_Inclui Pedido"  SIZE 40,15 ACTION IncPed()
@ 225,175 BUTTON "_Altera Entrega" SIZE 40,15 ACTION AltEnt()
@ 225,220 BUTTON "_Atualiza Saldo" SIZE 40,15 ACTION AtuSal()
@ 225,265 BUTTON "_Pesquisa"       SIZE 40,15 ACTION Pesq()
@ 225,310 BUTTON "_Sai" SIZE 40,15 ACTION Close(oDlg2)

ACTIVATE DIALOG oDlg2 CENTERED
Return

****************************
Static Function TotPed()
****************************
Select TRBB
xReg := recno()
go top
cTemp12b := CriaTrab(nil,.f.)
//Index on Dtos(Entrega) to &cTemp12B
IndRegua("TRBB", cTemp12B, "Dtos(Entrega)", , , "Selecionando Registros...")

nVal := nQtd := nValE := nQtdE := nValQ := nQtdQ := 0
aChave := {}
//xQtdEsp:={}
//xDia:={}
Do while !eof()
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+trim(trbb->Cod)
	Select Trbb
	if trim(sb1->b1_grupo)$"10*20" .and. !left(trba->Cod,4)$"1004*1006*1010*1020*1021*1065"
		nQtdE := nQtdE + TRBB->QTDPED
		nValE := nValE + TRBB->VALOR
		if trbb->Entrega>=dDataBase .and. trbb->Entrega<=dDataBase+30
			nLinha := Ascan(aChave, {|x|x[1] == dtoc(trbb->entrega)})
			If nLinha != 0
				aChave[nLinha][2] := aChave[nLinha][2] + trbb->qtdPed
				//      xQtdEsp[nLinha] := xQtdEsp[nLinha] + trbb->qtdPed
			Else
				AAdd(aChave ,{dtoc(trbb->entrega),trbb->qtdPed})
				//      AAdd(xQtdEsp,trbb->qtdPed)
				//      AAdd(xDia,dtoc(trbb->entrega))
			Endif
		Endif
	else
		nQtdQ := nQtdQ + TRBB->QTDPED
		nValQ := nValQ + TRBB->VALOR
	endif
	nQtd := nQtd + TRBB->QTDPED
	nVal := nVal + TRBB->VALOR
	Skip
Enddo
goto xReg

@ 006,52 TO 443,505 DIALOG oDlg1A TITLE "Total no Periodo"
@ 001,010 TO 60,200
@ 16,015 say "Espelhos : Quantidade - "
@ 16,080 get nQtdE picture "@E 999,999" SIZE 040,20
@ 16,125 say "Valor - "
@ 16,155 get nValE picture "@E 999,999" SIZE 040,20
@ 28,015 say "Quadros  : Quantidade - "
@ 28,080 get nQtdQ picture "@E 999,999" SIZE 040,20
@ 28,125 say "Valor - "
@ 28,155 get nValQ picture "@E 999,999" SIZE 040,20
@ 40,015 say "T o t a l: Quantidade - "
@ 40,080 get nQtd  picture "@E 999,999" SIZE 040,20
@ 40,125 say "Valor - "
@ 40,155 get nVal  picture "@E 999,999" SIZE 040,20
nLin := 70
nCol := 0
@ 60,05 say "Pedidos de Espelhos Grupo 20"
For I:=1 to Len(aChave)
	//For I:=1 to Len(xQtdEsp)
	//@ nLin,005+nCol say xDia[I]
	//@ nLin,040+nCol say xQtdEsp[I] picture "@E 9999,999" SIZE 040,20
	@ nLin,005+nCol say aChave[I][1]
	@ nLin,040+nCol say aChave[I][2] picture "@E 9999,999" SIZE 040,20
	nLin := nLin + 8
	if nLin>160
		nLin := 70
		nCol := 60
	endif
Next
@ 58,196 BMPBUTTON TYPE 1 ACTION Close(oDlg1A)

ACTIVATE DIALOG oDlg1A CENTERED

Return

****************************
Static Function AtuSal()
****************************
Select SA1
dbSetOrder(1)
seek xFilial()+trbb->Cliente
lCodBar := .f.
cLoc := "01"
if !eof() .and. sa1->a1_codbar=='S'
	cLoc    := "CB"
	lCodBar := .t.
endif
Select TRBB
xReg := recno()
go top
Do while !eof()
	Sele sb2
	dbSetOrder(1)
	Seek xFilial()+trbb->Cod+cLoc
	nQtd := 0
	Select TRBB
	if TRBB->Cod == sb2->b2_cod
		RecLock("TRBB",.F.)
		TRBB->saldo := Sb2->b2_qatu - sb2->b2_reserva
		MsUnLock()
	endif
	Skip
Enddo
goto xReg
Return

****************************
Static Function AltEnt()
****************************
dEnt := trbb->Entrega
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Confirma"
@ 15,010 TO 55,180
@ 26,030 say "Data de Entrega"
@ 40,030 get dEnt  SIZE 60,20  VALID .t.
@ 20,196 BMPBUTTON TYPE 1 ACTION AltEnt1()
@ 35,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

****************************
Static Function AltEnt1()
****************************
Close(oDlg1)
cNumx := trbb->Num
Select SC6
dbSetOrder(1)
Seek xFilial()+trbb->num
//Seek xFilial()+trbb->(num+item)
//if !eof() .and. rlock()
Do while !eof() .and. SC6->c6_num==trbb->Num
	RecLock("SC6",.F.)
	sc6->c6_entreg := dEnt
	MsUnLock()
	Skip
enddo
Select TRBB
dbSetOrder()
nRec := recno()
dbGoTop()
Do while !eof()
	if trim(trbb->Num)==trim(cNumx)
		RecLock("TRBB",.F.)
		trbb->entrega := dEnt
		MsUnLock()
	endif
	Skip
Enddo
cTemp12c := CriaTrab(nil,.f.)
//Index on Cod+Dtos(Entrega)+Cliente to &cTemp12c
IndRegua("TRBB", cTemp12c, "Cod+Dtos(Entrega)+Cliente", , , "Selecionando Registros...")

goto nRec

****************************
Static Function Inclui()
****************************

Select TRBB
xRecTrb := Recno()
Select SC6
dbsetorder(1)
seek xFilial()+trbb->(Num+Item)
cLoc := sc6->c6_local
Select SA1
dbSetOrder(1)
seek xFilial()+trbb->Cliente
//cLoc := "01"
//if !eof() .and. sa1->a1_codbar=='S'
//	cLoc    := "CB"
//endif
Select SB1
Seek xFilial()+trbb->Cod
Select SC2
dbSetOrder(1)
if bof()
	nProx := "000001"
else
	go bott
	nProx := strzero(val(c2_num)+1,6)
endif
reclock("SC2",.t.)
sc2->c2_filial := xFilial()
sc2->c2_num    := nProx
sc2->c2_item   := "01"
sc2->c2_sequen := "001"
sc2->c2_pedido := trbb->Num
sc2->c2_itempv := trbb->Item
sc2->c2_produto:= trbb->Cod
sc2->c2_quant  := trbb->Quant
sc2->c2_emissao:= dDataBase
sc2->c2_datpri := trbb->entrega-1
sc2->c2_datprf := trbb->entrega
sc2->c2_um     := "PC"
sc2->c2_local  := cLoc
sc2->c2_tpop   := "F"
sc2->c2_prior  := "500"
msunlock()

Select SA1
dbSetOrder(1)
Seek xFilial()+trbb->(Cliente+loja)

reclock("TRBA",.t.)
trba->Op     := nProx+"01001"
trba->Cod    := trbb->cod
trba->Quant  := trbb->quant
trba->Entrega:= trbb->entrega
trba->Pedido := trbb->num
trba->Itempv := trbb->item
trba->Nome   := sa1->a1_nome

msunlock()
go top

Select SC6
dbSetOrder(1)
Seek xFilial()+trbb->(num+item)
if !eof()
	RecLock("SC6",.F.)
	//	sc6->c6_numop  := nProx
	sc6->c6_chassi := trim(nProx)+"01"
	//	sc6->c6_itemop := "01"
	msunlock()
	
	Select Trbb
	if rlock()
		dele
	Endif
endif
goto xRecTrb

****************************
Static Function IncPed()
****************************
dIni := dDataBase
cInteiro := "S"
cImprime := "N"
@ 050,52 TO 200,405 DIALOG oDlg1 TITLE "Confirma"
@ 05,010 TO 60,120
@ 15,015 say "Inicio da Producao "
@ 15,070 get dIni  SIZE 40,20  VALID .t.
@ 30,015 say "Pedido completo ? "
@ 30,070 get cInteiro  picture "@!" SIZE 20,20  VALID cInteiro$"S*N"
@ 45,015 say "Imprimir        ? "
@ 45,070 get cImprime  picture "@!" SIZE 20,20  VALID cImprime$"S*N"
@ 10,130 BMPBUTTON TYPE 1 ACTION IncPed1()
@ 25,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

****************************
Static Function IncPed1()
****************************
if cInteiro=="N"
	Close(oDlg1)
	incPed2()
	set filt to
	Return
endif
Close(oDlg1)
Select TRBB
xRecTrb := Recno()
cNumPed := trbb->Num
nProx   := trbb->Num

Select TRBB
go top

Do while !eof()
	if trbb->Num#cNumPed
		Skip
		Loop
	Endif
	Select SA1
	dbSetOrder(1)
	seek xFilial()+trbb->Cliente
	cLoc := "01"
	//	if !eof() .and. sa1->a1_codbar=='S'
	//		cLoc    := "CB"
	//	endif
	Select SC6
	dbsetorder(1)
	seek xFilial()+trbb->(Num+Item)
	cLoc := sc6->c6_local
	Select SB1
	Seek xFilial()+trbb->Cod
	Select SB2
	Seek xFilial()+trbb->Cod+cLoc
	* if eof()
	*   appe blan
	*   sb2->b2_filial := xFilial()
	*   sb2->b2_cod    := trbb->Cod
	*   sb2->b2_local  := cLoc
	* endif
	nNecess  := sb2->b2_qatu-sb2->b2_reserva - trbb->QTDPED
	do case
		case nNecess >= 0
			nQtdProd := 0
		case nNecess < 0
			nQtdProd := -nNecess
	endcase
	if nQtdProd >= trbb->QTDPED // .or. lCodBar .or. left(sb1->b1_grupo,1)>="3"
		nQtdProd := trbb->QTDPED
	endif
	//if left(sb1->b1_grupo,1)>="3" .and. trbb->QTDPED<sb1->B1_CONV
	// Sempre produzir qdo qtde de quadro/relogio menor que qtde da caixa
	//  nQtdProd := trbb->QTDPED
	//endif
	if !eof()
		RecLock("SB2",.F.)
		sb2->b2_reserva := sb2->b2_reserva + trbb->QTDPED
		MsUnlock()
	endif
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+trbb->(Num+Item)
	Select SC0
	dbSetOrder(3)
	Seek xFilial()+trbb->(Num+Cod+Item)
	if trbb->QTDPED>0 // .and. !lCodBar
		if eof() .or. reccount()==0
			RecLock("SC0",.t.)
		ELSE
			RecLock("SC0",.f.)
		endif
		sc0->c0_Filial   := xFilial()
		sc0->c0_Num      := trbb->Num
		sc0->c0_tipo     := "PD"
		sc0->c0_docres   := trbb->item
		sc0->c0_solicit  := substr(cUsuario,7,15)
		sc0->c0_Filres   := xFilial()
		sc0->c0_produto  := sc6->c6_produto
		sc0->c0_local    := cLoc
		sc0->c0_quant    := sc0->c0_quant+trbb->QTDPED
		sc0->c0_valida   := ctod("31/12/2030")
		sc0->c0_emissao  := dDatabase
		sc0->c0_qtdorig  := trbb->QTDPED
		MsUnLock()
	endif
	
	
	Select SC2
	dbSetOrder(1)
	cSeq := "001"
	seek xFilial()+nProx+trbb->Item+cSeq
	if left(sc2->c2_status,1)=="S"
		Do while .t.
			cSeq := strzero(val(cSeq)+1,3)
			seek xFilial()+nProx+trbb->Item+cSeq
			if eof()
				exit
			endif
		Enddo
	Endif
	if nQtdProd>0 .and. sb1->b1_tipo<>"RV"
		Select SC2
		dbSetOrder(1)
		seek xFilial()+nProx+trbb->Item+cSeq
		if eof()
			reclock("SC2",.t.)
		else
			reclock("SC2",.f.)
		endif
		sc2->c2_filial  := xFilial()
		sc2->c2_num     := nProx
		sc2->c2_item    := trbb->Item
		sc2->c2_sequen  := cSeq
		sc2->c2_pedido  := trbb->Num
		sc2->c2_itempv  := trbb->Item
		sc2->c2_produto := trbb->Cod
		sc2->c2_apfiff4 := iif(trbb->Parcial=="S",1,0)
		sc2->c2_apfiff5 := trbb->Quant
		*sc2->c2_quant   := sc2->c2_quant+nQtdProd
		sc2->c2_quant   := nQtdProd
		sc2->c2_emissao := dDataBase
		sc2->c2_datpri  := dIni
		sc2->c2_datprf  := dIni+1
		sc2->c2_um      := "PC"
		sc2->c2_local   := cLoc
		sc2->c2_tpop    := "F"
		sc2->c2_prior   := "500"
		sc2->c2_status  := trbb->parcial
		msunlock()
		
	Endif
	
	reclock("TRBA",.t.)
	trba->Op     := nProx+trbb->item+cSeq
	trba->Cod    := trbb->cod
	trba->Quant  := nQtdProd
	trba->Entrega:= dIni
	trba->Pedido := trbb->num
	trba->Itempv := trbb->item
	trba->Nome   := trbb->nome
	
	msunlock()
	go top
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+sc2->(c2_pedido+c2_itempv)
	nValTot := nValTot + sc6->c6_valor
	if trim(sb1->b1_grupo)$"10*20" .and. !left(trbb->Cod,4)$"1004*1006*1010*1020*1021*1065" ;
		.and. nQtdProd>0
		nQtdEsp := nQtdEsp + trbb->QTDPED
	endif
	
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+trbb->(num+item)
	if !eof()
		RecLock("SC6",.f.)
		
		//		sc6->c6_numop  := nProx
		//		sc6->c6_itemop := trbb->Item
		sc6->c6_chassi := trim(nProx)+trbb->Item
		MsUnLock()
	endif
	
	dlgRefresh(oDlg2)
	
	Select Trbb
	if rlock()
		dele
	Endif
	Skip
	
Enddo
if cImprime=="S"
	impOp()
endif

goto xRecTrb
//Close(oDlg2)
//Tela1()

Return

****************************
Static Function IncPed2()
****************************
@ 250,1 TO 450,540 DIALOG oDlg7 TITLE "Itens do Pedido"
Select TRBB
cNumPed := trbb->Num
set filt to trbb->Num==cNumPed
aCampos1 := {}
AADD(aCampos1,{"NUM"    ,"Num","@!"})
AADD(aCampos1,{"ITEM"   ,"Item","!!"})
AADD(aCampos1,{"COD"    ,"Produto"})
AADD(aCampos1,{"QUANT"  ,"Qtde","@E 999,999.99"})
AADD(aCampos1,{"DESC"   ,"Descr"})
AADD(aCampos1,{"ENTREGA","Entrega"})
AADD(aCampos1,{"QTDPED" ,"Qtde Solic","@E 999,999.99"})

@ 6,5 TO 093,200 BROWSE "TRBB" FIELDS aCampos1

@ 005,220 BUTTON "_Alt.Quant" SIZE 40,15 ACTION AltQtd()
@ 085,220 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg7)

ACTIVATE DIALOG oDlg7 CENTERED
return

****************************
Static Function AltQtd()
****************************
Select TRBB
nQtd  := trbb->qtdped

@ 196,52 TO 343,505 DIALOG oDlg6 TITLE "Altera Quantidade"
@ 15,010 TO 45,250
@ 26,020 say "Produto : "+trbb->Cod
@ 26,080 say "Qtde"
@ 26,140 get nQtd picture "999,999.99" SIZE 25,25

@ 50,168 BMPBUTTON TYPE 1 ACTION GrvAltQtd()
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg6)
ACTIVATE DIALOG oDlg6 CENTERED

Return .t.

****************************
Static Function GrvAltQtd()
****************************
Close(oDlg6)
RecLock("trbb",.f.)
trbb->Qtdped := nQtd
trbb->Parcial:= "S"
MsUnLock()
return

****************************
Static Function Exclui1()
****************************

Select TRBA
if MsgBox ("Confirma exclusao da programacao ? "+trba->cod,"Escolha","YESNO")
	Select SC2
	dbSetOrder(1)
	Seek xFilial()+trba->Op
	if rlock() .and. !eof()
		Dele
	Endif
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+trba->(Pedido+Itempv)
	if !eof()
		RecLock("SC6",.f.)
		//		sc6->c6_numop  := space(6)
		sc6->c6_itemop := "  "
		sc6->c6_chassi := " "
		MsUnLock()
	Endif
	cLoc := sc6->c6_local
	Select SC5
	Seek xFilial()+trba->Pedido
	Select SA1
	Seek xFilial()+sc5->(c5_cliente+c5_lojacli)
	//	cLoc := "01"
	//	if !eof() .and. sa1->a1_codbar=='S'
	//		cLoc    := "CB"
	//	endif
	
	reclock("TRBB",.t.)
	trbb->Num    := trba->Pedido
	trbb->Item   := trba->Itempv
	trbb->Cod    := trba->Cod
	trbb->Cliente:= sc5->c5_cliente+sc5->c5_lojacli
	trbb->Nome   := trba->nome
	trbb->Quant  := trba->quant
	trbb->Entrega:= trba->Entrega
	trbb->Emissao:= sc5->c5_emissao
	trbb->Fator  := sc5->c5_fator
	
	msunlock()
	go top
	
	Select SB2
	Seek xFilial()+trba->Cod+cLoc
	if !eof()
		RecLock("SB2",.f.)
		sb2->b2_reserva := sb2->b2_reserva - trbb->Quant
		MsUnLock()
	endif
	
	Select trba
	if rlock()
		Dele
	Endif
	go top
Endif
//Close(oDlg2)
//MontaTela2()

Return

****************************
Static Function Exclui2()
****************************

Select TRBA
if MsgBox ("Confirma exclusao do pedido ? "+trba->Pedido,"Escolha","YESNO")
	Select SC2
	dbSetOrder(1)
	Seek xFilial()+left(trba->Op,6)
	do while !eof() .and. sc2->(c2_num) == left(trba->Op,6)
		if rlock() .and. !eof() .and. c2_datrf==ctod("0") .and. c2_quje==0
			Dele
		Endif
		Skip
	Enddo
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+trba->(Pedido)
	do while !eof() .and. sc6->c6_num == trba->Pedido
		if !eof()
			RecLock("SC6",.f.)
			//			sc6->c6_numop  := space(6)
			sc6->c6_itemop := "  "
			sc6->c6_chassi := " "
			MsUnLock()
		Endif
		Skip
	Enddo
	Select SC5
	Seek xFilial()+trba->Pedido
	Select SA1
	Seek xFilial()+sc5->(c5_cliente+c5_lojacli)
	cLoc := "01"
	//	if !eof() .and. sa1->a1_codbar=='S'
	//		cLoc    := "CB"
	//	endif
	Select TRBA
	cPed := trba->Pedido
	Do while !eof() .and. trba->Pedido==cPed
		Select SC0
		dbSetOrder(1)
		Seek xFilial()+cPed
		Do while !eof() .and. sc0->c0_num==cPed
			Select SC6
			seek xFilial()+sc0->(c0_num+left(c0_docres,2))
			select SB2
			set order to 1
			seek xFilial()+sc0->c0_produto+sc6->c6_local
			RecLock("SB2",.f.)
			sb2->B2_Reserva := sb2->B2_Reserva - sc0->c0_quant
			MsUnLock()
			Select SC0
			if rlock()
				dele
			endif
			Skip
		enddo
		
		Select SC6
		dbSetOrder(1)
		Seek xFilial()+trba->(Pedido+Itempv)
		reclock("TRBB",.t.)
		trbb->Num    := trba->Pedido
		trbb->Item   := trba->Itempv
		trbb->Cod    := trba->Cod
		trbb->Cliente:= sc5->c5_cliente+sc5->c5_lojacli
		trbb->Nome   := sa1->a1_Nome
		trbb->Quant  := trba->quant
		trbb->Entrega:= trba->Entrega
		trbb->Emissao:= sc5->c5_emissao
		trbb->Fator  := sc5->c5_fator
		trbb->valor  := sc6->c6_valor
		
		msunlock()
		Select SB1
		dbsetOrder(1)
		Seek xFilial()+trba->Cod
		Select SC6
		dbSetOrder(1)
		Seek xFilial()+trba->(Pedido+itempv)
		nValTot := nValTot - sc6->c6_valor
		if trim(sb1->b1_grupo)$"10*20" .and. !left(trba->Cod,4)$"1004*1006*1010*1020*1021*1065"
			nQtdEsp := nQtdEsp - trba->Quant
		endif
		dlgRefresh(oDlg2)
		
		Select TRBA
		if rlock()
			Dele
		Endif
		Skip
	Enddo
	go top
	
Endif
//Close(oDlg2)
//MontaTela2()

Return

***************************
Static Function Pesq()
***************************
cChave := space(20)
cArq := space(1)
aArq := {}
AADD(aArq,"Pedido")
AADD(aArq,"Produto")
AADD(aArq,"Nome Cliente")
AADD(aArq,"Entrega")
AADD(aArq,"Prazo")

@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Pesquisa"
@ 15,010 TO 55,180
@ 26,030 COMBOBOX cArq   ITEMS aArq SIZE 140,50
@ 40,030 get cChave picture "@!" SIZE 140,20  VALID .t.
@ 20,196 BMPBUTTON TYPE 1 ACTION Pesq1()
@ 35,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

***************************
Static Function Pesq1()
***************************
Close(oDlg1)

Select TRBB
cTemp12d := CriaTrab(nil,.f.)
Set softseek on
Do case
	Case trim(cArq)=="Produto"
		//		Index on Cod+Dtos(Entrega) to &cTemp12d
		IndRegua("TRBB", cTemp12d, "Cod+Dtos(Entrega)", , , "Selecionando Registros...")
	Case trim(cArq)=="Nome Cliente"
		//		Index on Nome+Dtos(Entrega) to &cTemp12d
		IndRegua("TRBB", cTemp12d, "Nome+Dtos(Entrega)", , , "Selecionando Registros...")
	Case trim(cArq)=="Entrega"
		//		Index on Dtos(Entrega)+Cliente to &cTemp12d
		IndRegua("TRBB", cTemp12d, "Dtos(Entrega)+Cliente", , , "Selecionando Registros...")
	Case trim(cArq)=="Prazo"
		//		Index on Cond+Dtos(Entrega) to &cTemp12d
		IndRegua("TRBB", cTemp12d, "Cond+Dtos(Entrega)", , , "Selecionando Registros...")
	Case trim(cArq)=="Pedido"
		//		Index on Num to &cTemp12d
		IndRegua("TRBB", cTemp12d, "Num", , , "Selecionando Registros...")
Endcase
Set softseek off

Close(oDlg1)
//Tela1()
Seek trim(cChave)
dlgRefresh(oDlg2)

Return

***************************
Static Function Pesq2()
***************************
cChave := space(20)
cArq := space(1)
aArq := {}
AADD(aArq,"Op")
AADD(aArq,"Produto")
AADD(aArq,"Nome Cliente")
AADD(aArq,"Entrega")
AADD(aArq,"Pedido")

@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Pesquisa"
@ 15,010 TO 55,180
@ 26,030 COMBOBOX cArq   ITEMS aArq SIZE 140,50
@ 40,030 get cChave picture "@!" SIZE 140,20  VALID .t.
@ 20,196 BMPBUTTON TYPE 1 ACTION Pesq2a()
@ 35,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

***************************
Static Function Pesq2a()
***************************
Close(oDlg1)

Select TRBA
cTemp12e := CriaTrab(nil,.f.)
Set softseek on
Do case
	Case trim(cArq)=="Op"
		//		Index on Op     to &cTemp12e
		IndRegua("TRBA", cTemp12e, "Op", , , "Selecionando Registros...")
	Case trim(cArq)=="Produto"
		//		Index on Cod    to &cTemp12e
		IndRegua("TRBA", cTemp12e, "Cod", , , "Selecionando Registros...")
	Case trim(cArq)=="Nome Cliente"
		//		Index on Nome   to &cTemp12e
		IndRegua("TRBA", cTemp12e, "Nome", , , "Selecionando Registros...")
	Case trim(cArq)=="Entrega"
		//		Index on Dtos(Entrega)+Cliente to &cTemp12e
		IndRegua("TRBA", cTemp12e, "Dtos(Entrega)", , , "Selecionando Registros...")
		
	Case trim(cArq)=="Pedido"
		//		Index on Pedido to &cTemp12e
		IndRegua("TRBA", cTemp12e, "Pedido", , , "Selecionando Registros...")
Endcase
Set softseek off

Close(oDlg1)
Seek trim(cChave)
dlgRefresh(oDlg2)

Return

*************************
Static Function ALTPROG()   // Programa alterar programa‡ao de vendas
*************************
Select SB1
dbSetOrder(1)
Seek xFilial()+trbb->Cod
Select SC2
dbSetOrder(1)
Seek xFilial()+trbb->Op
nQtd := sc2->c2_quant
nQtd1:= sc2->c2_quant
dDat := sc2->c2_datprf
@ 196,52 TO 343,555 DIALOG oDlgP TITLE "Altera quantidade de pecas"
@ 15,010 TO 45,250
@ 18,020 say "Produto : "+trbb->Cod
@ 26,020 say sb1->b1_desc
@ 18,100 say "Qtde Pedido"
@ 26,100 get nQtd  picture "99999" SIZE 25,25
@ 18,140 say "Qtde Progr."
@ 26,140 get nQtd1 picture "99999" SIZE 25,25
@ 18,180 say "Previsao"
@ 26,180 get dDat SIZE 40,25
@ 50,110 BMPBUTTON TYPE 1 ACTION GrvAlt1()
@ 50,140 BMPBUTTON TYPE 2 ACTION Close(oDlgP)
@ 50,180 BUTTON "_Exclui" SIZE 40,15 ACTION ExcOp1()
ACTIVATE DIALOG oDlgP CENTERED

Return .t.

************************
Static function GrvAlt1()
************************
Select TRBB
RecLock("trbb",.f.)
trbb->quant  := nQtd1
trbb->entrega:= dDat
MsUnLock()

Close(oDlgP)
Select SC2
dbSetOrder(1)
seek xFilial()+trbb->op
if c2_quje # 0
	MsgBox ("Operacao nÆo permitida - OP em produ‡Æo ","Informa‡ao","INFO")
else
	cTempP := CriaTrab(nil,.f.)
	xReg := recno()
	copy to &cTempP next 10 for sc2->(c2_num+c2_item)==left(trbb->Op,8)
	dbSetOrder(1)
	go bott
	cProx := strzero(val(sc2->c2_num)+1,6)
	
	dbUseArea( .T.,,cTempP,"TRBP", Nil, .F. )
	go top
	Do while !Eof()
		RecLock("trbp",.f.)
		if left(sc2->c2_produto,2)==left(trbb->COD,2)
			trbp->c2_quant  := nQtd
			trbp->c2_quant  := nQtd1
			trbp->c2_num    := cProx
			trbp->c2_item   := "01"
			trbp->c2_datpri := dDat-1
			trbp->c2_datprf := dDat
			trbp->c2_cerqua := dtos(date())+left(time(),2)+substr(time(),4,2)
			trbp->c2_obs    := "Ref. OP - "+trbb->op
			MsUnLock()
		endif
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+TRBP->c2_produto
		Select TRBB
		xReg := recno()
		reclock("TRBB",.t.)
		trbb->Op     := trbp->(c2_num+c2_item+c2_sequen)
		trbb->Cod    := trbp->c2_produto
		trbb->Quant  := trbp->c2_quant
		trbb->Cliente:= left(trbp->c2_produto,2)
		trbb->Entrega:= trbp->c2_datprf
		trbb->Status := "N"
		msunlock()
		goto xReg
		select trbp
		Skip
	Enddo
	
	use
	Select SC2
	Appe from &cTempP
	goto xReg
	ExcOp1()
endif

Return

*-------------------------*
Static Function ExcOp1()
*-------------------------*
Close(oDlgP)
Select SC2
dbSetOrder(1)
seek xFilial()+trbb->Op
if c2_quje # 0
	MsgBox ("Operacao nÆo permitida - OP em produ‡Æo ","Informa‡ao","INFO")
	Return
endif
if !MsgBox ("Confirma exclusao da OP "+trbb->Op,"Escolha","YESNO")
	Return
Endif
Select SC2
dbSetOrder(1)
seek xFilial()+trbb->Op
do while !eof() .and. sc2->(c2_num+c2_item)==left(trbb->Op,8)
	if sc2->(c2_num+c2_item+c2_sequen)==trbb->op
		RecLock("SC2",.f.)
		sc2->c2_datrf := date()
		sc2->c2_cerqua:= dtos(date())+left(time(),2)+substr(time(),4,2)
		msunlock()
	Endif
	Select SD4
	dbSetOrder(2)
	seek xFilial()+sc2->(c2_num+c2_item+c2_sequen)
	do while !eof() .and. left(d4_op,11)==sc2->(c2_num+c2_item+c2_sequen) .and. rlock()
		sd4->d4_quant := 0
		Skip
	enddo
	Select SC2
	lBx := .f.
	if sc2->(c2_num+c2_item+c2_seqpai)==trbb->op
		RecLock("SC2",.f.)
		sc2->c2_datrf := date()
		sc2->c2_cerqua:= dtos(date())+left(time(),2)+substr(time(),4,2)
		lBx := .t.
		MsUnLock()
	Endif
	Select SD4
	dbSetOrder(2)
	seek xFilial()+sc2->(c2_num+c2_item+c2_sequen)
	do while !eof() .and. left(d4_op,11)==sc2->(c2_num+c2_item+c2_sequen) .and. rlock()
		if lBx .and. rlock()
			sd4->d4_quant := 0
		endif
		Skip
	enddo
	Select SC2
	Skip
Enddo

Select TRBB
if rlock()
	Delete
Endif
go top

Return .t.

**************************888 Fase II - Controle de Reservas
*-------------------------*
Static Function FatPed()      // Escolhe Pedidos Para Faturar
*-------------------------*
dFat := dDataBase
@ 096,52 TO 180,405 DIALOG oDlg1 TITLE "Confirma"
@ 05,010 TO 30,120
@ 15,015 say "Data do Faturamento"
@ 15,070 get dFat  SIZE 40,20  VALID .t.
@ 10,130 BMPBUTTON TYPE 1 ACTION FatPed1()
@ 25,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

*-------------------------*
Static Function FatPed1()
*-------------------------*
Close(oDlg1)

aCampos := {}
AADD(aCampos,{ "PEDIDO"  , "C",06,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "QTDE"    , "N",12,2})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "FATOR"   , "C",01,0})
AADD(aCampos,{ "CLIENTE" , "C",30,0})
AADD(aCampos,{ "DESC"    , "C",30,0})
AADD(aCampos,{ "ENTREGA" , "D",08,0})
AADD(aCampos,{ "DATFAT"  , "D",08,0})
AADD(aCampos,{ "OK"      , "C",02,0})
cFat  := CriaTrab(nil,.f.)
dbCreate(cFat,aCampos)
dbUseArea( .T.,,cFat,"FAT", Nil, .F. )
//Index on Pedido to &cFat
IndRegua("FAT", cFat, "Pedido", , , "Selecionando Registros...")

Processa( {|| RunPrFat() } )
Select FAT
Use
Select TRBA
Return

*-------------------------*
Static Function RunPrFat()
*-------------------------*
Select SC0
dbSetOrder(1)
go top
ProcRegua(reccount())
Do while !eof()
	IncProc()
	Select SB1
	seek xFilial()+sc0->c0_produto
	Select SC5
	seek xFilial()+sc0->c0_num
	Select SC6
	seek xFilial()+sc0->c0_num
	nValPed := nQtdPed := 0
	dEnt := sc6->c6_entreg
	do while !eof() .and. sc6->c6_num == sc0->c0_num
		nValPed := nValPed +sc6->c6_valor
		nQtdPed := nQtdPed +sc6->c6_qtdven - sc6->c6_qtdent
		Skip
	enddo
	Select SA1
	seek xFilial()+sc5->(c5_cliente+c5_lojacli)
	Select FAT
	if nQtdPed>0
		RecLock("FAT",.t.)
		fat->Pedido := sc0->c0_num
		fat->Qtde   := nQtdPed
		fat->Valor  := nValPed
		fat->Cliente:= sa1->a1_nome
		fat->Entrega:= dEnt
		fat->Fator  := SC5->C5_Fator
		fat->DatFat := ctod(trim(SC0->C0_Localiz))
		MsUnLock()
	Endif
	Select SC0
	cReserva := sc0->c0_num
	do while !eof() .and. cReserva == sc0->c0_num
		if !empty(sc5->c5_nota)
			Select SB2
			dbsetOrder(1)
			Seek xFilial()+sc0->c0_produto+"01"
			if !eof()
				RecLock("SB2",.f.)
				sb2->b2_reserva := sb2->b2_reserva - sc0->c0_quant
				MsUnLock()
			endif
			if sb2->b2_reserva<0
				RecLock("SB2",.f.)
				sb2->b2_reserva := 0
				MsUnLock()
			endif
			Select SC0
			if rlock()
				Dele
			Endif
		Endif
		Skip
	enddo
Enddo

EscolheOp()
Return

*-------------------------*
Static Function EscolheOp()
*-------------------------*

@ 100,1 TO 600,700 DIALOG oDlgFat TITLE "Escolha Pedidos para Faturar"

Select FAT
go top
aCampos := {}
AADD(aCampos,{"OK","OK"})
AADD(aCampos,{"Pedido","Pedido","@!"})
AADD(aCampos,{"qtde" ,"Qtde","@E 999,999"})
AADD(aCampos,{"Valor","Valor","@E 999,999.99"})
AADD(aCampos,{"Cliente","Nome do Cliente"})
AADD(aCampos,{"Entrega","Prev.Entr."})
AADD(aCampos,{"DatFat","Faturar"})
AADD(aCampos,{"Fator","Fator"})

@ 6,5 TO 210,350 BROWSE "FAT" FIELDS aCampos ENABLE "OK" MARK "OK"

@ 220,130 BUTTON "_Imprime" SIZE 40,15 ACTION ImpFat()
@ 220,180 BUTTON "_Limpa"   SIZE 40,15 ACTION limpaok()
@ 220,230 BUTTON "_Ok"      SIZE 40,15 ACTION Conf()
@ 220,280 BUTTON "_Cancela" SIZE 40,15 ACTION Close(oDlgFat)

@ 10,155 SAY "- Clicar nas ordens a serem baixadas"
ACTIVATE DIALOG oDlgFat CENTERED
Return

*-------------------------*
Static Function LimpaOk()
*-------------------------*
Close(oDlgFat)
Select FAT
go top
Do while !eof()
	RecLock("FAT",.f.)
	fat->ok     := "  "
	msUnLock()
	Skip
Enddo
EscolheOp()
return

*--------------------------*
Static Function Conf()   // Confirma Pedidos para Nota Fiscal
*--------------------------*
Close(oDlgFat)
Select FAT
Go top
Do while !eof()
	if Marked("OK")
		Skip
		Loop
	endif
	cNum := fat->Pedido
	Select SC0
	dbSetOrder(1)
	Seek xFilial()+cNum
	do while !eof() .and. sc0->c0_num ==fat->Pedido
		RecLock("SC0",.f.)
		sc0->c0_localiz := dtoc(dFat)
		MsUnLock()
		skip
	enddo
	Select FAT
	do while !eof() .and. fat->Pedido == cNum
		RecLock("FAT",.f.)
		fat->datfat := dFat
		MsUnLock()
		Skip
	enddo
Enddo

************************
Static Function ImpFat()
************************
//cPerg := "PROG01"
//if !Pergunte(cPerg,.T.)
//   Return
//Endif

mv_par01 := dFat

// MV_PAR01 - Data do Faturamento

cString:="FAT"
cDesc1:= "Pedidos a Faturar"
cDesc2:= ""
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="PROG01"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Pedidos a Faturar "+DTOC(dDataBase)
cabec1      :="Pedido    Cliente                             Valor    Faturar "
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0

wnrel:="PROG01"            //Nome Default do relatorio em Disco

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
Conf()

Select SC0
go top
SetRegua(RecCount())
nLin := 80
nVal := 0
Do while !eof()
	IncRegua()
	if ctod(trim(sc0->c0_localiz)) # mv_par01
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
	@ nLin,042 PSAY nValPed  PICTURE "@E 999,999.99"
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
	
	@ nLin+1,042 PSAY nVal PICTURE "@E 999,999.99"
	
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
Static Function ImpOp()
****************************
cNumOp := nProx
cString:="SC2"
cDesc1:= "Ordem de Producao "+nProx
cDesc2:= ""
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="PCP001"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Ordem de Producao "+cNumOp
cabec1      :="Num.Op It Cod.Produto       Descricao                      Quantidade"
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0

wnrel:="PCP001"            //Nome Default do relatorio em Disco

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

RptStatus({|| RptOp() })
Return

***************************
Static Function RptOp()
***************************

Select SC2
dbSetOrder(1)
Seek xFilial()+cNumOp
Select SC5
dbSetOrder(1)
seek xFilial()+sc2->c2_pedido
Select SA1
dbSetOrder(1)
seek xFilial()+sc5->c5_cliente
cCb := iif(sa1->a1_codbar=='S' .or. substr(cCod,13,2)=="CB","S"," ")
Select SC2

SetRegua(recno())
nLin := 80
cabec2      :="Num.Op It Cod.Produto  CB Descricao                        Quantidade"
cabec1      :="Espelhos - Op "+cNumOp
nTot := 0
Do while !eof() .and. sc2->c2_num==cNumOp
	cCod := sc2->c2_produto
	if left(cCod,2)#"10"
		Skip
		Loop
	Endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 9
	endif
	Select SB1
	seek xFilial()+cCod
	Select SC2
	cCod  := left(cCod,12)
	cDesc := sb1->b1_Desc
	dEnt  := sc2->c2_datpri
	@ nLin,00 psay sc2->c2_num+"-"+sc2->c2_item
	@ nLin,10 psay left(cCod,12)+iif(cCB=="S","(S)"," ")
	@ nLin,26 psay left(cDesc,34)
	@ nLin,62 psay sc2->c2_quant picture "@E 999,999"
	@ nLin,70 psay "__________"
	nLin := nLin + 1
	@ nLin,00 psay replicate("- ",40)
	nLin := nLin + 1
	nTot := nTot + sc2->c2_quant
	Skip
Enddo
@ nLin,40 psay "TOTAL DE ESPELHOS"
@ nLin,62 psay nTot  picture "@E 999,999"

Select SC2
dbSetOrder(1)
Seek xFilial()+cNumOp
SetRegua(recno())
cabec2      :="Num.Op It Cod.Produto    CB Descricao                      Quantidade"
cabec1      :="Outros Produtos - OP "+cNumOp
lIni := .t.
Do while !eof()  .and. sc2->c2_num==cNumOp
	IncRegua()
	if left(sc2->c2_produto,2)=="10"
		Skip
		Loop
	Endif
	if lIni
		@ nLin,00 psay"QUADROS"
		nLin := nLin + 1
		lIni := .f.
	endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 9
	endif
	Select SB1
	seek xFilial()+sc2->c2_produto
	Select SC2
	@ nLin,00 psay sc2->c2_num+"-"+sc2->c2_item
	@ nLin,10 psay sc2->c2_produto
	@ nLin,26 psay left(sb1->b1_desc,34)
	@ nLin,62 psay sc2->c2_quant picture "@E 999,999"
	@ nLin,70 psay "__________"
	nLin := nLin + 1
	skip
Enddo

Roda(0,"","P")
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()

Return


***************************
Static Function VerAlt1()  //  Verifica se houve alteracao na OP
***************************

Select SC6
dbSetOrder(1)
Seek xFilial()+sc2->(c2_pedido+c2_itempv)
Select SB1
dbSetOrder(1)
Seek xFilial()+sc6->c6_produto
Select SC6
if sb1->b1_grupo>"20" .and. !(sb1->b1_grupo='999' .and. left(sb1->b1_cod,1)='1')
	cProd := sc6->c6_produto
else
	cProd := left(c6_produto,at(".",c6_produto))+"0"+substr(c6_produto,at(".",c6_produto)+2,10)
	cProd := left(cProd,15)
endif
c2prod := sc2->c2_produto
c6prod := cProd
//c2prod := substr(sc2->c2_produto,2,4)+substr(sc2->c2_produto,7,4)
//c6prod := substr(sc6->c6_produto,2,4)+substr(sc6->c6_produto,7,4)
if (eof() .or. c2prod#c6prod;
	.or. sc2->c2_apfiff5>sc6->c6_qtdven) .and. !empty(sc2->c2_pedido) .and. at(".",sc2->c2_produto)<>0
	lAlt := .t.
	Select SA1
	dbSetOrder(1)
	Seek xFilial()+SC6->(C6_CLI+C6_LOJA)
	Select SC6
	if MsgBox ("Pedido "+sc2->c2_Pedido+" de "+sa1->a1_nome+" Alterado (ou excluido) deseja tirar da programacao ? ","Escolha","YESNO");
		.and. sc2->c2_Pedido#space(6)
		Seek xFilial()+sc2->c2_pedido
		cnum := sc2->c2_num
		do while !eof() .and. c6_num==sc2->c2_pedido
			RecLock("SC6",.f.)
			//				sc6->c6_numop  :=" "
			//				sc6->c6_itemop :="*"
			sc6->c6_chassi := " "
			MsUnLock()
			Skip
		enddo
		Select SC0
		dbSetOrder(1)
		Seek xFilial()+sc2->c2_pedido
		Do while !eof() .and. sc0->c0_num==sc2->c2_pedido
			Select SB1
			dbSetOrder(1)
			seek xFilial()+sc0->c0_produto
			Select SC0
			if trim(sb1->b1_grupo)$"10*20"
				cProd := left(c0_produto,at(".",c0_produto))+"0"+substr(c0_produto,at(".",c0_produto)+2,10)
			else
				cProd := sc0->c0_produto
			endif
			select SB2
			set order to 1
			seek xFilial()+cProd+sc0->c0_local
			if !eof()
				RecLock("SB2",.f.)
				sb2->B2_Reserva := sb2->B2_Reserva - sc0->c0_quant
				MsUnLock()
			endif
			Select SC0
			if rlock()
				dele
			endif
			Skip
		enddo
		Select TRBA
		seek sc2->c2_num
		do while !eof() .and. left(trba->op,6)==sc2->c2_num
			if rlock() .and. left(trba->op,6)==sc2->c2_num
				dele
			endif
			skip
		enddo
		Select SC2
		nReg := Recno()
		Seek xFilial()+cNum
		Do while !eof() .and. sc2->c2_num==cNum
			RecLock("SC2",.f.)
			sc2->c2_obs := substr(cUsuario,7,15)+" "+dtoc(date())
			MsUnLock()
			if rlock()
				dele
			endif
			Skip
		enddo
		goto nReg
	endif
Endif
