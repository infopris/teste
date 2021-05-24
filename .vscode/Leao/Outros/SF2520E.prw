#include "rwmake.ch

User Function SF2520E()

_xAlias   := { Alias(), IndexOrd(), Recno() }                          
_cLeaoPrx := GetMv("MV_LEAOPRX")

DbSelectArea("SE1")
_nRegSE1 := Recno()
_nOrdSE1 := IndexOrd()
DbSetOrder(1)

If DbSeek( xFilial("SE1") +_cLeaoPrx + SF2->F2_DOC )
   Do While SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_PREFIXO == _cLeaoPrx .And. SE1->E1_NUM == SF2->F2_DOC
      RecLock("SE1",.F.)
      DbDelete()
      MsUnlock()
      DbSkip()
   EndDo
EndIf

DbSelectArea("SE3")
_nRegSE3 := Recno()
_nOrdSE3 := IndexOrd()
DbSetOrder(1)

If DbSeek(xFilial()+_cLeaoPrx+SF2->F2_DOC)
   Do While SE3->E3_FILIAL == xFilial("SE3") .and. SE3->E3_PREFIXO == _cLeaoPrx .and. SE3->E3_NUM == SF2->F2_DOC
      RecLock("SE3",.F.)
      DbDelete()
      MsUnlock()
      DbSkip()
   EndDo
EndIf

DbSelectArea("SE1")
DbGoTo(_nRegSE1)
DbSetOrder(_nOrdSE1)

DbSelectArea("SE3")
DbGoTo(_nRegSE3)
DbSetOrder(_nOrdSE3)

DbSelectArea(_xAlias[1])
DbSetorder(_xAlias[2])
DbGoto(_xAlias[3])

Return(.T.)
