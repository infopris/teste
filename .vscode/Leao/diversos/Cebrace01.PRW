#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cebrace01 �Autor  �Luiz Eduardo        � Data �  08/03/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � protheus                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Comunica��o do estoque com CEBRACE                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CEBRACE01()

	private oRest=FWRest():New("http://localhost:8015") // ou usar FWREST():Post(<aHeadStr >)-> lOK
	private aHeader := {}
	
	oRest:SetPath("www.cebrace.com.br/ReposicaoContinua/api/obterReposicoes")

	if oRest:Get(aHeader) 
		Conout("GET",oRest:GetResult())
	else
		Conout("GET",oRest:GetLastError())
	Endif
	
	private Resultado := oRest:GetResult()
	private Error	:= oRest:GetLastError()
	alert(Resultado)
	alert(error)
	Conout("Fim")
	
Return

/*Api de comunica��o com a CEBRACE

WSRESTFUL ESTOQUE DESCRIPTION "Servi�o REST para comunica��o com CEBRACE"

WSDATA CODPRODUTO As String

WSMETHOD GET DESCRIPTION "Retorna o produto informado na URL" WSSYNTAX "/PRODUTOS || /PRODUTOS/{}"

END WSRESTFUL

*/