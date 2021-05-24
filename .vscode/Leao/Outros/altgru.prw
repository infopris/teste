#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/08/01
#INCLUDE "TOPCONN.CH"

User Function AltGru()  // Altera Grupos no cadastro de produtos

* Este programa podera ser desativado apos 01/10/2003
Select SB9
dbgotop()
do while !eof()
	Select SB1
	seek xFilial()+sb9->b9_cod
	if !eof()
		Select SB9
		skip
		loop
	Endif   
	Select SB9
	if rlock() 
		delete
	endif
	skip
enddo
Return

Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 16/08/01 ==> Processa( {|| Execute(RunProc) } )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunProc   ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function RunProc()

Select SB1
ProcRegua(reccount())
go top
Do while !eof()
    Do case
    case left(b1_cod,4)$"1001*1020*1021*1004*1006*1038*1037" .and. rlock()
      sb1->b1_grupo := "10"

    Case left(b1_cod,4)$"0001*0020*0021*0004*0006*0038*0037" .and. rlock()
      sb1->b1_grupo := "10"

    Case left(b1_cod,4)$"1035*1055*1056*1057*1058*1059*1062*1063*1064" .and. rlock()
      sb1->b1_grupo := "20"

    Case left(b1_cod,4)$"0035*0055*0056*0057*0058*0059*0062*0063*0064" .and. rlock()
      sb1->b1_grupo := "20"

    Case left(b1_cod,4)$"1007*1009*1010*1013*1014*1015*1016*1018" .and. rlock()
      sb1->b1_grupo := "20"

    Case left(b1_cod,4)$"0007*0009*0010*0013*0014*0015*0016*0018" .and. rlock()
      sb1->b1_grupo := "20"

    Case left(b1_cod,4)$"1401*1402" .and. rlock()
      sb1->b1_grupo := "30"

    Case left(b1_cod,2)=="22" .and. rlock() .and. b1_tipo=='PA'
      sb1->b1_grupo := "40"

    Case left(b1_cod,2)$"26*12*18" .and. rlock() .and. b1_tipo=='PA'
      sb1->b1_grupo := "50"

    Case left(b1_cod,2)=="20" .and. rlock() .and. b1_tipo=='PA'
      sb1->b1_grupo := "60"

    Otherwise
      if rlock() .and. b1_tipo=="PA"
        sb1->b1_grupo := "999"
      endif
    EndCase

    IncProc()
    Skip
Enddo
Return


