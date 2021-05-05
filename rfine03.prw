#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function rfine03()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_JUROS,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������� �Ŀ��
���Rotina    � RFINE03.PRw                                                 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para calcular o valor dos juros nos titulos do   ���
���          � do contas a pagar, a ser gravado no arquivo de remessa     ���
���          � de titulos ao banco via CNAB.                              ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 31/03/2006                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cnab Pagar Bradesco                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
_Juros := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
_Juros := Left(StrZero((_Juros*1000),16),15)
// Substituido pelo assistente de conversao do AP5 IDE em 29/06/00 ==> __Return(_Juros)
Return(_Juros)        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
