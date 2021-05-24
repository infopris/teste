#include "rwmake.ch"         

User Function MATR48B()        
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis utilizadas no programa atraves da funcao    Ё
//Ё SetPrvt, que criara somente as variaveis definidas pelo usuario,    Ё
//Ё identificando as variaveis publicas do sistema utilizadas no codigo Ё
//Ё Incluido pelo assistente de conversao do AP5 IDE                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetPrvt("_ACA,_NOPCAO,_LSHARED,_LREADONLY,AORDEM,CALIAS")
SetPrvt("CARQUIVO,CDESC1,CDESC2,CDESC3,CDESC4,CDESTINATARIO")
SetPrvt("CFILTRO,CFORMULARIO,NOMEPROG,CPERG,WNREL,CTAMANHO")
SetPrvt("CTITULO,C_CABEC1,C_CABEC2,LDICIONARIO,LCOMPRESSAO,NCARACTER")
SetPrvt("NFORMATO,NLASTKEY,NMIDIA,NORDEM,NPORTA,NVIAS")
SetPrvt("M_PAG,ARETURN,WLN,C_MSGREG,C_SAVREG1,C_SAVREG2")
SetPrvt("N_CNTREG1,N_CNTREG2,N_CNTREG3,C_SAVSCR1,N_SAVCUR1,N_SAVROW1")
SetPrvt("N_SAVCOL1,C_SAVCOR1,N_AREA,N_IND,N_REC,_ACAMPOS")
SetPrvt("_CNOME,REG,_NLIN,XQTDE,XCUSTO1,XCUSTO2")
SetPrvt("CGRU,NQTDE,NCUSTO1,NCUSTO2,C_COLOR,")

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё MATR48A  Ё Autor Ё Luiz Eduardo Tapajos  Ё Data Ё 03.08.00 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Este Relatorio Lista os produtos em poder de 3os pos se┤ao Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁArquivos  Ё SB1 , SB6                                                  Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                            Define Variaveis                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                            Variaveis Padrao                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aOrdem        := {"Secao","Cliente"}
cAlias        := "SB6"
cArquivo      := ""
cDesc1        := "Relacao de Produtos em poder de terceiros - por secao"
cDesc2        := ""
cDesc3        := ""
cDesc4        := ""
cDestinatario := "ESTOQUE"
cFiltro       := ""
cFormulario   := ""
nomeprog      := "MATR48B"
cPerg         := "MTR48B"
wnRel         := "MATR48B"
cTamanho      := "G"		// P=80, M=132, G=220
cTitulo       := "Relacao de Produtos em poder de terceiros"
c_Cabec1      := "Grupo    Codigo              Descricao do Produto               Cliente                  Docto     Emissao   Quantidade        Custo R$      Validade     TES"
c_Cabec2      := ""
lDicionario   := .F.
lCompressao   := .T.
nTipo     := 15	// Caracter de Compressao
nFormato      := 1	// 1-Comprimido 2-Normal
nLastKey      := 0	// Ultima tecla pressionada - para checar se saiu com <ESC>
nMidia        := 2   // 1-Disco      2-Impressora
nOrdem        := 1	// Ordem default
nPorta        := 1   // 1-LPT1 ... 4-COM1...
nVias         := 1
m_pag         := 0

aReturn  := {cFormulario, nVias, cDestinatario, nFormato, nMidia, nPorta, cFiltro, nOrdem}


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                         Variaveis do Cabecalho                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cArquivo := SetPrint(cAlias,nomeprog,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.F.,cTamanho)

IF  nLastKey == 27
   Set Filter To
   Return
Endif

aReturn[7] := "B6_FILIAL == '"+xFilial("SB6")+"'"
SetDefault(aReturn,cAlias)
IF  nLastKey == 27
        Set Filter to
		Return
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                         Variaveis do Relatorio                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

m_pag     := 1
wln       := 999  // Contador do numero de linhas

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                         Variaveis da Regua                                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды



//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                            Salva a Integridade                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


