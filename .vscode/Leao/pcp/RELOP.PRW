#include "rwmake.ch"

User Function RelOp()   // Relatorio para impressao das OP's separando Espelhos de Qds

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "RELOP1"
Pergunte (cPerg,.T.)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
// ?Par„metros para emiss„o do relat?io :                                  ?
// ?mv_par01 => Da Entrega (pedido)                                         ?
// ?mv_par02 => Ate entrega                                                 ?
// ?mv_par03 => Numero OP                                                   ?
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?

cString:="SC2"
cDesc1:= OemToAnsi("Relacao das OP's no periodo")
cDesc2:= OemToAnsi("      ")
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="RELOP1"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Entregas de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
cabec1      :="Num.Op It Cod.Produto       Descricao                      Quantidade"
cabec2      :=""
//cabec2      :="Ordens de Producao"
cCancel := "***** CANCELADO PELO OPERADOR *****"

lResumo := .f.
if MsgBox ("Imprimir Resumos ? ","Escolha","YESNO")
	lResumo := .t.
endif

lIncons := .f.
if MsgBox ("Imprimir Inconsistências ? ","Escolha","YESNO")
	lIncons := .t.
endif

m_pag := 1  //Variavel que acumula numero da pagina

wnrel:="RELOP1"            //Nome Default do relatorio em Disco
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

aCampos := {}
AADD(aCampos,{ "ENTREGA" , "D",08,0})
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "ITEM"    , "C",02,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "CB"      , "C",01,0})
AADD(aCampos,{ "DESC"    , "C",35,0})
AADD(aCampos,{ "CLI"     , "C",30,0})
AADD(aCampos,{ "FANTASIA", "C",30,0})
AADD(aCampos,{ "QTDE"    , "N",12,0})
AADD(aCampos,{ "AREA"    , "N",14,6})
AADD(aCampos,{ "AREAUNIT", "N",14,6})
AADD(aCampos,{ "ENTREG"	 , "C",05,0})
AADD(aCampos,{ "OK"      , "C",02,0})
AADD(aCampos,{ "LINHA"   , "C",03,0})

//AADD(aCampos,{ "EMISSAO" , "C",05,0})

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
//index on COD to &cTemp
IndRegua("TRB", cTemp, "cod", , , "Selecionando Registros...")

aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "CB"      , "C",01,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "QTDE"    , "N",12,0})
AADD(aCampos,{ "AREA"    , "N",14,6})
AADD(aCampos,{ "AREAUNIT", "N",14,6})
AADD(aCampos,{ "OK"      , "C",02,0})

IF SELECT("TRBIN") # 0
	TRBIN->(DBCLOSEAREA( ))
ENDIF

cTempIn := CriaTrab(nil,.f.)
dbCreate(cTempIn,aCampos)
dbUseArea( .T.,,cTempIn,"TRBIN", Nil, .F. )
//index on COD to &cTemp
IndRegua("TRBIN", cTempIn, "cod", , , "Selecionando Registros...")

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 16/08/01 ==> RptStatus({|| Execute(RptDetail) })
//Select TRB
//Use
Select SC2
Retindex("SC2")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±?un‡„o    ?ptDetail ?Autor ?Ary Medeiros          ?Data ?15.02.96 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±?escri‡„o ?mpressao do corpo do relatorio                             ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function RptDetail()

Select SC2
DbOrderNickName("C2DTPRF")
//dbSetOrder(12)
set softseek on
seek xFilial()+dtos(mv_par01)
set softseek off
Do while !eof() .and. c2_datprf>=mv_par01 .and. c2_datprf<=mv_par02
	if LEFT(mv_par03,6)#space(6) .and. c2_num+C2_ITEM#left(mv_par03,8)
		skip
		loop
	endif
	if c2_emissao<mv_par04 .or. c2_emissao>mv_par05
		skip
		loop
	endif
	if left(sc2->c2_produto,2) == '00'
		cCod := "10"+SUBSTR(sc2->c2_produto,3,13)
		RecLock("SC2",.f.)
		sc2->c2_produto := cCod
		MsUnLock()
	else
		cCod := sc2->c2_produto
	endif
	Select SC5
	dbSetOrder(1)
	seek xFilial()+sc2->c2_pedido
	Select SC6
	dbSetOrder(1)
	seek xFilial()+sc2->(c2_pedido+c2_itempv)
	Select SA1
	dbSetOrder(1)
	seek xFilial()+sc5->(c5_cliente+C5_LOJACLI)
	Select SB1
	seek xFilial()+cCod
	nPonto := at(".",SC6->C6_PRODUTO)
	nArea := 0
	cLinha := iif(sb1->b1_grupo>'20',"Quadro","Espelho")
	if nPonto=0 .and. !empty(SB1->b1_base)
		nArea := val(substr(SC6->C6_PRODUTO,7,4))*val(substr(SC6->C6_PRODUTO,12,4))/1000000
		cLinha := "Chapa"
	else
		Select SG1
		dbSetOrder(1)
		Seek xFilial()+LEFT(SC6->C6_PRODUTO,nPonto-1)+space(15-nPonto+1)+"19."
		nArea := sg1->g1_quant
	endif
	Select TRB
	if  sc2->c2_quant-sc2->c2_quje>0 .and. sc2->c2_datrf==ctod("0")
		RecLock("trb",.t.)
		trb->num  := sc2->c2_num
		trb->item := sc2->c2_item
		trb->cod  := cCod
		trb->cb   := sc2->c2_local
		//		if sc2->c2_pedido = sc5->c5_num
		//			trb->cb   := sc2->c2_local //iif(sa1->a1_codbar=='S' .or. substr(cCod,13,2)=="CB","S"," ")
		//		endif
		trb->desc := sb1->b1_desc
		trb->cli  := sa1->a1_nome
		trb->fantasia  := sa1->a1_nreduz
		trb->qtde := sc2->c2_quant-sc2->c2_quje
		trb->Area := (sc2->c2_quant-sc2->c2_quje)*nArea
		trb->AreaUnit := nArea
