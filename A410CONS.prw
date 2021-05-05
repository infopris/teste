#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} A410CONS              

@author 	cbarros | Claudio Barros
@since 		06/05/2017
@version 	P11
@obs    	Rotina Especifica Qualita
@Obs    	Ponto de entrada para gravar a forma de pagamento no 
@Obs        campo na tabela SZ8 forma de pagamento dos títulos
@Obs        que será incluido pelo usuário no momento da digitação do
@Obs        pedido de vendas.
/*/             
//-------------------------------------------------------------------
//Alterado: Bruna Zechetti - 03/07/2017 - inclusão de valores e rateio
// de IPI nas parcelas.                              
//-------------------------------------------------------------------                      

User Function A410CONS()

Local aBtnUsr := {}

aAdd(aBtnUsr , {"" ,{|| U_ForPagto(.F.) },"Formas Pagto","Formas Pagto"} )
aAdd(aBtnUsr , {"" ,{|| U__fPreNt1() },"Pré Pedido","Pré Pedido"} )

Return(aBtnUsr) 


User Function ForPagto(lAlt)
	
	Local aArea     := GetArea()
	Local aPosObj   := {}
	Local aObjects  := {}
	Local aSize     := MsAdvSize()
	Local nOpcA     := 0                                                      
	Local nTotalPed	:= 0 
	Local nMax		:= 0
	Local nMaxCols	:= 0   
	Local nPVencto	:= 0
	Local aRow		:= {}      
	Local aRowBase	:= {}
	Local oDlg
	Local oGetDad     
	Local oTFont 	:= TFont():New('Times New Roman',,-16,,.T.)
	Local _nQtdLib	:= 0
	Local _nTotLib	:= 0
	Local _nI		:= 0
	Local _lAux		:= .F.
	Local nOpcGrid	:= Iif((INCLUI .Or. ALTERA) .And. lAlt,GD_UPDATE+GD_DELETE,0)
		
	Private aRegSZ8 	:= {}    
    Private axHeadFor 	:= {}
    Private axColsFor 	:= {}
    Private _nVIPI		:= 0
    Private _nVlrMerc	:= 0
    Private _cTipo		:= ""
    Private _nValParc	:= 0 
    Private aHeadSC6    := aClone(aHeader) 
    Private aColsSC6    := aClone(aCols)
        
   	Private _nPosCod := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
	Private _nPosTES := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})
	Private _nPosQTD := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"})
	Private _nPosPRV := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN"})
	Private _nPosTOT := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_VALOR"})
	Private _nPosDSC := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_VALDESC"})
	Private _nPosQLB := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDLIB"})
	Private _nPosITM := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM"})
	
	For _nI	:= 1 To Len(aCols)
		If aCols[_nI,_nPosQLB] > 0
			_lAux := .T.
		EndIf
	Next _nI
	
	If FunName() == "MATA465"
		INCLUI := .F.
		ALTERA := .F.
	EndIF
	
	If !_lAux .And. (INCLUI .Or. ALTERA)
		AVISO(OEMTOANSI("Pré Pedido de Venda"),OEMTOANSI("O Pedido não contém nenhuma quantidade liberada. Por favor, realizar o preenchimento desta informação para visualização desta opção"),{"Ok"},2)
	Else
	
		MaFisIni(Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT),M->C5_LOJAENT,IIf(M->C5_TIPO$'DB',"F","C"),M->C5_TIPO,M->C5_TIPOCLI,Nil,Nil,Nil,Nil,"MATA461")
		
		For i := 1 to Len(aCols)
			IF !aCols[i,Len(aHeader)+1]
				MaFisAdd(aCols[i,_nPosCod],aCols[i,_nPosTES],aCols[i,_nPosQLB]-_nQtdLib,aCols[i,_nPosPRV],aCols[i,_nPosDSC],"","",0,0,0,0,0,(aCols[i,_nPosPRV]*iIf(aCols[i][_nPosQLB] > 0,(aCols[i,_nPosQLB]-_nQtdLib),0)),0)
			ENDIF
		Next
		     
		_nVIPI		:= MaFisRet(,"NF_VALIPI")	   
		_nVlrMerc	:= MaFisRet(,"NF_VALMERC")
		
		MaFisEnd()
		
		If Empty(M->C5_CONDPAG)
		   MsgInfo("Informe a Condição de Pagamento!!!")
		   Return(Nil)
		Else
			dbSelectArea("SE4")
			SE4->(dbSetOrder(1))
			If SE4->(dbSeek(xFilial("SE4")+M->C5_CONDPAG))
				_cTipo	:= SE4->E4_TIPO
			EndIf
		EndIf   
		DbSelectArea("SZ8")
		QuaFormPg(axHeadFor,axColsFor,aRegSZ8)
		
		If( !Empty(M->C5_CONDPAG) )
			nTotalPed 	:= GetTotalPed()		 
			_nTotLib	:= GetTLPed()
			Private aHeader := aClone(axHeadFor)
			Private aCols   := aClone(axColsFor)   
		    Private n		:= 1
		 	
		 	If INCLUI .Or. ALTERA
				_nVlrMerc   := _nTotLib
				SetParcels(_nTotLib)
			EndIf

			If (_nVlrMerc+_nVIPI)!= _nValParc .And. _cTipo == '9' 
				AVISO(OEMTOANSI("Divergência de Valores"),OEMTOANSI("A soma do Valor das parcelas está divergente do valor total dos itens liberados do pedido. Verifique o valor correto na rotina de Pré-Pedido!"),{"Ok"},2)	
				Return(nil)
			EndIf
		 	
			aAdd( aObjects, { 100, 100, .t., .t. } )
		
			aSize[ 3 ] -= 50
			aSize[ 4 ] -= 50 	
			
			aSize[ 5 ] -= 100
			aSize[ 6 ] -= 050
			
			aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
			aPosObj := MsObjSize( aInfo, aObjects )
		  
			DbSelectArea("SZ8")
			DEFINE MSDIALOG oDlg TITLE OemToAnsi("Formas de Pagamento") From aSize[7],00 to aSize[6],aSize[5] Of oMainWnd PIXEL
				
				If FunName() == "MATA456"
					oGetDad := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],0,,,,,,4096,,,,,aHeader,aCols)
				Else
					oGetDad := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpcGRID,,,,,,4096,,,,,aHeader,aCols)
				EndIf
				If _cTipo <> "9"
					TSay():New(aPosObj[1,3]+10,aPosObj[1,2],{|| OemToAnsi("Total Mercadoria (R$):  " + Transform(_nVlrMerc,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)
					TSay():New(aPosObj[1,3]+10,(aPosObj[1,4]/3)+50,{|| OemToAnsi("Total IPI (R$):  "+ Transform(_nVIPI,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)
					TSay():New(aPosObj[1,3]+10,(aPosObj[1,4]/2)+180,{|| OemToAnsi("Total C/ IPI (R$):  "+ Transform(_nVlrMerc+_nVIPI,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)
				Else
     			    TSay():New(aPosObj[1,3]+10,aPosObj[1,2],{|| OemToAnsi("Total Mercadoria (R$):  " + Transform(_nValParc,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)
					TSay():New(aPosObj[1,3]+10,(aPosObj[1,4]/2)+180,{|| OemToAnsi("Total Parcelado (R$):  "+ Transform(_nValParc,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)
				EndIf
				
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,If(_fTudoOk(ogetdad:aHeader,ogetdad:aCols,lAlt),(GrvFormOk(ogetdad:aHeader,ogetdad:aCols),oDlg:End()),nOpcA := 0)},{||oDlg:End()}) CENTERED		   
		Else 
	   		Aviso( "Atenção", "Por favor, informe o campo Condição de Pagamento (C5_CONDPAG) antes de acessar esta opção", {"Ok"})		
		EndIf 
	EndIf
		
	RestArea(aArea)
Return(nOpcA)

Static Function _fGetQLB(_cProduto,_cItemPv)

	Local _nQtd		:= 0
	Local _cQuery	:= ""
	Local _cAlias	:= GetNextAlias()
	
	_cQuery := "SELECT SUM(D2_QUANT) AS QTDEFAT "
	_cQuery += " FROM " + RetSqlName("SD2") + " D2 "
	_cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2")+ "' "
	_cQuery += " AND D2_PEDIDO = '" + M->C5_NUM + "' "
	_cQuery += " AND D2_COD = '" + _cProduto + "' "
	_cQuery += " AND D2_ITEMPV = '" + _cItemPv + "' "
	_cQuery += " AND D2.D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAlias)
	
	If (_cAlias)->(!EOF())
		_nQtd	:= (_cAlias)->QTDEFAT
	EndIf
	
	(_cAlias)->(dbCloseArea())

Return(_nQtd)

 /*
 	Calcula o total do pedido
 */
