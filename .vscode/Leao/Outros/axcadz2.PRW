#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF
//#Include "RwMake.ch"

/*
*****************************************************************************
** Funcao     AXCADZ2  Autor   Luiz Eduardo               Data   28.09.2017**
*****************************************************************************
* Cadastro do Grupos de Clientes
*/

User Function AXCADZ2()


AxCadastro("SZ2","Grupos de Clientes")
Return
/*
SELECT SZ1
DBSETORDER(1)
dbgotop()
do while !eof()
	select SZ2
	dbSetOrder(2)
	seek xFilial()+sz1->Z1_nreduz
	Select SZ1
	if rlock()
		replace Z1_XGRPCLI with sz2->Z2_CODGRP
	endif                                     
	skip
Enddo
	cCod := Z2_CODGRP
	skip
	Do while Z2_CODGRP=cCod
		if rlock()
			delete
		endif
		skip
	Enddo
enddo
SELECT SZ2
DBSETORDER(1)
dbgotop()
do while !eof()
	select SZ1
	dbSetOrder(3)
	seek xFilial()+sz2->Z2_codgrp
	Select SZ2
	if rlock() .and. sz2->Z2_codgrp =sz1->Z1_XGRPCLI
		replace Z2_TOP with "S"
	endif                                     
	skip
Enddo
/*	cCod := Z2_CODGRP
	skip
	Do while Z2_CODGRP=cCod
		if rlock()
			delete
		endif
		skip
	Enddo
enddo
SELECT SZ2
DBSETORDER(1)
dbgotop()
do while !eof()
	select SZ1
	dbSetOrder(3)
	seek xFilial()+sz2->Z2_codgrp
	Select SZ2
	if rlock() .and. sz2->Z2_codgrp =sz1->Z1_XGRPCLI
		replace Z2_TOP with "S"
	endif                                     
	skip
Enddo
/*	cCod := Z2_CODGRP
	skip
	Do while Z2_CODGRP=cCod
		if rlock()
			delete
		endif
		skip
	Enddo
enddo
