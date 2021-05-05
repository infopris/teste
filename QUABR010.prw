#Include "PROTHEUS.CH"
#include "report.ch"

/*
	Relatórios de itens de compra
*/
User Function QUABR010()	
	Local oReport	:= Nil
	Local oSec1		:= Nil
	Local cWAlias	:= ""
	
	//RpcSetType(3)
	//RpcSetEnv("01", "01")
	
	cWAlias := GetNextAlias()
	Pergunte("QLTCOM01", .F.)		
	
	oReport:= TReport():New("QUABR010","Relação de compras x item","QLTCOM01",{|oReport| PrintReport(oReport, oSec1, cWAlias)},"Imprime a relação de compras por item, baseado nas notas fiscais de entrada")
   	oReport:SetLandscape()			// Formato paisagem
	oReport:oPage:nPaperSize:=9 	// Impressão em papel A4
	oReport:lFooterVisible 	:= .F.	// Não imprime rodapé do protheus
	oReport:lParamPage		:=.F.	// Não imprime pagina de parametros 
	
	oSec1 := ReportDef(oReport, cWAlias)
	
	oReport:PrintDialog()		
Return()   
/*
	Definição das celulas e totais do relatório
*/
Static Function ReportDef(oReport, cWAlias)
	Local oSec1		:= Nil 
	
	oSec1 := TRSection():New(oReport,"Relatação compras por item", {cWAlias},,.F.,.F.)

	TRCell():New(oSec1,"D1_DTDIGIT"		,cWAlias,"Digitacao"								,Alltrim(X3Picture("D1_DTDIGIT"))	,TamSx3("D1_DTDIGIT")[1]	,)
	TRCell():New(oSec1,"D1_EMISSAO"		,cWAlias,"Emissao"									,Alltrim(X3Picture("D1_EMISSAO"))	,TamSx3("D1_EMISSAO")[1]	,)
	TRCell():New(oSec1,"D1_FORNECE"		,cWAlias,"Forn"										,Alltrim(X3Picture("D1_FORNECE"))	,TamSx3("D1_FORNECE")[1]	,)
	TRCell():New(oSec1,"D1_LOJA"		,cWAlias,"Lj"										,Alltrim(X3Picture("D1_LOJA"))	 	,TamSx3("D1_LOJA")[1]		,)
	TRCell():New(oSec1,"A2_NREDUZ"		,cWAlias,"Nome"										,Alltrim(X3Picture("A2_NREDUZ")) 	,TamSx3("A2_NREDUZ")[1]		,)
	TRCell():New(oSec1,"D1_TIPO"		,cWAlias,"T Doc"									,Alltrim(X3Picture("D1_TIPO"))		,TamSx3("D1_TIPO")[1]		,)
	TRCell():New(oSec1,"D1_DOC"			,cWAlias,"No Doc"									,Alltrim(X3Picture("D1_DOC"))		,TamSx3("D1_DOC")[1]		,)
	TRCell():New(oSec1,"D1_ITEM"		,cWAlias,"It Doc"									,Alltrim(X3Picture("D1_ITEM"))		,TamSx3("D1_ITEM")[1]		,)
	TRCell():New(oSec1,"D1_PEDIDO"		,cWAlias,"No PC"									,Alltrim(X3Picture("D1_PEDIDO"))	,TamSx3("D1_PEDIDO")[1]		,)
   	TRCell():New(oSec1,"D1_ITEMPC"		,cWAlias,"It PC"									,Alltrim(X3Picture("D1_ITEMPC"))	,TamSx3("D1_ITEMPC")[1]		,)
   	TRCell():New(oSec1,"D1_COD"			,cWAlias,GetSx3Cache( "D1_COD" 		, "X3_TITULO" )	,Alltrim(X3Picture("D1_COD"))		,TamSx3("D1_COD")[1]		,)
   	TRCell():New(oSec1,"B1_DESC"		,cWAlias,GetSx3Cache( "B1_DESC" 	, "X3_TITULO" )	,Alltrim(X3Picture("B1_DESC"))		,13							,)
   	TRCell():New(oSec1,"D1_UM"			,cWAlias,"Un."										,Alltrim(X3Picture("D1_UM"))		,TamSx3("D1_UM")[1]			,)
   	TRCell():New(oSec1,"D1_QUANT"		,cWAlias,"Qtde"										,Alltrim(X3Picture("D1_QUANT"))		,TamSx3("D1_QUANT")[1]		,)
   	TRCell():New(oSec1,"D1_VUNIT"		,cWAlias,"Vlr Unit"									,Alltrim(X3Picture("D1_VUNIT"))		,TamSx3("D1_VUNIT")[1]		,)
   	TRCell():New(oSec1,"D1_TOTAL"		,cWAlias,"Tot. S/ IPI"								,Alltrim(X3Picture("D1_TOTAL")) 	,TamSx3("D1_TOTAL")[1]		,)
   	TRCell():New(oSec1,"D1_VALIPI"		,cWAlias,"Vlr. IPI"									,Alltrim(X3Picture("D1_VALIPI")) 	,TamSx3("D1_VALIPI")[1]		,)
   	TRCell():New(oSec1,"TOTCIPI"		,cWAlias,"Tot. C/ IPI"								,Alltrim(X3Picture("D1_VALIPI")) 	,TamSx3("D1_VALIPI")[1]		,)
	TRCell():New(oSec1,"D1_ICMSRET"		,cWAlias,GetSx3Cache( "D1_ICMSRET" 	, "X3_TITULO" )	,Alltrim(X3Picture("D1_ICMSRET"))	,TamSx3("D1_ICMSRET")[1]	,)
	TRCell():New(oSec1,"D1_VALICM"		,cWAlias,GetSx3Cache( "D1_VALICM" 	, "X3_TITULO" )	,Alltrim(X3Picture("D1_VALICM")) 	,TamSx3("D1_VALICM")[1]		,)
	TRCell():New(oSec1,"D1_VALFRE"		,cWAlias,GetSx3Cache( "D1_VALFRE" 	, "X3_TITULO" )	,Alltrim(X3Picture("D1_VALFRE")) 	,TamSx3("D1_VALFRE")[1]		,)
	TRCell():New(oSec1,"D1_SEGURO"		,cWAlias,GetSx3Cache( "D1_SEGURO" 	, "X3_TITULO" )	,Alltrim(X3Picture("D1_SEGURO")) 	,TamSx3("D1_SEGURO")[1]		,)
	TRCell():New(oSec1,"D1_DESPESA"		,cWAlias,GetSx3Cache( "D1_DESPESA" 	, "X3_TITULO" )	,Alltrim(X3Picture("D1_DESPESA"))	,TamSx3("D1_DESPESA")[1]	,)
	TRCell():New(oSec1,"D1_VALDESC"		,cWAlias,GetSx3Cache( "D1_VALDESC" 	, "X3_TITULO" )	,Alltrim(X3Picture("D1_VALDESC"))	,TamSx3("D1_VALDESC")[1]	,)
	
	TRFunction():New(oSec1:Cell("D1_TOTAL")		,"Total S/ IPI" 	,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.)	   	   		
	TRFunction():New(oSec1:Cell("D1_VALIPI")	,"Total IPI" 		,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.)	   	   		
	TRFunction():New(oSec1:Cell("TOTCIPI")		,"Total c/ IPI" 	,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.)	   	   		
	TRFunction():New(oSec1:Cell("D1_ICMSRET")	,"Total ICMS Ret" 	,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.)	   	   		
	TRFunction():New(oSec1:Cell("D1_VALICM")	,"Total ICMS " 		,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.)	   	   			
	TRFunction():New(oSec1:Cell("D1_VALFRE")	,"Total Frete "		,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.)	   	   				
	TRFunction():New(oSec1:Cell("D1_SEGURO")	,"Total Seguro "	,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.)	   	   				
	TRFunction():New(oSec1:Cell("D1_DESPESA")	,"Total Despesa "	,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.) 
	TRFunction():New(oSec1:Cell("D1_VALDESC")	,"Total Despesa "	,"SUM"	,,,"@E 999,999,999,999",,.F.,.T.) 
   	
   	oReport:lTotalInLine := .F.		   	   				
