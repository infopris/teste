#include "rwmake.ch"

User Function CALCUST()   // Programa para Calcular o Custo do produtos baseado na estrutura cadastrada

SetPrvt("AOPERACAO,NLINHA,CPROD")

if select("TRB")<>0
	Select TRB
	use
endif

aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "COMP"    , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "TP"      , "C",02,0})
AADD(aCampos,{ "QTD"     , "N",12,8})
AADD(aCampos,{ "PERDA"   , "N",12,4})
AADD(aCampos,{ "UM"      , "C",02,0})
AADD(aCampos,{ "SIT"     , "C",02,0})
AADD(aCampos,{ "NIV"     , "N",02,0})
AADD(aCampos,{ "VALSTD"	 , "N",15,8})
AADD(aCampos,{ "STD"	 , "N",15,8})
AADD(aCampos,{ "MED"	 , "N",17,8}) // Custo Medio sem Impostos
//AADD(aCampos,{ "ULTVAL"  , "N",12,4})
AADD(aCampos,{ "ULTCUST" , "N",15,8})
AADD(aCampos,{ "ATU" 	 , "N",15,8}) // Custo Atualizado
AADD(aCampos,{ "SIMULAD" , "N",15,8})
AADD(aCampos,{ "FORNECE" , "C",30,0})
AADD(aCampos,{ "ULTCOM"  , "C",10,0})
AADD(aCampos,{ "ULTQTD"  , "N",12,3})
AADD(aCampos,{ "ORDEM"   , "C",06,0})
AADD(aCampos,{ "OK"      , "C",1,0})
AADD(aCampos,{ "STD1"	 , "N",15,8})
AADD(aCampos,{ "MED1"	 , "N",17,8})
AADD(aCampos,{ "ULT1"	 , "N",15,8})
AADD(aCampos,{ "ATU1" 	 , "N",15,8}) // Custo Atualizado
AADD(aCampos,{ "GRUPO"   , "C",4,0})
AADD(aCampos,{ "CODPAI"  , "C",15,0})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp, "TRB", Nil, .F. )
//Index on Cod to &cTemp
IndRegua("TRB", cTemp, "cod", , , "Selecionando Registros...")


Processa( {|| Moldura() } )

Processa( {|| Calc() } )

Select TRB
use
Return

***************************
Static Function Calc()
***************************

Select SG1
dbSetOrder(1)
n:=1
//set filter to g1_cod='10245' .or. g1_cod='12.166'  .or. g1_cod='12.169' //.or. g1_cod='12.156'
ProcRegua(reccount())
dbGoTop()
Do while !eof()
	IncProc("1/3")
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+sg1->g1_cod
	if sb1->b1_sitprod='OB' .and. left(b1_cod,2)$'22*26*12' //*29'
		Select SG1
		skip
		loop
	endif
if sg1->g1_cod='39000S'
	x:=1
endif	
	//	if sb1->b1_tipo="RV"
	//		cGrp := sb1->b1_grupo
	//		nCust:= sb1->b1_custd3
	//		nSimul := sb1->b1_cstsim3
	//	else
	cGrp := sb1->b1_grupo
	Seek xFilial()+sg1->g1_comp
	if sg1->g1_comp<>sb1->b1_prodpai .and. !empty(sb1->b1_prodpai) .and. !'*'$b1_prodpai
		cprodPai := sb1->b1_prodpai
		Seek xFilial()+cProdPai
	Endif
//	nCust  := iif(cGrp<'30' .or. cGrp='999',b1_custd,b1_custd3) // Alterado em 30/04 para considerar apenas sem ICMS e sem IPI
	nCust  := b1_custd
//	nSimul := iif(cGrp<'30' .or. cGrp='999',b1_custsim,b1_cstsim3)
	nSimul := b1_custsim
	// Tratamento para produtos com Custo Std específico (compras noutro código ex.: vidro 19.118)
	cComp := sg1->g1_comp
	if at("*",B1_prodpai)<>0
		cComp := left(B1_PRODPAI,at("*",B1_prodpai)-1)
		cComp := cComp+space(15-len(cComp))
		Seek xFilial()+cComp
	endif
	//	endif
	Select SB2
	dbSetOrder(1)
