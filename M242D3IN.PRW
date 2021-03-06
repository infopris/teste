#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M242D3IN  �Autor  �Fabio Cazarini      � Data �  17/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Manipula��o do movimento "RE7" da tabela SD3                ���
���          �                                                            ���
���          �LOCALIZA��O:                                                ���
���          �Na rotina de desmontagem de produtos.                       ���
���          �                                                            ���
���          �EM QUE PONTO:                                               ���
���          �Ser� executado ap�s a grava��o do registro "RE7" referente  ���
���          �� movimenta��o derequisi��o do produto origem.              ���
���          �                                                            ���
���          �UTILIZA��O:                                                 ���
���          �Este ponto de entrada permitir� ao usu�rio a manipula��o    ���
���          �dos dados criados para omovimento "RE7" na tabela SD3. Estas��� 
���          �informa��es referem-se ao cabe�alho dajanela de desmontagem ���
���          �de produtos.                                                ���
���          �                                                            ���
���          �Este ponto de entrada poder� ser usado em conjunto com o    ���
���          �ponto de entrada MT242SCR que permite ao usu�rio manipular  ���
���          �os objeto na tela da rotina, comopor exemplo, incluir GET's ���
���          �para obter informa��es que n�o s�o captadas nopadr�o.       ���
���          �                                                            ���
���          �IMPORTANTE: a tabela SD3 j� estar� posicionada no registro  ��� 
���          �que acabou de serinserido pelo sistema.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION M242D3IN()

CusCabD3() // Calcula o custo do cabecalho da SD3

RETURN                                                                     
       

STATIC FUNCTION CusCabD3()   
LOCAL _aArea := GetArea() 
               
SD3->D3_CUSTO1 := 1

RestArea(_aArea)

RETURN