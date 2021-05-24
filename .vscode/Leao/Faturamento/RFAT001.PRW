#include "rwmake.ch"
#DEFINE ENTER Chr(13)+Chr(10)
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function rfat001()  // Estatistica Mensal das Vendas por Representante

SetPrvt("C_STRING,C_NOMREL,C_PERG,C_DESC1,C_DESC2,C_DESC3")
SetPrvt("C_DESC4,L_DICDATA,A_ORDEM,L_HABCOMP,C_TAMANHO,C_ARQ")
SetPrvt("ARETURN,C_CABEC1,C_CABEC2,M_PAG,WLN,WFILTRO,NORDEM,AORDEM")
SetPrvt("WCOND,WPULA,WWIDPAGE,A_QUEBRA,A_TOTA01,A_TOTA02")
SetPrvt("A_TOTA03,A_TOTA04,A_TOTA05,A_TOTA06,A_TOTA07,A_TOTA08")
SetPrvt("A_TOTA09,A_TOTA10,A_TOTA11,A_TOTA12,A_TOTG01,A_TOTG02")
SetPrvt("A_TOTG03,A_TOTG04,A_TOTG05,A_TOTG06,A_TOTG07,A_TOTG08")
SetPrvt("A_TOTG09,A_TOTG10,A_TOTG11,A_TOTG12,XDESCRI,XMES")
SetPrvt("XVENDE,XDATINI,XDATFIM,XDATREA,XSN,C_MSGREG")
SetPrvt("C_SAVREG1,C_SAVREG2,N_CNTREG1,N_CNTREG2,N_CNTREG3,C_SAVSCR1")
SetPrvt("N_SAVCUR1,N_SAVROW1,N_SAVCOL1,C_SAVCOR1,N_AREA,N_IND")
SetPrvt("N_REC,NLASTKEY,C_COLOR,dDataINI,lResumo,cTMP1")

c_String  := "SC5" // Nome do Alias
c_NomRel  := "Estatistica Mensal das Vendas por Representante"  // Nome do Relatorio
c_Perg    := "RFT001"    // Nome do Grupo de Perguntas
c_Desc1   := "Estatistica Mensal das Vendas por Representante" // Descricao do Relatorio - Titulo
c_Desc2   := "     Este Programa irá imprimir um Relatorio contendo todas as Com"    // Primeira linha da Descricao
c_Desc3   := "pras efetuadas. Totalizando por Grupo, Mes á Mes, e Seu Percentual"    // Segunda  linha da Descricao
c_Desc4   := "em Relação ao Valor Total."    // Terceira linha da Descricao
l_DicData := .F.   // Habilita o Dicionario de Dados
a_Ordem   := {}    // Array com as Ordens de Indexacao
l_HabComp := .T.   // Habilita a Compressao do Relatorio
c_Tamanho := "G"    // (P) 080  /  (M) 132  /  (G) 220
c_Arq     := ""    // Nome do arquivo com o relatorio impresso em disco
//aOrdem    := {"Por Cliente","Por Data Mov","Grupo de Clientes"}
aOrdem    := {"Por Cliente","Por Data Mov"}
nOrdem    := 0

aReturn   := {"",1,"",2,2,1,"",1} // Formulario,N.vias,Destinatario,Formato,Midia,Porta,Filtro,Ordem


xDescri   := ""
xmes      := 0
wln       := 0
TGQT      := 0
TGQ1:=TGQ2:=TGQ3:=TGQ4:=TGQ5:=TGQ6:=TGQ7:=TGQ8:=TGQ9:=TGQa:=TGQb:=TGQc:=0
TTQ1:=TTQ2:=TTQ3:=TTQ4:=TTQ5:=TTQ6:=TTQ7:=TTQ8:=TTQ9:=TTQa:=TTQb:=TTQc:=0
TQ1:=TQ2:=TQ3:=TQ4:=TQ5:=TQ6:=TQ7:=TQ8:=TQ9:=TQa:=TQb:=TQc:=0
SQ1:=SQ2:=SQ3:=SQ4:=SQ5:=SQ6:=SQ7:=SQ8:=SQ9:=SQa:=SQb:=SQc:=0
TGCL:=STGCL:=0
TGLL:=0
xDescri   := ""
xsn := ""

n_Area    := Alias()
n_Ind     := IndexOrd()
n_Rec     := Recno()
nLastKey  := 0

if select("TMP")<>0
	Select TMP
	use
endif

//+--------------------------------------------------------------------------+
//¦ Verifica as Perguntas Selecionadas no SX1                                ¦
//+--------------------------------------------------------------------------+
// mv_par01  - Emissao de
// mv_par02  - Emissao ate
// mv_par03  - Repres. de
// mv_par04  - Repres. ate
// mv_par05  - Da Regiao
// mv_par06  - Ate Regiao
// mv_par07  - Descr.Cliente
// mv_par08  - Estado  de
// mv_par09  - Estado  de
// mv_par10  - Agrupar por coordenador ?
// mv_par11  - Agrupar por grupo de clientes ?
//+--------------------------------------------------------------------------+
Pergunte(c_Perg,.F.)

//+--------------------------------------------------------------------------+
//¦ Envia Controle para Funcao SetPrint                                      ¦
//+--------------------------------------------------------------------------+

c_Arq := Setprint(c_String,c_Perg,c_Perg,@c_Desc1,c_Desc2,c_Desc3,c_Desc4,;
l_DicData,aOrdem,l_HabComp,c_Tamanho)

If LastKey() == 27 .or. nLastKey == 27
	// Ret_Int()
	Return
EndIf


SetDefault(aReturn,c_String)

if MsgBox ("Deseja verificar status do cliente (ex.:ativo,inativo,...","Escolha","YESNO")
	Processa({|| u_VerAtiv() })
endif
lResumo := .f.
//if MsgBox ("Deseja imprimir somente o resumo por vendedor ?","Escolha","YESNO")
//	lResumo := .t.
//endif
Processa({|| PCliente() })

Return

Static Function PCliente()



Local _nTotReg := 0
Local _nRegAtu := 0

ddataIni := firstday(ddatabase-366)

cArq := CriaTrab({{"T_CODI"   ,"C",06,0},;
{"T_REPR"   ,"C",15,0},;
{"T_COOR"   ,"C",06,0},;
{"T_CODC"   ,"C",06,0},;
{"T_LOJA"   ,"C",02,0},;
{"T_CLIE"   ,"C",20,0},;
{"T_GRPCLI" ,"C",08,0},;
{"T_DESCGRP","C",20,0},;
{"T_CLASS"  ,"C",06,0},;
{"T_RANK"   ,"N",03,0},;
{"T_EST"    ,"C",02,0},;
{"T_SEG"    ,"C",06,0},;
{"T_ULTC"   ,"D",08,0},;
{"T_QTD01"  ,"N",17,2},;
{"T_QTD02"  ,"N",17,2},;
{"T_QTD03"  ,"N",17,2},;
{"T_QTD04"  ,"N",17,2},;
{"T_QTD05"  ,"N",17,2},;
{"T_QTD06"  ,"N",17,2},;
{"T_QTD07"  ,"N",17,2},;
{"T_QTD08"  ,"N",17,2},;
{"T_QTD09"  ,"N",17,2},;
{"T_QTD10"  ,"N",17,2},;
{"T_QTD11"  ,"N",17,2},;
{"T_QTD12"  ,"N",17,2},;
{"T_QTDTT"  ,"N",17,2}},.T.)

dbUseArea(.t.,,cArq,"TMP",.f.)
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Define a ordem de impress„o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nOrdem := aReturn [8]
cTemp := CriaTrab(nil,.f.)
//index On TMP->T_CODC+TMP->T_LOJA+dtos(TMP->T_ULTC) To &(cTemp)
IndRegua("TMP", cTemp, "TMP->T_CODC+TMP->T_LOJA+dtos(TMP->T_ULTC)", , , "Selecionando Registros...")

