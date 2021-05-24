#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "rwmake.ch"

User Function RCOM006()    //Gera Arquivo de MP

cTemp := CriaTrab(nil,.f.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCOM006  ³ Autor ³ Luiz Eduardo Santos   ³ Data ³ 21/05/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastro de Mat.Prima(com custos)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RCOM006                                                    ³±±
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
cDesc1   := "Este programa ir  imprimir o Relatorio de Custos por produto."
cDesc2   := ""
cDesc3   := ""
aOrdem   := {}
Titulo   := "Custos dos Produtos"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
cString  := "SB1"
nomeprog := "RCOM006"
cPerg    := "COM006"
wnRel    := "RCOM006"
cbtxt    := Space(10)
Tamanho  := "M"
cbcont   := 0
limite   := 132
nLastKey := 0
li       := 80
m_pag    := 1
lEnd     := .F.
lNew 	 := .f.
lCalcust := .f.

cData:=dtoc(getmv("MV_ULTCONS"))
//if MsgBox ("Deseja calcular o consumo dos ultimos 3 meses ? ultimo calculo em "+cData,"Escolha","YESNO")
//   Processa( {|| CalCons() } )
//   Select SX6
//   Seek xFilial()+"MV_ULTCONS"
//   if rlock()
//	x6_conteud := dtoc(dDataBase)
//   endif
//endif

cData1:=dtoc(getmv("MV_ULTCOMP"))
if MsgBox ("Deseja calcular o a ultima compra por produto ? ultimo calculo em "+cData1,"Escolha","YESNO")
	GetMv("MV_ULTCOMP")
	PUTMV("MV_ULTCOMP", dtoc(dDataBase) )
	Processa( {|| CalComp() } )
	U_CALCUST()
	lCalcust := .t.
	//	Select SX6
	//	Seek xFilial()+""
	//	RecLock("SX6",.f.)
	//	x6_conteud := dtoc(dDataBase)
	//	MsUnLock()
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas Selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas p/ Parametros :                         ³
//³                                                              ³
//³ mv_par01  // Data de                                         ³
//³ mv_par02  // Data ate                                        ³
//³ mv_par03  // Produto de                                      ³
//³ mv_par04  // Produto ate                                     ³
//³ mv_par05  // Fornecedor de                                   ³
//³ mv_par06  // Fornecedor ate                                  ³
//³ mv_par07  // Analitico / Sintetico                           ³
//³ mv_par08  // Natureza   de                                   ³
//³ mv_par09  // Natureza   ate                                  ³
//³ mv_par10  // Digitacao / Emissao                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte("COM005", .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Retindex("SD1")
Retindex("SD2")
Retindex("SA1")
Retindex("SA2")
Retindex("SB1")
Retindex("SB2")
Retindex("SB3")
Retindex("SF1")
Retindex("SF4")


wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,NIL,Tamanho)

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

Processa( {|| RunProc() } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a ordem do arquivo.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)

Return Nil


