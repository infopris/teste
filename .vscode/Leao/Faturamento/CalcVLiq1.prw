#include "protheus.ch"
#include "rwmake.ch"

*************************************************************************************************
User Function CalcVLiq1(cFator,nValPed,cCod1,cCod,cCli,cTes,cCondPg,cTpNF,cVend,cDoc,cItem,cSuper,nQuant)//,nAcresc,nVerbAdic,cObs)
*************************************************************************************************
// Declaracao das Variaveis
// nFator  (n,1)    - Fator de reducao
// nValPed (n,12,2) - Valor do Pedido
// cTpVend (c,2)    - Venda ou Nao (S/N)
// cCod1   (c,6)    - Grupo de Produtos
// cCod    (c,15)   - Codigo do Produto

// cCli (c,8) - Cliente + Loja
// cTes (c,3) - TES
// cCondpg (c,3) - Cond. Pagamento
// cTPNF (c,1) - tipo nota (normal,dev,complem...)
// cVend (c,6) - Vendedor
// cDoc (c,3) - Tipo Ped/Fat/Cal
// 1   - Carrega Variaveis
// 1.1 - Tipo do Pedido - nFator
nValLiq := 0
nFator := 0
lTipo:= .t.
cOrigem := LEFT(cDoc,1)

do Case
	Case Alltrim(cfator) == "A"
		nFator := 2
	Case Alltrim(cfator) == "B"
		nFator := 5
	Case Alltrim(cfator) == "C"
		nFator := 1
	Case Alltrim(cfator) == "S"
		nFator := 0
Endcase

// 1.2 - Dados do Cliente/fornecedor

select SA1
dbSetOrder(1)
seek xFilial()+cCli
select SA2
dbSetOrder(1)
seek xFilial()+cCli

// 1.3 - Dados do TES

Select SF4
dbSetOrder(1)
Seek xFilial()+cTes
cTpVend := "S"
if sf4->f4_duplic=="N" .or. cTpNF$'D*I'
	cTpVend := "N"
	Return
endif

// 1.4 - Dados do item do pedido

Select SB1
dbSetOrder(1)
Seek xFilial()+cCod1


// Impostos

dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial()+"MV_PCI")
nPCI  := Val(Alltrim(SX6->X6_CONTEUD))
dbSeek(xFilial()+"MV_CPMF")
//if year(dEmis)<=2007
//	nCPMF := 0.38
//else
nCPMF := Val(Alltrim(SX6->X6_CONTEUD))
//Endif

nValLiq := nVCpmf := nIcms1 := nIcm   := nIpi1 := 0
nCom1   := nCom2  := nFin1  := nIr    := nValAdic :=  0
nPC     := nTotZFR:= 0

