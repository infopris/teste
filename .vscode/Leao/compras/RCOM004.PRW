#include "rwmake.ch"   

User Function RCOM004()        // Relatorio de NFEntrada por prazo pgto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCOM004  ³ Autor ³ Luiz Eduardo          ³ Data ³ 12/05/2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico p/ Espelhos Leao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
aOrdem   := {"Diario - Detalhado","Diario - Resumido"}  
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos de compras"
cDesc2   := "em Carteira por periodo"
cDesc3   := ""
cPerg    := "RCOM04"
cString  := "SE2"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RCOM004"
titulo   := "Notas Fiscais de Compra por Prazo de Pagto"
wnrel    := "RCOM004"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Data de                                         ³
//³ mv_par02  // Data ate                                        ³
//³ mv_par03  // Dias periodo 01                                 ³
//³ mv_par04  // Dias periodo 02                                 ³
//³ mv_par05  // Dias periodo 03                                 ³
//³ mv_par06  // Dias periodo 04                                 ³
//³ mv_par07  // Dias periodo 05                                 ³
//³ mv_par08  // Dias periodo 06                                 ³
//³ mv_par09  // Data Emissao/Digitacao                          ³
//³ mv_par10  // Natureza de                                     ³
//³ mv_par11  // Natureza ate                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,,Tamanho)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()   
//Select TRB
//Use
             
Return Nil

*************************
Static Function C030Imp()
*************************

nOrdem := aReturn [8]
if nOrdem==1
  lResumo := .f.
else
  lResumo := .t.
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",09,0}) 
AADD(aCampos,{ "FORNECE" , "C",20,0}) 
AADD(aCampos,{ "ENTREG"  , "D",08,0}) 
AADD(aCampos,{ "EMISSAO" , "D",08,0}) 
AADD(aCampos,{ "COND"    , "C",30,0}) 
AADD(aCampos,{ "VALOR"   , "N",12,2}) 
AADD(aCampos,{ "PRAZO1"  , "N",12,2}) 
AADD(aCampos,{ "PRAZO2"  , "N",12,2}) 
AADD(aCampos,{ "PRAZO3"  , "N",12,2}) 
AADD(aCampos,{ "PRAZO4"  , "N",12,2}) 
AADD(aCampos,{ "PRAZO5"  , "N",12,2}) 
AADD(aCampos,{ "PRAZO6"  , "N",12,2}) 

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on dtos(Emissao)+num to &cTemp
//Index on Entreg to &cTemp

Select SE2
if mv_par09==2
  dbSetOrder(5)
else
  dbSetOrder(7)
