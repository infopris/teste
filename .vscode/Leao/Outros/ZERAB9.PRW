#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function zerab9()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ZeraB9    ³ Autor ³ Luiz Eduardo          ³ Data ³ 30.06.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina para zerar o arquivo de saldos iniciais do estoque   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
aItems := {"1-Todos","2-PA","3-MP"}
nList := 1
cList := " "
dDt := dDataBase
@ 196,52 TO 343,505 DIALOG oDlg TITLE "Rotina de Limpar Saldos de Estoque"
@ 15,010 TO 55,250 
@ 18,020 say "Data Inv.: "
@ 18,060 get dDt SIZE 40,25
@ 30,020 say "Produtos : "
@ 30,060 COMBOBOX cList ITEMS aItems SIZE 50,50 
@ 60,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 60,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg

Return nil

Static Function OkProc()
Close(oDlg)
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 13/08/01 ==> Processa( {|| Execute(RunProc) } )
Return

Static Function RunProc()

Select SB1
ProcRegua(reccount())
Do while !eof()
   IncProc()
   if left(cList,1) == '2' .and. sb1->b1_tipo#"PA"
     Skip
     Loop
   endif
   if left(cList,1) == '3' .and. sb1->b1_tipo#"MP"
     Skip
     Loop
   endif
   Select SB9
   Seek xFilial()+sb1->b1_cod+sb1->b1_locpad
   if eof() .and. rlock()
     Appe blan
   endif
   if rlock()
     sb9->b9_filial  := xFilial()
     sb9->b9_cod     := sb1->b1_cod
     sb9->b9_data    := dDt
     sb9->b9_local   := sb1->b1_locpad
   endif
   Select SB1
   Skip
Enddo
Return
