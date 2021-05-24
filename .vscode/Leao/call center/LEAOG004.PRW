#include "RwMake.ch"

User Function LEAOG004()

// Reprocessa Call Center

nMgs := nMgR := nMgS1 := nMgS2 := nMgR1 := 0

For n:=1 to len(aCols)

_xAlias     := GetArea()
_nValorTot  := 0
_nPosPrvIpi := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRVIPI" })
_nPosValIpi := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VALIPI" })
_nPosQuant  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_QUANT" })
_nPosPrcTab := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRCTAB" })
_nPosVlrIt  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VLRITEM"})
_nPosBasIcm := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_BASEICM"})
_nPosPrcUni := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VRUNIT" })
_nProd	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO"})
_nQuant     := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_QUANT"  })
_nPosDescto := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_DESC1" })
_nPosValDesc:= aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VALDESC" })
_nPosTes	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_TES"})
_nPosCF	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_CF"})
_nPosStdp := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGSTD"})
_nPosStdv := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGSTDV"})
_nPosMgRP	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGREAL"})
_nPosMgRV	  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_MGREALV"})

nQuant     := aCols[n,_nPosQuant] 
nValliq    := 0
//nAcresc,nVerbAdic,cObs

if !M->ua_oper$'1*2' .or. aCols[n][_nProd]='000001'
	Return
endif
Select SB1
dbSetOrder(1)
Seek xFilial()+aCols[n][_nProd]
Select SB5
dbSetOrder(1)
Seek xFilial()+aCols[n][_nProd]

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
	Return
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

//GetDRefresh() 

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
	aCols[n,_nPosStdp] := nPerc //Percentual
	aCols[n,_nPosMgRp] := nPerc //Percentual
	aCols[n,_nPosMgRV] := nMgReal // Valor

	nMgS1 += aCols[n,_nPosStdv] //sb5->b5_margem*aCols[x,_nPosQuant]       // Margem Std
	nMgS2 += sb5->b5_prv7*aCols[n,_nPosQuant]                              // Custo Std
	nMgS  += aCols[n,_nPosStdv]
	nMgR  += aCols[n,_nPosMgRV]
	nMgR1 += sb5->b5_prv7*aCols[n,_nPosQuant]

Endif  

Next n

if nMgS2 > 0
	m->UA_MGSTD   := (nMgS1/nMgS2)*100
	m->UA_MGREAL  := nMgR/nMgS2*100
endif

m->UA_MGSTDV  := nMgS //nMGI-(nCStd*nQuant) + m->UA_MGSTDV
m->UA_MGREALV := nMgR //nMgReal + m->UA_MGREALV

//GetDRefresh() 

RestArea(_xAlias)

Return(m->UA_ENTRADA)