#include "RwMake.ch"

User Function LEAOG003(_nValor)
                                                                                           
// GATILHO DOS CAMPOS UB_VRUNIT

Local _xAlias     := GetArea()
Local _nValorTot  := 0
Local _nPosPrvIpi := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRVIPI" })
Local _nPosValIpi := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VALIPI" })
Local _nPosQuant  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_QUANT" })
Local _nPosPrcTab := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRCTAB" })
Local _nPosVlrIt  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VLRITEM"})
Local _nPosBasIcm := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_BASEICM"})
Local _nPosPrcUni := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VRUNIT" })
local _nProd	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO"})
local _nQuant     := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_QUANT"  })
Local _nPosDescto := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_DESC1" })
Local _nPosValDesc:= aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VALDESC" })
local _nPosTes	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_TES"})
local _nPosCF	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_CF"})

Public _cSetor    := m->ua_setor
Public _cTpFrete  := m->ua_tpfrete
Public _cNumPed   := m->ua_numped
Public _dDataEmis := m->ua_emissao
Public _cCli      := m->(ua_cliente+ua_loja)

nQuant := aCols[n,_nPosQuant] 
nVlPed  := 	aCols[n,_nPosVlrIt]
nValLiq :=0
cCod  := aCols[n][_nProd]
cCod1 := left(aCols[n][_nProd],at(".",aCols[n][_nProd])-1)
cTes  := aCols[n,_nPosTes]
nMgReal := nPerc := nValliq := npercstd  := 0

//CalcVLiq1(m->ua_setor,m->(ua_cliente+ua_loja),aCols[n,_nPosTes],m->UA_VEND,aCols[n,_nProd],aCols[n,_nPosVlrIt],m->UA_TIPOCLI,m->UA_EMISSAO,m->ua_tpfrete,m->UA_CONDPG,m->UA_COMIS,aCols[n,_nQuant])
u_CalcVLiq(Alltrim(_cSetor),nVlPed,cCod1,cCod,_cCli,cTes,M->UA_CONDPG,"N",m->ua_vend,"CAL"," "," ",nQuant)

Return _nValor

***************************************************************************************************************
//Static Function CalcVLiq1(cSetor,cCli,cTes,cVend,cProd,nVal,cTIPOCLI,dEmissao,_cTpFrete,cCONDPAG,nComis,nQuant)
***************************************************************************************************************
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
	Case Alltrim(cSetor) == "A"
		nFator := 2
	Case Alltrim(cSetor) == "B"
		nFator := 5
	Case Alltrim(cSetor) == "C"
		nFator := 1
	Case Alltrim(cSetor) == "S"
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
//if sf4->f4_duplic=="N" .or. trb1->c5_tipo$'D*I'
//	cTpVend := "N"
//	Return
//endif

// 1.4 - Dados do item do pedido

Select SA3
dbSetOrder(1)
Seek xFilial()+cVend
cSuper := sa3->a3_super
Seek xFilial()+sa3->a3_super
nComS := sa3->a3_comis
//Seek xFilial()+trb1->c5_vend1
Select SB1
dbSetOrder(1)
Seek xFilial()+cProd

if sf4->f4_ipi=="N"
	nIpi := 0
else
	nIpi := sb1->b1_ipi
endif

//Select SUB
//dbsetOrder(3)
//seek xFilial()+sc6->(c6_num+c6_item)
//Do while !eof() .and. sc6->(c6_num+c6_item)=SUB->(UB_NUMPV+UB_ITEMPV) .and. sub->ub_num<>trb1->C5_NUMTMK
//	skip
//Enddo
nValLiq := nVCpmf := nIcms1 := nIcm   := nIpi1 := 0
nCom1   := nCom2  := nFin1  := nIr    := nValAdic :=  0
nPC     := nTotZFR:= 0
nVlPed  := nVal/nFator
nQtdEnt := nQuant
if ctes$'512*543*559'
	if ctes$'543*559' // Z.Franca = ICMS + PIS + Cofins
		nAliqZF := 0.1065
	else
		nAliqZF := 0.07
	endif
	if nFator#0
		nTotZFR := (nVlPed)*nAliqZF
		nTotZFR := (nVlPed)*nAliqZF
//		nVlPed  := nVal*nFator // nVlPed-nTotZFR  // Luiz - 27/05/2015
	endif
endif

dbSelectArea("SF4")
dbSetOrder(1)
dbSeek(xFilial()+cTes)
GetMV("MV_PCI")
//dbSelectArea("SX6")
//dbSetOrder(1)
//dbSeek(xFilial()+"MV_PCI")
if sf4->f4_cstpis <>"06"
	nPCI  := GetMV("MV_PCI") //Val(Alltrim(SX6->X6_CONTEUD))
else
	nPCI := 0
endif
//dbSeek(xFilial()+"MV_CPMF")
nCPMF := GetMV("MV_CPMF") //Val(Alltrim(SX6->X6_CONTEUD))

// 1 - Calcula precentual do ICMS

dbSelectArea("SA1")
dbSeek(xFilial()+cCli)
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
	//	nBase:= nVlPed*(1+(nIpi)/100)
	nBase:= nVlPed
	nIcm := 18
endif
if sf4->f4_codigo$'536*541*512*519*543*559'
	nBase:= 0
	nIcm := 0
endif
if cTes$'538*518'
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

nValNota := nVlPed
if year(demissao)>=2014
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
dbSeek(xFilial()+cCONDPAG)
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

_cSetor := Alltrim(cSetor)

nValComis := 0
If nComis > 0
	nValComis := ((nVlPed-nFrete)*(nComis+nComS))/100
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
nCom1   := ((((nVlPed- nTotZFR)-nFrete)*nComis)/100)
nCom2   := iif(nCom1#0,((((nVlPed- nTotZFR)-nFrete)*nComS)/100),0)
nValAdic:= (nVlPed-nZFr)*(sa1->a1_mgextra/100)

// Alterei a fórmula em 06-03-2014 antecipei o cálculo do financeiro
nFin1   := (nVlPed- nTotZFR+nIpi1)-((nVlPed- nTotZFR+nIpi1)/nValFin)
nValLiq := nVal - nIcms1 - nCom1 - nCom2 - nFrete - nValAdic - nPC - nIR - nVCpmf - nFin1 - nTotZFR //-nZfr
//nFin1   := nValliq-(nValliq/nValFin) //financeiro abate apos desconto dos impostos
//nValLiq := nValliq - nFin1

Select SB5
Seek xFilial()+left(cProd,at(".",cProd)-1)    
                                                       
nCStd := sb5->b5_prv7 * nQuant
nMgReal:= (nValLiq-nCStd)/(1.05)
nPerc  := (nMgReal/nCStd)*100
/*
	@ 000,000 TO 070,250 DIALOG oDlg TITLE "Margem"
	
	@ 05,005 SAY "Margem:"  SIZE 30,10
	@ 05,055 say nMgReal Picture "@E 999,999.99"  //SIZE 50,20 
	
	@ 20,005 SAY "Perc.:"  SIZE 30,10
	@ 20,055 SAY nPerc	 Picture "@E 999,999.99" // SIZE 50,20
	
	@ 015,090 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	
	ACTIVATE DIALOG oDlg CENTER
*/
Return
                   