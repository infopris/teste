#include "protheus.ch"
#include "parmtype.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT010_MVC
Ponto de Entrada MVC da rotina MATA010 (CADASTRO DE PRODUTOS)

@author Andre R. Esteves
@since 12/03/2018
@version P12
/*/
//-------------------------------------------------------------------

 User Function ITEM()  //Substitui o antigo A010TOK
    Local aParam := PARAMIXB
    Local oModel := FwModelActive()    
    Local lRet   := .T.
    Local cXUser := SuperGetMV("ES_XUSERA",,"") //Códigos dos usuários
         
    // VERIFICA SE APARAM NÃO ESTÁ NULO
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
         
        //  VERIFICA SE O PONTO EM QUESTÃO É O FORMPOS
        If cIdPonto == "FORMPOS"
             alert("entrou")
            // VERIFICA SE OMODEL NÃO ESTÁ NULO
            If oModel <> NIL
             
		If (__cUserID $ cXUser)
			M->B1_MSBLQL := '1'
		Endif
                 
            EndIf
             
        EndIf
     
    EndIf
Return lRet