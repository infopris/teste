#include "rwmake.ch"

User Function CRIAPROD()   // Programa para criar produtos a partir de cadastros já efetuados

Public cDesc:= ''

cCod := 0
@ 050,01 To 200,500 Dialog Odlg Title "Produto a ser copiado"
@ 003,09 to 100,400
@ 011,11 Say "Cod :"
@ 011,45 GET cCod  Picture "@E 99999" Valid .T.
@ 60,25 BMPBUTTON TYPE 01 ACTION criar()
@ 60,65 BMPBUTTON TYPE 02 ACTION Close(oDlg)
Activate Dialog oDlg Centered

Return

Static Function Criar()

cTmp := CriaTrab(nil,.f.)

Select SB1
dbSetOrder(1)
seek xFilial()+ltrim(str(cCod))
if eof()
	MsgBox("Produto não encontrado , favor verificar","Atencao","ALERT")
endif
nLen := len(ltrim(str(cCod)))
Do while !eof() .and. left(B1_COD,nLen)=ltrim(str(cCod))
	if !left(B1_COD,nLen)+".0"$B1_COD
		skip
		loop
	endif
	cNovoCod := ltrim(str(cCod))+".1"+substr(B1_COD,nLen+3,10)
	nReg := recno()
	Seek xFilial()+cNovoCod
	
	if eof()        
		dbgoto(nReg)
		cPosCR := at(" CR ",b1_desc)
		cDesc  := left(b1_DESC,cPosCR)+substr(B1_DESC,cPosCR+4,30)
		nLen1 :=0
		//		verpos2()
		nLen1 := len(trim(cDesc))
		do while .t.
			cCarac := substr(cDesc,nLen1,1)
			if cCarac < chr(58)
				exit
			endif
			nLen1--
		enddo
		
		do while .t.
			cCarac := substr(cDesc,nLen1,1)
			if cCarac > chr(58)
				exit
			endif
			nLen1--
			if nLen1<0
				exit
			endif
		enddo
		
		cDesc1 :=left(cDesc,nLen1)+"1"+substr(cDesc,nLen1+1,40)
		
		goto nReg
		copy to &cTmp NEXT 1
		dbUseArea( .T.,,cTmp, "cTmp", Nil, .F. )
		RecLock("cTmp",.f.)
		cTmp->B1_COD 	:= cNovoCod
		cTmp->B1_CODITE	:= "1"
		cTmp->B1_DESC	:= cDesc1
		MsUnLock()
		use
		dbSelectArea("SB1")
		Seek xFilial()+cNovoCod
		if eof() 
			append from &cTmp
			reclock("SB1",.f.)
			sb1->B1_COD 	:= cNovoCod
			sb1->B1_CODITE	:= "1"
			sb1->B1_DESC	:= cDesc1
			msunlock()
		endif
	endif
	Select SB1
	goto nReg
	skip
enddo
Close(oDlg)
Return

//Static Function verpos2()

nLen1 := len(trim(cDesc))
do while .t.
	cCarac := substr(cDesc,nLen1,1)
	if cCarac < chr(58)
		exit
	endif
	nLen1--
enddo

do while .t.
	cCarac := substr(cDesc,nLen1,1)
	if cCarac > chr(58)
		exit
	endif
	nLen1--
	if nLen1<0
		exit
	endif
