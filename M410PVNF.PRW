#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410PVNF  ºAutor  ³Andre R. Esteves    º Data ³  04/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na validacao da geracao da NF saida        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Qualita                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410PVNF()

Local _lRet    := .T.
Local _aArea   := GetArea()
Local _aAreaC6 := GetArea("SC6")
Local _aAreaC9 := GetArea("SC9")
Local _lGeraDup := .F.
Local _lC9Ok   := .F.

//Verifica se tem itens liberados (SC9) que ainda nao foram faturados
dbSelectArea("SC9")
SC9->(dbSetOrder(1))   //FILIAL + PEDIDO + ITEM + SEQUEN + PRODUTO
If SC9->(DbSeek(xFilial("SC9") + SC5->C5_NUM))
	While SC9->(!Eof()) .And. xFilial("SC5") + SC5->C5_NUM == xFilial("SC9") + SC9->C9_PEDIDO
		If Empty(SC9->C9_NFISCAL)
			_lC9Ok := .T.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se gera financeiro (venda)     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC6")
			dbSetOrder(1) //FILIAL + NUM + ITEM + PRODUTO
			dbSeek(xFilial("SC6") + SC5->C5_NUM + SC9->C9_ITEM + SC9->C9_PRODUTO)  //POSICIONA NO ITEM DO PEDIDO
			_lGeraDup := Iif(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")=="S" .And. SC5->C5_TIPO == "N",.T.,_lGeraDup)
			
			If _lGeraDup
				//Caso tenha item liberado, verifica se tem Forma de pagto em aberto (sem nota gerada)
				dbSelectArea("SZ8")
				SZ8->(dbSetOrder(1)) //Z8_FILIAL+Z8_NUMPED+Z8_DTLIB+Z8_DOC+Z8_SERIE+Z8_PARCELA
				If !SZ8->(DbSeek(xFilial("SZ8")+SC5->C5_NUM+DtoS(SC9->C9_DATALIB)+PadR("",TamSX3("Z8_DOC")[1])+PadR("",TamSX3("Z8_SERIE")[1])))
					_lRet	:= .F.
				EndIf
			EndIf
			
		EndIf
		SC9->(dbSkip())
	EndDo
Else
	_lRet := .F.
EndIf
If !_lC9Ok
	_lRet := .F.
EndIf

If !_lRet
	AVISO(OEMTOANSI("Formas Pagto"),OEMTOANSI("Para este tipo de faturamento, é obrigatório o preenchimento da forma de pagamento para todas as parcelas!!"),{"Ok"},2)
EndIf

RestArea(_aAreaC6)
RestArea(_aAreaC9)
RestArea(_aArea)
Return(_lRet)
