#include "rwmake.ch"        
#INCLUDE "TOPCONN.CH"

User Function PON003()      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PON001    ³ Autor ³ Luiz Eduardo          ³ Data ³ 23.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera relatório de faltas e atrasos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Sigapon                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

dIni := dFin := date()
@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Processamento"
@ 8,10 TO 84,222
@ 15,15 say "Inicio : "
@ 15,45 get  dIni SIZE 40,20
@ 30,15 say "Termino: "
@ 30,45 get  dFin SIZE 40,20

@ 91,168 BMPBUTTON TYPE 1 ACTION Processa( {|| RunProc() } ) //OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
//@ 23,14 SAY "Este programa e uma demontra‡Æo da utilizacao das rotinas de processamento."
//@ 33,14 SAY "   -Processa()  - Dispara Dialogo de Processamento"
//@ 43,14 SAY "   -ProcRegua() - Ajusta tamanho da regua"
//@ 53,14 SAY "   -IncProc() - Incrementa posicao da regua"
ACTIVATE DIALOG oDlg5

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OkProc    ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Confirma o Processamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function OkProc()
Close(oDlg5)
//Processa( {|| RunProc() } )
//Return

*-------------------------*
Static Function RunProc()
*-------------------------*

aCampos := {}
AADD(aCampos,{ "MAT"     , "C",06,0}) 
AADD(aCampos,{ "NOME"    , "C",40,0}) 
AADD(aCampos,{ "ADMISSAO", "D",08,0}) 
AADD(aCampos,{ "DEMISSAO", "D",08,0}) 
//AADD(aCampos,{ "PREV"    , "N",12,2}) 
AADD(aCampos,{ "QUANT"   , "N",12,2}) 
//AADD(aCampos,{ "TRAB"    , "N",12,2}) 
AADD(aCampos,{ "AFASTINI", "D",08,0}) 
AADD(aCampos,{ "AFASTFIM", "D",08,0}) 
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Select TRB
Reclock("TRB",.t.)
trb->NOME		:= "Período"
trb->ADMISSAO	:= dIni
trb->DEMISSAO	:= dFin
MsunLock()

Select SPH
dbSetOrder(1)
dbgotop()
cTemp1 := CriaTrab(nil,.f.)
copy to &cTemp1 for sph->ph_data >=dIni .and. sph->ph_data<=dFin .and. !sph->ph_abono$"028*029" .and. trim(sph->ph_pd)$"101*411*413*414*446"
//Set filter to sph->ph_data >=dIni .and. sph->ph_data<=dFin .and. !sph->ph_abono$"028*029" .and. trim(sph->ph_pd)$"101*411*413*414*446"
dbUseArea( .T.,,cTemp1,"TRB1", Nil, .F. )

ProcRegua(reccount())
Do while !eof()
    IncProc() 
	Select TRB1
    cMat := trb1->ph_mat  
    nQuant := nTrab := 0
    dAfIni := dAfFim := cTod("0")
	Do while trb1->ph_mat=cMat .and. !eof()
		nQuant += int(trb1->PH_QUANTC)+(trb1->PH_QUANTC-int(trb1->PH_QUANTC))*100/60
		skip
	Enddo                       
	Select SRA
	seek xFilial()+cMat
	// Verifica Afastamento
	Select SR8
	seek xFilial()+cMat
	Do while !eof() .and. cMat = R8_MAT
		if R8_TIPO="F"
			skip
			loop
		endif
		if sr8->R8_dataini >= dIni
			dAFIni := sr8->R8_dataini
		endif
		if sr8->R8_datafim >= dFin
			dAFFIM := sr8->R8_datafim
		endif             
		skip
	Enddo