//		trb->emissao := dtoc(sc2->c2_emissao)
		trb->entrega := sc2->c2_datpri
		trb->entreg  := dtoc(sc2->c2_datpri)
		trb->Linha := cLinha
		MsUnlock()
	Endif
	Select SC2
	Skip
Enddo

Select TRB
//index on num to &cTemp
cTemp12a := CriaTrab(nil,.f.)
//index on cod+cb to &cTemp12a
IndRegua("TRB", cTemp12a, "cod+cb", , , "Selecionando Registros...")

go top
SetRegua(recno())
nLin := 80
ntot := 0
cabec2      :="Num.Op It Cod.Produto  CB Descricao                        Quantidade"
cabec1      :="Espelhos - entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
Do while !eof()
	if left(cod,2)#"10"
		Skip
		Loop
	Endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 9
	endif
	cCod  := left(Cod,12)
	cCb   := CB
	cDesc := Desc
	dEnt  := Entrega
	nQtde := 0
	n:= 0
	Do while !eof() .and. left(Cod,12)+CB == cCod+cCB
		IncRegua()
		if nLin >60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			nLin := 9
		endif
		nQtde := nQtde + Qtde
		nTot  := nTot  + Qtde
		@ nLin,00 psay Entreg+" "+num//+"-"+item
		@ nLin,13 psay left(Cod,12)//+iif(CB=="C","(S)"," ")
		@ nLin,26 psay Desc
		@ nLin,62 psay Qtde picture "@E 99999"
		//  @ nLin,64 psay dEnt
		@ nLin,67 psay "_____"
		@ nLin,73 psay Fantasia
		nLin := nLin + 1
		n := n + 1
		Skip
	Enddo
	if n>1
		@ nLin,40 psay "TOTAL DO PRODUTO"
		@ nLin,60 psay nQtde picture "@E 999,999"
		nLin := nLin + 1
	endif
	@ nLin,00 psay replicate("- ",40)
	nLin := nLin + 1
Enddo
@ nLin,40 psay "TOTAL DE ESPELHOS"
@ nLin,67 psay nTot  picture "@E 999,999"

// Impressao de Quadros

Select TRB
cTemp12b := CriaTrab(nil,.f.)
//index on num+item to &cTemp12b
IndRegua("TRB", cTemp12b, "linha+num+item", , , "Selecionando Registros...")

nLin := 80
go top
SetRegua(recno())
cabec2      :="Num.Op It Cod.Produto    CB Descricao                      Quantidade"
cabec1      :="Outros Produtos (1)- entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
Do while !eof()
	IncRegua()
	if left(cod,2)=="10" .or. linha='Cha'
		Skip
		Loop
	Endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 9
	endif
	cNumPed := Trb->Num
	@ nLin,00 psay Trb->Cli+" "+trb->Entreg+"  - Nome Fantasia : "+Fantasia
	nLin := nLin + 1
	Do while !eof() .and. Trb->Num==cNumPed
		if left(cod,2)=="10" .or. linha='Cha'
			Skip
			Loop
		Endif
		if nLin >60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			nLin := 9
		endif
		@ nLin,00 psay num+"-"+item
		@ nLin,10 psay cod
		@ nLin,26 psay desc
		@ nLin,62 psay qtde picture "@E 999,999"
		//  @ nLin,70 psay entrega
		@ nLin,70 psay "__________"
		//@ nLin,82 psay Fantasia
		nLin := nLin + 1
		skip
	Enddo
	nLin := nLin + 1
Enddo

Select TRB
cTemp12c := CriaTrab(nil,.f.)
//index on cod to &cTemp12c
IndRegua("TRB", cTemp12c, "cod", , , "Selecionando Registros...")
nLin := 80
go top
SetRegua(recno())
cabec1      :="Outros Produtos - entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
Do while !eof()
	IncRegua()
	if left(cod,2)=="10" .or. linha='Cha'
		Skip
		Loop
	Endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 9
	endif
	cCod  := Cod
	cDesc := Desc
	dEnt  := Entrega
	nQtde := 0
	n:= 0
	Do while !eof() .and. Cod == cCod
		IncRegua()
		nQtde := nQtde + Qtde
		nTot  := nTot  + Qtde
		@ nLin,00 psay num+"-"+item
		@ nLin,10 psay Cod
		@ nLin,26 psay Desc
		@ nLin,62 psay Qtde picture "@E 999,999"
		//  @ nLin,60 psay dEnt
		@ nLin,70 psay "__________"
		nLin := nLin + 1
		n := n + 1
		Skip
	Enddo
	if n>1
		@ nLin,40 psay "TOTAL DO PRODUTO"
		@ nLin,62 psay nQtde picture "@E 999,999"
		nLin := nLin + 1
	endif
	@ nLin,00 psay replicate("- ",40)
	nLin := nLin + 1
