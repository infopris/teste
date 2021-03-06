#Include "PROTHEUS.Ch"

#DEFINE QUEBR				1
#DEFINE FORNEC				2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO			6
#DEFINE VENCTO				7
#DEFINE VENCREA			8
#DEFINE VL_ORIG			9
#DEFINE VL_NOMINAL		10
#DEFINE VL_CORRIG			11
#DEFINE VL_VENCIDO		12
#DEFINE PORTADOR			13
#DEFINE VL_JUROS			14
#DEFINE ATRASO				15
#DEFINE HISTORICO			16
#DEFINE VL_SOMA			17

Static lFWCodFil := FindFunction("FWCodFil")

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? FIN150	? Autor ? Daniel Tadashi Batori ? Data ? 07.08.06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Posi噭o dos Titulos a Pagar					              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? FINR150(void)                                              潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?                                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
User Function FINR150M()

Local oReport  
AjustaSX1()

If FindFunction("TRepInUse") .And. TRepInUse() .and. !IsBlind()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return FINR150R3() // Executa vers鉶 anterior do fonte
Endif

Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? ReportDef? Autor ? Daniel Batori         ? Data ? 07.08.06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Definicao do layout do Relatorio									  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe   ? ReportDef(void)                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local cPictTit
Local nTamVal, nTamCli, nTamQueb
Local cPerg := Padr("FIN150M",Len(SX1->X1_GRUPO))
Local aOrdem := {"Por Numero",;	//"Por Numero"
				 "Por Natureza",;	//"Por Natureza"
				 "Por Vencimento",;	//"Por Vencimento"
				 "Por Banco",;	//"Por Banco"
				 "Fornecedor",;	//"Fornecedor"
				 "Por Emissao",;	//"Por Emissao"
				 "Por Cod.Fornec.",;	//"Por Cod.Fornec."
				 "Por Valor"}	

oReport := TReport():New("FINR150","Posicao dos Titulos a Pagar","FIN150M",{|oReport| ReportPrint(oReport)},"Imprime a posicao dos titulos a pagar relativo a data basedo sistema.")

oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)		//Imprime o total em linha

//Nao retire esta chamada. Verifique antes !!!
//Ela ? necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

dbSelectArea("SX1")
dbSetOrder(1)
If !dbSeek("FIN150M")
	CriaSX1( cPerg )
EndIf	

pergunte("FIN150M",.F.)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Variaveis utilizadas para parametros ?
//? mv_par01	  // do Numero 			  ?
//? mv_par02	  // at? o Numero 		  ?
//? mv_par03	  // do Prefixo			  ?
//? mv_par04	  // at? o Prefixo		  ?
//? mv_par05	  // da Natureza  	     ?
//? mv_par06	  // at? a Natureza		  ?
//? mv_par07	  // do Vencimento		  ?
//? mv_par08	  // at? o Vencimento	  ?
//? mv_par09	  // do Banco			     ?
//? mv_par10	  // at? o Banco		     ?
//? mv_par11	  // do Fornecedor		  ?
//? mv_par12	  // at? o Fornecedor	  ?
//? mv_par13	  // Da Emiss刼			  ?
//? mv_par14	  // Ate a Emiss刼		  ?
//? mv_par15	  // qual Moeda			  ?
//? mv_par16	  // Imprime Provisios  ?
//? mv_par17	  // Reajuste pelo vencto ?
//? mv_par18	  // Da data contabil	  ?
//? mv_par19	  // Ate data contabil	  ?
//? mv_par20	  // Imprime Rel anal/sint?
//? mv_par21	  // Considera  Data Base??
//? mv_par22	  // Cons filiais abaixo ??
//? mv_par23	  // Filial de            ?
//? mv_par24	  // Filial ate           ?
//? mv_par25	  // Loja de              ?
//? mv_par26	  // Loja ate             ?
//? mv_par27 	  // Considera Adiantam.? ?
//? mv_par28	  // Imprime Nome 		  ?
//? mv_par29	  // Outras Moedas 		  ?
//? mv_par30     // Imprimir os Tipos    ?
//? mv_par31     // Nao Imprimir Tipos	  ?
//? mv_par32     // Consid. Fluxo Caixa  ?
//? mv_par33     // DataBase             ?
//? mv_par34     // Tipo de Data p/Saldo ?
//? mv_par35     // Quanto a taxa		  ?
//? mv_par36     // Tit.Emissao Futura	  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

cPictTit := PesqPict("SE2","E2_VALOR")
nTamVal	 := TamSX3("E2_VALOR")[1]
nTamCli	 := TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1] + 25
nTamTit	 := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + 5
nTamQueb := nTamCli + nTamTit + TamSX3("E2_TIPO")[1] + TamSX3("E2_NATUREZ")[1] + TamSX3("E2_EMISSAO")[1] +;
			TamSX3("E2_VENCTO")[1] + TamSX3("E2_VENCREA")[1] + 12
			
//谀哪哪哪哪哪?
//?  Secao 1  ?
//滥哪哪哪哪哪?
oSection1 := TRSection():New(oReport,"Titulos a Pagar",{"SE2","SA2"},aOrdem)

TRCell():New(oSection1,"FORNECEDOR"	,	  ,"Codigo-Nome do Fornecedor"				,,nTamCli,.F.,)  		//"Codigo-Nome do Fornecedor"
TRCell():New(oSection1,"TITULO"		,	  ,"Prf-Numero"+CRLF+"Parcela"	,,nTamTit,.F.,)  		//"Prf-Numero" + "Parcela"
TRCell():New(oSection1,"E2_TIPO"	,"SE2","TP"				,,,.F.,)  				//"TP"
TRCell():New(oSection1,"E2_NATUREZ"	,"SE2","Natureza"				,,,.F.,)  				//"Natureza"
TRCell():New(oSection1,"E2_EMISSAO"	,"SE2","Data de"+CRLF+"Emissao"	,,,.F.,) 				//"Data de" + "Emissao"
TRCell():New(oSection1,"E2_VENCTO"	,"SE2","Vencto"+CRLF+"Titulo"	,,,.F.,)  				//"Vencto" + "Titulo"
TRCell():New(oSection1,"E2_VENCREA"	,"SE2","Vencto"+CRLF+"Real"	,,,.F.,)  				//"Vencto" + "Real"
TRCell():New(oSection1,"VAL_ORIG"	,	  ,"Valor Original"				,cPictTit,nTamVal,.F.,) //"Valor Original"
TRCell():New(oSection1,"VAL_NOMI"	,	  ,"Tit Vencidos"+CRLF+"Valor Nominal"	,cPictTit,nTamVal,.F.,) //"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection1,"VAL_CORR"	,	  ,"Tit Vencidos"+CRLF+"Valor Corrigido"	,cPictTit,nTamVal,.F.,) //"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection1,"VAL_VENC"	,	  ,"Titulos a Vencer"+CRLF+"Valor Nominal"	,cPictTit,nTamVal,.F.,) //"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection1,"E2_PORTADO"	,"SE2","Porta-"+CRLF+"dor"	,,,.F.,)  				//"Porta-" + "dor"
TRCell():New(oSection1,"JUROS"		,	  ,"Vlr.juros ou"+CRLF+"permanencia"	,cPictTit,nTamVal,.F.,) //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR"	,	  ,"Dias"+CRLF+"Atraso"	,,4,.F.,)  				//"Dias" + "Atraso"
TRCell():New(oSection1,"E2_HIST"	,"SE2",IIf(cPaisloc =="MEX","Historico(Vencidos+Vencer)","Historico(Vencidos+Vencer)") ,,25,.F.,)  			//"Historico(Vencidos+Vencer)"
TRCell():New(oSection1,"VAL_SOMA"	,	  ,"(Vencidos+Vencer)"				,cPictTit,26,.F.,)  	//"(Vencidos+Vencer)"

oSection1:Cell("VAL_ORIG"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_NOMI"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_CORR"):SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_VENC"):SetHeaderAlign("RIGHT")
oSection1:Cell("JUROS")   :SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_SOMA"):SetHeaderAlign("RIGHT")

oSection1:SetLineBreak(.f.)		//Quebra de linha automatica
Return oReport                                                                              

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北砅rograma  砇eportPrint? Autor 矰aniel Batori          ? Data ?08.08.06	潮?
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 矨 funcao estatica ReportDef devera ser criada para todos os  潮?
北?          硆elatorios que poderao ser agendados pelo usuario.           潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpO1: Objeto Report do Relat髍io                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北?   DATA   ? Programador   矼anutencao efetuada                          潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北?          ?               ?                                             潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function ReportPrint(oReport)

Local oSection1	:=	oReport:Section(1) 
Local nOrdem 	:= oSection1:GetOrder()
Local oBreak
Local oBreak2

Local aDados[17]
Local cString :="SE2"
Local nRegEmp := SM0->(RecNo())
Local nRegSM0 := SM0->(Recno())
Local nAtuSM0 := SM0->(Recno())
Local dOldDtBase := dDataBase
Local dOldData := dDataBase
Local nJuros  :=0

Local nQualIndice := 0
Local lContinua := .T.
Local nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
Local nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
Local nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
Local cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
Local dDataReaj
Local dDataAnt := dDataBase , lQuebra
Local nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
Local dDtContab
Local cIndexSe2
Local cChaveSe2
Local nIndexSE2
Local cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par15)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt
Local cMoeda := LTrim(Str(mv_par15))
Local cFilterUser
Local cFilUserSA2 := oSection1:GetADVPLExp("SA2")

Local cNomFor	:= ""
Local cNomNat	:= ""
Local cNomFil	:= ""
Local cNumBco	:= 0
Local nTotVenc	:= 0
Local nTotMes	:= 0
Local nTotGeral := 0
Local nTotTitMes:= 0
Local nTotFil	:= 0
Local dDtVenc
Local aFiliais	:= {}
Local lTemCont := .F.
Local cNomFilAnt := ""

#IFDEF TOP
	Local nI := 0
	Local aStru := SE2->(dbStruct())
#ENDIF

Private dBaixa := dDataBase
Private cTitulo  := ""

//*******************************************************
// Solu玢o para o problema no filtro de Serie minuscula *
//*******************************************************
mv_par04 := LOWER(mv_par04)

