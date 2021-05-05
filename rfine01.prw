#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function Rfine01()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
   
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_TTABAT,_JUROS,_LIQUI,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � RFINE01.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para calcular o valor de l�quido (principal -    ���
���          � abatimentos concedidos+Juros) nos t�tulos do contas a pagar���
���          � a ser gravado no arquivo de remessa de titulos ao banco    ���
���          � via Cnab Pagar Bradesco                                    ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari Rosa                                      ���
���mento     � 31/03/06.                                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cnab a Pagar BRADESCO                                      ���
��������������������������������������������������������������������������ٱ�
/*/

_TtAbat := 0.00
_Juros  := 0.00

//--- Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao
//---        titulo do parametro 
_TtAbat  := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_TtAbat  += SE2->E2_DECRESC 
_Juros := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
_Liqui := (SE2->E2_SALDO-_TtAbat+_Juros)
_Liqui := Left(StrZero((_Liqui*1000),16),15)

Return(_Liqui)