dbSelectArea("SC5")
//set filter to C5_VEND1='9602'
_nTotReg := RecCount()
dbSelectArea("SC5")
dbSetOrder(2)
set softseek on
//dDataIni := iif(year(mv_par01)<year(dDataIni),mv_par01,dDataIni)
dDataIni := mv_par01
Seek xFilial()+dtos(ddataini)
set softseek off
ProcRegua(_nTotReg)
nMes01 := nMes02 := nMes03:= nMes04:= nMes05:= nMes06 := space(9)
nMes07 := nMes08 := nMes09:= nMes10:= nMes11:= nMes12 := space(9)
//set filter to C5_NUM='069124'
While !Eof()
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SC5->(C5_CLIENTE+C5_LOJACLI))
	dbSelectArea("SC5")
	If SA1->A1_VEND < MV_PAR03 .OR. SA1->A1_VEND > MV_PAR04
		skip
		loop
	endif
	if (sa1->a1_regiao < mv_par05 .or. sa1->a1_regiao > mv_par06) .and. !empty(sa1->a1_regiao)
		skip
		Loop
	endif
	IF SC5->C5_TIPO $ "N*C"
		IF SC5->C5_EMISSAO >= MV_PAR01 .And. SC5->C5_EMISSAO <= MV_PAR02
			if trim(sa1->a1_regiao) >= trim(mv_par05) .and. sa1->a1_regiao <= mv_par06;
				.and. sa1->a1_est    >= mv_par08 .and. sa1->a1_est    <= mv_par09
				//				dult := ctod("0")
				//				Verult()
				
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek(xFilial()+SC5->C5_NUM)
				While SC5->C5_NUM == SC6->C6_NUM .and. !eof()
					cTes := sc6->C6_Tes
					if left(C6_NUM,1)="P"
						xReg := Recno()
						dbSeek(xFilial()+"0"+substr(SC5->C5_NUM,2,5))
						cTes := sc6->C6_Tes
						dbGoTo(xReg)
					endif
					nTotZFR := 0
					nFator :=1
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
					if sc6->c6_tes$'512*543*559'
						if sc6->c6_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
							nAliqZF := 0.1065
						else
							nAliqZF := 0.07
						endif
						if nFator#0
							//							nTotZFR := (SC6->C6_VALOR/nfator)*nAliqZF
							nTotZFR := (SC6->C6_VALOR)*nAliqZF
						endif
					endif
					
					Select SF4
					Seek xFilial()+cTes
					if f4_duplic="N"
						dbSelectArea("SC6")
						skip
						loop
					endif
					dbSelectArea("TMP")
					dbseek(SC6->(C6_CLI+C6_LOJA))
					if eof()
						RecLock("TMP",.t.)
						TMP->T_CODC := SC5->C5_CLIENTE
						TMP->T_LOJA := SC5->C5_LOJACLI
					else
						RecLock("TMP",.f.)
					Endif
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek(xFilial()+SA1->A1_VEND)
					dbSelectArea("SA1")
					dbSetOrder(1)
					dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
					cDescGrp := cUf := ""
					if !empty(A1_XGRPCLI)
						cGrp := A1_XGRPCLI
						nReg := recno()
						dbSeek(xFilial()+cGrp)
						if !eof()
							cDescGrp := A1_NREDUZ
							cUf		 := A1_EST
						endif
						dbGoto(nReg)
					endif
					cDescGrp := iif(cDescGrp="",A1_NREDUZ,cDescGrp)
					Select SZ1
					dbSetOrder(3)
					Seek xFilial()+SA1->A1_XGRPCLI
					
					//					TMP->T_COOR := iif(SC5->C5_SUPER<="000000",SA3->A3_SUPER,SC5->C5_SUPER)
					TMP->T_COOR := SA3->A3_SUPER
					TMP->T_CODI := SA1->A1_VEND
					TMP->T_REPR := SA3->A3_NREDUZ
					TMP->T_RANK := SZ1->Z1_RANK
					TMP->T_GRPCLI:= iif(!empty(SA1->A1_XGRPCLI),SA1->A1_XGRPCLI,SC5->C5_CLIENTE+SC5->C5_LOJACLI)
					TMP->T_DESCGRP:= cDescGrp
					if SZ1->Z1_RANK <> 0
						TMP->T_CLASS:= '0'+strzero(SZ1->Z1_RANK,4)+SA1->A1_SATIV8
					else
						Do Case
							Case SA1->A1_SATIV8='D'
								TMP->T_CLASS:= '1'+SA1->A1_SATIV8
							Case SA1->A1_SATIV8='A'
								TMP->T_CLASS:= '2'+SA1->A1_SATIV8
							Case SA1->A1_SATIV8='R'
								TMP->T_CLASS:= '3'+SA1->A1_SATIV8
							Case SA1->A1_SATIV8='I'
								TMP->T_CLASS:= '4'+SA1->A1_SATIV8
							Case SA1->A1_SATIV8='X'
								TMP->T_CLASS:= '5'+SA1->A1_SATIV8
							Case SA1->A1_SATIV8='N'
								TMP->T_CLASS:= '6'+SA1->A1_SATIV8
						Endcase
					endif
					TMP->T_EST  := if(!empty(cUf) .and. mv_par11=1,cUf,sa1->a1_est)
					TMP->T_SEG  := SA1->A1_SATIV1
					if mv_par07=2
						TMP->T_CLIE := SA1->A1_NREDUZ
					else
						TMP->T_CLIE := SA1->A1_NOME
					endif
					if left(sc6->c6_blq,1)#"R"
						nVal := sc6->c6_valor - nTotZfr
					else
						nVal := ((SC6->C6_VALOR-nTotZfr)/SC6->C6_QTDVEN*SC6->C6_QTDENT)
					endif
					//					if dult==ctod("0")
					TMP->T_ULTC := SA1->A1_XULTVEN //SA1->A1_ULTCOM
					//					else
					//						TMP->T_ULTC := dult
					//					endif
					If Month(SC5->C5_EMISSAO) == 1
						TMP->T_QTD01 := TMP->T_QTD01 + nVal
						nMes01 := "Jan/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 2
						TMP->T_QTD02 := TMP->T_QTD02 + nVal
						nMes02 := "Fev/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 3
						TMP->T_QTD03 := TMP->T_QTD03 + nVal
						nMes03 := "Mar/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 4
						TMP->T_QTD04 := TMP->T_QTD04 + nVal
						nMes04 := "Abr/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 5
						TMP->T_QTD05 := TMP->T_QTD05 + nVal
						nMes05 := "Mai/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 6
						TMP->T_QTD06 := TMP->T_QTD06 + nVal
						nMes06 := "Jun/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 7
						TMP->T_QTD07 := TMP->T_QTD07 + nVal
						nMes07 := "Jul/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 8
						TMP->T_QTD08 := TMP->T_QTD08 + nVal
						nMes08 := "Ago/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 9
						TMP->T_QTD09 := TMP->T_QTD09 + nVal
						nMes09 := "Set/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 10
						TMP->T_QTD10 := TMP->T_QTD10 + nVal
						nMes10 := "Out/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 11
						TMP->T_QTD11 := TMP->T_QTD11 + nVal
						nMes11 := "Nov/"+strzero(year(SC5->C5_EMISSAO),4)
					ElseIf Month(SC5->C5_EMISSAO) == 12
						TMP->T_QTD12 := TMP->T_QTD12 + nVal
						nMes12 := "Dez/"+strzero(year(SC5->C5_EMISSAO),4)
					Endif
					tmp->T_QTDTT := tmp->T_QTDTT + nVal
					dbSelectArea("SC6")
					dbSkip()
				Enddo
			Endif
		Endif
	Endif
	_nRegAtu++
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6))
	dbSelectArea("SC5")
	dbSkip()
Endd

// Função para verificar o último faturamento (venda) do cliente
// Separei do programa pois a cada pedido o sistema fazia uma verificação (Luiz-07/11/2016)
Select Tmp
dbgotop()
Do while !eof() .and. 1==2 // Incluida na função Verifica ultima venda
	//	TMP->T_CODC := SC5->C5_CLIENTE
	//	TMP->T_LOJA := SC5->C5_LOJACLI
	dult := ctod("0")
	Verult(TMP->T_CODC)
	if dult==ctod("0")
		TMP->T_ULTC := SA1->A1_ULTCOM
	else
		TMP->T_ULTC := dult
	endif
	Select Tmp
	skip
Enddo

//+------------------------------------------------------------------------+
//¦ Inicia a Impressao do Relatorio                                        ¦
//+------------------------------------------------------------------------+



dbSelectArea("TMP")
cTemp1 := CriaTrab(nil,.f.)
//index On TMP->T_CODC+TMP->T_LOJA+TMP->T_CODI To &(cTemp1)
IndRegua("TMP", cTemp1, "TMP->T_CODC+TMP->T_LOJA+TMP->T_CODI", , , "Selecionando Registros...")



dbGotop()
dbSelectArea("SA1")
_nTotReg := RecCount()
dbSelectArea("SA1")
dbSetOrder(1)
dbGotop()
While !Eof()
	if (sa1->a1_regiao < mv_par05 .or. sa1->a1_regiao > mv_par06) .and. !empty(sa1->a1_regiao)
		skip
		Loop
	endif
	
	If SA1->A1_VEND >= MV_PAR03 .And. SA1->A1_VEND <= MV_PAR04
		cDescGrp := ""
		if !empty(A1_XGRPCLI)
			cGrp := A1_XGRPCLI
			nReg := recno()
			dbSeek(xFilial()+cGrp)
			if !eof()
				cDescGrp := A1_NREDUZ
			endif
			dbGoto(nReg)
		endif
		cDescGrp := iif(cDescGrp="",A1_NREDUZ,cDescGrp)
		
		dbSelectArea("TMP")
		dbSeek(SA1->A1_COD+SA1->A1_LOJA)
		
		If !Found()
			Select SZ1
			dbSetOrder(3)
			Seek xFilial()+SA1->A1_XGRPCLI
			dbSelectArea("SA3")
			dbSetOrder(1)
			dbSeek(xFilial()+SA1->A1_VEND)
			dbSelectArea("TMP")
			RecLock("TMP",.T.)
			TMP->T_CODI := SA1->A1_VEND
			TMP->T_REPR := SA3->A3_NREDUZ
			TMP->T_GRPCLI:= iif(!empty(SA1->A1_XGRPCLI),SA1->A1_XGRPCLI,SA1->(A1_COD+A1_LOJA))
			TMP->T_DESCGRP:= cDescGrp
			TMP->T_RANK := SZ1->Z1_RANK
			if SZ1->Z1_RANK <> 0
				TMP->T_CLASS:= '0'+strzero(SZ1->Z1_RANK,4)+SA1->A1_SATIV8
			else
				Do Case
					Case SA1->A1_SATIV8='D'
						TMP->T_CLASS:= '1'+SA1->A1_SATIV8
					Case SA1->A1_SATIV8='A'
						TMP->T_CLASS:= '2'+SA1->A1_SATIV8
					Case SA1->A1_SATIV8='R'
						TMP->T_CLASS:= '3'+SA1->A1_SATIV8
					Case SA1->A1_SATIV8='I'
						TMP->T_CLASS:= '4'+SA1->A1_SATIV8
					Case SA1->A1_SATIV8='X'
						TMP->T_CLASS:= '5'+SA1->A1_SATIV8
					Case SA1->A1_SATIV8='N'
						TMP->T_CLASS:= '6'+SA1->A1_SATIV8
				Endcase
			endif
			TMP->T_EST  := SA1->A1_EST
			TMP->T_SEG  := SA1->A1_SATIV1
			TMP->T_CODC := SA1->A1_COD
			TMP->T_LOJA := SA1->A1_LOJA
			TMP->T_COOR := iif(val(T_COOR)==0,SA3->A3_SUPER,T_COOR)
			if mv_par07==2
				TMP->T_CLIE := SA1->A1_NREDUZ
			else
				TMP->T_CLIE := SA1->A1_NOME
			endif
			TMP->T_ULTC := SA1->A1_XULTVEN //SA1->A1_ULTCOM
//			TMP->T_ULTC := SA1->A1_ULTCOM
			MsUnlock()
		Endif
	Endif
	ProcRegua(_nTotReg)
	dbSelectArea("SA1")
	dbSkip()
	_nRegAtu++
	IncProc()
Endd

Select Tmp
copy to \gerencia\vendas_rep_mesXmes
ResGrp()
if MsgBox ("Deseja gerar planilha Excel ?","Escolha","YESNO")
	GeraExcel()
endif


Select SA3
dbSetOrder(1)
Set softseek on
Seek xFilial()+mv_par03
lVendIni := lVendFim := .f.
skip-1
if bof()
	lVendIni := .t.
endif
Seek xFilial()+mv_par04
Set softseek off
skip+1
if eof()
	lVendFim := .t.
endif

RptStatus({|| RptDetail() })
****************************
Static Function RptDetail() // Funcao para imprimir o Relatorio
****************************

if lResumo
	Resum1()
	Return
endif
if mv_par10==1
	Resumo()
	dbSelectArea("TMP")
	dbCloseArea()
	//fErase(cArq+".DBF")
	fErase(cArq+OrdBagExt())
	Return
endif

dbSelectArea("TMP")

Do Case
	Case nOrdem == 1 .or. nOrdem == 3
		If mv_par11=2 //Agrupar por grupo de clientes ?
			//			index On T_GRPCLI To &(cArq) //TMP->T_CODI+TMP->T_CLIE To &(cArq)
			//			index On TMP->T_CODI+TMP->T_CLIE To &(cArq)
		else
			//			index On T_CODI+T_GRPCLI To &(cArq)
			// index On T_CODI+T_DESCGRP To &(cArq)
			//			index On T_CODI+T_DESCGRP+T_GRPCLI To &(cArq)
		endif
		//		index On TMP->T_CODI+TMP->T_CLASS+TMP->T_EST+TMP->T_CLIE To &(cArq)
		cTemp2 := CriaTrab(nil,.f.)
