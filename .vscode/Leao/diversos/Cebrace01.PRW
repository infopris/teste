#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCebrace01 บAutor  ณLuiz Eduardo        บ Data ณ  08/03/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ protheus                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Comunica็ใo do estoque com CEBRACE                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

/*Api de comunica็ใo com a CEBRACE

WSRESTFUL ESTOQUE DESCRIPTION "Servi็o REST para comunica็ใo com CEBRACE"

WSDATA CODPRODUTO As String

WSMETHOD GET DESCRIPTION "Retorna o produto informado na URL" WSSYNTAX "/PRODUTOS || /PRODUTOS/{}"

END WSRESTFUL

*/