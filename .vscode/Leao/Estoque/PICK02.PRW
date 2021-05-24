#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function PICK02()        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PICK02   ³ Autor ³ Luiz Eduardo Santos   ³ Data ³ 17/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Pedidos Pendentes.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PICK01                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake Especifico p/ Espelhos Leao                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cDesc1   := "Este programa ir  imprimir o Relatorio de Pedidos Pendentes."
cDesc2   := "IMPORTANTE - Cadastro dos rateios de cores na tabela C9 "
cDesc3   := "arquivo SX5"
aOrdem   := {"Por Componente","Por Entrega","Por Cliente","Por OP"}
Titulo   := "Necessidade de Compra para Pedidos Pendentes"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
cString  := "SC5"
nomeprog := "PICK01"
cPerg    := "PICK01"
wnRel    := "PICK01"
cbtxt    := Space(10)
Tamanho  := "M"
cbcont   := 0
limite   := 132
nLastKey := 0
li       := 80
m_pag    := 1
lEnd     := .F.

cData:=dtoc(getmv("MV_ULTCONS"))
if MsgBox ("Deseja calcular o consumo dos ultimos 3 meses ? ultimo calculo em "+cData,"Escolha","YESNO")
	Processa( {|| CalCons() } )
//	Select SX6
//	Seek xFilial()+"MV_ULTCONS"
	PUTMV("MV_ULTCONS",dtoc(dDataBase))
//	if rlock()
//		x6_conteud := dtoc(dDataBase)
//	endif
endif
cData1:=dtoc(getmv("MV_ULTCOMP"))
if MsgBox ("Deseja calcular o a ultima compra por produto ? ultimo calculo em "+cData1,"Escolha","YESNO")
	Processa( {|| CalComp() } )
	PUTMV("MV_ULTCOMP",dtoc(dDataBase))
//	Select SX6
//	Seek xFilial()+"MV_ULTCOMP"
//	if rlock()
//		x6_conteud := dtoc(dDataBase)
//	endif
endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas Selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas p/ Parametros :                         ³
//³                                                              ³
//³ mv_par01  // Emissao Pedidos de                              ³
//³ mv_par02  // Emissao Pedidos ate                             ³
//³ mv_par03  // Entrega de (Op/Pedido)                          ³
//³ mv_par04  // Entrega Ate (Op/Pedido)                         ³
//³ mv_par05  // Componente de                                   ³
//³ mv_par06  // Componente ate                                  ³
//³ mv_par07  // Todos / Liberados                               ³
//³ mv_par08  // Analitico / Sintetico / Sint.por Pedido         ³
//³ mv_par09  // Cliente de                                      ³
//³ mv_par10  // Cliente ate                                     ³
//³ mv_par11  // Vendedor de                                     ³
//³ mv_par12  // Vendedor ate                                    ³
//³ mv_par13  // Considera Estoque PA                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("PICK01", .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
do case
	case mv_par08 == 1
		wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,NIL,"G")
	case mv_par08 <> 1
		wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,NIL,Tamanho)
endcase

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
EndIf

nTipo := Iif(aReturn[4] == 1, 15, 18)

RptStatus( { | lEnd | Imp01() }, Titulo )// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { | lEnd | Execute(CZR040Imp) }, Titulo )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a ordem do arquivo.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
dbSetOrder(1)

Return Nil


****************************
Static Function Imp01()   // Impressao do Relatorio
****************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do Cabecalho.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := "Emissao de: " + dtoc(mv_par01) + " ate " + dtoc(mv_par02) + Space(05) + "Entrega de: " + dtoc(mv_par03) + " ate " + dtoc(mv_par04)
do case
	case mv_par08 == 1
		cabec2 := "Pedido  Emissao     Entrega          CLIENTE          Produto         Componente      Descricao                           Qtd.Necess.Qtd.Vendida Saldo Estq. Custo Un. Custo Tot. "
		//         123456789012345    123456    11/11/11    12345678901234567890   123456    100,00   99.999.999    123456789012345    999.999.999,99    123456789012345      14610    11/11/11    999.999.999,99
		//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
		Titulo := "Necessidade de Compra para Pedidos Pendentes (Analitico)"
		Tamanho:= "G"
		limite := 220
	case mv_par08 == 2
		//cabec2 := "Componente      Descricao Componente                           Quantidade   Consumo Mensal  Estq.Atual  Ped.Compras  Comprar"
		//cabec2 := "Componente          Descricao Componente                       Quantidade   Consumo Mensal        Estq.Atual  Ped.Compras    Comprar"
		cabec2 := "Componente  Descricao Componente            Quantidade Est.Segur. Qtde Total   Cons.Mensal  Estq.Atual  Ped.Compras    Comprar    "// Val.Std  Val.Ult.Prc"
		Titulo := "Necessidade de Compra para Pedidos Pendentes (Resumido)"
		Tamanho:= "M"
		limite := 132
	case mv_par08 == 3
		cabec2 := "Produto  Descricao                                          UM               Qtde"
		Titulo := "Necessidade de Compra para Pedidos Pendentes (Resumido)"
		Tamanho:= "P"
		limite := 080
Endcase
nTipo   := 15

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria e Abre o Arquivo de Trabalho.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "ITEM"    , "C",02,0})
AADD(aCampos,{ "CLIENTE" , "C",08,0})
AADD(aCampos,{ "NOME"    , "C",30,0})
AADD(aCampos,{ "FANTASIA", "C",30,0})
AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "ENTREGA" , "D",08,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "COMP"    , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "QUANT"   , "N",12,2})
AADD(aCampos,{ "QTDPED"  , "N",12,2})
AADD(aCampos,{ "LIB"     , "C",02,0})
AADD(aCampos,{ "UM"      , "C",02,0})
AADD(aCampos,{ "SEGUM"   , "C",02,0})
AADD(aCampos,{ "QTDSEG"  , "N",12,2})
AADD(aCampos,{ "CUST"    , "N",12,4})
AADD(aCampos,{ "SALDO"   , "N",12,2})
AADD(aCampos,{ "ESTSEG"  , "N",12,2})
AADD(aCampos,{ "PC"      , "N",12,2})
AADD(aCampos,{ "CONS_MES", "N",12,2})
AADD(aCampos,{ "ULTCOM"  , "D",08,0})
AADD(aCampos,{ "ULTQTD"  , "N",12,2})
AADD(aCampos,{ "ULTVAL"  , "N",12,2})
AADD(aCampos,{ "COMPRAR" , "N",12,2})
AADD(aCampos,{ "QTDTOT"  , "N",12,2})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

//aOrdem     := {"Por Componente","Por Entrega","Por Cliente"}
nOrdem := aReturn [8]
Do Case
	Case nOrdem == 1
		Index on Comp to &cTemp
	Case nOrdem == 2
		Index on Entrega to &cTemp
	Case nOrdem == 3
		Index on Cliente to &cTemp
	Case nOrdem == 4
		Index on Comp to &cTemp
