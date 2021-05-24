#include "rwmake.ch"  

User Function PCom004()   // Liberacao de Pedidos de Compras

if    !(upper(substr(cUsuario,7,5))=="ADMIN" .or. upper(substr(cUsuario,7,6))=="IRINEU") ;
.and. !(upper(substr(cUsuario,7,5))=="EMERS" .or. upper(substr(cUsuario,7,5))=="ELISA")
  MsgBox ("Usuario sem permissao para utilizar esta rotina","Informa‡Æo","INFO")
  Return
endif

aCampos := {}
AADD(aCampos,{ "EMISSAO" , "D",08,0}) 
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "PED"     , "C",06,0}) 
AADD(aCampos,{ "ITEM"    , "C",02,0}) 
AADD(aCampos,{ "SEQUEN"  , "C",03,0}) 
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "UM"      , "C",02,0}) 
AADD(aCampos,{ "DESC"    , "C",30,0}) 
AADD(aCampos,{ "QTDE"    , "N",12,2}) 
AADD(aCampos,{ "UNIT"    , "N",12,2}) 
AADD(aCampos,{ "ENTREGA" , "D",08,0}) 
AADD(aCampos,{ "TOTAL"   , "N",12,2}) 
AADD(aCampos,{ "FORN"    , "C",08,0}) 
AADD(aCampos,{ "NOME"    , "C",30,0}) 
AADD(aCampos,{ "CONDPAG" , "C",15,0}) 
AADD(aCampos,{ "MSG"     , "C",03,0}) 
AADD(aCampos,{ "SLD"     , "N",11,2}) 
AADD(aCampos,{ "STD"     , "N",11,2}) 
AADD(aCampos,{ "LIQ"     , "N",11,2}) 
AADD(aCampos,{ "DTULT"   , "D",08,0}) 
AADD(aCampos,{ "QTDULT"  , "N",11,2}) 
AADD(aCampos,{ "PRCULT"  , "N",11,2}) 
AADD(aCampos,{ "MSGANT"  , "C",03,0}) 
AADD(aCampos,{ "OK"      , "C",02,0}) 

cTemp1:= CriaTrab(nil,.f.)
dbCreate(cTemp1,aCampos)
dbUseArea( .T.,,cTemp1,"TRB1", Nil, .F. )
Index on Num to &cTemp1

Processa( {|| RunProc1() } )
Select TRB1
Use
Select SD1

Return

*-------------------------*
Static Function RunProc1()
*-------------------------*
Select SC7
dbSetOrder(1)
go top
//Seek xFilial()+cNum
ProcRegua(reccount())
Do while !eof()

  IncProc()
  if year(c7_emissao)<2004
     Skip
     Loop
  Endif
  if sc7->c7_conapro=="L" .or. sc7->c7_quje>=sc7->c7_quant .or. sc7->c7_residuo=="S"
    Skip 
    Loop
  endif
  Select SA2
  seek xFilial()+sc7->(c7_fornece+c7_loja)
  Select SE4
  dbSetOrder(1)
  Seek xFilial()+sc7->c7_cond
  Select SB1
  seek xFilial()+sc7->c7_produto
  Select SB2
  seek xFilial()+sc7->c7_produto
  nQtdUlt := nPrcUlt := 0
  cMsgAnt := Space(1)
  VerUlt()
  Select TRB1
  Seek sc7->c7_num
  cNum1 := " "
  if eof()
     cNum1 := sc7->c7_num
  endif
  if rlock()
     appe blan
     trb1->emissao := sc7->c7_emissao
     trb1->entrega := sc7->c7_datprf
     trb1->cod     := sc7->c7_produto
     trb1->um      := sc7->c7_um
     trb1->desc    := sc7->c7_descri
     trb1->num     := sc7->c7_num
     trb1->ped     := cNum1
     trb1->item    := sc7->c7_item
     trb1->sequen  := sc7->c7_sequen
     trb1->qtde    := sc7->c7_quant
     trb1->unit    := sc7->c7_preco
     trb1->total   := sc7->c7_total
     trb1->forn    := sc7->c7_fornece+sc7->c7_loja
     trb1->nome    := sa2->a2_nome
     trb1->condpag := se4->e4_descri
     trb1->msg     := sc7->c7_msg
     trb1->sld     := sb2->b2_qatu
     trb1->std     := sb1->b1_custd
     trb1->dtult   := sb1->b1_ucom
     trb1->prcult  := nPrcUlt
//   trb1->prcult  := sb1->b1_uprc
     trb1->qtdult  := nQtdUlt
     trb1->msgant  := cMsgAnt
     nIcm := sc7->c7_valicm/sc7->c7_quant
     Do Case
     case left(sc7->c7_msg,1)=="A"
       trb1->liq     := sc7->c7_preco-(nIcm*.5)
     case left(sc7->c7_msg,1)=="B"
       trb1->liq     := sc7->c7_preco-(nIcm*.2)
     case left(sc7->c7_msg,1)=="C"
       trb1->liq     := sc7->c7_preco-(nIcm)
     case left(sc7->c7_msg,1)=="D"
       trb1->liq     := sc7->c7_preco
     otherwise
       trb1->liq     := sc7->c7_preco-(nIcm)
     EndCase
