#include "rwmake.ch"

User Function RCOM005()       // Relatorio de Compras por Produtos


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCOM005  ³ Autor ³ Luiz Eduardo Santos   ³ Data ³ 25/04/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Compras por Produtos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RCOM005                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake Especifico p/ Espelhos Leao                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cDesc1   := "Este programa ir  imprimir o Relatorio de Compras por produto."
cDesc2   := ""
cDesc3   := ""
aOrdem     := {"Por Componente","Por Data","Por Fornecedor"}
Titulo   := "Compras no periodo"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
cString  := "SD1"
nomeprog := "RCOM005"
cPerg    := "COM005"
wnRel    := "RCOM005"
cbtxt    := Space(10)
Tamanho  := "M"
cbcont   := 0
limite   := 132
nLastKey := 0
li       := 80
m_pag    := 1
lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas Selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas p/ Parametros :                         ³
//³                                                              ³
//³ mv_par01  // Data de                                         ³
//³ mv_par02  // Data ate                                        ³
//³ mv_par03  // Produto de                                      ³
//³ mv_par04  // Produto ate                                     ³
//³ mv_par05  // Fornecedor de                                   ³
//³ mv_par06  // Fornecedor ate                                  ³
//³ mv_par07  // Analitico / Sintetico                           ³
//³ mv_par08  // Natureza   de                                   ³
//³ mv_par09  // Natureza   ate                                  ³
//³ mv_par10  // Digitacao / Emissao                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("COM005", .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,NIL,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
EndIf

nTipo := Iif(aReturn[4] == 1, 15, 18)

Retindex("SD2")
Retindex("SD1")
Retindex("SB3")
Retindex("SA2")
Retindex("SB1")
Retindex("SC5")
Retindex("SE2")
Retindex("SF4")

SET CENTURY ON
RptStatus( { | lEnd | Imp01() }, Titulo )// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { | lEnd | Execute(CZR040Imp) }, Titulo )
SET CENTURY OFF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a ordem do arquivo.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetOrder(1)

Return Nil


****************************
Static Function Imp01()   // Impressao do Relatorio
****************************


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao do Cabecalho.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := "NFs de: " + dtoc(mv_par01) + " ate " + dtoc(mv_par02)
If mv_par07 == 1
	cabec2 := "Produto       Doc   Entrega    Fornecedor            Quant.          Valor           Val IPI       Valor Total  "
	//	cabec2 := "Produto       Doc   Entrega    Fornecedor            Quant.          Valor  Custo Unit    Cons.Mes   Custo Std"
	//         123456789012345    123456    11/11/11    12345678901234567890   123456    100,00   99.999.999    123456789012345    999.999.999,99    123456789012345      14610    11/11/11    999.999.999,99
	//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	Titulo := "Compras Efetuadas(Analitico)"
Else
	cabec2 := "Componente      Descricao Componente        Quantidade   Valor NF Custo Unit  Custo Simul Custo Std.  Consumo Mes  Saldo Est   %"
	Titulo := "Compras Efetuadas(Resumido)"
Endif
Tamanho := "M"
limite  := 132
nTipo   := 15

if select("TRB")<>0
	Select TRB
	use
endif
if select("TRBFOR")<>0
	Select TRBFOR
	use
endif
if select("TRBALIQ")<>0
	Select TRBALIQ
	use
endif
if select("TRBPROD")<>0
	Select TRBPROD
	use
endif
if select("TRBNF")<>0
	Select TRBNF
	use
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria e Abre o Arquivo de Trabalho.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "DOC"     , "C",06,0})
AADD(aCampos,{ "FORNECE" , "C",20,0})
AADD(aCampos,{ "EMISSAO" , "C",10,0})
//AADD(aCampos,{ "CONTABIL", "D",08,0})
//AADD(aCampos,{ "DIGITAC" , "D",08,0})
AADD(aCampos,{ "ENTRADA", "C",10,0})
AADD(aCampos,{ "DIGITAC" , "C",10,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "REDUZIDO", "C",15,0})
AADD(aCampos,{ "DESC"    , "C",50,0})
AADD(aCampos,{ "UM"      , "C",02,0})
AADD(aCampos,{ "GRUPO"   , "C",04,0})
AADD(aCampos,{ "QUANT"   , "N",12,2})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "VALORS"  , "N",12,2})
AADD(aCampos,{ "VALMERC" , "N",12,2})
AADD(aCampos,{ "UNIT"    , "N",12,4})
AADD(aCampos,{ "VALSICM" , "N",12,2})
//AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "UNITSICM" , "N",12,4})

AADD(aCampos,{ "VALORNF" , "N",12,2})
AADD(aCampos,{ "PERC"    , "N",08,1})
AADD(aCampos,{ "UNITNF"  , "N",12,4})
AADD(aCampos,{ "VALIPI"  , "N",12,2})
AADD(aCampos,{ "VALCPMF" , "N",12,2})
AADD(aCampos,{ "VALICMS" , "N",12,2})
AADD(aCampos,{ "VALFIN"  , "N",12,2})
AADD(aCampos,{ "VALFRET" , "N",12,2})
AADD(aCampos,{ "VALDESC" , "N",12,2})
AADD(aCampos,{ "EST"     , "C",02,0})
AADD(aCampos,{ "TESS"    , "C",03,0})
AADD(aCampos,{ "TESC"    , "C",03,0})
//AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "CONDPAG" , "C",10,0})
AADD(aCampos,{ "ALIQICM" , "N",08,2})
AADD(aCampos,{ "ALIQIPI" , "N",08,2})
AADD(aCampos,{ "NCM"     , "C",15,0})
AADD(aCampos,{ "CNPJ"    , "C",15,0})
AADD(aCampos,{ "COD1"    , "C",15,0})
AADD(aCampos,{ "CFOP"    , "C",04,0})
AADD(aCampos,{ "NATUREZA", "C",09,0})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
//Index on Doc+dtos(ctod(Digitac))+Fornece+cod to cTemp //verificar
cInd := CriaTrab(Nil, .F.)
IndRegua("TRB", cInd, "Doc+dtos(ctod(Digitac))+Fornece+cod", , , "Selecionando Registros...")

Monta()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
//aOrdem     := {"Por Componente","Por Entrega","Por Cliente"}
nOrdem := aReturn [8]
Do Case
	Case nOrdem == 1
		cTempF := CriaTrab(nil,.f.)
		Index on Cod to cTempF //Verificar
	Case nOrdem == 2
		cTempG := CriaTrab(nil,.f.)
		Index on digitac to cTempG //Verificar
	Case nOrdem == 3
		cTempH := CriaTrab(nil,.f.)
		Index on Fornece to cTempH //Verificar
Endcase

dbGoTop()

