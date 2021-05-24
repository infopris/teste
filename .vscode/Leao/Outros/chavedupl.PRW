#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF
//#Include "RwMake.ch"

/*
*****************************************************************************
** Funcao     Inventario   Autor   Luiz Eduardo           Data   23.04.2010**
*****************************************************************************
** Descricao  Geracao do arquivo de inventario                             **
*****************************************************************************
*/

User Function chavedupl()

Select SX2
seek "SC6"
cUnico := X2_UNICO

Select SC6
dbSetOrder(1)
dbGoTop()
Do while !eof()
	cChave := &cUnico //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	nReg := recno()
	skip
	do while cChave = &cUnico .and. rlock() // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO .and. rlock()
		replace C6_FILIAL with 'MI'
		goto nReg
		skip
	enddo
Enddo

Return
