#include "rwmake.ch"      
#IFNDEF WINDOWS
        #DEFINE PSAY SAY
#ENDIF

User Function rfat006()  // Faturamento sem IPI

SetPrvt("C_STRING,C_NOMREL,C_PERG,C_DESC1,C_DESC2,C_DESC3")
SetPrvt("C_DESC4,L_DICDATA,A_ORDEM,L_HABCOMP,C_TAMANHO,C_ARQ")
SetPrvt("ARETURN,C_CABEC1,C_CABEC2,M_PAG,WLN,WFILTRO")
SetPrvt("WCOND,WPULA,WWIDPAGE,A_QUEBRA,A_TOTA01,A_TOTA02")
SetPrvt("A_TOTG09,A_TOTG10,A_TOTG11,A_TOTG12,XDESCRI,XMES")
SetPrvt("XVENDE,XDATINI,XDATFIM,XDATREA,XSN,C_MSGREG")
SetPrvt("C_SAVREG1,C_SAVREG2,N_CNTREG1,N_CNTREG2,N_CNTREG3,C_SAVSCR1")
SetPrvt("N_SAVCUR1,N_SAVROW1,N_SAVCOL1,C_SAVCOR1,N_AREA,N_IND")
SetPrvt("N_REC,NLASTKEY,C_COLOR,dDataINI")

c_String  := "SF2" // Nome do Alias
c_NomRel  := "Faturamento sem IPI                            "  // Nome do Relatorio
c_Perg    := "RFT001"    // Nome do Grupo de Perguntas
c_Desc1   := "Faturamento sem IPI                            " // Descricao do Relatorio - Titulo
c_Desc2   := "     Sera impresso no intervalo solicitado o faturamento de cada  "    // Primeira linha da Descricao
c_Desc3   := "representante e seus clientes.                                    "    
c_Desc4   := " "
l_DicData := .F.   // Habilita o Dicionario de Dados
a_Ordem   := {}    // Array com as Ordens de Indexacao
l_HabComp := .T.   // Habilita a Compressao do Relatorio
c_Tamanho := "M"    // (P) 080  /  (M) 132  /  (G) 220
c_Arq     := "RFT006"    // Nome do arquivo com o relatorio impresso em disco

aReturn   := {"",1,"",1,2,1,"",1} // Formulario,N.vias,Destinatario,Formato,Midia,Porta,Filtro,Ordem

xDescri   := ""
xmes      := 0  
wln       := 0
TGQT      := 0
TGQ1:=0;TGQL:=0;TGQ3:=0;TGQ4:=0;TGQ5:=0;TGQ6:=0;TGQ7:=0;TGQ8:=0;TGQ9:=0
TGTT:=0
TGCL:=0
TGLL:=0
TCUSTO := TCUSTO1 := 0
xDescri   := ""
xsn := ""

n_Area    := Alias()
n_Ind     := IndexOrd()
n_Rec     := Recno()
nLastKey  := 0

//+--------------------------------------------------------------------------+
//¦ Verifica as Perguntas Selecionadas no SX1                                ¦
//+--------------------------------------------------------------------------+

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

Processa({|| PCliente() })

Return

Static Function PCliente()

Local _nTotReg := 0
Local _nRegAtu := 0

cArq := CriaTrab({{"T_CODI"   ,"C",06,0},;
                  {"T_REPR"   ,"C",15,0},;
		  {"T_CODC"   ,"C",06,0},;
		  {"T_CLIE"   ,"C",20,0},;
		  {"T_PEDIDO" ,"C",06,0},;
       		  {"T_DTPEDI" ,"D",08,0},;
		  {"T_NOTA"   ,"C",06,0},;
		  {"T_DTNOTA" ,"D",08,0},;
		  {"T_VALOR"  ,"N",17,2},;
		  {"T_CUSTO"  ,"N",17,2},;
                  {"T_MARGEM" ,"N",06,2}},.T.)

dbUseArea(.t.,,cArq,"TMP",.f.)
index On TMP->T_CODI To &(cArq)
dbSelectArea("SF2")
_nTotReg := RecCount()
dbSelectArea("SF2")
dbSetOrder(3)
dbSeek(xFilial()+" "+dtoc(MV_PAR01),.T.)
ProcRegua(_nTotReg)	
While !Eof() 
    IF SF2->F2_TIPO == "N" 
     IF SF2->F2_EMISSAO >= MV_PAR01 .And. SF2->F2_EMISSAO <= MV_PAR02
	If SF2->F2_VEND1 >= MV_PAR03 .And. SF2->F2_VEND1 <= MV_PAR04
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_VEND1)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_CLIENTE+SF2->F2_LOJA)
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
                nVal := 0
                do while sd2->(d2_doc+d2_serie)==SF2->(F2_DOC+f2_serie)
                   Select SF4
                   seek xFilial()+sd2->d2_tes
                   Select SD2
                   if sf4->f4_duplic=="S"
                     nVal := nVal + sd2->d2_total
                   endif
                   Skip
                Enddo
                if nVal == 0
                  Select SF2
                  Skip
                  Loop
                endif
		dbSeek(xFilial()+SF2->F2_DOC+SF2->F2_SERIE)
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial()+SD2->D2_PEDIDO)
		dbSelectArea("TMP")
		RecLock("TMP",.T.)
		TMP->T_CODI   := SF2->F2_VEND1
		TMP->T_REPR   := SA3->A3_NREDUZ
		TMP->T_CODC   := SF2->F2_CLIENTE
		TMP->T_CLIE   := SA1->A1_NREDUZ
		TMP->T_PEDIDO := SC5->C5_NUM
		TMP->T_DTPEDI := SC5->C5_EMISSAO
		TMP->T_NOTA   := SF2->F2_DOC
		TMP->T_DTNOTA := SF2->F2_EMISSAO
		If SF2->F2_FATOR <> 0
