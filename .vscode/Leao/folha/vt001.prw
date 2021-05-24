#include "rwmake.ch"        
#INCLUDE "TOPCONN.CH"

User Function VT001()      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³VT001     ³ Autor ³ Luiz Eduardo          ³ Data ³ 05.05.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera VT no adto                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Sigagpe                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

cVb := '127'
cDt := date()
@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Processamento"
@ 8,10 TO 84,222
@ 15,15 say "Informe o codigo da verba do V.T"
@ 15,55 get  cVb  SIZE 40,20
@ 30,15 say "Informe a data do pagamento do V.T"
@ 30,100 get  cDt  SIZE 40,20

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
//Static Function RunProc()
*-------------------------*

Select SR0
//ProcRegua(reccount())
x := 1
goto x
do while !eof()
    goto x
    x:=x+1
//    IncProc()
   
    if r0_valcal#0 .and. rlock()
      Select SRA
      dbSetOrder(1)
      Seek xFilial()+sr0->r0_mat
      Select SRC
      Seek xFilial()+sr0->r0_mat+cVb
      if eof() .and. rlock()
        appe blan
      endif
      if rlock() .and. 1==2   // Não grava mais no adto a partir de 14/12/12
        src->rc_filial := "01"
        src->rc_mat    := sr0->r0_mat
        src->rc_pd     := cVb
        src->rc_tipo1  := "V"
        src->rc_valor  := sr0->r0_valcal
        src->rc_data   := cDt
        src->rc_cc     := sra->ra_cc
        src->rc_tipo2  := "I" // Substitui no dia 14/12/12 , anterior = "A"
      Endif

// Grava Verba
      Select SR1
      dbSetOrder(1)
      Seek xFilial()+sr0->r0_mat+"01"+cVb
      if eof() .and. rlock()
        appe blan
      endif
      if rlock()
        sr1->r1_filial := "01"
        sr1->r1_mat    := sr0->r0_mat
        sr1->r1_pd     := cVb
        sr1->r1_tipo1  := "V"
        sr1->r1_horas  := 1
        sr1->r1_valor  := sr0->r0_valcal
        sr1->r1_data   := cDt
        sr1->r1_semana := "01"
        sr1->r1_parcela:=  1
        sr1->r1_cc     := sra->ra_cc
        sr1->r1_tipo2  := "I"
      Endif
    Endif
    Select SR0
Enddo

Return
