#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSD2520  � Autor �   Alexandro Dias   � Data �  24/08/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Call Center com informacoes da Nota Fiscal quando ���
���          � a mesma e excluida.                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MSD2520()

_xAlias  := GetArea()

DbSelectArea("SUA")
DbOrderNickName("NUMSC5")

IF DbSeek(xFilial("SUA")+SD2->D2_PEDIDO)
	RecLock("SUA",.F.)
	Replace UA_DOC     With ""
	Replace UA_SERIE   With ""
	Replace UA_EMISNF  With Ctod("")
	Replace UA_STATUS  With "SUP"
	MsUnLock()
EndIF

RestArea(_xAlias)

Return