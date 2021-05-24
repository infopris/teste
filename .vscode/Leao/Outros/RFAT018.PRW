#include "rwmake.ch"

User Function RFAT018()        // Relatorio de Faturamento por prazp pgto

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
±±³Fun‡…o    ³ RFAT018  ³ Autor ³ Luiz Eduardo          ³ Data ³ 07/07/2006 ³±±
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
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos em Carteira "
cDesc2   := "por periodo"
cDesc3   := ""
cPerg    := "RFT018"
cString  := "SE1"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT018"
titulo   := "Faturamento por Prazo de Pagto"
wnrel    := "RFAT018"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Emissao de                                      ³
//³ mv_par02  // Emissao ate                                     ³
//³ mv_par03  // Analitico/Sintetico                             ³
//³ mv_par04  // Dias periodo 01                                 ³
//³ mv_par05  // Dias periodo 02                                 ³
//³ mv_par06  // Dias periodo 03                                 ³
//³ mv_par07  // Dias periodo 04                                 ³
//³ mv_par08  // Dias periodo 05                                 ³
//³ mv_par09  // Dias periodo 06                                 ³
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "CLI"     , "C",20,0}) 
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
cIndex := CriaTrab(nil,.f.)
IndRegua("TRB", cIndex, "Entreg", , , "Selecionando Registros...")
//Index on Entreg to &cTemp

Select SE1
dbSetOrder(6)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off

SetRegua(recCount())
Do while !eof() 
	IF se1->e1_emissao<mv_par01 .OR. se1->e1_emissao>mv_par02
		Skip
		loop
	endif
	IncRegua()
	if !trim(se1->e1_tipo)$"NF" //*NCC"
		skip
		loop
	endif
	
	Select SA1
	dbsetorder(1)
	Seek xFilial()+se1->e1_cliente+se1->e1_loja
	Select SE1
	dEnt := se1->e1_emissao
	nValPed := 0
	cNum    := se1->e1_num+dtos(se1->e1_vencto)
	nPrazo  := se1->e1_vencto-se1->e1_emissao
	Do while !eof() .and. e1_num+dtos(e1_vencto)==cNum
		if !trim(se1->e1_tipo)$"NF" //*NCC"
			skip
			loop
		endif
		nValPed := nValPed + se1->e1_valor*(iif(se1->e1_tipo='NCC',(-1),1))
		if e1_decresc=0 .and. sa1->a1_mgextra <>0 .and. e1_valliq=0 .and. se1->e1_tipo='NF'
			RecLock("SE1",.f.)
			se1->e1_decresc := se1->e1_valor*(sa1->a1_mgextra/100)
			se1->e1_sddecre := se1->e1_valor*(sa1->a1_mgextra/100)
			MsUnLock()
		endif
		Skip
	Enddo
	nVal1 := nVal2 := nVal3 := nVal4 := nVal5 := nVal6 := 0
	Do Case
		Case nPrazo<=mv_par04
			nVal1 := nVal1 + nValPed
		Case nPrazo<=mv_par05 .and. nPrazo>mv_par04
			nVal2 := nVal2 + nValPed
		Case nPrazo<=mv_par06 .and. nPrazo>mv_par05
			nVal3 := nVal3 + nValPed
		Case nPrazo<=mv_par07 .and. nPrazo>mv_par06
			nVal4 := nVal4 + nValPed
		Case nPrazo<=mv_par08 .and. nPrazo>mv_par07
			nVal5 := nVal5 + nValPed
		Case nPrazo<=mv_par09 .and. nPrazo>mv_par08
			nVal6 := nVal6 + nValPed
	EndCase
	Select TRB
	RecLock("TRB",.t.)
		trb->num       := cNum
		trb->entreg    := dEnt
		trb->cli       := sa1->a1_nreduz
		trb->emissao   := dEnt
		trb->cond      := " "
		trb->valor     := nValPed
		trb->prazo1    := nVal1
		trb->prazo2    := nVal2
		trb->prazo3    := nVal3
		trb->prazo4    := nVal4
		trb->prazo5    := nVal5
		trb->prazo6    := nVal6
	MsUnLock()
	Select SE1
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPer := space(8)+str(mv_par04,3)+space(12)+str(mv_par05,3)+space(12)+str(mv_par06,3)+space(12)+str(mv_par07,3)+space(12)+str(mv_par08,3)+space(12)+str(mv_par09,3)+space(12)+"Total"
Cabec2 := ""
if mv_par03==1
Cabec1 := "NF      Cliente      "+Space(10)+cPer
//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
else
Cabec1 := "        Emissao   "+cPer
endif

