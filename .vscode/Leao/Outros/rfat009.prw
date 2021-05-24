#include "rwmake.ch"      
#IFNDEF WINDOWS
        #DEFINE PSAY SAY
#ENDIF

User Function rfat009()  // Vendas diarias com % por impostos

SetPrvt("C_STRING,C_NOMREL,C_PERG,C_DESC1,C_DESC2,C_DESC3")
SetPrvt("C_DESC4,L_DICDATA,A_ORDEM,L_HABCOMP,TAMANHO,C_ARQ")
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
c_NomRel  := "Estatistica de Vendas por Estado              "   // Nome do Relatorio
c_Perg    := "RFT002"    // Nome do Grupo de Perguntas
c_Desc1   := "Vendas com Impostos                           " // Descricao do Relatorio - Titulo
c_Desc2   := ""
c_Desc3   := ""
c_Desc4   := ""
l_DicData := .F.   // Habilita o Dicionario de Dados
a_Ordem   := {}    // Array com as Ordens de Indexacao
l_HabComp := .T.   // Habilita a Compressao do Relatorio
Tamanho   := "M"    // (P) 080  /  (M) 132  /  (G) 220
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

Cabec1 := "                         Vend. Grupo I                                          Vend. Grupo II"
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         0         1         2         3         4         5         6         7         8
Cabec2 := "Data          Icms 7       Icms 12       Icms 18   Sub-Total 1       Icms 7       Icms 12       Icms 18   Sub-Total 2  Total Vendas"
titulo   := "Vendas por Aliquota de ICMS"
nomeprog := "RFAT009"

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
                  l_DicData,a_Ordem,l_HabComp,Tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Ret_Int()
   Return
EndIf

SetDefault(aReturn,c_String)

cArq := CriaTrab({{"T_CODI"   ,"C",02,0},;
		  {"T_CODR"   ,"C",06,0},;
		  {"T_DATA"   ,"D",08,0},;
		  {"T_PEDIDO" ,"C",06,0},;
		  {"T_REPR"   ,"C",20,0},;
		  {"T_CLIEN"  ,"C",20,0},;
		  {"T_C7"     ,"N",12,2},;
		  {"T_C12"    ,"N",12,2},;
		  {"T_C18"    ,"N",12,2},;
		  {"T_S7"     ,"N",12,2},;
		  {"T_S12"    ,"N",12,2},;
		  {"T_S18"    ,"N",12,2},;
                  {"T_QTDTT"  ,"N",17,2}},.T.)

