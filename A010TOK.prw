#INCLUDE 'PROTHEUS.CH' 
#INCLUDE "RWMAKE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} A010TOK
Ponto de Entrada antes da efetiva��o do Cadastro do Produto.

@author Bruno Lazarini Garcia
@since 14/06/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function A010TOK()

Local cXUser := SuperGetMV("ES_XUSERA",,"") //C�digos dos usu�rios
Local lRet   := .T.

//If lcopia == .T. .And. 
If (__cUserID $ cXUser)
	M->B1_MSBLQL := '1'
Endif

Return( lRet )

//ALTERADO PARA TESTE