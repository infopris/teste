#include "rwmake.ch"

User Function PCOM005()        // Exclui notas do financeiro

dDatade := date()
dDataAte:= date()
cNota := space(9) 

@ 196,52 TO 343,505 DIALOG oDlg TITLE "Exclui NF no Financeiro "
@ 05,005 TO 45,220 
@ 10,015 Say "Data Inicial" 
@ 10,070 get dDatade  SIZE 40,20
@ 10,115 Say "Data Final" 
@ 10,150 get dDataAte SIZE 40,20
@ 25,015 Say "Nota " 
@ 25,070 get cNota  SIZE 40,20
@ 25,115 Say "(em branco para todas)" 

@ 50,100 BUTTON "Confirma" Size 40,15  ACTION OkProc()
@ 50,150 BUTTON "Cancela"  Size 40,15  ACTION Close(oDlg)
ACTIVATE DIALOG oDlg 

Return nil

************************
Static Function OkProc()
************************
mv_par01 := dDatade
mv_par02 := dDataate

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 13/08/01 ==> RptStatus({|| Execute(RptDetail) })
Return
Static Function RptDetail()

Select SE2
dbSetOrder(5)
set softseek on
seek xFilial()+dtos(mv_par01)
set softseek off
SetRegua(recCount())
li := 080
nTot := 0
Do while !eof() .and. se2->e2_emissao<=mv_par02
   IncRegua()
   if !empty(cNota) .and. cNota<>se2->e2_num
      Skip
      Loop
   Endif
   if left(e2_origem,4)#"MATA"
      Skip
      Loop
   Endif
   If se2->e2_emissao<mv_par01 .or. se2->e2_emissao>mv_par02
      Skip
      Loop
   Endif
   Select SF1
   dbSetOrder(1)
   Seek xFilial()+se2->(e2_num+e2_prefixo+e2_fornece+e2_loja)
   if !eof()
     Select SE2
     if MsgBox ("Confirma exclusÆo do titulo "+se2->e2_num+" de "+dtoc(se2->e2_emissao)+" "+se2->e2_nomfor+" Valor "+transform(se2->e2_valor,"@E 99,999,999.99"),"Escolha","YESNO")
       if rlock()
		se2->e2_titorig := Alltrim(Substr(cUsuario,7,15))+dtos(dDataBase)
		delete
       endif
     endif
   Endif
   Select SE2
   skip
Enddo 

Close(oDlg)

Return