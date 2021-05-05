#INCLUDE 'PROTHEUS.CH' 
#INCLUDE "RWMAKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MA040TOK
Ponto de Entrada antes da efetivação do Cadastro de Vendedores.

@author Fábio Lima
@since 19/07/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function MA040TOK()

Local cXUser := SuperGetMV("ES_XUSERA",,"") //Códigos dos usuários
Local lRet   := .T.

//If lcopia == .T. .And. 
If (__cUserID $ cXUser)
	M->A3_MSBLQL := '1'
Endif

Return( lRet )