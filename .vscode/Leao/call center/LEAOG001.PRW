#include "RwMake.ch"

User Function LEAOG001(_nValor)

// GATILHO DOS CAMPOS UB_DESC E UB_DESC1 E UB_VRUNIT

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
//local _nPosMgStdp := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MARGSTD"})
local _nPosStdp := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGSTD"})
local _nPosStdv := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGSTDV"})
local _nPosMgRP	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGREAL"})
local _nPosMgRV	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGREALV"})
//local _nPosValV	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VALM2"})

Public nQuant     := aCols[n,_nPosQuant] 
Public nValliq    := 0
Public nAcresc,nVerbAdic,cObs


if !M->ua_oper$'1*2' .or. aCols[n][_nProd]='000001'
	Return
endif

// Verifica se o produto tem substituicao tributaria e altera o TES e caclula o IVA
nIva := 0
if sb1->b1_picmret<>0 .and. sa1->a1_est$"SP*MG*RS" .and. left(sa1->a1_inscr,4)<>"ISEN" .and. sa1->a1_tipo=="S"
	nIva := SB1->B1_PICMRET
	nIcm := 18
	if sa1->a1_est <>"SP"
		Select SF7
		dbgotop()
		do while !eof() .and. f7_est <> sa1->a1_est
			skip
		enddo
		nIcm := 12
		nIva := f7_margem
	endif
	aCols[n,_nPosTes] :=  "550"
endif

// Verifica se o produto eh PJ (contribuinte) e altera CFOP
if trim(aCols[n,_nPosCF]) = "6107" .and. SA1->A1_PESSOA='J' .and. SA1->A1_CONTRIB$" *1"
	aCols[n,_nPosCF] = left(aCols[n,_nPosCF],1)+substr(SF4->F4_CF,2,3)
endif

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

if left(M->UA_CONDPG,3)=space(3)
	MsgBox ("FAVOR CADASTRAR COND.DE PAGTO","Informa‡Æo","INFO")
endif

// Grava Margens Std e Real em Valor e Percentual

nQuant := aCols[n,_nPosQuant] 
nVlPed  := 	aCols[n,_nPosVlrIt]
nValLiq :=0
cCod  := aCols[n][_nProd]
if at(".",aCols[n][_nProd])<>0
	cCod1 := left(aCols[n][_nProd],at(".",aCols[n][_nProd])-1)
else
	cCod1 := left(aCols[n][_nProd],6)
endif
cTes  := aCols[n,_nPosTes]
nMgReal := nPerc := nValliq := npercstd  := 0
cObs := "Call Center"
nAcresc   := 5
nVerbAdic := sa1->a1_mgextra

//u_CalcImp("PED")
u_CalcVLiq(Alltrim(m->ua_setor),nVlPed,cCod1,cCod,m->(ua_cliente+ua_loja),cTes,M->UA_CONDPG,"N",m->ua_vend,"CAL"," "," ",nQuant)

Select SB5
seek xFilial()+cCod1
nQuant := aCols[n,_nPosQuant]
nCStd := sb5->b5_prv7
nMarg := sb5->b5_margem
nMGI  := nMarg * nQuant 
if nCStd<>0
	npercstd  := nMGI/(nCStd*nQuant)*100
endif
// Gravação da Margem Std
aCols[n,_nPosStdp] := npercstd
aCols[n,_nPosStdv] := sb5->b5_margem*nQuant

//If M->UA_XVALM2<>0
//	aCols[n,_nPosValV] := M->UA_XVALM2
//Endif
 
GetDRefresh() 

if nCstd#0
	if !empty(sb1->b1_base)
		nMed := val(substr(sb1->b1_cod,7,4))/1000*val(substr(sb1->b1_cod,12,4))/1000
		nCstd := nCstd*nMed 
	else
		nMed := 1
	endif
	nMgreal := nValLiq-(nCstd*nQuant)///1.05

	nMg := nMgReal/(nCstd*nQuant) //nMgReal*1.05/(nCstd*nQuant)
	
	if nMg>(-100) .and. nMg<999.99
		nPerc	:= nMG*100
	endif