//		index On TMP->T_CODI+TMP->T_CLASS+TMP->T_DESCGRP+tmp->T_GrpCli+TMP->T_EST To &(cTemp2)  // Alterado em 02/03/2018 Luiz Eduardo - solicitação do Irineu
		IndRegua("TMP", cTemp2, "T_CODI+T_CLASS+T_DESCGRP+T_GrpCli+T_EST", , , "Selecionando Registros...")
		//		copy to \xTemp
		//		return
	Case nOrdem == 2
		cTemp3 := CriaTrab(nil,.f.)
//		index On TMP->T_CODI+T_CLIE+dtos(TMP->T_ULTC) To &(cTemp3)
		IndRegua("TMP", cTemp3, "TMP->T_CODI+T_CLIE+dtos(TMP->T_ULTC)", , , "Selecionando Registros...")

		Do while !eof()
			cCli := TMP->T_CODI+T_CLIE
			dDt  := TMP->T_ULTC
			n    := 0
			nrec := recno()
			nTot01 := ntot02 := nTot03 := ntot04 := nTot05 := nTot06 := 0
			nTot07 := ntot08 := nTot09 := ntot10 := nTot11 := nTot12 := 0
			do while !eof() .and. TMP->T_CODI+T_CLIE==cCli
				ntot01 := ntot01 + T_QTD01
				ntot02 := ntot02 + T_QTD02
				ntot03 := ntot03 + T_QTD03
				ntot04 := ntot04 + T_QTD04
				ntot05 := ntot05 + T_QTD05
				ntot06 := ntot06 + T_QTD06
				ntot07 := ntot07 + T_QTD07
				ntot08 := ntot08 + T_QTD08
				ntot09 := ntot09 + T_QTD09
				ntot10 := ntot10 + T_QTD10
				ntot11 := ntot11 + T_QTD11
				ntot12 := ntot12 + T_QTD12
				if TMP->T_ULTC >dDt
					dDt := TMP->T_ULTC
				endif
				n      :=n+1
				nrec1  := recno()
				skip
			enddo
			if n>1
				goto nRec
				do while !eof() .and. TMP->T_CODI+T_CLIE==cCli
					if rlock() .and. recno()#nRec1
						dele
					endif
					if recno()==nRec1
						reclock("tmp",.f.)
						tmp->t_ultc  := dDt
						tmp->t_qtd01 := ntot01
						tmp->t_qtd02 := ntot02
						tmp->t_qtd03 := ntot03
						tmp->t_qtd04 := ntot04
						tmp->t_qtd05 := ntot05
						tmp->t_qtd06 := ntot06
						tmp->t_qtd07 := ntot07
						tmp->t_qtd08 := ntot08
						tmp->t_qtd09 := ntot09
						tmp->t_qtd10 := ntot10
						tmp->t_qtd11 := ntot11
						tmp->t_qtd12 := ntot12
						MsUnLock()
					endif
					skip
				enddo
			endif
		Enddo
		cTemp4 := CriaTrab(nil,.f.)
//		index On TMP->T_CODI+dtos(TMP->T_ULTC) To &(cTemp4)
		IndRegua("TMP", cTemp4, "TMP->T_CODI+dtos(TMP->T_ULTC)", , , "Selecionando Registros...")
EndCase


SetRegua(Reccount()) //Ajusta numero de elementos da regua de relatorios

Set Device to Print
nRep := TMP->T_CODI
nAt := nIn := nRe := nDes := nNov := 0
lFirst := 1
dbGotop()

