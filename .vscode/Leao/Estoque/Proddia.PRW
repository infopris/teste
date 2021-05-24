#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Atendimento  ºAutor  ³Luiz Eduardo     º Data ³  21/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para geração do relatório de produção no dia          ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Leao                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Proddia()

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

aAdd( aD, "Este programa permite exportar para excel a produção do dia " )
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
AADD(aCampos,{ "COD"        , "C",15,0})
AADD(aCampos,{ "QUANT"   	, "N",12,2})
AADD(aCampos,{ "Emissao" 	, "C",10,0})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on EMISSAO+COD to &cTemp

DbSelectArea("SD3")
dbsetorder(6)
Set SoftSeek On
Seek xFilial()+dtos(mv_par01)
Set SoftSeek Off
Do while !eof() .AND. d3_emissao <= mv_par02
	if d3_tm<>"001"
		skip
		loop
	endif
	cProduto := left(d3_cod,at(".",d3_cod)-1)
	Select TRB
	seek cProduto
	RecLock("TRB",eof())
	trb->COD 	:= cProduto
	trb->quant  += sd3->d3_quant
	trb->emissao:= dtoc(sd3->d3_emissao)
	MsUnLock()
	Select SD3
	skip	
Enddo

Select Trb

//Cria o arquivo CSV
//cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	:= "c:\temp\Producao_" + DtoS(mv_par01) + "_" + StrTran(Time(),":") + ".CSV"
nHdl	:= FCreate(cFile)

if !MsgBox ("Possui o Excel instalado?","Escolha","YESNO")
	Copy to \Producao
	MsgAlert("Arquivo Gerado \Producao.dbf")
    Return
endif

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
AADD(aCabec,{ "Produto"     , "C","COD"})
AADD(aCabec,{ "Quantidade"   	, "N","QUANT"})
AADD(aCabec,{ "Data Emissao"  	, "C","Emissao"})

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