// Gravação da Margem Real
	aCols[n,_nPosMgRp] := nPerc
	aCols[n,_nPosMgRV] := nMgReal
Endif  

nMgs := nMgR := nMgS1 := nMgS2 := nMgR1 := 0
For x:=1 to len(aCols)
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+(aCols[n][_nProd])
	if !empty(sb1->b1_base)
		cCodx := left(aCols[n][_nProd],6)
	else
		cCodx := left(aCols[x,_nProd],at(".",aCols[x,_nProd])-1)
	endif
	Select SB5
	//cCodx := left(aCols[x,_nProd],at(".",aCols[x,_nProd])-1)
	seek xFilial()+cCodx
//	if eof() // cCn=x
//		exit
//	endif
	// Para margem Std busca-se somente os valores da margem e valor cadastrados no SB5
	nMgS1 += aCols[x,_nPosStdv] //sb5->b5_margem*aCols[x,_nPosQuant]       // Margem Std
	nMgS2 += sb5->b5_prv7*aCols[x,_nPosQuant]                              // Custo Std
	nMgS  += aCols[x,_nPosStdv]
	nMgR  += aCols[x,_nPosMgRV]
	nMgR1 += sb5->b5_prv7*aCols[x,_nPosQuant]

Next x
if nMgS2 > 0
	m->UA_MGSTD   := (nMgS1/nMgS2)*100
	m->UA_MGREAL  := nMgR/nMgS2*100
endif

m->UA_MGSTDV  := nMgS2 //nMGI-(nCStd*nQuant) + m->UA_MGSTDV
m->UA_MGREALV := nMgR //nMgReal + m->UA_MGREALV

GetDRefresh() 

