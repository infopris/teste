#include "rwmake.ch"        
#INCLUDE "TOPCONN.CH"

User Function VALCESTA()

Select SRX
Seek xFilial()+"35"
nValCes := Val(left(rx_txt,10))/10
Return(nValCes)