oSection1:Cell("FORNECEDOR"	):SetBlock( { || aDados[FORNEC] 	})
oSection1:Cell("TITULO"		):SetBlock( { || aDados[TITUL] 		})
oSection1:Cell("E2_TIPO"	):SetBlock( { || aDados[TIPO] 		})
oSection1:Cell("E2_NATUREZ"	):SetBlock( { || aDados[NATUREZA] 	})
oSection1:Cell("E2_EMISSAO"	):SetBlock( { || aDados[EMISSAO] 	})
oSection1:Cell("E2_VENCTO"	):SetBlock( { || aDados[VENCTO] 	})
oSection1:Cell("E2_VENCREA"	):SetBlock( { || aDados[VENCREA] 	})
oSection1:Cell("VAL_ORIG"	):SetBlock( { || aDados[VL_ORIG] 	})
oSection1:Cell("VAL_NOMI"	):SetBlock( { || aDados[VL_NOMINAL] })
oSection1:Cell("VAL_CORR"	):SetBlock( { || aDados[VL_CORRIG] 	})
oSection1:Cell("VAL_VENC"	):SetBlock( { || aDados[VL_VENCIDO] })
oSection1:Cell("E2_PORTADO"	):SetBlock( { || aDados[PORTADOR] 	})
oSection1:Cell("JUROS"		):SetBlock( { || aDados[VL_JUROS] 	})
oSection1:Cell("DIA_ATR"	):SetBlock( { || aDados[ATRASO] 	})
oSection1:Cell("E2_HIST"	):SetBlock( { || aDados[HISTORICO] 	})
oSection1:Cell("VAL_SOMA"	):SetBlock( { || aDados[VL_SOMA] 	})

oSection1:Cell("VAL_SOMA"):Disable()

TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA })

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Define as quebras da se玢o, conforme a ordem escolhida.      ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If nOrdem == 2	//Natureza
	oBreak := TRBreak():New(oSection1,{|| IIf(!MV_MULNATP,SE2->E2_NATUREZ,aDados[NATUREZA]) },{|| cNomNat })
ElseIf nOrdem == 3	.Or. nOrdem == 6	//Vencimento e por Emissao
	oBreak  := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO) },{|| "S U B - T O T A L ----> " + DtoC(dDtVenc) })	//"S U B - T O T A L ----> "
	oBreak2 := TRBreak():New(oSection1,{|| IIf(nOrdem == 3,Month(SE2->E2_VENCREA),Month(SE2->E2_EMISSAO)) },{|| "T O T A L   D O  M E S ---> " + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi("TITULOS"),OemToAnsi("TITULO"))+")" })		//"T O T A L   D O  M E S ---> "
	If mv_par20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,PesqPict("SE2","E2_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotMes)},.F.,.F.)
	EndIf
ElseIf nOrdem == 4	//Banco
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_PORTADO },{|| "S U B - T O T A L ----> " + cNumBco })	//"S U B - T O T A L ----> "
ElseIf nOrdem == 5	//Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->(E2_FORNECE+E2_LOJA) },{|| cNomFor })
ElseIf nOrdem == 7	//Codigo Fornecedor
	oBreak := TRBreak():New(oSection1,{|| SE2->E2_FORNECE },{|| cNomFor })	
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Imprimir TOTAL por filial somente quando ?
//? houver mais do que uma filial.	         ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If mv_par22 == 1 .And. SM0->(Reccount()) > 1
	oBreak2 := TRBreak():New(oSection1,{|| SE2->E2_FILIAL },{|| "T O T A L   F I L I A L ----> " +" "+cNomFil })	//"T O T A L   F I L I A L ----> " 
	If mv_par20 == 1	//1- Analitico  2-Sintetico
		TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak2,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak2,,PesqPict("SE2","E2_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotFil)},.F.,.F.)
	EndIf
EndIf

If mv_par20 == 1	//1- Analitico  2-Sintetico
	//Altero o texto do Total Geral
	oReport:SetTotalText({|| "T O T O A L   G E R A L ----> " + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,"TITULO","TITULOS")+")" })
	TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak,,PesqPict("SE2","E2_VALOR"),{|lSection,lReport| If(lReport, nTotGeral, nTotVenc)},.F.,.T.)
EndIf

#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE2") == 0
		ChkFile("SE2",.f.,"__SE2")
	Endif
#ENDIF

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par22 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par23
	cFilAte:= mv_par24
Endif

//Acerta a database de acordo com o parametro
If mv_par21 == 1    // Considera Data Base
	dDataBase := mv_par33
Endif	

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())
            
// Cria vetor com os codigos das filiais da empresa corrente                     
aFiliais := FinRetFil()

oReport:NoUserFilter()

oSection1:Init()

