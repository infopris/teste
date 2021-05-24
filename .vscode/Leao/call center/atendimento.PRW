#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Atendimento  ºAutor  ³Luiz Eduardo     º Data ³  17/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para geração do relatório de atendimentos             ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Leao                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Atendimento()

local cPerg		:= "ATEND"
local cQuery	:= ""
local aD		:= {}
local aB		:= {}
local lC		:= .F.
local d,i

Private nHdl		:= 0
Private i			:= 0
Private cFile		:= ""
Private oExcel	:= Nil
Private aAreaSM0	:= SM0->(GetArea())
Private aCabec	:= {}
Private cLinhaCSV	:= ""

public cNomeArq

aAdd( aD, "Este programa permite exportar para excel um resumo dos atendimentos " )
aAdd( aD, "" )

ajustaSX1(cPerg)
pergunte(cPerg,.F.)

aAdd( aB, {5,.T.,{|| pergunte(cPerg,.T.) }} )
aAdd( aB, {1,.T.,{|| lC := .T., fechaBatch() }} )
aAdd( aB, {2,.T.,{|| fechaBatch() }} )

formBatch( "Resumo dos Atendimentos", aD, aB )

If Select("trb1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif
If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := {}
AADD(aCampos,{ "UB_NUM"     	, "C",06,0})
//AADD(aCampos,{ "UB_PRODUTO"     , "C",15,0})
AADD(aCampos,{ "DESCRI"     	, "C",40,0})
AADD(aCampos,{ "UB_QUANT"   	, "N",12,2})
AADD(aCampos,{ "UB_VLRITEM"     , "N",12,2})
AADD(aCampos,{ "UB_NUMPV"     	, "C",06,0})
AADD(aCampos,{ "Emissao"   		, "C",10,0})
AADD(aCampos,{ "Obs"     		, "C",160,0})
AADD(aCampos,{ "Cliente"		, "C",06,0})
AADD(aCampos,{ "Loja"     		, "C",06,0})
AADD(aCampos,{ "Grupo"			, "C",08,0})
AADD(aCampos,{ "Operador"     	, "C",06,0})
AADD(aCampos,{ "Coordenad"  	, "C",06,0})
AADD(aCampos,{ "Vendedor"     	, "C",06,0})
AADD(aCampos,{ "Tipo"     		, "C",06,0})

cTemp := CriaTrab(nil,.f.)
//dbCreate(cTemp,aCampos)
//dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

uRet:= FWTemporaryTable():New( "TRB" )
uRet:SetFields( aCampos )
uRet:Create()

DbSelectArea("SUA")
set softseek on
dbsetorder(4)
Seek xFilial()+dtos(mv_par01)
set softseek off
Do while !eof()
	if sua->UA_EMISSAO>mv_par02 .or. sua->UA_CANC='S'
		skip
		loop
	endif
	cProduto := " "
	DbSelectArea("SUB")
	dbsetorder(1)
	Seek xFilial()+SUA->ua_num
	if eof()
		DbSelectArea("SUA")
		skip
		loop
	endif
	cProduto := ub_produto
	nquant   := 1
	nvalor   := 0
	cNumPV   := UB_NUMPV
	if left(ub_produto,7)<>' 000001'
		do while ub_num=sua->UA_NUM
			if sub->ub_tes <>'513'
				nQuant += sub->ub_quant
				nValor += sub->ub_vlritem
			endif
			skip
		enddo
		if nValor<>0
			cProduto := "VENDA"
		endif
	else
		if left(ub_produto,7)=space(7)
			DbSelectArea("SUA")
			skip
			loop
		endif
	endif
	DbSelectArea("SB1")
	dbsetorder(1)
	Seek xFilial()+cProduto
	if cProduto="VENDA"
		cDescr :="VENDA"
	else
		cDescr := sb1->b1_desc
	endif
	DbSelectArea("SA3")
	dbsetorder(1)
	Seek xFilial()+sua->UA_VEND
	DbSelectArea("SYP")
	dbsetorder(1)
	Seek xFilial()+sua->UA_CODOBS
	cObs := ""
	Do while !eof() .and. yp_chave = sua->UA_CODOBS
		cObs += STRTRAN(trim(yp_texto), ';', '')
		skip
	enddo
	Select SA1
	seek xFilial()+sua->(UA_CLIENTE+UA_LOJA)
	Select Trb
	RecLock("trb",.t.)
	trb->UB_NUM 	:= sua->UA_NUM
	//	trb->UB_PRODUTO := cProduto
	trb->descri 	:= cDescr
	trb->UB_QUANT 	:= nQuant
	trb->UB_VLRITEM := nValor
	trb->UB_NUMPV 	:= cNumPV
	trb->Emissao 	:= dtoc(sua->UA_EMISSAO)
	trb->Obs 		:= NoAcento(cObs)
	trb->Cliente 	:= sua->UA_CLIENTE
	trb->Loja 		:= sua->UA_LOJA
	trb->Grupo	 	:= sa1->a1_xgrpcli
	trb->Operador 	:= sua->UA_OPERADO
	trb->Vendedor 	:= sua->UA_VEND
	trb->Coordenad 	:= sa3->a3_super
	trb->Tipo 		:= sua->UA_SETOR
	MsUnLock()
	Select SUA
	skip
Enddo

Select Trb

//Cria o arquivo CSV
//cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	:= "c:\temp\Atendimentos_" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
AADD(aCabec,{ "Atendimento"     , "C","UB_NUM"})
//AADD(aCabec,{ "Codigo"		    , "C","UB_PRODUTO"})
AADD(aCabec,{ "Descricao"   	, "C","DESCRI"})
AADD(aCabec,{ "Quantidade"		, "N","UB_QUANT"})
AADD(aCabec,{ "Valor Total"	    , "N","UB_VLRITEM"})
AADD(aCabec,{ "Num.Pedido"     	, "C","UB_NUMPV"})
AADD(aCabec,{ "Data Emissao"  	, "C","Emissao"})
AADD(aCabec,{ "Observacao" 		, "C","Obs"})
AADD(aCabec,{ "Cliente"			, "C",'Cliente'})
AADD(aCabec,{ "Loja"     		, "C",'Loja'})
AADD(aCabec,{ "Grupo Cliente"	, "C",'Grupo'})
AADD(aCabec,{ "Operador"     	, "C",'Operador'})
AADD(aCabec,{ "Vendedor"     	, "C",'Vendedor'})
AADD(aCabec,{ "Coordenador"    	, "C",'Coordenad'})
AADD(aCabec,{ "Tipo"     		, "C",'Tipo'})

For i := 1 To Len(aCabec)
	cLinhaCSV += aCabec[i,1] + ";"
Next i
FWrite(nHdl,cLinhaCSV+ENTER)

Select Trb
dbgotop()
ProcRegua(reccount())

//Geracao do arquivo CSV
While TRB->(!Eof())
	IncProc()
	cLinhaCSV := ""
	
	For i := 1 To Len(aCabec)
		If aCabec[i,2] == "C"
			cLinhaCSV += TRB->&(aCabec[i,3])+";"
		ElseIf aCabec[i,2] == "D"
			cLinhaCSV += DToC(SToD(TRB->&(aCabec[i,3])))+";"
		ElseIf aCabec[i,2] == "N"
			cLinhaCSV += Transform(TRB->&(aCabec[i,3]),"@E 999,999,999.99")+";"
		EndIf
	Next i
	
	FWrite(nHdl,cLinhaCSV+ENTER)
	TRB->(dbSkip())
EndDo

FClose(nHdl)
oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cFile)
oExcel:SetVisible(.T.)

dbSelectArea("TRB")
DBCLOSEAREA()

RestArea(aAreaSM0)

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
static function ajustaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

putSx1( cPerg, "01", "Data inicial"  ,".",".","mv_ch1","D",08,0,2,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,,"")
putSx1( cPerg, "02", "Data final"    ,".",".","mv_ch2","D",08,0,2,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,,"")

return


static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
Local cMaior := "&lt;:"
Local cMenor := "&gt;:"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString
	cString := strTran( cString, cMaior, "" )
EndIf
If cMenor$ cString
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|'
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
Return cString
