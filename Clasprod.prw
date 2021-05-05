#Include "Protheus.ch"
  
//Bibliotecas
#Include "Protheus.ch"
  
/*/{Protheus.doc} zTeste
Fun��o de Teste
@type function
@author Terminal de Informa��o
@since 13/11/2016
@version 1.0
    @example
    u_zTeste()
/*/
  
User Function Clasprd()
    Local aArea    := GetArea()
    Local aAreaZX  := SZX->(GetArea())
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T."
     
    //Chamando a tela de cadastros
    AxCadastro('SZX', 'Classifica��o de Produto - Qualita', cDelOk, cFunTOk)
     
    RestArea(aAreaZX)
    RestArea(aArea)
Return