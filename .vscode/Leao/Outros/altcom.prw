#INCLUDE "rwmake.ch"
User Function AltCOM

If !Empty(SE1->E1_VEND1)
	MsgBox("Este Titulo j  Possui Vendedor nananin nÆo !!!","Atencao","INFO")
	Return( Nil )
Endif
If !Empty(SE1->E1_BAIXA)
	MsgBox("Este Titulo j  Possui Baixa nananin nÆo !!!","Atencao","INFO")
	Return( Nil )
Endif

Private _nVend := SE1->E1_VEND1
Private _nComis:= SE1->E1_COMIS1
Private _nPed  := SE1->E1_PEDIDO

@ 050,01 To 200,500 Dialog Odlg Title "Inclui Comissao CH-PR‚"
@ 003,09 to 100,400
@ 011,11 Say "Vendedor:"
@ 011,45 GET _nVend  Picture "@X" Valid .T. F3 "SA3"
@ 022,11 Say "Comissao:"
@ 022,45 GET _nComis  Picture "@E 999.99"
@ 033,11 Say "Pedido  :"
@ 033,45 GET _nPed    Picture "999999" Valid .T. F3 "SC5"
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

dbSelectArea("SE1")
RecLock("SE1",.F.)
SE1->E1_VEND1 := _nVend
SE1->E1_COMIS1:= _nComis
SE1->E1_PEDIDO:= _nPed 
MsUnlock()

Static Function Cancela
Close(oDlg)
Return (.T.)