endif
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off
SetRegua(recCount())
Do while !eof()
   IncRegua()
   if mv_par09==2 .and. e2_emissao>mv_par02
     exit
   endif
   if mv_par09==1 .and. e2_emis1>mv_par02
     exit
   endif
   if se2->e2_naturez<mv_par10 .or. se2->e2_naturez>mv_par11
     skip
     loop
   endif
   if left(e2_origem,4)#"MATA"
     skip
     loop
   endif
   Select SA2
   Seek xFilial()+se2->e2_fornece+se2->e2_loja
   Select SE2
   nVal1 := nVal2 := nVal3 := nVal4 := nVal5 := nVal6 := 0
   nPrazo := se2->e2_vencrea-se2->e2_emissao
   if se2->e2_tipo='NDF'
	nValE2 := -se2->e2_valor
   else
	nValE2 := se2->e2_valor
   endif
   Do Case
     Case nPrazo<=mv_par03 
       nVal1 := nVal1 + nValE2
     Case nPrazo<=mv_par04 .and. nPrazo>mv_par03
       nVal2 := nVal2 + nValE2
     Case nPrazo<=mv_par05 .and. nPrazo>mv_par04
       nVal3 := nVal3 + nValE2
     Case nPrazo<=mv_par06 .and. nPrazo>mv_par05
       nVal4 := nVal4 + nValE2
     Case nPrazo<=mv_par07 .and. nPrazo>mv_par06
       nVal5 := nVal5 + nValE2
     Case nPrazo<=mv_par08 .and. nPrazo>mv_par07
       nVal6 := nVal6 + nValE2
   EndCase
   Select TRB
   reclock("TRB",.t.)
     appe blan
     trb->num       := se2->(e2_prefixo+e2_num)
     trb->fornece   := sa2->a2_nreduz
     trb->emissao   := iif(mv_par09==1,se2->e2_emis1,se2->e2_emissao)
     trb->valor     := nValE2
     trb->entreg    := iif(mv_par09==1,se2->e2_emis1,se2->e2_emissao)
     trb->prazo1    := nVal1
     trb->prazo2    := nVal2
     trb->prazo3    := nVal3
     trb->prazo4    := nVal4
     trb->prazo5    := nVal5
     trb->prazo6    := nVal6
   MsUnLock()
   Select SE2
   skip
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Cabec1 := "Todos os Pedidos"
cPer := space(8)+str(mv_par03,3)+space(12)+str(mv_par04,3)+space(12)+str(mv_par05,3)+space(12)+str(mv_par06,3)+space(12)+str(mv_par07,3)+space(12)+str(mv_par08,3)+space(10)+"Total"
if mv_par09==1
  Cabec2 := "Dt.Digit Fornecedor  "+Space(10)+cPer
else
  Cabec2 := "Dt.Emiss Fornecedor  "+Space(10)+cPer
endif
//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

Select TRB
dbGotop()

SetRegua(recCount())

nVlt1 := nVlt2 := nVlt3 := nVlt4 := nVlt5 := nVlt6 := nValt := 0

Do While !Eof()
	
   IncRegua()
	
   If li > 60
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif
   dDat := Emissao
   nVl1 := nVl2 := nVl3 := nVl4 := nVl5 := nVl6 := nVal := 0
   do while !eof() .and. Emissao==dDat
         cNum := trb->Num
         cForn:= trb->Fornece
         nPz1 := nPz2 := nPz3 := nPz4 := nPz5 := nPz6 := nVlz := 0
         Do while !eof() .and. Num == cNum .and. fornece=cForn
            nPz1 := nPz1 + Prazo1
            nPz2 := nPz2 + Prazo2
            nPz3 := nPz3 + Prazo3
            nPz4 := nPz4 + Prazo4
            nPz5 := nPz5 + Prazo5
            nPz6 := nPz6 + Prazo6
            skip
         Enddo
         nVlz := nPz1 + nPz2 + nPz3 + nPz4 + nPz5 + nPz6 
         if !lResumo
            If li > 60
              Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
            Endif
//          @ li,001 PSAY Num 
//          @ li,000 PSAY left(dtoc(entreg),5)
            @ li,000 PSAY left(dtoc(dDat),5)
            @ li,007 PSAY left(cForn,15)
            @ li,023 PSAY cNum
            @ li,033 PSAY nPz1    picture "@E 99,999,999.99"
            @ li,048 PSAY nPz2    picture "@E 99,999,999.99"
            @ li,063 PSAY nPz3    picture "@E 99,999,999.99"
            @ li,078 PSAY nPz4    picture "@E 99,999,999.99"
            @ li,092 PSAY nPz5    picture "@E 99999,999.99"
            @ li,105 PSAY nPz6    picture "@E 99999,999.99"
            @ li,119 PSAY nVlz    picture "@E 99,999,999.99"
            li := li +1
         endif
         nVl1  := nVl1 + npz1
         nVl2  := nVl2 + npz2
         nVl3  := nVl3 + npz3
         nVl4  := nVl4 + npz4
         nVl5  := nVl5 + npz5
         nVl6  := nVl6 + npz6
         nVal  := nVal + nVlz 
//       skip
   Enddo
   @ li,000 PSAY "Total :"
   @ li,008 PSAY dDat
