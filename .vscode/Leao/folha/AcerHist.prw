#include "rwmake.ch"        
#INCLUDE "TOPCONN.CH"

User Function ACERHIST()      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PON001    ³ Autor ³ Luiz Eduardo          ³ Data ³ 23.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera apontamentos de hora extra                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Sigapon                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Processa( {|| RunProc() } )
Return

*-------------------------*
Static Function RunProc()
*-------------------------*


Select SRA
ProcRegua(reccount())
DBGOTOP()
Do while !eof()
    IncProc()
	if dtos(sra->ra_demissa)<'20160401' .AND. !EMPTY(ra_demissa)
		skip
		loop
	endif
	if dtos(sra->ra_admissa)>='20160401'
		skip
		loop
	endif
	Select SR3
	reclock("SR3",.t.)
	SR3->R3_FILIAL	:=xfilial()
	SR3->R3_MAT	:= sra->ra_mat
	SR3->R3_DATA	:= stod("20160401")
	SR3->R3_SEQ	:= "1"
	SR3->R3_TIPO	:="003"
	SR3->R3_PD	:= "000"
	SR3->R3_DESCPD	:= "SALARIO BASE"
	SR3->R3_VALOR	:= sra->ra_salario
	SR3->R3_ANTEAUM	:= sra->ra_salario
	msunlock()
	Select SR7
	reclock("SR7",.t.)
	SR7->R7_FILIAL	:= xFilial()
	SR7->R7_MAT	:= sra->ra_mat
	SR7->R7_DATA	:= stod("20160401")
	SR7->R7_SEQ	:="1"
	SR7->R7_TIPO	:="003"
	SR7->R7_FUNCAO	:= sra->ra_codfunc
	SR7->R7_DESCFUN	:= ""
	SR7->R7_TIPOPGT	:= "M"
	SR7->R7_CATFUNC	:= "M"
	SR7->R7_CARGO  	:= sra->ra_cargo
	SR7->R7_DESCCAR	:= ""
	SR7->R7_USUARIO	:= "Luiz"
	msunlock()
	Select SRA
	skip
	
Enddo
Return
