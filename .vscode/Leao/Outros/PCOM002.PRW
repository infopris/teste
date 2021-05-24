#include "rwmake.ch"  

User Function PCom002()   // Consulta ultimo preco de compra

cPerg      := "PCM002"
Pergunte (cPerg,.T.)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Do produto                                                  ³
// ³ mv_par04 => Ate Produto                                                 ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "DTDIGIT" , "D",08,0}) 
AADD(aCampos,{ "EMISSAO" , "D",08,0}) 
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "DESC"    , "C",30,0}) 
AADD(aCampos,{ "QTDE"    , "N",12,2}) 
AADD(aCampos,{ "UNIT"    , "N",12,4}) 
AADD(aCampos,{ "TOTAL"   , "N",12,2}) 
AADD(aCampos,{ "TOTALG"  , "N",12,2}) 
AADD(aCampos,{ "FRETE"   , "N",12,4}) 
AADD(aCampos,{ "DESP"    , "N",12,4}) 
AADD(aCampos,{ "TES"     , "C",03,0}) 
AADD(aCampos,{ "CF"      , "C",04,0}) 
AADD(aCampos,{ "TEXTO"   , "C",15,0}) 
AADD(aCampos,{ "FORN"    , "C",08,0}) 
AADD(aCampos,{ "NOME"    , "C",30,0}) 
AADD(aCampos,{ "CONDPAG" , "C",15,0}) 
AADD(aCampos,{ "ITENSNF" , "C",02,0}) 
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
  Select SF1
  dbSetOrder(1)
  Seek xFilial()+sd1->(d1_doc+d1_serie+d1_fornece+d1_loja)
  Select SD1
  ntot := nTotg := nQtd := 0
  cDoc := d1_doc
  cTes := d1_tes
  cCod := d1_cod
  cForn:= d1_fornece
  nIt  := 0
  Do while !eof() .and. d1_cod=cCod .and. d1_doc==cDoc .and. d1_fornece==cForn
     nTot := nTot +d1_total
     nTotg:= nTotg+d1_total +d1_valipi
     nQtd := nQtd +d1_quant
     nIt  := nIt  + 1
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
  nDespfin := sf1->f1_despesa/sf1->f1_valmerc*sd1->d1_total
  nDespFrt := sf1->f1_frete/sf1->f1_valmerc*sd1->d1_total
  nTot     := nTot + nDespfin
  nTotg    := nTotg + nDespFin + nDespFrt
  Select TRB
  reclock("TRB",.t.)
         trb->dtdigit:= sf1->f1_dtdigit
         trb->emissao:= sf1->f1_emissao
         trb->Num    := sf1->f1_doc
         trb->Cod    := sd1->d1_cod
         trb->Desc   := sb1->b1_desc
         trb->Qtde   := nQtd
         trb->Total  := nTot
         trb->TotalG := nTotG
         trb->frete  := nDespFrt
         trb->Desp   := nDespFin
         trb->Unit   := nTot/nQtd
         trb->tes    := cTes
         trb->cf     := sd1->d1_cf 
         trb->texto  := sf4->f4_texto
         trb->forn   := sd1->d1_fornece+sd1->d1_loja
         trb->Nome   := sa2->a2_nome
         trb->Condpag:= se4->e4_descri
         trb->ItensNF:= iif(nIt>1,strzero(nIt,2)," ")
  MsUnLock()
  Select SD1
  Skip
Enddo

@ 100,1 TO 600,750 DIALOG oDlg2 TITLE "Verifica Preco"

Select TRB
if mv_par05==2
	Index on Emissao to &cTemp
endif
go top
aCampos := {}
AADD(aCampos,{"Emissao","Emissao"})
AADD(aCampos,{"Num","NF"})
AADD(aCampos,{"Cod","Cod.Prod."}) 
AADD(aCampos,{"Qtde","Quant" ,"@E 999,999.99"})
AADD(aCampos,{"Unit","V.Unit (s/IPI)","@E 999,999.9999"})
AADD(aCampos,{"Total","Total s/IPI","@E 999,999.99"})
AADD(aCampos,{"Totalg","Total a PG","@E 999,999.99"})
AADD(aCampos,{"Texto","Operacao"})
AADD(aCampos,{"Nome","Fornec"})
AADD(aCampos,{"CondPag","Pagto"})
AADD(aCampos,{"Desc","Produto"})
AADD(aCampos,{"ItensNF","Itens NF"})
AADD(aCampos,{"Dtdigit","Data Dig"})
AADD(aCampos,{"Frete","Frete","@E 999,999.9999"})
AADD(aCampos,{"Desp","Despesa","@E 999,999.9999"})

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

