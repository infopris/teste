#include "Rwmake.ch"

User Function MUDAPROD()

Processa({|| ProcMuda() })

Return

Static Function ProcMuda()

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SB1")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SB1->B1_COD
	
	IF Substr(SB1->B1_COD,1,4) == "2801"
		RecLock("SB1",.F.)
		Replace B1_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SB1->B1_COD,1,4) == "2802"
		RecLock("SB1",.F.)
		Replace B1_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" - "+Substr(SB1->B1_DESC,1,20)+" 1/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SB5")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SB5->B5_COD
	
	IF Substr(SB5->B5_COD,1,4) == "2801"
		RecLock("SB5",.F.)
		Replace B5_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SB5->B5_COD,1,4) == "2802"
		RecLock("SB5",.F.)
		Replace B5_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" - "+Substr(SB5->B5_CEME,1,20)+" 2/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SG1")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SG1->G1_COD
	
	IF Substr(SG1->G1_COD,1,4) == "2801"
		RecLock("SG1",.F.)
		Replace G1_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SG1->G1_COD,1,4) == "2802"
		RecLock("SG1",.F.)
		Replace G1_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 3/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SG1")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SG1->G1_COMP
	
	IF Substr(SG1->G1_COMP,1,4) == "2801"
		RecLock("SG1",.F.)
		Replace G1_COMP With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SG1->G1_COMP,1,4) == "2802"
		RecLock("SG1",.F.)
		Replace G1_COMP With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 4/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SB2")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SB2->B2_COD
	
	IF Substr(SB2->B2_COD,1,4) == "2801"
		RecLock("SB2",.F.)
		Replace B2_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SB2->B2_COD,1,4) == "2802"
		RecLock("SB2",.F.)
		Replace B2_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 5/12")
EndDo
//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SB9")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SG1->G1_COD
	
	IF Substr(SB9->B9_COD,1,4) == "2801"
		RecLock("SB9",.F.)
		Replace B9_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SB9->B9_COD,1,4) == "2802"
		RecLock("SB9",.F.)
		Replace B9_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 6/12")
EndDo
//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SC6")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SC6->C6_PRODUTO
	
	IF Substr(SC6->C6_PRODUTO,1,4) == "2801"
		RecLock("SC6",.F.)
		Replace C6_PRODUTO With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SC6->C6_PRODUTO,1,4) == "2802"
		RecLock("SC6",.F.)
		Replace C6_PRODUTO With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 7/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SC9")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SC9->C9_PRODUTO
	
	IF Substr(SC9->C9_PRODUTO,1,4) == "2801"
		RecLock("SC9",.F.)
		Replace C9_PRODUTO With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SC9->C9_PRODUTO,1,4) == "2802"
		RecLock("SC9",.F.)
		Replace C9_PRODUTO With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 8/12")
EndDo
//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SD1")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SD1->D1_COD
	
	IF Substr(SD1->D1_COD,1,4) == "2801"
		RecLock("SD1",.F.)
		Replace D1_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SD1->D1_COD,1,4) == "2802"
		RecLock("SD1",.F.)
		Replace D1_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 9/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SD2")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SD2->D2_COD
	
	IF Substr(SD2->D2_COD,1,4) == "2801"
		RecLock("SD2",.F.)
		Replace D2_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SD2->D2_COD,1,4) == "2802"
		RecLock("SD2",.F.)
		Replace D2_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 10/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SD3")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SD3->D3_COD
	
	IF Substr(SD3->D3_COD,1,4) == "2801"
		RecLock("SD3",.F.)
		Replace D3_COD With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SD3->D3_COD,1,4) == "2802"
		RecLock("SD3",.F.)
		Replace D3_COD With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 11/12")
EndDo

//*****************************************************************************************
//*****************************************************************************************
//*****************************************************************************************

  _nTotReg := 0
  _nRegAtu := 0

DbSelectArea("SUB")

DbSetOrder(0)

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

While !Eof()
	
	_cOldCod := SUB->UB_PRODUTO
	
	IF Substr(SUB->UB_PRODUTO,1,4) == "2801"
		RecLock("SUB",.F.)
		Replace UB_PRODUTO With "2800" + Substr(_cOldCod,5,11)
		MsUnLock()
	ElseIF Substr(SUB->UB_PRODUTO,1,4) == "2802"
		RecLock("SUB",.F.)
		Replace UB_PRODUTO With "2900" + Substr(_cOldCod,5,11)
		MsUnLock()
	EndIF
	DbCommit()
	DbSkip()
	
	_nRegAtu := _nRegAtu + 1
	
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" 12/12")
EndDo

MsgBox("Fim do Processamento !!!","Atencao","ALERT")

Return