SetRegua(RecCount())
nTotCusto := 0
nValTot	  := nValor := 0
While !Eof()
	
	IncRegua()
	
	if trb->Cod<mv_par03 .or. trb->Cod>mv_par04
		Skip
		Loop
	Endif
	
	If mv_par07 == 1   // Imprime relatorio analitico (somente resumo: nao)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do Cabecalho.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If li > 60
			Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
		EndIf
		Select TRB
		@ li, 00 PSAY left(COD,10)
		@ li, 12 PSAY DOC
		@ li, 20 PSAY DIGITAC
		@ li, 30 PSAY FORNECE
		//		@ li, 59 PSAY left(DESC,40)
		@ li,058  PSAY QUANT        Picture "@E 999,999"
		@ li,070  PSAY VALOR	    Picture "@E 9,999,999.99"
		@ li,085  PSAY VALIPI 	    Picture "@E 9,999,999.99"
		@ li,0100 PSAY VALOR+VALIPI Picture "@E 9,999,999.99"
		li := li + 1
		nValor	+= Valor
		nValTot	+= Valor+Valipi
		Skip
	Else		// Relatorio sintetico
		Do case
			Case nOrdem == 1    // Por Componente
				cGrp  := left(trb->cod,at(".",trb->cod)-1)
				nQtd1 := nTot1 := nTot2 := 0
				Do while !eof() .and. left(trb->cod,at(".",trb->cod)-1)==cGrp
					cCod  := trb->Cod
					cDesc := trb->Desc
					nVal  := trb->Valor
					nQtd  := nCust := nValor := 0
					//				nPc   := trb->PC
					Do while !eof() .and. trb->Cod == cCod
						nQtd   += trb->Quant
						nValor += trb->Valor
						nValTot+= trb->Valor+Valipi
						Skip
					Enddo
					If li > 60
						Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
					EndIf
					nCst1 := 0
					@ li, 00 PSAY left(cCOD,10)
					@ li, 12 PSAY cDESC
					@ li, 44 PSAY nQtd 						Picture "@E 999,999"
					@ li, 54 PSAY nValor       				Picture "@E 999,999.99"
					nQtd1 += nQtd
					nTot1 += nValor
					li := li + 1
				Enddo
				if val(left(trb->cod,at(".",trb->cod)-1))#val(cGrp)
					@ li, 01 PSAY "Total do Grupo "+cGrp
					@ li, 44 PSAY nQtd1 Picture "@E 999,999"
					@ li, 53 PSAY nTot1 Picture "@E 9999,999.99"
					li := li + 1
					@ li, 01 PSAY replicate("-",132)
					li := li + 1
				endif
			Case nOrdem == 2    // Por Data
				nQtd1 := nTot1 := nTot2 := 0
				Do while !eof()
					cCod  := trb->Cod
					cGrp  := Digitac
					cDesc := trb->Desc
					nVal  := trb->Valor
					nQtd  := nCust := nValor := 0
					Do while !eof() .and. digitac==cGrp
						nQtd   += trb->Quant
						nValor += trb->Valor
						nValTot+= trb->Valor+Valipi
						Skip
					Enddo
					If li > 60
						Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
					EndIf
					@ li, 00 PSAY cGrp
					@ li, 44 PSAY nQtd 						Picture "@E 999,999"
					@ li, 54 PSAY nValor       				Picture "@E 999,999.99"
					nQtd1 += nQtd
					nTot1 += nValor
					li := li + 1
				Enddo
			Case nOrdem == 3    // Por Fornecedor
				nQtd1 := nTot1 := nTot2 := 0
				Do while !eof()
					cGrp  := fornece
					cCod  := trb->Cod
					cDesc := trb->Desc
					nVal  := trb->Valor
					nQtd  := nCust := nValor := 0
					Do while !eof() .and. Fornece == cGrp
						nQtd   += trb->Quant
						nValor += trb->Valor
						nValTot+= trb->Valor+Valipi
						Skip
					Enddo
					If li > 60
						Cabec(Titulo,Cabec1,Cabec2,Nomeprog,Tamanho,nTipo)
					EndIf
					@ li, 00 PSAY cGrp
					@ li, 44 PSAY nQtd 						Picture "@E 999,999"
					@ li, 54 PSAY nValor       				Picture "@E 999,999.99"
					nTot1 += nValor
					li := li + 1
				Enddo
		Endcase
	EndIf
	dbSelectArea("TRB")
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Total Geral para o relatorio analitico.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li != 80
	@ li, 00 PSAY Replicate("-",limite)
	li := li + 1
	If mv_par07 == 1
		@ li, 000 PSAY "TOTAIS (com Ipi)"
		@ li, 070 PSAY nValor  Picture "@E 99,999,999.99"
		@ li, 100 PSAY nValTot  Picture "@E 99,999,999.99"
	Endif
	li := li + 1
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Rodape.                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If li #80
	Roda(cbcont,cbtxt,Tamanho)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra o Spool.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(wnrel)
EndIf

MS_FLUSH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga o arquivo de trabalho.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
cTempI := CriaTrab(nil,.f.)
if mv_par10==1  // D1_DTDIGIT
	//	Index on dtos(ctod(Digitac))+Doc+Fornece+cod to cTempI //Verificar
	cIndexI := CriaTrab(Nil, .F.)
	IndRegua("TRB", cIndexI, "dtos(ctod(Digitac))+Doc+Fornece+cod", , , "Selecionando Registros...")
	
else		// D1_EMISSAO
	//	Index on dtos(ctod(ENTRADA))+Doc+Fornece+cod to cTempI //Verificar
	cIndexI := CriaTrab(Nil, .F.)
	IndRegua("TRB", cIndexI, "dtos(ctod(ENTRADA))+Doc+Fornece+cod", , , "Selecionando Registros...")
endif
//Copy to \gerencia\compras
//MsgBox("Arquivo gravado (abrir com o Excel) : \GERENCIA\COMPRAS.dtc","Atencao","ALERT")
if MsgBox ("Deseja gerar planilha Excel ?","Escolha","YESNO")
	Relat001()
endif

dbCloseArea()
If File(cTemp+".DBF")
	//	FErase(cTemp+".DBF")
EndIf

if select("TRB")<>0
	Select TRB
	use
endif
if select("TRBFOR")<>0
	Select TRBFOR
	use
endif
if select("TRBALIQ")<>0
	Select TRBALIQ
	use
endif
if select("TRBPROD")<>0
	Select TRBPROD
	use
endif
if select("TRBNF")<>0
	Select TRBNF
	use
endif

Return(.T.)

****************************
Static Function Monta()  // Monta Temporario
****************************
dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial()+"MV_CPMF")
nCPMF := Val(Alltrim(SX6->X6_CONTEUD))

dbSelectArea("SD1")
if mv_par10==1
	dbSetOrder(6)  // D1_DTDIGIT
else
	dbSetOrder(3)  // Emissao
Endif
set softseek on
dbSeek( xFilial("SD1") + Dtos(mv_par01),.T.)
set softseek off

SetRegua( 10000 )
While  !Eof()
	
	IncRegua()
	if mv_par10=1
		if SD1->D1_DTDIGIT < mv_par01 .or. SD1->D1_DTDIGIT > mv_par02
			exit
		endif
	else
		if SD1->D1_EMISSAO < mv_par01 .or. SD1->D1_EMISSAO > mv_par02
			exit
		endif
	endif
	if SD1->D1_DATACUS == ctod("0")
		reclock("SD1",.f.)
		SD1->D1_DATACUS := sd1->d1_dtdigit
		MsUnLock()
	endif
	If 	SD1->D1_COD     <  mv_par03 .Or. SD1->D1_COD     >  mv_par04 .Or. ;
		SD1->D1_FORNECE <  mv_par05 .Or. SD1->D1_FORNECE >  mv_par06 .Or. SD1->D1_TIPO=="D"
		
		dbSelectArea("SD1")
		dbSkip()
		Loop
	EndIf
	IF SUBSTR(SD1->D1_CF,2,3)=="252"  // NF Energia Eletrica
		dbSkip()
		Loop
	ENDIF
	if trim(SD1->D1_ORIGLAN)="FR"   // Nota de Frete, sera rateada no final
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o F4_DUPLIC = "N".                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4") + SD1->D1_TES)
	if sf4->f4_duplic<>"S" .and. sd1->d1_tes<>"045"
		dbSelectArea("SD1")
		dbSkip()
		Loop
	Endif
	Select SE2
	dbSetOrder(6)
	Seek xFilial()+sd1->(d1_fornece+d1_loja+d1_serie+d1_doc)
	if se2->e2_naturez<mv_par08 .or. se2->e2_naturez>mv_par09
		if sd1->d1_tes<>"045"
			dbSelectArea("SD1")
			dbSkip()
			Loop
		endif
	endif
	Select SF1
	Seek xFilial()+sd1->(d1_doc+d1_serie+d1_fornece+d1_loja)
	nDespesa := 0
	if sf1->f1_despesa#0 .or. sf1->f1_frete#0
		nDespesa := (sd1->d1_total/sf1->f1_valmerc)*(sf1->f1_frete+sf1->f1_despesa)
	endif
	nDescont  := 0
	if sf1->f1_descont#0
		nDescont := (sd1->d1_total/sf1->f1_valmerc)*(sf1->f1_descont)
	endif
	nDespfin := sf1->f1_despesa/sf1->f1_valmerc*sd1->d1_total
	nDespFrt := sf1->f1_frete/sf1->f1_valmerc*sd1->d1_total
	Select SB1
	cCodP := left(sd1->d1_cod,3+at(".",substr(sd1->d1_cod,5,5)))
	Seek xFilial()+cCodP
	if left(sb1->b1_grupo,3)<>"200" .or. eof()
		Select SB1
		Seek xFilial()+sd1->d1_cod
	Endif
	Select SB2
	Seek xFilial()+sb1->b1_cod+"02"
	Select SB3
	DbSetOrder(1)
	Seek xFilial()+sb1->b1_cod
	cUlt := GetMv("MV_ULMES")
	Select SB9
	Seek xFilial()+sb1->b1_cod+"02"+dtos(cUlt)
	nCm1 := iif(sb9->b9_margem<>0,sb9->b9_margem,sb2->b2_cm1)
	Select SA2
	Seek xFilial()+sd1->(d1_fornece+d1_loja)
	Select SF4
	Seek xFilial()+sd1->D1_TES
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial()+sf1->f1_cond)
	Select TRB
	if sd1->d1_tipo=="C"
		Seek SD1->(D1_NFORI+DTOS(D1_DTDIGIT))+left(SA2->A2_NREDUZ,20)+SD1->D1_COD
		if eof()
			Seek SD1->(D1_DOC+DTOS(D1_DTDIGIT))+left(SA2->A2_NREDUZ,20)+SD1->D1_COD
		endif
	else
		Seek SD1->(D1_DOC+DTOS(D1_DTDIGIT))+left(SA2->A2_NREDUZ,20)+SD1->D1_COD
	Endif
	nVALORNF := nValorS := 0
	if SD1->D1_TIPO=="C" .or. sd1->d1_serie="001" .or. sd1->d1_serie="002" .or. sd1->d1_tes="200"
		nValorS := sd1->d1_total
	else
		nVALORNF := sd1->d1_total
	endif
	reclock("trb",!found())
	TRB->DOC     := SD1->D1_DOC
	TRB->EMISSAO := DTOC(SD1->D1_EMISSAO)
	TRB->ENTRADA:= DTOC(SF1->F1_DTCPISS)
	TRB->DIGITAC := DTOC(SD1->D1_DTDIGIT)
	TRB->COD     := SD1->D1_COD
	TRB->COD1    := SB1->B1_PRODPAI
	TRB->GRUPO   := SB1->B1_GRUPO
	TRB->FORNECE := SA2->A2_NREDUZ
	TRB->DESC    := SB1->B1_DESC
	TRB->QUANT   := TRB->QUANT+SD1->D1_QUANT
	TRB->VALOR   := TRB->VALOR+SD1->D1_TOTAL+nDespesa-nDescont
	TRB->VALORS  := TRB->VALORS+nValorS
	TRB->VALMERC := TRB->VALMERC+iif(nVALORNF<>0,nValorNF,0)
	TRB->VALSICM := TRB->VALSICM+SD1->D1_TOTAL+nDespesa-nDescont-SD1->D1_VALICM
	
	if nVALORNF<>0
		TRB->UNITNF  := IIF(TRB->QUANT<>0,TRB->VALOR/TRB->QUANT,0)
	endif
	//	TRB->VALLIQ     := TRB->VALLIQ+SD1->D1_CUSTO
	TRB->UM      := SD1->D1_UM
	TRB->VALORNF 	:= TRB->VALORNF+nVALORNF
	TRB->PERC    	:= IIF(TRB->VALOR<>0,TRB->VALORNF/TRB->VALOR*100,0)
	TRB->VALIPI     := TRB->VALIPI+SD1->D1_VALIPI
	TRB->VALICMS    := TRB->VALICMS+SD1->D1_VALICM
	TRB->VALFIN     := TRB->VALFIN +nDespFin
	TRB->VALFRET    := TRB->VALFRET+nDespFrt
	TRB->VALDESC    := TRB->VALDESC+nDescont
	TRB->VALCPMF    := (SD1->D1_TOTAL+SD1->D1_VALIPI+nDespesa)*nCpmf/100
	TRB->EST        := iif(sd1->d1_tipo$"B*D",sa1->a1_est,sa2->a2_est)
	TRB->TESS       := iif(nValorS<>0,SD1->D1_TES,TESS)
	TRB->TESC       := iif(nVALORNF<>0,SD1->D1_TES,TESC)
	TRB->CFOP       := SD1->D1_CF
	TRB->CONDPAG    := SE4->E4_DESCRI
	TRB->ALIQICM    := SD1->D1_PICM
	TRB->ALIQIPI    := SD1->D1_IPI
	TRB->NCM        := SB1->B1_POSIPI
	TRB->CNPJ       := SA2->A2_CGC
	TRB->NATUREZA   := SE2->E2_NATUREZ
	
	MsUnlock()
	dbSelectArea("SD1")
	dbSkip()
