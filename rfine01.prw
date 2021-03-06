#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00

User Function Rfine01()        // incluido pelo assistente de conversao do AP5 IDE em 29/06/00
   
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP5 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_TTABAT,_JUROS,_LIQUI,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿝otina    ? RFINE01.PRW                                                낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏escri뇚o ? ExecBlock para calcular o valor de l죘uido (principal -    낢?
굇?          ? abatimentos concedidos+Juros) nos t죜ulos do contas a pagar낢?
굇?          ? a ser gravado no arquivo de remessa de titulos ao banco    낢?
굇?          ? via Cnab Pagar Bradesco                                    낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏esenvolvi? Marciane Gennari Rosa                                      낢?
굇쿺ento     ? 31/03/06.                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Cnab a Pagar BRADESCO                                      낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
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
