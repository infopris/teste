#INCLUDE "PROTHEUS.CH" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA440C9   �Autor  �Andre R. Esteves    � Data �  24/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado ap�s confirma��o do Pedido de   ���
���          � Venda  *                                                   ���
���          |
�������������������������������������������������������������������������͹��
���Uso       � WorkFlow Qualita                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������     
Identificacao dos bloqueios de credito:
           01 - Bloqueio de Credito por Valor   
           04 - Vencto do Limite de Credito - Data de Credito Vencida               
           05 - Bloqueio de Credito por Estorno           
           06 - Bloqueio de Credito por Risco              
           09 - Rejei��o de Credito - Rejeitado Manualmente
*/
User Function MTA440C9()

If SC9->C9_BLCRED $ '01|04|05|06|09'

	__lBlqCred := .T.

EndIf     

     //U_RFATE50() 

Return()   