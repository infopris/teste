#include "rwmake.ch"      
#IFNDEF WINDOWS
        #DEFINE PSAY SAY
#ENDIF

User Function rfat003()  

SetPrvt("C_STRING,C_NOMREL,C_PERG,C_DESC1,C_DESC2,C_DESC3")
SetPrvt("C_DESC4,L_DICDATA,A_ORDEM,L_HABCOMP,C_TAMANHO,C_ARQ")
SetPrvt("ARETURN,C_CABEC1,C_CABEC2,M_PAG,WLN,WFILTRO")
SetPrvt("WCOND,WPULA,WWIDPAGE,A_QUEBRA,A_TOTA01,A_TOTA02")
SetPrvt("XVENDE,XDATINI,XDATFIM,XDATREA,XSN,C_MSGREG")
SetPrvt("C_SAVREG1,C_SAVREG2,N_CNTREG1,N_CNTREG2,N_CNTREG3,C_SAVSCR1")
SetPrvt("N_SAVCUR1,N_SAVROW1,N_SAVCOL1,C_SAVCOR1,N_AREA,N_IND")
SetPrvt("N_REC,NLASTKEY,C_COLOR,dDataINI")

c_String  := "SC5" // Nome do Alias
c_NomRel  := "Ranking das Vendas por Representante/Vendedor "   // Nome do Relatorio
c_Perg    := "RFT003"    // Nome do Grupo de Perguntas
c_Desc1   := "Ranking das Vendas por Vendedor /Representante" // Descricao do Relatorio - Titulo
c_Desc2   := ""
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
TGCL      := 0
GTGCL     := 0
xDescri   := ""
nVend     := ""

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

cArq := CriaTrab({{"T_CODR"   ,"C",06,0},;
		  {"T_PEDIDO" ,"C",06,0},;
		  {"T_REPR"   ,"C",20,0},;
                  {"T_QTDTT"  ,"N",17,2}},.T.)

dbUseArea(.t.,,cArq,"TMP",.f.)
Index On TMP->T_PEDIDO To &(cArq)
dbSelectArea("SC5")
_nTotReg := RecCount()
dbSelectArea("SC5")
dbSetOrder(2)
dbSeek(xFilial()+dtoc(MV_PAR01),.T.)
While !Eof() 
  IF SC5->C5_EMISSAO >= MV_PAR01 .AND. SC5->C5_EMISSAO <= MV_PAR02
    IF SC5->C5_TIPO == "N" 
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC5->C5_NUM)
		While SC5->C5_NUM == SC6->C6_NUM
                        Select SF4
                        dbSetOrder(1)
                        Seek xFilial()+sc6->C6_Tes
                        if sf4->f4_duplic=="N"
                          Select SC6
                          skip
                          loop
                        endif
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
			TMP->T_REPR := SA3->A3_NREDUZ
			TMP->T_CODR := SC5->C5_VEND1   
			nVlPed := SC6->C6_VALOR
			if sc6->c6_tes$'512*543*559*559'
				do Case
				Case sc5->c5_fator == "A"
					nFator := 2
				Case sc5->c5_fator == "B"
					nFator := 5
				Case sc5->c5_fator == "C"
					nFator := 1
				Case sc5->c5_fator == "S"
					nFator := 0
				Endcase
				if sc6->c6_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
					nAliqZF := 0.1065
				else
					nAliqZF := 0.07
				endif
				if nFator#0
					nTotZFR := (nVlPed/nfator)*nAliqZF
					nVlPed  := nVlPed-nTotZFR
				endif
			endif
                        if sc6->c6_blq#"R "
			    TMP->T_QTDTT := TMP->T_QTDTT + nVlPed
                        else
			    TMP->T_QTDTT := TMP->T_QTDTT + (nVlPed/SC6->C6_QTDVEN*SC6->C6_QTDENT)
                        endif
			TMP->T_PEDIDO:= SC5->C5_NUM
			dbSelectArea("SC6")
			ProcRegua(_nTotReg)			
			dbSkip()
	    	Endd
     	Endif
    Endif
   dbSelectArea("SC5")
   _nRegAtu++
   IncProc()
   dbSkip()
