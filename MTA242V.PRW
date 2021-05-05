#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA242V   บAutor  ณFabio Cazarini      บ Data ณ  05/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida a inclusใo dos dados no arquivo SD3                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณLOCALIZAวรO : Function A242Inclui() - Responsแvel pela      บฑฑ
ฑฑบ          ณinclusใo de movimenta็๕es                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณDESCRIวรO : Este Ponto de Entrada tem como finalidade       บฑฑ
ฑฑบ          ณvalidar ou nao a inclusao dos dados no arquivo SD3.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณSe Verdadeiro (.T.), valida a inclusao dos dados no SD3.    บฑฑ
ฑฑบ          ณSe Falso (.F.), nao valida a inclusao dos dados no SD3.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณQualita                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION MTA242V()
LOCAL _lRet := .T.

IF _lRet
	U_QUPCPG01("V")
ENDIF	

RETURN _lRet 