****************************
Static Function RunProc()   // Impressao do Relatorio
****************************
aCampos := {}
AADD(aCampos,{ "PER"     , "C",04,0})
AADD(aCampos,{ "COD"     , "C",15,0})
//AADD(aCampos,{ "GRUPO"   , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",50,0})
AADD(aCampos,{ "UM"      , "C",02,0})
AADD(aCampos,{ "TP"      , "C",02,0})
AADD(aCampos,{ "FORNECE" , "C",30,0})
AADD(aCampos,{ "ULTCOM"  , "C",10,0})
AADD(aCampos,{ "ULTQTD"  , "N",12,3})
AADD(aCampos,{ "CONS_MES", "N",12,2})
AADD(aCampos,{ "COMPRAS_M", "N",12,2})  // Compras no mês atual (dDataBase)
AADD(aCampos,{ "STDCIPI" , "N",12,4})
AADD(aCampos,{ "STDSIMP" , "N",12,4})
AADD(aCampos,{ "MEDCIPI" , "N",12,4}) // Custo medio com IPI
AADD(aCampos,{ "MEDSIMP" , "N",12,4}) // Custo Medio sem Impostos
AADD(aCampos,{ "ULTVALBRU", "N",12,4}) //Ult valor bruto
AADD(aCampos,{ "ULTVALSIM", "N",12,4})//Ult Valor sem Ipi
AADD(aCampos,{ "ULTVALIPI", "N",12,4})//Ult Valor com Ipi
AADD(aCampos,{ "ULTCUST" , "N",12,4})
AADD(aCampos,{ "ATUCIPI" , "N",12,4}) // Custo Atualizado com ICMs e IPI (o IPI é calculado sobre valor + ICMS)
AADD(aCampos,{ "ATUSIMP" , "N",12,4}) // Custo Atualizado sem Impostos
AADD(aCampos,{ "SIMULAD" , "N",12,4})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Select SB1
dbSetOrder(1)
ProcRegua(reccount())
dbGoTop()
Do while !eof()
	IncProc()
	if left(B1_COD,5)='7.002' //.or. b1_cod='19.119' .or. b1_cod='19.117'
		x:=1
	endif
	if left(B1_COD,6)='19.018' //.or. b1_cod='19.119' .or. b1_cod='19.117'
		x:=1
	endif
	if !b1_tipo$"MP*RV" .or. b1_sitprod='OB'
		skip
		loop
	endif
	if b1_tipo$"RV" .AND. b1_locpad$'01*CB'
		skip
		loop
	endif
	if b1_tipo="RV" .and. left(sb1->b1_prodpai,6) <> left(sb1->b1_cod,6)
		RecLock("SB1",.f.)
		sb1->b1_prodpai := left(sb1->b1_cod,6)
		MsunLock()
	endif
	if b1_prodpai<>b1_cod //.and. !'*'$b1_prodpai
		skip
		loop
	endif
	nPonto1 := at(".",b1_cod)
	cParte1 := left(b1_cod,nPonto1)
	cParte2 := substr(b1_cod,nPonto1+1,10)
	if at(".",cParte2)<>0
		cParte3 := left(cParte2,at(".",cParte2)-1)
	else
		cParte3 := cParte2
	endif
	cGrupo	:= cParte1 + cParte3
	Select SA2
	DbSetOrder(1)
	Seek xFilial()+sb1->(b1_proc+b1_lojproc)
	cForn := ' '
	if !eof()
		cForn := sa2->a2_nreduz
	endif
	Select trb
	if !'*'$sb1->b1_prodpai .OR. 1<>2
		//		Seek xFilial()+sb1->b1_prodpai
		cProdPai := sb1->b1_prodpai
	else
		//		Seek xFilial()+left(sb1->b1_prodpai,at('*',sb1->b1_prodpai-1))
		cProdPai := left(sb1->b1_prodpai,at('*',sb1->b1_prodpai)-1)
		nCount := len(cProdPai)
		cProdPai := cProdPai+space(15-nCount)
	endif
	Select SB3
	DbSetOrder(1)
	Seek xFilial()+cprodpai
	Select SB2
	dbSetOrder(1)
	//	Seek xFilial()+sb1->b1_prodpai+"02"
	Seek xFilial()+cProdPai+"02"
	if eof()
		//		Seek xFilial()+sb1->b1_prodpai+"  "
		Seek xFilial()+cProdPai+"  "
	endif
	nCompras := 0
	do while !eof() .and. trim(cProdPai)=left(b2_cod,len(trim(cProdPai)))
		nCompras += sb2->b2_cmfim5
		skip
	enddo
	Select SB2
	DbSetOrder(1)
	Seek xFilial()+cProdPai+sb1->b1_locpad
	if eof()
		Seek xFilial()+cProdPai
	else
		// Atualiza ultimos custos quando prod pai = "*"
		cmedcipi	:= sb2->b2_cmff2
		cmedsimp 	:= sb2->b2_cmff4
		cultcust	:= SB1->B1_UPRCSIM
		Select SB2
		dbSetOrder(1)
		Seek xFilial()+sb1->b1_cod+"02"
		if !eof()
			RecLock("SB2",.f.)
			sb2->b2_cmff2 := cmedcipi
			sb2->b2_cmff4 := cmedsimp
			SB2->B2_CMFF5 := cultcust
			MsUnLock()
		endif
		Select SB1
		nReg := recno()
		seek xFilial()+cProdPai
		cultvalbru 	:= SB1->B1_UPRC
		cultvalsim 	:= SB1->B1_UPRCSIM
		cultvalIPI 	:= SB1->B1_XUPRCSI
		goto nReg
		recLock("SB1",.F.)
		SB1->B1_UPRC    := cultvalbru
		//		SB1->B1_UPRCSIM := cultvalsim
		//		SB1->B1_XUPRCSI := cultvalipi
		msunlock()
	endif
	Select TRB
	RecLock("TRB",.t.)
	trb->cod	:= sb1->b1_cod // sb1->b1_prodpai
	//		trb->grupo	:= cGrupo
	trb->desc	:= sb1->b1_desc
	trb->um		:= sb1->b1_um
	trb->tp		:= sb1->b1_tipo
	trb->fornece	:= cForn
	trb->COMPRAS_M  := nCompras
	trb->cons_mes	:= SB3->B3_TOTAL/3
	trb->stdcipi 	:= SB1->B1_CUSTD3
	trb->stdsimp	:= SB1->B1_CUSTD
	trb->medcipi	:= sb2->b2_cmff2
	trb->medsimp 	:= sb2->b2_cmff4
	trb->ultvalbru 	:= SB1->B1_UPRC
	trb->ultvalsim 	:= SB1->B1_UPRCSIM
	trb->ultvalIPI 	:= SB1->B1_XUPRCSI
	trb->ultcust	:= SB2->B2_CMFF5
	if SB1->B1_UCOM <> ctod("0")
		trb->ATUCIPI	:= iif(medcipi>ultvalipi,medcipi,ultvalipi)
		trb->atusimp 	:= iif(medsimp>ultvalsim,medsimp,ultvalsim)
	else
		trb->ATUCIPI	:= SB1->B1_CUSTD3
		trb->atusimp 	:= SB1->B1_CUSTD
	endif
	if trb->ATUCIPI = 0  // Buscar o custo std caso não encontre custo anterior
		trb->ATUCIPI:= SB1->B1_CUSTD3
	endif
	if trb->atusimp = 0  // Buscar o custo std caso não encontre custo anterior
		trb->atusimp 	:= SB1->B1_CUSTD
	endif
	trb->simulad	:= SB1->B1_CUSTSIM
	trb->ultcom 	:= dtoc(SB1->B1_UCOM)
	trb->ultqtd 	:= SB1->B1_ULTQTD
	if ddatabase==lastday(ddatabase)
		trb->per	 	:= substr(dtos(ddatabase),3,4)
	endif
	MsunLock()
	Select SB1
	skip
