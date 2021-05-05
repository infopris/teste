#INCLUDE 'PROTHEUS.CH' 
#INCLUDE "RWMAKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MA030TOK
Ponto de Entrada antes da efetiva��o do Cadastro de Cliente.

@author Bruno Lazarini Garcia
@since 14/06/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function MA030TOK()

Local cXUser := SuperGetMV("ES_XUSERA",,"") //C�digos dos usu�rios
Local lRet   := .T.

//If lcopia == .T. .And. 
If (__cUserID $ cXUser)
	M->A1_MSBLQL := '1'
Endif

Return( lRet )