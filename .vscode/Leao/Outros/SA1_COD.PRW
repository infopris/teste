#include "rwmake.ch"   

* Numeração automática de Clientes
* Stat -> Ok

User Function SA1_COD()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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