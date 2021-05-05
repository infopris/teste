#Include "PROTHEUS.CH"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "REPORT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FSRDWR02
Relatório de Pedido de Compras - Especifico

@author Bruno Lazarini Garcia
@since 21/06/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function FSRDWR02()      

	Local lAdjustToLegacy	:= .T.
	Local lDisableSetup  	:= .T.
	Local lNPassou			:= .T.
	Local cLocal          	:= '' //"c:\siga\"
	Local cFilePrint 		:= ''  
	Local cDescLogo			:= ''
	Local cLogoD			:= '' 
	Local cObserv			:= ''
	Local cObserv1			:= ''
	Local cObserv2          := ''
	Local cObserv3			:= ''
	Local nCol       		:= 2950
	Local nLinha     		:= 180 
	Local cFrete                   
	
	Private oPrinter
	Private cPedido    		:= SC7->C7_NUM
	Private nSubTot 	    := 0
	Private nDesc    	    := 0
	Private nTotal  	    := 0 
	Private nTotFret		:= 0
	Private nICMS			:= 0
	Private nIPI			:= 0
	
	//-> Query para selecionar o Pedido de Compras Posicionado
	BUSCA()
	
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))
	SY1->(DbGotop())
	
	DbSelectArea("SE4")
	SE4->(DbSetOrder(1))
	SE4->(DbGotop())
			        
	DbSelectArea("SC7")
	SC7->(DbSetOrder(RetOrder("DTOS(C7_DATPRF)+C7_PRODUTO+C7_NUM+C7_ITEM+C7_SEQUEN")))
			
	SY1->(DbSeek(xFilial("SY1")+C7TEMP->C7_USER))
	SE4->(DbSeek(xFilial("SE4")+SC7->C7_COND))
		
	oFont09 	:= TFont():New( "Arial",,09,,.F.,,,,,.F. )
	oFont10		:= TFont():New( "Arial",,10,,.F.,,,,,.F. )
	oFont10B 	:= TFont():New( "Arial",,10,,.T.,,,,,.F. )
	oFont12B 	:= TFont():New( "Arial",,12,,.T.,,,,,.F. )
	oFont15B 	:= TFont():New( "Arial",,15,,.T.,,,,,.F. )
	
	oBrush  := TBrush():New(,(0,0,0))
	oBrush2 := TBrush():New(,CLR_HGRAY) // Cinza Claro
	
	//--> Parâmetros com impressão direto em PDF
	//oPrinter := FWMSPrinter():New('Pedido_'+cPedido+'.PD_', IMP_PDF, lAdjustToLegacy,cLocal,.T., , , , , , .F., )//lDisableSetup
	oPrinter := FWMSPrinter():New(cPedido)//lDisableSetup
	oPrinter:SetResolution(72)
	oPrinter:SetLandScape(.T.)
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(10,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
	
	oPrinter:StartPage()
		
	oPrinter:Box( 0100, 10, 2460,nCol, "-4")//BOX PRINCIPAL 2500
	
	cDescLogo := cEmpAnt	
	cLogoD    := GetSrvProfString("Startpath","") + "lgrl" + cDescLogo + ".BMP"
	
	oPrinter:SayBitmap(0120,50, cLogoD , 0520, 0190)	// Logo Qualita 
	//oPrinter:Say(0230,0050,"QUALITÁ DO BRASIL",oFont15B)
	
	oPrinter:Box( 0120, 2350,0240 ,nCol, "-4")//BOX PRINCIPAL
	
	oPrinter:Say(0150,2370,"Data do Pedido:",oFont12B)
	oPrinter:Say(0200,2370,DTOC(STOD(C7TEMP->C7_EMISSAO)),oFont10)
	oPrinter:Say(0150,2670,"COMPRADOR:",oFont12B)
	oPrinter:Say(0200,2670,SY1->Y1_NOME,oFont10)
	
	oPrinter:Line ( 0300, 0010, 0300, 2950)
	
	oPrinter:Say(0230,1400,"PEDIDO DE COMPRAS - Nº"+ SC7->C7_NUM,oFont15B)
	
	oPrinter:Box( 0300,0010,0350,1000, "-4")//BOX FORNECEDOR
	oPrinter:Say(0335,400,"DADOS DO FORNECEDOR",oFont10B)
	oPrinter:Box( 0300,1000,0350,2000, "-4")//BOX DADOS DO FATURAMENTO
	oPrinter:Say(0335,1500,"DADOS DO FATURAMENTO",oFont10B)
	oPrinter:Box( 0300,2000,0350,nCol, "-4")//BOX DADOS DA ENTREGA
	oPrinter:Say(0335,2400,"DADOS ENTREGA E COBRANÇA ",oFont10B)
	
	nLin:=0400
	
	oPrinter:Say(nLin,0020,"NOME:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_NOME + "-"+SA2->A2_COD,oFont10)
	oPrinter:Say(nLin,1010,"NOME:",oFont10)
	oPrinter:Say(nLin,1150,RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_NOMECOM'),oFont10)
	oPrinter:Say(nLin,2010,"NOME:",oFont10)
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_NOMECOM'),oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"CNPJ:",oFont10)
	oPrinter:Say(nLin,150,TRANSFORM(SA2->A2_CGC,PESQPICT("SA2","A2_CGC")),oFont10)
	oPrinter:Say(nLin,1010,"CNPJ:",oFont10)
	oPrinter:Say(nLin,1150,TRANSFORM(RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_CGC'),PESQPICT("SA2","A2_CGC")),oFont10)
	oPrinter:Say(nLin,2010,"CNPJ",oFont10)
	oPrinter:Say(nLin,2150,TRANSFORM(RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_CGC'),PESQPICT("SA2","A2_CGC")),oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"IE:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_INSCR,oFont10)
	oPrinter:Say(nLin,1010,"IE:",oFont10)
	oPrinter:Say(nLin,1150,RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_INSC'),oFont10)
	oPrinter:Say(nLin,2010,"IE:",oFont10)
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_INSC'),oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"END:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_END,oFont10)
	oPrinter:Say(nLin,1010,"END:",oFont10)
	oPrinter:Say(nLin,1150,RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_ENDENT'),oFont10)
	oPrinter:Say(nLin,2010,"END:",oFont10)
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_ENDENT'),oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"BAIRRO:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_BAIRRO,oFont10)
	oPrinter:Say(nLin,1010,"BAIRRO:",oFont10)
	oPrinter:Say(nLin,1150,RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_BAIRENT'),oFont10)
	oPrinter:Say(nLin,2010,"BAIRRO:",oFont10)//cFilAnt
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_BAIRENT'),oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"CEP:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_CEP,oFont10)
	oPrinter:Say(nLin,1010,"CEP:",oFont10)
	oPrinter:Say(nLin,1150,RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_CEPENT'),oFont10)
	oPrinter:Say(nLin,2010,"CEP:",oFont10)
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_CEPENT'),oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"CIDADE:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_MUN+ " UF: "+SA2->A2_EST,oFont10)
	oPrinter:Say(nLin,1010,"CIDADE:",oFont10)
	oPrinter:Say(nLin,1150,RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_CIDENT')+"UF "+ RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_ESTENT'),oFont10)
	oPrinter:Say(nLin,2010,"CIDADE:",oFont10)
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_CIDENT')+"UF "+ RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_ESTENT'),oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"Contato:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_CONTATO,oFont10)
	oPrinter:Say(nLin,1010,"CONTATO:",oFont10)
	oPrinter:Say(nLin,2010,"CONTATO:",oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"EMAIL:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_EMAIL,oFont10)
	oPrinter:Say(nLin,1010,"EMAIL:",oFont10)
	oPrinter:Say(nLin,2010,"EMAIL:",oFont10)
	
	nLin+=40
	
	oPrinter:Say(nLin,0020,"Tel:",oFont10)
	oPrinter:Say(nLin,150,SA2->A2_DDD+"-"+SA2->A2_TEL,oFont10)
	oPrinter:Say(nLin,1010,"TEL:",oFont10)
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILIAL,'M0_TEL'),oFont10)
	oPrinter:Say(nLin,2010,"TEL:",oFont10)
	oPrinter:Say(nLin,2150,RetField('SM0',1,cEmpAnt+SC7->C7_FILENT,'M0_TEL'),oFont10)
	
	nLin+=20
	
	oPrinter:Line ( nLin, 0010, nLin, 2950 )
	oPrinter:FillRect({ nLin,0010, nLin+40,2950 },oBrush2)
	
	nLin+=30
		
	oPrinter:Say(nLin,01350,"CONDIÇÕES DO PEDIDO:",oFont10)
	
	nLin+=60
	
	oPrinter:Say(nLin,0360,"SOLICITANTE DO PEDIDO: ",oFont10B)
	oPrinter:Say(nLin,0660,SC1->C1_SOLICIT,oFont10)
	oPrinter:Say(nLin,1160,"FORMA DE PAGAMENTO:",oFont10B)
	oPrinter:Say(nLin,1450,ALLTRIM(SC7->C7_COND),oFont10B)
	
	oPrinter:Say(nLin,1960,"FRETE:",oFont10B)
	
	If C7TEMP->C7_TPFRETE == "F"
		cFrete := "FIFO"
	Elseif C7TEMP->C7_TPFRETE == "C"
		cFrete := "CIF"
	ElseIF C7TEMP->C7_TPFRETE == "T"
		cFrete := "Por Conta	Terceiros"
	Else 
		cFrete := "Sem Frete"
	EndiF
	 
	oPrinter:Say(nLin,2100,cFrete,oFont10)
	
	nLin+=50
	oPrinter:Say(nLin,0360,"APROVADOR DO PEDIDO:",oFont10B)
	oPrinter:Say(nLin,0660,UsrRetName(C7TEMP->C7_USER),oFont10)
	oPrinter:Say(nLin,1160,"CONDIÇÃO:",oFont10B)
	oPrinter:Say(nLin,1290,ALLTRIM(SE4->E4_DESCRI),oFont10)
		
	nLin+=40
	oPrinter:FillRect({ nLin,0010, nLin+40,2950 },oBrush2)
	nLin+=30
	oPrinter:Say(nLin,01350,"DADOS DA COMPRA:",oFont10)
	nLin+=10
	
	oPrinter:Line ( nLin, 0010,nLin, 2950)
	oPrinter:Line ( nLin, 0145,1880, 0145)
	oPrinter:Line ( nLin, 0300,1880, 0300)
	oPrinter:Line ( nLin, 0600,1880, 0600)
	oPrinter:Line ( nLin, 1870,1880, 1870)
	oPrinter:Line ( nLin, 2100,1880, 2100)
	oPrinter:Line ( nLin, 2300,1880, 2300)
	oPrinter:Line ( nLin, 2430,1880, 2430)
	oPrinter:Line ( nLin, 2550,1880, 2550)
	oPrinter:Line ( nLin, 2750,1880, 2750)
	
	nLin+=30
	/*
	oPrinter:Say(nLin,0040,"QTD",oFont10B)
	oPrinter:Say(nLin,0180,"UNID",oFont10B)
	oPrinter:Say(nLin,0390,"CÓDIGO",oFont10B)
	oPrinter:Say(nLin,1100,"DESCRIÇÃO",oFont10B)
	oPrinter:Say(nLin,1900,"DT.ENTREGA",oFont10B)
	oPrinter:Say(nLin,2180,"NCM",oFont10B)
	oPrinter:Say(nLin,2330,"ICMS%",oFont10B)
	oPrinter:Say(nLin,2470,"IPI%",oFont10B)
	oPrinter:Say(nLin,2570,"Vl.UNITARIO",oFont10B)
	oPrinter:Say(nLin,2770,"VALOR TOTAL",oFont10B)
	*/     
	
	oPrinter:Say(nLin,0040,"QTD",oFont10B)
	oPrinter:Say(nLin,0180,"UNID",oFont10B)
	oPrinter:Say(nLin,0390,"CÓDIGO",oFont10B)
	oPrinter:Say(nLin,1100,"DESCRIÇÃO",oFont10B)
	oPrinter:Say(nLin,1900,"Vl.UNITARIO",oFont10B)
	oPrinter:Say(nLin,2120,"VALOR TOTAL",oFont10B)
	oPrinter:Say(nLin,2330,"ICMS%",oFont10B)
	oPrinter:Say(nLin,2470,"IPI%",oFont10B)
	oPrinter:Say(nLin,2590,"NCM",oFont10B)
	oPrinter:Say(nLin,2770,"DT.ENTREGA",oFont10B)
	
	nLin+=10
	oPrinter:Line (nLin+10, 0010,nLin+10, 2950)
	
	WHILE !C7TEMP->(EOF()) 

		If nLin > 2400 // 30 itens por página
			If lNPassou == .T.
			
				//oPrinter:Line ( nLin, 0010,nLin, 2950)
				oPrinter:Line ( 1880, 0145,2460, 0145)
				oPrinter:Line ( 1880, 0300,2460, 0300)
				oPrinter:Line ( 1880, 0600,2460, 0600)
				oPrinter:Line ( 1880, 1870,2460, 1870)
				oPrinter:Line ( 1880, 2100,2460, 2100)
				oPrinter:Line ( 1880, 2300,2460, 2300)
				oPrinter:Line ( 1880, 2430,2460, 2430)
				oPrinter:Line ( 1880, 2550,2460, 2550)
				oPrinter:Line ( 1880, 2750,2460, 2750)
				
				//Fecha página
				oPrinter:EndPage() 
				
				//-- Inicia Página
				oPrinter:StartPage()
				lNPassou := .F.	
							
				nLin := 120 
				
				//{linha inicial, coluna inicial, linha final, coluna final}
				//oPrinter:FillRect({ nLin,0010, 1880,0010 },oBrush2)  
				oPrinter:Line ( nLin,0010, 1880,0010)
				oPrinter:Line ( nLin, 0010,nLin, 2950)
				oPrinter:Line ( nLin, 0145,1880, 0145)
   				oPrinter:Line ( nLin, 0300,1880, 0300)
				oPrinter:Line ( nLin, 0600,1880, 0600)
				oPrinter:Line ( nLin, 1870,1880, 1870)
				oPrinter:Line ( nLin, 2100,1880, 2100)
				oPrinter:Line ( nLin, 2300,1880, 2300)
				oPrinter:Line ( nLin, 2430,1880, 2430)
				oPrinter:Line ( nLin, 2550,1880, 2550)
   				oPrinter:Line ( nLin, 2750,1880, 2750)
   				oPrinter:Line ( nLin, 2950, 1880,2950)
   				//oPrinter:FillRect({ nLin,0010, 1880,2950 },oBrush2)
			Endif    
		EndIf
			
		nLin+=40
        /*
	   	oPrinter:Say(nLin,0040,ALLTRIM(TRANSFORM(C7TEMP->C7_QUANT,PESQPICT("SC7","C7_QUANT"))),oFont10,,,,2)
	   	oPrinter:Say(nLin,0190,C7TEMP->C7_UM,oFont10)
	   	oPrinter:Say(nLin,0320,C7TEMP->C7_PRODUTO,oFont10)
	   	oPrinter:Say(nLin,0610,C7TEMP->C7_DESCRI,oFont10)
	   	oPrinter:Say(nLin,2150,C7TEMP->B1_POSIPI,oFont10)
	   	oPrinter:Say(nLin,1930,DTOC(STOD(C7TEMP->C7_DATPRF)),oFont10)
	   	oPrinter:Say(nLin,2340,TRANSFORM(C7TEMP->C7_PICM,PESQPICT("SC7","C7_PICM")),oFont10,,,,2)
	   	oPrinter:Say(nLin,2470,TRANSFORM(C7TEMP->C7_IPI,PESQPICT("SC7","C7_IPI")),oFont10,,,,2)
	   	oPrinter:Say(nLin,2540,TRANSFORM(C7TEMP->C7_PRECO,PESQPICT("SC7","C7_PRECO")),oFont10,,,,1)
	   	oPrinter:Say(nLin,2780,TRANSFORM(C7TEMP->C7_TOTAL,PESQPICT("SC7","C7_TOTAL")),oFont10,300,,,2) 
	   	*/  	
	   	
	   	oPrinter:Say(nLin,0040,ALLTRIM(TRANSFORM(C7TEMP->C7_QUANT,PESQPICT("SC7","C7_QUANT"))),oFont10,,,,2)
	   	oPrinter:Say(nLin,0190,C7TEMP->C7_UM,oFont10)
	   	oPrinter:Say(nLin,0320,C7TEMP->C7_PRODUTO,oFont10)
	   	oPrinter:Say(nLin,0610,C7TEMP->C7_DESCRI,oFont10)
	   	oPrinter:Say(nLin,1930,TRANSFORM(C7TEMP->C7_PRECO,PESQPICT("SC7","C7_PRECO")),oFont10)
	   	oPrinter:Say(nLin,2100,TRANSFORM(C7TEMP->C7_TOTAL,PESQPICT("SC7","C7_TOTAL")),oFont10)
	   	oPrinter:Say(nLin,2340,TRANSFORM(C7TEMP->C7_PICM,PESQPICT("SC7","C7_PICM")),oFont10,,,,2)
	   	oPrinter:Say(nLin,2470,TRANSFORM(C7TEMP->C7_IPI,PESQPICT("SC7","C7_IPI")),oFont10,,,,2)
	   	oPrinter:Say(nLin,2600,C7TEMP->B1_POSIPI,oFont10,,,,1)
	   	oPrinter:Say(nLin,2780,DTOC(STOD(C7TEMP->C7_DATPRF)),oFont10,300,,,2)
	   	
	   	nTotFret += C7TEMP->C7_VALFRE
	    nICMS    += C7TEMP->C7_VALICM
	    nIPI     += C7TEMP->C7_VALIPI
	   	nSubTot  += C7TEMP->C7_TOTAL
	   	nDesc    += C7TEMP->C7_DESC
	     
	   	C7TEMP->(dbSkip())
	
	ENDDO 
	
	oPrinter:Line (1880, 0010,1880, 2950)
	
	oPrinter:Line ( 1920, 0010, 1920, 950)
	oPrinter:Say(1950,0040,"Observação :",oFont10)
	
	cObserv  := SC7->C7_OBS
	cObserv1 := SubStr(cObserv,1  ,60)
	cObserv2 := SubStr(cObserv,40 ,60)
	cObserv3 := SubStr(cObserv,122,60) 
	
	oPrinter:Say(2000,0040,cObserv1,oFont10)  
	oPrinter:Say(2040,0040,cObserv2,oFont10)
	oPrinter:Say(2080,0040,cObserv3,oFont10)
	oPrinter:Line ( 2120, 0010, 2120, 950)
	
	//oPrinter:Say(1910,2500,"PEDIDO PARA: ( ) VENDA ( ) CONSUMO",oFont10)
	oPrinter:Say(1920,2300,"SUBTOTAL:",oFont10)
	oPrinter:Say(1920,2770,"R$"+ TRANSFORM(nSubTot,PESQPICT("SC7","C7_TOTAL")),oFont10)
	oPrinter:Say(1960,2300,"DESCONTO:",oFont10)
	oPrinter:Say(1960,2770,"R$ "+ TRANSFORM(nDesc,PESQPICT("SC7","C7_TOTAL")),oFont10)
	oPrinter:Say(2000,2300,"FRETE:",oFont10)
	oPrinter:Say(2000,2770,"R$ "+ TRANSFORM(nTotFret,PESQPICT("SC7","C7_TOTAL")) ,oFont10)
	
	oPrinter:Say(2040,2300,"ICMS:",oFont10)
	oPrinter:Say(2040,2770,"R$ "+ TRANSFORM(nICMS,PESQPICT("SC7","C7_TOTAL")) ,oFont10)
	
	oPrinter:Say(2080,2300,"IPI:",oFont10)
	oPrinter:Say(2080,2770,"R$ "+ TRANSFORM(nIPI,PESQPICT("SC7","C7_TOTAL")) ,oFont10)
	
	oPrinter:Say(2120,2300,"TOTAL EM REAIS:",oFont10)
	oPrinter:Say(2120,2770,"R$ "+ TRANSFORM(nSubTot-nDesc-nICMS-nIPI+nTotFret,PESQPICT("SC7","C7_TOTAL")) ,oFont10)
	
	oPrinter:Line ( 2010, 1000, 2010, 1500)
	oPrinter:Say(2050,1100,"APROVAÇÃO - COMPRAS",oFont10)   
	
	oPrinter:Line ( 2010, 1600, 2010, 2100)
	oPrinter:Say(2050,1650,"APROVAÇÃO - QUALITÁ DO BRASIL",oFont10)
	
	nLin := 2150 
	
	oPrinter:FillRect({ nLin,0010, nLin,2950 },oBrush2)
	
	nLin += 50
	
	oPrinter:Say(nLin,0040,"1)A Qualitá do Brasil reserva-se o direito de cancelar esta Ordem de Compra ou qualquer item nela constante caso a entrega não seja feita dentro do prazo estabelecido e/ou negociado, ou se a quantidade ou",oFont10)
	nLin+=40
	oPrinter:Say(nLin,0040,"embalagens das mercadorias estiverem em desacordo com o solicitado.",oFont10)
	nLin+=40
	oPrinter:Say(nLin,0040,"2) A Qualitá do Brasil não aceita negociações com Factoring.O pagamento deste pedido de compras será feito em nome da empresa a qual se destina este pedido.",oFont10)
	nLin+=40	
	oPrinter:Say(nLin,0040,"3) O número deste Pedido de Compras deverá constar em todas as Notas Fiscais referentes ao mesmo e sem esta informação o recebimento dos materiais e/ou serviços não poderá ser aceito e/ou realizado.",oFont10)
	nLin+=40
	oPrinter:Say(nLin,0040,"4) Horário de recebimento: de 2ª a 6ª das 08:30 as 11:30 e das 13:30 as 17:00.",oFont10)
	nLin+=40
	oPrinter:Say(nLin,0040,"5) A mercadoria será recebida após conferência da NF com o pedido de compras pelo setor Fiscal.",oFont10)
	nLin+=40
	oPrinter:Say(nLin,0040,"6) A Nota Fiscal Eletrônica e Boleto Bancário deverão ser encaminhados para o e-mail : adriana.lopes@qualitadobrasil.com.br",oFont10)
	nLin+=20
		
	/*
	oPrinter:FillRect({ 2080,0010, 2120,2950 },oBrush2)
	oPrinter:Say(2110,1400,"INSPENCAO DE RECEBIMENTO",oFont10)
		
	//-------------------------------------------------------------
	// Colunas Na parte inferior 
	// Qusitos/Conforme/Não Conforme/Obs/NF/Respons.
	//-------------------------------------------------------------
	oPrinter:Line ( 2120, 0300, 2160, 0300)
	oPrinter:Line ( 2120, 0730, 2160, 0730)
	oPrinter:Line ( 2120, 1470, 2160, 1470)
	oPrinter:Line ( 2120, 2205, 2160, 2205)
		
	oPrinter:Line ( 2180, 0300, 2460, 0300)
	oPrinter:Line ( 2180, 0730, 2460, 0730)
	oPrinter:Line ( 2180, 1470, 2460, 1470)
	oPrinter:Line ( 2180, 2205, 2460, 2205)
	oPrinter:Line ( 2120, 0010, 2120, 2950)
	oPrinter:Line ( 2120, 2500, 2160, 2500)	// Linha Vertical separando NF-E e RESPONSAVEL 
	oPrinter:Line ( 2180, 2500, 2460, 2500) 
	oPrinter:Line ( 2160, 0010, 2160, 2950)
		
	oPrinter:Say(2150,0120,"QUESITOS",oFont10B)
	oPrinter:Say(2150,0400,"CONFORME",oFont10B)
	oPrinter:Say(2150,0980,"NÃO CONFORME",oFont10B)
	oPrinter:Say(2150,1650,"OBSERVAÇÕES",oFont10B)  
	oPrinter:Say( 2150, 2225, "NF",oFont10B)  
	oPrinter:Say(2150,2550,"RESPONSÁVEL",oFont10B)	
		
	oPrinter:Line ( 2185, 0010, 2185, 2950)
	oPrinter:Say(2210,0020,"QUALIDADE",oFont10)
	oPrinter:Line ( 2225, 0010, 2225, 2950)
	oPrinter:Say(2250,0020,"PRAZO DE ENTREGA",oFont10)
	oPrinter:Line ( 2265, 0010, 2265, 2950)
	oPrinter:Say(2290,0020,"PRECO",oFont10)
	oPrinter:Line ( 2305, 0010, 2305, 2950)
	oPrinter:Say(2330,0020,"QUANTIDADE",oFont10)
	oPrinter:Line ( 2345, 0010, 2345, 2950)
	oPrinter:Say(2370,0020,"COND.PAGAMENTO",oFont10)
	oPrinter:Line ( 2385, 0010, 2385, 2950)
	oPrinter:Say(2410,0020,"EMBALAGEM",oFont10)
	oPrinter:Line ( 2425, 0010, 2425, 2950)
	oPrinter:Say(2450,0020,"TRANSPORTE",oFont10)
	
	oPrinter:Say(2490,2690,"REVISÃO 1 – 21/06/2016",oFont10)
	*/
	//-------------------------------------------------------
	
	//->Impressão em PDF
	//cFilePrint := cLocal+"orcamento_000000.PD_"
	//File2Printer( cFilePrint, "PDF" )
	//oPrinter:cPathPDF:= cLocal
	
	oPrinter:EndPage()
	C7TEMP->(dbCloseArea())
	oPrinter:Preview()
	MS_FLUSH() 
	
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} BuzzBox
Desenha um Box Sem Preenchimento.

@author Bruno Lazarini Garcia
@since 21/06/2016
@version P11
@Param  < nRow>, < nCol>, < nBottom>, < nRight>
/*/
//-------------------------------------------------------------------
Static Function BuzzBox(_nLinIni,_nColIni,_nLinFin,_nColFin)
	
	oPrinter:Line( _nLinIni,_nColIni,_nLinIni,_nColFin)
	oPrinter:Line( _nLinFin,_nColIni,_nLinFin,_nColFin)
	oPrinter:Line( _nLinIni,_nColIni,_nLinFin,_nColIni)
	oPrinter:Line( _nLinIni,_nColFin,_nLinFin,_nColFin)
	
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} BuzzLin
Desenha um Box Sem Preenchimento.

@author Bruno Lazarini Garcia
@since 24/05/2016
@version P11
@Param  < nRow>, < nCol>, < nBottom>, < nRight>
/*/
//-------------------------------------------------------------------
Static Function BuzzLin(_nLinIni,_nColIni,_nLinFin,_nColFin) 
	
	oPrinter:Line( _nLinIni,_nColIni,_nLinIni,_nColFin)
	oPrinter:Line( _nLinFin,_nColIni,_nLinFin,_nColFin)
	oPrinter:Line( _nLinIni,_nColIni,_nLinFin,_nColIni)
	oPrinter:Line( _nLinIni,_nColFin,_nLinFin,_nColFin)
	
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} BUSCA
Faz a query, referente ao pedido pocisionado na tela do PC. 

@author Bruno Lazarini Garcia
@since 21/06/2016
@version P11
/*/
//-------------------------------------------------------------------
Static Function BUSCA()
	
	BeginSql alias 'C7TEMP'
	cORDER  :=	'SC7.C7_FILIAL, SC7.C7_DATPRF '
	
		//->Tratamento de campos, caso necessário.
		
		//column C7_EMISSAO as Date,
		//C7_DATPRF  AS DATE 
		//C7_PRECO as Numeric(tam_cp,2),
		//C7_TOTAL as Numeric(tam_cp,2)
		
		SELECT SC7.C7_ITEM,SC7.C7_QUANT,SC7.C7_UM,SC7.C7_PRODUTO,SC7.C7_DESCRI,SC7.C7_QUANT,SC7.C7_PICM,SC7.C7_IPI,SC7.C7_PRECO,SC7.C7_TOTAL,SC7.C7_DESC,
		SC7.C7_EMISSAO,SC7.C7_USER,SC7.C7_FILIAL,SC7.C7_TPFRETE,SB1.B1_POSIPI,SC7.C7_DATPRF,SC7.C7_VALFRE, SC7.C7_VALICM, SC7.C7_VALIPI,
		SA2.A2_NOME,SA2.A2_CGC,SA2.A2_END,SA2.A2_BAIRRO,SA2.A2_MUN,SA2.A2_EST,SA2.A2_INSCR,SA2.A2_CEP,SA2.A2_DDD,SA2.A2_TEL,SA2.A2_EMAIL
		FROM %table:SC7% SC7,
		     %table:SA2% SA2,
		     %table:SB1% SB1
		WHERE SC7.C7_FILIAL= %xfilial:SC7% AND SC7.%notDel%  AND
		SC7.C7_NUM= %exp:cPedido% AND
		SC7.C7_FORNECE = SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA AND
		SC7.C7_PRODUTO = SB1.B1_COD AND
		SA2.%notDel%   
		ORDER BY ' + cORDER'		
	EndSql
	
	DbSelectArea("C7TEMP")
	
Return(Nil)