End


Select SF8
dbgotop()
SetRegua( reccount() )

While  !Eof()
	IncRegua()
	Select SD1
	dbSetOrder(1)
	seek xFilial()+sf8->(F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA)
	if mv_par10=1
		if SD1->D1_DTDIGIT < mv_par01 .or. SD1->D1_DTDIGIT > mv_par02
			Select SF8
			skip
			loop
		endif
	else
		if SD1->D1_EMISSAO < mv_par01 .or. SD1->D1_EMISSAO > mv_par02
			Select SF8
			skip
			loop
		endif
	endif
	Select SD1
	dbSetOrder(1)
	seek xFilial()+sf8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
	
	//	if SF8->F8_dtdigit < mv_par01 .and. SF8->F8_dtdigit > mv_par02
	//		skip
	//		loop
	//	endif
	//	Select SD1
	//	dbSetOrder(1)
	//	seek xFilial()+sf8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
	nValFrete :=0
	do while !eof() .and. sd1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = sf8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
		nValFrete += sd1->d1_total
		skip
	enddo
	Select SA2
	seek xFilial()+sf8->(f8_fornece+f8_loja)
	Select TRB
	dbgotop()
	nTot := 0
	Do while !eof()
		//		if left(SF8->F8_NFORIG,6)=trb->doc .and. DTOC(SF8->F8_DTDIGIT)=trb->digitac .and. left(SA2->A2_NREDUZ,20) = trb->FORNECE
		if left(SF8->F8_NFORIG,6)=trb->doc .and. left(SA2->A2_NREDUZ,20) = trb->FORNECE
			nTot += (Valor+ValorS)
		endif
		skip
	enddo
	Select TRB
	dbgotop()
	Do while !eof()
		if left(SF8->F8_NFORIG,6)=trb->doc .and. left(SA2->A2_NREDUZ,20) = trb->FORNECE
			nPerc := (Valor+ValorS)/nTot
			reclock("TRB",.f.)
			TRB->VALFRET    := TRB->VALFRET+(nValFrete*nPerc)
			TRB->VALOR   	+= TRB->VALFRET
			TRB->UNIT    	:= IIF(TRB->QUANT<>0,TRB->VALOR/TRB->QUANT,0)
			TRB->UNITSICM   := IIF(TRB->QUANT<>0,TRB->VALSICM/TRB->QUANT,0)
			//				TRB->VALORNF 	+= TRB->VALFRET
			MsUnLock()
		endif
		skip
	enddo
	Select SF8
	skip
Enddo

/*
Select SF8
dbgotop()
SetRegua( reccount() )

While  !Eof()
IncRegua()
Select SD1
dbSetOrder(1)
seek xFilial()+sf8->(F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA)
if mv_par10=1
if SD1->D1_DTDIGIT < mv_par01 .or. SD1->D1_DTDIGIT > mv_par02
Select SF8
skip
loop
endif
else
if SD1->D1_DATACUS < mv_par01 .or. SD1->D1_DATACUS > mv_par02
Select SF8
skip
loop
endif
endif
// Verificar se tem mais de um registro
Select SF8
cChave := sf8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
// Verifica Valor do Frete
Select SD1
dbSetOrder(1)
seek xFilial()+cChave
nValFrete := 0
do while !eof() .and. cChave = sf8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
nValFrete += sd1->d1_total
skip
enddo

nReg := recno()
Seek xFilial()+cChave
n:=0
do while !eof() .and. cChave = sf8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
n++
// Verifica Valor Total a Ratear
Select SD1
dbSetOrder(1)
cChave1 := sf8->(F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA)
seek xFilial()+cChave1
nValTot := 0
do while !eof() .and. cChave1 = sf8->(F8_NFORIG+F8_SERORIG+F8_FORNECE+F8_LOJA)
nValTot += sd1->d1_total
skip
enddo

Select SF8
skip
enddo
goto nReg

if n=1
Select SA2
seek xFilial()+sf8->(f8_fornece+f8_loja)
Select TRB
dbgotop()
nTot := 0
Do while !eof()
//		if left(SF8->F8_NFORIG,6)=trb->doc .and. DTOC(SF8->F8_DTDIGIT)=trb->digitac .and. left(SA2->A2_NREDUZ,20) = trb->FORNECE
if left(SF8->F8_NFORIG,6)=trb->doc .and. left(SA2->A2_NREDUZ,20) = trb->FORNECE
nTot += (Valor+ValorS)
endif
skip
enddo
Select TRB
dbgotop()
Do while !eof()
if left(SF8->F8_NFORIG,6)=trb->doc .and. left(SA2->A2_NREDUZ,20) = trb->FORNECE
nPerc := (Valor+ValorS)/nTot
if rlock()
TRB->VALFRET    := TRB->VALFRET+(nValFrete*nPerc)
TRB->VALOR   	+= TRB->VALFRET
TRB->UNIT    	:= IIF(TRB->QUANT<>0,TRB->VALOR/TRB->QUANT,0)
//				TRB->VALORNF 	+= TRB->VALFRET
endif
endif
skip
enddo
else
Select SF8
do while !eof() .and. cChave = sf8->(F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
Select TRB
dbgotop()
Do while !eof()
Select SA2
dbSetOrder(3)
seek xFilial()+trb->CNPJ
Select TRB
if left(SF8->F8_NFORIG,6)=trb->doc .and. left(SA2->A2_NREDUZ,20) = trb->FORNECE
if rlock()
TRB->VALFRET    := TRB->VALFRET+(nValFrete*trb->Valor/nValTot)
TRB->VALOR   	+= TRB->VALFRET
TRB->UNIT    	:= IIF(TRB->QUANT<>0,TRB->VALOR/TRB->QUANT,0)
//				TRB->VALORNF 	+= TRB->VALFRET
endif
endif
skip
enddo
select SF8
skip
enddo
skip-1
endif
Select SF8
skip
Enddo
*/

// Verifica devoluções de compras

dbSelectArea("SD2")
dbSetOrder(5)  // D1_DTDIGIT
set softseek on
dbSeek( xFilial("SD2") + Dtos(mv_par01),.T.)
set softseek off

SetRegua( 10000 )

