#include "rwmake.ch"

User Function BlocoK()   // Programa para Calcular o Custo do produtos baseado na estrutura cadastrada

SetPrvt("AOPERACAO,NLINHA,CPROD")     

if !Pergunte ("INV001",.T.)
	Return
endif


if select("TRB")<>0
	Select TRB
	use
endif

aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "COMP"    , "C",15,0})
AADD(aCampos,{ "PRODUTO" , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "TP"      , "C",02,0})
AADD(aCampos,{ "QTD"     , "N",12,8})
AADD(aCampos,{ "PERDA"   , "N",12,4})
AADD(aCampos,{ "UM"      , "C",02,0})
AADD(aCampos,{ "SIT"     , "C",02,0})
AADD(aCampos,{ "NIV"     , "N",02,0})
AADD(aCampos,{ "VEND"    , "N",12,2})
AADD(aCampos,{ "QTDCMP"	 , "N",12,4})
AADD(aCampos,{ "VALSTD"	 , "N",12,4})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp, "TRB", Nil, .F. )
Index on Cod to &cTemp


Processa( {|| Vendas() } ) //1- Separa Vendas no Mês e explode compon pelas Vendas no Mês
Processa( {|| Entradas() } )//3- Separa Entradas com e sem n
Processa( {|| Resultado() } )//3- Separa Entradas com e sem n

Return

//4- Gera Inventário


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
if sg1->g1_cod='2803.CH'
	x:=1
endif	
	//	if sb1->b1_tipo="RV"
	//		cGrp := sb1->b1_grupo
	//		nCust:= sb1->b1_custd3
	//		nSimul := sb1->b1_cstsim3
	//	else
	cGrp := sb1->b1_grupo
	Seek xFilial()+sg1->g1_comp
	nCust  := iif(cGrp<'30' .or. cGrp='999',b1_custd,b1_custd3)
	nSimul := iif(cGrp<'30' .or. cGrp='999',b1_custsim,b1_cstsim3)
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
	trb->atu		:= iif(cGrp<'30' .or. cGrp='999',sb1->b1_cstatu,sb1->b1_cstatu2)*Qtd*(1+Perda/100)
	if trb->atu = 0  // Buscar o custo std caso não encontre custo anterior
		trb->atu := TRB->STD
	endif
	trb->ultcom 	:= dtoc(SB1->B1_UCOM)
	trb->ultqtd 	:= SB1->B1_ULTQTD
	trb->STD1		:= NCUST
	trb->MED1		:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff4,sb2->b2_cmff2)
	trb->ULT1		:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff5,sb1->b1_XUPRCSI)
	trb->atu1		:= iif(cGrp<'30' .or. cGrp='999',sb1->b1_cstatu,sb1->b1_cstatu2)
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
		nCust  := iif(cGrp<'30' .or. cGrp='999',b1_custd,b1_custd3)
		nSimul := iif(cGrp<'30' .or. cGrp='999',b1_custsim,b1_cstsim3)
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
		//trb->atu	:= iif(med>ultcust,med,ultcust)
		trb->atu		:= iif(cGrp<'30' .or. cGrp='999',sb1->b1_cstatu,sb1->b1_cstatu2)*Qtd*(1+Perda/100)
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
index on cod+ordem to &cTemp1
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
	if !eof() .and. rlock()
		sb5->B5_prv7	:= tstd
		sb5->B5_CustSim	:= tsimulad
		sb5->B5_cmsipi	:= tmed
		sb5->B5_cmsimp	:= 0
		sb5->B5_cstatu	:= tatu
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
index on cod+ordem to &cTemp2
copy to \gerencia\estruturas.dbf for niv<3
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
	IF cCOD='12.141'
		x:=1
	ENDIF
	do while ! eof() .and. g1_cod=cCod
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+sg1->g1_cod
		cGrp := sb1->b1_grupo
		Seek xFilial()+sg1->g1_comp
		nCust  := b1_custd
		nCust1 := b1_custd3
		nSimul := b1_custsim
		nSimul1:= b1_cstsim3
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
		trb->std1	:= sb1->b1_custd3*Qtd*(1+Perda/100)
		trb->med	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff4,sb2->b2_cmff3)*Qtd*(1+Perda/100)
		//		trb->ultval 	:= SB1->B1_UPRC*Qtd*(1+Perda/100)
		trb->ultcust	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff5,sb1->b1_XUPRCSI)*Qtd*(1+Perda/100) //SB2->B2_CMFF5*Qtd*(1+Perda/100)
		trb->simulad	:= nSimul*Qtd*(1+Perda/100) // iif(cGrp<'30' .or. cGrp='999',SB1->B1_CUSTSIM,SB1->B1_CSTSIM2)*Qtd*(1+Perda/100)
		//		trb->atu		:= iif(med>ultval,med,ultval)
		trb->atu		:= sb1->b1_cstatu*Qtd*(1+Perda/100)  // Sem IPI (espelhos)
		trb->atu1		:= sb1->b1_cstatu2*Qtd*(1+Perda/100) // com IPI (quadros)
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

