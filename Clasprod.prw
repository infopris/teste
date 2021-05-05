#Include "Protheus.ch"
  
//Bibliotecas
#Include "Protheus.ch"
  
/*/{Protheus.doc} zTeste
Função de Teste
@type function
@author Terminal de Informação
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
    AxCadastro('SZX', 'Classificação de Produto - Qualita', cDelOk, cFunTOk)
     
    RestArea(aAreaZX)
    RestArea(aArea)
Return