#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function RFAT019()         // Posicao de Faturamento com Margem /Uf / Vendedor - 29/09/2016    
								// Versão excel em 16/12/2019

public nTotQtde,nTotValb,nTotValq,nTotStdl

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Faturamento com Margem"
cDesc2   := ""
cDesc3   := ""
cPerg    := "RFT019"
cString  := "SD2"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT019"
titulo   := "Posicao de Faturamento UF/Repr.(Margem)"
wnrel    := "RFAT019"
limite   := 132
tamanho  := "M"
nMultip  := 1
nFrete   := nvCPMF := nIcms := nPC := mIR := nCom := nFin := 0
nTot4 := nZfr := nTotZFR := 0
cTpVend  := " "
nCustAmost := 0
nValFol	:=0
nDespG := nDespA := nDespF := nDespC := nDespP := nDespIM := nDespA := 0
nDespOu := nDespJR := nDespIp := nDescto := nRecFin	:= nResF1 := nResF2 := nResF3 := 0
nCStd := 0
nMarg := 0
cTempPrn := ""
aCampos:= {}
aVend  := {}
aEst   := {}
aChave := {}
dFecStd := GetMV("MV_ULSTD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Periodo de                                      ³
//³ mv_par02  // Periodo ate                                     ³
//| mv_par03  // Vendedor de                                     ³
//| mv_par04  // Vendedor ate                                    ³
//| mv_par05  // % de acrescimo da margem                        ³
//| mv_par06  // Tipo de Relatorio                               ³
//| mv_par07  // Cliente  de                                     ³
//| mv_par08  // Cliente  ate                                    ³
//| mv_par09  // Relatorio por Cliente ?                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Obs mv_par05 - refere-se a gordura a ser embutida na margem (seguran‡a)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if !Pergunte(cPerg,.T.)
	Return
endif
mv_par11:=1
mv_par12:=1  // Para entrar na condição dos índices

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

//cData1:=dtoc(getmv("MV_CALCATV"))
if MsgBox ("Deseja verificar status do cliente (ex.:ativo,inativo,... ?)","Escolha","YESNO") //ultimo calculo em "+cData1,"Escolha","YESNO")
	//Processa({|| VerAtiv() })
	Processa({|| u_VerAtiv() })
endif

Select SX6
Seek xFilial()+"MV_CALCATV"
reclock("SX6",.f.)
sx6->x6_conteud := dtoc(dDataBase)
MSUNLOCK()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})
Retindex("SD2")
Retindex("SD1")
Retindex("SA1")
Retindex("SA2")
Retindex("SB1")
Retindex("SC5")
Retindex("SF2")
Retindex("SF4")

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
AADD(aCampos,{ "NUM"     , "C",06,0})  //1- Numero da NF
AADD(aCampos,{ "ITEM"    , "C",02,0})  //2- Numero do item da NF
AADD(aCampos,{ "CODCLI"  , "C",06,0})  //3- Código do cliente
AADD(aCampos,{ "LOJA"    , "C",02,0})  //4- Loja do Cliente
AADD(aCampos,{ "CLI"     , "C",30,0})  //5- Razão Social
AADD(aCampos,{ "NREDUZ"  , "C",20,0})  //6- Nome Reduzido
AADD(aCampos,{ "GRPCLI"  , "C",08,0})
AADD(aCampos,{ "RANK"    , "N",04,0})
AADD(aCampos,{ "VEND"    , "C",06,0})  //7- Vendedor
AADD(aCampos,{ "COOR"    , "C",06,0})  //8- Coordenador
AADD(aCampos,{ "COD"     , "C",15,0})  //9- Código do Produto
AADD(aCampos,{ "DESC"    , "C",50,0})  //10- Descrição do Produto
AADD(aCampos,{ "QTDE"    , "N",12,2})  //11- Quantidade Faturada
AADD(aCampos,{ "QTDEM2"  , "N",16,4})  //11- Quantidade Faturada
AADD(aCampos,{ "EMISSAO" , "D",08,0})  //12- Data de Emissão da NF
AADD(aCampos,{ "VALBRUT" , "N",12,2})  //13- Valor da Mercadoria (X2 se parte A) + Frete
AADD(aCampos,{ "VALLIQ"  , "N",12,2})  //14- Valor Liquido = nTotFat-trb1->d2_valicm-nVCpmf-nCom-nCom2-nPC-nIR-nCSLL-nFin-nFrete-nValAdic
AADD(aCampos,{ "CUSTOSTD", "N",12,2})  //15- Custo Standard do produto (baseado na estrutura)
AADD(aCampos,{ "MGSTD"   , "N",12,2})  //16- Margem Std = Cadastrada no compl produto (SB5)X Qtde
AADD(aCampos,{ "PERCSTD" , "N",12,4})  //17- (trb->mgSTD/trb->CUSTOSTD)*100
AADD(aCampos,{ "MGREAL"  , "N",12,2})  //18- Val.Liq - Custo Std
AADD(aCampos,{ "PERCREAL", "N",12,4})  //19- (trb->mgreal/trb->CUSTOSTD)*100
AADD(aCampos,{ "CUSTOATU"  , "N",12,2})//20-
AADD(aCampos,{ "MGATU"   , "N",12,2})  //21-
AADD(aCampos,{ "PERCATU" , "N",12,4})  //22-
AADD(aCampos,{ "CUSTOSIM"  , "N",12,2})//23-
AADD(aCampos,{ "MGSIMUL" , "N",12,2})  //24-
AADD(aCampos,{ "PERCSIM" , "N",12,4})  //25-

AADD(aCampos,{ "ACRESC"  , "N",06,4})  //27- Acréscimo no Valor do produto
AADD(aCampos,{ "VERBADIC", "N",08,4})  //28- Percentual da Verba Adicional
AADD(aCampos,{ "PEDIDO"  , "C",06,0})  //29- Número do pedido de Vendas
AADD(aCampos,{ "ITEMPV"  , "C",02,0})  //30- Item do Pedido de Vendas
AADD(aCampos,{ "VALMERC" , "N",12,2})  //31- Valor da Mercadoria na Nota Fiscal
AADD(aCampos,{ "VALIPI"  , "N",12,2})  //32- Valor do IPI
AADD(aCampos,{ "VALADIC" , "N",12,2})  //33-
AADD(aCampos,{ "VALCPMF" , "N",12,2})  //34-
AADD(aCampos,{ "VALICMS" , "N",12,2})  //35-
AADD(aCampos,{ "VALICMST", "N",12,2})  //36-
AADD(aCampos,{ "VALPC"   , "N",12,2})  //37-
AADD(aCampos,{ "VALIR"   , "N",12,2})  //38-
AADD(aCampos,{ "VALCSLL" , "N",12,2})  //39-
AADD(aCampos,{ "VALCOM"  , "N",12,2})  //40-
AADD(aCampos,{ "VALCOM2" , "N",12,2})  //41-
AADD(aCampos,{ "VALFIN"  , "N",12,2})  //42-
AADD(aCampos,{ "VALFRET" , "N",12,2})  //43-
AADD(aCampos,{ "DESCZFR" , "N",12,2})  //44-
AADD(aCampos,{ "PERCCOM" , "N",12,2})  //45-
AADD(aCampos,{ "DIFAL"   , "N",12,2})
AADD(aCampos,{ "TP"      , "C",01,0})  //46-
AADD(aCampos,{ "FRETE"   , "C",01,0})  //47-
AADD(aCampos,{ "PERFRET" , "N",12,2})  //43-
AADD(aCampos,{ "EST"     , "C",02,0})  //48-
AADD(aCampos,{ "ESTGRP"  , "C",02,0})  //48-
AADD(aCampos,{ "TES"     , "C",03,0})
AADD(aCampos,{ "CFOP"    , "C",04,0})
AADD(aCampos,{ "CONDPAG" , "C",10,0})
AADD(aCampos,{ "TPVEND"  , "C",01,0})
AADD(aCampos,{ "QTDE2"   , "N",12,2})  //11- Quantidade desconsiderada
AADD(aCampos,{ "ALIQICM" , "N",08,2})
AADD(aCampos,{ "ALIQIPI" , "N",08,2})
AADD(aCampos,{ "NCM"     , "C",15,0})
AADD(aCampos,{ "CNPJ"    , "C",15,0})
AADD(aCampos,{ "INSCR"   , "C",15,0})
AADD(aCampos,{ "TPCLI"   , "C",01,0})
AADD(aCampos,{ "EMISS"   , "C",10,0})
AADD(aCampos,{ "PRODUTO" , "C",15,0})
AADD(aCampos,{ "STDPROD" , "N",12,4})
AADD(aCampos,{ "DESONER" , "N",12,2})
AADD(aCampos,{ "MUNI"    , "C",30,0})
AADD(aCampos,{ "TRANSP"  , "C",30,0})
AADD(aCampos,{ "SEGMENTO", "C",10,0})
AADD(aCampos,{ "REGIAO"  , "C",10,0})
AADD(aCampos,{ "SITCLI"  , "C",01,0})
AADD(aCampos,{ "VENDCAD" , "C",06,0})
AADD(aCampos,{ "DATASAI" , "D",08,0})  // Data de Saida da NF

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )


Select SD2
dbSetOrder(5)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off
cTrb1 := Criatrab(nil,.f.)
Copy to &cTrb1 next 1000000 for d2_emissao<=mv_par02 .and. d2_tipo$"N*B*I*P*C" .and.;
d2_cliente>=mv_par07 .and. d2_cliente<=mv_par08 .and. left(D2_PEDIDO,1)<>'P'
dbUseArea( .T.,, cTrb1,"TRB1", .F., .F. )

VerDevol()

Select TRB1

ProcRegua(reccount())
go top
// Totalizadores para balancete
nBalFat := nBalIPI := nBalICMST := 0
nBalICM := nBalPC  := nBALIR 	:= nBalCom := nBalCom1 := nBalFrete := nBalDESCZF := nBalVAdic := 0
nTotSTD := nTotCAtu:= nTotCSim  := nTotMg  := nTotIdeal:= nCustAmost:= 0
nBalDespF := 0
Do while !eof()
	IncProc()
	if trim(d2_item)$'DV'
		x:=1
	endif
	select SF2
	dbSetOrder(1)
	seek xFilial()+trb1->(d2_doc+d2_serie+D2_cliente+D2_loja)
	select SA1
	dbSetOrder(1)
	seek xFilial()+trb1->d2_cliente+trb1->d2_loja
	cGrpCli := iif(!empty(SA1->A1_XGRPCLI),SA1->A1_XGRPCLI,trb1->(D2_cliente+D2_loja))
	seek xFilial()+cGrpCli
	cEst := sa1->A1_est
	seek xFilial()+trb1->(D2_cliente+D2_loja)
	select SA2
	dbSetOrder(1)
	seek xFilial()+trb1->d2_cliente+trb1->d2_loja
	select SC5
	dbSetOrder(1)
	seek xFilial()+trb1->d2_pedido
	Select SUA
	dbSetOrder(8)
	seek xFilial()+SC5->c5_num
	cCondPag := sua->UA_CONDPG
	select SA4
	dbSetOrder(1)
	seek xFilial()+sc5->c5_transp
	select SB1
	dbSetOrder(1)
	seek xFilial()+trb1->d2_cod
	select SF2
	dbSetOrder(1)
	seek xFilial()+trb1->d2_doc+trb1->d2_serie
	if left(sc5->c5_tpfrete,1)=="C"
		VerFrete()  // Função não está funcionando
	else
		if !eof()
			reclock("SF2",.f.)
			sf2->f2_frete1 := 0
			MSUNLOCK()
			
		endif
	endif
	Select TRB1
	if trb1->d2_emissao<mv_par01 .or. trb1->d2_emissao>mv_par02
		Skip
		loop
	Endif
	if sc5->c5_vend1<mv_par03 .or. sc5->c5_vend1>mv_par04
		Skip
		loop
	Endif
	cDoc := trb1->d2_doc
	nTotLiq := nTotCust := 0 //nTotCAtu := nTotCSim := nTotMg := nTotIdeal := 0
	do while !eof() .and. trb1->d2_doc==cDoc
		Select SF4
		dbSetOrder(1)
		Seek xFilial()+trb1->d2_Tes
		Select trb1
		cTpVend := "S"
		if sf4->f4_duplic=="N" .or. trb1->d2_tipo$'D*I*P*B'
			//     Skip
			//     loop
			cTpVend := "N"
		else
			Select SB5
			seek xFilial()+trb1->D2_COD
			if eof() .and. year(trb1->d2_emissao)>=2013
				Select SB1
				dbSetOrder(1)
				Seek xFilial()+trb1->d2_cod
				if left(b1_posipi,4)$'7009*9616'
					Select SB5
					Reclock("SB5",sb5->(eof()))
					sb5->B5_Filial := xFilial()
					sb5->B5_cod    := trb1->d2_cod
					sb5->B5_ceme   := sb1->B1_DESC
					sb5->B5_inspat := "1"
					sb5->B5_verind := "1"
					sb5->B5_codativ:= sb1->b1_posipi
					MsUnLock()
				Endif
			endif
		endif
		cDescPrd := cPosIPI := " "
		nPerIpi  := 0
		cCod1    := left(trb1->d2_cod,4)
		if empty(SB1->B1_BASE)
			cCod     := left(trb1->d2_cod,at(".",trb1->d2_cod)-1)
			cCodProd := trb1->d2_cod
			cCod1    := cCod      
		else
			cCod     := left(trb1->d2_cod,6)
			cCodProd := trb1->d2_cod
			cCod1    := cCod      
		Endif

		select SC5
		dbSetOrder(1)
		seek xFilial()+trb1->d2_pedido
		select SUA
		dbSetOrder(1)
		seek xFilial()+sc5->c5_numtmk
		Do Case
			Case  sua->ua_setor == "A"
				nMultip  := 2
			Case  sua->ua_setor == "B"
				nMultip  := 5
			Case  sua->ua_setor == "C"
				seek xfilial()+"P"+substr(trb1->d2_pedido,2,5)
				if !eof()
					nMultip  := 2
					seek xFilial()+trb1->d2_pedido
//					reclock("SC5",.f.)
//					sC5->C5_FATOR := "C"
//					MSUNLOCK()
				endif
				seek xFilial()+trb1->d2_pedido
				nMultip  := 1
			Case  sua->ua_setor == "S"
				nMultip  := 1
		EndCase
		Select SC6              
		dbSetOrder(1)
		Seek xFilial()+trb1->(d2_pedido+d2_itempv)
		Select SC5              
		if sc5->c5_numtmk = sua->ua_num
//			reclock("SC5",.f.)
//			sC5->C5_FATOR := SUA->UA_SETOR
//			MSUNLOCK()                     
		endif
