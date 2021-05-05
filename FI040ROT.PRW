#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} FI040ROT
Adiciona itens no menu principal do fonte FINA040

@author		Andre R. Esteves
@since		07/11/2016
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
User Function FI040ROT()  
Local aRotina := ParamIxb

aAdd(aRotina,{'Digitalizacao','u_LOTXM010',0,5})
Return aRotina