#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

* Numera��o autom�tica de Clientes
* Stat -> Ok

User Function exblksa1()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

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
  Go bott
  Do while SA1->A1_COD>'10' .and. SA1->A1_COD<'15ZZZZ' .and. !bof()
    SKIP -1
  Enddo
  cCod := SA1->A1_COD     
  do while .t.
    cCod := val(cCod)+1
    cCod :=strzero(cCod,6)
    seek xfilial()+cCod
    if eof()
       exit
    endif 
  Enddo
Endif

dbSelectArea( cAlias )
Return( cCod )
