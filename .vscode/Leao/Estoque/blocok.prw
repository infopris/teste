#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF
//#Include "RwMake.ch"

/*
*****************************************************************************
** Funcao     Inventario   Autor   Luiz Eduardo           Data   04.09.2015**
*****************************************************************************
** Descricao  Geracao do arquivo para comprativo do bloco K                **
*****************************************************************************
*/


// Ver parei aki

User Function BLOCOK()


//mv_par01 -> Data de
//mv_par02 -> Data ate

if !Pergunte ("INV002",.T.)
	Return
endif

if select("TRB")<>0
	Select TRB
	use
endif

Processa({|| Inv() })


*********************
Static Function Inv()
*********************

aCampos := {}
AADD(aCampos,{ "OP"        , "C",11,0})
AADD(aCampos,{ "PRODUTO"   , "C",15,0})
AADD(aCampos,{ "DESCRI"    , "C",40,0})
AADD(aCampos,{ "LOCAL"     , "C",02,0})
AADD(aCampos,{ "TM"        , "C",02,0})
AADD(aCampos,{ "UM"        , "C",03,0})
AADD(aCampos,{ "QTD"       , "N",12,2})
AADD(aCampos,{ "CUSTO"     , "N",12,2})


cTempD3 := CriaTrab(nil,.f.)
dbCreate(cTempD3,aCampos)
dbUseArea( .T.,,cTempD3,"TRBD3", Nil, .F. )
Index on op+produto to &cTempD3

Select SD3
dbSetOrder(6)
set softseek on
seek xFilial()+dtos(MV_PAR01)
set softseek off
dbGoTop()
ProcRegua(Reccount())
Do while !eof()
	IncProc("Processando Ordens de Produção")
	if sd3->d3_emissao > MV_PAR02
		exit              
	endif
	if sd3->d3_cf='RE6' .or. sd3->d3_cf='DE6'
		skip
		loop
	endif
	cCod := sd3->D3_COD
	select SB1
	dbSetOrder(1)
	seek xFilial()+cCod
	Select TRBD3
	if sd3->D3_LOCAL="CB"
//		cCod := Parei aki, definir quando o produto terá 4 ou 5 digitos
		nPto1	:= at('.',sb1->b1_cod)
		if nPto1 = 4
			cCod := left(cCod,4)
		else
			cCod := left(cCod,5)
		endif
	endif
//	seek cOp
	select SD3
	RecLock("trbD3",.t.)
	trbd3->OP		:= trim(sd3->D3_OP)
	trbd3->produto	:= cCod
	trbd3->descri	:= sb1->b1_desc
	trbd3->local 	:= sd3->d3_local
	trbd3->tm		:= sd3->d3_tm
	trbd3->um		:= sb1->B1_um
	trbd3->qtd		:= sd3->d3_quant
	trbd3->custo	:= SB1->B1_CUSTD
	Select SD3
	skip
Enddo
select trbd3
copy to \ordens

aCampos := {}
AADD(aCampos,{ "CODRED"    , "C",5,0})
AADD(aCampos,{ "DESC"      , "C",40,0})
AADD(aCampos,{ "TIPO"      , "C",02,0})
AADD(aCampos,{ "UM"        , "C",03,0})
AADD(aCampos,{ "QTDFAT"    , "N",12,2})
AADD(aCampos,{ "VALFAT"    , "N",12,2})
AADD(aCampos,{ "UNITLIQ"   , "N",12,2})
AADD(aCampos,{ "TOTLIQ"    , "N",12,2})
AADD(aCampos,{ "CUSTO"     , "N",12,2})


cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on CODRED to &cTemp

Select SD2
dbSetOrder(5)
set softseek on
seek xFilial()+dtos(MV_PAR01)
set softseek off
Do while !eof() 
	IncProc("Processando Vendas")
	if sd2->d2_emissao > MV_PAR02
		exit              
	endif
	if sd2->d2_local<>"CB"
		skip
		loop
	endif
	Select SF4
	seek xFilial()+sd2->D2_TES
	cTpVend := "S"
	if sf4->f4_duplic=="N" .or. trb1->d2_tipo$'D*I*P*B'
		Select SD2
		cTpVend := "N"
		skip
		loop
	endif
	if substr(sd2->D2_COD,5,1)='.'
		cCod := left(sd2->D2_COD,4)
	else
		cCod := left(sd2->D2_COD,5)
	endif     
	Select SB1
	seek xFilial()+cCod
	Select TRB         
	seek cCod
	RecLock("TRB",eof())
	trb->CodRed := cCod
	trb->Desc   := sb1->B1_DESC
	trb->Tipo   := sb1->B1_tipo
	trb->Um     := sb1->B1_UM
	trb->QtdFat += sd2->D2_quant
	trb->ValFat += sd2->d2_total
	trb->TotLiq :=(sd2->(d2_total-d2_valicm-d2_valimp5-d2_valimp6))
	trb->UnitLiq:= TotLiq/QtdFat
	MsUnLock()
	select SD2
	skip
enddo

select trb
copy to \vendas
Return
/*/Luiz/*/

// Acerta Classificacao Fiscal

Select SD1
dbsetOrder(6)
dbgotop()
set softseek on
seek xFilial()+dtos(firstday(date())-31)
set softseek off
do while !eof() .and. 1=2
	Select SB1
	dbSetOrder(1)
	seek xFilial()+sd1->d1_cod
	Select SF4
	dbSetOrder(1)
	seek xFilial()+sd1->d1_tes
	Select SD1
	if substr(sd1->d1_clasfis,2,1)=" "
		RecLock("SD1",.f.)
		sd1->d1_clasfis := left(sb1->b1_origem,1)+left(sf4->f4_sittrib,2)
		MsUnlock()
	endif
	skip
enddo
return
/*
dbUseArea( .T.,,"\custstd.dbf","ARQ", Nil, .F. )
dbgotop()
do while !eof()
select SB1
seek xFilial()+trim(arq->cod)+" "
if !eof() .and. rlock()
sb1->B1_CUSTD2	:= arq->B1_CUSTD2
sb1->B1_CUSTD	:= arq->B1_CUSTD
sb1->B1_CUSTD3	:= arq->B1_CUSTD3
sb1->B1_CUSTSIM	:= arq->B1_CUSTSIM
sb1->B1_CSTSIM2	:= arq->B1_CSTSIM2
sb1->B1_CSTSIM3	:= arq->B1_CSTSIM3
endif
Select arq
skip
enddo
Return


dbUseArea( .T.,,"\margem1.dbf","ARQ", Nil, .F. )
dbgotop()
do while !eof()
select SB5
seek xFilial()+trim(arq->ref)+" "
if !eof() .and. rlock()
sb5->B5_margem   := arq->margem
else
if rlock()
append blank
sb5->B5_filial   := xFilial()
sb5->B5_cod      := arq->ref
sb5->B5_margem   := arq->margem

endif
endif
Select arq
skip
enddo
Return
*/

