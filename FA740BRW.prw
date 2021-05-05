#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} FA740BRW
Adiciona itens no menu principal do fonte FINA740

@author		Andre R. Esteves
@since		07/11/2016
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
User Function FA740BRW()  
Local aRotina := {} 

aAdd(aRotina,{'Digitalizacao','u_LOTXM010',0,5}) 

Return aRotina