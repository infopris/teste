#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT460EST � Autor �   Alexandro Dias   � Data �  24/08/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Call Center com informacoes do pedido quando      ���
���          � o mesmo e estornado.                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT460EST()

_xAlias  := GetArea()

DbSelectArea("SUA")
DbOrderNickName("NUMSC5")

IF DbSeek(xFilial("SUA")+SC9->C9_PEDIDO)
	RecLock("SUA",.F.)
	Replace UA_STATUS  With "SUP"
	MsUnLock()
EndIF

RestArea(_xAlias)

Return