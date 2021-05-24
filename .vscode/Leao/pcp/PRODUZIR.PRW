#include "rwmake.ch"  

User Function Produzir()   // Relatorio de necessidade de produ‡Æo

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "PROD01"
Pergunte (cPerg,.T.)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Analitico / Sintetico                                       ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cString:="SC2"
cDesc1:= OemToAnsi("Relacao das OP's no periodo")
cDesc2:= OemToAnsi("      ")
cDesc3:= ""
tamanho:="M"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="Produzir - By L.E."
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Rel.das OP's de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
cabec1      :="Num.Op It Cod.Produto       Descricao                      Quantidade   Data"
cabec2      :=""
//cabec2      :="Ordens de Producao"
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 1  //Variavel que acumula numero da pagina

wnrel:="PRODUZIR"            //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "ITEM"    , "C",02,0}) 
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "DESC"    , "C",30,0}) 
AADD(aCampos,{ "CLI"     , "C",30,0}) 
AADD(aCampos,{ "QTDE"    , "N",12,2}) 
AADD(aCampos,{ "ENTREGA" , "D",08,0}) 
AADD(aCampos,{ "TIPO"    , "C",02,0}) 
AADD(aCampos,{ "OK"      , "C",02,0}) 
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 16/08/01 ==> RptStatus({|| Execute(RptDetail) })
Select TRB
Use
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function RptDetail()


*----------------------------------*
* Processa pedidos de Vendas
*----------------------------------*

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
     trb->desc    := sb1->b1_desc
     trb->cli     := sa1->a1_nome
     trb->qtde    := sc6->c6_qtdven-sc6->c6_qtdent
     trb->entrega := sc6->c6_entreg
     trb->tipo    := "PV"
   Endif
  Endif
  Select SC6
  Skip
Enddo

*----------------------------------*
* Processa Ordens de Producao
*----------------------------------*

Select SC2
dbSetOrder(1)
//set softseek on
//seek xFilial()+dtos(mv_par01)
//set softseek off
SetRegua(recno())
Do while !eof() .and. c2_emissao>=mv_par01 .and. c2_emissao<=mv_par02 
   incRegua()
   if sc2->c2_quant<=sc2->c2_quje .or. sc2->c2_datrf#ctod("0")
     Skip
     loop
   Endif

   if left(sc2->c2_produto,2) == '00'
     cCod := "10"+SUBSTR(sc2->c2_produto,3,13)
     if rlock()
       sc2->c2_produto := cCod
     endif
   else
     cCod := sc2->c2_produto
   endif
   Select SC5
   dbSetOrder(1)
   seek xFilial()+sc2->c2_num
   Select SA1
   dbSetOrder(1)
   seek xFilial()+sc5->c5_cliente
   Select SB1
   seek xFilial()+cCod
   Select TRB
   if rlock()
      appe blan
      trb->num  := sc2->c2_num
      trb->item := sc2->c2_item
      trb->cod  := cCod
      trb->desc := sb1->b1_desc
      trb->cli  := sa1->a1_nome
      trb->qtde := sc2->c2_quant-sc2->c2_quje
      trb->entrega := sc2->c2_datpri
      trb->tipo    := "OP"
   Endif
   Select SC2
   Skip
Enddo

*----------------------------------*
* Impressao do Relatorio
*----------------------------------*

Select SB2
dbSetOrder(1)

Select TRB
index on cod to &cTemp
go top
SetRegua(recno())
nLin := 80
cabec2      :=""

Do while !eof()
  if nLin >60
     Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) 
     nLin := 9
  endif
  IncRegua()
  cCod := Cod
  nPed := nOp := 0
  Do while !eof() .and. cod==cCod
    if mv_par03==2
      @ nLin,00 psay num+"-"+item
      @ nLin,10 psay cod
      @ nLin,28 psay desc
      @ nLin,60 psay qtde picture "@E 99,999.99"
      @ nLin,70 psay entrega
      @ nLin,80 psay tipo
      @ nLin,84 psay cli
      nLin := nLin + 1
    endif
    if tipo=="PV"
       nPed := nPed + qtde
    elseif tipo=="OP"
*      nOP  := nOP  + qtde       // Liberar esta linha qdo a Op estiver funcion
    endif
    Skip
  Enddo
  Select SB2
  Seek xFilial()+trb->Cod
  Select TRB
  if sb2->b2_qatu-nPed+nOp > 0
     Skip
     Loop
  endif
  if mv_par03==2
    @ nLin,00 psay "Total : "
  else
    @ nLin,00 psay cod
    @ nLin,18 psay desc
  Endif
  @ nLin,60 psay sb2->b2_qatu-nPed+nOp picture "@E 99,999.99"
  nLin := nLin + 1
  skip
Enddo

//if nlin<60
  Roda(0,"","P")
//Endif
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

***************** Fim do Programa ************************