//		nTotZFR := iif(trb1->d2_desczfr#0 .and. trb1->d2_tes<>"543" .and. sc5->c5_fator#"S",trb1->d2_desczfr+trb1->d2_cusff4+trb1->d2_cusff5,0)
		nTotZFR := iif(trb1->d2_desczfr#0 .and. sc5->c5_fator#"S",trb1->d2_desczfr+trb1->d2_cusff4+trb1->d2_cusff5,0)
		nTotNF  := iif(trb1->d2_desczfr==0,trb1->d2_total,trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5)
		nTotFat := nTotNF*nMultip

		cCod     := left(sc6->c6_produto,at(".",sc6->c6_produto)-1)
		cCodProd := sc6->c6_produto
		if !empty(SB1->B1_BASE)
			cCod     := left(sc6->c6_produto,6)
			cCodProd := sc6->c6_produto
		Endif

		Select SB5
		Seek xFilial()+cCod
		if eof()
			Seek xFilial()+cCodprod
		endif
		if val(sc5->c5_pedexp)<=1   // Percentual de MP e MDO utilizados (RM)
			nVar := nVar1 := 1
		else
			if sm0->m0_codigo=="02"
				nVar := 1-val(substr(sc5->c5_pedexp,11,5))/10000
				nVar1:= 1-val(substr(sc5->c5_pedexp,16,5))/10000
			else
				nVar := val(substr(sc5->c5_pedexp,11,5))/10000
				nVar1:= val(substr(sc5->c5_pedexp,16,5))/10000
			endif
		endif
		nCStd := sb5->b5_prv7
		nMarg := sb5->b5_margem
		nCAtu := sb5->b5_cstatu
		nCSim := sb5->b5_custsim
		// Custo Amostra
		if trb1->d2_tes$"505*513*520"
			//			nFatAmost := nFatAmost  + (trb1->d2_Total*0.0925) + trb1->d2_valipi + trb1->d2_valicm
			nCustAmost += (trb1->d2_quant*nCStd)
		endif
		Select SZ3
		dbSetOrder(2)
		seek "  "+left(dtos(trb1->d2_emissao),6)
		if sz3->z3_data>=trb1->d2_emissao
			cDt := z3_data
			nTam := len(trim(cCod))
			seek "  "+dtos(cDt)+left(cCod,nTam)+space(15-nTam)
			nMarg := sz3->z3_margem
			nCStd := sz3->z3_stdcipi
			//nCAtu := sz3->z3_atucipi
			nCSim := sz3->z3_simcipi
		Endif
		
		if mv_par02 <= dFecStd
			//			verStd()
		endif
		nCStd := nCStd*nVar
		nMarg := nMarg*nVar
		
		Select SZ1
		dbSetOrder(3)
		Seek xFilial()+SA1->A1_XGRPCLI
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
		nValLiq := nValAdic:= 0
		nFrete  := nvCpmf := nIcms := nPC := nIR := nCSLL := nCom := nCom2 := nFin := 0
		cncm    := cCf := " "
		CalcVLiq(trb1->d2_emissao)
if cCod1='10193'
x:=1
endif
		Select TRB
		Reclock("TRB",.t.)
		trb->num    := cDoc
		trb->item   := trb1->d2_item
		trb->cod    := cCod1  // left(cCodProd,4)
		trb->desc   := cDescPrd
		trb->codcli := trb1->d2_cliente+trb1->d2_loja
		trb->loja   := trb1->d2_loja
		trb->cli    := iif(trb1->d2_tipo$"B*D",sa2->a2_nome,sa1->a1_nome)
		trb->nreduz := iif(trb1->d2_tipo$"B*D",sa2->a2_nreduz,sa1->a1_nreduz)
		trb->grpcli := iif(trb1->d2_tipo$"B*D",sa2->a2_COD,sa1->a1_xgrpcli)
		trb->rank   := SZ1->Z1_RANK
		trb->vend   := sc5->c5_vend1
		trb->coor   := cSuper
		trb->qtde   := trb1->d2_quant
//		trb->qtdeM2 := iif(sb1->b1_segum="M2",trb1->d2_quant*sb1->b1_conv,0)
		nQtdV := trb1->d2_quant
		if TRB1->D2_TES <>"569"
			trb->qtdeM2 := iif(sb1->b1_segum="M2",trb1->d2_quant*sb1->b1_conv,0)
			if trb->qtdeM2<>0 .and. sb1->b1_um<>'KG'
				nQtdV := trb1->d2_quant*sb1->b1_conv
			endif
		Endif
		trb->emissao:= trb1->d2_EMISSAO
		trb->emiss  := dtoc(trb1->d2_EMISSAO)
		trb->DATASAI:= sf2->F2_DATASAI
		if cTpVend#"N"
			trb->valliq := nValLiq
			trb->valbrut:= iif(trim(sc5->c5_fator)=="C",nTotNF,nTotFat+trb1->d2_desczfr)//+nTotZFR)
//			trb->valbrut:= iif(trim(sc5->c5_fator)=="A",nTotNF-trb->desczfr,nTotFat)//+nTotZFR)
			trb->CUSTOSTD := nCStd * nQtdV // trb1->d2_quant
			trb->MGSTD:= nMarg * nQtdV // trb1->d2_quant //nQtdEnt
			//   trb->MGSTD:= iif(left(cCod,4)=="2700",nVlPed,nMarg * nQtdEnt)
			if (trb->mgSTD/trb->CUSTOSTD)*100<100000
				trb->percstd   := (trb->mgstd/trb->CUSTOSTD)*100
			endif
			
			trb->mgreal := (nValLiq-trb->CUSTOSTD)/(1+(mv_par05)/100)
			//     trb->perc   := (trb->mgreal/trb->MGSTD)*100
			if (trb->mgreal/trb->CUSTOSTD)*100<100000 .and. (trb->mgreal/trb->CUSTOSTD)*100>-10000
				trb->percreal   := (trb->mgreal/trb->CUSTOSTD)*100
			endif
			//			trb->MGSTD:= nMarg * trb1->d2_quant
			//     trb->MGSTD:= iif(left(cCod1,4)=="2700",trb->ValBrut,nMarg * trb1->d2_quant)
			//			trb->mgreal := (nValLiq-trb->CUSTOSTD)/(1+(mv_par05/100))
			//			if (trb->mgreal/trb->MGSTD)*100<100000
			//				trb->perc   := (trb->mgreal/trb->MGSTD)*100
			//			endif
			
			trb->CUSTOATU := nCAtu * nQtdV //trb1->d2_quant
			trb->mgatu  := (nValLiq-trb->CUSTOATU) //(nValLiq-trb->CUSTOATU)/(1+(mv_par05/100))
			//			if (trb->mgatu/trb->MGSTD)*100<100000
			//				trb->percatu:= (trb->mgatu/trb->MGSTD)*100
			//			endif
			if (trb->mgatu/trb->CUSTOATU)*100<100000
				trb->percatu:= (trb->mgatu/trb->CUSTOATU)*100
			endif
			
			trb->CUSTOSIM := nCSim * nQtdV // trb1->d2_quant
			trb->mgsimul  := nMarg*nQtdv
			// trb->mgsimul:= (nValLiq-trb->CUSTOSIM)/(1+(mv_par05/100))
			//			trb->percsim:= (trb->mgsimul/trb->MGSTD)*100
			if (trb->mgsimul/trb->CUSTOSTD)*100<100000 .and. (trb->mgsimul/trb->CUSTOSTD)*100>-100000
				trb->percsim:= (trb->mgsimul/trb->CUSTOSTD)*100
			endif
			trb->valcpmf:= nvCpmf
			trb->valmerc:= iif(sc5->c5_fator#"S",nTotNf,0)
			trb->valadic:= nValAdic
		else
			trb->valbrut:= iif(sc5->c5_fator#"S" .and. trb1->d2_tipo<>"P",-trb1->d2_valipi,0)
			//			trb->CUSTOSTD := trb1->d2_custo5
		endif
		//   trb->perc   := ((trb->mgreal/(1+(mv_par05/100)))/trb->MGSTD)*100
		trb->acresc := mv_par05
		trb->verbadic:= SA1->A1_MGEXTRA
		trb->pedido := trb1->d2_pedido
		trb->itempv := trb1->d2_itempv
		if sc5->c5_fator#"S"
			trb->valicms := trb1->d2_valicm
			trb->valicmst:= trb1->d2_icmsret
			trb->valipi  := trb1->d2_valipi
			trb->valpc   := trb1->(d2_valimp5+d2_valimp6) //iif(trb1->d2_tipo$"B*D",trb1->d2_valimp5,nPC)
			trb->valir   := iif(trb1->d2_tipo$"B*D",trb1->d2_valimp4,nIR)
			trb->valcsll := iif(trb1->d2_tipo$"B*D",trb1->d2_valimp3,nCSLL)
		endif
		trb->valcom := iif(sc5->c5_comis1<>0.01,nCom,0)
		trb->perccom:= iif(sc5->c5_comis1<>0.01,sc5->c5_comis1,0)
		trb->valcom2:= nCom2
		trb->DIFAL  := trb1->d2_difal
		if cTpVend = "S"
			trb->valfin := nFin
			trb->valfret:= nFrete
		endif
		trb->desczfr:= IIF(trb1->d2_tes="543",trb1->d2_desczfr,nTotZFR)
		trb->tp     := sc5->c5_fator
		trb->frete  := sc5->c5_tpfrete
		trb->perfret:= sua->UA_PERFRET
		trb->est    := iif(trb1->d2_tipo$"B*D",sa2->a2_est,sa1->a1_est)
		trb->estgrp := iif(trb1->d2_tipo$"B*D",sa2->a2_est,cEst)
		trb->muni   := iif(trb1->d2_tipo$"B*D","dev",sa1->a1_mun)
		trb->transp := iif(trb1->d2_tipo$"B*D","dev",sa4->a4_nome)
		trb->tes    := trb1->d2_tes
		trb->cfop   := trb1->d2_cf
		trb->tpvend := cTpVend
		IF cTpVend = "N" //.or. trb->qtde < 0  - tirei essa condição em 19/02/2018 para voltarem a aparecer as devoluções de VENDAS no relatório de margem
			trb->qtde2 := trb->qtde
			trb->qtde  := 0
			trb->valbrut:= 0
		Endif
		trb->condpag:= se4->e4_descri
		trb->aliqicm:= trb1->d2_picm
		trb->aliqipi:= trb1->d2_ipi
		trb->ncm    := cPosIpi
		trb->cnpj   := SA1->A1_CGC
		trb->inscr  := SA1->A1_INSCR
		trb->tpcli  := SA1->A1_TIPO
		trb->produto:= trb1->d2_cod
		trb->stdprod:= nCStd
		if trim(trb1->d2_cf)$'5101*6101*6107*6109*6110*6118*6401' .and. sc5->c5_fator<>'S'
			trb->desoner:= iif(left(cPosIPI,4)='7009',trb1->d2_total,0)
		endif
		TRB->SEGMENTO 	:= SA1->a1_sativ1
		TRB->REGIAO   	:= SA1->a1_regiao
		TRB->SITCLI	  	:= SA1->A1_SATIV8
		trb->vendcad	:= sa1->a1_vend
		
		msunlock()
		nTotLiq  += (nValLiq*nMultip)
		nTotCust += trb->CUSTOSTD
		nTotStd	 += trb->CUSTOSTD
		nTotCAtu += trb->CUSTOATU
		nTotCSim += trb->CUSTOSIM
		nTotIdeal+= trb->MGSTD
		nTotMg   += (nMarg * nQtdV) //trb1->d2_quant)
		// Totalizadores do balancete - luiz - 18-02-11
		if mv_par01=firstday(mv_par01) .and. mv_par02=lastday(mv_par02)
			if cTpVend = "S"
				nBalFat   += trb->(valbrut+valipi+valicmst)
				nBalIPI   += trb->valipi
				nBalICMST += trb->valicmst
				nBalPC    += trb->valpc
				nBALIR 	  += trb->(valir+valcsll)
				nBalCom   += trb->valcom
				nBalCom1  += trb->valcom2
				nBalFrete += trb->valfret
				nBalDESCZF+= trb->desczfr
				nBalVAdic += trb->valadic
				nBalDespF += iif(trb->valbrut<>0,trb->valfin,0)
			endif
			nBalICM   += trb->valicms
		Endif
		Select trb1
		Skip
	enddo
Enddo

Select trb
//copy to \x for num='026554'

if nBalFat<>0
	GravaBal()
endif

if mv_par06#1 .or. mv_par09#1
	
	aCampos := {}
	AADD(aCampos,{ "EMISSAO" , "D",08,0})
	AADD(aCampos,{ "NUM"     , "C",06,0})
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
	AADD(aCampos,{ "VALIPI"  , "N",12,2})
	AADD(aCampos,{ "VALST"   , "N",12,2})

	AADD(aCampos,{ "VALZFR"  , "N",12,2})
	AADD(aCampos,{ "MGREAL"  , "N",12,2})
	AADD(aCampos,{ "PERCREAL", "N",12,4})
	AADD(aCampos,{ "PESO"    , "N",12,4})
	AADD(aCampos,{ "SEGMENTO", "C",06,0})
	AADD(aCampos,{ "TP"      , "C",01,0})
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
nQtd := nQtdm2 := nVal1 := nVal2 := nVal3 := nVal4 := nVal5 := nVal5 := 0
Do while !eof()
	if tes$"541*542"
		nQtd += Qtde
		nQtdm2 += Qtdem2
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
cTemp12a := CriaTrab(nil,.f.)
IndRegua("TRB", cTemp12a, "Num", , , "Selecionando Registros...")
//Index on Num to &cTemp12a
do case
	case sm0->m0_codigo=="01"
		dbgotop()   
		cArq := "\gerencia\mgft-le.dtc"
		copy to &cArq
//		__CopyFile(cTemp, "\gerencia\mgft-le")
//		copy to \gerencia\mgft-le
//		MsgBox ("Arquivo gerado com sucesso \gerencia\mgft-le.dbf","Informa‡Æo","INFO")
		if file("mgftrm.dbf")
			reclock("TRB",.T.)
			trb->Qtde := -nQtd
			trb->Qtdem2 := -nQtdm2
			trb->ValBrut:= -nVal1
			trb->ValLiq := -nVal2
			trb->CUSTOSTD := -nVal3
			trb->MGSTD:= -nVal4
			trb->MgReal := -nVal5
			MsUnLock()
			appe from mgftrm
			bOk := CpyS2T( cTemp, "mgft-tt" )
//			copy to \gerencia\mgft-tt
			MsgBox ("Arquivo gerado com sucesso \system\mgft-tot.dbf","Informa‡Æo","INFO")
		Endif
	case sm0->m0_codigo=="02"
		bOk := CpyS2T( cTemp, "mgft-rm" )
//		copy to \gerencia\mgft-rm
		MsgBox ("Arquivo gerado com sucesso \system\mgft-rm.dbf","Informa‡Æo","INFO")
endcase
//copy to margemft
//MsgBox ("Arquivo gerado com sucesso \sigaadv\margemft.dbf","Informa‡Æo","INFO")

Use
Select TRB1
Use
Select SC5
Return

*************************
Static Function Imprime()
*************************

if mv_par06#1
	
	//	Cabec1 := "Codigo Vendedor        Est   Custo Std.    Val.Bruto     MG Std.     MG Real   Perc    Peso"
	Cabec1 := "Codigo Vendedor     Coord.   Est       Meta     Val.Bruto  %Meta       Custo Std.     MG Std.     MG Real    Perc        Peso"
	*          01234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec2 := "Período de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
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
	dbGoTop()
	Do while !eof()
		IncRegua("1/6")
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
	Select TRB
	cTemp12b := CriaTrab(nil,.f.)
	IndRegua("TRB", cTemp12b, "Vend", , , "Selecionando Registros...")
//	index on Vend to &cTemp12b
	dbGotop()
	SetRegua(recCount())
	li := 80
	//nTot := 0
	Do while !eof()
		cVend  := trb->Vend
		Select SA3
		seek xFilial()+cVend
		cCoor  := A3_Super
		Select TRB
		nMGR   := nMGI := nVLB := nStd := 0
		Do while !eof() .and. trb->Vend==cVend
			IncRegua("2/6")
			nMGR := nMGR + trb->MGReal
			nMGI := nMGI + trb->MGSTD
			nVLB := nVLB + trb->Valbrut
			nStd := nStd + trb->CUSTOSTD
			skip
		Enddo
		
		Select TRBPRN
		reclock("trbprn",.t.)
		trbprn->Vend   := cVend
		trbprn->Coor   := cCoor
		trbprn->VlBrut := nVLB
		trbprn->CUSTOSTD := nStd
		trbprn->MGSTD:= nMGI
		trbprn->MgReal := nMGR
		if nMGR/nMGI*100<100000 .AND. nMGR/nMGI*100>-10000
			//				trbprn->Percreal   := nMGR/nMGI*100
			trbprn->Percreal   := nMGR/nStd*100
		endif
		trbprn->Peso   := nMGR/nTot*100
		MsUnLock()
		Select TRB
	Enddo
	
	Select TRBPRN
	cTemp12c := CriaTrab(nil,.f.)
	IndRegua("TRBPRN", cTemp12c, "Vend", , , "Selecionando Registros...")
//	index on Vend to cTemp12c //&cTempPrn - verificar
	for n=1 to len(aVendedor)
		Select TRBPRN
		seek aVendedor[n][1]
		if !eof()
			loop
		endif
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+aVendedor[n][1]
		Select trbprn
		if eof() .and. aVendedor[n][2]<>0 .and. mv_par02-mv_par01<=31
			reclock("trbprn",.t.)
			trbprn->Vend   := sa3->a3_cod
			trbprn->Coor   := sa3->a3_super
			trbprn->Meta   := aVendedor[n][2]
			MsUnLock()
		endif
		Select TRBPRN
	Next N
	Select TRBPRN
	//	copy to \x1
	Do Case
		Case mv_par06==2
			cTempPeso := CriaTrab(nil,.f.)
			IndRegua("TRBPRN", cTempPeso, "Peso*(-1)", , , "Selecionando Registros...")
//			index on Peso*(-1) to &cTempPeso
		Case mv_par06==3
			cTempPrn1 := CriaTrab(nil,.f.)
			IndRegua("TRBPRN", cTempPrn1, "Percreal*(-1)", , , "Selecionando Registros...")
//			index on Percreal*(-1) to &cTempPrn1
	EndCase
	
	titulo   := "Posicao de Faturamento (Margem Vend.)"
	
	dbGoTop()
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTotM := 0
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
		// Verificar Meta Vendador (SCT)
		nLinha := Ascan(aVendedor, {|x|x[1] == trbprn->Vend})
		nMeta  := 0
		if nLinha<>0
			nMeta  := aVendedor[nLinha][2]
		endif
		
		Select TRBPRN
		reclock("trbprn",.f.)
		trbprn->Coor   := sa3->a3_super
		trbprn->Meta := nMeta
		MsUnLock()
		@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+" "+left(sa3->a3_super,4)+" "+sa3->a3_est
		//		@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+"  "+sa3->a3_est
		@ li,036 PSAY nMeta   picture "@E 99,999,999"
		@ li,048 PSAY VlBrut  picture "@E 99,999,999"
		if nMeta#0
			@ li,060 PSAY VlBrut/nMeta*100  picture "@E 999.99%"
		endif
		@ li,072 PSAY CUSTOSTD  picture "@E 99,999,999"
		@ li,084 PSAY MGSTD picture "@E 99,999,999"
		@ li,096 PSAY MGReal  picture "@E 99,999,999"
		@ li,108 PSAY Percreal    picture "@E 999.99"
		@ li,120 PSAY Peso    picture "@E 999.99"
		nTot1 := nTot1 +VlBrut
		nTot2 := nTot2 +MGSTD
		nTot3 := nTot3 +MGReal
		nTot4 := nTot4 +Percreal
		nTot5 := nTot5 +Peso
		nTot6 := nTot6 +CUSTOSTD
		nTotM := nTotM +nMETA
		skip
		li:=li+1
	Enddo
	li:=li+1
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,036 PSAY nTotM   picture "@E 99,999,999"
	@ li,048 PSAY ntot1   picture "@E 99,999,999"
	if nTotM#0
		@ li,060 PSAY ntot1/nTotM*100  picture "@E 999.99%"
	endif
	@ li,072 PSAY ntot6   picture "@E 99,999,999"
	@ li,084 PSAY ntot2   picture "@E 99,999,999"
	@ li,096 PSAY nTot3   picture "@E 99,999,999"
	@ li,108 PSAY ntot3/ntot6*100  picture "@E 999.99"
	@ li,120 PSAY ntot5   picture "@E 999.99"
	li:=li+2
	
	cTempCoor := CriaTrab(nil,.f.)
	IndRegua("TRBPRN", cTempcoor, "Coor", , , "Selecionando Registros...")
//	index on Coor to &cTempCoor
	dbGoTop()
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTotM := 0
	Do while !eof()
		If li > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		cCoor  := trbprn->Coor
		nMGR   := nMGI := nVLB := nStd := nMet := 0
		Do while !eof() .and. trbprn->Coor==cCoor
			IncRegua("3/6")
			nMGR := nMGR + trbprn->MGReal
			nMGI := nMGI + trbprn->MGSTD
			nVLB := nVLB + trbprn->Vlbrut
			nStd := nStd + trbprn->CUSTOSTD
			nMet := nMet + trbprn->META
			skip
		Enddo
		//		if nMGR/nMGI*100<100000
		if nMGR/nStd*100<100000
			nPerc   := nMGR/nStd*100
		endif
		nPeso   := nMGR/nTot*100
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+cCoor
		Select TRBPRN
		@ li,000 PSAY cCoor+"-"+sa3->a3_nreduz
		@ li,036 PSAY nMet    picture "@E 99,999,999"
		@ li,048 PSAY nVlB    picture "@E 99,999,999"
		if nMet#0
			@ li,060 PSAY nVlB/nMet*100  picture "@E 999.99%"
		endif
		@ li,072 PSAY nStd    picture "@E 99,999,999"
		@ li,084 PSAY nMGI    picture "@E 99,999,999"
		@ li,096 PSAY nMGR    picture "@E 99,999,999"
		@ li,108 PSAY nPerc   picture "@E 999.99"
		@ li,120 PSAY nPeso   picture "@E 999.99"
		nTot1 := nTot1 +nVlB
		nTot2 := nTot2 +nMGI
		nTot3 := nTot3 +nMGR
		nTot4 := nTot4 +nPerc
		nTot5 := nTot5 +nPeso
		nTot6 := nTot6 +nStd
		nTotM := nTotM +nMet
		li:=li+1
	Enddo
	
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total  "
	@ li,036 PSAY ntotM   picture "@E 99,999,999"
	@ li,048 PSAY ntot1   picture "@E 99,999,999"
	if nTotM#0
		@ li,060 PSAY ntot1/nTotM*100  picture "@E 999.99%"
	endif
	@ li,072 PSAY ntot6   picture "@E 99,999,999"
	@ li,084 PSAY ntot2   picture "@E 99,999,999"
	@ li,096 PSAY nTot3   picture "@E 99,999,999"
	//	@ li,066 PSAY ntot3/ntot2*100  picture "@E 999.99"
	@ li,108 PSAY ntot3/ntot6*100  picture "@E 999.99"
	@ li,120 PSAY ntot5   picture "@E 999.99"
	
	// Totalizado por Segmento - 12/11/2018
	nPeso := 0
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0

	li:=li+1
	@ li,000 PSAY "Segmento"//                                         Val.Bruto              Custo Std.     MG Std.     MG Real    Perc        Peso"
	li:=li+1
	for n=1 to len(aSegmento)
		Select SX5
		seek xFilial()+"T3"+TRIM(aSegmento[n][1])
		If li > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			@ li,000 PSAY "Segmento"//                                         Val.Bruto              Custo Std.     MG Std.     MG Real    Perc        Peso"
			li:=li+1
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
	@ li,000 PSAY "Total "
	@ li,048 PSAY ntot2   picture "@E 99,999,999"
	@ li,072 PSAY ntot3   picture "@E 99,999,999"
	@ li,084 PSAY ntot4   picture "@E 99,999,999"
	@ li,096 PSAY nTot5   picture "@E 99,999,999"
	@ li,108 PSAY nTot5/nTot3*100   picture "@E 999.99"
	@ li,120 PSAY 100     picture "@E 999.99"

	//	@ li,108 PSAY ntot3/ntot6*100  picture "@E 999.99"
	//	@ li,120 PSAY ntot5   picture "@E 999.99"
	
Endif

** Relatorio por cliente

if mv_par09#1
	Cabec1 := "Cliente Nome                                    Est   Val.Bruto   Custo Std     MG Std.     MG Real    Perc     Peso"
	*          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	*                    1         2         3         4         5         6         7         8         9        10        11         12
	*                                                               99,999,999  99,999,999  99,999,999  99,999,999  99,999   99,999
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
			IncRegua("4/6")
			ntot := nTot + MGReal
			Skip
		Enddo
	Endif
	cTempCli := CriaTrab(nil,.f.)
	IndRegua("TRBPRN", cTempCli, "Cli", , , "Selecionando Registros...")
//	index on Cli  to &cTempCli
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
		nMGR   := nMGI := nVLB := nStd := 0
		Do while !eof() .and. trb->CodCli ==cCli
			IncRegua("5/6")
			nStd := nStd + trb->CUSTOSTD
			nMGR := nMGR + trb->MGReal
			nMGI := nMGI + trb->MGSTD
			nVLB := nVLB + trb->Valbrut
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
		trbprn->CUSTOSTD := nStd
		trbprn->MGSTD:= nMGI
		trbprn->MgReal := nMGR
		//			if nMGR/nMGI*100<100000
		//				trbprn->Perc   := nMGR/nMGI*100
		//			endif
		if nMGR/nStd*100<100000 .AND. nMGR/nStd*100>-10000
			trbprn->Percreal   := nMGR/nStd*100
		endif
		trbprn->Peso   := nMGR/nTot*100
		MsUnLock()
		Select TRB
	Enddo
	
	cPrn1:= CriaTrab(nil,.f.)
	Select TRBPRN
	Do Case
		Case mv_par09==2
			IndRegua("TRBPRN", cPrn1, "Peso*(-1)", , , "Selecionando Registros...")
//			index on Peso*(-1) to &cPrn1
		Case mv_par09==3
			IndRegua("TRBPRN", cPrn1, "Percreal*(-1)", , , "Selecionando Registros...")
//			index on Percreal*(-1) to &cPrn1
		Case mv_par09==4
			IndRegua("TRBPRN", cPrn1, "Nome", , , "Selecionando Registros...")
//			index on Nome to &cPrn1
	EndCase
	
	titulo   := "Posicao de Faturamento (Margem Cli.)"
	
	dbGoTop()
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		Select TRBPRN
		@ li,000 PSAY Cli+"-"+Nome+"  "+Est
		@ li,053 PSAY VlBrut  picture "@E 99,999,999"
		@ li,065 PSAY CUSTOSTD  picture "@E 99,999,999"
		@ li,077 PSAY MGSTD picture "@E 99,999,999"
		@ li,089 PSAY MGReal  picture "@E 99,999,999"
		@ li,101 PSAY Percreal    picture "@E 999.99"
		@ li,110 PSAY Peso    picture "@E 999.99"
		nTot1 := nTot1 +VlBrut
		nTot2 := nTot2 +MGSTD
		nTot3 := nTot3 +MGReal
		nTot4 := nTot4 +PercReal
		nTot5 := nTot5 +Peso
		nTot6 := nTot6 +CUSTOSTD
		skip
		li:=li+1
	Enddo
	If li > 56
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	li:=li+1
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,053 PSAY ntot1   picture "@E 99,999,999"
	@ li,065 PSAY ntot6   picture "@E 99,999,999"
	@ li,077 PSAY ntot2   picture "@E 99,999,999"
	@ li,089 PSAY nTot3   picture "@E 99,999,999"
	//	@ li,066 PSAY ntot3/ntot2*100  picture "@E 999.99"
	@ li,101 PSAY ntot3/ntot6*100  picture "@E 999.99"
	@ li,110 PSAY ntot5   picture "@E 999.99"
	li:=li+2
	
	** Relatorio por nota fiscal
	
	Cabec1 := "Nota    Nome           Est Custo Std    Val.Bruto       IPI          ST       Total"
	*          01234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec2 := "Período de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	Select TRBPRN
	if reccount()#0
		use
		dbCreate(cTempPrn,aCampos)
		dbUseArea( .T.,,cTempPrn,"TRBPRN", Nil, .F. )
	endif
	Select TRB
	SetRegua(recCount())
	cTempEmis := CriaTrab(nil,.f.)
	IndRegua("TRB", cTempEmis, "dtos(emissao)+num", , , "Selecionando Registros...")
//	index on dtos(emissao)+num to &cTempEmis
	dbGotop()
	SetRegua(recCount())
	li := 80
	//nTot := 0 xxy
	Do while !eof()
		IF ITEM='DV' .or. TPVEND='N'
			SKIP
			LOOP
		ENDIF
		dEmissao := trb->Emissao
		tValIPI:= tValSt := tVLB := tStd := 0
		tZfr := 0
		Do while !eof() .and. dEmissao == trb->Emissao
			IF ITEM='DV' .or. TPVEND='N'
				SKIP
				LOOP
			ENDIF
			cCli   := trb->CodCli
			cNum   := trb->Num
			cNom   := trb->Cli
			cNomR  := trb->NReduz
			cEst   := trb->Est
			cVend  := trb->Vend
			cCoor  := trb->Coor
			cTp	   := trb->tp
			nValIPI:= nValSt := nVLB := nStd := 0
			nZfr := 0
			Do while !eof() .and. trb->Num ==cNum
				IncRegua("6/6")
				IF ITEM='DV' .or. TPVEND='N'
					SKIP
					LOOP
				ENDIF
				nValIpi += trb->ValIpi
				nValSt  += trb->ValicmST
				nVLB	+= trb->Valbrut
				nStd	+= trb->CUSTOSTD
				nZfr	+= iif(trb->tp="A",trb->DescZfr,0)
				tValIpi += trb->ValIpi
				tValSt  += trb->ValicmST
				tVLB	+= trb->Valbrut
				tStd	+= trb->CUSTOSTD
				tZfr	+= iif(trb->tp="A",trb->DescZfr,0)
				skip
			Enddo
			Select TRBPRN
			reclock("trbprn",.t.)
			trbprn->emissao:= dEmissao
			trbprn->Cli    := cCli
			trbprn->Num    := cNum
			trbprn->Nome   := cNom
			trbprn->NReduz := cNomR
			trbprn->Est    := cEst
			trbprn->Vend   := cVend
			trbprn->Coor   := cCoor
			trbprn->VlBrut := nVLB
			trbprn->CUSTOSTD := nStd
			trbprn->ValIpi := nValIPI
			trbprn->ValST  := nValST
			trbprn->ValZfr := nZfr
			MsUnLock()
			Select TRB
		Enddo
		Select TRBPRN
		reclock("trbprn",.t.)
		trbprn->emissao:= dEmissao
		trbprn->num    := '999999'
		trbprn->CUSTOSTD := tStd
		trbprn->VlBrut := tVLB
		trbprn->ValIpi := tValIPI
		trbprn->ValST  := tValST
		trbprn->ValZfr := tZfr
		msUnLock()
		Select TRB
	Enddo
	cPrn1:= CriaTrab(nil,.f.)
	Select TRBPRN
	IndRegua("TRBPRN", cPrn1, "dtos(emissao)+num", , , "Selecionando Registros...")
//	index on dtos(emissao)+Num to &cPrn1
	
	titulo   := "Relacao de Notas Fiscais emitidas"
	
	dbGoTop()
	
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := tZfr := 0
	Do while !eof()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		Select TRBPRN
		if Num<>'999999'  //ctp="X" para não considerar desconto da zona franca
			@ li,000 PSAY Num+"-"+left(Nome,20)+"  "+Est
			@ li,028 PSAY VlBrut  picture "@E 99,999,999"
			@ li,040 PSAY CUSTOSTD  picture "@E 99,999,999"
			@ li,052 PSAY ValIpi picture "@E 99,999,999"
			@ li,064 PSAY ValST  picture "@E 99,999,999"
			@ li,076 PSAY VlBrut+ValIPI+ValST+iif(ctp="X",ValZfr,0) picture "@E 999,999.99"
			nTot6 := nTot6 +CUSTOSTD
			nTot1 := nTot1 +VlBrut
			nTot2 := nTot2 +ValIpi
			nTot3 := nTot3 +ValST
			nTot4 := nTot4 +VlBrut+ValIPI+ValST
			tZfr  := tZfr +iif(ctp="X",ValZfr,0)
		endif
		skip
		li:=li+1
		if Num='999999'
			li:=li+1
			@ li,000 PSAY "Total dia " + dtoc(Emissao)
			@ li,028 PSAY VlBrut  picture "@E 99,999,999"
			@ li,040 PSAY CUSTOSTD  picture "@E 99,999,999"
			@ li,052 PSAY ValIpi picture "@E 99,999,999"
			@ li,064 PSAY ValST  picture "@E 99,999,999"
			@ li,076 PSAY VlBrut+ValIPI+ValST+iif(ctp="X",ValZfr,0) picture "@E 999,999.99"
			li:=li+1
			li:=li+1
		endif
	Enddo
	If li > 56
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	li:=li+1
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,028 PSAY ntot1   picture "@E 99,999,999"
	@ li,040 PSAY ntot6   picture "@E 99,999,999"
	@ li,052 PSAY ntot2   picture "@E 99,999,999"
	@ li,064 PSAY nTot3   picture "@E 99,999,999"
	@ li,076 PSAY ntot4+tZfr   picture "@E 9999,999.99"
	li:=li+2
	
Endif

if 1==2
	**Desoneração da Folha
	Cabec2 := "Nota Fiscal Produto        NCM          CFOP  Valor"
	*          01234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec1 := "de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	titulo   := "Desoneração Folha "
	
	Select TRB1
	ProcRegua(reccount())
	go top
	nTot := nTotFat := 0
	Do while !eof()
		IncProc()
		if !trim(d2_cf)$'5101*6101*6107*6109*6110*6118*6401'
			skip
			loop
		endif
		Select SB1
		seek xFilial()+trb1->d2_cod
		Select TRB1
		@ li,000 PSAY D2_DOC
		@ li,012 PSAY D2_COD
		@ li,027 PSAY sb1->b1_posipi
		@ li,040 PSAY D2_CF
		if left(sb1->b1_posipi,4)$'7009*9616'
			@ li,046 PSAY D2_TOTAL  picture "@E 99,999,999.99"
			nTot += D2_TOTAL
		endif
		nTotFat += D2_TOTAL
		li:=li+1
		If li > 56
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		skip
	Enddo
	li:=li+2
	@ li,025 PSAY "Total no Periodo"
	@ li,046 PSAY nTot     picture "@E 99,999,999.99"
	@ li,060 PSAY nTotFat  picture "@E 99,999,999.99"
	@ li,076 PSAY nTot/nTotFat*100  picture "@E 99.99"
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
Static Function CalcVLiq(dEmis)
**************************
dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial()+"MV_PCI")
nPCI  := Val(Alltrim(SX6->X6_CONTEUD))
dbSeek(xFilial()+"MV_CPMF")
if year(dEmis)<=2007
	nCPMF := 0.38
else
	nCPMF := Val(Alltrim(SX6->X6_CONTEUD))
Endif

Do Case
	Case SA1->A1_EST $ "AC/AL/AM/AP/BA/CE/DF/ES/GO/MA/MS/MT/PA/PE/PB/PI/SE/RN/RO/RR/TO"
		//	_nImpost := 7 + nPCI
	Case SA1->A1_EST $ "RJ/MG/PR/SC/RS"
		//	_nImpost := 12+ nPCI
	Case SA1->A1_EST == "SP"
		//	_nImpost := 18+ nPCI
	Otherwise
		//	_nImpost := 18+ nPCI
EndCase
if SC5->C5_TIPOCLI == "F" .OR. (LEN(TRIM(SA1->A1_CGC))>=9 .AND. LEN(TRIM(SA1->A1_CGC))<=11)
	//	_nImpost := 18+ nPCI
endif
_nImpost := nPCI
if SC5->C5_Fator == "S"
	nPCI    := 0
	_nImpost := 0
endif

nFrete := 0
// Novo cálculo em 18/02/2021
if 	trb1->d2_serie= "DEV" .or. year(sf2->f2_emissao)>=2014
	if Substr(sc5->c5_TpFrete,1,1)=="C"
		Do case
			Case sa1->a1_est$"BA*CE"
				nFrete := nTotFat*.1 // -nTotFat/1.10
				//			nFrete := nValNota*0.10
				if sa1->a1_est="CE" .and. trim(sa1->a1_cod_mun)="12908" //"SOBRAL"
					//				nFrete := nValNota*0.12
					nFrete := nTotFat*.12 //-nTotFat/1.12
				endif
			Case sa1->a1_est$"MG" .and. trim(sa1->a1_cod_mun)="06200" //"BELO HORIZONTE"
				//			nFrete := nValNota*0.06
				nFrete := nTotFat*.06 //-nTotFat/1.06
			Case sa1->a1_est$"RJ"
				//			nFrete := nValNota*0.065
				nFrete := nTotFat*.065 //-nTotFat/1.065
			Case sa1->a1_est$"SP" .and. ;
				trim(sa1->a1_mun)$"SANTOS*SAO VICENTE*GUARUJA*CARAGUATATUBA*UBATUBA"
				//			nFrete := nValNota*0.065
				nFrete := nTotFat*.065 //-nTotFat/1.065
			Case sa1->a1_est$"SP" .and. ;
				trim(sa1->a1_mun)$"PRAIA GRANDE*CUBATAO*ITANHAEM*MONGAGUA*PERUIBE*SAO SEBASTIAO"
				//			nFrete := nValNota*0.065
				nFrete := nTotFat*.065 //-nTotFat/1.065
			Case sa1->a1_est$"SP" .and. sa1->a1_cod_mun$"50308*05708*25003*18800" // SP / Barueri / Jandira / Guarulhos ;
				//		"SAO"$sa1->a1_mun .and. "PAULO"$sa1->a1_mun
				nFrete := 0
			Case sa1->a1_est$"RS"
				//			nFrete := nValNota*0.12
				nFrete := nTotFat*.12 //-nTotFat/1.12
			Otherwise
				//			nFrete := nValNota*0.15
				nFrete := nTotFat*.15 //-nTotFat/1.15
		EndCase
	endif
Else
	Do case
		Case Substr(sc5->c5_TpFrete,1,1)=="C" .and. sa1->a1_est$"CE"
			nFrete := nTotFat-nTotFat/1.10
		Case Substr(sc5->c5_TpFrete,1,1)=="C" .and. sa1->a1_est$"BA*PE"
			nFrete := nTotFat-nTotFat/1.08
		Case Substr(sc5->c5_TpFrete,1,1)=="C" .and. sa1->a1_est$"RJ"
			nFrete := nTotFat-nTotFat/1.065
		Case Substr(sc5->c5_TpFrete,1,1)=="C" .and. sa1->a1_est$"SP"
			nFrete := nTotFat-nTotFat/1.03
		Otherwise
			if Substr(sc5->c5_TpFrete,1,1)=="C"
				nFrete := nTotFat-nTotFat/1.15
			else
				nFrete := 0
			endif
	EndCase
endif

Select SUA
dbSetOrder(8)
seek xFilial()+trb1->d2_pedido
//IF SC5->c5_numtmk=sua->ua_num .and. sc5->c5_emissao >=stod("20160901")
	cCondPag := sua->UA_CONDPG
//else
//	cCondPag := sc5->C5_CONDPAG
//endif

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+cCondPag)
_cPagto := se4->e4_indefla

nTotFat1 := nTotFat + trb1->d2_valipi
Do case
	Case _cPagto == "A"  // A Vista
		_ValIni := nTotFat1-(nTotFat1/1.00)
	Case _cPagto == "B"  // 14 dd
		_ValIni := nTotFat1-(nTotFat1/1.015)
	Case _cPagto == "C"  // 30 dd
		_ValIni := nTotFat1-(nTotFat1/1.030)
	Case _cPagto == "D"  // 45 dd
		_ValIni := nTotFat1-(nTotFat1/1.045)
	Case _cPagto == "E"  // 60 dd
		_ValIni := nTotFat1-(nTotFat1/1.060)
	Case _cPagto == "F"  // 75 dd
		_ValIni := nTotFat1-(nTotFat1/1.075)
	Case _cPagto == "G"  // 90 dd
		_ValIni := nTotFat1-(nTotFat1/1.090)
	Otherwise  // Outros
		_ValIni := nTotFat1-(nTotFat1/1.00)
EndCase



nFin    := _ValIni
if cTpVend # "N"
	nDescontar := 0
	if SC5->C5_Fator == "C"
		nDescontar := 0 //nTotZFR
	endif
	//	nCom    := ((nTotFat-nDescontar-nFrete) * sc5->C5_COMIS1)/100  // Alterei 01/08/2017 para o cálculo de comissão ficar de acordo com o recebimento
	//	nCom2   := iif(nCom#0,((nTotFat-nDescontar-nFrete) * nComS)/100,0)
	nCom    := ((nTotFat) * sc5->C5_COMIS1)/100
	nCom2   := iif(nCom#0,((nTotFat) * nComS)/100,0)
endif
nVCpmf  := ((nTotFat+trb1->d2_valipi) * nCpmf)/100
if sf4->f4_piscof#"4"
	nIR     := (nTotNf * 1.80)/100
	nCSLL   := (nTotNf * 1.08)/100
	if nTotZFR#0
		nIR     := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.80)/100
		nCSLL   := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.08)/100
		nVCpmf  := (((nTotFat+trb1->d2_valipi)+nTotZFR) * nCpmf)/100
	else
		nPC     := (nTotNf * nPCI)/100
	endif