if cDoc="FAT"
	Select SD2
	dbSetOrder(3)
	Seek xFilial()+trb1->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM)
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+trb1->d2_pedido
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+trb1->(d2_pedido+d2_itempv)
	Select SUA
	dbSetOrder(8)
	seek xFilial()+trb1->(d2_pedido)
	Select SUB    
	dbSetOrder(3)
	Seek xFilial()+trb1->(d2_pedido+d2_itempv)
	cTipoCli:= SC5->C5_TIPOCLI
	nComis  := SC5->C5_COMIS1
	nVlPed  := trb1->D2_TOTAL
	nQtde	:= trb1->d2_quant
	nIpi	:= trb1->d2_ipi
	nIcms	:= trb1->d2_PICM
	nIcms1  := trb1->d2_valicm
	dEmissao:= trb1->d2_emissao
	nTotZFR := iif(trb1->d2_desczfr#0 .and. sc5->c5_fator#"S",trb1->d2_desczfr+trb1->d2_cusff4+trb1->d2_cusff5,0)
	nTotNF  := iif(trb1->d2_desczfr==0,trb1->d2_total,trb1->d2_total-trb1->d2_cusff4-trb1->d2_cusff5)
	nValPed := nTotNF*nFator
	nValLiq := nTotFat-nVCpmf-nPC-nIR-nCSLL-nFin-nFrete-nValAdic
else
	if cDoc = "PED"
		Select SC5
		dbSetOrder(1)
		seek xFilial()+trb1->c5_num
		Select SUA
		dbSetOrder(8)
		seek xFilial()+trb1->c5_num
		Select SUB
		dbsetOrder(3)
		seek xFilial()+sc6->(c6_num+c6_item)
		nVlPed  := SUB->UB_VRUNIT*SUB->UB_QUANT
		nQtde     := SC6->C6_QTDVEN
//		Do while !eof() .and. sc6->(c6_num+c6_item)=SUB->(UB_NUMPV+UB_ITEMPV) .and. sub->ub_num<>trb1->C5_NUMTMK
//			skip
//		Enddo
		nComis  := SC5->C5_COMIS1
		Select SD2
		dbSetOrder(8)
		Seek xFilial()+sc6->(c6_num+c6_item)
		if !eof()
//			cDoc = "FAT"
		endif
	Endif
	if cDoc = "CAL"
		nComis    := m->UA_COMIS
		_cTpFrete := m->ua_tpfrete
		nVlPed    := nValPed
		nQtde     := nQuant
	endif
//	nVlPed  := SUB->UB_VRUNIT*SUB->UB_QUANT
//	nQtdEnt := SUB->UB_QUANT
	
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+cCod
	
	if sf4->f4_ipi=="N"
		nIpi := 0
	else
		nIpi := sb1->b1_ipi
	endif
	
	if cDoc <> "CAL"
		
		Select SUA
		dbSetOrder(8)
		seek xFilial()+trb1->c5_num
		Select SUB
		dbsetOrder(3)
		seek xFilial()+sc6->(c6_num+c6_item)
		Do while !eof() .and. sc6->(c6_num+c6_item)=SUB->(UB_NUMPV+UB_ITEMPV) .and. sub->ub_num<>SC5->C5_NUMTMK
			skip
		Enddo
		if !empty(SC5->C5_TIPOCLI)
			cTipoCli := SC5->C5_TIPOCLI
		else
			if !empty(SUA->UA_TIPOCLI)
				cTipoCli := SUA->UA_TIPOCLI
			Else
				cTipoCli := SA1->A1_TIPOCLI
			Endif
		endif
	ELSE
		cTipoCli := SUA->UA_TIPOCLI
		
	Endif
endif

Select SUB
if cTes$'512*543*559'
	if cTes$'543*559' // Z.Franca = ICMS + PIS + Cofins
		nAliqZF := 0.1065
	else
		nAliqZF := 0.07
	endif
	if nFator#0
		nTotZFR := (nVlPed)*nAliqZF
	endif
endif

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial()+cTes)
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
if cTIPOCLI == "F" .OR. (LEN(TRIM(SA1->A1_CGC))>=9 .AND. LEN(TRIM(SA1->A1_CGC))<=11)
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
	if left(sa1->a1_codmun,5)=="00255" .and. cTes$'512*543*559' // Zona Franca de Manaus
		nICM    := 0
		nIR     := (((nVlPed+nTotZFR)-(nVlPed+nTotZFR)*.1065) * 2.88)/100
		nVCpmf  := ((nVlPed-nTotNF*.1065) * nCpmf)/100
		nZFr    := nTotZFR
	else
		nVCpmf  := ((nVlPed * nCPMF)/100)
	endif
else
	if left(sa1->a1_codmun,5)=="00255" .and. cTes$'512*543*559'  // Zona Franca de Manaus
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


nFrete := 0
if cDoc <> "CAL"
	_cTpFrete := SC5->c5_tpfrete
Endif

nValNota := nVlPed
if year(sc5->c5_emissao)>=2014 .or. cDoc="CAL"
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
dbSeek(xFilial()+cCONDPG)
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

Select SA3
dbSetOrder(1)
Seek xFilial()+cVend
cSuper := sa3->a3_super
Seek xFilial()+sa3->a3_super
nComS := sa3->a3_comis
Seek xFilial()+cVend