Enddo

nLin := 80
go top
SetRegua(recno())
cabec2      :="Num.Op It Cod.Produto    CB Descricao                      Quantidade"
cabec1      :="Chaparia (1)- entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
Do while !eof()
	IncRegua()
	if linha<>'Cha'
		Skip
		Loop
	Endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 9
	endif
	cNumPed := Trb->Num
	@ nLin,00 psay Trb->Cli+" "+trb->Entreg+"  - Nome Fantasia : "+Fantasia
	nLin := nLin + 1
	Do while !eof() .and. Trb->Num==cNumPed
		if linha<>'Cha'
			Skip
			Loop
		Endif
		if nLin >60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			nLin := 9
		endif
		@ nLin,00 psay num+"-"+item
		@ nLin,10 psay cod
		@ nLin,26 psay desc
		@ nLin,62 psay qtde picture "@E 999,999"
		//  @ nLin,70 psay entrega
		@ nLin,70 psay "__________"
		//@ nLin,82 psay Fantasia
		nLin := nLin + 1
		skip
	Enddo
	nLin := nLin + 1
Enddo

Select TRB
cTemp12c := CriaTrab(nil,.f.)
//index on cod to &cTemp12c
IndRegua("TRB", cTemp12c, "cod", , , "Selecionando Registros...")
nLin := 80
go top
SetRegua(recno())
cabec1      :="Chaparia - entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
Do while !eof()
	IncRegua()
	if linha<>'Cha'
		Skip
		Loop
	Endif
	if nLin >60
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		nLin := 9
	endif
	cCod  := Cod
	cDesc := Desc
	dEnt  := Entrega
	nQtde := 0
	n:= 0
	Do while !eof() .and. Cod == cCod
		IncRegua()
		nQtde := nQtde + Qtde
		nTot  := nTot  + Qtde
		@ nLin,00 psay num+"-"+item
		@ nLin,10 psay Cod
		@ nLin,26 psay Desc
		@ nLin,62 psay Qtde picture "@E 999,999"
		//  @ nLin,60 psay dEnt
		@ nLin,70 psay "__________"
		nLin := nLin + 1
		n := n + 1
		Skip
	Enddo
	if n>1
		@ nLin,40 psay "TOTAL DO PRODUTO"
		@ nLin,62 psay nQtde picture "@E 999,999"
		nLin := nLin + 1
	endif
	@ nLin,00 psay replicate("- ",40)
	nLin := nLin + 1
Enddo

if lResumo
	Select TRB
	cTemp12d := CriaTrab(nil,.f.)
//	index on cod to &cTemp12d
	IndRegua("TRB", cTemp12d, "cod", , , "Selecionando Registros...")

	nLin := 80
	go top
	SetRegua(recno())
	titulo      :="Resumo da Producao de Espelhos "
	cabec1      :="Entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	Do while !eof()
		IncRegua()
		if left(cod,2)#"10"
			Skip
			Loop
		Endif
		if nLin >60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			nLin := 9
		endif
		cCod  := left(Cod,11)
		cDesc := Desc
		dEnt  := Entrega
		nQtde := 0
		n:= 0
		Do while !eof() .and. left(Cod,11) == cCod
			IncRegua()
			nQtde := nQtde + Qtde
			nTot  := nTot  + Qtde
			//  nLin := nLin + 1
			n := n + 1
			Skip
		Enddo
		@ nLin,10 psay cCod
		@ nLin,26 psay cDesc
		@ nLin,62 psay nQtde picture "@E 999,999"
		@ nLin,70 psay "__________"
		nLin := nLin + 1
	Enddo
	
	Select TRB
	cTemp12e := CriaTrab(nil,.f.)
//	index on cod to &cTemp12e
	IndRegua("TRB", cTemp12e, "cod", , , "Selecionando Registros...")

	nLin := 80
	go top
	SetRegua(recno())
	titulo      :="Resumo da Producao de Quadros "
	cabec1      :="Entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	Do while !eof()
		IncRegua()
		if left(cod,2)=="10"
			Skip
			Loop
		Endif
		if nLin >60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			nLin := 9
		endif
		cCod  := left(Cod,10)
		cDesc := Desc
		dEnt  := Entrega
		nQtde := 0
		n:= 0
		Do while !eof() .and. left(Cod,10) == cCod
			IncRegua()
			nQtde := nQtde + Qtde
			nTot  := nTot  + Qtde
			//  nLin := nLin + 1
			n := n + 1
			Skip
		Enddo
		@ nLin,10 psay cCod
		@ nLin,26 psay cDesc
		@ nLin,62 psay nQtde picture "@E 999,999"
		@ nLin,70 psay "__________"
		nLin := nLin + 1
	Enddo
	
Endif