else
	if nTotZFR#0
		nIR     := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.80)/100
		nCSLL   := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.08)/100
		nVCpmf  := (((nTotFat+trb1->d2_valipi)+nTotZFR) * nCpmf)/100
	endif
endif

_cSetor := sc5->c5_fator

IF _cSetor == "S" .and. sm0->m0_codigo=="02"
	nSimples := 12.11
	nPC  := nTotNf*nSimples/100
	nIR  := 0
	nCSLL:= 0
Endif

nPc := trb1->(d2_valimp5+d2_valimp6)  // Novo cálculo do PIS/Cofins buscando direto no cálculo da nota

nValAdic := (nTotFat+trb1->(d2_valipi+d2_icmsret))*(sa1->a1_mgextra/100)
if sm0->m0_codigo=="02"   //xxxx
	nValLiq := nTotFat-trb1->d2_valicm-nVCpmf-nCom-nCom2-nPC-nFin-nFrete-nValAdic //+nTotZFR
else
	nValLiq := nTotFat-trb1->d2_valicm-trb1->d2_difal-nVCpmf-nCom-nCom2-nPC-nIR-nCSLL-nFin-nFrete-nValAdic+iif(_cSetor = "A",nTotZFR,0)//+nTotZFR
// Em 12/05/2020 Tirei ZFranca
	if _cSetor # "A"
		//		nValLiq := nValLiq - nTotZFR
	endif
