#include "rwmake.ch"
#INCLUDE "MATR730.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR730  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR730(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function xMatr730()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL tamanho:="M"
LOCAL titulo:=OemToAnsi(STR0001)	//"Emissao da Confirmacao do Pedido"
LOCAL cDesc1:=OemToAnsi(STR0002)	//"Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
LOCAL cDesc2:=OemToAnsi(STR0003)	//"intervalo informado na op‡„o Parƒmetros."
LOCAL cDesc3:=" "
LOCAL cObs  :=" "
LOCAL nRegistro:= 0
LOCAL cKey,nIndex,cIndex  && Variaveis para a criacao de Indices Temp.
LOCAL cCondicao

cPerg  :="MTR730"
PRIVATE aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",0 }			//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR730",nLastKey := 0,nBegin:=0,aLinha:={ }
//PRIVATE li:=80,limite:=220,lRodape:=.F.,cPictQtd:=""
PRIVATE li:=80,limite:=132,lRodape:=.F.,cPictQtd:=""
PRIVATE nTotQtd:=nTotVal:=0
PRIVATE aPedCli:= {}
wnrel    := "MATR730"
cString  := "SC6"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("MTR730",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		        ³
//³ mv_par01	     	  Do Pedido			        ³
//³ mv_par02	     	  Ate o Pedido			        ³
//³ mv_par03	     	  Imprime valores                       ³
//³ mv_par04	     	  Somente Liberados ?                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey==27
	Set Filter to
	Return( NIL )
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return( NIL )
Endif

RptStatus({|lEnd| C730Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C730IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR730			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==> Static Function C730Imp(lEnd,WnRel,cString)
Static Function C730Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL tamanho:="M"
LOCAL titulo:=OemToAnsi(STR0001)	//"Emissao da Confirmacao do Pedido"
LOCAL cDesc1:=OemToAnsi(STR0002)	//"Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
LOCAL cDesc2:=OemToAnsi(STR0003)	//"intervalo informado na op‡„o Parƒmetros."
LOCAL cDesc3:=" "
LOCAL nRegistro:= 0
LOCAL cKey,nIndex,cIndex  && Variaveis para a criacao de Indices Temp.
LOCAL cCondicao

pergunte("MTR730",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 psay AvalImp(Limite)

cIndex := CriaTrab(nil,.f.)
dbSelectArea("SC5")
cKey := IndexKey()
cFilter := dbFilter()
cFilter += If( Empty( cFilter ),""," .And. " )
cFilter += 'C5_FILIAL == "'+xFilial("SC5")+'" .And. C5_NUM >= "'+mv_par01+'"'
IndRegua("SC5",cIndex,cKey,,cFilter,STR0006)		//"Selecionando Registros..."

nIndex := RetIndex("SC5")
DbSelectArea("SC5")
#IFNDEF TOP
	DbSetIndex(cIndex+OrdBagExt())
#ENDIF
DbSetOrder(nIndex+1)
DbGoTop()

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. C5_NUM <= mv_par02
	
	nTotQtd:=0
	nTotVal:=0
	
	cPedido := C5_NUM
	** Incluido por Luiz Eduardo em 14/10/2004 (solicitado por Emerson) Obs Tmk
	dbSelectArea("SUA")
	dbSetOrder(1)
	dbSeek(xFilial()+SC5->C5_NUMTMK)
	cObs := " "
	IF !(SC5->C5_TIPO$"DB")
		dbSelectArea("SA1")
		dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	endif
//	dbSelectArea("SYP")
//	dbSetOrder(1)
//	dbSeek(xFilial()+SUA->UA_CODOBS)
//	Do while !eof() .and. syp->yp_chave==SUA->UA_CODOBS
//		cObs := cObs + yp_texto
//		Skip
//	Enddo
	** Fim da alteracao
	dbSelectArea("SA4")
	dbSeek(cFilial+SC5->C5_TRANSP)
	dbSelectArea("SA3")
	dbSeek(cFilial+SC5->C5_VEND1)
	dbSelectArea("SE4")
	dbSeek(cFilial+SC5->C5_CONDPAG)
	
	dbSelectArea("SC6")
	dbSeek(cFilial+cPedido)
	cPictQtd := PESQPICTQT("C6_QTDVEN",10)
	nRegistro:= RECNO()
	
	IF lEnd
		@Prow()+1,001 Psay STR0007	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tabela de pedidos do cliente p/ o cabe‡alho            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPedCli:= {}
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		IF !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedCli,SC6->C6_PEDCLI) = 0
			AAdd(aPedCli,SC6->C6_PEDCLI)
		ENDIF
		dbSkip()
	Enddo
	aSort(aPedCli)
	
	dbGoTo( nRegistro )
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		
		IF lEnd
			@Prow()+1,001 Psay STR0007	//"CANCELADO PELO OPERADOR"
			Exit
		Endif
		
		IF li > 48
			IF lRodape
				ImpRodape()
			Endif
			li := 0
			lRodape := ImpCabec()
		Endif
		ImpItem()
		dbSkip()
		li++
	Enddo
	
	IF lRodape // .or. Eof() .or. !( C6_NUM == SC5->C5_NUM )
		ImpRodape()
		lRodape:=.F.
	Endif
	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC5")
Set Filter to

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
Set Filter To
dbSetOrder(1)
dbGotop()

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==> Static Function ImpCabec()
Static Function ImpCabec()

LOCAL cHeader,nPed,cMoeda,cCampo,cComis,cPedCli

//cHeader := STR0008	//"It Codigo          Desc. do Material TES UM   Quant.  Valor Unit. IPI   ICM   ISS   Vl.Tot.C/IPI Entrega   Desc Loc.Qtd.a Fat     Saldo  Ult.Fat."
cHeader := "It Codigo          Desc. do Material TES UM   Quant.  Valor Unit. IPI   ICM   ISS   Vl.Tot.C/IPI Entrega   Desc Loc.Qtd.a Fat     Saldo  Ult.Fat."
//          				99 xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxx 999 XX99999.99999,999,999.9999,99 99,9999,99 999,999,999.99 99/99/9999 9.9  999999999.999999999.999999999,99
//          				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
//                      0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !(SC5->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Else
	dbSelectArea("SA2")
	dbSeek(cFilial+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Endif
If cPaisLoc=="ARG"
	cPictCGC:="@R 99-99.999.999-9"
ElseIf cPaisLoc $ "POR|EUA"
	cPicCgc	:=PesqPict("SA2","A2_CGC")
Else
	cPictCGC:="@R 99.999.999/9999-99"
EndIf
//@ 01,000 psay Replicate("-",limite-75)
@ 01,000 psay Replicate("-",limite)
@ 02,000 psay SM0->M0_NOME
IF !(SC5->C5_TIPO$"DB")
	@ 02,041 psay "| "+Left(SA1->A1_COD+"/"+SA1->A1_LOJA+" "+SA1->A1_NOME, 56)
	@ 02,110 psay STR0009		//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay trim(SM0->M0_ENDCOB)
	@ 03,041 psay "| "+IF( !Empty(SA1->A1_ENDENT) .And. SA1->A1_ENDENT #SA1->A1_END,;
	SA1->A1_ENDENT, SA1->A1_END )
	@ 03,110 psay "|"
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "+IF( !Empty(SA1->A1_CEPE) .And. SA1->A1_CEPE #SA1->A1_CEP,;
	SA1->A1_CEPE, SA1->A1_CEP )
	IF !Empty(SA1->A1_MUNE) .And. SA1->A1_MUNE #SA1->A1_MUN
		@ 04,053 psay trim(SA1->A1_MUNE)+"-"+SA1->A1_ESTE
	ELSE
		@ 04,053 psay trim(SA1->A1_MUN)+"-"+SA1->A1_EST
	ENDIF
	@ 04,110 psay STR0011		//"| EMISSAO: "
	@ 04,121 psay SC5->C5_EMISSAO
	@ 05,000 psay STR0012		//"CGC: "
	@ 05,005 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
	@ 05,043 psay SA1->A1_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,062 psay STR0013+SA1->A1_INSCR			//"IE: "
	@ 05,086 psay "Fone: "+SA1->A1_TEL
	@ 05,110 psay STR0014+SC5->C5_NUM			//"| PEDIDO N. "
Else
	@ 02,041 psay "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" "+SA2->A2_NOME
	@ 02,100 psay STR0009	//"| CONFIRMACAO DO PEDIDO "
	@ 03,000 psay SM0->M0_ENDCOB
	@ 03,041 psay "| "+ SA2->A2_END
	@ 03,100 psay "|"
	@ 04,000 psay STR0010+SM0->M0_TEL			//"TEL: "
	@ 04,041 psay "| "+SA2->A2_CEP
	@ 04,053 psay SA2->A2_MUN
	@ 04,077 psay SA2->A2_EST
	@ 04,100 psay STR0011		//"| EMISSAO: "
	@ 04,111 psay SC5->C5_EMISSAO
	@ 05,000 psay STR0012		//"CGC: "
	@ 05,005 psay SM0->M0_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,025 psay Subs(SM0->M0_CIDCOB,1,15)
	@ 05,041 psay "|"
	@ 05,043 psay SA2->A2_CGC    Picture cPictCGC //"@R 99.999.999/9999-99"
	@ 05,062 psay STR0013+SA2->A2_INSCR			//"IE: "
	@ 05,100 psay STR0014+SC5->C5_NUM			//"| PEDIDO N. "
Endif
li:= 6
If Len(aPedCli) > 0
//	@ li,000 psay Replicate("-",limite-75)
	@ li,000 psay Replicate("-",limite)
	li++
	@ li,000 psay "PEDIDO(S) DO CLIENTE:"
	cPedCli:=""
	For nPed := 1 To Len(aPedCli)
		cPedCli += aPedCli[nPed]+Space(02)
		If Len(cPedCli) > 100 .or. nPed == Len(aPedCli)
			@ li,23 psay cPedCli
			cPedCli:=""
			li++
		Endif
	Next
Endif
//@ li,000 psay Replicate("-",limite-75)
@ li,000 psay Replicate("-",limite)
li++
@ li,000 psay STR0016+SC5->C5_TRANSP+" - "+SA4->A4_NOME			//"TRANSP...: "
@ li,065 psay SA4->A4_TEL
li++

For i := 1 to 5
	
	cCampo := "SC5->C5_VEND" + Str(i,1,0)
	cComis := "SC5->C5_COMIS" + Str(i,1,0)
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek(cCampo)
	If !Eof()
		Loop
	Endif
	
	If !Empty(&cCampo)
		dbSelectArea("SA3")
		dbSeek(cFilial+&cCampo)
		If i == 1
			@ li,000 psay STR0017		//"VENDEDOR.: "
		EndIf
		@ li,013 psay &cCampo + " - "+SA3->A3_NOME
		If i == 1
			@ li,065 psay STR0018		//"COMISSAO: "
		EndIf
		@ li,075 psay &cComis Picture "99.99"
		li++
	Endif
Next

li++
@ li,000 psay STR0019+SC5->C5_CONDPAG+" - "+SE4->E4_DESCRI			//"COND.PGTO: "
@ li,065 psay STR0020		//"FRETE...: "
@ li,075 psay SC5->C5_FRETE  Picture "@EZ 999,999,999.99"
If SC5->C5_FRETE > 0
	@ li,090 psay IIF(SC5->C5_TPFRETE="C","(CIF)","(FOB)")
Endif
@ li,100 psay STR0021		//"SEGURO: "
@ li,108 psay SC5->C5_SEGURO Picture "@EZ 999,999,999.99"
li++
@ li,000 psay STR0022+SC5->C5_TABELA		//"TABELA...: "
@ li,065 psay STR0023		//"VOLUMES.: "
@ li,075 psay SC5->C5_VOLUME1    Picture "@EZ 999,999"
@ li,100 psay STR0024+SC5->C5_ESPECI1		//"ESPECIE: "
li++
cMoeda:=Strzero(SC5->C5_MOEDA,1,0)
@ li,000 psay STR0025+SC5->C5_REAJUST+STR0026 +IIF(cMoeda < "2","1",cMoeda)		//"REAJUSTE.: "###"   Moeda : "
@ li,065 psay STR0027 + SC5->C5_BANCO					//"BANCO: "
@ li,100 psay STR0028+Str(SC5->C5_ACRSFIN,6,2)		//"ACRES.FIN.: "
li++
//@ li,000 psay Replicate("-",limite-75)
@ li,000 psay Replicate("-",limite)

li++
@ li,000 psay cHeader
li++
//@ li,000 psay Replicate("-",limite-75)
@ li,000 psay Replicate("-",limite)
li++
Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpItem  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpItem(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpItem()
Local nIPI :=0,nVipi:=0,nBaseIPI :=100,nValBase := 0,nDesplaza:=0
Local lIpiBruto:=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)
Local nUltLib  := 0
Local cChaveD2 := ""

dbSelectArea("SC9")
dbSeek(cFilial+SC6->C6_NUM+SC6->C6_ITEM)
if mv_par04==1
	nQtd := 0
	do while !eof() .and. SC9->C9_PEDIDO+SC9->C9_ITEM==SC6->C6_NUM+SC6->C6_ITEM
		if c9_nfiscal==space(6)
			nQtd := nQtd + c9_qtdlib
		endif
		skip
	enddo
	if nQtd==0
		dbSelectArea("SC6")
		li := li - 1
		Return(nil)
	endif
endif
dbSelectArea("SB1")
dbSeek(cFilial+SC6->C6_PRODUTO)
dbSelectArea("SF4")
dbSeek(cFilial+SC6->C6_TES)
IF mv_par03 == 1
	IF SF4->F4_IPI == "S"
		nBaseIPI := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
		nIPI 		:= SB1->B1_IPI
		nValBase := If(lIPIBruto .And. SC6->C6_PRUNIT > 0,SC6->C6_PRUNIT,SC6->C6_PRCVEN)*SC6->C6_QTDVEN
		nVipi		:= NoRound(nValBase * (nIPI/100)*(nBaseIPI/100),2)
	Endif
EndIF

@li,000 psay SC6->C6_ITEM
@li,003 psay SC6->C6_PRODUTO
@li,019 psay SUBS(IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),1,17)
IF mv_par03 == 1 
@li,037 psay SC6->C6_TES
ENDIF
@li,041 psay SC6->C6_UM
@li,043 psay SC6->C6_QTDVEN	Picture cPictQtd
IF mv_par03 == 1
	@li,052 psay SC6->C6_PRCVEN	Picture PesqPict("SC6","C6_PRCVEN",12)
	@li,065 psay nIPI				   Picture "@e 99.99"
	If ( cPaisLoc=="BRA" )
		nPerRet:= a730VerIcm()
		
		@li,071 psay nPerRet Picture "@e 99.99"
		@li,076 psay SB1->B1_ALIQISS	Picture "@e 99.99"
	EndIf
EndIF
nDesplaza:=6

cChaveD2 := xFilial("SD2")+SC6->(C6_NOTA+C6_SERIE+C6_CLI+C6_LOJA+C6_PRODUTO)
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(cChaveD2)
While cChaveD2 = xFilial("SD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
	nUltLib := D2_QUANT
	dbSkip()
EndDo
dbSetOrder(1)
dbSelectArea("SC6")
IF mv_par03 == 1
	@li,076+ndesplaza   psay SC6->C6_VALOR+nVIPI Picture PesqPict("SC6","C6_VALOR",14)
EndIF
@li,091+ndesplaza   psay SC6->C6_ENTREG
IF mv_par03 == 1
	@li,099+ndesplaza+2 psay SC6->C6_DESCONT    Picture "99.9"
@li,105+ndesplaza+2 psay SC6->C6_LOCAL
//@li,107+ndesplaza+2 psay SC6->C6_QTDEMP + SC6->C6_QTDLIB + SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
@li,107+ndesplaza+2 psay SC6->C6_QTDEMP + SC6->C6_QTDLIB  Picture PesqPict("SC6","C6_QTDLIB",10)
@li,117+ndesplaza+2 psay SC6->C6_QTDVEN - SC6->C6_QTDEMP + SC6->C6_QTDLIB - SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
@li,127+ndesplaza+2 psay nUltLib Picture PesqPict("SD2","D2_QUANT",10)
Endif

nTotQtd += SC6->C6_QTDVEN
nTotVal += SC6->C6_VALOR+nVipi

dbSelectArea("SC6")

Return(nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpRoadpe(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function ImpRodape()
//@ li,000 psay Replicate("-",limite-75)
@ li,000 psay Replicate("-",limite)
li++
@ li,000 psay STR0029	//" T O T A I S "
@ li,043 psay nTotQtd    Picture cPictQtd
IF mv_par03 == 1
	If ( cPaisLoc=="BRA" )
		@ li,079 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
	Else
		@ li,068 psay nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
	EndIf
EndIF
** Incluido por Luiz Eduardo em 14/10/2004 (solicitado por Emerson) Obs Tmk
//IF SA1->A1_CODBAR=='S' .and. left(cObs,10)==space(10)
	@ 42,00 psay "P R O D U T O   C O M  C O D I G O  D E  B A R R A S"
//endif

//if left(cObs,10)#space(10)
//	IF SA1->A1_CODBAR=='S'
		//@ 42,00 psay "P R O D U T O   C O M  C O D I G O  D E  B A R R A S"
		//@ 43,00 psay "Obs pedido:"+left(cObs,220)
//	else
//		@ 42,00 psay "Obs pedido:"+left(cObs,110)
		//@ 43,00 psay subs(cObs,111,130)
//	endif
//endif
//@ 43,000 psay STR0037			//"MENSAGEM PARA NOTA FISCAL: "
cMemo     := alltrim( MSMM(SUA->UA_CODOBS) )
nMemCount := MlCount( cMemo ,120 )

li := 44
cLinha := ''
If !Empty( nMemCount )
	For nLoop := 1 To nMemCount
		cLinha += trim(MemoLine( cMemo, 120, nLoop ,2,.t.))+"  "
		if len(trim(cLinha))>80 .or. nLoop = nMemCount     // novo - para quebrar a linha apenas com 132 caracteres
//			oSend( oPrn, "Say", nLin , 0130, StrTran( StrTran( cLinha, Chr(13), "" ), Chr(10), "" ) , aFontes:COURIER_NEW_09 )
			@ li,000 psay AllTrim(cLinha)			//"MENSAGEM PARA NOTA FISCAL: "
			li++
			cLinha := ''
		endif
	Next
Endif

li++

** Incluido por Luiz Eduardo em 13/05/2003 (solicitado por Sergio)
IF left(SC5->C5_TRANSP,3)=="01 "
	@ li+0,000 psay CHR(18)
	@ li+0,005 psay "   C O N F E R E N C I A    D E    C A R G A "
	@ li+2,005 psay "EU, __________________________________________, RG __________________"
	@ li+3,005 psay "CONFERI TODA A MERCADORIA REF. NF_____________, DE _____/______/_____"
	@ li+4,005 psay "PARA O CLIENTE MENCIONADO ACIMA, QUE FOI CARREGADA EM NOSSO CAMINHAO CONF. MINHA ORIENTACAO"
	@ li+6,005 psay "ASSINATURA : _______________________"
	@ li+7,000 psay CHR(15)
Endif
li := li+7
@ li+0,005 psay STR0030+STR(SC5->C5_PBRUTO)	//"PESO BRUTO ------>"
@ li+1,005 psay STR0031+STR(SC5->C5_PESOL)	//"PESO LIQUIDO ---->"
@ li+2,005 psay STR0032	//"VOLUMES --------->"
@ li+3,005 psay STR0033	//"SEPARADO POR ---->"
@ li+4,005 psay STR0034	//"CONFERIDO POR --->"
@ li+5,005 psay STR0035	//"D A T A --------->"
IF mv_par03 == 1
	@ li+6,000 psay STR0036	//"DESCONTOS: "
	@ li+6,011 psay SC5->C5_DESC1 Picture "99.99"
	@ li+6,019 psay SC5->C5_DESC2 picture "99.99"
	@ li+6,027 psay SC5->C5_DESC3 picture "99.99"
	@ li+6,035 psay SC5->C5_DESC4 picture "99.99"
EndIF
//@ 60,000 psay STR0037+AllTrim(SC5->C5_MENNOTA)			//"MENSAGEM PARA NOTA FISCAL: "

@ li+7,000 psay ""

li := 80

Return( NIL )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A730verIcm³ Autor ³ Claudinei M. Benzi    ³ Data ³ 11.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para verificar qual e o ICM do Estado               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==> Static Function A730VerIcm(void)
Static Function A730VerIcm(void)
LOCAL nPerRet:=0		// Percentual de retorno
LOCAL cEstado:=GetMV("mv_estado"),tNorte:=GetMV("MV_NORTE")
LOCAL cEstCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_EST,SA1->A1_EST)
LOCAL cInscrCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_INSCR,SA1->A1_INSCR)

If SF4->F4_ICM == "S"
	nPerRet := AliqIcms(	SC5->C5_TIPO,;	// Tipo de Operacao
	"S",;								// Tipo de Nota ('E'ntrada/'S'aida)
	SC5->C5_TIPOCLI)				// Tipo do Cliente ou Fornecedor
EndIf
Return(nPerRet)