n_Area    := Alias()
n_Ind     := IndexOrd()
n_Rec     := Recno()
nLastKey  := 0

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as Perguntas Selecionadas no SX1                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicializa os parametros                                                  Ё
//цддддддддддбдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//Ё Pergunta Ё Uso                                                            Ё
//цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
//Ё mv_par01 Ё Secao de                                                       Ё
//Ё mv_par02 Ё Secao At┌                                                      Ё
//Ё mv_par03 Ё Pula pag apos impressao da secao ?                             Ё
//Ё mv_par04 Ё Emissao ate ?                                                  Ё
//юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Pergunte(cPerg,.F.)

Processa( {|| gera() },"Criando Arquivo Temporario" )
RptStatus({||   imprimir() })
 

Return
   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Pre-processamento do Relatorio                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
STATIC FUNCTION  gera


_aCampos := {  {"GRUPO","C",6,0 } ,; 
               {"COD","C",15,0 } ,;
               {"DESC","C",30,0 },;
               {"NOMCLI","C",20,0 },;
               {"DOC","C",6,0 },;
               {"EMISSAO","D",8,0 },;
               {"VALIDAD","D",8,0 },;
               {"QTDE","N",10,2 },;
               {"CUSTO1","N",12,2 },;
               {"CUSTO2","N",12,2 },;
               {"TES","C",3,0 },;
               {"OFERTA","C",11,0 }}

_cNome := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"TRB",.F.,.F.)

dbSelectArea("SB6")
dbSetOrder(1)
dbgotop()
nregs := RECCOUNT() 
Procregua(nregs)
 
While !EOF()
       IncProc()
      if B6_TES<'5' .or. B6_SALDO==0 .or. deleted() .or. B6_EMISSAO>mv_par04
	  dbskip()
	 loop
      endif
      dbSelectArea("SB1")
      dbSetOrder(1)
      dbSeek(xFilial()+SB6->B6_PRODUTO)
      if SB1->B1_GRUPO < mv_par01 .or.  SB1->B1_GRUPO > mv_par02
          dbSelectArea("SB6")
          dbskip()
	  Loop
      Endif
      dbSelectArea("SA1")
      dbSetOrder(1)
      dbSeek(xFilial()+SB6->B6_CLIFOR+SB6->B6_LOJA)
      dbSelectArea("SD2")
      dbSetOrder(3)
      dbSeek(xFilial()+SB6->B6_DOC)
      dbSelectArea("SC5")
      dbSetOrder(1)
      dbSeek(xFilial()+SD2->D2_PEDIDO)
      dbSelectArea("TRB")
         Reclock("TRB",.T.)
        TRB->GRUPO  := SB1->B1_GRUPO
        TRB->DESC   := SB1->B1_DESC 
        TRB->COD    := SB6->B6_PRODUTO
        TRB->NOMCLI := SA1->A1_NREDUZ
        TRB->DOC    := SB6->B6_DOC
        TRB->EMISSAO:= SB6->B6_EMISSAO
        TRB->VALIDAD:= SB6->B6_VALIDAD 
        TRB->QTDE   := SB6->B6_SALDO
        TRB->CUSTO1 := SB6->B6_CUSTO1
        TRB->TES    := SB6->B6_TES
        MsUnlock()
      dbSelectArea("SB6")
      dbskip()
Enddo
dbSelectArea("TRB")
return

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia a Impressao do Relatorio                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

If  nLastKey == 27
   Return
EndIf



 

STATIC FUNCTION imprimir 