endif
Return

**************************
Static Function VerFrete()
**************************

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT)

nFrete := 0
//nValNota := sf2->f2_valmerc
nValNota := TRB1->D2_total
// Mudança a partir de 01/01/2014
if year(sf2->f2_emissao)>=2014
	Do case
		Case sa1->a1_est$"BA*CE"
			nFrete := nValNota*0.10
			if sa1->a1_est="CE" .and. trim(sa1->a1_cod_mun)="12908" //"SOBRAL"
				nFrete := nValNota*0.12
			endif
		Case sa1->a1_est$"MG" .and. trim(sa1->a1_cod_mun)="06200" //"BELO HORIZONTE"
			nFrete := nValNota*0.06
		Case sa1->a1_est$"RJ"
			nFrete := nValNota*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"SANTOS*SAO VICENTE*GUARUJA*CARAGUATATUBA*UBATUBA"
			nFrete := nValNota*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"PRAIA GRANDE*CUBATAO*ITANHAEM*MONGAGUA*PERUIBE*SAO SEBASTIAO"
			nFrete := nValNota*0.065
		Case sa1->a1_est$"SP" .and. sa1->a1_cod_mun$"50308*05708*25003*18800" // SP / Barueri / Jandira / Guarulhos ;
			//		"SAO"$sa1->a1_mun .and. "PAULO"$sa1->a1_mun
			nFrete := 0
		Case sa1->a1_est$"RS"
			nFrete := nValNota*0.12
		Otherwise
			nFrete := nValNota*0.15
	EndCase
Else
	Do case
		Case sa1->a1_est$"BA*CE*PE"
			nFrete := nValNota*0.09
		Case sa1->a1_est$"MG"
			nFrete := nValNota*0.04
		Case sa1->a1_est$"RJ"
			nFrete := nValNota*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"SANTOS*SAO VICENTE*GUARUJA*CARAGUATATUBA*UBATUBA"
			nFrete := nValNota*0.05
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"PRAIA GRANDE*CUBATAO*ITANHAEM*MONGAGUA*PERUIBE*SAO SEBASTIAO"
			nFrete := nValNota*0.05
		Case sa1->a1_est$"SP" .and. ;
			"SAO"$sa1->a1_mun .and. "PAULO"$sa1->a1_mun
			nFrete := 0
		Otherwise
			nFrete := nValNota*0.15
	EndCase
Endif

DbSelectArea("SF2")

if !eof()
	RecLock("SF2",.f.)
	sf2->f2_frete1 := nFrete
	MsUnLock()
endif

Return

**************************
Static Function VerStd()
**************************
dFecStd := GetMV("MV_ULSTD")
nCStd := nMarg := 0
Select SB9  // Custo Congelado
dbSetOrder(1)
nTam := len(trim(cCod))
seek xFilial()+left(cCod,nTam)+space(15-nTam)+Space(2)+dtos(dFecStd)
if sb9->b9_custd<>0
	nCStd := sb9->b9_custd
endif
if sb9->b9_margem<>0
	nMarg := sb9->b9_margem
endif

Return



****************************
Static Function GArq
****************************

Select TRB
ProcRegua(reccount())
nTotReal := 0
nTotQtde := 0
nTotQtdeM2:= 0
nTotValB := 0
nTotValq := 0
nTotStdL := 0
nTotMGId := 0
dbGoTop()
Do while !eof()
	IncProc()
	nTotReal += MGReal
	nTotQtde += Qtde
	nTotQtdeM2 += QtdeM2
	nTotValB += ValBrut
	nTotValq += Valliq
	nTotStdL += CUSTOSTD
	nTotMGId += MGSTD
	Skip
Enddo

For n:=1 to 5   // Gerar os 5 arquivos
	aCampos := {}
	if n==1
		AADD(aCampos,{ "PRODUTO" , "C",15,0})
		AADD(aCampos,{ "DESC"    , "C",40,0})
		AADD(aCampos,{ "TPPROD"	 , "C",02,0})
	endif
	if n==2
		AADD(aCampos,{ "GRPCLI"  , "C",08,0})
		AADD(aCampos,{ "CLI"     , "C",08,0})
		AADD(aCampos,{ "NOME"    , "C",30,0})
		AADD(aCampos,{ "NREDUZ"  , "C",20,0})
		AADD(aCampos,{ "UF"      , "C",02,0})
		AADD(aCampos,{ "VEND"    , "C",06,0})
		AADD(aCampos,{ "RANK"    , "N",04,0})
		AADD(aCampos,{ "NOMEV"   , "C",20,0})
		AADD(aCampos,{ "NOMEC"   , "C",20,0})
		AADD(aCampos,{ "SEGMENTO", "C",10,0})
		AADD(aCampos,{ "REGIAO"  , "C",10,0})
		AADD(aCampos,{ "SITCLI"  , "C",01,0})
		AADD(aCampos,{ "VENDCAD"  , "C",06,0})
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
		AADD(aCampos,{ "NOMEC"   , "C",20,0})
		AADD(aCampos,{ "NOMEV"   , "C",20,0})
		AADD(aCampos,{ "QTDCLIUF", "N",04,0})
		AADD(aCampos,{ "QTDCLI"  , "N",04,0})
		AADD(aCampos,{ "DESATIVA", "N",04,0})
		AADD(aCampos,{ "ATIVO"   , "N",04,0})
		AADD(aCampos,{ "REATIVAD", "N",04,0})
		AADD(aCampos,{ "INATIVO" , "N",04,0})
	endif
	AADD(aCampos,{ "QTDE"    , "N",12,2})
	AADD(aCampos,{ "QTDEM2"  , "N",16,4})  //11- Quantidade Faturada
	AADD(aCampos,{ "QTDEP"   , "N",10,5})
	AADD(aCampos,{ "VLBRUT"  , "N",12,2})
	AADD(aCampos,{ "VLBRUTP" , "N",08,4})
	AADD(aCampos,{ "VALLIQ"  , "N",12,2})
	AADD(aCampos,{ "VALLIQP"  , "N",08,4})
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
			cTmp01 := CriaTrab(nil,.f.)
			IndRegua("TRBPR1", cTmp01, "Produto", , , "Selecionando Registros...")
//			index on Produto to &cTmp01
		Case n==2 .and. mv_par11==1
			cTmp02 := CriaTrab(nil,.f.)
			IndRegua("TRBPR1", cTmp02, "Nome", , , "Selecionando Registros...")
//			index on Nome to &cTmp02
		Case n==3 .and. mv_par12==1
			cTmp03 := CriaTrab(nil,.f.)
			IndRegua("TRBPR1", cTmp03, "Vend", , , "Selecionando Registros...")
//			index on Vend to &cTmp03
		Case n==4 .and. mv_par12==1
			cTmp04 := CriaTrab(nil,.f.)
			IndRegua("TRBPR1", cTmp04, "Uf", , , "Selecionando Registros...")
//			index on Uf   to &cTmp04
		Case n==5 .and. mv_par12==1
			cTmp05 := CriaTrab(nil,.f.)
			IndRegua("TRBPR1", cTmp05, "Uf+Vend", , , "Selecionando Registros...")
//			index on Uf+Vend to &cTmp05
//		Otherwise
//			index on Vend to &cTempArq
	EndCase
	
	Select TRB            
	do case
		Case n==1 .and. mv_par10==1
			cTmp06 := CriaTrab(nil,.f.)
			IndRegua("TRB", cTmp06, "Cod", , , "Selecionando Registros...")
//			index on Cod  to cTmp06 // Verificar
		Case n==2 .and. mv_par11==1
			cTmp07 := CriaTrab(nil,.f.)
			IndRegua("TRB", cTmp07, "GrpCli", , , "Selecionando Registros...")
//			index on GrpCli  to cTmp07 // Verificar
			//			index on Cli  to &cTemp
		Case n==3 .and. mv_par12==1
			cTmp08 := CriaTrab(nil,.f.)
			IndRegua("TRB", cTmp08, "Vend", , , "Selecionando Registros...")
//			index on vend to cTmp08 // Verificar
		Case n==4 .and. mv_par12==1
			cTmp09 := CriaTrab(nil,.f.)
			IndRegua("TRB", cTmp09, "Est+codcli", , , "Selecionando Registros...")
//			index on Est+codcli  to cTmp09 // Verificar
		Case n==5 .and. mv_par12==1
			cTmp10 := CriaTrab(nil,.f.)
			IndRegua("TRB", cTmp10, "Est+Vend", , , "Selecionando Registros...")
//			index on Est+Vend  to cTmp10 // Verificar
			//			UfXVen()
			UfXVen1()
			
	EndCase
	dbGotop()
	ProcRegua(reccount())
	li := 80
	//nTot := 0
	nTot1 := nTot1a := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTot7 :=nTot8 :=nTot9 :=nTot10 := 0

	Do while !eof()
		Select TRB
		nMGR   := nMGI := nVLB := nQtd := nQtdm2 := nStd := nVlq := 0
		nCUSTOATU	:= nMGAtu := nPercActu := nCUSTOSIM := nMgSimul := mPercSim :=  0
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
					nVLq := nVLq + trb->Valliq
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nQtdm2 := nQtdm2 + trb->Qtdem2
					nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
					nMGAtu := nMGAtu + trb->MGAtu
					nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
					nMgSimul := nMgSimul + trb->MgSimul
					skip
				Enddo
			Case n==2 .and. mv_par11==1
				cChave := GrpCli
				//				cChave := CODCLI
				cCli   := CLI
				cNReduz:= NREDUZ
				cVend  := VEND
				cEst   := EST
				cCoor  := COOR
				cRegiao:= REGIAO
				cSitCli:= SITCLI
				cSegmento:= SEGMENTO
				cVendCad:= VENDCAD
				cgrpcli := GRPCLI
				nRank	:= RANK
				Do while !eof() .and. GrpCli==cChave //trb->CodCli==cChave
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nVLq := nVLq + trb->Valliq
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nQtdm2 := nQtdm2 + trb->Qtdem2
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
					nVLq := nVLq + trb->Valliq
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nQtdm2 := nQtdm2 + trb->Qtdem2
					nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
					nMGAtu := nMGAtu + trb->MGAtu
					nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
					nMgSimul := nMgSimul + trb->MgSimul
					skip
				Enddo
			Case n==4 .and. mv_par12==1
				cChave := Est
				cEst   := Est
				Do while !eof() .and. trb->Est==cChave
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nVLq := nVLq + trb->Valliq
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nQtdm2 := nQtdm2 + trb->Qtdem2
					nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
					nMGAtu := nMGAtu + trb->MGAtu
					nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
					nMgSimul := nMgSimul + trb->MgSimul
					skip
				Enddo
			Case n==5 .and. mv_par12==1 .and. 1=2 // Estado / Vendedor // troquei pela função UfXVen1()
				cChave := CODCLI
				cCli   := CLI
				cNReduz:= NREDUZ
				cVend  := VEND
				cEst   := EST
				cCoor  := COOR
				Do while !eof() .and. trb->(Est+Vend+Coor)==cEst+cVend+cCoor
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nVLq := nVLq + trb->Valliq
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
					nQtdm2 := nQtdm2 + trb->Qtdem2
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
		Select SA1
		dbSetOrder(1)
		Seek xFilial()+trim(cChave)
		
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+trim(cChave)
		
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+cvend
		cNomv := sa3->a3_nreduz
		cUf   := iif(n==2 .or. n==4,cEst,sa3->a3_est)
		cCoor := sa3->a3_super
		Seek xFilial()+trim(cCoor)
		cSuper := sa3->a3_nreduz
		
		Select TRBPR1
		seek cCod
		if eof() .and. n==1
			reclock("trbpr1",.t.)
			msUnLock()
		endif
		
		if n==5
			seek cUf+cVend+cSuper
		endif
		
		if n<>5  // UF X Vend  substituido pela função UfXVen1()
			if n==1
				reclock("trbpr1",.f.)
				trbpr1->Produto:= cCod
				trbpr1->Desc   	:= sb1->b1_desc
				trbpr1->TPProd 	:= sb1->b1_base
			else
				reclock("trbpr1",.t.)
				if n==2
					trbpr1->Nome   := cCli
					trbpr1->NReduz := cNREDUZ
					trbpr1->Regiao := cREGIAO
					trbpr1->SitCli := cSITCLI
					trbpr1->Segmento:= cSEGMENTO
					trbpr1->VendCad:= cVENDCAD
					trbpr1->grpcli := cGRPCLI
					trbpr1->Rank   := nRANK
				endif
				trbpr1->Uf     := cUf
				if n<>4
					trbpr1->Vend   := cVend
					trbpr1->NomeV  := cNomV
					trbpr1->Nomec  := cSuper
				endif
				if n=3
					trbpr1->Nomec  := cCoor
				endif
			endif
			trbpr1->Qtde    += nQtd
			trbpr1->Qtdem2  += nQtdm2
			trbpr1->QtdeP   := Qtde/nTotQtde
			trbpr1->VlBrut  += nVLB
			trbpr1->VlBrutP := VLBrut/nTotValb
			trbpr1->Valliq  += nVLq
			trbpr1->ValliqP := Valliq/nTotValq
			trbpr1->CUSTOSTD  += nSTD
			trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
			trbpr1->MGSTD += nMGI
			if MGStd/nStd*100 < 100000
				trbpr1->PercStd    := MGStd/nStd*100
			endif
			trbpr1->MgReal  += nMGR
			//			if MGReal/nMGI*100 < 100000
			//				trbpr1->Perc    := MGReal/nMGI*100
			if MGReal/nStd*100 < 100000  .AND. MGReal/nStd*100>-10000
				trbpr1->PercReal    := MGReal/nStd*100
			endif
			trbpr1->CUSTOATU += nCUSTOATU
			trbpr1->MGAtu  += nMGAtu
			trbpr1->CUSTOSIM += nCUSTOSIM
			trbpr1->MgSimul+= nMgSimul
			if nMgSimul<>0
				//				trbpr1->PercSim := (mgsimul/MGSTD)*100
				if (nMgsimul/nCUSTOSIM)*100<100000 .and. (nMgsimul/nCUSTOSIM)*100>-100000
					trbpr1->PercSim := (nMgsimul/nCUSTOSIM)*100
				endif
			endif
			if MgAtu<>0
				//				trbpr1->PercAtu := (mgatu/MGSTD)*100
				trbpr1->PercAtu := (mgatu/CUSTOATU)*100
			endif
			msUnlock()
		endif
		nTot1 += nQtd
		nTot1a+= nQtdm2
		nTot2 += nVLB
		nTot3 += nStd
		nTot4 += nMGI
		nTot5 += nMGR
		nTot6 += nVLq
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
	trbpr1->Qtdem2  := nTot1a
	trbpr1->QtdeP   := nTot1/nTotQtde
	trbpr1->VlBrut  := nTot2
	trbpr1->VlBrutP := VLBrut/nTotValb
	trbpr1->Valliq  := nTot6
	trbpr1->ValliqP := Valliq/nTotValq
	trbpr1->CUSTOSTD  := nTot3
	trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
	trbpr1->MGSTD := nTot4
	trbpr1->MgReal  := nTot5
	//		if MGReal/nMGI*100 < 100000
	//			trbpr1->Perc    := MGReal/nTot4*100
	if MGReal/ntot3*100 < 100000 .and. MGReal/ntot3*100 > -10000
		trbpr1->PercReal    := MGReal/nTot3*100
	endif
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
			totaliza()
			copy to \gerencia\MGFTPRD
		Case n==2
			copy to \gerencia\MGFTCLI
		Case n==3 //.and. 1=2
			Select SA3
			Do while !eof()
				IF sa3->a3_regiao='999'
					skip
					loop
				endif
				Select trbpr1
				trbpr1->(DBClearIndex())
				cTmp03 := CriaTrab(nil,.f.)
				IndRegua("TRBPR1", cTmp03, "Vend", , , "Selecionando Registros...")
//				index on Vend to &cTmp03

				seek sa3->a3_cod
				//				Select SA3
				//				nReg := recno()
				//				cSuper := sa3->a3_super
				//				seek xFilial()+cSuper
				//				cSuper := sa3->a3_nreduz
				//				goto nReg
				Select trbpr1
				if eof()
					reclock("trbpr1",.t.)
					trbpr1->Vend := sa3->a3_cod
					trbpr1->NomeV:= sa3->a3_nreduz
					trbpr1->Nomec:= sa3->a3_super
					MsUnLock()
				else
					reclock("trbpr1",.f.)
					trbpr1->Nomec:= sa3->a3_super
					MsUnLock()
				endif
				Select SA3
				skip
			Enddo
			Select TrbPr1
			dbgotop()
			copy to \gerencia\MGFTVEN
		Case n==4
			totuf()
			copy to \gerencia\MGFTUF
		Case n==5
//			totuf1()
//			cTempUf := CriaTrab(nil,.f.)
//			IndRegua("TRBPR1", cTmpUf, "Uf+Vend", , , "Selecionando Registros...")
//			index on Uf+Vend to &cTempUf
//			copy to \gerencia\MGFTUFREP
	EndCase
	Use
	
Next N

Select Trb
Relat001()  //Gera Arquivo em Excel


Return


*****************************
Static Function Totaliza()
*****************************
dbGoTop()
nRecTot := reccount()
Do while recno()<= nRecTot
//	if empty(trbpr1->TPPROD)
		cQuebra := left(trbpr1->Produto,2)
//	else
//		cQuebra := left(trbpr1->Produto,6)
//	endif
	nTot1 := nTot1a := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTot7 := nTot8 := nTot9 := nTot10 := 0
//	Do while !eof() .and. iif(empty(trbpr1->TPPROD),left(trbpr1->Produto,2)==cQuebra,left(trbpr1->Produto,3)==cQuebra)
	Do while !eof() 
		nTot1a+= trbpr1->QtdeM2
		nTot2 += trbpr1->VlBrut
		nTot3 += trbpr1->CUSTOSTD
		nTot4 += trbpr1->MGSTD
		nTot5 += trbpr1->MgReal
		nTot6 += trbpr1->Valliq
		nTot7 += trbpr1->CUSTOATU
		nTot8 += trbpr1->MGAtu
		nTot9 += trbpr1->CUSTOSIM
		nTot10+= trbpr1->MgSimul
		skip
	Enddo
	nRec := recno()
	if  cQuebra#space(2)
		reclock("trbpr1",.t.)
		trbpr1->Produto := trim(cquebra)+"= Total"
		trbpr1->Qtde    := nTot1
		trbpr1->Qtdem2  := nTot1a
		trbpr1->QtdeP   := nTot1/nTotQtde
		trbpr1->VlBrut  := nTot2
		trbpr1->VlBrutP := VLBrut/nTotValb
		trbpr1->Valliq  := nTot6
		trbpr1->ValliqP := Valliq/nTotValq
		trbpr1->CUSTOSTD  := nTot3
		trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
		trbpr1->MGSTD := nTot4
		if MGStd/CustoStd*100 < 100000
			trbpr1->PercStd    := MGStd/CustoStd*100
		Endif
		trbpr1->MgReal  := nTot5
		//		if MGReal/nTot4*100 < 100000
		//			trbpr1->Perc    := MGReal/nTot4*100
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
//copy to \x
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
	//Seek cUf
	reclock("trbpr1",.f.)
	TRBPR1->qtdcli := nQtd
	MsUnLock()
	Select TRB