//  			TMP->T_VALOR := SF2->F2_VALMERC/SF2->F2_FATOR
    			TMP->T_VALOR := nVal/SF2->F2_FATOR
		Else
//			TMP->T_VALOR := SF2->F2_VALMERC
			TMP->T_VALOR := nVal
		Endif
		TMP->T_MARGEM := SC5->C5_MARGEM 
		TMP->T_CUSTO  := SC5->C5_MARGEM * TMP->T_VALOR /100
	  Endif
	Endif
      Endif
      _nRegAtu++
      IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6))
      dbSelectArea("SF2")
      dbSkip()
Endd

//+------------------------------------------------------------------------+
//¦ Inicia a Impressao do Relatorio                                        ¦
//+------------------------------------------------------------------------+

dbSelectArea("TMP")
Index on tmp->t_dtnota To &(cArq)
dbGotop()

Set Device to Print
lFirst := 1
While !Eof()
        If Wln > 58 .or. Wln == 0
	  Impcabec()
        Endif
dDat := TMP->T_DTNOTA
nVal := 0
Do while TMP->T_DTNOTA == dDat
@ wln,000 PSAY TMP->T_CODC
@ wln,008 PSAY TMP->T_CLIE
@ wln,036 PSAY TMP->T_PEDIDO
@ wln,045 PSAY TMP->T_DTPEDI
@ wln,055 PSAY TMP->T_NOTA 
@ wln,065 PSAY TMP->T_DTNOTA
@ wln,075 PSAY TMP->T_VALOR   Picture "@E 999,999.99"
@ wln,090 PSAY TMP->T_MARGEM  Picture "@E 999.99"

nVal := nVal + TMP->T_VALOR
TCUSTO := TCUSTO + TMP->T_CUSTO
TCUSTO1:= TCUSTO1+ TMP->T_CUSTO
TGQT := TGQT + TMP->T_MARGEM
TGQL := TGQL + TMP->T_MARGEM
TGQ1 := TGQ1 + TMP->T_VALOR
TGTT := TGTT + TMP->T_VALOR
TGCL := TGCL + 1
TGLL := TGLL + 1
Wln := Wln + 1

dbSkip()
Enddo
@ wln-1,100 PSAY nVal   Picture "@E 999,999.99"
Enddo
wln := wln + 1
@ wln,000 PSAY Replicate("-",132)
wln := wln + 1
@ wln,000 PSAY "TOTAL GERAL: "
@wln,012 PSAY TGLL   Picture "@E 9999"
@wln,018 PSAY "<- Notas Fiscais"
@wln,075 PSAY TGTT    Picture "@E 999,999.99"
@wln,090 PSAY TCUSTO1/TGTT*100 Picture "@E 999.99"
wln:=wln+1
@wln,000 PSAY Replicate("-",132)
wln:=wln+1

Set Device to Screen

If aReturn[5]==1
   Set Print to
   dbCommitAll()
   OurSpool(c_Arq)
EndIf

MS_FLUSH()

dbSelectArea("TMP")
copy to x
dbCloseArea()
fErase(cArq+".DBF")
fErase(cArq+OrdBagExt())

Return

Static Function ImpCabec()
Wln := 1
@ 000,000 PSAY Replicate("*",132)
@ 001,000 PSAY "*Leao      / Matriz"
@ 001,115 PSAY "Folha..:"
@ 001,132 PSAY "*"
@ 002,000 PSAY "*SIGA / RFAT006 / V.5.08 "
@ 002,048 PSAY "FATURAMENTO SEM IPI "
@ 002,115 PSAY "Dt.Ref.:"
@ 002,123 PSAY ddatabase
@ 002,132 PSAY "*"
@ 003,000 PSAY "*Hora...:"
@ 003,010 PSAY Time()
@ 003,048 PSAY "PERIODO : DE "+dtoc(MV_PAR01)+" ATE "+dtoc(MV_PAR02)
@ 003,115 PSAY "Emissao:"
@ 003,123 PSAY Date()
@ 003,132 PSAY "*"
@ 004,000 PSAY Replicate("*",132)
@ 005,000 PSAY "Codigo | Cliente                  | Pedido | Dt.Ped. |  Nota  | Emissao |  Valor (R$)  | Margem% | Tot.Dia"
@ 006,000 PSAY Replicate("*",132)

Wln := 7 

Return

Return .t.
