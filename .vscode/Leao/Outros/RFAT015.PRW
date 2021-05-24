#include "rwmake.ch"

User Function RFAT015()        // Posicao de Vendas com Margem

public nQtde,dEmissao,nAcresc,nVerbAdic,cObs
aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Vendas por Margem"
cDesc2   := ""
cDesc3   := ""
cPerg    := "RFT015"
cString  := "SC5"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT015"
titulo   := "Posicao de Vendas (Margem)"
wnrel    := "RFAT015"
limite   := 132
tamanho  := "M"
nValPed  := 0
nMgStd := nCustoSt1 := nIpi1 :=0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Periodo de                                      ³
//³ mv_par02  // Periodo ate                                     ³
//³ mv_par03  // Vendedor de                                     ³
//³ mv_par04  // Vendedor ate                                    ³
//³ mv_par05  // % de acrescimo da margem                        ³
//³ mv_par06  // Tipo de Relatorio                               ³
//³ mv_par07  // Cliente de        				 ³
//³ mv_par08  // Cliente Ate                                     ³
//³ mv_par09  // Tipo de Relatorio                               ³
//³ mv_par10  // Resumo por Produto				 ³
//³ mv_par11  // Resumo por Cliente                              ³
//³ mv_par12  // Resumo por Vendedor                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Obs mv_par05 - refere-se a gordura a ser embutida na margem (seguran‡a)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !Pergunte(cPerg,.T.)
	Return
endif

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
IF SELECT("TRBPRN") # 0
	TRBPRN->(DBCLOSEAREA( ))
ENDIF
IF SELECT("TRBPR1") # 0
	TRBPR1->(DBCLOSEAREA( ))
ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})
Processa( {|| C030Imp() } )

MS_FLUSH()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C030Imp  ³ Autor ³ Luiz Eduardo          ³ Data ³ 10/12/2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C030Imp                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico p/ Espelhos Leao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> Function C030Imp
Static Function C030Imp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "ITEM"    , "C",02,0})
AADD(aCampos,{ "CODCLI"  , "C",06,0})
AADD(aCampos,{ "LOJA"    , "C",02,0})
AADD(aCampos,{ "CLI"     , "C",30,0})
AADD(aCampos,{ "NREDUZ"  , "C",20,0})
AADD(aCampos,{ "VEND"    , "C",06,0})
AADD(aCampos,{ "COOR"    , "C",06,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",30,0})
AADD(aCampos,{ "QTDE"    , "N",12,2})
AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "ENTREGA" , "D",08,0})
AADD(aCampos,{ "VALBRUT" , "N",12,2})
AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "CUSTOSTD", "N",12,2})
AADD(aCampos,{ "MGSTD"   , "N",12,2})
AADD(aCampos,{ "PERCSTD" , "N",12,4})
AADD(aCampos,{ "MGREAL"  , "N",12,2})
AADD(aCampos,{ "PERCREAL"    , "N",12,4})

AADD(aCampos,{ "CUSTOATU"  , "N",12,2})
AADD(aCampos,{ "MGATU"   , "N",12,2})
AADD(aCampos,{ "PERCATU" , "N",12,4})
AADD(aCampos,{ "CUSTOSIM"  , "N",12,2})
AADD(aCampos,{ "MGSIMUL" , "N",12,2})
AADD(aCampos,{ "PERCSIM" , "N",12,4})

AADD(aCampos,{ "ACRESC"  , "N",06,4})
AADD(aCampos,{ "VERBADIC", "N",08,4})
AADD(aCampos,{ "VALMERC" , "N",12,2})
AADD(aCampos,{ "VALIPI"  , "N",12,2})
AADD(aCampos,{ "VALADIC" , "N",12,2})
AADD(aCampos,{ "VALCPMF" , "N",12,2})
AADD(aCampos,{ "VALICMS" , "N",12,2})
AADD(aCampos,{ "VALICMST", "N",12,2})
AADD(aCampos,{ "VALPC"   , "N",12,2})
AADD(aCampos,{ "VALIR"   , "N",12,2})
AADD(aCampos,{ "VALCOM"  , "N",12,2})
AADD(aCampos,{ "VALCOM2" , "N",12,2})
AADD(aCampos,{ "VALFIN"  , "N",12,2})
AADD(aCampos,{ "VALFRET" , "N",12,2})
AADD(aCampos,{ "DESCZFR" , "N",12,2})
AADD(aCampos,{ "PERCCOM" , "N",12,2})
AADD(aCampos,{ "TP"      , "C",01,0})
AADD(aCampos,{ "FRETE"   , "C",01,0})
AADD(aCampos,{ "EST"     , "C",02,0})
AADD(aCampos,{ "TES"     , "C",03,0})
AADD(aCampos,{ "CONDPAG" , "C",10,0})
AADD(aCampos,{ "TPVEND"  , "C",01,0})
AADD(aCampos,{ "ALIQICM" , "N",08,2})
AADD(aCampos,{ "ALIQIPI" , "N",08,2})
AADD(aCampos,{ "NCM"     , "C",15,0})
AADD(aCampos,{ "CNPJ"    , "C",15,0})
AADD(aCampos,{ "PEDORI"  , "C",06,0})
AADD(aCampos,{ "RM1"     , "N",12,2})
AADD(aCampos,{ "RM2"     , "N",12,2})
AADD(aCampos,{ "RM3"     , "N",12,2})
AADD(aCampos,{ "VENDCAD" , "C",06,0})
AADD(aCampos,{ "OK"      , "C",02,0})
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Select SC5
dbSetOrder(2)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off
cTrb1 := Criatrab(nil,.f.)
Copy to &cTrb1 next 1000000 for c5_emissao<=mv_par02 .and. c5_tipo$"N*C" .and.;
c5_cliente>=mv_par07 .and. c5_cliente<=mv_par08
dbUseArea( .T.,, cTrb1,"TRB1", .F., .F. )
nMgStd := nCustoSt1 :=0 

