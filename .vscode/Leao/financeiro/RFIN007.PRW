#include "rwmake.ch" 
#IfNDEF WINDOWS
        #DEFINE PSAY SAY
#Endif

User Function RFin007() 

SetPrvt("CAREA,CDESC1,CDESC2,CDESC3,WNREL,CSTRING")
SetPrvt("CCABECALHO,CPERG,CRELATORIO,CTITULO,NNAT,LI")
SetPrvt("M_PAG,ARETURN,NLASTKEY,CINDICE,CMOEDA,CQUEBRA")
SetPrvt("AORDEM,NTAMANHO,LEND,CBANCOFINAL,CBANCOINICIAL,CNATFINAL")
SetPrvt("CNATINICIAL,CNUMFINAL,CNUMINICIAL,DDATAFINAL,DDATAINICIAL,NMOEDA")
SetPrvt("NNIVEL,NOPERACAO,ACHAVE,ACAMPOS,ATAM,ANUMERARIO")
SetPrvt("BTEXTO,CANTERIOR,CLINHA,COPERACAO,CTRABALHO,LPRIMEIRO")
SetPrvt("NGERALPAGO,NGERALRECEBIDO,NLOCALIZA,NORDEM,NTOTALPAGO,NTOTALRECEBIDO")
SetPrvt("NVALOR,CMVMOEDA,MV_MOEDA,CNATUREZA,CDESCRICAO,CBANCO")
SetPrvt("LFIRST,NLINHAS,CTEXTO,NTOTREC,CTAMANHO,CARQUIVO")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ RFIN007  ³ Autor ³ Luiz Eduardo          ³ Data ³ 12/11/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Or‡ado X Realizado (Anual)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³ RFIN007()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGAFIN - Espelhos Leao                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos  ³ SA6 ( Cadastro de Bancos )                                 ³±±
±±³           ³ SE5 ( Movimenta‡„o Banc ria )                              ³±±
±±³           ³ SED ( Cadastro de Naturezas )                              ³±±
±±³           ³ SE7 ( Cadastro de Or‡amentos)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Rdmake 5.08   ³Autor ³ Luiz Eduardo        ³ Data ³     12/11/2003     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArea      := ""
cDesc1     := ""
cDesc2     := ""
cDesc3     := ""

wnrel      := ""
cString    := "SE5"

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabecalho := ""
cPerg      := ""
cRelatorio := ""
cTitulo    := ""
nNat := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis utilizadas para impressao do cabe‡alho e rodap‚ ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Li     := 0
m_Pag  := 1

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis utilizadas pela fun‡„o SetDefault () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis p£blicas utilizadas em macro-substitui‡„o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndice := ""
cMoeda  := ""
cQuebra := ""

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ VerIfica os par„metros selecionados e en- ³
// ³ via o controle para a fun‡„o SetPrint ()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aOrdem     := {"Por Natureza","Por Numerario","Por Banco","Por Data"}  
aOrdem     := {}
cArea      := "SE5"
cDesc1     := "Relacao das Despesas e ou Recebimentos Ordenados pela Natureza       -"
cDesc2     := "Podera ser Impresso Analitico ou Sintetico. Titulos Pagos e/Ou Recebi-"
cDesc3     := "dos. Impressao Conforme Parametros Selecionados - USO Espelhos Leao.  "
cPerg      := "RFIN07"
cRelatorio := "RFIN007"
cTitulo    := "Orcado X Realizado"
nTamanho   := "G"
lEnd       := .F.

Pergunte (cPerg,.T.)
nTamanho   := "G"
cRelatorio := SetPrint(cArea,cRelatorio,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,NIL,nTamanho)

If nLastKey == 27
   Return
Endif

SetDefault ( aReturn, cArea )

If nLastKey == 27
   Return
Endif

#IfDEF WINDOWS
       RptStatus({|| Fa120Imp()},cTitulo)// Substituido pelo assistente de conversao do AP5 IDE em 27/02/02 ==>        RptStatus({|| Execute(Fa120Imp)},cTitulo)
#Else
       Fa120Imp()
#Endif
Return

****** Inicio do Relatorio *********

