#include "rwmake.ch"   

* Numera��o autom�tica de Clientes
* Stat -> Ok

User Function SA1_COD()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCOD")

cAlias     := Alias( )
cCod       := Space(06)

dbSelectArea( "SA1" )
dbSetOrder(1)      
cCod := M->A1_COD          
IF val(cCod)>=1 .and. val(cCod)<=999999
  cCod := M->A1_COD
else          
//Go bott
  seek xFilial()+"15"
  skip-1
  Do while SA1->A1_COD>'999999' .and. !bof()
    SKIP -1
  Enddo
  cCod := SA1->A1_COD     
  cCod := val(SA1->A1_COD)+1
  cCod :=strzero(cCod,6)
Endif

dbSelectArea( cAlias )
Return( cCod )
