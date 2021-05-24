#include "rwmake.ch"

User Function RFAT016()        // Posicao de Faturamento com Margem - 28/07/05

public nAcresc,nVerbAdic,cObs
aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Faturamento com Margem"
cDesc2   := ""
cDesc3   := ""
cPerg    := "RFT015"
cString  := "SD2"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT016"
titulo   := "Posicao de Faturamento (Margem)"
wnrel    := "RFAT016"
limite   := 132
tamanho  := "M"
nMultip  := 1
nFrete   := nvCPMF := nIcms := nPC := mIR := nCom := nFin := 0
cTpVend  := " "
nCustAmost := 0
nValFol	:=0
nDespG := nDespA := nDespF := nDespC := nDespP := nDespIM := nDespA := 0
nDespOu := nDespJR := nDespIp := nDescto := nRecFin	:= nResF1 := nResF2 := nResF3 := 0

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
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "ITEM"    , "C",02,0})
AADD(aCampos,{ "CODCLI"  , "C",06,0})
AADD(aCampos,{ "LOJA"    , "C",02,0})
AADD(aCampos,{ "CLI"     , "C",30,0})
AADD(aCampos,{ "NREDUZ"  , "C",20,0})
AADD(aCampos,{ "VEND"    , "C",06,0})
AADD(aCampos,{ "COOR"    , "C",06,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "QTDE"    , "N",12,2})
AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "VALBRUT" , "N",12,2})
AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "CUSTOSTD", "N",12,2})
AADD(aCampos,{ "MGSTD"   , "N",12,2})
AADD(aCampos,{ "PERCSTD" , "N",12,4})
AADD(aCampos,{ "MGREAL"  , "N",12,2})
AADD(aCampos,{ "PERCREAL", "N",12,4})
AADD(aCampos,{ "CUSTOATU"  , "N",12,2})
AADD(aCampos,{ "MGATU"   , "N",12,2})
AADD(aCampos,{ "PERCATU" , "N",12,4})
AADD(aCampos,{ "CUSTOSIM"  , "N",12,2})
AADD(aCampos,{ "MGSIMUL" , "N",12,2})
AADD(aCampos,{ "PERCSIM" , "N",12,4})