Static Function FA120Imp()

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBancoFinal    := ""
cBancoInicial  := ""
cNatFinal      := ""
cNatInicial    := ""
cNumFinal      := ""
cNumInicial    := ""
dDataFinal     := CTOD(SPACE(08))
dDataInicial   := CTOD(SPACE(08))
nMoeda         := 0
nNivel         := 0
nOperacao      := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Vari veis de controle ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aChave         := {}
aCampos        := {}
aTam           := {}
aNumerario     := {}
bTexto         := { || NIL }
cAnterior      := ""
cLinha         := ""

cOperacao      := ""
cTrabalho      := ""
lPrimeiro      := .T.
nGeralPago     := 0
nGeralRecebido := 0
nLocaliza      := 0
nOrdem         := 0
nTotalPago     := 0
nTotalRecebido := 0
nValor         := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Ano                                                         ³
// ³ mv_par02 => Numer rio final                                             ³
// ³ mv_par03 => Data inicial                                                ³
// ³ mv_par04 => Data final                                                  ³
// ³ mv_par05 => Banco inicial                                               ³
// ³ mv_par06 => Banco final                                                 ³
// ³ mv_par07 => Natureza inicial                                            ³
// ³ mv_par08 => Natureza final                                              ³
// ³ mv_par09 => Moeda utilizada ( 1...5 )                                   ³
// ³ mv_par10 => N¡vel anal¡tico ( 1 ) ou sint‚tico ( 2 )                    ³
// ³ mv_par11 => Pagamentos ( 1 ), recebimentos ( 2 ) ou ambos ( 3 )         ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataInicial   := ctod("01/01/"+mv_par01)
dDataFinal     := ctod("31/12/"+mv_par01)
cNatInicial    := mv_par02
cNatFinal      := mv_par03
nMoeda         := 1
nNivel         := 1
nOperacao      := 3
nSal           := 0

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Ajusta as vari veis de controle ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOperacao := cOperacao + IIf ( nOperacao == 1 .or. nOperacao == 3, "P", "" )
cOperacao := cOperacao + IIf ( nOperacao == 2 .or. nOperacao == 3, "R", "" )

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabecalho := "Data       Numerario Natureza   Banco Agencia Conta      Cheque          Documento           Vencimento  Beneficiario                Historico                                 Pagamentos      Recebimentos"

cMoeda     := STR(nMoeda,1)
cMvMoeda   := "MV_MOEDA" + cMoeda
mv_moeda   := GetMv(cMvMoeda)

