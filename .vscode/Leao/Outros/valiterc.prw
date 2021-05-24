#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 24/11/01

User Function VALITERC()        // Informar a Validade em Poder de Terceiros

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")
 
cResp := '000000'
cPref := 'UNI'
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Informar Validade de Consignacao"
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

Select SB6
dbSetOrder(1)
Go top
Do while !eof()
   if sb6->(b6_doc+b6_serie)==cResp+cPref
      exit
   endif
   Skip
enddo
if eof()
  MsgBox ("Nota Fiscal nao encontrada !!","Informa‡ao","INFO")
  Return
endif
Close(oDlg1)
ddata := Date()+60
cObs  := space(30)
cHora := left(Time(),5)
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Informar Data "
//@ 15,010 TO 45,180 
@ 06,030 Say 'Validade ate : '
@ 06,100 get dData SIZE 40,20  VALID .t.
@ 50,150 BUTTON "Confirma" Size 40,15  ACTION conf()
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
return

*---------------*
Static Function Conf()
*---------------*
Select SB6

Do while !eof() .and. sb6->(b6_doc+b6_serie)==cResp+cPref
  if rlock()
    sb6->b6_validad := dData
  Endif
  Skip
Enddo

Close(oDlg1)
Return
