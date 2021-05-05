#INCLUDE 'PROTHEUS.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} GFATX003
Inicializa Seg. Unidade de Medida pelo Fator de Conversao. CK_QTDVEN

@author Bruno Lazarini Garcia
@since 24/05/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function GFATX003()

Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="CK_PRODUTO"})
Local nPItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="CK_ITEM"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="CK_QTDVEN"})
Local aOld 		:= GETAREA()
Local lGrade    := MaGrade()
Local cProduto  := ''
Local lRet	 	:= .T.

cProduto := TMP1->CK_PRODUTO
cItem    := TMP1->CK_ITEM                                   

If ( lGrade )
	MatGrdPrrf(@cProduto)
EndIf
	
nQtdConv  := Round( ConvUm(cProduto,M->CK_QTDVEN,TMP1->CK_UNSVEN,2), TamSX3( "C6_QTDVEN" )[2] )
 
DbSelectArea( "TMP1" )
RecLock("TMP1",.F.)
	TMP1->CK_UNSVEN  := nQtdConv
MsUnlock()

RESTAREA( aOld )
	
Return( lRet )