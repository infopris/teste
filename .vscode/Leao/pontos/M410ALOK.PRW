#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  M410aloc  �Autor  �   Luiz Eduardo   � Data �  02/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera o campo C6_PEDCLI para o sistema permitir a exclusao.           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function m410Alok()

Local _xAlias  := GetArea()

//cPar1 := ParamIxb[1]
//cPar2 := ParamIxb[2]

//MsgBox ("m410aloc"+str(nOpc,4),"Informa��o","INFO")
if left(sc5->c5_num,1)=="P"
	if MsgBox ("Deseja excluir o pedido "+sc5->c5_num+" ?","Escolha","YESNO")
		Select SC6
		Seek xFilial()+sc5->c5_num
		do while !eof() .and. sc6->c6_num==sc5->c5_num
			if rlock() .and. left(sc6->c6_pedcli,3) = "TMK"
				sc6->c6_pedcli := "  "
			endif
			skip
		enddo
	endif
Endif

RestArea(_xAlias)

Return(.T.)
