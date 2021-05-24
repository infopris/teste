#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/10/00

User Function CHKCNPJ()        // incluido pelo assistente de conversao do AP5 IDE em 25/10/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Inc\luido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_cret")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CHKCGC   � Autor � Heitor Sacomani       � Data � 30/08/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PONTO DE ENTRADA PARA RETORNAR SE O CLI E CNPJ OU CPF      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Leao Espelhos                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
     
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Substituido pelo assistente de conversao do AP5 IDE em 25/10/00 ==> FUNCTION FILTRABOR

////////////////////////////////////////////////////////////////////////////////////////////////////////////

Dbselectarea("SA1")
Dbsetorder(1)
Dbseek(xfilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
If SA1->A1_PESSOA == "F"
   _CRET := "01"
ELSE   
    _CRET := "02" 
Endif
Return(_CRET)        // incluido pelo assistente de conversao do AP5 IDE em 25/10/00

