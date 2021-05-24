#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF
//#Include "RwMake.ch"

/*
*****************************************************************************
** Funcao     Inventario   Autor   Luiz Eduardo           Data   23.04.2010**
*****************************************************************************
** Descricao  Elimina chaves duplicadas                             **
*****************************************************************************
*/

User Function chavedupl()

Select SE1
dbSetOrder(1)
dbGoTop()
Do while !eof()
	cChave := E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	nReg := recno()
	skip
	do while cChave = E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO .and. rlock()
		replace E1_FILIAL with 'MI'
		goto nReg
		skip
	enddo
	if E1_filial='MI'
		exit
	endif
Enddo


Return

Select SD1
dbSetOrder(1)
dbGoTop()
Do while !eof()
	cChave := D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_FORMUL+D1_ITEMGRD
	nReg := recno()
	skip
	do while cChave = D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_FORMUL+D1_ITEMGRD .and. rlock()
		replace D1_FILIAL with 'MI'
		goto nReg
		skip
	enddo
	if D1_filial='MI'
		exit
	endif
Enddo


Return

Select SC6
dbSetOrder(1)
dbGoTop()
Do while !eof()
	cChave := C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	nReg := recno()
	skip
	do while cChave = C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO .and. rlock()
		replace C6_FILIAL with 'MI'
		goto nReg
		skip
	enddo
	if c6_filial='MI'
		exit
	endif
Enddo

Select SC9
dbSetOrder(1)
dbGoTop()
Do while !eof()
	cChave := C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	nReg := recno()
	skip
	do while cChave = C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO .and. rlock()
		replace C9_FILIAL with 'MI'
		goto nReg
		skip
	enddo
	if c9_filial='MI'
		exit
	endif
Enddo

Select SC5
dbSetOrder(2)
dbGoTop()          
set softseek on
SEEK xFilial()+"20170701"
set softseek off
n:=0
Do while !eof()
	Select SA1
	seek xFilial()+sc5->(C5_CLIENTE+C5_LOJACLI)
	if !empty(sa1->a1_menpad1) .and. empty(sc5->C5_MENPAD1)
		Select SC5                  
		if rlock()
		Replace sc5->C5_MENPAD1 With SA1->A1_MENPAD1
		endif
		n++
	endif
	Select SC5
	skip
Enddo      

return
