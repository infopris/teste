#include "rwmake.ch"      
#IFNDEF WINDOWS
        #DEFINE PSAY SAY
#ENDIF

User Function rfat007()  

SetPrvt("C_STRING,C_NOMREL,C_PERG,C_DESC1,C_DESC2,C_DESC3")
SetPrvt("C_DESC4,L_DICDATA,A_ORDEM,L_HABCOMP,C_TAMANHO,C_ARQ")
SetPrvt("ARETURN,C_CABEC1,C_CABEC2,M_PAG,WLN,WFILTRO")
SetPrvt("WCOND,WPULA,WWIDPAGE,A_QUEBRA,A_TOTA01,A_TOTA02")
SetPrvt("A_TOTA03,A_TOTA04,A_TOTA05,A_TOTA06,A_TOTA07,A_TOTA08")
SetPrvt("A_TOTA09,A_TOTA10,A_TOTA11,A_TOTA12,A_TOTG01,A_TOTG02")
SetPrvt("A_TOTG03,A_TOTG04,A_TOTG05,A_TOTG06,A_TOTG07,A_TOTG08")
SetPrvt("A_TOTG09,A_TOTG10,A_TOTG11,A_TOTG12,XDESCRI,XMES")
SetPrvt("XVENDE,XDATINI,XDATFIM,XDATREA,XSN,C_MSGREG")
SetPrvt("C_SAVREG1,C_SAVREG2,N_CNTREG1,N_CNTREG2,N_CNTREG3,C_SAVSCR1")
SetPrvt("N_SAVCUR1,N_SAVROW1,N_SAVCOL1,C_SAVCOR1,N_AREA,N_IND")
SetPrvt("N_REC,NLASTKEY,C_COLOR,dDataINI")

c_String  := "SC5" // Nome do Alias
c_NomRel  := "Vendas por Vendedor/Cliente                   "   // Nome do Relatorio
c_Perg    := "RFT002"    // Nome do Grupo de Perguntas
c_Desc1   := "Vendas por Vendedor/Cliente                   " // Descricao do Relatorio - Titulo
c_Desc2   := "Relatorio de Vendas por Vendedor/Cliente      "
c_Desc3   := ""
c_Desc4   := ""
l_DicData := .F.   // Habilita o Dicionario de Dados
a_Ordem   := {}    // Array com as Ordens de Indexacao
l_HabComp := .T.   // Habilita a Compressao do Relatorio
c_Tamanho := "P"    // (P) 080  /  (M) 132  /  (G) 220
c_Arq     := ""    // Nome do arquivo com o relatorio impresso em disco

aReturn   := {"",1,"",1,2,1,"",1} // Formulario,N.vias,Destinatario,Formato,Midia,Porta,Filtro,Ordem

xDescri   := ""
xmes      := 0  
wln       := 0
TGQT      := 0
GTGQT     := 0
TGCL      := 1
GTGCL     := 1
xDescri   := ""
xsn := ""

n_Area    := Alias()
n_Ind     := IndexOrd()
n_Rec     := Recno()
nLastKey  := 0

//+--------------------------------------------------------------------------+
//¦ Verifica as Perguntas Selecionadas no SX1                                ¦
//+--------------------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Data de                              ¦
//¦ mv_par02             // Data Ate                             ¦
//¦ mv_par03             // Estado De                            ¦
//¦ mv_par04             // Estado At‚                           ¦
//¦ mv_par05             // Vendedor de                          ¦
//¦ mv_par06             // Vendedor At‚                         ¦
//+--------------------------------------------------------------+

Pergunte(c_Perg,.F.)

//+--------------------------------------------------------------------------+
//¦ Envia Controle para Funcao SetPrint                                      ¦
//+--------------------------------------------------------------------------+

