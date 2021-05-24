#include "rwmake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFAT021  ³ Autor ³ Luiz Eduardo Tapajós  ³ Data ³ 09.11.20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fat Vend CliMg                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function RFAT021()

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "RFT021"

if !Pergunte (cPerg,.T.)
  Return
Endif

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao                                          ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "VEND"    , "C",06,0})
AADD(aCampos,{ "NVEND"   , "C",30,0})
AADD(aCampos,{ "CODCLI"  , "C",06,0})
AADD(aCampos,{ "LOJA"    , "C",02,0})
AADD(aCampos,{ "NREDUZ"  , "C",20,0})
AADD(aCampos,{ "ENTREGA" , "D",08,0})
AADD(aCampos,{ "VALBRUT" , "N",12,2})
AADD(aCampos,{ "CSTSTD"  , "N",12,2})
AADD(aCampos,{ "MGREAL"  , "N",12,2})
AADD(aCampos,{ "PERCREAL", "N",12,4})

AADD(aCampos,{ "TP"      , "C",01,0})
AADD(aCampos,{ "FRETE"   , "C",01,0})
AADD(aCampos,{ "EST"     , "C",02,0})
AADD(aCampos,{ "DUPLIC"  , "C",01,0})
AADD(aCampos,{ "CONDPAG" , "C",20,0})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa( {|| RunProc() } )
Select TRB
Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*

Local cQuery     := ""
//Local nAcD7		:= 0

Pergunte(cPerg,.F.)

cQuery += " SELECT " + CRLF 
cQuery += "     SC5.C5_NUM " + CRLF 
cQuery += "    ,SC5.C5_EMISSAO " + CRLF 
cQuery += "    ,SC5.C5_CLIENTE " + CRLF 
cQuery += "    ,SC5.C5_LOJACLI " + CRLF 
cQuery += "    ,SC5.C5_CONDPAG " + CRLF 
cQuery += "    ,SC5.C5_FATOR " + CRLF 
cQuery += "    ,SC5.C5_VEND1 " + CRLF 
cQuery += "    ,SC5.C5_TPFRETE" + CRLF 
cQuery += "    ,SA1.A1_NREDUZ " + CRLF 
cQuery += "    ,SA1.A1_EST " + CRLF 
cQuery += "    ,SA3.A3_NOME " + CRLF 
cQuery += "    ,SE4.E4_DESCRI " + CRLF 
cQuery += "    ,SF4.F4_DUPLIC " + CRLF 
cQuery += "    ,SC6.C6_ITEM " + CRLF 
cQuery += "    ,SC6.C6_VALOR " + CRLF 
cQuery += "    ,SC6.C6_ENTREG " + CRLF 
cQuery += "    ,SC6.C6_TES " + CRLF 
cQuery += "  FROM " + RetSqlName("SC6") + " SC6,"
cQuery +=  RetSqlName("SC5") + " SC5," + CRLF
cQuery +=  RetSqlName("SE4") + " SE4," + CRLF
cQuery +=  RetSqlName("SF4") + " SF4," + CRLF
cQuery +=  RetSqlName("SA3") + " SA3," + CRLF
cQuery +=  RetSqlName("SA1") + " SA1 " + CRLF 
cQuery += " WHERE SC5.C5_FILIAL = '" + xFilial ("SC5") + "' " + CRLF 
cQuery += "   AND C5_NUM=C6_NUM " + CRLF 
cQuery += "   AND (C5_TIPO='N' OR C5_TIPO='C')" + CRLF 
cQuery += "   AND C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA " + CRLF 
cQuery += "   AND C5_VEND1=A3_COD " + CRLF 
cQuery += "   AND C5_CONDPAG=E4_CODIGO " + CRLF 
cQuery += "   AND C6_TES=F4_CODIGO " + CRLF 
cQuery += "   AND SUBSTRING(SC5.C5_EMISSAO,1,8) = '" + dtos(mv_par01) + "' " + CRLF 
cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "   AND SA3.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "   AND SE4.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "   AND SF4.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "   AND SC5.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "   AND SC6.D_E_L_E_T_ = ' ' " + CRLF 
cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"

ProcRegua(reccount())

dbgotop()
do while !eof()
	IncProc()
	if left(qry->C5_Num,1)='P' .OR. qry->f4_Duplic='N' 
		skip
		loop
	Endif
	Select SUA
	dbSetOrder(8)
	Seek xFilial()+qry->C5_Num
	cCondPg := qry->e4_descri
	if qry->C5_CONDPAG <> sua->ua_condpg
		Select SE4
		Seek xFilial()+sua->ua_condpg
		cCondPg := e4_descri
	Endif
	Select SZ0
	dbSetOrder(2)
	seek xfilial()+qry->(C5_NUM+C6_ITEM)

	if SZ0->Z0_PEDIDO = QRY->C5_NUM
		RecLock("TRB",.t.)
		trb->Num	 := SZ0->Z0_PEDIDO
		trb->Vend	 := QRY->C5_VEND1
		trb->NVend	 := QRY->A3_NOME
		trb->CodCli	 := SZ0->Z0_CLIENTE
		trb->Loja	 := SZ0->Z0_LOJA
		trb->NReduz	 := QRY->A1_NREDUZ
		trb->Entrega := Stod(QRY->C6_ENTREG)
		trb->ValBrut := SZ0->Z0_VALBRUT
		trb->CstStd  := SZ0->Z0_CSTSTD
		trb->MgReal	 := SZ0->Z0_MGREAL
		trb->PercReal:= SZ0->Z0_PERCREAL
		trb->TP	 	 := QRY->C5_FATOR
		trb->Frete	 := QRY->C5_TPFRETE
		trb->Est	 := QRY->A1_EST
		trb->CondPag := cCondPg
		trb->Duplic  := QRY->F4_DUPLIC
		MsUnLock()
		Select QRY
		Skip
		Loop
	Endif

	// Verifica o tipo do pedido
 	do Case
		Case qry->c5_fator == "A"
			nFator := 2
		Case qry->c5_fator == "B"
			nFator := 5
		Case qry->c5_fator == "C"
			nFator := 1
		Case qry->c5_fator == "S"
			nFator := 0
	Endcase

		RecLock("TRB",.t.)
		trb->Num	 := QRY->C5_NUM
		trb->Vend	 := QRY->C5_VEND1
		trb->NVend	 := QRY->A3_NOME
		trb->CodCli	 := QRY->C5_CLIENTE
		trb->Loja	 := QRY->C5_LOJACLI
		trb->NReduz	 := QRY->A1_NREDUZ
		trb->Entrega := Stod(QRY->C6_ENTREG)
