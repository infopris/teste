#include "rwmake.ch"

User Function F040RECIMP()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � F040RECIMP � Autor � Luiz Eduardo       � Data � 30/08/18  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PONTO DE ENTRADA PARA AJUTAR VENCIMENTOS DE TIT NO CR      ���
���Descri��o � (APENAS T�TULOS EM BANCO N�O CONSIDERAR RETEN��O)          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Leao Espelhos                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
M->E1_VENCREA:=M->E1_VENCTO
//SITCOB
//Titulos em Banco
IF !empty(m->E1_portado)

	M->E1_VENCREA := DataValida(M->E1_VENCTO,.T.)
	
EndIF

Return()