dbUseArea(.t.,,cArq,"TMP",.f.)
index On TMP->T_DATA To &(cArq)
dbSelectArea("SC5")
dbSetOrder(2)
set softseek on
dbSeek(xFilial()+dtos(MV_PAR01))
set softseek off
While !Eof() 
  IF SC5->C5_EMISSAO >= MV_PAR01 .AND. SC5->C5_EMISSAO <= MV_PAR02
    if sc5->c5_vend1<mv_par05 .and. sc5->c5_vend2<mv_par05 .and. ;
       sc5->c5_vend3<mv_par05 .and. sc5->c5_vend4<mv_par05 .and. ;
       sc5->c5_vend5<mv_par05 
       Skip
       Loop
    Endif
    if sc5->c5_vend1>mv_par06 .and. sc5->c5_vend2>mv_par06 .and. ;
       sc5->c5_vend3>mv_par06 .and. sc5->c5_vend4>mv_par06 .and. ;
       sc5->c5_vend5>mv_par06 
       Skip
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
			dbSeek(SC5->C5_Emissao)
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
			dbSeek(xFilial()+SC5->C5_CLIENTE)
			TMP->T_CODI := SA1->A1_EST
			TMP->T_REPR := SA3->A3_NREDUZ
			TMP->T_CODR := SC5->C5_VEND1   
			TMP->T_DATA := SC5->C5_EMISSAO 
			TMP->T_CLIEN:= SA1->A1_NREDUZ
			TMP->T_QTDTT:= TMP->T_QTDTT + SC6->C6_VALOR
                        Do case
                        Case sc5->c5_fator == "A"
                          do case
                          Case sa1->a1_est=="SP"
  			  TMP->T_C18  := TMP->T_C18 + SC6->C6_VALOR*.5
  			  TMP->T_S18  := TMP->T_S18 + SC6->C6_VALOR*.5
                          Case sa1->a1_est$"RJ*MG*PR*SC*RS"
  			  TMP->T_C12  := TMP->T_C12 + SC6->C6_VALOR*.5
  			  TMP->T_S12  := TMP->T_S12 + SC6->C6_VALOR*.5
                          Otherwise
  			  TMP->T_C7   := TMP->T_C7 + SC6->C6_VALOR*.5
  			  TMP->T_S7   := TMP->T_S7 + SC6->C6_VALOR*.5
                          Endcase
                        Case sc5->c5_fator == "B"
                          do case
                          Case sa1->a1_est=="SP"
  			  TMP->T_C18  := TMP->T_C18 + SC6->C6_VALOR*.2
  			  TMP->T_S18  := TMP->T_S18 + SC6->C6_VALOR*.8
                          Case sa1->a1_est$"RJ*MG*PR*SC*RS"
  			  TMP->T_C12  := TMP->T_C12 + SC6->C6_VALOR*.2
  			  TMP->T_S12  := TMP->T_S12 + SC6->C6_VALOR*.8
                          Otherwise
  			  TMP->T_C7   := TMP->T_C7 + SC6->C6_VALOR*.2
  			  TMP->T_S7   := TMP->T_S7 + SC6->C6_VALOR*.8
                          Endcase
                        Case sc5->c5_fator == "C"
                          do case
                          Case sa1->a1_est=="SP"
    			  TMP->T_C18  := TMP->T_C18 + SC6->C6_VALOR
                          Case sa1->a1_est$"RJ*MG*PR*SC*RS"
   			  TMP->T_C12  := TMP->T_C12 + SC6->C6_VALOR
                          Otherwise
    			  TMP->T_C7   := TMP->T_C7 + SC6->C6_VALOR
                          Endcase
                        Endcase
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
index On TMP->T_DATA To &(cArq)
dbGotop()
Set Device to Print
nDat := TMP->T_DATA
lFirst := 1
nSubTot := 0
li := 80
tc7 := tc12 := tc18 := ts7 := ts12 := ts18 := 0
While !Eof()
	If li >60
           Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
        nData   := TMP->T_DATA
        Do while !eof() .and. TMP->T_DATA == nData
           @ li,000 PSAY TMP->T_DATA
           @ li,010 PSAY TMP->T_C7  Picture "@E 999,999.99"
           @ li,024 PSAY TMP->T_C12 Picture "@E 999,999.99"
           @ li,038 PSAY TMP->T_C18 Picture "@E 999,999.99"
           @ li,052 PSAY TMP->(T_C7+T_C12+T_C18) Picture "@E 999,999.99"

           @ li,065 PSAY TMP->T_S7  Picture "@E 999,999.99"
           @ li,079 PSAY TMP->T_S12 Picture "@E 999,999.99"
           @ li,093 PSAY TMP->T_S18 Picture "@E 999,999.99"
           @ li,107 PSAY TMP->(T_S7+T_S12+T_S18) Picture "@E 999,999.99"

           @ li,119 PSAY TMP->T_QTDTT Picture "@E 999,999.99"

           tc7  := tc7 +t_c7
           tc12 := tc12+t_c12
           tc18 := tc18+t_c18
           ts7  := ts7 +t_s7
           ts12 := ts12+t_s12
           ts18 := ts18+t_s18

           nSubTot := nSubTot + TMP->T_QTDTT
           TGQT := TGQT + TMP->T_QTDTT
           TGCL := TGCL + 1
           GTGQT:= GTGQT + TMP->T_QTDTT
           GTGCL:= GTGCL + 1
           li := li + 1
           If li > 60
              Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
           Endif
           dbSkip()
        Enddo
Endd
@ li,000 PSAY replicate("-",132)
li := li + 1
@ li,000 PSAY "TOTAIS: "
           @ li,010 PSAY TC7  Picture "@E 999,999.99"
           @ li,024 PSAY TC12 Picture "@E 999,999.99"
           @ li,038 PSAY TC18 Picture "@E 999,999.99"
           @ li,052 PSAY tc7+tc12+TC18 Picture "@E 999,999.99"

           @ li,065 PSAY TS7  Picture "@E 999,999.99"
           @ li,079 PSAY TS12 Picture "@E 999,999.99"
           @ li,093 PSAY TS18 Picture "@E 999,999.99"
           @ li,107 PSAY ts7+ts12+TS18 Picture "@E 999,999.99"
           
           @ li,119 PSAY nSubTot Picture "@E 999,999.99"
           li := li + 1

           @ li,015 PSAY TC7/nSubTot*100   Picture "@E 99.99"
           @ li,020 PSAY "%"
           @ li,029 PSAY TC12/nSubTot*100  Picture "@E 99.99"
           @ li,034 PSAY "%"
           @ li,043 PSAY TC18/nSubTot*100  Picture "@E 99.99"
           @ li,048 PSAY "%"
           @ li,057 PSAY (tc7+tc12+TC18)/nSubTot*100  Picture "@E 99.99"
           @ li,062 PSAY "%"

           @ li,070 PSAY TS7/nSubTot*100   Picture "@E 99.99"
           @ li,075 PSAY "%"
           @ li,084 PSAY TS12/nSubTot*100  Picture "@E 99.99"
           @ li,089 PSAY "%"
           @ li,098 PSAY TS18/nSubTot*100  Picture "@E 99.99"
           @ li,103 PSAY "%"
           @ li,112 PSAY (ts7+ts12+TS18)/nSubTot*100  Picture "@E 99.99"
           @ li,117 PSAY "%"


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

