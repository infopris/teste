#include "rwmake.ch"      
#IFNDEF WINDOWS
        #DEFINE PSAY SAY
#ENDIF

User Function rfat004()  

SetPrvt("C_STRING,C_NOMREL,C_PERG,C_DESC1,C_DESC2,C_DESC3")
SetPrvt("C_DESC4,L_DICDATA,A_ORDEM,L_HABCOMP,C_TAMANHO,C_ARQ")
SetPrvt("ARETURN,C_CABEC1,C_CABEC2,M_PAG,WLN,WFILTRO")
SetPrvt("C_SAVREG1,C_SAVREG2,N_CNTREG1,N_CNTREG2,N_CNTREG3,C_SAVSCR1")
SetPrvt("N_SAVCUR1,N_SAVROW1,N_SAVCOL1,C_SAVCOR1,N_AREA,N_IND")
SetPrvt("N_REC,NLASTKEY,C_COLOR,dDataINI")
SetPrvt("_nICms,_nMargem,_nMargemt,_nTotCust,_nMargPer,_nValSetor,_ValIni")
_nMargemt := 0;_nTotCust :=0

c_String  := "SC5" // Nome do Alias
c_NomRel  := "Margem por pedido - Detalhada                 "   // Nome do Relatorio
c_Perg    := "RFT004"    // Nome do Grupo de Perguntas
c_Desc1   := "Margem por Pedido - Detalhada                 " // Descricao do Relatorio - Titulo
c_Desc2   := ""
c_Desc3   := ""
c_Desc4   := ""
l_DicData := .F.   // Habilita o Dicionario de Dados
a_Ordem   := {}    // Array com as Ordens de Indexacao
l_HabComp := .T.   // Habilita a Compressao do Relatorio
c_Tamanho := "M"    // (P) 080  /  (M) 132  /  (G) 220
c_Arq     := ""    // Nome do arquivo com o relatorio impresso em disco

aReturn   := {"",1,"",1,2,1,"",1} // Formulario,N.vias,Destinatario,Formato,Midia,Porta,Filtro,Ordem

xDescri   := ""
xmes      := 0  
wln       := 0
TGQT      := 0
GTGQT     := 0
TGCL      := 1
GTGCL     := 1
lFirst    := 0
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
_nTotReg := 0

Return

Static Function PCliente()
dbSelectArea("SC5")
_nTotReg := RecCount()
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial()+MV_PAR01,.T.)
ProcRegua(_nTotReg)	
Set Device to Print

While !Eof() .And. SC5->C5_NUM == MV_PAR01
    IF SC5->C5_TIPO == "N" 
	@ wln,000 PSAY Replicate("-",080)
	wln := wln + 1
	@ wln,000 PSAY "Espelhos LEAO "
	@ wln,050 PSAY "Data: "
	@ wln,058 PSAY ddatabase
	wln := wln + 1
	@ wln,000 PSAY "-----Margem Detalhada do Pedido: "
	@ wln,033 PSAY SC5->C5_NUM
	@ wln,042 PSAY "Fator: "
	@ wln,050 PSAY SC5->C5_FATOR
	@ wln,055 PSAY "Frete: "
	@ wln,063 PSAY SC5->C5_TPFRETE
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	IF SC5->C5_TIPOCLI == "F"
		_nIcms := 18
	Else
	  If SA1->A1_EST $ "AC/AL/AM/AP/BA/CE/DF/ES/GO/MA/MS/MT/PA/PB/PI/SE/RN/RO/RR/TO"
		_nIcms := 7
	  ElseIf SA1->A1_EST $ "RJ/MG/PR/SC/RS"
		_nIcms := 12
	  ElseIf SA1->A1_EST == "SP"
		_nicms := 18
	Endif
      Endif
      dbSelectArea("SE4")
      dbSetOrder(1)
      dbSeek(xFilial()+SC5->C5_CONDPAG)
      dbSelectArea("SC6")
      dbSetOrder(1)
      dbSeek(xFilial()+SC5->C5_NUM)

      While SC5->C5_NUM == SC6->C6_NUM
      		dbSelectArea("SB1")
      		dbSetOrder(1)
      		dbSeek(xFilial()+SC6->C6_PRODUTO)		

			_ValIni := SC6->C6_VALOR
		If lFirst == 0