Endcase

if nOrdem <> 4
	Monta()
Else
	MontaOp()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
//Gravar MP que não entraram no Pick-list
IF SELECT("TMPB1") # 0
	TMPB1->(DBCLOSEAREA( ))
ENDIF

cQuery := " SELECT B1_COD "
cQuery += " FROM SB1010 WHERE "
cQuery += " B1_TIPO = 'MP' AND B1_MSBLQL<>'1' AND B1_SITPROD<>'OB' AND "
cQuery += " SB1010.D_E_L_E_T_ <>'*'  "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPB1", .F., .T.)

dbSelectArea("TMPB1")
do while !eof()
	Select Trb
	seek tmpb1->b1_Cod
	if eof()
		nEstPA := 0
		cCod := ""
		cComp := tmpb1->B1_COD
		nDiv  := 1
		Select Trb
		GravaTrb(2,0)
	endif
	dbSelectArea("TMPB1")
	skip
Enddo
TMPB1->(dbCloseArea())

IF SELECT("TRBMP") # 0
	TRBMP->(DBCLOSEAREA( ))
ENDIF
dbSelectArea("TRB")
copy stru to \gerencia\Pick_mp
dbUseArea( .T.,,"\gerencia\Pick_mp.dtc","TRBMP", Nil, .F. )
dbSelectArea("TRB")

if mv_par08=3
	dbSelectArea("TRB1")
endif

SetRegua(RecCount())
dbGoTop()

nTotCusto := nTotCust1 := 0
nQuant := 0
While !Eof()
	
	IncRegua()
	
	if mv_par08<>3 .and. ( trb->Comp<mv_par05 .or. trb->Comp>mv_par06 )
		Skip
		Loop
	Endif
	
	do case
		case mv_par08 == 1   // Imprime relatorio analitico (somente resumo: nao)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do Cabecalho.                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If li > 60
				Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
			EndIf
			Select SA1
			Seek xFilial()+trb->Cliente
			Select SB1
			Seek xFilial()+trb->COMP
			Select TRB
			
			@ li, 00 PSAY NUM
			@ li, 08 PSAY EMISSAO
			@ li, 20 PSAY ENTREGA
			@ li, 32 PSAY Left(SA1->A1_NOME,20)
			@ li, 54 PSAY COD
			@ li, 70 PSAY COMP
			@ li, 86 PSAY DESC
			@ li,118 PSAY QUANT      Picture "@E 999,999.99"
			@ li,130 PSAY QTDPED     Picture "@E 999,999"
			@ li,142 PSAY SALDO      Picture "@E 999,999"
			//              nTotCusto := nTotCusto + nQuant*nCUST
			li := li + 1
			nQuant += Quant
			Skip
		case mv_par08 == 2   // Imprime sintético por MP
			//			Do case
			//				Case nOrdem == 1    // Por Componente
			Select SB1
			if left(trb->COMP,3)<>"12"
				Seek xFilial()+trb->COMP
			else
				Seek xFilial()+left(trb->COMP,6)
			endif
			
			dbSelectArea("TRB")
			//dbgotop()
			
			cGrp  := left(trb->comp,6)
			nQtd1 := nTot1 := nTot2 := 0
			Do while !eof() .and. left(trb->comp,6)==cGrp
				cComp := trb->Comp
				cDesc := trb->Desc
				nSal  := trb->Saldo
				nSeg  := trb->EstSeg
				nQtd  := nQtdSeg := 0
				cDesc := left(trb->Desc,29)+" "+trb->Um
				nPc   := trb->PC
				nCust := trb->Cust
				nUlt  := trb->UltVal
				nConsumo := trb->Cons_mes
				Do while !eof() .and. trb->Comp == cComp
					nQtd := nQtd + trb->Quant
					nQtd1:= nQtd1+ trb->Quant
					nQtdSeg += trb->QtdSeg
					Skip
				Enddo
				If li > 60
					Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
				EndIf
				@ li, 00 PSAY left(cCOMP,08)
				@ li, 10 PSAY cDESC
				@ li, 44 PSAY nQtd	  	 Picture "@E 99,999,999"
				@ li, 56 PSAY nSeg  	 Picture "@E 99,999,999"
				@ li, 68 PSAY nQtd+nSeg  Picture "@E 99,999,999"
				@ li, 80 PSAY nConsumo   Picture "@E 999,999.99"
				@ li, 92 PSAY nSal       Picture "@E 999,999.99"
				@ li,104 PSAY nPC        Picture "@E 999,999.99"
				@ li,118 PSAY nQtd-nSal-nPc Picture "@E 999,999"
				if (nQtd+nSeg-nSal-nPc)*nCust>=0
					nTotCusto := nTotCusto + (nQtd+nSeg-nSal-nPc)*nCust
					nTot1 := nTot1 + (nQtd+nSeg-nSal-nPc)*nCust
				endif
				if (nQtd+nSeg-nSal-nPc)*nUlt>=0
					nTotCust1 := nTotCust1 + (nQtd+nSeg-nSal-nPc)*nUlt
					nTot2 := nTot2 + (nQtd+nSeg-nSal-nPc)*nUlt
				endif
				li := li + 1
				Select TRBMP
				Reclock("TRBMP",.t.)
				TRBMP->COMP 		:= cComp
				TRBMP->DESC 		:= cDesc
				TRBMP->um 			:= sb1->B1_UM
				TRBMP->segum		:= sb1->b1_SEGUM
				TRBMP->QUANT 		:= nQtd
				TRBMP->QTDSEG 		:= nQtdSeg
				TRBMP->SALDO 		:= nSal
				TRBMP->ESTSEG 		:= nSeg
				TRBMP->PC 			:= nPC
				TRBMP->CONS_MES 	:= nConsumo
				TRBMP->QTDTOT	 	:= nQtd+nSeg
				TRBMP->COMPRAR 		:= nQtd-nSal-nPc
				MsunLock()
				Select TRB
				
			Enddo
			if substr(cComp,8,4)#space(4)
				@ li, 01 PSAY "Total do Grupo "+cGrp
				@ li, 44 PSAY nQtd1 Picture "@E 99,999,999"
				@ li,100 PSAY nTot1 Picture "@E 999,999.99"
				@ li,118 PSAY nTot2 Picture "@E 999,999.99"
				li := li + 1
				@ li, 01 PSAY replicate("-",132)
				li := li + 1
			endif
			// Informa produtos que com estoque e sem Pedidos de Vendas
	EndCase
	dbSelectArea("TRB")
			if mv_par08=3
				dbSelectArea("TRB1")
				Skip
			endif
End

if mv_par08=1
	copy to \gerencia\Pick_Analit
Endif

