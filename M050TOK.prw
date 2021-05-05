#INCLUDE 'PROTHEUS.CH' 
#INCLUDE "RWMAKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} M050TOK
Ponto de Entrada antes da efetiva��o do Cadastro de Transportadora.

@author F�bio Lima
@since 19/07/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function M050TOK()

Local cXUser := SuperGetMV("ES_XUSERA",,"") //C�digos dos usu�rios
Local lRet   := .T.

//If lcopia == .T. .And. 
If (__cUserID $ cXUser)
	M->A4_MSBLQL := '1'
Endif

Return( lRet )