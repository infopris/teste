#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA440C9 º Autor ³   Alexandro Dias   º Data ³  24/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza Call Center com informacoes do pedido quando      º±±
±±º          ³ o mesmo for liberado.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA440C9()

Local _xAlias  := GetArea()
Local _cNumPed := SC9->C9_PEDIDO
Local _cNumTmk := ""

if sc9->c9_sequen<>"01"
	Select SC6                          
	dbsetorder(1)
	seek xFilial()+sc9->(c9_pedido+c9_item) 
//	if sc6->c6_
	ALERT("Item em duplicidade - Verificar ")
	Select SC9

endif

DbSelectArea("SUA")
DbOrderNickName("NUMSC5")

IF DbSeek(xFilial("SUA")+_cNumPed)
	
	_cNumTmk := SUA->UA_NUM
	
	RecLock("SUA",.F.)
		Replace UA_STATUS  With "LIB"
	MsUnLock()
	
EndIF

DbSelectArea("SC9")
DbSetOrder(1)
DbSeek(xFilial("SC9")+_cNumPed)

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+_cNumPed)
RecLock("SC5",.F.)
SC5->C5_DATALIB := SC9->C9_DATALIB
MsUnlock()

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA)

DbSelectArea("SC9")

While SC9->(!Eof()) .and. SC9->C9_PEDIDO == _cNumPed

	RecLock("SC9",.F.)
		Replace C9_NUMTMK  With _cNumTmk
		Replace C9_NOMECLI With SA1->A1_NOME
	MsUnLock()

	DbSkip()

EndDo

RestArea(_xAlias)

Return