//	Seek xFilial()+sg1->g1_comp+sb1->b1_locpad
	Seek xFilial()+cComp+sb1->b1_locpad
	if eof()
		Seek xFilial()+sb1->b1_prodpai
	endif
	if sb2->b2_cmff3=0 .and. sb2->b2_cmff4=0
//		Seek xFilial()+sg1->g1_comp+"  "
		Seek xFilial()+cComp+"  "
	endif
	if sb2->b2_cmff3=0 .and. sb2->b2_cmff4=0
		Seek xFilial()+sb1->b1_prodpai+"02"
	endif
	Select TRB
	RecLock("TRB",.t.)
	trb->Cod    := sg1->g1_cod
	trb->CodPai := sb1->b1_prodpai
	trb->Comp   := sg1->g1_comp
	trb->Desc   := sb1->b1_desc
	trb->Tp	  	:= sb1->b1_tipo
	trb->Qtd    := sg1->g1_quant
	trb->Perda  := sg1->g1_perda
	trb->Um     := sb1->b1_um
	trb->Sit    := sb1->b1_sitprod
	trb->Niv    := 1
	trb->Ordem  := strzero(n,4)
	trb->valstd	:= nCUST
	trb->std	:= nCUST*Qtd*(1+Perda/100)
	trb->med	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff4,sb2->b2_cmff2)*Qtd*(1+Perda/100)
	//		trb->ultval 	:= SB1->B1_UPRC*Qtd*(1+Perda/100)
	trb->ultcust	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff5,sb1->b1_XUPRCSI)*Qtd*(1+Perda/100) //SB2->B2_CMFF5*Qtd*(1+Perda/100)
	trb->simulad	:= nSimul*Qtd*(1+Perda/100) // iif(cGrp<'30' .or. cGrp='999',SB1->B1_CUSTSIM,SB1->B1_CSTSIM2)*Qtd*(1+Perda/100)
	//		trb->atu		:= iif(med>ultval,med,ultval)
	//trb->atu		:= iif(cGrp<'30' .or. cGrp='999',sb1->b1_cstatu,sb1->b1_cstatu2)*Qtd*(1+Perda/100)
	trb->atu		:= sb1->b1_cstatu*Qtd*(1+Perda/100)
	if trb->atu = 0  // Buscar o custo std caso não encontre custo anterior
		trb->atu := TRB->STD
	endif
	trb->ultcom 	:= dtoc(SB1->B1_UCOM)
	trb->ultqtd 	:= SB1->B1_ULTQTD
	trb->STD1		:= NCUST
	trb->MED1		:= iif(sb2->b2_cmff4<1000000,sb2->b2_cmff4,0)
	trb->ULT1		:= sb2->b2_cmff5
	trb->atu1		:= iif(trb->Med1 > trb->Ult1,trb->Med1,trb->Ult1)//sb1->b1_cstatu
//	trb->MED1		:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff4,sb2->b2_cmff2)
//	trb->ULT1		:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff5,sb1->b1_XUPRCSI)
//	trb->atu1		:= iif(cGrp<'30' .or. cGrp='999',sb1->b1_cstatu,sb1->b1_cstatu2)
	trb->grupo	 	:= cGrp
	MsUnLock()
	n:=n+1
	Select SG1
	Skip
Enddo
Select TRB
ProcRegua(reccount())
dbGoTop()
Do while !eof() .and. 1==2  // Cancelei  para executar o cálculo das molduras separadamente
	IncProc("2/3 - Cálculo do 2.Nível")
	cCod  := trb->Cod
	cComp := trb->Comp
	if cCod=cComp 
		skip
		loop
	endif
	nQtd1 := trb->qtd*(1+trb->perda/100)
	cOrdem:= trim(trb->Ordem)
	nNiv  := 2
	nReg := recno()
	Select SG1
	dbSetOrder(1)
	seek xfilial()+trim(cComp)
	if !eof()
		Select TRB
		if rlock()
			repl niv with 2
			repl ordem with trim(ordem)+"XX"
		endif
		Select SG1
	endif
	Do while !eof() .and. sg1->g1_cod == cComp
		if sg1->G1_Cod=sg1->G1_Comp
			skip
			loop
		endif
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod
		cGrp := sb1->b1_grupo
		Seek xFilial()+sg1->g1_comp