Enddo

Select TRB
copy to \gerencia\stdXreal
Set filter to
Relat001()  // Gera Excel diretamente do Protheus

//MsgBox("Arquivo gravado (abrir com o Excel) : m:\gerencia\STDXREAL","Atencao","ALERT")

if ddatabase=lastday(ddatabase)
	cArq := "\gerencia\std"+substr(dtos(ddatabase),3,4)//+".dbf"
	copy to &cArq
endif
use
*************************
Static Function Calcomp()
*************************

// Mudança no cálculo em 06/02/2021

dFimCM := lastday(firstday(dDataBase)-1)
dIniCM := firstday(firstday(firstday(dFimCM)-1)-1)

cQuery := " SELECT D1_FILIAL,D1_COD,D1_SERIE,D1_DOC,D1_FORNECE,D1_LOJA,D1_DTDIGIT,D1_TES,"
cQuery += " D1_QUANT,D1_TOTAL,D1_VALIPI,D1_VALICM,B1_PRODPAI "
cQuery += " FROM SD1010
cQuery += " INNER JOIN SF4010 ON D1_TES=F4_CODIGO "
cQuery += " INNER JOIN SB1010 ON D1_COD=B1_COD	  "
cQuery += " WHERE "
cQuery += " F4_DUPLIC='S' AND D1_TES<>'035' AND D1_TES<>'040' AND D1_TES<>'016' AND "
cQuery += " D1_DTDIGIT>='"+dtos(dIniCM)+"' AND "
cQuery += " D1_DTDIGIT<='"+dtos(dFimCM)+"' AND "
cQuery += " SD1010.D_E_L_E_T_ <>'*' AND "
cQuery += " SB1010.D_E_L_E_T_ <>'*' AND "
cQuery += " SF4010.D_E_L_E_T_ <>'*' "
cQuery += " ORDER BY B1_PRODPAI,D1_DTDIGIT,D1_DOC,D1_COD "

