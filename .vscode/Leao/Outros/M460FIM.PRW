#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M460FIM  � Autor �   Alexandro Dias   � Data �  24/08/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Call Center com informacoes da Nota Fiscal quando ���
���          � a mesma e gerada.                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M460FIM()

_xAlias  := GetArea()

DbSelectArea("SUA")
DbOrderNickName("NUMSC5")

IF DbSeek(xFilial("SUA")+SD2->D2_PEDIDO)
	RecLock("SUA",.F.)
	Replace UA_DOC     With SF2->F2_DOC
	Replace UA_SERIE   With SF2->F2_SERIE
	Replace UA_EMISNF  With SF2->F2_EMISSAO
	Replace UA_STATUS  With "NF."
	MsUnLock()
EndIF

RestArea(_xAlias)

Return