While !Eof()
	IncRegua()
	If Wln == 0
		ImpCabec()
	Endif
	If lFirst == 1 .and. !lResumo
		nAt := nIn := nRe := nDes := nNov := 0
		@wln,000 PSAY "Repres.: "
		@wln,009 PSAY TMP->T_CODI+" - "+TMP->T_REPR
		wln:=wln+1
		@wln,000 PSAY Replicate("-",220)
		wln:=wln+1
		lFirst := lFirst + 1
	Endif
	cCodCli := TMP->T_CODC
	//	cClie   := TMP->T_CLIE  // LE 02/03/2018
	cClie   := TMP->T_DESCGRP
	cClass  := iif(left(TMP->T_CLASS,1)="0",substr(TMP->T_CLASS,6,1),substr(TMP->T_CLASS,2,1))
	//	Do while !eof() .and. TMP->T_CLIE==cClie
	nTot01 := nTot02 := nTot03 := nTot04 := nTot05 := nTot06 := nTot07 := nTot08 := nTot09 := nTot10 := nTot11 := nTot12 := nTot13 := nTot14 := 0
	//	Do while !eof() .and. iif(nOrdem<>3,TMP->T_CodC==cCodCli,TMP->T_Clie==cClie)
	Do while !eof() .and. iif(nOrdem=5,TMP->T_CodC==cCodCli,TMP->T_DESCGRP==cClie)  // LE 02/03/2018
		
		if !lResumo
			nTot01 := nTot02 := nTot03 := nTot04 := nTot05 := nTot06 := nTot07 := nTot08 := nTot09 := nTot10 := nTot11 := nTot12 := nTot13 := nTot14 := 0
			if mv_par11=1  // Agrupado pelo Grupo de Clientes
				cGrpCli = tmp->T_GrpCli
				Select SA1
				dbSetOrder(1)
				Seek xFilial()+cGrpCli
				Select SZ1
				dbSetOrder(3)
				Seek xFilial()+cGrpCli
				/*
				Select TMP
				If rlock()
				if tmp->T_RANK <> 0
				TMP->T_CLASS:= '0'+strzero(SZ1->Z1_RANK,4)+SA1->A1_SATIV8
				else
				Do Case
				Case SA1->A1_SATIV8='D'
				TMP->T_CLASS:= '1'+SA1->A1_SATIV8
				Case SA1->A1_SATIV8='A'
				TMP->T_CLASS:= '2'+SA1->A1_SATIV8
				Case SA1->A1_SATIV8='R'
				TMP->T_CLASS:= '3'+SA1->A1_SATIV8
				Case SA1->A1_SATIV8='I'
				TMP->T_CLASS:= '4'+SA1->A1_SATIV8
				Endcase
				endif
				Endif
				*/
				//				cClass  := substr(TMP->T_CLASS,2,1)
				cClass  := iif(left(TMP->T_CLASS,1)="0",substr(TMP->T_CLASS,6,1),substr(TMP->T_CLASS,2,1))
				Select Tmp
				//				cLin1 := T_GRPCLI+"  "+sa1->a1_nreduz+"("+substr(TMP->T_CLASS,2,1)+")"+" "+TMP->T_EST+" "+TMP->T_SEG
				//				cLin1 := T_GRPCLI+" "+TMP->T_SEG+" "+sa1->a1_nreduz+""+substr(TMP->T_CLASS,2,1)+" "+TMP->T_EST
				cLin1 := T_GRPCLI+" "+TMP->T_SEG+" "+sa1->a1_nreduz+""+cClass+" "+TMP->T_EST
				cLin2 := TMP->T_ULTC
				do while !eof() .and. cGrpCli = tmp->T_GrpCli
					nTot01 += TMP->T_QTD01
					nTot02 += TMP->T_QTD02
					nTot03 += TMP->T_QTD03
					nTot04 += TMP->T_QTD04
					nTot05 += TMP->T_QTD05
					nTot06 += TMP->T_QTD06
					nTot07 += TMP->T_QTD07
					nTot08 += TMP->T_QTD08
					nTot09 += TMP->T_QTD09
					nTot10 += TMP->T_QTD10
					nTot11 += TMP->T_QTD11
					nTot12 += TMP->T_QTD12
					nTot13 += (TMP->T_QTD01+TMP->T_QTD02+TMP->T_QTD03+TMP->T_QTD04+TMP->T_QTD05+TMP->T_QTD06+TMP->T_QTD07+TMP->T_QTD08+TMP->T_QTD09+TMP->T_QTD10+TMP->T_QTD11+TMP->T_QTD12)
					TGQ1 := TGQ1 + TMP->T_QTD01
					TGQ2 := TGQ2 + TMP->T_QTD02
					TGQ3 := TGQ3 + TMP->T_QTD03
					TGQ4 := TGQ4 + TMP->T_QTD04
					TGQ5 := TGQ5 + TMP->T_QTD05
					TGQ6 := TGQ6 + TMP->T_QTD06
					TGQ7 := TGQ7 + TMP->T_QTD07
					TGQ8 := TGQ8 + TMP->T_QTD08
					TGQ9 := TGQ9 + TMP->T_QTD09
					TGQa := TGQa + TMP->T_QTD10
					TGQb := TGQb + TMP->T_QTD11
					TGQc := TGQc + TMP->T_QTD12
					skip
				Enddo
				@ wln,000 PSAY cLin1
				@ wln,046 PSAY cLin2
				@ wln,058 PSAY nTot01   Picture "@E 99999,999"
				@ wln,069 PSAY nTot02   Picture "@E 99999,999"
				@ wln,080 PSAY nTot03   Picture "@E 99999,999"
				@ wln,091 PSAY nTot04   Picture "@E 99999,999"
				@ wln,102 PSAY nTot05   Picture "@E 99999,999"
				@ wln,113 PSAY nTot06   Picture "@E 99999,999"
				@ wln,124 PSAY nTot07   Picture "@E 99999,999"
				@ wln,135 PSAY nTot08   Picture "@E 99999,999"
				@ wln,146 PSAY nTot09   Picture "@E 99999,999"
				@ wln,157 PSAY nTot10   Picture "@E 99999,999"
				@ wln,168 PSAY nTot11   Picture "@E 99999,999"
				@ wln,179 PSAY nTot12   Picture "@E 99999,999"
				@ wln,190 PSAY nTot13     Picture "@R 99999,999"
				@ wln,201 PSAY nTot13/12  Picture "@R 999,999"
				IF sz1->Z1_RANK<>0
					@ wln,215 PSAY sz1->Z1_RANK  Picture "@R 999"
				endif
				TGQT := TGQT + nTot13//(TMP->T_QTD01+TMP->T_QTD02+TMP->T_QTD03+TMP->T_QTD04+TMP->T_QTD05+TMP->T_QTD06+TMP->T_QTD07+TMP->T_QTD08+TMP->T_QTD09+TMP->T_QTD10+TMP->T_QTD11+TMP->T_QTD12)
				ttq1 += iif(nTot01#0,1,0)
				ttq2 += iif(nTot02#0,1,0)
				ttq3 += iif(nTot03#0,1,0)
				ttq4 += iif(ntot04#0,1,0)
				ttq5 += iif(nTot05#0,1,0)
				ttq6 += iif(nTot06#0,1,0)
				ttq7 += iif(nTot07#0,1,0)
				ttq8 += iif(nTot08#0,1,0)
				ttq9 += iif(nTot09#0,1,0)
				ttqa += iif(nTot10#0,1,0)
				ttqb += iif(nTot11#0,1,0)
				ttqc += iif(nTot12#0,1,0)
				
				sq1 += iif(nTot01#0,1,0)
				sq2 += iif(nTot02#0,1,0)
				sq3 += iif(nTot03#0,1,0)
				sq4 += iif(ntot04#0,1,0)
				sq5 += iif(nTot05#0,1,0)
				sq6 += iif(nTot06#0,1,0)
				sq7 += iif(nTot07#0,1,0)
				sq8 += iif(nTot08#0,1,0)
				sq9 += iif(nTot09#0,1,0)
				sqa += iif(nTot10#0,1,0)
				sqb += iif(nTot11#0,1,0)
				sqc += iif(nTot12#0,1,0)
				
				Wln := Wln + 1
				nAt += (iif(cclass=="A",1,0))
				nIn += (iif(cclass=="I",1,0))
				nRe += (iif(cclass=="R",1,0))
				nDes+= (iif(cclass=="D",1,0))
				nNov+= (iif(cclass=="N",1,0))
				
			else  // Sem agrupamento
				
				Select SZ1
				dbSetOrder(3)
				Seek xFilial()+tmp->T_GRPCLI
				Select TMP
				//				cClass  := substr(TMP->T_CLASS,2,1)
				cClass  := iif(left(TMP->T_CLASS,1)="0",substr(TMP->T_CLASS,6,1),substr(TMP->T_CLASS,2,1))
				//				cLin1 := T_GRPCLI+"  "+sa1->a1_nreduz+"("+substr(TMP->T_CLASS,2,1)+")"+" "+TMP->T_EST+" "+TMP->T_SEG
				//				cLin2 := TMP->T_ULTC
				IF 	TMP->T_CODC+TMP->T_LOJA = T_GRPCLI
					cDiv := "X"
				ELSE
					cDiv := "/"
				ENDIF
				//				@ wln,000 PSAY TMP->T_CODC+cDiv+TMP->T_LOJA+" "+TMP->T_CLIE+"("+tmp->T_CLASS+")"+TMP->T_EST
				//				@ wln,000 PSAY tmp->T_GRPCLI+" "+TMP->T_CODC+cDiv+TMP->T_LOJA+" "+TMP->T_CLIE+substr(TMP->T_CLASS,2,1)+" "+TMP->T_EST //xxa
				@ wln,000 PSAY tmp->T_GRPCLI+" "+TMP->T_CODC+cDiv+TMP->T_LOJA+" "+TMP->T_CLIE+cClass+" "+TMP->T_EST
				@ wln,046 PSAY TMP->T_ULTC
				//				@ wln,000 PSAY TMP->T_GRPCLI+"/"+TMP->T_LOJA+" "+TMP->T_CLIE+"("+substr(TMP->T_CLASS,2,1)+")"+" "+TMP->T_EST+" "+TMP->T_SEG
				//				@ wln,046 PSAY TMP->T_ULTC
				@ wln,058 PSAY TMP->T_QTD01   Picture "@E 99999,999"
				@ wln,069 PSAY TMP->T_QTD02   Picture "@E 99999,999"
				@ wln,080 PSAY TMP->T_QTD03   Picture "@E 99999,999"
				@ wln,091 PSAY TMP->T_QTD04   Picture "@E 99999,999"
				@ wln,102 PSAY TMP->T_QTD05   Picture "@E 99999,999"
				@ wln,113 PSAY TMP->T_QTD06   Picture "@E 99999,999"
				@ wln,124 PSAY TMP->T_QTD07   Picture "@E 99999,999"
				@ wln,135 PSAY TMP->T_QTD08   Picture "@E 99999,999"
				@ wln,146 PSAY TMP->T_QTD09   Picture "@E 99999,999"
				@ wln,157 PSAY TMP->T_QTD10   Picture "@E 99999,999"
				@ wln,168 PSAY TMP->T_QTD11   Picture "@E 99999,999"
				@ wln,179 PSAY TMP->T_QTD12   Picture "@E 99999,999"
				@ wln,190 PSAY (TMP->T_QTD01+TMP->T_QTD02+TMP->T_QTD03+TMP->T_QTD04+TMP->T_QTD05+TMP->T_QTD06+TMP->T_QTD07+TMP->T_QTD08+TMP->T_QTD09+TMP->T_QTD10+TMP->T_QTD11+TMP->T_QTD12)     Picture "@R 99999,999"
				@ wln,201 PSAY (TMP->T_QTD01+TMP->T_QTD02+TMP->T_QTD03+TMP->T_QTD04+TMP->T_QTD05+TMP->T_QTD06+TMP->T_QTD07+TMP->T_QTD08+TMP->T_QTD09+TMP->T_QTD10+TMP->T_QTD11+TMP->T_QTD12)/12  Picture "@R 999,999"
				IF sz1->Z1_RANK<>0
					@ wln,215 PSAY sz1->Z1_RANK  Picture "@R 999"
				endif
				
				Wln := Wln + 1
				nTot01 += TMP->T_QTD01
				nTot02 += TMP->T_QTD02
				nTot03 += TMP->T_QTD03
				nTot04 += TMP->T_QTD04
				nTot05 += TMP->T_QTD05
				nTot06 += TMP->T_QTD06
				nTot07 += TMP->T_QTD07
				nTot08 += TMP->T_QTD08
				nTot09 += TMP->T_QTD09
				nTot10 += TMP->T_QTD10
				nTot11 += TMP->T_QTD11
				nTot12 += TMP->T_QTD12
				nTot13 += (TMP->T_QTD01+TMP->T_QTD02+TMP->T_QTD03+TMP->T_QTD04+TMP->T_QTD05+TMP->T_QTD06+TMP->T_QTD07+TMP->T_QTD08+TMP->T_QTD09+TMP->T_QTD10+TMP->T_QTD11+TMP->T_QTD12)
				
				TGQ1 := TGQ1 + TMP->T_QTD01
				TGQ2 := TGQ2 + TMP->T_QTD02
				TGQ3 := TGQ3 + TMP->T_QTD03
				TGQ4 := TGQ4 + TMP->T_QTD04
				TGQ5 := TGQ5 + TMP->T_QTD05
				TGQ6 := TGQ6 + TMP->T_QTD06
				TGQ7 := TGQ7 + TMP->T_QTD07
				TGQ8 := TGQ8 + TMP->T_QTD08
				TGQ9 := TGQ9 + TMP->T_QTD09
				TGQa := TGQa + TMP->T_QTD10
				TGQb := TGQb + TMP->T_QTD11
				TGQc := TGQc + TMP->T_QTD12
				TGQT := TGQT + (TMP->T_QTD01+TMP->T_QTD02+TMP->T_QTD03+TMP->T_QTD04+TMP->T_QTD05+TMP->T_QTD06+TMP->T_QTD07+TMP->T_QTD08+TMP->T_QTD09+TMP->T_QTD10+TMP->T_QTD11+TMP->T_QTD12)
				
				ttq1 += iif(TMP->T_QTD01#0,1,0)
				ttq2 += iif(TMP->T_QTD02#0,1,0)
				ttq3 += iif(TMP->T_QTD03#0,1,0)
				ttq4 += iif(TMP->T_QTD04#0,1,0)
				ttq5 += iif(TMP->T_QTD05#0,1,0)
				ttq6 += iif(TMP->T_QTD06#0,1,0)
				ttq7 += iif(TMP->T_QTD07#0,1,0)
				ttq8 += iif(TMP->T_QTD08#0,1,0)
				ttq9 += iif(TMP->T_QTD09#0,1,0)
				ttqa += iif(TMP->T_QTD10#0,1,0)
				ttqb += iif(TMP->T_QTD11#0,1,0)
				ttqc += iif(TMP->T_QTD12#0,1,0)
				
				sq1 += iif(TMP->T_QTD01#0,1,0)
				sq2 += iif(TMP->T_QTD02#0,1,0)
				sq3 += iif(TMP->T_QTD03#0,1,0)
				sq4 += iif(TMP->T_QTD04#0,1,0)
				sq5 += iif(TMP->T_QTD05#0,1,0)
				sq6 += iif(TMP->T_QTD06#0,1,0)
				sq7 += iif(TMP->T_QTD07#0,1,0)
				sq8 += iif(TMP->T_QTD08#0,1,0)
				sq9 += iif(TMP->T_QTD09#0,1,0)
				sqa += iif(TMP->T_QTD10#0,1,0)
				sqb += iif(TMP->T_QTD11#0,1,0)
				sqc += iif(TMP->T_QTD12#0,1,0)
				
			endif
		endif
		
		if nTot13<>0
			//		If (TMP->T_QTD01+TMP->T_QTD02+TMP->T_QTD03+TMP->T_QTD04+TMP->T_QTD05+TMP->T_QTD06+TMP->T_QTD07+TMP->T_QTD08+TMP->T_QTD09+TMP->T_QTD10+TMP->T_QTD11+TMP->T_QTD12) <> 0
			TGCL  := TGCL  + 1
			STGCL := STGCL + 1
		Else
			TGLL := TGLL + 1
		Endif
		TQ1:=TQ2:=TQ3:=TQ4:=TQ5:=TQ6:=TQ7:=TQ8:=TQ9:=TQa:=TQb:=TQc:=0
		
		
		if mv_par11=2
			nAt += (iif(cclass=="A",1,0))
			nIn += (iif(cclass=="I",1,0))
			nRe += (iif(cclass=="R",1,0))
			nDes+= (iif(cclass=="D",1,0))
			nNov+= (iif(cclass=="N",1,0))
			dbSkip()
		endif
	Enddo
	
	If Wln > 58
		Impcabec()
	Endif
	
	If TMP->T_CODI <> nRep
		if lResumo			// Impressao do resumo nao mostra detalhe
			@wln,000 PSAY "Repres.: "
			@wln,009 PSAY TMP->T_CODI+" - "+TMP->T_REPR
		else
			@wln,000 PSAY Replicate("-",220)
			wln := wln + 1
			@wln,000 PSAY "Totais: "
			@wln,020 PSAY TGCL+TGLL Picture "@E 9999"
			@wln,026 PSAY "Clientes"
		endif
		@wln,058 PSAY TGQ1   Picture "@E 99999,999"
		@wln,069 PSAY TGQ2   Picture "@E 99999,999"
		@wln,080 PSAY TGQ3   Picture "@E 99999,999"
		@wln,091 PSAY TGQ4   Picture "@E 99999,999"
		@wln,102 PSAY TGQ5   Picture "@E 99999,999"
		@wln,113 PSAY TGQ6   Picture "@E 99999,999"
		@wln,124 PSAY TGQ7   Picture "@E 99999,999"
		@wln,135 PSAY TGQ8   Picture "@E 99999,999"
		@wln,146 PSAY TGQ9   Picture "@E 99999,999"
		@wln,157 PSAY TGQa   Picture "@E 99999,999"
		@wln,168 PSAY TGQb   Picture "@E 99999,999"
		@wln,179 PSAY TGQc   Picture "@E 99999,999"
		@wln,190 PSAY TGQT   Picture "@E 99999,999"
		wln:=wln+1
		
		if !lResumo			// Impressao do resumo nao mostra detalhe
			@wln,000 PSAY Replicate("-",220)
			wln:=wln+1
			@wln,000 PSAY "Compras/Mes: "
			@wln,020 PSAY TGCL   Picture "@E 9999"
			@wln,026 PSAY "Efetuaram Compras: "
			@wln,058 PSAY TTQ1   Picture "@E 9999,999"
			@wln,069 PSAY TTQ2   Picture "@E 9999,999"
			@wln,080 PSAY TTQ3   Picture "@E 9999,999"
			@wln,091 PSAY TTQ4   Picture "@E 9999,999"
			@wln,102 PSAY TTQ5   Picture "@E 9999,999"
			@wln,113 PSAY TTQ6   Picture "@E 9999,999"
			@wln,124 PSAY TTQ7   Picture "@E 9999,999"
			@wln,135 PSAY TTQ8   Picture "@E 9999,999"
			@wln,146 PSAY TTQ9   Picture "@E 9999,999"
			@wln,157 PSAY TTQa   Picture "@E 9999,999"
			@wln,168 PSAY TTQb   Picture "@E 9999,999"
			@wln,179 PSAY TTQc   Picture "@E 9999,999"
			wln:=wln+1
			@wln,000 PSAY Replicate("-",220)
			wln:=wln+1
			if mv_par11=1  // Agrupado pelo Grupo de Clientes
				@wln,000 PSAY "Total Grupos Clientes : "
			else
				@wln,000 PSAY "Total Clientes : "
			endif
			@wln,030 PSAY strzero(nAt+nIn+nDes+nRe,6)
			@wln,050 PSAY "Sit. do Cliente : "
			@wln,070 PSAY "Ativos  : "+strzero(nAt+nDes+nRe+nNov,6)
			@wln,090 PSAY "Inativos: "+strzero(nIn,6)
			@wln,110 PSAY "|| a Desativar: "+strzero(nDes,6)
			@wln,135 PSAY "Reativados : "+strzero(nRe,6)
			@wln,160 PSAY "Novos : "+strzero(nNov,6)
			wln:=wln+1
			@wln,000 PSAY Replicate("=",220)
			wln:=wln+1
		Endif			// Fim da impressao do resumo
		nRep := TMP->T_CODI
		tGQT := 0
		TGLL := 0
		TTQ1:=TTQ2:=TTQ3:=TTQ4:=TTQ5:=TTQ6:=TTQ7:=TTQ8:=TTQ9:=TTQa:=TTQb:=TTQc:=0
		TGQ1:=TGQ2:=TGQ3:=TGQ4:=TGQ5:=TGQ6:=TGQ7:=TGQ8:=TGQ9:=TGQa:=TGQb:=TGQc:=0
		TGCL:=0
		lFirst := 1
	Endif
	
Endd
if lVendIni .and. lVendFim
	@wln,000 PSAY "Total Geral :"
	@wln,020 PSAY STGCL Picture "@E 9999"
	@wln,026 PSAY "Clientes Compraram"
	@wln,058 PSAY SQ1   Picture "@E 9999,999"
	@wln,069 PSAY SQ2   Picture "@E 9999,999"
	@wln,080 PSAY SQ3   Picture "@E 9999,999"
	@wln,091 PSAY SQ4   Picture "@E 9999,999"
	@wln,102 PSAY SQ5   Picture "@E 9999,999"
	@wln,113 PSAY SQ6   Picture "@E 9999,999"
	@wln,124 PSAY SQ7   Picture "@E 9999,999"
	@wln,135 PSAY SQ8   Picture "@E 9999,999"
	@wln,146 PSAY SQ9   Picture "@E 9999,999"
	@wln,157 PSAY SQa   Picture "@E 9999,999"
	@wln,168 PSAY SQb   Picture "@E 9999,999"
	@wln,179 PSAY SQc   Picture "@E 9999,999"
	wln:=wln+1
	@wln,000 PSAY Replicate("-",220)
endif

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

Return

Static Function ImpCabec()
Wln := 1
@ 000,000 PSAY Replicate("*",220)
@ 001,000 PSAY "*Leao      / Matriz"
@ 001,200 PSAY "Folha..:"
@ 001,218 PSAY "*"
@ 002,000 PSAY "*SIGA / RFAT001 / V.5.08 "
@ 002,100 PSAY "VENDAS MES A MES POR REPRESENTANTE de"+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
@ 002,200 PSAY "Dt.Ref.:"
@ 002,209 PSAY ddatabase
@ 002,218 PSAY "*"
@ 003,000 PSAY "*Hora...:"
@ 003,010 PSAY Time()
@ 003,200 PSAY "Emissao:"
@ 003,209 PSAY Date()
@ 003,218 PSAY "*"
@ 004,000 PSAY Replicate("*",220)
//@ 005,000 PSAY "Codigo | Cliente                  |Ult.Movmto  |  Janeiro  | Fevereiro |   Marco   |   Abril   |   Maio    |   Junho   |   Julho   |   Agosto  |  Setembro |  Outubro  |  Novembro |  Dezembro |   TOTAL   |  MEDIA   |"
if mv_par11=1
	@ 005,000 PSAY "Grupo  |Segm. | Cliente                |Est|Ult.Mov.Fat |"
else
	@ 005,000 PSAY "Grupo   |Cod.Cli  | Cliente             |Est|Ult.Mov.Fat|"
endif
@ 005,057 PSAY nMes01+"|"
@ 005,068 PSAY nMes02+"|"
@ 005,079 PSAY nMes03+"|"
@ 005,090 PSAY nMes04+"|"
@ 005,101 PSAY nMes05+"|"
@ 005,112 PSAY nMes06+"|"
@ 005,123 PSAY nMes07+"|"
@ 005,134 PSAY nMes08+"|"
@ 005,145 PSAY nMes09+"|"
@ 005,156 PSAY nMes10+"|"
@ 005,167 PSAY nMes11+"|"
@ 005,178 PSAY nMes12+"|"
@ 005,189 PSAY "Total   |"
@ 005,200 PSAY "Media   |"
@ 005,211 PSAY "Ranking |"

@ 006,000 PSAY Replicate("*",220)

Wln := 7

Return

Return .t.

************************
Static Function Resumo()
************************

dbSelectArea("TMP")

*cArq := CriaTrab(nil,.f.)
cTemp5 := CriaTrab(nil,.f.)
//index On TMP->T_COOR+TMP->T_CODI To &(cTemp5)
IndRegua("TMP", cTemp5, "TMP->T_COOR+TMP->T_CODI", , , "Selecionando Registros...")

dbGotop()


SetRegua(Reccount())

Set Device to Print
nRep := TMP->T_CODI
nTotf01 := nTotf02 := nTotf03 := nTotf04 := nTotf05 := nTotf06 := 0
nTotf07 := nTotf08 := nTotf09 := nTotf10 := nTotf11 := nTotf12 := 0

lFirst := 1
While !Eof()
	IncRegua()
	If Wln == 0
		ImpCabec()
	Endif
	If lFirst == 1
		Select SA3
		dbSetOrder(1)
		Seek xFilial()+tmp->t_coor
		Select TMP
		@wln,000 PSAY "Coord.: "
		@wln,009 PSAY TMP->T_COOR+" - "+sa3->a3_nome
		wln:=wln+1
		@wln,000 PSAY Replicate("-",220)
		wln:=wln+1
		lFirst := lFirst + 1
	Endif
	nTot01 := ntot02 := nTot03 := ntot04 := nTot05 := nTot06 := 0
	nTot07 := ntot08 := nTot09 := ntot10 := nTot11 := nTot12 := 0
	cCoor := tmp->t_coor
	cCodi := tmp->t_codi
	cRepr := tmp->t_repr
	Do while !eof() .and. tmp->T_CODI==cCodi
		nTot01:= nTot01+ tmp->t_qtd01
		nTot02:= nTot02+ tmp->t_qtd02
		nTot03:= nTot03+ tmp->t_qtd03
		nTot04:= nTot04+ tmp->t_qtd04
		nTot05:= nTot05+ tmp->t_qtd05
		nTot06:= nTot06+ tmp->t_qtd06
		nTot07:= nTot07+ tmp->t_qtd07
		nTot08:= nTot08+ tmp->t_qtd08
		nTot09:= nTot09+ tmp->t_qtd09
		nTot10:= nTot10+ tmp->t_qtd10
		nTot11:= nTot11+ tmp->t_qtd11
		nTot12:= nTot12+ tmp->t_qtd12
		skip
	Enddo
	@ wln,000 PSAY cCODI
	@ wln,008 PSAY cRepr
	@ wln,058 PSAY ntot01   Picture "@E 99999,999"
	@ wln,069 PSAY ntot02   Picture "@E 99999,999"
	@ wln,080 PSAY ntot03   Picture "@E 99999,999"
	@ wln,091 PSAY ntot04   Picture "@E 99999,999"
	@ wln,102 PSAY ntot05   Picture "@E 99999,999"
	@ wln,113 PSAY ntot06   Picture "@E 99999,999"
	@ wln,124 PSAY ntot07   Picture "@E 99999,999"
	@ wln,135 PSAY ntot08   Picture "@E 99999,999"
	@ wln,146 PSAY ntot09   Picture "@E 99999,999"
	@ wln,157 PSAY ntot10   Picture "@E 99999,999"
	@ wln,168 PSAY ntot11   Picture "@E 99999,999"
	@ wln,179 PSAY ntot12   Picture "@E 99999,999"
	@ wln,190 PSAY (ntot01+ntot02+ntot03+ntot04+ntot05+ntot06+ntot07+ntot08+ntot09+ntot10+ntot11+ntot12)     Picture "@R 99999,999"
	@ wln,201 PSAY (ntot01+ntot02+ntot03+ntot04+ntot05+ntot06+ntot07+ntot08+ntot09+ntot10+ntot11+ntot12)/12  Picture "@R 999,999"
	nTotf01:= nTotf01+ nTot01
	nTotf02:= nTotf02+ nTot02
	nTotf03:= nTotf03+ nTot03
	nTotf04:= nTotf04+ nTot04
	nTotf05:= nTotf05+ nTot05
	nTotf06:= nTotf06+ nTot06
	nTotf07:= nTotf07+ nTot07
	nTotf08:= nTotf08+ nTot08
	nTotf09:= nTotf09+ nTot09
	nTotf10:= nTotf10+ nTot10
	nTotf11:= nTotf11+ nTot11
	nTotf12:= nTotf12+ nTot12
	
	
	TGQT := TGQT + (ntot01+ntot02+ntot03+ntot04+ntot05+ntot06+ntot07+ntot08+ntot09+ntot10+ntot11+ntot12)
	TGQ1 := TGQ1 + ntot01
	TGQ2 := TGQ2 + ntot02
	TGQ3 := TGQ3 + ntot03
	TGQ4 := TGQ4 + ntot04
	TGQ5 := TGQ5 + ntot05
	TGQ6 := TGQ6 + ntot06
	TGQ7 := TGQ7 + ntot07
	TGQ8 := TGQ8 + ntot08
	TGQ9 := TGQ9 + ntot09
	TGQa := TGQa + ntot10
	TGQb := TGQb + ntot11
	TGQc := TGQc + ntot12
	If (ntot01+ntot02+ntot03+ntot04+ntot05+ntot06+ntot07+ntot08+ntot09+ntot10+ntot11+ntot12) <> 0
		TGCL  := TGCL  + 1
		STGCL := STGCL + 1
	Else
		TGLL := TGLL + 1
	Endif
	TQ1:=TQ2:=TQ3:=TQ4:=TQ5:=TQ6:=TQ7:=TQ8:=TQ9:=TQa:=TQb:=TQc:=0
	
	IF ntot01#0
		TTQ1 := TTQ1 + 1
		SQ1  := SQ1  + 1
	ENDIF
	IF ntot02#0
		TTQ2 := TTQ2 + 1
		SQ2  := SQ2  + 1
	ENDIF
	IF ntot03#0
		TTQ3 := TTQ3 + 1
		SQ3  := SQ3  + 1
	ENDIF
	IF ntot04#0
		TTQ4 := TTQ4 + 1
		SQ4  := SQ4  + 1
	ENDIF
	IF ntot05#0
		TTQ5 := TTQ5 + 1
		SQ5  := SQ5  + 1
	ENDIF
	IF ntot06#0
		TTQ6 := TTQ6 + 1
		SQ6  := SQ6  + 1
	ENDIF
	IF ntot07#0
		TTQ7 := TTQ7 + 1
		SQ7  := SQ7  + 1
	ENDIF
	IF ntot08#0
		TTQ8 := TTQ8 + 1
		SQ8  := SQ8  + 1
	ENDIF
	IF ntot09#0
		TTQ9 := TTQ9 + 1
		SQ9  := SQ9  + 1
	ENDIF
	IF ntot10#0
		TTQa := TTQa + 1
		SQa  := SQa  + 1
	ENDIF
	IF ntot11#0
		TTQb := TTQb + 1
		SQb  := SQb  + 1
	ENDIF
	IF ntot12#0
		TTQc := TTQc + 1
		SQc  := SQc  + 1
	ENDIF
	Wln := Wln + 1
	If Wln > 58
		Impcabec()
	Endif
	
	//dbSkip()
	
	if tmp->t_coor <> cCoor
		
		@wln,000 PSAY Replicate("-",220)
		wln := wln + 1
		@wln,000 PSAY "Totais: "
		@wln,058 PSAY TGQ1   Picture "@E 99999,999"
		@wln,069 PSAY TGQ2   Picture "@E 99999,999"
		@wln,080 PSAY TGQ3   Picture "@E 99999,999"
		@wln,091 PSAY TGQ4   Picture "@E 99999,999"
		@wln,102 PSAY TGQ5   Picture "@E 99999,999"
		@wln,113 PSAY TGQ6   Picture "@E 99999,999"
		@wln,124 PSAY TGQ7   Picture "@E 99999,999"
		@wln,135 PSAY TGQ8   Picture "@E 99999,999"
		@wln,146 PSAY TGQ9   Picture "@E 99999,999"
		@wln,157 PSAY TGQa   Picture "@E 99999,999"
		@wln,168 PSAY TGQb   Picture "@E 99999,999"
		@wln,179 PSAY TGQc   Picture "@E 99999,999"
		@wln,190 PSAY TGQT   Picture "@E 99999,999"
		@wln,201 PSAY TGQT/12   Picture "@E 9999,999"
		wln:=wln+1
		@wln,000 PSAY Replicate("-",220)
		wln:=wln+1
		nRep := TMP->T_CODI
		tGQT := 0
		TGLL := 0
		TTQ1:=TTQ2:=TTQ3:=TTQ4:=TTQ5:=TTQ6:=TTQ7:=TTQ8:=TTQ9:=TTQa:=TTQb:=TTQc:=0
		TGQ1:=TGQ2:=TGQ3:=TGQ4:=TGQ5:=TGQ6:=TGQ7:=TGQ8:=TGQ9:=TGQa:=TGQb:=TGQc:=0
		TGCL:=0
		lFirst := 1
	Endif
	
Endd
@ wln,000 PSAY "Total Geral :"
@ wln,058 PSAY nTotf01   Picture "@E 99999,999"
@ wln,069 PSAY nTotf02   Picture "@E 99999,999"
@ wln,080 PSAY nTotf03   Picture "@E 99999,999"
@ wln,091 PSAY nTotf04   Picture "@E 99999,999"
@ wln,102 PSAY nTotf05   Picture "@E 99999,999"
@ wln,113 PSAY nTotf06   Picture "@E 99999,999"
@ wln,124 PSAY nTotf07   Picture "@E 99999,999"
@ wln,135 PSAY nTotf08   Picture "@E 99999,999"
@ wln,146 PSAY nTotf09   Picture "@E 99999,999"
@ wln,157 PSAY nTotf10   Picture "@E 99999,999"
@ wln,168 PSAY nTotf11   Picture "@E 99999,999"
@ wln,179 PSAY nTotf12   Picture "@E 99999,999"
@ wln,190 PSAY (nTotf01+nTotf02+nTotf03+nTotf04+nTotf05+nTotf06+nTotf07+nTotf08+nTotf09+nTotf10+nTotf11+nTotf12)     Picture "@R 99999,999"
@ wln,201 PSAY (nTotf01+nTotf02+nTotf03+nTotf04+nTotf05+nTotf06+nTotf07+nTotf08+nTotf09+nTotf10+nTotf11+nTotf12)/12  Picture "@R 999,999"
wln:=wln+1
@ wln,000 PSAY Replicate("=",220)
wln:=wln+1


if lVendIni .and. lVendFim .and. 1==2
	@wln,000 PSAY "Total Geral :"
	@wln,020 PSAY STGCL Picture "@E 9999"
	@wln,026 PSAY "Clientes Compraram"
	@wln,058 PSAY SQ1   Picture "@E 9999,999"
	@wln,069 PSAY SQ2   Picture "@E 9999,999"
	@wln,080 PSAY SQ3   Picture "@E 9999,999"
	@wln,091 PSAY SQ4   Picture "@E 9999,999"
	@wln,102 PSAY SQ5   Picture "@E 9999,999"
	@wln,113 PSAY SQ6   Picture "@E 9999,999"
	@wln,124 PSAY SQ7   Picture "@E 9999,999"
	@wln,135 PSAY SQ8   Picture "@E 9999,999"
	@wln,146 PSAY SQ9   Picture "@E 9999,999"
	@wln,157 PSAY SQa   Picture "@E 9999,999"
	@wln,168 PSAY SQb   Picture "@E 9999,999"
	@wln,179 PSAY SQc   Picture "@E 9999,999"
	wln:=wln+1
	@wln,000 PSAY Replicate("-",220)
endif

Set Device to Screen

If aReturn[5]==1
	Set Print to
	dbCommitAll()
	OurSpool(c_Arq)
EndIf

MS_FLUSH()


Return

************************
Static Function Resum1()
************************

dbSelectArea("TMP")

cTemp6 := CriaTrab(nil,.f.)
//index On TMP->T_CODI To &(cTemp6)
IndRegua("TMP", cTemp6, "TMP->T_CODI", , , "Selecionando Registros...")

dbGotop()


SetRegua(Reccount())

Set Device to Print
nRep := TMP->T_CODI
nTotf01 := nTotf02 := nTotf03 := nTotf04 := nTotf05 := nTotf06 := 0
nTotf07 := nTotf08 := nTotf09 := nTotf10 := nTotf11 := nTotf12 := 0

lFirst := 1
While !Eof()
	IncRegua()
	If Wln == 0
		ImpCabec()
	Endif
	
	nTot01 := ntot02 := nTot03 := ntot04 := nTot05 := nTot06 := 0
	nTot07 := ntot08 := nTot09 := ntot10 := nTot11 := nTot12 := 0
	
	cCodi := tmp->t_codi
	cRepr := tmp->t_repr
	Do while !eof() .and. tmp->T_CODI==cCodi
		nTot01:= nTot01+ tmp->t_qtd01
		nTot02:= nTot02+ tmp->t_qtd02
		nTot03:= nTot03+ tmp->t_qtd03
		nTot04:= nTot04+ tmp->t_qtd04
		nTot05:= nTot05+ tmp->t_qtd05
		nTot06:= nTot06+ tmp->t_qtd06
		nTot07:= nTot07+ tmp->t_qtd07
		nTot08:= nTot08+ tmp->t_qtd08
		nTot09:= nTot09+ tmp->t_qtd09
		nTot10:= nTot10+ tmp->t_qtd10
		nTot11:= nTot11+ tmp->t_qtd11
		nTot12:= nTot12+ tmp->t_qtd12
		skip
	Enddo
	@ wln,000 PSAY cCODI
	@ wln,008 PSAY cRepr
	@ wln,058 PSAY ntot01   Picture "@E 99999,999"
	@ wln,069 PSAY ntot02   Picture "@E 99999,999"
	@ wln,080 PSAY ntot03   Picture "@E 99999,999"
	@ wln,091 PSAY ntot04   Picture "@E 99999,999"
	@ wln,102 PSAY ntot05   Picture "@E 99999,999"
	@ wln,113 PSAY ntot06   Picture "@E 99999,999"
	@ wln,124 PSAY ntot07   Picture "@E 99999,999"
	@ wln,135 PSAY ntot08   Picture "@E 99999,999"
	@ wln,146 PSAY ntot09   Picture "@E 99999,999"
	@ wln,157 PSAY ntot10   Picture "@E 99999,999"
	@ wln,168 PSAY ntot11   Picture "@E 99999,999"
	@ wln,179 PSAY ntot12   Picture "@E 99999,999"
	@ wln,190 PSAY (ntot01+ntot02+ntot03+ntot04+ntot05+ntot06+ntot07+ntot08+ntot09+ntot10+ntot11+ntot12)     Picture "@R 99999,999"
	@ wln,201 PSAY (ntot01+ntot02+ntot03+ntot04+ntot05+ntot06+ntot07+ntot08+ntot09+ntot10+ntot11+ntot12)/12  Picture "@R 999,999"
	nTotf01:= nTotf01+ nTot01
	nTotf02:= nTotf02+ nTot02
	nTotf03:= nTotf03+ nTot03
	nTotf04:= nTotf04+ nTot04
	nTotf05:= nTotf05+ nTot05
	nTotf06:= nTotf06+ nTot06
	nTotf07:= nTotf07+ nTot07
	nTotf08:= nTotf08+ nTot08
	nTotf09:= nTotf09+ nTot09
	nTotf10:= nTotf10+ nTot10
	nTotf11:= nTotf11+ nTot11
	nTotf12:= nTotf12+ nTot12
	
	Wln := Wln + 1
	
Endd
If Wln > 58
	Impcabec()
Endif
@ wln,000 PSAY "Total Geral :"
@ wln,058 PSAY nTotf01   Picture "@E 99999,999"
@ wln,069 PSAY nTotf02   Picture "@E 99999,999"
@ wln,080 PSAY nTotf03   Picture "@E 99999,999"
@ wln,091 PSAY nTotf04   Picture "@E 99999,999"
@ wln,102 PSAY nTotf05   Picture "@E 99999,999"
@ wln,113 PSAY nTotf06   Picture "@E 99999,999"
@ wln,124 PSAY nTotf07   Picture "@E 99999,999"
@ wln,135 PSAY nTotf08   Picture "@E 99999,999"
@ wln,146 PSAY nTotf09   Picture "@E 99999,999"
@ wln,157 PSAY nTotf10   Picture "@E 99999,999"
@ wln,168 PSAY nTotf11   Picture "@E 99999,999"
@ wln,179 PSAY nTotf12   Picture "@E 99999,999"
@ wln,190 PSAY (nTotf01+nTotf02+nTotf03+nTotf04+nTotf05+nTotf06+nTotf07+nTotf08+nTotf09+nTotf10+nTotf11+nTotf12)     Picture "@R 99999,999"
@ wln,201 PSAY (nTotf01+nTotf02+nTotf03+nTotf04+nTotf05+nTotf06+nTotf07+nTotf08+nTotf09+nTotf10+nTotf11+nTotf12)/12  Picture "@R 999,999"
wln:=wln+1
@ wln,000 PSAY Replicate("=",220)
wln:=wln+1

Set Device to Screen

If aReturn[5]==1
	Set Print to
	dbCommitAll()
	OurSpool(c_Arq)
EndIf

MS_FLUSH()

Return

*************************
//Static Function VerUlt(cCli)
*************************
dbSelectArea("SA1")
dbSetOrder(1)
//	TMP->T_CODC := SC5->C5_CLIENTE
//	TMP->T_LOJA := SC5->C5_LOJACLI
dbSeek(xFilial()+TMP->(T_CODC+t_loja))
dUltCom := SA1->A1_ULTCOM
if !empty(A1_XGRPCLI)
	cGrp := A1_XGRPCLI
endif
DBOrderNickname("GRPCLI")
Do while !eof() .and. cGrp = A1_XGRPCLI
	Select SC5
	//cCli := sc5->c5_cliente
	nReg := Recno()
	if cCli = '000025'
		dbSetOrder(2)
		set softseek on
		Seek xFilial()+dtos(ddatabase-60)
		set softseek off
		do while !eof() .and. sc5->c5_cliente<>cCli
			skip
		enddo
		dbSetOrder(3)
	else
		dbSetOrder(3)
		seek xFilial()+sa1->(A1_COD+A1_LOJA)
	endif
	
	do while !eof() .and. sc5->(c5_cliente+c5_lojacli)==sa1->(A1_COD+A1_LOJA)
		if dult<sc5->c5_emissao
			dult := sc5->c5_emissao
		endif
		skip
	enddo
	dbSetOrder(2)
	goto nReg
	
	Select SF2
	if cCli = '000025'
		dbSetOrder(3)
		set softseek on
		Seek xFilial()+" "+dtos(ddatabase-60)
		set softseek off
		do while !eof() .and. sc5->c5_cliente<>cCli
			skip
		enddo
		dbSetOrder(3)
	else
		dbSetOrder(2)
		seek xFilial()+sa1->(A1_COD+A1_LOJA)
	endif
	do while !eof() .and. sf2->(f2_cliente+f2_loja)==sa1->(A1_COD+A1_LOJA)
		if dult<sf2->f2_emissao
			dult := sf2->f2_emissao
		endif
		skip
	enddo
	Select SA1
	skip
Enddo
dbSetOrder(1)
Return

*************************
//Static Function VerAtiv()
//User Function VerAtiv()
*************************

Select SA3
dbgotop()
Do while !eof()
	RecLock("SA3",.f.)
	SA3->A3_CLIATIV := 0
	SA3->A3_CLIINAT := 0
	SA3->A3_CLIDESA := 0
	SA3->A3_CLIREAT := 0
	MsUnLock()
	skip
enddo

Select SA1
dbSetOrder("GRPCLI")  // Verifica o grupo todo
//dbSetOrder(5)  // Verifica o grupo todo
//Select TMP
ProcRegua(Reccount())
dbGoTop()
dData1 := lastday(mv_par02)
dData2 := firstday(mv_par02)
dData3 := lastday(mv_par02-210)
dData4 := firstday(mv_par02-210)

seek xFilial()+"10445203"
Do while !eof() .and. sa1->A1_XGRPCLI = "10445203"
	IncProc()
	if A1_REGIAO="999"
		skip
		loop
	endif
	//	cGrupo := sa1->a1_nreduz
	if !empty(A1_XGRPCLI)
		cGrupo := A1_XGRPCLI
	else
		cGrupo := sa1->(a1_cod+a1_loja)
	endif
	cVendCli := sa1->a1_vend
	n5  := 0 // Outros
	n4  := 0 // Compra > 180 dias
	n3  := 0 // Compra entre 180 e 150 dias
	n2  := 0 // Compra entre 150 e 030 dias
	n1  := 0 // Compra entre 0 e 30 dias
	Do while !eof() .and. cGrupo == sa1->a1_nreduz
		//	Do while !eof() .and. cGrupo == sa1->(a1_cod+a1_loja)
		Select SC5
		dbSetOrder(3)
		//		Seek xFilial()+tmp->(t_codc+t_loja)
		Seek xFilial()+cgrupo // sa1->(a1_cod)   //+a1_loja)
		do while !eof() .and. sc5->(c5_cliente+c5_lojacli)==sa1->(a1_cod+a1_loja) //cGrupo
			Do Case
				Case c5_emissao<dData4
					n4  :=1
				Case c5_emissao>=dData4 .and. c5_emissao<dData3
					n3  :=1
				Case c5_emissao>=dData3 .and. c5_emissao<dData2
					n2  :=1
				Case c5_emissao>=dData2
					n1  :=1
				otherwise
					n5 := 1
			EndCase
			skip
		Enddo
		Select SA1
		skip
	Enddo
	do Case
		Case n1 ==1 .and. n2==1
			cCond := "A"
		Case n2 ==1
			cCond := "A"
		Case n1=1 .and. n2=0 .and. n3=0 .and. n4=0 .and. n5=0
			cCond := "A"
		Case n1=0 .and. n2=0 .and. n3=0
			cCond := "I"
		Case n1=1 .and. n2=0 .and. n4=1
			cCond := "R"
		Case n1=0 .and. n2=0 .and. n3=1
			cCond := "D"
	EndCase
	Select SA1
	Seek xFilial()+cGrupo
	//	Do while !eof() .and. cGrupo == sa1->a1_nreduz
	//	Do while !eof() .and. cGrupo == sa1->a1_cod
	RecLock("SA1",.f.)
	SA1->A1_SATIV8 := cCond
	MsUnLock()
	//		skip
	//	Enddo
	Select SA3
	dbSetOrder(1)
	seek xFilial()+cVendCli
	if !eof()
		RecLock("SA3",.f.)
		Do Case
			Case cCond="A"
				SA3->A3_CLIATIV := 	SA3->A3_CLIATIV +1
			Case cCond="I"
				SA3->A3_CLIINAT := 	SA3->A3_CLIINAT +1
			Case cCond="R"
				SA3->A3_CLIREAT := 	SA3->A3_CLIREAT +1
			Case cCond="D"
				SA3->A3_CLIDESA := 	SA3->A3_CLIDESA +1
		EndCase
		MsUnLock()
	Endif
	Select SA1
	skip
Enddo

Return

************************
Static Function ResGrp()
************************

Select Tmp
cTmp1 := CriaTrab(nil,.f.)
copy structure to &cTmp1
dbUseArea( .T.,,cTmp1, "RES", Nil, .F. )

Select Tmp
//index On T_GRPCLI+T_CODI To &cTmp1
IndRegua("TMP", cTmp1, "T_GRPCLI+T_CODI", , , "Selecionando Registros...")
dbgotop()
do while !eof()
	cCodGrp		:= T_GRPCLI
	cT_CODI		:= T_CODI
	cT_REPR		:= T_REPR
	cT_COOR		:= T_COOR
	cT_DESCGRP	:= T_DESCGRP
	cT_CLASS	:= T_CLASS
	cT_RANK		:= T_RANK
	cT_EST		:= T_EST
	cT_SEG		:= T_SEG
	cT_ULTC		:= T_ULTC
	nTot1 := nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := nTot7 := nTot8 := nTot9 := nTot10 := nTot11 := nTot12 := nTotTT := 0
	do while !eof() .and. T_GRPCLI = cCodGrp
		if 	T_ULTC > cT_ULTC
			cT_ULTC := T_ULTC
		endif
		nTot1  += T_QTD01
		nTot2  += T_QTD02
		nTot3  += T_QTD03
		nTot4  += T_QTD04
		nTot5  += T_QTD05
		nTot6  += T_QTD06
		nTot7  += T_QTD07
		nTot8  += T_QTD08
		nTot9  += T_QTD09
		nTot10 += T_QTD10
		nTot11 += T_QTD11
		nTot12 += T_QTD12
		nTotTT += T_QTDtt
		skip
	Enddo
	
	dbSelectArea("RES")
	RecLock("RES",.t.)
	RES->T_CODI 	:= cT_CODI
	RES->T_REPR 	:= cT_REPR
	RES->T_GRPCLI	:= cCodGrp
	RES->T_DESCGRP	:= cT_DESCGRP
	RES->T_RANK 	:= cT_RANK
	RES->T_CLASS	:= cT_CLASS
	RES->T_EST  	:= cT_EST
	RES->T_SEG  	:= cT_SEG
	RES->T_COOR 	:= cT_COOR
	RES->T_ULTC 	:= cT_ULTC
	RES->T_QTD01	:= nTot1
	RES->T_QTD02	:= nTot2
	RES->T_QTD03	:= nTot3
	RES->T_QTD04	:= nTot4
	RES->T_QTD05	:= nTot5
	RES->T_QTD06	:= nTot6
	RES->T_QTD07	:= nTot7
	RES->T_QTD08	:= nTot8
	RES->T_QTD09	:= nTot9
	RES->T_QTD10	:= nTot10
	RES->T_QTD11	:= nTot11
	RES->T_QTD12	:= nTot12
	RES->T_QTDtt	:= nTottt
	MsUnlock()
	Select Tmp
Enddo

Select Res
copy to \gerencia\vendas_rep_mesXmes_resumo
dbCloseArea()
fErase(cTmp1+".DBF")
fErase(cTmp1+OrdBagExt())

Select Tmp
dbGotop()

Return

*************************
//Static Function VerAtiv()  // Verifica se o cliente esta Ativo/inativo
User Function VerAtiv()  // Verifica se o cliente esta Ativo/inativo
*************************  // Reativado/Desativado (per.180 dias)

Select SA1
DBOrderNickname("GRPCLI")
//dbSetOrder(5)  // Verifica o grupo todo
//Select TMP
ProcRegua(Reccount())
dbGoTop()
dData1 := lastday(mv_par02)
dData2 := firstday(mv_par02)
dData3 := lastday(mv_par02-140)
dData4 := firstday(mv_par02-140)

//Seek '  108599'
//Do while !eof() //.and. left(sa1->a1_xgrpcli,6)='108599'
cGrupo := sa1->a1_xgrpcli
//	IncProc("Processando 1")
//MsgAlert("1. passo")
n5  := 0 // Outros
n4  := 0 // Compra > 180 dias
n3  := 0 // Compra entre 180 e 150 dias
n2  := 0 // Compra entre 150 e 030 dias
n1  := 0 // Compra entre 0 e 30 dias
dEmiss := ctod("0")
cCond1 := ' '
// Verifica ultimo pedido do cliente
cQuery := "SELECT A1_XGRPCLI,MAX(C5_EMISSAO) AS dEmiss"
cQuery += "FROM SC5010 INNER JOIN SA1010 ON C5_CLIENTE=A1_COD AND C5_LOJACLI = A1_LOJA "
cQuery += "WHERE  " //A1_XGRPCLI='"+CGRUPO+"' AND "
cQuery += "SC5010.D_E_L_E_T_ <>'*' AND SA1010.D_E_L_E_T_ <>'*' "
cQuery += "GROUP BY A1_XGRPCLI "
cQuery := ChangeQuery(cQuery)
IF SELECT("TMP1") # 0
	TMP1->(DBCLOSEAREA( ))
ENDIF
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
cTmpx1 := CriaTrab(nil,.f.)
copy to &cTmpx1
use
dbUseArea(.t.,,ctmpx1,"TMPX1",.f.)
IndRegua("TMPX1", cTmpx1, "TMPX1->A1_XGRPCLI", , , "Selecionando Registros...")

//MsgAlert("2. passo")

// Verifica ultima nota fiscal do cliente
cQuery := "SELECT A1_XGRPCLI,MAX(D2_EMISSAO) AS dEmiss1"
cQuery += "FROM SD2010 INNER JOIN SA1010 ON D2_CLIENTE=A1_COD AND D2_LOJA = A1_LOJA "
cQuery += "WHERE "// A1_XGRPCLI='"+CGRUPO+"' AND "
cQuery += "SD2010.D_E_L_E_T_ <>'*' AND SA1010.D_E_L_E_T_ <>'*' "
cQuery += "GROUP BY A1_XGRPCLI "
cQuery := ChangeQuery(cQuery)
IF SELECT("TMP2") # 0
	TMP2->(DBCLOSEAREA( ))
ENDIF
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP2", .F., .T.)
cTmpx2 := CriaTrab(nil,.f.)
copy to &cTmpx2
use
dbUseArea(.t.,,ctmpx2,"TMPX2",.f.)
IndRegua("TMPX2", cTmpx2, "TMPX2->A1_XGRPCLI", , , "Selecionando Registros...")

//MsgAlert("3. passo")
//  Verifica se o cliente tem atraso Leão
// * Verifica Titulos em Aberto Cliente há mais de 15 dias superior a 1% do valor
cQuery := "SELECT E1_NUM,A1_XGRPCLI,E1_SALDO,E1_VALOR "
cQuery += "FROM SE1010 INNER JOIN SA1010 ON E1_CLIENTE=A1_COD AND E1_LOJA = A1_LOJA AND E1_STATUS='A' "
cQuery += "WHERE E1_SALDO<>0 AND E1_VENCREA<'"+DTOS(ddatabase-15)+"' AND " //A1_XGRPCLI='"+CGRUPO+"' AND
cQuery += "E1_TIPO <> 'RA ' AND E1_TIPO <> 'NCC' AND E1_TIPO <> 'IR-' AND E1_PREFIXO<>'RA ' AND "
cQuery += "E1_SALDO/E1_VALOR>0.05 AND A1_XGRPCLI<>'00002501' and "
cQuery += "SE1010.D_E_L_E_T_ <>'*' AND SA1010.D_E_L_E_T_ <>'*' "
cQuery += "GROUP BY E1_NUM,A1_XGRPCLI,E1_SALDO,E1_VALOR "
cQuery := ChangeQuery(cQuery)
IF SELECT("TMP3") # 0
	TMP3->(DBCLOSEAREA( ))
ENDIF
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP3", .F., .T.)
cTmpx3 := CriaTrab(nil,.f.)
copy to &cTmpx3
use
dbUseArea(.t.,,ctmpx3,"TMPX3",.f.)
IndRegua("TMPX3", cTmpx3, "TMPX3->A1_XGRPCLI", , , "Selecionando Registros...")
//			cCond1 := "X"
//MsgAlert("4. passo")

Select SA1
DBOrderNickname("GRPCLI")
ProcRegua(Reccount())
dbgotop()
DO WHILE !EOF()
	n1 := n2 := n3 := n4 := n5 := N6 := 0
	cGrupo := sa1->a1_xgrpcli
	// Verifica Penultimo pedido do cliente
	Select TMPX1
	seek cGrupo
	Select TMPX2
	seek cGrupo
	Select TMPX3
	seek cGrupo
	if !eof()
		cCond1 = "X"
	endif
	
	if tmpx1->dEmiss > tmpx2->dEmiss1
		dUltVen := stod(tmpx1->dEmiss)
	else
		dUltVen := sTod(tmpx2->dEmiss1)
	endif
	
	If sa1->a1_dtincl > firstday(mv_par02) .and. dUltVen >=firstday(mv_par02) .and. dUltVen <=mv_par02  
		n6 := 1
	Endif
	
	Do Case
		Case dUltVen<dData4
			n4  :=1
		Case dUltVen>=dData4 .and. dUltVen<dData3
			n3  :=1
		Case dUltVen>=dData3 .and. dUltVen<dData2
			n2  :=1
		Case dUltVen>=dData2
			n1  :=1
		otherwise
			n5 := 1
	EndCase
	
	do Case
		Case n1 ==1 .and. n2==0  .and. n4==0
			cCond := "A"
		Case n1 ==1 .and. n2==1
			cCond := "A"
		Case n2 ==1
			cCond := "A"
		Case n1=0 .and. n2=0 .and. n3=0
			cCond := "I"
//		Case n1=1 .and. n2=0 .and. n4=1 .and. dEmiss2 < dData4
		Case n1=1 .and. n2=0 .and. dEmiss2 < dData4
			cCond := "R"
		Case n1=0 .and. n2=0 .and. n3=1
			cCond := "D"
		Otherwise
			cCond := "I"
	EndCase
	if n6=1
		cCond := "N"
	endif

	if cCond1 = "X"
		cCond := "X"
	endif
	Select SA1
	Do while !eof() .and. cGrupo == sa1->a1_xgrpcli
		IncProc("Gravando ")
		
		if SA1->A1_XULTVEN<> dUltVen .or. SA1->A1_SATIV8 <> cCond
			reclock("SA1",.f.)
			SA1->A1_XULTVEN:= dUltVen
			SA1->A1_SATIV8 := cCond
			MsUnLock()
		Endif
		skip
	Enddo
	cCond1 := " "
Enddo

Return

Static function GeraExcel()

Private nHdl		:= 0
Private i			:= 0
Private cFile		:= ""
Private oExcel	:= Nil
Private aAreaSM0	:= SM0->(GetArea())
Private aCabec	:= {}
Private cLinhaCSV	:= ""


//Cria o arquivo CSV
cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	+= "\vendas_rep_" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
AAdd(aCabec,{"Cod.Vend" ,"C","T_CODI"})
AAdd(aCabec,{"Repr"   ,"C","T_REPR"})
AAdd(aCabec,{"Coord"   ,"C","T_COOR"})
AAdd(aCabec,{"Cod.Cli"   ,"C","T_CODC"})
AAdd(aCabec,{"Loja"   ,"C","T_LOJA"})
AAdd(aCabec,{"Cliente"   ,"C","T_CLIE"})
AAdd(aCabec,{"Grupo" ,"C","T_GRPCLI"})
AAdd(aCabec,{"Desc.Grupo","C","T_DESCGRP"})
AAdd(aCabec,{"Classe"  ,"C","T_CLASS"})
AAdd(aCabec,{"Ranking"   ,"N","T_RANK"})
AAdd(aCabec,{"Estado"    ,"C","T_EST"})
AAdd(aCabec,{"Segmento"    ,"C","T_SEG"})
AAdd(aCabec,{"ult.Compra"   ,"C","T_ULTC"})
AAdd(aCabec,{"T_QTD01"  ,"N","T_Qtd01"})
AAdd(aCabec,{"T_QTD02"  ,"N","T_Qtd02"})
AAdd(aCabec,{"T_QTD03"  ,"N","T_Qtd03"})
AAdd(aCabec,{"T_QTD04"  ,"N","T_Qtd04"})
AAdd(aCabec,{"T_QTD05"  ,"N","T_Qtd05"})
AAdd(aCabec,{"T_QTD06"  ,"N","T_Qtd06"})
AAdd(aCabec,{"T_QTD07"  ,"N","T_Qtd07"})
AAdd(aCabec,{"T_QTD08"  ,"N","T_Qtd08"})
AAdd(aCabec,{"T_QTD09"  ,"N","T_Qtd09"})
AAdd(aCabec,{"T_QTD10"  ,"N","T_Qtd10"})
AAdd(aCabec,{"T_QTD11"  ,"N","T_Qtd11"})
AAdd(aCabec,{"T_QTD12"  ,"N","T_Qtd12"})
AAdd(aCabec,{"Total"  ,"N","T_QTDTT"})

dbUseArea(.t.,,cArq,"TRB",.f.)

For i := 1 To Len(aCabec)
	cLinhaCSV += aCabec[i,1] + ";"
Next i
FWrite(nHdl,cLinhaCSV+ENTER)

if select("TMPX1")<>0
	Select TMPX1
	use
endif

dbUseArea( .T.,,cTMP1, "TMPX1", Nil, .F. )

nTotReg := reccount()
ProcRegua(nTotReg)
dbgotop()
//Geracao do arquivo CSV
While TMPX1->(!Eof())
	IncProc()
	cLinhaCSV := ""
	
	For i := 1 To Len(aCabec)
		If aCabec[i,2] == "C"
			do Case
				Case trim(aCabec[i,3]) $ "T_ULTC"
					cCpo := dtoc(TMPX1->&(aCabec[i,3]))
					cLinhaCSV += cCpo+";"
				Otherwise
					cLinhaCSV += TMPX1->&(aCabec[i,3])+";"
			endcase
		ElseIf aCabec[i,2] == "D"
			//			cLinhaCSV += DToC(SToD(TMPX1->&(aCabec[i,3])))+";"
			if trim(aCabec[i,3]) $ "T_ULTC"
				cCpo := dtoc(stod(TMPX1->&(aCabec[i,3])))
				cLinhaCSV += cCpo+";"
			endif
			
		ElseIf aCabec[i,2] == "N"
			cLinhaCSV += Transform(TMPX1->&(aCabec[i,3]),"@E 999,999,999.99")+";"
		EndIf
	Next i
	
	FWrite(nHdl,cLinhaCSV+ENTER)
	TMPX1->(dbSkip())
EndDo

FClose(nHdl)
oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cFile)
oExcel:SetVisible(.T.)

Select TMPX1
dbgotop()

RestArea(aAreaSM0)


Return