Return(oSec1)        
/*
	Imprime o relatório 
*/
Static Function PrintReport( oReport, oSec1, cWAlias) 
	Local cWhere	:= ""
	Local cFilF4	:= ""  
	Local cFilB1	:= ""
	Local cFilD1	:= ""
	Local cFilC7	:= ""      
	Local cFilA2	:= ""
	 
	cWhere	:= GetWhere()
	cWhere 	:= "%"+cWhere+"%"
	
	cFilF4 	:= xFilial("SF4")
	cFilB1	:= xFilial("SB1") 
	cFilD1	:= xFilial("SB1")
	cFilC7	:= xFilial("SC7")
	cFilA2	:= xFilial("SA2")

	BeginSql alias cWAlias
		SELECT * FROM			
		%Table:SD1% SD1
		INNER JOIN %Table:SF1% SF1
			ON D1_FILIAL=%exp:cFilD1% 	AND
				F1_FILIAL=%exp:cFilD1%  AND
				D1_DOC=F1_DOC 			AND
				D1_SERIE=F1_SERIE 		AND
				D1_FORNECE=F1_FORNECE 	AND
				D1_LOJA=F1_LOJA 		AND
				SF1.%NotDel%			AND
				SD1.%NotDel%
		LEFT JOIN %Table:SA2% SA2 
			ON D1_FORNECE=A2_COD 		AND
				D1_LOJA=A2_LOJA 		AND  
				A2_FILIAL=%exp:cFilA2%  AND
				SA2.%NotDel%
		LEFT JOIN %Table:SB1% SB1
			ON B1_COD=D1_COD 			AND   
			B1_FILIAL=%exp:cFilB1%		AND
			SB1.%NotDel%
		LEFT JOIN %Table:SF4% SF4
			ON F4_CODIGO=D1_TES 		AND
			F4_FILIAL=%exp:cFilF4%		AND
			SF4.%NotDel%
		LEFT JOIN %Table:SC7%  SC7 
			ON D1_PEDIDO=C7_NUM 		AND
			D1_ITEMPC=C7_ITEM           AND
			C7_FILIAL=%exp:cFilC7%		AND
			SC7.%NotDel%
		/*WHERE*/
			%exp:cWhere%
		ORDER BY 