Endd

//+------------------------------------------------------------------------+
//¦ Inicia a Impressao do Relatorio                                        ¦
//+------------------------------------------------------------------------+

dbSelectArea("TMP")
index On TMP->T_CODR To &(cArq)
dbGotop()

nArq := CriaTrab({{"T_CODR"   ,"C",06,0},;
		  {"T_REPR"   ,"C",20,0},;
                  {"T_QTDTT"  ,"N",17,2}},.T.)

dbUseArea(.t.,,nArq,"TLP",.f.)
Index On TLP->T_CODR To &(nArq)
dbSelectArea("TMP")
While !Eof()
	dbSelectArea("TLP")
	dbSeek(TMP->T_CODR)
	If Found()
		RecLock("TLP",.F.)
	Else
		RecLock("TLP",.T.)
	Endif
	TLP->T_CODR := TMP->T_CODR
	TLP->T_REPR := TMP->T_REPR	
	TLP->T_QTDTT:= TLP->T_QTDTT+TMP->T_QTDTT
	dbSelectArea("TMP")
	dbSkip()
Endd

dbSelectArea("TLP")
Index On Descend(TLP->T_QTDTT) To &(nArq)
dbGotop()
While !Eof()
	GTGCL := GTGCL + TLP->T_QTDTT
	dbSkiP()
Endd

dbSelectArea("TLP")
dbGotop()

Set Device to Print

While !Eof()
	If Wln == 0
		ImpCabec()
	Endif
	@ wln,001 PSAY TLP->T_CODR
	@ wln,008 PSAY TLP->T_REPR
	@ wln,040 PSAY TLP->T_QTDTT   Picture "@E 99,999,999.99"
	@ wln,064 PSAY ((TLP->T_QTDTT/GTGCL)*100)  Picture "@E 999.99"
	TGQT := TGQT + TLP->T_QTDTT
	TGCL := TGCL + ((TLP->T_QTDTT/GTGCL)*100)
	Wln := Wln + 1
	If Wln > 58
		Impcabec()
	Endif
	dbSkip()
Endd
Wln := wln + 1
@ WLN,000 PSAY Replicate("-",080)
wln := wln + 1
@ Wln,000 PSAY "TOTAL GERAL: "
@ Wln,040 PSAY TGQT    Picture "@E 99,999,999.99"
@ wln,064 PSAY TGCL    Picture "@E 999.99"
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
//fErase(cArq+".DBF")
fErase(cArq+OrdBagExt())

dbSelectArea("TLP")
dbCloseArea()
fErase(nArq+".DBF")
fErase(nArq+OrdBagExt())

Return

Static Function ImpCabec()
Wln := 1
@ 000,000 PSAY Replicate("*",080)
@ 001,000 PSAY "*Leao /Matriz"
@ 001,060 PSAY "Folha..:"
@ 001,079 PSAY "*"
@ 002,000 PSAY "*SIGA/RFAT003/V.5.08 "
@ 002,027 PSAY "RANKING DAS VENDAS POR VENDEDOR"
@ 002,060 PSAY "Dt.Ref.:"
@ 002,069 PSAY ddatabase
@ 002,079 PSAY "*"
@ 003,000 PSAY "*Hora...:"
@ 003,010 PSAY Time()
@ 003,060 PSAY "Emissao:"
@ 003,069 PSAY Date()
@ 003,079 PSAY "*"
@ 004,000 PSAY Replicate("*",080)
@ 005,000 PSAY "Codigo | Representante            |(R$) Venda              |% Participacao| "
@ 006,000 PSAY Replicate("*",080)

Wln := 7 

Return

Return .t.