if mv_par04=1 // Gerencial busca SB7 - Sped SB9
	vSB9 := .f.
	vSB7 := .t.
else
	vSB9 := .t.
	vSB7 := .f.
endif


nTotal := 0
Processa({|| Finalizando() })
Select TRB
copy to \inv01 for tipo$"PA*RV"
copy to \inv02 for !tipo$"PA*RV"


//Return // Tirar 1=2 xxxxx

Processa({|| TotalizaMP() })

dbUseArea( .T.,,"\inv01.dbf","TRB1", Nil, .F. )
cTemp1 := CriaTrab(nil,.f.)
copy stru to &cTemp1
dbUseArea( .T.,,cTemp1,"TRB2", Nil, .F. )
Select TRB1
dbgotop()
do while !eof()
	select sb1
	seek xFilial()+trb1->cod
	select TRB1
	cPto := at(".",cod)
	if cPto=0
		skip
		loop
	endif
	cCod := left(cod,cpto+3)
	nInv := nQtdComp := nQtdVend := nQtdEnt1 := nQtdEnt2 := nQtdEnt3 := nUnit:= 0
	nAcerto := nSaldo := nEstoque := nTotLiq := nNovaQtd := nPonderado := 0
	nSalGer := nSalSped := 0
	cdt  := ctod("0")
	cnota := ' '
	dult := ' '
	ctpvenda := ' '
	Do while left(cod,cpto+3)=cCod
		//		nInv +=INVENTARIO
		nQtdEnt1  += QTDENT1
		nQtdEnt2  += QTDENT2
		nQtdEnt3  += QTDENT3
		nQtdVend += QTDSAI
		nAcerto 	+= ACERTO
		//		nSaldo 		+= Saldo
		nSalGer 	+= SalGeren
		nSalSped	+= SalSped
		nEstoque 	+= SaldoAtu
		if ctod(datultnf) > cDt
			cNota := ULTNF
			dUlt   := DATULTNF
			nUnit  := UNITLIQ
		endif
		nTotLiq     := nUnit*nEstoque
		if !empty(tpvenda)
			ctpvenda := TPVENDA
		endif
		skip
	enddo
	
	Select TRB2
	cCod1 := cCod
	if sb1->B1_TIPO='PA' .and. left(cCod,1)='1'
		cCod1 := left(sb1->b1_cod,at('.',sb1->b1_cod))+"0"+substr(sb1->b1_cod,at('.',sb1->b1_cod)+2,10)
	else
		cCod1 := left(sb1->b1_cod,4)
	endif
	if rlock()
		appe blan
		trb2->cod	:= cCod
		trb2->codtot:= cCod1
		trb2->codred	:= iif(sb1->b1_tipo$"PA*RV",left(sb1->b1_cod,at('.',sb1->b1_cod)-1),"")
		trb2->desc 	:= sb1->b1_desc
		trb2->loc	:=	sb1->b1_locpad
		trb2->sit	:=	sb1->b1_sitprod
		trb2->tipo	:=	sb1->b1_tipo
		trb2->um	:=	sb1->b1_um
		trb2->ncm	:=	sb1->b1_posipi
		//		trb2->inventario:=	nInv
		trb2->qtdent1	:=	nQtdEnt1
		trb2->qtdent2	:=	nQtdEnt2
		trb2->qtdent3	:=	nQtdEnt3
		trb2->qtdsai	:=	nQtdVend
		trb2->ultnf		:=	cNota
		trb2->datultnf	:=	dult
		trb2->unitliq	:=	nUnit
		trb2->acerto	:=  nAcerto
		trb2->SalGeren 	:=  nSalGer
		trb2->SalSped 	:=  nSalSped
		trb2->SaldoAtu 	:=  nEstoque
		trb2->TotLiq 	:=  nEstoque*nUnit
		trb2->tpvenda	:=  ctpvenda
		trb2->atugeren	:=  nsalger  + nqtdent1 + nqtdent2 + nqtdent3 - nqtdvend
		trb2->atusped 	:=  nsalsped + nqtdent1 - nqtdvend
		
	endif
	
	select TRB1
enddo
use
Select TRB2
copy to \inv03  // Agrupamento desconsiderando a cor do produto

if mv_par04=1
	cTemp2 := CriaTrab(nil,.f.)
	copy stru to &cTemp2
	dbUseArea( .T.,,cTemp2,"TRB3", Nil, .F. )
	
	Select TRB2
	Index on CodRed to &cTemp2
	dbgotop()
	Do while !eof()
		cCodTot := trb2->CodTot
		cCodRed := trb2->CodRed
		cDesc	:= trb2->desc
		if left(cCodTot,4)$'1025*1026*1083'
			X:=1
		endif
		nInv := nSai := nEnt := nEntS := nValEst := nEstq := nAcerto := 0
		nSalGer := nSalSped := nSaldo := 0
		ctpvenda := trb2->tpvenda
		cNota := cNota1 := ''
		dUlt  := dUlt1  := ''
		nUnit := nUnit1 := 0
		lTp1 := lTp2 := .f.
		do while !eof() .and. cCodRed = CodRed
			//			nInv += Inventario
			nSai += QtdSai
			nEnt += QtdEnt1+QtdEnt2+QtdEnt3
			nEntS+= QtdEnt1+QtdEnt3
			nValEst += VALESTQ
			nEstq   += SaldoAtu
			nAcerto += Acerto
			nSalGer	+= SalGeren
			nSalSped+= SalSped
			//			nSaldo  += Saldo
			nTam := len(trim(COD))
			
			// Verificar gravação da última nota
			
			
			Select xD2A
			seek trim(cCodRed)
			if !eof()
				cNota := xD2A->d2_doc
				dUlt  := xd2a->d2_emissao
				nUnit := xd2a->d2_prcven
			else
				Select TRB2
				if cNota < trb2->ultnf
					cNota := trb2->ultnf
					dUlt  := (trb2->datultnf)
					nUnit := trb2->unitliq
				endif
			endif
			Select TRB2
			/*			do case
			case trim(COD)=left(codtot,nTam)
			cNota := trb2->ultnf
			dUlt  := (trb2->datultnf)
			nUnit := trb2->unitliq
			case !empty(trb2->ultnf) .and. dUlt1<trb2->datultnf .and. trim(COD)<>left(codtot,nTam)
			cNota1 := "Z "+trb2->ultnf
			dUlt1  := (trb2->datultnf)
			nUnit1 := trb2->unitliq
			endcase
			*/
			if empty(tpvenda) .and. !empty(trb2->ultnf)
				lTp1 := .t.
			endif
			if !empty(tpvenda) .and. !empty(trb2->ultnf)
				lTp2 := .t.
			endif
			skip
		Enddo
		if lTp2 .and. !lTp1
			cTpVenda := "1/2"
		endif
		
		if empty(cNota)
			cNota := cNota1
			dUlt  := dUlt1
			nUnit := nUnit1
		endif
		Select SB1
		seek xFilial()+cCodTot
		reclock("TRB3",.t.)
		trb3->cod	:= cCodtot
		trb3->codtot:= ""
		trb3->codred:= cCodRed
		trb3->desc 	:=  iif(sb1->b1_desc=" ",cdesc,sb1->b1_desc)
		trb3->loc	:=	sb1->b1_locpad
		trb3->sit	:=	sb1->b1_sitprod
		trb3->tipo	:=	sb1->b1_tipo
		trb3->um	:=	sb1->b1_um
		trb3->ncm	:=	sb1->b1_posipi
		//			trb3->inventario:=	nInv
		trb3->SaldoAtu	:= nEstq
		trb3->VALESTQ 	:= nValEst
		trb3->qtdsai 	:=	nSai
		trb3->qtdent1 	:=	nEnt
		trb3->acerto 	:=	nAcerto
		//			trb3->saldo 	:=	nSaldo
		trb3->salgeren 	:=	nSalGer
		trb3->salsped 	:=	nSalSped
		trb3->ultnf		:=	cNota
		trb3->datultnf	:=	dult
		trb3->unitliq	:=	nUnit
		trb3->tpvenda		:=	ctpvenda
		trb3->atugeren	:= nsalger  + nent - nsai
		trb3->atusped 	:= nsalsped + nentS - nsai
		MsUnLock()
		Select TRB2
	Enddo
	use
	Select TRB3
	copy to \INV04  // Desconsiderando itens meia nota
	Processa({|| GeraExcel() })
	
	use
