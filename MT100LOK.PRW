#Include "Protheus.ch"

/*
-----------------------------------------------------------------------+
Programa  |MT100LOK  |Autor  |Luiz Eduardo        | Data |  25/03/20   |
-----------------------------------------------------------------------+
|Desc.     |Ponto de Entrada na Validacao da conta contabil            |
|          |                                                           |
-----------------------------------------------------------------------+
|Uso       | Qualita                                                   |
-----------------------------------------------------------------------+
*/
User Function MT100LOK()


Local lRet := ParamIxb[1]
local cConta := AScan(aHeader, { |x| Alltrim(x[2]) == 'D1_CONTA'})

if empty(aCols[n][cConta])
	ALERT("Favor digitar a conta contábil")
	lRet:= .F.
endif

Return(lRet)
