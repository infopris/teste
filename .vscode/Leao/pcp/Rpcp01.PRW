#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RPCP01()        // Relatorio de Pedidos a faturar por prazo pgto/Quant

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
Public CSTSTD,MGSTD,PERSTD,MGREAL,PERCREAL

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
cPerg    := "RPCP01"
cString  := "SC5"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RPCP01"
titulo   := "Pedidos a Faturar por Prazo de Pagto"
wnrel    := "RPCP01"
limite   := 132
tamanho  := "G"
nTipo    := 15

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Perguntas :                                                  ?
//?mv_par01  // Entrega de                                      ?
//?mv_par02  // Entrega ate                                     ?
//?mv_par03  // Emissao de                                      ?
//?mv_par04  // Emissao ate                                     ?
//?mv_par05  // Liberados                                       ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Verifica as Perguntas selecionadas.                          ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !Pergunte(cPerg,.t.)
	Return
Endif

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Cria array para gerar arquivo de trabalho                    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "ITEM"    , "C",02,0})
AADD(aCampos,{ "CLI"     , "C",20,0})
AADD(aCampos,{ "FANTASIA", "C",20,0})
AADD(aCampos,{ "UF"      , "C",02,0})
AADD(aCampos,{ "PRODUTO" , "C",15,0})
AADD(aCampos,{ "TPCOB"   , "C",02,0})
AADD(aCampos,{ "ENTREG"  , "D",08,0})
AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "COND"    , "C",30,0})
AADD(aCampos,{ "LIBERADO", "C",01,0})
AADD(aCampos,{ "LINHA"	 , "C",03,0})
AADD(aCampos,{ "VEND"    , "C",06,0})
AADD(aCampos,{ "NOMEVEND", "C",30,0})
AADD(aCampos,{ "CODRED"  , "C",08,0})
AADD(aCampos,{ "GRPCLI"  , "C",08,0})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "PECAS"   , "N",12,2})
AADD(aCampos,{ "AREA"    , "N",12,6})
AADD(aCampos,{ "DTPROG"  , "D",08,0})
AADD(aCampos,{ "QTDPROD" , "N",12,2})
AADD(aCampos,{ "AREAPROD", "N",12,2})
AADD(aCampos,{ "CUSTOSTD", "N",12,2})
AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "MARGEM"  , "N",12,2})
AADD(aCampos,{ "PERCSTD" , "N",12,2})
AADD(aCampos,{ "MGREAL"  , "N",12,2})
AADD(aCampos,{ "PERCREAL", "N",12,2})

if select("TRB")<>0
	dbCloseArea("Trb")
Endif

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on Entreg to &cTemp

cQuery := " SELECT C6_NUM,C6_ITEM,C5_NUM,C5_TIPO,C5_EMISSAO,C5_FATOR, "
cQuery += " B1_BASE,B1_GRUPO,C5_CONDPAG,B1_SEGUM,B1_CONV,C5_VEND1 "
cQuery += " FROM SC6010 "
cQuery += " INNER JOIN SB1010 ON B1_COD = C6_PRODUTO"
cQuery += " AND (B1_TIPO = 'PA' OR B1_TIPO = 'RV' OR B1_TIPO = 'SU') AND SB1010.D_E_L_E_T_ <>'*'"
cQuery += " INNER JOIN SF4010 ON F4_CODIGO = C6_TES"
cQuery += " AND F4_DUPLIC='S'  AND SF4010.D_E_L_E_T_ <>'*'"
cQuery += " INNER JOIN SC5010 ON C5_NUM = C6_NUM"
cQuery += " AND C5_EMISSAO>='"+DTOS(mv_par03)+"'"
cQuery += " AND C5_EMISSAO<='"+DTOS(mv_par04)+"'"
cQuery += " AND  SC5010.D_E_L_E_T_ <>'*'"
cQuery += " WHERE C6_BLQ<>'R' "
cQuery += " AND C5_TIPO<>'C'"
cQuery += " AND C6_QTDVEN-C6_QTDENT > 0 "
cQuery += " AND C6_ENTREG>='"+DTOS(mv_par01)+"'"
cQuery += " AND C6_ENTREG<='"+DTOS(mv_par02)+"'"
cQuery += " AND SUBSTRING(C6_NOTA,1,1)=' '"
cQuery += " AND SUBSTRING(C6_NUM,1,1)<>'P'"
cQuery += " AND SC6010.D_E_L_E_T_ <>'*'  "
cQuery += " ORDER BY C5_NUM "
cQuery := ChangeQuery(cQuery)

