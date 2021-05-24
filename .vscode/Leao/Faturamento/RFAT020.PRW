#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "RWMAKE.CH"
#Include "TOTVS.CH"
//#include "rwmake.ch"

User Function RFAT020()        // Posicao de Vendas com Margem
// Versão excel em 16/12/2019

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
nomeprog := "RFAT020"
titulo   := "Posicao de Vendas (Margem)"
wnrel    := "RFAT020"
limite   := 132
tamanho  := "M"
nValPed  := 0
nMgStd := nCustoSt1 := nIpi1 :=0
aVend  := {}
aEst   := {}
aChave := {}
aCliEstV := {}
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
	TRBPRN->(DBCLOSEAREA( ))
ENDIF

cData1:=dtoc(getmv("MV_CALCATV"))
if MsgBox ("Deseja verificar status do cliente (ex.:ativo,inativo,... ? ultimo calculo em "+cData1,"Escolha","YESNO")
	Processa({|| u_VerAtiv() })
	Select SX6
	Seek xFilial()+"MV_CALCATV"
	reclock("SX6",.f.)
	x6_conteud := dtoc(dDataBase)
	MsUnLock()
Endif

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

Public cCod1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "ITEM"    , "C",02,0})
AADD(aCampos,{ "CODCLI"  , "C",06,0})
AADD(aCampos,{ "LOJA"    , "C",02,0})
AADD(aCampos,{ "GRPCLI"  , "C",08,0})
AADD(aCampos,{ "CLI"     , "C",30,0})
AADD(aCampos,{ "NREDUZ"  , "C",20,0})
AADD(aCampos,{ "RANK"    , "N",04,0})
AADD(aCampos,{ "VEND"    , "C",06,0})
AADD(aCampos,{ "COOR"    , "C",06,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",30,0})
AADD(aCampos,{ "QTDE"    , "N",12,2})
AADD(aCampos,{ "QTDEM2"  , "N",12,4})  //11- Quantidade Faturada
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
AADD(aCampos,{ "PERFRET" , "N",12,2})  //43-
AADD(aCampos,{ "EST"     , "C",02,0})
AADD(aCampos,{ "ESTGRP"  , "C",02,0})
AADD(aCampos,{ "TES"     , "C",03,0})
AADD(aCampos,{ "CONDPAG" , "C",10,0})
AADD(aCampos,{ "TPVEND"  , "C",01,0})
AADD(aCampos,{ "QTDE2"   , "N",12,2})
AADD(aCampos,{ "ALIQICM" , "N",08,2})
AADD(aCampos,{ "ALIQIPI" , "N",08,2})
AADD(aCampos,{ "NCM"     , "C",15,0})
AADD(aCampos,{ "CNPJ"    , "C",15,0})
AADD(aCampos,{ "PEDORI"  , "C",06,0})
AADD(aCampos,{ "RM1"     , "N",12,2})
AADD(aCampos,{ "RM2"     , "N",12,2})
AADD(aCampos,{ "RM3"     , "N",12,2})
AADD(aCampos,{ "OK"      , "C",02,0})
AADD(aCampos,{ "SEGMENTO", "C",10,0})
AADD(aCampos,{ "REGIAO"  , "C",10,0})
AADD(aCampos,{ "SITCLI"  , "C",01,0})
AADD(aCampos,{ "VENDCAD" , "C",06,0})
AADD(aCampos,{ "DATAFAT" , "D",08,0})
AADD(aCampos,{ "DATASAI" , "D",08,0})
AADD(aCampos,{ "PRODUTO" , "C",15,0})
AADD(aCampos,{ "STDPROD" , "N",12,4})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )


cQuery := " SELECT * "
cQuery += " FROM SC5010 "
//cQuery += " INNER JOIN SUA010 "
//cQuery += " ON UA_NUMSC5 = C5_NUM "
//cQuery += " AND SUA010.D_E_L_E_T_ <>'*'  "
cQuery += " WHERE C5_EMISSAO>='"+DTOS(mv_par01)+"'" 
cQuery += " AND C5_EMISSAO<='"+DTOS(mv_par02)+"'" 
cQuery += " AND C5_VEND1 >='"+(mv_par03)+"' "
cQuery += " AND C5_VEND1 <='"+(mv_par04)+"' "
cQuery += " AND C5_CLIENTE >='"+(mv_par07)+"' "
cQuery += " AND C5_CLIENTE <='"+(mv_par08)+"' "
cQuery += " AND (C5_TIPO='N' OR C5_TIPO='C')"
cQuery += " AND SUBSTRING(C5_NUM,1,1)<>'P'  "
cQuery += " AND SC5010.D_E_L_E_T_ <>'*'  "
cQuery := ChangeQuery(cQuery)

if select("TRB1")<>0
	dbCloseArea("TRB1")
Endif

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB1", .F., .T.)

nMgStd := nCustoSt1 :=0

Select TRB1
ProcRegua(reccount())
go top
Do while !eof()
	IncProc("Processando - Pedidos")
	Select SUA
	dbSetOrder(8)
	seek xFilial()+trb1->c5_num
	Do while !eof() .and. trb1->c5_numtmk<>sua->ua_num
		skip
	enddo
	Select trb1
//	reclock("trb1",.f.)
//	replace trb1->c5_fator with sua->ua_setor
//	replace trb1->c5_condpag with sua->UA_CONDPG
//	msunLock()
	nFator :=1
	do Case
		Case sua->ua_setor == "A"
			nFator := 2
		Case sua->ua_setor == "B"
			nFator := 5
		Case sua->ua_setor == "C"
			nFator := 1
		Case sua->ua_setor == "S"
			nFator := 0
	Endcase
	_cTpFrete := trb1->c5_tpfrete
	select SF2
	dbSetOrder(1)
	seek xFilial()+trb1->(c5_nota+c5_serie+c5_cliente+c5_lojacli)
	select SA1
	dbSetOrder(1)
	seek xFilial()+trb1->(c5_cliente+c5_lojacli)
	cGrpCli := iif(!empty(SA1->A1_XGRPCLI),SA1->A1_XGRPCLI,trb1->(c5_cliente+c5_lojacli))
	seek xFilial()+cGrpCli
	cEst := sa1->A1_est
	seek xFilial()+trb1->(c5_cliente+c5_lojacli)
	select SA2
	dbSetOrder(1)
	seek xFilial()+trb1->c5_cliente+trb1->c5_lojacli
	
	Select TRB1
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
			reclock("SC6",.f.)
			SC6->C6_MARGEM  := 0
			SC6->C6_MARGEMV := 0
			MsUnLock()
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

		Select SB1
		dbSetOrder(1)
		Seek xFilial()+sc6->c6_produto
		if sc6->(c6_num+c6_item)='07842901'
		x:=1			
		endif
		if left(sc6->c6_produto,2)=="00" .and. substr(sc6->c6_produto,3,1)#"."
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

		if empty(SB1->B1_BASE) .and. at(".",sc6->c6_produto)<>0
			cCod     := left(sc6->c6_produto,at(".",sc6->c6_produto)-1)
			cCodProd := sc6->c6_produto
			cCod1    := cCod      
		else
			cCod     := left(sc6->c6_produto,6)
			cCodProd := sc6->c6_produto
			cCod1    := cCod      
		Endif
		
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
		if left(sc6->c6_produto,7) = '2912.CO' .or.left(sc6->c6_produto,7) = '2900.RE'
			x:=1
		endif
		//		verStd()
		
		Select SZ3
		dbSetOrder(2)
		seek "  "+left(trb1->c5_emissao,6)
		if sz3->z3_data>=stod(trb1->c5_emissao) .AND. 1=2 //Desativei
			cDt := z3_data
			nTam := len(trim(cCod))
			seek "  "+dtos(cDt)+left(cCod,nTam)+space(15-nTam)
			nMarg := sz3->z3_margem
			nCStd := sz3->z3_stdcipi
			nCAtu := sz3->z3_atucipi
			nCSim := sz3->z3_simcipi
		Endif
		
		nCStd_1:= nCStd
		nMarg_1:= nMarg
		nCStd  := nCStd*nVar
		nMarg  := nMarg*nVar
		Select SUA
		dbSetOrder(8)
		seek xFilial()+trb1->c5_num
		Select SZ1
		dbSetOrder(3)
		Seek xFilial()+SA1->A1_XGRPCLI
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
		Select SUB
		dbsetOrder(3)
		seek xFilial()+sc6->(c6_num+c6_item)
		Do while !eof() .and. sc6->(c6_num+c6_item)=SUB->(UB_NUMPV+UB_ITEMPV) .and. sub->ub_num<>trb1->C5_NUMTMK
			skip
		Enddo
		IF nFator > 1
			nVlPed  := SUB->UB_VRUNIT*SUB->UB_QUANT
			nQtdEnt := SUB->UB_QUANT
		Endif
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
		u_pCalcVLiq(nVlPed)
		if sc6->(c6_num+c6_item)="079167"
		x:=1
		endif
		
		Select TRB
		Reclock("TRB",.t.)
		trb->num    := trb1->c5_num
		trb->item   := sc6->c6_item
		trb->cod    := cCod1   // left(cCodProd,4)
		trb->desc   := cDescPrd
		trb->produto:= sc6->c6_produto
		trb->codcli := trb1->c5_cliente+trb1->c5_lojacli
		trb->loja	:= iif(trb1->c5_tipo$"B*D",sa2->a2_loja,sa1->a1_loja)
		trb->cli    := iif(trb1->c5_tipo$"B*D",sa2->a2_nome,sa1->a1_nome)
		trb->grpcli := iif(trb1->c5_tipo$"B*D",sa2->a2_COD,sa1->a1_xgrpcli)
		trb->nreduz := iif(trb1->c5_tipo$"B*D",sa2->a2_nreduz,sa1->a1_nreduz)
		trb->rank   := SZ1->Z1_RANK
		trb->vend   := trb1->c5_vend1
		trb->coor   := cSuper
		trb->qtde   := nQtdEnt
		nQtdV := nQtdEnt
		if sc6->C6_TES <>"569"
			trb->qtdeM2 := iif(sb1->b1_segum="M2",nQtdEnt*sb1->b1_conv,0)
			if trb->qtdeM2<>0 .and. sb1->b1_um<>"KG"
				nQtdV := nQtdV*sb1->b1_conv
			endif
		Endif
		trb->entrega:= sc6->c6_entreg
		trb->emissao:= stod(trb1->C5_EMISSAO)
		trb->valliq := nValLiq//-nTotZFR
		trb->valbrut:= nVlPed
		trb->CUSTOSTD := iif(sm0->m0_codigo#"02",nCstd * nQtdV,nCstd)
		trb->MGSTD:= nMarg * nQtdV
		//   trb->MGSTD:= iif(left(cCod,4)=="2700",nVlPed,nMarg * nQtdEnt)
		trb->percstd  := (trb->mgstd/trb->CUSTOSTD)*100
//		if (nValLiq-trb->CUSTOSTD)/(1+(mv_par05)/100)<-1000
//		MsgBox ("Pedido"+trb1->C5_Num,"Informa‡Æo","INFO")
//		endif
		trb->mgreal := (nValLiq-trb->CUSTOSTD)/(1+(mv_par05)/100)
		//     trb->perc   := (trb->mgreal/trb->MGSTD)*100
		trb->percReal   := (trb->mgreal/trb->CUSTOSTD)*100
		
		trb->CUSTOATU := nCAtu * nQtdV
		trb->mgatu  := (nValLiq-trb->CUSTOATU)/(1+(mv_par05/100))
		if (trb->mgatu/trb->CUSTOSTD)*100<100000
			//		trb->percatu:= (trb->mgatu/trb->MGSTD)*100
			//			trb->percatu:= (trb->mgatu/trb->MGSTD)*100
			trb->percatu:= (trb->mgatu/trb->CUSTOATU)*100
		endif
		
		trb->CUSTOSIM := nCSim * nQtdV
		trb->mgsimul:= (nValLiq-trb->CUSTOSIM)/(1+(mv_par05/100))
		trb->percsim:= (trb->mgsimul/trb->CUSTOSIM)*100
		
		
		trb->acresc := mv_par05
		trb->verbadic:= sa1->a1_mgextra
		trb->valadic:= nValAdic
		//		trb->valmerc:= if(nFator#0,(nVlPed-nTotZFR)/nFator,0)
		//trb->valmerc:= if(nFator#0,(nVlPed-nTotZFR)/nFator,0)//zz
		trb->valmerc:= if(nFator#0,(nVlPed-nTotZFR)/nFator,0)
		trb->valcpmf:= nVCpmf
		if trb1->c5_fator#"S" .and. !"536*541"$sc6->c6_tes
			trb->valicms := nIcms1
			trb->valicmst:= nIcmST
			trb->valipi  := nIpi1
			trb->valpc   := nPC
			trb->valir   := nIr
		endif
		trb->valcom := iif(trb1->c5_comis1<>0.01,nCom1,0)
		trb->perccom:= iif(trb1->c5_comis1<>0.01,trb1->c5_comis1,0)
		trb->valcom2:= nCom2
		if cTpVend = "S"
			trb->valfin := nFin1
			trb->valfret:= nFrete
		endif
		trb->desczfr:= nTotZFR
		trb->tp     := trb1->c5_fator
		trb->frete  := trb1->c5_tpfrete
		trb->perfret:= sua->UA_PERFRET
		trb->est    := iif(trb1->c5_tipo$"B*D",sa2->a2_est,sa1->a1_est)
		trb->estgrp := iif(trb1->c5_tipo$"B*D",sa2->a2_est,cEst)
		trb->tes    := sc6->c6_tes
		trb->tpvend := cTpVend
		IF cTpVend = "N" .or. trb->qtde < 0
			trb->qtde2 := trb->qtde
			trb->qtde  := 0
			trb->valbrut:= 0
		Endif
		trb->condpag:= se4->e4_descri
		trb->aliqicm:= nIcm
		trb->aliqipi:= nperIpi
		trb->ncm    := cPosIpi
		trb->cnpj   := sa1->a1_cgc
		trb->pedori := cPedOri
		trb->rm1    := ncStd1
		trb->rm2    := ncStd2
		trb->rm3    := ncStd3
		trb->segmento := SA1->a1_sativ1
		trb->regiao   := SA1->a1_regiao
		trb->sitcli	  := SA1->A1_SATIV8
		trb->vendcad:= sa1->a1_vend
		trb->DATAFAT := sc6->c6_datfat
		trb->datasai := sf2->f2_datasai
		trb->stdprod:= nCStd
		msunlock()
		
		nTotLiq  := nTotLiq + nValLiq
		nTotCust := nTotCust+ trb->CUSTOSTD
		nTotMg   := nTotMg  + (nMarg * nQtdV)
		nMgStd   += trb->MgStd
		nCustoSt1+= trb->CustoStd
		nTAtu 	 += (sb5->b5_cstatu*SC6->C6_QTDVEN)
		Select SC6
		reclock("SC6",.f.)
		//			if trb->MGSTD#0
		if (trb1->c5_emissao)<'20150101'
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
		MsUnLock()
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
			reclock("SC5",.f.)
			Replace C5_MARGEM  With nMg*100
			Replace C5_MARGEMV With nMgReal //(nTotLiq-nTotCust)
			nMgAtu := nTotLiq-nTAtu
			if (nMgatu/nTAtu)*100<1000 .and. (nMgatu/nTAtu)*100>-1000
				Replace C5_MARGATU with (nMgatu/nTAtu)*100
			endif
			if nCustoSt1<>0 .and. (nMgstd/nCUSTOST1)*100<10000
				Replace C5_MARGSTD With (nMgstd/nCUSTOST1)*100
				nMgstd := 0
				nCUSTOST1 := 0
			endif
			MsUnLock()
		endif
	else
		reclock("SC5",.f.)
		Replace C5_MARGEM  With 0
		Replace C5_MARGEMV With 0
		MsUnLock()
	Endif
	reclock("SC5",.f.)
	Replace C5_VALPED  With nValPed
	MsUnLock()
	
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
endif

Select TRB
dbGoTop()
nQtd := nQtd2 := nVal1 := nVal2 := nVal3 := nVal4 := nVal5 := nVal5 := 0
Do while !eof()
	if tes$"541*542"
		nQtd += Qtde
		nQtd2+= Qtdem2
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
		copy to \gerencia\mgvdle
		//		MsgBox ("Arquivo gerado com sucesso \system\mgvd-le","Informa‡Æo","INFO")
		if file("mgvdarm.dtc")
			reclock("trb",.t.)
			trb->Qtde := -nQtd
			trb->ValBrut:= -nVal1
			trb->ValLiq := -nVal2
			trb->CUSTOSTD := -nVal3
			trb->MGSTD:= -nVal4
			trb->MgReal := -nVal5
			MsUnLock()
			appe from mgvdarm
			copy to \gerencia\mgvdtot
			MsgBox ("Arquivo gerado com sucesso \system\mgvdatt","Informa‡Æo","INFO")
		endif
	case sm0->m0_codigo=="02"
		copy to \gerencia\mgvdrm
		MsgBox ("Arquivo gerado com sucesso \system\mgvdarm","Informa‡Æo","INFO")
endcase

Select TRB
Use
Select TRB1
Use
Select SC5

Return

**************************
//Static Function CalcVLiq()
User Function PCalcVLiq(nVlPed)
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
IF nFator > 1
	nVlPed  := SUB->UB_VRUNIT*SUB->UB_QUANT
	nQtdEnt := SUB->UB_QUANT
Endif
if sub->ub_tes$'512*543*559'
	if sub->ub_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
		nAliqZF := 0.1065
	else
		nAliqZF := 0.07
	endif
	if nFator#0
		nTotZFR := (nVlPed/nfator)*nAliqZF
//		nVlPed	:= (nVlPed)-nTotZFR//*nAliqZF
//		nVlPed  := (SC6->C6_VALOR)*nFator // nVlPed-nTotZFR  // Luiz - 27/05/2015
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
if SA1->A1_PESSOA == "F" .OR. (LEN(TRIM(SA1->A1_CGC))>=9 .AND. LEN(TRIM(SA1->A1_CGC))<=11) 
	//	nBase:= nVlPed*(1+(nIpi)/100)
	if sa1->a1_contrib<>"1"
		nBase:= nVlPed
		nIcm := 18
	endif
endif
if sf4->f4_codigo$'536*541*512*543*559' .or. sf4->f4_icm=="N"
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
nBaseIR := (nVlPed/nFator)-nTotZFR
* Verifica PIS/Cofins/IR
if sf4->f4_piscof#"4"
	nVlPed	:= nVlPed-nTotZFR
	nTotNf  := (nVlPed-nTotZFR)/nFator //-nTotZfr
	nPC     := (nTotNf * nPCI)/100
	//	nIR     := ((nVlPed+nTotZFR) * 2.88)/100
	nIR     := ((nTotnf+nTotZFR) * 2.88)/100
	if nTotZFR<>0
		nTotNf  := (nVlPed)/nFator//-nTotZfr
		nPC     := (nTotNf * nPCI)/100
		nIR     := (nBaseIR * 2.88)/100
		//		nVlPed	:= nVlPed-nTotZFR
	endif
	if left(sa1->a1_codmun,5)=="00255" .and. sub->ub_tes$'512*543*559' // Zona Franca de Manaus
		nICM    := 0
		//		nIR     := (((nVlPed-nTotZFR)-(nVlPed-nTotZFR)*.1065) * 2.88)/100
		nVCpmf  := ((nVlPed-nTotNF*.1065) * nCpmf)/100
		nZFr    := nTotZFR
	else
		nVCpmf  := ((nVlPed * nCPMF)/100)
	endif
else
	if left(sa1->a1_codmun,5)=="00255" .and. sub->ub_tes$'512*543*559'  // Zona Franca de Manaus
		nTotNf  := (nVlPed-nTotZFR)/nFator //-nTotZFR
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

nValNota := nVlPed-nTotZFR
if year(sc5->c5_emissao)>=2014
	Do case
		Case sa1->a1_est$"BA*CE" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := (nValNota*0.10)  //-nValNota/1.10
			if sa1->a1_est="CE" .and. trim(sa1->a1_cod_mun)="12908"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C"//"SOBRAL"
				nFrete := nValNota*.12//-nValNota/1.12
			endif
		Case sa1->a1_est$"MG" .and. trim(sa1->a1_cod_mun)="06200"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C" //"BELO HORIZONTE"
			nFrete := nValNota*.06//-nValNota/1.06 //nValNota*0.06
		Case sa1->a1_est$"RJ"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*.065 //-nValNota/1.065//nValNota*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"SANTOS*SAO VICENTE*GUARUJA*CARAGUATATUBA*UBATUBA" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*.065 //-nValNota/1.065//nValNota*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"PRAIA GRANDE*CUBATAO*ITANHAEM*MONGAGUA*PERUIBE*SAO SEBASTIAO" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*.065 //-nValNota/1.065//nValNota*0.065
		Case sa1->a1_est$"SP" .and. sa1->a1_cod_mun$"50308*05708*25003*18800" // SP / Barueri / Jandira / Guarulhos ;
			//		"SAO"$sa1->a1_mun .and. "PAULO"$sa1->a1_mun
			nFrete := 0
		Case sa1->a1_est$"RS" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nValNota*.12//-nValNota/1.12//nValNota*0.12
		Otherwise
			if Substr(Alltrim(_cTpFrete),1,1)=="C"
				nFrete := nValNota*.15//-nValNota/1.15//nValNota*0.15
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

dbSelectArea("SUA")
dbSetOrder(8) //UA_FILIAL+UA_NUMSC5
dbSeek(xFilial()+SC5->C5_NUM)
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+sua->UA_CONDPG) //sc5->C5_CONDPAG)
//dbSeek(xFilial()+trb1->C5_CONDPAG)
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
//	nValComis := ((nVlPed-nFrete)*(trb1->C5_COMIS1+nComS))/100
	nValComis := ((nVlPed)*(trb1->C5_COMIS1+nComS))/100
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

//nCom1   := ((((nVlPed- nTotZFR)-nFrete)*trb1->C5_COMIS1)/100)
//nCom2   := iif(nCom1#0,((((nVlPed- nTotZFR)-nFrete)*nComS)/100),0)
// Tirei o desconto de Zona Franca da Comissão e Financeiro - 30-08-2017
//nCom1   := ((((nVlPed)-nFrete)*trb1->C5_COMIS1)/100)
//nCom2   := iif(nCom1#0,((((nVlPed)-nFrete)*nComS)/100),0)
nCom1   := (((nVlPed)*trb1->C5_COMIS1)/100)
nCom2   := iif(nCom1#0,(((nVlPed)*nComS)/100),0)

nValAdic:= (nVlPed+nIpi1-nZFr)*(sa1->a1_mgextra/100)

// Alterei a fórmula em 06-03-2014 antecipei o cálculo do financeiro
//nFin1   := (nVlPed- nTotZFR+nIpi1)-((nVlPed- nTotZFR+nIpi1)/nValFin)
//nFin1   := (nVlPed+ nIpi1)-((nVlPed +nIpi1)/nValFin)
nFin1   := (nVlPed+ nIpi1)*(nValFin-1)
nValLiq := nVlPed - nIcms1 - nCom1 - nCom2 - nFrete - nValAdic - nPC - nIR - nVCpmf - nFin1// - nTotZFR (23/02/2017)//-nZfr
//nFin1   := nValliq-(nValliq/nValFin) //financeiro abate apos desconto dos impostos
//nValLiq := nValliq - nFin1
nQuant := iif(empty(sb1->b1_base) .AND. SB1->B1_UM<>'KG',sc6->c6_qtdven,sc6->c6_unsven)
u_GrvCpos(Alltrim(_cSetor),nVlPed,cCod1,cCod,sa1->(a1_cod+a1_loja),sc6->c6_Tes,trb1->C5_CONDPAG,"N",trb1->c5_vend1,"PED"," "," ",nQuant)
dbSelectArea("SC6")

Return

*************************
Static Function Imprime()
*************************

if mv_par06#1
	Cabec1 := "Codigo Vendedor        Coord.  Est         Meta    Val.Bruto   %Meta  Custo Std       MG Std.     MG Real   Perc        Peso      "
	//	012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec2 := "Período de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	// Verifica Meta dos vendedores
	aVendedor := {}
	aSegmento := {}
	Select SCT
	dbSetOrder(1)
	Seek xFilial()+substr(dtos(mv_par02),5,2)+left(dtos(mv_par02),4)
	Do while !eof() .and. substr(dtos(mv_par02),5,2)+left(dtos(mv_par02),4)==left(ct_doc,6)
		if sct->ct_valor<>0
			aAdd(aVendedor,{sct->ct_vend,sct->ct_valor})
		endif
		Skip
	Enddo
	
	Select TRB
	SetRegua(recCount())
	nTot := 0
	dbGoTop()
	Do while !eof()
		IncRegua()
		ntot := nTot + MGReal
		nLinha := Ascan(aSegmento, {|x|x[1] == trb->Segmento})
		If nLinha != 0
			aSegmento[nLinha][2] := aSegmento[nLinha][2] + trb->ValBrut
			aSegmento[nLinha][3] := aSegmento[nLinha][3] + trb->CustoStd
			aSegmento[nLinha][4] := aSegmento[nLinha][4] + trb->MGSTD
			aSegmento[nLinha][5] := aSegmento[nLinha][5] + trb->MgReal
		Else
			aAdd(aSegmento,{segmento,Valbrut,CUSTOSTD,MgStd,MgReal})  // Totaliza Segmento
		Endif
		Skip
	Enddo
	cIndex := CriaTrab(nil,.f.)
	IndRegua("TRB", cIndex, "Vend", , , "Selecionando Registros...")
	//	index on Vend to &cTemp12a
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
		RecLock("trbprn",.t.)
		trbprn->nReduz := "99"
		trbprn->Vend   := cVend
		trbprn->Coor   := cCoor
		trbprn->VlBrut := nVLB
		trbprn->CUSTOSTD := nStd
		trbprn->MGSTD:= nMGI
		trbprn->MgReal := nMGR
		if nStd<>0 .and. (mgreal/CUSTOSTD)<10000
			//		if MGSTD<>0
			//			trbprn->perc   := (mgreal/MGSTD)*100
			trbprn->percReal   := (mgreal/CUSTOSTD)*100
		endif
		//     trbprn->Perc   := iif(nMGI<>0,nMGR/nMGI*100,0)
		trbprn->Peso   := nMGR/nTot*100
		MsUnLock()
		Select TRB
	Enddo
	Select TRBPRN
	cIndex1 := CriaTrab(nil,.f.)
	IndRegua("TRBPRN", cIndex1, "Vend", , , "Selecionando Registros...")
	//	Index on Vend to &cTempPrn
	for n=1 to len(aVendedor)
		Select TRBPRN
		seek aVendedor[n][1]
		if !eof() .and. mv_par02-mv_par01<=31
			reclock("trbprn",.f.)
			trbprn->Meta   := aVendedor[n][2]
			MsUnLock()
			loop
		endif
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+aVendedor[n][1]
		Select trbprn
		if eof() .and. aVendedor[n][2]<>0
			reclock("trbprn",.t.)
			trbprn->NReduz := "99"
			trbprn->Vend   := sa3->a3_cod
			trbprn->Coor   := sa3->a3_super
			trbprn->Meta   := aVendedor[n][2]
			MsUnLock()
		endif
		Select TRBPRN
	Next N
	
	Select TRBPRN
	copy to \gerencia\mgvdvnd_semana
	cTemp12g := CriaTrab(nil,.f.)
	Do Case
		Case mv_par06==2
			cIndex := CriaTrab(nil,.f.)
			IndRegua("TRBPRN", cTemp12g, "Peso*(-1)", , , "Selecionando Registros...")
			//			index on Peso*(-1) to &cTemp12g
		Case mv_par06==3
			IndRegua("TRBPRN", cTemp12g, "PercReal*(-1)", , , "Selecionando Registros...")
			//			index on PercReal*(-1) to &cTemp12g
	EndCase
	
	dbGoTop()
	nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+trbprn->Vend
		if eof() .or. empty(trbprn->Vend)
			Select TRBPRN
			skip
			loop
		endif
		Select TRBPRN
		@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+"  "+sa3->a3_super+"  "+sa3->a3_est
		//		@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+"  "+Coor+"  "+sa3->a3_est
		@ li,038 PSAY Meta         picture "@E 99,999,999"
		@ li,050 PSAY VlBrut               picture "@E 99,999,999"
		if Meta#0
			@ li,062 PSAY VlBrut/Meta*100  picture "@E 999.99%"
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
		nTot6 := nTot6 +Meta
		skip
		li:=li+1
	Enddo
	li:=li+1
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,038 PSAY nTot6 picture "@E 99,999,999"
	@ li,050 PSAY ntot1   picture "@E 99,999,999"
	if nTot6#0
		@ li,062 PSAY ntot1/ntot6*100  picture "@E 999.99%"
	endif
	@ li,070 PSAY ntot0   picture "@E 99,999,999"
	@ li,082 PSAY ntot2   picture "@E 99,999,999"
	@ li,094 PSAY nTot3   picture "@E 99,999,999"
	@ li,106 PSAY ntot3/ntot0*100  picture "@E 999.99%"
	@ li,118 PSAY ntot5   picture "@E 999.99%"
	li:=li+2
	
	cTemp12h := CriaTrab(nil,.f.)
	IndRegua("TRBPRN", cTemp12h, "Coor+Vend", , , "Selecionando Registros...")
	//	index on Coor+Vend to &cTemp12h
	dbGoTop()
	nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		cCoor  := trbprn->Coor
		cVend  := " "
		nStd := nMGR   := nMGI := nVLB := nMet := 0
		Do while !eof() .and. trbprn->Coor==cCoor
			IncRegua()
			//			if cVend#trbprn->Vend
			Select TRBPRN
			nMet := nMet + Meta
			cVend := Vend
			//			Endif
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
		@ li,000 PSAY left(cCoor,3)+"-"+sa3->a3_nreduz //+left(sa3->a3_nome,20)
		@ li,038 PSAY nMet picture "@E 99,999,999"
		@ li,050 PSAY nVlB picture "@E 99,999,999"
		if nMet#0
			@ li,062 PSAY nVlB/nMet*100  picture "@E 999.99%"
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
	
	
	// Totalizado por Segmento - 12/11/2018
	nPeso := 0
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	
	li:=li+2
	@ li,000 PSAY "Segmento"//                                         Val.Bruto              Custo Std.     MG Std.     MG Real    Perc        Peso"
	li:=li+1
	for n=1 to len(aSegmento)
		Select SX5
		seek xFilial()+"T3"+TRIM(aSegmento[n][1])
		If li > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			@ li,000 PSAY "Segmento "//                                        Val.Bruto              Custo Std.     MG Std.     MG Real    Perc        Peso"
		Endif
		@ li,000 PSAY trim(aSegmento[n][1]) + "-" + left(sx5->x5_descri,27)
		@ li,048 PSAY aSegmento[n][2]    picture "@E 99,999,999"  // Valor Bruto
		@ li,072 PSAY aSegmento[n][3]    picture "@E 99,999,999"  // Custo Std
		@ li,084 PSAY aSegmento[n][4]    picture "@E 99,999,999"  // Margem Std
		@ li,096 PSAY aSegmento[n][5]    picture "@E 99,999,999"  // Margem Real
		if aSegmento[n][3]#0
			@ li,108 PSAY (aSegmento[n][5])/(aSegmento[n][3])*100   picture "@E 999.99"
		endif
		if nTot#0
			nPeso   := aSegmento[n][5]/nTot*100
		endif
		@ li,120 PSAY nPeso   picture "@E 999.99"
		nTot2 += aSegmento[n][2]
		nTot3 += aSegmento[n][3]
		nTot4 += aSegmento[n][4]
		nTot5 += aSegmento[n][5]
		li:=li+1
	Next
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral"
	@ li,048 PSAY ntot2   picture "@E 99,999,999"
	@ li,072 PSAY ntot3   picture "@E 99,999,999"
	@ li,084 PSAY ntot4   picture "@E 99,999,999"
	@ li,096 PSAY nTot5   picture "@E 99,999,999"
	@ li,108 PSAY nTot5/nTot3*100   picture "@E 999.99"
	@ li,120 PSAY 100   picture "@E 999.99"
	
	//	@ li,108 PSAY ntot3/ntot6*100  picture "@E 999.99"
	//	@ li,120 PSAY ntot5   picture "@E 999.99"
	
	// Relatório de Vendas por Semana (só será criado caso o período seja mensal) - Luiz - 06/07/2017
	if mv_par01 <> mv_par02 .and. left(dtos(mv_par01),6)=left(dtos(mv_par02),6)
		
		Select TRB
		cTemp12c := CriaTrab(nil,.f.)
		SetRegua(recCount())
		IndRegua("TRB", cTemp12c, "Vend+dtos(emissao)", , , "Selecionando Registros...")
		//		index on Vend+dtos(emissao) to &cTemp12c
		dbGotop()
		SetRegua(recCount())
		li := 80
		nIni := dow(firstday(mv_par01))
		nFim := dow(lastday(mv_par01))
		IF nIni = 7 .or. nIni=1
			nIni1 := iif(nIni=1,1,2)
			dIni  := firstday(mv_par01)+nIni1
			cSemana1	:= firstday(mv_par01)+nIni1+7-1
		else
			cSemana1	:= firstday(mv_par01)+7-nIni
			dIni  		:= firstday(mv_par01)
		endif
		cSemana2	:= cSemana1+7
		cSemana3	:= cSemana2+7
		cSemana4	:= Iif(cSemana3+7>lastday(mv_par01),lastday(mv_par01),cSemana3+7)
		cSemana5	:= Iif(cSemana4+7>lastday(mv_par01),lastday(mv_par01),cSemana4+7)
		cSemana		:= ""
		cCab1 := left(dtoc(dIni),2)+" a "+left(dtoc(cSemana1),2)
		cCab2 := left(dtoc(cSemana1+1),2)+" a "+left(dtoc(cSemana2),2)
		cCab3 := left(dtoc(cSemana2+1),2)+" a "+left(dtoc(cSemana3),2)
		cCab4 := left(dtoc(cSemana3+1),2)+" a "+left(dtoc(cSemana4),2)
		cCab5 := Iif(cSemana4+1>lastday(mv_par01),"",left(dtoc(cSemana4+1),2)+" a "+left(dtoc(lastday(mv_par01)),2))
		
		//Cálculo do número de Dias Úteis no mês
		
		cDt  := dow(firstday(mv_par01))
		dDt  := firstday(mv_par01)
		nFim := dow(lastday(mv_par01))
		nDU := 0
		DU_Sem1 := DU_Sem2 := DU_Sem3 := DU_Sem4 := DU_Sem5 := 0
		For n:=1 to 31
			cDt := dow(dDt)
			if cDt=2 .or. cDt=3 .or. cDt=4 .or. cDt=5 .or. cDt=6
				nDU++
				Do Case
					Case dIni<=dDt .and. cSemana1>=dDt
						DU_Sem1 ++
					Case cSemana1<dDt .and. cSemana2>=dDt
						DU_Sem2 ++
					Case cSemana2<dDt .and. cSemana3>=dDt
						DU_Sem3 ++
					Case cSemana3<dDt .and. cSemana4>=dDt
						DU_Sem4 ++
					Case cSemana4<dDt .and. lastday(mv_par01)<=dDt
						DU_Sem5 ++
				EndCase
			endif
			dDt := dDt + 1
		Next
		DU_Sem1a := Transform( DU_Sem1/nDu*100, "@E 999.99" )
		DU_Sem2a := Transform( (DU_Sem1+DU_Sem2)/nDu*100, "@E 999.99" )
		DU_Sem3a := Transform( (DU_Sem1+DU_Sem2+DU_Sem3)/nDu*100, "@E 999.99" )
		DU_Sem4a := Transform( (DU_Sem1+DU_Sem2+DU_Sem3+DU_Sem4)/nDu*100, "@E 999.99" )
		DU_Sem5a := Transform( (DU_Sem1+DU_Sem2+DU_Sem3+DU_Sem4+DU_Sem5)/nDu*100, "@E 999.99" )
		cSpace := "%  |  "
		Cabec1 := "Codigo Vendedor        Coord.              Meta    "+cCab1+"  |  "+cCab2+"  |  "+cCab3+"  |  "+cCab4+"  |  "+cCab5+"  |     Total"
		//		012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		Cabec2 := "Período de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)+space(15)+DU_Sem1a+cSpace+DU_Sem2a+cSpace+DU_Sem3a+cSpace+DU_Sem4a+cSpace+DU_Sem5a+cSpace+strzero(nDu,2)+" dias"
		n:=1
		Do while !eof()
			cVend  := trb->Vend
			cCoor  := trb->Coor
			nVLB   := 0
			cSemana0 := dIni
			cSemanaI := "cSemana"+str(n-1,1)
			cSemanaF := "cSemana"+str(n,1)
			Do while !eof() .and. emissao<mv_par01 .or. emissao > mv_par02
				skip
			Enddo
			Do while !eof() .and. trb->Vend==cVend .and. emissao>=&cSemanaI .and. emissao<(IIF(&cSemanaF=lastday(&cSemanaF),&cSemanaF+1,&cSemanaF))
				IncRegua()
				nVLB := nVLB + trb->Valbrut
				skip
			Enddo
			Select TRBPRN
			reclock("trbprn",.t.)
			trbprn->nReduz := dtos(&cSemanaF)
			trbprn->Vend   := cVend
			trbprn->Coor   := cCoor
			trbprn->VlBrut := nVLB
			MsUnLock()
			Select TRB
			n++
			if n>5
				n:=1
			endif
		Enddo
		Select TRBPRN
		cTemp12i := CriaTrab(nil,.f.)
		IndRegua("TRBPRN", cTemp12i, "Vend+nReduz", , , "Selecionando Registros...")
		//		Index on Vend+nReduz to &cTemp12i
		for n=1 to len(aVendedor)
			Select TRBPRN
			seek aVendedor[n][1]
			if !eof() .and. mv_par02-mv_par01<=31
				reclock("trbprn",.f.)
				trbprn->Meta   := aVendedor[n][2]
				MsUnLock()
				loop
			endif
			Select SA3
			dbSetOrder(1)
			Seek xFilial()+aVendedor[n][1]
			Select trbprn
			if eof() .and. aVendedor[n][2]<>0
				reclock("trbprn",.t.)
				trbprn->Vend   := sa3->a3_cod
				trbprn->Coor   := sa3->a3_super
				trbprn->Meta   := aVendedor[n][2]
				msunlock()
			endif
			Select TRBPRN
		Next N
		
		Select TRBPRN
		IndRegua("TRBPRN", cTempPrn, "PercReal*(-1)", , , "Selecionando Registros...")
		//		index on PercReal*(-1) to &cTempPrn
		
		dbGoTop()
		nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
		nTot01 := nTot02 := nTot03 := nTot04 := nTot05 := nTot06 := 0
		nTotMeta := 0
		Do while !eof()
			If li > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			Endif
			Select SA3
			dbSetOrder(1)
			Seek xFilial()+trbprn->Vend
			if eof() .or. empty(trbprn->Vend)
				Select TRBPRN
				skip
				loop
			endif
			Select TRBPRN
			@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+"  "+sa3->a3_super+"  "+sa3->a3_est
			//		@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+"  "+Coor+"  "+sa3->a3_est
			@ li,038 PSAY Meta         picture "@E 99,999,999"
			nTotMeta += Meta
			cVend := Vend
			Do while !eof() .and. Vend = cVend
				nCol=50
				do case
					case trim(nReduz)=dtos(cSemana1)
						ntot01 +=  VlBrut
						nCol = 52
					case trim(nReduz)=dtos(cSemana2)
						ntot02 +=  VlBrut
						nCol = 64
					case trim(nReduz)=dtos(cSemana3)
						ntot03 +=  VlBrut
						nCol = 76
					case trim(nReduz)=dtos(cSemana4)
						ntot04 +=  VlBrut
						nCol = 88
					case trim(nReduz)=dtos(cSemana5)
						ntot05 +=  VlBrut
						nCol = 100
					otherwise
						ntot06 +=  VlBrut
						nCol = 112
				Endcase
				if VLBrut<>0
					@ li,nCol PSAY VlBrut               picture "@E 9999,999"
				endif
				nTot1 := nTot1 +VlBrut
				nTot6 := nTot6 +Meta
				skip
			Enddo
			//			skip
			li:=li+1
		Enddo
		li:=li+1
		@ li,000 PSAY replicate("-",132)
		li:=li+1
		@ li,000 PSAY "Total Geral"
		@ li,038 PSAY ntotMeta             picture "@E 9999,999"
		@ li,052 PSAY ntot01               picture "@E 9999,999"
		@ li,064 PSAY nTot02               picture "@E 9999,999"
		@ li,076 PSAY nTot03               picture "@E 9999,999"
		@ li,088 PSAY nTot04               picture "@E 9999,999"
		@ li,100 PSAY nTot05               picture "@E 9999,999"
		@ li,112 PSAY nTot06               picture "@E 9999,999"
		li:=li+1
		@ li,038 PSAY 100         					picture "@E 9999.99%"
		@ li,052 PSAY ntot01/nTotMeta*100         	picture "@E 9,999.99%"
		@ li,064 PSAY (nTot01+nTot02)/nTotMeta*100  picture "@E 9,999.99%"
		@ li,076 PSAY (nTot01+nTot02+nTot03)/nTotMeta*100  			     picture "@E 9,999.99%"
		@ li,088 PSAY (nTot01+nTot02+nTot03+nTot04)/nTotMeta*100         picture "@E 9,999.99%"
		@ li,100 PSAY (nTot01+nTot02+nTot03+nTot04+nTot05)/nTotMeta*100  picture "@E 9,999.99%"
		@ li,112 PSAY (nTot01+nTot02+nTot03+nTot04+nTot05)/nTotMeta*100  picture "@E 9,999.99%"
		li:=li+1
		@ li,000 PSAY replicate("-",132)
		li:=li+1
		@ li,000 PSAY replicate("-",132)
		li:=li+1
		//		@ li,000 PSAY "Total Geral "
		//		@ li,038 PSAY nTot6 picture "@E 99,999,999"
		//		@ li,050 PSAY ntot1   picture "@E 99,999,999"
		//		li:=li+2
		Coord()
		cTemp12j := CriaTrab(nil,.f.)
		IndRegua("TRBPRN", cTemp12j, "Coor+Vend", , , "Selecionando Registros...")
		//		index on Coor+Vend to &cTemp12j
		dbGoTop()
		nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nVLB := nMeta := 0
		Do while !eof() .and. 1==2
			
			If li > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			Endif
			cCoor  := trbprn->Coor
			cVend  := " "
			nStd := nMGR   := nMGI := nVLB := nMet := 0
			Do while !eof() .and. trbprn->Coor==cCoor
				IncRegua()
				//			if cVend#trbprn->Vend
				Select TRBPRN
				if left(nReduz,2)<>"99"
					skip
					loop
				endif
				nMet := nMet + Meta
				cVend := Vend
				//			Endif
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
			@ li,000 PSAY left(cCoor,3)+"-"+sa3->a3_nreduz //+left(sa3->a3_nome,20)
			@ li,038 PSAY nMet picture "@E 99,999,999"
			@ li,050 PSAY nVlB picture "@E 99,999,999"
			nTot1 := nTot1 +nVlB
			nTot6 := nTot6 +nMet
			li:=li+1
		Enddo
		
		//		@ li,000 PSAY "------------------------"
		//		li:=li+1
		//		@ li,000 PSAY "Total Geral "
		//		@ li,038 PSAY iif(ntot6#0,ntot6,0)  picture "@E 99,999,999"
		//		@ li,050 PSAY ntot1   picture "@E 99,999,999"
		//		@ li,062 PSAY iif(ntot6#0,nTot1/ntot6*100,0)  picture "@E 999.99%"
	Endif
	// Final Relatório por Semana
	
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
	cTemp12d := CriaTrab(nil,.f.)
	IndRegua("TRBPRN", cTemp12d, "Cli", , , "Selecionando Registros...")
	//	index on Cli  to &cTemp12d
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
		reclock("trbprn",.t.)
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
		MsUnLock()
		Select TRB
	Enddo
	
	cPrn1:= CriaTrab(nil,.f.)
	Select TRBPRN
	Do Case
		Case mv_par09==2
			IndRegua("TRBPRN", cprn1, "Peso*(-1)", , , "Selecionando Registros...")
			//			index on Peso*(-1) to &cPrn1
		Case mv_par09==3
			IndRegua("TRBPRN", cprn1, "PercReal*(-1)", , , "Selecionando Registros...")
			//			index on PercReal*(-1) to &cPrn1
		Case mv_par09==4
			IndRegua("TRBPRN", cprn1, "Nome", , , "Selecionando Registros...")
			//			index on Nome to &cPrn1
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
	IncProc("1")
	nTotReal += MGReal
	nTotQtde += Qtde
	nTotValB += ValBrut
	nTotValL += Valliq
	nTotStdL += CUSTOSTD
	nTotMGId += MGSTD
	Skip
Enddo

For n:=1 to 5   // Gerar os 5 arquivos
	
	aCampos := {}
	if n==1
		AADD(aCampos,{ "PRODUTO" , "C",15,0})
		AADD(aCampos,{ "DESC"    , "C",40,0})
	endif
	if n==2
		AADD(aCampos,{ "GRPCLI"  , "C",08,0})
		AADD(aCampos,{ "CLI"     , "C",08,0})
		AADD(aCampos,{ "NOME"    , "C",30,0})
		AADD(aCampos,{ "NREDUZ"  , "C",20,0})
		AADD(aCampos,{ "RANK"    , "N",04,0})
		AADD(aCampos,{ "UF"      , "C",02,0})
		AADD(aCampos,{ "VEND"    , "C",06,0})
		AADD(aCampos,{ "NOMEV"   , "C",20,0})
		AADD(aCampos,{ "NOMEC"   , "C",20,0})
		AADD(aCampos,{ "REGIAO"  , "C",10,0})
		AADD(aCampos,{ "SITCLI"  , "C",01,0})
		AADD(aCampos,{ "SEGMENTO", "C",06,0})
		AADD(aCampos,{ "VENDCAD" , "C",06,0})
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
	if n==5
		AADD(aCampos,{ "UF"      , "C",02,0})
		AADD(aCampos,{ "VEND"    , "C",06,0})
		AADD(aCampos,{ "NOMEV"   , "C",20,0})
		AADD(aCampos,{ "NOMEC"   , "C",20,0})
		AADD(aCampos,{ "QTDCLIUF", "N",04,0})
		AADD(aCampos,{ "QTDCLI"  , "N",04,0})
		AADD(aCampos,{ "DESATIVA", "N",04,0})
		AADD(aCampos,{ "ATIVO"   , "N",04,0})
		AADD(aCampos,{ "REATIVAD", "N",04,0})
		AADD(aCampos,{ "INATIVO" , "N",04,0})
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
	IF SELECT("TRBPR1") # 0
		TRBPRN->(DBCLOSEAREA( ))
	ENDIF
	
	cTempArq := CriaTrab(nil,.f.)
	dbCreate(cTempArq,aCampos)
	dbUseArea( .T.,,cTempArq,"TRBPR1", Nil, .F. )
	
	do case
		Case n==1 .and. mv_par10==1
			IndRegua("TRBPR1", cTempArq, "Produto", , , "Selecionando Registros...")
			//			index on Produto to &cTempArq
		Case n==2 .and. mv_par11==1
			IndRegua("TRBPR1", cTempArq, "Nome", , , "Selecionando Registros...")
			//			index on Nome to &cTempArq
		Case n==3 .and. mv_par12==1
			IndRegua("TRBPR1", cTempArq, "Vend", , , "Selecionando Registros...")
			//			index on Vend to &cTempArq
		Case n==4 .and. mv_par12==1
			IndRegua("TRBPR1", cTempArq, "UF", , , "Selecionando Registros...")
			//			index on UF to &cTempArq
		Case n==5 .and. mv_par12==1
			IndRegua("TRBPR1", cTempArq, "UF+Vend", , , "Selecionando Registros...")
			//			index on UF+Vend to &cTempArq
	EndCase
	
	Select TRB
	cTemp12f := CriaTrab(nil,.f.)
	do case
		Case n==1 .and. mv_par10==1
			IndRegua("TRB", cTemp12f, "Cod", , , "Selecionando Registros...")
			//			index on Cod  to &cTemp12f
		Case n==2 .and. mv_par11==1
			IndRegua("TRB", cTemp12f, "GRPCLI", , , "Selecionando Registros...")
			//			index on GRPCLI to &cTemp12f
			//			index on Cli  to &cTemp
		Case n==3 .and. mv_par12==1
			IndRegua("TRB", cTemp12f, "Vend", , , "Selecionando Registros...")
			//			index on vend to &cTemp12f
		Case n==4 .and. mv_par12==1
			IndRegua("TRB", cTemp12f, "Est", , , "Selecionando Registros...")
			//			index on EST to &cTemp12f
		Case n==5 .and. mv_par12==1
			IndRegua("TRB", cTemp12f, "EST+Vend", , , "Selecionando Registros...")
			//			index on EST+Vend to &cTemp12f
			UfXVen()
	EndCase
	dbGotop()
	ProcRegua(reccount())
	li := 80
	//nTot := 0
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTot7 :=nTot8 :=nTot9 :=nTot10 := 0
	Do while !eof()
		Select TRB
		nMGR    := nMGI := nVLB := nQtd := nStd := 0
		nCUSTOATU	:= nMGAtu := nPercActu := nCUSTOSIM := nMgSimul := mPercSim := nValliq := 0
		
		cCoor  := ""
		cChave := ""
		cChave1 := ""
		Do case
			Case n==1 .and. mv_par10==1
				if left(cod,1)=="0" .and. substr(cod,6,2)<"A"
					cCod := "1"+substr(Cod,2,3)
				else
					cCod := COD
				endif
				cChave1 := COD
				cVend  := VEND
				cCoor  := COOR
				Do while !eof() .and. trb->Cod==cChave1
					IncProc("2")
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
				cRegiao:= REGIAO
				cSitCli:= SITCLI
				cSegment:= SEGMENTO
				cVendCad:= VENDCAD
				cgrpcli := GRPCLI
				nRank	:= RANK
				
				//				Do while !eof() .and. trb->CodCli==cChave
				Do while !eof() .and. trb->GrpCli==cGrpCli
					IncProc("3")
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
					IncProc("4")
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
					IncProc("5")
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
			Case n==5 .and. mv_par12==1
				cChave := EST+VEND
				cEst   := Est
				cVend  := VEND
				cCoor  := COOR
				Select TrbPr1
				Seek cEst+cVend
				if eof()
					reclock("trbpr1",.t.)
					trbpr1->Uf			:= cEst
					trbpr1->Vend		:= cvend
					trbpr1->NomeV		:= 'cNomv'
					trbpr1->NomeC		:= cCoor
					MsUnLock()
				endif
				Select Trb
				Do while !eof() .and. trb->(Est+Vend)==cChave
					IncProc("6")
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
		Seek xFilial()+trim(cChave1)
		
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+cvend
		cNomv := sa3->a3_nreduz
		cUf   := iif(n==2 .or. n==4 .or. n==5,cEst,sa3->a3_est)
		Seek xFilial()+trim(cCoor)
		cSuper := sa3->a3_nreduz
		
		Select TRBPR1
		seek cCod
		if eof() .and. n==1
			reclock("trbpr1",.t.)
			trbpr1->Produto:= cCod
			MsUnLock()
		endif
		if n==5  //xxyy
			seek cUf+cvend
		endif
		if n==1
			recLock("trbpr1",.f.)
			trbpr1->Produto:= cCod
			trbpr1->Desc   := sb1->b1_desc
		else
			if n<>5
				recLock("trbpr1",.t.)
				//					appe blan
				trbpr1->Uf     := cUf
			endif
			if n==2
				trbpr1->Nome   := cCli
				trbpr1->NReduz := cNReduz
				trbpr1->Regiao := cREGIAO
				trbpr1->SitCli := cSITCLI
				trbpr1->Segmento:= cSEGMENT
				trbpr1->VendCad:= cVENDCAD
				trbpr1->grpcli := cGRPCLI
				trbpr1->Rank	:= nRANK
			endif
			if n<>4 .and.n<>5
				trbpr1->Vend   := cVend
				trbpr1->NomeV  := cNomV
				trbpr1->Nomec  := cSuper
			endif
			if n==5 //xxxxxx
				recLock("trbpr1",.f.)
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
		if CUSTOSTD<>0 .and. (mgreal/CUSTOSTD)<10000
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
		MsUnLock()
		
		nTot1 += nQtd
		nTot2 += nVLB
		nTot3 += nStd
		nTot4 += nMGI
		nTot5 += nMGR
		nTot6 += nValliq
		nTot7 += nCUSTOATU
		nTot8 += nMGAtu
		nTot9 += nCUSTOSIM
		nTot10 += nMgSimul
		Select TRB
	Enddo
	Select TRBPR1
	dbGoTop()
	reclock("trbpr1",.t.)
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
	trbpr1->CUSTOATU :=  nTot7
	trbpr1->MGAtu    :=  nTot8
	trbpr1->CUSTOSIM :=  nTot9
	trbpr1->MgSimul  :=  nTot10
	if MGStd/CUSTOSTD*100 < 100000 .and. MGStd/CUSTOSTD*100 > -10000
		trbpr1->PercStd    := MGStd/CUSTOSTD*100
	endif
	if MGAtu/nTot7*100 < 100000 .and. MGAtu/nTot7*100 > -10000
		trbpr1->PercAtu    := MGAtu/nTot7*100
	endif
	if MGSimul/ntot9*100 < 100000 .and. MGSimul/ntot9*100 > -10000
		trbpr1->PercSim    := MGSimul/ntot9*100
	endif
	MsUnLock()
	Do case
		Case n==1
			totaliza(1)
			copy to \gerencia\MGVDPRD
		Case n==2
			copy to \gerencia\MGVDCLI
		Case n==3
			Select SA3
			Do while !eof()
				IF sa3->a3_regiao='999'
					skip
					loop
				endif
				Select trbpr1
				cTempV := CriaTrab(nil,.f.)
				IndRegua("TRBPR1", cTempV, "Vend", , , "Selecionando Registros...")
				//				index on vend to &cTempV
				seek sa3->a3_cod
				if eof()
					reclock("trbpr1",.t.)
					trbpr1->Vend := sa3->a3_cod
					trbpr1->NomeV:= sa3->a3_nreduz
					trbpr1->Nomec:= sa3->a3_super
					MsUnlock()
				endif
				Select SA3
				skip
			Enddo
			Select TrbPr1
			dbgotop()
			do while !eof()
				Select SA3
				seek xFilial()+trbpr1->Vend
				Select TrbPr1
				if !eof()
					reclock("trbpr1",.f.)
					trbpr1->Nomec:= sa3->a3_super
					MsUnLock()
				endif
				skip
			enddo
			dbgotop()
			copy to \gerencia\MGVDVEN
		Case n==4
			TotUf()
			copy to \gerencia\MGVDUF
		Case n==5
			TotUf1()
			cTempUf := CriaTrab(nil,.f.)
			IndRegua("TRBPR1", cTempV, "Uf+Vend", , , "Selecionando Registros...")
			//			index on Uf+Vend to &cTempUf
			copy to \gerencia\MGVDUFREP
	EndCase
	Use
	
Next N  

//if upper(substr(cUsuario,7,5))=="ADMIN" .or. upper(substr(cUsuario,7,6))=="IRINEU"
	if MsgBox ("Deseja gerar planilha Excel ?","Escolha","YESNO")
		GeraExcel()
	endif
//endif

Return

*****************************
Static Function Totaliza(cTp)
*****************************
dbGoTop()
nRecTot := reccount()
Do while recno()<= nRecTot
	if left(trbpr1->Produto,2)#"29"
		cQuebra := left(trbpr1->Produto,2)
	else
		cQuebra := left(trbpr1->Produto,3)
	endif
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTot7 := nTot8 := nTot9 := nTot10 := 0
	//	cQuebra := left(trbpr1->Produto,2)
	//	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := 0
	//	Do while !eof() .and. left(trbpr1->Produto,2)==cQuebra
	Do while !eof() .and. iif(left(trbpr1->Produto,2)#"29",left(trbpr1->Produto,2)==cQuebra,left(trbpr1->Produto,3)==cQuebra)
		nTot1 += trbpr1->Qtde
		nTot2 += trbpr1->VlBrut
		nTot3 += trbpr1->CUSTOSTD
		nTot4 += trbpr1->MGSTD
		nTot5 += trbpr1->MgReal
		nTot6 += trbpr1->Vlliq
		nTot7 += trbpr1->CUSTOATU
		nTot8 += trbpr1->MGAtu
		nTot9 += trbpr1->CUSTOSIM
		nTot10+= trbpr1->MgSimul
		skip
	Enddo
	nRec := recno()
	if cQuebra#space(2)
		reclock("trbpr1",.t.)
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
		if MGStd/CustoStd*100 < 100000
			trbpr1->PercStd    := MGStd/CustoStd*100
		Endif
		trbpr1->MgReal  := nTot5
		if MGReal/nTot3*100 < 100000 .and. MGReal/nTot3*100 > -10000
			trbpr1->PercReal    := MGReal/nTot3*100
		Endif
		trbpr1->CUSTOATU :=  nTot7
		trbpr1->MGAtu    :=  nTot8
		trbpr1->CUSTOSIM :=  nTot9
		trbpr1->MgSimul  :=  nTot10
		if MGStd/CUSTOSTD*100 < 100000 .and. MGStd/CUSTOSTD*100 > -10000
			trbpr1->PercStd    := MGStd/CUSTOSTD*100
		endif
		if MGAtu/nTot7*100 < 100000 .and. MGAtu/nTot7*100 > -10000
			trbpr1->PercAtu    := MGAtu/nTot7*100
		endif
		if MGSimul/ntot9*100 < 100000 .and. MGSimul/ntot9*100 > -10000
			trbpr1->PercSim    := MGSimul/ntot9*100
		endif
		MsUnLock()
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
	cUf   := Est
	cVend := Vend
	nQtd  := 0
	Do while !eof() .and. Est==cUf
		IncProc("7")
		cCli := codcli
		Do while !eof() .and. Codcli==cCli
			skip
		Enddo
		nQtd++
	Enddo
	Select TRBPR1
	//	Seek cUf
	reclock("trbpr1",.f.)
	TRBPR1->qtdcli := nQtd
	MsUnLock()
	Select TRB
Enddo
cUf := "AC*AL*AM*AP*BA*CE*DF*ES*GO*MA*MG*MS*MT*PA*PB*PE*PI*PR*RJ*RN*RO*RR*RS*SC*SE*SP*TO"

For x:=1 to len(cUf)
	Select TRBPR1
	//	Seek substr(cUf,x,2)
	if eof()
		reclock("trbpr1",.t.)
		TrbPr1->Uf := substr(cUf,x,2)
		MsUnLock()
	endif
	x++
	x++
Next x
Select TRBPR1

Return

*****************************
Static Function TotUF1()
*****************************
Select TRB
ProcRegua(reccount())
li := 80
nTotCli := 0
dbGoTop()
Do while !eof()
	cUf  := Est
	cVend := Vend
	nQtd := 0
	Do while !eof() .and. Est==cUf .and. Vend =cVend
		IncProc("8")
		cCli := codcli
		Do while !eof() .and. Codcli==cCli
			skip
		Enddo
		nQtd++
	Enddo
	Select TRBPR1
	//	Seek cUf+cVend
	reclock("trbpr1",.f.)
	TRBPR1->qtdcli := nQtd
	MsUnLock()
	Select TRB
Enddo
Select TRBPR1
dbGoTop()
nRecTot := reccount()
Do while recno()<= nRecTot .and. 1==2  // Desabilitei
	cQuebra := Uf
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := 0
	nQTDCLIUF:=nQTDCLI:=nDESATIVA:=	nATIVO:=nREATIVAD:=	nINATIVO:=0
	
	Do while !eof() .and. Uf==cQuebra
		nTot1 += trbpr1->Qtde
		nTot2 += trbpr1->VlBrut
		nTot3 += trbpr1->CUSTOSTD
		nTot4 += trbpr1->MGSTD
		nTot5 += trbpr1->MgReal
		nTot6 += trbpr1->Vlliq
		nQTDCLIUF+=QTDCLIUF
		nQTDCLI+=QTDCLI
		nDESATIVA+=	DESATIVA
		nATIVO+= ativo
		nREATIVAD+=	REATIVAD
		nINATIVO+=INATIVO
		skip
	Enddo
	nRec := recno()
	if cQuebra#space(2)
		reclock("trbpr1",.t.)
		trbpr1->Uf := left(cquebra,2)
		trbpr1->Vend:= "="
		trbpr1->Nomev   := "Total"
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
		trbpr1->QTDCLIUF:=nQTDCLIUF
		trbpr1->QTDCLI:=nQTDCLI
		trbpr1->DESATIVA:=	nDESATIVA
		trbpr1->ATIVO:= nativo
		trbpr1->REATIVAD:=	nREATIVAD
		trbpr1->INATIVO:=nINATIVO
		
		if MGSTD<>0
			trbpr1->percReal   := (mgreal/CUSTOSTD)*100
		endif
		MsUnLock()
	Endif
	Goto nRec
Enddo

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
//Copy to &ctrb2 next 1000000 for d1_dtdigit<=mv_par02 .and. d1_tipo=="D" .and.;
//d1_fornece>=mv_par07 .and. d1_fornece<=mv_par08
cQuery := " SELECT D1_FILIAL,D1_SERIE,D1_DOC,D1_DTDIGIT,D1_FORNECE,D1_LOJA,D1_TES,"
cQuery += " D1_NFORI,D1_SERIORI,D1_COD,D1_TOTAL,D1_QUANT FROM "
cQuery +=   RetSqlName("SD1")+" WHERE D_E_L_E_T_<>'*' AND "
cQuery += "  D1_DTDIGIT BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery += "  AND d1_tipo='D' AND D1_FORNECE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"

IF Select("TRB2") <> 0
	TRB2->(DbCloseArea())
Endif

TcQuery cQuery Alias "TRB2" New
dbSelectArea("TRB2")
dBGotop()

//dbUseArea( .T.,, cTrb2,"TRB2", .F., .F. )
ProcRegua(reccount())
go top
Do while !eof()
	IncProc("9")
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
//	if sc5->c5_vend1<mv_par03 .or. sc5->c5_vend1>mv_par04
//		Skip
//		loop
//	Endif
	cTrbDev := Criatrab(nil,.f.)
//	Copy to &cTrbDev next 1
	Select TRB1
//	append from &cTrbDev
//	erase &(trim(cTrbDev)+".dtc")
	cPedOri := " "
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+sd2->d2_pedido+sd2->d2_itempv
	nTotLiq := nTotCust := nTotMg := nValPedx := nValMDO := nValAdic := 0
	do while !eof() .and. sd2->(d2_pedido+d2_itempv)==sc6->(c6_num+c6_item)
		if sc6->c6_produto<>trb2->d1_cod
			skip
			loop
		endif
		nValPedx := nValPedx + trb2->d1_total
		
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
//		verStd()
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
		nValLiqx := nVCpmf := nIcms1 := nIcm   := nIpi1 := nIcmST   := 0
		nCom1   := nCom2  := nFin1  := ne1:= nIr   := nValAdic := 0
		nPC     := nTotZFR:= nZfr   := 0
		nVlPedx  := trb2->d1_quant*sc6->c6_prcven
		nQtdEntx:= trb2->d1_quant
		nCStd1 := nCStd2 := nCStd3 := 0
		if sc6->c6_tes$'512*543*559'
			if sc6->c6_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
				nAliqZF := 0.1065
			else
				nAliqZF := 0.07
			endif
			if nFator#0
				nTotZFR := (nVlPedx/nfator)*nAliqZF
				nVlPedx  := nVlPedx-nTotZFR
			endif
		endif
		u_pCalcVLiq(nVlPed)//CalcVLiq()
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
		trb->qtde   := nQtdEntx*(-1)
		trb->entrega:= sc6->c6_entreg
		trb->emissao:= sc5->C5_EMISSAO
		trb->valliq := nValLiqx*(-1)
		trb->valbrut:= nVlPedx*(-1)
		trb->CUSTOSTD := iif(sm0->m0_codigo#"02",nCstd * nQtdEntx,nCstd)*(-1)
		trb->MGSTD:= nMarg * nQtdEntx*(-1)
		trb->mgreal := (nValLiqx+trb->CUSTOSTD)/(1+(mv_par05)/100)*(-1)
		//		trb->perc   := (trb->mgreal/trb->MGSTD)*100
		trb->percReal   := (trb->mgreal/trb->CUSTOSTD)*100
		trb->acresc := mv_par05
		trb->verbadic:= sa1->a1_mgextra
		trb->valadic:= nValAdic*(-1)
		//		trb->valmerc:= if(nFator#0,(nVlPed-nTotZFR)/nFator,0)*(-1)
		trb->valmerc:= if(nFator#0,(nVlPedx)/nFator,0)*(-1)
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
		
		nTotLiq  := nTotLiq + nValLiqx
		nTotCust := nTotCust+ trb->CUSTOSTD
		nTotMg   := nTotMg  + (nMarg * nQtdEntx)
		
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

*************************
//Static Function VerAtiv()  // Verifica se o cliente esta Ativo/inativo
*************************  // Reativado/Desativado (per.180 dias)

Select SA1
dbSetOrder(1)  // Verifica o grupo todo
ProcRegua(Reccount())
dbGoTop()
dData1 := lastday(mv_par02)
dData2 := firstday(mv_par02)
dData3 := lastday(mv_par02-210)
dData4 := firstday(mv_par02-210)
aVend := {}
aEst  := {}
aChave := {}
aCliEstV := {}
Do while !eof()
	IncProc(recno(),reccount())
	if a1_regiao='999'
		skip
		loop
	endif
	cGrupo	:= sa1->a1_cod
	n5  := 0 // Outros
	n4  := 0 // Compra > 180 dias
	n3  := 0 // Compra entre 180 e 150 dias
	n2  := 0 // Compra entre 150 e 030 dias
	n1  := 0 // Compra entre 0 e 30 dias
	Do while !eof() .and. cGrupo == sa1->a1_cod
		if sa1->a1_regiao='999'
			skip
			loop
		endif
		Select SC5
		dbSetOrder(3)
		Seek xFilial()+sa1->(a1_cod)
		do while !eof() .and. sc5->(c5_cliente)==sa1->(a1_cod)
			Do Case
				Case c5_emissao<dData4
					n4  :=1
				Case c5_emissao>=dData4 .and. c5_emissao<dData3
					n3  :=1
				Case c5_emissao>=dData3 .and. c5_emissao<dData2
					n2  :=1
				Case c5_emissao>=dData2
					n1  :=1
				otherwise
					n5 := 1
			EndCase
			skip
		Enddo
		Select SA1
		// Por Estado/Cliente/Repres
		nLinha := Ascan(aCliEstV, {|x|x[1] == sa1->(a1_est+a1_vend)})
		If nLinha != 0
			aCliEstV[nLinha][2] := aCliEstV[nLinha][2] + 1
		Else
			aAdd(aCliEstV,{sa1->(a1_est+a1_vend),1})
		Endif
		skip
	Enddo
	do Case
		Case n1 ==1 .and. n2==1
			cCond := "A"
		Case n2 ==1
			cCond := "A"
		Case n1=1 .and. n2=0 .and. n3=0 .and. n4=0 .and. n5=0
			cCond := "A"
		Case n1=0 .and. n2=0 .and. n3=0
			cCond := "I"
		Case n1=1 .and. n2=0 .and. n4=1
			cCond := "R"
		Case n1=0 .and. n2=0 .and. n3=1
			cCond := "D"
	EndCase
	Select SA1
	Seek xFilial()+cGrupo
	Do while !eof() .and. cGrupo == sa1->a1_cod
		if a1_regiao='999'
			skip
			loop
		endif
		reclock("SA1",.f.)
		SA1->A1_SATIV8 := cCond
		MsUnLock()
		// Por Representante
		nLinha := Ascan(aVend, {|x|x[1] == sa1->a1_vend})
		If nLinha != 0
			aVend[nLinha][2] := aVend[nLinha][2] + iif(cCond="D",1,0)
			aVend[nLinha][3] := aVend[nLinha][3] + iif(cCond="A",1,0)
			aVend[nLinha][4] := aVend[nLinha][4] + iif(cCond="R",1,0)
			aVend[nLinha][5] := aVend[nLinha][5] + iif(cCond="I",1,0)
		Else
			aAdd(aVend,{sa1->a1_vend,iif(cCond="D",1,0),iif(cCond="A",1,0),iif(cCond="R",1,0),iif(cCond="I",1,0)})
		Endif
		// Por Estado
		nLinha := Ascan(aest, {|x|x[1] == sa1->a1_est})
		If nLinha != 0
			aest[nLinha][2] := aest[nLinha][2] + iif(cCond="D",1,0)
			aest[nLinha][3] := aest[nLinha][3] + iif(cCond="A",1,0)
			aest[nLinha][4] := aest[nLinha][4] + iif(cCond="R",1,0)
			aest[nLinha][5] := aest[nLinha][5] + iif(cCond="I",1,0)
		Else
			aAdd(aest,{sa1->a1_est,iif(cCond="D",1,0),iif(cCond="A",1,0),iif(cCond="R",1,0),iif(cCond="I",1,0)})
		Endif
		// Por Chave
		nLinha := Ascan(aChave, {|x|x[1] == sa1->(a1_est+a1_vend)})
		If nLinha != 0
			aChave[nLinha][2] := aChave[nLinha][2] + iif(cCond="D",1,0)
			aChave[nLinha][3] := aChave[nLinha][3] + iif(cCond="A",1,0)
			aChave[nLinha][4] := aChave[nLinha][4] + iif(cCond="R",1,0)
			aChave[nLinha][5] := aChave[nLinha][5] + iif(cCond="I",1,0)
		Else
			aAdd(aChave,{sa1->(a1_est+a1_vend),iif(cCond="D",1,0),iif(cCond="A",1,0),iif(cCond="R",1,0),iif(cCond="I",1,0)})
		Endif
		
		skip
	Enddo
Enddo

Return

Static Function UfXVen()

Select SA1
dbSetOrder(1)
dbgotop()
do while !eof()
	if sa1->a1_regiao='999'
		skip
		loop
	endif
	cCond := SA1->A1_SATIV8
	Select SA3
	dbSetOrder(1)
	seek xFilial()+sa1->A1_Vend
	Select TrbPr1
	seek sa1->(A1_EST+A1_VEND)  //index on EST+Vend to &cTemp
	RecLock("TRBPR1",eof())
	trbpr1->Uf			:= sa1->a1_est
	trbpr1->Vend		:= sa1->a1_vend
	trbpr1->NomeV		:= sa3->a3_nreduz
	trbpr1->QtdCliUf	:= QtdCliUf + 1
	Do Case
		Case cCond = "A"
			trbpr1->Ativo := Ativo + 1
		Case cCond = "D"
			trbpr1->DesAtiva := Desativa + 1
		Case cCond = "R"
			trbpr1->Reativad := reativad + 1
		Case cCond = "I"
			trbpr1->Inativo := Inativo + 1
		Otherwise
			trbpr1->DesAtiva := Desativa + 1
	Endcase
	MsUnLock()
	Select SA1
	Skip
Enddo

Static Function Coord()

cTemp12m := CriaTrab(nil,.f.)
IndRegua("TRBPRN", cTemp12m, "Coor+Vend", , , "Selecionando Registros...")
//index on Coor+Vend to &cTemp12m
dbGoTop()
Do while !eof()
	If li > 70
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	cCoor  := trbprn->Coor
	nTot0 := nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	nTot01 := nTot02 := nTot03 := nTot04 := nTot05 := nTot06 := 0
	nTotMeta := 0
	nCol1 := nCol2 := nCol3 := nCol4 := nCol5 := nCol6 := 0
	nMeta := 0
	Do while !eof() .and. Coor = cCoor
		if left(nReduz,2)="99"
			nMeta := nMeta + Meta
		endif
		nCol=50
		do case
			case trim(nReduz)=dtos(cSemana1)
				ntot01 +=  VlBrut
				nCol1 = 52
			case trim(nReduz)=dtos(cSemana2)
				ntot02 +=  VlBrut
				nCol2 = 64
			case trim(nReduz)=dtos(cSemana3)
				ntot03 +=  VlBrut
				nCol3 = 76
			case trim(nReduz)=dtos(cSemana4)
				ntot04 +=  VlBrut
				nCol4 = 88
			case trim(nReduz)=dtos(cSemana5)
				ntot05 +=  VlBrut
				nCol5 = 100
			otherwise
				ntot06 +=  VlBrut
				nCol6 = 112
		Endcase
		if VLBrut<>0
			//			@ li,nCol PSAY VlBrut               picture "@E 9999,999"
		endif
		nTot1 := nTot1 +VlBrut
		nTot6 := nTot6 +Meta
		skip
	Enddo
	Select SA3
	dbSetOrder(1)
	Seek xFilial()+cCoor
	Select TRBPRN
	@ li,000 PSAY left(cCoor,3)+"-"+sa3->a3_nreduz //+left(sa3->a3_nome,20)
	@ li,038 PSAY nMeta         picture "@E 99,999,999"
	@ li,052 PSAY ntot01        picture "@E 9999,999"
	@ li,064 PSAY nTot02        picture "@E 9999,999"
	@ li,076 PSAY nTot03        picture "@E 9999,999"
	@ li,088 PSAY nTot04        picture "@E 9999,999"
	@ li,100 PSAY nTot05        picture "@E 9999,999"
	@ li,112 PSAY nTot06        picture "@E 9999,999"
	li:=li+1
	@ li,038 PSAY 100         				picture "@E 9999.99%"
	@ li,052 PSAY ntot01/nMeta*100         	picture "@E 9,999.99%"
	@ li,064 PSAY (nTot01+nTot02)/nMeta*100 picture "@E 9,999.99%"
	@ li,076 PSAY (nTot01+nTot02+nTot03)/nMeta*100 			     picture "@E 9,999.99%"
	@ li,088 PSAY (nTot01+nTot02+nTot03+nTot04)/nMeta*100        picture "@E 9,999.99%"
	@ li,100 PSAY (nTot01+nTot02+nTot03+nTot04+nTot05)/nMeta*100 picture "@E 9,999.99%"
	@ li,112 PSAY (nTot01+nTot02+nTot03+nTot04+nTot05)/nMeta*100 picture "@E 9,999.99%"
	li:=li+1
	@ li,000 PSAY replicate("-",132)
	li:=li+1
	nTotMeta += Meta
Enddo

Return

Static Function GeraExcel()

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
Local oSection7:= Nil
Local oBreak
Local oFunction

oReport := TReport():New(cNome,"Margem dos Pedidos",cNome,{|oReport| ReportPrint(oReport)},"PedidosXmargem")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Margem Pedidos", {"TRB"}, , .F., .T.)

TRCell():New(oSection1,"NUM","TRB","Pedido"  ,"@!",10)
TRCell():New(oSection1,"ITEM","TRB","Item"  ,"@!",04)
TRCell():New(oSection1,"CODCLI","TRB","Cod.Cli."  ,"@!",06)
TRCell():New(oSection1,"LOJA","TRB","Loja"  ,"@!",02)
TRCell():New(oSection1,"GRPCLI","TRB","Grupo Cli"  ,"@!",08)
TRCell():New(oSection1,"CLI","TRB","Nome Cli"  ,"@!",40)
TRCell():New(oSection1,"NREDUZ","TRB","Nome Fantasia"  ,"@!",20)
TRCell():New(oSection1,"RANK","TRB","Ranking"  ,"9999",04)
TRCell():New(oSection1,"VEND","TRB","Vendedor"  ,"@!",06)
TRCell():New(oSection1,"COOR","TRB","Coord."  ,"@!",06)
TRCell():New(oSection1,"COD","TRB","Cód.prod."  ,"@!",15)
TRCell():New(oSection1,"DESC","TRB","Descrição"  ,"@!",50)
TRCell():New(oSection1,"QTDE","TRB", "Quantidade","@E 999,999,999.99",15)
TRCell():New(oSection1,"QTDEM2","TRB", "Quant.M2","@E 999,999,999.99",15)
TRCell():New(oSection1,"EMISSAO","TRB", "Dt.Emissao","@!",10)
TRCell():New(oSection1,"ENTREGA","TRB", "Dt.entrega","@!",10)
TRCell():New(oSection1,"VALBRUT","TRB", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALLIQ","TRB", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection1,"CUSTOSTD","TRB", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection1,"MGSTD","TRB", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCSTD","TRB", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection1,"MGREAL","TRB", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCREAL","TRB", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection1,"CUSTOATU","TRB", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection1,"MGATU","TRB", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCATU","TRB", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection1,"CUSTOSIM","TRB", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection1,"MGSIMUL","TRB", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCSIM","TRB", "Perc.Simulado","@E 9,999.99",15)
TRCell():New(oSection1,"ACRESC","TRB", "Acréscimo","@E 999,999,999.99",15)
TRCell():New(oSection1,"VERBADIC","TRB", "Verba Adicional","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALMERC","TRB", "Valor Mercadoria","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALIPI" ,"TRB", "Valor IPI","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALADIC","TRB", "Valor Adicional","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALCPMF" ,"TRB", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALICMS","TRB", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALICMST" ,"TRB", "Valor ICMS ST","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALPC","TRB", "Valor Pis/Cofins","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALIR" ,"TRB", "Valor IR","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALCOM" ,"TRB", "Valor Comissão","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALCOM2","TRB", "Valor Comissão Coord.","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALFIN" ,"TRB", "Valor Financeiro","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALFRET","TRB", "Valor Frete","@E 999,999,999.99",15)
TRCell():New(oSection1,"DESCZFR" ,"TRB", "Descto. Zona Franca","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCCOM" ,"TRB", "Perc.Comiss","@E 999,999,999.99",15)
TRCell():New(oSection1,"TP"     ,"TRB", "Tipo","@!",02)
TRCell():New(oSection1,"FRETE"    ,"TRB", "Frete","@!",08)
TRCell():New(oSection1,"PERFRET"  ,"TRB", "Perc.Frete","@e 999.99",06)
TRCell():New(oSection1,"EST"     ,"TRB", "UF","@!",02)
TRCell():New(oSection1,"ESTGRP"   ,"TRB", "Grupo Est.","@!",02)
TRCell():New(oSection1,"TES"     ,"TRB", "TES","@!",04)
TRCell():New(oSection1,"CONDPAG"  ,"TRB", "Condic.Pagto.","@!",10)
TRCell():New(oSection1,"TPVEND"    ,"TRB", "Frete","@!",08)
TRCell():New(oSection1,"QTDE2"  ,"TRB", "Qtde 2a Um","@e 999,999.99",09)
TRCell():New(oSection1,"ALIQICM"  ,"TRB", "Aliq.ICMS","@e 999.99",06)
TRCell():New(oSection1,"ALIQIPI"  ,"TRB", "Aliq.IPI","@e 999.99",06)
TRCell():New(oSection1,"NCM"    ,"TRB", "NCM","@!",08)
TRCell():New(oSection1,"CNPJ"    ,"TRB", "CNPJ","@!",08)
TRCell():New(oSection1,"PEDORI"    ,"TRB", "Pedido Original","@!",08)
TRCell():New(oSection1,"RM1"    ,"TRB", "RM1","@!",02)
TRCell():New(oSection1,"RM2"    ,"TRB", "RM2","@!",02)
TRCell():New(oSection1,"RM3"    ,"TRB", "RM3","@!",02)
TRCell():New(oSection1,"OK"    ,"TRB", "OK","@!",02)
TRCell():New(oSection1,"SEGMENTO"   ,"TRB", "Segmento","@!",10)
TRCell():New(oSection1,"REGIAO"   ,"TRB", "Região","@!",10)
TRCell():New(oSection1,"SITCLI"   ,"TRB", "Situação Cli.","@!",10)
TRCell():New(oSection1,"VENDCAD"   ,"TRB", "Vendedor Cadastro","@!",10)
TRCell():New(oSection1,"DATAFAT"   ,"TRB", "Data Fatura","@!",10)
TRCell():New(oSection1,"DATASAI"   ,"TRB", "Data Saída","@!",10)
TRCell():New(oSection1,"PRODUTO"   ,"TRB", "Produto","@!",15)
TRCell():New(oSection1,"STDPROD"   ,"TRB", "Std.Produto","@e 999,999.99",12)

// Section 2
IF SELECT("TRBPRD") # 0
	TRBPRD->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\gerencia\MGVDPRD.dtc","TRBPRD", Nil, .F. )
oSection2:= TRSection():New(oReport, "Vendas X Produto ", {"TRBPRD"}, , .F., .T.)

TRCell():New(oSection2,"PRODUTO","TRBPROD","Cód.prod."  ,"@!",15)
TRCell():New(oSection2,"DESC","TRBPROD","Descrição"  ,"@!",50)
TRCell():New(oSection2,"QTDE","TRBPROD", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection2,"QTDEP","TRBPROD", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection2,"VLBRUT","TRBPROD", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection2,"VLBRUTP","TRBPROD", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection2,"VLLIQ","TRBPROD", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection2,"VLLIQP","TRBPROD", "Valor.Liq.P","@E 999,999,999.99",15)
TRCell():New(oSection2,"CUSTOSTD","TRBPROD", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection2,"CUSTOSTDP","TRBPROD", "Custo Std.P","@E 999,999,999.99",15)
TRCell():New(oSection2,"MGSTD","TRBPROD", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCSTD","TRBPROD", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection2,"MGREAL","TRBPROD", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCREAL","TRBPROD", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection2,"CUSTOATU","TRBPROD", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection2,"MGATU","TRBPROD", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCATU","TRBPROD", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection2,"CUSTOSIM","TRBPROD", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection2,"MGSIMUL","TRBPROD", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCSIM","TRBPROD", "Perc.Simulado","@E 9,999.99",15)

Use

// Section 3
dbUseArea( .T.,,"\GERENCIA\MGVDCLI","TRBCLI", Nil, .F. )
oSection3:= TRSection():New(oReport, "Vendas x Cliente ", {"TRBCLI"}, , .F., .T.)

TRCell():New(oSection3,"GRPCLI","TRBCLI", "Grupo Cli"  ,"@!",08)
TRCell():New(oSection3,"CLI","TRBCLI", "Cod.Cli."  ,"@!",08)
TRCell():New(oSection3,"NOME","TRBCLI", "Nome Cli"  ,"@!",40)
TRCell():New(oSection3,"NREDUZ","TRBCLI", "Nome Fantasia"  ,"@!",20)
TRCell():New(oSection3,"UF","TRBCLI", "UF"  ,"@!",02)
TRCell():New(oSection3,"VEND","TRBCLI", "Vendedor"  ,"@!",06)
TRCell():New(oSection3,"RANK","TRBCLI", "Ranking"  ,"9999",04)
TRCell():New(oSection3,"NOMEV","TRBCLI", "Nome Vendedor"  ,"@!",20)
TRCell():New(oSection3,"NOMEC","TRBCLI", "Nome Coord."  ,"@!",20)
TRCell():New(oSection3,"SEGMENTO","TRBCLI", "Segmento"  ,"@!",10)
TRCell():New(oSection3,"REGIAO","TRBCLI", "Região"  ,"@!",10)
TRCell():New(oSection3,"SITCLI","TRBCLI", "Situação Cli"  ,"@!",1)
TRCell():New(oSection3,"VENDCAD","TRBCLI", "Vendedor Cad."  ,"@!",06)
TRCell():New(oSection3,"QTDE","TRBCLI", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection3,"QTDEP","TRBCLI", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection3,"VLBRUT","TRBCLI", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection3,"VLBRUTP","TRBCLI", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection3,"VLLIQ","TRBCLI", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection3,"VLLIQP","TRBCLI", "Valor.Liq.P","@E 999,999,999.99",15)
TRCell():New(oSection3,"CUSTOSTD","TRBCLI", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection3,"CUSTOSTDP","TRBCLI", "Custo Std.P","@E 999,999,999.99",15)
TRCell():New(oSection3,"MGSTD","TRBCLI", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCSTD","TRBCLI", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection3,"MGREAL","TRBCLI", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCREAL","TRBCLI", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection3,"CUSTOATU","TRBCLI", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection3,"MGATU","TRBCLI", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCATU","TRBCLI", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection3,"CUSTOSIM","TRBCLI", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection3,"MGSIMUL","TRBCLI", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCSIM","TRBCLI", "Perc.Simulado","@E 9,999.99",15)

Use

// Section 4 - // Por Vendedor
dbUseArea( .T.,,"\GERENCIA\MGVDVEN","TRBVEN", Nil, .F. )
oSection4:= TRSection():New(oReport, "Vendas x Vendedor ", {"TRBVEN"}, , .F., .T.)

TRCell():New(oSection4,"VEND"		,"TRBVEN", "Vendedor"  ,"@!",06)
TRCell():New(oSection4,"NOMEV"		,"TRBVEN", "Nome Vendedor"  ,"@!",20)
TRCell():New(oSection4,"NOMEC"		,"TRBVEN", "Nome Coord."  ,"@!",20)
TRCell():New(oSection4,"UF"			,"TRBVEN", "UF"  ,"@!",02)
TRCell():New(oSection4,"QTDE"		,"TRBVEN", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection4,"QTDEP"		,"TRBVEN", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection4,"VLBRUT"		,"TRBVEN", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection4,"VLBRUTP"	,"TRBVEN", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection4,"VLLIQ"		,"TRBVEN", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection4,"VLLIQP"		,"TRBVEN", "Valor.Liq.P","@E 999,999,999.99",15)
TRCell():New(oSection4,"CUSTOSTD"	,"TRBVEN", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection4,"CUSTOSTDP"	,"TRBVEN", "Custo Std.P","@E 999,999,999.99",15)
TRCell():New(oSection4,"MGSTD"		,"TRBVEN", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection4,"PERCSTD"	,"TRBVEN", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection4,"MGREAL"		,"TRBVEN", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection4,"PERCREAL"	,"TRBVEN", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection4,"CUSTOATU"	,"TRBVEN", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection4,"MGATU"		,"TRBVEN", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection4,"PERCATU"	,"TRBVEN", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection4,"CUSTOSIM"	,"TRBVEN", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection4,"MGSIMUL"	,"TRBVEN", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection4,"PERCSIM"	,"TRBVEN", "Perc.Simulado","@E 9,999.99",15)

Use

// Section 5 - // Por Nota Fiscal
dbUseArea( .T.,,"\GERENCIA\MGVDUFREP","TRBUF", Nil, .F. )
oSection5:= TRSection():New(oReport, "Vendas. x UF ", {"TRBUF"}, , .F., .T.)

TRCell():New(oSection5,"UF"			,"TRBVEN", "UF"  ,"@!",02)
TRCell():New(oSection5,"VEND"		,"TRBVEN", "Vendedor"  ,"@!",06)
TRCell():New(oSection5,"NOMEC"		,"TRBVEN", "Nome Coord."  ,"@!",20)
TRCell():New(oSection5,"NOMEV"		,"TRBVEN", "Nome Vendedor"  ,"@!",20)
TRCell():New(oSection5,"QTDCLIUF"	,"TRBVEN", "Qtde.Cli. UF","@E 999,999,999.99",15)
TRCell():New(oSection5,"QTDCLI"		,"TRBVEN", "Qtde.Clientes","@E 999,999,999.99",15)
TRCell():New(oSection5,"DESATIVA"	,"TRBVEN", "Qtde.Desativar","@E 999,999,999.99",15)
TRCell():New(oSection5,"ATIVO"		,"TRBVEN", "Qtde.Ativos","@E 999,999,999.99",15)
TRCell():New(oSection5,"REATIVAD"	,"TRBVEN", "Qtde.Reativados","@E 999,999,999.99",15)
TRCell():New(oSection5,"INATIVO"	,"TRBVEN", "Qtde.Inativos","@E 999,999,999.99",15)
TRCell():New(oSection5,"QTDE"		,"TRBVEN", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection5,"QTDEP"		,"TRBVEN", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection5,"VLBRUT"		,"TRBVEN", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection5,"VLBRUTP"	,"TRBVEN", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection5,"VLLIQ"		,"TRBVEN", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection5,"VLLIQP"		,"TRBVEN", "Valor.Liq.P","@E 999,999,999.99",15)
TRCell():New(oSection5,"CUSTOSTD"	,"TRBVEN", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection5,"CUSTOSTDP"	,"TRBVEN", "Custo Std.P","@E 999,999,999.99",15)
TRCell():New(oSection5,"MGSTD"		,"TRBVEN", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection5,"PERCSTD"	,"TRBVEN", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection5,"MGREAL"		,"TRBVEN", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection5,"PERCREAL"	,"TRBVEN", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection5,"CUSTOATU"	,"TRBVEN", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection5,"MGATU"		,"TRBVEN", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection5,"PERCATU"	,"TRBVEN", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection5,"CUSTOSIM"	,"TRBVEN", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection5,"MGSIMUL"		,"TRBVEN", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection5,"PERCSIM"	,"TRBVEN", "Perc.Simulado","@E 9,999.99",15)

Use

// Section 6 - // Por Semana
dbUseArea( .T.,,"\GERENCIA\MGVDVND_SEMANA","TRBCLI", Nil, .F. )
oSection6:= TRSection():New(oReport, "Vendas x Semana ", {"TRBCLI"}, , .F., .T.)

TRCell():New(oSection6,"VEND","TRBCLI", "Vendedor"  ,"@!",06)
TRCell():New(oSection6,"COOR","TRBCLI", "Coordenador"  ,"@!",06)
TRCell():New(oSection6,"META","TRBCLI", "Meta","@E 999,999,999.99",15)
TRCell():New(oSection6,"VLBRUT","TRBCLI", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection6,"CUSTOSTD","TRBCLI", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection6,"MGSTD","TRBCLI", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection6,"PERCSTD","TRBCLI", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection6,"MGREAL","TRBCLI", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection6,"PERCREAL","TRBCLI", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection6,"PESO","TRBCLI", "Peso","@E 9,999.99",15)

Use

// Section 7 - // Por Pedido

oSection7 := TRSection():New(oReport,"Margem Pedidos (Resumo)", {"TRB"}, , .F., .T.)

TRCell():New(oSection7,"NUM","TRB","Pedido"  ,"@!",10)
TRCell():New(oSection7,"CODCLI","TRB","Cod.Cli."  ,"@!",06)
TRCell():New(oSection7,"LOJA","TRB","Loja"  ,"@!",02)
TRCell():New(oSection7,"GRPCLI","TRB","Grupo Cli"  ,"@!",08)
TRCell():New(oSection7,"CLI","TRB","Nome Cli"  ,"@!",40)
TRCell():New(oSection7,"NREDUZ","TRB","Nome Fantasia"  ,"@!",20)
TRCell():New(oSection7,"RANK","TRB","Ranking"  ,"9999",04)
TRCell():New(oSection7,"VEND","TRB","Vendedor"  ,"@!",06)
TRCell():New(oSection7,"COOR","TRB","Coord."  ,"@!",06)
TRCell():New(oSection7,"QTDE","TRB", "Quantidade","@E 999,999,999.99",15)
TRCell():New(oSection7,"QTDEM2","TRB", "Quant.M2","@E 999,999,999.99",15)
TRCell():New(oSection7,"EMISSAO","TRB", "Dt.Emissao","@!",10)
TRCell():New(oSection7,"ENTREGA","TRB", "Dt.entrega","@!",10)
TRCell():New(oSection7,"VALBRUT","TRB", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALLIQ","TRB", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection7,"CUSTOSTD","TRB", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection7,"MGSTD","TRB", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCSTD","TRB", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection7,"MGREAL","TRB", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCREAL","TRB", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection7,"CUSTOATU","TRB", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection7,"MGATU","TRB", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCATU","TRB", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection7,"CUSTOSIM","TRB", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection7,"MGSIMUL","TRB", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCSIM","TRB", "Perc.Simulado","@E 9,999.99",15)
TRCell():New(oSection7,"ACRESC","TRB", "Acréscimo","@E 999,999,999.99",15)
TRCell():New(oSection7,"VERBADIC","TRB", "Verba Adicional","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALMERC","TRB", "Valor Mercadoria","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALIPI" ,"TRB", "Valor IPI","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALADIC","TRB", "Valor Adicional","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALCPMF" ,"TRB", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALICMS","TRB", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALICMST" ,"TRB", "Valor ICMS ST","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALPC","TRB", "Valor Pis/Cofins","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALIR" ,"TRB", "Valor IR","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALCOM" ,"TRB", "Valor Comissão","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALCOM2","TRB", "Valor Comissão Coord.","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALFIN" ,"TRB", "Valor Financeiro","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALFRET","TRB", "Valor Frete","@E 999,999,999.99",15)
TRCell():New(oSection7,"DESCZFR" ,"TRB", "Descto. Zona Franca","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCCOM" ,"TRB", "Perc.Comiss","@E 999,999,999.99",15)
TRCell():New(oSection7,"TP"     ,"TRB", "Tipo","@!",02)
TRCell():New(oSection7,"FRETE"    ,"TRB", "Frete","@!",08)
TRCell():New(oSection7,"PERFRET"  ,"TRB", "Perc.Frete","@e 999.99",06)
TRCell():New(oSection7,"EST"     ,"TRB", "UF","@!",02)
TRCell():New(oSection7,"ESTGRP"   ,"TRB", "Grupo Est.","@!",02)
TRCell():New(oSection7,"TES"     ,"TRB", "TES","@!",04)
TRCell():New(oSection7,"CONDPAG"  ,"TRB", "Condic.Pagto.","@!",10)
TRCell():New(oSection7,"TPVEND"    ,"TRB", "Frete","@!",08)
TRCell():New(oSection7,"QTDE2"  ,"TRB", "Qtde 2a Um","@e 999,999.99",09)
TRCell():New(oSection7,"CNPJ"    ,"TRB", "CNPJ","@!",08)
TRCell():New(oSection7,"PEDORI"    ,"TRB", "Pedido Original","@!",08)
TRCell():New(oSection7,"SEGMENTO"   ,"TRB", "Segmento","@!",10)
TRCell():New(oSection7,"REGIAO"   ,"TRB", "Região","@!",10)
TRCell():New(oSection7,"SITCLI"   ,"TRB", "Situação Cli.","@!",10)
TRCell():New(oSection7,"VENDCAD"   ,"TRB", "Vendedor Cadastro","@!",10)
TRCell():New(oSection7,"DATAFAT"   ,"TRB", "Data Fatura","@!",10)
TRCell():New(oSection7,"DATASAI"   ,"TRB", "Data Saída","@!",10)

//Final seção 7

TRFunction():New(oSection3:Cell("CLI"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por seção
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)	 // Abrir a seção Alíquota
Local oSection4 := oReport:Section(4)	 // Abrir a seção Produto
Local oSection5 := oReport:Section(5)	 // Abrir a seção Nota Fiscal
Local oSection6 := oReport:Section(6)	 // Abrir a seção Vendas X Semana
Local oSection7 := oReport:Section(7)	 // Abrir a seção Pedidos

Local cQuery    := ""
Local cPedido   := ""
Local lPrim 	:= .T.

dbSelectArea("TRB")
TRB->(dbGoTop())

oReport:SetMeter(TRB->(LastRec()))

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
		
		//imprimo a primeira seção
		oSection1:Cell('NUM'):SetValue(TRB->NUM)
		oSection1:Cell('ITEM'):SetValue(TRB->ITEM)
		oSection1:Cell('CODCLI'):SetValue(TRB->CODCLI)
		oSection1:Cell('LOJA'):SetValue(TRB->LOJA)
		oSection1:Cell('GRPCLI'):SetValue(TRB->GRPCLI)
		oSection1:Cell('CLI'):SetValue(TRB->CLI)
		oSection1:Cell('NREDUZ'):SetValue(TRB->NREDUZ)
		oSection1:Cell('RANK'):SetValue(TRB->RANK)
		oSection1:Cell('VEND'):SetValue(TRB->VEND)
		oSection1:Cell('COOR'):SetValue(TRB->COOR)
		oSection1:Cell('COD'):SetValue(TRB->COD)
		oSection1:Cell('DESC'):SetValue(TRB->DESC)
		oSection1:Cell('QTDE'):SetValue(TRB->QTDE)
		oSection1:Cell('QTDEM2'):SetValue(TRB->QTDEM2)
		oSection1:Cell('EMISSAO'):SetValue(TRB->EMISSAO)
		oSection1:Cell('ENTREGA'):SetValue(TRB->ENTREGA)
		oSection1:Cell('VALBRUT'):SetValue(TRB->VALBRUT)
		oSection1:Cell('VALLIQ'):SetValue(TRB->VALLIQ)
		oSection1:Cell('CUSTOSTD'):SetValue(TRB->CUSTOSTD)
		oSection1:Cell('MGSTD'):SetValue(TRB->MGSTD)
		oSection1:Cell('PERCSTD'):SetValue(TRB->PERCSTD)
		oSection1:Cell('MGREAL'):SetValue(TRB->MGREAL)
		oSection1:Cell('PERCREAL'):SetValue(TRB->PERCREAL)
		oSection1:Cell('CUSTOATU'):SetValue(TRB->CUSTOATU)
		oSection1:Cell('MGATU'):SetValue(TRB->MGATU)
		oSection1:Cell('PERCATU'):SetValue(TRB->PERCATU)
		oSection1:Cell('CUSTOSIM'):SetValue(TRB->CUSTOSIM)
		oSection1:Cell('MGSIMUL'):SetValue(TRB->MGSIMUL)
		oSection1:Cell('PERCSIM'):SetValue(TRB->PERCSIM)
		oSection1:Cell('ACRESC'):SetValue(TRB->ACRESC)
		oSection1:Cell('VERBADIC'):SetValue(TRB->VERBADIC)
		oSection1:Cell('VALMERC'):SetValue(TRB->VALMERC)
		oSection1:Cell('VALIPI'):SetValue(TRB->VALIPI)
		oSection1:Cell('VALADIC'):SetValue(TRB->VALADIC)
		oSection1:Cell('VALCPMF'):SetValue(TRB->VALCPMF)
		oSection1:Cell('VALICMS'):SetValue(TRB->VALICMS)
		oSection1:Cell('VALICMST'):SetValue(TRB->VALICMST)
		oSection1:Cell('VALPC'):SetValue(TRB->VALPC)
		oSection1:Cell('VALIR'):SetValue(TRB->VALIR)
		oSection1:Cell('VALCOM'):SetValue(TRB->VALCOM)
		oSection1:Cell('VALCOM2'):SetValue(TRB->VALCOM2)
		oSection1:Cell('VALFIN'):SetValue(TRB->VALFIN)
		oSection1:Cell('VALFRET'):SetValue(TRB->VALFRET)
		oSection1:Cell('DESCZFR'):SetValue(TRB->DESCZFR)
		oSection1:Cell('PERCCOM'):SetValue(TRB->PERCCOM)
		oSection1:Cell('TP'):SetValue(TRB->TP)
		oSection1:Cell('FRETE'):SetValue(TRB->FRETE)
		oSection1:Cell('PERFRET'):SetValue(TRB->PERFRET)
		oSection1:Cell('EST'):SetValue(TRB->EST)
		oSection1:Cell('ESTGRP'):SetValue(TRB->ESTGRP)
		oSection1:Cell('TES'):SetValue(TRB->TES)
		oSection1:Cell('CONDPAG'):SetValue(TRB->CONDPAG)
		oSection1:Cell('TPVEND'):SetValue(TRB->TPVEND)
		oSection1:Cell('QTDE2'):SetValue(TRB->QTDE2)
		oSection1:Cell('ALIQICM'):SetValue(TRB->ALIQICM)
		oSection1:Cell('ALIQIPI'):SetValue(TRB->ALIQIPI)
		oSection1:Cell('NCM'):SetValue(TRB->NCM)
		oSection1:Cell('CNPJ'):SetValue(TRB->CNPJ)
		oSection1:Cell('PEDORI'):SetValue(TRB->PEDORI)
		oSection1:Cell('RM1'):SetValue(TRB->RM1)
		oSection1:Cell('RM2'):SetValue(TRB->RM2)
		oSection1:Cell('RM3'):SetValue(TRB->RM3)
		oSection1:Cell('OK'):SetValue(TRB->OK)
		oSection1:Cell('SEGMENTO'):SetValue(TRB->SEGMENTO)
		oSection1:Cell('REGIAO'):SetValue(TRB->REGIAO)
		oSection1:Cell('SITCLI'):SetValue(TRB->SITCLI)
		oSection1:Cell('VENDCAD'):SetValue(TRB->VENDCAD)
		oSection1:Cell('DATAFAT'):SetValue(TRB->DATAFAT)
		oSection1:Cell('DATASAI'):SetValue(TRB->DATASAI)
		oSection1:Cell('PRODUTO'):SetValue(TRB->PRODUTO)
		oSection1:Cell('STDPROD'):SetValue(TRB->STDPROD)
		
		oSection1:Printline()
		TRB->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo
//oSection1:Finish()

//SEÇÃO 2 - Por Produto
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\gerencia\MGVDPRD.dtc","TRB1", Nil, .F. )

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
	
	IncProc("Imprimindo Faturamento x Produto")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a segunda seção
		
		oSection2:Cell('PRODUTO'):SetValue(TRB1->PRODUTO)
		oSection2:Cell('DESC'):SetValue(TRB1->DESC)
		oSection2:Cell('QTDE'):SetValue(TRB1->QTDE)
		oSection2:Cell('QTDEP'):SetValue(TRB1->QTDEP)
		oSection2:Cell('VLBRUT'):SetValue(TRB1->VLBRUT)
		oSection2:Cell('VLBRUTP'):SetValue(TRB1->VLBRUTP)
		oSection2:Cell('VLLIQ'):SetValue(TRB1->VLLIQ)
		oSection2:Cell('VLLIQP'):SetValue(TRB1->VLLIQP)
		oSection2:Cell('CUSTOSTD'):SetValue(TRB1->CUSTOSTD)
		oSection2:Cell('CUSTOSTDP'):SetValue(TRB1->CUSTOSTDP)
		oSection2:Cell('MGSTD'):SetValue(TRB1->MGSTD)
		oSection2:Cell('PERCSTD'):SetValue(TRB1->PERCSTD)
		oSection2:Cell('MGREAL'):SetValue(TRB1->MGREAL)
		oSection2:Cell('PERCREAL'):SetValue(TRB1->PERCREAL)
		oSection2:Cell('CUSTOATU'):SetValue(TRB1->CUSTOATU)
		oSection2:Cell('MGATU'):SetValue(TRB1->MGATU)
		oSection2:Cell('PERCATU'):SetValue(TRB1->PERCATU)
		oSection2:Cell('CUSTOSIM'):SetValue(TRB1->CUSTOSIM)
		oSection2:Cell('MGSIMUL'):SetValue(TRB1->MGSIMUL)
		oSection2:Cell('PERCSIM'):SetValue(TRB1->PERCSIM)
		
		oSection2:Printline()
		Trb1->(dbSkip())
	Enddo
	
	//finalizo a segunda seção
Enddo

Use
//SEÇÃO 3 - Por Cliente
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\gerencia\MGVDCLI.dtc","TRB1", Nil, .F. )

dbSelectArea("Trb1")

oReport:SetMeter(Trb1->(LastRec()))
Trb1->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a TERCEIRA seção
	oSection3:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("Trb1")
	
	IncProc("Imprimindo Faturamento x Cliente")
	
	Do while !eof()
		oReport:IncMeter()
		
		// Section 3
		oSection3:Cell('GRPCLI'):SetValue(trb1->GRPCLI)
		oSection3:Cell('CLI'):SetValue(trb1->CLI)
		oSection3:Cell('NOME'):SetValue(trb1->NOME)
		oSection3:Cell('NREDUZ'):SetValue(trb1->NREDUZ)
		oSection3:Cell('RANK'):SetValue(trb1->RANK)
		oSection3:Cell('UF'):SetValue(trb1->UF)
		oSection3:Cell('VEND'):SetValue(trb1->VEND)
		oSection3:Cell('NOMEV'):SetValue(trb1->NOMEV)
		oSection3:Cell('NOMEC'):SetValue(trb1->NOMEC)
		oSection3:Cell('REGIAO'):SetValue(trb1->REGIAO)
		oSection3:Cell('SITCLI'):SetValue(trb1->SITCLI)
		oSection3:Cell('SEGMENTO'):SetValue(trb1->SEGMENTO)
		oSection3:Cell('VENDCAD'):SetValue(trb1->VENDCAD)
		oSection3:Cell('QTDE'):SetValue(trb1->QTDE)
		oSection3:Cell('QTDEP'):SetValue(trb1->QTDEP)
		oSection3:Cell('VLBRUT'):SetValue(trb1->VLBRUT)
		oSection3:Cell('VLBRUTP'):SetValue(trb1->VLBRUTP)
		oSection3:Cell('VLLIQ'):SetValue(trb1->VLLIQ)
		oSection3:Cell('VLLIQP'):SetValue(trb1->VLLIQP)
		oSection3:Cell('CUSTOSTD'):SetValue(trb1->CUSTOSTD)
		oSection3:Cell('CUSTOSTDP'):SetValue(trb1->CUSTOSTDP)
		oSection3:Cell('MGSTD'):SetValue(trb1->MGSTD)
		oSection3:Cell('PERCSTD'):SetValue(trb1->PERCSTD)
		oSection3:Cell('MGREAL'):SetValue(trb1->MGREAL)
		oSection3:Cell('PERCREAL'):SetValue(trb1->PERCREAL)
		oSection3:Cell('CUSTOATU'):SetValue(trb1->CUSTOATU)
		oSection3:Cell('MGATU'):SetValue(trb1->MGATU)
		oSection3:Cell('PERCATU'):SetValue(trb1->PERCATU)
		oSection3:Cell('CUSTOSIM'):SetValue(trb1->CUSTOSIM)
		oSection3:Cell('MGSIMUL'):SetValue(trb1->MGSIMUL)
		oSection3:Cell('PERCSIM'):SetValue(trb1->PERCSIM)
		
		oSection3:Printline()
		Trb1->(dbSkip())
	Enddo
	
	//finalizo a terceira seção
Enddo

use

//SEÇÃO 4 - Vendedor
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\gerencia\MGVDVEN.dtc","TRB1", Nil, .F. )

dbSelectArea("Trb1")

oReport:SetMeter(Trb1->(LastRec()))
Trb1->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection4:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("Trb1")
	
	IncProc("Imprimindo Faturamento x Vendedor")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a quarta seção
		
		oSection4:Cell('VEND'):SetValue(trb1->VEND)
		oSection4:Cell('NOMEV'):SetValue(trb1->NOMEV)
		oSection4:Cell('NOMEC'):SetValue(trb1->NOMEC)
		oSection4:Cell('UF'):SetValue(trb1->UF)
		oSection4:Cell('QTDE'):SetValue(trb1->QTDE)
		oSection4:Cell('QTDEP'):SetValue(trb1->QTDEP)
		oSection4:Cell('VLBRUT'):SetValue(trb1->VLBRUT)
		oSection4:Cell('VLBRUTP'):SetValue(trb1->VLBRUTP)
		oSection4:Cell('VLLIQ'):SetValue(trb1->VLLIQ)
		oSection4:Cell('VLLIQP'):SetValue(trb1->VLLIQP)
		oSection4:Cell('CUSTOSTD'):SetValue(trb1->CUSTOSTD)
		oSection4:Cell('CUSTOSTDP'):SetValue(trb1->CUSTOSTDP)
		oSection4:Cell('MGSTD'):SetValue(trb1->MGSTD)
		oSection4:Cell('PERCSTD'):SetValue(trb1->PERCSTD)
		oSection4:Cell('MGREAL'):SetValue(trb1->MGREAL)
		oSection4:Cell('PERCREAL'):SetValue(trb1->PERCREAL)
		oSection4:Cell('CUSTOATU'):SetValue(trb1->CUSTOATU)
		oSection4:Cell('MGATU'):SetValue(trb1->MGATU)
		oSection4:Cell('PERCATU'):SetValue(trb1->PERCATU)
		oSection4:Cell('CUSTOSIM'):SetValue(trb1->CUSTOSIM)
		oSection4:Cell('MGSIMUL'):SetValue(trb1->MGSIMUL)
		oSection4:Cell('PERCSIM'):SetValue(trb1->PERCSIM)
		
		oSection4:Printline()
		TRB1->(dbSkip())
	Enddo
	
	//finalizo a 4a seção
Enddo

Use

//SEÇÃO 5 - Vendedor
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\GERENCIA\MGVDUFREP","TRB1", Nil, .F. )

dbSelectArea("Trb1")

oReport:SetMeter(Trb1->(LastRec()))
Trb1->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection5:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("Trb1")
	
	IncProc("Imprimindo Faturamento x Vendedor")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a quinta seção
		
		oSection5:Cell("UF"):SetValue(Trb1->UF)
		oSection5:Cell("VEND"):SetValue(Trb1->VEND)
		oSection5:Cell("NOMEC"):SetValue(Trb1->NOMEC)
		oSection5:Cell("NOMEV"):SetValue(Trb1->NOMEV)
		oSection5:Cell("QTDCLIUF"):SetValue(TRB1->QTDCLIUF)
		oSection5:Cell("QTDCLI"):SetValue(TRB1->QTDCLI)
		oSection5:Cell("DESATIVA"):SetValue(TRB1->DESATIVA)
		oSection5:Cell("ATIVO"):SetValue(TRB1->ATIVO)
		oSection5:Cell("REATIVAD"):SetValue(TRB1->REATIVAD)
		oSection5:Cell("INATIVO"):SetValue(TRB1->INATIVO)
		
		oSection5:Cell("QTDE"):SetValue(TRB1->QTDE)
		oSection5:Cell("QTDEP"):SetValue(TRB1->QTDEP)
		oSection5:Cell("VLBRUT"):SetValue(TRB1->VLBRUT)
		oSection5:Cell("VLBRUTP"):SetValue(TRB1->VLBRUTP)
		oSection5:Cell("VLLIQ"):SetValue(TRB1->VLLIQ)
		oSection5:Cell("VLLIQP"):SetValue(TRB1->VLLIQP)
		oSection5:Cell("CUSTOSTD"):SetValue(TRB1->CUSTOSTD)
		oSection5:Cell("CUSTOSTDP"):SetValue(TRB1->CUSTOSTDP)
		oSection5:Cell("MGSTD"):SetValue(TRB1->MGSTD)
		oSection5:Cell("PERCSTD"):SetValue(TRB1->PERCSTD)
		oSection5:Cell("MGREAL"):SetValue(TRB1->MGREAL)
		oSection5:Cell("PERCREAL"):SetValue(TRB1->PERCREAL)
		oSection5:Cell("CUSTOATU"):SetValue(TRB1->CUSTOATU)
		oSection5:Cell("MGATU"):SetValue(TRB1->MGATU)
		oSection5:Cell("PERCATU"):SetValue(TRB1->PERCATU)
		oSection5:Cell("CUSTOSIM"):SetValue(TRB1->CUSTOSIM)
		oSection5:Cell("MGSIMUL"):SetValue(TRB1->MGSIMUL)
		oSection5:Cell("PERCSIM"):SetValue(TRB1->PERCSIM)
		
		oSection5:Printline()
		TRB1->(dbSkip())
	Enddo
Enddo
Use

//finalizo a seção 5

//SEÇÃO 6 - Vendas x Semana
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\gerencia\MGVDVND_SEMANA.dtc","TRB1", Nil, .F. )

dbSelectArea("Trb1")

oReport:SetMeter(Trb1->(LastRec()))
Trb1->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection6:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("Trb1")
	
	IncProc("Imprimindo Vendas x Semana")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a segunda seção
		oSection6:Cell('VEND'):SetValue(Trb1->VEND)
		oSection6:Cell('COOR'):SetValue(Trb1->COOR)
		oSection6:Cell('META'):SetValue(Trb1->META)
		oSection6:Cell('VLBRUT'):SetValue(Trb1->VLBRUT)
		oSection6:Cell('CUSTOSTD'):SetValue(Trb1->CUSTOSTD)
		oSection6:Cell('MGSTD'):SetValue(Trb1->MGSTD)
		oSection6:Cell('PERCSTD'):SetValue(Trb1->PERCSTD)
		oSection6:Cell('MGREAL'):SetValue(Trb1->MGREAL)
		oSection6:Cell('PERCREAL'):SetValue(Trb1->PERCREAL)
		oSection6:Cell('PESO'):SetValue(Trb1->PESO)
		
		
		oSection6:Printline()
		TRB1->(dbSkip())
	Enddo
	
	//finalizo a 6a seção
	
Enddo

//Use
dbSelectArea("TRB")
TRB->(dbGoTop())

oReport:SetMeter(TRB->(LastRec()))

While !Eof() // total Geral
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection7:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRB")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		nQTDE:= nQTDEM2:= nVALBRUT:= nVALLIQ:= nCUSTOSTD:= nMGSTD:= nPERCSTD:= nMGREAL:=0
		nPERCREAL:= nCUSTOATU:= nMGATU:= nPERCATU:= nCUSTOSIM:= nMGSIMUL:= nPERCSIM:=0
		nACRESC:= nVERBADIC:= nVALMERC:= nVALIPI:= nVALADIC:= nVALCPMF:= nVALICMS:=0
		nVALICMST:= nVALPC:= nVALIR:= nVALCOM:= nVALCOM2:= nVALFIN:= nVALFRET:= nDESCZFR:=0
		nPERCCOM:= nPERFRET:= nQTDE2:= 0		

		cNum := trb->Num
		Do while !eof() .and. trb->Num = cNum 
			nQTDE+=QTDE
			nQTDEM2+=QTDEM2
			nVALBRUT+=VALBRUT
			nVALLIQ+=VALLIQ
			nCUSTOSTD+=CUSTOSTD
			nMGSTD+=MGSTD
			nPERCSTD+=PERCSTD
			nMGREAL+=MGREAL
			nCUSTOATU+=CUSTOATU
			nMGATU+=MGATU
			nCUSTOSIM += CUSTOSIM
			nMGSIMUL += MGSIMUL
			nACRESC += ACRESC
			nVERBADIC +=VERBADIC
			nVALMERC+=VALMERC
			nVALIPI+=VALIPI
			nVALADIC+=VALADIC
			nVALCPMF+=VALCPMF
			nVALICMS+=VALICMS
			nVALICMST+=VALICMST
			nVALPC+=VALPC
			nVALIR+=VALIR
			nVALCOM+=VALCOM
			nVALCOM2+=VALCOM2
			nVALFIN+=VALFIN
			nVALFRET+=VALFRET
			nDESCZFR += DESCZFR
			nQTDE2+=QTDE2
			nReg := Recno()
			TRB->(dbSkip())
		Enddo
		if (nmgstd/nCUSTOSTD)*100<100000
			npercstd  := (nmgstd/nCUSTOSTD)*100
		endif
		if (nmgreal/nCUSTOSTD)*100<100000
			npercReal   := (nmgreal/nCUSTOSTD)*100
		Endif
		if (nmgatu/nCUSTOATU)*100<100000
			npercatu:= (nmgatu/nCUSTOATU)*100
		endif

		dbGoto(nReg)
		//imprimo a primeira seção
		oSection7:Cell('NUM'):SetValue(TRB->NUM)
		oSection7:Cell('CODCLI'):SetValue(TRB->CODCLI)
		oSection7:Cell('LOJA'):SetValue(TRB->LOJA)
		oSection7:Cell('GRPCLI'):SetValue(TRB->GRPCLI)
		oSection7:Cell('CLI'):SetValue(TRB->CLI)
		oSection7:Cell('NREDUZ'):SetValue(TRB->NREDUZ)
		oSection7:Cell('RANK'):SetValue(TRB->RANK)
		oSection7:Cell('VEND'):SetValue(TRB->VEND)
		oSection7:Cell('COOR'):SetValue(TRB->COOR)
		oSection7:Cell('QTDE'):SetValue(nQTDE)
		oSection7:Cell('QTDEM2'):SetValue(nQTDEM2)
		oSection7:Cell('EMISSAO'):SetValue(TRB->EMISSAO)
		oSection7:Cell('ENTREGA'):SetValue(TRB->ENTREGA)
		oSection7:Cell('VALBRUT'):SetValue(nVALBRUT)
		oSection7:Cell('VALLIQ'):SetValue(nVALLIQ)
		oSection7:Cell('CUSTOSTD'):SetValue(nCUSTOSTD)
		oSection7:Cell('MGSTD'):SetValue(nMGSTD)
		oSection7:Cell('PERCSTD'):SetValue(nPERCSTD)
		oSection7:Cell('MGREAL'):SetValue(nMGREAL)
		oSection7:Cell('PERCREAL'):SetValue(nPERCREAL)
		oSection7:Cell('CUSTOATU'):SetValue(nCUSTOATU)
		oSection7:Cell('MGATU'):SetValue(nMGATU)
		oSection7:Cell('PERCATU'):SetValue(nPERCATU)
		oSection7:Cell('CUSTOSIM'):SetValue(nCUSTOSIM)
		oSection7:Cell('MGSIMUL'):SetValue(nMGSIMUL)
		oSection7:Cell('PERCSIM'):SetValue(nPERCSIM)
		oSection7:Cell('ACRESC'):SetValue(TRB->ACRESC)
		oSection7:Cell('VERBADIC'):SetValue(TRB->VERBADIC)
		oSection7:Cell('VALMERC'):SetValue(nVALMERC)
		oSection7:Cell('VALIPI'):SetValue(nVALIPI)
		oSection7:Cell('VALADIC'):SetValue(nVALADIC)
		oSection7:Cell('VALCPMF'):SetValue(nVALCPMF)
		oSection7:Cell('VALICMS'):SetValue(nVALICMS)
		oSection7:Cell('VALICMST'):SetValue(nVALICMST)
		oSection7:Cell('VALPC'):SetValue(nVALPC)
		oSection7:Cell('VALIR'):SetValue(nVALIR)
		oSection7:Cell('VALCOM'):SetValue(nVALCOM)
		oSection7:Cell('VALCOM2'):SetValue(nVALCOM2)
		oSection7:Cell('VALFIN'):SetValue(nVALFIN)
		oSection7:Cell('VALFRET'):SetValue(nVALFRET)
		oSection7:Cell('DESCZFR'):SetValue(nDESCZFR)
		oSection7:Cell('PERCCOM'):SetValue(nPERCCOM)
		oSection7:Cell('TP'):SetValue(TRB->TP)
		oSection7:Cell('FRETE'):SetValue(TRB->FRETE)
		oSection7:Cell('PERFRET'):SetValue(nPERFRET)
		oSection7:Cell('EST'):SetValue(TRB->EST)
		oSection7:Cell('ESTGRP'):SetValue(TRB->ESTGRP)
		oSection7:Cell('TES'):SetValue(TRB->TES)
		oSection7:Cell('CONDPAG'):SetValue(TRB->CONDPAG)
		oSection7:Cell('TPVEND'):SetValue(TRB->TPVEND)
		oSection7:Cell('QTDE2'):SetValue(nQTDE2)
		oSection7:Cell('CNPJ'):SetValue(TRB->CNPJ)
		oSection7:Cell('PEDORI'):SetValue(TRB->PEDORI)
		oSection7:Cell('SEGMENTO'):SetValue(TRB->SEGMENTO)
		oSection7:Cell('REGIAO'):SetValue(TRB->REGIAO)
		oSection7:Cell('SITCLI'):SetValue(TRB->SITCLI)
		oSection7:Cell('VENDCAD'):SetValue(TRB->VENDCAD)
		oSection7:Cell('DATAFAT'):SetValue(TRB->DATAFAT)
		oSection7:Cell('DATASAI'):SetValue(TRB->DATASAI)

		oSection7:Printline()
		TRB->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo

oSection7:Finish()
oSection6:Finish()
oSection5:Finish()
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()

Return

User Function grvcpos(cFator,nValPed,cCod1,cCod,cCli,cTes,cCondPg,cTpNF,cVend,cDoc,cItem,cSuper,nQuant)//,nAcresc,nVerbAdic,cObs)

Select SUB
dbSetOrder(3)
Seek xFilial()+SC6->(C6_NUM+C6_ITEM)

Select SD2
dbSetOrder(8)
Seek xFilial()+SC6->(C6_NUM+C6_ITEM)

		if sc6->(c6_num+c6_item)="079167"
		x:=1
		endif

Select SZ0
Do Case
Case cDoc="TMK" .or. cDoc="CAL"
	dbSetOrder(1)
	seek xfilial()+SUB->(UB_NUM+UB_ITEM)+"C"
Case cDoc="PED"
	dbSetOrder(2)
	seek xfilial()+SC6->(C6_NUM+C6_ITEM)
	if SC6->c6_segum='M2' 
		if sc6->c6_um<>'KG' // Regra para não contemplar resíduos
			nQuant := sc6->c6_unsven
		else
			nQuant := sc6->c6_qtdven
		endif
	endif
Case cDoc="FAT"
	dbSetOrder(3)
	seek xfilial()+SD2->(D2_DOC+D2_ITEM)
EndCase
if !eof() .and. rlock()
	delete
endif

//Reclock("SZ0",lTipo)
Reclock("SZ0",.t.)

SZ0->Z0_TMK := SUB->UB_NUM //iif(cOrigem="T",cDoc,"")
SZ0->Z0_PEDIDO := sc5->c5_num //iif(cOrigem="P",cDoc,"")
SZ0->Z0_NF := sc6->c6_nota //iif(cOrigem="N",cDoc,"")
SZ0->Z0_TMKIT := SUB->UB_ITEM //iif(cOrigem="T",cItem,"")
SZ0->Z0_PEDIT := SC6->C6_ITEM // iif(cOrigem="P",cItem,"")
SZ0->Z0_NFITEM := SD2->D2_ITEM //iif(cOrigem="N",cItem,"")
SZ0->Z0_TMKEMIS := SUA->UA_EMISSAO // iif(cOrigem="T",dEmissao,ctod("0"))
SZ0->Z0_EMISPED := SC5->C5_EMISSAO //iif(cOrigem="P",dEmissao,ctod("0"))
SZ0->Z0_EMISNF := SD2->D2_EMISSAO //iif(cOrigem="N",dEmissao,ctod("0"))
SZ0->Z0_PRODUTO := cCod
SZ0->Z0_CLIENTE := cCli
SZ0->Z0_LOJA := substr(cCli,7,2)
SZ0->Z0_VEND := cVEND
SZ0->Z0_COORD := cSuper
SZ0->Z0_QTDE := nQuant
SZ0->Z0_VALBRUT := nValPed
SZ0->Z0_VALLIQ := nVALLIQ
//SZ0->Z0_ACRESC := nAcresc
//SZ0->Z0_VERBADIC := nVerbAdic
SZ0->Z0_VALIPI := nIpi1
SZ0->Z0_VALADIC := nValadic
SZ0->Z0_CPMF := nVCpmf
SZ0->Z0_VALICMS := nIcms1
SZ0->Z0_VALPIS := nPc//VALPIS
SZ0->Z0_VALCOF := 0//VALCOF
SZ0->Z0_VALIR := nIr 
SZ0->Z0_VALCOM1 := nCom1
SZ0->Z0_VALCOM2 := nCom2
SZ0->Z0_VALFIN := nFin1
SZ0->Z0_VALFRET := nFrete
SZ0->Z0_DESCZFR := nTotZFR
SZ0->Z0_TP := cFator
SZ0->Z0_FRETE := Alltrim(_cTpFrete)
SZ0->Z0_EST := sa1->a1_est
SZ0->Z0_TES := cTes
SZ0->Z0_CONDPG := cCondPg
SZ0->Z0_TPVEND := cTpNF

SZ0->Z0_CSTSTD := sb5->b5_prv7*nQuant
SZ0->Z0_MGSTD := sb5->b5_margem*nQuant
SZ0->Z0_PERSTD := (sb5->b5_margem/sb5->b5_prv7)*100

SZ0->Z0_MGREAL := (nVALLIQ-Z0_CSTSTD)/(1+(mv_par05/100))
if SZ0->(Z0_MGREAL/Z0_CSTSTD)*100>-1000 .and. SZ0->(Z0_MGREAL/Z0_CSTSTD)*100<1000
	SZ0->Z0_PERCREAL := (SZ0->Z0_MGREAL/Z0_CSTSTD)*100
endif
SZ0->Z0_TIPO := "P"

MsUnLock()