While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte

	cTitulo := oReport:title() + " " + "Posicao dos Titulos a Pagar" + " em " + GetMv("MV_MOEDA"+cMoeda)  //"Posicao dos Titulos a Pagar" + " em "

	dbSelectArea("SE2")
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	#IFDEF TOP
		cFilterUser := oSection1:GetSqlExp("SE2")
		if TcSrvType() != "AS/400"
			cQuery := "SELECT * "
			cQuery += "  FROM "+	RetSqlName("SE2")
			cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
			cQuery += "   AND D_E_L_E_T_ = ' ' " 
			If !empty(cFilterUser)
			  	cQuery += " AND ( "+cFilterUser + " ) "
			Endif
		endif
	#ENDIF

	IF nOrdem == 1
		SE2->(dbSetOrder(1))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
		#ENDIF
		cCond1 := "SE2->E2_PREFIXO <= mv_par04"
		cCond2 := "SE2->E2_PREFIXO"
		cTitulo += OemToAnsi(" - Por Numero")  //" - Por Numero"
		nQualIndice := 1
	Elseif nOrdem == 2
		SE2->(dbSetOrder(2))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par05,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par05,.T.)
		#ENDIF
		cCond1 := "SE2->E2_NATUREZ <= mv_par06"
		cCond2 := "SE2->E2_NATUREZ"
		cTitulo += " - Por Natureza"  //" - Por Natureza"
		nQualIndice := 2
	Elseif nOrdem == 3
		SE2->(dbSetOrder(3))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
		#ENDIF
		cCond1 := "SE2->E2_VENCREA <= mv_par08"
		cCond2 := "SE2->E2_VENCREA"
		cTitulo += " - Por Vencimento"  //" - Por Vencimento"
		nQualIndice := 3
	Elseif nOrdem == 4
		SE2->(dbSetOrder(4))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par09,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par09,.T.)
		#ENDIF
		cCond1 := "SE2->E2_PORTADO <= mv_par10"
		cCond2 := "SE2->E2_PORTADO"
		cTitulo += OemToAnsi(" - Por Banco")  //" - Por Banco"
		nQualIndice := 4
	Elseif nOrdem == 6
		SE2->(dbSetOrder(5))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
		#ENDIF
		cCond1 := "SE2->E2_EMISSAO <= mv_par14"
		cCond2 := "SE2->E2_EMISSAO"
		cTitulo += " - Por Emissao" //" - Por Emissao"
		nQualIndice := 5
	Elseif nOrdem == 7
		SE2->(dbSetOrder(6))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par11,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par11,.T.)
		#ENDIF			
		cCond1 := "SE2->E2_FORNECE <= mv_par12"
		cCond2 := "SE2->E2_FORNECE"
		cTitulo += " - Por Cod.Fornecedor" //" - Por Cod.Fornecedor"
		nQualIndice := 6
	Elseif nOrdem == 8 //Criada por Marcio para adicionar a ordem por valor
		cChaveSe2 := "E2_FILIAL+E2_VALOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			cIndexSe2 := CriaTrab(nil,.f.)
			IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
			nIndexSE2 := RetIndex("SE2")
			dbSetIndex(cIndexSe2+OrdBagExt())
			dbSetOrder(nIndexSe2+1)
			dbSeek(xFilial("SE2"))
		#ENDIF
		cCond1 := "SE2->E2_VALOR >= 0"
		cCond2 := "SE2->E2_VALOR"
		cTitulo += " - Por Valor" 
		nQualIndice := IndexOrd()		
	Else
		cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			cIndexSe2 := CriaTrab(nil,.f.)
			IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
			nIndexSE2 := RetIndex("SE2")
			dbSetIndex(cIndexSe2+OrdBagExt())
			dbSetOrder(nIndexSe2+1)
			dbSeek(xFilial("SE2"))
		#ENDIF
		cCond1 := "SE2->E2_FORNECE <= mv_par12"
		cCond2 := "SE2->E2_FORNECE+SE2->E2_LOJA"
		cTitulo += " - Por Fornecedor" //" - Por Fornecedor"
		nQualIndice := IndexOrd()
	EndIF

	If mv_par20 == 1	//1- Analitico  2-Sintetico	
		cTitulo += " - Analitico"  //" - Analitico"
	Else
		cTitulo += " - Sintetico"  // " - Sintetico"
	EndIf

	oReport:SetTitle(cTitulo)
	
	dbSelectArea("SE2")

	Set Softseek Off

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
			cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
			cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
			cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
			cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
			cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
			cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
			cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"

			//Considerar titulos cuja emissao seja maior que a database do sistema
			If mv_par36 == 2
				cQuery += " AND E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
			Endif
	
			If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
				cQuery += " AND E2_TIPO IN "+FormatIn(mv_par30,";") 
			ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par31,";")
			EndIf
			If mv_par32 == 1
				cQuery += " AND E2_FLUXO <> 'N'"
			Endif
			
			cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
			
			If mv_par16 == 2
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")			
			Endif
			
			If mv_par27 == 2
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")			 
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")			
			Endif							

			cQuery += " ORDER BY "+ cOrder 
			cQuery += Iif(MV_PAR37 == 2," DESC","")
            alert(cQuery)
			cQuery := ChangeQuery(cQuery)

			dbSelectArea("SE2")
			dbCloseArea()
			dbSelectArea("SA2")

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)

			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		endif
	#ELSE
		cFilterUser := oSection1:GetADVPLExp("SE2")
		
		If !Empty(cFilterUser)
			oSection1:SetFilter(cFilterUser)
		Endif	
	#ENDIF
	
	oReport:SetMeter(nTotsRec)

	If MV_MULNATP .And. nOrdem == 2
		Finr155(cFr150Flt, .F., @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ, oReport, aDados, @cNomNat, @nTotVenc, @nTotGeral)
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				dbSelectArea("SE2")
				dbCloseArea()
				ChKFile("SE2")
				dbSetOrder(1)
			endif
		#ENDIF
		If Empty(xFilial("SE2"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif  
	
	
	While &cCond1 .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
	
		oReport:IncMeter()

		dbSelectArea("SE2")

		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5

		If nOrdem == 3 .And. Str(Month(SE2->E2_VENCREA)) <> Str(Month(dDataAnt))
			nMesTTit := 0
		Elseif nOrdem == 6 .And. Str(Month(SE2->E2_EMISSAO)) <> Str(Month(dDataAnt))
			nMesTTit := 0
		EndIf
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Carrega data do registro para permitir ?
		//? posterior analise de quebra por mes.   ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

		cCarAnt := &cCond2
        
		lTemCont := .F.
		While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. SE2->E2_FILIAL == xFilial("SE2")
			
			oReport:IncMeter()

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Filtro de usu醨io pela tabela SA2.					 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SA2")
			MsSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			If !Empty(cFilUserSA2).And.!SA2->(&cFilUserSA2)
				SE2->(dbSkip())
				Loop
			Endif
			
			dbSelectArea("SE2")

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Considera filtro do usuario no ponto de entrada.             ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If lFr150flt
				If &cFr150flt
					DbSkip()
					Loop
				Endif
			Endif					
			
			#IFNDEF TOP			
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se trata-se de abatimento ou provisorio, ou ?
			//? Somente titulos emitidos ate a data base				   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF SE2->E2_TIPO $ MVABATIM .Or. (SE2 -> E2_EMISSAO > dDataBase .and. mv_par36 == 2)
				dbSkip()
				Loop
			EndIF
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se ser? impresso titulos provisios		   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF E2_TIPO $ MVPROVIS .and. mv_par16 == 2
				dbSkip()
				Loop
			EndIF
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se ser? impresso titulos de Adiantamento	 	?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par27 == 2
				dbSkip()
				Loop
			EndIF
                                   
            #ENDIF
            
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se deve imprimir outras moedas?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If mv_par29 == 2 // nao imprime
				if SE2->E2_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					dbSkip()
					Loop
				endif	
			Endif  

			// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
			// compatibilizando com a vers刼 2.04 que n刼 gerava para titulos
			// de ISS e FunRural

			dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se esta dentro dos parametros ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
					E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
					E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
					E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
					E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
					E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
					E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
					(E2_EMISSAO > dDataBase .and. mv_par36 == 2) .OR. dDtContab  < mv_par18 .OR. ;
					E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
					dDtContab  > mv_par19  .Or. !&(fr150IndR())

				dbSkip()
				Loop
			Endif  
			
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se esta dentro do parametro compor pela data de digita玢o ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF mv_par34 == 2 .And. !Empty(E2_EMIS1) .And. !Empty(mv_par33)
				If E2_EMIS1 > mv_par33
					dbSkip()
					Loop
				Endif			
			Endif
						

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ?
			//? n苚 no relatio quando se considera database (mv_par21 = 1) ?
			//? ou caso n苚 se considere a database, se o titulo foi totalmen?
			//? te baixado.																  ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE2")
			IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,;
					IIF(mv_par34 == 1,(SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase),.F.))
				dbSkip()
				Loop
			EndIF
            
			 // Tratamento da correcao monetaria para a Argentina
			If  cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE2->E2_CONVERT=='N'
				dbSkip()
				Loop
			Endif

			
			dbSelectArea("SA2")
			MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			dbSelectArea("SE2")

			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If SE2->E2_VENCREA < dDataBase
				If mv_par17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
					dDataReaj := SE2->E2_VENCREA
				Else
					dDataReaj := dDataBase
				EndIf	
			Else
				dDataReaj := dDataBase
			EndIf       

			If mv_par21 == 1
				nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA,,If(mv_par35==1,SE2->E2_TXMOEDA,Nil),IIF(mv_par34 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
				//Verifica se existem compensa珲es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta珲es da filial corrente. Nao deve processar quando existe somente uma filial.
				If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1
					nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par34 == 2,3,1),aFiliais);
									,SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)),nDecs+1),nDecs)
				EndIf
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
					nSAldo -= SE2->E2_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
					nSAldo += SE2->E2_ACRESC
				Endif
			Else
				nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
			Endif
			If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
			   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

				//Quando considerar Titulos com emissao futura, eh necessario
				//colocar-se a database para o futuro de forma que a Somaabat()
				//considere os titulos de abatimento
				If mv_par36 == 1
					dOldData := dDataBase
					dDataBase := CTOD("31/12/40")
				Endif

				nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)

				If mv_par36 == 1
					dDataBase := dOldData
				Endif
			EndIf

			nSaldo:=Round(NoRound(nSaldo,3),2)
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Desconsidera caso saldo seja menor ou igual a zero   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif

			aDados[FORNEC] := SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+If(mv_par28 == 1, SA2->A2_NREDUZ, SA2->A2_NOME)
			aDados[TITUL]		:= SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
			aDados[TIPO]		:= SE2->E2_TIPO
			aDados[NATUREZA]	:= SE2->E2_NATUREZ
			aDados[EMISSAO]	:= SE2->E2_EMISSAO
			aDados[VENCTO]		:= SE2->E2_VENCTO
			aDados[VENCREA]	:= SE2->E2_VENCREA
			aDados[VL_ORIG]	:= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 

			#IFDEF TOP
				If TcSrvType() == "AS/400"
					dbSetOrder( nQualIndice )
				Endif
			#ELSE
				dbSetOrder( nQualIndice )
			#ENDIF

			If dDataBase > SE2->E2_VENCREA 		//vencidos
				aDados[VL_NOMINAL] := nSaldo * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
				nJuros := 0
				dBaixa := dDataBase
				nJuros := fa080Juros(mv_par15)
				dbSelectArea("SE2")
				aDados[VL_CORRIG] := (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit1 -= nSaldo
					nTit2 -= nSaldo+nJuros
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit1 -= nSaldo
					nMesTit2 -= nSaldo+nJuros
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit1 += nSaldo
					nTit2 += nSaldo+nJuros
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit1 += nSaldo
					nMesTit2 += nSaldo+nJuros
				Endif
				nTotJur += (nJuros)
				nMesTitJ += (nJuros)
			Else				  //a vencer
				aDados[VL_VENCIDO] := nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit3 -= nSaldo
					nTit4 -= nSaldo
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit3 -= nSaldo
					nMesTit4 -= nSaldo
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit3 += nSaldo
					nTit4 += nSaldo
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit3 += nSaldo
					nMesTit4 += nSaldo
				Endif
			Endif

			ADados[PORTADOR] := SE2->E2_PORTADO

			If nJuros > 0
				aDados[VL_JUROS] := nJuros
				nJuros := 0
			Endif

			IF dDataBase > E2_VENCREA
				nAtraso:=dDataBase-E2_VENCTO
				IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso:=0
					EndIF
				EndIF
				nAtraso := If(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					aDados[ATRASO] := nAtraso
				EndIF
			EndIF
			If mv_par20 == 1	//1- Analitico  2-Sintetico									
				aDados[HISTORICO] := SUBSTR(SE2->E2_HIST,1,24)+If(E2_TIPO $ MVPROVIS,"*"," ")				
				oSection1:PrintLine()
				aFill(aDados,nil)				
			EndIf

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Carrega data do registro para permitir ?
			//? posterior analise de quebra por mes.	 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

			If nOrdem == 5		//Forncedor
				cNomFor := If(mv_par28 == 1,AllTrim(SA2->A2_NREDUZ),AllTrim(SA2->A2_NOME))+" "+Substr(SA2->A2_TEL,1,15)
            ElseIf nOrdem == 7	//Codigo Fornecedor
				cNomFor :=	SA2->A2_COD+" "+SA2->A2_LOJA+" "+AllTrim(SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
			EndIf
			
			If nOrdem == 2		//Natureza
				dbSelectArea("SED")
				dbSetOrder(1)
				dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
				cNomNat	 := SED->ED_CODIGO+" "+SED->ED_DESCRIC
			EndIf
			
			cNumBco	 := SE2->E2_PORTADO
			dDtVenc  := IIf(nOrdem == 3,SE2->E2_VENCREA,SE2->E2_EMISSAO)
			nTotVenc := nTit2+nTit3
			nTotMes	 := nMesTit2+nMesTit3

			SE2->(dbSkip())

			nTotTit ++
			nMesTTit ++
			nFiltit++
			nTit5 ++
		EndDo

		If nTit5 > 0 .and. nOrdem != 1 .And. mv_par20 == 2	//1- Analitico  2-Sintetico	
			SubT150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)
		EndIF
				
	   	nTotGeral  := nTotMes 
		nTotTitMes := nMesTTit

		If mv_par20 == 2	//1- Analitico  2-Sintetico	
			lQuebra := .F.
			If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
				lQuebra := .T.
			Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
				lQuebra := .T.
			Endif
			If lQuebra .And. nMesTTit # 0
				oReport:SkipLine()
				IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)
				oReport:SkipLine()
				nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
			Endif
		EndIf
				
		dbSelectArea("SE2")

		nTot0 += nTit0
		nTot1 += nTit1
		nTot2 += nTit2
		nTot3 += nTit3
		nTot4 += nTit4
		nTotJ += nTotJur

		nFil0 += nTit0
		nFil1 += nTit1
		nFil2 += nTit2
		nFil3 += nTit3
		nFil4 += nTit4
		nFilJ += nTotJur
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
	Enddo					
        
	nTotMes 	:= nTotVenc
	nTotFil 	:= nFil0	
	lTemCont := If(nFil0 > 0,.T.,.F.)
	If lTemCont		
		cNomFil 	:= cFilAnt + " - " + AllTrim(SM0->M0_FILIAL)
		cNomFilAnt  := cNomFil
	Else
		cNomFil := cNomFilAnt  
	Endif
		
	If mv_par20 == 2	//1- Analitico  2-Sintetico	
		if mv_par22 == 1 .and. SM0->(Reccount()) > 1
			oReport:SkipLine()
			IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,oReport,oSection1)
			oReport:SkipLine()			
		Endif	
	EndIf	
		
	dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
	Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
	If Empty(xFilial("SE2"))
		Exit
	Endif
	#IFDEF TOP
		if TcSrvType() != "AS/400"
			dbSelectArea("SE2")
			dbCloseArea()
			ChKFile("SE2")
			dbSetOrder(1)
		endif
	#ENDIF
	dbSelectArea("SM0")
	dbSkip()
		
