#INCLUDE 'PROTHEUS.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} GFATX005
Gatilho para tratar desconto especifico em Valor.

@author Bruno Lazarini Garcia
@since 12/07/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function GFATX005()
                      
Local nValRet   := 0
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})  // Quantidade Vedida
Local nPPrcVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})  // Preço Unitário Liquido
Local nPValTot	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})   // Preço Total
Local nPPrcLis  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})  // Preço Unitário de Tabela
Local nPDesVal	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"}) // Percentual de Desconto
Local nPDesPer	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"}) // Valor de Desconto do Item
Local nPValEsp	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_XVLDESC"}) // Valor do Desconto Especifico
Local nPValPer	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_XDESCFI"}) // Desconto Especifico %
Local nPDesApl  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XDESCES"}) // Desconto Aplicado 
Local nPDesAnt  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_XPRCANT"}) // Preço Lista Antigo   
Local nPDesPro  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"}) // Cód. Produto
Local nPLoteCtl := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"}) // Utiliza Lote
Local nPNumLote := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"}) // Numero Lote

Local nQtdVen  := 0
Local nPrcVen  := 0
Local nPrcLis  := 0
Local nDesVal  := 0
Local nDesPer  := 0
Local nValEsp  := 0
Local nValPer  := 0
Local nDesApl  := 0    
Local nPrcTab  := 0 
Local nDesAnt  := 0
Local cTabela  := ''
Local cProd    := '' 
Local cCliTab  := '' 
Local cLojaTab := ''

nQtdVen := aCols[n][nPQtdVen]
nPrcVen := aCols[n][nPPrcVen]
nPrcLis := aCols[n][nPPrcLis]
nDesVal := aCols[n][nPDesVal]
nDesPer := aCols[n][nPDesPer]
nValEsp := aCols[n][nPValEsp]
nValPer := aCols[n][nPValPer]
nDesApl := aCols[n][nPDesApl] 
nDesAnt := aCols[n][nPDesAnt]
cProd   := aCols[n][nPDesPro]
cTabela := M->C5_TABELA

Do Case
	Case !Empty(M->C5_LOJAENT) .And. !Empty(M->C5_CLIENT)
		cCliTab   := M->C5_CLIENT
		cLojaTab  := M->C5_LOJAENT
	Case Empty(M->C5_CLIENT) 
		cCliTab   := M->C5_CLIENTE
		cLojaTab  := M->C5_LOJAENT
	OtherWise
		cCliTab   := M->C5_CLIENTE
		cLojaTab  := M->C5_LOJACLI
EndCase  

nPrcTab := A410Tabela(cProd,;
					  cTabela,;
					  n,;
					  nQtdVen,;                                   
					  cCliTab,;
					  cLojaTab,;
					  If(nPLoteCtl>0,aCols[n][nPLoteCtl],""),;
					  If(nPNumLote>0,aCols[n][nPNumLote],""),;
					  NIL,;
					  NIL,;
					 .T.)	

nValRet := Round( nPrcTab - (nValEsp),2 ) 

//If nDesAnt == 0                  
	// Grava o valor de tabela antigo.
	aCols[n][nPDesAnt] := nPrcTab 
	// Grava o valor de desconto aplicado. 
	aCols[n][nPDesApl] := (nPrcTab - nValRet) 
//Endif
 
Return( nValRet )