#include "rwmake.ch"  

User Function GeraOp()   // Programa para gerar OP's separando Espelhos de Qds

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "GERAOP"
Pergunte (cPerg,.T.)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Do pedido                                                   ³
// ³ mv_par04 => Ate Pedido                                                  ³
// ³ mv_par05 => Do Cliente                                                  ³
// ³ mv_par06 => At‚ Cliente                                                 ³
// ³ mv_par07 => Ordem      1-Pedido  2-Cliente  3-Produto                   ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "ITEM"    , "C",02,0}) 
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "DESC"    , "C",30,0}) 
AADD(aCampos,{ "QTDE"    , "N",12,2}) 
AADD(aCampos,{ "TES"     , "C",03,0}) 
AADD(aCampos,{ "CF"      , "C",04,0}) 
AADD(aCampos,{ "CLI"     , "C",06,0}) 
AADD(aCampos,{ "NOME"    , "C",30,0}) 
AADD(aCampos,{ "CONDPAG" , "C",15,0}) 
AADD(aCampos,{ "ENTREGA" , "D",08,0}) 
AADD(aCampos,{ "OK"      , "C",02,0}) 
AADD(aCampos,{ "NUM1"    , "C",06,0}) 
AADD(aCampos,{ "NOME1"   , "C",30,0}) 
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa( {|| RunProc() } )
Select SC2
Retindex("SC2")
Select TRB
Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SC5
dbSetOrder(2)
set softseek on
seek xFilial()+dtos(mv_par01)
set softseek off
ProcRegua(50)
Do while !eof()
  IncProc()
  if c5_emissao<mv_par01 .or. c5_emissao>mv_par02 .or. ;
     c5_num<mv_par03 .or. c5_num>mv_par04 .or. ;
     c5_cliente<mv_par05 .or. c5_cliente>mv_par06
     Skip
     loop
  Endif
  Select SC6
  Seek xFilial()+sc5->c5_num
  lPrim := .t.
  do while !eof() .and. c6_num == sc5->c5_num
    if !empty(sc6->c6_numop)
      Select SC2
      seek xFilial()+sc6->c6_numop
      if sc2->c2_produto==sc6->c6_produto .and. !eof()
        Select SC6
        Skip
        Loop
      Endif
//    if !eof() .and. sc6->c6_qtdven>c6_qtdent
//      Select SC6
//      Skip
//      Loop
//    Endif
      Select SC6
    endif
    if substr(c6_cf,2,1)# "1"
      Skip
      Loop
    Endif
    if sc6->c6_qtdven-sc6->c6_qtdent<=0
      Skip
      Loop
    endif
    Select SB1
    if left(sc6->c6_produto,2) == '00'
      cCod := "10"+SUBSTR(sc6->c6_produto,3,13)
    else
      cCod := sc6->c6_produto
    Endif
    seek xFilial()+cCod
//  if sb1->b1_emin#0
//    Select SC6
//    Skip
//    Loop
//  Endif
    Select SE4
    dbSetOrder(1)
    Seek xFilial()+sc5->c5_condpag
    Select SA1
    dbSetOrder(1)
    Seek xFilial()+sc5->c5_cliente+sc5->c5_lojacli
    Select TRB
    if rlock()
         Appe Blan
         trb->Num    := sc6->c6_num
         trb->Item   := sc6->c6_item
         trb->Cod    := cCod
         trb->Desc   := sb1->b1_desc
         trb->Qtde   := sc6->c6_qtdven-sc6->c6_qtdent
         trb->tes    := sc6->c6_tes
         trb->cf     := sc6->c6_cf 
         trb->Cli    := sc5->c5_cliente
         trb->Nome   := sa1->a1_nome
         trb->Entrega:= sc6->c6_entreg
         trb->Condpag:= se4->e4_descri
         if lPrim .or. mv_par07#1
           trb->Num1   := sc6->c6_num
           trb->Nome1  := sa1->a1_nome
           lPrim := .f.
         Endif
    Endif
    Select SC6
    Skip
  Enddo
  Select SC5
  Skip
Enddo

EscolhePed()
Return

*--------------------------*
Static Function GeraOrdem()
*--------------------------*
Close(oDlg2)
Select Trb
//1§ Gera Ordens de Espelhos
index on cod to &cTemp
Go top
Do while !eof()
  if left(cod,2)#"00" .and. left(cod,2)#"10"
    Skip
    loop
  Endif
  if left(cod,3)=="10."
    Skip
    loop
  Endif
  if Marked("OK") 
    Skip
    Loop
  endif

  cNum := 0
  cPed := trb->Num
  BuscaNum()
  Select TRB
  cNum := "A"+strzero(cNum,5)
  cCod := trb->Cod
  nQtd := 0
  do while !eof() .and. Cod == cCod
    if Marked("OK") 
     Skip
     Loop
    endif
    Select SC6
    seek xFilial()+trb->(num+item)
    if !empty(sc6->c6_numop)
       if !MsgBox ("Ja gerei op (Espelho) para este pedido "+trb->(Num+Item)+", gerar novamente ?","Escolha","YESNO")
         Select TRB
         skip
         loop
       Endif
    endif
    if rlock()
      sc6->c6_numop := cNum
    endif
    Select Trb
    nQtd := nQtd + Qtde
    Skip
  Enddo
  Select Sc5
  seek xFilial()+cPed
  Select SB1
  seek xFilial()+cCod
  lEsp := .t.
  if nQtd#0
    GravaSC2() 
  endif  
  Select TRB
