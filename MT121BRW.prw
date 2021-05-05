#Include "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT121BRW
P.E para incluir no MenuDef do Pedido de Compras. 

@author Bruno Lazarini Garcia
@since 21/06/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function MT121BRW()  

//aAdd(aRotina,{'Impr. Espec.','U_FSRDWR01()', 0, 2, 0, Nil }) //"Relatório Especifico de Compras" 
aAdd(aRotina,{'Impressao Espec.'       ,'U_FSRDWR02()', 0, 2, 0, Nil }) //"Relatório Especifico de Compras" 

Return()