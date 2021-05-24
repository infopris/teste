#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RPCP02()        // Relatorio de Producao diaria

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP5 IDE                    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?

SetPrvt("ARETURN,CBTXT,CBCONT,CDESC1,CDESC2,CDESC3")
SetPrvt("CPERG,CSTRING,LI,M_PAG,NLASTKEY,NOMEPROG")
SetPrvt("TITULO,WNREL,LIMITE,TAMANHO,ACPOTRB,ATAM")
SetPrvt("CNOMARQ,CKEY,CTPPED,CARQ,CFILTER,CKEY2")
SetPrvt("CARQIND,ASECAO,AVENDEDOR,NVLCOMIS,NVLNETO,NCUSTO")
SetPrvt("NLINHA,NTOTCOMI,CABEC1,CABEC2,NTGFATURA,NTGCOMIS")
SetPrvt("NTGIPI,NTGICMS,NTGVLNETO,NTGCUSTO,NTGFRETE,NTGCOMIBR")
SetPrvt("NTGCOMIAL,NTGEXTRAS,NTGVLCOMI,ATOTAL,LCABECPRIM,CTPPEDIDO")
SetPrvt("CTIT,I,NTIPO")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±?
±±?un‡…o    ?RFAT014  ?Autor ?Luiz Eduardo          ?Data ?09/12/2004 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?so       ?Especifico p/ Espelhos Leao                                  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?Atualizacoes sofridas desde a Construcao Inicial.                       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?Programador  ?Data   ?BOPS ? Motivo da Alteracao                     ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?             ?       ?     ?                                         ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/


aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos em Carteira "
cDesc2   := "por periodo"
cDesc3   := ""
cPerg    := "RPCP02"
cString  := "SD3"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RPCP02"
titulo   := "Fabricação"
wnrel    := "RPCP02"
limite   := 132
tamanho  := "G"
nTipo    := 15

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Perguntas :                                                  ?
//?mv_par01  // Data de                                      ?
//?mv_par02  // Data ate                                     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Verifica as Perguntas selecionadas.                          ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.t.)

//SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)
//SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

//SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

limite  := 132
//tamanho := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Impressao do Relatorio com os Itens do Pedido.               ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()
//Select TRB
//Use

Return Nil

*************************
Static Function C030Imp()
*************************

if select("TRB")<>0
//	dbCloseArea->("TRB")
endif
if select("Tmp")<>0
//	dbCloseArea->("Tmp")
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Cria array para gerar arquivo de trabalho                    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "DTPROD" , "D",08,0})
AADD(aCampos,{ "PRODUTO", "C",15,0})
AADD(aCampos,{ "QTDE"   , "N",12,2})
AADD(aCampos,{ "AREA"   , "N",12,6})

if select("TRB")<>0
	dbCloseArea("Trb")
Endif

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

cQuery := " SELECT D3_EMISSAO,D3_COD,SUM(D3_QUANT) AS TOTAL "
cQuery += " FROM SD3010 "
cQuery += " where D3_TM='001'  "
cQuery += " AND D3_EMISSAO>='"+DTOS(MV_PAR01)+"'  "
cQuery += " AND D3_EMISSAO<='"+DTOS(MV_PAR02)+"'  "
cQuery += " AND SD3010.D_E_L_E_T_ <>'*'  "
cQuery += " GROUP BY D3_EMISSAO,D3_COD "
cQuery += " ORDER BY D3_EMISSAO,D3_COD "

cQuery := ChangeQuery(cQuery)

if select("TMP")<>0
	dbCloseArea("TMP")
Endif

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP", .F., .T.)
SetRegua(tmp->(recCount()))
dbGoTop()
nValPed := nQtdPed := nAreaT := 0

Do while !eof()
	IncRegua()
	Select SB1
	Seek xFilial()+TMP->D3_COD
	Select Tmp
	nPonto := at(".",TMP->D3_COD)
	nArea := 0
	cLinha := iif(sb1->b1_grupo>'20',"Quadro","Espelho")
	if nPonto=0 .and. !empty(SB1->b1_base)
		nArea := val(substr(TMP->D3_COD,7,4))*val(substr(TMP->D3_COD,12,4))/1000000
		cLinha := "Chapa"
		cCodRed := left(TMP->D3_COD,2)
	else
		Select SG1
		dbSetOrder(1)
		Seek xFilial()+LEFT(TMP->D3_COD,nPonto-1)+space(15-nPonto+1)+"19."
		nArea := sg1->g1_quant
		cCodRed := LEFT(TMP->D3_COD,nPonto-1)
	endif

		Select TRB
		RecLock("TRB",.t.)
		TRB->DTPROD	:= stod(tmp->d3_emissao)
		trb->produto	:= tmp->d3_cod
		trb->qtde	:= tmp->total
		trb->area	:= tmp->total*nArea
		MsUnLock()
		Select Tmp
		Skip
Enddo


dbSelectArea("TRB")
dbgotop()

GeraExcel()

Return Nil

Static Function GeraExcel() // Função para gerar planilha em Excel

Local oReport := nil
oReport := RptDef(cPerg)
oReport:PrintDialog()

Return

Static Function RptDef(cNome)
Local oReport := Nil
Local oSection1:= Nil
Local oSection2:= Nil
Local oBreak
Local oFunction

oReport := TReport():New(cNome,"Fabricação diária",cNome,{|oReport| ReportPrint(oReport)},"Relatório Programação")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1:= TRSection():New(oReport, "Fabricação", {"TRB"}, , .F., .T.)

TRCell():New( oSection1, "DTPROD"   ,"TRB", "Dt.Prod","@!",10)
TRCell():New( oSection1, "PRODUTO" 	,"TRB", "Produto","@!",30)
TRCell():New( oSection1, "QTDE"		,"TRB", "Quantidade","@E 999,999,999.99",15)
TRCell():New( oSection1, "AREA"		,"TRB", "Area","@E 999,999.9999",15)

TRFunction():New(oSection1:Cell("PRODUTO"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por seção
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)

Local cQuery    := ""
Local cPedido   := ""
Local lPrim 	:= .T.

dbSelectArea("TRB")
cTempa := CriaTrab(nil,.f.)
//IndRegua("TRB", cTempa, "DTPROD", , , "Selecionando Registros...")
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
		oReport:IncMeter()
		//imprimo a primeira seção
		oSection1:Cell("DTPROD"):SetValue(DTPROD)
		oSection1:Cell("PRODUTO"):SetValue(PRODUTO)
		oSection1:Cell("QTDE"):SetValue(QTDE)
		oSection1:Cell("AREA"):SetValue(AREA)
		oSection1:Printline()
		TRB->(dbSkip())
	Enddo

	//finalizo a primeira seção
Enddo


//Select Trb
//Use

oSection1:Finish()

Return