If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB1", .F., .T.)

SetRegua(trb1->(recCount()))
dbGoTop()
nValPed := nQtdPed := nAreaT := nAreaP := 0

Do while !eof()
	IncRegua(strzero(trb1->(recCount()),6)+"/"+strzero(trb1->(recCount()),6) )
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+"P"+substr(trb1->(C6_NUM+C6_ITEM),2,7)
	nValPed := 0
	if !eof()
		nValPed := C6_VALOR
	Endif
	
	Seek xFilial()+trb1->(C6_NUM+C6_ITEM)
	if C6_QTDVEN-C6_QTDENT<=0
		Select trb1
		skip
		loop
	Endif
	nPonto := at(".",SC6->C6_PRODUTO)
	nArea  := nAreaProd := 0
	cLinha := iif(trb1->b1_grupo>'20',"Quadro","Espelho")
	if nPonto=0 .and. !empty(trb1->b1_base)
		nArea := val(substr(C6_PRODUTO,7,4))*val(substr(C6_PRODUTO,12,4))/1000000
		cLinha := "Chapa"
		cCodRed := left(C6_PRODUTO,6)
	else
		Select SG1
		dbSetOrder(1)
		Seek xFilial()+LEFT(SC6->C6_PRODUTO,nPonto-1)+space(15-nPonto+1)+"19."
		nArea := sg1->g1_quant
		cCodRed := LEFT(SC6->C6_PRODUTO,nPonto-1)
	endif
	
	nValLiq :=0
	
	Select SB5
	Seek xFilial()+cCodRed
	if eof()
		Seek xFilial()+SC6->C6_PRODUTO
	endif
	
	CSTSTD 	:= sb5->b5_prv7
	MGSTD 	:= sb5->b5_margem
	PERSTD 	:= 0
	MGREAL 	:= (nValLiq-trb->CUSTOSTD)/(1,05/100)
	PERCREAL:= iif((trb->mgreal/trb->CUSTOSTD)*100<1000 .and. (trb->mgreal/trb->CUSTOSTD)*100>-1000,(trb->mgreal/trb->CUSTOSTD)*100,0)
	
	if trb1->(c6_num+c6_item)='07873508' //10208//	078915'
		x:=1
	endif
	
	Select SZ0
	dbSetOrder(2)
	Seek space(2)+trb1->(C6_NUM+C6_ITEM)
	
	if trb1->(c6_num)='078928' //10208//	078915'
		x:=1
	endif
	nCstd := 0
	if eof()
		//		Aviso("Atenção","Pedido"+trb1->(c6_num+c6_item),{"Sair"} )
		u_CalcVLiq(Alltrim(trb1->C5_FATOR),SC6->C6_VALOR,cCodRed,SC6->C6_PRODUTO,SC6->(C6_cli+C6_loja),SC6->C6_TES,trb1->C5_CONDPAG,"N",trb1->C5_VEND1,"PED",SC6->C6_ITEM," ",SC6->C6_QTDVEN)
	else
		//if at(".",sz0->z0_produto)<>0
		//nValliq :=  SZ0->Z0_VALLIQ
		//nCStd	:= (sz0->z0_CSTSTD/sz0->z0_Qtde)*SC6->C6_QTDVEN
		//nMarg	:= (sz0->z0_mgstd/sz0->z0_Qtde)*SC6->C6_QTDVEN
		//else
		nValliq :=  SZ0->Z0_VALLIQ
		nCStd	:=  sz0->z0_CSTSTD
		nMarg	:=  sz0->z0_mgstd
		//Endif
	endif
	
	if nCstd = 0
		Select SB1
		Seek xFilial()+sc6->c6_produto
		Select SB5
		Seek xFilial()+cCodRed
		if eof()
			Seek xFilial()+SC6->C6_PRODUTO
		endif
		nCStd := sb5->b5_prv7
		nMarg := sb5->b5_margem
		
		Select SZ3   // Busca custo congelado
		dbSetOrder(2)
		seek "  "+left(trb1->c5_emissao,6)
		if sz3->z3_data>=stod(trb1->c5_emissao)
			cDt := z3_data
			nTam := len(trim(cCodRed))
			seek "  "+dtos(cDt)+left(cCodRed,nTam)+space(15-nTam)
			if !eof() .and. sz3->z3_margem<>0
				nMarg := sz3->z3_margem
			endif
			if !eof() .and. sz3->z3_stdcipi<>0
				nCStd := sz3->z3_stdcipi
			endif
		Endif
	Endif
	
	Select SC6
	if trb1->C5_TIPO<>"C"
		nValPed += (sc6->c6_qtdven-sc6->c6_qtdent)*sc6->c6_prcven
	endif
	nAreaT  := (sc6->c6_qtdven-sc6->c6_qtdent)*nArea
	if nValPed==0
		loop
	endif
	nQtdPed := sc6->(C6_QTDVEN-C6_QTDENT)
	Select SC2
	Seek xFilial()+trb1->(C6_NUM+C6_ITEM)
	nQtdprod := SC2->(C2_QUANT-C2_QUJE)
	nAreaP  := nQtdProd*nArea
	Select SC9
	Seek xFilial()+trb1->C6_NUM
	Select SC5
	Seek xFilial()+trb1->C6_NUM
	Select SA1
	Seek xFilial()+SC5->(C5_CLIENTE+C5_LOJACLI)
	Select SA3
	Seek xFilial()+SC5->(C5_VEND1)
	Select SE4
	Seek xFilial()+SC5->C5_CONDPAG
	Select TRB
	RecLock("TRB",.t.)
	trb->num       := SC6->C6_num
	trb->Item      := SC6->C6_item
	trb->entreg    := SC6->C6_ENTREG
	trb->cli       := sa1->a1_nome
	trb->fantasia  := sa1->a1_nreduz
	trb->uf        := sa1->a1_est
	trb->produto   := sc6->c6_produto
	trb->TpCob     := ""
	trb->Liberado  := iif(sc9->c9_datalib<>ctod("0"),"S","N")
	trb->Linha     := cLinha
	trb->CodRed    := cCodRed
	trb->DtProg    := SC2->C2_DATPRI
	trb->QTDPROD   := iif(empty(TRB1->b1_base),nQtdprod,0) //-SC2->C2_QUJE
	trb->AREAPROD  := iif(empty(TRB1->b1_base),nAreaP,0) //-SC2->C2_QUJE
	trb->emissao   := sc5->c5_emissao
	trb->vend      := sc5->c5_vend1
	trb->NOMEVEND  := sa3->a3_nome
	trb->grpcli    := sa1->a1_xgrpcli
	trb->cond      := se4->e4_cond
	trb->valor     := nValPed
	trb->pecas     := iif(empty(TRB1->b1_base),nQtdPed,nAreaT)
	nQtdV := nQtdPed
	if sc6->C6_TES <>"569"
		trb->pecas := iif(TRB1->b1_segum="M2",nQtdPed*sb1->b1_conv,nQtdPed)
		if trb->Pecas<>0
			nQtdPed := nQtdPed*TRB1->b1_conv
		endif
	Endif
	trb->area      := nAreaT
	trb->valliq    := nValliq
	trb->CUSTOSTD	:= nCStd //* SC6->C6_QTDVEN
	trb->MARGEM		:= nMarg //* SC6->C6_QTDVEN
	if (trb->MARGEM/trb->CUSTOSTD)*100<100000
		trb->percstd   := (trb->MARGEM/trb->CUSTOSTD)*100
	endif
	trb->mgreal := (nValLiq-trb->CUSTOSTD)
	if (trb->mgreal/trb->CUSTOSTD)*100<1000 .and. (trb->mgreal/trb->CUSTOSTD)*100>-1000
		trb->percreal   := (trb->mgreal/trb->CUSTOSTD)*100
	endif
	MsUnLock()
	Select trb1
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