//AADD(aCampos,{ "LIQ"     , "N",11,2}) 

  endif
  Select SC7
  skip
Enddo

Tela()
Return
***********************
Static Function Tela()
***********************

Select TRB1
go top
aCampos1 := {}
AADD(aCampos1,{ "EMISSAO" , "Emissao"}) 
AADD(aCampos1,{ "MSG"     , "Msg"}) 
//AADD(aCampos1,{ "NUM"     , "Pedido"}) 
AADD(aCampos1,{ "PED"     , "Pedido"}) 
AADD(aCampos1,{ "COD"     , "Cod","!!!!!!!!!!!!"}) 
AADD(aCampos1,{ "DESC"    , "Descr."}) 
AADD(aCampos1,{ "UM"      , "Um","!!"}) 
AADD(aCampos1,{ "QTDE"    , "Qtde","@E 999999.99"}) 
AADD(aCampos1,{ "UNIT"    , "V.Unit","@E 9999999.99"}) 
AADD(aCampos1,{ "TOTAL"   , "V.Tot.","@E 9999,999.99"}) 
AADD(aCampos1,{ "LIQ"     , "V.Liq","@E 9999999.99"}) 
AADD(aCampos1,{ "STD"     , "Prc.Base","@E 999,999.99"}) 
AADD(aCampos1,{ "PRCULT"  , "Ult.Preco","@E 999,999.99"}) 
AADD(aCampos1,{ "DTULT"   , "Ult.Comp."}) 
AADD(aCampos1,{ "MSGANT"  , "Msg.Ant."}) 
AADD(aCampos1,{ "SLD"     , "Saldo","@E 999,999.99"}) 
//AADD(aCampos1,{ "FORN"    , "C",08,0}) 
AADD(aCampos1,{ "NOME"    , "Nome Forn."}) 
AADD(aCampos1,{ "CONDPAG" , "Cond.Pgto"}) 
AADD(aCampos1,{ "ENTREGA" , "Prev.Entr"}) 

@ 100,1 TO 440,770 DIALOG oDlg4 TITLE "Itens do Pedido"

@ 6,5 TO 103,370 BROWSE "TRB1" FIELDS aCampos1

//@ 005,190 BUTTON "_Libera"    SIZE 40,15 ACTION Libera()
//@ 025,190 BUTTON "_Consulta " SIZE 40,15 ACTION Consulta()
//@ 045,190 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg4) 
//@ 115,005 say trb1->MSG
//@ 115,025 say trb1->emissao
//@ 115,025 say se4->e4_descri
//@ 115,060 say sa2->a2_nome
@ 130,010 BUTTON "_Libera"    SIZE 40,15 ACTION Libera()
@ 130,060 BUTTON "_Consulta " SIZE 40,15 ACTION Consulta()
@ 130,110 BUTTON "_Ped.Comp." SIZE 40,15 ACTION VerPed()
@ 130,160 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg4) 


ACTIVATE DIALOG oDlg4 CENTERED
Return

*-------------------------*
Static Function VerPed()
*-------------------------*
AxCadastro("SC7","Pedidos de Compras")
Return

*-------------------------*
Static Function Libera()
*-------------------------*
Select SC7
dbSetOrder(1)
Seek xFilial()+trb1->(num+item+sequen)
Do while !eof() .and. c7_num == trb1->num
  if !eof() .and. rlock()
   sc7->c7_conapro := "L"
  endif
  skip
Enddo
Select SCR
dbSetOrder(1)
Seek xFilial()+trb1->num
Do while !eof() .and. cr_num == trb1->num
   if rlock()
     scr->cr_userlib := upper(substr(cUsuario,7,5))
     scr->cr_vallib  := scr->cr_total
     scr->cr_datalib := ddatabase
   Endif
   Skip
Enddo
Select Trb1
cNum := trb1->num
Do while !eof() .and. trb1->num==cNum
   if rlock()
      Dele
   endif
   Skip
enddo
MsgBox ("Pedido Liberado - "+cNum,"Informa‡Æo","INFO")
Close(oDlg4)
Tela()

Return

*-------------------------*
Static Function Consulta()
*-------------------------*

