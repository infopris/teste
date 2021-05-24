#include "rwmake.ch

// Na virada de saldos grava o campo b9_margem com o custo medio para MP
User Function A280SB9()

_xAlias   := { Alias(), IndexOrd(), Recno() }                          

//Select SB1
//dbSetOrder(1)
//Seek xFilial()+sb9->b9_cod
//Select SB2
//dbSetOrder(1)
//Seek xFilial()+sb9->b9_cod+sb9->b9_local
Select SB9
if rlock() .and. sb1->b1_tipo=="MP"
	replace b9_margem with sb2->b2_cm1
endif

Return(.T.)
