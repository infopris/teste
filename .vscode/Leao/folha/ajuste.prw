#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/01
#INCLUDE "TOPCONN.CH"

User Function ajuste()        // Importa base

dbUseArea( .T.,,"\xra.dbf", "TRB", Nil, .F. )
cTemp := CriaTrab(nil,.f.)
dbgotop()
do while !eof()
	Select SR7
	append from \XR7
	RecLock("SR7",.F.)
	sr7->R7_MAT     := trb->RA_MAT
	sr7->R7_CARGO     := trb->RA_cargo
	sr7->R7_FUNCAO     := trb->RA_CODFUNC
	sr7->R7_DESCCARG     := " "
	sr7->R7_DESCFUN     := " "
	MsUnlock()
	Select trb
	skip
enddo                           
return

dbUseArea( .T.,,"\xra.dbf", "TRB", Nil, .F. )
cTemp := CriaTrab(nil,.f.)
dbgotop()
do while !eof()
	Select SR3
	append from \XR3
	RecLock("SR3",.F.)
	sr3->R3_MAT     := trb->RA_MAT
	sr3->R3_VALOR   := trb->RA_SALARIO
	sr3->R3_ANTEAUM := trb->RA_SALARIO
	MsUnlock()
	Select trb
	skip
enddo                           
return