//Skip
Enddo

Select Trb
//2§ Gera Ordens de Outros Produtos
index on cod to &cTemp
Go top
Do while !eof()
  if left(cod,2)=="00" .or. left(cod,2)=="10"
    Skip
    loop
  Endif
  if Marked("OK") 
    Skip
    Loop
  endif
  cPed := trb->Num
  Select Sc5
  seek xFilial()+cPed
  cCod := trb->Cod
  Select SB1
  seek xFilial()+cCod
  nQtd := trb->Qtde
  lEsp := .f.
  Select SC2
  dbSetOrder(1)
  Seek xfilial()+trb->(Num+Item)
  if !eof()
    if !MsgBox ("A OP "+trb->(Num+Item)+"ja foi gerada, apagar e gerar novamente ?","Escolha","YESNO")
      Select TRB
      Skip
      Loop
    else
      if rlock()
         Delete
      endif
    endif
  Endif
  GravaSC2() 
  Select TRB
  Skip
Enddo

Return

*-------------------------*
Static Function BuscaNum()
*-------------------------*
Select SC2
dbSetOrder(1)
go bott
if c2_num # "A"
  seek xFilial()+"A"
  if eof()
    cNum := 1
  Else
    Do while !eof() .and. c2_num == "A"
      cNum := val(substr(c2_num,2,5))+1
      Skip
    Enddo
  endif
Else
  cNum := val(substr(c2_num,2,5))+1
Endif
Return

*-------------------------*
Static Function GravaSC2()
*-------------------------*
reclock("SC2",.t.)
sc2->c2_filial := xFilial()
sc2->c2_Num    := if(lEsp,cNum,trb->num)
sc2->c2_Item   := if(lEsp,"01",trb->item)
sc2->c2_Sequen := "001"
sc2->c2_Produto:= cCod
sc2->c2_Local  := "01"
sc2->c2_Quant  := nQtd
sc2->c2_um     := sb1->b1_um
sc2->c2_datpri := iif(dDataBase>trb->Entrega,dDataBase,trb->Entrega)
sc2->c2_datprf := iif(dDataBase>trb->Entrega,dDataBase,trb->Entrega)
sc2->c2_emissao:= dDataBase
sc2->c2_prior  := "500"
sc2->c2_destina:= " "
sc2->c2_Segum  := sb1->b1_segum
sc2->c2_Tpop   := "F"
sc2->c2_pedido := trb->num
sc2->c2_Itempv := trb->item
MsUnlock()
Return


*-------------------------*
Static Function EscolhePed()
*-------------------------*

//@ 200,1 TO 500,600 DIALOG oDlg2 TITLE "Escolha de Pedidos"
@ 100,1 TO 600,700 DIALOG oDlg2 TITLE "Escolha de Pedidos"

Select TRB
Do case
Case mv_par07 == 1
  index on num to &cTemp
Case mv_par07 == 2
  index on nome to &cTemp
Case mv_par07 == 3
  index on cod to &cTemp
Endcase

go top
aCampos := {}
AADD(aCampos,{"OK","OK"})   
AADD(aCampos,{"Num1","Pedido","@!"})
AADD(aCampos,{"Cod","Cod.Prod."}) 
AADD(aCampos,{"Nome1","Nome Cliente"})
AADD(aCampos,{"Qtde","Quant"})
AADD(aCampos,{"CondPag","Pagto"})
AADD(aCampos,{"Entrega","Prev.Entrega"})
AADD(aCampos,{"Desc","Descricao do Produto"})
@ 15,5 TO 210,350 BROWSE "TRB" FIELDS aCampos ENABLE "OK" MARK "OK"

@ 220,020 BUTTON "_Ok" SIZE 40,15 ACTION GeraOrdem()
@ 220,070 BUTTON "_Limpa" SIZE 40,15 ACTION limpaok()
@ 220,120 BUTTON "_Cancela" SIZE 40,15 ACTION Close(oDlg2)
@ 02,155 SAY "- Clicar nos pedidos que irao gerar OP"
ACTIVATE DIALOG oDlg2 CENTERED
Return

*-------------------------*
Static Function LimpaOk()
*-------------------------*
Close(oDlg2)
Select TRB
go top
Do while !eof()
  if rlock()
     trb->ok     := "  "
  Endif
  Skip
Enddo
EscolhePed()
return

***************** Fim do Programa ************************



@ 200,1 TO 400,530 DIALOG oDlg2 TITLE "Escolha de Pedidos"

Select TRB
go top
aCampos := {}
//AADD(aCampos,{"Num","Pedido","@!"})
AADD(aCampos,{"Cod","Cod.Prod."}) 
AADD(aCampos,{"Desc","Descricao do Produto"})
AADD(aCampos,{"OK","OK"})   
@ 6,5 TO 93,150 BROWSE "TRB" FIELDS aCampos ENABLE "NUM" MARK "OK"
//@ 6,5 TO 93,150 BROWSE "SC6" ENABLE "C6_QTDENT" MARK "C6_OK"

// Para avaliar se o registro esta marcado utilize:
// ...
// if Marked("C6_OK") 
//   ...
// endif

@ 70,180 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg2)
ACTIVATE DIALOG oDlg2 CENTERED
Return



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