//			D1_FORNECE, D1_LOJA, D1_DOC, D1_ITEM 
			D1_FORNECE, D1_LOJA, D1_DOC, D1_COD //Modificado por Fabio Lima 13/03/2017	
	
	EndSql	
	
	If( (cWAlias)->(!Eof()) )
		oSec1:Init()
		oSec1:SetHeaderSection(.T.)   
	
		While( (cWAlias)->(!Eof()) )
			If oReport:Cancel()
				Exit
			EndIf
	 
			oReport:IncMeter()
			
			oSec1:Cell("D1_DTDIGIT"):SetValue(SToD((cWAlias)->D1_DTDIGIT))
			oSec1:Cell("D1_EMISSAO"):SetValue(SToD((cWAlias)->D1_EMISSAO))
			oSec1:Cell("D1_FORNECE"):SetValue((cWAlias)->D1_FORNECE)
			oSec1:Cell("D1_LOJA"):SetValue((cWAlias)->D1_LOJA)
			oSec1:Cell("A2_NREDUZ"):SetValue((cWAlias)->A2_NREDUZ)
			oSec1:Cell("D1_TIPO"):SetValue((cWAlias)->D1_TIPO)
			oSec1:Cell("D1_DOC"):SetValue((cWAlias)->D1_DOC)
			oSec1:Cell("D1_ITEM"):SetValue((cWAlias)->D1_ITEM)
			oSec1:Cell("D1_PEDIDO"):SetValue((cWAlias)->D1_PEDIDO)
			oSec1:Cell("D1_ITEMPC"):SetValue((cWAlias)->D1_ITEMPC)
			oSec1:Cell("D1_COD"):SetValue((cWAlias)->D1_COD)
			oSec1:Cell("B1_DESC"):SetValue(Substr((cWAlias)->B1_DESC,1,10)+iif(Len((cWAlias)->B1_DESC)>10,"...",""))
			oSec1:Cell("D1_UM"):SetValue((cWAlias)->D1_UM)
			oSec1:Cell("D1_QUANT"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_QUANT*-1,(cWAlias)->D1_QUANT))
			oSec1:Cell("D1_VUNIT"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_VUNIT*-1,(cWAlias)->D1_VUNIT))
			oSec1:Cell("D1_TOTAL"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_TOTAL*-1,(cWAlias)->D1_TOTAL))
			oSec1:Cell("D1_VALIPI"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_VALIPI*-1,(cWAlias)->D1_VALIPI))
			oSec1:Cell("TOTCIPI"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",((cWAlias)->D1_TOTAL+(cWAlias)->D1_VALIPI)*-1,(cWAlias)->D1_TOTAL+(cWAlias)->D1_VALIPI))
			oSec1:Cell("D1_ICMSRET"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_ICMSRET*-1,(cWAlias)->D1_ICMSRET))
			oSec1:Cell("D1_VALICM"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_VALICM*-1,(cWAlias)->D1_VALICM))
			oSec1:Cell("D1_VALFRE"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_VALFRE*-1,(cWAlias)->D1_VALFRE))
			oSec1:Cell("D1_SEGURO"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_SEGURO*-1,(cWAlias)->D1_SEGURO))
			oSec1:Cell("D1_DESPESA"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_DESPESA*-1,(cWAlias)->D1_DESPESA))
			oSec1:Cell("D1_VALDESC"):SetValue(iif( AllTrim((cWAlias)->D1_TIPO)=="D",(cWAlias)->D1_VALDESC*-1,(cWAlias)->D1_VALDESC))
			
			oSec1:PrintLine()
	 
			(cWAlias)->(dbSkip())
		EndDo
	
		oSec1:Finish()
	EndIf                     
	
	(cWAlias)->(DbCloseArea())
	
 