//		trb->ValBrut := QRY->Z0_VALBRUT
//		trb->MgReal	 := QRY->Z0_MGREAL
//		trb->PercReal:= QRY->Z0_PERCREAL
		trb->TP	 	 := QRY->C5_FATOR
		trb->Frete	 := QRY->C5_TPFRETE
		trb->Est	 := QRY->A1_EST
		trb->CondPag := "PROCESSAR MARGEM"//cCondPg
		trb->Duplic  := QRY->F4_DUPLIC
		MsUnLock()

	Select QRY
	Skip
Enddo
Select Qry
Use
// Totaliza Trb
Select Trb

dbGoTop()

Imprime()

Return Nil



*************************
Static Function Imprime()
*************************

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Vendas por Vendedor X Cliente"
cDesc2   := ""
cDesc3   := ""
cString  := "SC6"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT021"
titulo   := "Vendas X Vendedor X Cliente"
wnrel    := "RFAT021"
limite   := 132
tamanho  := "M"
nValPed  := 0

Cabec1 := "Pedido  Vendedor Cliente Nome                      Uf      Entrega Valor Bruto Mg.Real Perc.Real Tipo Frete Cond.Pgto"
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec2 := "Data "+dtoc(mv_par01)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho)

If nLastKey == 27
Set Filter To
	Return Nil
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf    
  
nTot := 0
RptStatus({|| Imprime1() })

**************************
Static Function Imprime1()
**************************
Select TRB
cIndex := CriaTrab(nil,.f.)
IndRegua("TRB", cIndex, "Vend+Num", , , "Selecionando Registros...")
SetRegua(recCount())
li   := 80
dbGoTop()
nTTot1 := nTTot2 := nTTot3 := 0
Do while !eof()
	If li > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	cVend 	:= trb->Vend
	cNVend 	:= trb->NVend
	@ li,000 PSAY cVend
	@ li,010 PSAY cNVend
	li++
	nTot1 := nTot2 := nTot3 := 0
	Do while !eof() .and. cVend = trb->Vend
	cCodCli	:= trb->(codCli+Loja)
	cNum 	:= trb->Num
	cNReduz := trb->NReduz
	cEst	:= trb->Est
	dEntrega:= trb->Entrega
	cTp 	:= trb->Tp 
	cFrete	:= trb->Frete
	cCondPag:= trb->CondPag
	TValBrut := TMgReal :=  tCstStd := 0
	Do while !eof() .and. cNum = trb->Num
		IncRegua()
		tValBrut += ValBrut
		tMgReal  += MgReal 
		tCstStd += CstStd
		ntot1 += ValBrut
		nTot2 += MgReal 
		ntot3 += CstStd
		nTTot1+= trb->valbrut
		nTTot2+= trb->mgreal
		nTTot3+= trb->CstStd
		skip
	Enddo
	@ li,000 PSAY cNum
	@ li,010 PSAY cCodCli
	@ li,020 PSAY cNReduz
	@ li,050 PSAY cEst
	@ li,055 PSAY dEntrega
	@ li,065 PSAY tValBrut picture "@E 9999,999.99"
	@ li,077 PSAY tMgReal picture "@E 9999,999.99"
	@ li,089 PSAY (tmgreal/tCstStd)*100 picture "@E 9,999.99"
	@ li,098 PSAY ctp
	@ li,102 PSAY cFrete
	@ li,105 PSAY cCondPag
	li++
	Enddo
	@ li,000 PSAY "Total Vendedor "+cVend+" - "+cNVend
	@ li,065 PSAY nTot1 picture "@E 9999,999.99"
	@ li,077 PSAY nTot2 picture "@E 9999,999.99"
	@ li,089 PSAY (nTot2/ntot3)*100 picture "@E 9,999.99"
	li++
	@ li,000 PSAY "---------"
	li++
Enddo
li := li + 1
@ li,000 PSAY "Total Geral "
@ li,065 PSAY nTTot1 picture "@E 9999,999.99"
@ li,077 PSAY nTTot2 picture "@E 9999,999.99"
@ li,089 PSAY (nTTot2/nTtot3)*100 picture "@E 9,999.99"

IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

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