Enddo

cTempUf1 := CriaTrab(nil,.f.)
IndRegua("TRBPR1", cTempUf1 , "Uf", , , "Selecionando Registros...")

cUf := "AC*AL*AM*AP*BA*CE*DF*ES*GO*MA*MG*MS*MT*PA*PB*PE*PI*PR*RJ*RN*RO*RR*RS*SC*SE*SP*TO"
//      1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27
For x:=1 to len(cUf)
	Select TRBPR1
	Seek substr(cUf,x,2)
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
		nQtd := nQtd+1
	Enddo
	Select TRBPR1
	Seek cUf
	if !eof()
		reclock("trbpr1",.f.)
		TRBPR1->qtdcli := nQtd
		MsUnLock()
	endif
	Select TRB
Enddo
Select TRBPR1

Return

**************************
Static Function VerDevol()
**************************
dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial()+"MV_PCI")
nPCI  := Val(Alltrim(SX6->X6_CONTEUD))

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
	Select SD2
	dbSetOrder(3)
	seek xFilial()+trb2->(d1_nfori+d1_seriori+d1_fornece+d1_loja)
	Do while !eof() .and. trim(trb2->d1_nfori)==trim(sd2->d2_doc)
		if trim(trb2->d1_itemori)==trim(sd2->d2_item)
			Exit
		Endif
		Skip
	Enddo
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+sd2->d2_pedido
	Select SF4
	dbSetOrder(1)
	Seek xFilial()+trb2->d1_tes
	nTotZFR := nPC := nIR := nCSLL := 0
	nTotZFR := iif(sd2->d2_desczfr#0 .and. sc5->c5_fator#"S",sd2->(d2_desczfr+d2_cusff4+d2_cusff5),0)
	nTotNF  := trb2->(d1_total) //iif(trb2->d1_desczfr==0,trb1->d2_total,trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5)
	if sf4->f4_piscof#"4"
		nIR     := (nTotNf * 1.80)/100
		nCSLL   := (nTotNf * 1.08)/100
		if nTotZFR#0
			nIR     := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.80)/100
			nCSLL   := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.08)/100
			//			nVCpmf  := (((nTotFat+trb1->d2_valipi)+nTotZFR) * nCpmf)/100
		else
			nPC     := (nTotNf * nPCI)/100
		endif
	else
		if nTotZFR#0
			nIR     := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.80)/100
			nCSLL   := ((trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5) * 1.08)/100
			//			nVCpmf  := (((nTotFat+trb1->d2_valipi)+nTotZFR) * nCpmf)/100
		endif
	endif
	
	if sf4->f4_estoque=="S"
		Select SD2
		dbSetOrder(3)
		Seek xFilial()+trb2->(d1_nfori+d1_seriori+d1_fornece+d1_loja+d1_cod)
		Select TRB1
		RecLock("TRB1",.t.)
		trb1->d2_item	:= "DV"
		trb1->d2_cod 	:= trb2->d1_cod
		trb1->d2_um   	:= trb2->d1_um
		trb1->d2_quant	:= iif(sf4->f4_estoque=="S",trb2->d1_quant*(-1),0)
		trb1->d2_prcven	:= trb2->d1_vunit*(-1)
		trb1->d2_total	:= iif(sf4->f4_estoque=="S",trb2->(d1_total-d1_desczfr)*(-1),0)
		trb1->d2_valipi	:= iif(sf4->f4_ipi=="S",trb2->d1_valipi*(-1),0)
		trb1->d2_valicm	:= iif(sf4->f4_icm=="S",trb2->d1_valicm*(-1),0)
		trb1->d2_icmsret:= iif(sf4->f4_icm=="S",sd2->d2_icmsret*(-1),0)
		trb1->d2_valimp5:= nPc //trb2->(d1_valimp5+d1_valimp6)
		trb1->d2_valimp4:= nIR
		trb1->d2_valimp3:= nCSLL
		trb1->d2_tes	:= trb2->d1_tes
		trb1->d2_cf  	:= sd2->d2_cf //trb2->d1_cf
		trb1->d2_ipi	:= trb2->d1_ipi
		trb1->d2_picm	:= trb2->d1_picm
		trb1->d2_pedido	:= sd2->d2_pedido
		trb1->d2_cliente:= trb2->d1_fornece
		trb1->d2_loja	:= trb2->d1_loja
		trb1->d2_doc 	:= trb2->d1_nfori
		trb1->d2_emissao:= trb2->d1_dtdigit
		trb1->d2_serie	:= "DEV"
		trb1->d2_est 	:= sd2->d2_est
		trb1->d2_tipo	:= "X"
		trb1->d2_desczfr:= nTotZFR*(-1)
		trb1->d2_cusff4 := sd2->d2_cusff4*(-1)
		trb1->d2_cusff5 := sd2->d2_cusff5*(-1)
		MsUnLock()
	Endif
	Select TRB2
	Skip
Enddo
use
Return

**************************
Static Function GravaBal()
**************************

nValFol := 0