// Vendas
***************************
Static Function Vendas()
***************************

if select("VEND")<>0
	Select VEND
	use
endif

aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "COMP"    , "C",15,0})
AADD(aCampos,{ "PRODUTO" , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "TP"      , "C",02,0})
AADD(aCampos,{ "QTD"     , "N",12,8})
AADD(aCampos,{ "VEND"    , "N",12,2})
AADD(aCampos,{ "PERDA"   , "N",12,4})
AADD(aCampos,{ "UM"      , "C",02,0})
AADD(aCampos,{ "SIT"     , "C",02,0})
AADD(aCampos,{ "NIV"     , "N",02,0})
AADD(aCampos,{ "QTDCMP"	 , "N",12,4})
AADD(aCampos,{ "STD"	 , "N",12,4})
AADD(aCampos,{ "VALSTD"	 , "N",12,4})

cVend := CriaTrab(nil,.f.)
dbCreate(cVend,aCampos)
dbUseArea( .T.,,cVend, "Vend", Nil, .F. )
Index on Cod to &cVend

// Verificar Faturamento

cQuery := " SELECT D2_COD, sum(D2_QUANT) as QUANT "
//cQuery += " CONVERT(VARCHAR(4),DAY(D2_EMISSAO)) + '/' + CONVERT(VARCHAR(3),MONTH(D2_EMISSAO)) + '/' + CONVERT(VARCHAR(4),YEAR(D2_EMISSAO)) AS EMISSAO, "
//cQuery += " D2_EMISSAO,D2_COD,B1_DESC,D2_QUANT,D2_TOTAL,(D2_VALICM+D2_VALISS) AS D2_VALICM,D2_VALIMP5,D2_VALIMP6,D2_CUSTO1,D2_VALTST,D2_VALIPI,D2_ICMSRET,D2_TES,D2_CF,D2_VALFRE,D2_SEGURO,D2_DESPESA,"
//cQuery += " A1_COD,A1_LOJA,A1_NREDUZ,A1_EST,A1_CODPAIS,A1_SATIV1,C5_VEND1,B1_GRUPO2,B1_GRUPO3 AS B1_GRUPO,B1_CONTA,B1_POSIPI,A1_MUN,A1_COD_MUN,A1_BAIRRO,A1_GRPVEN, " //,BM_DESC,BM_SGRUPO,BM_DESCSGR,BM_DIVISAO,BM_DESCDIV "
//cQuery += " D2_PEDIDO,D2_ITEMPV " 
cQuery += " FROM SD2010,SF4010 " // ,SBM010 "
cQuery += " WHERE F4_CODIGO=D2_TES AND (F4_DUPLIC='S') AND "
cQuery += "D2_EMISSAO BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+" AND "
cQuery += " SD2010.D_E_L_E_T_ <>'*' AND SF4010.D_E_L_E_T_ <>'*' "
cQuery += "GROUP BY D2_COD"
cQuery += "ORDER BY D2_COD"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "VEND1", .F., .T.)
cTemp := CriaTrab(nil,.f.)

Select Vend1
dbGoTop()
ProcRegua(reccount())
Do while !eof() 
	IncProc("Vendas no mês")
	Select Vend1
	cRed := left(D2_COD,at(".",D2_COD)-1)
	nQuant :=0            
	cCodProd := D2_COD
	do while !eof() .and. cRed = left(D2_COD,at(".",D2_COD)-1)
		nQuant += QUANT
		skip
	enddo              
	Select SG1
	seek xFilial()+cRed
	cCod := sg1->g1_cod
	do while ! eof() .and. g1_cod=cCod
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+sg1->g1_cod
		cGrp := sb1->b1_grupo
		Seek xFilial()+sg1->g1_comp
		nCust  := b1_custd
		Select Vend
		RecLock("Vend",.t.)
		Vend->Cod    := sg1->g1_cod
		Vend->Comp   := sg1->g1_comp
		Vend->Produto:= cCodProd
		Vend->Desc   := sb1->b1_desc
		Vend->Tp	 := sb1->b1_tipo
		Vend->Vend   := nQuant
		Vend->Qtd    := sg1->g1_quant
		Vend->Perda  := sg1->g1_perda
		Vend->Um     := sb1->b1_um
		Vend->Sit    := sb1->b1_sitprod
		Vend->Niv    := 1
		Vend->valstd := nCUST
		Vend->qtdcmp := nQuant*Qtd*(1+Perda/100)
		Vend->std	 := nCUST*Qtd*(1+Perda/100)
		MsUnLock()
		Select SG1
		Skip
	Enddo
	Select Vend1
