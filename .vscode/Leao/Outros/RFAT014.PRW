#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RFAT014()        // Relatorio de Pedidos a faturar por prazp pgto

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP5 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("ARETURN,CBTXT,CBCONT,CDESC1,CDESC2,CDESC3")
SetPrvt("CPERG,CSTRING,LI,M_PAG,NLASTKEY,NOMEPROG")
SetPrvt("TITULO,WNREL,LIMITE,TAMANHO,ACPOTRB,ATAM")
SetPrvt("CNOMARQ,CKEY,CTPPED,CARQ,CFILTER,CKEY2")
SetPrvt("CARQIND,ASECAO,AVENDEDOR,NVLCOMIS,NVLNETO,NCUSTO")
SetPrvt("NLINHA,NTOTCOMI,CABEC1,CABEC2,NTGFATURA,NTGCOMIS")
SetPrvt("NTGIPI,NTGICMS,NTGVLNETO,NTGCUSTO,NTGFRETE,NTGCOMIBR")
SetPrvt("NTGCOMIAL,NTGEXTRAS,NTGVLCOMI,ATOTAL,LCABECPRIM,CTPPEDIDO")
SetPrvt("CTIT,I,NTIPO")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴컴엽?
굇?un뇚o    ?RFAT014  ?Autor ?Luiz Eduardo          ?Data ?09/12/2004 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴컴눙?
굇?so       ?Especifico p/ Espelhos Leao                                  낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?Atualizacoes sofridas desde a Construcao Inicial.                       낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?Programador  ?Data   ?BOPS ? Motivo da Alteracao                     낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?             ?       ?     ?                                         낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/


aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos em Carteira "
cDesc2   := "por periodo"
cDesc3   := ""
cPerg    := "RFT014"
cString  := "SC5"
li       := 080
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT014"
titulo   := "Pedidos a Faturar por Prazo de Pagto"
wnrel    := "RFAT014"
limite   := 132
tamanho  := "G"
nTipo    := 15

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Perguntas :                                                  ?
//?mv_par01  // Entrega de                                      ?
//?mv_par02  // Entrega ate                                     ?
//?mv_par03  // Emissao de                                      ?
//?mv_par04  // Emissao ate                                     ?
//?mv_par05  // Dias periodo 01                                 ?
//?mv_par06  // Dias periodo 02                                 ?
//?mv_par07  // Dias periodo 03                                 ?
//?mv_par08  // Dias periodo 04                                 ?
//?mv_par09  // Dias periodo 05                                 ?
//?mv_par10  // Dias periodo 06                                 ?
//?mv_par11  // Liberados                                       ?
//?mv_par12  // Analitico/Sintetico                             ?
//?mv_par13  // Tipo de cobranca (CArteira/BAnco/CHeque/Todos)  ?
//?mv_par14  // Vendedor de                                     ?
//?mv_par15  // Vendedor ate                                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Verifica as Perguntas selecionadas.                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Pergunte(cPerg,.F.)

//SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)
SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)
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
//tamanho := "M"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Impressao do Relatorio com os Itens do Pedido.               ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()
//Select TRB
//Use

Return Nil

*************************
Static Function C030Imp()
*************************

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Cria array para gerar arquivo de trabalho                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "CLI"     , "C",20,0})
AADD(aCampos,{ "TPCOB"   , "C",02,0})
AADD(aCampos,{ "ENTREG"  , "D",08,0})
AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "COND"    , "C",30,0})
AADD(aCampos,{ "VEND"    , "C",06,0})
AADD(aCampos,{ "GRPCLI"  , "C",08,0})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "PRAZO1"  , "N",12,2})
AADD(aCampos,{ "PRAZO2"  , "N",12,2})
AADD(aCampos,{ "PRAZO3"  , "N",12,2})
AADD(aCampos,{ "PRAZO4"  , "N",12,2})
AADD(aCampos,{ "PRAZO5"  , "N",12,2})
AADD(aCampos,{ "PRAZO6"  , "N",12,2})
AADD(aCampos,{ "PECAS"   , "N",12,2})
AADD(aCampos,{ "AREA"    , "N",12,2})


cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on Entreg to &cTemp

Select SC6
dbSetOrder(3)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off

