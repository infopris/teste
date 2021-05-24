#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF
//#Include "RwMake.ch"

/*
*****************************************************************************
** Funcao     Inventario   Autor   Luiz Eduardo           Data   23.04.2010**
*****************************************************************************
** Descricao  Geracao do arquivo de inventario                             **
*****************************************************************************
*/

User Function INV01()

// inv01 - PA
// Inv02 - MP
// inv03 - resumo PA
// inv04 - resumo PA2

//AcertInv()

if !Pergunte ("INV001",.T.)
	Return
endif

// Saldo Sped deve estar no dia 30/12/20..
if substr(dtos(mv_par02),5,4)='0101'
	mv_par00 := mv_par02-1
else
	mv_par00 := mv_par02
endif
if select("TRB")<>0
	Select TRB
	use
endif

//mv_par01 -> Inventário Inicial
//mv_par02 -> Data final
//mv_par03 -> Valor do Inventario
//mv_par04 -> Gerencial X Sped
//mv_par05 -> Data Novo Inventário

/*/Luiz/*/

// Acerta Classificacao Fiscal

aCampos := {}
AADD(aCampos,{ "COD"       , "C",15,0})
AADD(aCampos,{ "CODTOT"    , "C",15,0})
AADD(aCampos,{ "CODRED"    , "C",06,0})
AADD(aCampos,{ "DESC"      , "C",40,0})
AADD(aCampos,{ "LOC"       , "C",02,0})
AADD(aCampos,{ "SIT"       , "C",02,0})
AADD(aCampos,{ "TIPO"      , "C",02,0})
AADD(aCampos,{ "UM"        , "C",03,0})
AADD(aCampos,{ "NCM"       , "C",10,0})
AADD(aCampos,{ "QUANT"	   , "N",12,2})
AADD(aCampos,{ "ULTNF"     , "C",09,0})
AADD(aCampos,{ "DATULTNF"  , "C",10,0})
AADD(aCampos,{ "UNITLIQ"   , "N",12,2})
AADD(aCampos,{ "TOTLIQ"    , "N",12,2})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa({|| Inv() })

nTotal := 0
//Processa({|| Finalizando() })
//Alert('Finalizando ok (2)')
Select TRB
//copy to \inv01 for tipo$"PA*RV"
copy to \inv02 for !tipo$"PA*RV"


//Return // Tirar 1=2 xxxxx

Processa({|| TotalizaMP() })
//Alert('totaliza MP ok (3)')

dbUseArea( .T.,,"\inv01","TRB1", Nil, .F. )
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
		nSalGer 	+= Quant
		//		if ctod(datultnf) > cDt
		if stod(datultnf) > cDt
			cNota := ULTNF
			dUlt   := stod(DATULTNF)
			nUnit  := UNITLIQ
		endif
		nTotLiq     := nUnit*nEstoque
		skip
	enddo
	
	Select TRB2
	cCod1 := cCod
	if sb1->B1_TIPO='PA' .and. left(cCod,1)='1'
		cCod1 := left(sb1->b1_cod,at('.',sb1->b1_cod))+"0"+substr(sb1->b1_cod,at('.',sb1->b1_cod)+2,10)
	else
		cCod1 := left(sb1->b1_cod,4)
	endif
	RecLock("TRB2",.t.)
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
	trb2->ultnf		:=	cNota
	trb2->datultnf	:=	dtoc(dult)
	trb2->unitliq	:=	nUnit
	trb2->Quant 	:=  nSalGer
	trb2->TotLiq 	:=  quant*nUnit
	MsUnLock()
	
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
	cTemp12f := CriaTrab(nil,.f.)
	IndRegua("TRB2", cTemp12f, "CodRed", , , "Selecionando Registros...")
	//	Index on CodRed to &cTemp2
	dbgotop()
	Do while !eof()
		cCodTot := trb2->CodTot
		cCodRed := trb2->CodRed
		cDesc	:= trb2->desc
		cLoc	:= trb2->Loc
		cTipo	:= trb2->Tipo
		cUm		:= trb2->Um
		cNcm	:= trb2->NCM
		nUnitLiq:= trb2->UnitLiq
		cUltNF	:= trb2->UltNF
		cDtUltNF:= trb2->DatUltNF
		// Ver saldo Inventário
		//SELECT SUM(B9_QINI) FROM SB9010 WHERE B9_DATA='20201231' AND SUBSTRING(B9_COD,1,4)='1001'
		nLenCod := len(trim(cCodRed))
		cQuery := "SELECT SUM(B9_QINI) as qtd "
		cQuery += " FROM SB9010  "
		cQuery += " WHERE " 
		cQuery += " substring(B9_COD,1,"+str(nLenCod,1)+") = '"+cCodRed+"' AND "
		cQuery += " B9_DATA='20201231' AND "
		cQuery += " D_E_L_E_T_ <>'*' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
		nQtd := Qtd
		Use

		Select TRB2
		do while !eof() .and. cCodRed = CodRed
			skip
		Enddo
		*/
		Select SB1
		seek xFilial()+cCodRed
		if nQtd<>0
		reclock("TRB3",.t.)
		trb3->cod	:= cCodtot
		trb3->codtot:= ""
		trb3->codred:= cCodRed
		trb3->desc 	:=  sb1->b1_desc //iif(sb1->b1_desc=" ",cdesc,sb1->b1_desc)
		trb3->loc	:=	sb1->b1_locpad
		trb3->sit	:=	sb1->b1_sitprod
		trb3->tipo	:=	sb1->b1_tipo
		trb3->um	:=	sb1->b1_um
		trb3->ncm	:=	sb1->b1_posipi
		trb3->quant 	:=	nQtd
		trb3->ultnf		:=	cUltNf
		trb3->datultnf	:=	cDtUltNf
		trb3->unitliq	:=	nUnitLiq
		trb3->totliq	:=	nUnitLiq*nQtd
		MsUnLock()
		Endif
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
Static Function Inv()
*********************

