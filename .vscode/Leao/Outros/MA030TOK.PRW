#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030Inc  � Autor � Luiz Eduardo       � Data �  31/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida codigo do cliente na inclusao do cadastro           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M030Inc()

_xAlias  := GetArea()
nRec := recno()
cnome := sa1->a1_nome
DbSelectArea("SA1")
dbSetOrder(1)
Seek xFilial()+a1_cod+a1_loja
if !eof() .and. val(a1_cod)#0 .and. a1_nome#cnome
	xCod := val(sa1->a1_cod)
	Do while .t.
		cCod := strzero(xCod+1,6)
		Select SA1
		seek xFilial()+cCod
		if eof()
			exit
		endif
		xCod := val(cCod)
	Enddo
	MsgBox ("Cliente Cadastrado para outro usuario, regravado com o codigo "+cCod,"Informa��o","INFO")
	Goto nRec
	recLock("SA1",.f.)
	sa1->a1_cod := cCod
	MsUnLock()
	dbGoTop()
endif

RestArea(_xAlias)

Return(.t.)