oReport := TReport():New(cNome,"Pedidos a Faturar",cNome,{|oReport| ReportPrint(oReport)},"Relatório Programação")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1:= TRSection():New(oReport, "Sintetico", {"TRB"}, , .F., .T.)

TRCell():New( oSection1, "NUM"    	 ,"TRB", "Pedido","@!",06)
TRCell():New( oSection1, "CLI"	     ,"TRB", "Cliente","@!",30)
TRCell():New( oSection1, "FANTASIA"  ,"TRB", "Nome Fantasia","@!",20)
TRCell():New( oSection1, "UF"  		 ,"TRB", "Estado","@!",20)
TRCell():New( oSection1, "VEND"  	 ,"TRB", "Vendedor","@!",20)
TRCell():New( oSection1, "NOMEVEND"  ,"TRB", "Nome Vend","@!",20)
TRCell():New( oSection1, "GRPCLI"    ,"TRB", "Grupo Cli","@!",10)
TRCell():New( oSection1, "ENTREG"    ,"TRB", "Data Entrega ","@!",10)
TRCell():New( oSection1, "EMISSAO"   ,"TRB", "Data Emissao ","@!",10)
TRCell():New( oSection1, "COND"		 ,"TRB", "Cond.Pgt","@!",30)
TRCell():New( oSection1, "PERCREAL"	 ,"TRB", "% Real","@E 999,999,999.99",15)
TRCell():New( oSection1, "LIBERADO"  ,"TRB", "Liberado","@!",10)
TRCell():New( oSection1, "VALOR" 	 ,"TRB", "Valor","@E 999,999,999.99",15)
TRCell():New( oSection1, "PECAS"	 ,"TRB", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection1, "AREA"		 ,"TRB", "Area total","@E 9999,999.99999",15)
TRCell():New( oSection1, "LINHAE"	 ,"TRB", "Esp. Qtde","@E 999,999",07)
TRCell():New( oSection1, "AREAE"	 ,"TRB", "Area Esp","@E 9999,999.99999",15)
TRCell():New( oSection1, "LINHAQ"	 ,"TRB", "Quadros Qtde","@E 999,999",07)
TRCell():New( oSection1, "AREAQ"	 ,"TRB", "Area Quadros","@E 9999,999.99999",15)
TRCell():New( oSection1, "LINHAC"	 ,"TRB", "Chapas Qtde","@E 999,999",07)
TRCell():New( oSection1, "AREAC"	 ,"TRB", "Area Chapas","@E 9999,999.99999",15)
TRCell():New( oSection1, "DTPROG"    ,"TRB", "Data Fabricação ","@!",10)
TRCell():New( oSection1, "QTDPROD"   ,"TRB", "Falta Produzir ","@E 999,999,999.99",15)
TRCell():New( oSection1, "AREAPROD"  ,"TRB", "Area a Produzir ","@E 999,999,999.99",15)
TRCell():New( oSection1, "CUSTOSTD"	 ,"TRB", "Custo Std","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALLIQ"	 ,"TRB", "Valor Liq","@E 999,999,999.99",15)
TRCell():New( oSection1, "MARGEM"	 ,"TRB", "Margem","@E 999,999,999.99",15)
TRCell():New( oSection1, "PERCSTD"	 ,"TRB", "% Std","@E 999,999,999.99",15)
TRCell():New( oSection1, "MGREAL"	 ,"TRB", "Margem Real","@E 999,999,999.99",15)