EndDo

SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

If mv_par20 == 2	//1- Analitico  2-Sintetico	
	ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)
EndIf

oSection1:Finish()

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil()
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	else
		dbSelectArea( "SE2" )
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF	

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Restaura empresa / filial original    ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
SM0->(dbGoto(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//Acerta a database de acordo com a database real do sistema
If mv_par21 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return


/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 砈ubT150R  ? Autor ? Wagner Xavier 		  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR SUBTOTAL DO RELATORIO 									  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? SubT150R()  															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function SubT150R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,oReport,oSection1)

Local cQuebra := ""

If nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 6
	cQuebra := "S U B - T O T A L ----> " + DtoC(cCarAnt) //"S U B - T O T A L ----> "
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	cQuebra := cCarAnt +" "+SED->ED_DESCRIC
ElseIf nOrdem == 4
	cQuebra := "S U B - T O T A L ----> " + cCarAnt //"S U B - T O T A L ----> "
Elseif nOrdem == 5
	cQuebra := If(mv_par28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	cQuebra := SA2->A2_COD+" "+SA2->A2_LOJA+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Endif

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| cQuebra })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTit1   })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTit2   })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTit3   })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJur })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTit2+nTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矷mpT150R  ? Autor ? Wagner Xavier 		  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO 										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? ImpT150R()	 															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
STATIC Function ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| "T O T O A L   G E R A L ----> " + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,"TITULOS","TITULO")+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTot1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTot2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTot3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTot2+nTot3 })

oSection1:PrintLine()

Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矷Mes150R  ? Autor ? Vinicius Barreira	  ? Data ? 12.12.94 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? IMes150R()  															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
STATIC Function IMes150R(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nTotTitMes,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| "T O T O A L   M E S ----> " + "("+ALLTRIM(STR(nTotTitMes))+" "+IIF(nTotTitMes > 1,OemToAnsi("TITULOS"),OemToAnsi("TITULO"))+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nMesTit1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nMesTit2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nMesTit3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nMesTitJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nMesTit2+nMesTit3 })

oSection1:PrintLine()

Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? IFil150R	? Autor ? Paulo Boschetti 	     ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Imprimir total do relatorio										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? IFil150R()																  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?																				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico				   									 			  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function IFil150R(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| "T O T A L   F I L I A L ----> "  + " " + cFilAnt + " - " + AllTrim(SM0->M0_FILIAL) })	//"T O T A L   F I L I A L ----> " 
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nFil1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nFil2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nFil3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nFilJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nFil2+nFil3 })

oSection1:PrintLine()

Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矵abiCel	? Autor ? Daniel Tadashi Batori ? Data ? 04/08/06 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 砲abilita ou desabilita celulas para imprimir totais		  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? HabiCel()	 											  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 															  潮?
北?			 ? oReport ->objeto TReport que possui as celulas 			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 												  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function HabiCel(oReport)

Local oSection1 := oReport:Section(1)

oSection1:Cell("FORNECEDOR"):SetSize(50)
oSection1:Cell("TITULO"    ):Disable()
oSection1:Cell("E2_TIPO"   ):Hide()
oSection1:Cell("E2_NATUREZ"):Hide()
oSection1:Cell("E2_EMISSAO"):Hide()
oSection1:Cell("E2_VENCTO" ):Hide()
oSection1:Cell("E2_VENCREA"):Hide()
oSection1:Cell("VAL_ORIG"  ):Hide()
oSection1:Cell("E2_PORTADO"):Hide()
oSection1:Cell("DIA_ATR"   ):Hide()
oSection1:Cell("E2_HIST"   ):Disable()
oSection1:Cell("VAL_SOMA"  ):Enable()

oSection1:Cell("FORNECEDOR"):HideHeader()
oSection1:Cell("E2_TIPO"   ):HideHeader()
oSection1:Cell("E2_NATUREZ"):HideHeader()
oSection1:Cell("E2_EMISSAO"):HideHeader()
oSection1:Cell("E2_VENCTO" ):HideHeader()
oSection1:Cell("E2_VENCREA"):HideHeader()
oSection1:Cell("VAL_ORIG"  ):HideHeader()
oSection1:Cell("E2_PORTADO"):HideHeader()
oSection1:Cell("DIA_ATR"   ):HideHeader()	

Return(.T.)



/*
---------------------------------------------------------- RELEASE 3 ---------------------------------------------
*/



/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? FINR150R3? Autor ? Wagner Xavier   	     ? Data ? 02.10.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Posi噭o dos Titulos a Pagar										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? FINR150R3(void)														  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅ar僲etros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Gen俽ico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function FinR150R3()
//谀哪哪哪哪哪哪哪哪目
//? Define Vari爒eis ?
//滥哪哪哪哪哪哪哪哪馁
Local cDesc1 :=OemToAnsi("Imprime a posi噭o dos titulos a pagar relativo a data base")  //"Imprime a posi噭o dos titulos a pagar relativo a data base"
Local cDesc2 :=OemToAnsi("do sistema.")  //"do sistema."
LOCAL cDesc3 :=""
LOCAL cString:="SE2"
LOCAL nRegEmp := SM0->(RecNo())
Local dOldDtBase := dDataBase
Local dOldData := dDataBase
Local wnrel
Local nTamPar01,nTamPar02,nTamPar03,nTamPar04,nTamPar05,nTamPar06,nTamPar09,nTamPar10,nTamPar11,nTamPar12,nTamPar23,nTamPar24,nTamPar25,nTamPar26,nTamPar30,nTamPar31
Local i

PRIVATE cPerg    := Padr("FIN150M",Len(SX1->X1_GRUPO))
PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR150"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE nJuros  :=0
PRIVATE tamanho:="G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2

//谀哪哪哪哪哪哪哪哪哪哪哪哪目
//? Definicao dos cabe嘺lhos ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪馁
titulo := OemToAnsi("Posicao dos Titulos a Pagar")  //"Posicao dos Titulos a Pagar"
cabec1 := IIf(cPaisloc =="MEX",OemToAnsi("Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos vencidos          | Titulos a vencer | Porta-|  Vlr.juros ou   Dias   Historico     "),OemToAnsi("Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos vencidos          | Titulos a vencer | Porta-|  Vlr.juros ou   Dias   Historico     "))  //"Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos vencidos          | Titulos a vencer | Porta-|  Vlr.juros ou   Dias   Historico     "
cabec2 := OemToAnsi("                            Parcela                            Emissao  Titulo    Real                         |  Valor nominal   Valor corrigido |   Valor nominal  | dor   |   permanencia   Atraso               ")  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor nominal   Valor corrigido |   Valor nominal  | dor   |   permanencia   Atraso               "

//Nao retire esta chamada. Verifique antes !!!
//Ela ? necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Verifica as perguntas selecionadas ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
CriaSX1( cPerg )

pergunte("FIN150M",.F.)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Variaveis utilizadas para parametros ?
//? mv_par01	  // do Numero 			  ?
//? mv_par02	  // at? o Numero 		  ?
//? mv_par03	  // do Prefixo			  ?
//? mv_par04	  // at? o Prefixo		  ?
//? mv_par05	  // da Natureza  	     ?
//? mv_par06	  // at? a Natureza		  ?
//? mv_par07	  // do Vencimento		  ?
//? mv_par08	  // at? o Vencimento	  ?
//? mv_par09	  // do Banco			     ?
//? mv_par10	  // at? o Banco		     ?
//? mv_par11	  // do Fornecedor		  ?
//? mv_par12	  // at? o Fornecedor	  ?
//? mv_par13	  // Da Emiss刼			  ?
//? mv_par14	  // Ate a Emiss刼		  ?
//? mv_par15	  // qual Moeda			  ?
//? mv_par16	  // Imprime Provisios  ?
//? mv_par17	  // Reajuste pelo vencto ?
//? mv_par18	  // Da data contabil	  ?
//? mv_par19	  // Ate data contabil	  ?
//? mv_par20	  // Imprime Rel anal/sint?
//? mv_par21	  // Considera  Data Base??
//? mv_par22	  // Cons filiais abaixo ??
//? mv_par23	  // Filial de            ?
//? mv_par24	  // Filial ate           ?
//? mv_par25	  // Loja de              ?
//? mv_par26	  // Loja ate             ?
//? mv_par27 	  // Considera Adiantam.? ?
//? mv_par28	  // Imprime Nome 		  ?
//? mv_par29	  // Outras Moedas 		  ?
//? mv_par30     // Imprimir os Tipos    ?
//? mv_par31     // Nao Imprimir Tipos	  ?
//? mv_par32     // Consid. Fluxo Caixa  ?
//? mv_par33     // DataBase             ?
//? mv_par34     // Tipo de Data p/Saldo ?
//? mv_par35     // Quanto a taxa		  ?
//? mv_par36     // Tit.Emissao Futura	  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Envia controle para a funcao SETPRINT ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?

#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE2") == 0
		ChkFile("SE2",.f.,"__SE2")
	Endif
#ENDIF

If IsBlind() // Guardando os tamanhos para restaurar apos pegar os valores do webspool
	nTamPar01:=len(mv_par01)
	nTamPar02:=len(mv_par02)
	nTamPar03:=len(mv_par03)
	nTamPar04:=len(mv_par04)
	nTamPar05:=len(mv_par05)
	nTamPar06:=len(mv_par06)
	nTamPar09:=len(mv_par09)
	nTamPar10:=len(mv_par10)
	nTamPar11:=len(mv_par11)
	nTamPar12:=len(mv_par12)
	nTamPar23:=len(mv_par23)
	nTamPar24:=len(mv_par24)
	nTamPar25:=len(mv_par25)
	nTamPar26:=len(mv_par26)
	nTamPar30:=len(mv_par30)
	nTamPar31:=len(mv_par31)
EndIf