IF SELECT("TRBPA") # 0
	TRBPA->(DBCLOSEAREA( ))
ENDIF

dbSelectArea("TRB1")
copy stru to \gerencia\Pick_pa
dbUseArea( .T.,,"\gerencia\Pick_pa.dtc","TRBPA", Nil, .F. )
dbSelectArea("TRB1")
cTemp := CriaTrab(nil,.f.)
IndRegua("TRB1", cTemp, "C6_PRODUTO", , , "Selecionando Registros...")
dbgotop()
nQtd1 := nTotPC := nTotKG := nTotUm2 := 0
Do while !eof()
	if at(".",trb1->c6_produto)<>0
		cGrp  := left(trb1->c6_produto,at(".",trb1->c6_produto)-1)
	else
		cGrp := left(trb1->c6_produto,6)
	endif
	nQtd  := nQtd2 := 0
	Do while !eof()
		if at(".",trb1->c6_produto)<>0
			cGrp1 := left(trb1->c6_produto,at(".",trb1->c6_produto)-1)
		else
			cGrp1 := left(trb1->c6_produto,6)
		endif
		if val(cGrp1) <> val(cGrp)
			exit
		endif
		nQtd := nQtd +  TRB1->(c6_QTDVEN - C6_QTDENT)
		nQtd2:= nQtd2 + TRB1->QTD2
		Skip
	Enddo
	Select SB2
	dbSetOrder(1)
	Seek xFilial()+cGrp
	nQtdEst := 0
	Do while !eof() .and. left(b2_cod,len(cGrp))=cGrp
		nQtdEst += SB2->B2_QATU
		skip
	Enddo
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+cGrp
	Select Trb1
	if sb1->b1_um ='PC'
		nTotPC += nQtd
	else
		nTotKG += nQtd
	Endif
	nTotum2 += nQtd2
	If li > 60
		Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
	EndIf
	@ li, 00 PSAY cGrp
	@ li, 10 PSAY trim(sb1->b1_desc)
	@ li, 60 psay sb1->b1_um
	@ li, 70 PSAY nQtd	  	 Picture "@E 99,999,999"
	li := li + 1
	Select TRBPA
	Reclock("TRBPA",.t.)
	trbpa->C6_PRODUTO 	:= cGrp
	trbpa->C6_DESCRI 	:= trim(sb1->b1_desc)
	trbpa->c6_um 		:= sb1->B1_UM
	trbpa->b1_segum		:= sb1->b1_SEGUM
	trbpa->C6_QTDVEN 	:= nQtd
	trbpa->QTD2 		:= nQtd2
	trbpa->ESTQ 		:= nQtdEst
	if sb1->b1_conv<>0
		//			trbpa->qtd2			:= iif(sb1->b1_tipconv="M",nQtd*SB1->B1_conv,nQtd/SB1->B1_conv)
	endif
	MsunLock()
	Select TRB1
