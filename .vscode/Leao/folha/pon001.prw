#include "rwmake.ch"        
#INCLUDE "TOPCONN.CH"

User Function PON001()      

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

cTemp1 := CriaTrab(nil,.f.)
inkey(0.5)
cTemp2 := CriaTrab(nil,.f.) 

Select SP8
//ProcRegua(reccount())
x := 1
goto x
Do while !eof()
    goto x
    x:=x+1
//    IncProc()
    if sp8->p8_data >=dIni .and. sp8->p8_data<=dFin .and. sp8->p8_hora>18
       xReg := Recno()
       cReg := p8_Mat + dtos(p8_data)
       Select SP8
       dbSetOrder(4)
       seek xFilial()+cReg+"17.35"
       if !eof()
         Loop
       endif
       goto xReg
       copy to &cTemp1 next 1
       copy to &cTemp2 next 1
       dbUseArea( .T.,,cTemp1, "TRB", Nil, .F. )
       if rlock()
         trb->p8_hora := 17.35
       Endif
       Use
       dbUseArea( .T.,,cTemp2, "TRB", Nil, .F. )
       if rlock()
         trb->p8_hora := 17.36
       Endif
       Use
       Select SP8
       Appe from &cTemp1
       Appe from &cTemp2
    endif
Enddo
Return
