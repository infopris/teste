#include "rwmake.ch"
#INCLUDE "MATR790.CH"

User Function Matr790()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR790  ³ Autor ³ Gilson do Nascimento  ³ Data ³ 05.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Romaneio de Despacho  (Expedicao)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR790(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL tamanho:="M"
LOCAL titulo:=OemToAnsi(STR0001)	//"Romaneio de Despacho  (Expedicao)"
LOCAL cDesc1:=OemToAnsi(STR0002)	//"Emiss„o do Romaneio de Despacho para a Expedicao, Almoxarifado"
LOCAL cDesc2:=OemToAnsi(STR0003)	//"atraves de intervalo de Pedidos informado na op‡„o Parƒmetros."
LOCAL cDesc3:=""
LOCAL CbCont,cabec1,cabec2
LOCAL cString:="SC9"

cPerg  :="MTR790"
PRIVATE aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",0 }			//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR790",nLastKey := 0,nBegin:=0,aLinha:={ }
PRIVATE li:=80,limite:=132,lRodape:=.F.
PRIVATE nTotQtd:=nTotVal:=0
wnrel    := "MATR790"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR790",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01	     	  Do Pedido                             ³
//³ mv_par02	     	  Ate o Pedido                          ³
//³ mv_par03	     	  Faturamento de                        ³
//³ mv_par04	     	  Faturamento ate                       ³
//³ mv_par05	     	  Mascara                               ³
//³ mv_par06	     	  Aglutina Pedidos de Grade             ³
//³ mv_par07	     	  Qual moeda                            ³
//³ mv_par08	     	  Um pedido por folha?                  ³
//³ mv_par09	     	  Imprime os valores?                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C790Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C790IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR790			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C790Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL tamanho:="M"
LOCAL titulo:=OemToAnsi(STR0001)	//"Romaneio de Despacho  (Expedicao)"
LOCAL cDesc1:=OemToAnsi(STR0002)	//"Emiss„o do Romaneio de Despacho para a Expedicao, Almoxarifado"
LOCAL cDesc2:=OemToAnsi(STR0003)	//"atraves de intervalo de Pedidos informado na op‡„o Parƒmetros."
LOCAL cDesc3:=""
LOCAL CbCont,cabec1,cabec2
LOCAL lContinua := .T.,	lFirst := .T.
LOCAL cPedAnt:="   "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
nTipo    :=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := STR0006+ " - " + GetMv("MV_MOEDA" + STR(mv_par07,1))//"ROMANEIO DE DESPACHO - moeda"
cabec1 := STR0007	//"It Codigo          Desc. Material  UM Quantidade  Valor Unitario IPI ICM/ISS Valor Merc. Entrega   Alm Localiz.     N.F./Serie"
cabec2 := ""
// BRA               99 999999999999999 XXXXXXXXXXXXXXX XX 9999999.99 9999,999,999.99  99.99  9999,999,999.99 99/99/9999 99 XXXXXXXXXXXX XXXXXXXXXXXX/XXX
// SPA              "It C¢digo          Desc. Material  UM   Cantidad  Valor Unitario    IVA      Valor Merc. Entrega   Dep Local.       Fact/Serie"
// SPA               99 999999999999999 XXXXXXXXXXXXXXX XX 9999999.99 9999,999,999.99  99 99  9999,999,999.99 99/99/9999 99 XXXXXXXXXXXX XXXXXXXXXXXX/XXX
//                             1         2         3         4         5         6         7         8         9        10        11        12        13
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("SC9")
dbSetOrder(1)
dbSeek( xFilial()+mv_par01,.T. )

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. C9_PEDIDO <= mv_par02 .And. lContinua .and. xFilial() == C9_FILIAL
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial()+SC9->C9_PEDIDO)
	dbSelectArea("SC9")
	
	If At(SC5->C5_TIPO,"DB") != 0 .Or. ( !Empty(C9_BLEST) .AND. !Empty(C9_BLCRED) .And. C9_BLEST #"10" .AND. C9_BLCRED # "10")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial()+SC9->C9_PEDIDO+SC9->C9_ITEM)
	
	dbSelectArea("SC9")
	If SC6->C6_DATFAT < MV_PAR03 .OR. SC6->C6_DATFAT > MV_PAR04
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida o produto conforme a mascara         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet:=ValidMasc(SC9->C9_PRODUTO,MV_PAR05)
	If !lRet
		dbSkip()
		Loop
	Endif
	
	IF lEnd
		@PROW()+1,001 Psay STR0008	//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	IncRegua()
	
	IF li > 55 .Or. lFirst
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		lRodape := .T.
	Endif
	
	If C9_PEDIDO #cPedAnt .Or. lFirst
		cPedAnt:= C9_PEDIDO
		lFirst := .F.
		nTotQtd:= 0
		nTotVal:= 0
		CPedido:= SC5->C5_NUM
		dbSelectArea("SA4")
		dbSeek(xFilial()+SC5->C5_TRANSP)
		dbSelectArea("SA1")
		dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do Cabecalho do Pedido                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ li,000 Psay STR0009+SC5->C5_NUM				//"PEDIDO : "
		@ li,020 Psay STR0010+DTOC(SC5->C5_EMISSAO)	//"EMISSAO : "
		li++
		@ li,000 Psay STR0011+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+"-"+SA1->A1_NOME	  //"CLIENTE : "
		li++
		@ li,000 Psay STR0015+Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) +" - "+SA1->A1_EST   //"ENDERECO: "
		li++
		@ li,000 Psay STR0012+SC5->C5_TRANSP+"-"+SA4->A4_NREDUZ+"  "+STR0013+SA4->A4_VIA		//"TRANSPORTADORA : "###"VIA : "
		li++
		@ li,000 Psay STR0015+Alltrim(SA4->A4_END)+ " - " + Alltrim(SA4->A4_MUN)+" - "+SA4->A4_EST   //"ENDERECO: "
		li++
		@ li,000 Psay Replicate("-",limite)
		
	Endif
	
	li++
	ImpItem()
	
	dbSelectArea("SC9")
	dbSkip()
	
	If C9_PEDIDO #cPedAnt .or. Eof()
		
		li++
		@ li,000 Psay Replicate("-",limite)
		li++
		@ li,000 Psay STR0014	//" T O T A I S "
		@ li,038 Psay nTotQtd	Picture PESQPICTQT("C6_QTDVEN",10)
		IF MV_PAR09 == 1
		@ li,071 Psay xMoeda(nTotVal,1,mv_par07,SC5->C5_EMISSAO)	Picture "@E 99,999,999,999.99"
		EndIF
		
		Li := Li + 2
		If MV_PAR08 = 1 .Or. Li + 7 > 55	//1 pedido por folha
			lFirst := .T.
			li := 80
		EndIf
		
	Endif
