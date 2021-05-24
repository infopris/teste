#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 24/11/01

User Function DATSAI()        // Data de Saida da Nota Fiscal

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                 
Local dData
SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6")
 
cResp := '000000'
cPref := 'UNI'
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Data e Hora de Saida da NF"
@ 05,010 TO 45,180 
@ 16,030 Say 'Nota Fiscal : '
@ 16,100 get cresp pict '@!' SIZE 40,20  VALID .t.
@ 28,030 Say 'Prefixo     : '
@ 28,100 get cPref pict '@!' SIZE 40,20  VALID .t.
@ 50,150 BUTTON "Confirma" Size 40,15  ACTION imped()// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==> @ 50,150 BUTTON "Confirma" Size 40,15  ACTION Execute(R01Imp)
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
return

*---------------*
Static Function Imped()
*---------------*

Select SF2
dbSetOrder(1)
Seek xFilial()+cResp+"   "+cPref
if eof()
  MsgBox ("Nota Fiscal nao encontrada !!","Informa‡ao","INFO")
  Return
endif
Close(oDlg1)
ddata := Date()
cObs  := space(40)
cHora := left(Time(),5)
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Informar Data e Hora de Saida da NF"
//@ 15,010 TO 45,180 
@ 06,030 Say 'Data Saida : '
@ 06,100 get dData SIZE 40,20  VALID .t.
@ 18,030 Say 'Hora Saida : '
@ 18,100 get cHora pict '@!' SIZE 40,20  VALID .t.
@ 30,030 Say 'Observacao : '
@ 30,100 get cObs  pict '@!' SIZE 80,20  VALID .t.
@ 50,150 BUTTON "Confirma" Size 40,15  ACTION conf()
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
return

*---------------*
Static Function Conf()
*---------------*
Select SF2

reclock("SF2",.f.)
sf2->f2_datasai := dData
sf2->f2_horasai := cHora
sf2->f2_obs     := cObs
MsunLock()

dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial()+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))

dbSelectArea("SUA")
dbSetOrder(8)
dbSeek(xFilial()+SD2->D2_PEDIDO)
RecLock("SUA",.f.)
sua->ua_datasai := dData
MsUnLock()

Close(oDlg1)
Return
