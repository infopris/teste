#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/10/00

User Function Fa60fil()        // incluido pelo assistente de conversao do AP5 IDE em 25/10/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Inc\luido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("MVPAR100,MVPAR101,MVPAR102,MVPAR103")
SetPrvt("EFIL060,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  � FA60FIL  � Autor � Heitor Sacomani       � Data � 03/08/01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � PONTO DE ENTRADA PARA FILTRAR DADOS DO SE1 P/ BORDERO      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Leao Espelhos                                              낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
     
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Substituido pelo assistente de conversao do AP5 IDE em 25/10/00 ==> FUNCTION FILTRABOR

////////////////////////////////////////////////////////////////////////////////////////////////////////////

Alert("Os Titulos serao selecionados conforme Banco do Cliente registrado nos titulos a partir do Cadastro de Clientes")
EFIL060  := 'E1_FILIAL == "'+XFILIAL()+'"'
EFIL060  := EFIL060+'.AND. E1_BCO1 == "'+cPort060+'"'
EFIL060  := EFIL060+'.OR. E1_BCO2 == "'+cPort060+'"'
EFIL060  := EFIL060+'.OR. E1_BCO3 == "'+cPort060+'"'
EFIL060  := EFIL060+'.OR. E1_BCO4 == "'+cPort060+'"'
EFIL060  := EFIL060+'.OR. E1_BCO5 == "'+cPort060+'"'

Return(EFIL060)        // incluido pelo assistente de conversao do AP5 IDE em 25/10/00

