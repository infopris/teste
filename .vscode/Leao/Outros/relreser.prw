#include "rwmake.ch"  

User Function RelReser()   // Relatorio das Reservas

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "RELOP1"
Pergunte (cPerg,.T.)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da Entrega (pedido)                                         ³
// ³ mv_par02 => Ate entrega                                                 ³
// ³ mv_par03 => Numero OP                                                   ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cString:="SC0"
cDesc1:= OemToAnsi("Relacao das Reservas do periodo")
cDesc2:= OemToAnsi("      ")
cDesc3:= ""
tamanho:="M"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="RELRESER"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Entregas de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
cabec1      :="Pedido It Cod.Produto     Descricao                                  Quant Entrega   Cliente"
cabec2      :=""

cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 1  //Variavel que acumula numero da pagina

wnrel:="RELRESER"            //Nome Default do relatorio em Disco
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

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 16/08/01 ==> RptStatus({|| Execute(RptDetail) })

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

Select SC0
dbSetOrder(1)
SetRegua(recno())
dbGoTop()
nLin := 80
nQtd := 0
Do while !eof() 
   IncRegua()
   Select SC6
   dbSetOrder(1)
   Seek xFilial()+sc0->c0_num+left(sc0->c0_docres,2)
   if c6_entreg<mv_par01 .or. c6_entreg<mv_par01
      Select SC0
      skip
      loop
   endif
   if nLin >60
     Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) 
     nLin := 9
   endif
   Select SC5
   dbSetOrder(1)
   seek xFilial()+sc0->c0_num
   Select SA1
   dbSetOrder(1)
   seek xFilial()+sc5->c5_cliente
   Select SB1
   seek xFilial()+sc0->c0_produto
    @ nLin,00 psay sc6->c6_num+"-"+sc6->c6_item
    @ nLin,10 psay sb1->b1_cod+" "+left(sb1->b1_desc,40)
    @ nLin,67 psay sc0->c0_Quant picture "@E 999,999"
    @ nLin,75 psay sc6->c6_entreg 
    @ nLin,85 psay sa1->a1_nome
    nLin := nLin + 1
    nQtd := nQtd + sc0->c0_Quant
   Select SC0
   Skip
Enddo
nLin := nLin + 1
@ nLin,00 psay "Total do periodo (em pecas)"
@ nLin,67 psay nQtd picture "@E 999,999"


if nlin<60
  Roda(0,"","P")
Endif
Set Filter To
If aReturn[5] == 1
   Set Printer To
   commit
   ourspool(wnrel)
Endif
MS_FLUSH() 
Return

