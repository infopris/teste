#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/08/01

User Function Frete2()        // incluido pelo assistente de conversao do AP5 IDE em 15/08/01

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")
 
cResp := '000000'
cPref := '000'
@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Informar Nota Fiscal Frete"
@ 05,010 TO 45,180 
@ 16,030 Say 'Nota Fiscal Frete : '
@ 16,100 get cresp pict '@!' SIZE 40,20  VALID .t.
@ 28,030 Say 'Prefixo     : '
@ 28,100 get cPref pict '@!' SIZE 40,20  VALID .t.
@ 50,150 BUTTON "Confirma" Size 40,15  ACTION escolhe()
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
return

*---------------*
Static Function Escolhe()
*---------------*
cTemp1 := CriaTrab(nil,.f.)
Select SD1
dbSetOrder(1)
Seek xFilial()+cResp
if eof()
   MsgBox ("Nota nao cadastrada","Informa‡ao","INFO")
   Return
Endif
copy to &cTemp1 for sd1->d1_doc == left(cResp,6) next 100
dbUseArea( .T.,,cTemp1, "TRB", Nil, .F. )
go top

@ 150,1 TO 440,530 DIALOG oDlg4 TITLE "Itens da Nota"

aCampos := {}
AADD(aCampos,{"D1_ITEM","Item","@!"})
AADD(aCampos,{"D1_COD","Cod"}) 
AADD(aCampos,{"D1_TOTAL","Valor ","@E 999,999.99"})

@ 6,5 TO 103,170 BROWSE "TRB" FIELDS aCampos 

@ 105,190 BUTTON "_Descricao" SIZE 40,15 ACTION Desc()
@ 125,190 BUTTON "_Sair" SIZE 40,15 ACTION Fecha()

ACTIVATE DIALOG oDlg4 CENTERED
Return

*---------------*
Static Function Fecha()
*---------------*
Close(oDlg4)
Select TRB
use
Select SD1
Return

*---------------*
Static Function Desc()
*---------------*
Select SYP
dbSetOrder(1)
Seek xFilial()+"*"+substr(cResp,2,5)
cTemp2 := CriaTrab(nil,.f.)
copy to &cTemp2 for left(syp->yp_campo,8) == cResp+trb->d1_item next 100
dbUseArea( .T.,,cTemp2, "TRB1", Nil, .F. )
Desc1()
Select TRB1
Use
Select SD1
Return

*---------------*
Static Function Desc1()
*---------------*
aCampos := {}
AADD(aCampos,{ "YP_TEXTO" , "C",80,0}) 
cTemp5 := CriaTrab(nil,.f.)
dbCreate(cTemp5,aCampos)
dbUseArea( .T.,,cTemp5,"TRB5", Nil, .F. )
Append From &cTemp2
Copy to scArq1.txt SDF
Use
Select SYP
cTexto := MemoRead("scArq1.txt")
@ 116,090 To 316,407 Dialog oDlgMemo Title "Descricao do Item "
@ 003,005 Get cTexto   Size 150,080  MEMO Object oMemo
@ 085,043 Button OemToAnsi("_Salvar")   Size 36,16 Action FRSalDesc()
@ 085,093 Button OemToAnsi("_Sair")     Size 36,16 Action Close(oDlgMemo)

Activate Dialog oDlgMemo

Return


***************************
Static Function FRSalDesc()
***************************

cFOpen := "scArq1.txt"
If !Empty(cFOpen)
    MemoWrit(cFOpen,cTexto)
Endif
Close(oDlgMemo)
Select SYP
Seek xFilial()+"*"+substr(cResp,2,5)
do while !eof() .and. SYP->YP_CHAVE=="*"+substr(cResp,2,5)
   if rlock() .and. left(syp->yp_campo,8) == cResp+trb->d1_item
      Dele
   Endif
   Skip
Enddo

Select SYP
aCampos := {}
AADD(aCampos,{ "TEXTO" , "C",80,0}) 
dbCreate(cTemp5,aCampos)
dbUseArea( .T.,,cTemp5,"TRB5", Nil, .F. )
append from scArq1.txt SDF
go top
n:=1
do while !eof()
   RecLock("SYP",.t.)
   SYP->YP_TEXTO := ALLTRIM(trb5->Texto)
   SYP->YP_SEQ   := strzero(n,3)
   SYP->YP_CHAVE := "*"+substr(cResp,2,5)
   SYP->YP_CAMPO := cResp+trb->d1_item
   n:=n+1 
   Select TRB5
   skip
enddo
use
Select SYP

Return .t.