endif


use
MsgBox("Fim do Processamento !!!","Atencao","INFO")

Return

*********************
//Static Function Inv()
*********************

cAno  := year(date())-1
cData := "31/12/"+strzero(cAno,4)
dInv := mv_par01 //ctod(cData)
dFin := mv_par02 //stod("20130630")

Select SB1
dbSetOrder(1)
//set filter  to left(B1_COD,3)='12.' //left(B1_COD,4)$'1025*1026*1083'  // Tirar xxxxx
//set filter  to left(B1_COD,10)='1004.018VA' .or. left(B1_COD,10)='1004.118VA' //left(B1_COD,4)$'1025*1026*1083'  // Tirar xxxxx
//set filter to B1_COD="10100.050BC"

//set filter to left(B1_COD,5)="1004."  // Luiz 12-03-15
dbGoTop()
ProcRegua(Reccount())
Do while !eof()
	IncProc(StrZero(recno(),6)+"/"+StrZero(reccount(),6)+" - "+sb1->b1_cod)
	
	Select Sped
	seek sb1->b1_cod
	nSalSped := 0
	Do while !eof() .and. sb1->b1_cod = produto
		nSalSped += Quantidade
		skip
	Enddo
	
	if sb1->b1_tipo$"PA*RV"
		cLoc := "CB"
	else
		cLoc := "02"
	endif
	
	Select SB7   //31-12-2013  - Saldo Gerencial
	dbSetOrder(1)
	seek xFilial()+dtos(MV_PAR00)+sb1->b1_cod
	nGer := nSped := nSalAtu := 0
	Do while !eof() .and. dtos(MV_PAR00)+sb1->b1_cod=dtos(b7_data)+sb7->b7_cod
		if sb7->b7_local=cLoc
			nGer += sb7->b7_quant
		endif
		skip
	Enddo
	
	Select SB9   //30-12-2013  - Saldo Sped
	dbSetOrder(1)
	seek xFilial()+sb1->b1_cod+cLoc+dtos(MV_PAR00-1)
	nSped := 0
	Do while !eof() .and. dtos(MV_PAR00-1)+sb1->b1_cod=dtos(b9_data)+sb9->b9_cod
		nSped += sb9->b9_qini
		skip
	Enddo
	
	Select SB2
	dbSetOrder(1)
	seek xFilial()+sb1->b1_cod+cLoc
	nSalAtu := sb2->b2_qatu
	
	/*
	Select SB7
	// Para o saldo de 31/12/2012 Gerencial foi feito 30/12 e Sped em 31/12
	dbSetOrder(1)
	seek xFilial()+"20121230"+sb1->b1_cod
	nGer := nSped := nSalAtu := 0
	Do while !eof() .and. "20121230"+sb1->b1_cod=dtos(b7_data)+sb7->b7_cod
	nGer += sb7->b7_quant
	skip
	Enddo
	if vSB7
	Select SB7
	seek xFilial()+dtos(dInv)+sb1->b1_cod
	nQtdInv := 0
	Do while !eof() .and. b7_cod == sb1->b1_cod
	if b7_data==dInv
	nQtdInv += b7_quant
	endif
	skip
	Enddo
	endif
	if vSB9
	Select SB9
	seek xFilial()+sb1->b1_cod
	nQtdInv := 0
	Do while !eof() .and. b9_cod == sb1->b1_cod
	if b9_data==dInv
	nQtdInv += b9_qini
	endif
	skip
	Enddo
	endif
	
	Select SB9
	// Saldo Final
	nSalAtu := 0
	seek xFilial()+sb1->b1_cod
	Do while !eof() .and. sb1->b1_cod=sb9->b9_cod
	if dtos(mv_par02)=dtos(b9_data)
	nSalAtu += sb9->b9_qini
	endif
	skip
	Enddo
	*/
	nQtdVen := nQtdEnt1 := nQtdEnt2 := nQtdEnt3 := 0
	cCom 	:= cSem := 0
	nQtdVen := 0
	cNota	:= '  '
	nUnit	:= 0
	dNota	:= ctod("0")
	nTot	:= 0
	if sb1->b1_tipo$"PA*RV"
		Select SD2
		dbSetOrder(6)
		set softseek on
		seek xFilial()+sb1->b1_cod+"CB"+left(dtos(dInv),4)
		set softseek off
		nQtdVen := 0
		cNota	:= '  '
		nUnit	:= 0
		dNota	:= ctod("0")
		nTot	:= 0
		do while !eof() .and. sd2->d2_cod==sb1->b1_cod
			if d2_emissao<dInv .or. d2_emissao>mv_par02
				skip
				loop
			endif
			if !d2_tipo$"N*B*I*P*C"
				skip
				loop
			endif
			Select SF4
			seek xFilial()+sd2->d2_tes
			Select SD2
			if sf4->f4_estoque='N'
				skip
				loop
			endif
			//			Select SF4
			//			seek xFilial()+sd2->d2_tes
			//			Select SD2
			//			if sf4->f4_duplic<>"S" .or. d2_serie='001' .or. d2_Serie='002'
			//				skip
			//				loop
			//			endif
			cCom1 := cSem1 := ""
			if at(".0",sd2->d2_cod)=4 .or. at(".0",sd2->d2_cod)=5
				cCom++
				cCom1="C"
			endif
			if at(".1",sd2->d2_cod)=4 .or. at(".1",sd2->d2_cod)=5
				cSem++
				cSem1="S"
			endif
			
			if sd2->d2_cf<>"000" .and. sd2->d2_quant<>0
				nPonto := at(".",sd2->d2_cod)-1
				Select xD2
				reclock("XD2",.t.)
				replace D2_DOC with sd2->d2_doc
				replace D2_COD with sd2->d2_cod
				replace D2_CONTA with left(sd2->d2_cod,nPonto)
				replace D2_OP with trim(cCom1+cSem1)
				replace D2_QUANT with sd2->d2_quant
				replace D2_TOTAL with sd2->((d2_total-d2_valicm)/sd2->d2_quant)
				replace D2_TES with sd2->d2_tes
				replace D2_CF with sd2->d2_cf
				replace D2_EMISSAO with sd2->d2_emissao
				msunlock()
			endif
			Select SD2
			nQtdVen += sd2->d2_quant
			if sd2->d2_quant <>0
				nunit 	:= (d2_total - d2_valicm)/d2_quant
				cNota 	:= d2_doc
				dNota 	:= d2_emissao
			endif
			skip
		enddo
		
		Select SD1
		dbSetOrder(7)
		set softseek on
		seek xFilial()+sb1->b1_cod+"CB"+left(dtos(firstday(dInv+1)),4)
		set softseek off
		do while !eof() .and. sd1->d1_cod==sb1->b1_cod
			if d1_dtdigit<dInv .or. d1_dtdigit>dFin
				skip
				loop
			endif
			if !d1_tipo$"D" .or. d1_tes='200'
				skip
				loop
			endif
			Select SF4
			seek xFilial()+sd2->d2_tes
			Select SD1
			if sf4->f4_estoque<>"S"
				skip
				loop
			endif
			nQtdVen -= sd1->d1_quant
			skip
		enddo
		
		// RM
		if sm0->m0_codigo='02'
			Select SD1
			dbSetOrder(7)
			set softseek on
			seek xFilial()+sb1->b1_cod+"CB"+left(dtos(firstday(dInv+1)),4)
			set softseek off
			do while !eof() .and. sd1->d1_cod==sb1->b1_cod
				if d1_dtdigit<dInv .or. d1_dtdigit>dFin
					skip
					loop
				endif
				if d1_tipo$"D" .or. d1_tes='200'
					skip
					loop
				endif
				Select SF4
				seek xFilial()+sd2->d2_tes
				Select SD1
				if sf4->f4_estoque<>"S"
					skip
					loop
				endif
				nQtdEnt1 += sd1->d1_quant
				skip
			enddo
		Endif// Final RM
		//Endif //1==2 xxxx
	Else
		Select SD1
		dbSetOrder(7)
		set softseek on
		seek xFilial()+sb1->b1_cod+"02"+left(dtos(firstday(dInv+1)),4)
		set softseek off
		nQtdEnt1 := nQtdEnt2 := nQtdEnt3 := 0
		cNota	:= '  '
		nUnit	:= 0
		dNota	:= ctod("0")
		nTot	:= 0
		do while !eof() .and. sd1->d1_cod==sb1->b1_cod .and. left(dtos(d1_dtdigit),4)>=left(dtos(dInv),4) .and. d1_dtdigit<=dFin
			Select SF4
			seek xFilial()+sd1->d1_tes
			Select SD1
			if sf4->f4_duplic<>"S" .and. sd1->d1_tes<>"045"
				dbSkip()
				Loop
			Endif
			if sf4->f4_estoque="N" .and. sd1->D1_TES<>'200'
				skip
				loop
			endif
			if D1_TES='200'  //sf4->f4_duplic<>"S" .or.  //.or. d1_serie='001' .or. d1_Serie='002'
				nQtdEnt2 += sd1->D1_quant
				skip
				loop
			endif
			nQtdEnt1 += sd1->d1_quant
			if sd1->d1_quant <>0
				nunit 	:= (d1_total - d1_valicm)/d1_quant
				ntot 	:= nGer * nunit //ntot 	:= d1_quant * nunit
				cNota 	:= d1_doc
				dNota 	:= d1_dtdigit
			endif
			skip
		enddo
	Endif
	
	Select SD3
	dbSetOrder(7)
	set softseek on
	seek xFilial()+sb1->b1_cod+cLoc+dtos(dInv)
	set softseek off
	nQtdD3 := 0
	Do while !eof() .and. sb1->b1_cod+cLoc = sd3->(d3_cod+d3_local)
		if sd3->d3_emissao<dInv .or. sd3->d3_emissao>mv_par02
			skip
			loop
		endif
		if sd3->d3_tm<"500"
			nQtdD3 += sd3->d3_quant
		else
			nQtdD3 -= sd3->d3_quant
		endif
		skip
	enddo
	Select TRB
	ntot 	:= nGer * nunit //d2_quant * nunit
	if rlock()
		appe blan
		trb->cod	:= sb1->b1_cod
		trb->codred	:= iif(sb1->b1_tipo$"PA*RV",left(sb1->b1_cod,at('.',sb1->b1_cod)-1),"")
		trb->codred	:= iif(sb1->b1_tipo$"MP" .and. substr(cod,7,1)='.',left(sb1->b1_cod,6),codred)
		trb->codred	:= iif(sb1->b1_tipo$"MP" .and. substr(cod,6,1)='.',left(sb1->b1_cod,5),codred)
		trb->desc 	:= sb1->b1_desc
		trb->loc	:=	sb1->b1_locpad
		trb->sit	:=	sb1->b1_sitprod
		trb->tipo	:=	sb1->b1_tipo
		trb->um		:=	sb1->b1_um
		trb->ncm	:=	sb1->b1_posipi
		trb->salgeren	:=	nGer
		trb->saldoatu	:=	nSalAtu
		trb->qtdent1	:=	nQtdEnt1 + nQtdEnt2
		//		trb->qtdent2	:=	nQtdEnt2
		trb->qtdent3	:=	iif(sb1->b1_tipo<>"MP",nQtdD3,0)
		trb->qtdsai		:=	nQtdVen
		if !empty(cNota)
			trb->ultnf		:=	cNota
			trb->datultnf	:=	dtoc(dNota)
		endif
		trb->unitliq	:=	nUnit
		trb->totliq		:=	nSalAtu*nUnit
		if cSem<>0 .and. cCom=0
			trb->tpvenda		:=	"1/2"
		endif
		trb->salsped	:=	nSped
		trb->entsped	:=	nQtdEnt1 //+nQtdEnt2+nQtdEnt3
		trb->saisped	:=	nQtdVen
		trb->atusped	:=	nSalSped + EntSped - SaiSped
		
	endif
	DbSelectArea("SB1")
	DbSkip()
