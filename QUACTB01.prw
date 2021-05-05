#INCLUDE "PROTHEUS.CH"

User Function QUACTB01()
Local aArea   := GetArea()
Local cTabela := "Z6"  
Local cConta  := ""    
Local cCodPro
Local cAlias
Local cCampo
Local nI
Local nTamCod

dbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+cTabela)

While SX5->(!EOF()) .And. SX5->(X5_FILIAL+X5_TABELA)==xFilial("SX5")+cTabela .And. Empty(cConta)

	cCodPro := AllTrim(SX5->X5_DESCRI)
	nTamCod := Len(cCodPro)

	If SubStr(SD1->D1_COD,1,nTamCod)==cCodPro .And. AllTrim(SD1->D1_CF) $ AllTrim(SX5->X5_DESCSPA)		
		
		cConta := AllTrim(SX5->X5_DESCENG)
		   
		nI := At("->",cConta)
		If nI > 0
			cAlias := SubStr(cConta,1,nI - 1)
			cCampo := SubStr(cConta,nI + 2)
			If cAlias $ "SD1|SF4|SB1|SA1|SA2"
				cConta := (cAlias)->&cCampo
			EndIf
		EndIf			
		
	EndIf
	 
	SX5->(dbSkip())	
EndDO

RestArea(aArea)
Return( cConta )