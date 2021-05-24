#INCLUDE "rwmake.ch"
User Function Data

Private xDtProgr := SC5->C5_DTPROGR

@ 050,01 To 200,500 Dialog Odlg Title "Data de Entrega Prevista"
@ 003,09 to 100,400
@ 011,11 Say "Data: "
@ 011,43 GET xDTProgr Picture "@!"
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

dbSelectArea("SC5")
RecLock("SC5",.F.)
SC5->C5_DTPROGR := XDTPROGR
MsUnlock()

Static Function Cancela
Close(oDlg)
Return (.T.)