if lResumo
   
   @ li,020 PSAY nVl1  picture "@E 99,999,999.99"
   @ li,035 PSAY nVl2  picture "@E 99,999,999.99"
   @ li,053 PSAY nVl3  picture "@E 99,999,999.99"
   @ li,068 PSAY nVl4  picture "@E 99,999,999.99"
   @ li,083 PSAY nVl5  picture "@E 99,999,999.99"
   @ li,098 PSAY nVl6  picture "@E 99,999,999.99"
   @ li,110 PSAY nVal  picture "@E 99,999,999.99"
else
   @ li,033 PSAY nVl1  picture "@E 99,999,999.99"
   @ li,048 PSAY nVl2  picture "@E 99,999,999.99"
   @ li,063 PSAY nVl3  picture "@E 99,999,999.99"
   @ li,078 PSAY nVl4  picture "@E 99,999,999.99"
   @ li,092 PSAY nVl5  picture "@E 99999,999.99"
   @ li,105 PSAY nVl6  picture "@E 99999,999.99"
   @ li,119 PSAY nVal  picture "@E 99,999,999.99"

endif
   li := li +2
   nVlt1 := nVlt1 + nVl1
   nVlt2 := nVlt2 + nVl2
   nVlt3 := nVlt3 + nVl3
   nVlt4 := nVlt4 + nVl4
   nVlt5 := nVlt5 + nVl5
   nVlt6 := nVlt6 + nVl6
   nValt := nValt + nVal
Enddo
li := li +1
@ li,000 PSAY "Total do relatorio:"
if lResumo
@ li,020 PSAY nVlt1  picture "@E 99,999,999.99"
@ li,035 PSAY nVlt2  picture "@E 99,999,999.99"
@ li,050 PSAY nVlt3  picture "@E 99,999,999.99"
@ li,065 PSAY nVlt4  picture "@E 99,999,999.99"
@ li,080 PSAY nVlt5  picture "@E 99,999,999.99"
@ li,095 PSAY nVlt6  picture "@E 99,999,999.99"
@ li,110 PSAY nValt  picture "@E 99,999,999.99"
li := li +1
@ li,000 PSAY "Percentuais:"
@ li,020 PSAY nVlt1/nValt*100  picture "@E 99,999,999.99"
@ li,035 PSAY nVlt2/nValt*100  picture "@E 99,999,999.99"
@ li,050 PSAY nVlt3/nValt*100  picture "@E 99,999,999.99"
@ li,065 PSAY nVlt4/nValt*100  picture "@E 99,999,999.99"
@ li,080 PSAY nVlt5/nValt*100  picture "@E 99,999,999.99"
@ li,095 PSAY nVlt6/nValt*100  picture "@E 99,999,999.99"

else
@ li,033 PSAY nVlt1  picture "@E 99,999,999.99"
@ li,048 PSAY nVlt2  picture "@E 99,999,999.99"
@ li,063 PSAY nVlt3  picture "@E 99,999,999.99"
@ li,079 PSAY nVlt4  picture "@E 99,999,999.99"
@ li,092 PSAY nVlt5  picture "@E 99999,999.99"
@ li,105 PSAY nVlt6  picture "@E 99999,999.99"
@ li,119 PSAY nValt  picture "@E 99,999,999.99"
li := li +1
@ li,000 PSAY "Percentuais:"
@ li,033 PSAY nVlt1/nValt*100  picture "@E 99,999,999.99"
@ li,048 PSAY nVlt2/nValt*100  picture "@E 99,999,999.99"
@ li,063 PSAY nVlt3/nValt*100  picture "@E 99,999,999.99"
@ li,078 PSAY nVlt4/nValt*100  picture "@E 99,999,999.99"
@ li,092 PSAY nVlt5/nValt*100  picture "@E 99999,999.99"
@ li,105 PSAY nVlt6/nValt*100  picture "@E 99999,999.99"
endif

///
IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
copy to trb
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Spool de Impressao.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