//		   @ wln,066 PSAY "Deflacao:"
//		   @ wln,074 PSAY SE4->E4_INDEFLA  Picture "@E 999.99"
		   wln := wln + 2
		Endif
		@ wln,000 PSAY "Produto:       Quant....: Val.Venda..:   Custo.: "
		wln := wln + 1
		@ wln,000 PSAY SC6->C6_PRODUTO
		@ wln,016 PSAY SC6->C6_QTDVEN    Picture "@E 999,999"
		@ wln,028 PSAY SC6->C6_VALOR     Picture "@E 99,999.99"
		@ wln,039 PSAY SB1->B1_CUSTD     Picture "@E 9,999.9999"
		wln:= wln + 1
		If SC5->C5_FATOR == "C"
			_nMargem := _ValIni-(SB1->B1_CUSTD*SC6->C6_QTDVEN)
			@ wln,000 PSAY "Val.Deflac...:"
			@ wln,015 PSAY _ValIni   Picture "@E 99,999.99"
			wln:=wln+1
			@ wln,000 PSAY "Custo Inicial:"
			@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
			wln:= wln + 1
			_nMargem := _nMargem-((_ValIni * _nIcms)/100)
			@ wln,000 PSAY "ICMS: "
			@ wln,006 PSAY _nICMS Picture "@E 99"
			@ wln,015 PSAY _nMargem   Picture "@E 99,999.99"
			wln:=wln+1
			If SC5->C5_COMIS1 > 0
				_nMargem := _nMargem-((_ValIni*SC5->C5_COMIS1)/100)
				@ wln,000 PSAY "Com.:"
				@ wln,006 PSAY SC5->C5_COMIS1   Picture "@E 999.99"
				@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
				wln:=wln+1
			Endif
	ElseIf SC5->C5_FATOR  == "B"
		_nMargem := _ValIni-(SB1->B1_CUSTD*SC6->C6_QTDVEN)
		@ wln,000 PSAY "Val.Deflac...:"
		@ wln,015 PSAY _ValIni    Picture "@E 99,999.99"
		wln := wln + 1
		@ wln,000 PSAY "Custo Inicial:"
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:= wln + 1
		_nMargem := _nMargem-((((_ValIni*_nIcms)/100)*20)/100)
		@ wln,000 PSAY "ICMS: "
		@ wln,006 PSAY _nICMS Picture "@E 99"
		@ wln,015 PSAY _nMargem   Picture "@E 99,999.99"
		wln:=wln+1
		If SC5->C5_COMIS1 > 0
			_nMargem := _nMargem-((_ValIni*SC5->C5_COMIS1)/100)
			@ wln,000 PSAY "Com.:"
			@ wln,006 PSAY SC5->C5_COMIS1   Picture "@E 999.99"
			@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
			wln:=wln+1
		Endif
	ElseIf SC5->C5_FATOR == "A"
		_nMargem := _ValIni-(SB1->B1_CUSTD*SC6->C6_QTDVEN)
		@ wln,000 PSAY "Val.Deflac...:"
		@ wln,015 PSAY _Valini   Picture "@E 99,999.99"
		wln := wln + 1
		@ wln,000 PSAY "Custo Inicial:"
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:=wln+1
		_nMargem := _nMargem-((((_ValIni*_nIcms)/100)*50)/100)
		@ wln,000 PSAY "ICMS: "
		@ wln,006 PSAY _nICMS Picture "@E 99"
		@ wln,015 PSAY _nMargem   Picture "@E 99,999.99"
		wln:=wln+1
		If SC5->C5_COMIS1 > 0
			_nMargem := _nMargem-((_ValIni*SC5->C5_COMIS1)/100)
			@ wln,000 PSAY "Com.:"
			@ wln,006 PSAY SC5->C5_COMIS1   Picture "@E 999.99"
			@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
			wln:=wln+1
		Endif
	Endif
	dbSelectArea("SX6")
	dbSetOrder(1)
	dbSeek(xFilial()+"MV_PCI")
	If SC5->C5_FATOR == "C"
		_nMargem := _nMargem-((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)
		@ wln,000 PSAY "PCI: "
		@ wln,007 PSAY AllTrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem Picture "@E 99,999.99"
		wln := wln + 1
		dbSeek(xFilial()+"MV_CPMF")
		_nMargem := _nMargem-((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)
		@ wln,000 PSAY "CPMF: "
		@ wln,008 PSAY Alltrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:=wln+1
           If SC5->C5_TPFRETE  == "C"
		dbSeek(xFilial()+"MV_FRETE")
		_nMargem := _nMargem-((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)
		@ wln,000 PSAY "Frete: "
		@ wln,007 PSAY Alltrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:=wln+1
	   Endif
	ElseIf SC5->C5_FATOR == "B"
		_nMargem := _nMargem-((((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)*20)/100)
		@ wln,000 PSAY "PCI: "
		@ wln,007 PSAY AllTrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem Picture "@E 99,999.99"
		wln := wln + 1
		dbSeek(xFilial()+"MV_CPMF")
		_nMargem := _nMargem-((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)
		@ wln,000 PSAY "CPMF: "
		@ wln,008 PSAY Alltrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:=wln+1
	   If SC5->C5_TPFRETE == "C"
		dbSeek(xFilial()+"MV_FRETE")
		_nMargem := _nMargem-((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)
		@ wln,000 PSAY "Frete: "
		@ wln,007 PSAY Alltrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:=wln+1
	   Endif
	ElseIf SC5->C5_FATOR == "A"
		_nMargem := _nMargem-((((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)*50)/100)
		@ wln,000 PSAY "PCI: "
		@ wln,007 PSAY AllTrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem Picture "@E 99,999.99"
		wln := wln + 1
		dbSeek(xFilial()+"MV_CPMF")
		_nMargem := _nMargem-((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)
		@ wln,000 PSAY "CPMF: "
		@ wln,008 PSAY Alltrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:=wln+1
	   If SC5->C5_TPFRETE == "C"
		dbSeek(xFilial()+"MV_FRETE")
		_nMargem := _nMargem-((_ValIni*(Val(Alltrim(SX6->X6_CONTEUD))))/100)
		@ wln,000 PSAY "Frete: "
		@ wln,007 PSAY Alltrim(SX6->X6_CONTEUD)
		@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
		wln:=wln+1
	   Endif
	Endif
	_nMargemt := _nMargemt + _nMargem  
	@ wln,000 PSAY "Liq.(R$):"
	@ wln,015 PSAY _nMargem  Picture "@E 99,999.99"
	_nTotCust :=(_nTotCust + (SB1->B1_CUSTD * SC6->C6_QTDVEN))
	@ wln,025 PSAY (SB1->B1_CUSTD*SC6->C6_QTDVEN) Picture "@E 99,999.99"
	@ wln,035 PSAY (_nMargem /(SB1->B1_CUSTD*SC6->C6_QTDVEN))*100   Picture "@E 999.99"
	@ wln,042 PSAY "%"
	wln := wln + 1
	@ wln,000 PSAY Replicate("-",080)
	wln := wln + 1
	lFirst := lFirst + 1
	IncProc(StrZero(_nTotReg,6))
	dbSelectArea("SC6")
	dbSkip()
       Endd	
	_nMargPer := (_nMargemt/_nTotCust)*100
	@ wln,000 PSAY "Margem..:"
	@ wln,015 PSAY _nMargPer  Picture "@E 999.99"
	@ wln,022 PSAY "%"
	@ wln,030 PSAY "Total/Itens:"
	@ wln,048 PSAY lFirst Picture "999"
	wln := wln + 1
	@ wln,000 PSAY Replicate("-",080)
   Endif
   DbSelectArea("SC5")
   dbSkip()
Endd

Set Device to Screen

If aReturn[5]==1
   Set Print to
   dbCommitAll()
   OurSpool(c_Arq)
EndIf

MS_FLUSH()

Return

Return .t.