Static Function GetTotalPed()
Local nI 		:= 1
Local nMax 		:= Len( aCols )
Local nPVlrTot 	:= GdFieldPos( "C6_VALOR", aHeader )
Local nPTotDesc	:= GdFieldPos( "C6_VALDESC", aHeader )
Local _nPosTES  := GdFieldPos( "C6_TES", aHeader )
Local nTotalPed	:= 0
Local nTotalDesc:= 0


While( nI <= nMax )

	If( nPVlrTot > 0 ) .And. Posicione("SF4",1,xFilial("SF4")+aCols[ni][_nPosTES],"F4_DUPLIC")=="S" .And. M->C5_TIPO == "N"
		nTotalPed += aCols[nI][nPVlrTot]
	EndIf
	
	If( nPTotDesc > 0 ) .And. Posicione("SF4",1,xFilial("SF4")+aCols[ni][_nPosTES],"F4_DUPLIC")=="S".And. M->C5_TIPO == "N"
		nTotalDesc += aCols[nI][nPTotDesc]
	EndIf
	nI++
EndDo

If( M->C5_PDESCAB > 0 )
	nTotalDesc  += (nTotPed*M->C5_PDESCAB/100)
	nTotalPed  	-= nTotalDesc
Else
	nTotalPed   -= nTotalDesc