oSection2:= TRSection():New(oReport, "Analítico", {"TRB"}, , .F., .T.)

TRCell():New( oSection2, "NUM"    	 ,"TRB", "Pedido","@!",06)
TRCell():New( oSection2, "ITEM"    	 ,"TRB", "Item","@!",02)
TRCell():New( oSection2, "CLI"	     ,"TRB", "Cliente","@!",20)
TRCell():New( oSection2, "FANTASIA"  ,"TRB", "Nome Fantasia","@!",20)
TRCell():New( oSection2, "GRPCLI"    ,"TRB", "Grupo Cli","@!",10)
TRCell():New( oSection2, "ENTREG"    ,"TRB", "Data Entrega ","@!",10)
TRCell():New( oSection2, "EMISSAO"   ,"TRB", "Data Emissao ","@!",10)
TRCell():New( oSection2, "COND"		 ,"TRB", "Cond.Pgt","@!",30)
TRCell():New( oSection2, "PERCREAL"	 ,"TRB", "% Real","@E 999,999,999.99",15)
TRCell():New( oSection2, "LIBERADO"  ,"TRB", "Liberado","@!",10)
TRCell():New( oSection2, "LINHA"	 ,"TRB", "Linha","@!",10)
TRCell():New( oSection2, "CODRED"	 ,"TRB", "Cod.Reduzido","@!",10)
TRCell():New( oSection2, "PRODUTO"   ,"TRB", "Produto","@!",15)
TRCell():New( oSection2, "VALOR" 	 ,"TRB", "Valor","@E 999,999,999.99",15)
TRCell():New( oSection2, "PECAS"	 ,"TRB", "Qtde Pecas","@E 999,999,999.99",15)
TRCell():New( oSection2, "AREA"		 ,"TRB", "Area total","@E 999,999,999.99",15)
TRCell():New( oSection2, "DTPROG"    ,"TRB", "Data Fabricação ","@!",10)
TRCell():New( oSection2, "QTDPROD"   ,"TRB", "Falta Produzir ","@E 999,999,999.99",15)
TRCell():New( oSection2, "AREAPROD"  ,"TRB", "Area a Produzir ","@E 999,999,999.99",15)
TRCell():New( oSection2, "CUSTOSTD"	 ,"TRB", "Custo Std","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALLIQ"	 ,"TRB", "Valor Liq","@E 999,999,999.99",15)
TRCell():New( oSection2, "MARGEM"	 ,"TRB", "Margem","@E 999,999,999.99",15)
TRCell():New( oSection2, "PERCSTD"	 ,"TRB", "% Std","@E 999,999,999.99",15)
TRCell():New( oSection2, "MGREAL"	 ,"TRB", "Margem Real","@E 999,999,999.99",15)