//		nCust  := iif(cGrp<'30' .or. cGrp='999',b1_custd,b1_custd3)
		nCust  := b1_custd
//		nSimul := iif(cGrp<'30' .or. cGrp='999',b1_custsim,b1_cstsim3)
		nSimul := b1_custsim
		Select SB2
		dbSetOrder(1)
		Seek xFilial()+sg1->g1_comp+sb1->b1_locpad
		if eof()
			Seek xFilial()+sb1->b1_prodpai
		endif
		if sb2->b2_cmff3=0 .and. sb2->b2_cmff4=0
			Seek xFilial()+sg1->g1_comp+"  "
		endif
		Select TRB
		nReg1 := recno()
		RecLock("TRB",.t.)
		trb->Cod    := cCod
		trb->Comp   := sg1->g1_comp
		trb->Desc   := sb1->b1_desc
		trb->Tp	    := sb1->b1_tipo
		trb->Qtd    := sg1->g1_quant
		trb->Perda  := sg1->g1_perda
		trb->Um     := sb1->b1_um
		trb->Sit    := sb1->b1_sitprod
		trb->Niv    := 1
		trb->Ordem  := cOrdem+strzero(nNiv,2)
		trb->std	:= nCust*Qtd*(1+Perda/100)*nQtd1
		trb->med	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff4,sb2->b2_cmff3)*Qtd*(1+Perda/100)*nQtd1
		//			trb->ultval 	:= SB1->B1_UPRC*Qtd*(1+Perda/100)*nQtd1
		trb->ultcust	:= SB2->B2_CMFF5*Qtd*(1+Perda/100)*nQtd1
		trb->simulad	:= nSimul*Qtd*(1+Perda/100)*nQtd1 //iif(cGrp<'30' .or. cGrp='999',SB1->B1_CUSTSIM,SB1->B1_CSTSIM2)*Qtd*(1+Perda/100)*nQtd1
		//			trb->atu	:= iif(med>ultval,med,ultval)
		trb->atu	:= sb1->b1_cstatu
		//trb->atu		:= iif(cGrp<'30' .or. cGrp='999',sb1->b1_cstatu,sb1->b1_cstatu2)*Qtd*(1+Perda/100)
		if trb->atu = 0  // Buscar o custo std caso não encontre custo anterior
			trb->atu := TRB->STD
		endif
		trb->ultcom 	:= dtoc(SB1->B1_UCOM)
		trb->ultqtd 	:= SB1->B1_ULTQTD
		MsUnLock()
		Select SG1
		skip
	Enddo
	Select TRB
	goto nReg
	Skip
Enddo
//copy to \x.dbf
//return

// Alteração (26/10/2017) - Agrupa nível 2 no nivel 1
Select TRB
cTemp1 := CriaTrab(nil,.f.)
//index on cod+ordem to &cTemp1
IndRegua("TRB", cTemp1, "cod+ordem", , , "Selecionando Registros...")

Do while !eof()
	ProcRegua(reccount())
	dbGoTop()
	Do while !eof()
		cProd := trb->Cod
		if cProd='2503'
			x:=1
		endif
		tstd 	:= 0
		tmed	:= 0
		tatu	:= 0
		
		tultval 	:= 0
		tultcust	:= 0
		tsimulad	:= 0
		Do while !eof() .and. trb->cod==cProd
			IncProc("2/3 - Eliminando subnível")
			if trb->niv<>2 .and. substr(ordem,5,2)='  '
				skip
				loop
			endif
			nChave := COD +left(ORDEM,4)
			do while COD+left(ordem,4) = nChave
				if rlock() .and. substr(ordem,5,2)<>'  ' .and. substr(ordem,5,2)<>'XX'
					trb->Niv:=3
					tstd += std
					tmed += med
					tatu += atu
					tultcust+= ultcust
					tsimulad+= simulad
				else
					if trb->niv=2
						RecLock("TRB",.f.)
						trb->std	 := tstd
						trb->med	 := tmed
						trb->atu	 := tatu
						trb->ultcust := tultcust
						trb->simulad := tsimulad
						MsUnLock()
					endif
				endif
				skip
			enddo
		Enddo
	Enddo
Enddo