Enddo

Select XD2
cxd2 := CriaTrab(nil,.f.)
copy structure to &cxD2   // Luiz 22-07-15
dbUseArea( .T.,,cxd2,"XD2A", Nil, .F. )
index on D2_CONTA to &cxD2

Select XD2
dbgotop()
ProcRegua(Reccount())
do while !eof()
	IncProc(StrZero(recno(),6)+"/"+StrZero(reccount(),6))
	cCod := d2_conta
	dEmi := dEmi1 := ctod("0")
	nVal := nVal1 := nQtd := nQtd1 := 0
	cDoc := cDoc1 := ""
	do while !eof() .and. d2_conta = cCod
		if d2_op="C"
			cDoc := d2_doc
			dEmi := d2_emissao
			nVal := d2_total
			nQtd := d2_quant
		else
			cDoc1 := d2_doc
			dEmi1 := d2_emissao
			nVal1 := d2_total
			nQtd1 := d2_quant
		endif
		skip
	enddo
	if cDoc <> "" .and. dEmi >=mv_par02-100
		reclock("XD2A",.t.)
		replace D2_DOC with cDoc
		replace D2_COD with cCod
		replace D2_OP with "C"
		replace D2_TOTAL with nVal
		replace D2_prcven with nVal/nQtd
		replace D2_EMISSAO with dEmi
		msunlock()
	endif
	if (cDoc = "" .and. cDoc1 <> "" ) .or. dEmi <mv_par02-100
		reclock("XD2A",.t.)
		replace D2_DOC with cDoc1
		replace D2_COD with cCod
		replace D2_OP with "S"
		replace D2_TOTAL with nVal1
		replace D2_prcven with nVal1/nQtd1
		replace D2_EMISSAO with dEmi1
		msunlock()
	endif
	Select xD2