wnrel := "FINR150"            //Nome Default do relatorio em Disco
aOrd	:= {OemToAnsi("Por Numero"),OemToAnsi("Por Natureza"),OemToAnsi("Por Vencimento") ,;  //"Por Numero"###"Por Natureza"###"Por Vencimento"
	OemToAnsi("Por Banco"),OemToAnsi("Fornecedor"),OemToAnsi("Por Emissao"),OemToAnsi("Por Cod.Fornec.") ,OemToAnsi("Por Valor") }  //"Por Banco"###"Fornecedor"###"Por Emissao"###"Por Cod.Fornec."
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If IsBlind() // Acerto dos parametros apos chamada pelo webspool
	mv_par01:=padr(IIf(alltrim(mv_par01)='#','',mv_par01), nTamPar01)
	mv_par02:=padr(IIf(alltrim(mv_par02)='#','',mv_par02), nTamPar02)
	mv_par03:=padr(IIf(alltrim(mv_par03)='#','',mv_par03), nTamPar03)
	mv_par04:=padr(IIf(alltrim(mv_par04)='#','',mv_par04), nTamPar04)
	mv_par05:=padr(IIf(alltrim(mv_par05)='#','',mv_par05), nTamPar05)
	mv_par06:=padr(IIf(alltrim(mv_par06)='#','',mv_par06), nTamPar06)
	mv_par09:=padr(IIf(alltrim(mv_par09)='#','',mv_par09), nTamPar09)
	mv_par10:=padr(IIf(alltrim(mv_par10)='#','',mv_par10), nTamPar10)
	mv_par11:=padr(IIf(alltrim(mv_par11)='#','',mv_par11), nTamPar11)
	mv_par12:=padr(IIf(alltrim(mv_par12)='#','',mv_par12), nTamPar12)
	mv_par22:=IIf(valtype(mv_par22)='C',val(mv_par22),mv_par22)
	mv_par23:=padr(IIf(alltrim(mv_par23)='#','',mv_par23), nTamPar23)
	mv_par24:=padr(IIf(alltrim(mv_par24)='#','',mv_par24), nTamPar24)
	mv_par25:=padr(IIf(alltrim(mv_par25)='#','',mv_par25), nTamPar25)
	mv_par26:=padr(IIf(alltrim(mv_par26)='#','',mv_par26), nTamPar26)
	mv_par30:=padr(IIf(alltrim(mv_par30)='#','',mv_par30), nTamPar30)
	mv_par31:=padr(IIf(alltrim(mv_par31)='#','',mv_par31), nTamPar31)