Cpyt2s("D:\p10tst\data\gerencia\FOL1"+substr(dtos(mv_par01),3,4)+".dbf","\gerencia\")
Cpyt2s("D:\p10tst\data\gerencia\FOL2"+substr(dtos(mv_par01),3,4)+".dbf","\gerencia\")

//Cpyt2s("E:\p10tst\data\gerencia\FOL1"+substr(dtos(mv_par01),3,4)+".dbf","\gerencia\")
//Cpyt2s("E:\p10tst\data\gerencia\FOL2"+substr(dtos(mv_par01),3,4)+".dbf","\gerencia\")

//COPY FILE &("E:\p10\data\gerencia\BAL01.dbf") TO &("E:\p10\data\gerencia\FOL01.dbf")
//COPY FILE &("E:\p10\data\gerencia\BAL02.dbf") TO &("E:\p10\data\gerencia\FOL02.dbf")
//run copy file E:\p10tst\data\gerencia\BAL01.dbf to E:\p10\data\gerencia\Fol01.dbf
//run copy file E:\p10tst\data\gerencia\BAL02.dbf to E:\p10\data\gerencia\Fol02.dbf
//cArq2 := "E:\p10tst\data\gerencia\BAL01.dbf"
cArq2 := "\gerencia\FOL1"+substr(dtos(mv_par01),3,4)+".dbf"
if file(cArq2)
	dbUseArea( .T.,,cArq2,"TRBFOL", Nil, .F. )
	do while !eof()
		if trim(tipo)='X-TOTAL' .and. substr(dtos(mv_par01),1,6)=PER
			nValFol += VALOR
			exit
		endif
		skip
	enddo
	use
Endif
cArq2 := "\gerencia\FOL2"+substr(dtos(mv_par01),3,4)+".dbf"
if file(cArq2)
	dbUseArea( .T.,,cArq2,"TRBFOL", Nil, .F. )
	do while !eof()
		if trim(tipo)='X-TOTAL' .and. substr(dtos(mv_par01),1,6)=PER
			nValFol += VALOR
			exit
		endif
		skip
	enddo
	use
endif

cArq := "\gerencia\BAL"+substr(dtos(mv_par01),3,4)
if !file(cArq)
	aCampos := {}
	AADD(aCampos,{ "DESCRIC" , "C",30,0})
	AADD(aCampos,{ "VALOR"   , "N",12,2})
	AADD(aCampos,{ "PERCVAL" , "N",08,2})
	AADD(aCampos,{ "VALATU"  , "N",12,2})
	AADD(aCampos,{ "PERCATU" , "N",08,2})
	AADD(aCampos,{ "VALSIM"  , "N",12,2})
	AADD(aCampos,{ "PERCSIM" , "N",08,2})
	cTempBal := CriaTrab(nil,.f.)
	dbCreate(cTempBal,aCampos)
	dbUseArea( .T.,,cTempBal,"TRBBAL", Nil, .F. )
	RecLock("TRBBAL",.t.)
	replace DESCRIC with "FATURAM.TOTAL C/IPI C/ST"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "(-)IPI SOBRE FATUR."
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "(-)ICMS ST SOBRE FATUR."
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "(=) FATURA.S/IPI e S/ST"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "(-) DEDUCOES"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " * ICMS SOBRE FAT"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " * PIS(0,65%)/COFINS(3%) SOBRE FAT"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " * CSLL(1,08%) e IR(1,80%)"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " * COMISSOES"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " * COMISSOES INTERNAS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " * FRETE S/VENDAS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC with " * DESCONTOS Z.FRANCA"
	RecLock("TRBBAL",.t.)
	replace DESCRIC with " * VERBAS ADICIONAIS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " (-) DESP.FINANCEIRAS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " = FATURAMENTO LIQUIDO"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - CUSTO LIQUIDO"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " = MARGEM REAL"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " = MARGEM CONT (% s/CMV)"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " = MARGEM IDEAL (%real/ideal)"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - DESPESAS FIXAS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - SALARIOS + ENCARGOS (comp)"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - DESP.GERENCIAIS "
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - DESP.ADMINISTRATIVAS "
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - DESP.FINANCEIRAS "
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - DESP.COMERCIAIS "
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " - DESP.PRODUCAO "
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with " = RESULTADO OPERACIONAL"
	
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "(-)OUTRAS SAIDAS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "IMOBILIZACOES"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "OUTROS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "JUROS PAGOS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "PARCEL IMPOSTOS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "AMOSTRAS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "DESC.CONCEDIDOS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "(+) RECEITAS FINANCEIRAS"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "________________"
	RecLock("TRBBAL",.t.)
	replace DESCRIC	with "RESULTADO FINAL"
	
	MsUnlock()
else
	dbUseArea( .T.,,cArq,"TRBBAL", Nil, .F. )
	cTempBal := CriaTrab(nil,.f.)
	copy to &cTempbal
	use
	dbUseArea( .T.,,cTempBal,"TRBBAL", Nil, .F. )
Endif
dbgotop()
nValFat := nBalFat - nBalIPI - nBalICMST
if nValFat = 0
	nValFat := 1
endif
RecLock("TRBBAL",.f.)
replace VALOR	with nBalFat
replace VALATU	with nBalFat
replace VALSIM	with nBalFat
replace PERCVAL	with nBalFat/nValFat*100
replace PERCATU	with nBalFat/nValFat*100
replace PERCSIM	with nBalFat/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalIPI
replace VALATU	with nBalIPI
replace VALSIM	with nBalIPI
replace PERCVAL	with nBalIpi/nValFat*100
replace PERCATU	with nBalIpi/nValFat*100
replace PERCSIM	with nBalIpi/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalICMST
replace VALATU	with nBalICMST
replace VALSIM	with nBalICMST
replace PERCVAL	with nBalICMST/nValFat*100
replace PERCATU	with nBalICMST/nValFat*100
replace PERCSIM	with nBalICMST/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalFat - nBalIPI - nBalICMST
replace VALATU	with nBalFat - nBalIPI - nBalICMST
replace VALSIM	with nBalFat - nBalIPI - nBalICMST
replace PERCVAL	with 100
replace PERCATU	with 100
replace PERCSIM	with 100
skip
RecLock("TRBBAL",.f.)  // Despesas
replace VALOR	with nBalICM + nBalPC + nBALIR + nBalCom + nBalCom1 + nBalFrete + nBalDESCZF + nBalVAdic
replace VALATU	with nBalICM + nBalPC + nBALIR + nBalCom + nBalCom1 + nBalFrete + nBalDESCZF + nBalVAdic
replace VALSIM	with nBalICM + nBalPC + nBALIR + nBalCom + nBalCom1 + nBalFrete + nBalDESCZF + nBalVAdic
replace PERCVAL	with (nBalICM + nBalPC + nBALIR + nBalCom + nBalCom1 + nBalFrete + nBalDESCZF + nBalVAdic)/nValFat*100
replace PERCATU	with (nBalICM + nBalPC + nBALIR + nBalCom + nBalCom1 + nBalFrete + nBalDESCZF + nBalVAdic)/nValFat*100
replace PERCSIM	with (nBalICM + nBalPC + nBALIR + nBalCom + nBalCom1 + nBalFrete + nBalDESCZF + nBalVAdic)/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalICM
replace VALATU	with nBalICM
replace VALSIM	with nBalICM
replace PERCVAL	with nBalIcm/nValFat*100
replace PERCATU	with nBalIcm/nValFat*100
replace PERCSIM	with nBalIcm/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalPC
replace VALATU	with nBalPC
replace VALSIM	with nBalPC
replace PERCVAL	with nBalPC/nValFat*100
replace PERCATU	with nBalPC/nValFat*100
replace PERCSIM	with nBalPC/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBALIR
replace VALATU	with nBALIR
replace VALSIM	with nBALIR
replace PERCVAL	with nBalIR/nValFat*100
replace PERCATU	with nBalIR/nValFat*100
replace PERCSIM	with nBalIR/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalCom
replace VALATU	with nBalCom
replace VALSIM	with nBalCom
replace PERCVAL	with nBalCom/nValFat*100
replace PERCATU	with nBalCom/nValFat*100
replace PERCSIM	with nBalCom/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalCom1
replace VALATU	with nBalCom1
replace VALSIM	with nBalCom1
replace PERCVAL	with nBalCom1/nValFat*100
replace PERCATU	with nBalCom1/nValFat*100
replace PERCSIM	with nBalCom1/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalFrete
replace VALATU	with nBalFrete
replace VALSIM	with nBalFrete
replace PERCVAL	with nBalFrete/nValFat*100
replace PERCATU	with nBalFrete/nValFat*100
replace PERCSIM	with nBalFrete/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalDESCZF
replace VALATU	with nBalDESCZF
replace VALSIM	with nBalDESCZF
replace PERCVAL	with nBalDESCZF/nValFat*100
replace PERCATU	with nBalDESCZF/nValFat*100
replace PERCSIM	with nBalDESCZF/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalVAdic
replace VALATU  with nBalVAdic
replace VALSIM  with nBalVAdic
replace PERCVAL	with nBalVAdic/nValFat*100
replace PERCATU	with nBalVAdic/nValFat*100
replace PERCSIM	with nBalVAdic/nValFat*100
skip
RecLock("TRBBAL",.f.)
replace VALOR	with nBalDespF
replace VALATU with nBalDespF
replace VALSIM with nBalDespF
replace PERCVAL	with nBalDespF/nValFat*100
replace PERCATU	with nBalDespF/nValFat*100
replace PERCSIM	with nBalDespF/nValFat*100
skip
RecLock("TRBBAL",.f.)
nFatLiq := nBalFat - nBalIPI - nBalICMST - nBalICM - nBalPC - nBalIR - nBalCom - nBalCom1 - nBalFrete - nBalDescZF - nBalVAdic - nBalDespF
replace VALOR	with nFatLiq
replace VALATU with nFatLiq
replace VALSIM with nFatLiq
replace PERCVAL	with nFatLiq/nValFat*100
replace PERCATU	with nFatLiq/nValFat*100
replace PERCSIM	with nFatLiq/nValFat*100
skip
RecLock("TRBBAL",.f.) // Custo
replace VALOR  with nTotStd
replace VALATU with nTotCAtu
replace VALSIM with nTotCSim
replace PERCVAL	with nTotStd/nValFat*100
replace PERCATU	with nTotCAtu/nValFat*100
replace PERCSIM	with nTotCSim/nValFat*100
skip
RecLock("TRBBAL",.f.)
nMgReal1 := nMgReal2 := nMgReal3 := 0
replace VALOR	with (nFatLiq - nTotStd)/1.05 //" = MARGEM REAL"
replace VALATU	with (nFatLiq - nTotCAtu)/1.05 //" = MARGEM REAL"
replace VALSIM	with (nFatLiq - nTotCSim)/1.05 //" = MARGEM REAL"
replace PERCVAL	with ((nFatLiq - nTotStd)/nValFat)/1.05*100
replace PERCATU	with ((nFatLiq - nTotCAtu)/nValFat)/1.05*100
replace PERCSIM	with ((nFatLiq - nTotCSim)/nValFat)/1.05*100
nMGReal1 := Valor
nMGReal2 := ValAtu
nMGReal3 := ValSim
skip
RecLock("TRBBAL",.f.)
replace VALOR	with (nFatLiq-nTotStd)/1.05 //" = MARGEM CONT (% s/CMV)"
replace VALATU	with (nFatLiq-nTotCAtu)/1.05 //" = MARGEM CONT (% s/CMV)"
replace VALSIM	with (nFatLiq-nTotCSim)/1.05 //" = MARGEM CONT (% s/CMV)"
replace PERCVAL	with ((nFatLiq - nTotStd)/nTotStd)/1.05*100
replace PERCATU	with ((nFatLiq - nTotCAtu)/nTotCatu)/1.05*100
replace PERCSIM	with ((nFatLiq - nTotCSim)/nTotCSim)/1.05*100
skip
RecLock("TRBBAL",.f.)
nVal1 := nFatLiq-nTotStd
nVal2 := nFatLiq-nTotCAtu
nVal3 := nFatLiq-nTotCSim
replace VALOR	with nTotIdeal //" = MARGEM IDEAL (%real/ideal)"
replace VALATU	with nTotIdeal //" = MARGEM IDEAL (%real/ideal)"
replace VALSIM	with nTotIdeal //" = MARGEM IDEAL (%real/ideal)"
replace PERCVAL	with (((nFatLiq-nTotStd)/1.05)/nTotIdeal)*100
replace PERCATU	with (((nFatLiq-nTotCatu)/1.05)/nTotIdeal)*100
replace PERCSIM	with (((nFatLiq-nTotCSim)/1.05)/nTotIdeal)*100
skip
Do while !eof() .and. trim(DESCRIC)<>"AMOSTRAS"
	skip
enddo
if trim(descric)="AMOSTRAS" .and. nCustAmost<>0
	RecLock("TRBBAL",.f.)
	replace VALOR	with nCustAmost //" = AMOSTRA"
	replace VALATU	with nCustAmost //" = AMOSTRA"
	replace VALSIM	with nCustAmost//" = AMOSTRA"
	replace PERCVAL	with nCustAmost/nValFat*100
	replace PERCATU	with nCustAmost/nValFat*100
	replace PERCSIM	with nCustAmost/nValFat*100
endif
MsUnlock()

cArq1 := "\gerencia\FIN"+substr(dtos(mv_par01),3,4)+"F.dbf"
if file(cArq1)
	nDespAm := nCustAmost
	dbUseArea( .T.,,cArq1,"TRBFIN", Nil, .F. )
	dbgotop()
	Do while !eof()
		do case
			case trim(DESCRIC) = " - DESP.GERENCIAIS"
				nDespG := VALOR
			case trim(DESCRIC) = " - DESP.ADMINISTRATIVAS"
				nDespA := VALOR
			case trim(DESCRIC) = " - DESP.FINANCEIRAS"
				nDespF := VALOR
			case trim(DESCRIC) = " - DESP.COMERCIAIS"
				nDespC := VALOR
			case trim(DESCRIC) = " - DESP.PRODUCAO"
				nDespP := VALOR
			case trim(DESCRIC) = " = RESULTADO OPERACIONAL"
				nRes1 := nMgReal1 - nDespA - nDespC - nDespF - nDespG - nDespP
				nRes2 := nMgReal2 - nDespA - nDespC - nDespF - nDespG - nDespP
				nRes3 := nMgReal3 - nDespA - nDespC - nDespF - nDespG - nDespP
			case trim(DESCRIC) = "(-)OUTRAS SAIDAS"
				nOutras := VALOR
			case trim(DESCRIC) = "IMOBILIZACOES"
				nDespIm := VALOR
			case trim(DESCRIC) = "OUTROS"
				nDespOu := VALOR
			case trim(DESCRIC) = "JUROS PAGOS"
				nDespJR := VALOR
			case trim(DESCRIC) = "PARCEL IMPOSTOS"
				nDespIp := VALOR
			case trim(DESCRIC) = "DESC.CONCEDIDOS"
				nDescto	:= VALOR
			case trim(DESCRIC) = "(+) RECEITAS FINANCEIRAS"
				nRecFin	:= VALOR
			case trim(DESCRIC) = "RESULTADO FINAL"
				nResF1 := nRes1 - nOutras
				nResF2 := nRes2 - nOutras
				nResF3 := nRes3 - nOutras
				
		EndCase
		skip
	Enddo
	use
	Select TRBBAL
	dbgotop()
	Do while !eof()
		
		do case
			case "SALARIOS"$trim(DESCRIC)// = " - SALARIOS + ENCARGOS (comp)"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nValFol
				replace VALATU	with nValFol
				replace VALSIM	with nValFol
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
				MsUnLock()
			case trim(DESCRIC) = " - DESP.GERENCIAIS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespG
				replace VALATU	with nDespG
				replace VALSIM	with nDespG
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.ADMINISTRATIVAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespA
				replace VALATU	with nDespA
				replace VALSIM	with nDespA
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.FINANCEIRAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespF
				replace VALATU	with nDespF
				replace VALSIM	with nDespF
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.COMERCIAIS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespC
				replace VALATU	with nDespC
				replace VALSIM	with nDespC
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.PRODUCAO"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespP
				replace VALATU	with nDespP
				replace VALSIM	with nDespP
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " = RESULTADO OPERACIONAL"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nMgReal1 - nDespA - nDespC - nDespF - nDespG - nDespP
				replace VALATU	with nMgReal2 - nDespA - nDespC - nDespF - nDespG - nDespP
				replace VALSIM	with nMgReal3 - nDespA - nDespC - nDespF - nDespG - nDespP
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
				nResult1 := VALOR
				nResult2 := VALATU
				nResult3 := VALSIM
			case trim(DESCRIC) = "(-)OUTRAS SAIDAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespIm + nDespOu + nDespJr + nDespIp + nDespAm + nDescto + nValFol
				replace VALATU	with nDespIm + nDespOu + nDespJr + nDespIp + nDespAm + nDescto + nValFol
				replace VALSIM	with nDespIm + nDespOu + nDespJr + nDespIp + nDespAm + nDescto + nValFol
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
				nOutras := VALOR
			case trim(DESCRIC) = "IMOBILIZACOES"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespIm
				replace VALATU	with nDespIm
				replace VALSIM	with nDespIm
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "OUTROS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespOu
				replace VALATU	with nDespOu
				replace VALSIM	with nDespOu
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "JUROS PAGOS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespJr
				replace VALATU	with nDespJr
				replace VALSIM	with nDespJr
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "PARCEL IMPOSTOS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespIp
				replace VALATU	with nDespIp
				replace VALSIM	with nDespIp
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "DESC.CONCEDIDOS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDescto
				replace VALATU	with nDescto
				replace VALSIM	with nDescto
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "(+) RECEITAS FINANCEIRAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nRecFin
				replace VALATU	with nRecFin
				replace VALSIM	with nRecFin
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "RESULTADO FINAL"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nResult1 - nOutras
				replace VALATU	with nResult2 - nOutras
				replace VALSIM	with nResult3 - nOutras
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
		EndCase
		MsUnLock()
		RecLock("TRBBAL",.f.)
		skip
	Enddo
	
endif
copy to &cArq
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
Do while !eof()
	IncProc()
	cGrupo := sa1->a1_cod
	n5  := 0 // Outros
	n4  := 0 // Compra > 180 dias
	n3  := 0 // Compra entre 180 e 150 dias
	n2  := 0 // Compra entre 150 e 030 dias
	n1  := 0 // Compra entre 0 e 30 dias
	Do while !eof() .and. cGrupo == sa1->a1_cod
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

*************************
Static Function u_VerAtiv()  // Verifica se o cliente esta Ativo/inativo
*************************  // Reativado/Desativado (per.180 dias)

Select SA1
DbOrderNickName("GRPCLI")
//dbSetOrder(GRPCLI)  // Verifica o grupo todo
ProcRegua(Reccount())
dbGoTop()
dData1 := lastday(mv_par02)
dData2 := firstday(mv_par02)
dData3 := lastday(mv_par02-210)
dData4 := firstday(mv_par02-210)
aVend := {}
aEst  := {}
aChave := {}
Do while !eof()
	IncProc()
	lGrupo := .t.
	if !empty(A1_XGRPCLI)
		cGrupo := A1_XGRPCLI
	else
		lGrupo := .f.
		cGrupo := sa1->(a1_cod+a1_loja)
	endif
	n5  := 0 // Outros
	n4  := 0 // Compra > 180 dias
	n3  := 0 // Compra entre 180 e 150 dias
	n2  := 0 // Compra entre 150 e 030 dias
	n1  := 0 // Compra entre 0 e 30 dias
	Do while !eof() .and. cGrupo == iif(lGrupo,sa1->a1_xgrpcli,sa1->(a1_cod+a1_loja))
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
	if !lGrupo
		nReg := recno()
		dbSetOrder(1)
		seek xFilial()+cGrupo
		DbOrderNickName("GRPCLI")
		//		dbSetOrder("GRPCLI")
	else
		Seek xFilial()+cGrupo
	endif
	Do while !eof() .and. cGrupo == iif(lGrupo,sa1->a1_xgrpcli,sa1->(a1_cod+a1_loja))
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

************************
Static Function UfXVen1()
************************

Select TRB
dbgotop()
nTot1 := nTot1a := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTotM := nTot7 := nTot8 := nTot9 := nTot10 := 0
Do While !eof()
	cChave := CODCLI
	cCli   := CLI
	cNReduz:= NREDUZ
	cVend  := VEND
	cEst   := EST
	cCoor  := COOR
	nMGR   := nMGI := nVLB := nVLq := nStd := nQtd   := nCUSTOATU := nMGAtu := nCUSTOSIM := nMgSimul  := 0
	Do while !eof() .and. trb->(Est+Vend+Coor)==cEst+cVend+cCoor
		IncProc()
		nMGR := nMGR + trb->MGReal
		nMGI := nMGI + trb->MGSTD
		nVLB := nVLB + trb->Valbrut
		nVLq := nVLq + trb->Valliq
		nSTD := nSTD + trb->CUSTOSTD
		nQtd := nQtd + trb->Qtde
		nQtdm2 := nQtdm2 + trb->Qtdem2
		nCUSTOATU	:= nCUSTOATU + trb->CUSTOATU
		nMGAtu := nMGAtu + trb->MGAtu
		nCUSTOSIM := nCUSTOSIM +trb->CUSTOSIM
		nMgSimul := nMgSimul + trb->MgSimul
		skip
	Enddo
	
	Select TRBpr1
	RecLock("TRBPR1",.t.)
	trbpr1->Uf     := cEst
	trbpr1->Vend   := cVend
	trbpr1->NomeV  := cNomV
	trbpr1->Nomec  := cCoor
	trbpr1->Qtde    += nQtd
	trbpr1->QtdeM2  += nQtdm2
	trbpr1->QtdeP   := Qtde/nTotQtde
	trbpr1->VlBrut  += nVLB
	trbpr1->VlBrutP := VLBrut/nTotValb
	trbpr1->Valliq  += nVLq
	trbpr1->ValliqP := Valliq/nTotValq
	trbpr1->CUSTOSTD  += nSTD
	trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
	trbpr1->MGSTD += nMGI
	if MGStd/nStd*100 < 100000
		trbpr1->PercStd    := MGStd/nStd*100
	endif
	trbpr1->MgReal  += nMGR
	if MGReal/nStd*100 < 100000  .AND. MGReal/nStd*100>-10000
		trbpr1->PercReal    := MGReal/nStd*100
	endif
	trbpr1->CUSTOATU += nCUSTOATU
	trbpr1->MGAtu  += nMGAtu
	trbpr1->CUSTOSIM += nCUSTOSIM
	trbpr1->MgSimul+= nMgSimul
	if MgSimul<>0
		trbpr1->PercSim := (mgsimul/CUSTOSIM)*100
	endif
	if MgAtu<>0
		trbpr1->PercAtu := (mgatu/CUSTOATU)*100
	endif
	MsUnLock()
	nTot1 += nQtd
	nTot1a+= nQtdm2
	nTot2 += nVLB
	nTot3 += nStd
	nTot4 += nMGI
	nTot5 += nMGR
	nTot6 += nVLq
	nTot7 += nCUSTOATU
	nTot8 += nMGAtu
	nTot9 += nCUSTOSIM
	nTot10+= nMgSimul
	Select TRB
Enddo
Select TRBPR1
dbGoTop()
reclock("trbpr1",.t.)
trbpr1->Qtde    := nTot1
trbpr1->Qtdem2  := nTot1a
trbpr1->QtdeP   := nTot1/nTotQtde
trbpr1->VlBrut  := nTot2
trbpr1->VlBrutP := VLBrut/nTotValb
trbpr1->Valliq  := nTot6
trbpr1->ValliqP := Valliq/nTotValq
trbpr1->CUSTOSTD  := nTot3
trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
trbpr1->MGSTD := nTot4
trbpr1->MgReal  := nTot5
if MGReal/ntot3*100 < 100000 .and. MGReal/ntot3*100 > -10000
	trbpr1->PercReal    := MGReal/nTot3*100
endif
trbpr1->CUSTOATU += nTot7
trbpr1->MGAtu  += nTot8
trbpr1->CUSTOSIM += nTot9
trbpr1->MgSimul+= nTot10
if MGStd/CUSTOSTD*100 < 100000 .and. MGStd/CUSTOSTD*100 > -10000
	trbpr1->PercStd    := MgStd/CUSTOSTD*100
endif
if MGAtu/nTot7*100 < 100000 .and. MGAtu/nTot7*100 > -10000
	trbpr1->PercAtu    := MGAtu/nTot7*100
endif
if MGSimul/ntot9*100 < 100000 .and. MGSimul/ntot9*100 > -10000
	trbpr1->PercSim    := MGSimul/ntot9*100
endif
MsUnLock()

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
	Seek cUf+cVend
	if !eof()
		reclock("trbpr1",.f.)
		TRBPR1->qtdcli := nQtd
		MsUnLock()
	endif
	Select TRB
Enddo

Select TrbPr1
//copy to \x
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
	cSuper := A3_Super
	nReg := recno()
	seek xFilial()+cSuper
	cNSuper := sa3->a3_nreduz
	goto nReg
	Select TrbPr1
	seek sa1->(A1_EST+A1_VEND)  //index on EST+Vend to &cTemp
	RecLock("TRBPR1",eof())
	trbpr1->Uf			:= sa1->a1_est
	trbpr1->Vend		:= sa1->a1_vend
	trbpr1->NomeV		:= sa3->a3_nreduz
	trbpr1->NomeC		:= cNSuper
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

Select TRBPR1
copy to \gerencia\MGFTUFREP

Return

//		cArq := "\gerencia\mgft-le.dtc"
//			copy to \gerencia\MGFTPRD ;; sec 3
//			copy to \gerencia\MGFTCLI ;; sec 2
//			copy to \gerencia\MGFTVEN ;; sec 4
//			copy to \gerencia\MGFTUF  ;; sec 5
// copy to \gerencia\MGFTUFREP        ;; sec 6

Static Function RELAT001()

Local oReport := nil
oReport := RptDef(cPerg)
if upper(substr(cUsuario,7,5))=="ADMIN" .or. upper(substr(cUsuario,7,6))=="IRINEU"
	if MsgBox ("Deseja abrir planilha Excel ?","Escolha","YESNO")
		oReport:PrintDialog() 
	endif
	MsgBox ("Arquivo gerado com sucesso wsus(f:\totvs\protheus_data\spool","Informa‡Æo","INFO")
endif


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

oReport := TReport():New(cNome,"Faturamento com Margem",cNome,{|oReport| ReportPrint(oReport)},"FaturamentoXmargem")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Margem FT", {"TRB"}, , .F., .T.)

TRCell():New(oSection1,"NUM"		,"TRB","Doc."  ,"@!",10)
TRCell():New(oSection1,"ITEM"		,"TRB","Item"  ,"@!",04)
TRCell():New(oSection1,"CODCLI"		,"TRB","Cod.Cli."  ,"@!",06)
TRCell():New(oSection1,"LOJA"		,"TRB","Loja"  ,"@!",02)
TRCell():New(oSection1,"CLI"		,"TRB","Nome Cli"  ,"@!",40)
TRCell():New(oSection1,"NREDUZ"		,"TRB","Nome Fantasia"  ,"@!",20)
TRCell():New(oSection1,"GRPCLI"		,"TRB","Grupo Cli"  ,"@!",08)
TRCell():New(oSection1,"RANK"		,"TRB","Ranking"  ,"9999",04)
TRCell():New(oSection1,"VEND"		,"TRB","Vendedor"  ,"@!",06)
TRCell():New(oSection1,"COOR"		,"TRB","Coord."  ,"@!",06)
TRCell():New(oSection1,"COD"		,"TRB","Cód.prod."  ,"@!",15)
TRCell():New(oSection1,"DESC"		,"TRB","Descrição"  ,"@!",50)
TRCell():New(oSection1,"QTDE"		,"TRB", "Quantidade","@E 999,999,999.99",15)
TRCell():New(oSection1,"QTDEM2"		,"TRB", "Seg.Um","@E 9,999,999,999.9999",15)
TRCell():New(oSection1,"EMISSAO"	,"TRB", "Dt.Emissao","@!",10)
TRCell():New(oSection1,"VALBRUT"	,"TRB", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALLIQ"		,"TRB", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection1,"CUSTOSTD"	,"TRB", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection1,"MGSTD"		,"TRB", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCSTD"	,"TRB", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection1,"MGREAL"		,"TRB", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCREAL"	,"TRB", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection1,"CUSTOATU"	,"TRB", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection1,"MGATU"		,"TRB", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCATU"	,"TRB", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection1,"CUSTOSIM"	,"TRB", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection1,"MGSIMUL"	,"TRB", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCSIM"	,"TRB", "Perc.Simulado","@E 9,999.99",15)
TRCell():New(oSection1,"ACRESC"		,"TRB", "Acréscimo","@E 999,999,999.99",15)
TRCell():New(oSection1,"VERBADIC"	,"TRB", "Verba Adicional","@E 999,999,999.99",15)
TRCell():New(oSection1,"PEDIDO"		,"TRB", "Pedido"  ,"@!",06)
TRCell():New(oSection1,"ITEMPV"		,"TRB", "Item PV"  ,"@!",02)
TRCell():New(oSection1,"VALMERC"	,"TRB", "Valor Mercadoria","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALIPI" 	,"TRB", "Valor IPI","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALADIC"	,"TRB", "Valor Adicional","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALCPMF" 	,"TRB", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALICMS"	,"TRB", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALICMST" 	,"TRB", "Valor ICMS ST","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALPC"		,"TRB", "Valor Pis/Cofins","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALIR"	 	,"TRB", "Valor IR","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALCSLL"		,"TRB", "Valor CSLL","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALCOM"	 		,"TRB", "Valor Comissão","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALCOM2"		,"TRB", "Valor Comissão Coord.","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALFIN"	 		,"TRB", "Valor Financeiro","@E 999,999,999.99",15)
TRCell():New(oSection1,"VALFRET"		,"TRB", "Valor Frete","@E 999,999,999.99",15)
TRCell():New(oSection1,"DESCZFR"	 	,"TRB", "Descto. Zona Franca","@E 999,999,999.99",15)
TRCell():New(oSection1,"PERCCOM"	 	,"TRB", "Perc.Comiss","@E 999,999,999.99",15)
TRCell():New(oSection1,"TP"    	 		,"TRB", "Tipo","@!",02)
TRCell():New(oSection1,"FRETE"   	 	,"TRB", "Frete","@!",08)
TRCell():New(oSection1,"PERFRET" 	 	,"TRB", "Perc.Frete","@E 999.99",06)
TRCell():New(oSection1,"DIFAL"  	 	,"TRB", "DIFAL","@E 999,999,999.99",15)
TRCell():New(oSection1,"EST"    	 	,"TRB", "UF","@!",02)
TRCell():New(oSection1,"ESTGRP"  	 	,"TRB", "Grupo Est.","@!",02)
TRCell():New(oSection1,"TES"    	 	,"TRB", "TES","@!",04)
TRCell():New(oSection1,"CFOP"    	 	,"TRB", "CFOP","@!",05)
TRCell():New(oSection1,"CONDPAG" 	 	,"TRB", "Condic.Pagto.","@!",10)
TRCell():New(oSection1,"TPVEND"   	 	,"TRB", "Frete","@!",08)
TRCell():New(oSection1,"QTDE2" 	 		,"TRB", "Qtde 2a Um","@e 999,999.99",09)
TRCell():New(oSection1,"ALIQICM" 	 	,"TRB", "Aliq.ICMS","@e 999.99",06)
TRCell():New(oSection1,"ALIQIPI" 	 	,"TRB", "Aliq.IPI","@e 999.99",06)
TRCell():New(oSection1,"NCM"   	 		,"TRB", "NCM","@!",08)
TRCell():New(oSection1,"CNPJ"   	 	,"TRB", "CNPJ","@!",08)
TRCell():New(oSection1,"INSCR"   	 	,"TRB", "Inscrição Est.","@!",08)
TRCell():New(oSection1,"TPCLI"   	 	,"TRB", "Tipo Cli.","@!",08)
TRCell():New(oSection1,"EMISS"   	 	,"TRB", "Emissão","@!",08)
TRCell():New(oSection1,"PRODUTO"   	 	,"TRB", "Produto","@!",08)
TRCell():New(oSection1,"STDPROD" 	 	,"TRB", "Std.Produto","@e 999,999.99",12)
TRCell():New(oSection1,"DESONER" 	 	,"TRB", "Desoneração","@e 999,999.99",12)
TRCell():New(oSection1,"MUNI"   	 	,"TRB", "Município","@!",30)
TRCell():New(oSection1,"TRANSP"   	 	,"TRB", "Transportadora","@!",30)
TRCell():New(oSection1,"SEGMENTO"   		,"TRB", "Segmento","@!",10)
TRCell():New(oSection1,"REGIAO"   		,"TRB", "Região","@!",10)
TRCell():New(oSection1,"SITCLI"   		,"TRB", "Situação Cli.","@!",10)
TRCell():New(oSection1,"VENDCAD"   		,"TRB", "Vendedor Cadastro","@!",10)
TRCell():New(oSection1,"DATASAI"   		,"TRB", "Data Saída","@!",10)


// Section 2
IF SELECT("TRBPRD") # 0
	TRBPRD->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\gerencia\MGFTPRD.dtc","TRBPRD", Nil, .F. )
oSection2:= TRSection():New(oReport, "Fat. X Produto ", {"TRBPRD"}, , .F., .T.)  
//			copy to \gerencia\MGFTVEN ;; sec 4
//			copy to \gerencia\MGFTUF  ;; sec 5
// copy to \gerencia\MGFTUFREP        ;; sec 6

TRCell():New(oSection2,"PRODUTO"	,"TRBPRD","Cód.prod."  ,"@!",15)
TRCell():New(oSection2,"DESC"		,"TRBPRD","Descrição"  ,"@!",50)
TRCell():New(oSection2,"TPPROD"		,"TRBPRD","Tipo Prod"  ,"@!",02)
TRCell():New(oSection2,"QTDE"		,"TRBPRD", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection2,"QTDEM2"		,"TRBPRD", "Qtde.M2","@E 999,999,999.9999",15)
TRCell():New(oSection2,"QTDEP"		,"TRBPRD", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection2,"VLBRUT"		,"TRBPRD", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection2,"VLBRUTP"	,"TRBPRD", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection2,"VALLIQ"		,"TRBPRD", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection2,"VALLIQP"	,"TRBPRD", "Valor.Liq.P","@E 999,999,999.99",15)
TRCell():New(oSection2,"CUSTOSTD"	,"TRBPRD", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection2,"CUSTOSTDP"	,"TRBPRD", "Custo Std.P","@E 999,999,999.99",15)
TRCell():New(oSection2,"MGSTD"		,"TRBPRD", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCSTD"	,"TRBPRD", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection2,"MGREAL"		,"TRBPRD", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCREAL"	,"TRBPRD", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection2,"CUSTOATU"	,"TRBPRD", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection2,"MGATU"		,"TRBPRD", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCATU"	,"TRBPRD", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection2,"CUSTOSIM"	,"TRBPRD", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection2,"MGSIMUL"	,"TRBPRD", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection2,"PERCSIM"	,"TRBPRD", "Perc.Simulado","@E 9,999.99",15)

Use

// Section 3
dbUseArea( .T.,,"\GERENCIA\MGFTCLI","TRBCLI", Nil, .F. )
oSection3:= TRSection():New(oReport, "Faturado x Cliente ", {"TRBCLI"}, , .F., .T.)  
                     
TRCell():New(oSection3,"GRPCLI"		,"TRBCLI", "Grupo Cli"  ,"@!",08)
TRCell():New(oSection3,"CLI"		,"TRBCLI", "Cod.Cli."  ,"@!",08)
TRCell():New(oSection3,"NOME"		,"TRBCLI", "Nome Cli"  ,"@!",40)
TRCell():New(oSection3,"NREDUZ"		,"TRBCLI", "Nome Fantasia"  ,"@!",20)
TRCell():New(oSection3,"UF"			,"TRBCLI", "UF"  ,"@!",02)
TRCell():New(oSection3,"VEND"		,"TRBCLI", "Vendedor"  ,"@!",06)
TRCell():New(oSection3,"RANK"		,"TRBCLI", "Ranking"  ,"9999",04)
TRCell():New(oSection3,"NOMEV"		,"TRBCLI", "Nome Vendedor"  ,"@!",20)
TRCell():New(oSection3,"NOMEC"		,"TRBCLI", "Nome Coord."  ,"@!",20)
TRCell():New(oSection3,"SEGMENTO"	,"TRBCLI", "Segmento"  ,"@!",10)
TRCell():New(oSection3,"REGIAO"		,"TRBCLI", "Região"  ,"@!",10)
TRCell():New(oSection3,"SITCLI"		,"TRBCLI", "Situação Cli"  ,"@!",1)
TRCell():New(oSection3,"VENDCAD"	,"TRBCLI", "Vendedor Cad."  ,"@!",06)
TRCell():New(oSection3,"QTDE"		,"TRBCLI", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection3,"QTDEM2"		,"TRBCLI", "Qtde.M2","@E 9,999,999.9999",15)
TRCell():New(oSection3,"QTDEP"		,"TRBCLI", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection3,"VLBRUT"		,"TRBCLI", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection3,"VLBRUTP"	,"TRBCLI", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection3,"VALLIQ"		,"TRBCLI", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection3,"VALLIQP"	,"TRBCLI", "Valor.Liq.P","@E 999,999,999.99",15)
TRCell():New(oSection3,"CUSTOSTD"	,"TRBCLI", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection3,"CUSTOSTDP"	,"TRBCLI", "Custo Std.P","@E 999,999,999.99",15)
TRCell():New(oSection3,"MGSTD"		,"TRBCLI", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCSTD"	,"TRBCLI", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection3,"MGREAL"		,"TRBCLI", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCREAL"	,"TRBCLI", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection3,"CUSTOATU"	,"TRBCLI", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection3,"MGATU"		,"TRBCLI", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCATU"	,"TRBCLI", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection3,"CUSTOSIM"	,"TRBCLI", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection3,"MGSIMUL"		,"TRBCLI", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection3,"PERCSIM"	,"TRBCLI", "Perc.Simulado","@E 9,999.99",15)

Use

// Section 4 - // Por Vendedor
dbUseArea( .T.,,"\GERENCIA\MGFTVEN","TRBVEN", Nil, .F. )
oSection4:= TRSection():New(oReport, "Fat. x Vendedor ", {"TRBVEN"}, , .F., .T.)  

TRCell():New(oSection4,"VEND"		,"TRBVEN", "Vendedor"  ,"@!",06)
TRCell():New(oSection4,"NOMEV"		,"TRBVEN", "Nome Vendedor"  ,"@!",20)
TRCell():New(oSection4,"NOMEC"		,"TRBVEN", "Nome Coord."  ,"@!",20)
TRCell():New(oSection4,"UF"			,"TRBVEN", "UF"  ,"@!",02)
TRCell():New(oSection4,"QTDE"		,"TRBVEN", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection4,"QTDEP"		,"TRBVEN", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection4,"VLBRUT"		,"TRBVEN", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection4,"VLBRUTP"	,"TRBVEN", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection4,"VALLIQ"		,"TRBVEN", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection4,"VALLIQP"	,"TRBVEN", "Valor.Liq.P","@E 999,999,999.99",15)
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
dbUseArea( .T.,,"\GERENCIA\MGFTUFREP","TRBUF", Nil, .F. )
oSection5:= TRSection():New(oReport, "Fat. x UF x Rep.", {"TRBUF"}, , .F., .T.)  
// copy to \gerencia\MGFTUFREP        ;; sec 6

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
TRCell():New(oSection5,"VALLIQ"		,"TRBVEN", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection5,"VALLIQP"	,"TRBVEN", "Valor.Liq.P","@E 999,999,999.99",15)
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
TRCell():New(oSection5,"MGSIMUL"	,"TRBVEN", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection5,"PERCSIM"	,"TRBVEN", "Perc.Simulado","@E 9,999.99",15)

Use

// Section 6 - // Por UF
dbUseArea( .T.,,"\GERENCIA\MGFTUF","TRBUF", Nil, .F. )
oSection6:= TRSection():New(oReport, "Fat. x UF", {"TRBUF"}, , .F., .T.)  
// copy to \gerencia\MGFTUFREP        ;; sec 6

TRCell():New(oSection6,"UF"			,"TRBVEN", "UF"  ,"@!",02)
TRCell():New(oSection6,"QTDCLI"		,"TRBVEN", "Qtde.Clientes","@E 999,999,999.99",15)
TRCell():New(oSection6,"QTDE"		,"TRBVEN", "Qtde.","@E 999,999,999.99",15)
TRCell():New(oSection6,"QTDEM2"		,"TRBVEN", "Qtde M2","@E 999,999,999.9999",15)
TRCell():New(oSection6,"QTDEP"		,"TRBVEN", "Qtde P.","@E 999,999,999.99",15)
TRCell():New(oSection6,"VLBRUT"		,"TRBVEN", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection6,"VLBRUTP"	,"TRBVEN", "Valor Bruto P","@E 999,999,999.99",15)
TRCell():New(oSection6,"VALLIQ"		,"TRBVEN", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection6,"VALLIQP"	,"TRBVEN", "Valor.Liq.P","@E 999,999,999.99",15)
TRCell():New(oSection6,"CUSTOSTD"	,"TRBVEN", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection6,"CUSTOSTDP"	,"TRBVEN", "Custo Std.P","@E 999,999,999.99",15)
TRCell():New(oSection6,"MGSTD"		,"TRBVEN", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection6,"PERCSTD"	,"TRBVEN", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection6,"MGREAL"		,"TRBVEN", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection6,"PERCREAL"	,"TRBVEN", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection6,"CUSTOATU"	,"TRBVEN", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection6,"MGATU"		,"TRBVEN", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection6,"PERCATU"	,"TRBVEN", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection6,"CUSTOSIM"	,"TRBVEN", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection6,"MGSIMUL"	,"TRBVEN", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection6,"PERCSIM"	,"TRBVEN", "Perc.Simulado","@E 9,999.99",15)


Use

// Section 7 - // Resumo Geral
dbSelectArea("TRB")
TRB->(dbGoTop())
oSection7:= TRSection():New(oReport, "Resumo por NF", {"TRB"}, , .F., .T.)  
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

TRCell():New(oSection7,"NUM"		,"TRB","Doc."  ,"@!",10)
TRCell():New(oSection7,"ITEM"		,"TRB","Item"  ,"@!",04)
TRCell():New(oSection7,"CODCLI"		,"TRB","Cod.Cli."  ,"@!",06)
TRCell():New(oSection7,"LOJA"		,"TRB","Loja"  ,"@!",02)
TRCell():New(oSection7,"CLI"		,"TRB","Nome Cli"  ,"@!",40)
TRCell():New(oSection7,"NREDUZ"		,"TRB","Nome Fantasia"  ,"@!",20)
TRCell():New(oSection7,"GRPCLI"		,"TRB","Grupo Cli"  ,"@!",08)
TRCell():New(oSection7,"RANK"		,"TRB","Ranking"  ,"9999",04)
TRCell():New(oSection7,"VEND"		,"TRB","Vendedor"  ,"@!",06)
TRCell():New(oSection7,"COOR"		,"TRB","Coord."  ,"@!",06)
//TRCell():New(oSection7,"COD"		,"TRB","Cód.prod."  ,"@!",15)
//TRCell():New(oSection7,"DESC"		,"TRB","Descrição"  ,"@!",50)
TRCell():New(oSection7,"QTDE"		,"TRB", "Quantidade","@E 999,999,999.99",15)
TRCell():New(oSection7,"QTDEM2"		,"TRB", "Seg.Um","@E 999,999,999.9999",15)
TRCell():New(oSection7,"EMISSAO"	,"TRB", "Dt.Emissao","@!",10)
TRCell():New(oSection7,"VALBRUT"	,"TRB", "Valor Bruto","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALLIQ"		,"TRB", "Valor.Liq.","@E 999,999,999.99",15)
TRCell():New(oSection7,"CUSTOSTD"	,"TRB", "Custo Std.","@E 999,999,999.99",15)
TRCell():New(oSection7,"MGSTD"		,"TRB", "Mg.Std","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCSTD"	,"TRB", "Perc.Std","@E 9,999.99",15)
TRCell():New(oSection7,"MGREAL"		,"TRB", "Mg.Real","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCREAL"	,"TRB", "Perc.Real","@E 9,999.99",15)
TRCell():New(oSection7,"CUSTOATU"	,"TRB", "Custo Atual","@E 999,999,999.99",15)
TRCell():New(oSection7,"MGATU"		,"TRB", "Mg.Atual","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCATU"	,"TRB", "Perc.Atual","@E 9,999.99",15)
TRCell():New(oSection7,"CUSTOSIM"	,"TRB", "Custo Simulado","@E 999,999,999.99",15)
TRCell():New(oSection7,"MGSIMUL"	,"TRB", "Mg.Simulado","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCSIM"	,"TRB", "Perc.Simulado","@E 9,999.99",15)
TRCell():New(oSection7,"ACRESC"		,"TRB", "Acréscimo","@E 999,999,999.99",15)
TRCell():New(oSection7,"VERBADIC"	,"TRB", "Verba Adicional","@E 999,999,999.99",15)
TRCell():New(oSection7,"PEDIDO"		,"TRB", "Pedido"  ,"@!",06)
TRCell():New(oSection7,"ITEMPV"		,"TRB", "Item PV"  ,"@!",02)
TRCell():New(oSection7,"VALMERC"	,"TRB", "Valor Mercadoria","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALIPI" 	,"TRB", "Valor IPI","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALADIC"	,"TRB", "Valor Adicional","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALCPMF" 	,"TRB", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALICMS"	,"TRB", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALICMST" 	,"TRB", "Valor ICMS ST","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALPC"		,"TRB", "Valor Pis/Cofins","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALIR"	 	,"TRB", "Valor IR","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALCSLL"		,"TRB", "Valor CSLL","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALCOM"	 		,"TRB", "Valor Comissão","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALCOM2"		,"TRB", "Valor Comissão Coord.","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALFIN"	 		,"TRB", "Valor Financeiro","@E 999,999,999.99",15)
TRCell():New(oSection7,"VALFRET"		,"TRB", "Valor Frete","@E 999,999,999.99",15)
TRCell():New(oSection7,"DESCZFR"	 	,"TRB", "Descto. Zona Franca","@E 999,999,999.99",15)
TRCell():New(oSection7,"PERCCOM"	 	,"TRB", "Perc.Comiss","@E 999,999,999.99",15)
TRCell():New(oSection7,"TP"    	 		,"TRB", "Tipo","@!",02)
TRCell():New(oSection7,"FRETE"   	 	,"TRB", "Frete","@!",08)
TRCell():New(oSection7,"PERFRET" 	 	,"TRB", "Perc.Frete","@E 999.99",06)
TRCell():New(oSection7,"DIFAL"  	 	,"TRB", "DIFAL","@E 999,999,999.99",15)
TRCell():New(oSection7,"EST"    	 	,"TRB", "UF","@!",02)
TRCell():New(oSection7,"ESTGRP"  	 	,"TRB", "Grupo Est.","@!",02)
TRCell():New(oSection7,"TES"    	 	,"TRB", "TES","@!",04)
TRCell():New(oSection7,"CFOP"    	 	,"TRB", "CFOP","@!",05)
TRCell():New(oSection7,"CONDPAG" 	 	,"TRB", "Condic.Pagto.","@!",10)
TRCell():New(oSection7,"TPVEND"   	 	,"TRB", "Frete","@!",08)
TRCell():New(oSection7,"QTDE2" 	 		,"TRB", "Qtde 2a Um","@e 999,999.99",09)
TRCell():New(oSection7,"ALIQICM" 	 	,"TRB", "Aliq.ICMS","@e 999.99",06)
TRCell():New(oSection7,"ALIQIPI" 	 	,"TRB", "Aliq.IPI","@e 999.99",06)
TRCell():New(oSection7,"NCM"   	 		,"TRB", "NCM","@!",08)
TRCell():New(oSection7,"CNPJ"   	 	,"TRB", "CNPJ","@!",08)
TRCell():New(oSection7,"INSCR"   	 	,"TRB", "Inscrição Est.","@!",08)
TRCell():New(oSection7,"TPCLI"   	 	,"TRB", "Tipo Cli.","@!",08)
TRCell():New(oSection7,"EMISS"   	 	,"TRB", "Emissão","@!",08)
TRCell():New(oSection7,"PRODUTO"   	 	,"TRB", "Produto","@!",08)
TRCell():New(oSection7,"STDPROD" 	 	,"TRB", "Std.Produto","@e 999,999.99",12)
TRCell():New(oSection7,"DESONER" 	 	,"TRB", "Desoneração","@e 999,999.99",12)
TRCell():New(oSection7,"MUNI"   	 	,"TRB", "Município","@!",30)
TRCell():New(oSection7,"TRANSP"   	 	,"TRB", "Transportadora","@!",30)
TRCell():New(oSection7,"SEGMENTO"   		,"TRB", "Segmento","@!",10)
TRCell():New(oSection7,"REGIAO"   		,"TRB", "Região","@!",10)
TRCell():New(oSection7,"SITCLI"   		,"TRB", "Situação Cli.","@!",10)
TRCell():New(oSection7,"VENDCAD"   		,"TRB", "Vendedor Cadastro","@!",10)
TRCell():New(oSection7,"DATASAI"   		,"TRB", "Data Saída","@!",10)


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
Local oSection6 := oReport:Section(6)	 // Abrir a seção UF
Local oSection7 := oReport:Section(7)	 // Abrir a seção Resumo por NF

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
		//		oSection1:Cell("DULTVEN"):SetValue(dtoc(SC5->C5_EMISSAO))
		oSection1:Cell("NUM"):SetValue(TRB->NUM)
		oSection1:Cell("ITEM"):SetValue(TRB->ITEM)
		oSection1:Cell("CODCLI"):SetValue(TRB->CODCLI)
		oSection1:Cell("LOJA"):SetValue(TRB->LOJA)
		oSection1:Cell("CLI"):SetValue(TRB->CLI)
		oSection1:Cell("NREDUZ"):SetValue(TRB->NREDUZ)
		oSection1:Cell("GRPCLI"):SetValue(TRB->GRPCLI)
		oSection1:Cell("RANK"):SetValue(TRB->RANK)
		oSection1:Cell("VEND"):SetValue(TRB->VEND)
		oSection1:Cell("COOR"):SetValue(TRB->COOR)
		oSection1:Cell("COD"):SetValue(TRB->COD)
		oSection1:Cell("DESC"):SetValue(TRB->DESC)
		oSection1:Cell("QTDE"):SetValue(TRB->QTDE)
		oSection1:Cell("QTDEM2"):SetValue(TRB->QTDEM2)
		oSection1:Cell("EMISSAO"):SetValue(TRB->EMISSAO)
		oSection1:Cell("VALBRUT"):SetValue(TRB->VALBRUT)
		oSection1:Cell("VALLIQ"):SetValue(TRB->VALLIQ)
		oSection1:Cell("CUSTOSTD"):SetValue(TRB->CUSTOSTD)
		oSection1:Cell("MGSTD"):SetValue(TRB->MGSTD)
		oSection1:Cell("PERCSTD"):SetValue(TRB->PERCSTD)
		oSection1:Cell("MGREAL"):SetValue(TRB->MGREAL)
		oSection1:Cell("PERCREAL"):SetValue(TRB->PERCREAL)
		oSection1:Cell("CUSTOATU"):SetValue(TRB->CUSTOATU)
		oSection1:Cell("MGATU"):SetValue(TRB->MGATU)
		oSection1:Cell("PERCATU"):SetValue(TRB->PERCATU)
		oSection1:Cell("CUSTOSIM"):SetValue(TRB->CUSTOSIM)
		oSection1:Cell("MGSIMUL"):SetValue(TRB->MGSIMUL)
		oSection1:Cell("PERCSIM"):SetValue(TRB->PERCSIM)
		oSection1:Cell("ACRESC"):SetValue(TRB->ACRESC)
		oSection1:Cell("VERBADIC"):SetValue(TRB->VERBADIC)
		oSection1:Cell("PEDIDO"):SetValue(TRB->PEDIDO)
		oSection1:Cell("ITEMPV"):SetValue(TRB->ITEMPV)
		oSection1:Cell("VALMERC"):SetValue(TRB->VALMERC)
		oSection1:Cell("VALIPI" ):SetValue(TRB->VALIPI )
		oSection1:Cell("VALADIC"):SetValue(TRB->VALADIC)
		oSection1:Cell("VALCPMF" ):SetValue(TRB->VALCPMF )
		oSection1:Cell("VALICMS"):SetValue(TRB->VALICMS)
		oSection1:Cell("VALICMST"):SetValue(TRB->VALICMST )
		oSection1:Cell("VALPC"):SetValue(TRB->VALPC)
		oSection1:Cell("VALIR"):SetValue(TRB->VALIR)
		oSection1:Cell("VALCSLL"):SetValue(TRB->VALCSLL)
		oSection1:Cell("VALCOM"):SetValue(TRB->VALCOM)
		oSection1:Cell("VALCOM2"):SetValue(TRB->VALCOM2)
		oSection1:Cell("VALFIN"):SetValue(TRB->VALFIN)
		oSection1:Cell("VALFRET"):SetValue(TRB->VALFRET)
		oSection1:Cell("DESCZFR"):SetValue(TRB->DESCZFR)
		oSection1:Cell("PERCCOM"):SetValue(TRB->PERCCOM)
		oSection1:Cell("TP"    ):SetValue(TRB->TP    )
		oSection1:Cell("FRETE"   ):SetValue(TRB->FRETE   )
		oSection1:Cell("PERFRET" ):SetValue(TRB->PERFRET )
		oSection1:Cell("DIFAL" ):SetValue(TRB->DIFAL )
		oSection1:Cell("EST"    ):SetValue(TRB->EST    )
		oSection1:Cell("ESTGRP"  ):SetValue(TRB->ESTGRP  )
		oSection1:Cell("TES"    ):SetValue(TRB->TES    )
		oSection1:Cell("CFOP"    ):SetValue(TRB->CFOP    )
		oSection1:Cell("CONDPAG" ):SetValue(TRB->CONDPAG )
		oSection1:Cell("TPVEND"  ):SetValue(TRB->TPVEND   )
		oSection1:Cell("QTDE2" ):SetValue(TRB->QTDE2 )
		oSection1:Cell("ALIQICM" ):SetValue(TRB->ALIQICM )
		oSection1:Cell("ALIQIPI" ):SetValue(TRB->ALIQIPI )
		oSection1:Cell("NCM"   ):SetValue(TRB->NCM   )
		oSection1:Cell("CNPJ"   ):SetValue(TRB->CNPJ   )
		oSection1:Cell("INSCR"   ):SetValue(TRB->INSCR   )
		oSection1:Cell("TPCLI"   ):SetValue(TRB->TPCLI   )
		oSection1:Cell("EMISS"   ):SetValue(TRB->EMISS   )
		oSection1:Cell("PRODUTO" ):SetValue(TRB->PRODUTO  )
		oSection1:Cell("STDPROD" ):SetValue(TRB->STDPROD )
		oSection1:Cell("DESONER" ):SetValue(TRB->DESONER )
		oSection1:Cell("MUNI"   ):SetValue(TRB->MUNI   )
		oSection1:Cell("TRANSP"  ):SetValue(TRB->TRANSP   )
		oSection1:Cell("SEGMENTO"):SetValue(TRB->SEGMENTO )
		oSection1:Cell("REGIAO"  ):SetValue(TRB->REGIAO   )
		oSection1:Cell("SITCLI"  ):SetValue(TRB->SITCLI   )
		oSection1:Cell("VENDCAD" ):SetValue(TRB->VENDCAD  )
		oSection1:Cell("DATASAI" ):SetValue(TRB->DATASAI  )
		
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
dbUseArea( .T.,,"\gerencia\MGFTPRD.dtc","TRB1", Nil, .F. )

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
		
		//imprimo a segunda seção - resumo por produto

		oSection2:Cell("PRODUTO"):SetValue(Trb1->PRODUTO)
		oSection2:Cell("DESC"):SetValue(Trb1->DESC)
		oSection2:Cell("TPPROD"):SetValue(Trb1->TPPROD)
		
		oSection2:Cell("QTDE"):SetValue(TRB1->QTDE)
		oSection2:Cell("QTDEM2"):SetValue(TRB1->QTDEM2)
		oSection2:Cell("QTDEP"):SetValue(TRB1->QTDEP)
		oSection2:Cell("VLBRUT"):SetValue(TRB1->VLBRUT)
		oSection2:Cell("VLBRUTP"):SetValue(TRB1->VLBRUTP)
		oSection2:Cell("VALLIQ"):SetValue(TRB1->VALLIQ)
		oSection2:Cell("VALLIQP"):SetValue(TRB1->VALLIQP)
		oSection2:Cell("CUSTOSTD"):SetValue(TRB1->CUSTOSTD)
		oSection2:Cell("CUSTOSTDP"):SetValue(TRB1->CUSTOSTDP)
		oSection2:Cell("MGSTD"):SetValue(TRB1->MGSTD)
		oSection2:Cell("PERCSTD"):SetValue(TRB1->PERCSTD)
		oSection2:Cell("MGREAL"):SetValue(TRB1->MGREAL)
		oSection2:Cell("PERCREAL"):SetValue(TRB1->PERCREAL)
		oSection2:Cell("CUSTOATU"):SetValue(TRB1->CUSTOATU)
		oSection2:Cell("MGATU"):SetValue(TRB1->MGATU)
		oSection2:Cell("PERCATU"):SetValue(TRB1->PERCATU)
		oSection2:Cell("CUSTOSIM"):SetValue(TRB1->CUSTOSIM)
		oSection2:Cell("MGSIMUL"):SetValue(TRB1->MGSIMUL)
		oSection2:Cell("PERCSIM"):SetValue(TRB1->PERCSIM)

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
dbUseArea( .T.,,"\gerencia\MGFTCLI.dtc","TRB1", Nil, .F. )

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
                    
		oSection3:Cell("GRPCLI"):SetValue(Trb1->GRPCLI)
		oSection3:Cell("CLI"):SetValue(Trb1->CLI)
		oSection3:Cell("NOME"):SetValue(Trb1->NOME)
		oSection3:Cell("NREDUZ"):SetValue(Trb1->NREDUZ)
		oSection3:Cell("UF"):SetValue(Trb1->UF)
		oSection3:Cell("VEND"):SetValue(Trb1->VEND)
		oSection3:Cell("RANK"):SetValue(Trb1->RANK)
		oSection3:Cell("NOMEV"):SetValue(Trb1->NOMEV)
		oSection3:Cell("NOMEC"):SetValue(Trb1->NOMEC)
		oSection3:Cell("SEGMENTO"):SetValue(Trb1->SEGMENTO)
		oSection3:Cell("REGIAO"):SetValue(Trb1->REGIAO)
		oSection3:Cell("SITCLI"):SetValue(Trb1->SITCLI)
		oSection3:Cell("VENDCAD"):SetValue(Trb1->VENDCAD)
		oSection3:Cell("QTDE"):SetValue(TRB1->QTDE)
		oSection3:Cell("QTDEM2"):SetValue(TRB1->QTDEM2)
		oSection3:Cell("QTDEP"):SetValue(TRB1->QTDEP)
		oSection3:Cell("VLBRUT"):SetValue(TRB1->VLBRUT)
		oSection3:Cell("VLBRUTP"):SetValue(TRB1->VLBRUTP)
		oSection3:Cell("VALLIQ"):SetValue(TRB1->VALLIQ)
		oSection3:Cell("VALLIQP"):SetValue(TRB1->VALLIQP)
		oSection3:Cell("CUSTOSTD"):SetValue(TRB1->CUSTOSTD)
		oSection3:Cell("CUSTOSTDP"):SetValue(TRB1->CUSTOSTDP)
		oSection3:Cell("MGSTD"):SetValue(TRB1->MGSTD)
		oSection3:Cell("PERCSTD"):SetValue(TRB1->PERCSTD)
		oSection3:Cell("MGREAL"):SetValue(TRB1->MGREAL)
		oSection3:Cell("PERCREAL"):SetValue(TRB1->PERCREAL)
		oSection3:Cell("CUSTOATU"):SetValue(TRB1->CUSTOATU)
		oSection3:Cell("MGATU"):SetValue(TRB1->MGATU)
		oSection3:Cell("PERCATU"):SetValue(TRB1->PERCATU)
		oSection3:Cell("CUSTOSIM"):SetValue(TRB1->CUSTOSIM)
		oSection3:Cell("MGSIMUL"):SetValue(TRB1->MGSIMUL)
		oSection3:Cell("PERCSIM"):SetValue(TRB1->PERCSIM)


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
dbUseArea( .T.,,"\gerencia\MGFTVEN.dtc","TRB1", Nil, .F. )

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
		
		//imprimo a segunda seção

		oSection4:Cell("VEND"):SetValue(Trb1->VEND)
		oSection4:Cell("NOMEV"):SetValue(Trb1->NOMEV)
		oSection4:Cell("NOMEC"):SetValue(Trb1->NOMEC)
		oSection4:Cell("UF"):SetValue(Trb1->UF)
		oSection4:Cell("QTDE"):SetValue(TRB1->QTDE)
		oSection4:Cell("QTDEP"):SetValue(TRB1->QTDEP)
		oSection4:Cell("VLBRUT"):SetValue(TRB1->VLBRUT)
		oSection4:Cell("VLBRUTP"):SetValue(TRB1->VLBRUTP)
		oSection4:Cell("VALLIQ"):SetValue(TRB1->VALLIQ)
		oSection4:Cell("VALLIQP"):SetValue(TRB1->VALLIQP)
		oSection4:Cell("CUSTOSTD"):SetValue(TRB1->CUSTOSTD)
		oSection4:Cell("CUSTOSTDP"):SetValue(TRB1->CUSTOSTDP)
		oSection4:Cell("MGSTD"):SetValue(TRB1->MGSTD)
		oSection4:Cell("PERCSTD"):SetValue(TRB1->PERCSTD)
		oSection4:Cell("MGREAL"):SetValue(TRB1->MGREAL)
		oSection4:Cell("PERCREAL"):SetValue(TRB1->PERCREAL)
		oSection4:Cell("CUSTOATU"):SetValue(TRB1->CUSTOATU)
		oSection4:Cell("MGATU"):SetValue(TRB1->MGATU)
		oSection4:Cell("PERCATU"):SetValue(TRB1->PERCATU)
		oSection4:Cell("CUSTOSIM"):SetValue(TRB1->CUSTOSIM)
		oSection4:Cell("MGSIMUL"):SetValue(TRB1->MGSIMUL)
		oSection4:Cell("PERCSIM"):SetValue(TRB1->PERCSIM)

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
dbUseArea( .T.,,"\GERENCIA\MGFTUFREP","TRB1", Nil, .F. )

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
		oSection5:Cell("VALLIQ"):SetValue(TRB1->VALLIQ)
		oSection5:Cell("VALLIQP"):SetValue(TRB1->VALLIQP)
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
	
	//finalizo a seção 5
Enddo

//SEÇÃO 6 - Uf
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF
dbUseArea( .T.,,"\GERENCIA\MGFTUF","TRB1", Nil, .F. )

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
	
	IncProc("Imprimindo Faturamento x Uf")

	Do while !eof()
		oReport:IncMeter()

		//imprimo a quinta seção

		oSection6:Cell("UF"):SetValue(Trb1->UF)
		oSection6:Cell("QTDCLI"):SetValue(TRB1->QTDCLI)

		oSection6:Cell("QTDE"):SetValue(TRB1->QTDE)
		oSection6:Cell("QTDEP"):SetValue(TRB1->QTDEP)
		oSection6:Cell("VLBRUT"):SetValue(TRB1->VLBRUT)
		oSection6:Cell("VLBRUTP"):SetValue(TRB1->VLBRUTP)
		oSection6:Cell("VALLIQ"):SetValue(TRB1->VALLIQ)
		oSection6:Cell("VALLIQP"):SetValue(TRB1->VALLIQP)
		oSection6:Cell("CUSTOSTD"):SetValue(TRB1->CUSTOSTD)
		oSection6:Cell("CUSTOSTDP"):SetValue(TRB1->CUSTOSTDP)
		oSection6:Cell("MGSTD"):SetValue(TRB1->MGSTD)
		oSection6:Cell("PERCSTD"):SetValue(TRB1->PERCSTD)
		oSection6:Cell("MGREAL"):SetValue(TRB1->MGREAL)
		oSection6:Cell("PERCREAL"):SetValue(TRB1->PERCREAL)
		oSection6:Cell("CUSTOATU"):SetValue(TRB1->CUSTOATU)
		oSection6:Cell("MGATU"):SetValue(TRB1->MGATU)
		oSection6:Cell("PERCATU"):SetValue(TRB1->PERCATU)
		oSection6:Cell("CUSTOSIM"):SetValue(TRB1->CUSTOSIM)
		oSection6:Cell("MGSIMUL"):SetValue(TRB1->MGSIMUL)
		oSection6:Cell("PERCSIM"):SetValue(TRB1->PERCSIM)
		
		oSection6:Printline()
		TRB1->(dbSkip())
	Enddo
	
	//finalizo a seção 6
Enddo

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
		nPERCCOM:= nPERFRET:= nQTDE2:= nVALCSLL := 0		

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
			nVALCSLL +=VALCSLL
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
		
		//imprimo o resumo
		oSection7:Cell("NUM"):SetValue(TRB->NUM)
		oSection7:Cell("ITEM"):SetValue(TRB->ITEM)
		oSection7:Cell("CODCLI"):SetValue(TRB->CODCLI)
		oSection7:Cell("LOJA"):SetValue(TRB->LOJA)
		oSection7:Cell("CLI"):SetValue(TRB->CLI)
		oSection7:Cell("NREDUZ"):SetValue(TRB->NREDUZ)
		oSection7:Cell("GRPCLI"):SetValue(TRB->GRPCLI)
		oSection7:Cell("RANK"):SetValue(TRB->RANK)
		oSection7:Cell("VEND"):SetValue(TRB->VEND)
		oSection7:Cell("COOR"):SetValue(TRB->COOR)
		//oSection7:Cell("COD"):SetValue(TRB->COD)
		//oSection7:Cell("DESC"):SetValue(TRB->DESC)
		oSection7:Cell("QTDE"):SetValue(nQTDE)
		oSection7:Cell("QTDEM2"):SetValue(nQTDEM2)
		oSection7:Cell("EMISSAO"):SetValue(TRB->EMISSAO)
		oSection7:Cell("VALBRUT"):SetValue(nVALBRUT)
		oSection7:Cell("VALLIQ"):SetValue(nVALLIQ)
		oSection7:Cell("CUSTOSTD"):SetValue(nCUSTOSTD)
		oSection7:Cell("MGSTD"):SetValue(nMGSTD)
		oSection7:Cell("PERCSTD"):SetValue(nPERCSTD)
		oSection7:Cell("MGREAL"):SetValue(nMGREAL)
		oSection7:Cell("PERCREAL"):SetValue(nPERCREAL)
		oSection7:Cell("CUSTOATU"):SetValue(nCUSTOATU)
		oSection7:Cell("MGATU"):SetValue(nMGATU)
		oSection7:Cell("PERCATU"):SetValue(nPERCATU)
		oSection7:Cell("CUSTOSIM"):SetValue(nCUSTOSIM)
		oSection7:Cell("MGSIMUL"):SetValue(nMGSIMUL)
		oSection7:Cell("PERCSIM"):SetValue(nPERCSIM)
		oSection7:Cell("ACRESC"):SetValue(TRB->ACRESC)
		oSection7:Cell("VERBADIC"):SetValue(nVERBADIC)
		oSection7:Cell("PEDIDO"):SetValue(TRB->PEDIDO)
		oSection7:Cell("ITEMPV"):SetValue(TRB->ITEMPV)
		oSection7:Cell("VALMERC"):SetValue(nVALMERC)
		oSection7:Cell("VALIPI" ):SetValue(nVALIPI )
		oSection7:Cell("VALADIC"):SetValue(nVALADIC)
		oSection7:Cell("VALCPMF" ):SetValue(nVALCPMF )
		oSection7:Cell("VALICMS"):SetValue(nVALICMS)
		oSection7:Cell("VALICMST"):SetValue(nVALICMST )
		oSection7:Cell("VALPC"):SetValue(nVALPC)
		oSection7:Cell("VALIR"):SetValue(nVALIR)
		oSection7:Cell("VALCSLL"):SetValue(NVALCSLL)
		oSection7:Cell("VALCOM"):SetValue(nVALCOM)
		oSection7:Cell("VALCOM2"):SetValue(nVALCOM2)
		oSection7:Cell("VALFIN"):SetValue(nVALFIN)
		oSection7:Cell("VALFRET"):SetValue(nVALFRET)
		oSection7:Cell("DESCZFR"):SetValue(nDESCZFR)
		oSection7:Cell("PERCCOM"):SetValue(TRB->PERCCOM)
		oSection7:Cell("TP"    ):SetValue(TRB->TP    )
		oSection7:Cell("FRETE"   ):SetValue(TRB->FRETE   )
		oSection7:Cell("PERFRET" ):SetValue(TRB->PERFRET )
		oSection7:Cell("DIFAL" ):SetValue(TRB->DIFAL )
		oSection7:Cell("EST"    ):SetValue(TRB->EST    )
		oSection7:Cell("ESTGRP"  ):SetValue(TRB->ESTGRP  )
		oSection7:Cell("TES"    ):SetValue(TRB->TES    )
		oSection7:Cell("CFOP"    ):SetValue(TRB->CFOP    )
		oSection7:Cell("CONDPAG" ):SetValue(TRB->CONDPAG )
		oSection7:Cell("TPVEND"  ):SetValue(TRB->TPVEND   )
		oSection7:Cell("QTDE2" ):SetValue(nQTDE2 )
		oSection7:Cell("ALIQICM" ):SetValue(TRB->ALIQICM )
		oSection7:Cell("ALIQIPI" ):SetValue(TRB->ALIQIPI )
		oSection7:Cell("NCM"   ):SetValue(TRB->NCM   )
		oSection7:Cell("CNPJ"   ):SetValue(TRB->CNPJ   )
		oSection7:Cell("INSCR"   ):SetValue(TRB->INSCR   )
		oSection7:Cell("TPCLI"   ):SetValue(TRB->TPCLI   )
		oSection7:Cell("EMISS"   ):SetValue(TRB->EMISS   )
		oSection7:Cell("PRODUTO" ):SetValue(TRB->PRODUTO  )
		oSection7:Cell("STDPROD" ):SetValue(TRB->STDPROD )
		oSection7:Cell("DESONER" ):SetValue(TRB->DESONER )
		oSection7:Cell("MUNI"   ):SetValue(TRB->MUNI   )
		oSection7:Cell("TRANSP"  ):SetValue(TRB->TRANSP   )
		oSection7:Cell("SEGMENTO"):SetValue(TRB->SEGMENTO )
		oSection7:Cell("REGIAO"  ):SetValue(TRB->REGIAO   )
		oSection7:Cell("SITCLI"  ):SetValue(TRB->SITCLI   )
		oSection7:Cell("VENDCAD" ):SetValue(TRB->VENDCAD  )
		oSection7:Cell("DATASAI" ):SetValue(TRB->DATASAI  )
		
		oSection7:Printline()
		TRB->(dbSkip())
	Enddo
	
	//finalizo a setima seção
Enddo

oSection7:Finish()
oSection6:Finish()
oSection5:Finish()
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()

Return