EndIf

Return( nTotalPed )

Static Function GetTLPed()

Local nI 		:= 1
Local nMax 		:= Len( aCols )
Local nPVlrTot 	:= GdFieldPos( "C6_VALOR", aHeader )
Local nPTotDesc	:= GdFieldPos( "C6_VALDESC", aHeader )
Local nTotalPed	:= 0
Local nTotalDesc:= 0
Local _nQtLib	:= GdFieldPos( "C6_QTDLIB", aHeader )
Local _nVlrUnt	:= GdFieldPos( "C6_PRCVEN", aHeader )
Local _nQtdFat	:= 0
Local _nPProd	:= GdFieldPos( "C6_PRODUTO", aHeader )
Local _npItem	:= GdFieldPos( "C6_ITEM", aHeader )
Local _nPosTES  := GdFieldPos( "C6_TES", aHeader )

While( nI <= nMax )

	If aCols[nI][_nQtLib] > 0 .And. Posicione("SF4",1,xFilial("SF4")+aCols[ni][_nPosTES],"F4_DUPLIC")=="S" .And. M->C5_TIPO == "N"
		nTotalPed += aCols[nI][_nVlrUnt] * (aCols[nI][_nQtLib]-_nQtdFat)
	EndIf
	If( nPTotDesc > 0 ) .And. Posicione("SF4",1,xFilial("SF4")+aCols[ni][_nPosTES],"F4_DUPLIC")=="S" .And. M->C5_TIPO == "N"
		nTotalDesc += aCols[nI][nPTotDesc]
	EndIf
	nI++
EndDo

If( M->C5_PDESCAB > 0 )
	nTotalDesc  += (nTotPed*M->C5_PDESCAB/100)
	nTotalPed  	-= Iif(nTotalPed>0,nTotalDesc,0)
Else
	nTotalPed   -= Iif(nTotalPed>0,nTotalDesc,0)
EndIf

Return(nTotalPed)


Static Function SetParcels(nTotalPed)
Local aArea		:= GetArea()
Local aVencto 	:= {}
Local cCondPag	:= ""
Local nI		:= 0
Local nMax		:= 0
Local nMaxCols	:= 0
Local nPVencto	:= 0
Local nPVlr		:= 0
Local nParcela  := 0
Local nParcs	:= 0
Local _nTaPar 	:= TamSx3("E1_PARCELA")[1]
Local _nVlrIPI	:= 0
Local _nDifIPI	:= 0
Local _nTparc	:= 0
Local _cPDup	:= SUPERGETMV("MV_1DUP   ", .F., "1")

cCondPag		:= M->C5_CONDPAG