cAno  := year(date())
cData := "31/12/"+strzero(cAno,4)
dInv := mv_par01 //ctod(cData)
dFin := mv_par02 //stod("20130630")

cQuery := " SELECT B9_COD,B9_QINI,B9_DATA,B1_UM,B1_TIPO "
cQuery += " FROM SB9010 SB9 "
cQuery += " INNER JOIN SB1010 SB1 "
cQuery += " ON SB1.B1_COD = SB9.B9_COD "
cQuery += " WHERE "
cQuery += " SB9.B9_DATA= '"+DTOS(mv_par01)+"' AND "
cQuery += " SB9.B9_QINI <> 0 AND "
cQuery += " SB9.D_E_L_E_T_ <>'*' AND "
cQuery += " SB1.D_E_L_E_T_ <>'*'  "
cQuery += " ORDER BY B9_COD  "
if select("TMPB9")<>0
	Select TMPB9
	use
endif
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPB9", .F., .T.)
dbGoTop()
nrecTot := Reccount()
ProcRegua(nrecTot)

Do while !eof()
	IncProc(StrZero(recno(),6)+"/"+StrZero(nrecTot,6)+" - "+b9_cod)
	
	if TMPB9->b1_tipo$"PA*RV"
		cLoc := "CB"
	else
		cLoc := "02"
	endif
	
	nQtdVen := nQtdEnt1 := nQtdEnt2 := nQtdEnt3 := nQuant := 0
	cCom 	:= cSem := 0
	nQtdVen := 0
	cDoc	:= '  '
	nUnit	:= 0
	dNota	:= ctod("0")
	nTot	:= 0
	if TMPB9->b1_tipo$"PA*RV"
		if left(TMPB9->B9_COD,1)$"1*2" .AND. AT(".",TMPB9->B9_COD)<>0
			cCod := left(TMPB9->B9_COD,AT(".",TMPB9->B9_COD)-1)
			cCod := cCod+space(15-len(cCod))
		Else
			cCod := left(TMPB9->B9_COD,6)
		Endif
		nLenCod := len(trim(cCod))
		cQuery := "SELECT MAX(SD2.R_E_C_N_O_) as reg "
		cQuery += " FROM SD2010 SD2 INNER JOIN SF4010 SF4 ON D2_TES=F4_CODIGO "
		cQuery += " WHERE " 
		cQuery += " substring(D2_COD,1,"+str(nLenCod,1)+") = '"+cCod+"' AND "
		cQuery += " F4_DUPLIC<>'N' AND D2_TIPO='N' AND "
		cQuery += " D2_EMISSAO<='20201231' AND "
		cQuery += " SD2.D_E_L_E_T_ <>'*' AND SF4.D_E_L_E_T_ <>'*' "
//		cQuery += "GROUP BY 		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
		nReg := REG

		use
		Select SD2
		Goto nReg
		cDoc	:= SD2->D2_DOC
		cEmissao:= dtos(SD2->D2_EMISSAO)
		nVUnit	:= D2_PRCVEN
		nTotal	:= D2_TOTAL
	Else
		if left(TMPB9->B9_COD,6)="19.017"
			x:=1
		Endif
		cQuery := " SELECT MAX(SD1.R_E_C_N_O_) as reg "