cQuery := ChangeQuery(cQuery)
IF SELECT("TMP1") # 0
	TMP1->(DBCLOSEAREA( ))
ENDIF

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
dbgotop()

ProcRegua(reccount())
dbgotop()
Do while !eof() // Media dos ultimos 3 meses cheios para custo medio
	IncProc("Custo Medio "+tmp1->D1_COD)//"entre "+dtoc(dIniCM)+" e "+dtoc(dFimCM))
	nValCst := nQuant := nValSNota := 0
	dDtDigit := ctod("0")
	cForn := cLoja := ""
	cProd := tmp1->B1_ProdPai
	Do while !eof() .and. tmp1->B1_ProdPai = cProd
		if left(tmp1->B1_ProdPai,6)='17.001'
			x:=1
		endif
//		nValCST += D1_TOTAL-D1_VALICM
//		nQuant  += D1_QUANT
		cforn	:= D1_FORNECE+D1_LOJA
		if D1_TES='200'
			nValSNota += D1_TOTAL
		Endif
		
		// Verifica última nota fiscal
		Select tmp1
		cDoc := D1_DTDIGIT+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
		nVal := nValS := nValIPI :=  nQtd := nCm := nCmS := nCmI := 0
		cForn := cLoja := ""
		if D1_TES<>'016' .and. stod(D1_DTDIGIT)>=dDTDIGIT
			cDoc := D1_DOC
			do while !eof() .and. d1_doc = cDoc .and. B1_ProdPai = cProd 
		//		if B1_ProdPai = cProd
		//Verificar Frete
				Select SF8
				dbSetOrder(2)
				Seek TMP1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
				nValFrete=0
				if !eof()
					Select SD1
					dbSetOrder(1)
					Seek xFilial()+SF8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)+TMP1->D1_COD
					nValFrete := SD1->D1_TOTAL
				Endif
				if nValFrete=0 // Caso entre diretamente na Nota Fiscal
					Select SF1
					dbSetOrder(1)
					Seek TMP1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
					nValFrete := (sf1->f1_frete/sf1->f1_valmerc)*tmp1->d1_total
				Endif
				Select Tmp1
		//final Verificação Frete

				nValCST += D1_TOTAL-D1_VALICM+nValFrete
				nVal  += d1_total+nValFrete
				nValS += (d1_total - d1_valicm)+nValFrete
				nValIPI += (d1_total + d1_valipi)+nValFrete
				nQuant  += D1_QUANT
				nQtd  += d1_quant
				dDtDigit := stod(d1_dtdigit)
				cforn := D1_FORNECE
				cLoja := D1_LOJA