DbSelectArea( "SE4" )
SE4->(DbSetOrder( RetOrder( "SE4", "E4_FILAL+E4_CODIGO" )))

If( SE4->( DbSeek(xFilial("SE4")+cCondPag ) ) )
	If( SE4->E4_TIPO != "9" )
		aVencto 		:= Condicao(nTotalPed,cCondPag,0,dDataBase,0)
		nI 				:= 1
		nMax 			:= Len(aVencto)
		nMaxCols		:= Len(aCols)
		nPNumPed        := GdFieldPos("Z8_NUMPED")
		nPVencto		:= GdFieldPos("Z8_VENCTO")
		nPVlr			:= GdFieldPos("Z8_VALOR")
		nParcela		:= GdFieldPos("Z8_PARCELA")
		nIPI			:= GdFieldPos("Z8_IPI")
		nTotCIPI		:= GdFieldPos("Z8_VLRCIPI")
		nForma			:= GdFieldPos("Z8_FORMA")
		nDesForm 		:= GdFieldPos("Z8_DESFORM")
		_nVlrIPI		:= NoRound(_nVIPI/nMax,2)
		_nDifIPI		:= _nVIPI - (_nVlrIPI*nMax)
		aCols := {}
		If( nPVencto > 0 .And. nPVlr > 0 )
			While( nI <= nMax )
				Aadd(aCols,Array(Len(aHeader)+1))
				aCols[Len(aCols)][nPNumPed] := &("M->C5_NUM")
				aCols[Len(aCols)][nPVencto] := aVencto[nI,1]
				aCols[Len(aCols)][nPVlr	  ] := aVencto[nI,2]
				aCols[Len(aCols)][nParcela] := _cPDup
				aCols[Len(aCols)][nIPI    ] := Iif(!Empty(aCols[nI][nPVencto]),_nVlrIPI+ Iif(nI==nMax,_nDifIPI,0),0)
				aCols[Len(aCols)][nTotCIPI] := Iif(!Empty(aCols[nI][nPVencto]),aVencto[nI,2] + _nVlrIPI + Iif(nI==nMax,_nDifIPI,0),0)
				aCols[Len(aCols)][nForma  ] := Space(TamSX3("Z8_FORMA")[1])
				aCols[Len(aCols)][nDesForm] := " "
				aCols[Len(aCols)][Len(aHeader)+1]			:= .F.
				_cPDup := Soma1(_cPDup)
				nI++
			EndDo
			
			aSize( aCols, nMax)
		EndIf
	Else
		
		nPNumPed		:= GdFieldPos("Z8_NUMPED")
		nPVencto		:= GdFieldPos("Z8_VENCTO")
		nPVlr			:= GdFieldPos("Z8_VALOR")
		nParcela		:= GdFieldPos("Z8_PARCELA")
		nIPI			:= GdFieldPos("Z8_IPI")
		nTotCIPI		:= GdFieldPos("Z8_VLRCIPI")
		nDesForm 		:= GdFieldPos("Z8_DESFORM")
		nForma			:= GdFieldPos("Z8_FORMA")
		nMaxCols		:= Len(aCols)
		_nValParc       := 0
		If( nPVencto> 0 .And. nPVlr > 0 )
			nI 			:= 1
			nMax 		:= 20
			//Verifica a quantidade de parcelas - Cond Tipo 9
			While( nI <= nMax )
				If( Type("M->C5_PARC"+AllTrim(Str(nI))) != "U"  )
					If( &("M->C5_PARC"+AllTrim(Str(nI))) > 0 )
						_nTparc++
					EndIf
				EndIf
				nI++
			EndDo
			
			_nVlrIPI	:= NoRound(_nVIPI/_nTparc,2)
			_nDifIPI	:= _nVIPI - (_nVlrIPI*_nTparc)
			nI			:= 1
			aCols := {}
			While( nI <= _nTparc )
				If( Type("M->C5_PARC"+AllTrim(Str(nI))) != "U"  )
					If( &("M->C5_PARC"+AllTrim(Str(nI))) > 0 )
						nParcs++
						Aadd(aCols,Array(Len(aHeader)+1))
						aCols[Len(aCols)][nPNumPed] := &("M->C5_NUM")
						aCols[Len(aCols)][nPVencto] := &("M->C5_DATA"+AllTrim(Str(nI)))
						//aCols[Len(aCols)][nPVlr	  ] := (&("M->C5_PARC"+AllTrim(Str(nI)))/aColsSC6[n][_nPosQTD]) * aColsSC6[n][_nPosQLB] //&("M->C5_PARC"+AllTrim(Str(nI))) 
						aCols[Len(aCols)][nPVlr	  ]  := &("M->C5_PARC"+AllTrim(Str(nI)))
						aCols[Len(aCols)][nParcela] := _cPDup
						aCols[Len(aCols)][nForma  ] := Space(TamSX3("Z8_FORMA")[1])
						aCols[Len(aCols)][nDesForm] := " "
						aCols[Len(aCols)][Len(aHeader)+1]			:= .F.
						//_nValParc			+= (&("M->C5_PARC"+AllTrim(Str(nI)))/aColsSC6[n][_nPosQTD]) * aColsSC6[n][_nPosQLB] //&("M->C5_PARC"+AllTrim(Str(nI))) 
						_nValParc			+= &("M->C5_PARC"+AllTrim(Str(nI)))
						_cPDup := Soma1(_cPDup)
					EndIf
				EndIf
				nI++
			EndDo
			
			aSize( aCols, nParcs)
		EndIf
	EndIf