Enddo
li := li + 1
@ li, 01 PSAY "Total de peças a entregar : "+str(nTotPC,8)
li := li + 1
@ li, 01 PSAY "Total por kilo a entregar : "+str(nTotkg,8)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Total Geral para o relatorio analitico.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li != 80 .and. mv_par08<>3
	@ li, 00 PSAY Replicate("-",limite)
	li := li + 1
	If mv_par08 == 1
		@ li, 00  PSAY "TOTAIS"
		@ li, 118 PSAY nQuant  Picture "@E 999,999.99"
	else
		@ li, 00 PSAY "TOTAIS"
		@ li,100 PSAY nTotCusto  Picture "@E 999,999.99"
		@ li,112 PSAY nTotCust1  Picture "@E 999,999.99"
	Endif
	li := li + 1
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Rodape.                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li #80
	Roda(cbcont,cbtxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga o arquivo de trabalho.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea("TRB")
//Copy to \pick
//dbCloseArea()
//If File(cTemp+".DBF")
//	FErase(cTemp+".DBF")
//EndIf

dbSelectArea("SC5")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra o Spool.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Select Trb
cInd := CriaTrab(Nil, .F.)
IndRegua("TRB", cInd, "COMP", , , "Verificando MP...")


if MsgBox ("Deseja abrir planilha Excel ?","Escolha","YESNO")
	Relat001()
endif

Return(.T.)

****************************
Static Function Monta()  // Monta Temporario
****************************
Local cQuery := ""

cQuery := "SELECT C6_NUM,C6_ITEM,C5_EMISSAO,C6_PRODUTO,C6_DESCRI,C6_TES,C6_ENTREG,C5_CLIENTE,C5_LOJACLI, "
cQuery += "C6_QTDVEN,C6_QTDENT,C6_UNSVEN AS QTD2,C6_UM,B1_SEGUM,B1_CONV AS ESTQ "
cQuery += "FROM SC6010 "
cQuery += " INNER JOIN SC5010 ON C6_NUM=C5_NUM "
cQuery += " INNER JOIN SB1010 ON C6_PRODUTO=B1_COD "
cQuery += " INNER JOIN SF4010 ON C6_TES=F4_CODIGO "
cQuery += " AND SB1010.D_E_L_E_T_ <>'*'
cQuery += " WHERE "
cQuery += "F4_DUPLIC='S' AND "
cQuery += "C5_EMISSAO>='"+dtos(MV_PAR01)+"' AND "
cQuery += "C5_EMISSAO<='"+dtos(MV_PAR02)+"' AND "
cQuery += "C6_ENTREG>='"+dtos(MV_PAR03)+"' AND "
cQuery += "C6_ENTREG<='"+dtos(MV_PAR04)+"' AND "
cQuery += "C5_CLIENTE >= '"+  mv_par09 +"' AND "
cQuery += "C5_CLIENTE <= '"+  mv_par10 +"' AND "
cQuery += "C6_NUM     >= '"+  mv_par11 +"' AND "
cQuery += "C6_NUM     <= '"+  mv_par12 +"' AND "
cQuery += "C6_QTDENT < C6_QTDVEN AND "
cQuery += "SUBSTRING(C6_BLQ,1,1)<>'R' AND "
cQuery += "SC5010.D_E_L_E_T_ <>'*' AND SC6010.D_E_L_E_T_ <>'*' AND SF4010.D_E_L_E_T_ <>'*' "
cQuery += "Order by C6_PRODUTO "

cQuery := ChangeQuery(cQuery)
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB1", .F., .T.)
//	copy to \gerencia\Pick_pa1
dbgotop()
if mv_par08=3
	Return
endif


SetRegua( RECCOUNT() )

While !Eof()
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acumular os valores dos pedidos.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")
	dbSeek( xFilial("SA1")+TRB1->(C5_CLIENTE+C5_LOJACLI) )
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o F4_DUPLIC = "N".                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SB1")
	dbsetorder(1)
	dbSeek( xFilial("SB1")+trb1->(C6_PRODUTO))
	
	dbSelectArea("SC9")
	dbsetorder(1)
	dbSeek( xFilial("SC9")+trb1->(C6_NUM+C6_ITEM))
	dbSelectArea("trb1")
	cCod := left(TRB1->c6_produto,at(".",TRB1->c6_produto)-1)
	if left(TRB1->c6_produto,4)='3002'// left(cCod,4)$"2001*2005*2013"
		x:=1
	endif
	if sb1->b1_grupo='15'
		cCod := left(c6_produto,6)
	endif
	if left(cCod,1)=="0"
		Select SB1
		Seek xFilial()+trb1->c6_produto
		if left(sb1->b1_codbar,1)=='2'
			cCod := left(sb1->b1_codbar,7)
		else
			cCod := "1"+substr(cCod,2,3)
		endif
	endif
	nQtdEst := 0
	nQtdVen := C6_QTDVEN - C6_QTDENT
	nQtdSegum := QTD2
	if mv_par13==1 .and. mv_par08=2 // Verifica Saldo de Pa para abater do pick-list
		
		Select SB1
		cCod2 := trb1->c6_produto
		cPos := at(".",b1_cod)
		Seek xFilial()+cCod2
		IF SB1->B1_CODITE='1'
			cPos := at(".",b1_cod)
			if (substr(b1_cod,cPos+1,1)=="1" .or. substr(b1_cod,cPos+1,1)=="2") .and. substr(b1_cod,cPos,1)=='.' .and. left(b1_cod,1)='1'
				cCod2:= left(b1_cod,cPos-1)+".0"+substr(b1_cod,cPos+2,14)
			endif
		Endif
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		Seek xFilial()+cCod2+"CB"
		if B2_QATU<>0
			nQtdEst := SB2->B2_QATU
		Endif
		
		Select Trb1
		nQtdVen 	:= 0
		nQtdSegum 	:= 0
		if left(sb1->b1_cod,1)='1'
			Do while !eof() .and. left(cCod2,at(".",cCod2)) = left(trb1->c6_produto,at(".",trb1->c6_produto))
				nQtdVen   += C6_QTDVEN - C6_QTDENT
				nQtdSegum += qtd2
				skip
			Enddo
		else
			Do while !eof() .and. TRIM(cCod2) = TRIM(trb1->c6_produto)
				nQtdVen   += C6_QTDVEN - C6_QTDENT
				nQtdSegum += qtd2
				skip
			Enddo
		endif
		nQtdVen := nQtdVen - nQtdEst
		if nQtdVen<0
			dbSelectArea("trb1")
			skip
			loop
		endif
	Endif
	
	Select SG1
	dbSetOrder(1)
	Seek xFilial()+cCod
	Do while !eof() .and. trim(sg1->g1_cod)==cCod
		cComp := SG1->G1_COMP
		Select SB1
		Seek xFilial()+cComp
		lMudar := .f.
		if left(cComp,3)=='12.' .or. left(cComp,3)=='32.'
			skip
			//				cComp := Trim(cComp)+"."+substr(TRB1->c6_produto,at(".",TRB1->c6_produto)+1,4)
			if  trim(cComp)<>left(sb1->b1_cod,len(trim(cComp)))
				cComp := Trim(cComp)
				skip-1
			else
				cComp := left(SB1->B1_COD,9)
				lMudar := .t.
			endif
		endif
		dbSelectArea("TRB")
		nDiv := 1
		/*			if left(cComp,3)='12.' .and. "V"$cComp .and. lMudar
		Select SX5
		nPosicao := at("V",trb1->c6_produto)
		seek xFilial()+"C9V"+substr(trb1->c6_produto,nPosicao+1,1)
		if !eof()
		aCores := {}
		n:=1
		Do while .t.
		cCor := substr(X5_Descri,n,2)
		nQtd := val(substr(X5_Descri,n+2,2))
		if cCor==space(2)
		exit
		endif
		aAdd(aCores,{cCor,nQtd})
		n:=n+5
		Enddo
		For x:=1 to len(aCores)
		nDiv := 1/(aCores[x][2]/100)
		if left(cComp,6)#"12.091"
		//							cComp := left(cComp,6)+"."+substr(sc6->c6_produto,at(".",sc6->c6_produto)+1,2)+aCores[x][1]+space(4)
		endif
		GravaTrb(1,nQtdVen)
		Next x
		else
		nDiv := 1
		GravaTrb(1,nQtdVen)
		endif
		else
		nDiv := 1
		GravaTrb(1,nQtdVen)
		endif
		*/
		GravaTrb(1,nQtdVen)
		Select SG1
		Skip
	Enddo
	
	dbSelectArea("trb1")
	dbSkip()
End

if mv_par13==1 .and. mv_par08<>3 .and. 1=2  // Desativado em 15/06/2020
	// Verifica Saldo de Pa para abater do pick-list
	// Titulo   := "Verifica Saldo de PA"
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbGoTop()
	SetRegua(reccount())
	While !eof()
		IncRegua()
		if b2_qatu==0
			skip
			loop
		endif
		Select SB1
		Seek xFilial()+sb2->b2_cod
		if sb1->b1_tipo#"PA"
			Select SB2
			skip
			loop
		endif
		cCod := left(sb2->b2_cod,at(".",sb2->b2_cod)-1)
		if left(cCod,1)=="0"
			if left(sb1->b1_codbar,1)=='2'
				cCod := left(sb1->b1_codbar,7)
			else
				cCod := "1"+substr(cCod,2,3)
			endif
		endif
		nEstPA := -sb2->b2_qatu
		
		Select SG1
		dbSetOrder(1)
		Seek xFilial()+cCod
		Do while !eof() .and. trim(sg1->g1_cod)==left(cCod,4)
			cComp := SG1->G1_COMP
			if left(cComp,6)#"12.091"
				if left(cComp,3)=='12.' .or. left(cComp,3)=='32.'
					//					cComp := Trim(cComp)+"."+substr(sb2->b2_cod,at(".",sb2->b2_cod)+1,4)
				endif
			Endif
			Select SB1
			Seek xFilial()+cComp
			dbSelectArea("TRB")
			if left(cComp,2)='12' .and. substr(sb2->b2_cod,8,1)=="V"
				Select SX5
				seek xFilial()+"C9V"+substr(sb2->b2_cod,9,1)
				if !eof()
					aCores := {}
					n:=1
					Do while .t.
						cCor := substr(X5_Descri,n,2)
						nQtd := val(substr(X5_Descri,n+2,2))
						if cCor==space(2)
							exit
						endif
						aAdd(aCores,{cCor,nQtd})
						n:=n+5
					Enddo
					For x:=1 to len(aCores)
						nDiv := 1/(aCores[x][2]/100)
						if left(cComp,6)#"12.091"
							//							cComp := left(cComp,6)+"."+substr(sb2->b2_cod,at(".",sb2->b2_cod)+1,2)+aCores[x][1]+space(4)
						endif
						GravaTrb(2)
					Next x
				else
					nDiv := 1
					GravaTrb(2)
				endif
			else
				nDiv := 1
				GravaTrb(2)
			endif
			Select SG1
			Skip
		Enddo
		Select SB2
		*	goto nRecB2
		Skip
	Enddo
endif   // Considera Estoque PA

Select TRB
// Titulo   := "Verifica Pedidos de Compra"
dbGoTop()
SetRegua(reccount())
While !eof() .and. mv_par08<>3
	IncRegua()
	cCod :=  TRB->COMP
	if ccod='1.089'
		x:=1
	endif
	Select SB2
	dbSetOrder(1)
	Seek xFilial()+cCod+sb1->b1_locpad
	if eof()
		Seek xFilial()+cCod+space(15-len(trim(cCod)))+sb1->b1_locpad
	endif
	
	nQtdPc := 0
	cQuery := " SELECT SUM(c7_QUANT-C7_QUJE) AS QTDE "
	cQuery += " FROM SC7010 WHERE "
	cQuery += " C7_PRODUTO = '"+CCOD+"' AND C7_RESIDUO<>'S' AND (C7_QUANT-C7_QUJE) > 0 AND "
	cQuery += " SC7010.D_E_L_E_T_ <>'*'  "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
	cTempD2b := CriaTrab(nil,.f.)
	nQtdPC := tmp1->QTDE
	use
	
	
	//	Select SC7
	//	dbSetOrder(2)
	//	Seek xFilial()+cCod
	//	nQtdPc := 0
	//	Do while !eof() .and. sc7->c7_produto==cCod
	//		if sc7->c7_residuo#"S" .and. (sc7->c7_quant-sc7->c7_quje) > 0
	//			nQtdPc := nQtdPc + sc7->c7_quant-sc7->c7_quje
	//		endif
	//		skip
	//	Enddo
	Select SB1
	DbSetOrder(1)
	Seek xFilial()+cCod
	Select SB3
	DbSetOrder(1)
	Seek xFilial()+cCod
	Select TRB
	reclock("TRB",.f.)
	trb->cons_mes := sb3->b3_total/3
	trb->pc       := nQtdPC
	trb->saldo    := Sb2->b2_qatu
	trb->estseg   := Sb1->b1_EMIN
	MsUnLock()
	Skip
Enddo
dbSelectArea("SC5")
dbSetOrder(1)  // C5_FILIAL+C5_NUM

Return

*****************************
Static Function GravaTrb(cTp,nQtdVen) // Grava arquivo de trabalho
*****************************
Select SB1
if left(cComp,3)<>'12.'
	Seek xFilial()+trim(cComp)
else
	Seek xFilial()+left(cComp,6)
endif
Select TRB
RecLock("TRB",.T.)
if cTp==1
	TRB->NUM        := trb1->C6_NUM
	TRB->ITEM       := trb1->C6_ITEM
	TRB->LIB        := sc9->c9_blcred
	TRB->CLIENTE    := trb1->(C5_CLIENTE+C5_LOJACLI)
	TRB->NOME       := SA1->A1_NOME
	TRB->FANTASIA   := SA1->A1_NREDUZ
	TRB->EMISSAO    := stod(trb1->C5_EMISSAO)
	TRB->ENTREGA    := stod(trb1->C6_ENTREG)
	TRB->QTDPED     := nQtdVen //trb1->(C6_QTDVEN-C6_QTDENT)
	TRB->QTDSEG     := nQtdSegUm
	TRB->COD        := cCod
	TRB->COMP       := cComp
	TRB->DESC       := Sb1->b1_desc
	TRB->QUANT      := (SG1->G1_QUANT*(nQtdVen)*(1+(sg1->g1_perda/100)))/nDiv
	TRB->UM         := Sb1->b1_um
	TRB->cust       := Sb1->b1_CUSTD
Else
	TRB->NUM        := "ESTOQ"
	TRB->QTDPED     := nEstPA
	TRB->COD        := cCod
	TRB->COMP       := cComp
	TRB->DESC       := Sb1->b1_desc
	TRB->QUANT      := (SG1->G1_QUANT*nEstPA*(1+(sg1->g1_perda/100)))/nDiv
	TRB->UM         := Sb1->b1_um
	TRB->cust       := Sb1->b1_CUSTD
Endif
TRB->ultcom     := Sb1->b1_ucom
TRB->ultqtd     := Sb1->b1_ultqtd
TRB->ultval     := sb1->b1_uprc

MsUnLock()
Return

*************************
Static Function Calcons()
*************************

dFim := firstday(dDatabase)-1
dIni := firstday(dFim-100)
Select SD3
DbSetOrder(6)
Set softseek on
//Seek xFilial()+dtos(dDatabase-90)
Seek xFilial()+dtos(dIni)
Set softseek off
nQtd := 0
ProcRegua(60000)
Do while !eof() .and. d3_emissao<=dFim
	IncProc()
	if sd3->d3_tm#"999"
		skip
		loop
	endif
	Select SB3
	dbSetOrder(1)
	Seek xFilial()+sd3->d3_cod
	if eof()
		reclock("SB3",.t.)
		sb3->b3_filial:= xFilial()
		sb3->b3_cod   := sd3->d3_cod
	else
		reclock("SB3",.f.)
	Endif
	if sb3->b3_mes # dDataBase
		sb3->b3_total := 0
		sb3->b3_mes   := dDataBase
	endif
	if sd3->d3_tm=='999'
		RecLock("SB3",.f.)
		sb3->b3_total := sb3->b3_total + sd3->d3_quant
		MsUnLock()
	endif
	msunlock()
	Select SD3
	skip
Enddo

*************************
Static Function Calcomp()
*************************

Select SB1
DbSetOrder(1)
nQtd := 0
ProcRegua(reccount())
Do while !eof()
	IncProc()
	if sb1->b1_tipo='PA'
		skip
		loop
	endif
	Select SD1
	dbSetOrder(2)
	Seek xFilial()+TRIM(sb1->b1_cod)
	dData := ctod("0")
	nQtdCom := nValCom := nValUnit := nUltCust := 0
	Do while !eof() .and. left(sd1->d1_cod,len(trim(sb1->b1_cod)))=trim(sb1->b1_cod)
		if sd1->d1_dtdigit>ddata .and. sd1->d1_quant#0
			dData   := sd1->d1_dtdigit
			nQtdCom1:= nValCom1:= nValUnit1:= 0
			Do while !eof() .and. sd1->d1_dtdigit==ddata
				Select SF1
				Seek xFilial()+sd1->(d1_doc)
				nDespesa := 0
				if sf1->f1_despesa#0 .or. sf1->f1_frete#0
					nDespesa := (sd1->d1_total/sf1->f1_valmerc)*(sf1->f1_frete+sf1->f1_despesa)
				endif
				nQtdCom1 := sd1->d1_quant + nQtdCom1
				nValCom1 := sd1->d1_total + nValCom1+ nDespesa
				if sd1->d1_quant#0
					nUltcust := sd1->d1_custo/sd1->d1_quant
				endif
				Select SD1
				skip
			Enddo
			nQtdCom := nQtdCom1
			nValCom := nValCom1
			nValUnit:= nUltCust
		else
			skip
		endif
	Enddo
	Select SB2
	seek xFilial()+sb1->b1_cod+"02"
	if !eof()
		RecLock("SB2",.F.)
		sb2->b2_cmff5 := nUltCust
		MsUnLock()
	endif
	Select SB1
	RecLock("SB1",.F.)
	sb1->b1_ucom    := dData
	sb1->b1_uprc    := nValUnit
	sb1->b1_ultqtd  := nQtdCom
	sb1->b1_ultunit := nValCom
	MsunLock()
	skip
Enddo


// Geração do Arquivo em Excel

Static Function RELAT001()

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

oReport := TReport():New(cNome,"Pick List",cNome,{|oReport| ReportPrint(oReport)},"Pick List")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Pick List (por MP)", {"TRB"}, , .F., .T.)


//	TRCell():New(oSection1,"NUM"		,"TRB","Doc."  ,"@!",10)
//	TRCell():New(oSection1,"ITEM"		,"TRB","Item"  ,"@!",04)
//	TRCell():New(oSection1,"CLIENTE"	,"TRB","Cod.Cli."  ,"@!",08)
//	TRCell():New(oSection1,"NOME"		,"TRB","Nome Cli"  ,"@!",40)
//	TRCell():New(oSection1,"FANTASIA"	,"TRB","Nome Fantasia"  ,"@!",20)
//	TRCell():New(oSection1,"EMISSAO"	,"TRB", "Dt.Emissao","@!",10)
//	TRCell():New(oSection1,"ENTREGA"	,"TRB", "Dt.Entrega","@!",10)
//	TRCell():New(oSection1,"COD"		,"TRB","Cód.prod."  ,"@!",15)
TRCell():New(oSection1,"COMP"		,"TRB","Cód.Componente."  ,"@!",15)
TRCell():New(oSection1,"DESC"		,"TRB","Descrição"  ,"@!",50)
TRCell():New(oSection1,"QUANT"		,"TRB","Quantidade","@E 999,999,999.99",15)
TRCell():New(oSection1,"QTDPED"		,"TRB","Qtde.Pedido","@E 9,999,999.9999",15)
TRCell():New(oSection1,"LIB"		,"TRB","Liberado"  ,"@!",02)
TRCell():New(oSection1,"UM"			,"TRB","UM"  ,"@!",02)
TRCell():New(oSection1,"CUST"		,"TRB","CUSTO","@E 999,999,999.99",15)
TRCell():New(oSection1,"SALDO"		,"TRB","Saldo","@E 999,999,999.99",15)
TRCell():New(oSection1,"ESTSEG"		,"TRB","Estoque Seg","@E 999,999,999.99",15)
TRCell():New(oSection1,"PC"			,"TRB","Ped.Compras","@E 999,999,999.99",15)
TRCell():New(oSection1,"CONS_MES"	,"TRB","Consumo Mensal","@E 999,999,999.99",15)
TRCell():New(oSection1,"ULTCOM"		,"TRB","Data Ult.compra","@!",10)
TRCell():New(oSection1,"ULTQTD"		,"TRB","Ultima Qtd Comprada","@E 999,999,999.99",15)
TRCell():New(oSection1,"ULTVAL"		,"TRB","Ultimo Valor","@E 999,999,999.99",15)


// Section 2
IF SELECT("TRBPA") # 0
	TRBPA->(DBCLOSEAREA( ))
ENDIF

dbUseArea( .T.,,"\gerencia\Pick_pa.dtc","TRBPA", Nil, .F. )
oSection2:= TRSection():New(oReport, "Pick List (por PA) ", {"TRBPA"}, , .F., .T.)

TRCell():New(oSection2,"C6_PRODUTO"		,"TRBPA", "Cód.prod."  ,"@!",15)
TRCell():New(oSection2,"C6_DESCRI"		,"TRBPA", "Descrição"  ,"@!",50)
TRCell():New(oSection2,"C6_UM"			,"TRBPA", "UM","@!",15)
TRCell():New(oSection2,"B1_SEGUM"		,"TRBPA", "Seg.Um.","@!",15)
TRCell():New(oSection2,"C6_QTDVEN"		,"TRBPA", "Qtd.Vendida","@E 999,999,999.99",15)
TRCell():New(oSection2,"QTD2"			,"TRBPA", "Qtd.Seg.UM","@E 999,999,999.99",15)
TRCell():New(oSection2,"ESTQ"			,"TRBPA", "Qtd.Estq","@E 999,999,999.99",15)

Use

if mv_par08=1
// Section 3
IF SELECT("TRBAN") # 0
	TRBAN->(DBCLOSEAREA( ))
ENDIF

dbUseArea( .T.,,"\gerencia\Pick_Analit.dtc","TRBAN", Nil, .F. )
oSection3:= TRSection():New(oReport, "Pick List (Analítico) ", {"TRBAN"}, , .F., .T.)

TRCell():New(oSection3,"NUM"		,"TRBAN","Número"  ,"@!",08)
TRCell():New(oSection3,"ITEM"		,"TRBAN","Item"  ,"@!",04)
TRCell():New(oSection3,"EMISSAO"	,"TRBAN","Emissao"  ,"@!",12)
TRCell():New(oSection3,"COD"		,"TRBAN","Cod.PA"  ,"@!",15)
TRCell():New(oSection3,"COMP"		,"TRBAN","Componente"  ,"@!",15)
TRCell():New(oSection3,"DESC"		,"TRBAN","Descrição"  ,"@!",50)
TRCell():New(oSection3,"QUANT"		,"TRBAN","Quantidade","@E 999,999,999.99",15)
TRCell():New(oSection3,"QTDPED"		,"TRBAN","Qtde.Pedido","@E 9,999,999.9999",15)
TRCell():New(oSection3,"LIB"		,"TRBAN","Liberado"  ,"@!",02)
TRCell():New(oSection3,"UM"			,"TRBAN","UM"  ,"@!",02)
TRCell():New(oSection3,"CUST"		,"TRBAN","CUSTO","@E 999,999,999.99",15)
TRCell():New(oSection3,"SALDO"		,"TRBAN","Saldo","@E 999,999,999.99",15)
TRCell():New(oSection3,"ESTSEG"		,"TRBAN","Estoque Seg","@E 999,999,999.99",15)
TRCell():New(oSection3,"PC"			,"TRBAN","Ped.Compras","@E 999,999,999.99",15)
TRCell():New(oSection3,"CONS_MES"	,"TRBAN","Consumo Mensal","@E 999,999,999.99",15)
TRCell():New(oSection3,"ULTCOM"		,"TRBAN","Data Ult.compra","@!",10)
TRCell():New(oSection3,"ULTQTD"		,"TRBAN","Ultima Qtd Comprada","@E 999,999,999.99",15)
TRCell():New(oSection3,"ULTVAL"		,"TRBAN","Ultimo Valor","@E 999,999,999.99",15)

Endif
TRFunction():New(oSection2:Cell("C6_PRODUTO"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por seção
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)

Local cQuery    := ""
Local cPedido   := ""
Local lPrim 	:= .T.

IF SELECT("TRBMP") # 0
	TRBMP->(DBCLOSEAREA( ))
ENDIF

dbUseArea( .T.,,"\gerencia\Pick_MP.dtc","TRBMP", Nil, .F. )

dbSelectArea("TRBMP")
TRBMP->(dbGoTop())

oReport:SetMeter(TRBMP->(LastRec()))

While !Eof() // total Geral
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection1:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRBMP")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a primeira seção
		//		oSection1:Cell("DULTVEN"):SetValue(dtoc(SC5->C5_EMISSAO))
		//			oSection1:Cell("NUM"):SetValue(TRBMP->NUM)
		//			oSection1:Cell("ITEM"):SetValue(TRBMP->ITEM)
		//			oSection1:Cell("CLIENTE"):SetValue(TRBMP->CLIENTE)
		//			oSection1:Cell("NOME"):SetValue(TRBMP->NOME)
		//			oSection1:Cell("FANTASIA"):SetValue(TRBMP->FANTASIA)
		//			oSection1:Cell("EMISSAO"):SetValue(TRBMP->EMISSAO)
		//			oSection1:Cell("ENTREGA"):SetValue(TRBMP->ENTREGA)
		//			oSection1:Cell("COD"):SetValue(TRBMP->COD)
		oSection1:Cell("COMP"):SetValue(TRBMP->COMP)
		oSection1:Cell("DESC"):SetValue(TRBMP->DESC)
		oSection1:Cell("QUANT"):SetValue(TRBMP->QUANT)
		oSection1:Cell("QTDPED"):SetValue(TRBMP->QTDPED)
		oSection1:Cell("LIB"):SetValue(TRBMP->LIB)
		oSection1:Cell("UM"):SetValue(TRBMP->UM)
		oSection1:Cell("CUST"):SetValue(TRBMP->CUST)
		oSection1:Cell("SALDO"):SetValue(TRBMP->SALDO)
		oSection1:Cell("ESTSEG"):SetValue(TRBMP->ESTSEG)
		oSection1:Cell("PC"):SetValue(TRBMP->PC)
		oSection1:Cell("CONS_MES"):SetValue(TRBMP->CONS_MES)
		oSection1:Cell("ULTCOM"):SetValue(TRBMP->ULTCOM)
		oSection1:Cell("ULTQTD"):SetValue(TRBMP->ULTQTD)
		oSection1:Cell("ULTVAL"):SetValue(TRBMP->ULTVAL)
		
		oSection1:Printline()
		TRBMP->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo
//oSection1:Finish()

//SEÇÃO 2 - Por Produto
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\gerencia\Pick_PA.dtc","TRB1", Nil, .F. )

dbSelectArea("Trb1")

oReport:SetMeter(Trb1->(LastRec()))
Trb1->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection2:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("Trb1")
	
	IncProc("Imprimindo Necessidade PA")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a segunda seção - resumo por produto
		
		oSection2:Cell("C6_PRODUTO"):SetValue(Trb1->C6_PRODUTO)
		oSection2:Cell("C6_DESCRI"):SetValue(Trb1->C6_DESCRI)
		oSection2:Cell("C6_UM"):SetValue(Trb1->C6_UM)
		oSection2:Cell("B1_SEGUM"):SetValue(Trb1->B1_SEGUM)
		oSection2:Cell("C6_QTDVEN"):SetValue(TRB1->C6_QTDVEN)
		oSection2:Cell("QTD2"):SetValue(TRB1->QTD2)
		oSection2:Cell("ESTQ"):SetValue(TRB1->ESTQ)
		
		
		oSection2:Printline()
		Trb1->(dbSkip())
	Enddo
	
	//finalizo a segunda seção
Enddo
Use

if mv_par08=1 // Apenas irá gerar caso a solicitação seja de relatório analítico
//SEÇÃO 3 - Analítico
IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

dbUseArea( .T.,,"\gerencia\Pick_Analit.dtc","TRB1", Nil, .F. )

dbSelectArea("Trb1")

oReport:SetMeter(Trb1->(LastRec()))
Trb1->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection3:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("Trb1")
	
	IncProc("Imprimindo Analítico")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a segunda seção - resumo por produto
		oSection3:Cell("NUM"):SetValue(TRB1->NUM)
		oSection3:Cell("ITEM"):SetValue(TRB1->ITEM)
		oSection3:Cell("EMISSAO"):SetValue(TRB1->EMISSAO)
		oSection3:Cell("COD"):SetValue(TRB1->COD)
		oSection3:Cell("COMP"):SetValue(TRB1->COMP)
		oSection3:Cell("DESC"):SetValue(TRB1->DESC)
		oSection3:Cell("QUANT"):SetValue(TRB1->QUANT)
		oSection3:Cell("QTDPED"):SetValue(TRB1->QTDPED)
		oSection3:Cell("LIB"):SetValue(TRB1->LIB)
		oSection3:Cell("UM"):SetValue(TRB1->UM)
		oSection3:Cell("CUST"):SetValue(TRB1->CUST)
		oSection3:Cell("SALDO"):SetValue(TRB1->SALDO)
		oSection3:Cell("ESTSEG"):SetValue(TRB1->ESTSEG)
		oSection3:Cell("PC"):SetValue(TRB1->PC)
		oSection3:Cell("CONS_MES"):SetValue(TRB1->CONS_MES)
		oSection3:Cell("ULTCOM"):SetValue(TRB1->ULTCOM)
		oSection3:Cell("ULTQTD"):SetValue(TRB1->ULTQTD)
		oSection3:Cell("ULTVAL"):SetValue(TRB1->ULTVAL)
		
		oSection3:Printline()
		Trb1->(dbSkip())
	Enddo
	
	//finalizo a segunda seção
Enddo
oSection3:Finish()
use
endif


oSection2:Finish()
oSection1:Finish()

IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
IF SELECT("TRBMP") # 0
	TRBMP->(DBCLOSEAREA( ))
ENDIF

Return

****************************
Static Function MontaOp()  // Monta Temporario
****************************
Local cQuery := ""

cQuery := "SELECT C2_NUM AS C6_NUM,C2_ITEM AS C6_ITEM,C2_EMISSAO AS C5_EMISSAO,C2_PRODUTO AS C6_PRODUTO,"
cQuery += "'OP' AS C6_DESCRI,' ' AS C6_TES,C2_DATPRF AS C6_ENTREG,' ' AS C5_CLIENTE,' ' AS C5_LOJACLI, "
cQuery += "C2_QUANT-C2_QUJE AS C6_QTDVEN,0 AS C6_QTDENT,0 AS QTD2,C2_UM AS C6_UM,B1_SEGUM,B1_CONV AS ESTQ "
cQuery += "FROM SC2010 "
cQuery += " INNER JOIN SB1010 ON C2_PRODUTO=B1_COD "
cQuery += " AND SB1010.D_E_L_E_T_ <>'*'
cQuery += " WHERE "
cQuery += " C2_QUANT-C2_QUJE > 0 AND "
cQuery += "C2_EMISSAO>='"+dtos(MV_PAR01)+"' AND "
cQuery += "C2_EMISSAO<='"+dtos(MV_PAR02)+"' AND "
cQuery += "C2_DATPRF>='"+dtos(MV_PAR03)+"' AND "
cQuery += "C2_DATPRF<='"+dtos(MV_PAR04)+"' AND "
cQuery += "SC2010.D_E_L_E_T_ <>'*'  "
cQuery += "Order by C2_PRODUTO "

cQuery := ChangeQuery(cQuery)
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB1", .F., .T.)
dbgotop()

SetRegua( RECCOUNT() )

While !Eof()
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Acumular os valores dos pedidos.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")
	dbSeek( xFilial("SA1")+TRB1->(C5_CLIENTE+C5_LOJACLI) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o F4_DUPLIC = "N".                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SB1")
	dbsetorder(1)
	dbSeek( xFilial("SB1")+trb1->(C6_PRODUTO))
	
	dbSelectArea("trb1")
	cCod := left(TRB1->c6_produto,at(".",TRB1->c6_produto)-1)
	if sb1->b1_grupo='15'
		cCod := left(c6_produto,6)
	endif
	if left(cCod,1)=="0"
		Select SB1
		Seek xFilial()+trb1->c6_produto
		if left(sb1->b1_codbar,1)=='2'
			cCod := left(sb1->b1_codbar,7)
		else
			cCod := "1"+substr(cCod,2,3)
		endif
	endif
	nQtdEst := 0
	nQtdVen := C6_QTDVEN - C6_QTDENT
	nQtdSegum := QTD2
	if mv_par13==1 .and. mv_par08=2 // Verifica Saldo de Pa para abater do pick-list
		
		Select SB1
		cCod2 := trb1->c6_produto
		cPos := at(".",b1_cod)
		Seek xFilial()+cCod2
		IF SB1->B1_CODITE='1'
			cPos := at(".",b1_cod)
			if (substr(b1_cod,cPos+1,1)=="1" .or. substr(b1_cod,cPos+1,1)=="2") .and. substr(b1_cod,cPos,1)=='.' .and. left(b1_cod,1)='1'
				cCod2:= left(b1_cod,cPos-1)+".0"+substr(b1_cod,cPos+2,14)
			endif
		Endif
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		Seek xFilial()+cCod2+"CB"
		if B2_QATU<>0
			nQtdEst := SB2->B2_QATU
		Endif
		
		Select Trb1
		nQtdVen 	:= 0
		nQtdSegum 	:= 0
		if left(sb1->b1_cod,1)='1'
			Do while !eof() .and. left(cCod2,at(".",cCod2)) = left(trb1->c6_produto,at(".",trb1->c6_produto))
				nQtdVen   += C6_QTDVEN - C6_QTDENT
				nQtdSegum += qtd2
				skip
			Enddo
		else
			Do while !eof() .and. TRIM(cCod2) = TRIM(trb1->c6_produto)
				nQtdVen   += C6_QTDVEN - C6_QTDENT
				nQtdSegum += qtd2
				skip
			Enddo
		endif
		nQtdVen := nQtdVen - nQtdEst
		if nQtdVen<0
			dbSelectArea("trb1")
			skip
			loop
		endif
	Endif
	
	Select SG1
	dbSetOrder(1)
	Seek xFilial()+cCod
	Do while !eof() .and. trim(sg1->g1_cod)==cCod
		cComp := SG1->G1_COMP
		Select SB1
		Seek xFilial()+cComp
		lMudar := .f.
		if left(cComp,3)=='12.' .or. left(cComp,3)=='32.'
			skip
			//				cComp := Trim(cComp)+"."+substr(TRB1->c6_produto,at(".",TRB1->c6_produto)+1,4)
			if  trim(cComp)<>left(sb1->b1_cod,len(trim(cComp)))
				cComp := Trim(cComp)
				skip-1
			else
				cComp := left(SB1->B1_COD,9)
				lMudar := .t.
			endif
		endif
		dbSelectArea("TRB")
		nDiv := 1
		GravaTrb(1,nQtdVen)
		Select SG1
		Skip
	Enddo
	
	dbSelectArea("trb1")
	dbSkip()
End


Select TRB
// Titulo   := "Verifica Pedidos de Compra"
dbGoTop()
SetRegua(reccount())
While !eof() .and. mv_par08<>3
	IncRegua()
	cCod :=  TRB->COMP
	if ccod='1.089'
		x:=1
	endif
	Select SB2
	dbSetOrder(1)
	Seek xFilial()+cCod+sb1->b1_locpad
	if eof()
		Seek xFilial()+cCod+space(15-len(trim(cCod)))+sb1->b1_locpad
	endif
	
	nQtdPc := 0
	cQuery := " SELECT SUM(c7_QUANT-C7_QUJE) AS QTDE "
	cQuery += " FROM SC7010 WHERE "
	cQuery += " C7_PRODUTO = '"+CCOD+"' AND C7_RESIDUO<>'S' AND (C7_QUANT-C7_QUJE) > 0 AND "
	cQuery += " SC7010.D_E_L_E_T_ <>'*'  "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
	cTempD2b := CriaTrab(nil,.f.)
	nQtdPC := tmp1->QTDE
	use
	
	Select SB1
	DbSetOrder(1)
	Seek xFilial()+cCod
	Select SB3
	DbSetOrder(1)
	Seek xFilial()+cCod
	Select TRB
	reclock("TRB",.f.)
	trb->cons_mes := sb3->b3_total/3
	trb->pc       := nQtdPC
	trb->saldo    := Sb2->b2_qatu
	trb->estseg   := Sb1->b1_EMIN
	MsUnLock()
	Skip
Enddo
dbSelectArea("SC5")
dbSetOrder(1)  // C5_FILIAL+C5_NUM

Return