nValComis := 0
If nComis > 0
	nValComis := ((nVlPed-nFrete)*(nComis+nComS))/100
Endif

// final 5 - Calculo de comissoes


// Finalizando os calculos

if cDoc<>"FAT"
	IF cFator == "C"
		nipi1   := ((nVlPed * nIpi)/100)
		nIcms1  := ((nBase  * (nIcm))/100)
	ElseIf cFator  == "B"
		nipi1   := ((nVlPed * nIpi)/100)*.20
		nIcms1  := ((nBase  * (nIcm))/100) *.20
	ElseIf cFator  == "A"
		nipi1   := ((nVlPed * nIpi)/100) *.50
		nIcms1  := ((nBase  * (nIcm))/100) *.50
	ElseIf cFator  == "S"
		nIcms1  := 0
		nIpi1   := 0
	Endif   
else
	nIpi1  	:= sd2->D2_VALIPI	
	nIcms1 	:= sd2->D2_VALICM	
	nPc		:= sd2->(d2_valimp5+d2_valimp6)
Endif


//nCom1   := ((((nVlPed-nZFr)-nFrete)*trb1->C5_COMIS1)/100)
//nCom2   := iif(nCom1#0,((((nVlPed-nZFr)-nFrete)*nComS)/100),0)
//nCom1   := ((((nVlPed- nTotZFR)-nFrete)*nCOMIS)/100)
nCom1   := (((nVlPed- nTotZFR)*nCOMIS)/100) // Tirei o frete em 18-05-2020
nCom2   := iif(nCom1#0,((((nVlPed- nTotZFR)-nFrete)*nComS)/100),0)
nValAdic:= (nVlPed+nIpi1-nZFr)*(sa1->a1_mgextra/100)

// Alterei a fórmula em 06-03-2014 antecipei o cálculo do financeiro
nFin1   := (nVlPed- nTotZFR+nIpi1)-((nVlPed- nTotZFR+nIpi1)/nValFin)
nValLiq := nVlPed - nIcms1 - nCom1 - nCom2 - nFrete - nValAdic - nPC - nIR - nVCpmf - nFin1 + IIf(cFator=="A",nTotZFR,0) // - nTotZFR (Retirei o desc ZF em 23-02-17)//-nZfr
//nFin1   := nValliq-(nValliq/nValFin) //financeiro abate apos desconto dos impostos
//nValLiq := nValliq - nFin1
/*
GravaCpos(.t.)

dbSelectArea("SC6")

Return

************************************************************************************
User Function CalcImp(cDoc)
************************************************************************************

do case
Case cDoc = "CAL"
Case cDoc = "PED"
Case cDoc = "FAT"
Endcase

Static Function GravaCpos(lTipo)
*/
Select SZ0
Do Case
Case cDoc="TMK" .or. cDoc="CAL"
	dbSetOrder(1)
	seek xfilial()+SUB->(UB_NUM+UB_ITEM)
Case cDoc="PED"
	dbSetOrder(2)
	seek xfilial()+SC6->(C6_NUM+C6_ITEM)
Case cDoc="FAT"
	dbSetOrder(3)
	seek xfilial()+SD2->(D2_DOC+D2_ITEM)
EndCase
if !eof() .and. rlock()
	delete
endif

Reclock("SZ0",lTipo)

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
SZ0->Z0_QTDE := nQtde
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
//SZ0->Z0_OBS := cOBS
MsUnLock()
/*
SZ0->Z0_CSTSTD := CSTSTD
SZ0->Z0_MGSTD := MGSTD
SZ0->Z0_PERSTD := PERSTD
SZ0->Z0_MGREAL := MGREAL
SZ0->Z0_PERCREAL := PERCREAL
SZ0->Z0_CSTATU := CSTATU
SZ0->Z0_MGATU := MGATU
SZ0->Z0_PERATU := PERATU
SZ0->Z0_CSTSIM := CSTSIM
SZ0->Z0_MGSIM := MGSIM
SZ0->Z0_PERSIM := PERSIM
SZ0->Z0_VALMERC := VALMERC
SZ0->Z0_ICMSST := ICMSST