TRFunction():New(oSection1:Cell("NUM"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por seção
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)

Local cQuery    := ""
Local cPedido   := ""
Local lPrim 	:= .T.

dbSelectArea("TRB")
cTempa := CriaTrab(nil,.f.)
IndRegua("TRB", cTempa, "Num", , , "Selecionando Registros...")
//Index on Num to &cTemp12a
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
		cNum 	:= Trb->Num
		cCli 	:= Trb->Cli
		cFan 	:= Trb->Fantasia
		cLib 	:= Trb->Liberado
		dEntreg := Trb->Entreg
		dEmissao := Trb->Emissao
		dDTPROG  := TRB->DTPROG
		cUf 	:= trb->Uf
		cVend	:= trb->Vend
		cNomeVend := trb->NomeVend
		
		cCond 	:= trb->Cond
		cGrpCli := trb->GrpCli
		nValor := nPecas := nArea := 0
		nQtdeE := nQtdeQ := nQtdeC := 0
		nAreaE := nAreaQ := nAreaC := nArea := nAreaP := 0
		nvalliq    	:= 0
		nQtdProd   	:= 0
		nCUSTOSTD	:= 0
		nMARGEM		:= 0
		
		Do while !eof() .and. cNum = Trb->Num
			if empty(dDTPROG)
				dDTPROG := TRB->DTPROG
		  	endif
			nValor 	+= trb->Valor
			nPecas 	+= trb->Pecas
			nArea 	+= trb->Area
			nQtdProd+= trb->QtdProd
			nAreaP	+= trb->AreaProd
			do case
				Case left( trb->Linha,3) = "Esp"
					nQtdeE += trb->Pecas
					nAreaE += trb->Area
				Case left( trb->Linha,3) = "Qua"
					nQtdeQ += trb->Pecas
					nAreaQ += trb->Area
				Case left( trb->Linha,3) = "Cha"
					nQtdeC += trb->Pecas
					nAreaC += trb->Area
			endcase
			//Calculo da Margem
			nvalliq    	+= trb->Valliq
			nCUSTOSTD	+= trb->CUSTOSTD
			nMARGEM		+= trb->Margem
			skip
		Enddo
		nPercStd := 0
		if (nMARGEM/nCUSTOSTD)*100<100000
			npercstd   := (nMARGEM/nCUSTOSTD)*100
		endif
		nmgreal 	:= (nValLiq-nCUSTOSTD)
		nPercreal := 0
		if (nmgreal/nCUSTOSTD)*100<100000 .and. (nmgreal/nCUSTOSTD)*100>-10000
			nPercreal   := (nMgreal/nCUSTOSTD)*100
		endif
		
		//imprimo a primeira seção
		//		oSection1:Cell("DULTVEN"):SetValue(dtoc(SC5->C5_EMISSAO))
		oSection1:Cell("NUM"):SetValue(cNUM)
		oSection1:Cell("CLI"):SetValue(cCLI)
		oSection1:Cell("FANTASIA"):SetValue(cFan)
		oSection1:Cell("UF"):SetValue(cUf)
		oSection1:Cell("VEND"):SetValue(cVend)
		oSection1:Cell("NOMEVEND"):SetValue(cNomeVend)
		oSection1:Cell("GRPCLI"):SetValue(cGRPCLI)
		oSection1:Cell("ENTREG"):SetValue(dENTREG)
		oSection1:Cell("EMISSAO"):SetValue(dEMISSAO)
		oSection1:Cell("COND"):SetValue(cCOND)
		oSection1:Cell("PERCREAL"):SetValue(nPercreal)
		oSection1:Cell("LIBERADO"):SetValue(cLib)
		oSection1:Cell("VALOR"):SetValue(nVALOR)
		oSection1:Cell("PECAS"):SetValue(nPECAS)
		oSection1:Cell("AREA"):SetValue(nArea)
		oSection1:Cell("LINHAE"):SetValue(nQtdeE)
		oSection1:Cell("AREAE"):SetValue(nAREAE)
		oSection1:Cell("LINHAQ"):SetValue(nQtdeQ)
		oSection1:Cell("AREAQ"):SetValue(nAREAQ)
		oSection1:Cell("LINHAC"):SetValue(nQtdeC)
		oSection1:Cell("AREAC"):SetValue(nAREAC)
		oSection1:Cell("DTPROG"):SetValue(dDTPROG)
		oSection1:Cell("QTDPROD"):SetValue(nQtdProd)
		oSection1:Cell("AREAPROD"):SetValue(nAREAP)
		oSection1:Cell("CUSTOSTD"):SetValue(nCUSTOSTD)
		oSection1:Cell("VALLIQ"):SetValue(nVALLIQ)
		oSection1:Cell("MARGEM"):SetValue(nMARGEM)
		oSection1:Cell("PERCSTD"):SetValue(nPERCSTD)
		oSection1:Cell("MGREAL"):SetValue(nMGREAL)
		oSection1:Printline()
		//		TRB->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo


dbSelectArea("TRB")
Trb->(dbGoTop())

oReport:SetMeter(Trb->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection2:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("Trb")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a primeira seção
		oSection2:Cell("NUM"):SetValue(TRB->NUM)
		oSection2:Cell("ITEM"):SetValue(TRB->ITEM)
		oSection2:Cell("CLI"):SetValue(TRB->CLI)
		oSection2:Cell("FANTASIA"):SetValue(TRB->FANTASIA)
		oSection2:Cell("GRPCLI"):SetValue(TRB->GRPCLI)
		oSection2:Cell("ENTREG"):SetValue(TRB->ENTREG)
		oSection2:Cell("EMISSAO"):SetValue(TRB->EMISSAO)
		oSection2:Cell("COND"):SetValue(TRB->COND)
		oSection2:Cell("LIBERADO"):SetValue(TRB->LIBERADO)
		oSection2:Cell("LINHA"):SetValue(TRB->LINHA)
		oSection2:Cell("CODRED"):SetValue(TRB->CODRED)
		oSection2:Cell("PRODUTO"):SetValue(TRB->PRODUTO)
		oSection2:Cell("VALOR"):SetValue(TRB->VALOR)
		oSection2:Cell("PECAS"):SetValue(TRB->PECAS)
		oSection2:Cell("AREA"):SetValue(TRB->AREA)
		oSection2:Cell("DTPROG"):SetValue(TRB->DTPROG)
		oSection2:Cell("QTDPROD"):SetValue(TRB->QTDPROD)
		oSection2:Cell("AREAPROD"):SetValue(trb->AreaProd)
		oSection2:Cell("CUSTOSTD"):SetValue(TRB->CUSTOSTD)
		oSection2:Cell("VALLIQ"):SetValue(TRB->VALLIQ)
		oSection2:Cell("MARGEM"):SetValue(TRB->MARGEM)
		oSection2:Cell("PERCSTD"):SetValue(TRB->PERCSTD)
		oSection2:Cell("MGREAL"):SetValue(TRB->MGREAL)
		oSection2:Cell("PERCREAL"):SetValue(TRB->PERCREAL)
		oSection2:Printline()
		TRB->(dbSkip())
		
	Enddo
	
	//finalizo a segunda seção
Enddo
Select Trb
Use


oSection2:Finish()
oSection1:Finish()

Return