********
if lIncons
	Select SB1
	dbSetOrder(1)
	nLin := 80
	go top
	SetRegua(recno())
	titulo      :="Relatorio de Inconsistencias "
	cabec1      :="Entrega de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	cabec2      :="Codigo do Produto  Descricao                               Quantidade        Emin"
	// 01234567890123456789012345678901234567890123456789012345678901234567890123456789
	Do while !eof()
		IncRegua()
		if !b1_tipo$"PA*RV"
			Skip
			Loop
		Endif
		if b1_grupo<='20' .and. substr(sb1->b1_cod,at(".",sb1->b1_cod)+1,1)<>"0"
			Skip
			Loop
		Endif
		if nLin >60
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
			nLin := 9
		endif
		Select SB2
		dbSetOrder(1)
		Seek xFilial()+sb1->b1_cod
		Do while !eof() .and. sb2->b2_cod==sb1->b1_cod
			//    Select SC0
			//    dbSetOrder(2)
			//    Seek xFilial()+sb1->b1_cod+sb2->b2_local
			//    nRes := 0
			//    Do while !eof() .and. c0_produto+c0_local==sb1->b1_cod+sb2->b2_local
			//      nRes := nRes + sc0->c0_quant
			//      Skip
			//    Enddo
			nRes := sb2->b2_reserva
			Select SC2
			dbSetOrder(2)
			Seek xFilial()+sb1->b1_cod
			nOps := 0
			Do while !eof() .and. c2_produto==sb1->b1_cod
				if sc2->c2_local#sb2->b2_local .or. sc2->c2_quje>=sc2->c2_quant .or. sc2->c2_datrf#ctod("0")
					skip
					loop
				endif
				nOps := nOps + sc2->c2_quant - sc2->c2_quje
				Skip
			Enddo
			nPonto := at(".",SB1->B1_COD)
			nArea := 0
			if nPonto=0 .and. !empty(SB1->b1_base)
				nArea := val(substr(SB1->B1_COD,7,4))*val(substr(SB1->B1_COD,12,4))/1000000
			else
				Select SG1
				dbSetOrder(1)
				Seek xFilial()+LEFT(SB1->B1_COD,nPonto-1)+space(15-nPonto+1)+"19."
				nArea := sg1->g1_quant
			endif
			
			nEmin := 0
			if sb2->b2_local='CB'
				nEmin := sb1->b1_emin
			endif
			if sb2->b2_qatu+nOps-nRes-nEmin<0
				@ nLin,01 psay sb1->b1_cod+"-"+left(sb1->b1_desc,40)
				@ nLin,62 psay (sb2->b2_qatu+nOps-nRes-nEmin) picture "@E 999,999"
				@ nLin,72 psay sb2->b2_local
				if nEmin<>0
					@ nLin,75 psay nEmin picture "@E 9999"
				endif
				nLin := nLin + 1
				Select TrbIn
				Reclock("TRBIN",.T.)
				TRBIN->COD	:= SB1->B1_COD
				TRBIN->DESC	:= SB1->B1_DESC
				TRBIN->CB	:= SB2->B2_LOCAL
				TRBIN->QTDE	:= (sb2->b2_qatu+nOps-nRes-nEmin)
				TRBIN->AREA	:= (sb2->b2_qatu+nOps-nRes-nEmin)*nArea
				TRBIN->AREAUNIT	:= nArea
				MsUnLock()
			Endif
			Select SB2
			skip
		Enddo
		Select Sb1
		skip
	Enddo
	
	
Endif

********
//if nlin<60
Roda(0,"","P")
//Endif
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

PedFat() // Verifica pedidos a faturar

GeraExcel()

Return

**************************
Static Function GeraExcel()
**************************

Local oReport := nil
oReport := RptDef(cPerg)
oReport:PrintDialog()

Return

Static Function RptDef(cNome)

Local oReport := Nil
Local oSection1:= Nil
Local oSection2:= Nil
Local oSection3:= Nil
Local oSection4:= Nil
Local oSection5:= Nil
Local oSection6:= Nil
Local oBreak
Local oFunction

oReport := TReport():New(cNome,"Ordens de Produção em Aberto",cNome,{|oReport| ReportPrint(oReport)},"Relat?io Programação")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1:= TRSection():New(oReport, "Espelhos", {"TRB"}, , .F., .T.)

TRCell():New( oSection1, "ENTREGA" 	 ,"TRB", "Producao","@!",10)
TRCell():New( oSection1, "NUM"	     ,"TRB", "Pedido","@!",10)
TRCell():New( oSection1, "ITEM"      ,"TRB", "Item ","@!",5)
TRCell():New( oSection1, "COD"		 ,"TRB", "Produto","@!",20)
TRCell():New( oSection1, "DESC"		 ,"TRB", "Descrição","@!",20)
TRCell():New( oSection1, "CB"        ,"TRB", "Local","@!",5)
TRCell():New( oSection1, "CLI"		 ,"TRB", "Cliente","@!",30)
TRCell():New( oSection1, "FANTASIA"	 ,"TRB", "Nome Fantasia","@!",30)
TRCell():New( oSection1, "QTDE"	 	 ,"TRB", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection1, "AREAUNIT"  ,"TRB", "Area Unit.","@E 999,999.999999",14)
TRCell():New( oSection1, "AREA"	 	 ,"TRB", "Area Total","@E 999,999.999999",14)

oSection2:= TRSection():New(oReport, "Quadros", {"TRB"}, , .F., .T.)

