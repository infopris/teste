#INCLUDE "rwmake.ch"
User Function Altipo

Private _nTipo := SE2->E2_TIPO

@ 050,01 To 200,500 Dialog Odlg Title "Altera Tipo Ctas a Pagar"
@ 003,09 to 100,400
@ 011,11 Say "Tipo: "
@ 011,43 GET _nTipo Picture "@!"
   Tone(550,2)
   Tone(650,2)
   Tone(550,2)
   Tone(650,2)
   Tone(550,2)
   Tone(650,2)
   Tone(900,4)
   Inkey(1)
@ 60,25 BMPBUTTON TYPE 01 ACTION Close(oDlg)
@ 60,65 BMPBUTTON TYPE 02 ACTION Cancela()
Activate Dialog oDlg Centered

dbSelectArea("SE2")
RecLock("SE2",.F.)
SE2->E2_TIPO := _nTipo
MsUnlock()

Static Function Cancela
Close(oDlg)
Return (.T.)