Select TRB
cTemp1 := CriaTrab(nil,.f.)
copy stru to &cTemp1
dbUseArea( .T.,,cTemp1, "TRB1", Nil, .F. )
cTemp2 := CriaTrab(nil,.f.)

Select TRB
ProcRegua(reccount())
dbGoTop()
Do while !eof()
	cProd := trb->Cod
	tstd 	:= 0
	tmed	:= 0
	tatu	:= 0
	tultval 	:= 0
	tultcust	:= 0
	tsimulad	:= 0
	
	Do while !eof() .and. trb->cod==cProd
		IncProc("3/3 - Totalizando")
		if trb->niv<>2
			tstd += std
			tmed += med
			tatu += atu
			//			tultval += ultval
			tultcust+= ultcust
			tsimulad+= simulad
		endif
		Select TRB
		skip
	Enddo
	Select SB1
	dbSetOrder(1)
	seek xfilial()+cProd
	if !eof()
		if !rlock()
			x:=1
		endif
		RecLock("SB1",.f.)
		sb1->b1_xuprcsi := tultcust
		MsUnLock()
	endif
	
	Select SB2
	dbSetOrder(1)
	Seek xFilial()+sb1->(b1_cod+b1_locpad)
	if eof()
		Seek xFilial()+sb1->b1_cod
	endif
	Seek xFilial()+cProd
	if eof()
		RecLock("SB2",.t.)
		sb2->b2_filial 	:= xFilial()
		sb2->b2_cod 	:= cProd
		MsUnLock()
	endif
	if !eof()
		RecLock("SB2",.f.)
		sb2->b2_cmff3 := tmed
		sb2->b2_cmff4 := tmed
		sb2->b2_cmff5 := tultcust
		MsUnLock()
	endif
	
	Select SB5
	dbSetOrder(1)
	seek xfilial()+cProd
	if !eof() 
		reclock("SB5",.F.)
		sb5->B5_prv7	:= tstd
		sb5->B5_CustSim	:= tsimulad
		sb5->B5_cmsipi	:= iif(tmed<1000000,tmed,0)
		sb5->B5_cmsimp	:= 0
		sb5->B5_cstatu	:= tatu
		MsUnLock()
	endif
	Select TRB1
	RecLock("TRB1",.t.)
	trb1->Cod 	:= trim(cProd)
	trb1->Comp	:= " Total"
	trb1->Desc  	:= "TOTAL"
	trb1->Niv	  	:= 1
	trb1->std 	:= tstd
	trb1->med	:= tmed
	//		trb1->ultval 	:= tultval
	trb1->ultcust	:= tultcust
	trb1->atu	:= tatu
	trb1->simulad	:= tsimulad
	trb1->Ordem		:= "TOTAL"
	MsUnLock()
	Select TRB
Enddo
Select TRB1
use
Select TRB
appe from &cTemp1
cTemp2 := CriaTrab(nil,.f.)
//index on cod+ordem to &cTemp2
IndRegua("TRB", cTemp2, "cod+ordem", , , "Selecionando Registros...")

copy to \gerencia\estruturas for niv<3
//copy to \gerencia\est

//MsgBox("Arquivo gravado (abrir com o Excel) : \Estruturas.dbf","Atencao","ALERT")
Return

/*
dbUseArea( .T.,,"\cstd1.dbf", "TRB", Nil, .F. )
do while !eof()
Select SB1
seek xFilial()+trb->ref
if !eof() .and. rlock()
replace b1_custd  with trb->stdsimp //sicmssipi
replace b1_custd3 with trb->sicmcipi //sicmscipi
replace b1_custsim with trb->cicmcipi //sicmssipi
replace b1_cstsim2 with trb->cicmsipi //sicmscipi
endif
select trb
skip
enddo
use
return
*/

***************************
Static Function Moldura()
***************************