Enddo
use
Select XD2A
copy to \x

//Select TRB
//copy to \x

// Movimentação de 2013 (Jan a Jun)

/*
aCampos := {}
AADD(aCampos,{ "COD"       , "C",15,0})
AADD(aCampos,{ "DESC"      , "C",40,0})
AADD(aCampos,{ "TIPO"      , "C",02,0})
AADD(aCampos,{ "UM"        , "C",03,0})
AADD(aCampos,{ "QTDCOMP"   , "N",12,2})
AADD(aCampos,{ "QTDVEND"   , "N",12,2})
AADD(aCampos,{ "MOVENT"    , "N",12,2})
AADD(aCampos,{ "MOVSAI"    , "N",12,2})
cMov := CriaTrab(nil,.f.)
dbCreate(cMov,aCampos)
dbUseArea( .T.,,cMov,"MOV", Nil, .F. )
index on COD to &cMov

//if 1==2 // Tirar xxxxx

Select SD1
dbSetOrder(6)
//set filter  to left(D1_COD,3)='12.' //set filter to left(D1_COD,4)$'1025*1026*1083'       // Tirar xxxxx
Set softseek on
seek xFilial()+dtos(mv_par01+1)//'20130101'
Set softseek off
nQtd := 0
ProcRegua(Reccount())
do while !eof() .and. dtos(sd1->d1_dtdigit)<=dtos(mv_par02)//'20130630'
IncProc("2/10")
Select SF4
seek xFilial()+sd1->d1_tes
Select SD1
if sf4->f4_estoque<>"S" .or. d1_serie='001' .or. d1_Serie='002'
skip
loop
endif
Select SB1
seek xFilial()+sd1->D1_COD
cCod := sd1->D1_COD
cPto := at(".",cCod)
cCod := iif(SB1->B1_TIPO="PA",left(cCod,cpto+3),cCod)
Select MOV
seek cCod
RecLock("MOV",eof())
mov->Cod	:= cCod
mov->Desc	:= sb1->B1_DESC
mov->Tipo	:= sb1->B1_TIPO
mov->UM		:= sb1->B1_UM
mov->QTDCOMP+= sd1->d1_quant
MsUnlock()
Select SD1
skip
Enddo

Select SD2
dbSetOrder(5)
//set filter  to left(D2_COD,3)='12.'//set filter to left(D2_COD,4)$'1025*1026*1083'       // Tirar xxxxx
Set softseek on
seek xFilial()+dtos(mv_par01+1) //'20130101'
Set softseek off
nQtd := 0
ProcRegua(Reccount())
do while !eof() .and. dtos(sd2->d2_emissao)<=dtos(mv_par02)//'20130630'
IncProc("3/10")
Select SF4
seek xFilial()+sd2->d2_tes
Select SD2
if sf4->f4_estoque<>"S" .or. d2_serie='001' .or. d2_Serie='002'
skip
loop
endif
Select SB1
seek xFilial()+sd2->D2_COD
cCod := sd2->D2_COD
cPto := at(".",cCod)
cCod := iif(SB1->B1_TIPO="PA",left(cCod,cpto+3),cCod)
Select MOV
seek cCod
RecLock("MOV",eof())
mov->Cod	:= cCod
mov->Desc	:= sb1->B1_DESC
mov->Tipo	:= sb1->B1_TIPO
mov->UM		:= sb1->B1_UM
mov->QTDVEND+= sD2->D2_quant
MsUnlock()
Select SD2
skip
Enddo

Select TRB
index on Cod to &cTemp

Select SD3
dbSetOrder(6)
//set filter  to left(D3_COD,3)='12.'//set filter to left(D3_COD,4)$'1025*1026*1083'       // Tirar Xxx
//if 1==2 //tirar xxxxx
Set softseek on
seek xFilial()+dtos(mv_par01+1)//'20130101'
Set softseek off
nQtd := 0
ProcRegua(Reccount())
do while !eof() .and. dtos(sD3->D3_emissao)<=dtos(mv_par02)//'20130630'
IncProc("4/10")
if mv_par04=1 .and. substr(D3_CF,3,1)='4'
skip
loop
endif
if d3_tm='050'
skip
loop
endif
Select SB1
seek xFilial()+sD3->D3_COD
cCod := sd3->D3_COD
cPto := at(".",cCod)
cCod := iif(SB1->B1_TIPO="PA",left(cCod,cpto+3),cCod)
Select MOV
seek cCod
RecLock("MOV",eof())
mov->Cod	:= cCod
mov->Desc	:= sb1->B1_DESC
mov->Tipo	:= sb1->B1_TIPO
mov->UM		:= sb1->B1_UM
if sd3->d3_tm<'500'
mov->MOVENT	+= sD3->D3_quant
else
mov->MOVSAI	+= sD3->D3_quant
endif
MsUnlock()

Select TRB
seek sd3->D3_COD
if !eof()
RecLock("TRB",.f.)
if sd3->d3_tm<'500'
trb->QTDENT1 += sD3->D3_quant
else
trb->QTDSAI += sD3->D3_quant
endif
if sd3->d3_tm>='510' .and. sd3->d3_tm<='600'
trb->ACERTO	+= SD3->D3_QUANT
endif
MsUnlock()
endif
Select SD3
skip
Enddo



Select MOV
dbgotop()
copy to \MOV001
use

//Endif // Tirar 1=2 xxxx
*/

