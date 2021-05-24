#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function PCOM001()        // Copia de notas fiscais de entrada

cNum := "000000000"
cSer := "UNI"
dData:= date()
@ 196,52 TO 343,505 DIALOG oDlg TITLE "Copiar notas de entrada "
@ 05,005 TO 45,220 
@ 10,015 Say "Nota Original" 
@ 10,070 get cNum picture "999999999" SIZE 40,20  VALID .t.
@ 10,130 Say "Serie" 
@ 10,150 get cSer picture "@!" SIZE 20,20  VALID .t. 
@ 26,015 Say "Data Digitacao"
@ 26,070 get dData SIZE 40,20

@ 50,100 BUTTON "Confirma" Size 40,15  ACTION OkProc()
@ 50,150 BUTTON "Cancela"  Size 40,15  ACTION Close(oDlg)
ACTIVATE DIALOG oDlg 

Return nil

************************
Static Function OkProc()
************************
IF SELECT("TRB1") # 0
	TRB1->(DBCLOSEAREA( ))
ENDIF

IF SELECT("TRB2") # 0
	TRB2->(DBCLOSEAREA( ))
ENDIF

IF SELECT("TRB3") # 0
	TRB3->(DBCLOSEAREA( ))
ENDIF

Select SF1
dbSetOrder(1)
seek xFilial()+cNum+"001"
lAchou := .f.
do while !eof()
  if cNum+"001"== sf1->f1_doc+sf1->f1_serie .and. sf1->f1_dtdigit==dData
     lAchou := .t.
  endif
  Skip
enddo
if lAchou
  MsgBox ("Nota Fiscal gerada, favor excluir","Informa‡Æo","INFO")
  Return
endif

Select SF1
dbSetOrder(1)
seek xFilial()+cNum+cSer
if eof()
  MsgBox ("Nota Fiscal nao encontrada, tente novamente","Informa‡Æo","INFO")
  Return
endif

seek xFilial()+cNum+cSer
do while !eof() .and. sf1->(f1_doc+f1_serie)==cNum+cSer .and. f1_dtdigit#dData
	if f1_dtdigit=dData
		exit
	endif
	Skip
Enddo
nReg := recno()
Select SA2
seek xFilial()+sf1->f1_fornece+sf1->f1_loja
if !MsgBox ("Confirma fornecedor "+sa2->a2_nome,"Escolha","YESNO")
  Return
Endif

cTemp1 := cTemp2 := cTemp3 := space(8)
lGrava := .f.
Close(oDlg)
Processa( {|| RunProc() } )
if lGrava
  Select TRB1
  use
  Select TRB2
  use
  Select TRB3
  use
  Select SF1
  appe from &cTemp1
  Select SD1
  appe from &cTemp2
  Select SE2
  appe from &cTemp3
Endif
Return


************************
Static Function RunProc()
************************
Select SF1
cTemp1 := CriaTrab(nil,.f.)
Copy to &cTemp1 next 1
dbUseArea( .T.,,cTemp1, "TRB1", Nil, .F. )

Select SD1
dbSetOrder(1)
seek xFilial()+sf1->(f1_doc+f1_serie+f1_fornece+f1_loja)
cTemp2 := CriaTrab(nil,.f.)
Copy to &cTemp2 next 100 for sd1->(d1_doc+d1_serie+d1_fornece+d1_loja)==sf1->(f1_doc+f1_serie+f1_fornece+f1_loja)
dbUseArea( .T.,,cTemp2, "TRB2", Nil, .F. )

@ 150,1 TO 440,530 DIALOG oDlg4 TITLE "Itens da Nota"

aCampos := {}
AADD(aCampos,{"D1_COD","Produto","@!"})
AADD(aCampos,{"D1_VUNIT","Valor Unit","@E 999,999.99"})
AADD(aCampos,{"D1_TOTAL","Valor Total","@E 999,999.99"})

@ 6,5 TO 103,220 BROWSE "TRB2" FIELDS aCampos 

@ 115,110 BUTTON "_Altera   " SIZE 40,15 ACTION AltD1()
@ 115,150 BUTTON "_Grava    " SIZE 40,15 ACTION GrvD1()
@ 115,190 BUTTON "_Sair     " SIZE 40,15 ACTION Close(oDlg4) 

ACTIVATE DIALOG oDlg4 CENTERED
Return

***************************
Static Function AltD1()
***************************
Select TRB2
*goto nList
cProd := trb2->d1_cod
nVU   := trb2->d1_vunit

