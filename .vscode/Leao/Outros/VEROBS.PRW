#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/08/01
#INCLUDE "TOPCONN.CH"

User Function VerObs() // Verifica se o item esta com obsoleto no cadastro

//Local _nItem := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO" })
nItem := m->UB_PRODUTO

Select SB1
Seek xFilial()+nItem

if sb1->b1_sitprod=="OB" .and. len(trim(sb1->b1_cod))#4
   MsgBox ("O Produto nao esta em uso, usar outro codigo ou verificar com producao","Informa‡Æo","INFO")
   Return("  ")
Endif   

Return(nItem)

