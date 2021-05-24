#include "rwmake.ch"

User Function MIGRA()   // Programa para Calcular o Custo do produtos baseado na estrutura cadastrada

//dbUseArea( .T.,,"\custos.dbf", "TRB", Nil, .F. )
SELECT SC5
dbSetOrder(1)
dbgotop()
MsgBox("SC5 !!!","Atencao","INFO")
do while !eof() .and. 1=2
	cNum := sc5->c5_num
	skip 
	do while sc5->c5_num=cNum
		if rlock()
			delete
		endif
		skip
	enddo
Enddo             

SELECT SC6
dbSetOrder(1)
dbgotop()
MsgBox("SC6 !!!","Atencao","INFO")
do while !eof() .and. 1=2
	cNum := sc6->(c6_num+c6_item)
	skip 
	do while sc6->(c6_num+c6_item)=cNum
		if rlock()
			delete
		endif
		skip
	enddo
Enddo             

SELECT SC9
dbSetOrder(1)
dbgotop()
MsgBox("SC9 !!!","Atencao","INFO")
do while !eof() .AND. 1=2
	cNum := sc9->(c9_pedido+c9_item+c9_sequen)
	skip 
	do while sc9->(c9_pedido+c9_item+c9_sequen)=cNum
		if rlock()
			delete
		endif
		skip
	enddo
Enddo             

SELECT SD2
dbSetOrder(3)
dbgotop()
MsgBox("SD2 !!!","Atencao","INFO")
do while !eof() .AND. 1=2
	cNum := sD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_ITEM)
	skip 
	do while sD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_ITEM)=cNum
		if rlock()
			delete
		endif
		skip
	enddo
Enddo             

SELECT SUA
dbSetOrder(1)
dbgotop()
MsgBox("SUA !!!","Atencao","INFO")
do while !eof()
	cNum := sUA->(UA_NUM)
	skip 
	do while sUA->(ua_num)=cNum
		if rlock()
			delete
		endif
		skip
	enddo
Enddo             
