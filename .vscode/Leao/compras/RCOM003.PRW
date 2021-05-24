#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RCOM003()        // Relatorio de Pedidos de Compras por periodo

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
±±³Fun‡…o    ³ RFAT011  ³ Autor ³ Luiz Eduardo          ³ Data ³ 06/11/2003 ³±±
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
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos em Carteira "
cDesc2   := "por periodo"
cDesc3   := ""
cPerg    := "RCOM03"
cString  := "SC7"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RCOM003"
titulo   := "Pedidos de Compras"
wnrel    := "RCOM003"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Entrega de                                      ³
//³ mv_par02  // Entrega ate                                     ³
//³ mv_par03  // Cliente de                                      ³
//³ mv_par04  // Cliente ate                                     ³
//³ mv_par05  // Liberados                                       ³
//³ mv_par06  // Analitico/Sintetico                             ³
//³ mv_par07  // total por produto                               ³
//³ mv_par08  // imprime valor                                   ³
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
tamanho := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()

Return Nil

*************************
Static Function C030Imp()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Select SC7
cTrb1 := Criatrab(nil,.f.)
Copy stru to &cTrb1
dbUseArea( .T.,, cTrb1,"TRB", .F., .F. )
Select SC7
dbGoTop()

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
	if sc7->c7_fornece<mv_par03 .or. sc7->c7_fornece>mv_par04
		Skip
		loop
	endif
	if mv_par05==1 .and. 1==2
		Select SC9
		dbsetorder(1)
		dbSeek( xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
		Select SC6
		If sc9->c9_blcred# '  '
			Skip
			Loop
		Endif
	endif
	
	Select SA2
	seek xFilial()+sc7->(c7_fornece+c7_loja)
	cCodProd := sc7->c7_produto
	
	Select TRB
	If rlock()
		appe blan
		trb->c7_num    := sc7->c7_num
		trb->c7_produto:= sc7->c7_produto
		trb->c7_datprf := sc7->c7_datprf
		trb->c7_emissao:= sc7->c7_emissao
		trb->c7_fornece:= sc7->c7_fornece
		trb->c7_loja   := sc7->c7_loja
		trb->c7_obs    := sa2->a2_nreduz
		trb->c7_quant  := sc7->c7_quant-sc7->c7_quje
		if mv_par08=1
			trb->c7_total  := (sc7->c7_quant-sc7->c7_quje)*sc7->c7_preco
		endif
	Endif
	Select SC7
	Skip
Enddo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if mv_par05==1
	Cabec1 := "Pedidos Liberados"
else
	Cabec1 := "Todos os Pedidos"
endif
//Cabec2 := "Pedido  Entrega                                              Quant.       Valor"
Cabec2 := "Pedido  Entrega                                                                             Quant.       Valor"
//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Select TRB
Index on dtos(c7_datprf)+c7_produto to &cTrb1
dbGotop()

SetRegua(recCount())

nQtdT := nValT := 0

Do While !Eof()
	
	IncRegua()
	
	If li > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	nQtd := nVal := 0
	dDat := c7_datprf
	Do while !eof() .and. c7_datprf ==dDat
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		if mv_par06==1
			if mv_par07==2
				Select TRB
				cNum := trb->c7_num
				lInicio := .t.
				do while !eof() .and. trb->c7_num==cNum
					If li > 60
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
					Endif
					Select SB1
					seek xFilial()+TRB->c7_produto
					Select Trb
					@ li,000 PSAY TRB->c7_num
					@ li,008 PSAY TRB->c7_datprf
					@ li,020 PSAY left(TRB->c7_produto,12)+" - "+LEFT(sb1->b1_desc,20)
					//         @ li,026 PSAY iif(lInicio,TRB->c7_obs," ")
					@ li,055 PSAY "-"+left(TRB->c7_obs,30)
					@ li,088 PSAY TRB->c7_quant  picture "@E 999,999.99"
					if mv_par08=1
						@ li,106 PSAY TRB->c7_total  picture "@E 999,999.99"
					endif
					li := li +1
					nQtd := nQtd + c7_quant
					nVal := nVal + c7_total
					nQtdT:= nQtdT+ c7_quant
					nValT:= nValT+ c7_total
					skip
				Enddo
			Else
				nQt   := nVl := 0
				cCod  := trb->c7_produto
				cForn := left(trb->c7_obs,30)
				do while !eof() .and. trb->c7_produto==cCod .and. c7_datprf ==dDat
					nQt  := nQt  + c7_quant
					nVl  := nVl  + c7_total
					nQtd := nQtd + c7_quant
					nVal := nVal + c7_total
					nQtdT:= nQtdT+ c7_quant
					nValT:= nValT+ c7_total
					skip
				Enddo
				If li > 60
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				Endif
				Select SB1
				seek xFilial()+cCod
				Select Trb
				@ li,008 PSAY dDat
				@ li,020 PSAY left(cCod,12)+" - "+LEFT(sb1->b1_desc,30)+"-"+left(cForn,20)
				@ li,088 PSAY nQt  picture "@E 999,999.99"
				if mv_par08=1
					@ li,106 PSAY nVl  picture "@E 999,999.99"
				endif
				li := li +1
			Endif
		else
			nQtd := nQtd + c7_quant
			nVal := nVal + c7_total
			nQtdT:= nQtdT+ c7_quant
			nValT:= nValT+ c7_total
			skip
		endif
	Enddo
	@ li,000 PSAY "Total :"
	@ li,008 PSAY dDat
	@ li,088 PSAY nQtd picture "@E 999,999.99"
	if mv_par08=1
		@ li,106 PSAY nVal picture "@E 999,999.99"
	endif
	if mv_par06==1
		li := li + 2
	else
		li := li + 1
	endif
	
Enddo
@ li,000 PSAY "Total do relatorio:"
@ li,088 PSAY nQtdt picture "@E 999,999.99"
if mv_par08=1
	@ li,106 PSAY nValt picture "@E 999,999.99"
endif


if mv_par07==1
	
	Select TRB
	Index on c7_produto to &cTrb1
	dbGotop()
	
	SetRegua(recCount())
	
	titulo   := "Resumo de Pedidos por Produto"
	
	Li := 80
	nQtdT := nValT := 0
	nTot  := nTotv := 0
	Do While !Eof()
		
		IncRegua()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		
		Select SB1
		Seek xFilial()+trb->c7_produto
		Select TRB
		cCodProd := trb->c7_produto
		nQtde := nVal := 0
		do while !eof() .and. trb->c7_produto == cCodProd
			nQtde := nQtde + trb->c7_quant
			nVal  := nVal  + trb->c7_total
			Skip
		Enddo
		@ li,000 PSAY left(cCodProd,10)+"-"+left(sb1->b1_desc,40)
		@ li,055 PSAY nQtde picture "@E 9,999,999"
		@ li,065 PSAY nVal  picture "@E 99,999,999.99"
		nTot := nTot + nQtde
		nTotv:= nTotv+ nVal
		li:=li+1
	Enddo
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total de Pecas Vendidas "
	@ li,055 PSAY nTot  picture "@E 9,999,999"
	@ li,065 PSAY nTotv picture "@E 99,999,999.99"
	
Endif    // final da impressÆo do resumo por pe‡as
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
