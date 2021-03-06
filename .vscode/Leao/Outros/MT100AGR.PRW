#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  MT100AGR�Autor  �   Luiz Eduardo     � Data �  10/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza data de Entrada de acordo com data digitacao      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT100AGR()

cDoc := sf1->f1_doc
Select Sd1
dbSetOrder(1)
seek xFilial()+cDoc
Do while sd1->d1_doc==sf1->f1_doc .and. sd1->d1_dtdigit== sf1->f1_dtdigit .and.;
	 sd1->d1_fornece==sf1->f1_fornece
	 if rlock()
		sd1->d1_datacus := sf1->f1_dtdigit
	 endif
	 skip
Enddo


// Atualiza numero do pedido de compras quando for complemento de NF
if sf1->f1_tipo == "C"
	cDoc1:= sf1->(f1_doc+"UNI"+f1_fornece+f1_loja)
	cDoc := sf1->(f1_doc+f1_serie+f1_fornece+f1_loja)
	Select Sd1
	dbSetOrder(1)
	seek xFilial()+cDoc
	Do while sd1->(d1_doc+d1_serie+d1_fornece+d1_loja)==cDoc .and. ;
		sd1->d1_dtdigit== sf1->f1_dtdigit
		cRec := recno()
		cCod := sd1->d1_cod
		Seek xFilial()+cDoc1+cCod
		cPed := sd1->d1_pedido
		cIt  := sd1->d1_itempc
		goto cRec
		if rlock() .and. !empty(cPed)
			sd1->d1_pedido := cPed
			sd1->d1_itempc := cIt
		endif
		skip
	Enddo
endif

Return