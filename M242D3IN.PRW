#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M242D3IN  ºAutor  ³Fabio Cazarini      º Data ³  17/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manipulação do movimento "RE7" da tabela SD3                º±±
±±º          ³                                                            º±±
±±º          ³LOCALIZAÇÃO:                                                º±±
±±º          ³Na rotina de desmontagem de produtos.                       º±±
±±º          ³                                                            º±±
±±º          ³EM QUE PONTO:                                               º±±
±±º          ³Será executado após a gravação do registro "RE7" referente  º±±
±±º          ³à movimentação derequisição do produto origem.              º±±
±±º          ³                                                            º±±
±±º          ³UTILIZAÇÃO:                                                 º±±
±±º          ³Este ponto de entrada permitirá ao usuário a manipulação    º±±
±±º          ³dos dados criados para omovimento "RE7" na tabela SD3. Estasº±± 
±±º          ³informações referem-se ao cabeçalho dajanela de desmontagem º±±
±±º          ³de produtos.                                                º±±
±±º          ³                                                            º±±
±±º          ³Este ponto de entrada poderá ser usado em conjunto com o    º±±
±±º          ³ponto de entrada MT242SCR que permite ao usuário manipular  º±±
±±º          ³os objeto na tela da rotina, comopor exemplo, incluir GET's º±±
±±º          ³para obter informações que não são captadas nopadrão.       º±±
±±º          ³                                                            º±±
±±º          ³IMPORTANTE: a tabela SD3 já estará posicionada no registro  º±± 
±±º          ³que acabou de serinserido pelo sistema.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Qualita                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION M242D3IN()

CusCabD3() // Calcula o custo do cabecalho da SD3

RETURN                                                                     
       

STATIC FUNCTION CusCabD3()   
LOCAL _aArea := GetArea() 
               
SD3->D3_CUSTO1 := 1

RestArea(_aArea)

RETURN