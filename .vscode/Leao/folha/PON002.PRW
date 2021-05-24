#include "rwmake.ch"        
#INCLUDE "TOPCONN.CH"

User Function PON002()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PON002    ³ Autor ³ Luiz Eduardo          ³ Data ³ 12.08.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera apontamentos de desconto de DSR                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Sigapon                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

dIni := dFin := date()
@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Processamento"
@ 8,10 TO 84,222
@ 15,15 say "Inicio : "
@ 15,45 get  dIni SIZE 40,20
@ 30,15 say "Termino: "
@ 30,45 get  dFin SIZE 40,20

@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
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
±±³Fun‡„o    ³OkProc    ³ Autor ³ Luiz Eduardo          ³ Data ³ 12.08.03 ³±±
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
//Static Function RunProc()
*-------------------------*

Select SPB
go top
Do while !eof()
  if rlock() .and. spb->pb_pd=="447"
      Dele
  Endif
  skip
enddo
Select SPC
go top
Do while !eof()
  if rlock() .and. spc->pc_pd=="447"
      Dele
  Endif
  skip
enddo
cTemp1 := CriaTrab(nil,.f.)
copy stru to &cTemp1
dbUseArea( .T.,,cTemp1, "TRB", Nil, .F. )

Select SPC
dbSetOrder(2)
//ProcRegua(reccount())
x := 0
go top
Do while !eof()
//    IncProc()
    lReg := .f.
    IF SPC->PC_PD$"411-413-414-446"
       xReg  := Recno()
       cSem  := 7-dow(spc->pc_data)
       cData1:= spc->pc_data+cSem
       nTot  := nTot1 := nTot2 := 0
       cMat  := pc_mat
       do while !eof() .and. spc->pc_data<= cData1 .and. pc_mat == cMat .and. pc_data<=dFin
         IF SPC->PC_PD=="411" .and. !deleted()
           nTot := nTot + spc->(pc_quantc - pc_qtabono)
         endif
         IF SPC->PC_PD=="413" .and. !deleted()
           nTot := nTot + spc->(pc_quantc - pc_qtabono)
         endif
         IF SPC->PC_PD=="414" .and. !deleted()
           nTot1:= nTot1+ spc->(pc_quantc - pc_qtabono)
         endif
         IF SPC->PC_PD=="446" .and. !deleted()
           nTot2:= nTot2+ spc->(pc_quantc - pc_qtabono)
         endif
         Skip
         lReg := .t.
         IncProc()
       Enddo
       Select TRB
       if rlock() .and. (nTot>=4 .or. nTot1>=4 .or. nTot2>=4)
         Appe blan
         trb->pc_filial := "01"
         trb->pc_mat    := cMat
         trb->pc_data   := iif(cData1+1<=dFin,cData1+1,dFin)
         trb->pc_pd     := "447"
         trb->pc_quantc := 7.20
       Endif
       Select SPC
    endif
    if !lReg
      Skip
    endif
Enddo
Select TRB
Use
Select SPC
Appe from &cTemp1
Return