Select TRB1
ProcRegua(reccount())
go top
Do while !eof()
	IncProc()
	Select SUA
	dbSetOrder(8)
	seek xFilial()+trb1->c5_num
	Do while !eof() .and. trb1->c5_numtmk<>sua->ua_num
		skip
	enddo
	Select trb1
	if rlock()
		replace trb1->c5_fator with sua->ua_setor
		replace trb1->c5_condpag with sua->UA_CONDPG
	endif
	nFator :=1
	do Case
		Case trb1->c5_fator == "A"
			nFator := 2
		Case trb1->c5_fator == "B"
			nFator := 5
		Case trb1->c5_fator == "C"
			nFator := 1
		Case trb1->c5_fator == "S"
			nFator := 0
	Endcase
	_cTpFrete := trb1->c5_tpfrete
	select SA1
	dbSetOrder(1)
	seek xFilial()+trb1->c5_cliente+trb1->c5_lojacli
	select SA2
	dbSetOrder(1)
	seek xFilial()+trb1->c5_cliente+trb1->c5_lojacli
	
	Select TRB1
	if trb1->c5_emissao<mv_par01 .or. trb1->c5_emissao>mv_par02
		Skip
		loop
	Endif
	if trb1->c5_vend1<mv_par03 .or. trb1->c5_vend1>mv_par04
		Skip
		loop
	Endif
	cPedOri := " "
	if left(trb1->c5_num,1)=="-"
		Select SC5
		dbSetOrder(5)
		Seek xFilial()+trb1->c5_numtmk
		Do while !eof() .and. sc5->c5_numtmk==trb1->c5_numtmk
			if left(sc5->c5_num,1)#"-"
				cPedOri := sc5->c5_num
			endif
			skip
		Enddo
	Endif
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+trb1->c5_num
	nTotLiq := nTotCust := nTotMg := nValPed := nTAtu := nValMDO := 0
	do while !eof() .and. trb1->c5_num==sc6->c6_num
		nValPed := nValPed + sc6->c6_valor
		if left(sc6->c6_blq,1)=="R" .and. sc6->c6_qtdent=0 // Residuo do Pedido Eliminado
			skip
			loop
		endif
		Select SF4
		dbSetOrder(1)
		Seek xFilial()+sc6->C6_Tes
		cTpVend := "S"
		if sf4->f4_duplic=="N" .or. sc5->c5_tipo$'D*I'  // Somente Venda
			cTpVend := "N"
		endif
		Select SC6
		if sf4->f4_duplic=="N"
			if rlock()
				SC6->C6_MARGEM  := 0
				SC6->C6_MARGEMV := 0
			endif
			Skip
			loop
		endif
		cCod1    := left(sc6->c6_produto,at(".",sc6->c6_produto)-1) //4)
		cDescPrd := cPosIPI := " "
		nPerIpi  := 0
		cCod	:= sc6->c6_produto
		nPonto	:= at(".",cCod)
		cCod	:= left(cCod,nPonto-1)
		cCod1	:= sc6->c6_produto
		cCodProd:= sc6->c6_produto
		
		if left(sc6->c6_produto,2)=="00" .and. substr(sc6->c6_produto,3,1)#"."
			Select SB1
			dbSetOrder(1)
			Seek xFilial()+sc6->c6_produto
			cDescPrd := sb1->b1_desc
			cPosIpi  := sb1->b1_posipi
			nPerIpi  := sb1->b1_ipi
			if left(b1_codbar,1)=='2'
				cCod     := left(sb1->b1_codbar,7)
				cCodProd := left(sb1->b1_codbar,7)
				cCod1    := left(sc6->c6_produto,7)
			else
				//         cCod := "1"+substr(sc6->c6_produto,2,3)
				cCodProd := "1"+substr(sc6->c6_produto,2,14)
				cCod := left(sc6->c6_produto,at(".",sc6->c6_produto)-1)
			endif
		else
			cCod     := left(sc6->c6_produto,at(".",sc6->c6_produto)-1)
			cCodProd := sc6->c6_produto
			cCod1    := cCod
		endif
		if left(sc6->c6_produto,2)=="28" .or. left(sc6->c6_produto,2)=="29"
			cCod := sc6->c6_produto
			cCod1:= cCod
		endif
		Select SB5
		Seek xFilial()+"2902.CH"
		nVidroSt:= sb5->b5_prv7
		nVidroMg:= sb5->b5_margem
		Seek xFilial()+left(cCodProd,7)+" "
		if eof()
			Seek xFilial()+cCod
		endif
		if val(trb1->c5_pedexp)<=1   // Percentual de MP e MDO utilizados (RM)
			nVar := nVar1 := 1
		else
			if sm0->m0_codigo=="02"
				nVar  := 1-val(substr(trb1->c5_pedexp,11,5))/10000
				nVar1 := 1-val(substr(trb1->c5_pedexp,16,5))/10000
			else
				nVar := val(substr(trb1->c5_pedexp,11,5))/10000
				nVar1:= val(substr(trb1->c5_pedexp,16,5))/10000
			endif
		endif
		nCStd := sb5->b5_prv7
		nMarg := sb5->b5_margem
		nCAtu := sb5->b5_cstatu
		nCSim := sb5->b5_custsim
		verStd()
		nCStd_1:= nCStd
		nMarg_1:= nMarg
		nCStd  := nCStd*nVar
		nMarg  := nMarg*nVar
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+trb1->c5_vend1
		cSuper := iif(val(trb1->c5_super)==0,sa3->a3_super,trb1->c5_super)
		Seek xFilial()+cSuper
		nComS := sa3->a3_comis
		Seek xFilial()+trb1->c5_vend1
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCodProd
		if cDescPrd == " "
			cDescPrd := sb1->b1_desc
			cPosIpi  := sb1->b1_posipi
			nPerIpi  := sb1->b1_ipi
		endif
		nValLiq := nVCpmf := nIcms1 := nIcm   := nIpi1 := nIcmST   := 0
		nCom1   := nCom2  := nFin1  := nFrete := nIr   := nValAdic := 0
		nPC     := nTotZFR:= 0
		nVlPed  := iif(trim(sc6->c6_blq)#"R",SC6->C6_VALOR,(SC6->C6_VALOR/SC6->C6_QTDVEN*SC6->C6_QTDENT))
		nQtdEnt := iif(trim(sc6->c6_blq)#"R",SC6->C6_QTDVEN,SC6->C6_QTDENT)
		nCStd1 := nCStd2 := nCStd3 := 0
		if sm0->m0_codigo=="02"
			Select SG1
			dbSetOrder(1)
			Seek xFilial()+left(sc6->c6_produto,4)+space(11)+"19"
			nCStd1:= ((nVidroSt*sg1->g1_quant*nQtdEnt)*.2+(nVidroMg*sg1->g1_quant*nQtdEnt)*.6)*1.15
			nCStd2:= (sb5->b5_vidro*nQtdEnt/0.82)+(sb5->b5_vidro*nQtdEnt/0.88)*0.05
			nCStd3:= ((nCStd_1*nQtdEnt*.2)+(nMarg_1*nQtdEnt*.2))*1.15
			nCStd := nCStd1+nCStd2+nCStd3
		endif
		if sc6->c6_tes$'512*543*559'
			if sc6->c6_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
				nAliqZF := 0.1065
			else
				nAliqZF := 0.07
			endif
			if nFator#0
				nTotZFR := (nVlPed/nfator)*nAliqZF
				//         nVlPed  := nVlPed -nTotZFR // Luiz alterei em 27/05/2015
			endif
		endif
//		CalcVLiq()
// Declaracao das Variaveis
// nFator  (n,1)    - Fator de reducao
// nValPed (n,12,2) - Valor do Pedido
// cCod1   (c,6)    - Grupo de Produtos
// cCod    (c,15)   - Codigo do Produto                      

// cCli (c,8) - Cliente + Loja
// cTes (c,3) - TES
// cCondpg (c,3) - Cond. Pagamento
// cTipoNF (C,1) - trb1->c5_tipo Verifica se é devolução, complemento,...
// cDoc (c,3) - Tipo Ped/Fat/Cal
		nValLiq :=0           
		nQtde 	:=nQtdEnt 
		cObs := "Pedido"
		dEmissao := trb1->C5_EMISSAO
		cItem := sc6->c6_item
		nAcresc   := mv_par05
		nVerbAdic := sa1->a1_mgextra
//		u_CalcImp("PED")
		u_CalcVLiq(Alltrim(trb1->c5_fator),nVlPed,cCod1,cCod,trb1->c5_cliente+trb1->c5_lojacli,sc6->c6_TES,trb1->C5_CONDPAG,trb1->c5_tipo,trb1->c5_vend1,"PED",cItem,cSuper)
		Select TRB
		Reclock("TRB",.t.)
		trb->num    := trb1->c5_num
		trb->item   := sc6->c6_item
		trb->cod    := cCod1   // left(cCodProd,4)
		trb->desc   := cDescPrd
		trb->codcli := trb1->c5_cliente+trb1->c5_lojacli
		trb->cli    := iif(trb1->c5_tipo$"B*D",sa2->a2_nome,sa1->a1_nome)
		trb->nreduz := iif(trb1->c5_tipo$"B*D",sa2->a2_nreduz,sa1->a1_nreduz)
		trb->vend   := trb1->c5_vend1
		trb->coor   := cSuper
		trb->qtde   := nQtdEnt
		trb->entrega:= sc6->c6_entreg
		trb->emissao:= trb1->C5_EMISSAO
		trb->valliq := nValLiq
		trb->valbrut:= nVlPed
		trb->CUSTOSTD := iif(sm0->m0_codigo#"02",nCstd * nQtdEnt,nCstd)
		trb->MGSTD:= nMarg * nQtdEnt
		//   trb->MGSTD:= iif(left(cCod,4)=="2700",nVlPed,nMarg * nQtdEnt)
		trb->percstd  := (trb->mgstd/trb->CUSTOSTD)*100
		trb->mgreal := (nValLiq-trb->CUSTOSTD)/(1+(mv_par05)/100)
		//     trb->perc   := (trb->mgreal/trb->MGSTD)*100
		trb->percReal   := (trb->mgreal/trb->CUSTOSTD)*100
		
		trb->CUSTOATU := nCAtu * nQtdEnt
		trb->mgatu  := (nValLiq-trb->CUSTOATU)/(1+(mv_par05/100))
		if (trb->mgatu/trb->CUSTOSTD)*100<100000
			//		trb->percatu:= (trb->mgatu/trb->MGSTD)*100
//			trb->percatu:= (trb->mgatu/trb->MGSTD)*100
			trb->percatu:= (trb->mgatu/trb->CUSTOATU)*100
		endif
		
		trb->CUSTOSIM := nCSim * nQtdEnt
		trb->mgsimul:= (nValLiq-trb->CUSTOSIM)/(1+(mv_par05/100))
		trb->percsim:= (trb->mgsimul/trb->CUSTOSIM)*100
		
		
		trb->acresc := mv_par05
		trb->verbadic:= sa1->a1_mgextra
		trb->valadic:= nValAdic
//		trb->valmerc:= if(nFator#0,(nVlPed-nTotZFR)/nFator,0)
		trb->valmerc:= if(nFator#0,(nVlPed)/nFator,0)
		trb->valcpmf:= nVCpmf
		if trb1->c5_fator#"S" .and. !"536*541"$sc6->c6_tes
			trb->valicms := nIcms1
			trb->valicmst:= nIcmST
			trb->valipi  := nIpi1
			trb->valpc   := nPC
			trb->valir   := nIr
		endif
		trb->valcom := nCom1
		trb->perccom:= trb1->c5_comis1
		trb->valcom2:= nCom2
		trb->valfin := nFin1
		trb->valfret:= nFrete
		trb->desczfr:= nTotZFR
		trb->tp     := trb1->c5_fator
		trb->frete  := trb1->c5_tpfrete
		trb->est    := iif(trb1->c5_tipo$"B*D",sa2->a2_est,sa1->a1_est)
		trb->tes    := sc6->c6_tes
		trb->tpvend := cTpVend
		trb->condpag:= se4->e4_descri
		trb->aliqicm:= nIcm
		trb->aliqipi:= nperIpi
		trb->ncm    := cPosIpi
		trb->cnpj   := sa1->a1_cgc
		trb->pedori := cPedOri
		trb->rm1    := ncStd1
		trb->rm2    := ncStd2
		trb->rm3    := ncStd3
		trb->vendcad:= sa1->a1_vend
		msunlock()
		
		nTotLiq  := nTotLiq + nValLiq
		nTotCust := nTotCust+ trb->CUSTOSTD
		nTotMg   := nTotMg  + (nMarg * nQtdEnt)
		nMgStd   += trb->MgStd 
		nCustoSt1+= trb->CustoStd
		nTAtu 	 += (sb5->b5_cstatu*SC6->C6_QTDVEN)
		Select SC6
		if rlock()
//			if trb->MGSTD#0
			if dtos(trb1->c5_emissao)<'20150101'
				nValMg := trb->MGSTD
			else
				nValMg := trb->CUSTOSTD
			endif         
			nMgAtu := nValLiq-(sb5->b5_cstatu*SC6->C6_QTDVEN)
			if (sb5->b5_cstatu*SC6->C6_QTDVEN)<>0 .and. nMgAtu>0 .and. nMgAtu/(sb5->b5_cstatu*SC6->C6_QTDVEN)*100<990
					SC6->C6_MARGATU  := nMgAtu/(sb5->b5_cstatu*SC6->C6_QTDVEN)*100
			endif
			if nValMg #0
				// Atencao - no calculo da margem esta embutido um acrescimo de 5% (gordura)
//		trb->perc   := (trb->mgreal/trb->CUSTOSTD)*100

//				nMg := (((nValLiq-trb->CUSTOSTD)/1.05)/(nMarg * nQtdEnt))*100
//				if nMg>(-100) .and. nMg<999.99
				if trb->percreal>(-100) .and. trb->percreal<999.99
					SC6->C6_MARGEM  := trb->percReal //nMg
					SC6->C6_MARGEMV := trb->mgreal// /1.05
				endif
			else
				SC6->C6_MARGEM  := 0
				SC6->C6_MARGEMV := 0
			endif
		endif
		Skip
	enddo
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+trb1->c5_num
	nMgReal := nCustoStd := 0
	do while !eof() .and. sc6->c6_num=trb1->c5_num
		nMgReal   += SC6->C6_MARGEMV
		skip
	enddo
	
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+trb1->c5_num
	
	if nTotMg#0
		nMg := nMgReal/nTotCust //((nTotLiq-nTotCust)/(nTotMg))*100
		if nMg>(-100) .and. nMg<999.99
			if rlock()
				Replace C5_MARGEM  With nMg*100
				Replace C5_MARGEMV With nMgReal //(nTotLiq-nTotCust)
				nMgAtu := nTotLiq-nTAtu
				if (nMgatu/nTAtu)*100<1000
					Replace C5_MARGATU with (nMgatu/nTAtu)*100
				endif
				if nCustoSt1<>0
					Replace C5_MARGSTD With (nMgstd/nCUSTOST1)*100
					nMgstd := 0                              
					nCUSTOST1 := 0
				endif
			endif
		endif
	else    
		if rlock()
			Replace C5_MARGEM  With 0
			Replace C5_MARGEMV With 0
		endif
	Endif
	if rlock()
		Replace C5_VALPED  With nValPed
	endif
	
	Select TRB1
	Skip
Enddo

VerDevol()   // Tratamento de devolucoes de Nota Fiscal

if mv_par06#1 .or. mv_par09#1
	
	aCampos := {}
	AADD(aCampos,{ "CLI"     , "C",08,0})
	AADD(aCampos,{ "NOME"    , "C",40,0})
	AADD(aCampos,{ "NREDUZ"  , "C",20,0})
	AADD(aCampos,{ "EST"     , "C",02,0})
	AADD(aCampos,{ "VEND"    , "C",06,0})
	AADD(aCampos,{ "COOR"    , "C",06,0})
	AADD(aCampos,{ "META"    , "N",12,2})
	AADD(aCampos,{ "VLBRUT"  , "N",12,2})
	AADD(aCampos,{ "CUSTOSTD", "N",12,2})
	AADD(aCampos,{ "MGSTD"   , "N",12,2})
	AADD(aCampos,{ "PERCSTD" , "N",12,4})
	AADD(aCampos,{ "MGREAL"  , "N",12,2})
	AADD(aCampos,{ "PERCREAL"    , "N",12,4})
	AADD(aCampos,{ "PESO"    , "N",10,4})
	cTempPrn := CriaTrab(nil,.f.)
	dbCreate(cTempPrn,aCampos)
	dbUseArea( .T.,,cTempPrn,"TRBPRN", Nil, .F. )
	
	aCamposx := {}
	AADD(aCamposx,{ "VEND"    , "C",06,0})
	AADD(aCamposx,{ "META"    , "N",12,2})
	cTempPr1 := CriaTrab(nil,.f.)
	dbCreate(cTempPr1,aCamposx)
	dbUseArea( .T.,,cTempPr1,"TRBPR1", Nil, .F. )
	Index on Vend to &cTempPr1
	
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
	RptStatus({|| Imprime() })
	Select TRBPRN
	Use
	Select TRBPR1
	Use
endif

Select TRB
dbGoTop()
nQtd := nVal1 := nVal2 := nVal3 := nVal4 := nVal5 := nVal5 := 0
Do while !eof()
	if tes$"541*542"
		nQtd += Qtde
		nVal1+= ValBrut
		nVal2+= ValLiq
		nVal3+= CUSTOSTD
		nVal4+= MGSTD
		nVal5+= MgReal
	endif
	skip
Enddo

Processa( {|| GArq() } )   // Gera arquivos por Cliente / Vendedor / Produto

Select TRB

do case
	case sm0->m0_codigo=="01"
		copy to \gerencia\mgvdle.dbf
		MsgBox ("Arquivo gerado com sucesso \system\mgvd-le.dbf","Informa‡Æo","INFO")
		if file("mgvdarm.dbf")
			if rlock()
				appe blan
				trb->Qtde := -nQtd
				trb->ValBrut:= -nVal1
				trb->ValLiq := -nVal2
				trb->CUSTOSTD := -nVal3
				trb->MGSTD:= -nVal4
				trb->MgReal := -nVal5
			endif
			appe from mgvdarm
			copy to \gerencia\mgvdtot
			MsgBox ("Arquivo gerado com sucesso \system\mgvdatt.dbf","Informa‡Æo","INFO")
		endif
	case sm0->m0_codigo=="02"
		copy to \gerencia\mgvdrm
		MsgBox ("Arquivo gerado com sucesso \system\mgvdarm.dbf","Informa‡Æo","INFO")
endcase

Select TRB
Use
Select TRB1
Use
Select SC5
Return

**************************
Static Function CalcVLiq()
**************************
// Declaracao das Variaveis
// nFator  (n,1)    - Fator de reducao
// nValPed (n,12,2) - Valor do Pedido
// cTpVend (c,2)    - Venda ou Nao (S/N)
// cCod1   (c,6)    - Grupo de Produtos
// cCod    (c,15)   - Codigo do Produto

// 1   - Carrega Variaveis
// 1.1 - Tipo do Pedido - nFator
nFator := 0
do Case
	Case Alltrim(trb1->c5_fator) == "A"
		nFator := 2
	Case Alltrim(trb1->c5_fator) == "B"
		nFator := 5
	Case Alltrim(trb1->c5_fator) == "C"
		nFator := 1
	Case Alltrim(trb1->c5_fator) == "S"
		nFator := 0
Endcase

// 1.2 - Dados do Cliente/fornecedor

select SA1
dbSetOrder(1)
seek xFilial()+trb1->(c5_cliente+c5_lojacli)
select SA2
dbSetOrder(1)
seek xFilial()+trb1->(c5_cliente+c5_lojacli)

// 1.3 - Dados do TES

Select SF4
dbSetOrder(1)
Seek xFilial()+sc6->C6_Tes
cTpVend := "S"
if sf4->f4_duplic=="N" .or. trb1->c5_tipo$'D*I'
	cTpVend := "N"
	Return
endif

// 1.4 - Dados do item do pedido

Select SA3
dbSetOrder(1)
Seek xFilial()+trb1->c5_vend1
cSuper := sa3->a3_super
Seek xFilial()+sa3->a3_super
nComS := sa3->a3_comis
Seek xFilial()+trb1->c5_vend1
Select SB1
dbSetOrder(1)
//Seek xFilial()+cCod1
Seek xFilial()+sc6->c6_produto

if sf4->f4_ipi=="N"
	nIpi := 0
else
	nIpi := sb1->b1_ipi
endif

Select SUB
dbsetOrder(3)
seek xFilial()+sc6->(c6_num+c6_item)
Do while !eof() .and. sc6->(c6_num+c6_item)=SUB->(UB_NUMPV+UB_ITEMPV) .and. sub->ub_num<>trb1->C5_NUMTMK
	skip
Enddo
nValLiq := nVCpmf := nIcms1 := nIcm   := nIpi1 := 0
nCom1   := nCom2  := nFin1  := nIr    := nValAdic :=  0
nPC     := nTotZFR:= 0
nVlPed  := SUB->UB_VRUNIT*SUB->UB_QUANT
nQtdEnt := SUB->UB_QUANT
if sub->ub_tes$'512*543*559'
	if sub->ub_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
		nAliqZF := 0.1065
	else
		nAliqZF := 0.07
	endif
	if nFator#0
		nTotZFR := (nVlPed/nfator)*nAliqZF
		nVlPed  := SC6->C6_VALOR*nFator // nVlPed-nTotZFR  // Luiz - 27/05/2015
	endif
endif

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial()+sc6->C6_TES)
dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial()+"MV_PCI")
if sf4->f4_cstpis <>"06"
	nPCI  := Val(Alltrim(SX6->X6_CONTEUD))
else
	nPCI := 0
endif
dbSeek(xFilial()+"MV_CPMF")
nCPMF := Val(Alltrim(SX6->X6_CONTEUD))

// 1 - Calcula precentual do ICMS

dbSelectArea("SA1")
dbSeek(xFilial()+SC6->C6_CLI+SC6->C6_LOJA)
Do Case
	Case SA1->A1_EST $ "AC/AL/AM/AP/BA/CE/DF/ES/GO/MA/MS/MT/PA/PE/PB/PI/SE/RN/RO/RR/TO"
		nIcm := 7
	Case SA1->A1_EST $ "RJ/MG/PR/SC/RS"
		nIcm := 12
	Case SA1->A1_EST == "SP"
		nIcm := 18
	Otherwise
		nIcm := 18
EndCase
nBase := nVlPed
if trb1->C5_TIPOCLI == "F" .OR. (LEN(TRIM(SA1->A1_CGC))>=9 .AND. LEN(TRIM(SA1->A1_CGC))<=11)
	//	nBase:= nVlPed*(1+(nIpi)/100)
	nBase:= nVlPed
	nIcm := 18
endif
if sf4->f4_codigo$'536*541*512*543*559'
	nBase:= 0
	nIcm := 0
endif
if sc6->c6_tes$'538*518'
	nBase:= nVlPed*(1+(nIpi)/100)
	nIcm := 18
endif

// final 1 - Calcula precentual do ICMS (nBase,nIcm)

// 2 - Calcula PIS/Cofins/IR e deducoes Zona Franca

nZFR := 0
* Verifica PIS/Cofins/IR
if sc6->c6_num='061319'
	x:=1
endif
if sf4->f4_piscof#"4"
	nTotNf  := (nVlPed+nTotZFR)/nFator //-nTotZfr
	nPC     := (nTotNf * nPCI)/100
	//	nIR     := ((nVlPed+nTotZFR) * 2.88)/100
	nIR     := ((nTotnf+nTotZFR) * 2.88)/100
	if nTotZFR<>0
		nTotNf  := (nVlPed)/nFator-nTotZFR //-nTotZfr
		nPC     := (nTotNf * nPCI)/100
		nIR     := (nTotnf * 2.88)/100
		nVlPed	:= nVlPed-nTotZFR
	endif
	if left(sa1->a1_codmun,5)=="00255" .and. sub->ub_tes$'512*543*559' // Zona Franca de Manaus
		nICM    := 0
		nIR     := (((nVlPed+nTotZFR)-(nVlPed+nTotZFR)*.1065) * 2.88)/100
		nVCpmf  := ((nVlPed-nTotNF*.1065) * nCpmf)/100
		nZFr    := nTotZFR
	else
		nVCpmf  := ((nVlPed * nCPMF)/100)
	endif
else
	if left(sa1->a1_codmun,5)=="00255" .and. sub->ub_tes$'512*543*559'  // Zona Franca de Manaus
		nTotNf  := (nVlPed+nTotZFR)/nFator //-nTotZFR
		nICM    := 0
		nIR     := ((ntotNF-nTotNF*.1065) * 2.88)/100
		nVCpmf  := ((nVlPed-nTotNF*.1065) * nCpmf)/100
		nZFr    := nTotZFR
	else
		nVCpmf  := ((nVlPed * nCPMF)/100)
	endif
endif

// final 2 - Calcula PIS/Cofins/IR e deducoes Zona Franca

// 3 - Calculo do valor de despesas com frete

Select SC5
dbsetOrder(1)
seek xFilial()+sc6->c6_num

nFrete := 0

nValNota := nVlPed
if year(sc5->c5_emissao)>=2014
	Do case
		Case sa1->a1_est$"BA*CE" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*0.10
			if sa1->a1_est="CE" .and. trim(sa1->a1_cod_mun)="12908"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C"//"SOBRAL"
				nFrete := nValNota*0.12
			endif
		Case sa1->a1_est$"MG" .and. trim(sa1->a1_cod_mun)="06200"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C" //"BELO HORIZONTE"
			nFrete := nValNota*0.06
		Case sa1->a1_est$"RJ"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"SANTOS*SAO VICENTE*GUARUJA*CARAGUATATUBA*UBATUBA" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"PRAIA GRANDE*CUBATAO*ITANHAEM*MONGAGUA*PERUIBE*SAO SEBASTIAO" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*0.065
		Case sa1->a1_est$"SP" .and. sa1->a1_cod_mun$"50308*05708*25003*18800" // SP / Barueri / Jandira / Guarulhos ;
			//		"SAO"$sa1->a1_mun .and. "PAULO"$sa1->a1_mun
			nFrete := 0
		Case sa1->a1_est$"RS" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*0.12
		Otherwise
			if Substr(Alltrim(_cTpFrete),1,1)=="C"
				nFrete := nValNota*0.15
			else
				nFrete := 0
			endif
	EndCase
Else
	Do case
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"CE"
			nFrete := nVlPed-nVlPed/1.10
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"BA*PE"
			nFrete := nVlPed-nVlPed/1.08
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"RJ"
			nFrete := nVlPed-nVlPed/1.065
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"SP"
			nFrete := nVlPed-nVlPed/1.03
		Otherwise
			if Substr(Alltrim(_cTpFrete),1,1)=="C"
				nFrete := nVlPed-nVlPed/1.15
			else
				nFrete := 0
			endif
	EndCase
Endif

// final 3 - Calculo do valor de despesas com frete

// 4 - Calculo do valor de despesas do financeiro

dbSelectArea("SE4")
dbSetOrder(1)
//dbSeek(xFilial()+sua->UA_CONDPG) //sc5->C5_CONDPAG)
dbSeek(xFilial()+trb1->C5_CONDPAG)
_cPagto := se4->e4_indefla

nValFin := 0
Do case
	Case _cPagto == "A"  // A Vista
		nValFin := 1.000
	Case _cPagto == "B"  // 14 dd
		nValFin := 1.015
	Case _cPagto == "C"  // 30 dd
		nValFin := 1.030
	Case _cPagto == "D"  // 45 dd
		nValFin := 1.045
	Case _cPagto == "E"  // 60 dd
		nValFin := 1.060
	Case _cPagto == "F"  // 75 dd
		nValFin := 1.075
	Case _cPagto == "G"  // 90 dd
		nValFin := 1.090
	Otherwise  // Outros
		nValFin := 1.000
EndCase

// final 4 - Calculo do valor de despesas do financeiro

// 5 - Calculo de comissoes

_cSetor := Alltrim(trb1->c5_fator)

nValComis := 0
If trb1->C5_COMIS1 > 0
	nValComis := ((nVlPed-nFrete)*(trb1->C5_COMIS1+nComS))/100
Endif

// final 5 - Calculo de comissoes


// Finalizando os calculos

IF _cSetor == "C"
	nipi1   := ((nVlPed * nIpi)/100)
	nIcms1  := ((nBase  * (nIcm))/100)
ElseIf _cSetor  == "B"
	nipi1   := ((nVlPed * nIpi)/100)*.20
	nIcms1  := ((nBase  * (nIcm))/100) *.20
ElseIf _cSetor  == "A"
	nipi1   := ((nVlPed * nIpi)/100) *.50
	nIcms1  := ((nBase  * (nIcm))/100) *.50
ElseIf _cSetor  == "S"
	nIcms1  := 0
	nIpi1   := 0
Endif


//nCom1   := ((((nVlPed-nZFr)-nFrete)*trb1->C5_COMIS1)/100)
//nCom2   := iif(nCom1#0,((((nVlPed-nZFr)-nFrete)*nComS)/100),0)
nCom1   := ((((nVlPed- nTotZFR)-nFrete)*trb1->C5_COMIS1)/100)
nCom2   := iif(nCom1#0,((((nVlPed- nTotZFR)-nFrete)*nComS)/100),0)
nValAdic:= (nVlPed-nZFr)*(sa1->a1_mgextra/100)

// Alterei a fórmula em 06-03-2014 antecipei o cálculo do financeiro
nFin1   := (nVlPed- nTotZFR+nIpi1)-((nVlPed- nTotZFR+nIpi1)/nValFin)
nValLiq := nVlPed - nIcms1 - nCom1 - nCom2 - nFrete - nValAdic - nPC - nIR - nVCpmf - nFin1 - nTotZFR //-nZfr
//nFin1   := nValliq-(nValliq/nValFin) //financeiro abate apos desconto dos impostos
//nValLiq := nValliq - nFin1

dbSelectArea("SC6")

Return

*************************
Static Function Imprime()
*************************

if mv_par06#1
	Cabec1 := "Codigo Vendedor        Coord.  Est         Meta    Val.Bruto   %Meta  Custo Std       MG Std.     MG Real   Perc        Peso      "
	012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec2 := "Período de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	Select TRB
	SetRegua(recCount())
	nTot := 0
	dbGoTop()
	Do while !eof()
		IncRegua()
		ntot := nTot + MGReal
		Skip
	Enddo
	index on Vend to &cTemp
	dbGotop()
	SetRegua(recCount())
	li := 80
	//nTot := 0
	Do while !eof()
		cVend  := trb->Vend
		cCoor  := trb->Coor
		nMGR   := nMGI := nVLB := nStd := 0
		Do while !eof() .and. trb->Vend==cVend
			IncRegua()
			nSTD := nSTD + trb->CUSTOSTD
			nMGR := nMGR + trb->MGReal
			nMGI := nMGI + trb->MGSTD
			nVLB := nVLB + trb->Valbrut
			skip
		Enddo
		Select TRBPRN
		if rlock()
			appe blan
			trbprn->Vend   := cVend
			trbprn->Coor   := cCoor
			trbprn->VlBrut := nVLB
			trbprn->CUSTOSTD := nStd
			trbprn->MGSTD:= nMGI
			trbprn->MgReal := nMGR
			if nStd<>0
				//		if MGSTD<>0
				//			trbprn->perc   := (mgreal/MGSTD)*100
				trbprn->percReal   := (mgreal/CUSTOSTD)*100
			endif
			//     trbprn->Perc   := iif(nMGI<>0,nMGR/nMGI*100,0)
			trbprn->Peso   := nMGR/nTot*100
		endif
		Select TRB
	Enddo
	lMeta := .f.
	if left(dtos(mv_par01),6)==left(dtos(mv_par02),6)
		lMeta := .t.
		Select SCT
		dbSetOrder(1)
		Seek xFilial()+substr(dtos(mv_par01),5,2)+left(dtos(mv_par01),4)
		Do while !eof() .and. substr(dtos(mv_par01),5,2)+left(dtos(mv_par01),4)==left(ct_doc,6)
			Select TRBPR1
			RecLock("TRBPR1",.T.)
			TRBPR1->Vend := sct->ct_vend
			TRBPR1->Meta := sct->ct_valor
			MsUnlock()
			Select SCT
			Skip
		Enddo
	endif
	
	Select TRBPRN
	Index on Vend to &cTempPrn
	Select TRBPR1
	dbGoTop()
	Do while !eof()
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+trbpr1->Vend
		Select TRBPRN
		Seek trbpr1->Vend
		if rlock() .and. eof() .and. trbpr1->Meta#0
			appe blan
			trbprn->Vend := trbpr1->Vend
			//		trbprn->Coor := sa3->a3_super
		endif
		Select TRBPR1
		skip
	Enddo
	Select TRBPRN
	Do Case
		Case mv_par06==2
			index on Peso*(-1) to &cTempPrn
		Case mv_par06==3
			index on PercReal*(-1) to &cTempPrn
	EndCase
	
	dbGoTop()
	nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		Select TRBPR1
		Seek trbprn->Vend
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+trbprn->Vend
		Select TRBPRN
		@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+"  "+sa3->a3_super+"  "+sa3->a3_est
		if lMeta
			@ li,038 PSAY trbpr1->Meta         picture "@E 99,999,999"
			@ li,050 PSAY VlBrut               picture "@E 99,999,999"
			if trbpr1->Meta#0
				@ li,062 PSAY VlBrut/trbpr1->Meta*100  picture "@E 999.99%"
			endif
		else
			@ li,050 PSAY VlBrut               picture "@E 99,999,999"
		endif
		@ li,070 PSAY CUSTOSTD  picture "@E 99,999,999"
		@ li,082 PSAY MGSTD picture "@E 99,999,999"
		@ li,094 PSAY MGReal  picture "@E 99,999,999"
		@ li,106 PSAY PercReal    picture "@E 999.99%"
		@ li,118 PSAY Peso    picture "@E 999.99%"
		nTot0 := nTot0 +CUSTOSTD
		nTot1 := nTot1 +VlBrut
		nTot2 := nTot2 +MGSTD
		nTot3 := nTot3 +MGReal
		nTot4 := nTot4 +PercReal
		nTot5 := nTot5 +Peso
		nTot6 := nTot6 +trbpr1->Meta
		skip
		li:=li+1
	Enddo
	li:=li+1
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	if lMeta
		@ li,038 PSAY nTot6 picture "@E 99,999,999"
		@ li,050 PSAY ntot1   picture "@E 99,999,999"
		if nTot6#0
			@ li,062 PSAY ntot1/ntot6*100  picture "@E 999.99%"
		endif
	else
		@ li,050 PSAY ntot1   picture "@E 99,999,999"
	endif
	@ li,070 PSAY ntot0   picture "@E 99,999,999"
	@ li,082 PSAY ntot2   picture "@E 99,999,999"
	@ li,094 PSAY nTot3   picture "@E 99,999,999"
	@ li,106 PSAY ntot3/ntot0*100  picture "@E 999.99%"
	@ li,118 PSAY ntot5   picture "@E 999.99%"
	li:=li+2
	
	index on Coor+Vend to &cTempPrn
	dbGoTop()
	nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		cCoor  := trbprn->Coor
		cVend  := " "
		nStd := nMGR   := nMGI := nVLB := nMet := 0
		Do while !eof() .and. trbprn->Coor==cCoor
			IncRegua()
			if cVend#trbprn->Vend
				Select TRBPR1
				Seek trbprn->Vend
				nMet := nMet + Meta
				Select TRBPRN
				cVend := Vend
			Endif
			nStd := nStd + trbprn->CUSTOSTD
			nMGR := nMGR + trbprn->MGReal
			nMGI := nMGI + trbprn->MGSTD
			nVLB := nVLB + trbprn->Vlbrut
			skip
		Enddo
//		nPerc   := nMGR/nMGI*100
		nPercReal   := nMGR/nStd*100
		nPeso   := nMGR/nTot*100
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+cCoor
		Select TRBPRN
		@ li,000 PSAY left(cCoor,3)+"-"+left(sa3->a3_nome,20)
		if lMeta
			@ li,038 PSAY nMet picture "@E 99,999,999"
			@ li,050 PSAY nVlB picture "@E 99,999,999"
			if nMet#0
				@ li,062 PSAY nVlB/nMet*100  picture "@E 999.99%"
			endif
		else
			@ li,050 PSAY nVlB picture "@E 99,999,999"
		endif
		@ li,070 PSAY nStd    picture "@E 99,999,999"
		@ li,082 PSAY nMGI    picture "@E 99,999,999"
		@ li,094 PSAY nMGR    picture "@E 99,999,999"
		@ li,106 PSAY nPercReal   picture "@E 999.99%"
		@ li,116 PSAY nPeso   picture "@E 999.99%"

		nTot0 := nTot0 +nStd
		nTot1 := nTot1 +nVlB
		nTot2 := nTot2 +nMGI
		nTot3 := nTot3 +nMGR
		nTot4 := nTot4 +nPercReal
		nTot5 := nTot5 +nPeso
		nTot6 := nTot6 +nMet
		li:=li+1
	Enddo
	
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,038 PSAY iif(ntot6#0,ntot6,0)  picture "@E 99,999,999"
	@ li,050 PSAY ntot1   picture "@E 99,999,999"
	@ li,062 PSAY iif(ntot6#0,nTot1/ntot6*100,0)  picture "@E 999.99%"
	@ li,070 PSAY ntot0   picture "@E 99,999,999"
	@ li,082 PSAY ntot2   picture "@E 99,999,999"
	@ li,094 PSAY nTot3   picture "@E 99,999,999"
	@ li,106 PSAY ntot3/ntot0*100  picture "@E 999.99%"
	@ li,116 PSAY ntot5   picture "@E 999.99%"
	
Endif

** Relatorio por cliente

if mv_par09#1
	Cabec1 := "Cliente Nome                                      Est     Val.Bruto   Custo Std    MG Std       MG Real     Perc     Peso"
	*          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	*          000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111
	Cabec2 := "Período de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	Select TRBPRN
	if reccount()#0
		use
		dbCreate(cTempPrn,aCampos)
		dbUseArea( .T.,,cTempPrn,"TRBPRN", Nil, .F. )
	endif
	Select TRB
	SetRegua(recCount())
	if nTot=0
		dbGoTop()
		Do while !eof()
			IncRegua()
			ntot := nTot + MGReal
			Skip
		Enddo
	Endif
	index on Cli  to &cTemp
	dbGotop()
	SetRegua(recCount())
	li := 80
	//nTot := 0 xxy
	Do while !eof()
		cCli   := trb->CodCli
		cNom   := trb->Cli
		cNomR  := trb->NReduz
		cEst   := trb->Est
		cVend  := trb->Vend
		cCoor  := trb->Coor
		nStd := nMGR   := nMGI := nVLB := 0
		Do while !eof() .and. trb->CodCli ==cCli
			IncRegua()
			nVLB := nVLB + trb->Valbrut
			nStd := nStd + trb->CUSTOSTD
			nMGI := nMGI + trb->MGSTD
			nMGR := nMGR + trb->MGReal
			skip
		Enddo
		Select TRBPRN
		if rlock()
			appe blan
			trbprn->Cli    := cCli
			trbprn->Nome   := cNom
			trbprn->NReduz := cNomR
			trbprn->Est    := cEst
			trbprn->Vend   := cVend
			trbprn->Coor   := cCoor
			trbprn->VlBrut := nVLB
			trbprn->MGSTD:= nMGI
			trbprn->MgReal := nMGR
			trbprn->CUSTOSTD := nStd
			if MGSTD<>0
				//trbprn->perc   := (mgreal/MGSTD)*100
				trbprn->percReal   := (mgreal/CUSTOSTD)*100
			endif
			//     trbprn->Perc   := iif(nMGI<>0,nMGR/nMGI*100,0)
			trbprn->Peso   := nMGR/nTot*100
		endif
		Select TRB
	Enddo
	
	cPrn1:= CriaTrab(nil,.f.)
	Select TRBPRN
	Do Case
		Case mv_par09==2
			index on Peso*(-1) to &cPrn1
		Case mv_par09==3
			index on PercReal*(-1) to &cPrn1
		Case mv_par09==4
			index on Nome to &cPrn1
	EndCase
	
	titulo   := "Posicao de Vendas (Margem Cli.)"
	
	dbGoTop()
	nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := 0
	Do while !eof()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		Select TRBPRN
		@ li,000 PSAY cli+"-"+Nome+"  "+Est
		@ li,058 PSAY VlBrut   picture "@E 99,999,999"
		@ li,070 PSAY CUSTOSTD picture "@E 99,999,999"
		@ li,082 PSAY MGSTD    picture "@E 99,999,999"
		@ li,094 PSAY MGReal   picture "@E 99,999,999"
		@ li,108 PSAY PercReal     picture "@E 999.99"
		@ li,118 PSAY Peso     picture "@E 999.99"
		nTot0 := nTot0 +CustoStd
		nTot1 := nTot1 +VlBrut
		nTot2 := nTot2 +MGSTD
		nTot3 := nTot3 +MGReal
		nTot4 := nTot4 +PercReal
		nTot5 := nTot5 +Peso
		skip
		li:=li+1
	Enddo
	li:=li+1
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,058 PSAY ntot1   picture "@E 99,999,999"
	@ li,070 PSAY ntot0   picture "@E 99,999,999"
	@ li,082 PSAY ntot2   picture "@E 99,999,999"
	@ li,094 PSAY nTot3   picture "@E 99,999,999"
	@ li,108 PSAY ntot3/ntot0*100  picture "@E 999.99"
	@ li,118 PSAY ntot5   picture "@E 999.99"
	li:=li+2
	
Endif

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

**************************
Static Function VerStd()
**************************
dFecStd := GetMV("MV_ULSTD")
If !empty(sc6->c6_datfat)
	cData := sc6->c6_datfat
else
	cData := trb1->C5_emissao
Endif
if cData>dFecStd
	Return
endif
nCStd := nMarg := nVidro := 0
Select SB9
dbSetOrder(1)
if len(trim(cCodProd))==7
	seek xFilial()+left(cCodProd,7)+space(10)
	Do while !eof() .and. left(cCodProd,7)==left(b9_cod,7) .and. b9_local==space(2)
		if trb1->C5_emissao<=b9_data
			nCStd := sb9->b9_custd
			nMarg := sb9->b9_margem
		endif
		skip
	Enddo
else
	seek xFilial()+left(cCodProd,4)+space(13)
	Do while !eof() .and. left(cCodProd,4)==left(b9_cod,4) .and. b9_local==space(2)
		if trb1->C5_emissao<=b9_data
			nCStd := sb9->b9_custd
			nMarg := sb9->b9_margem
		endif
		skip
	Enddo
endif
seek xFilial()+"2902.CH"+space(10)
Do while !eof() .and. left(b9_cod,7)=="2902.CH" .and. b9_local==space(2)
	if trb1->C5_emissao<=b9_data
		nVidroSt:= sb9->b9_custd
		nVidroMg:= sb9->b9_margem
	endif
	skip
Enddo

Return

****************************
Static Function GArq
****************************

Select TRB
ProcRegua(reccount())
nTotReal := 0
nTotQtde := 0
nTotValB := 0
nTotValL := 0
nTotStdL := 0
nTotMGId := 0
dbGoTop()
Do while !eof()
	IncProc()
	nTotReal += MGReal
	nTotQtde += Qtde
	nTotValB += ValBrut
	nTotValL += Valliq
	nTotStdL += CUSTOSTD
	nTotMGId += MGSTD
	Skip
Enddo

For n:=1 to 4   // Gerar os 4 arquivos
	
	aCampos := {}
	if n==1
		AADD(aCampos,{ "PRODUTO" , "C",15,0})
		AADD(aCampos,{ "DESC"    , "C",40,0})
	endif
	if n==2
		AADD(aCampos,{ "CLI"     , "C",08,0})
		AADD(aCampos,{ "NOME"    , "C",30,0})
		AADD(aCampos,{ "NREDUZ"  , "C",20,0})
		AADD(aCampos,{ "UF"      , "C",02,0})
		AADD(aCampos,{ "VEND"    , "C",06,0})
		AADD(aCampos,{ "NOMEV"   , "C",20,0})
		AADD(aCampos,{ "NOMEC"   , "C",20,0})
	endif
	if n==3
		AADD(aCampos,{ "VEND"    , "C",06,0})
		AADD(aCampos,{ "NOMEV"   , "C",20,0})
		AADD(aCampos,{ "NOMEC"   , "C",20,0})
		AADD(aCampos,{ "UF"      , "C",02,0})
	endif
	if n==4
		AADD(aCampos,{ "UF"      , "C",02,0})
		AADD(aCampos,{ "QTDCLI"  , "N",04,0})
	endif
	AADD(aCampos,{ "QTDE"    , "N",12,2})
	AADD(aCampos,{ "QTDEP"   , "N",10,5})
	AADD(aCampos,{ "VLBRUT"  , "N",12,2})
	AADD(aCampos,{ "VLBRUTP" , "N",08,4})
	AADD(aCampos,{ "VLLIQ"  , "N",12,2})
	AADD(aCampos,{ "VLLIQP" , "N",08,4})
	AADD(aCampos,{ "CUSTOSTD"  , "N",12,2})
	AADD(aCampos,{ "CUSTOSTDP" , "N",08,4})
	AADD(aCampos,{ "MGSTD" , "N",12,2})
	AADD(aCampos,{ "PERCSTD"    , "N",12,4})
	AADD(aCampos,{ "MGREAL"  , "N",12,2})
	AADD(aCampos,{ "PERCREAL"    , "N",12,4})
	
	AADD(aCampos,{ "CUSTOATU"  , "N",12,2})
	AADD(aCampos,{ "MGATU"   , "N",12,2})
	AADD(aCampos,{ "PERCATU" , "N",12,4})
	AADD(aCampos,{ "CUSTOSIM"  , "N",12,2})
	AADD(aCampos,{ "MGSIMUL" , "N",12,2})
	AADD(aCampos,{ "PERCSIM" , "N",12,4})
	
	//AADD(aCampos,{ "CHAVE"   , "C",25,0})
	cTempArq := CriaTrab(nil,.f.)
	dbCreate(cTempArq,aCampos)
	dbUseArea( .T.,,cTempArq,"TRBPR1", Nil, .F. )
	
	do case
		Case n==1 .and. mv_par10==1
			index on Produto to &cTempArq
		Case n==2 .and. mv_par11==1
			index on Nome to &cTempArq
		Case n==3 .and. mv_par12==1
			index on Vend to &cTempArq
		Case n==4 .and. mv_par12==1
			index on UF to &cTempArq
	EndCase
	
	Select TRB
	do case
		Case n==1 .and. mv_par10==1
			index on Cod  to &cTemp
		Case n==2 .and. mv_par11==1
			index on Cli  to &cTemp
		Case n==3 .and. mv_par12==1
			index on vend to &cTemp
		Case n==4 .and. mv_par12==1
			index on EST to &cTemp
	EndCase
	dbGotop()
	ProcRegua(reccount())
	li := 80
	//nTot := 0
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		Select TRB
		nMGR    := nMGI := nVLB := nQtd := nStd := 0
		nCUSTOATU	:= nMGAtu := nPercActu := nCUSTOSIM := nMgSimul := mPercSim := nValliq := 0
		
		cCoor  := ""       
		cChave := ""
		Do case
			Case n==1 .and. mv_par10==1
				if left(cod,1)=="0" .and. substr(cod,6,2)<"A"
					cCod := "1"+substr(Cod,2,3)
				else
					cCod := COD
				endif
				cChave := COD
				cVend  := VEND
				cCoor  := COOR
				Do while !eof() .and. trb->Cod==cChave
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nValliq := nValliq + trb->Valliq
					nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
					nMGAtu := nMGAtu + trb->MGAtu
					nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
					nMgSimul := nMgSimul + trb->MgSimul
					
					skip
				Enddo
			Case n==2 .and. mv_par11==1
				cChave := CODCLI
				cCli   := CLI
				cNReduz:= NREDUZ
				cVend  := VEND
				cEst   := EST
				cCoor  := COOR
				Do while !eof() .and. trb->CodCli==cChave
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nValliq := nValliq + trb->Valliq
					nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
					nMGAtu := nMGAtu + trb->MGAtu
					nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
					nMgSimul := nMgSimul + trb->MgSimul
					skip
				Enddo
			Case n==3 .and. mv_par12==1
				cChave := VEND
				cVend  := VEND
				cCoor  := COOR
				Do while !eof() .and. trb->Vend==cChave
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nValliq := nValliq + trb->Valliq
					nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
					nMGAtu := nMGAtu + trb->MGAtu
					nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
					nMgSimul := nMgSimul + trb->MgSimul
					skip
				Enddo
			Case n==4 .and. mv_par12==1
				cChave := Est
				cEst   := EST
				Do while !eof() .and. trb->Est==cChave
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nValliq := nValliq + trb->Valliq
					nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
					nMGAtu := nMGAtu + trb->MGAtu
					nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
					nMgSimul := nMgSimul + trb->MgSimul
					skip
				Enddo
			Otherwise
				skip
				loop
		EndCase
		
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+trim(cChave)
		
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+cvend
		cNomv := sa3->a3_nreduz
		cUf   := iif(n==2 .or. n==4,cEst,sa3->a3_est)
		Seek xFilial()+trim(cCoor)
		cSuper := sa3->a3_nreduz
		
		Select TRBPR1
		seek cCod
		if eof() .and. n==1 .and. rlock()
			appe blan
		endif
		if rlock()
			if n==1
				trbpr1->Produto:= cCod
				trbpr1->Desc   := sb1->b1_desc
			else
				appe blan
				if n==2
					trbpr1->Nome   := cCli
					trbpr1->NReduz := cNReduz
				endif
				trbpr1->Uf     := cUf
				if n<>4
					trbpr1->Vend   := cVend
					trbpr1->NomeV  := cNomV
					trbpr1->Nomec  := cSuper
				endif
			endif
			trbpr1->Qtde    += nQtd
			trbpr1->QtdeP   := Qtde/nTotQtde
			trbpr1->VlBrut  += nVLB
			trbpr1->VlBrutP := VLBrut/nTotValb
			trbpr1->VlLiq  += nValliq
			trbpr1->VlLiqP := VLliq/nTotVall
			trbpr1->CUSTOSTD  += nSTD
			trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
			trbpr1->MGSTD += nMGI
			if MGSTD<>0
				trbpr1->percstd   := (mgstd/CUSTOSTD)*100
			endif
			trbpr1->MgReal  += nMGR
			//	trbpr1->Perc    := iif(abs(MGReal)/nMGI*100<1000,MGReal/nMGI*100,0) // MGReal/nMGI*100
			if CUSTOSTD<>0
//				trbpr1->perc   := (mgreal/MGSTD)*100
				trbpr1->percReal   := (mgreal/CUSTOSTD)*100
			endif
			trbpr1->CUSTOATU += nCUSTOATU
			trbpr1->MGAtu  += nMGAtu
			trbpr1->CUSTOSIM += nCUSTOSIM
			trbpr1->MgSimul+= nMgSimul
			if MgSimul<>0
//				trbpr1->PercSim := (mgsimul/MGSTD)*100
				trbpr1->PercSim := (mgsimul/CUSTOSIM)*100
			endif
			if MgAtu<>0
//				trbpr1->PercAtu := (mgatu/MGSTD)*100
				trbpr1->PercAtu := (mgatu/CUSTOATU)*100
			endif
			
		endif
		nTot1 += nQtd
		nTot2 += nVLB
		nTot3 += nStd
		nTot4 += nMGI
		nTot5 += nMGR
		nTot6 += nValliq
		Select TRB
	Enddo
	Select TRBPR1
	dbGoTop()
	if rlock()
		appe blan
		trbpr1->Qtde    := nTot1
		trbpr1->QtdeP   := nTot1/nTotQtde
		trbpr1->VlBrut  := nTot2
		trbpr1->VlBrutP := VLBrut/nTotValb
		trbpr1->Vlliq   := nTot6
		trbpr1->VlliqP  := VLliq/nTotVall
		trbpr1->CUSTOSTD  := nTot3
		trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
		trbpr1->MGSTD := nTot4
		if MGSTD<>0
			trbpr1->percstd   := (mgstd/CUSTOSTD)*100
		endif
		trbpr1->MgReal  := nTot5
		if MGSTD<>0
//			trbpr1->perc   := (mgreal/MGSTD)*100
			trbpr1->percReal   := (mgreal/CUSTOSTD)*100
		endif
		//	trbpr1->Perc    := iif(abs(MGReal)/nTot4*100<1000,MGReal/nTot4*100,0) // MGReal/nTot4*100
	endif
	Do case
		Case n==1
			totaliza(1)
			copy to \gerencia\MGVDPRD
		Case n==2
			copy to \gerencia\MGVDCLI
		Case n==3
			copy to \gerencia\MGVDVEN
		Case n==4
			TotUf()
			copy to \gerencia\MGVDUF
	EndCase
	Use
	
Next N

*****************************
Static Function Totaliza(cTp)
*****************************
dbGoTop()
nRecTot := reccount()
Do while recno()<= nRecTot
	cQuebra := left(trbpr1->Produto,2)
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := 0
	Do while !eof() .and. left(trbpr1->Produto,2)==cQuebra
		nTot1 += trbpr1->Qtde
		nTot2 += trbpr1->VlBrut
		nTot3 += trbpr1->CUSTOSTD
		nTot4 += trbpr1->MGSTD
		nTot5 += trbpr1->MgReal
		nTot6 += trbpr1->Vlliq
		skip
	Enddo
	nRec := recno()
	if rlock() .and. cQuebra#space(2)
		appe blan
		trbpr1->Produto := trim(cquebra)+"= Total"
		trbpr1->Qtde    := nTot1
		trbpr1->QtdeP   := nTot1/nTotQtde
		trbpr1->VlBrut  := nTot2
		trbpr1->VlBrutP := VLBrut/nTotValb
		trbpr1->Vlliq   := nTot6
		trbpr1->VlliqP  := VLliq/nTotVall
		trbpr1->CUSTOSTD  := nTot3
		trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
		trbpr1->MGSTD := nTot4
		trbpr1->MgReal  := nTot5
		if MGSTD<>0
//			trbpr1->perc   := (mgreal/MGSTD)*100
			trbpr1->percReal   := (mgreal/CUSTOSTD)*100
		endif
		//		trbpr1->Perc    := iif(abs(MGReal)/nTot4*100<1000,MGReal/nTot4*100,0) // MGReal/nTot4*100
	Endif
	Goto nRec
Enddo

Return

*****************************
Static Function TotUF()
*****************************
Select TRB
ProcRegua(reccount())
li := 80
nTotCli := 0
dbGoTop()
Do while !eof()
	cUf  := Est
	nQtd := 0
	Do while !eof() .and. Est==cUf
		IncProc()
		cCli := codcli
		Do while !eof() .and. Codcli==cCli
			skip
		Enddo
		nQtd++
	Enddo
	Select TRBPR1
	Seek cUf
	if rlock()
		TRBPR1->qtdcli := nQtd
	endif
	Select TRB
Enddo
Select TRBPR1

Return

**************************
Static Function VerDevol()  // Tratamento de devolucoes de Nota Fiscal
**************************
Select SD1
dbSetOrder(6)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off
cTrb2 := Criatrab(nil,.f.)
Copy to &ctrb2 next 1000000 for d1_dtdigit<=mv_par02 .and. d1_tipo=="D" .and.;
d1_fornece>=mv_par07 .and. d1_fornece<=mv_par08

dbUseArea( .T.,, cTrb2,"TRB2", .F., .F. )
ProcRegua(reccount())
go top
Do while !eof()
	IncProc()
	Select SF4
	dbSetOrder(1)
	Seek xFilial()+trb2->d1_Tes
	if sf4->f4_duplic=="N"
		select trb2
		skip
		loop
	endif
	Select SD2
	dbSetOrder(3)
	Seek xFilial()+trb2->(d1_nfori+d1_seriori+d1_fornece+d1_loja+d1_cod)
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+sd2->(d2_pedido)
	do Case
		Case sc5->c5_fator == "A"
			nFator := 2
		Case sc5->c5_fator == "B"
			nFator := 5
		Case sc5->c5_fator == "C"
			nFator := 1
		Case sc5->c5_fator == "S"
			nFator := 0
	Endcase
	
	select SA1
	dbSetOrder(1)
	seek xFilial()+sc5->c5_cliente+sc5->c5_lojacli
	
	Select sc5
	if sc5->c5_vend1<mv_par03 .or. sc5->c5_vend1>mv_par04
		Skip
		loop
	Endif
	cTrbDev := Criatrab(nil,.f.)
	Copy to &cTrbDev next 1
	Select TRB1
	append from &cTrbDev
	erase &(trim(cTrbDev)+".dbf")
	cPedOri := " "
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+sd2->d2_pedido+sd2->d2_itempv
	nTotLiq := nTotCust := nTotMg := nValPed := nValMDO := nValAdic := 0
	do while !eof() .and. sd2->(d2_pedido+d2_itempv)==sc6->(c6_num+c6_item)
		if sc6->c6_produto<>trb2->d1_cod
			skip
			loop
		endif
		nValPed := nValPed + trb2->d1_total
		
		Select SF4
		dbSetOrder(1)
		Seek xFilial()+sc6->C6_Tes
		cTpVend := "S"
		if sf4->f4_duplic=="N" .or. sc5->c5_tipo$'D*I'  // Somente Venda
			cTpVend := "N"
		endif
		Select SC6
		if sf4->f4_duplic=="N"
			Skip
			loop
		endif
		cCod1    := left(sc6->c6_produto,4)
		cDescPrd := cPosIPI := " "
		nPerIpi  := 0
		cCod	:= sc6->c6_produto
		nPonto	:= at(".",cCod)
		cCod	:= left(cCod,nPonto-1)
		cCod1	:= sc6->c6_produto
		cCodProd:= sc6->c6_produto
		
		if left(sc6->c6_produto,2)=="00" .and. substr(sc6->c6_produto,3,1)#"."
			Select SB1
			dbSetOrder(1)
			Seek xFilial()+sc6->c6_produto
			cDescPrd := sb1->b1_desc
			cPosIpi  := sb1->b1_posipi
			nPerIpi  := sb1->b1_ipi
			if left(b1_codbar,1)=='2'
				cCod     := left(sb1->b1_codbar,7)
				cCodProd := left(sb1->b1_codbar,7)
				cCod1    := left(sc6->c6_produto,7)
			else
				//         cCod := "1"+substr(sc6->c6_produto,2,3)
				cCodProd := "1"+substr(sc6->c6_produto,2,14)
				cCod := left(sc6->c6_produto,at(".",sc6->c6_produto)-1)
			endif
		else
			cCod     := left(sc6->c6_produto,at(".",sc6->c6_produto)-1)
			cCodProd := sc6->c6_produto
			cCod1    := cCod
		endif
		if left(sc6->c6_produto,2)=="28" .or. left(sc6->c6_produto,2)=="29"
			cCod := sc6->c6_produto
			cCod1:= cCod
		endif
		Select SB5
		Seek xFilial()+"2902.CH"
		nVidroSt:= sb5->b5_prv7
		nVidroMg:= sb5->b5_margem
		Seek xFilial()+left(cCodProd,7)+" "
		if eof()
			Seek xFilial()+cCod
		endif
		nCStd := sb5->b5_prv7
		nMarg := sb5->b5_margem
		verStd()
		nCStd_1:= nCStd
		nMarg_1:= nMarg
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+sc5->c5_vend1
		cSuper := iif(val(sc5->c5_super)==0,sa3->a3_super,sc5->c5_super)
		Seek xFilial()+cSuper
		nComS := sa3->a3_comis
		Seek xFilial()+sc5->c5_vend1
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCodProd
		if cDescPrd == " "
			cDescPrd := sb1->b1_desc
			cPosIpi  := sb1->b1_posipi
			nPerIpi  := sb1->b1_ipi
		endif
		nValLiq := nVCpmf := nIcms1 := nIcm   := nIpi1 := nIcmST   := 0
		nCom1   := nCom2  := nFin1  := ne1:= nIr   := nValAdic := 0
		nPC     := nTotZFR:= nZfr   := 0
		nVlPed  := trb2->d1_quant*sc6->c6_prcven
		nQtdEnt := trb2->d1_quant
		nCStd1 := nCStd2 := nCStd3 := 0
		if sc6->c6_tes$'512*543*559'
			if sc6->c6_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
				nAliqZF := 0.1065
			else
				nAliqZF := 0.07
			endif
			if nFator#0
				nTotZFR := (nVlPed/nfator)*nAliqZF
				nVlPed  := nVlPed-nTotZFR
			endif
		endif
		CalcVLiq()
		select SA1
		dbSetOrder(1)
		seek xFilial()+sc5->c5_cliente+sc5->c5_lojacli
		Select TRB
		Reclock("TRB",.t.)
		trb->num    := sc5->c5_num
		trb->item   := "DV"
		trb->cod    := cCod1   // left(cCodProd,4)
		trb->desc   := cDescPrd
		trb->codcli := sc5->c5_cliente+sc5->c5_lojacli
		trb->cli    := iif(sc5->c5_tipo$"B*D",sa2->a2_nome,sa1->a1_nome)
		trb->nreduz := iif(sc5->c5_tipo$"B*D",sa2->a2_nreduz,sa1->a1_nreduz)
		trb->vend   := sc5->c5_vend1
		trb->coor   := cSuper
		trb->qtde   := nQtdEnt*(-1)
		trb->entrega:= sc6->c6_entreg
		trb->emissao:= sc5->C5_EMISSAO
		trb->valliq := nValLiq*(-1)
		trb->valbrut:= nVlPed*(-1)
		trb->CUSTOSTD := iif(sm0->m0_codigo#"02",nCstd * nQtdEnt,nCstd)*(-1)
		trb->MGSTD:= nMarg * nQtdEnt*(-1)
		trb->mgreal := (nValLiq+trb->CUSTOSTD)/(1+(mv_par05)/100)*(-1)
//		trb->perc   := (trb->mgreal/trb->MGSTD)*100
		trb->percReal   := (trb->mgreal/trb->CUSTOSTD)*100
		trb->acresc := mv_par05
		trb->verbadic:= sa1->a1_mgextra
		trb->valadic:= nValAdic*(-1)
//		trb->valmerc:= if(nFator#0,(nVlPed-nTotZFR)/nFator,0)*(-1)
		trb->valmerc:= if(nFator#0,(nVlPed)/nFator,0)*(-1)
		trb->valcpmf:= nVCpmf*(-1)
		if sc5->c5_fator#"S" .and. !"536*541"$sc6->c6_tes
			trb->valicms := sd2->d2_valicm*(-1)
			trb->valicmst:= sd2->d2_icmsret*(-1)
			trb->valipi  := sd2->d2_valipi*(-1)
			trb->valpc   := nPC*(-1)
			trb->valir   := nIr*(-1)
		endif
		trb->valcom := nCom1*(-1)
		trb->perccom:= sc5->c5_comis1
		trb->valcom2:= nCom2*(-1)
		trb->valfin := nFin1*(-1)
		trb->valfret:= nFrete*(-1)
		trb->desczfr:= nTotZFR*(-1)
		trb->tp     := sc5->c5_fator
		trb->frete  := sc5->c5_tpfrete
		trb->est    := iif(sc5->c5_tipo$"B*D",sa2->a2_est,sa1->a1_est)
		trb->tes    := sc6->c6_tes
		trb->tpvend := cTpVend
		trb->condpag:= se4->e4_descri
		trb->aliqicm:= nIcm
		trb->aliqipi:= nperIpi
		trb->ncm    := cPosIpi
		trb->cnpj   := sa1->a1_cgc
		trb->pedori := cPedOri
		msunlock()
		
		nTotLiq  := nTotLiq + nValLiq
		nTotCust := nTotCust+ trb->CUSTOSTD
		nTotMg   := nTotMg  + (nMarg * nQtdEnt)
		
		Select SC6
		Skip
	enddo
	Select TRB2
	Skip
Enddo
Select TRB2
copy to xtrb2
use
Return