SetRegua(recCount())
Do while !eof() .and. sc6->c6_entreg>=mv_par01 .and. sc6->c6_entreg<=mv_par02
	IncRegua()
	Select SB1
	Seek xFilial()+sc6->c6_produto
	Select SC6
	if !sb1->b1_tipo$"PA*RV*SU" .or. left(c6_blq,1)="R"
		Skip
		loop
	endif
	Select SC5
	Seek xFilial()+sc6->c6_num
	if sc5->c5_emissao<mv_par03 .or. sc5->c5_emissao>mv_par04 .or. eof() .or. left(c5_nota,3)='XXX' .or. sc5->c5_vend1<mv_par14 .or. c5_vend1>mv_par15
		Select SC6
		Skip
		Loop
	endif
	Select SC6
	nRec := Recno()
	if left(sc6->c6_num,1)='P' // Tratamento para parte P
		cNumPed := C6_ITEM+C6_PRODUTO
		dbSetOrder(1)
		seek xFilial()+'0'+substr(sc6->c6_num,2,5)+cNumPed
		Select SF4
		seek xFilial()+sc6->c6_tes
		Select SC6
		cBlq  := ' '
		cNota := ' '
		dFat  := ctod("0")
		lFat := .f.
		if sc6->c6_blq<>' ' .or. sc6->c6_qtdent>=sc6->c6_qtdven
			lFat  := .t.
			cBlq  := sc6->C6_blq
			cNota := sc6->c6_nota
			dFat  := sc6->c6_datfat
		endif
		dbSetOrder(3)
		goto nRec
		if lFat .or. sf4->f4_duplic='N'
			RecLock("SC6",.f.)
			sc6->C6_blq    := cBlq
			sc6->c6_nota   := cNota
			sc6->c6_datfat := dFat
			MsUnLock()
			skip
			loop
		endif
	endif
	Select SE1
	dbSetOrder(20)
	seek xFilial()+sc5->c5_num
	if !eof() .and. sc5->c5_tipo='C'
		Select SC6
		Skip
		loop
	endif
	Select SA1
	Seek xFilial()+sc5->c5_cliente+sc5->c5_lojacli
	if  (mv_par13==2 .and. left(sa1->a1_naturez,3)#'101') .or. ;
		(mv_par13==3 .and. left(sa1->a1_naturez,3)#'102') .or. ;
		(mv_par13==4 .and. left(sa1->a1_naturez,3)#'103')
		Select SC6
		skip
		loop
	endif
	cTpCob := " "
	do case
		Case left(sa1->a1_naturez,3)=='101'
			cTpCob := "CA"
		Case left(sa1->a1_naturez,3)=='102'
			cTpCob := "BC"
		Case left(sa1->a1_naturez,3)=='103'
			cTpCob := "CH"
	endcase
	dEnt := sc6->c6_entreg
	nValPed := nQtdPed := nAreaT := 0
	cNum := sc6->c6_Num
	Select SC6
	Do while !eof() .and. c6_num==cNum
		if sc6->c6_qtdven-sc6->c6_qtdent<=0 .and. sc5->c5_tipo<>"C"
			Skip
			loop
		endif
		if sc5->c5_tipo="C" .and. !empty(sc6->c6_nota)
			Skip
			loop
		endif
		if sc6->c6_blq=="R "
			Skip
			loop
		endif
		Select SF4
		Seek xFilial()+sc6->c6_tes
		Select SC6
		if sf4->f4_duplic#"S"
			skip
			loop
		endif
		cNumPed := SC6->C6_NUM
		if left(SC6->C6_NUM,1)='P'
			cNumPed := '0'+substr(SC6->C6_NUM,2,5)
		endif
		if mv_par11==1
			Select SC9
			dbsetorder(1)
			dbSeek( xFilial("SC9")+cNumPed+SC6->C6_ITEM)
			If eof() .or. sc9->c9_blcred# '  '
				Select SC6
				Skip
				Loop
			Endif
		endif
		if mv_par11==2
			Select SC9
			dbsetorder(1)
			dbSeek( xFilial("SC9")+cNumPed+SC6->C6_ITEM)
			If c9_pedido==cNumPed .and. sc9->c9_blcred=='  '
				Select SC6
				Skip
				Loop
			Endif
			
		endif
		nAreaT := 0
		nPonto := at(".",SC6->C6_PRODUTO))
		if nPonto=0 .and. !empty(sb1->b1_base)
			nArea := val(substr(sb1->b1_cod,7,4))*val(substr(sb1->b1_cod,12,4))
		else
			Select SG1
			Seek xFilial()+LEFT(SC6->C6_PRODUTO,1,nPonto-1)+space(15-nPonto)+"19"
			nArea := sg1->g1_quant
		endif
		Select SC6
		if sc5->c5_tipo<>"C"
			nValPed := nValPed + (sc6->c6_qtdven-sc6->c6_qtdent)*sc6->c6_prcven
			nQtdPed := nQtdPed+ (sc6->c6_qtdven-sc6->c6_qtdent)
			nAreaT := nAreaT + (sc6->c6_qtdven-sc6->c6_qtdent)*nArea
		else
			nValPed := nValPed + (sc6->c6_valor)
		endif
		Skip
	Enddo
	if nValPed==0
		loop
	endif
	Select SE4
	dbsetorder(1)
	Seek xFilial("SE4")+sc5->c5_condpag
	nPrazo1 := nPrazo2 := nPrazo3 := nPrazo4 := nPrazo5 := nPrazo6 := 0
	nPrazo7 := nPrazo8 := nPrazo9 := 0
	ini := 1
	cCond := se4->e4_cond
	if at(',',cCond)==0
		tam := at(' ',cCond)-1
	else
		tam := at(',',cCond)-1
	endif
	For x:=1 to 9
		cCond := substr(se4->e4_cond,ini+tam+1,20)
		if left(cCond,2) == space(2)
			Exit
		endif
		ini := ini+tam+1
		if at(',',cCond)==0
			tam := at(' ',cCond)-1
		else
			tam := at(',',cCond)-1
		endif
	Next
	ini := 1
	cCond := se4->e4_cond
	if at(',',cCond)==0
		tam := at(' ',cCond)-1
	else
		tam := at(',',cCond)-1
	endif
	nVal1 := nVal2 := nVal3 := nVal4 := nVal5 := nVal6 := 0
	For n:=1 to 9
		cPrazo  := "nPrazo"+str(n,1)
		&cPrazo := val(substr(se4->E4_Cond,ini,tam))
		cCond := substr(se4->e4_Cond,ini+tam+1,20)
		ini := ini+tam+1
		if at(',',cCond)==0
			tam := at(' ',cCond)-1
		else
			tam := at(',',cCond)-1
		endif
		Do Case
			Case &cPrazo<=mv_par05
				nVal1 := nVal1 + nValPed/x
			Case &cPrazo<=mv_par06 .and. &cPrazo>mv_par05
				nVal2 := nVal2 + nValPed/x
			Case &cPrazo<=mv_par07 .and. &cPrazo>mv_par06
				nVal3 := nVal3 + nValPed/x
			Case &cPrazo<=mv_par08 .and. &cPrazo>mv_par07
				nVal4 := nVal4 + nValPed/x
			Case &cPrazo<=mv_par09 .and. &cPrazo>mv_par08
				nVal5 := nVal5 + nValPed/x
			Case &cPrazo<=mv_par10 .and. &cPrazo>mv_par09
				nVal6 := nVal6 + nValPed/x
		EndCase
		if left(cCond,2) == space(2)
			Exit
		endif
	Next
	Select TRB
	RecLock("TRB",.t.)
	trb->num       := sc5->c5_num
	trb->entreg    := dEnt
	trb->cli       := sa1->a1_nreduz
	trb->TpCob     := cTpCob
	trb->emissao   := sc5->c5_emissao
	trb->vend      := sc5->c5_vend1
	trb->grpcli    := sa1->a1_xgrpcli
	trb->cond      := se4->e4_cond
	trb->valor     := nValPed
	trb->prazo1    := nVal1
	trb->prazo2    := nVal2
	trb->prazo3    := nVal3
	trb->prazo4    := nVal4
	trb->prazo5    := nVal5
	trb->prazo6    := nVal6
	trb->pecas     := nQtdPed
	trb->area      := nAreaT
	MsUnLock()
	Select SC6
Enddo


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Impressao do Relatorio.                                ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

if mv_par09==1
	Cabec1 := "Pedidos Liberados"
else
	Cabec1 := "Todos os Pedidos"
endif
cPer := space(8)+str(mv_par05,3)+space(12)+str(mv_par06,3)+space(12)+str(mv_par07,3)+space(12)+str(mv_par08,3)+space(12)+str(mv_par09,3)+space(12)+str(mv_par10,3)+space(10)+"Total"+iif(mv_par12==1," Tp"," ")
if mv_par12==1
	Cabec2 := "Pedido Vend. Emissao      Grp.Cli   Cliente      "+Space(10)+cPer
	//         Pedido  Vend. Emissao Grp.Cli  Cliente      "+Space(10)+cPer
	//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
	//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
else
	Cabec2 := "        Entrega   "+cPer
endif

Select TRB
//Index on dtos(c6_entreg)+c6_produto to &cTrb1
dbGotop()

SetRegua(recCount())

nVlt1 := nVlt2 := nVlt3 := nVlt4 := nVlt5 := nVlt6 := nValt := 0

Do While !Eof()
	
	IncRegua()
	
	If li > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	Endif
	dDat := entreg
	nVl1 := nVl2 := nVl3 := nVl4 := nVl5 := nVl6 := nVal := 0
	do while !eof() .and. entreg ==dDat
		if mv_par12==1
			If li > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			Endif
			//	Cabec2 := "Pedido  Vend.  Emissao Grp.Cli  Cliente      "+Space(10)+cPer
			//               12345678901234567890123456789012345678901234567890
			@ li,001 PSAY Num
			@ li,008 PSAY Vend
			@ li,016 PSAY Emissao
			@ li,029 PSAY GrpCli
			@ li,039 PSAY Cli
			@ li,060 PSAY Prazo1  picture "@E 99,999,999.99"
			@ li,075 PSAY Prazo2  picture "@E 99,999,999.99"
			@ li,090 PSAY Prazo3  picture "@E 99,999,999.99"
			@ li,105 PSAY Prazo4  picture "@E 99,999,999.99"
			@ li,120 PSAY Prazo5  picture "@E 99,999,999.99"
			@ li,135 PSAY Prazo6  picture "@E 99,999,999.99"
			@ li,150 PSAY Valor   picture "@E 99,999,999.99"
			@ li,165 PSAY TpCob
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
	if mv_par12#1
		
		@ li,020 PSAY nVl1  picture "@E 99,999,999.99"
		@ li,035 PSAY nVl2  picture "@E 99,999,999.99"
		@ li,050 PSAY nVl3  picture "@E 99,999,999.99"
		@ li,065 PSAY nVl4  picture "@E 99,999,999.99"
		@ li,080 PSAY nVl5  picture "@E 99,999,999.99"
		@ li,095 PSAY nVl6  picture "@E 99,999,999.99"
		@ li,110 PSAY nVal  picture "@E 99,999,999.99"
	else
		@ li,060 PSAY nVl1  picture "@E 99,999,999.99"
		@ li,075 PSAY nVl2  picture "@E 99,999,999.99"
		@ li,090 PSAY nVl3  picture "@E 99,999,999.99"
		@ li,105 PSAY nVl4  picture "@E 99,999,999.99"
		@ li,120 PSAY nVl5  picture "@E 99,999,999.99"
		@ li,135 PSAY nVl6  picture "@E 99,999,999.99"
		@ li,150 PSAY nVal  picture "@E 99,999,999.99"
		
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
if mv_par12#1
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
	@ li,060 PSAY nVlt1  picture "@E 99,999,999.99"
	@ li,075 PSAY nVlt2  picture "@E 99,999,999.99"
	@ li,090 PSAY nVlt3  picture "@E 99,999,999.99"
	@ li,105 PSAY nVlt4  picture "@E 99,999,999.99"
	@ li,120 PSAY nVlt5  picture "@E 99,999,999.99"
	@ li,135 PSAY nVlt6  picture "@E 99,999,999.99"
	@ li,150 PSAY nValt  picture "@E 99,999,999.99"
	li := li +1
	@ li,000 PSAY "Percentuais:"
	@ li,060 PSAY nVlt1/nValt*100  picture "@E 99,999,999.99"
	@ li,075 PSAY nVlt2/nValt*100  picture "@E 99,999,999.99"
	@ li,090 PSAY nVlt3/nValt*100  picture "@E 99,999,999.99"
	@ li,105 PSAY nVlt4/nValt*100  picture "@E 99,999,999.99"
	@ li,120 PSAY nVlt5/nValt*100  picture "@E 99,999,999.99"
	@ li,135 PSAY nVlt6/nValt*100  picture "@E 99,999,999.99"
endif

///
IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Deleta Arquivo Temporario e Restaura os Indices Nativos.     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("TRB")
copy to xtrb1
dbCloseArea()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Carrega Spool de Impressao.                                  ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