/*
//-- Monta calendario com horarios de trabalho
//-- Carga da tabela de horario padrao
If !fTabTurno(aTabPadrao)
	Help(' ',1,'TPADNCAD')
	Return Nil
EndIf
		//-- Chamada a fTrocaTno() para identificar o turno correto a ser passado para retseq.
		fTrocaTno(dIni, dFin, @aTurnos)
		cSeqTurn := SRA->RA_SEQTURN
		cTno     := If(Len(aTurnos)==0,SRA->RA_TNOTRAB,aTurnos[1,1])
If !CriaCalend( dIni,dFin,cTno,cSeqTurn,aTabPadrao,@aTabCalend,SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_CC,@aTurnos,NIL,NIL,.F.)
//	loop
EndIf

//-- Apura as horas trabalhadas a partir do calendario de trabalho
nHrsPrev := fHrsPrev(aTabCalend,dIni,dFin)
*/
	// Transformando Centesimal em horas
		nQuant := int(nQuant)+(nQuant-int(nQuant))*60/100

	Select TRB
	Reclock("TRB",.t.)
	trb->MAT		:= cMat
	trb->NOME		:= SRA->RA_NOME
	trb->ADMISSAO	:= SRA->RA_ADMISSA
	trb->DEMISSAO	:= SRA->RA_DEMISSA
	trb->QUANT 		:= nQuant
//	trb->Prev		:= nHrsPrev
//	trb->TRAB 		:= nTrab
	trb->AFASTINI	:= dAfIni
	trb->AFASTFIM	:= dAfFim
	MsunLock()
	Select TRB1
Enddo        
copy to \x
use

Select TRB
GeraExcel()
dbgotop()
copy to \gerencia\faltas
//MsgBox ("Arquivo gerado com sucesso \gerencia\faltas.dbf","Informa‡Æo","INFO")
Close(oDlg5)


Return

Static Function GeraExcel()

//Cria um arquivo do tipo *.xls
cArqPesq 	:= "\gerencia\faltas.xls"

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
cCabHtml += "  <title>Inventário 2013</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF

cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF

cRodHtml := "</body>" + CRLF
cRodHtml += "</html>"

cFileCont := cCabHtml

cLinFile := "<TABLE>" + CRLF
cLinFile += "<TR>" + CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Matrícula</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Nome</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Admissão</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Demissão</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Faltas</b></TD>"+ CRLF
//cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Trabalhadas</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Início Afastamento</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Final Afastamento</b></TD>"+ CRLF
cLinFile += "<TD style='Background: #B4CDCD; font-style: Bold;'><b>Férias</b></TD>"+ CRLF
cLinFile += "</TR>"+ CRLF

// anexa a linha montada ao corpo da tabela
cFileCont += cLinFile
cLinFile := ""
(FWRITE(nHandle, cFileCont) )
  
Select TRB
ProcRegua(reccount())
dbgotop()
//cQuery1 := "SELECT D1_DOC,B1_DESC,B1_UM,D1_DOC,D1_EMISSAO,D1_CF,D1_TES "
Do while !eof()
//For i:= 1 to len(aPlan)
	IncProc("Gerando Excel")
	cLinFile := "<TR>"
	cLinFile += "<TD>"+chr(160)+MAT+"</TD>"+ CRLF
	cLinFile += "<TD>"+NOME+"</TD>"+ CRLF
	cLinFile += "<TD>"+dtoc(ADMISSAO)+"</TD>"+ CRLF
	cLinFile += "<TD>"+dtoc(DEMISSAO)+"</TD>"+ CRLF
	cLinFile += "<TD>"+Transform(QUANT,"@E 9,999,999.9999")+"</TD>"+ CRLF
//	cLinFile += "<TD>"+Transform(TRAB,"@E 9,999,999.9999")+"</TD>"+ CRLF
	cLinFile += "<TD>"+dtoc(AFASTINI)+"</TD>"+ CRLF
	cLinFile += "<TD>"+dtoc(AFASTFIM)+"</TD>"+ CRLF
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

MsgBox ("Arquivo Gerado \Gerencia\Faltas.xls","Informa‡Æo","INFO")


Return

