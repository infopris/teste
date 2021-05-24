#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/02/02
#IfNDEF WINDOWS
        #DEFINE PSAY SAY
#Endif

User Function RFin004()        // Orcado X Realizado (Mes a Mes)

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
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � FINR120  � Autor � Lu�s C. Cunha         � Data � 05/11/93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Movimenta��o di�ria do caixa                               ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   � FINR120()                                                  ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGAFIN - Inbrafer                                         ���
��������������������������������������������������������������������������Ĵ��
��� Arquivos  � SA6 ( Cadastro de Bancos )                                 ���
���           � SE5 ( Movimenta��o Banc�ria )                              ���
���           � SED ( Cadastro de Naturezas )                              ���
��������������������������������������������������������������������������Ĵ��
��� Rdmake 2/4.07 �Autor � Airton Lira         � Data �     30/11/2001     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

// ��������������������������������������Ŀ
// � Par�metros para a fun��o SetPrint () �
// ����������������������������������������
cArea      := ""
cDesc1     := ""
cDesc2     := ""
cDesc3     := ""

wnrel      := ""
cString    := "SE5"

// �����������������������������������Ŀ
// � Par�metros para a fun��o Cabec () �
// �������������������������������������
cCabecalho := ""
cPerg      := ""
cRelatorio := ""
cTitulo    := ""
nNat := ""

// �����������������������������������������������������������Ŀ
// � Vari�veis utilizadas para impressao do cabe�alho e rodap� �
// �������������������������������������������������������������
Li     := 0
m_Pag  := 1

// ������������������������������������������������Ŀ
// � Vari�veis utilizadas pela fun��o SetDefault () �
// ��������������������������������������������������
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0

// �����������������������������������������������������Ŀ
// � Vari�veis p�blicas utilizadas em macro-substitui��o �
// �������������������������������������������������������
cIndice := ""
cMoeda  := ""
cQuebra := ""

// �������������������������������������������Ŀ
// � VerIfica os par�metros selecionados e en- �
// � via o controle para a fun��o SetPrint ()  �
// ���������������������������������������������
aOrdem     := {}  

cArea      := "SE5"
cDesc1     := "Relacao das Despesas e ou Recebimentos Ordenados pela Natureza       -"
cDesc2     := "Podera ser Impresso Analitico ou Sintetico. Titulos Pagos e/Ou Recebi-"
cDesc3     := "dos. Impressao Conforme Parametros Selecionados - USO Espelhos Leao.  "
cPerg      := "FIN120"
cRelatorio := "RFIN004"
cTitulo    := "Orcado X Realizado (Mes a Mes)"
nTamanho   := "G"
lEnd       := .F.

