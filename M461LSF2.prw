#INCLUDE "PROTHEUS.CH"

/*
	Ponto de entrada para verificar se existe
	a possibilidade de ativar o desconto suframa.
	
	Com o campo F2_TXZERO preenchido as rotinas padrões do protheus
	ativam o webservice Ws Sinal e então capturam o código que
	é enviado na nota permitindo o desconto do SUFRAMA	
	
	Autor: Valdeci Junior
	Data: 15/12/2016
*/                                                    

User Function M461LSF2()
    Local aArea := GetArea()
	Local nOrder:= 0
	Local lFound:= .F.
	
	nOrder := RetOrder("SA1", "A1_FILIAL+A1_COD+A1_LOJA")     
    DbSelectArea("SA1")  	                   
    SA1->(DbSetOrder(nOrder))
    lFound := SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))
    
    If( lFound )    
		If( !Empty(SA1->A1_SUFRAMA) .And. !Empty(SA1->A1_INSCR) .And. Upper(AllTrim(SA1->A1_CALCSUF)) $ "S/I" )	
			SF2->F2_TXZERO := "T"	
		EndIf	                              		
	EndIf    
	
	RestArea( aArea )		
Return()