c_Arq := Setprint(c_String,c_Perg,c_Perg,@c_Desc1,c_Desc2,c_Desc3,c_Desc4,;
                  l_DicData,a_Ordem,l_HabComp,c_Tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Ret_Int()
   Return
EndIf

SetDefault(aReturn,c_String)

cArq := CriaTrab({{"T_CODI"   ,"C",02,0},;
		  {"T_CODR"   ,"C",06,0},;
		  {"T_PEDIDO" ,"C",06,0},;
		  {"T_REPR"   ,"C",20,0},;
		  {"T_CLI"    ,"C",08,0},;
		  {"T_CLIEN"  ,"C",30,0},;
                  {"T_MRG"    ,"N",06,2},;
                  {"T_QTDTT"  ,"N",17,2}},.T.)

dbUseArea(.t.,,cArq,"TMP",.f.)
index On TMP->T_PEDIDO To &(cArq)
dbSelectArea("SC5")
dbSetOrder(2)
dbSeek(xFilial()+dtoc(MV_PAR01),.T.)
While !Eof() 
  IF SC5->C5_EMISSAO >= MV_PAR01 .AND. SC5->C5_EMISSAO <= MV_PAR02
    if sc5->c5_vend1<mv_par05 .and. sc5->c5_vend2<mv_par05 .and. ;
       sc5->c5_vend3<mv_par05 .and. sc5->c5_vend4<mv_par05 .and. ;
       sc5->c5_vend5<mv_par05 
       dbSkip()
       Loop
    Endif
    if sc5->c5_vend1>mv_par06 .and. sc5->c5_vend2>mv_par06 .and. ;
       sc5->c5_vend3>mv_par06 .and. sc5->c5_vend4>mv_par06 .and. ;
       sc5->c5_vend5>mv_par06 
       dbSkip()
       Loop
    Endif
    IF SC5->C5_TIPO == "N" 
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	If SA1->A1_EST >= MV_PAR03 .And. SA1->A1_EST <= MV_PAR04
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC5->C5_NUM)
		While SC5->C5_NUM == SC6->C6_NUM
			dbSelectArea("TMP")
			dbSeek(SC6->C6_NUM)
			If Found()
				RecLock("TMP",.F.)
			Else
				RecLock("TMP",.T.)
			Endif
			dbSelectArea("SA3")
			dbSetOrder(1)
			dbSeek(xFilial()+SC5->C5_VEND1)
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			TMP->T_CODI := SA1->A1_EST
			TMP->T_MRG  := SC5->C5_MARGEM
			TMP->T_REPR := SA3->A3_NREDUZ
			TMP->T_CODR := SC5->C5_VEND1   
			TMP->T_CLI  := SC5->C5_CLIENTE+SC5->C5_LOJACLI
			TMP->T_CLIEN:= SA1->A1_Nome
			TMP->T_QTDTT := TMP->T_QTDTT + SC6->C6_VALOR
			dbSelectArea("SC6")
			dbSkip()
	    	Endd
	Endif
     Endif
    Endif
   dbSelectArea("SC5")
   dbSkip()
Endd

//+------------------------------------------------------------------------+
//¦ Inicia a Impressao do Relatorio                                        ¦
//+------------------------------------------------------------------------+