EndIf

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa150Imp(@lEnd,wnRel,cString)},Titulo)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Restaura empresa / filial original    ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
SM0->(dbGoto(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

//Acerta a database de acordo com a database real do sistema
If mv_par21 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? FA150Imp ? Autor ? Wagner Xavier 		  ? Data ? 02.10.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Posi噭o dos Titulos a Pagar										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? FA150Imp(lEnd,wnRel,cString)										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? lEnd	  - A嚻o do Codeblock										  潮?
北?			 ? wnRel   - Tulo do relatio 									  潮?
北?			 ? cString - Mensagem										 			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Gen俽ico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function FA150Imp(lEnd,wnRel,cString)

LOCAL CbCont
LOCAL CbTxt
LOCAL nOrdem :=0
LOCAL nQualIndice := 0
LOCAL lContinua := .T.
LOCAL nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
LOCAL nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
LOCAL nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
LOCAL cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
LOCAL dDataReaj
LOCAL dDataAnt := dDataBase , lQuebra
LOCAL nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
LOCAL dDtContab
LOCAL	cIndexSe2
LOCAL	cChaveSe2
LOCAL	nIndexSE2
LOCAL cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
Local cTamFor, cTamTit := ""
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par15)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt
Local aFiliais := {}      

#IFDEF TOP
	Local nI := 0
	Local aStru := SE2->(dbStruct())
#ENDIF

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase

//*******************************************************
// Solu玢o para o problema no filtro de Serie minuscula *
//*******************************************************
mv_par04 := LOWER(mv_par04)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? Ponto de entrada para Filtrar 										  ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪? Localiza嚁es Argentina馁
If lFr150Flt
	cFr150Flt := EXECBLOCK("Fr150FLT",.f.,.f.)
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Variaveis utilizadas para Impress刼 do Cabe嘺lho e Rodap? ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
cbtxt  := OemToAnsi("* indica titulo provisorio, P indica Saldo Parcial")  //"* indica titulo provisorio, P indica Saldo Parcial"
cbcont := 0
li 	 := 80
m_pag  := 1

nOrdem := aReturn[8]
cMoeda := LTrim(Str(mv_par15))
Titulo += OemToAnsi(" em ")+GetMv("MV_MOEDA"+cMoeda)  //" em "

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par22 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par23
	cFilAte:= mv_par24
Endif

//Acerta a database de acordo com o parametro
If mv_par21 == 1    // Considera Data Base
	dDataBase := mv_par33
Endif	

// Cria vetor com os codigos das filiais da empresa corrente
aFiliais := FinRetFil()

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte

	dbSelectArea("SE2")
	cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

	#IFDEF TOP
		// Monta total de registros para IncRegua()
		If !Empty(mv_par07)	
			cQuery := "SELECT COUNT( R_E_C_N_O_ ) TOTREC "
			cQuery += "FROM " + RetSqlName("SE2") + " "
			cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND "
			cQuery += "E2_VENCREA >= '" + DtoS(mv_par07) + "' AND "
			cQuery += "E2_VENCREA <= '" + DtoS(mv_par08) + "' AND "
			cQuery += "D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
			nTotsRec := TRB->TOTREC
		Else
			cQuery := "SELECT COUNT( R_E_C_N_O_ ) TOTREC "
			cQuery += "FROM " + RetSqlName("SE2") + " "
			cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND "
			cQuery += "E2_EMISSAO >= '" + DtoS(mv_par13) + "' AND "
			cQuery += "E2_EMISSAO <= '" + DtoS(mv_par14) + "' AND "
			cQuery += "D_E_L_E_T_ = ' '"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
			nTotsRec := TRB->TOTREC
		EndIf
                     
		dbSelectArea("TRB")
		dbCloseArea()      
		dbSelectArea("SE2")

		if TcSrvType() != "AS/400"
			cQuery := "SELECT * "
			cQuery += "  FROM "+	RetSqlName("SE2")
			cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
			cQuery += "   AND D_E_L_E_T_ = ' ' "
		endif
	#ENDIF

	IF nOrdem == 1
		SE2->(dbSetOrder(1))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
		#ENDIF
		cCond1 := "E2_PREFIXO <= mv_par04"
		cCond2 := "E2_PREFIXO"
		titulo += OemToAnsi(" - Por Numero")  //" - Por Numero"
		nQualIndice := 1
	Elseif nOrdem == 2
		SE2->(dbSetOrder(2))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par05,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par05,.T.)
		#ENDIF
		cCond1 := "E2_NATUREZ <= mv_par06"
		cCond2 := "E2_NATUREZ"
		titulo += OemToAnsi(" - Por Natureza")  //" - Por Natureza"
		nQualIndice := 2
	Elseif nOrdem == 3
		SE2->(dbSetOrder(3))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
		#ENDIF
		cCond1 := "E2_VENCREA <= mv_par08"
		cCond2 := "E2_VENCREA"
		titulo += OemToAnsi(" - Por Vencimento")  //" - Por Vencimento"
		nQualIndice := 3
	Elseif nOrdem == 4
		SE2->(dbSetOrder(4))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par09,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par09,.T.)
		#ENDIF
		cCond1 := "E2_PORTADO <= mv_par10"
		cCond2 := "E2_PORTADO"
		titulo += OemToAnsi(" - Por Banco")  //" - Por Banco"
		nQualIndice := 4
	Elseif nOrdem == 6
		SE2->(dbSetOrder(5))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
		#ENDIF
		cCond1 := "E2_EMISSAO <= mv_par14"
		cCond2 := "E2_EMISSAO"
		titulo += OemToAnsi(" - Por Emissao")  //" - Por Emissao"
		nQualIndice := 5
	Elseif nOrdem == 7
		SE2->(dbSetOrder(6))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par11,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par11,.T.)
		#ENDIF			
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE"
		titulo += OemToAnsi(" - Por Cod.Fornecedor")  //" - Por Cod.Fornecedor"
		nQualIndice := 6    
	Elseif nOrdem == 8
		cChaveSe2 := "E2_FILIAL+E2_VALOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			cIndexSe2 := CriaTrab(nil,.f.)
			IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
			nIndexSE2 := RetIndex("SE2")
			dbSetIndex(cIndexSe2+OrdBagExt())
			dbSetOrder(nIndexSe2+1)
			dbSeek(xFilial("SE2"))
		#ENDIF
		cCond1 := "E2_VALOR >= 0"
		cCond2 := "E2_VALOR"
		titulo += OemToAnsi(" - Por Valor")  
		nQualIndice := IndexOrd()	
	Else
		cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			cIndexSe2 := CriaTrab(nil,.f.)
			IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi("Selecionando Registros..."))  // //"Selecionando Registros..."
			nIndexSE2 := RetIndex("SE2")
			dbSetIndex(cIndexSe2+OrdBagExt())
			dbSetOrder(nIndexSe2+1)
			dbSeek(xFilial("SE2"))
		#ENDIF
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE+E2_LOJA"
		titulo += OemToAnsi(" - Por Fornecedor")  //" - Por Fornecedor"
		nQualIndice := IndexOrd()
	EndIF

	If mv_par20 == 1
		titulo += OemToAnsi(" - Analitico")  //" - Analitico"
	Else
		titulo += OemToAnsi(" - Sintetico")  // " - Sintetico"
		cabec1 := OemToAnsi("                                                                                          |        Titulos vencidos         |    Titulos a vencer     |           Valor dos juros ou                       (Vencidos+Vencer)")  // "                                                                                          |        Titulos vencidos         |    Titulos a vencer     |           Valor dos juros ou                       (Vencidos+Vencer)"
		cabec2 := OemToAnsi("                                                                                          | Valor nominal   Valor corrigido |      Valor nominal      |            com. permanencia                                         ")  // "                                                                                          | Valor nominal   Valor corrigido |      Valor nominal      |            com. permanencia                                         "
	EndIf

	dbSelectArea("SE2")
	cFilterUser:=aReturn[7]

	Set Softseek Off

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
			cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
			cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
			cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
			cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
			cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
			cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
			cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"

			//Considerar titulos cuja emissao seja maior que a database do sistema
			If mv_par36 == 2 
				cQuery += " AND E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
			Endif
	
			If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
				cQuery += " AND E2_TIPO IN "+FormatIn(mv_par30,";") 
			ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par31,";")
			EndIf
			If mv_par32 == 1
				cQuery += " AND E2_FLUXO <> 'N'"
			Endif 
						
			cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
			
			If mv_par16 == 2
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")			
			Endif
			
			If mv_par27 == 2
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")			 
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")			
			Endif							
						
			cQuery += " ORDER BY "+ cOrder
			cQuery += Iif(MV_PAR37 == 2," DESC","")           

			cQuery := ChangeQuery(cQuery)

			dbSelectArea("SE2")
			dbCloseArea()
			dbSelectArea("SA2")

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)

			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		endif
	#ENDIF

	SetRegua(nTotsRec)
	
	If MV_MULNATP .And. nOrdem == 2
		Finr155R3(cFr150Flt, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ )
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				dbSelectArea("SE2")
				dbCloseArea()
				ChKFile("SE2")
				dbSetOrder(1)
			endif
		#ENDIF
		If Empty(xFilial("SE2"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif

	While &cCond1 .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")

		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
			Exit
		End

		IncRegua()

		dbSelectArea("SE2")

		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Carrega data do registro para permitir ?
		//? posterior analise de quebra por mes.	 ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

		cCarAnt := &cCond2

		While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")

			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
				Exit
			End

			IncRegua()

			dbSelectArea("SE2")

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Considera filtro do usuario                                  ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Considera filtro do usuario no ponto de entrada.             ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If lFr150flt
				If &cFr150flt
					DbSkip()
					Loop
				Endif
			Endif
			
			#IFNDEF TOP						
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//? Verifica se trata-se de abatimento ou provisorio, ou ?
				//? Somente titulos emitidos ate a data base				   ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				IF SE2->E2_TIPO $ MVABATIM .Or. (SE2 -> E2_EMISSAO > dDataBase .and. mv_par36 == 2)
					dbSkip()
					Loop
				EndIF
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//? Verifica se ser? impresso titulos provisios		   ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				IF E2_TIPO $ MVPROVIS .and. mv_par16 == 2
					dbSkip()
					Loop
				EndIF	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//? Verifica se ser? impresso titulos de Adiantamento	 ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par27 == 2
					dbSkip()
					Loop
				EndIF      
				         
            #ENDIF
            
            //谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se deve imprimir outras moedas?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If mv_par29 == 2 // nao imprime
				if SE2->E2_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					dbSkip()
					Loop
				endif	
			Endif   
			
			// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
			// compatibilizando com a vers刼 2.04 que n刼 gerava para titulos
			// de ISS e FunRural

			dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se esta dentro dos parametros ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
					E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
					E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
					E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
					E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
					E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
					E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
					(E2_EMISSAO > dDataBase .and. mv_par36 == 2) .OR. dDtContab  < mv_par18 .OR. ;
					E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
					dDtContab  > mv_par19  .Or. !&(fr150IndR())

				dbSkip()
				Loop
			Endif
			     
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se esta dentro do parametro compor pela data de digita玢o ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			IF mv_par34 == 2 .And. !Empty(E2_EMIS1) .And. !Empty(mv_par33)
				If E2_EMIS1 > mv_par33
					dbSkip()
					Loop
				Endif			
			Endif
			

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ?
			//? n苚 no relatio quando se considera database (mv_par21 = 1) ?
			//? ou caso n苚 se considere a database, se o titulo foi totalmen?
			//? te baixado.																  ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dbSelectArea("SE2")
			IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,;
					IIF(mv_par34 == 1,(SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase),.F.))
				dbSkip()
				Loop
			EndIF		
			
			 // Tratamento da correcao monetaria para a Argentina
			If  cPaisLoc=="ARG" .And. mv_par15 <> 1  .And.  SE2->E2_CONVERT=='N'
				dbSkip()
				Loop
			Endif
             

			dbSelectArea("SA2")
			MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			dbSelectArea("SE2")

			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If SE2->E2_VENCREA < dDataBase
				If mv_par17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
					dDataReaj := SE2->E2_VENCREA
				Else
					dDataReaj := dDataBase
				EndIf	
			Else
				dDataReaj := dDataBase
			EndIf       

			If mv_par21 == 1
				nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA,,If(mv_par35==1,SE2->E2_TXMOEDA,Nil),IIF(mv_par34 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
				//Verifica se existem compensa珲es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta珲es da filial corrente. Nao deve processar quando existe somente uma filial.
				If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5")) .And. Len(aFiliais) > 1
					nSaldo -= Round(NoRound(xMoeda(FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par34 == 2,3,1),aFiliais);
									,SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)),nDecs+1),nDecs)
				EndIf
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
					nSAldo -= SE2->E2_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
					nSAldo += SE2->E2_ACRESC
				Endif
			Else
				nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
			Endif
			If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
			   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

				//Quando considerar Titulos com emissao futura, eh necessario
				//colocar-se a database para o futuro de forma que a Somaabat()
				//considere os titulos de abatimento
				If mv_par36 == 1
					dOldData := dDataBase
					dDataBase := CTOD("31/12/40")
				Endif

				nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)

				If mv_par36 == 1
					dDataBase := dOldData
				Endif
			EndIf

			nSaldo:=Round(NoRound(nSaldo,3),2)
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Desconsidera caso saldo seja menor ou igual a zero   ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif

			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF

			If mv_par20 == 1				
				If !(Alltrim(cPaisLoc) $ "MEX|POR")
					@li,	0 PSAY SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+IIF(mv_par28 == 1, SubStr(SA2->A2_NREDUZ,1,15), SubStr(SA2->A2_NOME,1,15))
					li := IIf (aTamFor[1] > 6,li+1,li)
					@li, 26 PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
                Else				
					If Len(SE2->E2_FORNECE) > 6
						@li, 00 PSAY SubStr(SE2->E2_FORNECE+"-"+SE2->E2_LOJA,01,25)
						cTamFor  :=  SubStr(IIF(mv_par28 == 1, SA2->A2_NREDUZ, SA2->A2_NOME),01,25)
	            	Else
						@li, 00 PSAY SubStr(SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+IIF(mv_par28 == 1, SubStr(SA2->A2_NREDUZ,1,15), SubStr(SA2->A2_NOME,1,15)),01,25)
						cTamFor  :=  SubStr(SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+IIF(mv_par28 == 1, SubStr(SA2->A2_NREDUZ,1,15), SubStr(SA2->A2_NOME,1,15)),26,50)
	            	EndIf
	            
					@li, 26 PSAY SubStr(SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA,01,20)
					cTamTit  :=  SubStr(SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA,21,40)
                Endif				
				@li, 47 PSAY SE2->E2_TIPO
				@li, 51 PSAY SE2->E2_NATUREZ
				@li, 62 PSAY SE2->E2_EMISSAO
				@Li, 73 PSAY SE2->E2_VENCTO
				@li, 84 PSAY SE2->E2_VENCREA
				@li, 95 PSAY xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture PesqPict("SE2","E2_VALOR",15,MV_PAR15)
			EndIf
			#IFDEF TOP
				If TcSrvType() == "AS/400"
					dbSetOrder( nQualIndice )
				Endif
			#ELSE
				dbSetOrder( nQualIndice )
			#ENDIF

			If dDataBase > SE2->E2_VENCREA 		//vencidos
				If mv_par20 == 1
					@ li, 111 PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,15,nDecs)
				EndIf
				nJuros:=0
				dBaixa:=dDataBase
				fa080Juros(mv_par15)
				dbSelectArea("SE2")
				If mv_par20 == 1
					@li,128 PSAY (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo+nJuros,15,nDecs)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit1 -= nSaldo
					nTit2 -= nSaldo+nJuros
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit1 -= nSaldo
					nMesTit2 -= nSaldo+nJuros
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit1 += nSaldo
					nTit2 += nSaldo+nJuros
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit1 += nSaldo
					nMesTit2 += nSaldo+nJuros
				Endif
				nTotJur += (nJuros)
				nMesTitJ += (nJuros)
			Else				  //a vencer
				If mv_par20 == 1
					@li,147 PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,15,nDecs)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit3 -= nSaldo
					nTit4 -= nSaldo
					nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit3 -= nSaldo
					nMesTit4 -= nSaldo
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nTit3 += nSaldo
					nTit4 += nSaldo
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))
					nMesTit3 += nSaldo
					nMesTit4 += nSaldo
				Endif
			Endif
			If mv_par20 == 1
				@Li,165 PSAY SE2->E2_PORTADO
			EndIf
			If nJuros > 0
				If mv_par20 == 1
					@Li,173 PSAY nJuros Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
				EndIf
				nJuros := 0
			Endif

			IF dDataBase > E2_VENCREA
				nAtraso:=dDataBase-E2_VENCTO
				IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso:=0
					EndIF
				EndIF
				nAtraso:=IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par20 == 1
						@li,189 PSAY nAtraso Picture "9999"
					EndIf
				EndIF
			EndIF
			If mv_par20 == 1
				@li,194 PSAY SUBSTR(SE2->E2_HIST,1,24)+ ;
					IIF(E2_TIPO $ MVPROVIS,"*"," ")+ ;
					Iif(nSaldo - SE2->E2_ACRESC + SE2->E2_DECRESC == xMoeda(E2_VALOR,E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par35==1,SE2->E2_TXMOEDA,Nil))," ","P")
			EndIf
            
			If Alltrim(cPaisLoc) $ "MEX|POR"
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				//? Tratamento para imprimir restante do conte鷇o   ?
				//? dos campos quando maior que o permitido         ?
				//? para evitar impress鉶 incompleta ou imperfeita. ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
				If mv_par20 == 1 .and. (!Empty(cTamFor) .or. !Empty(cTamTit))
					li ++
					@li, 00 PSAY cTamFor
					@li, 26 PSAY cTamTit
				EndIf
			Endif
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//? Carrega data do registro para permitir ?
			//? posterior analise de quebra por mes.	 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

			dbSkip()
			nTotTit ++
			nMesTTit ++
			nFiltit++
			nTit5 ++
			If mv_par20 == 1
				li ++
			EndIf

		EndDO

		IF nTit5 > 0 .and. nOrdem != 1
			SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
			If mv_par20 == 1
				li++
			EndIf
		EndIF

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//? Verifica quebra por mes					 ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		lQuebra := .F.
		If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
			lQuebra := .T.
		Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
			lQuebra := .T.
		Endif
		If lQuebra .and. nMesTTit # 0
			ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif

		dbSelectArea("SE2")

		nTot0 += nTit0
		nTot1 += nTit1
		nTot2 += nTit2
		nTot3 += nTit3
		nTot4 += nTit4
		nTotJ += nTotJur

		nFil0 += nTit0
		nFil1 += nTit1
		nFil2 += nTit2
		nFil3 += nTit3
		nFil4 += nTit4
		nFilJ += nTotJur
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
	Enddo					

	dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//? Imprimir TOTAL por filial somente quan-?
	//? do houver mais do que 1 filial.        ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	if mv_par22 == 1 .and. SM0->(Reccount()) > 1
		ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,nDecs)
	Endif
	Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
	If Empty(xFilial("SE2"))
		Exit
	Endif

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			dbSelectArea("SE2")
			dbCloseArea()
			ChKFile("SE2")
			dbSetOrder(1)
		endif
	#ENDIF

	dbSelectArea("SM0")
	dbSkip()