//				Endif
				Skip
			enddo
		else
			nValCST += D1_TOTAL-D1_VALICM
			nQuant  += D1_QUANT
			Select Tmp1
			skip
		endif
	Enddo
	nValTot := nValCST/nQuant
	
	if nQtd<>0
		nCm  := nVal/nQtd
		nCmS := nValS/nQtd
		nCmI := nValIpi/nQtd
	Endif
	
	Select SB2
	seek xFilial()+cProd+'02'
	if eof()
		seek xFilial()+cProd+' '
	endif
	if eof()
		reclock("SB2",.t.)
		SB2->B2_FILIAL 	:= '01'
		SB2->B2_COD 	:= cProd
		SB2->B2_LOCAL	:= '02'
		MsUnLock()
	endif
	if !eof()
		reclock("SB2",.F.)
		if nValCst <> 0
			sb2->b2_cmff2 := 0//iif(nQtdCm<>0,nValCm2/nQtdCM,nValCSTSI)  // Custo Medio com IPI
			sb2->b2_cmff3 := 0//iif(nQtdCm<>0,(nValCm1+nValIPI)/nQtdCM,nValCst)  // Valor Bruto com IPI
			sb2->b2_cmff4 := nValCst/nQuant   // Custo Medio sem Impostos
		else
			sb2->b2_cmff2 := 0
			sb2->b2_cmff3 := 0//iif(nQtdCom1<>0,nCstIpi/nQtdCom1,0)  // Ultimo Custo
			sb2->b2_cmff4 := 0//iif(nQtdCom1<>0,nCst/nQtdCom1,0)  // Ultimo Custo
		endif
		//		sb2->b2_cmff5 := nUltCust  // Ultimo Custo
		MsUnLock()
	endif
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+cProd
	
	if !eof()
		RecLock("SB1",.f.)
		
		sb1->b1_ucom    := dDtDigit // data da última compra
		sb1->b1_uprc    := nCm  // Valor da última compra
		sb1->b1_uprcsim := nCmS  // Valor da última compra sem impostos
		sb1->b1_xuprcsi := nCmI //iif(nValUnitipi>0,nValUnitipi,iif(nQtdCom<>0,nCstipi/nQtdCom,0)) // Valor da última compra com IPI
		sb1->b1_ultqtd  := nQtd // Quantidade da última compra
		//			sb1->b1_ultunit := nValCom // Valor unitário da última compra
		sb1->b1_proc    := cForn  // Fornecedor da última compra
		sb1->b1_lojproc := cLoja
		
		if sb1->b1_custsim=0
			sb1->b1_custsim := nCmS
		endif
		if SB1->B1_UCOM <> ctod("0")
			sb1->b1_cstatu	:= iif(sb2->b2_cmff4>SB1->B1_UPRCSIM,sb2->b2_cmff4,SB1->B1_UPRCSIM)   // Sem Ipi
			sb1->b1_cstatu2	:= iif(sb2->b2_cmff2>SB1->B1_XUPRCSI,sb2->b2_cmff2,SB1->B1_XUPRCSI) // Com IPI
		else
			sb1->b1_cstatu	:= SB1->B1_CUSTD
			sb1->b1_cstatu2	:= SB1->B1_CUSTD3
		endif
		MsUnLock()
	Endif
	Select Tmp1
	//	skip
Enddo

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
Do while !eof() .and. d3_DtDigit<=dFim
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
		reclock("SB3",.f.)
		sb3->b3_total := sb3->b3_total + sd3->d3_quant
	endif
	msunlock()
	Select SD3
	skip
Enddo



Static Function RELAT001()  // Função para gerar planilha em Excel

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

oReport := TReport():New(cNome,"Std X Produtos",cNome,{|oReport| ReportPrint(oReport)},"Relatório Compras")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1:= TRSection():New(oReport, "Std", {"TRB"}, , .F., .T.)

TRCell():New( oSection1, "PER"    	 ,"TRB", "Periodo","@!",08)
TRCell():New( oSection1, "COD"	     ,"TRB", "Cód.Prod.","@!",15)
TRCell():New( oSection1, "DESC"	     ,"TRB", "Descrição ","@!",40)
TRCell():New( oSection1, "UM"	     ,"TRB", "UM ","@!",02)
TRCell():New( oSection1, "TP"	     ,"TRB", "Tipo ","@!",02)
TRCell():New( oSection1, "FORNECE"   ,"TRB", "Fornecedor","@!",30)
TRCell():New( oSection1, "ULTCOM"    ,"TRB", "Dt.ult.Compra","@!",10)
TRCell():New( oSection1, "ULTQTD" 	 ,"TRB", "Qtd.Ult.Compra","@E 999,999,999.99",15)
TRCell():New( oSection1, "CONS_MES"  ,"TRB", "Consumo Mês","@E 999,999,999.99",15)
TRCell():New( oSection1, "COMPRAS_M" ,"TRB", "Compras Mês Atual","@E 999,999,999.99",15)
TRCell():New( oSection1, "STDCIPI" 	 ,"TRB", "Std c/IPI","@E 9,999,999.9999",15)
TRCell():New( oSection1, "STDSIMP" 	 ,"TRB", "Std s/Imp","@E 9,999,999.9999",15)
TRCell():New( oSection1, "MEDCIPI" 	 ,"TRB", "Med c/IPI","@E 9,999,999.9999",15)
TRCell():New( oSection1, "MEDSIMP" 	 ,"TRB", "Med s/Imp","@E 9,999,999.9999",15)
TRCell():New( oSection1, "ULTVALBRU" ,"TRB", "Últ.Val.Bruto","@E 9,999,999.9999",15)
TRCell():New( oSection1, "ULTVALSIM" ,"TRB", "Últ.Val.s/Imp","@E 9,999,999.9999",15)
TRCell():New( oSection1, "ULTVALIPI" ,"TRB", "Últ.Val.c/IPI","@E 9,999,999.9999",15)
//TRCell():New( oSection1, "ULTCUST"   ,"TRB", "Últ.Custo","@E 9,999,999.9999",15)
TRCell():New( oSection1, "ATUCIPI" 	 ,"TRB", "Atu c/IPI","@E 9,999,999.9999",15)
TRCell():New( oSection1, "ATUSIMP" 	 ,"TRB", "Atu s/Imp","@E 9,999,999.9999",15)
TRCell():New( oSection1, "SIMULAD" 	 ,"TRB", "Sim s/Imp","@E 9,999,999.9999",15)

