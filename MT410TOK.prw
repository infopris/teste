#include "Protheus.ch"

User Function MT410TOK()
	Local lRet := .T.

	If( !Empty(M->C5_CONDPAG) .And. AllTrim(M->C5_CONDPAG) == "038" )
		lRet := !Empty(M->C5_PARC1) .And. !Empty(M->C5_DATA1)

		If(!lRet)
			MsgInfo("A condição de pagamento 038-Manual foi informada."+Chr(10)+Chr(13)+"Neste caso, é necessário informar a(s) parcela(s) e data(s) de vencimento(s) antes de gravar o pedido.")
		EndIf	
	EndIf
Return(lRet) 