dbSelectArea("TMP")
index On TMP->T_CODR+TMP->T_CLI To &(cArq)
dbGotop()
Set Device to Print
nRep := TMP->T_CODR
lFirst := 1
nMrg   := nMrgT  := 0
While !Eof()
        if TMP->T_CODR<MV_PAR05 .OR. TMP->T_CODR>MV_PAR06
           dbSkip()
           Loop
        Endif
	If wln == 0
		ImpCabec()
	Endif
	If lFirst == 1
		@wln,000 PSAY "Vendedor.: "
		@wln,009 PSAY TMP->T_CODR
		@wln,020 PSAY "Periodo: "
		@wln,029 PSAY MV_PAR01
		@wln,038 PSAY " a "
		@wln,041 PSAY MV_PAR02
		wln:=wln+1
		@wln,000 PSAY Replicate("-",080)
		wln:=wln+1
		lFirst := lFirst + 1
	Endif
        nSubTot := 0
        nSubMg  := 0
        nCli    := TMP->T_CLIEN
        nQtdPed := 0
        Do while !eof() .and. TMP->T_CLIEN== nCli .and. TMP->T_CODR==nRep
           @ wln,000 PSAY TMP->T_CODR
           @ wln,008 PSAY TMP->T_REPR
           @ wln,029 PSAY TMP->T_CLIEN
           @ wln,062 PSAY TMP->T_QTDTT   Picture "@E 9999,999.99"
           @ wln,074 PSAY TMP->T_MRG     Picture "@E 999.99"
           nSubTot := nSubTot + TMP->T_QTDTT
           NSubMG := NSubMG + TMP->T_MRG
           NMRG := NMRG + TMP->T_MRG
           NMRGT:= NMRGT+ TMP->T_MRG
           nQtdPed:= nQtdPed+1
           TGQT := TGQT + TMP->T_QTDTT
           TGCL := TGCL + 1
           GTGQT:= GTGQT + TMP->T_QTDTT
           GTGCL:= GTGCL + 1
           Wln := Wln + 1
           If Wln > 60
              Impcabec()
           Endif
           dbSkip()
        Enddo
  	@ wln,000 PSAY "Sub-Total Cliente.: "
        @ wln,062 PSAY nSubTot Picture "@E 9999,999.99"
        @ wln,074 PSAY nSubMg/nQtdPed  Picture "@E 999.99"
        Wln := Wln + 1

If TMP->T_CODR <> nRep
	@wln,000 PSAY Replicate("-",080)
	wln := wln + 1
	@wln,000 PSAY "Totais.: "
	@wln,010 PSAY TGCL   Picture "@E 9999"
	@wln,016 PSAY "<- PEDIDOS"
	@wln,062 PSAY TGQT   Picture "@E 9999,999.99"
	@wln,074 PSAY NMRG/TGCL Picture "@E 999.99"
	wln:=wln+1
	@wln,000 PSAY Replicate("-",080)
	wln:=wln+1
	nRep := TMP->T_CODR
	tGQT := 0
        NMRG := 0
	TGCL:=0
	lFirst := 1
Endif
		
Enddo
Wln := wln + 1
@ Wln,000 PSAY "TOTAL GERAL: "
@ Wln,013 PSAY GTGCL     Picture "@E 99999"
@ Wln,020 PSAY "<- PEDIDOS"
@ Wln,062 PSAY GTGQT     Picture "@E 9999,999.99"
@ wln,074 PSAY NMRGT/GTGCL Picture "@E 999.99"
Wln := Wln + 1
@ wln,000 PSAY Replicate("-",080)

Set Device to Screen

If aReturn[5]==1
   Set Print to
   dbCommitAll()
   OurSpool(c_Arq)
EndIf

MS_FLUSH()

dbSelectArea("TMP")
dbCloseArea()
fErase(cArq+".DBF")
fErase(cArq+OrdBagExt())

Return

Static Function ImpCabec()
Wln := 1
@ 000,000 PSAY Replicate("*",080)
@ 001,000 PSAY "*Leao    / Matriz"
@ 001,060 PSAY "Folha..:"
@ 001,079 PSAY "*"
@ 002,000 PSAY "*SIGA / RFAT007 / V.5.08 "
@ 002,033 PSAY "VENDAS POR VENDEDOR/CLIENTE"
@ 002,060 PSAY "Dt.Ref.:"
@ 002,069 PSAY ddatabase
@ 002,079 PSAY "*"
@ 003,000 PSAY "*Hora...:"
@ 003,010 PSAY Time()
@ 003,060 PSAY "Emissao:"
@ 003,069 PSAY Date()
@ 003,079 PSAY "*"
@ 004,000 PSAY Replicate("*",080)
@ 005,000 PSAY "Codigo | Representante            |Cliente                 |  (R$) VENDA  | MARGEM"
@ 006,000 PSAY Replicate("*",080)

Wln := 7 

Return

Return .t.