/*
@ 000,000 TO 070,250 DIALOG oDlg TITLE "Margem"

@ 05,005 SAY "Margem:"  SIZE 30,10
@ 05,055 say nMgReal Picture "@E 999,999.99"  //SIZE 50,20

@ 20,005 SAY "Perc.:"  SIZE 30,10
@ 20,055 SAY nPerc	 Picture "@E 999,999.99" // SIZE 50,20

@ 015,090 BMPBUTTON TYPE 1 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTER
*/
if m->ua_calcprc=="S"
	cProd := left(aCols[n][_nProd],at(".",aCols[n][_nProd])-1)
	cProd1:= aCols[n][_nProd]
	if left(cProd,1)=="0"
		if left(b1_codbar,1)=='2'
			cProd := left(sb1->b1_codbar,7)
		else
			cProd := '1'+substr(cProd,2,3)
		endif
	endif
	dbSelectArea("SE4")                   // Verifica cond.pagto
	dbSetOrder(1)
	if left(M->UA_CONDPG,3)=space(3)
		MsgBox ("FAVOR CADASTRAR COND.DE PAGTO","Informa‡Æo","INFO")
	endif
	dbSeek(xFilial()+M->UA_CONDPG)
	_cPagto := se4->e4_indefla
	
	Select SB5
	dbSetOrder(1)
	Seek xFilial()+cProd
	nPrcVen := 0
	Do case
		Case _cPagto == "A"  // A Vista
			nPrcVen := sb5->b5_prv2
		Case _cPagto == "B"  // 14 dd
			nPrcVen := sb5->b5_prv3
		Case _cPagto == "C"  // 30 dd
			nPrcVen := sb5->b5_prv4
		Case _cPagto == "D"  // 45 dd
			nPrcVen := sb5->b5_prv5
		Case _cPagto == "E" .or. _cPagto == "F" .or. _cPagto == "G" // 60,75,90 dd
			nPrcVen := sb5->b5_prv6
	EndCase
	do Case
		Case sa1->a1_est=="SP" .or. (right(sa1->a1_cgc,1)==" " .and. val(sa1->a1_cgc)#0)
			nPrcVen := nPrcVen * .50
			if Substr(m->ua_setor,1,1) # "C"
				nPrcVen := nPrcVen * .90
			Endif
		Case sa1->a1_est$"RJ*MG*RS*SC*PR"
			nPrcVen := nPrcVen * .46
			if Substr(m->ua_setor,1,1) # "C"
				nPrcVen := nPrcVen * .92
			Endif
		Otherwise
			nPrcVen := nPrcVen * .43
			if Substr(m->ua_setor,1,1) # "C"
				nPrcVen := nPrcVen * .93
			Endif
	endcase
	//if Substr(_cRepres,1,1) == "S"
	//  nPrcVen := nPrcVen * ((100-sa3->a3_comis)/100)
	//endif
//	if sa3->a3_comis<=3
//	if sa3->a3_comis>=3
//		nPrcVen := nPrcVen * .95
//		nPrcVen := nPrcVen*1.05
//	endif
	if Substr(m->ua_tpfrete,1,1)=="C"
		Do case
			Case sa1->a1_est$"BA*PE"       
					nPrcVen := nPrcVen*1.09
			Case sa1->a1_est$"CE"
				if "SOBRAL"$sa1->a1_mun
					nPrcVen := nPrcVen*1.11
				else
					nPrcVen := nPrcVen*1.10
				endif
			Case sa1->a1_est$"RJ"
				nPrcVen := nPrcVen*1.065
			Case sa1->a1_est$"SP*MG"
				nPrcVen := nPrcVen*1.06
			Otherwise
				nPrcVen := nPrcVen*1.15
		EndCase
	Endif
	//MsgBox (str(_nPosDescto),"Informa‡Æo","INFO")
	nValDesc := (100-aCols[n,_nPosDescto])/100
	if nValDesc#0
		nPrcVen := nPrcVen*nValDesc
	endif
	aCols[n,_nPosPrcTab] := nPrcVen
	aCols[n,_nPosPrcUni] := nPrcVen
	_nValSt := 0
	IF Substr(m->ua_setor,1,1) == "A"
		
		_nIpi   := SB1->B1_IPI / 2
		_nValIPI:= nPrcVen + (nPrcVen * _nIpi) / 100
		aCols[n,_nPosValIpi] := _nValIpi
		aCols[n,_nPosPrvIpi] :=  aCols[n,_nPosQuant] * _nValIpi
		if nIva <> 0
			_nValST := (_nValIPI * (1+(nIva/2)/ 100))*(nIcm/100) - (nPrcVen*(nIcm/100))
		endif
	ElseIF Substr(m->ua_setor,1,1) == "B"
		
		_nIpi   := (SB1->B1_IPI * 20) / 100
		_nValIpi:= nPrcVen+ (nPrcVen* _nIpi) / 100
		aCols[n,_nPosValIpi] := _nValipi
		aCols[n,_nPosPrvIpi] :=  aCols[n,_nPosQuant] * _nValipi
	ElseIF Substr(m->ua_setor,1,1) == "S"
		
		_nIpi   := 0
		_nValIpi:= _nValor
		aCols[n,_nPosValIpi] := _nValipi
		aCols[n,_nPosPrvIpi] :=  aCols[n,_nPosQuant] * _nValipi
		
	Else
		
		_nIpi   := SB1->B1_IPI
		_nValIpi:= nPrcVen+ (nPrcVen* _nIpi) / 100
		aCols[n,_nPosValIpi] := _nValIpi
		aCols[n,_nPosPrvIpi] :=  aCols[n,_nPosQuant] * _nValIpi
		if nIva <> 0
			_nValST := (_nValIPI * (1+(nIva)/ 100))*(nIcm/100) - (nPrcVen*(nIcm/100))
		endif
		
	EndIF
	nValIPI1 := _nValIpi + _nValST
	aCols[n,_nPosValIpi] := nValIpi1
	aCols[n,_nPosPrvIpi] :=  aCols[n,_nPosQuant] * (_nValIpi + _nValST)

	For _nLin := 1 to Len(aCols)
		
		IF !aCols[_nLin,Len(aHeader)+1] .and. cProd1 == aCols[n][_nProd]
			_nValorTot := _nValorTot + aCols[_nLin,_nPosPrvIpi]
		EndIF
		
	Next 
	
	aCols[n,_nPosVlrIt]  := aCols[n,_nPosQuant] * nPrcVen
	aCols[n,_nPosBasIcm] := aCols[n,_nPosQuant] * nPrcVen
	_nValor := _nValIpi
	
	************
Else         // Nao calcula preco
	************
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+m->ua_numSC5
	if !eof() .and. m->ua_numSC5==sc5->c5_numtmk
		m->ua_setor := sc5->c5_fator
	endif
	nValor1 := _nValor
	_nValSt := 0
	IF Substr(m->ua_setor,1,1) == "A"
		
		_nIpi   := SB1->B1_IPI / 2
		_nValor := _nValor + (_nValor * _nIpi) / 100  
		_nValIPI:= _nValor
		if nIva <> 0
			_nValST := (_nValIPI * (1+(nIva/2)/ 100))*(nIcm/100) - (_nValor*(nIcm/100))
		endif
		
	ElseIF Substr(m->ua_setor,1,1) == "B"
		
		_nIpi   := (SB1->B1_IPI * 20) / 100
		_nValor := _nValor + (_nValor * _nIpi) / 100
		_nValIPI:= _nValor
		
	ElseIF Substr(m->ua_setor,1,1) == "S"
		
		_nIpi   := 0
		_nValor := _nValor
		_nValIPI:= _nValor
	
	Else

		_nIpi   := SB1->B1_IPI
		_nValor := _nValor + (_nValor * _nIpi) / 100  
		_nValIPI:= _nValor
		if nIva <> 0
			_nValST := (_nValIPI * (1+(nIva)/ 100))*(nIcm/100) - (_nValor*(nIcm/100))
		endif
		
	EndIF
	
	if _nvalor#0              
		nValIPI1 := _nValIpi + _nValST
		aCols[n,_nPosValIpi] := nValIpi1
		aCols[n,_nPosPrvIpi] :=  aCols[n,_nPosQuant] * (_nValIpi + _nValST)
//		aCols[n,_nPosValIpi] := _nValor
//		aCols[n,_nPosPrvIpi] :=  aCols[n,_nPosQuant] * _nValor
	endif
	
	if nvalor1#0
		aCols[n,_nPosVlrIt]  := aCols[n,_nPosQuant] * nValor1
		aCols[n,_nPosBasIcm] := aCols[n,_nPosQuant] * nValor1
	endif
	
	For _nLin := 1 to Len(aCols)
		
		IF !aCols[_nLin,Len(aHeader)+1]
			_nValorTot := _nValorTot + aCols[_nLin,_nPosPrvIpi]
		EndIF
		
	Next
	
Endif        // Final do Calculo do Preco
*************
/*
MsgBox (str(nPrcVen),"Informa‡Æo","INFO")
@ 006,52 TO 443,505 DIALOG oDlg1 TITLE "Totais"
@ 001,010 TO 60,200
@ 16,015 say "Preco de Venda - "
@ 16,080 say nPrcVen picture "@E 999,999.99"
@ 16,125 say "IpiValor - "
@ 16,155 say _nIpi picture "@E 999,999.99"
@ 28,015 say "Valor - "
@ 28,080 say _nValor picture "@E 999,999.99"
@ 28,125 say "Valor Total - "
@ 28,155 say _nValorTot picture "@E 999,999.99"

@ 58,196 BMPBUTTON TYPE 1 ACTION Close(oDlg1)
*/
RestArea(_xAlias)

Return(_nValor)