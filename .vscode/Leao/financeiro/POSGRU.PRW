#include "rwmake.ch"

User Function POSGRU()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_ACA,_NOPCAO,_LSHARED,_LREADONLY,AORDEM,CALIAS")
SetPrvt("CARQUIVO,CDESC1,CDESC2,CDESC3,CDESC4,CDESTINATARIO")
SetPrvt("CFILTRO,CFORMULARIO,CPERGUNTA,CPROGRAMA,CTAMANHO,CTITULO")
SetPrvt("CCABEC1,CCABEC2,LDICIONARIO,LCOMPRESSAO,NCARACTER,NFORMATO")
SetPrvt("NLASTKEY,NMIDIA,NORDEM,NPORTA,NVIAS,M_PAG")
SetPrvt("ARETURN,C_CABEC1,C_CABEC2,WLN,C_MSGREG,C_SAVREG1")
SetPrvt("C_SAVREG2,N_CNTREG1,N_CNTREG2,N_CNTREG3,C_SAVSCR1,N_SAVCUR1")
SetPrvt("N_SAVROW1,N_SAVCOL1,C_SAVCOR1,N_AREA,N_IND,N_REC")
SetPrvt("MV_PAR05,MV_PAR06,MV_PAR07,C_ARQ,_ACAMPOS,_CNOME")
SetPrvt("NREG,NVALOR,CNUM,CPARC,CVENCTO,CGRUPO")
SetPrvt("DEMISSAO,CCLIENTE,CLOJA,CTIPO,CNAT,CNOMCLI")
SetPrvt("_NLIN,TOTX90,TOTX60,TOTX30,TOTX00,TOTV30")
SetPrvt("TOTV60,TOTV90,VALX90,VALX60,VALX30,VALX00")
SetPrvt("VALV30,VALV60,VALV90,TOTLIN,TOTGER,TOTVAL")
SetPrvt("C_COLOR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ POSGRU   ³ Autor ³ Luiz Eduardo Tapajos  ³ Data ³ 27.02.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este Relatorio demonstra os Titulos Vencidos e A Vencer    ³±±
±±³          ³ por Se‡Æo, (30,60,90 Dias) Sintetico                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void POSGRU(Void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SE1 , SD2 , SA1 , SX5                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Schott Zeiss                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                            Define Variaveis                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                            Variaveis Padrao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrdem        := {}
cAlias        := "SE1"
cArquivo      := ""
cDesc1        := "Posi‡Æo da Cobran‡a"    // Descricao do Relatorio - Titulo
cDesc2        := "     Este Programa demonstra a Posicao Geral da Cobran‡a, por "    // Primeira linha da Descricao
cDesc3        := "Secao, Respeitando os Intervalos, (30,60,90 Dias), a Vencer e"
cDesc4        := "Vencidos. Quebra por Secao             "
cDestinatario := "FINANCEIRO"
cFiltro       := ""
cFormulario   := ""
cPergunta     := "POSGRU"
cPrograma     := "POSGRU"
cTamanho      := "G"		// P=80, M=132, G=220
cTitulo       := "POSICAO DE TITULOS A RECEBER"
cCabec1       := " "
cCabec2       := " "
lDicionario   := .F.
lCompressao   := .T.
nCaracter     := 15	// Caracter de Compressao
nFormato      := 1	// 1-Comprimido 2-Normal
nLastKey      := 0	// Ultima tecla pressionada - para checar se saiu com <ESC>
nMidia        := 2   // 1-Disco      2-Impressora
nOrdem        := 1	// Ordem default
nPorta        := 1   // 1-LPT1 ... 4-COM1...
nVias         := 1
m_pag         := 0

aReturn  := {cFormulario, nVias, cDestinatario, nFormato, nMidia, nPorta, cFiltro, nOrdem}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                         Variaveis do Cabecalho                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArquivo := SetPrint(cAlias,cPrograma,cPergunta,@cTitulo,cDesc1,cDesc2,cDesc3,.t.,aOrdem)

IF  nLastKey == 27
	Return
End

aReturn[7] := "E1_FILIAL == '"+xFilial("SE1")+"'"
SetDefault(aReturn,cAlias)
IF  nLastKey == 27
	Return
End



cTitulo   := "POSICAO DE TITULOS A RECEBER"
c_Cabec1  := "                            V E N C I D O S                                                A  V E N C E R                 "
c_Cabec2  := " Grupo   | + de 90   | + de  60   | + de 30    | ate 30 dias |   Vencidos   |    15     |    30      |    60      |    90      |   120      |   150      |    180     |    a Vencer |  Total"
//c_Cabec2  := " Grupo   | + de 90   | + de  60   | + de 30    | ate 30 dias |  Vencidos   |    30     |    60     |    90     |   a Vencer | Total"
//            123456   |9999999.99|9999999.99|9999999.99|9999999.99|9999999.99|9999999.99|9999999.99|9999999.99 "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                         Variaveis do Relatorio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

m_pag     := 1
wln       := 999  // Contador do numero de linhas






//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                            Salva a Integridade                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


n_Area    := Alias()
n_Ind     := IndexOrd()
n_Rec     := Recno()
nLastKey  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas Selecionadas no SX1                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os parametros                                                  ³
//ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Pergunta ³ Uso                                                            ³
//ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ mv_par01 ³ Vencto Inicial                                                 ³
//³ mv_par02 ³ Vencto Final                                                   ³
//³ mv_par03 ³ Secao Inicial                                                  ³
//³ mv_par04 ³ Secao Final                                                    ³
//³ mv_par05 ³ Sintetico ou Analitico                                         ³
//³ mv_par06 ³ Emissao DE                                                     ³
//³ mv_par07 ³ Emissao ATE                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPergunta,.F.)



Processa( {|| gera1() },"Criando Arq Temporario ..." )

RptStatus({||   imprimir() })

Return



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pre-processamento do Relatorio                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION GERA1

_aCampos := {  {"GRUPO"   ,"C",06,0 } ,;
{"VALOR"   ,"N",12,2 } ,;
{"VENCTO"  ,"D",08,0 },;
{"QTDDIA"  ,"C",04,0 },;
{"DOC"     ,"C",09,0 },;
{"PARCELA" ,"C",01,0 },;
{"CLIENTE" ,"C",06,0 },;
{"LOJA"    ,"C",02,0 },;
{"NOMCLI"  ,"C",20,0 },;
{"EST"     ,"C",02,0 },;
{"TIPO"    ,"C",03,0 },;
{"EMISSAO" ,"D",08,0 },;
{"NATUREZA","C",09,0 }}





_cNome := CriaTrab(_aCampos,.t.)


dbUseArea(.T.,, _cNome,"TRB",.F.,.F.)


dbSelectArea("SE1")
dbgotop()
dbSetOrder(6)
set softseek on
Seek xFilial()+dtos(mv_par06)
set softseek off
nregs := reccount()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a Impressao do Relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



procRegua(nregs)

While !EOF()
	
	incproc()
	
	if  SE1->E1_VENCREA < MV_PAR01 .Or. SE1->E1_VENCREA > MV_PAR02 ;
		.or. SE1->E1_SALDO <= 0
		dbskip()
		loop
	endif
	if  SE1->E1_EMISSAO < MV_PAR06 .Or. SE1->E1_EMISSAO > MV_PAR07 ;
		.or. SE1->E1_SALDO <= 0
		dbskip()
		loop
	endif
	if se1->e1_prefixo=='COM' .or. left(se1->e1_natureza,1)=='4'
		dbskip()
		loop
	endif
	if se1->e1_TIPO=='NCC'
		dbskip()
		loop
	endif
	if se1->e1_STATUS=='B'
		dbskip()
		loop
	endif
	if LEFT(se1->e1_PEDIDO,6)==SPACE(6)
		dbskip()
		loop
	endif
	
	nValor  := SE1->E1_SALDO
	cNum    := SE1->E1_PREFIXO+SE1->E1_NUM
	cParc   := SE1->E1_PARCELA
	cVencto := SE1->E1_VENCREA
	dEmissao:= SE1->E1_Emissao
	cCliente:= SE1->E1_CLIENTE
	cLoja   := SE1->E1_LOJA
	cTipo   := SE1->E1_TIPO
	cNat    := SE1->E1_NATUREZA
	cNomCli := SE1->E1_NOMCLI
	
	Select SA1
	seek xFilial()+cCliente+cLoja
	cEst    := SA1->A1_EST
	Select SE1
	if len(trim(MV_PAR08))>1 .and. !trim(cEst)$MV_PAR08
		dbskip()
		loop
	endif

	dbSelectArea("SC5")     && Abertura dos arquivo de itens da NF
	dbSetOrder(1)
	dbSeek(xFilial()+SE1->E1_PEDIDO)
	
	dbSelectArea("TRB")
	Reclock("TRB",.T.)
	
	replace GRUPO  with " ",VALOR WITH SE1->E1_SALDO,;
	VENCTO with cVencto, DOC WITH cNum, PARCELA with cParc,CLIENTE with cCliente,;
	loja with cLoja,tipo with cTipo,Natureza with cNat,emissao with dEmissao,;
	nomcli with cNomCli,est with cEst
	Do case
		Case cVencto < dDatabase - 90
			Replace QtdDia with "X90"
		Case cVencto < dDatabase - 60 .and. Vencto >= dDatabase - 90
			Replace QtdDia with "X60"
		Case cVencto < dDatabase - 30 .and. Vencto >= dDatabase - 60
			Replace QtdDia with "X30"
		Case cVencto < dDatabase - 00 .and. Vencto >= dDatabase - 30
			Replace QtdDia with "X00"
		Case cVencto < dDatabase + 16 .and. Vencto >= dDatabase - 00
			Replace QtdDia with "V15"
		Case cVencto < dDatabase + 31 .and. Vencto >= dDatabase - 16
			Replace QtdDia with "V30"
		Case cVencto < dDatabase + 61 .and. Vencto >= dDatabase + 31
			Replace QtdDia with "V60"
		Case cVencto < dDatabase + 91 .and. Vencto >= dDatabase + 61
			Replace QtdDia with "V90"
		Case cVencto < dDatabase +121 .and. Vencto >= dDatabase + 91
			Replace QtdDia with "V120"
		Case cVencto < dDatabase +151 .and. Vencto >= dDatabase +121
			Replace QtdDia with "V150"
		Case cVencto < dDatabase + 1500
			Replace QtdDia with "V180"
	Endcase
	MSUNLOCK()
	
	dbSelectArea("SE1")
	DBSKIP()
Enddo
return
* Inicio da Impressao
STATIC FUNCTION IMPRIMIR

dbSelectArea("TRB")
setRegua(reccount())
Do case
	Case mv_par05 == 1
		index on QTDDIA to XTEMP1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³                         Inicializacao da Regua                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		
		
		_nLin := 80
		Totx90 := totx60 := totx30 := totx00 := 0
		totv15 := totv30 := totv60 := totv90 := totv120:= totv150:= totv180:= 0
		do while !eof()
			IF _nLin > 56
				Cabec(cTitulo,c_Cabec1,c_Cabec2,cPrograma,cTamanho,nCaracter)
				_nLin := 9
			End
			incRegua()
			
			valx90 := valx60 := valx30 := valx00 := 0
			valv15 := valv30 := valv60 := Valv90 := Valv120:= Valv150:= Valv180:= 0
			
			do while !eof()
				
				do case
					case trim(qtddia) == "X90"
						valx90 := valx90 + valor
					case trim(qtddia) == "X60"
						valx60 := valx60 + valor
					case trim(qtddia) == "X30"
						valx30 := valx30 + valor
					case trim(qtddia) == "X00"
						valx00 := valx00 + valor
					case trim(qtddia) == "V15"
						valv15 := valv15 + valor
					case trim(qtddia) == "V30"
						valv30 := valv30 + valor
					case trim(qtddia) == "V60"
						valv60 := valv60 + valor
					case trim(qtddia) == "V90"
						valv90 := valv90 + valor
					case trim(qtddia) == "V120"
						valv120 := valv120 + valor
					case trim(qtddia) == "V150"
						valv150 := valv150 + valor
					case trim(qtddia) == "V180"
						valv180 := valv180 + valor
				Endcase
				dbSkip()
			enddo
			TOTLIN := valX00 + valx30 + valx60 + valx90 + valV15+ valV30 + valV60 + valV90 + valV120+ valV150+ valV180
			@ _nLin , 09 PSAY valX90 PICTURE '9999,999.99'
			@ _nLin , 22 PSAY valX60 PICTURE '9999,999.99'
			@ _nLin , 35 PSAY valX30 PICTURE '9999,999.99'
			@ _nLin , 48 PSAY valX00 PICTURE '9999,999.99'
			@ _nLin , 62 PSAY valX00 + valx30 + valx60 + valx90 PICTURE '99,999,999.99'
			@ _nLin , 76 PSAY valV15 PICTURE '9999,999.99'
			@ _nLin ,088 PSAY valV30 PICTURE '9999,999.99'
			@ _nLin ,101 PSAY valV60 PICTURE '9999,999.99'
			@ _nLin ,115 PSAY valV90 PICTURE '9999,999.99'
			@ _nLin ,129 PSAY valV120 PICTURE '9999,999.99'
			@ _nLin ,143 PSAY valV150 PICTURE '9999,999.99'
			@ _nLin ,157 PSAY valV180 PICTURE '9999,999.99'
			@ _nLin ,171 PSAY valV15+valV30 + valV60 + valV90+ valV120+ valV150+ valV180 PICTURE '99,999,999.99'
			@ _nLin ,185 PSAY TOTLIN  PICTURE '99,999,999.99'
			Totx90 := Totx90 + valx90
			totx60 := Totx60 + valx60
			totx30 := Totx30 + valx30
			totx00 := Totx00 + valx00
			totv15 := Totv15 + valv15
			totv30 := Totv30 + valv30
			totv60 := Totv60 + valv60
			totv90 := Totv90 + valv90
			totv120:= Totv120+ valv120
			totv150:= Totv150+ valv150
			totv180:= Totv180+ valv180
			_nLin := _nLin + 1
		enddo
		_nLin := _nLin + 1
		@ _nLin,01 PSAY replicate("-",220)
		_nLin := _nLin + 1
		
		TOTLIN := totX00 + totx30 + totx60 + totx90 + totV15 + totV30 + totV60 + totV90 + totV120+ totV150+ totV180
		
		@ _nLin , 09 PSAY totX90 PICTURE '9999,999.99'
		@ _nLin , 22 PSAY totX60 PICTURE '9999,999.99'
		@ _nLin , 35 PSAY totX30 PICTURE '9999,999.99'
		@ _nLin , 48 PSAY totX00 PICTURE '9999,999.99'
		@ _nLin , 62 PSAY totX00 + totx30 + totx60 + totx90 PICTURE '99,999,999.99'
		@ _nLin , 76 PSAY totV15 PICTURE '9999,999.99'
		@ _nLin ,088 PSAY totV30 PICTURE '9999,999.99'
		@ _nLin ,101 PSAY totV60 PICTURE '9999,999.99'
		@ _nLin ,115 PSAY totV90 PICTURE '9999,999.99'
		@ _nLin ,129 PSAY totV120 PICTURE '9999,999.99'
		@ _nLin ,143 PSAY totV150 PICTURE '9999,999.99'
		@ _nLin ,157 PSAY totV180 PICTURE '9999,999.99'
		@ _nLin ,171 PSAY totV30 + totV60 + totV90 + totV120+ totV150+ totV180 PICTURE '99,999,999.99'
		@ _nLin ,185 PSAY TOTLIN  PICTURE '99,999,999.99'
		@ _nLin+1,1  PSAY ""
		
	Case mv_par05 == 2
		
		index on CLIENTE to XTEMP1
		
		_nLin := 80
		totger := 0
		c_Cabec2  := "CLIENTE                             TITULO       EMISSAO    VENCTO    SALDO EM ABERTO  EST"
		cTamanho := "M"
		do while !eof()
			incRegua()
			_nLin := 80
			IF _nLin > 56
				c_Cabec1  := "Posicao de Cobranca"
				Cabec(cTitulo,c_Cabec1,c_Cabec2,cPrograma,cTamanho,nCaracter)
				_nLin := 9
			Endif
			Set Century On
			totval := nVencer := nVencido :=0
			do while !eof()
				dbSelectArea("SA1")
				dbSETORDER(1)
				dbSeek(xFilial()+TRB->CLIENTE)
				dbSelectArea("TRB")
				IF _nLin > 56
					Cabec(cTitulo,c_Cabec1,c_Cabec2,cPrograma,cTamanho,nCaracter)
					_nLin := 9
				Endif
				
				@ _nLin , 01 PSAY cliente + " - " + sa1->a1_nreduz
				@ _nLin , 35 PSAY left(doc,3) + " " + substr(doc,4,6) + " " + parcela
				@ _nLin , 48 PSAY emissao
				@ _nLin , 60 PSAY vencto
				@ _nLin , 72 PSAY valor PICTURE '99,999,999.99'
				@ _nLin , 86 PSAY est 
				totval := totval + valor
				If vencto > dDatabase
					nvencer := nvencer + valor
				endif
				if vencto <= dDatabase
					nvencido := nvencido + valor
				endif
				
				_nLin := _nLin + 1
				dbSkip()
			enddo
			@ _nLin,01 PSAY replicate("-",80)
			_nLin := _nLin + 1
			@ _nLin , 001  PSAY "A vencer -"
			@ _nLin , 012  PSAY nVencer picture "99,999,999.99"
			@ _nLin , 030  PSAY "Vencidos -"
			@ _nLin , 042  PSAY nVencido picture "99,999,999.99"
			@ _nLin , 057  PSAY "Total  -"
			@ _nLin , 066 PSAY totval PICTURE '99,999,999.99'
			totger := totger + totval
		enddo
		_nLin := _nLin + 1
		@ _nLin,01 PSAY replicate("-",80)
		_nLin := _nLin + 1
		@ _nLin ,066 PSAY totger PICTURE '99,999,999.99'
		@ _nLin+1,1  PSAY ""
		
		
Endcase


dbSelectArea("TRB")
Copy to "\gerencia\ctasreceb"
MsgBox ("Arquivo Gerado \gerencia\ctasreceb","Informa‡ao","INFO")

dbCloseArea()
FERASE(_cNome+".DBF")
FERASE("XTEMP1.CDX")

dbSelectArea("SE1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Possibilita a visualizacao do relatorio se foi gerado em disco            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF aReturn[5] == 1
	Set Printer To
	Commit
	OurSpool(cArquivo)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera relatorio para o Spool da rede                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_PFLUSH()

RETURN
