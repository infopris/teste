#include "rwmake.ch"       

User Function CRVEN()        // Contas a Receber por Vendedor

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
SetPrvt("NREG,NVALOR,CNUM,CPARC,CVENCTO,CVEND")
SetPrvt("DEMISSAO,CCLIENTE,CLOJA,CTIPO,CNAT,CNOMCLI")
SetPrvt("_NLIN,TOTX90,TOTX60,TOTX30,TOTX00,TOTV30")
SetPrvt("TOTV60,TOTV90,VALX90,VALX60,VALX30,VALX00")
SetPrvt("VALV30,VALV60,VALV90,TOTLIN,TOTGER,TOTVAL")
SetPrvt("C_COLOR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CRVEN    ³ Autor ³ Luiz Eduardo Tapajos  ³ Data ³ 08.01.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este Relatorio demonstra os Titulos Vencidos e A Vencer    ³±±
±±³          ³ por Vend., (30,60,90 Dias) Sintetico                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void POSGRU(Void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SE1 , SD2 , SA1 , SX5                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Espelhos Leao                                              ³±±
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
cPergunta     := "CRVEN"
cPrograma     := "CRVEN"
cTamanho      := "P"		// P=80, M=132, G=220
cTitulo       := "POSICAO DE TITULOS A RECEBER por Vendedor"
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
c_Cabec2  := " Grupo   | + de 90   | + de  60   | + de 30    | ate 30 dias |  Vencidos   |    30     |    60     |    90     |   a Vencer | Total"
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
//³ mv_par03 ³ Vend. Inicial                                                  ³
//³ mv_par04 ³ Vend. Final                                                    ³
//³ mv_par05 ³ Sintetico/Analitico                                            ³
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

_aCampos := {  {"VEND","C",6,0 } ,; 
               {"VALOR","N",12,2 } ,;
               {"VENCTO","D",8,0 },;
               {"QTDDIA","C",3,0 },;
               {"DOC","C",9,0 },;
               {"PARCELA","C",1,0 },;
               {"CLIENTE","C",6,0 },;
               {"LOJA","C",2,0 },;
               {"NOMCLI","C",20,0 },;
               {"TIPO","C",3,0 },;
               {"EMISSAO","D",8,0 },;
               {"NATUREZA","C",9,0 }}

_cNome := CriaTrab(_aCampos,.t.)

dbUseArea(.T.,, _cNome,"TRB",.F.,.F.)


dbSelectArea("SE1")
dbgotop()
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
      if  SE1->E1_VEND1 < MV_PAR03 .Or. SE1->E1_VEND1 > MV_PAR04 
	  dbskip()
	  loop
      endif
      if se1->e1_TIPO=='NCC'
          dbskip()
          loop
      endif
      if se1->e1_STATUS=='B' .AND. SE1->E1_SALDO==0
          dbskip()
          loop
      endif
      if LEFT(se1->e1_tipo,2)=='RA' 
          dbskip()
          loop
      endif
      cQtddia := " "
      do case
      case SE1->E1_VENCREA <= ddatabase-60
         cQtddia := "X60"
      case SE1->E1_VENCREA <= ddatabase-30 .and. SE1->E1_VENCREA < ddatabase-60
         cQtddia := "X30"
      case SE1->E1_VENCREA <= ddatabase .and. SE1->E1_VENCREA < ddatabase-30
         cQtddia := "X00"
      case SE1->E1_VENCREA <= ddatabase+30 .and. SE1->E1_VENCREA < ddatabase
         cQtddia := "V30"
      case SE1->E1_VENCREA <= ddatabase+60 .and. SE1->E1_VENCREA < ddatabase+30
         cQtddia := "V60"
      Endcase
 
      nValor  := SE1->E1_SALDO
      cNum    := SE1->E1_PREFIXO+SE1->E1_NUM
      cParc   := SE1->E1_PARCELA
      cVencto := SE1->E1_VENCREA
      cVend   := SE1->E1_VEND1
      dEmissao:= SE1->E1_Emissao
      cCliente:= SE1->E1_CLIENTE
      cLoja   := SE1->E1_LOJA
      cTipo   := SE1->E1_TIPO
      cNat    := SE1->E1_NATUREZA
      cNomCli := SE1->E1_NOMCLI
     
      dbSelectArea("SC5")     && Abertura dos arquivo de itens da NF
      dbSetOrder(1)
      dbSeek(xFilial()+SE1->E1_PEDIDO)
//      IF SC5->C5_VEND1#SPACE(6)
//        cVend := SC5->C5_VEND1
//      ENDIF
      dbSelectArea("TRB")
      Reclock("TRB",.T.)
       
      replace Vend  with cVend,VALOR WITH SE1->E1_SALDO,;
	             VENCTO with cVencto, DOC WITH cNum, PARCELA with cParc,CLIENTE with cCliente,;
		     loja with cLoja,tipo with cTipo,Natureza with cNat,emissao with dEmissao,;
		     nomcli with cNomCli
      MSUNLOCK()
      dbSelectArea("SE1") 
      dbskip()
Enddo
return
* Inicio da Impressao
STATIC FUNCTION IMPRIMIR
 
dbSelectArea("TRB")
setRegua(reccount())

index on Vend + CLIENTE to XTEMP1

_nLin := 80
totger := 0
if mv_par05==2
c_Cabec2  := "CLIENTE                             TITULO       EMISSAO    VENCTO    SALDO EM ABERTO"
else
//c_Cabec2  := "VENDEDOR                VENCIDOS         VENCER        TOTAL "
c_cabec1    := "                               V   E  N  C  I  D  O  S           Total     |           V  E  N  C  E  R   Total  |               "
c_cabec2    := "VENDEDOR                   +de 60         +de 30     ate 30     Vencidos   |   ate 30      + de 30       Vencer  |   Total Aberto"
            //123456789012345678901234567890123456789012345678901234567890
            //         1         2         3         4         5    
Endif
cTamanho := "M"
nTVencer := nTVencido := 0
tvencid60 := tvencid30 := tvencid := tvence  := tvencer30 := tvencer60 := 0
do while !eof()
  incRegua()
  if mv_par05==2    
    _nLin := 80
  Endif
  cVend := Vend
  dbSelectArea("SA3")
  dbSETORDER(1)
  dbSeek(xFilial()+TRB->VEND)
  dbSelectArea("TRB")
  IF _nLin > 56
    if mv_par05==2
    c_Cabec1  := "Posicao de Cobranca do Vendedor "+sa3->a3_nreduz
    else
//  c_Cabec1  := "Posicao de Cobranca do Vendedor "
    endif
    Cabec(cTitulo,c_Cabec1,c_Cabec2,cPrograma,cTamanho,nCaracter) 
    _nLin := 9
  Endif
  Set Century On
  totval := nVencer := nVencido :=0
  dbSelectArea("TRB")
  nvencid60 := nvencid30 := nvencid := nvence := nvencer30 := nvencer60 := 0
  do while Vend == cVend .AND. !EOF()
    dbSelectArea("SA1")
    dbSETORDER(1)
    dbSeek(xFilial()+TRB->CLIENTE)
    dbSelectArea("TRB")
    IF _nLin > 56
      cVend := Vend
      if mv_par05==2
        c_Cabec1  := "Posicao de Cobranca do Vend. "+cVend+" "+sa3->a3_nreduz
      Endif
      Cabec(cTitulo,c_Cabec1,c_Cabec2,cPrograma,cTamanho,nCaracter) 
      _nLin := 9
    Endif
    set cent off
    if mv_par05==2    
      @ _nLin , 01 PSAY cliente + " - " + sa1->a1_nreduz
      @ _nLin , 35 PSAY left(doc,3) + " " + substr(doc,4,6) + " " + parcela
      @ _nLin , 48 PSAY emissao
      @ _nLin , 58 PSAY vencto
      @ _nLin , 68 PSAY valor PICTURE '99999,999.99'
      _nLin := _nLin + 1
    Endif
    set cent on
    totval := totval + valor
    do case
    case Vencto <= ddatabase-60
      nvencid60 := nvencid60 + valor
      tvencid60 := tvencid60 + valor
    case Vencto <= ddatabase-30 .and. Vencto > ddatabase-60
      nvencid30 := nvencid30 + valor
      tvencid30 := tvencid30 + valor
    case Vencto <= ddatabase .and. Vencto > ddatabase-30
      nvencid   := nvencid   + valor
      tvencid   := tvencid   + valor
    case Vencto <= ddatabase+30 .and. Vencto > ddatabase
      nvence    := nvence    + valor
      tvence    := tvence    + valor
    case Vencto <= ddatabase+60 .and. Vencto > ddatabase+30
      nvencer30 := nvencer30 + valor
      tvencer30 := tvencer30 + valor
    case Vencto > ddatabase+60 
      nvencer60 := nvencer60 + valor
      tvencer60 := tvencer60 + valor
    Endcase
    If vencto > dDatabase
      nvencer := nvencer + valor
    endif
    if vencto <= dDatabase
      nvencido := nvencido + valor
    endif
    dbSelectArea("TRB")
    dbSkip()
  enddo
  if mv_par05==2    
    @ _nLin,01 PSAY replicate("-",80)
    _nLin := _nLin + 1
    @ _nLin , 001  PSAY "A vencer -"
    @ _nLin , 012  PSAY nVencer picture "99,999,999.99"
    @ _nLin , 030  PSAY "Vencidos -"
    @ _nLin , 042  PSAY nVencido picture "99,999,999.99"
    @ _nLin , 057  PSAY "Total  -"
    @ _nLin , 066 PSAY totval PICTURE '99,999,999.99'
  else
    _nLin := _nLin + 1
    @ _nLin,00 PSAY cVend+"-"+sa3->a3_nreduz
//  @ _nLin , 020  PSAY nVencido picture "99999,999.99"
//  @ _nLin , 036  PSAY nVencer  picture "99999,999.99"
//  @ _nLin , 050  PSAY totval PICTURE '99999,999.99'
    @ _nLin , 024  PSAY nVencid60 picture "@E 99999,999.99"
    @ _nLin , 037  PSAY nVencid30 picture "@E 99999,999.99"
    @ _nLin , 050  PSAY nVencid   picture "@E 99999,999.99"
    @ _nLin , 063  PSAY nVencid+nVencid30+nVencid60 picture "@E 99999,999.99"
    @ _nLin , 076  PSAY nVence    picture "@E 99999,999.99"
    @ _nLin , 089  PSAY nVencer30+nVencer60 picture "@E 99999,999.99"
    @ _nLin , 102  PSAY nVence+nVencer30+nVencer60 picture "@E 99999,999.99"
    @ _nLin , 115  PSAY totval    picture "@E 99999,999.99"
  Endif
  totger    := totger + totval
  nTVencer  := nTVencer +nVencer
  nTVencido := nTVencido+nVencido
enddo
if mv_par05==2    
_nLin := _nLin + 1
@ _nLin,01 PSAY replicate("-",80)
_nLin := _nLin + 1
@ _nLin ,066 PSAY totger PICTURE '99,999,999.99'
else
_nLin := _nLin + 1
@ _nLin,01 PSAY replicate("-",132)
_nLin := _nLin + 1
//@ _nLin , 020  PSAY nTVencido picture "99,999,999.99"
//@ _nLin , 036  PSAY nTVencer  picture "99,999,999.99"
//@ _nLin , 050 PSAY totger PICTURE '99,999,999.99'
@ _nLin , 024  PSAY tVencid60 picture "@E 99999,999.99"
@ _nLin , 037  PSAY tVencid30 picture "@E 99999,999.99"
@ _nLin , 050  PSAY tVencid   picture "@E 99999,999.99"
@ _nLin , 063  PSAY tVencid+tVencid30+tVencid60 picture "@E 99999,999.99"
@ _nLin , 076  PSAY tVence    picture "@E 99999,999.99"
@ _nLin , 089  PSAY tVencer30+tVencer60 picture "@E 99999,999.99"
@ _nLin , 102  PSAY tVence+tVencer30+tVencer60 picture "@E 99999,999.99"
@ _nLin , 115  PSAY  totger   PICTURE "@E 99999,999.99"
Endif
@ _nLin+1,1  PSAY ""

dbSelectArea("TRB")  
*Copy to TESLUI

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

RETURN