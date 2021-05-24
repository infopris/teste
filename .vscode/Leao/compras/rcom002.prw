#include "rwmake.ch"

User Function RCOM002()        // Relatorio de Pedidos a faturar por prazo pgto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ARETURN,CBTXT,CBCONT,CDESC1,CDESC2,CDESC3")
SetPrvt("CPERG,CSTRING,LI,M_PAG,NLASTKEY,NOMEPROG")
SetPrvt("TITULO,WNREL,LIMITE,TAMANHO,ACPOTRB,ATAM")
SetPrvt("CNOMARQ,CKEY,CTPPED,CARQ,CFILTER,CKEY2")
SetPrvt("CARQIND,ASECAO,AVENDEDOR,NVLCOMIS,NVLNETO,NCUSTO")
SetPrvt("NLINHA,NTOTCOMI,CABEC1,CABEC2,NTGFATURA,NTGCOMIS")
SetPrvt("NTGIPI,NTGICMS,NTGVLNETO,NTGCUSTO,NTGFRETE,NTGCOMIBR")
SetPrvt("NTGCOMIAL,NTGEXTRAS,NTGVLCOMI,ATOTAL,LCABECPRIM,CTPPEDIDO")
SetPrvt("CTIT,I,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCOM002  ³ Autor ³ Luiz Eduardo          ³ Data ³ 12/05/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico p/ Espelhos Leao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos de compras"
cDesc2   := "em Carteira por periodo"
cDesc3   := ""
cPerg    := "RCOM02"
cString  := "SC1"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RCOM002"
titulo   := "Pedidos de Compra por Prazo de Pagto"
wnrel    := "RCOM002"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Entrega de                                      ³
//³ mv_par02  // Entrega ate                                     ³
//³ mv_par03  // Emissao de                                      ³
//³ mv_par04  // Emissao ate                                     ³
//³ mv_par05  // Dias periodo 01                                 ³
//³ mv_par06  // Dias periodo 02                                 ³
//³ mv_par07  // Dias periodo 03                                 ³
//³ mv_par08  // Dias periodo 04                                 ³
//³ mv_par09  // Dias periodo 05                                 ³
//³ mv_par10  // Dias periodo 06                                 ³
//³ mv_par11  // Liberados                                       ³
//³ mv_par12  // Analitico/Sintetico                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

limite  := 132
tamanho := "G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()
//Select TRB
//Use

Return Nil

*************************
Static Function C030Imp()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "FORNECE" , "C",20,0})
AADD(aCampos,{ "ENTREG"  , "D",08,0})
AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "COND"    , "C",30,0})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "PRAZO1"  , "N",12,2})
AADD(aCampos,{ "PRAZO2"  , "N",12,2})
AADD(aCampos,{ "PRAZO3"  , "N",12,2})
AADD(aCampos,{ "PRAZO4"  , "N",12,2})
AADD(aCampos,{ "PRAZO5"  , "N",12,2})
AADD(aCampos,{ "PRAZO6"  , "N",12,2})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on dtos(Entreg) to &cTemp