While  !Eof() .and. SD2->D2_emissao <= mv_par02
	
	IncRegua()
	if trim(d2_doc)$"004987*001267"
		x:=1
	endif
	if  !SD2->D2_TIPO$"D*B"
		dbSelectArea("SD2")
		dbSkip()
		Loop
	EndIf
	If 	SD2->D2_COD     <  mv_par03 .Or. SD2->D2_COD     >  mv_par04 .Or. ;
		SD2->D2_CLIENTE <  mv_par05 .Or. SD2->D2_CLIENTE >  mv_par06
		dbSelectArea("SD2")
		dbSkip()
		Loop
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o F4_DUPLIC = "N".                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4") + SD2->D2_TES)
	if sf4->f4_duplic<>"S"
		dbSelectArea("SD2")
		dbSkip()
		Loop
	Endif
	Select SE2
	dbSetOrder(6)
	Seek xFilial()+sd2->(d2_cliente+d2_loja+d2_serie+d2_doc)
	if se2->e2_naturez<mv_par08 .or. se2->e2_naturez>mv_par09
		dbSelectArea("SD2")
		dbSkip()
		Loop
	endif
	Select SF2
	Seek xFilial()+sd2->(d2_doc+d2_serie+d2_cliente+d2_loja)
	nDespesa := 0
	nDespfin := 0
	nDespFrt := 0
	Select SB1
	cCodP := left(sd2->d2_cod,3+at(".",substr(sd2->d2_cod,5,5)))
	Seek xFilial()+cCodP
	if left(sb1->b1_grupo,3)<>"200" .or. eof()
		Select SB1
		Seek xFilial()+sd2->d2_cod
	Endif
	Select SB2
	Seek xFilial()+sb1->b1_cod+"02"
	Select SB3
	DbSetOrder(1)
	Seek xFilial()+sb1->b1_cod
	cUlt := GetMv("MV_ULMES")
	Select SB9
	Seek xFilial()+sb1->b1_cod+"02"+dtos(cUlt)
	nCm1 := iif(sb9->b9_margem<>0,sb9->b9_margem,sb2->b2_cm1)
	Select SA2
	Seek xFilial()+sd2->(d2_cliente+d2_loja)
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial()+sf1->f1_cond)
	Select TRB
	Seek SD2->(D2_DOC+DTOS(D2_EMISSAO))+left(SA2->A2_NREDUZ,20)+SD2->D2_COD
	nVALORNF := nValorS := 0
	if sd2->d2_serie="001" .or. sd2->d2_serie="002"
		nValorS := sd2->d2_total
	else
		nVALORNF := sd2->d2_total
	endif
	reclock("trb",!found())
	TRB->DOC     := SD2->D2_DOC
	TRB->EMISSAO := dtoc(SD2->D2_EMISSAO)
	TRB->ENTRADA:= dtoc(SD2->D2_EMISSAO)
	TRB->DIGITAC := dtoc(SD2->D2_EMISSAO)
	TRB->COD     := SD2->D2_COD
	TRB->FORNECE := SA2->A2_NREDUZ
	TRB->DESC    := SB1->B1_DESC
	TRB->QUANT   := (TRB->QUANT+SD2->D2_QUANT)*(-1)
	TRB->VALOR   := (TRB->VALOR+SD2->D2_TOTAL+nDespesa-nDescont)*(-1)
	TRB->VALSICM := (TRB->VALSICM+SD2->D2_TOTAL+nDespesa-nDescont-SD2->D2_VALICM)*(-1)
	TRB->VALORS  := (TRB->VALORS+nValorS)*(-1)
	TRB->VALMERC := (TRB->VALMERC+iif(nVALORNF<>0,nValorNF,0))*(-1)
	TRB->UNIT    := (IIF(TRB->QUANT<>0,TRB->VALOR/TRB->QUANT,0))*(-1)
	TRB->UM      := SD2->D2_UM
	//	TRB->VALLIQ     := (TRB->VALLIQ+SD2->D2_CUSTO1)*(-1)
	if nVALORNF<>0
		TRB->UNITNF  := IIF(TRB->QUANT<>0,TRB->VALOR/TRB->QUANT,0)
	endif
	TRB->VALORNF 	:= (TRB->VALORNF+nVALORNF)*(-1)
	TRB->PERC    	:= (IIF(TRB->VALOR<>0,TRB->VALORNF/TRB->VALOR*100,0))*(-1)
	TRB->VALIPI     := (TRB->VALIPI+SD2->D2_VALIPI)*(-1)
	TRB->VALICMS    := (TRB->VALICMS+SD2->D2_VALICM)*(-1)
	TRB->VALFIN     := (TRB->VALFIN +nDespFin)*(-1)
	TRB->VALFRET    := (TRB->VALFRET+nDespFrt)*(-1)
	TRB->VALDESC    := (TRB->VALDESC+nDescont)*(-1)
	TRB->VALCPMF    := ((SD2->D2_TOTAL+SD2->D2_VALIPI+nDespesa)*nCpmf/100)*(-1)
	TRB->EST        := sa2->a2_est
	TRB->TESS       := iif(nValorS<>0,SD2->D2_TES,TESS)
	TRB->TESC       := iif(nVALORNF<>0,SD2->D2_TES,TESC)
	TRB->CFOP       := SD2->D2_CF
	TRB->CONDPAG    := SE4->E4_DESCRI
	TRB->ALIQICM    := SD2->D2_PICM
	TRB->ALIQIPI    := SD2->D2_IPI
	TRB->NCM        := SB1->B1_POSIPI
	TRB->CNPJ       := SA2->A2_CGC
	TRB->NATUREZA   := SE2->E2_NATUREZ
	
	MsUnlock()
	dbSelectArea("SD2")
	dbSkip()
End

// Grava Valor total das compras no mês - Luiz 17/08/2015

dFim := firstday(dDatabase)-1
dIni1 := firstday(dFim)
if mv_par01<=dIni1 .and. mv_par02>=dFim
	Select SB2
	dbgotop()
	do while !eof()
		if b2_local<>'02'
			skip
			loop
		endif
		reclock("SB2",.f.)
		sb2->b2_CMFIM5 := 0
		msunlock()
		skip
	enddo
	Select TRB
	cTempJ := CriaTrab(nil,.f.)
	Index on COD1 to cTempJ //Verificar
	dbgotop()
	Do while !eof()
		cCod1 := COD1
		nVal  := 0
		do while !eof() .and. COD1=cCod1
			if ctod(TRB->DIGITAC)>=dIni1 .and. ctod(TRB->DIGITAC)<=dFim
				//				nVal += VALLIQ
				nVal += VALSICM
			endif
			skip
		enddo
		Select SB2
		dbSetOrder(1)
		Seek xFilial()+cCod1+"02"
		IF EOF()
			Seek xFilial()+cCod1+"  "
		ENDIF
		if !eof()
			reclock("SB2",.f.)
			sb2->b2_CMFIM5 := nVal
			msunlock()
		endif
		Select TRB
	Enddo
	//	cTempK := CriaTrab(nil,.f.)
	//	Index on Doc+dtos(ctod(Digitac))+Fornece+cod to cTemp // verificar &cTempK
	cIndex := CriaTrab(Nil, .F.)
	IndRegua("TRB", cIndex, "Doc+dtos(ctod(Digitac))+Fornece+cod", , , "Selecionando Registros...")
endif

//Acerto do cálculo do valor unitário - Luiz - 18-02-2015
Select TRB
cTempA := CriaTrab(nil,.f.)
Index on Digitac+Doc+Fornece+cod to cTempA // Verificar
dbgotop()
do while !eof()
	cChave := Digitac+Doc+Fornece+cod
	nVal := nQuant := nValsicm := 0
	nReg := recno()
	Do while !eof() .and. cChave = Digitac+Doc+Fornece+cod
		nVal += VALOR
		nValsicm += Valsicm
		nQuant += Quant
		skip
	Enddo
	nReg1 := recno()
	Goto nReg
	reclock("TRB",.f.)
	trb->Unit := nVal/nQuant
	trb->UnitsIcm := nValsicm/nQuant
	MsUnLock()
	goto nReg1
enddo

// Solicitação do Irineu - Filtrar por Natureza - 08-01-2015

Select TRB
Set Filter to trim(NATUREZA)$"20501*20502*20503"

// Por Fornecedor

aCampos := {}
AADD(aCampos,{ "FORNECE" , "C",20,0})
AADD(aCampos,{ "QUANT"   , "N",12,2})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "VALORS"  , "N",12,2})
AADD(aCampos,{ "VALMERC" , "N",12,2})
//AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "VALORNF" , "N",12,2})
AADD(aCampos,{ "VALIPI"  , "N",12,2})
AADD(aCampos,{ "VALCPMF" , "N",12,2})
AADD(aCampos,{ "VALICMS" , "N",12,2})
AADD(aCampos,{ "VALFIN"  , "N",12,2})
AADD(aCampos,{ "VALFRET" , "N",12,2})
AADD(aCampos,{ "VALDESC" , "N",12,2})

cTempFor := CriaTrab(nil,.f.)
dbCreate(cTempFor,aCampos)
dbUseArea( .T.,,cTempFor,"TRBFOR", Nil, .F. )