@ 196,52 TO 343,505 DIALOG oDlg6 TITLE "Altera Item da Nota"
@ 15,010 TO 45,250 
@ 26,020 say "Codigo do Produto : "+cProd
@ 18,145 say "Valor Unit"
@ 26,140 get nVU picture "@E 999,999.9999" SIZE 40,25
//@ 18,175 say "Valor Total"
//@ 26,170 get nValOrcado  picture "@E 9999,999.99" SIZE 45,25
@ 50,168 BMPBUTTON TYPE 1 ACTION GrvAlt()
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg6)
ACTIVATE DIALOG oDlg6 CENTERED

Return .t.

***************************
Static Function GrvAlt()
***************************
Close(oDlg6)
Select TRB2
if rlock()
   trb2->d1_vunit 	:= nVu
   trb2->d1_total 	:= nVu*trb2->d1_quant
   trb2->d1_valipi	:= 0
   trb2->d1_valicm	:= 0
   trb2->d1_valfre	:= 0
   trb2->d1_total 	:= nVu*trb2->d1_quant
   trb2->d1_custo	:= nVu*trb2->d1_quant
endif
Return

***************************
Static Function GrvD1()
***************************
Select TRB2
go top
nTot := 0
do while rlock() .and. !eof()
   trb2->d1_serie  := "001"
   trb2->d1_tipo   := "C"
   trb2->d1_tes    := "200"
   trb2->d1_quant  :=  0
   trb2->d1_valipi :=  0
   trb2->d1_valicm :=  0
   trb2->d1_valfre :=  0
   nTot := nTot + d1_total
   Skip
Enddo

@ 196,52 TO 343,505 DIALOG oDlg7 TITLE "Confirma Total da Nota"
@ 15,010 TO 45,250 
@ 26,020 say "Valor Total da nota "
@ 26,140 get nTot picture "@E 999,999.9999" SIZE 40,25

@ 50,168 BMPBUTTON TYPE 1 ACTION GrvD2()
@ 50,196 BMPBUTTON TYPE 2 ACTION Close(oDlg7)
ACTIVATE DIALOG oDlg7 CENTERED

Return .t.

***************************
Static Function GrvD2()
***************************
Close(oDlg7)
Select TRB1
go top
if rlock()
   trb1->f1_prefixo := "001"
   trb1->f1_serie   := "001"
   trb1->f1_tipo    := "C"
   trb1->f1_especie := "VL"
   trb1->f1_baseipi := 0
   trb1->f1_valipi  := 0
   trb1->f1_baseicm := 0
   trb1->f1_valicm  := 0
   trb1->f1_frete	:= 0
   trb1->f1_valmerc := nTot
   trb1->f1_valbrut := nTot
endif
Select SE2
cTemp3 := CriaTrab(nil,.f.)
dbSetOrder(1)
seek xFilial()+sf1->("001"+f1_doc)
do while !eof() .and. rlock() .and. se2->e2_emissao==sf1->f1_emissao //.and. se2->(e2_num+e2_prefixo)==sf1->(f1_doc+f1_serie)
	if MsgBox ("Confirma exclusÆo do titulo "+se2->e2_num+" de "+dtoc(se2->e2_emissao)+" "+se2->e2_nomfor+" Valor "+transform(se2->e2_valor,"@E 99,999,999.99"),"Escolha","YESNO")
		if rlock()
			se2->e2_titorig := Alltrim(Substr(cUsuario,7,15))+dtos(dDataBase)
			delete
		endif
	endif
	Skip
enddo
seek xFilial()+sf1->(f1_serie+f1_doc)
Copy to &cTemp3 next 20 for se2->(e2_num+e2_prefixo)==sf1->(f1_doc+f1_serie);
                      .and. se2->(e2_fornece+e2_loja)==sf1->(f1_fornece+f1_loja)
dbUseArea( .T.,,cTemp3, "TRB3", Nil, .F. )
go top
nDup := 0
do while !eof() .and. e2_fornece==sf1->f1_fornece
   nDup := nDup + e2_valor
   Skip
Enddo
go top
do while rlock() .and. !eof() .and. e2_fornece==sf1->f1_fornece
   trb3->e2_prefixo:= "001"
   trb3->e2_tipo   := "VL"
   trb3->e2_valor  :=  ntot*e2_valor/nDup
   trb3->e2_saldo  :=  ntot*e2_saldo/nDup
   trb3->e2_vlcruz :=  ntot*e2_vlcruz/nDup
   Skip
Enddo

lGrava := .t.
Close(oDlg4) 

Return