EndDO

SM0->(dbGoTo(nRegSM0))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

IF li != 80
	If mv_par20 == 1
		li +=2
	Endif
	ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)
	cbcont := 1
	roda(cbcont,cbtxt,"G")
EndIF
Set Device To Screen

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil()
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	else
		dbSelectArea( "SE2" )
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF	

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 砈ubTot150 ? Autor ? Wagner Xavier 		  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR SUBTOTAL DO RELATORIO 									  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? SubTot150() 															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

If mv_par20 == 1
	li++
EndIf

IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

if nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 6
	@li,000 PSAY OemToAnsi("S U B - T O T A L ----> ")  //"S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	@li,000 PSAY cCarAnt +" "+SED->ED_DESCRIC
Elseif nOrdem == 5
	@Li,000 PSAY IIF(mv_par28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	@li,000 PSAY SA2->A2_COD+" "+SA2->A2_LOJA+" "+SA2->A2_NOME+" "+Substr(SA2->A2_TEL,1,15)
Endif
if mv_par20 == 1
	@li,096 PSAY nTit0		 Picture TM(nTit0,14,nDecs)
endif
@li,112 PSAY nTit1		 Picture TM(nTit1,14,nDecs)
@li,129 PSAY nTit2		 Picture TM(nTit2,14,nDecs)
@li,147 PSAY nTit3		 Picture TM(nTit3,14,nDecs)
If nTotJur > 0
	@li,173 PSAY nTotJur 	 Picture TM(nTotJur,12,nDecs)
Endif
@li,204 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,16,nDecs)
li++
Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矷mpTot150 ? Autor ? Wagner Xavier 		  ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO 										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? ImpTot150() 															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
STATIC Function ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi("T O T A L   G E R A L ----> ")  //"T O T A L   G E R A L ----> "
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi("TITULOS"),OemToAnsi("TITULO"))+")"  //"TITULOS"###"TITULO"
if mv_par20 == 1
	@li,095 PSAY nTot0		 Picture TM(nTot0,15,nDecs)
endif
@li,111 PSAY nTot1		 Picture TM(nTot1,15,nDecs)
@li,128 PSAY nTot2		 Picture TM(nTot2,15,nDecs)
@li,147 PSAY nTot3		 Picture TM(nTot3,15,nDecs)
@li,173 PSAY nTotJ		 Picture TM(nTotJ,12,nDecs)
@li,203 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,17,nDecs)
li+=2
Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 矷mpMes150 ? Autor ? Vinicius Barreira	  ? Data ? 12.12.94 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矷MPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? ImpMes150() 															  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? 																			  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
STATIC Function ImpMes150(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi("T O T A L   D O  M E S ---> ")  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi("TITULOS"),OemToAnsi("TITULO"))+")"  //"TITULOS"###"TITULO"
if mv_par20 == 1
	@li,096 PSAY nMesTot0   Picture TM(nMesTot0,14,nDecs)
endif
@li,112 PSAY nMesTot1	Picture TM(nMesTot1,14,nDecs)
@li,129 PSAY nMesTot2	Picture TM(nMesTot2,14,nDecs)
@li,147 PSAY nMesTot3	Picture TM(nMesTot3,14,nDecs)
@li,173 PSAY nMesTotJ	Picture TM(nMesTotJ,12,nDecs)
@li,204 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,16,nDecs)
li+=2
Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 ? ImpFil150? Autor ? Paulo Boschetti 	     ? Data ? 01.06.92 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o ? Imprimir total do relatorio										  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe e ? ImpFil150()																  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros?																				  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico				   									 			  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
STATIC Function ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi("T O T A L   F I L I A L ----> " )+" "+cFilAnt+" - " + AllTrim(SM0->M0_FILIAL)  //"T O T A L   F I L I A L ----> " 
if mv_par20 == 1
	@li,096 PSAY nFil0        Picture TM(nFil0,14,nDecs)
endif
@li,112 PSAY nFil1        Picture TM(nFil1,14,nDecs)
@li,129 PSAY nFil2        Picture TM(nFil2,14,nDecs)
@li,147 PSAY nFil3        Picture TM(nFil3,14,nDecs)
@li,173 PSAY nFilJ		  Picture TM(nFilJ,12,nDecs)
@li,204 PSAY nFil2+nFil3 Picture TM(nFil2+nFil3,16,nDecs)
li+=2
Return .T.

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噭o	 砯r150Indr ? Autor ? Wagner           	  ? Data ? 12.12.94 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噭o 矼onta Indregua para impressao do relatio						  潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso		 ? Generico 																  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function fr150IndR()
Local cString
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//? ATENCAO !!!!                                               ?
//? N刼 adiconar mais nada a chave do filtro pois a mesma est? ?
//? com 254 caracteres.                                        ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cString := 'E2_FILIAL="'+xFilial()+'".And.'
cString += '(E2_MULTNAT="1" .OR. (E2_NATUREZ>="'+mv_par05+'".and.E2_NATUREZ<="'+mv_par06+'")).And.'
cString += 'E2_FORNECE>="'+mv_par11+'".and.E2_FORNECE<="'+mv_par12+'".And.'
cString += 'DTOS(E2_VENCREA)>="'+DTOS(mv_par07)+'".and.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'".And.'
cString += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E2_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
	cString += '.And.E2_TIPO$"'+mv_par30+'"'
ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
	cString += '.And.!(E2_TIPO$'+'"'+mv_par31+'")'
EndIf
IF mv_par32 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E2_FLUXO!="N")'	
Endif
		