Enddo
Select Vend1
use
Select Vend
copy to \xVend
use

return

// Entradas
***************************
Static Function Entradas()
***************************

if select("ENTR")<>0
	Select ENTR
	use
endif

aCampos := {}
AADD(aCampos,{ "COMP"    , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "QTDC"     , "N",12,8})
AADD(aCampos,{ "QTDS"    , "N",12,2})

cEntr := CriaTrab(nil,.f.)
dbCreate(cEntr,aCampos)
dbUseArea( .T.,,cEntr, "Entr", Nil, .F. )

// Verificar entradas

cQuery := " SELECT D1_COD, sum(D1_QUANT) as QUANTSN,sum(d1_custo4) as QUANT  "
cQuery += " FROM SD1010 " // ,SBM010 "
cQuery += " WHERE D1_TES='200' AND "
cQuery += "D1_DTDIGIT BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+" AND "
cQuery += " SD1010.D_E_L_E_T_ <>'*' AND D1_TIPO<>'D'"
cQuery += "GROUP BY D1_COD"
cQuery += "ORDER BY D1_COD"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "ENT1", .F., .T.)
cTempEnt1 := CriaTrab(nil,.f.)
copy to &cTempEnt1
USE 

cQuery := " SELECT D1_COD, sum(D1_QUANT) as QUANT,sum(d1_custo4) as QUANTSN "
cQuery += " FROM SD1010,SF4010 " // ,SBM010 "
cQuery += " WHERE F4_CODIGO=D1_TES AND (F4_DUPLIC='S') AND "
cQuery += " D1_TES<>'200' AND "
cQuery += " D1_DTDIGIT BETWEEN "+DTOS(MV_PAR01)+" AND "+DTOS(MV_PAR02)+" AND "
cQuery += " SD1010.D_E_L_E_T_ <>'*' and SF4010.D_E_L_E_T_ <>'*' AND D1_TIPO<>'D' "
cQuery += "GROUP BY D1_COD"
cQuery += "ORDER BY D1_COD"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "ENT2", .F., .T.)
cTempEnt := CriaTrab(nil,.f.)
copy to &cTempEnt 
use
dbUseArea( .T.,,cTempEnt, "ENTRAD", Nil, .F. )
Append from &cTempEnt1    
dbgotop()        
do while !eof()
	if quant=0 .and. quantsn=0 .and. rlock()
		delete
	endif   
	skip
enddo
copy to \xEnt
use

return

***************************
Static Function Resultado()
***************************

aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "COMP"    , "C",15,0})
AADD(aCampos,{ "PRODUTO" , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",40,0})
AADD(aCampos,{ "TP"      , "C",02,0})
AADD(aCampos,{ "QTD"     , "N",12,8})
AADD(aCampos,{ "PERDA"   , "N",12,4})
AADD(aCampos,{ "UM"      , "C",02,0})
AADD(aCampos,{ "SIT"     , "C",02,0})
AADD(aCampos,{ "NIV"     , "N",02,0})
AADD(aCampos,{ "VEND"    , "N",12,2})
AADD(aCampos,{ "QTDCMP"	 , "N",12,4})
AADD(aCampos,{ "VALSTD"	 , "N",12,4})

cTempR := CriaTrab(nil,.f.)
dbCreate(cTempR,aCampos)
dbUseArea( .T.,,cTempR, "TRBR", Nil, .F. )
Index on Cod to &cTempR

dbUseArea( .T.,,"XVEND", "TRBV", Nil, .F. )
do while !eof()
		cCod := trbv->Cod
		cTempx := CriaTrab(nil,.f.)
		copy to &cTempx neXt 1
		Select TRBR
		append from &cTempx
		seleCt SB5
		Seek xFiLial()+cCod
		Select TrbV
		do while !eof() .and. Cod=cCod
			Skip
		EnDDo
EndDo