Select TRB
cTempB := CriaTrab(nil,.f.)
Index on Fornece to cTempB //Verificar
dbgotop()
tQuant := tValor := tValor := tValorS := tValMerc := tValliq := tValorNF := tValIPI := tValIcms := tValFin := tValFret := tValDesc := 0
Do while !eof()
	cFornece := Fornece
	nQuant := nValor := nValor := nValorS := nValMerc := nValliq := nValorNF := nValIPI := nValIcms := nValFin := nValFret := nValDesc := 0
	Do while !eof() .and. Fornece = cFornece
		nQuant	+= Quant
		nValor	+= Valor
		nValorS	+= ValorS
		nValMerc += ValMerc
		//		nValliq += Valliq
		nValorNF += ValorNF
		nValIPI += ValIPI
		nValIcms += ValICMS
		nValFin += ValFin
		nValFret += ValFret
		nValDesc += ValDesc
		
		tQuant	+= Quant
		tValor	+= Valor
		tValorS	+= ValorS
		tValMerc += ValMerc
		//		tValliq += Valliq
		tValorNF += ValorNF
		tValIPI += ValIPI
		tValIcms += ValICMS
		tValFin += ValFin
		tValFret += ValFret
		tValDesc += ValDesc
		skip
	Enddo
	Select TrbFor
	RecLock("TrbFor",.t.)
	TrbFor->Fornece := cFornece
	TrbFor->Quant	:= nQuant
	TrbFor->Valor	:= nValor
	TrbFor->ValorS	:= nValorS
	TrbFor->ValMerc := nValMerc
	//	TrbFor->Valliq 	:= nValliq
	TrbFor->ValorNF := nValorNF
	TrbFor->ValIPI 	:= nValIPI
	TrbFor->ValIcms := nValICMS
	TrbFor->ValFin 	:= nValFin
	TrbFor->ValFret := nValFret
	TrbFor->ValDesc := nValDesc
	MsUnLock()
	Select Trb
Enddo

Select TrbFor
//RecLock("TrbFor",.t.)
RecLock("TrbFor",.t.)
TrbFor->Quant	:= tQuant
TrbFor->Valor	:= tValor
TrbFor->ValorS	:= tValorS
TrbFor->ValMerc := tValMerc
//TrbFor->Valliq 	:= tValliq
TrbFor->ValorNF := tValorNF
TrbFor->ValIPI 	:= tValIPI
TrbFor->ValIcms := tValICMS
TrbFor->ValFin 	:= tValFin
TrbFor->ValFret := tValFret
TrbFor->ValDesc := tValDesc
MsUnLock()

Select TrbFor
cInd1 := CriaTrab(Nil, .F.)
IndRegua("TRBFOR", cInd1, "Fornece", , , "Selecionando Registros...")
Copy to \gerencia\compXfor
//Use

// Por Aliquota de Icms

aCampos := {}
AADD(aCampos,{ "ALIQICM" , "N",08,2})
AADD(aCampos,{ "QUANT"   , "N",12,2})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "VALORS"  , "N",12,2})
AADD(aCampos,{ "VALMERC" , "N",12,2})
//AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "VALORNF" , "N",12,2})
AADD(aCampos,{ "VALIPI"  , "N",12,2})
AADD(aCampos,{ "VALCPMF" , "N",12,2})
AADD(aCampos,{ "VALICMS" , "N",12,2})
AADD(aCampos,{ "VALFIN"  , "N",12,2})
AADD(aCampos,{ "VALFRET" , "N",12,2})
AADD(aCampos,{ "VALDESC" , "N",12,2})


cTempAliq := CriaTrab(nil,.f.)
dbCreate(cTempAliq,aCampos)
dbUseArea( .T.,,cTempAliq,"TRBALIQ", Nil, .F. )

Select TRB
cTempC := CriaTrab(nil,.f.)
Index on AliqIcm to cTempC //Verificar
dbgotop()
tQuant := tValor := tValor := tValorS := tValMerc := tValliq := tValorNF := tValIPI := tValIcms := tValFin := tValFret := tValDesc := 0
Do while !eof()
	cAliqICM := AliqICM
	nQuant := nValor := nValor := nValorS := nValMerc := nValliq := nValorNF := nValIPI := nValIcms := nValFin := nValFret := nValDesc := 0
	Do while !eof() .and. cAliqICM = AliqICM
		nQuant	+= Quant
		nValor	+= Valor
		nValorS	+= ValorS
		nValMerc += ValMerc
		//		nValliq += Valliq
		nValorNF += ValorNF
		nValIPI += ValIPI
		nValIcms += ValICMS
		nValFin += ValFin
		nValFret += ValFret
		nValDesc += ValDesc
		
		tQuant	+= Quant
		tValor	+= Valor
		tValorS	+= ValorS
		tValMerc += ValMerc
		//		tValliq += Valliq
		tValorNF += ValorNF
		tValIPI += ValIPI
		tValIcms += ValICMS
		tValFin += ValFin
		tValFret += ValFret
		tValDesc += ValDesc
		skip
	Enddo
	Select TrbAliq
	RecLock("TrbAliq",.t.)
	TrbAliq->AliqICM:= cAliqICM
	TrbAliq->Quant	:= nQuant
	TrbAliq->Valor	:= nValor
	TrbAliq->ValorS	:= nValorS
	TrbAliq->ValMerc:= nValMerc
	//	TrbAliq->Valliq	:= nValliq
	TrbAliq->ValorNF:= nValorNF
	TrbAliq->ValIPI	:= nValIPI
	TrbAliq->ValIcms:= nValICMS
	TrbAliq->ValFin	:= nValFin
	TrbAliq->ValFret:= nValFret
	TrbAliq->ValDesc:= nValDesc
	MsUnLock()
	Select Trb
Enddo
Select TrbAliq
//RecLock("TrbAliq",.t.)
RecLock("TrbAliq",.t.)
TrbAliq->AliqICM:= -1
TrbAliq->Quant	:= tQuant
TrbAliq->Valor	:= tValor
TrbAliq->ValorS	:= tValorS
TrbAliq->ValMerc:= tValMerc
//TrbAliq->Valliq	:= tValliq
TrbAliq->ValorNF:= tValorNF
TrbAliq->ValIPI	:= tValIPI
TrbAliq->ValIcms:= tValICMS
TrbAliq->ValFin	:= tValFin
TrbAliq->ValFret:= tValFret
TrbAliq->ValDesc:= tValDesc
MsUnLock()


Select TrbAliq
cInd2 := CriaTrab(Nil, .F.)
IndRegua("TRBALIQ", cInd2, "AliqICM", , , "Selecionando Registros...")
Copy to \gerencia\compXAliq
//Use

// Por Produto

aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "CODRED"  , "C",15,0})
AADD(aCampos,{ "DESC"    , "C",50,0})
AADD(aCampos,{ "QUANT"   , "N",12,2})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "VALORS"  , "N",12,2})
AADD(aCampos,{ "VALMERC" , "N",12,2})
//AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "VALORNF" , "N",12,2})
AADD(aCampos,{ "VALIPI"  , "N",12,2})
AADD(aCampos,{ "VALCPMF" , "N",12,2})
AADD(aCampos,{ "VALICMS" , "N",12,2})
AADD(aCampos,{ "VALFIN"  , "N",12,2})
AADD(aCampos,{ "VALFRET" , "N",12,2})
AADD(aCampos,{ "VALDESC" , "N",12,2})

cTempProd := CriaTrab(nil,.f.)
dbCreate(cTempProd,aCampos)
dbUseArea( .T.,,cTempProd,"TRBPROD", Nil, .F. )

Select TRB
cTempD := CriaTrab(nil,.f.)
Index on Cod to cTempD //Verificar
dbgotop()
tQuant := tValor := tValor := tValorS := tValMerc := tValliq := tValorNF := tValIPI := tValIcms := tValFin := tValFret := tValDesc := 0
Do while !eof()
	cCod  := Cod
	cCodRed  := Cod1
	cDesc := Desc
	nQuant := nValor := nValor := nValorS := nValMerc := nValliq := nValorNF := nValIPI := nValIcms := nValFin := nValFret := nValDesc := 0
	Do while !eof() .and. cCod = Cod
		nQuant	+= Quant
		nValor	+= Valor
		nValorS	+= ValorS
		nValMerc += ValMerc
		//		nValliq += Valliq
		nValorNF += ValorNF
		nValIPI += ValIPI
		nValIcms += ValICMS
		nValFin += ValFin
		nValFret += ValFret
		nValDesc += ValDesc
		
		tQuant	+= Quant
		tValor	+= Valor
		tValorS	+= ValorS
		tValMerc += ValMerc
		//		tValliq += Valliq
		tValorNF += ValorNF
		tValIPI += ValIPI
		tValIcms += ValICMS
		tValFin += ValFin
		tValFret += ValFret
		tValDesc += ValDesc
		skip
	Enddo
	Select TrbProd
	RecLock("TrbProd",.t.)
	TrbProd->Cod	:= cCod
	TrbProd->CodRed	:= cCodRed
	TrbProd->Desc	:= cDesc
	TrbProd->Quant	:= nQuant
	TrbProd->Valor	:= nValor
	TrbProd->ValorS	:= nValorS
	TrbProd->ValMerc:= nValMerc
	//	TrbProd->Valliq	:= nValliq
	TrbProd->ValorNF:= nValorNF
	TrbProd->ValIPI	:= nValIPI
	TrbProd->ValIcms:= nValICMS
	TrbProd->ValFin	:= nValFin
	TrbProd->ValFret:= nValFret
	TrbProd->ValDesc:= nValDesc
	MsUnLock()
	Select Trb