End

IF lRodape
	roda(cbcont,cbtxt,"M")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC9")
Set Filter To
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Gilson do Nascimento  ³ Data ³ 05.10.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Itens do Romaneio  de Despacho                ³±±
±±³          ³ Ordem de Impressao : LOCALIZACAO NO ALMOXARIFADO           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR790                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpItem()

LOCAL cMascara :=GetMv("MV_MASCGRD")
LOCAL nTamRef  :=Val(Substr(cMascara,1,2))
LOCAL nTamLin  :=Val(Substr(cMascara,4,2))
LOCAL nTamCol  :=Val(Substr(cMascara,7,2))
dbSelectArea("SB2")
dbSeek(xFilial()+SC9->C9_PRODUTO)

dbSelectArea("SC6")
dbSeek(xFilial()+SC9->C9_PEDIDO+SC9->C9_ITEM)

dbSelectArea("SB1")
dbSeek(xFilial()+SC6->C6_PRODUTO+SC6->C6_LOCAL)

IF SC6->C6_GRADE == "S" .And. MV_PAR06 == 1
	dbSelectArea("SC9")
	cProdRef:=Substr(C9_PRODUTO,1,nTamRef)
	cPedido := SC9->C9_PEDIDO
	nReg    := 0
	nTotLib := 0
	
	While !Eof() .And. xFilial() == C9_FILIAL .And. Substr(C9_PRODUTO,1,nTamRef) == cProdRef;
		.And. C9_PEDIDO == cPedido
		nReg:=Recno()
		If !Empty(C9_BLEST) .AND. !Empty(C9_BLCRED) .And. C9_BLEST #"10" .AND. C9_BLCRED # "10"
			dbSkip()
			Loop
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o produto conforme a mascara         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc(SC9->C9_PRODUTO,MV_PAR05)
		If !lRet
			dbSkip()
			Loop
		Endif
		nTotLib += SC9->C9_QTDLIB
		dbSkip()
	End
	If nReg > 0
		dbGoto(nReg)
		nReg:=0
	Endif
Endif

@li,000 Psay SC9->C9_ITEM
@li,003 Psay IIF(SC6->C6_GRADE == "S" .And. MV_PAR06 == 1,Substr(SC9->C9_PRODUTO,1,nTamRef),SC9->C9_PRODUTO)
@li,019 Psay Left(IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI), 15)
@li,035 Psay SC6->C6_UM
@li,038 Psay IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB)	Picture PESQPICTQT("C9_QTDLIB",10)
IF MV_PAR09 == 1
	@li,049 Psay xMoeda(SC9->C9_PRCVEN,1,mv_par07,SC5->C5_EMISSAO)	Picture "@E 9999,999,999.99"
	If ( cPaisloc=="BRA" )
		@li,066 Psay SB1->B1_IPI				Picture "99"
		If !Empty(SB1->B1_PICM)
			@li,069 Psay SB1->B1_PICM			Picture "99"
		Else
			@li,069 Psay SB1->B1_ALIQISS		Picture "99"
		EndIf
	Else
		@li,066 Psay SB1->B1_IPI				Picture "99.99"
	EndIf
	@li,073 Psay xMoeda(((IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB))*SC9->C9_PRCVEN),1,mv_par07,SC5->C5_EMISSAO)	Picture "@E 9999,999,999.99"
EndIF
@li,089 Psay SC6->C6_ENTREG
@li,100 Psay SC6->C6_LOCAL
@li,103 Psay Left(SB2->B2_LOCALIZ,12)
@li,116 Psay SC9->C9_NFISCAL+"/"+SC9->C9_SERIENF
nTotQtd += IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB)
nTotVal += IIF(SC6->C6_GRADE=="S" .And. MV_PAR06 ==1,nTotLib,SC9->C9_QTDLIB)*SC9->C9_PRCVEN

Return