IF file("\gerencia\estruturas.dtc")
	
	dbUseArea( .T.,,"\gerencia\estruturas", "ESTRUT", Nil, .F. )
	oSection2:= TRSection():New(oReport, "Estruturas", {"ESTRUT"}, , .F., .T.)
	
	TRCell():New( oSection2,"COD"   	,'ESTRUT',"COD"     ,'@!',15)
	TRCell():New( oSection2,"COMP"    	,'ESTRUT',"COMP"    ,'@!',15)
	TRCell():New( oSection2,"DESC"    	,'ESTRUT',"DESC"    ,'@!',40)
	TRCell():New( oSection2,"TP"      	,'ESTRUT',"TP"      ,'@!',2)
	TRCell():New( oSection2,"QTD"     	,'ESTRUT',"QTD"     ,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"PERDA"   	,'ESTRUT',"PERDA"   ,'@E 999,999,999.99',15)
	TRCell():New( oSection2,"UM"      	,'ESTRUT',"UM"      ,'@!',15)
	TRCell():New( oSection2,"SIT"     	,'ESTRUT',"SIT"     ,'@!',15)
	TRCell():New( oSection2,"NIV"     	,'ESTRUT',"NIV"     ,'@E 999,999,999.99',15)
	TRCell():New( oSection2,"VALSTD"	,'ESTRUT',"VALSTD"	,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"STD"		,'ESTRUT',"STD"		,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"MED"		,'ESTRUT',"MED"		,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"ULTCUST" 	,'ESTRUT',"ULTCUST" ,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"ATU" 		,'ESTRUT',"ATU" 	,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"SIMULAD" 	,'ESTRUT',"SIMULAD" ,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"FORNECE" 	,'ESTRUT',"FORNECE" ,'@!',15)
	TRCell():New( oSection2,"ULTCOM"  	,'ESTRUT',"ULTCOM"  ,'@!',15)
	TRCell():New( oSection2,"ULTQTD"  	,'ESTRUT',"ULTQTD"  ,'@E 999,999,999.99',15)
	TRCell():New( oSection2,"ORDEM"   	,'ESTRUT',"ORDEM"   ,'@!',15)
	TRCell():New( oSection2,"OK"      	,'ESTRUT',"OK"      ,'@!',15)
	TRCell():New( oSection2,"STD1"		,'ESTRUT',"STD1"	,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"MED1"		,'ESTRUT',"MED1"	,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"ULT1"		,'ESTRUT',"ULT1"	,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"ATU1" 		,'ESTRUT',"ATU1" 	,'@E 99,999.99999999',15)
	TRCell():New( oSection2,"GRUPO"   	,'ESTRUT',"GRUPO"   ,'@!',15)
	TRCell():New( oSection2,"CODPAI"  	,'ESTRUT',"CODPAI" ,'@!',15)
	
Endif

TRFunction():New(oSection1:Cell("FORNECE"),NIL,"COUNT",,,,,.F.,.T.)

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
		//		oSection1:Cell("DULTVEN"):SetValue(dtoc(SC5->C5_EMISSAO))
		oSection1:Cell("PER"):SetValue(TRB->PER)
		oSection1:Cell("COD"):SetValue(TRB->COD)
		oSection1:Cell("DESC"):SetValue(TRB->DESC)
		oSection1:Cell("UM"):SetValue(TRB->UM)
		oSection1:Cell("TP"):SetValue(TRB->TP)
		oSection1:Cell("FORNECE"):SetValue(TRB->FORNECE)
		oSection1:Cell("ULTCOM"):SetValue(TRB->ULTCOM)
		oSection1:Cell("ULTQTD"):SetValue(TRB->ULTQTD)
		oSection1:Cell("CONS_MES"):SetValue(TRB->CONS_MES)
		oSection1:Cell("COMPRAS_M"):SetValue(TRB->COMPRAS_M)
		oSection1:Cell("STDCIPI"):SetValue(TRB->STDCIPI)
		oSection1:Cell("STDSIMP"):SetValue(TRB->STDSIMP)
		oSection1:Cell("MEDCIPI"):SetValue(TRB->MEDCIPI)
		oSection1:Cell("MEDSIMP"):SetValue(TRB->MEDSIMP)
		oSection1:Cell("ULTVALBRU"):SetValue(TRB->ULTVALBRU)
		oSection1:Cell("ULTVALSIM"):SetValue(TRB->ULTVALSIM)
		oSection1:Cell("ULTVALIPI"):SetValue(TRB->ULTVALIPI)
