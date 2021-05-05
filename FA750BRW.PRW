#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} FA750BRW
Adiciona itens no menu principal do fonte FINA750

@author		Andre R. Esteves
@since		07/11/2016
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
User Function FA750BRW()  
Local aRotina := {} //ParamIxb

aAdd(aRotina,{'Digitalizacao','u_LOTXM010',0,5}) 

Return aRotina