aCampos := {}
AADD(aCampos,{ "NAT"     , "C",10,0}) 
AADD(aCampos,{ "JAN"     , "N",12,2}) 
AADD(aCampos,{ "FEV"     , "N",12,2}) 
AADD(aCampos,{ "MAR"     , "N",12,2}) 
AADD(aCampos,{ "ABR"     , "N",12,2}) 
AADD(aCampos,{ "MAI"     , "N",12,2}) 
AADD(aCampos,{ "JUN"     , "N",12,2}) 
AADD(aCampos,{ "JUL"     , "N",12,2}) 
AADD(aCampos,{ "AGO"     , "N",12,2}) 
AADD(aCampos,{ "SET"     , "N",12,2}) 
AADD(aCampos,{ "OUT"     , "N",12,2}) 
AADD(aCampos,{ "NOV"     , "N",12,2}) 
AADD(aCampos,{ "DEZ"     , "N",12,2}) 
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on Nat to &cTemp

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m a tabela de numer rios ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSeek(xFilial() + "06")
dbEval({||AADD(aNumerario,SX5->X5_DESCRI),AADD(aChave,SX5->X5_CHAVE)},NIL,{ ||xFilial() == SX5->X5_FILIAL .and. SX5->X5_TABELA == "06"})

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Cria o arquivo de trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam := TamSX3("E5_FILIAL")
AADD(aCampos,{"TB_FILIAL"  ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_MOEDA")
AADD(aCampos,{"TB_MOEDA"   ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_DTDISPO")
AADD(aCampos,{"TB_DATA"    ,"D",aTam[1],aTam[2]})
aTam := TamSX3("E5_BANCO")
AADD(aCampos,{"TB_BANCO"   ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_AGENCIA")
AADD(aCampos,{"TB_AGENCIA" ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_CONTA")
AADD(aCampos,{"TB_CONTA"   ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_NUMCHEQ")
AADD(aCampos,{"TB_NUMCHEQ" ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_NATUREZ")
AADD(aCampos,{"TB_NATUREZ" ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_DOCUMEN")
AADD(aCampos,{"TB_DOCUMEN" ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_RECPAG")
AADD(aCampos,{"TB_RECPAG"  ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_VENCTO")
AADD(aCampos,{"TB_VENCTO"  ,"D",aTam[1],aTam[2]})
aTam := TamSX3("A2_NREDUZ")
AADD(aCampos,{"TB_BENEF"   ,"C",aTam[1],aTam[2]})
aTam := TamSX3("E5_HISTOR")
AADD(aCampos,{"TB_HISTOR"  ,"C",aTam[1],aTam[2]})
AADD(aCampos,{"TB_NUM"     ,"C",9,0 })
AADD(aCampos,{"TB_VALOR"   ,"N",17,2})
AADD(aCampos,{"TB_IMP"     ,"C",01,0})
cTrabalho := CriaTrab(aCampos)
dbUseArea(.T.,,cTrabalho,"Trabalho",.F.,.F.)
dbSelectArea("Trabalho")

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Define a ordem de impress„o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//nOrdem := aReturn [8]
nOrdem := 1
cNatureza  := Trabalho->TB_NATUREZ
cDescricao := ""
Natureza()
bTexto     := {||Trabalho->TB_NATUREZ+ " - " + POSICIONE("SED",1,xFilial("SED")+Trabalho->TB_NATUREZ,"SED->ED_DESCRIC")}
cIndice    := "TB_FILIAL+TB_NATUREZ+DTOS(TB_DATA)"
cQuebra    := "Trabalho->TB_NATUREZ"

dbSelectArea("Trabalho")
IndRegua("Trabalho",cTrabalho,cIndice,,,"Selecionando Registros...")

cTemp := CriaTrab(nil,.f.)
dbSelectArea("SE5")
dbSetOrder(1)
set softseek on
dbSeek(xFilial("SE5")+DTOS(dDataInicial),.T.)
set softseek off
SetRegua(RecCount())
While ! Eof() .AND. SE5->E5_DTDISPO <= dDataFinal
	IncRegua()
	if se5->e5_motbx$"FAT*DES"
		skip
		loop
	endif
	if mv_par04<>1
//		dbSelectArea("SED")
//		dbSetOrder(1)
//		dbSeek(xFilial("SED") + se5->e5_naturez)
		dbSelectArea("SE5")
		do Case
		Case mv_par05==1 .and. !(se5->e5_tipo=="ADM" .or. se5->e5_moeda=="TA")//sed->ed_grupo<>"A"
			skip
			loop
		Case mv_par05==2 .and. !(se5->e5_tipo=="FIN" .or. se5->e5_moeda=="TF")//sed->ed_grupo<>"F"
			skip
			loop
		Case mv_par05==3 .and. !(se5->e5_tipo=="PRO" .or. se5->e5_moeda=="TP")//sed->ed_grupo<>"P"
			skip
			loop
		Case mv_par05==4 .and. !(se5->e5_tipo=="COM" .or. se5->e5_moeda=="TC")//sed->ed_grupo<>"C"
			skip
			loop
		Case mv_par05==5 .and. !(se5->e5_tipo=="GER" .or. se5->e5_moeda=="TG")//sed->ed_grupo<>"G"
			skip
			loop
		EndCase
	endif

      #IfNDEF WINDOWS
              Inkey()
              If LastKey() == 286
                 lEnd := .T.
              Endif
      #Endif

      If lEnd
         @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
         Exit
      Endif

      If SE5->E5_TIPODOC $ "CH/DC/MT/CM/JR/CP/M2/C2/D2/J2/V2"  // valores agregados
         dbSkip()
         Loop
      Endif

      If nOrdem == 2 .AND. Empty(SE5->E5_MOEDA) // por numer rio, n„o considera em brancos
         dbSkip()
         Loop
      Endif    
      // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      // ³ N„o processa t¡tulos sem numer rio   ³
      // ³ ou que n„o satisfa‡am aos par„metros ³
      // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If  SE5->E5_DTDISPO >= dDataInicial  .AND. ;
          SE5->E5_DTDISPO <= dDataFinal    .and. ;
          SE5->E5_NATUREZ >= cNatInicial   .and. ;
          SE5->E5_NATUREZ <= cNatFinal     .and. ;
          SE5->E5_SITUACA != "C" 

          RecLock("Trabalho",.T.)
          Trabalho->TB_FILIAL  := SE5->E5_FILIAL
          Trabalho->TB_MOEDA   := SE5->E5_MOEDA
          Trabalho->TB_DATA    := SE5->E5_DTDISPO
          Trabalho->TB_BANCO   := SE5->E5_BANCO
          Trabalho->TB_AGENCIA := SE5->E5_AGENCIA
          Trabalho->TB_CONTA   := SE5->E5_CONTA
          Trabalho->TB_NUMCHEQ := SE5->E5_NUMCHEQ
          Trabalho->TB_NATUREZ := SE5->E5_NATUREZ
          Trabalho->TB_DOCUMEN := SE5->E5_DOCUMEN
          Trabalho->TB_RECPAG  := SE5->E5_RECPAG
          Trabalho->TB_VENCTO  := SE5->E5_VENCTO
          Trabalho->TB_NUM     := SE5->(E5_PREFIXO+E5_NUMERO)
      Trabalho->TB_HISTOR  := SE5->E5_HISTOR
      Trabalho->TB_VALOR   := SE5->E5_VALOR/RecMoeda(SE5->E5_DTDISPO,1)
      If SE5->E5_TIPODOC == "CH" 
	Trabalho->TB_IMP := "N"
      Else	
        Trabalho->TB_IMP := "S"	
      Endif
     Endif
     Select TRB
     seek SE5->E5_NATUREZ
     if eof() .and. rlock()
       Appe Blan
     Endif
     nValor:= SE5->E5_VALOR/RecMoeda(SE5->E5_DTDISPO,1)
     If Trabalho->TB_RECPAG == "P"
        nValor := -nValor
     Endif

     If rlock()
       trb->nat := SE5->E5_NATUREZ
       Do case
       Case month(SE5->E5_DTDISPO)==01
         trb->jan := trb->jan + nValor
       Case month(SE5->E5_DTDISPO)==02
         trb->fev := trb->fev + nValor
       Case month(SE5->E5_DTDISPO)==03
         trb->mar := trb->mar + nValor
       Case month(SE5->E5_DTDISPO)==04
         trb->abr := trb->abr + nValor
       Case month(SE5->E5_DTDISPO)==05
         trb->mai := trb->mai + nValor
       Case month(SE5->E5_DTDISPO)==06
         trb->jun := trb->jun + nValor
       Case month(SE5->E5_DTDISPO)==07
         trb->jul := trb->jul + nValor
       Case month(SE5->E5_DTDISPO)==08
         trb->ago := trb->ago + nValor
       Case month(SE5->E5_DTDISPO)==09
         trb->set := trb->set + nValor
       Case month(SE5->E5_DTDISPO)==10
         trb->out := trb->out + nValor
       Case month(SE5->E5_DTDISPO)==11
         trb->nov := trb->nov + nValor
       Case month(SE5->E5_DTDISPO)==12
         trb->dez := trb->dez + nValor
       Endcase
     Endif
     dbSelectArea("SE5")
     dbSkip()
Enddo


Retindex("SE5")

dbSelectArea("Trabalho")
dbGoTop()
ResNat()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ PulaLinha ( nLinhas )                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Incrementa  a linha atual e verIfica se h  necessidade  de ³±±
±±³           ³ salto de p gina.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par„metros³ nLinhas ú N£mero de linhas a incrementar.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 27/02/02 ==> Function PulaLinha
Static Function PulaLinha()

nLinhas := IIf (nLinhas == NIL,1,nLinhas)

li := li + nLinhas

// ÚÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Cabe‡alho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÙ
If nNivel == 2
   cTamanho := "G"
// cTamanho := "M"
*  cCabecalho := "Natureza           Jan          Fev          Mar          Abr          Mai          Jun          Jul          Ago          Set          Out          Nov          Dez          Tot        Media       Orcado    Perc        "
*                 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
   If Li > 58 .or. M_Pag == 1
     Cabec(cTitulo,cCabecalho,"",cRelatorio,cTamanho,15)
   Endif
Else
   cTamanho := "G" 
   If Li > 58 .or. M_Pag == 1
     Cabec(cTitulo,cCabecalho,"",cRelatorio,cTamanho)
   Endif
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³ Natureza ( cNatureza )                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³ Obt‚m a descri‡„o de uma natureza no arquivo SED.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Par„metros³ cNatureza ú C¢digo da natureza.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FinR120                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Natureza()

cDescricao := ""
cArquivo   := Alias()
nOrdem     := 0
dbSelectArea("SED")
nOrdem := IndexOrd( )
dbSetOrder(1)
dbSeek(xFilial("SED") + cNatureza)
If Found()
   cDescricao := SED->ED_DESCRIC
Else
   cDescricao := "NATUREZA NAO DEFINIDA ( " + cNatureza + " )"
Endif
dbSetOrder(nOrdem)
dbSelectArea(cArquivo)
Return

*-----------------------*
Static Function ResNat()
*-----------------------*

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Inicializa a barra indicativa de processamento para o arquivo Trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCabecalho := "Natureza                   Orcado        Jan          Fev          Mar          Abr          Mai          Jun          Jul          Ago          Set          Out          Nov          Dez          Tot        Media   Perc"
*              01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                        1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22

dbSelectArea("Trb")
dbGoTop()

lFirst := 1
nValFim:= nValFim1:= 0
PulaLinha()
nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
nTot7 := nTot8 := nTot9 := nTot10:= nTot11:= nTot12:= 0
dbSelectArea("SED")
dbSeek(xFilial()+nNat)
SetRegua(RecCount())
While !Eof()
      IncRegua()
      if SED->ED_CODIGO < cNatInicial .OR. SED->ED_CODIGO > cNatFinal
        Skip
        Loop
      Endif
      Select SE7
      Seek xFilial()+sed->ed_Codigo+mv_par01
      nMesAtu := month(dDataBase)
      Do case
      Case nMesAtu == 1
        nValAtu := se7->e7_valjan1
      Case nMesAtu == 2
        nValAtu := se7->e7_valfev1
      Case nMesAtu == 3
        nValAtu := se7->e7_valmar1
      Case nMesAtu == 4
        nValAtu := se7->e7_valabr1
      Case nMesAtu == 5
        nValAtu := se7->e7_valmai1
      Case nMesAtu == 6
        nValAtu := se7->e7_valjun1
      Case nMesAtu == 7
        nValAtu := se7->e7_valjul1
      Case nMesAtu == 8
        nValAtu := se7->e7_valago1
      Case nMesAtu == 9
        nValAtu := se7->e7_valset1
      Case nMesAtu == 10
        nValAtu := se7->e7_valout1
      Case nMesAtu == 11
        nValAtu := se7->e7_valnov1
      Case nMesAtu == 12
        nValAtu := se7->e7_valdez1
      Endcase
      lAchou := .t.
      if eof() 
        lAchou := .f.
      Endif
      Select TRB
      Seek sed->ed_Codigo
      if eof() .and. !lAchou
        dbSelectArea("SED")
        Skip
        loop
      Endif
      nValTot := Jan+fev+mar+abr+mai+jun+jul+ago+set+out+nov+dez
      @ Li, 000 PSAY left(sed->ed_codigo,6)+"-"+left(SED->ED_DESCRIC,14)
      @ Li, 021 PSAY nValAtu  Picture "@E 99999,999.99"
      @ Li, 033 PSAY trb->jan Picture "@E 99999,999.99"
      @ Li, 045 PSAY trb->fev Picture "@E 99999,999.99"
      @ Li, 058 PSAY trb->mar Picture "@E 99999,999.99"
      @ Li, 071 PSAY trb->abr Picture "@E 99999,999.99"
      @ Li, 084 PSAY trb->mai Picture "@E 99999,999.99"
      @ Li, 097 PSAY trb->jun Picture "@E 99999,999.99"
      @ Li, 110 PSAY trb->jul Picture "@E 99999,999.99"
      @ Li, 123 PSAY trb->ago Picture "@E 99999,999.99"
      @ Li, 136 PSAY trb->set Picture "@E 99999,999.99"
      @ Li, 149 PSAY trb->out Picture "@E 99999,999.99"
      @ Li, 162 PSAY trb->nov Picture "@E 99999,999.99"
      @ Li, 175 PSAY trb->dez Picture "@E 99999,999.99"
      @ Li, 188 PSAY nValTot  Picture "@E 99999,999.99"
      @ Li, 201 PSAY nValTot/nMesAtu Picture "@E 99999,999.99"
      @ Li, 214 PSAY (nValTot/nMesAtu)/nValAtu Picture "@E 999.999"
      nValFim := nValFim + nValAtu
      nValFim1:= nValFim1+ nValTot
	nTot1 := nTot1 + trb->Jan
	nTot2 := nTot2 + trb->Fev
	nTot3 := nTot3 + trb->Mar
	nTot4 := nTot4 + trb->Abr
	nTot5 := nTot5 + trb->Mai
	nTot6 := nTot6 + trb->Jun
	nTot7 := nTot7 + trb->Jul
	nTot8 := nTot8 + trb->Ago
	nTot9 := nTot9 + trb->Set
	nTot10:= nTot10+ trb->Out
	nTot11:= nTot11+ trb->Nov
	nTot12:= nTot12+ trb->Dez
      PulaLinha()
      dbSelectArea("SED")
      Skip
Enddo      
PulaLinha()
ntot := ntot1 +ntot2 +ntot3 +ntot4 +ntot5 +ntot6 
ntot := ntot7 +ntot8 +ntot9 +ntot10+ntot11+ntot12 + nTot
@ Li,000 PSAY "Total Geral "
@ Li, 020 PSAY nValFim  Picture "@E 999999,999.99"
@ Li, 033 PSAY nTot1    Picture "@E 99999,999.99"
@ Li, 045 PSAY nTot2    Picture "@E 99999,999.99"
@ Li, 058 PSAY nTot3    Picture "@E 99999,999.99"
@ Li, 071 PSAY nTot4    Picture "@E 99999,999.99"
@ Li, 084 PSAY nTot5    Picture "@E 99999,999.99"
@ Li, 097 PSAY nTot6    Picture "@E 99999,999.99"
@ Li, 110 PSAY nTot7    Picture "@E 99999,999.99"
@ Li, 123 PSAY nTot8    Picture "@E 99999,999.99"
@ Li, 136 PSAY nTot9    Picture "@E 99999,999.99"
@ Li, 149 PSAY nTot10   Picture "@E 99999,999.99"
@ Li, 162 PSAY nTot11   Picture "@E 99999,999.99"
@ Li, 175 PSAY nTot12   Picture "@E 99999,999.99"
@ Li, 188 PSAY nTot     Picture "@E 99999,999.99"
@ Li, 200 PSAY nValFim1 Picture "@E 999999,999.99"
//@ Li, 214 PSAY nValFim1/nValFim Picture "@E 999.999"
PulaLinha(2)
Roda(0,"","G")

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Restaura o ambiente inicial ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device to Screen
If aReturn[5] == 1
   Set Printer to
   dbCommitAll()
   OurSpool(cRelatorio)
Endif
MS_FLUSH()
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Elimina os arquivos de trabalho ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("Trabalho")
//COPY TO XTESTE1
dbCloseArea()
fErase(cTrabalho+".DBF")
fErase(cTrabalho+OrdBagExt())

dbSelectArea("TRB")
dbCloseArea()
fErase(cTemp+".DBF")
fErase(cTemp+OrdBagExt())

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Restaura as ordens dos arquivos ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea ( "SE5" )
dbSetOrder(1)

Return