//		oSection1:Cell("ULTCUST"):SetValue(TRB->ULTCUST)
		oSection1:Cell("ATUCIPI"):SetValue(TRB->ATUCIPI)
		oSection1:Cell("ATUSIMP"):SetValue(TRB->ATUSIMP)
		oSection1:Cell("SIMULAD"):SetValue(TRB->SIMULAD)
		oSection1:Printline()
		TRB->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo

IF file("\gerencia\estruturas.dtc")
	
	dbSelectArea("ESTRUT")
	ESTRUT->(dbGoTop())
	
	oReport:SetMeter(ESTRUT->(LastRec()))
	
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
		
		//inicializo a primeira seção
		oSection2:Init()
		
		oReport:IncMeter()
		
		dbSelectArea("ESTRUT")
		
		IncProc("Imprimindo ")
		
		Do while !eof()
			oReport:IncMeter()
			
			//imprimo a primeira seção
			//		oSection1:Cell("DULTVEN"):SetValue(dtoc(SC5->C5_EMISSAO))
			
			oSection2:Cell("COD"):SetValue(ESTRUT->COD)
			oSection2:Cell("COMP"):SetValue(ESTRUT->COMP)
			oSection2:Cell("DESC"):SetValue(ESTRUT->DESC)
			oSection2:Cell("TP"):SetValue(ESTRUT->TP)
			oSection2:Cell("QTD"):SetValue(ESTRUT->QTD)
			oSection2:Cell("PERDA"):SetValue(ESTRUT->PERDA)
			oSection2:Cell("UM"):SetValue(ESTRUT->UM)
			oSection2:Cell("SIT"):SetValue(ESTRUT->SIT)
			oSection2:Cell("NIV"):SetValue(ESTRUT->NIV)
			oSection2:Cell("VALSTD"):SetValue(ESTRUT->VALSTD)
			oSection2:Cell("STD"):SetValue(ESTRUT->STD)
			oSection2:Cell("MED"):SetValue(ESTRUT->MED)
			oSection2:Cell("ULTCUST"):SetValue(ESTRUT->ULTCUST)
			oSection2:Cell("ATU"):SetValue(ESTRUT->ATU)
			oSection2:Cell("SIMULAD"):SetValue(ESTRUT->SIMULAD)
			oSection2:Cell("FORNECE"):SetValue(ESTRUT->FORNECE)
			oSection2:Cell("ULTCOM"):SetValue(ESTRUT->ULTCOM)
			oSection2:Cell("ULTQTD"):SetValue(ESTRUT->ULTQTD)
			oSection2:Cell("ORDEM"):SetValue(ESTRUT->ORDEM)
			oSection2:Cell("OK"):SetValue(ESTRUT->OK)
			oSection2:Cell("STD1"):SetValue(ESTRUT->STD1)
			oSection2:Cell("MED1"):SetValue(ESTRUT->MED1)
			oSection2:Cell("ULT1"):SetValue(ESTRUT->ULT1)
			oSection2:Cell("ATU1"):SetValue(ESTRUT->ATU1)
			oSection2:Cell("GRUPO"):SetValue(ESTRUT->GRUPO)
			oSection2:Cell("CODPAI"):SetValue(ESTRUT->CODPAI)
			oSection2:Printline()
			ESTRUT->(dbSkip())
		Enddo
		
		//finalizo a segunda seção
	Enddo
	Select Estrut
	Use
	
Endif

oSection2:Finish()
oSection1:Finish()

Return