Return()
/*
	Formata o Where de acordo com o pergunte carregado
*/
Static Function GetWhere()
	Local cWhere := ""
	Local cFornIni	:= ""
	Local cFornFin	:= ""
	Local cPrdIni	:= ""
	Local cPrdFin	:= "" 
	Local dDigIni	:= SToD("")
	Local dDigFin	:= SToD("")	
	
	dDigIni := MV_PAR01 
	dDigFin	:= MV_PAR02 
	cFornIni:= MV_PAR03
	cFornFin:= MV_PAR04
	cPrdIni	:= MV_PAR05
	cPrdFin	:= MV_PAR06
               
 	If( !Empty(dDigIni) .AND. !Empty(dDigFin) )
 		cWhere := "D1_DTDIGIT BETWEEN '"+DToS(dDigIni)+"' AND '"+DToS(dDigFin)+"'"
 	EndIf   
 	
 	If( !Empty(cFornIni) )
 		If(!Empty(cWhere))
 			cWhere += " AND "
 		EndIf                
 		
 		cWhere += "D1_FORNECE >='"+cFornIni+"'"
 	EndIf
 	
 	If( !Empty(cFornFin) )
 		If(!Empty(cWhere))
 			cWhere += " AND "
 		EndIf                
 		
 		cWhere += "D1_FORNECE <='"+cFornFin+"'"
 	EndIf
 	 
 	If( !Empty(cPrdIni) )
 		If(!Empty(cWhere))
 			cWhere += " AND "
 		EndIf                
 		
 		cWhere += "D1_COD >='"+cPrdIni+"'"
 	EndIf  
 	
 	If( !Empty(cPrdFin) )
 		If(!Empty(cWhere))
 			cWhere += " AND "
 		EndIf                
 		
 		cWhere += "D1_COD <='"+cPrdFin+"'"
 	EndIf         
   
	If( !Empty( cWhere) )
		cWhere := " WHERE "+cWhere
	EndIf	 	
Return( cWhere )