Select TRB
index on Cod to &cTemp
Select SD3
dbSetOrder(6)
Set softseek on
seek xFilial()+dtos(mv_par01+1)//'20140101'
Set softseek off
nQtd := 0
ProcRegua(Reccount())
do while !eof() .and. dtos(sD3->D3_emissao)<=dtos(mv_par02)//'20130630'
	IncProc("4/10 - Verifica Acertos ")
	if mv_par04=1 .and. substr(D3_CF,3,1)='4'
		skip
		loop
	endif
	if d3_tm='050' //.or. d3_tm='499' .or. d3_tm='999' .or. d3_tm='001'
		skip
		loop
	endif
	if dtos(d3_emissao)<='20140102'
		skip
		loop
	endif
	Select SB1
	seek xFilial()+sD3->D3_COD
	cCod := sd3->D3_COD
	cPto := at(".",cCod)
	cCod := iif(SB1->B1_TIPO="PA",left(cCod,cpto+3),cCod)
	
	Select TRB
	seek sd3->D3_COD
	if !eof()
		RecLock("TRB",.f.)
		if sb1->b1_tipo="MP"
			if sd3->d3_tm<'500'
				trb->QTDENT1 += sD3->D3_quant
			else
				trb->QTDSAI += sD3->D3_quant
			endif
			trb->atugeren := salgeren +qtdent1-qtdsai
			trb->atusped  := salsped +qtdent1-qtdsai
		endif
		if sd3->d3_tm>='510' .and. sd3->d3_tm<='600'
			trb->ACERTO	+= SD3->D3_QUANT
		endif
		MsUnlock()
	endif
	Select SD3
	skip
Enddo

// Cálculo da Moldura
Select TRB
//Set Filter to left(cod,3)='12.'
dbgotop()
do while !eof()
	IncProc("Valor das Molduras "+trb->Cod)
	Select SG1
	seek xFilial()+left(trb->Cod,6)
	if !eof()
		Select Trb
		if rlock()
			trb->Moldura := trim(sg1->G1_COMP)+".01"
			trb->QtdMold := sg1->G1_QUANT
		endif
	endif
	Select SD1
	dbSetOrder(7)
	set softseek on
	seek xFilial()+trb->Moldura+"02"+left(dtos(dInv+1),4)
	set softseek off
	nUnitch	:= 0
	do while !eof() .and. left(sd1->d1_cod,6)=left(trb->moldura,6) .and. left(dtos(d1_dtdigit),4)>left(dtos(dInv),4) .and. d1_dtdigit<=dFin
		Select SF4
		seek xFilial()+sd1->d1_tes
		Select SD1
		if D1_TES='200' //sf4->f4_duplic<>"S" .or.  //.or. d1_serie='001' .or. d1_Serie='002'
			skip
			loop
		endif
		if sd1->d1_quant <>0
			nunitch	:= (d1_total - d1_valicm)/d1_quant
		endif
		skip
	enddo
	
	//	Select SB1
	//	dbSetOrder(1)
	cCod:=trim("3"+substr(trb->cod,2,14))
	nLen := len(cCod)
	cCod := cCod + space(15-nLen)
	//	seek xFilial()+cCod
	//	Select SD1
	//	dbSetOrder(7)
	//	set softseek on
	//	seek xFilial()+"32."//cCod+"02"+left(dtos(dInv+1),4)
	//	Set Filter to d1_cod=cCod .and. year(d1_dtdigit)=2013 .and. D1_TES<>'200'
	//	dbgotop()
	//	set softseek off
	nUnitMdo	:= 0.05
	do while 1=2 .and. !eof() .and. left(dtos(d1_dtdigit),4)>left(dtos(dInv),4) .and. d1_dtdigit<=dFin //.and. sd1->d1_cod=cCod
		Select SF4
		seek xFilial()+sd1->d1_tes
		Select SD1
		if D1_TES='200'//sf4->f4_duplic<>"S" .or.  //.or. d1_serie='001' .or. d1_Serie='002'
			skip
			loop
		endif
		if sd1->d1_quant <>0
			nunitMDO 	:= (d1_total - d1_valicm)/d1_quant
		endif
		skip
	enddo
	
	Select Trb
	if rlock()
		trb->CustMdo := nUnitMDO
		trb->CustCH  := nUnitCh
		trb->CustMold:= nUnitCh*QtdMold + nUnitMDO
	endif
	skip
enddo

Set Filter to
//xxxxx
//AADD(aCampos,{ "MOLDURA"   , "C",03,0})
//AADD(aCampos,{ "QTDMOLD"   , "N",12,2})
//AADD(aCampos,{ "CUSTMDO"   , "N",12,2})
//AADD(aCampos,{ "CUSTCH"    , "N",12,2})
//AADD(aCampos,{ "CUSTMOLD"  , "N",12,2})


Return

*****************************
Static Function Finalizando()
*****************************

Select TRB
//dbSetOrder(1)//1=2 tirar xxxxx
Index on Cod to &cTemp
dbGoTop()
ProcRegua(Reccount())

Do while !eof()
	IncProc("Finalizando 1/4")
	if !tipo$"PA*RV"
		skip
		loop
	endif     //xxxx
	//MsgBox("Processamento ano "+strzero(year(date()),4)+"0101 - "+dtos(mv_par02+1),"Atencao","INFO")
	if dtos(mv_par02+1) = strzero(year(date()),4)+"0101"
		Select SB9
		seek xFilial()+trb->Cod+"CB"+dtos(mv_par02)
		nEstAtu := 0
		do while !eof() .and. b9_cod=trb->Cod
			nEstAtu := sb9->B9_QINI + nEstAtu
			skip
		enddo
	else
		Select SB2
		seek xFilial()+trb->Cod
		nEstAtu := 0
		do while !eof() .and. b2_cod=trb->Cod
			nEstAtu := sb2->B2_QATU + nEstAtu
			skip
		enddo
	endif
	Select SB7
	seek xFilial()+dtos(mv_par02)+trb->Cod
	nEst := 0
	Do while !eof() .and. B7_COD=trb->Cod .and. mv_par02=b7_data
		nEst := nEst +sb7->B7_QUANT
		skip
	Enddo
	Select TRB
	if nEst>0 .and. rlock()
		trb->VALESTQ   := nEst * UnitLiq
		trb->SaldoAtu    := nEstAtu
		nTotal += ValEstq
	endif
	Select TRB
	skip
Enddo

dbGoTop()
ProcRegua(Reccount())

if mv_par03<>0
	Do while !eof()
		IncProc("Finalizando 2/4")
		if !tipo$"PA*RV"
			skip
			loop
		endif
		Select TRB
		RecLock("TRB",.f.)
		trb->TotLiq :=	UNITLIQ*SALDOATU
		trb->NovaQtd   := round(mv_par03/nTotal * SaldoAtu,0)
		trb->Ponderado := round(mv_par03/nTotal * SaldoAtu,0) *UnitLiq
		MsUnLock()
		Select TRB
		skip
	Enddo
endif

aCampos := {}
AADD(aCampos,{ "COD"       , "C",15,0})
AADD(aCampos,{ "QTDSAI"    , "N",12,2})
AADD(aCampos,{ "QTDESTR"   , "N",12,6})
AADD(aCampos,{ "QTDTOT"    , "N",12,4})
cBx:= CriaTrab(nil,.f.)
dbCreate(cBx,aCampos)
dbUseArea( .T.,,cBx,"BAIXA", Nil, .F. )

