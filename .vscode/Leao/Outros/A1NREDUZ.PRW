#include "rwmake.ch"  

* Verifica se jah existe o nome fantasia cadastrado com outro codigo

User Function A1NREDUZ()

//cAlias     := Alias()

cCod    := M->A1_COD
cNReduz := M->A1_NREDUZ

dbSelectArea("SA1")
dbSetOrder(5)
Seek xFilial()+cNReduz
if sa1->a1_cod<>cCod
	Aviso("Atencao","Cliente cadastrado com o codigo "+sa1->a1_cod,{"Sair"} )
Endif

//dbSelectArea( cAlias )

Return()
