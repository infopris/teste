#include "rwmake.ch" 

* Numera��o autom�tica de Ordens de Produ��o

User Function NumOP()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCOD")

cAlias     := Alias()
cCod       := Space(06)

dbSelectArea( "SC2" )
dbSetOrder(1)      
cCod := M->C2_NUM
IF val(cCod)>=1 .and. val(cCod)<=999999
  cCod := M->C2_NUM
else          
  Go bott
  Do while !bof()
    SKIP -1
  Enddo
  cCod := SC2->C2_NUM
  do while .t.
    cCod := val(cCod)+1
    cCod :=	strzero(cCod,6)
    seek xfilial()+cCod
    if eof()
       exit
    endif 
  Enddo
Endif

dbSelectArea( cAlias )
Return( cCod )
