#include "TOTVS.ch"

User Function GFATX001()
Local aArea    := GetArea()
Local cProduto := aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})]
Local cCliente := M->C5_CLIENTE
Local cloja := M->C5_LOJACLI
Local cGrupoProd := Posicione("SB1",1,XFilial('SB1')+cProduto,"B1_GRUPO") 
Local nPreco
Local nReturn

nPreco := Posicione("DA1",2,XFilial('DA1')+cProduto+M->C5_TABELA,"DA1_PRCVEN")
If nPreco==0
	nPreco := Posicione("DA1",4,XFilial('DA1')+M->C5_TABELA+cGrupoProd,"DA1_PRCVEN")
	If nPreco == 0
		Return
	EndIf
EndIf

nReturn := nPreco

If !AtIsRotina("A410DEVOL")
	DbSelectArea("SZ2")
	DbSetOrder(1)
	DbSeek(xFilial("SZ2")+cCliente+cLoja+cProduto)
	If (SZ2->Z2_FATOR) > 0
		nReturn := (SZ2->Z2_FATOR)*nPreco
	Else
		DbSetOrder(2)
		DbSeek(xFilial("SZ2")+cCliente+cLoja+cGrupoProd)
		If (SZ2->Z2_FATOR) > 0
			nReturn := (SZ2->Z2_FATOR)*nPreco
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return (nReturn)