TRCell():New( oSection2, "ENTREGA" 	 ,"TRB", "Produção","@!",10)
TRCell():New( oSection2, "NUM"	     ,"TRB", "Pedido","@!",10)
TRCell():New( oSection2, "ITEM"      ,"TRB", "Item ","@!",5)
TRCell():New( oSection2, "COD"		 ,"TRB", "Produto","@!",20)
TRCell():New( oSection2, "DESC"		 ,"TRB", "Descrição","@!",20)
TRCell():New( oSection2, "CB"        ,"TRB", "Local","@!",5)
TRCell():New( oSection2, "CLI"		 ,"TRB", "Cliente","@!",30)
TRCell():New( oSection2, "FANTASIA"	 ,"TRB", "Nome Fantasia","@!",30)
TRCell():New( oSection2, "QTDE"	 	 ,"TRB", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection2, "AREAUNIT"  ,"TRB", "Area Unit.","@E 999,999.999999",14)
TRCell():New( oSection2, "AREA"	 	 ,"TRB", "Area Total","@E 999,999.999999",14)

oSection3:= TRSection():New(oReport, "Chapas", {"TRB"}, , .F., .T.)

TRCell():New( oSection3, "ENTREGA" 	 ,"TRB", "Produção","@!",10)
TRCell():New( oSection3, "NUM"	     ,"TRB", "Pedido","@!",10)
TRCell():New( oSection3, "ITEM"      ,"TRB", "Item ","@!",5)
TRCell():New( oSection3, "COD"		 ,"TRB", "Produto","@!",20)
TRCell():New( oSection3, "DESC"		 ,"TRB", "Descrição","@!",20)
TRCell():New( oSection3, "CB"        ,"TRB", "Local","@!",5)
TRCell():New( oSection3, "CLI"		 ,"TRB", "Cliente","@!",30)
TRCell():New( oSection3, "FANTASIA"	 ,"TRB", "Nome Fantasia","@!",30)
TRCell():New( oSection3, "QTDE"	 	 ,"TRB", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection3, "AREAUNIT"  ,"TRB", "Area Unit.","@E 999,999.999999",14)
TRCell():New( oSection3, "AREA"	 	 ,"TRB", "Area Total","@E 999,999.999999",14)


oSection4:= TRSection():New(oReport, "Faturar", {"TRBFAT"}, , .F., .T.)

TRCell():New( oSection4, "NUM"	     ,"TRBFAT", "Pedido","@!",10)
TRCell():New( oSection4, "ITEM"      ,"TRBFAT", "Item ","@!",5)
TRCell():New( oSection4, "CLIENTE"	 ,"TRBFAT", "Cliente","@!",30)
TRCell():New( oSection4, "NOME"		 ,"TRBFAT", "Nome","@!",30)
TRCell():New( oSection4, "EMISSAO" 	 ,"TRBFAT", "Emissao","@!",10)
TRCell():New( oSection4, "ENTREGA" 	 ,"TRBFAT", "Producao","@!",10)
TRCell():New( oSection4, "COD"		 ,"TRBFAT", "Produto","@!",20)
TRCell():New( oSection4, "DESC"		 ,"TRBFAT", "Descricao","@!",20)
//TRCell():New( oSection4, "QUANT"	 ,"TRBFAT", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection4, "QTDPED"	 ,"TRBFAT", "Qtde Pedido","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALOR"	 ,"TRBFAT", "Valor Pedido","@E 999,999,999.99",15)
TRCell():New( oSection4, "PERC"		 ,"TRBFAT", "Percentual","@E 999,999.99",10)
TRCell():New( oSection4, "PRONTAS"	 ,"TRBFAT", "Prontas","@E 999,999.99",10)
TRCell():New( oSection4, "FAZER"	 ,"TRBFAT", "Fazer","@E 999,999.99",10)
//TRCell():New( oSection4, "LIB"       ,"TRBFAT", "Liberado","@!",5)
TRCell():New( oSection4, "UM"	 	 ,"TRBFAT", "Unidade Medida","@!",2)
TRCell():New( oSection4, "SALDO"	 ,"TRBFAT", "Saldo em Estq","@E 999,999.99",10)
TRCell():New( oSection4, "COND"	 	 ,"TRBFAT", "Cond.Pgto","@!",15)
TRCell():New( oSection4, "FATOR"	 ,"TRBFAT", "Fator","@!",1)

// Section 5 - a Faturar (Analítico)

oSection5:= TRSection():New(oReport, "Faturar (Analit)", {"TRBFAT1"}, , .F., .T.)