Select TRB
dbGotop()

SetRegua(recCount())

nVlt1 := nVlt2 := nVlt3 := nVlt4 := nVlt5 := nVlt6 := nValt := 0

Do While !Eof()
	
   IncRegua()
	
   If li > 60
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif
   dDat := entreg 
   nVl1 := nVl2 := nVl3 := nVl4 := nVl5 := nVl6 := nVal := 0
   do while !eof() .and. entreg ==dDat
         if mv_par03==1
            If li > 60
              Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
            Endif
            @ li,000 PSAY Num 
//          @ li,008 PSAY dDat
            @ li,008 PSAY Cli 
            @ li,030 PSAY Prazo1  picture "@E 99,999,999.99"
            @ li,045 PSAY Prazo2  picture "@E 99,999,999.99"
            @ li,060 PSAY Prazo3  picture "@E 99,999,999.99"
            @ li,075 PSAY Prazo4  picture "@E 99,999,999.99"
            @ li,090 PSAY Prazo5  picture "@E 99,999,999.99"
            @ li,105 PSAY Prazo6  picture "@E 99,999,999.99"
            @ li,119 PSAY Valor   picture "@E 99,999,999.99"
            li := li +1
         endif
         nVl1  := nVl1 + prazo1
         nVl2  := nVl2 + prazo2
         nVl3  := nVl3 + prazo3
         nVl4  := nVl4 + prazo4
         nVl5  := nVl5 + prazo5
         nVl6  := nVl6 + prazo6
         nVal  := nVal + Valor 
         skip
   Enddo
   @ li,000 PSAY "Total :"
   @ li,008 PSAY dDat
if mv_par03#1
   
   @ li,020 PSAY nVl1  picture "@E 99,999,999.99"
   @ li,035 PSAY nVl2  picture "@E 99,999,999.99"
   @ li,050 PSAY nVl3  picture "@E 99,999,999.99"
   @ li,065 PSAY nVl4  picture "@E 99,999,999.99"
   @ li,080 PSAY nVl5  picture "@E 99,999,999.99"
   @ li,095 PSAY nVl6  picture "@E 99,999,999.99"
   @ li,110 PSAY nVal  picture "@E 99,999,999.99"
else
   @ li,030 PSAY nVl1  picture "@E 99,999,999.99"
   @ li,045 PSAY nVl2  picture "@E 99,999,999.99"
   @ li,060 PSAY nVl3  picture "@E 99,999,999.99"
   @ li,075 PSAY nVl4  picture "@E 99,999,999.99"
   @ li,090 PSAY nVl5  picture "@E 99,999,999.99"
   @ li,105 PSAY nVl6  picture "@E 99,999,999.99"
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
if mv_par03#1
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
@ li,030 PSAY nVlt1  picture "@E 99,999,999.99"
@ li,045 PSAY nVlt2  picture "@E 99,999,999.99"
@ li,060 PSAY nVlt3  picture "@E 99,999,999.99"
@ li,075 PSAY nVlt4  picture "@E 99,999,999.99"
@ li,090 PSAY nVlt5  picture "@E 99,999,999.99"
@ li,105 PSAY nVlt6  picture "@E 99,999,999.99"
@ li,119 PSAY nValt  picture "@E 99,999,999.99"
li := li +1
@ li,000 PSAY "Percentuais:"
@ li,030 PSAY nVlt1/nValt*100  picture "@E 99,999,999.99"
@ li,045 PSAY nVlt2/nValt*100  picture "@E 99,999,999.99"
@ li,060 PSAY nVlt3/nValt*100  picture "@E 99,999,999.99"
@ li,075 PSAY nVlt4/nValt*100  picture "@E 99,999,999.99"
@ li,090 PSAY nVlt5/nValt*100  picture "@E 99,999,999.99"
@ li,105 PSAY nVlt6/nValt*100  picture "@E 99,999,999.99"
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