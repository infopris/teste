
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT021   ºAutor  ³ Luiz Eduardo      º Data ³ 08/11/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relação de Vendas X Faturado							      º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFAT021a()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local nAcD7    := 0

Private mv_par01  := date()

Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg    := "RFT021"
cNome := "RFT021"

//AjustaSX1(cPerg)
//pergunte(cPerg,.t.)
if !Pergunte(cPerg,.T.)
	Return
endif

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "VEND"    , "C",06,0})
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
AADD(aCampos,{ "CONDPAG" , "C",10,0})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

GravaArquivo()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReportDef()
oReport	:PrintDialog()	

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³ Vinícius Moreira   º Data ³ 21/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definição da estrutura do relatório.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

oReport := TReport():New("RFAT021","Vendas X Vendedor X Cliente ",cPerg,{|oReport| PrintReport(oReport)},"Impressão de Vendas X Vendedor X Cliente")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:SetLandscape(.T.)

oSection1 := TRSection():New( oReport , "Vendas", {"TRB"} )

TRCell():New(oSection1,"NUM","TRB","Pedido"  ,"@!",10)
TRCell():New(oSection1,"VEND","TRB","Vendedor"  ,"@!",06)
TRCell():New(oSection1,"CODCLI","TRB","Cod.Cli."  ,"@!",06)
TRCell():New(oSection1,"LOJA","TRB","Loja"  ,"@!",02)
TRCell():New(oSection1,"NREDUZ","TRB","Nome Fantasia"  ,"@!",20)
TRCell():New(oSection1,"EST","TRB","UF"  ,"@!",02)
TRCell():New(oSection1,"ENTREGA","TRB", "Dt.entrega","@!",10)
TRCell():New(oSection1,"VALBRUT","TRB", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection1,"MGREAL","TRB", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCREAL","TRB", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection1,"TP"     ,"TRB", "Tipo","@!",02)
TRCell():New(oSection1,"FRETE"    ,"TRB", "Frete","@!",08)
TRCell():New(oSection1,"CONDPAG"  ,"TRB", "Condic.Pagto.","@!",10)

TRFunction():New(oSection1:Cell("CODCLI"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por seção
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText(" ")
Return(oReport)

Static Function GeraExcel()

Local oReport := nil
oReport := RptDef(cPerg)
oReport:PrintDialog()

Return

Static Function RptDef(cNome) //oReport)

Local oSection1 := oReport:Section(1)
Local cQuery    := ""
Local cPedido   := ""
Local lPrim 	:= .T.

dbSelectArea("TRB")

oReport:SetMeter(TRB->(LastRec()))
TRB->(dbGoTop())

While !Eof() // total Geral
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection1:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRB")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		cNum := trb->Num
		cVend := TRB->VEND
		cCodCli := TRB->CODCLI
		cLOJA := TRB->LOJA
		cNREDUZ := TRB->NREDUZ
		cEst := TRB->EST
		dENTREGA := TRB->ENTREGA
		cTp := TRB->TP
		cFRETE := TRB->FRETE
		cCONDPAG := TRB->CONDPAG
		Do while !eof() .and. trb->Num = cNum
			nValBrut +=zz
			Skip
		Enddo
		//imprimo a primeira seção
		oSection1:Cell('NUM'):SetValue(cNUM)
		oSection1:Cell('VEND'):SetValue(cVEND)
		oSection1:Cell('CODCLI'):SetValue(cCODCLI)
		oSection1:Cell('LOJA'):SetValue(cLOJA)
		oSection1:Cell('NREDUZ'):SetValue(cNREDUZ)
		oSection1:Cell('EST'):SetValue(cEST)
		oSection1:Cell('ENTREGA'):SetValue(dEntrega)
		oSection1:Cell('VALBRUT'):SetValue(TRB->VALBRUT)
		oSection1:Cell('MGREAL'):SetValue(TRB->MGREAL)
		oSection1:Cell('PERCREAL'):SetValue(TRB->PERCREAL)
		oSection1:Cell('TP'):SetValue(cTp)
		oSection1:Cell('FRETE'):SetValue(cFRETE)
		oSection1:Cell('CONDPAG'):SetValue(cCONDPAG)
		
		oSection1:Printline()
		TRB->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo
//oSection1:Finish()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR01   ºAutor  ³ Vinícius Moreira   º Data ³ 21/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaArquivo() //PrintReport(oReport)

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
cQuery += "    ,SC6.C6_ITEM " + CRLF 
cQuery += "    ,SC6.C6_VALOR " + CRLF 
cQuery += "    ,SC6.C6_ENTREG " + CRLF 
cQuery += "    ,SC6.C6_TES " + CRLF 
cQuery += "  FROM " + RetSqlName("SC6") + " SC6," + RetSqlName("SC5") + " SC5," + RetSqlName("SA1") + " SA1 " + CRLF 
cQuery += " WHERE SC5.C5_FILIAL = '" + xFilial ("SC5") + "' " + CRLF 
cQuery += "   AND C5_NUM=C6_NUM " + CRLF 
cQuery += "   AND (C5_TIPO='N' OR C5_TIPO='C')" + CRLF 
cQuery += "   AND C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA " + CRLF 
cQuery += "   AND SUBSTRING(SC5.C5_EMISSAO,1,8) = '" + dtos(mv_par01) + "' " + CRLF 
cQuery += "   AND SA1.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "   AND SC5.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "   AND SC6.D_E_L_E_T_ = ' ' " + CRLF 
cQuery := ChangeQuery(cQuery)

If Select("QRY") > 0
	Dbselectarea("QRY")
	QRY->(DbClosearea())
EndIf

TcQuery cQuery New Alias "QRY"

dbgotop()
do while !eof()
	Select SZ0
	dbSetOrder(2)
	seek xfilial()+qry->(C5_NUM+C6_ITEM)

	if SZ0->Z0_PEDIDO = QRY->C5_NUM
		RecLock("TRB",.t.)
		trb->Num	 := SZ0->Z0_PEDIDO
		trb->Vend	 := SZ0->Z0_VEND
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
		trb->CondPag := QRY->C5_CONDPAG
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
		trb->CondPag := QRY->C5_CONDPAG
		MsUnLock()

	Select QRY
	Skip
Enddo
Select Qry
Use
// Totaliza Trb
Select Trb
dbGoTop()
Do while !eof()
	Select Trb
	Skip
Enddo
Copy to \x
//nAcD7 := 22
//oReport:Section(3):Cell("NACD7"):SetBlock({|| nAcD7})

//oSecCab:BeginQuery()
//oSecCab:EndQuery({{"QRY"},cQuery})    
//oSecCab:Print()

Return Nil
// Fim do programa