EndIf
RestArea( aArea )
Return()

Static Function QuaFormPg(axHeadFor,axColsFor,aRegSZ8)

	Local cArqQry    := "SZ8"
	Local lQuery     := .F.
	Local nUsado     := 0
	Local nX         := 0
	
	#IFDEF TOP
		Local aStruSZ8   := {}
		Local cQuery     := ""
	#ENDIF 	
	
	DEFAULT aRegSZ8  := {}
	DEFAULT axHeadFor := {}
	DEFAULT axColsFor := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do axHeadFor                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZ8")
	While !Eof() .And. SX3->X3_ARQUIVO == "SZ8"
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
				Aadd(axHeadFor, { AllTrim(X3Titulo()),;
								SX3->X3_CAMPO,;
								SX3->X3_PICTURE,;
								SX3->X3_TAMANHO,;
								SX3->X3_DECIMAL,;
								SX3->X3_VALID,;
								SX3->X3_USADO,;
								SX3->X3_TIPO,;
								SX3->X3_F3,;
								SX3->X3_CONTEXT } )
				nUsado++
			
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	If  !INCLUI
		If !INCLUI .And. !ALTERA
			_nVIPI		:= 0
			_nVlrMerc	:= 0
		EndIf
		SZ8->(DbSetOrder(1))
		#IFDEF TOP
			If TcSrvType()<>"AS/400" .And. !InTransact()
				lQuery  := .T.
				cArqQry := "SZ8"
				aStruSZ8:= SZ8->(dbStruct())
	
				cQuery := "SELECT SZ8.*,SZ8.R_E_C_N_O_ SZ8RECNO "
				cQuery += "FROM "+RetSqlName("SZ8")+" SZ8 "
				cQuery += "WHERE "
				cQuery += "SZ8.Z8_FILIAL='"+xFilial("SZ8")+"' AND "
				cQuery += "SZ8.Z8_NUMPED='"+M->C5_NUM+"' AND "
				cQuery += "SZ8.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SZ8->(IndexKey()))
	
				cQuery := ChangeQuery(cQuery)
	
				dbSelectArea("SZ8")
				dbCloseArea()
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
	
				For nX := 1 To Len(aStruSZ8)
					If	aStruSZ8[nX,2] <> "C"
						TcSetField(cArqQry,aStruSZ8[nX,1],aStruSZ8[nX,2],aStruSZ8[nX,3],aStruSZ8[nX,4])
					EndIf
				Next nX
			Else
		#ENDIF
			SZ8->(DbSeek(xFilial("SZ8")+M->C5_NUM))
			#IFDEF TOP
			EndIf
			#ENDIF
		While (cArqQry)->(!Eof() .And. (cArqQry)->Z8_FILIAL==xFilial("SZ8") .And.;
				(cArqQry)->Z8_NUMPED==M->C5_NUM)
			aadd(axColsFor,Array(nUsado+1))	
			For nX := 1 To nUsado
				If ( axHeadFor[nX][10] <> "V" )
					axColsFor[Len(axColsFor)][nX] := (cArqQry)->(FieldGet(FieldPos(axHeadFor[nX][2])))
				Else 
					axColsFor[Len(axColsFor)][nX] := CriaVar(axHeadFor[nX,2])
				EndIf
				If _cTipo == "9" .And. AllTrim(axHeadFor[nX,2]) == "Z8_VALOR"
					_nValParc	+= (cArqQry)->(FieldGet(FieldPos(axHeadFor[nX][2])))
				EndIf
			Next
			axColsFor[Len(axColsFor)][nUsado+1] := .F.
			
			If !INCLUI .And. !ALTERA
				_nVIPI		+= (cArqQry)->Z8_IPI //(cArqQry)->Z8_VLRCIPI
				_nVlrMerc	+= (cArqQry)->Z8_VALOR
			EndIf
	
			aadd(aRegSZ8,If(lQuery,(cArqQry)->SZ8RECNO,(cArqQry)->(RecNo())))
	
			dbSelectArea(cArqQry)
			dbSkip()
		EndDo
		If lQuery
			dbSelectArea(cArqQry)
			dbCloseArea()
			ChkFile("SZ8",.F.)
			dbSelectArea("SZ8")
		EndIf
	Endif
	
	If Empty(axColsFor)
		aadd(axColsFor,Array(nUsado+1))
	
		For nX := 1 To nUsado
			axColsFor[1][nX] := CriaVar(axHeadFor[nX][2])
		Next nX
		axColsFor[Len(axColsFor)][nUsado+1] := .F.
	Endif

