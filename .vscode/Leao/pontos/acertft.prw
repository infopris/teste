#include "protheus.ch"
#include "rwmake.ch"

User Function ACERTFT

nNota := 0
@ 050,01 To 200,500 Dialog Odlg Title "Acerto Suframa"
@ 003,09 to 100,400
@ 011,11 Say "Nota :"
@ 011,45 GET nNota  Picture "@E 999999" Valid .T.
@ 60,25 BMPBUTTON TYPE 01 ACTION Executa()
@ 60,65 BMPBUTTON TYPE 02 ACTION Close(oDlg)
Activate Dialog oDlg Centered
                                        
Static Function Executa()

Select SFT
dbSetOrder(1)
seek xFilial()+"S1"+space(2)+strzero(nNota,6)

do while !eof() .and. FT_CFOP='6109 ' .and. FT_NFISCAL=strzero(nNota,6)+space(3)
	if sft->FT_CLASFIS = "040"
    RecLock("SFT",.f.)
    sft->FT_CLASFIS := "000"
    MsUnLock()        
	endif
	skip
enddo

MsgBox("Fim do Processamento !!!","Atencao","INFO")
return                                                              