Enddo
Select TrbProd
//RecLock("TrbProd",.t.)
RecLock("TrbProd",.t.)
TrbProd->Quant	:= tQuant
TrbProd->Valor	:= tValor
TrbProd->ValorS	:= tValorS
TrbProd->ValMerc:= tValMerc
//TrbProd->Valliq	:= tValliq
TrbProd->ValorNF:= tValorNF
TrbProd->ValIPI	:= tValIPI
TrbProd->ValIcms:= tValICMS
TrbProd->ValFin	:= tValFin
TrbProd->ValFret:= tValFret
TrbProd->ValDesc:= tValDesc
MsUnLock()
Select TrbProd
cInd3 := CriaTrab(Nil, .F.)
IndRegua("TRBPROD", cInd3, "Cod", , , "Selecionando Registros...")
Copy to \gerencia\compXprod
//Use

// Por Nota Fiscal

aCampos := {}
AADD(aCampos,{ "DOC"     , "C",06,0})
AADD(aCampos,{ "FORNECE" , "C",20,0})
AADD(aCampos,{ "EMISSAO" , "C",10,0})
AADD(aCampos,{ "ENTRADA" , "C",10,0})
AADD(aCampos,{ "DIGITAC" , "C",10,0})
AADD(aCampos,{ "CONDPAG" , "C",10,0})
AADD(aCampos,{ "EST"     , "C",02,0})
AADD(aCampos,{ "QUANT"   , "N",12,2})
AADD(aCampos,{ "VALOR"   , "N",12,2})
AADD(aCampos,{ "VALORS"  , "N",12,2})
AADD(aCampos,{ "VALMERC" , "N",12,2})
//AADD(aCampos,{ "VALLIQ"  , "N",12,2})
AADD(aCampos,{ "VALORNF" , "N",12,2})
AADD(aCampos,{ "VALIPI"  , "N",12,2})
AADD(aCampos,{ "VALCPMF" , "N",12,2})
AADD(aCampos,{ "VALICMS" , "N",12,2})
AADD(aCampos,{ "VALFIN"  , "N",12,2})
AADD(aCampos,{ "VALFRET" , "N",12,2})
AADD(aCampos,{ "VALDESC" , "N",12,2})
AADD(aCampos,{ "NATUREZA", "C",09,0})

cTempNF := CriaTrab(nil,.f.)
dbCreate(cTempNF,aCampos)
dbUseArea( .T.,,cTempNF,"TRBNF", Nil, .F. )

Select TRB
cTempE := CriaTrab(nil,.f.)
Index on Doc+Fornece to cTempE //Verificar
dbgotop()
tQuant := tValor := tValor := tValorS := tValMerc := tValliq := tValorNF := tValIPI := tValIcms := tValFin := tValFret := tValDesc := 0
Do while !eof()
	cDoc  := Doc
	cNat  := Natureza
	cFornece := Fornece
	cEmissao := Emissao
	cEntrada := Entrada
	cDigitac := Digitac
	cCondPag := CondPag
	cEst     := EST
	nQuant := nValor := nValor := nValorS := nValMerc := nValliq := nValorNF := nValIPI := nValIcms := nValFin := nValFret := nValDesc := 0
	Do while !eof() .and. cDoc+cFornece = Doc+Fornece
		nQuant	+= Quant
		nValor	+= Valor
		nValorS	+= ValorS
		nValMerc += ValMerc
		//		nValliq += Valliq
		nValorNF += ValorNF
		nValIPI += ValIPI
		nValIcms += ValICMS
		nValFin += ValFin
		nValFret += ValFret
		nValDesc += ValDesc
		
		tQuant	+= Quant
		tValor	+= Valor
		tValorS	+= ValorS
		tValMerc += ValMerc
		//		tValliq += Valliq
		tValorNF += ValorNF
		tValIPI += ValIPI
		tValIcms += ValICMS
		tValFin += ValFin
		tValFret += ValFret
		tValDesc += ValDesc
		skip
	Enddo
	Select TrbNF
	RecLock("TrbNF",.t.)
	TrbNF->Doc	:= cDoc
	TrbNF->Fornece := cFornece
	TrbNF->CondPag := cCondPag
	TrbNF->Emissao := cEMISSAO
	TrbNF->Entrada := cENTRADA
	TrbNF->Digitac := cDigitac
	TrbNF->Est     := cEST
	TrbNF->Natureza:= cNat
	TrbNF->Quant	:= nQuant
	TrbNF->Valor	:= nValor
	TrbNF->ValorS	:= nValorS
	TrbNF->ValMerc:= nValMerc
	//	TrbNF->Valliq	:= nValliq
	TrbNF->ValorNF:= nValorNF
	TrbNF->ValIPI	:= nValIPI
	TrbNF->ValIcms:= nValICMS
	TrbNF->ValFin	:= nValFin
	TrbNF->ValFret:= nValFret
	TrbNF->ValDesc:= nValDesc
	MsUnLock()
	Select Trb
Enddo
Select TrbNF
//RecLock("TrbNF",.t.)
RecLock("TrbNF",.t.)
TrbNF->Quant	:= tQuant
TrbNF->Valor	:= tValor
TrbNF->ValorS	:= tValorS
TrbNF->ValMerc	:= tValMerc
//TrbNF->Valliq	:= tValliq
TrbNF->ValorNF	:= tValorNF
TrbNF->ValIPI	:= tValIPI
TrbNF->ValIcms	:= tValICMS
TrbNF->ValFin	:= tValFin
TrbNF->ValFret	:= tValFret
TrbNF->ValDesc	:= tValDesc
MsUnLock()
Select TrbNF
cInd4 := CriaTrab(Nil, .F.)
IndRegua("TRBNF", cInd4, "DOC", , , "Selecionando Registros...")
Copy to \gerencia\compXNF
//Use

Select Trb
Copy to \gerencia\compras
dbgotop()
Set filter to

//if MsgBox ("Deseja gerar planilha Excel ?","Escolha","YESNO")
//	Relat001()
//endif
// Rcom007

Static Function RELAT001()

Local oReport := nil
oReport := RptDef(cPerg)
oReport:PrintDialog()

Return

Static Function RptDef(cNome)
Local oReport := Nil
Local oSection1:= Nil
Local oSection2:= Nil
Local oSection3:= Nil
Local oSection4:= Nil
Local oSection5:= Nil
Local oBreak
Local oFunction

oReport := TReport():New(cNome,"Compras no periodo",cNome,{|oReport| ReportPrint(oReport)},"Relatório Compras")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1:= TRSection():New(oReport, "Compras", {"TRB"}, , .F., .T.)
TRCell():New( oSection1, "DOC"    	 ,"TRB", "Documento","@!",08)
TRCell():New( oSection1, "FORNECE"   ,"TRB", "Fornecedor","@!",08)
TRCell():New( oSection1, "EMISSAO"   ,"TRB", "Dt.Emissao","@!",10)
TRCell():New( oSection1, "ENTRADA" 	 ,"TRB", "Dt.Entrada","@!",10)
TRCell():New( oSection1, "DIGITAC"	 ,"TRB", "Dt.Digitação","@!",10)
TRCell():New( oSection1, "COD"	     ,"TRB", "Cód.Prod.","@!",15)
TRCell():New( oSection1, "REDUZIDO"  ,"TRB", "Cód.reduz.","@!",10)
TRCell():New( oSection1, "DESC"	     ,"TRB", "Descrição ","@!",40)
TRCell():New( oSection1, "UM"	     ,"TRB", "UM ","@!",02)
TRCell():New( oSection1, "GRUPO"     ,"TRB", "Grupo ","@!",04)
TRCell():New( oSection1, "QUANT"	 ,"TRB", "Quantidade","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALOR"	 ,"TRB", "Valor","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALORS"	 ,"TRB", "Valor S","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALMERC"   ,"TRB", "Valor Mercad.","@E 999,999,999.99",15)
TRCell():New( oSection1, "UNIT"	     ,"TRB", "Valor Unitário","@E 9,999,999.9999",15)
TRCell():New( oSection1, "VALSICM"   ,"TRB", "Valor s/ICMS","@E 999,999,999.99",15)
TRCell():New( oSection1, "UNITSICM"  ,"TRB", "Unit.s/ICMS","@E 9,999,999.9999",15)
TRCell():New( oSection1, "VALORNF"  ,"TRB", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection1, "PERC"	     ,"TRB", "Percentual","@E 99,999.99",15)
TRCell():New( oSection1, "UNITNF"   ,"TRB", "Unitário NF","@E 9,999,999.9999",15)
TRCell():New( oSection1, "VALIPI"  ,"TRB", "Valor IPI","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALCPMF"  ,"TRB", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALICMS"  ,"TRB", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALFIN"  ,"TRB", "Valor Financeiro","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALFRET"  ,"TRB", "Valor Frete","@E 999,999,999.99",15)
TRCell():New( oSection1, "VALDESC"  ,"TRB", "Valor Descto","@E 999,999,999.99",15)
TRCell():New( oSection1, "EST"	     ,"TRB", "Estado ","@!",02)
TRCell():New( oSection1, "TESS"	     ,"TRB", "TES S ","@!",02)
TRCell():New( oSection1, "TESC"	     ,"TRB", "TES C ","@!",02)
TRCell():New( oSection1, "CONDPAG"	 ,"TRB", "Cond.Pag ","@!",02)
TRCell():New( oSection1, "ALIQICM"   ,"TRB", "% ICMS","@E 999,999,999.99",15)
TRCell():New( oSection1, "ALIQIPI"   ,"TRB", "% IPI","@E 999,999,999.99",15)
TRCell():New( oSection1, "NCM"	     ,"TRB", "NCM ","@!",15)
TRCell():New( oSection1, "CNPJ"	     ,"TRB", "CNPJ ","@!",15)
TRCell():New( oSection1, "COD1"		 ,"TRB", "COD1 ","@!",15)
TRCell():New( oSection1, "CFOP"	     ,"TRB", "CFOP ","@!",04)
TRCell():New( oSection1, "NATUREZA"	 ,"TRB", "NATUREZA ","@!",09)