Return(.T.)
             

Static Function GrvFormOk(axHeadFor,axColsFor)

Local lRet := .T.
Local _nNumPed  := GdFieldPos("Z8_NUMPED")
Local _nParcela := GdFieldPos("Z8_PARCELA")
Local _nForma   := GdFieldPos("Z8_FORMA")
Local _nVencto  := GdFieldPos("Z8_VENCTO")
Local _nValor   := GdFieldPos("Z8_VALOR")
Local _nDesForm := GdFieldPos("Z8_DESFORM")
Local _nIPI 	:= GdFieldPos("Z8_IPI")
Local _nVlrCIPI := GdFieldPos("Z8_VLRCIPI")

DbSelectArea("SZ8")

If Len(axColsFor) > 0 .And. (INCLUI .Or. ALTERA)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe alguma parcela sem a forma de pagamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	For _Ic:= 1 To Len(axColsFor)
		If !SZ8->(DbSeek(xFilial("SZ8")+axColsFor[_Ic][_nNumPed]+DtoS(dDataBase)+PadR("",TamSX3("Z8_DOC")[1])+PadR("",TamSX3("Z8_SERIE")[1])+axColsFor[_Ic][_nParcela]))
			If Reclock("SZ8",.T.)
				SZ8->Z8_FILIAL  := xFilial("SZ8")
				SZ8->Z8_NUMPED  := axColsFor[_Ic][_nNumPed]
				SZ8->Z8_PARCELA := axColsFor[_Ic][_nParcela]
				SZ8->Z8_VENCTO  := axColsFor[_Ic][_nVencto]
				SZ8->Z8_VALOR   := axColsFor[_Ic][_nValor]
				SZ8->Z8_FORMA   := axColsFor[_Ic][_nForma]
				SZ8->Z8_DESFORM := axColsFor[_Ic][_nDesForm]
				SZ8->Z8_IPI 	:= axColsFor[_Ic][_nIPI]
				SZ8->Z8_VLRCIPI := axColsFor[_Ic][_nVlrCIPI]
				SZ8->Z8_DTLIB	:= dDataBase
				SZ8->(MsUnlock())
			EndIf
		Else
			If Reclock("SZ8",.F.)
				SZ8->Z8_VENCTO  := axColsFor[_Ic][_nVencto]
				SZ8->Z8_VALOR   := axColsFor[_Ic][_nValor]
				SZ8->Z8_FORMA   := axColsFor[_Ic][_nForma]
				SZ8->Z8_DESFORM := axColsFor[_Ic][_nDesForm]
				SZ8->Z8_IPI 	:= axColsFor[_Ic][_nIPI]
				SZ8->Z8_VLRCIPI := axColsFor[_Ic][_nVlrCIPI]
				SZ8->Z8_DTLIB	:= dDataBase
				SZ8->(MsUnlock())
			EndIf
		EndIf
	Next