Select TRB  // Verifica acerta Materia Prima pela Estrutura (Moldura)
//Set filter to left(cod,3)='12.'
dbGoTop()
ProcRegua(Reccount())

Do while !eof()
	IncProc("Finalizando 3/4")
	if !tipo$"PA*RV"
		skip
		loop
	endif
	Select SG1
	seek xFilial()+left(trb->Cod,6)
	do while !eof() .and. left(trb->Cod,6)=left(sg1->g1_cod,6)
		Select Baixa
		if rlock()
			appe blan
			Baixa->Cod	:= sg1->g1_comp
			Baixa->QtdSai	:= trb->QTDSAI
			Baixa->QtdEstr	:= sg1->g1_quant
			Baixa->QtdTot	:= trb->QTDSAI*sg1->g1_quant
		endif
		Select SG1
		skip
	enddo
	Select TRB
	if rlock()
		//		replace SaldoAtu  with 0
		replace QtdSai with 0
	endif
	skip
Enddo

Select TRB
//copy to \x2
Set filter to
Index on Cod to &cTemp

Select Baixa
//copy to \x1
dbGotop()
Do while !eof()
	IncProc("Finalizando 4/4")
	Select TRB
	seek baixa->Cod
	if !eof() .and. rlock()
		trb->QtdSai	:= Baixa->QtdSai
	endif
	Select Baixa
	skip
Enddo
use

Select TRB
dbgotop()
ProcRegua(Reccount())
do while !eof()
	IncProc("Finalizando")
	if rlock()
		if sb1->b1_tipo="MP"
			trb->atugeren := salgeren +qtdent1-qtdsai
			trb->atusped  := salsped +qtdent1-qtdsai
		else
			trb->atugeren := salgeren +qtdent1+qtdent2+qtdent3-qtdsai
			trb->atusped  := salsped +qtdent1-qtdsai
		endif
	endif
	skip
Enddo
dbGoTop()

Return


// Nova Geração do Relatório formato XLS
Static Function GeraExcel()

//Cria um arquivo do tipo *.xls
cArqPesq 	:= "\gerencia\inventario.xls"

nHandle := FCREATE(cArqPesq, 0)

//Verifica se o arquivo pode ser criado, caso contrario um alerta sera exibido

If FERROR() != 0
	Alert("Nao foi possivel abrir ou criar o arquivo: " + cArqPesq )
EndIf

//monta cabecalho de pagina HTML para posterior utilizao

cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml += "<html>" + CRLF
cCabHtml += "<head>" + CRLF
cCabHtml += "  <title>Inventário 2014</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF

cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF

cRodHtml := "</body>" + CRLF
cRodHtml += "</html>"

cFileCont := cCabHtml

cLinFile := "<TABLE>" + CRLF
cLinFile += "<TR>" + CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Código</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Código (Totalizador)</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Código Reduzido</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Descrição</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Local</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Situação</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Tipo</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Um</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>NCM</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Saldo Gerencial</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Qtde.Entrada</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Qtde.Saída</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Gerencial (Inicial + Ent - Sai)</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Inventário Atual</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Acertos</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Última Nota Fiscal</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Data Ult.NF</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Unit. Líq.</b></TD>"+ CRLF
//cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Total Líq.</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Estoque</b></TD>"+ CRLF
//cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Tipo de Venda</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Saldo Sped</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Sped (Inicial + Ent - Sai)</b></TD>"+ CRLF
cLinFile += "</TR>"+ CRLF

// anexa a linha montada ao corpo da tabela
cFileCont += cLinFile
cLinFile := ""
(FWRITE(nHandle, cFileCont) )