//TRFunction():New(oSection1:Cell("COD"),NIL,"COUNT",,,,,.F.,.T.)

// Section 2
oSection2:= TRSection():New(oReport, "Compras x fornecedor ", {"TRBFOR"}, , .F., .T.)

TRCell():New( oSection2, "FORNECE"   ,"TRBFOR", "Fornecedor","@!",08)
TRCell():New( oSection2, "QUANT"	 ,"TRBFOR", "Quantidade","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALOR"	 ,"TRBFOR", "Valor","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALORS"	 ,"TRBFOR", "Valor S","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALMERC"   ,"TRBFOR", "Valor Mercad.","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALORNF"   ,"TRBFOR", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALIPI"    ,"TRBFOR", "Unit.s/ICMS","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALCPMF"   ,"TRBFOR", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALICMS"   ,"TRBFOR", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALFIN"    ,"TRBFOR", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALFRET"   ,"TRBFOR", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection2, "VALDESC"   ,"TRBFOR", "Valor NF","@E 999,999,999.99",15)

// Section 3
oSection3:= TRSection():New(oReport, "Compras x Alíquota ", {"TRBALIQ"}, , .F., .T.)

TRCell():New( oSection3, "ALIQICM"   ,"TRBALIQ", "Alíquota","@E 999.99",08)
TRCell():New( oSection3, "QUANT"	 ,"TRBALIQ", "Quantidade","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALOR"	 ,"TRBALIQ", "Valor","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALORS"	 ,"TRBALIQ", "Valor S","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALMERC"   ,"TRBALIQ", "Valor Mercad.","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALORNF"   ,"TRBALIQ", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALIPI" 	 ,"TRBALIQ", "Valor IPI","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALCPMF"   ,"TRBALIQ", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALICMS" 	 ,"TRBALIQ", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALFIN"	 ,"TRBALIQ", "Valor Financeiro","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALFRET" 	 ,"TRBALIQ", "Valor Frete","@E 999,999,999.99",15)
TRCell():New( oSection3, "VALDESC"   ,"TRBALIQ", "Valor Descto","@E 999,999,999.99",15)

// Section 4 - // Por Produto
oSection4:= TRSection():New(oReport, "Compras x Produto ", {"TRBPROD"}, , .F., .T.)

TRCell():New( oSection4, "COD"       ,"TRBPROD", "Código","@!",08)
TRCell():New( oSection4, "CODRED"    ,"TRBPROD", "Cód.Reduz.","@!",08)
TRCell():New( oSection4, "DESC"      ,"TRBPROD", "Descrição","@!",08)
TRCell():New( oSection4, "ALIQICM"   ,"TRBPROD", "Alíquota","@E 999.99",08)
TRCell():New( oSection4, "QUANT"	 ,"TRBPROD", "Quantidade","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALOR"	 ,"TRBPROD", "Valor","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALORS"	 ,"TRBPROD", "Valor S","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALMERC"   ,"TRBPROD", "Valor Mercad.","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALORNF"   ,"TRBPROD", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALIPI"    ,"TRBPROD", "Valor IPI","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALCPMF"   ,"TRBPROD", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALICMS"   ,"TRBPROD", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALFIN"    ,"TRBPROD", "Valor Fin","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALFRET"   ,"TRBPROD", "Valor Frete","@E 999,999,999.99",15)
TRCell():New( oSection4, "VALDESC"   ,"TRBPROD", "Valor Descto","@E 999,999,999.99",15)


// Section 5 - // Por Nota Fiscal
oSection5:= TRSection():New(oReport, "Compras x Nota Fiscal ", {"TRBNF"}, , .F., .T.)

TRCell():New( oSection5, "DOC"       ,"TRBNF", "Nota Fiscal","@!",08)
TRCell():New( oSection5, "FORNECE"   ,"TRBNF", "Fornecedor","@!",10)
TRCell():New( oSection5, "EMISSAO"   ,"TRBNF", "Emissão","@!",10)
TRCell():New( oSection5, "DIGITAC"   ,"TRBNF", "Data Digitação","@!",10)
TRCell():New( oSection5, "ENTRADA"   ,"TRBNF", "Data Entrada","@!",10)
TRCell():New( oSection5, "CONDPAG"   ,"TRBNF", "Cond.Pagto","@!",10)
TRCell():New( oSection5, "EST"       ,"TRBNF", "EST","@!",02)

TRCell():New( oSection5, "QUANT"	 ,"TRBNF", "Quantidade","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALOR"	 ,"TRBNF", "Valor","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALORS"	 ,"TRBNF", "Valor S","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALMERC"   ,"TRBNF", "Valor Mercad.","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALORNF"   ,"TRBNF", "Valor NF","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALIPI"    ,"TRBNF", "Valor IPI","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALCPMF"   ,"TRBNF", "Valor Cpmf","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALICMS"   ,"TRBNF", "Valor ICMS","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALFIN"    ,"TRBNF", "Valor Fin","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALFRET"   ,"TRBNF", "Valor Frete","@E 999,999,999.99",15)
TRCell():New( oSection5, "VALDESC"   ,"TRBNF", "Valor Descto","@E 999,999,999.99",15)
TRCell():New( oSection5, "NATUREZA"  ,"TRBNF", "Natureza","@!",09)

TRFunction():New(oSection2:Cell("FORNECE"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por seção
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)	 // Abrir a seção Alíquota
Local oSection4 := oReport:Section(4)	 // Abrir a seção Produto
Local oSection5 := oReport:Section(5)	 // Abrir a seção Nota Fiscal

Local cQuery    := ""
Local cPedido   := ""
Local lPrim 	:= .T.

dbSelectArea("TRB")
TRB->(dbGoTop())

oReport:SetMeter(TRB->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection1:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRB")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		cChave := trb->(Doc+Fornece+Cod)
		cDOC := DOC
		cFORNECE := FORNECE
		cEMISSAO := EMISSAO
		cENTRADA := ENTRADA
		cDIGITAC := DIGITAC
		cCOD := COD
		cREDUZIDO := REDUZIDO
		cDESC := DESC
		cUM := UM
		cGRUPO := GRUPO
		cUM := UM
		cUM := UM
		cEST := EST
		cTESS := TESS
		cTESC := TESC
		cCONDPAG := CONDPAG
		cALIQICM := ALIQICM
		cALIQIPI := ALIQIPI
		cNCM := NCM
		cCNPJ := CNPJ
		cCOD1 := COD1
		cCFOP := CFOP
		cNATUREZA := NATUREZA
		nQuant := nValor := nVALORS := nVALMERC := nUNIT := nVALSICM := 0
		nUNITSICM := nVALORNF := nPERC := nUNITNF := nVALIPI := nVALCPMF := 0
		nVALICMS := nVALFIN := nVALFRET := nVALDESC := 0
		
		Do while !eof() .and. trb->(Doc+Fornece+Cod) == cChave
			nQUANT += QUANT
			nVALOR += VALOR
			nVALORS += VALORS
			nVALMERC += VALMERC
			nUNIT += UNIT
			nVALSICM += VALSICM
			nUNITSICM += UNITSICM
			nVALORNF += VALORNF
//			nPERC += PERC
			nUNITNF += UNITNF
			nVALIPI += VALIPI
			nVALCPMF += VALCPMF
			nVALICMS += VALICMS
			nVALFIN += VALFIN
			nVALFRET += VALFRET
			nVALDESC += VALDESC
			TRB->(dbSkip())
		Enddo
		//imprimo a primeira seção
		//		oSection1:Cell("DULTVEN"):SetValue(dtoc(SC5->C5_EMISSAO))
		oSection1:Cell("DOC"):SetValue(cDOC)
		oSection1:Cell("FORNECE"):SetValue(cFORNECE)
		oSection1:Cell("EMISSAO"):SetValue(cEMISSAO)
		oSection1:Cell("ENTRADA"):SetValue(cENTRADA)
		oSection1:Cell("DIGITAC"):SetValue(cDIGITAC)
		oSection1:Cell("COD"):SetValue(cCOD)
		oSection1:Cell("REDUZIDO"):SetValue(cREDUZIDO)
		oSection1:Cell("DESC"):SetValue(cDESC)
		oSection1:Cell("UM"):SetValue(cUM)
		oSection1:Cell("GRUPO"):SetValue(cGRUPO)
		oSection1:Cell("QUANT"):SetValue(nQUANT)
		oSection1:Cell("VALOR"):SetValue(nVALOR)
		oSection1:Cell("VALORS"):SetValue(nVALORS)
		oSection1:Cell("VALMERC"):SetValue(nVALMERC)
		oSection1:Cell("UNIT"):SetValue(nUNIT)
		oSection1:Cell("VALSICM"):SetValue(nVALSICM)
		oSection1:Cell("UNITSICM"):SetValue(nUNITSICM)
		oSection1:Cell("VALORNF"):SetValue(nVALORNF)
		oSection1:Cell("PERC"):SetValue(nPERC)
		oSection1:Cell("UNITNF"):SetValue(nUNITNF)
		oSection1:Cell("VALIPI"):SetValue(nVALIPI)
		oSection1:Cell("VALCPMF"):SetValue(nVALCPMF)
		oSection1:Cell("VALICMS"):SetValue(nVALICMS)
		oSection1:Cell("VALFIN"):SetValue(nVALFIN)
		oSection1:Cell("VALFRET"):SetValue(nVALFRET)
		oSection1:Cell("VALDESC"):SetValue(nVALDESC)
		oSection1:Cell("EST"):SetValue(cEST)
		oSection1:Cell("TESS"):SetValue(cTESS)
		oSection1:Cell("TESC"):SetValue(cTESC)
		oSection1:Cell("CONDPAG"):SetValue(cCONDPAG)
		oSection1:Cell("ALIQICM"):SetValue(cALIQICM)
		oSection1:Cell("ALIQIPI"):SetValue(cALIQIPI)
		oSection1:Cell("NCM"):SetValue(cNCM)
		oSection1:Cell("CNPJ"):SetValue(cCNPJ)
		oSection1:Cell("COD1"):SetValue(cCOD1)
		oSection1:Cell("CFOP"):SetValue(cCFOP)
		oSection1:Cell("NATUREZA"):SetValue(cNATUREZA)
		
		oSection1:Printline()
		//		TRB->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo
//oSection1:Finish()

//SEÇÃO 2 - Por Fornecedor
dbSelectArea("TrbFor")

oReport:SetMeter(TrbFor->(LastRec()))
TrbFor->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection2:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TrbFor")
	
	IncProc("Imprimindo Compras x Fornecedores")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a segunda seção
		oSection2:Cell("FORNECE"):SetValue(TrbFor->FORNECE)
		oSection2:Cell("QUANT"):SetValue(TrbFor->QUANT)
		oSection2:Cell("VALOR"):SetValue(TrbFor->VALOR)
		oSection2:Cell("VALORS"):SetValue(TrbFor->VALORS)
		oSection2:Cell("VALMERC"):SetValue(TrbFor->VALMERC)
		oSection2:Cell("VALORNF"):SetValue(TrbFor->VALORNF)
		oSection2:Cell("VALIPI"):SetValue(TrbFor->VALIPI)
		oSection2:Cell("VALCPMF"):SetValue(TrbFor->VALCPMF)
		oSection2:Cell("VALICMS"):SetValue(TrbFor->VALICMS)
		oSection2:Cell("VALFIN"):SetValue(TrbFor->VALFIN)
		oSection2:Cell("VALFRET"):SetValue(TrbFor->VALFRET)
		oSection2:Cell("VALDESC"):SetValue(TrbFor->VALDESC)
		
		oSection2:Printline()
		TrbFor->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo

//SEÇÃO 3 - Por Alíquota
dbSelectArea("TrbAliq")

oReport:SetMeter(TrbAliq->(LastRec()))
TrbAliq->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection3:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TrbAliq")
	
	IncProc("Imprimindo Compras x Alíquotas")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a segunda seção
		oSection3:Cell("ALIQICM"):SetValue(TrbAliq->ALIQICM)
		oSection3:Cell("QUANT"):SetValue(TrbAliq->QUANT)
		oSection3:Cell("VALOR"):SetValue(TrbAliq->VALOR)
		oSection3:Cell("VALORS"):SetValue(TrbAliq->VALORS)
		oSection3:Cell("VALMERC"):SetValue(TrbAliq->VALMERC)
		oSection3:Cell("VALORNF"):SetValue(TrbAliq->VALORNF)
		oSection3:Cell("VALIPI"):SetValue(TrbAliq->VALIPI)
		oSection3:Cell("VALCPMF"):SetValue(TrbAliq->VALCPMF)
		oSection3:Cell("VALICMS"):SetValue(TrbAliq->VALICMS)
		oSection3:Cell("VALFIN"):SetValue(TrbAliq->VALFIN)
		oSection3:Cell("VALFRET"):SetValue(TrbAliq->VALFRET)
		oSection3:Cell("VALDESC"):SetValue(TrbAliq->VALDESC)
		
		oSection3:Printline()
		TrbAliq->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo


//SEÇÃO 4 - Por Produto
dbSelectArea("TrbProd")

oReport:SetMeter(TrbProd->(LastRec()))
TrbProd->(dbGoTop())

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection4:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TrbProd")
	
	IncProc("Imprimindo Compras x Produtos")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a segunda seção
		oSection4:Cell("COD"):SetValue(TrbProd->COD)
		oSection4:Cell("CODRED"):SetValue(TrbProd->CODRED)
		oSection4:Cell("DESC"):SetValue(TrbProd->DESC)
		oSection4:Cell("QUANT"):SetValue(TrbProd->QUANT)
		oSection4:Cell("VALOR"):SetValue(TrbProd->VALOR)
		oSection4:Cell("VALORS"):SetValue(TrbProd->VALORS)
		oSection4:Cell("VALMERC"):SetValue(TrbProd->VALMERC)
		oSection4:Cell("VALORNF"):SetValue(TrbProd->VALORNF)
		oSection4:Cell("VALIPI"):SetValue(TrbProd->VALIPI)
		oSection4:Cell("VALCPMF"):SetValue(TrbProd->VALCPMF)
		oSection4:Cell("VALICMS"):SetValue(TrbProd->VALICMS)
		oSection4:Cell("VALFIN"):SetValue(TrbProd->VALFIN)
		oSection4:Cell("VALFRET"):SetValue(TrbProd->VALFRET)
		oSection4:Cell("VALDESC"):SetValue(TrbProd->VALDESC)
		
		oSection4:Printline()
		TrbProd->(dbSkip())
	Enddo
	
	//finalizo a 4a seção
Enddo

dbSelectArea("TRBNF")
TRBNF->(dbGoTop())

oReport:SetMeter(TRBNF->(LastRec()))

While !Eof()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	//inicializo a primeira seção
	oSection5:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRBNF")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		//imprimo a quinta seção
		oSection5:Cell("DOC"):SetValue(TRBNF->DOC)
		oSection5:Cell("FORNECE"):SetValue(TRBNF->FORNECE)
		oSection5:Cell("EMISSAO"):SetValue(TRBNF->EMISSAO)
		oSection5:Cell("ENTRADA"):SetValue(TRBNF->ENTRADA)
		oSection5:Cell("DIGITAC"):SetValue(TRBNF->DIGITAC)
		oSection5:Cell("EST"):SetValue(TRBNF->EST)
		oSection5:Cell("CONDPAG"):SetValue(TRBNF->CONDPAG)
		oSection5:Cell("QUANT"):SetValue(TRBNF->QUANT)
		oSection5:Cell("VALOR"):SetValue(TRBNF->VALOR)
		oSection5:Cell("VALORS"):SetValue(TRBNF->VALORS)
		oSection5:Cell("VALMERC"):SetValue(TRBNF->VALMERC)
		oSection5:Cell("VALORNF"):SetValue(TRBNF->VALORNF)
		oSection5:Cell("VALIPI"):SetValue(TRBNF->VALIPI)
		oSection5:Cell("VALCPMF"):SetValue(TRBNF->VALCPMF)
		oSection5:Cell("VALICMS"):SetValue(TRBNF->VALICMS)
		oSection5:Cell("VALFIN"):SetValue(TRBNF->VALFIN)
		oSection5:Cell("VALFRET"):SetValue(TRBNF->VALFRET)
		oSection5:Cell("VALDESC"):SetValue(TRBNF->VALDESC)
		oSection5:Cell("NATUREZA"):SetValue(TRBNF->NATUREZA)
		
		oSection5:Printline()
		TRBNF->(dbSkip())
	Enddo
	
	//finalizo a primeira seção
Enddo

oSection5:Finish()
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()

Return