cPerg      := "PCOM04"
Pergunte (cPerg,.T.)
mv_par03 := mv_par04 := trb1->cod

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros                                                              ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Do produto                                                  ³
// ³ mv_par04 => Ate Produto                                                 ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "EMISSAO" , "D",08,0}) 
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "DESC"    , "C",30,0}) 
AADD(aCampos,{ "QTDE"    , "N",12,2}) 
AADD(aCampos,{ "UNIT"    , "N",12,2}) 
AADD(aCampos,{ "LIQ"     , "N",12,2}) 
AADD(aCampos,{ "TOTAL"   , "N",12,2}) 
AADD(aCampos,{ "TES"     , "C",03,0}) 
AADD(aCampos,{ "MSG"     , "C",03,0}) 
AADD(aCampos,{ "CF"      , "C",04,0}) 
AADD(aCampos,{ "TEXTO"   , "C",15,0}) 
AADD(aCampos,{ "FORN"    , "C",08,0}) 
AADD(aCampos,{ "NOME"    , "C",30,0}) 
AADD(aCampos,{ "CONDPAG" , "C",15,0}) 
AADD(aCampos,{ "OK"      , "C",02,0}) 

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa( {|| RunProc() } )
Select TRB
Use
Select SD1
//Retindex("SD1")
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SD1
dbSetOrder(2)
set softseek on
seek xFilial()+mv_par03
set softseek off
ProcRegua(150)
Do while !eof() .and. d1_cod>=mv_par03 .and. d1_cod<=mv_par04
  IncProc()
  if d1_dtdigit<mv_par01 .or. d1_dtdigit>mv_par02 .or. ;
     d1_cod<mv_par03 .or. d1_cod>mv_par04
     Skip
     loop
  Endif
  Select SC7
  xReg := Recno()
  dbSetOrder(1)
  Seek xFilial()+sd1->d1_pedido
  xMsg := sc7->c7_msg
  Goto xReg
  Select SF1
  dbSetOrder(1)
  Seek xFilial()+sd1->(d1_doc+d1_serie+d1_fornece+d1_loja)
  Select SD1
  ntot := ntot1 := nQtd := 0
  cDoc := d1_doc
  cTes := d1_tes
  cCod := d1_cod
  Do while !eof() .and. d1_cod=cCod .and. d1_doc==cDoc
//   nTot := nTot+d1_total+d1_valipi
     nTot := nTot+d1_total
     nTot1:= nTot1+d1_custo
     nQtd := nQtd+d1_quant
     Skip
  Enddo
  Skip-1

  Select SB1
  dbSetOrder(1)
  Seek xFilial()+cCod
  Select SF4
  dbSetOrder(1)
  Seek xFilial()+cTes
  Select SE4
  dbSetOrder(1)
  Seek xFilial()+sf1->f1_cond
  Select SA2
  dbSetOrder(1)
  Seek xFilial()+sf1->f1_fornece+sf1->f1_loja

  Select TRB
  if rlock()
         Appe Blan
         trb->emissao:= sf1->f1_dtdigit
         trb->Num    := sf1->f1_doc
         trb->Cod    := sd1->d1_cod
         trb->Desc   := sb1->b1_desc
         trb->Qtde   := nQtd
         trb->Total  := nTot
         trb->Liq    := nTot1/nQtd
         trb->Unit   := nTot/nQtd
         trb->tes    := cTes
         trb->msg    := xMsg
         trb->cf     := sd1->d1_cf 
         trb->texto  := sf4->f4_texto
         trb->forn   := sd1->d1_fornece+sd1->d1_loja
         trb->Nome   := sa2->a2_nome
         trb->Condpag:= se4->e4_descri
  Endif
  Select SD1
  Skip
Enddo

@ 100,1 TO 600,750 DIALOG oDlg2 TITLE "Verifica Preco"

Select TRB
go top
aCampos := {}
AADD(aCampos,{"Emissao","Data Dig"})
AADD(aCampos,{"Num","NF"})
AADD(aCampos,{"MSG","Msg"})
//AADD(aCampos,{"Cod","Cod.Prod."}) 
AADD(aCampos,{"Qtde","Quant" ,"@E 999,999.99"})
AADD(aCampos,{"Unit","V.Unit","@E 999,999.99"})
AADD(aCampos,{"Liq","V.Liq","@E 999,999.99"})
AADD(aCampos,{"Total","Total NF","@E 999,999.99"})
AADD(aCampos,{"Texto","Operacao"})
AADD(aCampos,{"Nome","Fornec"})
AADD(aCampos,{"CondPag","Pagto"})
//AADD(aCampos,{"Desc","Produto"})

//@ 15,5 TO 210,350 BROWSE "TRB" FIELDS aCampos ENABLE "OK" MARK "OK"
@ 15,5 TO 210,350 BROWSE "TRB" FIELDS aCampos 

//@ 220,020 BUTTON "_Ok" SIZE 40,15 ACTION GeraOrdem()
//@ 220,070 BUTTON "_Limpa" SIZE 40,15 ACTION limpaok()
@ 220,120 BUTTON "_Sair" SIZE 40,15 ACTION Close(oDlg2)
//@ 02,155 SAY "- Clicar nos pedidos que irao gerar OP"

ACTIVATE DIALOG oDlg2 CENTERED
Return

//EscolhePed()
Return

*-------------------------*
Static Function VerUlt()
*-------------------------*
Select SD1
dbSetOrder(6)
seek xFilial()+dtos(sb1->b1_ucom)
do while !eof() .and. d1_dtdigit==sb1->b1_ucom
  if sd1->d1_cod == sb1->b1_cod
    nQtdUlt := sd1->d1_quant
    nPrcUlt := sd1->d1_custo/sd1->d1_quant
    Select SC7
    x:=recno()
    dbSetOrder(1)
    Seek xFilial()+sd1->d1_pedido
    if !eof()
      cMsgAnt := sc7->c7_msg
    endif
    goto x
    Select SD1
  endif 
  skip
enddo