Select SC7
dbGotop()
SetRegua(recCount())
Do while !eof()
	IncRegua()
	if sc7->c7_datprf<mv_par01 .or. sc7->c7_datprf>mv_par02
		skip
		loop
	endif
	if sc7->c7_quje-sc7->c7_quant>=0 .or. sc7->c7_residuo=="S"
		Skip
		loop
	endif
	Select SA2
	Seek xFilial()+sc7->c7_fornece+sc7->c7_loja
	if mv_par11==1 .and. 1==2
		Select SC9
		dbsetorder(1)
		dbSeek( xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
		Select SC6
		If sc9->c9_blcred# '  '
			Skip
			Loop
		Endif
	endif
	
	dEnt     := sc7->c7_datprf
	nValPed  := 0
	cNum     := sc7->c7_Num
	cCond    := sc7->c7_Cond
	dEmissao := sc7->c7_emissao
	Select SC7
	Do while !eof() .and. c7_num==cNum
		nValPed := nValPed + (sc7->c7_quant-sc7->c7_quje)*sc7->c7_preco
		Skip
		if dEnt<>sc7->c7_datprf
			exit
		endif
	Enddo
	
	Select SE4
	Seek xFilial()+cCond
	nPrazo1 := nPrazo2 := nPrazo3 := nPrazo4 := nPrazo5 := nPrazo6 := 0
	nPrazo7 := nPrazo8 := nPrazo9 := 0
	ini := 1
	cCond := se4->e4_cond
	if at(',',cCond)==0
		tam := at(' ',cCond)-1
	else
		tam := at(',',cCond)-1
	endif
	For x:=1 to 9
		cCond := substr(se4->e4_cond,ini+tam+1,20)
		if left(cCond,2) == space(2)
			Exit
		endif
		ini := ini+tam+1
		if at(',',cCond)==0
			tam := at(' ',cCond)-1
		else
			tam := at(',',cCond)-1
		endif
	Next
	ini := 1
	cCond := se4->e4_cond
	if at(',',cCond)==0
		tam := at(' ',cCond)-1
	else
		tam := at(',',cCond)-1
	endif
	nVal1 := nVal2 := nVal3 := nVal4 := nVal5 := nVal6 := 0
	For n:=1 to 9
		cPrazo  := "nPrazo"+str(n,1)
		&cPrazo := val(substr(se4->E4_Cond,ini,tam))
		cCond := substr(se4->e4_Cond,ini+tam+1,20)
		ini := ini+tam+1
		if at(',',cCond)==0
			tam := at(' ',cCond)-1
		else
			tam := at(',',cCond)-1
		endif
		Do Case
			Case &cPrazo<=mv_par05
				nVal1 := nVal1 + nValPed/x
			Case &cPrazo<=mv_par06 .and. &cPrazo>mv_par05
				nVal2 := nVal2 + nValPed/x
			Case &cPrazo<=mv_par07 .and. &cPrazo>mv_par06
				nVal3 := nVal3 + nValPed/x
			Case &cPrazo<=mv_par08 .and. &cPrazo>mv_par07
				nVal4 := nVal4 + nValPed/x
			Case &cPrazo<=mv_par09 .and. &cPrazo>mv_par08
				nVal5 := nVal5 + nValPed/x
			Case &cPrazo<=mv_par10 .and. &cPrazo>mv_par09
				nVal6 := nVal6 + nValPed/x
		EndCase
		if left(cCond,2) == space(2)
			Exit
		endif
	Next
	Select TRB
	reclock("TRB",.t.)
		trb->num       := cNum
		trb->entreg    := dEnt
		trb->fornece   := sa2->a2_nreduz
		trb->emissao   := dEmissao
		trb->cond      := se4->e4_cond
		trb->valor     := nValPed
		trb->prazo1    := nVal1
		trb->prazo2    := nVal2
		trb->prazo3    := nVal3
		trb->prazo4    := nVal4
		trb->prazo5    := nVal5
		trb->prazo6    := nVal6
	MsUnLock()
	Select SC7
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if mv_par09==1
	Cabec1 := "Pedidos Liberados"
else
	Cabec1 := "Todos os Pedidos"
endif
cPer := space(8)+str(mv_par05,3)+space(12)+str(mv_par06,3)+space(12)+str(mv_par07,3)+space(12)+str(mv_par08,3)+space(12)+str(mv_par09,3)+space(12)+str(mv_par10,3)+space(09)+"Total"
if mv_par12==1
	Cabec2 := "Pedido  Emissao    Fornecedor   "+Space(10)+cPer
	//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
	//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
else
	Cabec2 := "        Entrega   "+cPer
endif

Select TRB
//Index on dtos(c6_entreg)+c6_produto to &cTrb1
dbGotop()

SetRegua(recCount())

nVlt1 := nVlt2 := nVlt3 := nVlt4 := nVlt5 := nVlt6 := nValt := 0

Do While !Eof()
	
	IncRegua()
	
	If li > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	dDat := entreg
	nVl1 := nVl2 := nVl3 := nVl4 := nVl5 := nVl6 := nVal := 0
	do while !eof() .and. entreg ==dDat
		if mv_par12==1
			If li > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			Endif
			@ li,001 PSAY Num
			@ li,008 PSAY Emissao
			@ li,019 PSAY Fornece
			@ li,040 PSAY Prazo1  picture "@E 99,999,999.99"
			@ li,055 PSAY Prazo2  picture "@E 99,999,999.99"
			@ li,070 PSAY Prazo3  picture "@E 99,999,999.99"
			@ li,085 PSAY Prazo4  picture "@E 99,999,999.99"
			@ li,100 PSAY Prazo5  picture "@E 99,999,999.99"
			@ li,115 PSAY Prazo6  picture "@E 99,999,999.99"
			@ li,129 PSAY Valor   picture "@E 99,999,999.99"
			li := li +1
		endif
		nVl1  := nVl1 + prazo1
		nVl2  := nVl2 + prazo2
		nVl3  := nVl3 + prazo3
		nVl4  := nVl4 + prazo4
		nVl5  := nVl5 + prazo5
		nVl6  := nVl6 + prazo6
		nVal  := nVal + Valor
		skip
	Enddo
	@ li,000 PSAY "Entreg:"
	@ li,008 PSAY dDat
	if mv_par12#1
		
		@ li,030 PSAY nVl1  picture "@E 99,999,999.99"
		@ li,045 PSAY nVl2  picture "@E 99,999,999.99"
		@ li,060 PSAY nVl3  picture "@E 99,999,999.99"
		@ li,075 PSAY nVl4  picture "@E 99,999,999.99"
		@ li,090 PSAY nVl5  picture "@E 99,999,999.99"
		@ li,105 PSAY nVl6  picture "@E 99,999,999.99"
		@ li,120 PSAY nVal  picture "@E 99,999,999.99"
	else
		@ li,040 PSAY nVl1  picture "@E 99,999,999.99"
		@ li,055 PSAY nVl2  picture "@E 99,999,999.99"
		@ li,070 PSAY nVl3  picture "@E 99,999,999.99"
		@ li,085 PSAY nVl4  picture "@E 99,999,999.99"
		@ li,100 PSAY nVl5  picture "@E 99,999,999.99"
		@ li,115 PSAY nVl6  picture "@E 99,999,999.99"
		@ li,129 PSAY nVal  picture "@E 99,999,999.99"
		
	endif
	li := li +2
	nVlt1 := nVlt1 + nVl1
	nVlt2 := nVlt2 + nVl2
	nVlt3 := nVlt3 + nVl3
	nVlt4 := nVlt4 + nVl4
	nVlt5 := nVlt5 + nVl5
	nVlt6 := nVlt6 + nVl6
	nValt := nValt + nVal
Enddo
li := li +1
@ li,000 PSAY "Total do relatorio:"
if mv_par12#1
	@ li,030 PSAY nVlt1  picture "@E 99,999,999.99"
	@ li,045 PSAY nVlt2  picture "@E 99,999,999.99"
	@ li,060 PSAY nVlt3  picture "@E 99,999,999.99"
	@ li,075 PSAY nVlt4  picture "@E 99,999,999.99"
	@ li,090 PSAY nVlt5  picture "@E 99,999,999.99"
	@ li,105 PSAY nVlt6  picture "@E 99,999,999.99"
	@ li,120 PSAY nValt  picture "@E 99,999,999.99"
	li := li +1
	@ li,000 PSAY "Percentuais:"
	@ li,030 PSAY nVlt1/nValt*100  picture "@E 99,999,999.99"
	@ li,045 PSAY nVlt2/nValt*100  picture "@E 99,999,999.99"
	@ li,060 PSAY nVlt3/nValt*100  picture "@E 99,999,999.99"
	@ li,075 PSAY nVlt4/nValt*100  picture "@E 99,999,999.99"
	@ li,090 PSAY nVlt5/nValt*100  picture "@E 99,999,999.99"
	@ li,105 PSAY nVlt6/nValt*100  picture "@E 99,999,999.99"
	
else
	@ li,040 PSAY nVlt1  picture "@E 99,999,999.99"
	@ li,055 PSAY nVlt2  picture "@E 99,999,999.99"
	@ li,070 PSAY nVlt3  picture "@E 99,999,999.99"
	@ li,085 PSAY nVlt4  picture "@E 99,999,999.99"
	@ li,100 PSAY nVlt5  picture "@E 99,999,999.99"
	@ li,115 PSAY nVlt6  picture "@E 99,999,999.99"
	@ li,129 PSAY nValt  picture "@E 99,999,999.99"
	li := li +1
	@ li,000 PSAY "Percentuais:"
	@ li,040 PSAY nVlt1/nValt*100  picture "@E 99,999,999.99"
	@ li,055 PSAY nVlt2/nValt*100  picture "@E 99,999,999.99"
	@ li,070 PSAY nVlt3/nValt*100  picture "@E 99,999,999.99"
	@ li,085 PSAY nVlt4/nValt*100  picture "@E 99,999,999.99"
	@ li,100 PSAY nVlt5/nValt*100  picture "@E 99,999,999.99"
	@ li,115 PSAY nVlt6/nValt*100  picture "@E 99,999,999.99"
endif

///
IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Spool de Impressao.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