TRCell():New( oSection5, "NUM"	     ,"TRBFAT1", "Pedido","@!",10)
TRCell():New( oSection5, "ITEM"      ,"TRBFAT1", "Item ","@!",5)
TRCell():New( oSection5, "CLIENTE"	 ,"TRBFAT1", "Cliente","@!",30)
TRCell():New( oSection5, "NOME"		 ,"TRBFAT1", "Nome","@!",30)
TRCell():New( oSection5, "EMISSAO" 	 ,"TRBFAT1", "Emissao","@!",10)
TRCell():New( oSection5, "ENTREGA" 	 ,"TRBFAT1", "Producao","@!",10)
TRCell():New( oSection5, "COD"		 ,"TRBFAT1", "Produto","@!",20)
TRCell():New( oSection5, "DESC"		 ,"TRBFAT1", "Descricao","@!",20)
//TRCell():New( oSection5, "QUANT"	 ,"TRBFAT1", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection5, "QTDPED"	 ,"TRBFAT1", "Qtde Pedido","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALOR"	 ,"TRBFAT1", "Valor Pedido","@E 999,999,999.99",15)
TRCell():New( oSection5, "PERC"		 ,"TRBFAT1", "Percentual","@E 999,999.99",10)
TRCell():New( oSection5, "PRONTAS"	 ,"TRBFAT1", "Prontas","@E 999,999.99",10)
TRCell():New( oSection5, "FAZER"	 ,"TRBFAT1", "Fazer","@E 999,999.99",10)
//TRCell():New( oSection5, "LIB"       ,"TRBFAT1", "Liberado","@!",5)
TRCell():New( oSection5, "UM"	 	 ,"TRBFAT1", "Unidade Medida","@!",2)
TRCell():New( oSection5, "SALDO"	 ,"TRBFAT1", "Saldo em Estq","@E 999,999.99",10)
TRCell():New( oSection5, "COND"	 	 ,"TRBFAT1", "Cond.Pgto","@!",15)
TRCell():New( oSection5, "FATOR"	 ,"TRBFAT1", "Fator","@!",1)

// Section 6
if lIncons

oSection6:= TRSection():New(oReport, "Inconsistencias ", {"TRBIN"}, , .F., .T.)  

TRCell():New( oSection6, "COD"		, "TRBIN","Cód.prod."  ,"@!",15)
TRCell():New( oSection6, "DESC"		 ,"TRBIN", "Descrição","@!",20)
//TRCell():New( oSection2, "CB"        ,"TRBIN", "Local","@!",5)
TRCell():New( oSection6, "QTDE"	 	 ,"TRBIN", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection6, "AREAUNIT"  ,"TRBIN", "Area Unit.","@E 999,999.999999",14)
TRCell():New( oSection6, "AREA"	 	 ,"TRBIN", "Area Total","@E 999,999.999999",14)

Endif