Select SG1
dbSetOrder(1)
n:=1
dbGoTop()
Seek xFilial()+"12"
ProcRegua(reccount())
Do while !eof() .and. g1_cod="12"
	IncProc("Cálculo de Molduras")
	cCod := sg1->g1_cod
	nStd01 := nStd02 := nAtu01 := nAtu02 := 0
	IF left(cCOD,6)='19.017'
		x:=1
	ENDIF
	do while ! eof() .and. g1_cod=cCod
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+sg1->g1_cod
		cGrp := sb1->b1_grupo
		Seek xFilial()+sg1->g1_comp
		nCust  := b1_custd
		nCust1 := b1_custd // b1_custd3
		nSimul := b1_custsim
		nSimul1:= b1_custsim // b1_cstsim3
		nAtu   := b1_cstatu
		nAtu1  := b1_cstatu2
		Select SB2
		dbSetOrder(1)
		Seek xFilial()+sg1->g1_comp+sb1->b1_locpad
		if eof()
			Seek xFilial()+sb1->b1_prodpai
		endif
		if sb2->b2_cmff3=0 .and. sb2->b2_cmff4=0
			Seek xFilial()+sg1->g1_comp+"  "
		endif
		if sb2->b2_cmff3=0 .and. sb2->b2_cmff4=0
			Seek xFilial()+sb1->b1_prodpai+"02"
		endif
		Select TRB
		RecLock("TRB",.t.)
		trb->Cod    := sg1->g1_cod
		trb->Comp   := sg1->g1_comp
		trb->Desc   := sb1->b1_desc
		trb->Tp	  	:= sb1->b1_tipo
		trb->Qtd    := sg1->g1_quant
		trb->Perda  := sg1->g1_perda
		trb->Um     := sb1->b1_um
		trb->Sit    := sb1->b1_sitprod
		trb->Niv    := 1
		trb->Ordem  := strzero(n,4)
		trb->valstd	:= nCUST
		trb->std	:= nCUST*Qtd*(1+Perda/100)
		trb->std1	:= nCUST*Qtd*(1+Perda/100) //sb1->b1_custd3*Qtd*(1+Perda/100)
		trb->med	:= sb2->b2_cmff4*Qtd*(1+Perda/100)
		//trb->med	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff4,sb2->b2_cmff3)*Qtd*(1+Perda/100)
		//		trb->ultval 	:= SB1->B1_UPRC*Qtd*(1+Perda/100)
		trb->ultcust	:= sb2->b2_cmff5*Qtd*(1+Perda/100) //SB2->B2_CMFF5*Qtd*(1+Perda/100)
		//trb->ultcust	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff5,sb1->b1_XUPRCSI)*Qtd*(1+Perda/100) //SB2->B2_CMFF5*Qtd*(1+Perda/100)
		trb->simulad	:= nSimul*Qtd*(1+Perda/100) // iif(cGrp<'30' .or. cGrp='999',SB1->B1_CUSTSIM,SB1->B1_CSTSIM2)*Qtd*(1+Perda/100)
		//		trb->atu		:= iif(med>ultval,med,ultval)
		trb->atu		:= sb1->b1_cstatu*Qtd*(1+Perda/100)  // Sem IPI (espelhos)
		trb->atu1		:= sb1->b1_cstatu*Qtd*(1+Perda/100)  // com IPI (quadros)
		//trb->atu1		:= sb1->b1_cstatu2*Qtd*(1+Perda/100) // com IPI (quadros)
		if trb->atu = 0  // Buscar o custo std caso não encontre custo anterior
			trb->atu := TRB->STD
		endif
		trb->ultcom 	:= dtoc(SB1->B1_UCOM)
		trb->ultqtd 	:= SB1->B1_ULTQTD
		MsUnLock()
		nStd01 += trb->Std
		nStd02 += trb->Std1
		nAtu01 += trb->Atu
		nAtu02 += trb->Atu1
		n:=n+1
		Select SG1
		Skip
	Enddo
	Select SB1
	seek xFilial()+cCod
	RecLock("SB1",.f.)
	sb1->B1_CSTATU	:= nAtu01 // Sem Ipi
	sb1->B1_CSTATU2	:= nAtu02 // Com Ipi
	sb1->B1_CUSTD	:= nStd01
	sb1->B1_CUSTD3	:= nStd02
	MsUnLock()
	Select SB2                  
	dbSetOrder(1)
	Seek xFilial()+sb1->B1_cod
	RecLock("SB2",.f.)
	sb2->b2_cmff4	:= nAtu01 // Sem Ipi
	sb2->b2_cmff2	:= nAtu02 // Com Ipi
	MsUnLock()
	Select SG1
Enddo
