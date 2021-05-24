#include "rwmake.ch"  

User Function GeraOp1()   // Programa para gerar OP's separando Espelhos de Qds

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

if !MsgBox ("Confirma processamento ?","Escolha","YESNO")
   Return
endif

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
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa( {|| RunProc() } )
Retindex("SC2")
Select TRB
Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SB1
dbSetOrder(1)
go top
ProcRegua(Reccount())
Do while !eof()
  IncProc()
  If sb1->b1_emin==0
     skip
     loop
  Endif
  Select SC2
  dbSetOrder(2)
  Seek xFilial()+sb1->b1_cod
  nQtOp := 0
  do while !eof() .and. c2_produto == sb1->b1_cod
    if sc2->c2_quant-sc2->c2_quje<=0
       Skip
       Loop
    Endif
    nQtOp := nQtOp + sc2->c2_quant-sc2->c2_quje
    Skip
  Enddo
  Select SB1
  if left(sb1->b1_cod,2) == '10'
      cCod := "00"+SUBSTR(sb1->b1_cod,3,13)
  else
      cCod := sb1->b1_cod
  Endif
  Select SB2
  Seek xFilial()+sb1->b1_cod
  nQtdVen := b2_qpedven+b2_reserva  
  nSal    := sb2->b2_qatu
  seek xFilial()+cCod
  if !eof()
    nQtdVen := nQtdVen + b2_qpedven+b2_reserva
    nSal    := nSal+sb2->b2_qatu
  Endif
  nProd   := nSal - sb1->b1_emin + nQtOp - nQtdVen
  Select TRB
  if rlock() .and. nProd<0
         Appe Blan
         trb->Cod    := sb1->b1_cod
         trb->Desc   := sb1->b1_desc
         trb->Qtde   := -nProd
  Endif
  Select SB1
  Skip
Enddo

EscolhePed()
Return

*--------------------------*
Static Function GeraOrdem()
*--------------------------*
Close(oDlg2)
Select Trb
index on cod to &cTemp
Go top
Do while !eof()

  if Marked("OK") 
    Skip
    Loop
  endif

  cNum := 0
  cPed := trb->Num
  BuscaNum()
  Select TRB
  cNum := "A"+strzero(cNum,5)
  Select SB1
  dbSetOrder(1)
  Seek trb->Cod
  Select TRB
  cCod := trb->Cod
  if Qtde#0
    GravaSC2() 
  endif  
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
sc2->c2_Num    := cNum
sc2->c2_Item   := "01"
sc2->c2_Sequen := "001"
sc2->c2_Produto:= cCod
sc2->c2_Local  := "01"
sc2->c2_Quant  := trb->Qtde
sc2->c2_um     := sb1->b1_um
sc2->c2_datpri := dDataBase+1
sc2->c2_datprf := dDataBase+1
sc2->c2_emissao:= Date()
sc2->c2_prior  := "500"
sc2->c2_destina:= " "
sc2->c2_Segum  := sb1->b1_segum
sc2->c2_Tpop   := "F"
MsUnlock()
Return


*-------------------------*
Static Function EscolhePed()
*-------------------------*

@ 200,1 TO 500,600 DIALOG oDlg2 TITLE "Escolha de Produtos"

Select TRB
go top
aCampos := {}
AADD(aCampos,{"OK","OK"})   
AADD(aCampos,{"Cod","Cod.Prod."}) 
AADD(aCampos,{"Desc","Descricao do Produto"})
AADD(aCampos,{"Qtde","Qtd.Produzir"})

@ 15,5 TO 110,300 BROWSE "TRB" FIELDS aCampos ENABLE "OK" MARK "OK"

@ 120,020 BUTTON "_Ok" SIZE 40,15 ACTION GeraOrdem()
@ 120,070 BUTTON "_Limpa" SIZE 40,15 ACTION limpaok()
@ 120,120 BUTTON "_Cancela" SIZE 40,15 ACTION Close(oDlg2)
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