Pergunte (cPerg,.T.)
nTamanho   := "M"
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

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � FA120Imp � Autor � Lu�s C. Cunha         � Data � 05/11/93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Movimenta��o di�ria do caixa                               ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   � FA120Imp(lEnd,wnRel,cString                                ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������Ĵ��
���Parametros � lEnd    - A��o do Codeblock                                ���
���           � wnRel   - T�tulo do relat�rio                              ���
���           � cString - Mensagem                                         ���
��������������������������������������������������������������������������Ĵ��
��� Arquivos  � SA6 ( cadastro de bancos )                                 ���
���           � SE5 ( movimenta��o banc�ria )                              ���
���           � SED ( cadastro de naturezas )                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 27/02/02 ==> Function FA120Imp
Static Function FA120Imp()

// ��������������������������������������Ŀ
// � Par�metros para emiss�o do relat�rio �
// ����������������������������������������
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

// �����������������������Ŀ
// � Vari�veis de controle �
// �������������������������
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

// �������������������������������������������������������������������������Ŀ
// � Par�metros para emiss�o do relat�rio :                                  �
// � mv_par01 => Numer�rio inicial                                           �
// � mv_par02 => Numer�rio final                                             �
// � mv_par03 => Data inicial                                                �
// � mv_par04 => Data final                                                  �
// � mv_par05 => Banco inicial                                               �
// � mv_par06 => Banco final                                                 �
// � mv_par07 => Natureza inicial                                            �
// � mv_par08 => Natureza final                                              �
// � mv_par09 => Moeda utilizada ( 1...5 )                                   �
// � mv_par10 => N�vel anal�tico ( 1 ) ou sint�tico ( 2 )                    �
// � mv_par11 => Pagamentos ( 1 ), recebimentos ( 2 ) ou ambos ( 3 )         �
// ���������������������������������������������������������������������������
cNumInicial    := mv_par01
cNumFinal      := mv_par02
dDataInicial   := mv_par03
dDataFinal     := mv_par04
cBancoInicial  := mv_par05
cBancoFinal    := mv_par06
cNatInicial    := mv_par07
cNatFinal      := mv_par08
nMoeda         := mv_par09
nNivel         := mv_par10
nOperacao      := mv_par11
nSal           := 0

// ���������������������������������Ŀ
// � Ajusta as vari�veis de controle �
// �����������������������������������
cOperacao := cOperacao + IIf ( nOperacao == 1 .or. nOperacao == 3, "P", "" )
cOperacao := cOperacao + IIf ( nOperacao == 2 .or. nOperacao == 3, "R", "" )

cMoeda     := STR(nMoeda,1)
cMvMoeda   := "MV_MOEDA" + cMoeda
mv_moeda   := GetMv(cMvMoeda)

// ������������������������������Ŀ
// � Obt�m a tabela de numer�rios �
// ��������������������������������
dbSelectArea("SX5")
dbSeek(xFilial() + "06")
dbEval({||AADD(aNumerario,SX5->X5_DESCRI),AADD(aChave,SX5->X5_CHAVE)},NIL,{ ||xFilial() == SX5->X5_FILIAL .and. SX5->X5_TABELA == "06"})

// ����������������������������Ŀ
// � Cria o arquivo de trabalho �
// ������������������������������
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
AADD(aCampos,{"TB_VACUM"   ,"N",17,2})
AADD(aCampos,{"TB_IMP"     ,"C",01,0})
cTrabalho := CriaTrab(aCampos)
dbUseArea(.T.,,cTrabalho,"Trabalho",.F.,.F.)
dbSelectArea("Trabalho")

// �����������������������������Ŀ
// � Define a ordem de impress�o �
// �������������������������������

cNatureza  := Trabalho->TB_NATUREZ
cDescricao := ""
Natureza()
bTexto     := {||Trabalho->TB_NATUREZ+ " - " + POSICIONE("SED",1,xFilial("SED")+Trabalho->TB_NATUREZ,"SED->ED_DESCRIC")}
cIndice    := "TB_FILIAL+TB_NATUREZ+DTOS(TB_DATA)"
cQuebra    := "Trabalho->TB_NATUREZ"
//cTitulo := cTitulo + " - Natureza"
dbSelectArea("Trabalho")
IndRegua("Trabalho",cTrabalho,cIndice,,,"Selecionando Registros...")

cTemp := CriaTrab(nil,.f.)
dbSelectArea("SE5")
dbSetOrder(9)
//Index on e5_filial+DTOS(e5_dtdispo) to &cTemp
//Seek "01"+DTOS(dDataInicial)
dDataInicial := ctod("01/01/"+str(year(mv_par03),4))
dbSeek(xFilial("SE5")+dtos(dDataInicial),.T.)
While ! Eof() .AND. SE5->E5_DTDISPO <= dDataFinal
//    incregua()
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

      If SE5->E5_TIPODOC $ "DC/MT/CM/JR/CP/M2/C2/D2/J2/V2"  // valores agregados
         dbSkip()
         Loop
      Endif

      If nOrdem == 2 .AND. Empty(SE5->E5_MOEDA) // por numer�rio, n�o considera em brancos
         dbSkip()
         Loop
      Endif    
      // ��������������������������������������Ŀ
      // � N�o processa t�tulos sem numer�rio   �
      // � ou que n�o satisfa�am aos par�metros �
      // ����������������������������������������
      If (SE5->E5_MOEDA   >= cNumInicial   .AND. ;
          SE5->E5_MOEDA   <= cNumFinal     .AND. ;
          SE5->E5_DTDISPO >= dDataInicial  .AND. ;
          SE5->E5_DTDISPO <= dDataFinal    .and. ;
          SE5->E5_BANCO   >= cBancoInicial .and. ;
          SE5->E5_BANCO   <= cBancoFinal   .and. ;
          SE5->E5_NATUREZ >= cNatInicial   .and. ;
          SE5->E5_NATUREZ <= cNatFinal     .and. ;
          SE5->E5_SITUACA != "C" )

          If mv_par11 != 3
             If cOperacao == SE5->E5_RECPAG .AND. SE5->E5_TIPODOC == "ES" 
                dbskip()
                loop
             Endif
             If cOperacao != SE5->E5_RECPAG .and. SE5->E5_TIPODOC != "ES"
                dbskip()
                loop
             Endif 
          Endif
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
      dbSelectArea("SA2")
      dbseek(xfilial() + SE5->E5_CLIFOR)
      Trabalho->TB_BENEF   := SA2->A2_NREDUZ
      if SE5->E5_DTDISPO>=mv_par03
      Trabalho->TB_VALOR   := IIf(mv_par09==1,SE5->E5_VALOR,SE5->E5_VALOR/RecMoeda(SE5->E5_DTDISPO,mv_par09))
      endif
      Trabalho->TB_VACUM   := IIf(mv_par09==1,SE5->E5_VALOR,SE5->E5_VALOR/RecMoeda(SE5->E5_DTDISPO,mv_par09))
      If SE5->E5_TIPODOC == "CH" 
	Trabalho->TB_IMP := "N"
      Else	
        Trabalho->TB_IMP := "S"	
      Endif
     Endif
     dbSelectArea("SE5")
     dbSkip()
Enddo

Select SA6                // Calcula o saldo banc�rio
set softseek on
seek xFilial()+mv_par05
set softseek off
nSal := 0
Do while !eof() .and. sa6->a6_cod>=mv_par05 .and. sa6->a6_cod<=mv_par06
   Select SE8
   set softseek on
   seek xFilial()+sa6->(a6_cod+a6_agencia+a6_numcon)+dtos(mv_par03)
   set softseek off
   skip -1
   if e8_banco>=mv_par05 .and. e8_banco<=mv_par06
      if e8_dtsalat < mv_par03 
        nSal := nSal + e8_salatua
      Endif
   endif
   Select SA6
   Skip
Enddo

Retindex("SE5")

ResNat()
Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � PulaLinha ( nLinhas )                                      ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Lu�s C. Cunha                            � Data � 13.10.93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Incrementa  a linha atual e verIfica se h� necessidade  de ���
���           � salto de p�gina.                                           ���
��������������������������������������������������������������������������Ĵ��
��� Par�metros� nLinhas � N�mero de linhas a incrementar.                  ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � FinR120                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 27/02/02 ==> Function PulaLinha
Static Function PulaLinha()

nLinhas := IIf (nLinhas == NIL,1,nLinhas)

li := li + nLinhas

// �����������Ŀ
// � Cabe�alho �
// �������������

// cTamanho := "P"
cTamanho := "M"
cCabecalho := "Natureza                                   Orcado     Despesas   Diferenca   Orcado Ano   Desp.Ano   Dif.Ano "
If Li > 58 .or. M_Pag == 1
   Cabec(cTitulo,cCabecalho,"",cRelatorio,cTamanho,15)
Endif

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � Natureza ( cNatureza )                                     ���
��������������������������������������������������������������������������Ĵ��
��� Autor     � Lu�s C. Cunha                            � Data � 13.10.93 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Obt�m a descri��o de uma natureza no arquivo SED.          ���
��������������������������������������������������������������������������Ĵ��
��� Par�metros� cNatureza � C�digo da natureza.                            ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � FinR120                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 27/02/02 ==> Function Natureza
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

// ������������������������������������������������������������������������Ŀ
// � Inicializa a barra indicativa de processamento para o arquivo Trabalho �
// ��������������������������������������������������������������������������
dbSelectArea("Trabalho")
dbGoTop()

SetRegua(RecCount())
cCabecalho := "Natureza                               Pagamentos   Recebimentos      Diferenca"
//*            012345678901234567890123456789012345678901234567890123456789012345678901234567890
//*            0        10        20        30        40        50        60        70        80
lFirst := 1
nNat   := trabalho->tb_naturez
nValPgt:= nValRect:= 0
nValPgt1 := tValPgt1 := 0
tOrcM := tOrct := 0
PulaLinha()
While !Eof()
      nNat := Trabalho->TB_NATUREZ
      nValPg := nValRec := 0
      do while Trabalho->TB_NATUREZ == nNat
         If Trabalho->TB_RECPAG == "P"
            nValPg  := nValPg + Trabalho->TB_VALOR
            nValPgt := nValPgt+ Trabalho->TB_VALOR
            nValPgt1:= nValPgt1+ Trabalho->TB_VACUM
         Else
            nValRec := nValRec + Trabalho->TB_VALOR
            nValRect:= nValRect+ Trabalho->TB_VALOR
         Endif
         skip
      Enddo
      cAno := str(year(mv_par04),4)
      dbSelectArea("SE7")
      dbSetOrder(2)
      dbSeek(xFilial()+cAno+nNat)
      nOrcT := 0
      if Month(mv_par04)>=1
        nOrcM := se7->e7_valjan1
        nOrcT := nOrcT + se7->e7_valjan1
      Endif
      if Month(mv_par04)>=2
        nOrcM := se7->e7_valfev1
        nOrcT := nOrcT + se7->e7_valfev1
      Endif
      if Month(mv_par04)>=3
        nOrcM := se7->e7_valmar1
        nOrcT := nOrcT + se7->e7_valmar1
      Endif
      if Month(mv_par04)>=4
        nOrcM := se7->e7_valabr1
        nOrcT := nOrcT + se7->e7_valabr1
      Endif
      if Month(mv_par04)>=5
        nOrcM := se7->e7_valmai1
        nOrcT := nOrcT + se7->e7_valmai1
      Endif
      if Month(mv_par04)>=6
        nOrcM := se7->e7_valjun1
        nOrcT := nOrcT + se7->e7_valjun1
      Endif
      if Month(mv_par04)>=7
        nOrcM := se7->e7_valjul1
        nOrcT := nOrcT + se7->e7_valjul1
      Endif
      if Month(mv_par04)>=8
        nOrcM := se7->e7_valago1
        nOrcT := nOrcT + se7->e7_valago1
      Endif
      if Month(mv_par04)>=9
        nOrcM := se7->e7_valset1
        nOrcT := nOrcT + se7->e7_valset1
      Endif
      if Month(mv_par04)>=10
        nOrcM := se7->e7_valout1
        nOrcT := nOrcT + se7->e7_valout1
      Endif
      if Month(mv_par04)>=11
        nOrcM := se7->e7_valnov1
        nOrcT := nOrcT + se7->e7_valnov1
      Endif
      if Month(mv_par04)>=12
        nOrcM := se7->e7_valdez1
        nOrcT := nOrcT + se7->e7_valdez1
      Endif
      dbSelectArea("SED")
      dbSeek(xFilial()+nNat)
      @ Li, 000 PSAY nNat+"-"+left(SED->ED_DESCRIC,24)
      @ Li, 036 PSAY nOrcM   Picture "@E 999999,999.99"
      @ Li, 050 PSAY nValPG  Picture "@E 999999,999.99"
      @ Li, 064 PSAY (nValPG/nOrcM-1)*100 Picture "@E 9,999.99%"
      @ Li, 074 PSAY nOrcT   Picture "@E 999999,999.99"
      @ Li, 088 PSAY nValPgt1 Picture "@E 999999,999.99"
      @ Li, 102 PSAY nValPgt1/nOrcT*100 Picture "@E 9,999.99%"

//    @ Li, 036 PSAY nValPG  Picture "@E 999999,999.99"
//    @ Li, 051 PSAY nValRec Picture "@E 999999,999.99"
//    @ Li, 066 PSAY nValPG-nValRec Picture "@E 999999,999.99"
      tOrcm := tOrcm + nOrcm
      tOrct := tOrct + nOrct
      tValPgt1 := tValPgt1 + nValPgt1
      nValPgt1 := 0
      PulaLinha()
      Select Trabalho
Enddo      
PulaLinha()
@ Li,000 PSAY "Total Geral "
@ Li, 036 PSAY tOrcM   Picture "@E 999999,999.99"
@ Li, 050 PSAY nValPGt  Picture "@E 999999,999.99"
@ Li, 064 PSAY (nValPGt/tOrcM-1)*100 Picture "@E 999999.99%"
@ Li, 074 PSAY tOrcT   Picture "@E 999999,999.99"
@ Li, 088 PSAY tValPGt1 Picture "@E 999999,999.99"
@ Li, 102 PSAY tValPGt1/tOrct*100 Picture "@E 999999.99%"

//@ Li, 036 PSAY nValPGt  Picture "@E 999999,999.99"
//@ Li, 050 PSAY nValRect Picture "@E 999999,999.99"
//@ Li, 064 PSAY nValPGt-nValRect Picture "@E 999999,999.99"
//PulaLinha()
//@ Li, 000 PSAY "Sld.Banc.Anterior "
//@ Li, 020 PSAY nSal     picture "@E 999999,999.99"
//PulaLinha()
//@ Li, 000 PSAY "Sld.Banc.Final "
//@ Li, 020 PSAY nSal-nValPGt+nValRect picture "@E 999999,999.99"

//@ Li+2,000 PSAY "De: "
//@ Li+2,005 PSAY MV_PAR03
//@ Li+2,014 PSAY "Ate:"
//@ Li+2,019 PSAY MV_PAR04
//PulaLinha(2)
Roda(0,"","G")

// �����������������������������Ŀ
// � Restaura o ambiente inicial �
// �������������������������������
Set Device to Screen
If aReturn[5] == 1
   Set Printer to
   dbCommitAll()
   OurSpool(cRelatorio)
Endif
MS_FLUSH()
// ���������������������������������Ŀ
// � Elimina os arquivos de trabalho �
// �����������������������������������
dbSelectArea("Trabalho")
//COPY TO XTESTE
dbCloseArea()
fErase(cTrabalho+".DBF")
fErase(cTrabalho+OrdBagExt())

// ���������������������������������Ŀ
// � Restaura as ordens dos arquivos �
// �����������������������������������
dbSelectArea ( "SE5" )
dbSetOrder(1)

Return