TRFunction():New(oSection3:Cell("NUM"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por seção
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local oSection4 := oReport:Section(4)
Local oSection5 := oReport:Section(5)
Local oSection6 := oReport:Section(6)

Local cQuery    := ""
Local cPedido   := ""
Local lPrim 	:= .T.

dbSelectArea("TRB")
TRB->(dbGoTop())

oReport:SetMeter(TRB->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection1:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRB")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		if Linha<>"Esp"
			skip
			loop
		endif
		oReport:IncMeter()
		//imprimo a primeira seção
		oSection1:Cell("ENTREGA"):SetValue(TRB->ENTREGA)
		oSection1:Cell("NUM"):SetValue(TRB->NUM)
		oSection1:Cell("ITEM"):SetValue(TRB->ITEM)
		oSection1:Cell("COD"):SetValue(TRB->COD)
		oSection1:Cell("DESC"):SetValue(TRB->DESC)
		oSection1:Cell("CB"):SetValue(TRB->CB)
		oSection1:Cell("CLI"):SetValue(TRB->CLI)
		oSection1:Cell("FANTASIA"):SetValue(TRB->FANTASIA)
		oSection1:Cell("QTDE"):SetValue(TRB->QTDE)
		oSection1:Cell("AREAUNIT"):SetValue(TRB->AREAUNIT)
		oSection1:Cell("AREA"):SetValue(TRB->AREA)
		oSection1:Printline()
		TRB->(dbSkip())
	Enddo
	//finalizo a primeira seção
Enddo

dbSelectArea("TRB")
TRB->(dbGoTop())

oReport:SetMeter(TRB->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection2:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRB")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		if Linha<>"Qua"
			skip
			loop
		endif
		oReport:IncMeter()
		//imprimo a primeira seção
		oSection2:Cell("ENTREGA"):SetValue(TRB->ENTREGA)
		oSection2:Cell("NUM"):SetValue(TRB->NUM)
		oSection2:Cell("ITEM"):SetValue(TRB->ITEM)
		oSection2:Cell("COD"):SetValue(TRB->COD)
		oSection2:Cell("DESC"):SetValue(TRB->DESC)
		oSection2:Cell("CB"):SetValue(TRB->CB)
		oSection2:Cell("CLI"):SetValue(TRB->CLI)
		oSection2:Cell("FANTASIA"):SetValue(TRB->FANTASIA)
		oSection2:Cell("QTDE"):SetValue(TRB->QTDE)
		oSection2:Cell("AREAUNIT"):SetValue(TRB->AREAUNIT)
		oSection2:Cell("AREA"):SetValue(TRB->AREA)
		oSection2:Printline()
		TRB->(dbSkip())
	Enddo
	//finalizo a primeira seção
Enddo

dbSelectArea("TRB")
TRB->(dbGoTop())

oReport:SetMeter(TRB->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection3:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRB")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		if Linha<>"Cha"
			skip
			loop
		endif
		oReport:IncMeter()
		//imprimo a primeira seção
		oSection3:Cell("ENTREGA"):SetValue(TRB->ENTREGA)
		oSection3:Cell("NUM"):SetValue(TRB->NUM)
		oSection3:Cell("ITEM"):SetValue(TRB->ITEM)
		oSection3:Cell("COD"):SetValue(TRB->COD)
		oSection3:Cell("DESC"):SetValue(TRB->DESC)
		oSection3:Cell("CB"):SetValue(TRB->CB)
		oSection3:Cell("CLI"):SetValue(TRB->CLI)
		oSection3:Cell("FANTASIA"):SetValue(TRB->FANTASIA)
		oSection3:Cell("QTDE"):SetValue(TRB->QTDE)
		oSection3:Cell("AREAUNIT"):SetValue(TRB->AREAUNIT)
		oSection3:Cell("AREA"):SetValue(TRB->AREA)
		oSection3:Printline()
		TRB->(dbSkip())
	Enddo
	//finalizo a primeira seção
Enddo

Select Trb
Use

dbSelectArea("TRBFAT")
TRBFAT->(dbGoTop())

oReport:SetMeter(TRBFAT->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a segunda seção
	oSection4:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRBFAT")
	
	IncProc("Imprimindo ")
	
	Do while !eof() 
		oReport:IncMeter()
		//imprimo a primeira seção
		oSection4:Cell("NUM"):SetValue(TRBFAT->NUM)
		oSection4:Cell("ITEM"):SetValue(TRBFAT->ITEM)
		oSection4:Cell("CLIENTE"):SetValue(TRBFAT->CLIENTE)
		oSection4:Cell("NOME"):SetValue(TRBFAT->NOME)
		oSection4:Cell("EMISSAO"):SetValue(TRBFAT->EMISSAO)
		oSection4:Cell("ENTREGA"):SetValue(TRBFAT->ENTREGA)
		oSection4:Cell("COD"):SetValue(TRBFAT->COD)
		oSection4:Cell("DESC"):SetValue(TRBFAT->DESC)
		//oSection4:Cell("QUANT"):SetValue(TRBFAT->QUANT)
		oSection4:Cell("QTDPED"):SetValue(TRBFAT->QTDPED)
		oSection4:Cell("VALOR"):SetValue(TRBFAT->VALOR)
		oSection4:Cell("PERC"):SetValue(TRBFAT->PERC)
		oSection4:Cell("PRONTAS"):SetValue(TRBFAT->PRONTAS)
		oSection4:Cell("FAZER"):SetValue(TRBFAT->FAZER)
		oSection4:Cell("UM"):SetValue(TRBFAT->UM)
		oSection4:Cell("SALDO"):SetValue(TRBFAT->SALDO)
		oSection4:Cell("COND"):SetValue(TRBFAT->COND)
		oSection4:Cell("FATOR"):SetValue(TRBFAT->FATOR)

		oSection4:Printline()
		TRBFAT->(dbSkip())

	Enddo
	//finalizo a primeira seção
Enddo
Use

dbSelectArea("TRBFAT1")
TRBFAT1->(dbGoTop())

oReport:SetMeter(TRBFAT1->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a segunda seção
	oSection5:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRBFAT1")
	
	IncProc("Imprimindo ")
	
	Do while !eof() 
		oReport:IncMeter()
		//imprimo a primeira seção
		oSection5:Cell("NUM"):SetValue(TRBFAT1->NUM)
		oSection5:Cell("ITEM"):SetValue(TRBFAT1->ITEM)
		oSection5:Cell("CLIENTE"):SetValue(TRBFAT1->CLIENTE)
		oSection5:Cell("NOME"):SetValue(TRBFAT1->NOME)
		oSection5:Cell("EMISSAO"):SetValue(TRBFAT1->EMISSAO)
		oSection5:Cell("ENTREGA"):SetValue(TRBFAT1->ENTREGA)
		oSection5:Cell("COD"):SetValue(TRBFAT1->COD)
		oSection5:Cell("DESC"):SetValue(TRBFAT1->DESC)
		//oSection5:Cell("QUANT"):SetValue(TRBFAT1->QUANT)
		oSection5:Cell("QTDPED"):SetValue(TRBFAT1->QTDPED)
		oSection5:Cell("VALOR"):SetValue(TRBFAT1->VALOR)
		oSection5:Cell("PERC"):SetValue(TRBFAT1->PERC)
		oSection5:Cell("PRONTAS"):SetValue(TRBFAT1->PRONTAS)
		oSection5:Cell("FAZER"):SetValue(TRBFAT1->FAZER)
		oSection5:Cell("UM"):SetValue(TRBFAT1->UM)
		oSection5:Cell("SALDO"):SetValue(TRBFAT1->SALDO)
		oSection5:Cell("COND"):SetValue(TRBFAT1->COND)
		oSection5:Cell("FATOR"):SetValue(TRBFAT1->FATOR)

		oSection5:Printline()
		TRBFAT1->(dbSkip())

	Enddo
	//finalizo a quinta seção
Enddo
Use

if lIncons

dbSelectArea("TRBIN")
TRBIN->(dbGoTop())

oReport:SetMeter(TRBIN->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a segunda seção
	oSection6:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRBIN")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		//imprimo a primeira seção
		oSection6:Cell("COD"):SetValue(TRBIN->COD)
		oSection6:Cell("DESC"):SetValue(TRBIN->DESC)
//		oSection6:Cell("CB"):SetValue(TRBIN->CB)
		oSection6:Cell("QTDE"):SetValue(TRBIN->QTDE)
		oSection6:Cell("AREAUNIT"):SetValue(TRBIN->AREAUNIT)
		oSection6:Cell("AREA"):SetValue(TRBIN->AREA)
		oSection6:Printline()
		TRBIN->(dbSkip())
	Enddo
	//finalizo a primeira seção
Enddo
Use

Endif

oSection1:Finish()
oSection2:Finish()
oSection3:Finish()
oSection4:Finish()
oSection5:Finish()
if lIncons
	oSection6:Finish()
endif

Return



***************** Fim do Programa ************************

// Pedidos a Faturar - Nova Planilha
Static Function PedFat()

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

if select("trbFAT1") # 0
	trbFAT1->(dbclosearea())
endif
IF SELECT("TRBFAT") # 0
	TRBFat->(DBCLOSEAREA( ))
ENDIF

cTempFat1 := CriaTrab(nil,.f.)
dbCreate(cTempFat1,aCamposA)
dbUseArea( .T.,,cTempFat1, "TRBFAT1", Nil, .F. )
//Index on Num to &cTemp
IndRegua("TRBFAT1", cTempFat1, "Num", , , "Selecionando Registros...")

cTempFat:= CriaTrab(nil,.f.)
copy to &cTempFat
dbUseArea( .T.,,cTempFat, "TRBFAT", Nil, .F. )
//Index on Num to &cTemp1
IndRegua("TRBFAT", cTempFAT, "Num", , , "Selecionando Registros...")


dbSelectArea("SC0")
dbGoTop()
ProcRegua(recCount())
While !eof()
	
	IncProc()
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
	
	//UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA¢¯
	//©ø Acumular os valores dos pedidos.                           ©ø
	//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU
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
	Select trbfat1
	RecLock("trbfat1",.T.)
	trbfat1->NUM        := SC5->C5_NUM
	trbfat1->ITEM       := SC6->C6_ITEM
	trbfat1->CLIENTE    := SC5->C5_CLIENTE+SC5->C5_LOJACLI
	trbfat1->NOME       := SA1->A1_NOME
	trbfat1->COND       := SE4->E4_DESCRI
	trbfat1->EMISSAO    := SC5->C5_EMISSAO
	trbfat1->ENTREGA    := SC6->C6_ENTREG
	trbfat1->QTDPED     := SC6->C6_QTDVEN-SC6->C6_QTDENT
	trbfat1->COD        := cCod
	trbfat1->DESC       := Sb1->b1_desc
	trbfat1->QUANT      := SC6->C6_QTDVEN
	trbfat1->VALOR      := SC6->C6_VALOR
	trbfat1->UM         := Sb1->b1_um
	trbfat1->saldo      := iif(Sb2->b2_qatu - nRes>0,Sb2->b2_qatu - nRes,0)
	trbfat1->prontas    := nPronta
	trbfat1->fazer      := SC6->C6_QTDVEN-SC6->C6_QTDENT-nPronta
	trbfat1->fator      := SC5->C5_Fator
	trbfat1->perc       := (Sb2->b2_qatu-nRes)/(SC6->C6_QTDVEN-SC6->C6_QTDENT)
	trbfat1->ok         := iif(!empty(sc0->c0_codant)," ","OK")
	MsUnLock()
	
	dbSelectArea("SC0")
	dbSkip()
End

Select TRBFAT1
dbGoTop()
Do while !eof()
	nReg := recno()
	cNum := trbfat1->Num
	cOk  := trbfat1->Ok
	nQt1 := nQT2 := nQt3 := nQt4 := nQt5 := nQt6 := 0
	Do while !eof() .and. trbfat1->Num==cNum
		nQt1 := nQt1 + trbfat1->Qtdped
		nQt2 := nQt2 + trbfat1->Valor
		nQt3 := nQt3 + iif(trbfat1->Saldo > trbfat1->Qtdped,trbfat1->Qtdped,trbfat1->Saldo)
		nQt5 := nQt5 + trbfat1->Prontas
		nQt6 := nQt6 + trbfat1->Fazer
		skip
	Enddo
	nReg1 := recno()
	goto nReg
	Select TRBfat
	RecLock("TRBfat",.T.)
	TRBfat->NUM        := trbfat1->Num
	TRBfat->ITEM       := " "
	TRBfat->LIB        := " "
	TRBfat->CLIENTE    := trbfat1->Cliente
	TRBfat->NOME       := trbfat1->Nome
	TRBfat->COND       := trbfat1->Cond
	TRBfat->EMISSAO    := trbfat1->emissao
	TRBfat->ENTREGA    := trbfat1->entrega
	TRBfat->VALOR      := nQt2
	TRBfat->UM         := trbfat1->um
	TRBfat->fator      := trbfat1->fator
	TRBfat->QTDPED     := nQt1
	TRBfat->saldo      := nQt3
	TRBfat->prontas    := nQt5
	TRBfat->fazer      := nQt6
	TRBfat->perc       := nQt5/nQt1 // if(nQt3>nQt1,100,iif(nQt3>0,nQt3/nQt1,0))
	TRBfat->ok         := cOk
	MsUnLock()
	Select TRBFAT1
	goto nReg1
	
enddo

Select TRBFAT
//copy to \x

Go Top


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