Return cString

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? PutDtBase? Autor ? Mauricio Pequim Jr    ? Data ? 18/07/02 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Ajusta parametro database do relat[orio.                   潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砋so       ? Finr150.                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek( padr( "FIN150M" , Len( x1_grupo ) , ' ' )+ "33")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif

dbSelectArea(_sAlias)
Return       


/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘?
北矲un噮o    ? CriaSX1  ? Autor ? Microsiga             ? Data ? 10.05.08 潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢?
北矰escri噮o ? Cria e analisa grupo de perguntas                          潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砈intaxe   ?                                                            潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北砅arametros? cPerg                                                      潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢?
北? Uso      ? Generico                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/

Static Function CriaSX1( cPerg )                                                                                         

Local i,j
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aTamSX3	:= {}
Local aRegs     := {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
//? Grava as perguntas no arquivo SX1                                                       ?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
aTamSX3	:= TAMSX3( "E5_NUMERO" )
AADD(aRegs,{cPerg,	"01","Do Numero ?"               ,"緿e Numero ?"                 ,"From Number ?"        ,"mv_ch1", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_numde"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"02","Ate o Numero ?"            ,"緼 Numero ?"                  ,"To Number ?"          ,"mv_ch2", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_numate" ,                "",               "",            "","ZZZZZZZZZ","",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "E5_PREFIXO" )
AADD(aRegs,{cPerg,	"03","Do Prefixo ?"              ,"緿e Prefijo ?"                ,"From Prefix ?"        ,"mv_ch3", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_prfde"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"04","Ate o Prefixo ?"           ,"緼 Prefijo ?"                 ,"To Prefix ?"          ,"mv_ch4", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_prfate" ,                "",               "",            "","ZZ"       ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 

aTamSX3	:= TAMSX3( "ED_CODIGO" )
AADD(aRegs,{cPerg,	"05","Da Natureza ?"             ,"緿e Naturaleza ?"             ,"From Class ?"         ,"mv_ch5", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_natde"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SED","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"06","Ate a Natureza ?"          ,"緼 Naturaleza ?"              ,"To Class ?"           ,"mv_ch6", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_natate" ,                "",               "",            "","ZZZZZZ"   ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SED","S",    "",          "","","" }) 

aTamSX3	:= TAMSX3( "E5_VENCTO" )
AADD(aRegs,{cPerg,	"07","Do Vencimento ?"           ,"緿e Vencimiento ?"            ,"From Due Date ?"      ,"mv_ch7", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_vencde" ,                "",               "",            "","01/01/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })  
AADD(aRegs,{cPerg,	"08","Ate o Vencimento ?"        ,"緼 Vencimiento ?"             ,"To Due Date ?"        ,"mv_ch8", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_vencate",                "",               "",            "","31/12/04" ,"",              "",                "",              "","","",         "",          "",            "","",            "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "A6_COD" )
AADD(aRegs,{cPerg,	"09","Do Banco ?"                ,"緿e Banco ?"                  ,"From Bank ?"          ,"mv_ch9", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_bcode"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","BCO","S","007" ,          "","","" })
AADD(aRegs,{cPerg,	"10","Ate o Banco ?"             ,"緼 Banco ?"                   ,"To Bank ?"            ,"mv_cha", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_bcoate" ,                "",               "",            "","ZZZ"      ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","BCO","S","007" ,          "","","" }) 

aTamSX3	:= TAMSX3( "A2_COD" )
AADD(aRegs,{cPerg,	"11","Do Fornecedor ?"           ,"緿e Proveedor ?"              ,"From Supplier ?"      ,"mv_chb", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_fornde" ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SA2","S","001" ,          "","","" })
AADD(aRegs,{cPerg,	"12","Ate o Fornecedor ?"        ,"緼 Proveedor ?"               ,"To Supplier ?"        ,"mv_chc", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_fornate",                "",               "",            "","ZZZZZZ"   ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SA2","S","001" ,          "","","" })

aTamSX3	:= TAMSX3( "E5_DATA" )
AADD(aRegs,{cPerg,	"13","Da Emissao ?"              ,"緿e Emision ?"                ,"From Issue Date ?"    ,"mv_chd", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_emisde" ,                "",               "",            "","01/01/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"14","Ate a Emissao ?"           ,"緼 Emision ?"                 ,"To Issue Date ?"      ,"mv_che", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_emisate",                "",               "",            "","21/12/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

AADD(aRegs,{cPerg,	"15","Qual Moeda ?"              ,"縌ue Moneda ?"                ,"Which Currency ?"     ,"mv_chf",        "N",          1,         0,         1,"C" ,"","mv_par15"  ,"Moeda 1"         ,"Moneda 1"       ,"Currency 1"  ,""         ,"","Moeda 2"       ,"Moneda 2"        ,"Currency 2"    ,"","", "Moeda 3" , "Moneda 3" , "Currency 3" ,"","", "Moeda 4" , "Moneda 4" , "Currency 4" ,"","", "Moeda 5" , "Moneda 5" , "Currency 5" ,"",   "","S",    "",          "","","" }) 
AADD(aRegs,{cPerg,	"16","Imprime Provisorios ?"     ,"縄mprime Provisorios ?"       ,"Print Temporary ?"    ,"mv_chg",        "N",          1,         0,         2,"C" ,"","mv_par16"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"17","Converte Venci pela ?"     ,"緾onvierte Vencidos por ?"    ,"Convert per ?"        ,"mv_chh",        "N",          1,         0,         2,"C" ,"","mv_par17"  ,"Data Base"       ,"Fecha de Hoy"   ,"Base Date"   ,""         ,"","Data de Vencto","Fecha Vencto."   ,"Due Date"      ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "E5_DATA" )
AADD(aRegs,{cPerg,	"18","Da data contabil ?"        ,"緼 Fecha Contable ?"          ,"From Acconting Date ?","mv_chh", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_dtcont1",                "",               "",            "","01/01/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"19","Ate data contabil ?"       ,"緼 Fecha Contable ?"          ,"To Accounting Date ?" ,"mv_chi", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_dtcont2",                "",               "",            "","31/12/04" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

AADD(aRegs,{cPerg,	"20","Imprime Relatorio ?"       ,"縄mprimir Informe ?"          ,"Print Report ?"       ,"mv_chj",        "N",          1,         0,         1,"C" ,"","mv_par20"  ,"Analitico"       ,"Analitico"      ,"Detailed"    ,""         ,"","Sintetico"     ,"Sintetico"       ,"Summarized"    ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"21","Compoem Saldo Retroativo ?","緾omponen Saldo Retroactivo ?","Consider Base Date ?" ,"mv_chk",        "N",          1,         0,         1,"C" ,"","mv_par21"  ,"Sim"             ,"Si"             ,"Yes "        ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"22","Cons.Filiais abaixo ?"     ,"緾onsidera Siguientes Suc ?"  ,"Cons.Branches below ?","mv_chx",        "C",          1,         0,         2,"C" ,"","mv_par22"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

aTamSX3	:= TAMSX3( "E5_FILIAL" )
AADD(aRegs,{cPerg,	"23","Da Filial ?"               ,"緿e Sucursal ?"               ,"From Branch ?"        ,"mv_chy", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par23"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"24","Ate a Filial ?"            ,"緼 Sucursal ?"                ,"To Branch ?"          ,"mv_chz", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par24"  ,                "",               "",            "","ZZ"       ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
                                                                                                                                                                                                                                                          
aTamSX3	:= TAMSX3( "E5_LOJA" )
AADD(aRegs,{cPerg,	"25","Da Loja ?"                 ,"緿e Tienda ?"                 ,"From Unit ?"          ,"mv_cho", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par25"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S","002" ,          "","","" })
AADD(aRegs,{cPerg,	"26","Ate a Loja ?"              ,"緼 Tienda ?"                  ,"To Unit ?"            ,"mv_chp", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par26"  ,                "",               "",            "","ZZ"       ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S","002" ,          "","","" })

AADD(aRegs,{cPerg,	"27","Considera Adiantam. ?"     ,"緾onsidera Anticipo ?"        ,"Consider Advance ?"   ,"mv_chq",        "N",          1,         0,         0,"C" ,"","mv_par27"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 
AADD(aRegs,{cPerg,	"28","Imprime Nome ?"            ,"縄mprime Nombre ?"            ,"Print Name ?"         ,"mv_chm",        "N",          1,         0,         1,"C" ,"","mv_par28"  ,"Nome Reduzido"   ,"Nombre Reducido","Reduced Name",""         ,"","Razao Social"  ,"Razon Social"    ,"Trade Name"    ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"29","Outras Moedas ?"           ,"縊tras Monedas ?"             ,"Other Currencies ?"   ,"mv_chn",        "N",          1,         0,         1,"C" ,"","mv_par29"  ,"Converter"       ,"Convertir"      ,"Convert"     ,""         ,"","Nao Imprimir"  ,"No Imprimir"     ,"Do Not Print"  ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"30","Imprimir Tipos ?"          ,"縄mprimir Tipos ?"            ,"Print Types ?"        ,"mv_cho",        "C",         40,         0,         0,"G" ,"","mv_par30"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"31","Nao Imprimir Tipos ?"      ,"縉o imprimir tipos ?"         ,"Do Not Print Types ?" ,"mv_chn",        "C",         40,         0,         0,"G" ,"","mv_par31"  ,                "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"32","Somente Tit.p/Fluxo ?"     ,"縎olamente Titulo p/Flujo ?"  ,"Only Bill per Flow ?" ,"mv_cho",        "N",          1,         0,         0,"C" ,"","mv_par32"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           ,"No"              ,"No"            ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 

aTamSX3	:= TAMSX3( "E5_DATA" )
AADD(aRegs,{cPerg,	"33","Data Base ?"               ,"縁echa Base ?"                ,"Base Date ?"          ,"MV_CHR", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","mv_par33"  ,                "",               "",            "","01/01/04","",               "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })

AADD(aRegs,{cPerg,	"34","Compoe Saldo por ?"        ,"緾ompone saldo por ?"         ,"Set Balance by ?"     ,"MV_CHS",        "N",          1,         0,         1,"C" ,"","mv_par34"  ,"Data da Baixa"   ,"Fecha Baja"     ,"Posting Date",""         ,"","Data Digitacao", "Fch.Digitacion" , "Entry Date"   ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 
AADD(aRegs,{cPerg,	"35","Quanto a taxa ?"           ,"緾on referencia a tasa ?"     ,"How about rate ?"     ,"MV_CHT",        "N",          1,         0,         1,"C" ,"","mv_par35"  ,"Taxa contratada" ,"Tasa contratada","Hired rate"  ,""         ,"","Taxa normal"   , "Tasa normal"    , "Standard rate","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
AADD(aRegs,{cPerg,	"36","Tit. Emissao Futura ?"     ,"縏it. Emision Futura ?"       ,"Future issue bill ?"  ,"MV_CHU",        "N",          1,         0,         2,"C" ,"","mv_par36"  ,"Sim"             ,"Si"             ,"Yes"         ,""         ,"","Nao"           , "No"             , "No"           ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",".FIN15036.","","" }) 
AADD(aRegs,{cPerg,	"37","Ordem de Impressao  ?"     ,"Ordem de Impressao  ?"        ,"Ordem de Impressao  ?","MV_CHV",        "N",          1,         0,         1,"C" ,"","mv_par37"  ,"Crescente"       ,"Crescente"      ,"Crescente"   ,""         ,"","Decrescente"   , "Decrescente"    , "Decrescente"  ,"","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" }) 
DbSelectArea("SX1")                                                                                                           
SX1->(DbSetOrder(1))                                                                                                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                                                                                                                                                                                                                                                           
For I := 1 To Len(aRegs)
	If 	!dbSeek(cPerg+aRegs[i,2])                                                                                                                                                                  
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			IF j <= Len(aRegs[i])           
				FieldPut(j,aRegs[i,j])
			EndIf                                          
		Next
		MsUnLock()
	Else                                                                     
		RecLock("SX1",.F.)
		For j:= 7 to 10
			FieldPut(j,aRegs[i,j])
		Next                                                                                                                                     
		MsUnLock()
	EndIf
Next

RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return()

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矨justaSX1 篈utor  砇aphael Zampieri    ? Data ?11.06.2008   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矨justa perguntas da tabela SX1                              罕?
北?          ?                                                            罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ? FINR150                                                    罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?
*/
Static Function AjustaSX1()

Local aArea := GetArea()
Local aRegs		:= {}  
Local nTamTitSX3:= 0       
Local cGrupoSX3	:= ""


dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E1_NUM")     
nTamTitSX3	:= SX3->X3_TAMANHO
cGrupoSX3	:= SX3->X3_GRPSXG  
dbSetOrder(1)

//            cPerg	Ordem	PergPort         cPerSpa        cPerEng           cVar  Tipo     nTam	 1 2 3    4   cVar01  cDef01  cDefSpa1    cDefEng1    cCont01	        cVar02	   cDef02           cDefSpa2         cDefEng2   cCnt02 cVar03 cDef03   cDefSpa3  cDefEng3  	cCnt03	cVar04	cDef04  cDefSpa4  cDefEng4  cCnt04 	cVar05 	 cDef05	 cDefSpa5  cDefEng5	 cCnt05	 cF3	cGrpSxg  cPyme	 aHelpPor aHelpEng	aHelpSpa  cHelp
AAdd(aRegs,{"FIN150", "01","Do Numero  ?","緿e Numero  ?","From Number  ?",  "mv_ch1","C",nTamTitSX3,0,0,"G","","mv_numde","",      "",         "",         "",               "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})
AAdd(aRegs,{"FIN150", "02","Ate o Numero  ?","緼 Numero  ?","To Number  ?",  "mv_ch2","C",nTamTitSX3,0,0,"G","","mv_numate","",      "",         "",    "ZZZZZZZZZZZZZZZZZZZZ",          "",        "",              "",              "",       "",    "",   "",        "",      "",       "",     "",    "",      "",        "",      "",     "",      "",     "",       "",      "",   "",   cGrupoSX3, "S",     "",      "",        "",     ""})

ValidPerg(aRegs,"FIN150",.T.)

RestArea( aArea )

Return
