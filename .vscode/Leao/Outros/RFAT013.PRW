#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RFAT013()        // Relatorio de Pedidos a faturar por periodo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("ARETURN,CBTXT,CBCONT,CDESC1,CDESC2,CDESC3")
SetPrvt("CPERG,CSTRING,LI,M_PAG,NLASTKEY,NOMEPROG")
SetPrvt("TITULO,WNREL,LIMITE,TAMANHO,ACPOTRB,ATAM")
SetPrvt("CNOMARQ,CKEY,CTPPED,CARQ,CFILTER,CKEY2")
SetPrvt("CARQIND,ASECAO,AVENDEDOR,NVLCOMIS,NVLNETO,NCUSTO")
SetPrvt("NLINHA,NTOTCOMI,CABEC1,CABEC2,NTGFATURA,NTGCOMIS")
SetPrvt("NTGIPI,NTGICMS,NTGVLNETO,NTGCUSTO,NTGFRETE,NTGCOMIBR")
SetPrvt("NTGCOMIAL,NTGEXTRAS,NTGVLCOMI,ATOTAL,LCABECPRIM,CTPPEDIDO")
SetPrvt("CTIT,I,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴컴엽�
굇쿑un뇚o    � RFAT011  � Autor � Luiz Eduardo          � Data � 06/11/2003 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴컴눙�
굇쿢so       � Especifico p/ Espelhos Leao                                  낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Atualizacoes sofridas desde a Construcao Inicial.                       낢�
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Programador  � Data   � BOPS �  Motivo da Alteracao                     낢�
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�              �        �      �                                          낢�
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/


aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos em Carteira "
cDesc2   := "por periodo"
cDesc3   := ""
cPerg    := "RFT013"
cString  := "SC5"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT013"
titulo   := "Pedidos a Faturar"
wnrel    := "RFAT013"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Perguntas :                                                  �
//� mv_par01  // Entrega de                                      �
//� mv_par02  // Entrega ate                                     �
//� mv_par03  // Cliente de                                      �
//� mv_par04  // Cliente ate                                     �
//� mv_par05  // Vendedor de                                     �
//� mv_par06  // Vendedor ate                                    �
//� mv_par07  // Liberados                                       �
//� mv_par08  // Analitico/Sintetico                             �
//� mv_par09  // total por produto                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as Perguntas selecionadas.                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

limite  := 132
tamanho := "M"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Impressao do Relatorio com os Itens do Pedido.               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()

Return Nil

*************************
Static Function C030Imp()
*************************

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria array para gerar arquivo de trabalho                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Select SC6
cTrb1 := Criatrab(nil,.f.)
Copy stru to &cTrb1
dbUseArea( .T.,, cTrb1,"TRB", .F., .F. )
Select SC6
dbSetOrder(3)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off

SetRegua(recCount())
Do while !eof() .and. sc6->c6_entreg>=mv_par01 .and. sc6->c6_entreg<=mv_par02
   IncRegua()
   if sc6->c6_cli<mv_par03 .or. sc6->c6_cli>mv_par04 .or.;
      sc6->c6_qtdven-sc6->c6_qtdent<=0 .or. substr(sc6->c6_produto,5,1)#"."
      Skip
      loop
   endif
   if sc6->c6_blq=="R "
      Skip
      loop
   endif
   Select SC5
   Seek xFilial()+sc6->c6_num
   if sc5->c5_vend1<mv_par05 .or. sc5->c5_vend1>mv_par06
     Select SC6
     Skip
     loop
   endif
   if mv_par07==1
     Select SC9
     dbsetorder(1)
     dbSeek( xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
     Select SC6
     If sc9->c9_blcred# '  '
        Skip
        Loop
     Endif
   endif

   Select SA1
   seek xFilial()+sc5->(c5_cliente+c5_lojacli)
   Select SF4
   Seek xFilial()+sc6->c6_tes
   Select SC6
   if sf4->f4_duplic#"S"
       skip
       loop
   endif
   if left(sc6->c6_produto,2)=="00" .and. substr(sc6->c6_produto,3,1)#"."
      cCodProd := "1"+substr(sc6->c6_produto,2,14)
   else
      cCodProd := sc6->c6_produto
   endif

   Select TRB
   If rlock() .and. sc6->c6_qtdven-sc6->c6_qtdent>0
     appe blan
     trb->c6_num    := sc5->c5_num
     trb->c6_produto:= left(cCodProd,4)
     trb->c6_entreg := sc6->c6_entreg
     trb->c6_dtvalid:= sc5->c5_emissao
     trb->c6_la     := sc5->c5_vend1
     trb->c6_cli    := sc5->c5_cliente
     trb->c6_loja   := sc5->c5_lojacli
     trb->c6_descri := sa1->a1_nome
     trb->c6_qtdven := sc6->c6_qtdven-sc6->c6_qtdent
     trb->c6_valor  := (sc6->c6_qtdven-sc6->c6_qtdent)*sc6->c6_prcven
   Endif
   Select SC6
   Skip
Enddo


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Impressao do Relatorio.                                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

if mv_par07==1
  Cabec1 := "Pedidos Liberados"
else
  Cabec1 := "Todos os Pedidos"
endif
Cabec2 := "Pedido  Entrega     Cliente                                  Quant.       Valor"
//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Select TRB
Index on dtos(c6_entreg)+c6_produto to &cTrb1
dbGotop()

SetRegua(recCount())

nQtdT := nValT := 0

Do While !Eof()
	
   IncRegua()
	
   If li > 60
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif
   nQtd := nVal := 0
   dDat := c6_entreg 
   Do while !eof() .and. c6_entreg ==dDat
     If li > 60
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
     Endif
     if mv_par08==1
       if mv_par09==2
         Select SA3
         dbSetOrder(1)
         Seek xFilial()+left(trb->c6_la,6)
         Select TRB
         cNum := trb->c6_num
         lInicio := .t.
         do while !eof() .and. trb->c6_num==cNum
           If li > 60
             Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
           Endif
           @ li,000 PSAY TRB->c6_num
           @ li,008 PSAY TRB->c6_entreg
           @ li,020 PSAY left(TRB->c6_produto,4)
           @ li,026 PSAY iif(lInicio,TRB->c6_descri," ")
           @ li,058 PSAY TRB->c6_qtdven picture "@E 999,999.99"
           @ li,072 PSAY TRB->c6_valor  picture "@E 999,999.99"
           @ li,084 PSAY iif(lInicio,sa3->a3_nome," ")
           li := li +1
//         lInicio := .f.
           nQtd := nQtd + c6_qtdven
           nVal := nVal + c6_valor
           nQtdT:= nQtdT+ c6_qtdven
           nValT:= nValT+ c6_valor
           skip
         Enddo
       Else
         nQt := nVl := 0
         cCod := trb->c6_produto
         do while !eof() .and. trb->c6_produto==cCod .and. c6_entreg ==dDat
           nQt  := nQt  + c6_qtdven
           nVl  := nVl  + c6_valor
           nQtd := nQtd + c6_qtdven
           nVal := nVal + c6_valor
           nQtdT:= nQtdT+ c6_qtdven
           nValT:= nValT+ c6_valor
           skip
         Enddo
         If li > 60
           Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
         Endif
         @ li,008 PSAY dDat
         @ li,020 PSAY left(cCod,4)
         @ li,058 PSAY nQt  picture "@E 999,999.99"
         @ li,072 PSAY nVl  picture "@E 999,999.99"
         li := li +1
       Endif
     else
       nQtd := nQtd + c6_qtdven
       nVal := nVal + c6_valor
       nQtdT:= nQtdT+ c6_qtdven
       nValT:= nValT+ c6_valor
       skip
     endif
   Enddo
   @ li,000 PSAY "Total :"
   @ li,008 PSAY dDat
   @ li,058 PSAY nQtd picture "@E 999,999.99"
   @ li,072 PSAY nVal picture "@E 999,999.99"
   if mv_par08==1
     li := li + 2
   else
     li := li + 1
   endif

Enddo
@ li,000 PSAY "Total do relatorio:"
@ li,058 PSAY nQtdt picture "@E 999,999.99"
@ li,072 PSAY nValt picture "@E 999,999.99"

if mv_par09==1

Select TRB
Index on c6_produto to &cTrb1
dbGotop()

SetRegua(recCount())

titulo   := "Resumo de Pedidos por Produto"

Li := 80
nQtdT := nValT := 0
nTot  := nTotv := 0
Do While !Eof()

   IncRegua()
   If li > 60
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif

   Select SB1
   Seek xFilial()+trb->c6_produto
   Select TRB
   cCodProd := trb->c6_produto
   nQtde := nVal := 0
   do while !eof() .and. trb->c6_produto == cCodProd
      nQtde := nQtde + trb->c6_qtdven
      nVal  := nVal  + trb->c6_valor
      Skip
   Enddo
   @ li,000 PSAY left(cCodProd,4)+"-"+left(sb1->b1_desc,40)
   @ li,050 PSAY nQtde picture "@E 9,999,999"
   @ li,060 PSAY nVal  picture "@E 99,999,999.99"
   nTot := nTot + nQtde
   nTotv:= nTotv+ nVal 
   li:=li+1
Enddo
@ li,000 PSAY "------------------------"
li:=li+1
@ li,000 PSAY "Total de Pecas Vendidas "
@ li,050 PSAY nTot  picture "@E 9,999,999"
@ li,060 PSAY nTotv picture "@E 99,999,999.99"

Endif    // final da impress�o do resumo por pe놹s
///
IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Deleta Arquivo Temporario e Restaura os Indices Nativos.     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("TRB")
copy to xtrb
dbCloseArea()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Carrega Spool de Impressao.                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