AADD(aCampos,{ "ACRESC"  , "N",06,4})
AADD(aCampos,{ "VERBADIC", "N",08,4})
AADD(aCampos,{ "PEDIDO"  , "C",06,0})
AADD(aCampos,{ "ITEMPV"  , "C",02,0})
AADD(aCampos,{ "VALMERC" , "N",12,2})
AADD(aCampos,{ "VALIPI"  , "N",12,2})
AADD(aCampos,{ "VALADIC" , "N",12,2})
AADD(aCampos,{ "VALCPMF" , "N",12,2})
AADD(aCampos,{ "VALICMS" , "N",12,2})
AADD(aCampos,{ "VALICMST", "N",12,2})
AADD(aCampos,{ "VALPC"   , "N",12,2})
AADD(aCampos,{ "VALIR"   , "N",12,2})
AADD(aCampos,{ "VALCSLL" , "N",12,2})
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
AADD(aCampos,{ "CFOP"    , "C",04,0})
AADD(aCampos,{ "CONDPAG" , "C",10,0})
AADD(aCampos,{ "TPVEND"  , "C",01,0})
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
	if trim(d2_doc)$'015350*015353'
		x:=1
	endif
	select SA1
	dbSetOrder(1)
	seek xFilial()+trb1->d2_cliente+trb1->d2_loja
	select SA2
	dbSetOrder(1)
	seek xFilial()+trb1->d2_cliente+trb1->d2_loja
	select SC5
	dbSetOrder(1)
	seek xFilial()+trb1->d2_pedido
	select SA4
	dbSetOrder(1)
	seek xFilial()+sc5->c5_transp
	select SF2
	dbSetOrder(1)
	seek xFilial()+trb1->d2_doc+trb1->d2_serie
	if left(sc5->c5_tpfrete,1)=="C"
		VerFrete()  // Função não está funcionando
	else
		if rlock() .and. !eof()
			sf2->f2_frete1 := 0
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
		if left(trb1->d2_cod,2)=="00" .and. substr(trb1->d2_cod,3,1)#"."
			Select SB1
			dbSetOrder(1)
			Seek xFilial()+trb1->d2_cod
			cDescPrd := sb1->b1_desc
			cPosIpi  := sb1->b1_posipi
			nPerIpi  := sb1->b1_ipi
			if left(b1_codbar,1)=='2'
				cCod     := left(sb1->b1_codbar,7)
				cCodProd := left(sb1->b1_codbar,7)
				cCod1    := left(trb1->d2_cod,7)
			else
				cCod     := "1"+substr(trb1->d2_cod,2,3)
				cCodProd := "1"+substr(trb1->d2_cod,2,14)
			endif
		else
			cCod     := left(trb1->d2_cod,at(".",trb1->d2_cod)-1)
			cCodProd := trb1->d2_cod
			cCod1    := cCod
		endif
		if left(trb1->d2_cod,2)=="28" .or. left(trb1->d2_cod,2)=="29"
			cCod := trb1->d2_cod
			cCod1:= left(trb1->d2_cod,7)
		endif
		select SC5
		dbSetOrder(1)
		seek xFilial()+trb1->d2_pedido
		Do Case
			Case  sc5->c5_fator == "A"
				nMultip  := 2
			Case  sc5->c5_fator == "B"
				nMultip  := 5
			Case  sc5->c5_fator == "C"
				seek xfilial()+"P"+substr(trb1->d2_pedido,2,5)
				if !eof()
					nMultip  := 2
					seek xFilial()+trb1->d2_pedido
					if rlock()
						sc5->c5_fator := "A"
					endif
				endif
				seek xFilial()+trb1->d2_pedido
				nMultip  := 1
			Case  sc5->c5_fator == "S"
				nMultip  := 1
		EndCase
		nTotZFR := iif(trb1->d2_desczfr#0 .and. sc5->c5_fator#"S",trb1->d2_desczfr+trb1->d2_cusff4+trb1->d2_cusff5,0)
		nTotNF  := iif(trb1->d2_desczfr==0,trb1->d2_total,trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5)
		nTotFat := nTotNF*nMultip
		Select SB5
		Seek xFilial()+left(cCodProd,7)+" "
		if eof()
			Seek xFilial()+cCod
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
		//		if trim(sb1->b1_grupo)$"10*20" // Espelhos
		nCAtu := sb5->b5_cstatu
		//		nCAtu := sb5->b5_cmsimp //sb5->b5_cstatu
		//		else
		//			nCAtu := sb5->b5_cmsipi //sb5->b5_cstatu
		//		endif
		nCSim := sb5->b5_custsim
		// Custo Amostra
		if trb1->d2_tes$"505*513*520"
			//			nFatAmost := nFatAmost  + (trb1->d2_Total*0.0925) + trb1->d2_valipi + trb1->d2_valicm
			nCustAmost += (trb1->d2_quant*nCStd)
		endif
		
		verStd()
		nCStd := nCStd*nVar
		nMarg := nMarg*nVar
		
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
		cObs := "Faturado"
		nAcresc   := mv_par05
		nVerbAdic := sa1->a1_mgextra
		nValLiq := nValAdic:= 0
		nFrete  := nvCpmf := nIcms := nPC := nIR := nCSLL := nCom := nCom2 := nFin := 0
		cncm    := cCf := " "
		u_CalcVLiq(Alltrim(sc5->c5_fator),TRB1->D2_TOTAL,cCod1,cCod,sc5->c5_cliente+sc5->c5_lojacli,trb1->d2_tes,sc5->C5_CONDPAG,sc5->c5_tipo,sc5->c5_vend1,"FAT",trb1->d2_item,cSuper)
//		CalcVLiq(trb1->d2_emissao)
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
		trb->vend   := sc5->c5_vend1
		trb->coor   := cSuper
		trb->qtde   := trb1->d2_quant
		trb->emissao:= trb1->d2_EMISSAO
		trb->emiss  := dtoc(trb1->d2_EMISSAO)
		if cTpVend#"N"
			trb->valliq := nValLiq
			trb->valbrut:= iif(trim(sc5->c5_fator)=="C",nTotNF,nTotFat+nTotZFR)
			trb->CUSTOSTD := nCStd * trb1->d2_quant
		trb->MGSTD:= nMarg * trb1->d2_quant //nQtdEnt
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
			
			trb->CUSTOATU := nCAtu * trb1->d2_quant
			trb->mgatu  := (nValLiq-trb->CUSTOATU) //(nValLiq-trb->CUSTOATU)/(1+(mv_par05/100))
//			if (trb->mgatu/trb->MGSTD)*100<100000
//				trb->percatu:= (trb->mgatu/trb->MGSTD)*100
//			endif
			if (trb->mgatu/trb->CUSTOATU)*100<100000
				trb->percatu:= (trb->mgatu/trb->CUSTOATU)*100
			endif
			
			trb->CUSTOSIM := nCSim * trb1->d2_quant
			trb->mgsimul:= (nValLiq-trb->CUSTOSIM)/(1+(mv_par05/100))
//			trb->percsim:= (trb->mgsimul/trb->MGSTD)*100
			trb->percsim:= (trb->mgsimul/trb->CUSTOSTD)*100
			
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
			trb->valpc   := iif(trb1->d2_tipo$"B*D",trb1->d2_valimp5,nPC)
			trb->valir   := iif(trb1->d2_tipo$"B*D",trb1->d2_valimp4,nIR)
			trb->valcsll := iif(trb1->d2_tipo$"B*D",trb1->d2_valimp3,nCSLL)
		endif
		trb->valcom := nCom
		trb->perccom:= sc5->c5_comis1
		trb->valcom2:= nCom2
		trb->valfin := nFin
		trb->valfret:= nFrete
		trb->desczfr:= nTotZFR
		trb->tp     := sc5->c5_fator
		trb->frete  := sc5->c5_tpfrete
		trb->est    := iif(trb1->d2_tipo$"B*D",sa2->a2_est,sa1->a1_est)
		trb->muni   := iif(trb1->d2_tipo$"B*D","dev",sa1->a1_mun)
		trb->transp := iif(trb1->d2_tipo$"B*D","dev",sa4->a4_nome)
		trb->tes    := trb1->d2_tes
		trb->cfop   := trb1->d2_cf
		trb->tpvend := cTpVend
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
		trb->segmento := SA1->a1_sativ1
		trb->regiao   := SA1->a1_regiao
		trb->sitcli	  := SA1->A1_SATIV8
		trb->vendcad:= sa1->a1_vend

		msunlock()
		nTotLiq  += (nValLiq*nMultip)
		nTotCust += trb->CUSTOSTD
		nTotStd	 += trb->CUSTOSTD
		nTotCAtu += trb->CUSTOATU
		nTotCSim += trb->CUSTOSIM
		nTotIdeal+= trb->MGSTD
		nTotMg   += (nMarg * trb1->d2_quant)
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
copy to \x for num='026554'

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
	AADD(aCampos,{ "VLBRUT"  , "N",12,2})
	AADD(aCampos,{ "CUSTOSTD", "N",12,2})
	AADD(aCampos,{ "MGSTD"   , "N",12,2})
	AADD(aCampos,{ "PERCSTD" , "N",12,4})
	AADD(aCampos,{ "VALIPI"  , "N",12,2})
	AADD(aCampos,{ "VALST"   , "N",12,2})
	AADD(aCampos,{ "MGREAL"  , "N",12,2})
	AADD(aCampos,{ "PERCREAL", "N",12,4})
	AADD(aCampos,{ "PESO"    , "N",12,4})
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
Index on Num to &cTemp
do case
	case sm0->m0_codigo=="01"
		copy to \gerencia\mgft-le
		MsgBox ("Arquivo gerado com sucesso \system\mgft-le.dbf","Informa‡Æo","INFO")
		if file("mgftrm.dbf")
			if rlock()
				appe blan
				trb->Qtde := -nQtd
				trb->ValBrut:= -nVal1
				trb->ValLiq := -nVal2
				trb->CUSTOSTD := -nVal3
				trb->MGSTD:= -nVal4
				trb->MgReal := -nVal5
			endif
			appe from mgftrm
			copy to \gerencia\mgft-tt
			MsgBox ("Arquivo gerado com sucesso \system\mgft-tot.dbf","Informa‡Æo","INFO")
		Endif
	case sm0->m0_codigo=="02"
		copy to \gerencia\mgft-rm
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
	Cabec1 := "Codigo Vendedor        Est   Val.Bruto     Custo Std.    MG Std.     MG Real   Perc    Peso"
	*          01234567890123456789012345678901234567890123456789012345678901234567890123456789
	Cabec2 := "Período de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
	Select TRB
	SetRegua(recCount())
	dbGoTop()
	Do while !eof()
		IncRegua("1/6")
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
			IncRegua("2/6")
			nMGR := nMGR + trb->MGReal
			nMGI := nMGI + trb->MGSTD
			nVLB := nVLB + trb->Valbrut
			nStd := nStd + trb->CUSTOSTD
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
			if nMGR/nMGI*100<100000 .AND. nMGR/nMGI*100>-10000
				trbprn->Percreal   := nMGR/nMGI*100
			endif
			trbprn->Peso   := nMGR/nTot*100
		endif
		Select TRB
	Enddo
	
	Select TRBPRN
	Do Case
		Case mv_par06==2
			index on Peso*(-1) to &cTempPrn
		Case mv_par06==3
			index on Percreal*(-1) to &cTempPrn
	EndCase
	
	titulo   := "Posicao de Faturamento (Margem Vend.)"
	
	dbGoTop()
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+trbprn->Vend
		Select TRBPRN
		@ li,000 PSAY Vend+"-"+sa3->a3_nreduz+"  "+sa3->a3_est
		@ li,029 PSAY VlBrut  picture "@E 99,999,999"
		@ li,042 PSAY CUSTOSTD  picture "@E 99,999,999"
		@ li,054 PSAY MGSTD picture "@E 99,999,999"
		@ li,066 PSAY MGReal  picture "@E 99,999,999"
		@ li,077 PSAY Percreal    picture "@E 999.99"
		@ li,085 PSAY Peso    picture "@E 999.99"
		nTot1 := nTot1 +VlBrut
		nTot2 := nTot2 +MGSTD
		nTot3 := nTot3 +MGReal
		nTot4 := nTot4 +Percreal
		nTot5 := nTot5 +Peso
		nTot6 := nTot6 +CUSTOSTD
		skip
		li:=li+1
	Enddo
	li:=li+1
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,029 PSAY ntot1   picture "@E 99,999,999"
	@ li,042 PSAY ntot6   picture "@E 99,999,999"
	@ li,054 PSAY ntot2   picture "@E 99,999,999"
	@ li,066 PSAY nTot3   picture "@E 99,999,999"
	@ li,077 PSAY ntot3/ntot6*100  picture "@E 999.99"
	@ li,085 PSAY ntot5   picture "@E 999.99"
	li:=li+2
	
	index on Coor to &cTempPrn
	dbGoTop()
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		cCoor  := trbprn->Coor
		nMGR   := nMGI := nVLB := nStd := 0
		Do while !eof() .and. trbprn->Coor==cCoor
			IncRegua("3/6")
			nMGR := nMGR + trbprn->MGReal
			nMGI := nMGI + trbprn->MGSTD
			nVLB := nVLB + trbprn->Vlbrut
			nStd := nStd + trbprn->CUSTOSTD
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
		@ li,029 PSAY nVlB    picture "@E 99,999,999"
		@ li,042 PSAY nStd    picture "@E 99,999,999"
		@ li,054 PSAY nMGI    picture "@E 99,999,999"
		@ li,066 PSAY nMGR    picture "@E 99,999,999"
		@ li,077 PSAY nPerc   picture "@E 999.99"
		@ li,085 PSAY nPeso   picture "@E 999.99"
		nTot1 := nTot1 +nVlB
		nTot2 := nTot2 +nMGI
		nTot3 := nTot3 +nMGR
		nTot4 := nTot4 +nPerc
		nTot5 := nTot5 +nPeso
		nTot6 := nTot6 +nStd
		li:=li+1
	Enddo
	
	@ li,000 PSAY "------------------------"
	li:=li+1
	@ li,000 PSAY "Total Geral "
	@ li,029 PSAY ntot1   picture "@E 99,999,999"
	@ li,042 PSAY ntot6   picture "@E 99,999,999"
	@ li,054 PSAY ntot2   picture "@E 99,999,999"
	@ li,066 PSAY nTot3   picture "@E 99,999,999"
//	@ li,066 PSAY ntot3/ntot2*100  picture "@E 999.99"
	@ li,077 PSAY ntot3/ntot6*100  picture "@E 999.99"
	@ li,085 PSAY ntot5   picture "@E 999.99"
	
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
		if rlock()
			appe blan
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
		endif
		Select TRB
	Enddo
	
	cPrn1:= CriaTrab(nil,.f.)
	Select TRBPRN
	Do Case
		Case mv_par09==2
			index on Peso*(-1) to &cPrn1
		Case mv_par09==3
			index on Percreal*(-1) to &cPrn1
		Case mv_par09==4
			index on Nome to &cPrn1
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
	index on dtos(emissao)+num to &cTemp
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
			nValIPI:= nValSt := nVLB := nStd := 0
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
				tValIpi += trb->ValIpi
				tValSt  += trb->ValicmST
				tVLB	+= trb->Valbrut
				tStd	+= trb->CUSTOSTD
				skip
			Enddo
			Select TRBPRN
			if rlock()
				appe blan
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
			endif
			Select TRB
		Enddo
		Select TRBPRN
		if rlock()
			appe blan
			trbprn->emissao:= dEmissao
			trbprn->num    := '999999'
			trbprn->CUSTOSTD := tStd
			trbprn->VlBrut := tVLB
			trbprn->ValIpi := tValIPI
			trbprn->ValST  := tValST
		endif
		Select TRB
	Enddo
	cPrn1:= CriaTrab(nil,.f.)
	Select TRBPRN
	index on dtos(emissao)+Num to &cPrn1
	
	titulo   := "Relacao de Notas Fiscais emitidas"
	
	dbGoTop()
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		If li > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		Select TRBPRN
		if Num<>'999999'
			@ li,000 PSAY Num+"-"+left(Nome,20)+"  "+Est
			@ li,028 PSAY VlBrut  picture "@E 99,999,999"
			@ li,040 PSAY CUSTOSTD  picture "@E 99,999,999"
			@ li,052 PSAY ValIpi picture "@E 99,999,999"
			@ li,064 PSAY ValST  picture "@E 99,999,999"
			@ li,076 PSAY VlBrut+ValIPI+ValST picture "@E 999,999.99"
			nTot6 := nTot6 +CUSTOSTD
			nTot1 := nTot1 +VlBrut
			nTot2 := nTot2 +ValIpi
			nTot3 := nTot3 +ValST
			nTot4 := nTot4 +VlBrut+ValIPI+ValST
		endif
		skip
		li:=li+1
		if Num='999999'
			@ li,000 PSAY "Total dia " + dtoc(Emissao)
			@ li,028 PSAY VlBrut  picture "@E 99,999,999"
			@ li,040 PSAY CUSTOSTD  picture "@E 99,999,999"
			@ li,052 PSAY ValIpi picture "@E 99,999,999"
			@ li,064 PSAY ValST  picture "@E 99,999,999"
			@ li,076 PSAY VlBrut+ValIPI+ValST picture "@E 999,999.99"
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
	@ li,076 PSAY ntot4   picture "@E 9999,999.99"
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
if 	trb1->d2_serie= "DEV" .or. year(sf2->f2_emissao)>=2014
	if Substr(sc5->c5_TpFrete,1,1)=="C"
		Do case
			Case sa1->a1_est$"BA*CE"
				nFrete := nTotFat-nTotFat/1.10
				//			nFrete := nValNota*0.10
				if sa1->a1_est="CE" .and. trim(sa1->a1_cod_mun)="12908" //"SOBRAL"
					//				nFrete := nValNota*0.12
					nFrete := nTotFat-nTotFat/1.12
				endif
			Case sa1->a1_est$"MG" .and. trim(sa1->a1_cod_mun)="06200" //"BELO HORIZONTE"
				//			nFrete := nValNota*0.06
				nFrete := nTotFat-nTotFat/1.06
			Case sa1->a1_est$"RJ"
				//			nFrete := nValNota*0.065
				nFrete := nTotFat-nTotFat/1.065
			Case sa1->a1_est$"SP" .and. ;
				trim(sa1->a1_mun)$"SANTOS*SAO VICENTE*GUARUJA*CARAGUATATUBA*UBATUBA"
				//			nFrete := nValNota*0.065
				nFrete := nTotFat-nTotFat/1.065
			Case sa1->a1_est$"SP" .and. ;
				trim(sa1->a1_mun)$"PRAIA GRANDE*CUBATAO*ITANHAEM*MONGAGUA*PERUIBE*SAO SEBASTIAO"
				//			nFrete := nValNota*0.065
				nFrete := nTotFat-nTotFat/1.065
			Case sa1->a1_est$"SP" .and. sa1->a1_cod_mun$"50308*05708*25003*18800" // SP / Barueri / Jandira / Guarulhos ;
				//		"SAO"$sa1->a1_mun .and. "PAULO"$sa1->a1_mun
				nFrete := 0
			Case sa1->a1_est$"RS"
				//			nFrete := nValNota*0.12
				nFrete := nTotFat-nTotFat/1.12
			Otherwise
				//			nFrete := nValNota*0.15
				nFrete := nTotFat-nTotFat/1.15
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
seek xFilial()+SC5->c5_num 
IF SC5->c5_numtmk=sua->ua_num .and. sc5->c5_emissao >=stod("20160901")
	cCondPag := sua->UA_CONDPG
else
	cCondPag := sc5->C5_CONDPAG
endif

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+cCondPag)
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
	nCom    := ((nTotFat-nFrete) * sc5->C5_COMIS1)/100
	nCom2   := iif(nCom#0,((nTotFat-nFrete) * nComS)/100,0)
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
nValAdic := (nTotFat+trb1->d2_valipi)*(sa1->a1_mgextra/100)
if sm0->m0_codigo=="02"
	nValLiq := nTotFat-trb1->d2_valicm-nVCpmf-nCom-nCom2-nPC-nFin-nFrete-nValAdic //+nTotZFR
else
	nValLiq := nTotFat-trb1->d2_valicm-nVCpmf-nCom-nCom2-nPC-nIR-nCSLL-nFin-nFrete-nValAdic//+nTotZFR
	if _cSetor # "A"
		nValLiq := nValLiq - nTotZFR
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

if rlock() .and. !eof()
	sf2->f2_frete1 := nFrete
endif

Return

**************************
Static Function VerStd()
**************************
dFecStd := GetMV("MV_ULSTD")
//if trb1->d2_emissao>dFecStd
	Return
//endif
nCStd := nMarg := 0
Select SB9
dbSetOrder(1)
//seek xFilial()+left(cCodProd,4)+space(13)
//Do while !eof() .and. left(cCodProd,4)==left(b9_cod,4) .and. b9_local==space(2)
//  if trb1->d2_emissao<=b9_data
//    nCStd := sb9->b9_custd
//    nMarg := sb9->b9_margem
//  endif
//  skip
//Enddo
Do case
case len(trim(cCodProd))==7
	seek xFilial()+left(cCodProd,7)+space(10)
	Do while !eof() .and. left(cCodProd,7)==left(b9_cod,7) .and. b9_local==space(2)
		if trb1->d2_emissao<=b9_data
			nCStd := sb9->b9_custd
			nMarg := sb9->b9_margem
		endif
		skip
	Enddo
case len(trim(cCodProd))==4
	seek xFilial()+left(cCodProd,4)+space(13)
	Do while !eof() .and. left(cCodProd,4)==left(b9_cod,4) .and. b9_local==space(2)
		if trb1->d2_emissao<=b9_data
			nCStd := sb9->b9_custd
			nMarg := sb9->b9_margem
		endif
		skip
	Enddo
case len(trim(cCodProd))==5
	seek xFilial()+left(cCodProd,5)+space(12)
	Do while !eof() .and. left(cCodProd,5)==left(b9_cod,5) .and. b9_local==space(2)
		if trb1->d2_emissao<=b9_data
			nCStd := sb9->b9_custd
			nMarg := sb9->b9_margem
		endif
		skip
	Enddo
endcase        

if nCstd=0
	x:=1
endif

Return



****************************
Static Function GArq
****************************

Select TRB
ProcRegua(reccount())
nTotReal := 0
nTotQtde := 0
nTotValB := 0
nTotValq := 0
nTotStdL := 0
nTotMGId := 0
dbGoTop()
Do while !eof()
	IncProc()
	nTotReal += MGReal
	nTotQtde += Qtde
	nTotValB += ValBrut
	nTotValq += Valliq
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
	AADD(aCampos,{ "QTDE"    , "N",12,2})
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
			index on Produto to &cTempArq
		Case n==2 .and. mv_par11==1
			index on Nome to &cTempArq
		Case n==3 .and. mv_par12==1
			index on Vend to &cTempArq
		Case n==4 .and. mv_par12==1
			index on Uf   to &cTempArq
		Otherwise
			index on Uf   to &cTempArq
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
			index on Est+codcli  to &cTemp
	EndCase
	dbGotop()
	ProcRegua(reccount())
	li := 80
	//nTot := 0
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof()
		Select TRB
		nMGR   := nMGI := nVLB := nQtd := nStd := nVlq := 0
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
				cSegmento:= SEGMENTO
				cVendCad:= VENDCAD
				Do while !eof() .and. trb->CodCli==cChave
					IncProc()
					nMGR := nMGR + trb->MGReal
					nMGI := nMGI + trb->MGSTD
					nVLB := nVLB + trb->Valbrut
					nVLq := nVLq + trb->Valliq
					nSTD := nSTD + trb->CUSTOSTD
					nQtd := nQtd + trb->Qtde
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
					trbpr1->NReduz := cNREDUZ
					trbpr1->Regiao := cREGIAO
					trbpr1->SitCli := cSITCLI
					trbpr1->Segmento:= cSEGMENTO
					trbpr1->VendCad:= cVENDCAD
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
		nTot6 += nVLq
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
		trbpr1->Valliq  := nTot6
		trbpr1->ValliqP := Valliq/nTotValq
		trbpr1->CUSTOSTD  := nTot3
		trbpr1->CUSTOSTDP := CUSTOSTD/nTotStdl
		trbpr1->MGSTD := nTot4
		trbpr1->MgReal  := nTot5
//		if MGReal/nMGI*100 < 100000
//			trbpr1->Perc    := MGReal/nTot4*100
		if MGReal/nstd*100 < 100000 .and. MGReal/nstd*100 > -10000
			trbpr1->PercReal    := MGReal/nTot3*100
		endif
	endif
	
	Do case
		Case n==1
			totaliza()
			copy to \gerencia\MGFTPRD
		Case n==2
			copy to \gerencia\MGFTCLI
		Case n==3
			copy to \gerencia\MGFTVEN
		Case n==4
			totuf()
			copy to \gerencia\MGFTUF
	EndCase
	Use
	
Next N

*****************************
Static Function Totaliza()
*****************************
dbGoTop()
nRecTot := reccount()
Do while recno()<= nRecTot
	cQuebra := left(trbpr1->Produto,2)
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
	Do while !eof() .and. left(trbpr1->Produto,2)==cQuebra
		nTot1 += trbpr1->Qtde
		nTot2 += trbpr1->VlBrut
		nTot3 += trbpr1->CUSTOSTD
		nTot4 += trbpr1->MGSTD
		nTot5 += trbpr1->MgReal
		nTot6 += trbpr1->Valliq
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
		nQtd := nQtd+1
	Enddo
	Select TRBPR1
	Seek cUf
	if rlock() .and. !eof()
		TRBPR1->qtdcli := nQtd
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
	nTotNF  := trb2->d1_total //iif(trb2->d1_desczfr==0,trb1->d2_total,trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5)
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
		trb1->d2_total	:= iif(sf4->f4_estoque=="S",trb2->d1_total*(-1),0)
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
		trb1->d2_desczfr:= nTotZFR
		trb1->d2_cusff4 := sd2->d2_cusff4
		trb1->d2_cusff5 := sd2->d2_cusff5
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


