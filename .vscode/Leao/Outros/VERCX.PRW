#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/08/01
#INCLUDE "TOPCONN.CH"

User Function VerCX() // Verifica quantidade de itens por caixa

nItem := m->UB_PRODUTO

Select SB1
Seek xFilial()+nItem
if B1_CONV <> 0
	if M->UB_QUANT % B1_CONV <> 0 .AND. B1_SEGUM<>"M2"
		msgstop("Em Cada Caixa Possui: "+str(B1_CONV,5,0))
	endif			                                        
endif

Return(nItem)

