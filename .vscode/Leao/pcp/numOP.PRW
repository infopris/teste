#include "rwmake.ch" 

* Numeração automática de Ordens de Produção

User Function NumOP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