do case
case aReturn[8] == 2
   Index on Nomcli to tmp
   dbgotop()
   _nLin := 80
   xQtde := xCusto1 := xCusto2 := 0
   nregs := reccount()
   SetRegua(nregs)
   do while !eof()
      incRegua()
     IF _nLin > 56
       Cabec(cTitulo,c_Cabec1,c_Cabec2,nomeprog,cTamanho,nTipo) 
       _nLin := 8
     End
     cGru := TRB->GRUPO
     nQtde := nCusto1 := nCusto2 := 0
    
     @ _nLin , 01 PSAY TRB->GRUPO
     @ _nLin , 10 PSAY Cod
     @ _nLin , 30 PSAY Desc
     @ _nLin , 65 PSAY NomCli
     @ _nLin , 90 PSAY Doc
     @ _nLin ,100 PSAY Emissao
     @ _nLin ,110 PSAY Qtde picture '999,999.99'
     @ _nLin ,125 PSAY Custo1 picture '9999,999.99'
     @ _nLin ,140 PSAY Validad
     @ _nLin ,155 PSAY Tes
     nQtde   := nQtde   + Qtde
     nCusto1 := nCusto1 + Custo1
     nCusto2 := nCusto2 + Custo2
     xQtde   := xQtde   + Qtde
     xCusto1 := xCusto1 + Custo1
     _nLin := _nLin + 1
    dbSkip()
  Enddo
  @ _nLin , 10 PSAY 'Total Geral  .................... '
  @ _nLin ,110 PSAY xQtde picture '999,999.99'
  @ _nLin ,125 PSAY xCusto1 picture '9999,999.99'

   SET DEVI TO SCREEN
   dbSelectArea("TRB")
   dbCloseArea()
   dbSelectArea("SB6")

case aReturn[8] == 1
   Index on Grupo + Cod to tmp
  DBGOTOP()
nregs := reccount()
   SetRegua(nregs)


_nLin := 80
xQtde := xCusto1 := xCusto2 := 0
do while !eof()
   incRegua()
  IF _nLin > 56
    Cabec(cTitulo,c_Cabec1,c_Cabec2,nomeprog,cTamanho,nTipo) 
    _nLin := 8
  Endif
  cGru := TRB->GRUPO
  nQtde := nCusto1 := nCusto2 := 0
  do while GRUPO == cGru .and. !eof()
    IF _nLin > 56
      Cabec(cTitulo,c_Cabec1,c_Cabec2,nomeprog,cTamanho,nTipo) 
      _nLin := 8
    End

    @ _nLin , 01 PSAY TRB->GRUPO
    @ _nLin , 10 PSAY Cod
    @ _nLin , 30 PSAY Desc
    @ _nLin , 65 PSAY NomCli
    @ _nLin , 90 PSAY Doc
    @ _nLin ,100 PSAY Emissao
    @ _nLin ,110 PSAY Qtde picture '999,999.99'
    @ _nLin ,125 PSAY Custo1 picture '9999,999.99'
    @ _nLin ,140 PSAY Validad
    @ _nLin ,155 PSAY Tes
    nQtde   := nQtde   + Qtde
    nCusto1 := nCusto1 + Custo1
    xQtde   := xQtde   + Qtde
    xCusto1 := xCusto1 + Custo1
    _nLin := _nLin + 1
    dbSkip()
  enddo
  _nLin := _nLin + 1
  @ _nLin , 10 PSAY 'Total da secao .................. '
  @ _nLin ,110 PSAY nQtde picture '999,999.99'
  @ _nLin ,125 PSAY nCusto1 picture '9999,999.99'
  _nLin := _nLin + 1
  @ _nLin,01 PSAY replicate("-",220)
  _nLin := _nLin + 1
  IF mv_par03 == 1 .and. !eof()
    Cabec(cTitulo,c_Cabec1,c_Cabec2,nomeprog,cTamanho,nTipo) 
    _nLin := 8
  Endif

enddo
@ _nLin , 10 PSAY 'Total Geral  .................... '
@ _nLin ,110 PSAY xQtde picture '999,999.99'
@ _nLin ,125 PSAY xCusto1 picture '9999,999.99'

SET DEVI TO SCREEN

dbSelectArea("TRB")
dbCloseArea()
dbSelectArea("SB6")
ENDCASE
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Possibilita a visualizacao do relatorio se foi gerado em disco            Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
IF aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(cArquivo)
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Libera relatorio para o Spool da rede                                     Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FT_PFLUSH()

return