EndIf

Return

Static Function TpFormOk()

	Local lRet     := .T.
	Local nX       := 0
	Local nPercent := 0
	Local nPosPer  := Ascan(aHeader,{|x| Alltrim(x[2]) == "Z8_FORMA"})
	Local lValida  := .F.
	
	For nX := 1 to Len(aCols)
		If !aCols[nX][Len(aHeader)+1]
		 If Empty(aCols[nX][nPosPer])
			lValida  := .T.             
			EndIf
		Endif
	Next nX
	If  lValida
		MsgAlert("Existe itens sem forma de pagamento")
		lRet := .F.
	EndIf 
	
Return(lRet)                


//Função para apresentar a tela de Pré pedido, de acordo com a quantidade liberada
User Function _fPreNt1()
	
	Local aArea     	:= GetArea()
	Local aPosObj   	:= {}
	Local aObjects  	:= {}
	Local aSize     	:= MsAdvSize()
	Local aRow			:= {}      
	Local aRowBase		:= {}
	Local oDlg			:= Nil
	Local oGDPREV		:= Nil
	Local _nVlrMerc		:= 0
	Local oTFont 		:= TFont():New('Times New Roman',,-16,,.T.)
	Local aFields		:= {"C6_ITEM","C6_PRODUTO","PV_DESC","C6_QTDLIB","C6_PRCVEN","C6_VALOR","PV_IPI","PV_VLRTIPI"}
	Local _nI			:= 0
	Local _nParcIPI		:= 0
	Local _nAux			:= 0
	Local _lAux			:= .F.
	
	Private aRegSZ8 	:= {}    
    Private _aHeadPV 	:= {}
    Private _aColsPV 	:= {}
    Private _nVIPI		:= 0
    Private n			:= 1
	 	
	aAdd( aObjects, { 100, 100, .t., .t. } )

	aSize[ 3 ] -= 50
	aSize[ 4 ] -= 50 	
	
	aSize[ 5 ] -= 100
	aSize[ 6 ] -= 050
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )		
	
	_nPosItem := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM"})
	_nPosCod := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
	_nPosTES := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})
	_nPosQTD := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDLIB"})
	_nPosPRV := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN"})
	_nPosTOT := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_VALOR"})
	_nPosDSC := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_VALDESC"})
	
	For _nI	:= 1 To Len(aCols)
		If aCols[_nI,_nPosQTD] > 0
			_lAux := .T.
		EndIf
	Next _nI
	
	If !_lAux
		AVISO(OEMTOANSI("Pré Pedido de Venda"),OEMTOANSI("O Pedido não contém nenhuma quantidade liberada. Por favor, realizar o preenchimento desta informação para visualização desta opção"),{"Ok"},2)
	Else
		//Monta o aHeader	
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		For _nX := 1 to Len(aFields)
			SX3->(dbGoTop())
			Do Case
				Case aFields[_nX] == "PV_IPI"
					If SX3->(DbSeek("Z8_IPI"))
				    	Aadd(_aHeadPV, {"IPI","PV_IPI",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				        	             SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				    Endif
				Case aFields[_nX] == "PV_VLRTIPI"
					If SX3->(DbSeek("Z8_VLRCIPI"))
				    	Aadd(_aHeadPV, {"Vlr. C/ IPI","PV_VLRTIPI",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				        	             SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				    Endif
			
				Case aFields[_nX] == "PV_DESC"
					If SX3->(DbSeek("B1_DESC"))
				    	Aadd(_aHeadPV, {AllTrim(X3Titulo()),"PV_DESC",SX3->X3_PICTURE,SX3->X3_TAMANHO+20,SX3->X3_DECIMAL,SX3->X3_VALID,;
				        	             SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				    Endif
	
				OtherWise
					If SX3->(DbSeek(aFields[_nX]))
				    	Aadd(_aHeadPV, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				        	             SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				    Endif
			EndCase
		Next _nX
		
		MaFisIni(Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT),M->C5_LOJAENT,IIf(M->C5_TIPO$'DB',"F","C"),M->C5_TIPO,M->C5_TIPOCLI,Nil,Nil,Nil,Nil,"MATA461")
		
		For i := 1 to Len(aCols)
			IF !aCols[i,Len(aHeader)+1]
				MaFisAdd(aCols[i,_nPosCod],aCols[i,_nPosTES],aCols[i,_nPosQTD],aCols[i,_nPosPRV],aCols[i,_nPosDSC],"","",0,0,0,0,0,(aCols[i,_nPosQTD]*aCols[i,_nPosPRV]),0)
			ENDIF
		Next
		     
		_nVIPI	:= MaFisRet(,"NF_VALIPI")	   
		_nVlrMerc:= MaFisRet(,"NF_VALMERC")
		MaFisEnd()
		
		For _nI	:= 1 To Len(aCols)
			_nAux:= 0
		
			MaFisIni(Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT),M->C5_LOJAENT,IIf(M->C5_TIPO$'DB',"F","C"),M->C5_TIPO,M->C5_TIPOCLI,Nil,Nil,Nil,Nil,"MATA461")
				MaFisAdd(aCols[_nI,_nPosCod],aCols[_nI,_nPosTES],aCols[_nI,_nPosQTD],aCols[_nI,_nPosPRV],aCols[_nI,_nPosDSC],"","",0,0,0,0,0,(aCols[_nI,_nPosQTD]*aCols[_nI,_nPosPRV]),0)
				_nAux	:= MaFisRet(1,"IT_VALIPI")	   
			MaFisEnd()
	
			_aAux := {}
			Aadd(_aAux,aCols[_nI,_nPosItem])
			Aadd(_aAux,aCols[_nI,_nPosCod])
			Aadd(_aAux,Posicione("SB1",1,xFilial("SB1")+aCols[_nI,_nPosCod],"B1_DESC"))
			Aadd(_aAux,aCols[_nI,_nPosQTD])
			Aadd(_aAux,aCols[_nI,_nPosPRV])
			Aadd(_aAux,(aCols[_nI,_nPosQTD]*aCols[_nI,_nPosPRV]))
			Aadd(_aAux,_nAux)
			Aadd(_aAux,(aCols[_nI,_nPosQTD]*aCols[_nI,_nPosPRV])+_nAux)		
			Aadd(_aAux,.F.)
			Aadd(_aColsPV,_aAux)
		Next _nI
	  
		DbSelectArea("SZ8")
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Pré Pedido de Venda") From aSize[7],00 to aSize[6],aSize[5] Of oMainWnd PIXEL
		
			oGetDad 	:= MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],0,"AllwaysTrue()","AllwaysTrue()",,,000,999,"AllWaysTrue","AllWaysTrue","AllWaysTrue",oDlg,_aHeadPV,_aColsPV)
			TSay():New(aPosObj[1,3]+10,aPosObj[1,2],{|| OemToAnsi("Total Mercadoria (R$):  " + Transform(_nVlrMerc,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)
			TSay():New(aPosObj[1,3]+10,(aPosObj[1,4]/3)+50,{|| OemToAnsi("Total IPI (R$):  "+ Transform(_nVIPI,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)
			TSay():New(aPosObj[1,3]+10,(aPosObj[1,4]/2)+180,{|| OemToAnsi("Total C/ IPI (R$):  "+ Transform(_nVlrMerc+_nVIPI,PesqPict("SF2","F2_VALBRUT")))},oDlg,,oTFont,,,,.T.,,,,10)			
			
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{||oDlg:End()}) CENTERED
	EndIf		
	RestArea(aArea)
	
Return(.T.)

User Function _f410con() 

	Local _cRet := Tabela("24",M->Z8_FORMA)                                                                            

Return(_cRet)   

Static Function _fTudoOk(aXHeader,aXCols,lAlt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existem parcelas coma forma de pagto em branco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nForma   := GdFieldPos("Z8_FORMA")
Local _lRet     := .T.

If lAlt
	For nx := 1 To Len(aXCols)
		
		If Empty(aXCols[nx][_nForma])
			_lRet := .F.
		EndIf
		
	Next nx
	
	If !_lRet
		AVISO(OEMTOANSI("Formas Pagto"),OEMTOANSI("Preencha a forma de pagamento para todas as parcelas!!"),{"Ok"},2)
	EndIf
EndIf
Return(_lRet)