//		cQuery := " Select D1_DTDIGIT,D1_QUANT as QUANT,"
//		cQuery += " D1_VUNIT,D1_TOTAL,"
//		cQuery += " D1_DOC,SD1.R_E_C_N_O_"
		cQuery += " from SD1010 SD1 "
		cQuery += " INNER JOIN SF4010 SF4 "
		cQuery += " ON SD1.D1_TES = SF4.F4_CODIGO "
		cQuery += " where D1_COD='"+TMPB9->B9_COD+"' "
		cQuery += " AND F4_DUPLIC<>'N' AND D1_TES<>'200' "
		cQuery += " AND D1_CF<>'200' AND D1_QUANT<>0"
		cQuery += " AND D1_DTDIGIT >= '20190101'"
		cQuery += " AND D1_DTDIGIT <= '"+TMPB9->B9_DATA+"' "
		cQuery += " AND SD1.D_E_L_E_T_ <>'*' "
		cQuery += " AND SF4.D_E_L_E_T_ <>'*' "
		//cQuery += " ORDER BY R_E_C_N_O_ " 
		//cQuery += " Group by D1_DOC,SD1.R_E_C_N_O_,d1_quant,D1_VUNIT,D1_TOTAL "
		
		if select("TMPD1")<>0
			Select TMPD1
			use
		endif
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPD1", .F., .T.)
		nReg := REG

		if !eof()
			//goto TRB->( LASTREC())
			//dbgobottom()
			select SD1
			goto nReg //tmpd1->R_E_C_N_O_
			cEmissao:= dtos(sd1->d1_dtdigit)//tmpd1->d1_dtdigit
			nQuant 	:= sd1->d1_quant //tmpd1->Quant
			cDoc 	:= sd1->d1_doc //tmpd1->d1_doc
			nVUnit	:= sd1->d1_vunit //tmpd1->d1_VUnit
			nTotal	:= sd1->d1_total //tmpd1->d1_Total
		endif
		cCod := tmpb9->b9_cod
	Endif
	
	Select Sb1
	dbSetOrder(1)
	Seek xFilial()+cCod	
//	Seek xFilial()+tmpb9->b9_cod
	
	Select TRB
	RecLock("TRB",.t.)
	trb->cod	:= TMPB9->B9_COD // cCod //sb1->b1_cod
	trb->codred	:= iif(sb1->b1_tipo$"PA*RV",cCod,"") //left(sb1->b1_cod,at('.',sb1->b1_cod)-1),"")
	trb->codred	:= iif(sb1->b1_tipo$"MP" .and. substr(cod,7,1)='.',left(sb1->b1_cod,6),codred)
	trb->codred	:= iif(sb1->b1_tipo$"MP" .and. substr(cod,6,1)='.',left(sb1->b1_cod,5),codred)
	trb->desc 	:= sb1->b1_desc
	trb->loc	:=	sb1->b1_locpad
	trb->sit	:=	sb1->b1_sitprod
	trb->tipo	:=	sb1->b1_tipo
	trb->um		:=	sb1->b1_um
	trb->ncm	:=	sb1->b1_posipi
	trb->quant	:=	tmpb9->B9_QINI
	trb->ultnf	:=	cDoc
	trb->datultnf := cEmissao
	trb->unitliq	:=	nVUnit
	trb->totliq		:=	nTotal
	MsUnLock()
	Select TMPB9
	DbSkip()
Enddo

Select TRB
//copy to \x
cTemp12h := CriaTrab(nil,.f.)
IndRegua("TRB", cTemp12h, "Cod", , , "Selecionando Registros...")
//Alert('aquivo base ok (1)')
Return

*****************************
Static Function Finalizando()
*****************************

Select TRB
cTemp12a := CriaTrab(nil,.f.)
IndRegua("TRB", cTemp12a, "Cod", , , "Selecionando Registros...")
//Index on Cod to &cTemp
dbGoTop()
ProcRegua(Reccount())


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
		trb->TotLiq :=	UNITLIQ*quant
		MsUnLock()
		Select TRB
		skip
	Enddo
endif

aCampos := {}
AADD(aCampos,{ "COD"       , "C",15,0})
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
		RecLock("BAIXA",.t.)
		Baixa->Cod	:= sg1->g1_comp
		Baixa->QtdEstr	:= sg1->g1_quant
		MsUnLock()
		Select SG1
		skip
	enddo
	Select TRB
	skip
Enddo

