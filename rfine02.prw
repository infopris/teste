#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function rfine02()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("TTABAT,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � RFINE02.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para calcular o valor de descontos nos titulos   ���
���          � do contas a pagar a ser gravado no arquivo de remessa de   ���
���          � titulos ao banco via CNAB                                  ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 31/03/2006                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cnab a Pagar Bradesco                                      ���
��������������������������������������������������������������������������ٱ�
/*/

_TtAbat := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_TtAbat  += SE2->E2_DECRESC 
_TtAbat := Left(StrZero((_TtAbat*1000),16),15)

Return(_TtAbat)        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00