Select TRB3
ProcRegua(reccount())
dbgotop()
//cQuery1 := "SELECT D1_DOC,B1_DESC,B1_UM,D1_DOC,D1_EMISSAO,D1_CF,D1_TES "
Do while !eof()
	//For i:= 1 to len(aPlan)
	IncProc("Gerando Excel")
	
	cLinFile := "<TR>"
	cLinFile += "<TD>"+chr(160)+COD+"</TD>"+ CRLF
	cLinFile += "<TD>"+CODTOT+"</TD>"+ CRLF
	cLinFile += "<TD>"+CODRED+"</TD>"+ CRLF
	cLinFile += "<TD>"+DESC+"</TD>"+ CRLF
	cLinFile += "<TD>"+LOC+"</TD>"+ CRLF
	cLinFile += "<TD>"+SIT+"</TD>"+ CRLF
	cLinFile += "<TD>"+TIPO+"</TD>"+ CRLF
	cLinFile += "<TD>"+UM+"</TD>"+ CRLF
	cLinFile += "<TD>"+NCM+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SALGEREN,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(QTDENT1,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(QTDSAI,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(ATUGEREN,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SALDOATU,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(ACERTO,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+ULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+DATULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SaldoAtu*UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	//	cLinFile += "<TD>"+Transform(ValEstq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SALSPED,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(ATUSPED,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+TPVenda+"</TD>"+ CRLF
	
	cLinFile += "</TR>"
	
	(FWRITE(nHandle, cLinFile))
	cLinFile := ""
	Skip
Enddo
//Next i

//cLinf
cLinFile := "</Table>"+CRLF
(FWRITE(nHandle, cLinFile))

//Acrescenta o rodap html
(FWRITE(nHandle, cRodHtml))

fCLose(nHandle)

//RestArea( _aArea )

MsgBox ("Arquivo Gerado \Gerencia\Inventario.xls","Informa‡Æo","INFO")


Return

****************************
Static Function TotalizaMP()
****************************

dbUseArea( .T.,,"\inv02.dbf","TRB1", Nil, .F. )  // Totalizando MP  zzzzz
cTemp1 := CriaTrab(nil,.f.)
index on cod to &cTemp1
cTemp2 := CriaTrab(nil,.f.)
copy stru to &cTemp2
dbUseArea( .T.,,cTemp2,"TRB2", Nil, .F. )
index on cod to &cTemp2
Select TRB1
ProcRegua(Reccount())
dbgotop()
do while !eof()
	IncProc("Finalizando MP")
	select sb1
	seek xFilial()+trb1->cod
	select TRB1
	//	cPto := 15
	cPto	:= len(trim(Cod))
	if substr(Cod,7,1)='.'
		cPto := 6
	endif
	if substr(Cod,6,1)='.'
		cPto := 5
	endif
	cCod 	:= left(cod,cPto)
	//	if cPto <> 15
	//	else
	//		cCod := Cod
	//	endif
	nInv := nQtdComp := nQtdVend := nQtdEnt1 := nQtdEnt2 := nQtdEnt3 := nUnit:= 0
	nAcerto := nSaldo := nEstoque := nTotLiq := nNovaQtd := nPonderado := 0
	nSalGer := nSalSped := 0
	cdt  := ctod("0")
	cnota := ' '
	dult := ' '
	ctpvenda := ' '
	Do while left(cod,cpto)=cCod
		nQtdEnt1  += QTDENT1
		nQtdEnt2  += QTDENT2
		nQtdEnt3  += QTDENT3
		nQtdVend += QTDSAI
		nAcerto 	+= ACERTO
		nSalGer 	+= SalGeren
		nSalSped	+= SalSped
		nEstoque 	+= SaldoAtu
		if ctod(datultnf) > cDt
			cNota  := ULTNF
			dUlt   := DATULTNF
			nUnit  := UNITLIQ
			cDt := ctod(datultnf)
		endif
		nTotLiq     := nUnit*nEstoque
		if !empty(tpvenda)
			ctpvenda := TPVENDA
		endif
		skip
	enddo
	
	Select TRB2
	Seek cCod
	if eof() .and. rlock()
		appe blan
	endif
	cCod1 := cCod
	if rlock()
		trb2->cod	:= cCod
		trb2->desc 	:= sb1->b1_desc
		trb2->loc	:=	sb1->b1_locpad
		trb2->sit	:=	sb1->b1_sitprod
		trb2->tipo	:=	sb1->b1_tipo
		trb2->um	:=	sb1->b1_um
		trb2->ncm	:=	sb1->b1_posipi
		//		trb2->inventario:=	nInv
		trb2->qtdent1	:=	nQtdEnt1
		trb2->qtdent2	:=	nQtdEnt2
		trb2->qtdent3	:=	nQtdEnt3
		trb2->qtdsai	:=	nQtdVend
		trb2->ultnf		:=	cNota
		trb2->datultnf	:=	dult
		trb2->unitliq	:=	nUnit
		trb2->acerto	:=  nAcerto
		trb2->SalGeren 	:=  nSalGer
		trb2->SalSped 	:=  nSalSped
		trb2->SaldoAtu 	:=  nEstoque
		trb2->TotLiq 	:=  nEstoque*nUnit
		trb2->tpvenda	:=  ctpvenda
		trb2->atugeren	:=  nsalger  + nqtdent1 + nqtdent2 - nqtdvend
		trb2->atusped 	:=  nsalsped + nqtdent1 - nqtdvend
		
	endif
	
	select TRB1
enddo
use
Select TRB2
copy to \inv02a  // Agrupamento de MP totalizado
use

Processa({|| GeraExc2() })
use

// Nova Geração do Relatório formato XLS (MP)
Static Function GeraExc2()

//Cria um arquivo do tipo *.xls
cArqPesq 	:= "\gerencia\inventario_MP.xls"

nHandle := FCREATE(cArqPesq, 0)

//Verifica se o arquivo pode ser criado, caso contrario um alerta sera exibido

If FERROR() != 0
	Alert("Nao foi possivel abrir ou criar o arquivo: " + cArqPesq )
EndIf

//monta cabecalho de pagina HTML para posterior utilizao

cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml += "<html>" + CRLF
cCabHtml += "<head>" + CRLF
cCabHtml += "  <title>Inventário MP 2014</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF

cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF

cRodHtml := "</body>" + CRLF
cRodHtml += "</html>"

cFileCont := cCabHtml

cLinFile := "<TABLE>" + CRLF
cLinFile += "<TR>" + CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Código</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Descrição</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Local</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Situação</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Tipo</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Um</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>NCM</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Saldo Gerencial</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Qtde.Entrada</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Qtde.Saída</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Gerencial (Inicial + Ent - Sai)</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Inventário Atual</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Acertos</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Última Nota Fiscal</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Data Ult.NF</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Unit. Líq.</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Estoque</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Saldo Sped</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Sped (Inicial + Ent - Sai)</b></TD>"+ CRLF
cLinFile += "</TR>"+ CRLF

// anexa a linha montada ao corpo da tabela
cFileCont += cLinFile
cLinFile := ""
(FWRITE(nHandle, cFileCont) )

dbUseArea( .T.,,"\inv02a.dbf","INV02A", Nil, .F. )
ProcRegua(reccount())
dbgotop()
//cQuery1 := "SELECT D1_DOC,B1_DESC,B1_UM,D1_DOC,D1_EMISSAO,D1_CF,D1_TES "
Do while !eof()
	//For i:= 1 to len(aPlan)
	IncProc("Gerando Excel")
	
	cLinFile := "<TR>"
	cLinFile += "<TD>"+chr(160)+COD+"</TD>"+ CRLF
	cLinFile += "<TD>"+DESC+"</TD>"+ CRLF
	cLinFile += "<TD>"+LOC+"</TD>"+ CRLF
	cLinFile += "<TD>"+SIT+"</TD>"+ CRLF
	cLinFile += "<TD>"+TIPO+"</TD>"+ CRLF
	cLinFile += "<TD>"+UM+"</TD>"+ CRLF
	cLinFile += "<TD>"+NCM+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SALGEREN,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(QTDENT1,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(QTDSAI,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(ATUGEREN,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SALDOATU,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(ACERTO,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+ULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+DATULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SaldoAtu*UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	//	cLinFile += "<TD>"+Transform(ValEstq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(SALSPED,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(ATUSPED,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+TPVenda+"</TD>"+ CRLF
	
	cLinFile += "</TR>"
	
	(FWRITE(nHandle, cLinFile))
	cLinFile := ""
	Skip
Enddo
Use
//Next i

//cLinf
cLinFile := "</Table>"+CRLF
(FWRITE(nHandle, cLinFile))

//Acrescenta o rodap html
(FWRITE(nHandle, cRodHtml))

fCLose(nHandle)

//RestArea( _aArea )

//MsgBox ("Arquivo Gerado \Gerencia\Inventario-MP.xls","Informa‡Æo","INFO")


Return

// Sped Final 2014 - Mp

dbUseArea( .T.,,"\invent.dbf","INV", Nil, .F. )
cTemp := CriaTrab(nil,.f.)
index on trim(cod) to &cTemp

dbUseArea( .T.,,"\system\sped13.dbf","SPED", Nil, .F. )
copy structure to sped13a
use
dbUseArea( .T.,,"\sped13a.dbf","SPED", Nil, .F. )

dbgotop()
do while !eof()
	Select INV
	seek trim(SPED->Produto)
	if eof()
		select SB1
		seek xFilial()+trim(inv->Cod)
		Select Sped
		nRec := recno()
		Reclock("SPED",.t.)
		sped->FILIAL:="01"
		sped->SITUACAO:="1"
		sped->PRODUTO:= inv->cod
		sped->UM:=sb1->b1_um
		sped->QUANTIDADE:=inv->qtde
		sped->VALOR_UNIT:=inv->vunit
		sped->TOTAL:=inv->vtot
		sped->ARMAZEM:=if(inv->loc<>" ",inv->loc,"01")
		MsUnlock()
		goto nRec
		skip
		loop
	endif
	Select Sped
	if trim(sped->produto)<>trim(inv->cod) .and. rlock()
		replace quantidade with 0
	else
		if  rlock()
			replace quantidade with inv->QTDE
			replace VALOR_UNIT with inv->vunit
			replace TOTAL with inv->vtot
		endif
	endif
	Select Sped
	skip
Enddo

Return
