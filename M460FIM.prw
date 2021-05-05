#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MA460FIM

@author 	cbarros | Claudio Barros
@since 		06/05/2017
@version 	P11
@obs    	Rotina Especifica Qualita
@Obs    	Ponto de entrada para gravar a forma de pagamento no
@Obs        campo E1_FORMA,busca na tabela SZ8 a forma de pagamento
@Obs        que foi incluida pelo usuário no momento da digitação do
@Obs        pedido de vendas.
/*/
//-------------------------------------------------------------------
User Function M460FIM()

Local _cAlias := GetArea()
Local _lRet  := .T.


	  

If !Empty(SF2->F2_DUPL)

CONOUT("M460FIM-------------Inicio da Chamada p/Gravacao SE1 - Forma de Pagamento-----------------")
Conout("Nro. Documento :"+SF2->F2_DOC)
Conout("Serie :"+SF2->F2_SERIE)
Conout("Data Emissao :"+Dtoc(SF2->F2_EMISSAO))
Conout("Nro. Pedido :"+SC5->C5_NUM)
CONOUT("Posicionamento dos Arquivos : "+DtoC(dDataBase)+"-"+Time())

	DbSelectArea("SZ8")
	If SZ8->(DbSeek(xFilial("SZ8")+SC5->C5_NUM))
		While SZ8->(Z8_FILIAL+Z8_NUMPED) == SC5->(C5_FILIAL+C5_NUM)
			DbSelectArea("SE1")
			If SE1->(DbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DUPL+SZ8->Z8_PARCELA))
				RecLock("SE1",.F.)
				SE1->E1_FORMA := SZ8->Z8_FORMA
				SE1->(MsUnlock())
		CONOUT("M460FIM-------------Gravado Forma de Pagamento -----------------")
	CONOUT("Prefixo : "+SE1->E1_PREFIXO)
	CONOUT("Nro. Duplicata : "+SE1->E1_NUM)
	CONOUT("Nro. Parcela : "+SE1->E1_PARCELA)
	CONOUT("Forma Pagto. : "+SZ8->Z8_FORMA)

			EndIf
			SZ8->(DbSkip())
		End
	Else
	   CONOUT("M460FIM-------------Problema na Gravacao SE1 - Forma de Pagamento-----------------")
	   CONOUT("Titulo Não Encontrado na Tabela SE1: "+DtoC(dDataBase)+"-"+Time())
	   CONOUT("Prefixo : "+SF2->F2_PREFIXO)
	   CONOUT("Nro. Duplicata : "+SF2->F2_DUPL)
	   CONOUT("Nro. Parcela : "+SZ8->Z8_PARCELA)
	
	EndIf
EndIf

RestArea(_cAlias)


Return
