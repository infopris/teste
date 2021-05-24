#INCLUDE "FINR720.CH"
#Include "PROTHEUS.CH"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FINR720  ³ Autor ³ Vin¡cius Barreira     ³ Data ³ 04.08.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Comparativo entre Valores Or‡ados x Reais Mensal           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR720(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFIN009()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1 := STR0001  //"Emiss„o do relat¢rio comparativo entre Or‡ados x Reais."
LOCAL cDesc2 := STR0002  //"Ser  analisado o mˆs de referˆncia da data base"
LOCAL cDesc3 :=""
LOCAL wnrel
LOCAL cString:="SED"
LOCAL tamanho:="M"
Local cTexto
Local dOldDtBase := dDataBase
Local nDespA  := nDespC  := nDespF  := nDespG  := nDespP  := nDescto := nRecFin := 0
Local nDespIm := nDespOu := nDespJr := nDespIp := nDespDs := nDespAm := 0

PRIVATE aReturn := { STR0003, 1,STR0004, 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="RFIN009"
PRIVATE nLastKey := 0
//PRIVATE cPerg   :="FIN720"
PRIVATE cPerg   :="RFIN009"
Private Titulo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 11 (Data Base)

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parƒmetros                        ³
//³      Entradas                                               ³
//³ mv_par01            // da Natureza                          ³
//³ mv_par02            // at‚ a Natureza                       ³
//³      Saidas                                                 ³
//³ mv_par03            // da Natureza                          ³
//³ mv_par04            // at‚ a Natureza                       ³
//³      Outros Parƒmetros                                      ³
//³ mv_par05            // Regime de Caixa/Competˆncia          ³
//³ mv_par06            // Moeda                                ³
//³ mv_par07            // Imprime Acumulados ?                 ³
//³ mv_par08            // Data de Referencia ?                 ³
//³ mv_par09            // Outras moedas      ?                 ³
//³ mv_par10            // Considera Provisorios?               ³
//³ mv_par11      	   // Data Base	 			³
//³ mv_par12            // Depto de                             ³
//³ mv_par13      	// Depto ate   				³
//³ mv_par14      	// Sintetico / Analitico		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo:= STR0005  //"Mapa Comparativo - Valores Orcados x Reais em "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RFIN009"            //Nome Default do relat¢rio em Disco

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

cTexto	:= GetMv("MV_MOEDA"+Str(mv_par06,1))
Titulo	+= (cTexto + " " + MesExtenso( mv_par08 ) + "-" + Str(Year(mv_par08),4,0))

Do Case
	Case mv_par02 < mv_par01
		HELP (" ",1,"R720NAT")
		Return
	Case mv_par04 < mv_par03
		HELP (" ",1,"R720NAT")
		Return
	Case mv_par01 == mv_par03
		HELP (" ",1,"R720NAT")
		Return
	Case mv_par01 > mv_par03 .and. (mv_par01 <= mv_par04 .or. mv_par02 <= mv_par03)
		HELP (" ",1,"R720NAT")
		Return
	Case mv_par01 < mv_par03 .and. (mv_par01 >= mv_par04 .or. mv_par02 >= mv_par03)
		HELP (" ",1,"R720NAT")
		Return
EndCase

Retindex("SE1")
Retindex("SE2")
Retindex("SE5")
Retindex("SD2")

dDataBase := mv_par11 // Altera data base conforme parametro
if mv_par14==1
	RptStatus({|lEnd| Fr720Imp(@lEnd,wnRel,cString)},Titulo)
else
	RptStatus({|lEnd| FrAnImp(@lEnd,wnRel,cString)},Titulo)
Endif
dDataBase := dOldDtBase // Restaura Data base
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ fr720Imp ³ Autor ³ Lu¡s C. Cunha         ³ Data ³ 05/11/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Or‡ados x Reais                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ fr720Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGAFIN                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³           ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos  ³ SA6 ( cadastro de bancos )                                 ³±±
±±³           ³ SE5 ( movimenta‡„o banc ria )                              ³±±
±±³           ³ SED ( cadastro de naturezas )                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fr720Imp(lEnd,wnRel,cString)
LOCAL aNiveis		:= {}
LOCAL aQuebras		:= {}
LOCAL nLaco			:= 0
LOCAL nByte			:= 0
LOCAL cMapa			:= ""
LOCAL nLimite		:= 0
LOCAL cabec1		:= 	STR0006 + space(27) + STR0007 + ;  // "Cod Natureza    Descricao"###"A Realizar            Realizado         Orcado          %"
if(mv_par07==1,space(20)+STR0026,"") // "Acumulado     Acumulado         %"
	LOCAL cabec2		:= space(54)+STR0030+if(mv_par07==1,space(18)+STR0027,"") // (A)     (B)      (C)     (A+B)/C ### "Realizado        Or‡ado"
	LOCAL tamanho		:=if(mv_par07==1,"G","M")
	Local nOrcAcm		:= 0
	Local nLaco2
	Local aOacumu
	Local aRCols		:= { 	048,;	// Coluna 1 : *** a Realizar no Mes ***
	067,; 	// Coluna 2 : Realizado no mes
	088,; 	// Coluna 3 : Orcado no Mes
	105,;	// Coluna 4 : % a realiz + realizado / orcado
	115,; 	// Coluna 5 : % realizado / orcado
	134,; 	// Coluna 6 : *** a Realizar Acumulado ***
	153,; 	// Coluna 7 : Realizado Acumulado
	174,; 	// Coluna 8 : Orcado Acumulado
	191,; 	// Coluna 9 : % a realiz + realizado / Orcado acm.
	201}  	// Coluna 10 : % realizado / orcado acm.}
	
	Local aTCols		:= {	{000,074,148},;	// Colunas Totalizadoras c/ Acumulado
	{000,044,088}}		// Colunas Totalizadoras s/ Acumulado
	Local aTotais 		:= {0,0,0,0,0,0,0,0,0,0,0,0}
	Local cArqTmp 		:= cIndex1 := cIndex2 := cIndex3 := ""
	Local nQuebras
	
	Private nDecs     	:= MsDecimais(mv_par06)
	
	IF SELECT("cArqTmp") # 0
		cArqTmp->(DBCLOSEAREA( ))
	ENDIF
	
	Fin720Cria(@cArqTmp, @cIndex1, @cIndex2, @cIndex3)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ a formata‡„o do c¢digo das naturezas   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMascNat := GetMV("MV_MASCNAT")
	cMapa    := "123456789"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Esta matriz informa em que posi‡”es ser„o feitas as quebras.   ³
	//³ 1-Byte inicial da quebra, 2-Quantidade de caracteres.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aNiveis  := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Esta matriz armazena as chaves de quebra e os totalizadores parciais.  ³
	//³ 1-Chave, 2-A Realizar, 3-Realizado e 4-Or‡ado                          ³
	//³ 5-A Realizar Acum. 6-Realizado Acumulado e 7-Orcado acumulado 			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aQuebras := {}
	For nLaco := 1 to len( cMascNat )
		nByte := Val( Substr( cMascNat,nLaco,1 ) )
		If nByte > 0
			AAdd( aNiveis  , { Val(Left(cMapa,1)) , nByte} )
			AAdd( aQuebras , { "", 0, 0, 0 ,0 ,0 ,0} )
			cMapa := Subst(cMapa,nByte+1,Len(cMapa)-nByte)
		Endif
	Next
	//EndFor
	nLimite := IIf(Len(aNiveis) > 1, Len(aNiveis)-1, 1)
	cabec1		:= "Cod Natureza    Descricao                               Orcado     Realizado                A Realizar         Total   %Total"
	cabec2		:= "                                                           (A)        (B)        (B/A)             (C)         (B+C)  (B+C)/A"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o relat¢rio a partir do arquivo tempor rio  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("cArqTmp")
	dbgotop()
	do while !eof()
		if left(divis,1)==" "
			reclock("cArqTmp",.f.)
			cArqTmp->divis := "Z"
			MsUnLock()
		endif
		skip
	enddo
	cIndex4 := CriaTrab(nil,.f.)
	index on DIVIS+NATUR to &cIndex4
	dbGoTop()
	li := 80
	
	nTotOrc := nTotReal := nTotAReal := ntotVal := 0
	nDespA  := nDespC  := nDespF  := nDespG  := nDespP  := nDescto := nRecFin := 0
	nDespIm := nDespOu := nDespJr := nDespIp := nDespDs := nDespAm := 0
	
	While !cArqTmp->( Eof() )
		If Li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		if divis < mv_par12 .or. divis > mv_par13
			skip
			loop
		endif
		nTotOrc2:= nTotReal2:= nTotAReal2:= ntotVal2:= 0
		cDivis1:= left(Divis,1)
		Do while !eof() .and. left(Divis,1)==cDivis1
			
			nOrcado := 0
			cDivis := Divis
			Select SX5
			Seek xFilial()+"ZW"+cDivis
			cDiv := sx5->x5_descri
			
			dbSelectArea("cArqTmp")
			nTotOrc1:= nTotReal1:= nTotAReal1:= ntotVal1:= 0
			Do while !eof() .and. Divis==cDivis
				IF LEFT(cArqTmp->DESCR,06)=="INATIV"
					skip
					loop
				endif
				If Li > 60
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
				Endif
				If SE7->(dbSeek(xFilial("SE7")+cArqTmp->NATUR+Str(Year(mv_par08),4)))
					nOrcado:=GetOrcado(month(mv_par08))
				else
					nOrcado:=0
				endif
				dbSelectArea("cArqTmp")
				nRealiz := cArqTmp->rEntr+cArqTmp->rSaid
				naReali := cArqTmp->aEntr+cArqTmp->aSaid
				@li, 0  Psay left(Mascnat(cArqTmp->Natur),10)
				@li,12  Psay cDivis picture "@!"
				@li,16  Psay cArqTmp->DESCR
				@li,48  Psay nOrcado Picture TM(rEntr,14,nDecs)
				@li,62  Psay nRealiz Picture TM(rEntr,14,nDecs)
				@li,78  Psay iif(nOrcado<>0,nRealiz/nOrcado*100,0) picture "@E 9999.99%"
				@li,88  Psay naReali Picture TM(aEntr,14,nDecs)
				@li,102 Psay nRealiz+naReali Picture TM(aEntr,14,nDecs)
				@li,118 Psay iif(nOrcado<>0,(nRealiz+naReali)/nOrcado*100,0) Picture "@E 9999.99%"
				
				nTotOrc   += nOrcado
				nTotReal  += nRealiz
				nTotAReal += naReali
				ntotVal   += nRealiz+naReali
				
				nTotOrc1  += nOrcado
				nTotReal1 += nRealiz
				nTotAReal1+= naReali
				ntotVal1  += nRealiz+naReali
				
				nTotOrc2  += nOrcado
				nTotReal2 += nRealiz
				nTotAReal2+= naReali
				ntotVal2  += nRealiz+naReali
				
				// Acumula valores para Resumo Contabil
				Do case
					case left(cArqTmp->Natur,3)="208"
						nDespIm += nRealiz
					case left(cArqTmp->Natur,5)="22506"
						nDespOu += nRealiz
					case left(cArqTmp->Natur,5)$"22001*22002*22003"
						nDespJr += nRealiz
					case left(cArqTmp->Natur,5)="22505"
						nDespIp += nRealiz
						//			case left(cArqTmp->Natur,5)="22506"
						//				nDespDs += naReali
						//			case left(cArqTmp->Natur,5)="22506"
						//				nDespAm += naReali
				endCase
				
				li++
				skip
			Enddo
			li++
			@li, 0  Psay "Sub-total da divisao "+left(cDiv,20)
			@li,48  Psay nTotOrc1   Picture TM(rEntr,14,nDecs)
			@li,62  Psay ntotReal1  Picture TM(rEntr,14,nDecs)
			@li,78  Psay iif(ntotOrc1<>0,ntotReal1/ntotorc1*100,0) Picture "@E 9999.99%"
			@li,88  Psay ntotaReal1 Picture TM(aEntr,14,nDecs)
			@li,102 Psay ntotReal1+ntotaReal1 Picture TM(aEntr,14,nDecs)
			@li,118 Psay iif(ntotOrc1<>0,(ntotReal1+ntotaReal1)/ntotOrc1*100,0) Picture "@E 9999.99%"
			li++
			li++
			Do case
				Case cDivis = 'A '
					nDespA += ntotReal1
				Case cDivis = 'C '
					nDespC += ntotReal1
				Case cDivis = 'F '
					nDespF += ntotReal1
				Case cDivis = 'G '
					nDespG += ntotReal1
				Case cDivis = 'P '
					nDespP += ntotReal1
			EndCase
			dbSelectArea("cArqTmp")
		Enddo
		@li, 0  Psay "total da divisao "+cDivis1
		@li,48  Psay nTotOrc2   Picture TM(rEntr,14,nDecs)
		@li,62  Psay ntotReal2  Picture TM(rEntr,14,nDecs)
		@li,78  Psay iif(ntotOrc2<>0,ntotReal2/ntotorc2*100,0) Picture "@E 9999.99%"
		@li,88  Psay ntotaReal2 Picture TM(aEntr,14,nDecs)
		@li,102 Psay ntotReal2+ntotaReal2 Picture TM(aEntr,14,nDecs)
		@li,118 Psay iif(ntotOrc2<>0,(ntotReal2+ntotaReal2)/ntotOrc2*100,0) Picture "@E 9999.99%"
		li++
		li++
		
		if cArqTmp->divis == "Z "
			exit
		endif
		
	End
	If Li > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	@li, 0  Psay "Total Despesas "
	@li,48  Psay nTotOrc    Picture TM(rEntr,14,nDecs)
	@li,62  Psay ntotReal   Picture TM(rEntr,14,nDecs)
	@li,78  Psay iif(ntotOrc<>0,ntotReal/ntotorc*100,0) Picture "@E 9999.99%"
	@li,88  Psay ntotaReal  Picture TM(aEntr,14,nDecs)
	@li,102 Psay ntotReal+ntotaReal Picture TM(aEntr,14,nDecs)
	@li,118 Psay iif(ntotOrc<>0,(ntotReal+ntotaReal)/ntotOrc*100,0) Picture "@E 9999.99%"
	
	if left(mv_par12,1)==left(mv_par13,1) .and. left(mv_par12,1)<>" "
		
		li := 80
		nTotOrc1:= nTotReal1:= nTotAReal1:= ntotVal1:= 0
		Titulo	+= " Outros pgtos"
		
		While !cArqTmp->( Eof() )
			If Li > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			Endif
			nOrcado := 0
			IF LEFT(cArqTmp->DESCR,06)=="INATIV"
				skip
				loop
			endif
			If SE7->(dbSeek(xFilial("SE7")+cArqTmp->NATUR+Str(Year(mv_par08),4)))
				nOrcado:=GetOrcado(month(mv_par08))
			endif
			dbSelectArea("cArqTmp")
			nRealiz := cArqTmp->rEntr+cArqTmp->rSaid
			naReali := cArqTmp->aEntr+cArqTmp->aSaid
			@li, 0  Psay Mascnat(cArqTmp->Natur)
			@li,16  Psay cArqTmp->DESCR
			@li,48  Psay nOrcado Picture TM(rEntr,14,nDecs)
			@li,62  Psay nRealiz Picture TM(rEntr,14,nDecs)
			@li,78  Psay iif(nOrcado<>0,nRealiz/nOrcado*100,0) picture "@E 9999.99%"
			@li,88  Psay naReali Picture TM(aEntr,14,nDecs)
			@li,102 Psay nRealiz+naReali Picture TM(aEntr,14,nDecs)
			@li,118 Psay iif(nOrcado<>0,(nRealiz+naReali)/nOrcado*100,0) Picture "@E 9999.99%"
			
			nTotOrc1  += nOrcado
			nTotReal1 += nRealiz
			nTotAReal1+= naReali
			ntotVal1  += nRealiz+naReali
			li++
			skip
		End
		li++
		If Li > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		@li, 0  Psay "Total Outros "
		@li,48  Psay nTotOrc1   Picture TM(rEntr,14,nDecs)
		@li,62  Psay ntotReal1  Picture TM(rEntr,14,nDecs)
		@li,78  Psay iif(ntotOrc1<>0,ntotReal1/ntotorc1*100,0) Picture "@E 9999.99%"
		@li,88  Psay ntotaReal1 Picture TM(aEntr,14,nDecs)
		@li,102 Psay ntotReal1+ntotaReal1 Picture TM(aEntr,14,nDecs)
		@li,118 Psay iif(ntotOrc1<>0,(ntotReal1+ntotaReal1)/ntotOrc1*100,0) Picture "@E 9999.99%"
		
		li++
		@li, 0  Psay replicate("-",132)
		li++
		@li, 0  Psay "Total Geral "
		@li,62  Psay ntotReal+ntotReal1   Picture TM(rEntr,14,nDecs)
		@li,88  Psay ntotaReal+ntotaReal1  Picture TM(aEntr,14,nDecs)
		@li,102 Psay ntotReal+ntotaReal+ntotReal1+ntotaReal1 Picture TM(aEntr,14,nDecs)
		
	Endif
	
	dbGoTop()
	
	roda(cbcont,cbtxt,Tamanho)
	
	Set Device To Screen
	dbSelectArea("SE5")
	RetIndex("SE5")
	Set Filter To
	
//	GeraBal() // Função retirada até estabilizar o programa
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga arquivos tempor rios  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectarea("cArqTmp")
	copy to trbdesp
	cArqTmp->( dbCloseArea() )
	Ferase(cArqTmp+GetDBExtension())
	Ferase(cArqTmp+OrdBagExt())
	
	dbSelectarea("RESU")
	copy to trbresu
	RESU->( dbCloseArea() )
	
	#IFDEF TOP
		If TcSrvType() == "AS/400"
			Ferase(cIndex1+OrdBagExt())
			Ferase(cIndex2+OrdBagExt())
		Endif
	#ELSE
		Ferase(cIndex1+OrdBagExt())
		Ferase(cIndex2+OrdBagExt())
		Ferase(cIndex3+OrdBagExt())
	#ENDIF
	
	dbSelectArea("SE1")
	
	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³FR720ChecF³ Autor ³ Vin¡cius Barreira     ³ Data ³ 04/09/94 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Filtra o arquivo A Receber para analisar o "A Realizar"    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ FR720ChecF()                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ FINR720                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function FR720ChecF()
	Local cFiltro := 'E1_FILIAL="'+xFilial("SE1")+'" .AND. '
/*	#IFDEF TOP
		Local cDbMs
		cDbMs	 := UPPER(TcGetDb())
		If TcSrvType() = "AS/400"
			cFiltro += 'E1_NATUREZ >= "' + mv_par01 + '" .AND. '
			cFiltro += 'E1_NATUREZ <= "' + mv_par02 + '" .AND. '
			If mv_par07 == 1
				*** Se calcula acumulado, pega vencimentos desde 01/01/ano_atual
				cFiltro += 'dTos(E1_VENCREA) >= "' + dTos(ctod("01/01/"+str(year(MV_PAR08),4),"ddmmyy") ) + '" .AND. '
			Else
				*** Sen„o, pega vencimentos apenas no mˆs
				cFiltro += 'dTos(E1_VENCREA) >= "' + dTos(FirstDay(MV_PAR08)) + '" .AND. '
			Endif
			cFiltro += 'dtos(E1_VENCREA) <= "' + dTos( LastDay(MV_PAR08) ) + '" .AND. '
			cFiltro += 'E1_SALDO > 0 '
		Else
			cFiltro := ""
			cFiltro += " WHERE SED.ED_FILIAL = '"+xFilial("SED")+"'"
			cFiltro +=   " AND SED.ED_CODIGO between '"+ mv_par01 + "' AND '" + mv_par02 + "'"
			If cDbMs == "ORACLE"
				cFiltro += "   AND SED.ED_CODIGO = SE1.E1_NATUREZ(+) "
			ElseIf (cDbMs == "INFORMIX" .or. cDbMs == "POSTGRES")
				cFiltro += "   AND SED.ED_CODIGO = SE1.E1_NATUREZ "
			ElseIf !(cDbMs $ "DB2/MYSQL")
				cFiltro += "   AND SED.ED_CODIGO *= SE1.E1_NATUREZ "
			Endif
			cFiltro +=   " AND SE1.E1_FILIAL = '" + xFilial("SE1") + "'"
			If mv_par07 == 1
				*** Se calcula acumulado, pega vencimentos desde 01/01/ano_atual
				cFiltro += " AND SE1.E1_VENCREA >= '" + dTos(ctod("01/01/"+str(year(MV_PAR08),4),"ddmmyy") ) + "'"
			Else
				*** Sen„o, pega vencimentos apenas no mˆs
				cFiltro += " AND SE1.E1_VENCREA >= '" + dTos(FirstDay(MV_PAR08)) + "'"
			Endif
			cFiltro += " AND SE1.E1_VENCREA <= '" + dTos( LastDay(MV_PAR08) ) + "'"
			cFiltro += " AND SE1.E1_SALDO > 0 "
			cFiltro += " AND SED.D_E_L_E_T_ <> '*'"
			cFiltro += " AND SE1.D_E_L_E_T_ <> '*'"
		Endif
	#ELSE
*/		cFiltro += 'E1_NATUREZ >= "' + mv_par01 + '" .AND. '
		cFiltro += 'E1_NATUREZ <= "' + mv_par02 + '" .AND. '
		If mv_par07 == 1
			*** Se calcula acumulado, pega vencimentos desde 01/01/ano_atual
			cFiltro += 'dTos(E1_VENCREA) >= "' + dTos(ctod("01/01/"+str(year(mv_par08),4),"ddmmyy") ) + '" .AND. '
		else
			*** Sen„o, pega vencimentos apenas no mˆs
			cFiltro += 'dTos(E1_VENCREA) >= "' + dTos(FirstDay(mv_par08)) + '" .AND. '
		Endif
		cFiltro += 'dtos(E1_VENCREA) <= "' + dTos( LastDay(mv_par08) ) + '" .AND. '
		cFiltro += 'E1_SALDO > 0 '
//	#ENDIF
	Return cFiltro
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³FR721ChecF³ Autor ³ Vin¡cius Barreira     ³ Data ³ 04/09/94 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Filtra o arquivo A Pagar para analisar o "A Realizar"      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ FR721ChecF()                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ FINR720                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function FR721ChecF()
	Local cFiltro := 'E2_FILIAL="'+xFilial("SE2")+'" .And. '
	#IFDEF ZZTOP
		Local cDbMs
		
		cDbMs	 := UPPER(TcGetDb())
		If TcSrvType() = "AS/400"
			cFiltro += 'E2_NATUREZ >= "' + mv_par03 + '" .AND. '
			cFiltro += 'E2_NATUREZ <= "' + mv_par04 + '" .AND. '
			If mv_par07 == 1
				**** Se calcula acumulado, pega vencimentos desde 01/01/ano_atual
				cFiltro += 'dTos(E2_VENCREA) >= "' + dTos(ctod("01/01/"+str(year(mv_par08),4),"ddmmyy") ) + '" .AND. '
			else
				**** Sen„o, pega vencimentos apenas no mˆs
				cFiltro += 'dTos(E2_VENCREA) >= "' + dTos(FirstDay(mv_par08)) + '" .AND. '
			Endif
			cFiltro += 'dTos(E2_VENCREA) <= "' + dTos(LastDay(mv_par08)) + '" .AND. '
			cFiltro += 'E2_SALDO > 0 '
		Else
			cFiltro := ""
			cFiltro += " WHERE SED.ED_FILIAL = '"+xFilial("SED")+"'"
			cFiltro +=   " AND SED.ED_CODIGO between '"+ mv_par03 + "' AND '" + mv_par04 + "'"
			If cDbMs == "ORACLE"
				cFiltro += "   AND SED.ED_CODIGO = SE2.E2_NATUREZ(+) "
			ElseIf (cDbMs == "INFORMIX" .or. cDbMs == "POSTGRES")
				cFiltro += "   AND SED.ED_CODIGO = SE2.E2_NATUREZ "
			ElseIf !(cDbMs $ "DB2/MYSQL")
				cFiltro += "   AND SED.ED_CODIGO *= SE2.E2_NATUREZ "
			Endif
			cFiltro +=   " AND SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
			If mv_par07 == 1
				*** Se calcula acumulado, pega vencimentos desde 01/01/ano_atual
				cFiltro += " AND SE2.E2_VENCREA >= '" + dTos(ctod("01/01/"+str(year(mv_par08),4),"ddmmyy") ) + "'"
			Else
				*** Sen„o, pega vencimentos apenas no mˆs
				cFiltro += " AND SE2.E2_VENCREA >= '" + dTos(FirstDay(mv_par08)) + "'"
			Endif
			cFiltro += " AND SE2.E2_VENCREA <= '" + dTos( LastDay(mv_par08) ) + "'"
			cFiltro += " AND SE2.E2_SALDO > 0 "
			cFiltro += " AND SED.D_E_L_E_T_ <> '*'"
			cFiltro += " AND SE2.D_E_L_E_T_ <> '*'"
		Endif
	#ELSE
		cFiltro += 'E2_NATUREZ >= "' + mv_par03 + '" .AND. '
		cFiltro += 'E2_NATUREZ <= "' + mv_par04 + '" .AND. '
		If mv_par07 == 1
			**** Se calcula acumulado, pega vencimentos desde 01/01/ano_atual
			cFiltro += 'dTos(E2_VENCREA) >= "' + dTos(ctod("01/01/"+str(year(mv_par08),4),"ddmmyy") ) + '" .AND. '
		else
			**** Sen„o, pega vencimentos apenas no mˆs
			cFiltro += 'dTos(E2_VENCREA) >= "' + dTos(FirstDay(mv_par08)) + '" .AND. '
		Endif
		cFiltro += 'dTos(E2_VENCREA) <= "' + dTos(LastDay(mv_par08)) + '" .AND. '
		cFiltro += 'E2_SALDO > 0 '
	#ENDIF
	Return cFiltro
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³FR722ChecF³ Autor ³ Vin¡cius Barreira     ³ Data ³ 04/09/94 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Filtra o arquivo de Movimenta‡„o Banc ria para analisar o  ³±±
	±±³          ³ Realizado.                                                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ FR722ChecF()                                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ FINR720                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function FR722ChecF()
	Local cFiltro := "E5_FILIAL='"+xFilial("SE5")+"' .And. ", cInicio := "" , cFim := ""
	If mv_par07 == 1
		**** Se calcula acumulado, considera desde o in¡cio do ano
		cInicio := dTos( ctod("01/01/"+str(year(mv_par08),4),"ddmmyy") )
	Else
		**** Sen„o, considera in¡cio do mes
		cInicio := dTos( FirstDay(mv_par08) )
	Endif
	cFim    := dTos( LastDay(mv_par08) )
	cFiltro += 'E5_NATUREZ >= "' + IIf(mv_par01<mv_par03,mv_par01,mv_par03)  + '" .AND. '
	cFiltro += 'E5_NATUREZ <= "' + IIf(mv_par02>mv_par04,mv_par02,mv_par04)  + '" .AND. '
	If mv_par05 == 1 // Regime de caixa
		//	cFiltro += 'dTos(E5_DATA) >= "' + cInicio  + '" .AND. '
		//	cFiltro += 'dtos(E5_DATA) <= "' + cFim + '"'
		cFiltro += 'dTos(E5_DTDISPO) >= "' + cInicio  + '" .AND. '
		cFiltro += 'dtos(E5_DTDISPO) <= "' + cFim + '"'
		
	Else
		cFiltro += 'dTos(E5_DTDIGIT) >= "' + cInicio  + '" .AND. '
		cFiltro += 'dtos(E5_DTDIGIT) <= "' + cFim + '"'
	EndIf
	Return cFiltro
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³ DevCred  ³ Autor ³ Alessandro B. Freire  ³ Data ³ 27/03/95 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Subtrai valor1 de valor2. Devolve um array com um valor    ³±±
	±±³          ³ positivo outro elemento com devedor ou credor              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ DevCred( nExp1, nExp2 )                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³  nExp1 = a receber nExp2 = a Pagar                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ FINR720                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function DevCred( nValor1, nValor2 )
	Local aRet := {}, cDevCred
	nRTotal := nValor1-nValor2
	Do Case
		Case ( nRTotal < 0 )
			nRTotal := nRTotal * (-1)
			cDevCred := STR0024  //" (  Devedor   )"
		Case ( nRTotal > 0 )
			cDevCred := STR0025  //" (   Credor   )"
		OtherWise
			cDevCred := " "
	EndCase
	AAdd( aRet, nRTotal )
	AAdd( aRet, cDevCred)
	Return( aRet )
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³GetOrcado ³ Autor ³ J£lio Wittwer         ³ Data ³ 19/03/99 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Retorna o orcamento registrado para a Natureza no Mes.     ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ FR722ChecF(<nMes>)                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ nMes : Numero do Mes a obter o Or‡amento                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ FINR720                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function GetOrcado(nMes)
	Local nValOrcado := 0
	
	Do Case
		Case nMes == 1
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALJAN1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 2
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALFEV1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 3
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALMAR1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 4
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALABR1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 5
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALMAI1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 6
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALJUN1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 7
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALJUL1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 8
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALAGO1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 9
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALSET1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 10
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALOUT1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 11
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALNOV1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
		Case nMes == 12
			nValOrcado := Round(NoRound(xMoeda(SE7->E7_VALDEZ1,SE7->E7_MOEDA,mv_par06,mv_par08,nDecs+1),nDecs+1),nDecs+1)
	EndCase
	Return nValOrcado
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡„o    ³Fin720Cria³ Autor ³ Wagner Mobile Costa   ³ Data ³ 29/07/02 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡„o ³ Monta arquivo temporario para apresentacao orcado x real   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe   ³ Fin720Cria(cArqTmp,cIndex1,cIndex2,cIndex3,lRelato)        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ cArqTmp - Nome do Arquivo temporario a ser criado          ³±±
	±±³          ³ cIndex1 - Nome do indice temporario  Contas a Receber      ³±±
	±±³          ³ cIndex2 - Nome do indice temporario  Contas a Pagar        ³±±
	±±³          ³ cIndex3 - Nome do indice temporario  Movimento Bancario    ³±±
	±±³          ³ lRelato - Indica se e chamado via relatorio (Default .T.)  ³±±
	±±³          ³ aNivel   - Array com nivels de quebra                      ³±±
	±±³          ³ aQuebras - Array de Quebras baseado MV_MASCNAT             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ SigaFin                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function Fin720Cria(cArqTmp, cIndex1, cIndex2, cIndex3, lRelato, aNiveis, aQuebras)
	
	Local aTotais	:= {0,0,0,0,0,0,0,0,0,0,0,0}	// Vetor com 12 Totalizadores
	Local nMoedaBco	:= 1, aArrayQ := {}
	Local aArray 	:= { }, aTotal, aAcumu
	#IFDEF ZZTOP
		Local cDbMs
		Local nj := 0
		Local ny := 0
		Local aStruSED   := SED->(dbStruct())
	#ENDIF
	Local nLaco
	Local nQuebras
	Local nLaco2
	Local bProp
	Local bWhile
	Local nProp
	Local nWhiles := 1
	Local lTemSev := .F.
	Local nRecSed
	Local aSaldoTit
	
	DEFAULT lRelato := .T.
	
	cFilterUser:= Iif(Type("aReturn[7]") == "U"," ",aReturn[7])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera arquivo de Trabalho      						  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos:={ 	{"NATUR"  , "C" , Len(SED->ED_CODIGO),0},;	// Cod. da Natureza
	{"FILIAL" , "C" , 02,0},;	// Codigo da Filial
	{"TITULO" , "C" , 10,0},;	// Codigo da Filial
	{"FORN"   , "C" , 08,0},;	// Codigo da Filial
	{"NOME"   , "C" , 40,0},;	// Codigo da Filial
	{"BENEF"  , "C" , 30,0},;	// Codigo da Filial
	{"HIST"   , "C" , 30,0},;	// Codigo da Filial
	{"DIVIS"  , "C" , 02,0},;	// Divisao
	{"DESCR"  , "C" , 30,0},;	// Descricao da Natureza
	{"AENTR"  , "N" , 17,2},;	// A Realizar Entrada no Mes
	{"ASAID"  , "N" , 17,2},;	// A Realizar Saida no Mes
	{"RENTR"  , "N" , 17,2},;	// Realizado Entrada no Mes
	{"RSAID"  , "N" , 17,2},;	// Realizado Saida no Mes
	{"AEACM"  , "N" , 17,2},;	// A realizar Entrada ACuMulado
	{"ASACM"  , "N" , 17,2},;	// A realizar Saida   ACuMulado
	{"REACM"  , "N" , 17,2},;	// Realizado Entrada ACuMulado
	{"RSACM"  , "N" , 17,2},;	// Realizado Saida   ACuMulado
	{"TIPO"   , "C" , 01,0} }	// Tipo P ou R
	
	cArqTmp := CriaTrab(aCampos)
	dbUseArea( .T.,, cArqTmp, "cArqTmp",.F.,.F.)
	IndRegua ( "cArqTmp",cArqTmp,"NATUR",,,STR0008)  //"Selecionando Registros..."
	
	aCampos:={ 	{"NATUR"  , "C" , Len(SED->ED_CODIGO),0},;	// Cod. da Natureza
	{"TITULO" , "C" , 10,0},;	// Codigo da Filial
	{"FORN"   , "C" , 08,0},;	// Codigo da Filial
	{"NOME"   , "C" , 40,0},;	// Codigo da Filial
	{"BENEF"  , "C" , 30,0},;	// Codigo da Filial
	{"HIST"   , "C" , 30,0},;	// Codigo da Filial
	{"DIVIS"  , "C" , 02,0},;	// Divisao
	{"VALOR"  , "N" , 17,2},;	// A Realizar Entrada no Mes
	{"NRECNO" , "N" , 10,0},;	// Registro do SE5
	{"TPNAT"  , "C" , 06,0},;	// Tipo de Operacao
	{"TIPO"   , "C" , 01,0} }	// Tipo P ou R
	
	cArqRes := CriaTrab(aCampos)
	dbUseArea( .T.,, cArqRes, "RESU",.F.,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona o arquivo SE1 - Contas a Receb, selecionando os registros ³
	//³ desejados. Veja a fun‡„o de filtragem.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIndex1 := CriaTrab(nil,.f.)
	dbSelectArea("SE1")
	dbSetOrder(3) // Ordem por natureza
	cChave  := IndexKey()
	IndRegua("SE1",cIndex1,cChave,,FR720ChecF(),STR0008)  //"Selecionando Registros..."
	nIndex := RetIndex("SE1")
	dbSelectArea("SE1")
	#IFNDEF TOP
		dbSetIndex(cIndex1+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona o arquivo SE2 - Contas a pagar, selecionando os registros ³
	//³ desejados. Veja a fun‡„o de filtragem.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIndex2 := CriaTrab(nil,.f.)
	dbSelectArea("SE2")
	dbSetOrder(2) // Ordem por natureza
	cChave  := IndexKey()
	IndRegua("SE2",cIndex2,cChave,,FR721ChecF(),STR0008)  //"Selecionando Registros..."
	nIndex := RetIndex("SE2")
	dbSelectArea("SE2")
	#IFNDEF TOP
		dbSetIndex(cIndex2+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Varre o arquivo de naturezas localizando os titulos selecionados  ³
	//³ pelo ¡ndice condicional.                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SED")
	dbSetOrder(1)
	nTregs := 	SED->(Reccount()) + SE1->(Reccount()) + SE2->(Reccount()) + ;
	SE5->(Reccount())
	
	If lRelato
		SetRegua(nTregs)
	Else
		ProcRegua(nTregs)
	Endif
	
	If !Empty(mv_par01) .or. !Empty(mv_par03)
		dbSeek( xFilial("SED") + Iif(mv_par01 < mv_par03,mv_par01,mv_par03) ,.t. )
	Else
		dbSeek(xFilial("SED"))
	Endif
	
	While !Eof() .and. SED->ED_FILIAL==xFilial("SED") .and. SED->ED_CODIGO <= IIf(mv_par02 > mv_par04,mv_par02,mv_par04)
		
		If lRelato
			IncRegua()
		Else
			IncProc()
		Endif
		
		IF SED->ED_CODIGO >= mv_par01 .and. SED->ED_CODIGO <= mv_par02
			cTIPO := "R"
		ElseIF SED->ED_CODIGO >= mv_par03 .and. SED->ED_CODIGO <= mv_par04
			cTIPO := "P"
		Else
			dbSelectArea("SED")
			dbSkip()
			Loop
		Endif
		
		dbSelectArea( "cArqTmp" )
		If ! cArqTmp->(MsSeek(SED->ED_CODIGO))
			RecLock("cArqTmp",.T.)
			cArqTmp->NATUR := SED->ED_CODIGO
			cArqTmp->DESCR := SED->ED_DESCRIC
			cArqTmp->DIVIS := SED->ED_GRUPO
			cArqTmp->TIPO  := cTipo
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Analiza as entradas daquela natureza ³
		//³ A Realizar !!!                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If SED->ED_CODIGO >= mv_par01 .and. SED->ED_CODIGO <= mv_par02
			dbSelectArea("SE1")
			dbSeek(xFilial("SE1")+SED->ED_CODIGO)
			While !Eof() .and. SE1->E1_FILIAL==xFilial("SE1") .and. SE1->E1_NATUREZA==SED->ED_CODIGO .and. cArqTmp->TIPO == "R"
				
				If lRelato
					IncRegua()
				Else
					IncProc()
				Endif
				
				// T¡tulos provis¢rios e IR ficam de fora
				If SE1->E1_TIPO $ MVABATIM+"/"+MVRECANT+"/"+MV_CRNEG
					dbSkip()
					Loop
				Endif
				
				If SE1->E1_TIPO $ MVPROVIS .and. mv_par10 == 2
					dbSkip()
					Loop
				Endif
				
				If mv_par09 == 2
					If SE1->E1_MOEDA <> mv_par06
						SE1->(DbSkip())
						Loop
					EndIf
				EndIf
				
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se estiver utilizando multiplas naturezas, verifica o codigo da natureza³
				//³do arquivo de multiplas naturezas (SEV)                                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				*/
				If SE1->E1_MULTNAT == "1"
					If !PesqNatSev("SE1","E1", MV_PAR01, MV_PAR02)
						SE1->(DbSkip())
						Loop
					Endif
				Endif
				
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se estiver utilizando multiplas naturezas, verifica o arquivo de multiplas³
				//³naturezas (SEV) e inclui diversos registros no temporario                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				*/
				aSaldoTit := SdoTitNat(	SE1->E1_PREFIXO	,;
				SE1->E1_NUM			,;
				SE1->E1_PARCELA	,;
				SE1->E1_TIPO		,;
				SE1->E1_CLIENTE	,;
				SE1->E1_LOJA  		,	,;
				"R"					,;
				"SE1"					,;
				MV_PAR06				,;
				.F.	)
				
				
				lNoMes:= (SE1->E1_VENCREA >= FirstDay(mv_par08)) .and. ;
				(SE1->E1_VENCREA <= LastDay(mv_par08))
				
				For nLaco := 1 To Len( aSaldoTit )
					If ! cArqTmp->(MsSeek(aSaldoTit[nLaco][1]))
						RecLock("cArqTmp",.T.)
						cArqTmp->NATUR := aSaldoTit[nLaco][1]
						nRecSed := SED->(Recno())
						SED->(MsSeek(xFilial("SED")+cArqTmp->NATUR))
						cArqTmp->DESCR := SED->ED_DESCRIC
						cArqTmp->DIVIS := SED->ED_GRUPO
						cArqTmp->TIPO  := "R"
						SED->(MsGoto(nRecSed))
					Else
						RecLock("cArqTmp",.F.)
					Endif
					cArqTmp->aEacm += aSaldoTit[nLaco][2]	// Atualiza acumulado a realizar
					IF lNoMes
						cArqTmp->aEntr += aSaldoTit[nLaco][2]	// Atualiza a Realizar no mes
					Endif
					GrvResu(aSaldoTit[nLaco][2],'AEACM')
				Next
				dbSelectArea("SE1")
				dbSkip()
			End
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Analiza as Saidas daquela natureza ³
		//³ A Realizar !!!                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SED->ED_CODIGO >= mv_par03 .and. SED->ED_CODIGO <= mv_par04
			dbSelectArea("SE2")
			dbSetOrder(2)
			dbSeek(xFilial("SE2")+SED->ED_CODIGO)
			While !Eof() .and. SE2->E2_FILIAL==xFilial("SE2") .and. SE2->E2_NATUREZA==SED->ED_CODIGO .and. cArqTmp->TIPO == "P"
				
				If lRelato
					IncRegua()
				Else
					IncProc()
				Endif
				
				// T¡tulos provis¢rios ficam de fora
				If SE2->E2_TIPO $ MVABATIM+"/"+MVPAGANT+"/"+MV_CPNEG
					dbSkip()
					Loop
				Endif
				
				If left(SE2->E2_TIPO,2) $ MVPROVIS .and. mv_par10 == 2
					dbSkip()
					Loop
				Endif
				
				If mv_par09 == 2
					If SE2->E2_MOEDA <> mv_par06
						SE2->(DbSkip())
						Loop
					EndIf
				EndIf
				
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se estiver utilizando multiplas naturezas, verifica o codigo da natureza³
				//³do arquivo de multiplas naturezas (SEV)                                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				*/
				If SE2->E2_MULTNAT == "1"
					If !PesqNatSev("SE2","E2", MV_PAR03, MV_PAR04)
						SE2->(DbSkip())
						Loop
					Endif
				Endif
				
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se estiver utilizando multiplas naturezas, verifica o arquivo de multiplas³
				//³naturezas (SEV) e inclui diversos registros no temporario                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				*/
				aSaldoTit := SdoTitNat(	SE2->E2_PREFIXO	,;
				SE2->E2_NUM			,;
				SE2->E2_PARCELA	,;
				SE2->E2_TIPO		,;
				SE2->E2_FORNECE	,;
				SE2->E2_LOJA  		,	,;
				"P"					,;
				"SE2"					,;
				MV_PAR06				,;
				.F.	)
				
				lNoMes:= (SE2->E2_VENCREA >= FirstDay(mv_par08)) .and. ;
				(SE2->E2_VENCREA <= LastDay(mv_par08))
				
				For nLaco := 1 To Len( aSaldoTit )
					If ! cArqTmp->(MsSeek(aSaldoTit[nLaco][1]))
						RecLock("cArqTmp",.T.)
						cArqTmp->NATUR := aSaldoTit[nLaco][1]
						nRecSed := SED->(Recno())
						SED->(MsSeek(xFilial("SED")+cArqTmp->NATUR))
						cArqTmp->DESCR := SED->ED_DESCRIC
						cArqTmp->DIVIS := SED->ED_GRUPO
						cArqTmp->TIPO  := "P"
						SED->(MsGoto(nRecSed))
					Else
						RecLock("cArqTmp",.F.)
					Endif
					cArqTmp->aSacm += aSaldoTit[nLaco][2]	// Atualiza acumulado a realizar
					IF lNoMes
						cArqTmp->aSaid += aSaldoTit[nLaco][2]	// Atualiza a Realizar no mes
					Endif
					GrvResu(aSaldoTit[nLaco][2],'ASACM')
				Next
				dbSelectArea("SE2")
				dbSkip()
			End
		Endif
		
		dbSelectArea("SED")
		dbSkip()
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura os arquivos de contas a receber / pagar para auxiliar ³
	//³ an lise do se5 caso seja escolhido regime de caixa             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SE1")
	Set Filter To
	RetIndex("SE2")
	Set Filter To
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Analisa Realizado no Mˆs em Ep¡grafe ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona o arquivo SE5 - Movimenta‡„o banc ria, para verificar     ³
	//³ o realizado.                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIndex3 := CriaTrab(nil,.f.)
	dbSelectArea("SE5")
	dbSetOrder(4) // Ordem por natureza
	cChave  := IndexKey()
	IndRegua("SE5",cIndex3,cChave,,FR722ChecF(),STR0008)  //"Selecionando Registros..."
	nIndex := RetIndex("SE5")
	dbSelectArea("SE5")
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			nTregs:= SE5->(Reccount())
			If lRelato
				SetRegua(nTregs)
			Else
				ProcRegua(nTregs)
			Endif
		Endif
	#ELSE
		dbSetIndex(cIndex3+OrdBagExt())
	#ENDIF
	
	dbSetOrder(nIndex+1)
	dbGoTop()
	DbSeek(xFilial("SE5"))
	
	aTotais[1] := 0	// Total a Realizar no MEs (Receber)
	aTotais[2] := 0	// Total a Realizar no Mes (Pagar)
	
	aTotais[3] := 0	// Total Realizado no Mes (Receber)
	aTotais[4] := 0	// Total Realizado no Mes (Pagar)
	
	aTotais[5] := 0	// Total Or‡ado no Mes (Receber)
	aTotais[6] := 0	// Total Or‡ado no Mes (Pagar)
	
	aTotais[7] := 0	// Total a Realizar Acumulado (Receber)
	aTotais[8] := 0	// Total a Realizar Acumulado (Receber)
	
	aTotais[9] := 0	// Total Realizado Acumulado (Receber)
	aTotais[10] := 0	// Total Realizado Acumulado (Pagar)
	
	aTotais[11] := 0	// Total Or‡ado Acumulado (Receber)
	aTotais[12] := 0	// Total Or‡ado Acumulado (Pagar)
	nDescto 	:= 0
	nRecFin		:= 0
	
	While SE5->(!Eof()) .and. SE5->E5_FILIAL==xFilial("SE5")
		IF SE5->E5_MOEDA='TT'
		X:=1
		ENDIF
		If lRelato
			IncRegua()
		Else
			IncProc()
		Endif
		
		If cPaisLoc	# "BRA"
			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
			nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe estorno para esta baixa                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .and. (SE5->E5_MOEDA='TT' .and. !empty(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)))
			SE5->(dbSkip())
			Loop
		EndIf
		
		IF SE5->E5_MOTBX $ "DES*DAC" .and. SE5->E5_SITUACA <>'C' .and. se5->e5_recpag = 'R' // Soma Valor do desconto
			nDescto += se5->e5_valor
		endif
		if SE5->E5_SITUACA<>"C" .and. SE5->E5_TIPODOC$"MT*JR"
			nRecFin += SE5->E5_VALOR
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta‡”es especiais ou canceladas n„o aparecem no relat¢rio  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF SE5->E5_TIPODOC $ "DCüJRüMTüCM/D2/J2/M2/C2/TL/CP/BL/EC" .or. SE5->E5_SITUACA $ "C/X/E"
			SE5->(dbSkip())
			Loop
		EndIF
		
		If SE5->E5_TIPODOC == "CH"
			dbSelectArea("SEF")
			dbSetOrder(1)
			If dbSeek(xFilial("SEF")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ))
				If SEF->EF_ORIGEM != "FINA390AVU"
					dbSelectArea("SE5")
					SE5->(dbSkip())
					Loop
				Endif
			Endif
		Endif
		
		If !Empty(SE5->E5_MOTBX)
			If !MovBcoBx(SE5->E5_MOTBX) .or. SE5->E5_MOTBX="FAT"
				SE5->(dbSkip())
				LOOP
			EndIf
		End
		
		If mv_par09 == 2
			If nMoedaBco <> mv_par06
				SE5->(DbSkip())
				Loop
			EndIf
		EndIf
		
		lNoMes :=.T.
		//	dVencto:=SE5->E5_DATA // Regime de Caixa
		dVencto:=SE5->E5_DTDISPO // Regime de Caixa
		
		lRet := .T.
		If mv_par05 == 2
			If !Empty(SE5->E5_NUMERO) // Regime de competˆncia
				If SE5->E5_RECPAG == "R"
					If SE1->(dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
						dVencto:=SE1->E1_EMIS1
						If SE1->E1_EMIS1 < if(mv_par07==2,FirstDay(dDataBase),ctod("01/01/"+str(year(dDataBase),4))) .OR. ;
							SE1->E1_EMIS1 > LastDay(dDatabase)
							lRet := .F.
						Endif
					Endif
				Else
					If SE2->(dbSeek(xFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR))
						dVencto:=SE2->E2_EMIS1
						If SE2->E2_EMIS1 < if(mv_par07==2,FirstDay(dDataBase),ctod("01/01/"+str(year(dDataBase),4))) .OR. ;
							SE2->E2_EMIS1 > LastDay(dDatabase)
							lRet := .F.
						Endif
					Endif
				Endif
			Else
				lRet := .F.
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Checa se Movimento est  dentro do mes          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lNoMes:= (dVencto >= FirstDay(mv_par08)) .and. ;
		(dVencto <= LastDay(mv_par08))
		
		If lRet
			If SED->(dbSeek(xFilial("SED")+SE5->E5_NATUREZ)) .And.;
				((SE5->E5_NATUREZ >= mv_par01 .And. SE5->E5_NATUREZ <= mv_par02) .Or.;
				(SE5->E5_NATUREZ >= mv_par03 .And. SE5->E5_NATUREZ <= mv_par04))
				If !cArqTmp->(dbSeek(SE5->E5_NATUREZ))
					RecLock("cArqTmp",.T.)
					cArqTmp->NATUR := SE5->E5_NATUREZ
					cArqTmp->DESCR := SED->ED_DESCRIC
					cArqTmp->DIVIS := iif(left(SE5->E5_NATUREZ,9)=="DESP BANC","F",SED->ED_GRUPO)
				Endif
				
				RecLock("cArqTmp")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza Realizados no MES                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//			nValor := Round(NoRound(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DATA,nDecs+1),nDecs+1),nDecs+1)
				nValor := Round(NoRound(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par06,SE5->E5_DTDISPO,nDecs+1),nDecs+1),nDecs+1)
				If SE5->E5_NATUREZ >= mv_par03 .and. SE5->E5_NATUREZ<= mv_par04 .AND. SE5->E5_RECPAG=="R"
					nValor := nValor *(-1)
				Else
					nValor *= If( SE5->E5_TIPODOC = "TE", -1,1)
				Endif
				
				If left(dtos(se5->e5_dtdispo),6)==left(dtos(mv_par08),6) .and. left(se5->e5_naturez,9)=="DESP BANC"
					cArqTmp->rSaid += nValor
					GrvResu(nValor,'RSAID',se5->(recno()))
				Endif
				
				bProp := { || 1 }
				bWhile := { || nWhiles++ <= 1 }
				lTemSev := .F.
				
				If SEV->(MsSeek(xFilial("SEV")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
					bProp := { || SEV->EV_PERC }
					bWhile := { ||	SEV->(!Eof()) .And.;
					xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) == ;
					SEV->EV_FILIAL + SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) }
					lTemSev := .T.
				Endif
				While Eval(bWhile)
					nProp := Eval(bProp)
					If lTemSev
						// Se foi distrubuido por multiplas naturezas, o percentual sera menor que 1
						If !cArqTmp->(dbSeek(SEV->EV_NATUREZ))
							RecLock("cArqTmp",.T.)
							cArqTmp->NATUR := SEV->EV_NATUREZ
							SED->(MsSeek(xFilial("SED")+cArqTmp->NATUR))
							cArqTmp->DESCR := SED->ED_DESCRIC
							cArqTmp->DIVIS := SED->ED_GRUPO
						Else
							RecLock("cArqTmp")
						Endif
					Endif
					
					IF lNoMes  .and. left(se5->e5_naturez,9)#"DESP BANC" .and. (se5->e5_tipo+se5->e5_moeda<>space(5))
						If cArqTmp->NATUR >= mv_par01 .and. cArqTmp->NATUR	<= mv_par02
							cArqTmp->rEntr += (nValor * nProp)
							GrvResu(nValor * nProp,'RENTR')
						Else
							cArqTmp->rSaid += (nValor * nProp)
							GrvResu(nValor * nProp,'RSAID',se5->(recno()))
						Endif
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Realizados Acumulados                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if mv_par07 == 1
						If cArqTmp->NATUR >= mv_par01 .and. cArqTmp->NATUR	<= mv_par02
							cArqTmp->REACM += (nValor * nProp)
							GrvResu(nValor * nProp,'REACM')
						Else
							cArqTmp->RSACM += (nValor * nProp)
							GrvResu(nValor * nProp,'RSACM')
						Endif
					Endif
					
					If cPaisLoc = "BRA" .or. Empty(cArqTmp->Tipo)
						cArqTmp-> Tipo := SE5->E5_RECPAG
					EndIf
					
					If lTemSev
						SEV->(DbSkip())
					Endif
					
				End
			Endif
		Endif
		nWhiles:=1
		dbSelectArea("SE5")
		dbSkip()
	End
	
	If ! lRelato
		cArqTmp->( DbGoTop() )
		If aNiveis <> Nil
			nLimite := IIf(Len(aNiveis) > 1, Len(aNiveis)-1, 1)
		Endif
	Endif
	
	While ! lRelato .And. !cArqTmp->( Eof() )
		
		nOrcado := 0
		nOrcAcm := 0
		
		If SE7->(dbSeek(xFilial("SE7")+cArqTmp->NATUR+Str(Year(mv_par08),4)))
			nOrcado:=GetOrcado(month(mv_par08))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Acumula or‡ados no Mes                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( cArqTmp-> Tipo == "R")
				aTotais[5] += nOrcado		// Acumula or‡ado no Mes (Receber)
			Else
				aTotais[6] += nOrcado		// Acumula or‡ado no Mes (Pagar)
			End
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Se calcula acumulados, Acumula or‡ados no Ano  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par07 == 1
				For nLaco2:=1 to month(mv_par08)
					nOrcAcm += GetOrcado(nLaco2)
				Next
				If ( cArqTmp-> Tipo == "R")
					aTotais[11] += nOrcAcm	// Acumula or‡ado no Ano (Receber)
				Else
					aTotais[12] += nOrcAcm	// Acumula or‡ado no Acno (Pagar)
				End
			Endif
		Endif
		
		If ( cArqTmp-> Tipo == "R" )
			*** Atualiza Totais RECEBER
			aTotais[1]  += cArqTmp->aEntr+cArqTmp->aSaid	// A Realizar
			aTotais[3]  += cArqTmp->rEntr+cArqTmp->rSaid	// Realizado
			aTotais[7]  += cArqTmp->aEacm+cArqTmp->aSacm	// A Realizar Acumulado
			aTotais[9]  += cArqTmp->rEacm+cArqTmp->rSacm	// Realizado Acumulado
		Else
			*** Atualiza Totais PAGAR
			aTotais[2]  += cArqTmp->aEntr+cArqTmp->aSaid	// A Realizar
			aTotais[4]  += cArqTmp->rEntr+cArqTmp->rSaid	// Realizado
			aTotais[8]  += cArqTmp->aEacm+cArqTmp->aSacm	// A Realizar Acumulado
			aTotais[10] += cArqTmp->rEacm+cArqTmp->rSacm	// Realizado Acumulado
		End
		
		If aQuebras <> Nil
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Inicia a matriz acumuladora de quebras  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nLaco := 1 to Len( aQuebras )
				aQuebras[nLaco,1] := Subst( cArqTmp->Natur,aNiveis[nLaco,1],aNiveis[nLaco,2] )
			Next
			//		EndFor
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Acumula os parciais  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nLaco := 1 to Len(aQuebras)
				****** Parciais no Mes
				aQuebras[nLaco,2] += cArqTmp->aEntr+cArqTmp->aSaid
				aQuebras[nLaco,3] += cArqTmp->rEntr+cArqTmp->rSaid
				aQuebras[nLaco,4] += nOrcado
				****** Parciais Acumulados
				If mv_par07 == 1
					aQuebras[nLaco,5] += cArqTmp->AEACM+cArqTmp->ASACM
					aQuebras[nLaco,6] += cArqTmp->REACM+cArqTmp->RSACM
					aQuebras[nLaco,7] += nOrcAcm
				Endif
			Next
			//		EndFor
			
		Endif
		
		cArqTmp->(DbSkip())
		
		If aQuebras <> Nil
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Verifica se houve quebra em algum n¡vel ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lQuebra := .F.
			For nLaco := 1 to nLimite
				If aQuebras[nLaco,1] # Subst( cArqTmp->NATUR, aNiveis[nLaco,1], aNiveis[nLaco,2] )
					*** Inicia as quebras de baixo para cima at‚ o ponto da quebra
					For nQuebras := nLimite to nLaco Step -1
						If 	aQuebras[nQuebras,2] == 0 .and. aQuebras[nQuebras,3] == 0 .and. ;
							aQuebras[nQuebras,4] == 0 .and. aQuebras[nQuebras,5] == 0 .and. ;
							aQuebras[nQuebras,6] == 0 .and. aQuebras[nQuebras,7] == 0
							Loop
						Endif
						
						Aadd(aArrayQ, Aclone(aQuebras[nQuebras]))
						aArrayQ[Len(aArrayQ)][1] := STR0009+ aQuebras[nQuebras,1]
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³  Zera as quebras do n¡vel.               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aQuebras[nQuebras,2] := 0
						aQuebras[nQuebras,3] := 0
						aQuebras[nQuebras,4] := 0
						aQuebras[nQuebras,5] := 0
						aQuebras[nQuebras,6] := 0
						aQuebras[nQuebras,7] := 0
					Next//EndFor
				Endif
			Next
		Endif
	End
	
	If ! lRelato
		If mv_par07 = 1
			Aadd(aArray, { STR0011, STR0031, STR0032, STR0012, STR0031, STR0032, STR0013, STR0031, STR0032 }) //"Mes"###"Acumulado"###"Mes"###"Acumulado"###"Mes"###"Acumulado"
		Else
			Aadd(aArray, { STR0011, "", STR0012, "", STR0013, "" })
		Endif
		
		aTotal := DevCred( aTotais[1], aTotais[2] )
		aAcumu := DevCred( aTotais[7], aTotais[8] )
		
		If mv_par07 = 1
			Aadd(aArray, { 	StrTran(STR0014, ":", ""), Transform( aTotais[1], "@E 9,999,999,999.99" ),;	//"A Realizar  : "
			Transform( aTotais[7], "@E 9,999,999,999.99" ),;
			StrTran(STR0014, ":", ""), Transform( aTotais[2], "@E 9,999,999,999.99" ),;	//"A Realizar  : "
			Transform( aTotais[8], "@E 9,999,999,999.99" ),;
			StrTran(STR0014, ":", ""), Transform( aTotal[1], "@E 9,999,999,999.99" ) + ; //"A Realizar  : "
			aTotal[2],;
			Transform( aAcumu[1], "@E 9,999,999,999.99" ) + aAcumu[2] })
		Else
			Aadd(aArray, { 	StrTran(STR0014, ":", ""), Transform( aTotais[1], "@E 9,999,999,999.99" ),;	//"A Realizar  : "
			StrTran(STR0014, ":", ""), Transform( aTotais[2], "@E 9,999,999,999.99" ),;	//"A Realizar  : "
			StrTran(STR0014, ":", ""), Transform( aTotal[1] , "@E 9,999,999,999.99" ) +; 	//"A Realizar  : "
			aTotal[2] })
		Endif
		
		aTotal := DevCred( aTotais[3], aTotais[4] )
		aAcumu := DevCred( aTotais[9], aTotais[10] )
		
		If mv_par07 = 1
			Aadd(aArray, { 	StrTran(STR0015, ":", ""),  Transform( aTotais[3], "@E 9,999,999,999.99" ),;	//"Realizado   : "
			Transform( aTotais[9], "@E 9,999,999,999.99" ),;
			StrTran(STR0015, ":", ""),  Transform( aTotais[4], "@E 9,999,999,999.99" ),; //"Realizado   : "
			Transform( aTotais[10], "@E 9,999,999,999.99" ),;
			StrTran(STR0015, ":", ""),  Transform( aTotal[1], "@E 9,999,999,999.99" ) +;//"Realizado   : "
			aTotal[2], Transform( aAcumu[1], "@E 9,999,999,999.99" ) +;
			aAcumu[2] })
		Else
			Aadd(aArray, { 	StrTran(STR0015, ":", ""),  Transform( aTotais[3], "@E 9,999,999,999.99" ),;	//"Realizado   : "
			StrTran(STR0015, ":", ""),  Transform( aTotais[4], "@E 9,999,999,999.99" ),; //"Realizado   : "
			StrTran(STR0015, ":", ""),  Transform( aTotal[1], "@E 9,999,999,999.99" ) +;//"Realizado   : "
			aTotal[2] })
		Endif
		
		nTotReceb := aTotais[1] + aTotais[3]
		nTotPagar := aTotais[2] + aTotais[4]
		
		nAcuReceb := aTotais[7] + aTotais[9]
		nAcuPagar := aTotais[8] + aTotais[10]
		
		aTotal := DevCred( nTotReceb, nTotPagar )
		aAcumu := DevCred( nAcuReceb, nAcuPagar )
		
		If mv_par07 = 1
			Aadd(aArray, { 	StrTran(STR0016, ":", ""),  Transform( nTotReceb, "@E 9,999,999,999.99" ),;	//"Total       : "
			Transform( nAcuReceb, "@E 9,999,999,999.99" ),;
			StrTran(STR0016, ":", ""),  Transform( nTotPagar, "@E 9,999,999,999.99" ),;	//"Total       : "
			Transform( nAcuPagar, "@E 9,999,999,999.99" ),;
			StrTran(STR0016, ":", ""),  Transform( aTotal[1],"@E 9,999,999,999.99") +;	//"Total       : "
			aTotal[2], Transform( aAcumu[1],"@E 9,999,999,999.99") +;
			aAcumu[2] } )
		Else
			Aadd(aArray, { 	StrTran(STR0016, ":", ""),  Transform( nTotReceb, "@E 9,999,999,999.99" ),;	//"Total       : "
			StrTran(STR0016, ":", ""),  Transform( nTotPagar, "@E 9,999,999,999.99" ),;	//"Total       : "
			StrTran(STR0016, ":", ""),  Transform( aTotal[1],"@E 9,999,999,999.99")+;	//"Total       : "
			aTotal[2] })
		Endif
		
		aTotal := DevCred( aTotais[5], aTotais[6] )
		aAcumu := DevCred( aTotais[11], aTotais[12] )
		If mv_par07 = 1
			Aadd(aArray, { 	StrTran(STR0029, ":", ""),  Transform( aTotais[5], "@E 9,999,999,999.99"),;	//"Orcado      : "
			Transform( aTotais[11], "@E 9,999,999,999.99"),;
			StrTran(STR0029, ":", ""),  Transform( aTotais[6], "@E 9,999,999,999.99"),; 	//"Orcado      : "
			Transform( aTotais[12], "@E 9,999,999,999.99"),;
			StrTran(STR0029, ":", ""),  Transform( aTotal[1],"@E 9,999,999,999.99") +;  	//"Orcado      : "
			aTotal[2], Transform( aAcumu[1],"@E 9,999,999,999.99") +;
			aAcumu[2] })
		Else
			Aadd(aArray, { 	StrTran(STR0029, ":", ""),  Transform( aTotais[5], "@E 9,999,999,999.99"),;	//"Orcado      : "
			StrTran(STR0029, ":", ""),  Transform( aTotais[6], "@E 9,999,999,999.99"),; 	//"Orcado      : "
			StrTran(STR0029, ":", ""),  Transform( aTotal[1],"@E 9,999,999,999.99")+;  	//"Orcado      : "
			aTotal[2] })
		Endif
	Endif
	
	Return { aTotais, aArrayQ, aArray }
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³ Fun‡…o    ³ frAnImp  ³ Autor ³ Luiz Eduardo          ³ Data ³ 28/08/08 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Descri‡…o ³ Or‡ados x Reais                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Sintaxe   ³ fr720Imp(lEnd,wnRel,cString)                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso       ³ SIGAFIN                                                    ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros ³ lEnd    - A‡Æo do Codeblock                                ³±±
	±±³           ³ wnRel   - T¡tulo do relat¢rio                              ³±±
	±±³           ³ cString - Mensagem                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Arquivos  ³ SA6 ( cadastro de bancos )                                 ³±±
	±±³           ³ SE5 ( movimenta‡„o banc ria )                              ³±±
	±±³           ³ SED ( cadastro de naturezas )                              ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	Static Function frAnImp(lEnd,wnRel,cString)
	
	LOCAL cabec1		:= "Cod Natureza    Descricao    A Realizar            Realizado         Orcado          %"
	LOCAL cabec2		:= ""
	LOCAL tamanho		:= "G"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona o arquivo SE2 - Contas a pagar, selecionando os registros ³
	//³ desejados. Veja a fun‡„o de filtragem.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cIndex2 := CriaTrab(nil,.f.)
	dbSelectArea("SE2")
	dbSetOrder(2) // Ordem por natureza
	cChave  := IndexKey()
	IndRegua("SE2",cIndex2,cChave,,FR721ChecF(),STR0008)  //"Selecionando Registros..."
//	nIndex := RetIndex("SE2")
	dbSelectArea("SE2")
//	dbSetIndex(cIndex2+OrdBagExt())
//	dbSetOrder(nIndex+1)
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona o arquivo SE5 - Movimenta‡„o banc ria, para verificar     ³
	//³ o realizado.                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIndex3 := CriaTrab(nil,.f.)
	dbSelectArea("SE5")
	dbSetOrder(4) // Ordem por natureza
	cChave  := IndexKey()
	IndRegua("SE5",cIndex3,cChave,,FR722ChecF(),STR0008)  //"Selecionando Registros..."
//	nIndex := RetIndex("SE5")
	dbSelectArea("SE5")
//	dbSetIndex(cIndex3+OrdBagExt())
//	dbSetOrder(nIndex+1)
	dbGoTop()
	DbSeek(xFilial("SE5"))
	SetRegua(Reccount())
	li := 80
	nTotOrc := nTotReal := nTotAReal := ntotVal := 0
	Do while !eof()
		IncRegua()
		if !(E5_MOTBX$"NOR*DEB*GER" .or. E5_MOEDA$"TF*TT*TG") .or. E5_SITUACA=="C" .or. E5_TIPODOC=="MT"
			if !(E5_MOTBX=="CMP" .and. E5_TIPODOC<>"CP") .or. E5_MOTBX="FAT" .or. SE5->E5_TIPODOC = "EC"
				Skip
				Loop
			endif
		endif
		Select SED
		dbSetOrder(1)
		Seek xFilial()+SE5->E5_NATUREZ
		if SED->ED_GRUPO<mv_par12 .or. 	SED->ED_GRUPO > mv_par13 .or. SED->ED_GRUPO ="Z1"
			Select SE5
			skip
			loop
		endif
		Select SE5
		tValor := 0
		Do while !eof() .and. SE5->E5_NATUREZ==SED->ED_CODIGO
			if !(E5_MOTBX$"NOR*DEB*GER" .or. E5_MOEDA$"TF*TT*TG") .or. E5_SITUACA=="C" .or. E5_TIPODOC=="MT"
				if !(E5_MOTBX=="CMP" .and. E5_TIPODOC<>"CP") .or. E5_MOTBX="FAT" .or. SE5->E5_TIPODOC = "EC"
					Skip
					Loop
				endif
			endif
			If Li > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			Endif
			nValor := SE5->E5_VALOR
			if E5_RECPAG=="R"
				nValor := SE5->E5_VALOR*(-1)
			endif
			@li, 0  Psay left(Mascnat(SE5->E5_NATUREZ),10)
			@li,12  Psay SED->ED_GRUPO picture "@!"
			@li,16  Psay SED->ED_DESCRIC
			@li,48  Psay SE5->E5_BENEF
			@li,80  Psay SE5->E5_HISTOR
			@li,120 Psay nValor Picture "@E 9,999,999.99"
			tValor += nValor
			ntotVal+= nValor
			li++
			Skip
		Enddo
		Select SE2
		Seek xfilial()+SED->ED_CODIGO
		Do while !eof() .and. SE2->E2_NATUREZ==SED->ED_CODIGO
			If Li > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
			Endif
			@li, 0  Psay left(Mascnat(SED->ED_CODIGO),10)
			@li,12  Psay SED->ED_GRUPO picture "@!"
			@li,16  Psay SED->ED_DESCRIC
			@li,48  Psay SE2->E2_nomfor
			@li,80  Psay SE2->E2_HIST
			@li,120 Psay SE2->E2_SALDO Picture "@E 9,999,999.99"
			@li,133 Psay "R"
			tValor += SE2->E2_SALDO
			ntotVal+= SE2->E2_SALDO
			li++
			Skip
		Enddo
		Select SE5
		li++
		@ li, 0  PSay "Total da Natureza "+SED->ED_CODIGO
		@ li,120 Psay tValor Picture "@E 9,999,999.99"
		li++
		li++
	Enddo
	@ li, 0  PSay "Total do Relatorio"
	@ li,120 Psay nTotVal Picture "@E 9,999,999.99"
	li++
	
	Roda(0,"","P")
	Set Filter To
	If aReturn[5] == 1
		Set Printer To
		Commit
		ourspool(wnrel) //Chamada do Spool de Impressao
	Endif
	MS_FLUSH() //Libera fila de relatorios em spool
	Return
	
	*************************
	Static Function GeraBal()
	*************************
	
	//nDespA  := nDespC  := nDespF  := nDespG  := nDespP  := 0
	
	cArq := "\gerencia\BAL"+substr(dtos(mv_par08),3,4)+".dbf"
	cArq1:= "\gerencia\FIN"+substr(dtos(mv_par08),3,4)+"F.dbf"
	
	Select SE5
	dbSetOrder(1)
	seek xFilial()+left(dtos(MV_PAR08),6)
	nRecFin  := 0
	nDescto  := 0
	//Do while !eof() .and. left(dtos(E5_DATA),6)=left(dtos(MV_PAR08),6)
	Do while !eof() .and. left(dtos(E5_DTDISPO),6)=left(dtos(MV_PAR08),6)
		if E5_SITUACA<>"C" .and. E5_TIPODOC$"MT*JR"
			nRecFin += E5_VALOR
		endif
		if E5_RECPAG='R' .and. E5_MOTBX$"DES*DAC"
			nDescto += E5_VALOR
		endif
		skip
	Enddo
	
	if !file(cArq)
		//	cArq2 := "\gerencia\BAL.tmp"
		cArq2 := "BAL.tmp"
		dbUseArea( .T.,,cArq2,"TRBBAL", Nil, .F. )
		copy structure to &cArq
		use
		//	MsgBox ("Executar primeiramente o calclulo de margens do dia 01 ao ult dia do mes desejado","Informa‡Æo","INFO")
		//	return
	endif
	if !file(cArq1)
		//	cArq2 := "\gerencia\BAL.tmp"
		cArq2 := "BAL.tmp"
		dbUseArea( .T.,,cArq2,"TRBBAL", Nil, .F. )
		copy structure to &cArq1
		use
	endif
	dbUseArea( .T.,,cArq,"TRBBAL", Nil, .F. )
	dbgotop()
	nResult := 0
	nValFat := 0
	Do while !eof()
		if trim(descric)="AMOSTRA"
			nDespAm := VALOR
		endif
		if trim(descric)="(=) FATURA.S/IPI e S/ST"
			nValFat := VALOR
		endif
		skip
	enddo
	dbgotop()
	nMgReal1 := nMgReal2 := nMgReal3 := 0
	Do while !eof()
		
		//	replace VALOR	with //" - DESPESAS FIXAS"
		//	replace VALOR	with //" - SALARIOS + ENCARGOS (compet)"
		do case
			case trim(DESCRIC) = " = MARGEM REAL"
				nMGReal1 := Valor
				nMGReal2 := ValAtu
				nMGReal3 := ValSim
			case trim(DESCRIC) = " - DESP.GERENCIAIS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespG
				replace VALATU	with nDespG
				replace VALSIM	with nDespG
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.ADMINISTRATIVAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespA
				replace VALATU	with nDespA
				replace VALSIM	with nDespA
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.FINANCEIRAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespF
				replace VALATU	with nDespF
				replace VALSIM	with nDespF
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.COMERCIAIS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespC
				replace VALATU	with nDespC
				replace VALSIM	with nDespC
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " - DESP.PRODUCAO"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespP
				replace VALATU	with nDespP
				replace VALSIM	with nDespP
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = " = RESULTADO OPERACIONAL"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nMgReal1 - nDespA - nDespC - nDespF - nDespG - nDespP
				replace VALATU	with nMgReal2 - nDespA - nDespC - nDespF - nDespG - nDespP
				replace VALSIM	with nMgReal3 - nDespA - nDespC - nDespF - nDespG - nDespP
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
				nResult1 := VALOR
				nResult2 := VALATU
				nResult3 := VALSIM
			case trim(DESCRIC) = "(-)OUTRAS SAIDAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespIm + nDespOu + nDespJr + nDespIp + nDespAm + nDescto - nRecFin
				replace VALATU	with nDespIm + nDespOu + nDespJr + nDespIp + nDespAm + nDescto - nRecFin
				replace VALSIM	with nDespIm + nDespOu + nDespJr + nDespIp + nDespAm + nDescto - nRecFin
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
				nOutras := VALOR
			case trim(DESCRIC) = "IMOBILIZACOES"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespIm
				replace VALATU	with nDespIm
				replace VALSIM	with nDespIm
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "OUTROS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespOu
				replace VALATU	with nDespOu
				replace VALSIM	with nDespOu
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "JUROS PAGOS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespJr
				replace VALATU	with nDespJr
				replace VALSIM	with nDespJr
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "PARCEL IMPOSTOS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDespIp
				replace VALATU	with nDespIp
				replace VALSIM	with nDespIp
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "DESC.CONCEDIDOS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nDescto
				replace VALATU	with nDescto
				replace VALSIM	with nDescto
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "(+) RECEITAS FINANCEIRAS"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nRecFin
				replace VALATU	with nRecFin
				replace VALSIM	with nRecFin
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
			case trim(DESCRIC) = "RESULTADO FINAL"
				RecLock("TRBBAL",.f.)
				replace VALOR	with nResult1 - nOutras
				replace VALATU	with nResult2 - nOutras
				replace VALSIM	with nResult3 - nOutras
				replace PERCVAL	with VALOR/nValFat*100
				replace PERCATU	with VALATU/nValFat*100
				replace PERCSIM	with VALSIM/nValFat*100
		EndCase
		MsUnLock()
		RecLock("TRBBAL",.f.)
		//	replace VALOR	with //" - PREMIOS DE COMISSOES "
		//	replace VALATU	with
		//	replace VALSIM	with
		skip
	Enddo
	copy to &cArq1
	use
	
	********************************
	Static Function GrvResu(nVlResu,cNat,nRecno)
	********************************
	if nVlResu=0
		Return
	endif
	
	Select RESU
	RecLock("RESU",.t.)
	Resu->Natur	:= cArqTmp->Natur
	Resu->Titulo:= cArqTmp->Titulo
	Resu->Forn	:= cArqTmp->Forn
	Resu->Nome	:= cArqTmp->Nome
	Resu->Benef	:= cArqTmp->Benef
	Resu->Hist	:= cArqTmp->Hist
	Resu->Divis	:= cArqTmp->DIVIS
	Resu->Valor	:= nVlResu
	Resu->Tipo	:= cArqTmp->TIPO
	Resu->TpNat	:= cNat
	Resu->NRECNO:= nRecno
	MsUnLock()