Select TRB
//copy to \x2
//Set filter to
cTemp12b := CriaTrab(nil,.f.)
IndRegua("TRB", cTemp12b, "Cod", , , "Selecionando Registros...")
//Index on Cod to &cTemp

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
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Última Nota Fiscal</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Data Ult.NF</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Unit. Líq.</b></TD>"+ CRLF

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
	cLinFile += "<TD>"+Transform(quant,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+ULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+DATULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(quant*UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	
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

dbUseArea( .T.,,"\inv02","TRB1", Nil, .F. )  // Totalizando MP  zzzzz
cTemp1 := CriaTrab(nil,.f.)
cTemp12c := CriaTrab(nil,.f.)
IndRegua("TRB1", cTemp12c, "Cod", , , "Selecionando Registros...")
//index on cod to &cTemp1
cTemp2 := CriaTrab(nil,.f.)
copy stru to &cTemp2
dbUseArea( .T.,,cTemp2,"TRB2", Nil, .F. )
cTemp12d := CriaTrab(nil,.f.)
IndRegua("TRB2", cTemp12d, "Cod", , , "Selecionando Registros...")
//index on cod to &cTemp2
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
	cdt  := " "//ctod("0")
	cnota := ' '
	dult := ' '
	ctpvenda := ' '
	Do while left(cod,cpto)=cCod
		nSalGer 	+= quant
		//		if ctod(datultnf) > cDt
		if (datultnf) > cDt
			cNota  := ULTNF
			dUlt   := DATULTNF
			nUnit  := UNITLIQ
			cDt := datultnf //ctod(datultnf)
		endif
		nTotLiq     := nUnit*nSalGer
		skip
	enddo
	
	Select TRB2
	Seek cCod
	cCod1 := cCod
	RecLock("TRB2",eof())
	trb2->cod	:= cCod
	trb2->desc 	:= sb1->b1_desc
	trb2->loc	:=	sb1->b1_locpad
	trb2->sit	:=	sb1->b1_sitprod
	trb2->tipo	:=	sb1->b1_tipo
	trb2->um	:=	sb1->b1_um
	trb2->ncm	:=	sb1->b1_posipi
	trb2->ultnf		:=	cNota
	trb2->datultnf	:=	dult
	trb2->unitliq	:=	nUnit
	trb2->quant 	:=  nSalGer
	trb2->TotLiq 	:=  nTotLiq //nSalGer*nUnit
	MsUnLock()
	select TRB1
enddo
use
Select TRB2
copy to \inv02a  // Agrupamento de MP totalizado
use

Processa({|| GeraExc2() })
use

Return

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
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Quantidade Inventario</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Última Nota Fiscal</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Data Ult.NF</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Unit. Líq.</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Valor Estoque</b></TD>"+ CRLF
cLinFile += "</TR>"+ CRLF

// anexa a linha montada ao corpo da tabela
cFileCont += cLinFile
cLinFile := ""
(FWRITE(nHandle, cFileCont) )

dbUseArea( .T.,,"\inv02a","INV02A", Nil, .F. )
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
	cLinFile += "<TD>"+Transform(Quant,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+ULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+DATULTNF+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(quant*UnitLiq,"@E 9,999,999.9999")+"</TD>"+ CRLF
	
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

Return

Static Function AcertInv()

		cQuery := "SELECT B7_COD,B7_DATA,B7_QUANT,B7_LOCAL "
		cQuery += " FROM SB7010  "
		cQuery += " WHERE " 
		cQuery += " B7_DATA='20201231' AND "
		cQuery += " B7_QUANT<>0 AND "
		cQuery += " D_E_L_E_T_ <>'*' "
		cQuery += " ORDER BY B7_COD "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
		copy to \inv00
		dbGoTop()
		do while !eof()
			cCod := B7_COD
			cLocal := B7_LOCAL
			nQuant := 0
			do while !eof() .and. cCod = B7_COD
				nQuant += B7_QUANT 
				Skip
			Enddo 
/*
		cQuery  := " UPDATE "+ RetSqlName("SB9") + " SET B9_QINI="+str(nQuant)+" "
		cQuery  += " WHERE B9_COD= '"+cCod+"' "
		cQuery  += " AND B9_Local = '"+cLocal +"' AND "
		cQuery  += " AND B9_DATA = '20201231' "
		nRet    := TCSQLExec(cQuery)
*/
			Select SB9
			dbSetOrder(1)
			seek xFilial()+cCod+cLocal+'20201231'
			if!eof()
				RecLock("SB9",.F.)
				SB9->B9_QINI := nQuant
				MsUnLock()
			Endif
			Select Tmp1
		enddo
use