enddo
return

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
AADD(aCampos,{ "VALSTD"	 , "N",12,4})
AADD(aCampos,{ "STD"	 , "N",12,4})
AADD(aCampos,{ "MED"	 , "N",12,4}) // Custo Medio sem Impostos
//AADD(aCampos,{ "ULTVAL"  , "N",12,4})
AADD(aCampos,{ "ULTCUST" , "N",12,4})
AADD(aCampos,{ "ATU" 	 , "N",12,4}) // Custo Atualizado
AADD(aCampos,{ "SIMULAD" , "N",12,4})
AADD(aCampos,{ "FORNECE" , "C",30,0})
AADD(aCampos,{ "ULTCOM"  , "C",10,0})
AADD(aCampos,{ "ULTQTD"  , "N",12,3})
AADD(aCampos,{ "ORDEM"   , "C",06,0})
AADD(aCampos,{ "OK"      , "C",1,0})
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp, "TRB", Nil, .F. )
//Index on Cod to &cTemp
IndRegua("TRB", cTemp, "Cod", , , "Selecionando Registros...")


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
//set filter to g1_cod='2207' //.or. g1_cod='12.156'
ProcRegua(reccount())
dbGoTop()
Do while !eof()
	IncProc("1/3")
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+sg1->g1_cod
	if sb1->b1_sitprod='OB' .and. left(b1_cod,2)$'22*26*29'
		Select SG1
		skip
		loop
	endif
	if sg1->g1_cod='10143'
		x:=1
	endif
	if sb1->b1_tipo="RV"
		cGrp := sb1->b1_grupo
		nCust:= sb1->b1_custd3
		nSimul := sb1->b1_cstsim3
	else
		cGrp := sb1->b1_grupo
		Seek xFilial()+sg1->g1_comp
		nCust  := iif(cGrp<'30' .or. cGrp='999',b1_custd,b1_custd3)
		nSimul := iif(cGrp<'30' .or. cGrp='999',b1_custsim,b1_cstsim3)
	endif
	Select SB2
	dbSetOrder(1)
	Seek xFilial()+sg1->g1_comp+sb1->b1_locpad
	Select TRB
	RecLock("TRB",.t.)
	//		appe blan
	trb->Cod    := sg1->g1_cod
	trb->Comp   := sg1->g1_comp
	trb->Desc   := sb1->b1_desc
	trb->Tp	  	:= sb1->b1_tipo
	trb->Qtd    := sg1->g1_quant
	trb->Perda  := sg1->g1_perda
	trb->Um     := sb1->b1_um
	trb->Sit    := sb1->b1_sitprod
	trb->Niv    := 1
	trb->Ordem  := strzero(n,3)
	trb->valstd	:= nCUST
	trb->std	:= nCUST*Qtd*(1+Perda/100)
	trb->med	:= iif(cGrp<'30' .or. cGrp='999',sb2->b2_cmff4,sb2->b2_cmff3)*Qtd*(1+Perda/100)
	//		trb->ultval 	:= SB1->B1_UPRC*Qtd*(1+Perda/100)
	trb->ultcust	:= SB2->B2_CMFF5*Qtd*(1+Perda/100)
	trb->simulad	:= nSimul*Qtd*(1+Perda/100) // iif(cGrp<'30' .or. cGrp='999',SB1->B1_CUSTSIM,SB1->B1_CSTSIM2)*Qtd*(1+Perda/100)
	//		trb->atu		:= iif(med>ultval,med,ultval)
	trb->atu		:= iif(med>ultcust,med,ultcust)
	trb->ultcom 	:= dtoc(SB1->B1_UCOM)
	trb->ultqtd 	:= SB1->B1_ULTQTD
	MsUnLock()
	n:=n+1
	Select SG1
	Skip
Enddo
Select TRB
ProcRegua(reccount())
dbGoTop()
Do while !eof()
	IncProc("2/3 - Cálculo do 2.Nível")
	cCod  := trb->Cod
	cComp := trb->Comp
	if cCod=cComp
		skip
		loop
	endif
	nQtd1 := trb->qtd*(1+trb->perda/100)
	cOrdem:= trim(trb->Ordem)
	//	nNiv  := Niv+1
	nNiv  := 2
	nReg := recno()
	Select SG1
	dbSetOrder(1)
	seek xfilial()+trim(cComp)
	if !eof()
		Select TRB
		RecLock("trb",.f.)
		repl niv with 2
		MsUnLock()
		Select SG1
	endif
	Do while !eof() .and. sg1->g1_cod == cComp
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
		Select TRB
		nReg := recno()
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
		trb->atu	:= iif(med>ultcust,med,ultcust)
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
copy to \x.dbf
//return

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
		if trb->niv=1
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
	Select SB5
	dbSetOrder(1)
	seek xfilial()+cProd
	if !eof()// .and. rlock()
		RecLock("SB5",.f.)
		sb5->B5_prv7	:= tstd
		sb5->B5_CustSim	:= tsimulad
		sb5->B5_cmsipi	:= tmed
		sb5->B5_cmsimp	:= 0
		sb5->B5_cstatu	:= tatu
		MsunLock()
	endif
	Select TRB1
	RecLock("TRB1",.t.)
	//		appe blan
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
//index on cod+ordem to &cTemp
IndRegua("TRB", cTemp1, "Cod+Ordem", , , "Selecionando Registros...")
copy to \gerencia\estruturas.dbf for niv=1
//MsgBox("Arquivo gravado (abrir com o Excel) : \Estruturas.dbf","Atencao","ALERT")
Return
