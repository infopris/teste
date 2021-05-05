#include "protheus.ch"
/*
	Ponto de entrada para customização do NFe Sefaz	
*/
User Function PE01NFESEFAZ()
	Local aArea		:= GetArea()
	Local aNfe 		:= PARAMIXB
	Local aProds 	:= {}
	Local cMsgCli	:= ""
	Local cTipo		:= ""
	Local cMsgFis	:= ""
	Local cPedido	:= ""

	If( Len(aNFe) >=5 )  
		aProds 	:= aNfe[1]
		cMsgFis	:= aNfe[3]
		aProds 	:= ChangeProducts(aProds)
        
        cTipo 	:= iIf(AllTrim(aNfe[5, 4]) == "1", "S", "E")

        If( cTipo=="S" .AND. ValType(aProds[1][38])=="C") 

			cPedido 	:= aProds[1][38]
			DbSelectArea("SC5")		
			SC5->(DbSetOrder(RetOrder("SC5","C5_FILIAL+C5_NUM")))
				
			If(SC5->(DbSeek(xFilial("SC5")+cPedido)))
	        	If( !Empty(SC5->C5_MENPAD) )
	        		If( Alltrim(SC5->C5_MENPAD) == AllTrim(SA1->A1_MENSAGE) )
	        			cMsgFis	:= Formula(SC5->C5_MENPAD)
	        		EndIf
	        	EndIf
        	EndIf
        EndIf

		aNfe[1]	:= aProds	
		aNfe[3] := cMsgFis		 		
	EndIf
	
	RestArea( aArea )                     	
Return(aNfe)              

/*
	Altera as caracteristicas do array de produtos
	enviado para a NFe Xml
*/
Static Function ChangeProducts(aProds)
	Local nI		:= 0
	Local nMax		:= 0
	Local nOrder	:= 0
	Local cPedido	:= ""
	Local cItemPv	:= ""
	Local cFilC6	:= ""        
	
	nI		:= 1
	nMax 	:= Len( aProds )
	
	DbSelectArea("SC6")
	nOrder	:= RetOrder("SC6", "C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO")
	cFilC6	:= xFilial("SC6")
	
	SC6->(DbSetOrder(nOrder))

	While( nI<=nMax )
		If( ValType(aProds[nI][38])=="C" .And. ValType(aProds[nI][39])=="C")
			cPedido 	:= aProds[nI][38]
			cItemPv		:= aProds[nI][39]
			cDescProd	:= aProds[nI][4]
					                    
			If( SC6->(DbSeek(cFilC6+cPedido+cItemPv)))					
				If !Empty(SC6->C6_XLOTE) 
					cDescProd := cDescProd + " Lote: " + SC6->C6_XLOTE + " Dt.Fabr.: " + Dtoc(SC6->C6_XDTFAB)
				Endif    
			EndIf
			
			aProds[nI][4] := cDescProd 
		EndIf
		nI++
	EndDo
	    
Return( aProds )