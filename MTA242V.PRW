#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA242V   �Autor  �Fabio Cazarini      � Data �  05/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida a inclus�o dos dados no arquivo SD3                  ���
���          �                                                            ���
���          �LOCALIZA��O : Function A242Inclui() - Respons�vel pela      ���
���          �inclus�o de movimenta��es                                   ���
���          �                                                            ���
���          �DESCRI��O : Este Ponto de Entrada tem como finalidade       ���
���          �validar ou nao a inclusao dos dados no arquivo SD3.         ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �Se Verdadeiro (.T.), valida a inclusao dos dados no SD3.    ���
���          �Se Falso (.F.), nao valida a inclusao dos dados no SD3.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MTA242V()
LOCAL _lRet := .T.

IF _lRet
	U_QUPCPG01("V")
ENDIF	

RETURN _lRet 