#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RFIN002()        // Relacao de Faturamento por Vendedor

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Faturamento por Vendedor"
cDesc2   := ""
cDesc3   := ""
cPerg    := "RFIN01"
cString  := "SE1"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFIN002"
titulo   := "Relacao de Faturamento por Vendedor"
wnrel    := "RFIN002"
limite   := 132
tamanho  := "P"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Periodo de                                      ³
//³ mv_par02  // Periodo ate                                     ³
//| mv_par03  // Vendedor de                                     ³
//| mv_par04  // Vendedor ate                                    ³
//| mv_par05  // Cliente de        		     		 ³
//| mv_par06  // Cliente ate                                     ³
//| mv_par07  // Serie de          		     		 ³
//| mv_par08  // Serie Ate                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C030Imp  ³ Autor ³ Luiz Eduardo          ³ Data ³ 10/12/2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C030Imp                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico p/ Espelhos Leao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> Function C030Imp
Static Function C030Imp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Select SE1
dbSetOrder(6)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off
cTrb := Criatrab(nil,.f.)
Copy to &cTrb next 1000000 for e1_emissao<=mv_par02
dbUseArea( .T.,, cTrb,"TRB", .F., .F. )
go top
do while !eof() .and. 1==2
  Select SC5
  dbSetOrder(1)
  Seek xFilial()+TRB->E1_pedido
  if e1_vend1<MV_PAR03 .or. e1_vend1>MV_PAR04 .and. rlock()
     dele
     skip 
     loop
  endif
  if trb->e1_cliente<MV_PAR05 .or. trb->e1_cliente>MV_PAR06 .and. rlock()
     dele
     skip 
     loop
  endif
  if rlock() .and. trb->e1_vend1==space(6)
     trb->e1_vend1 := sc5->c5_vend1
  endif
  Skip
Enddo
Imprime()
Select TRB
Use
Return

Static function Imprime()

cNum := "S"
@ 196,52 TO 343,505 DIALOG oDlg2 TITLE ""
@ 15,010 TO 45,180 
@ 26,030 Say "Relatorio Resumido ? " 
@ 26,100 get cNum picture "@!" SIZE 40,20  VALID "S*N*B"
@ 50,150 BUTTON "Confirma" Size 40,15  ACTION DgtEst()// Substituido pelo assistente de conversao do AP5 IDE em 15/08/01 ==>   @ 50,150 BUTTON "Confirma" Size 40,15  ACTION Execute(DgtEst)
ACTIVATE DIALOG oDlg2 CENTERED
Return  

Static Function DgtEst()
Close(oDlg2)

Cabec1 := "Pedido        Cliente                   Prf NF      Valor        Emissao"
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         0         1         2         3         4         5         6         7         8
Cabec2 := ""
Select TRB
index on trb->e1_vend1+trb->e1_num to &cTrb
Go top
SetRegua(recCount())
li := 80
nTot := 0
Do while !eof()
   IncRegua()
   if e1_vend1<MV_PAR03 .or. e1_vend1>MV_PAR04
     skip 
     loop
   endif
   if trb->e1_cliente<MV_PAR05 .or. trb->e1_cliente>MV_PAR06
     skip 
     loop
   endif

   cVend := trb->e1_vend1
   nTotv := 0
   If li > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif
   Select SA3
   dbSetOrder(1)
   Seek xFilial()+trb->e1_vend1
   Select TRB
   @ li,000 PSAY "Vendedor : "+trb->e1_vend1+"-"+sa3->a3_nreduz
   li := li + 1
   Do while !eof() .and. trb->e1_vend1==cVend
   if trb->e1_cliente<MV_PAR05 .or. trb->e1_cliente>MV_PAR06
      skip 
      loop
   endif
   if cNum#"B" .and. (trb->e1_prefixo=="001" .or. trb->e1_prefixo=="002")
// if cNum#"B" .and. trb->e1_prefixo=="001"
      skip 
      loop
   endif
   If li > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
        @ li,000 PSAY "Vendedor : "+trb->e1_vend1+"-"+sa3->a3_nreduz
        li := li + 1
   Endif
// Select SD2
// dbSetOrder(3)
// Seek xFilial()+TRB->e1_num
   Select SC5
   dbSetOrder(1)
   Seek xFilial()+TRB->E1_pedido
   if c5_vend1<MV_PAR03 .or. c5_vend1>MV_PAR04
      Select TRB
      skip 
      loop
   endif
   Select SA1
   dbSetOrder(1)
   Seek xFilial()+trb->(e1_cliente+e1_loja)
   Select TRB
// @ li,000 PSAY trb->e1_vend1+"-"+sa3->a3_nreduz
// @ li,025 PSAY TRB->e1_nomcli
   @ li,001 PSAY TRB->e1_pedido
   @ li,008 PSAY left(sa1->a1_nome,30)
   @ li,040 PSAY TRB->(e1_prefixo+e1_num+e1_parcela)
   @ li,052 PSAY TRB->e1_valor picture "@E 9,999,999.99"
   @ li,066 PSAY TRB->e1_emissao
   nTot := nTot + TRB->e1_valor
   nTotv:= nTotv+ TRB->e1_valor
   li:=li+1
   Select TRB
   Skip
   Enddo
   li:=li+1
   @ li,005 PSAY "Total do vendedor "+cVend+" : "+sa3->a3_nreduz
   @ li,052 PSAY nTotv picture "@E 99,999,999.99"
   li:=80
Enddo
//@ prow()+2,035 PSAY "Total : "
//@ prow()+2,052 PSAY nTot picture "@E 99,999,999.99"

IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Spool de Impressao.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen
Select SE1
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
