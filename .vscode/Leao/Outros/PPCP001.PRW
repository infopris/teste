#include "rwmake.ch"

User Function PPCP001()        // Gera Arquivo de Pedidos a faturar

if !MsgBox ("Confirma processamento","Escolha","YESNO")
   Return
endif

cPerg      := "PROD01"
Pergunte (cPerg,.T.)

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 13/08/01 ==> RptStatus({|| Execute(RptDetail) })
Return

Static Function RptDetail()

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "ITEM"    , "C",02,0}) 
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "CLI"     , "C",30,0}) 
AADD(aCampos,{ "TRANSP"  , "C",30,0}) 
AADD(aCampos,{ "PGTO"    , "C",15,0}) 
AADD(aCampos,{ "QTDE"    , "N",12,2}) 
AADD(aCampos,{ "ENTREGA" , "D",08,0}) 
AADD(aCampos,{ "TIPO"    , "C",02,0}) 
//AADD(aCampos,{ "OK"      , "C",02,0}) 
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
cTemp1:= CriaTrab(nil,.f.)
copy stru to &cTemp1
dbUseArea( .T.,,cTemp1,"TRB1", Nil, .F. )
index on cod to &cTemp1
Select SC5
dbSetOrder(1)
Select SC6
dbSetOrder(1)
set softseek on
seek xFilial()+"007900"
set softseek off
if eof()
  go top
endif
SetRegua(recno())
Do while !eof()
  incRegua()
  if c6_blq#"R" .and. c6_local=="01" .and. c6_qtdent<c6_qtdven
   if !c6_tes$"501*512*516*518"
      Skip
      Loop
   Endif
   Select SC5
   seek xFilial()+sc6->c6_num
   if c5_emissao<mv_par01 .or. c5_emissao>mv_par02
     Select SC6
     Skip
     Loop
   Endif
   Select SC6
   if left(sc6->c6_produto,2) == '00'
     cCod := "10"+SUBSTR(sc6->c6_produto,3,13)
   else
     cCod := sc6->c6_produto
   endif

   Select SA4
   dbSetOrder(1)
   seek xFilial()+sc5->c5_transp
   Select SE4
   dbSetOrder(1)
   seek xFilial()+sc5->c5_condpag
   Select SA1
   dbSetOrder(1)
   seek xFilial()+sc6->c6_cli+sc6->c6_loja
   Select SB1
   seek xFilial()+cCod
   Select TRB
   if rlock()
     appe blan
     trb->num     := sc6->c6_num
     trb->item    := sc6->c6_item
     trb->cod     := cCod
     trb->cli     := sa1->a1_nome
     trb->qtde    := sc6->c6_qtdven-sc6->c6_qtdent
     trb->entrega := sc6->c6_entreg
     trb->tipo    := "PV"
     trb->transp  := sa4->a4_nome
     trb->pgto    := se4->e4_descri
   Endif
   Select SB2
   Seek xFilial()+cCod
   Select TRB1
   Seek cCod
   if eof() .and. rlock()
      appe blan
   endif
   if rlock()
     trb1->cod     := cCod
     trb1->qtde    := -sb2->b2_qatu
     trb1->cli     := "Z-Saldo"
     trb1->entrega := ctod("31/12/2030")
     trb1->tipo    := "SL"
   endif
  Endif
  Select SC6
  Skip
Enddo
Select trb1
use
Select TRB
appe from &cTemp1
Copy to PCP
use
Select SC6

Return
