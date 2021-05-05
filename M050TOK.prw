#INCLUDE 'PROTHEUS.CH' 
#INCLUDE "RWMAKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} M050TOK
Ponto de Entrada antes da efetivação do Cadastro de Transportadora.

@author Fábio Lima
@since 19/07/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function M050TOK()

Local cXUser := SuperGetMV("ES_XUSERA",,"") //Códigos dos usuários
Local lRet   := .T.

//If lcopia == .T. .And. 
If (__cUserID $ cXUser)
	M->A4_MSBLQL := '1'
Endif

Return( lRet )