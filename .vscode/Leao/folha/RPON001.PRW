#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

User Function RPON001()        // Rela‡ao Horas Abonadas


// Relatorio em desenvolvimento
// - calcular o numero de dias trabalhados para afastados
// - veificar total h.extra e faltas
// - calc. qtde efetiva de horas trabalhadas

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

cPerg    := "RPON001"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Data de                                         ³
//³ mv_par02  // Data ate                                        ³
//³ mv_par03  // Matric. de                                      ³
//³ mv_par04  // Matric. ate                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg,.t.)

aAdd( aD, "Este programa permite exportar para excel um resumo das horas trabalhadas " )
aAdd( aD, "" )

ajustaSX1(cPerg)
pergunte(cPerg,.F.)

aAdd( aB, {5,.T.,{|| pergunte(cPerg,.T.) }} )
aAdd( aB, {1,.T.,{|| lC := .T., fechaBatch() }} )
aAdd( aB, {2,.T.,{|| fechaBatch() }} )

formBatch( "Resumo de Horas", aD, aB )

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
AADD(aCampos,{ "MAT"	     	, "C",06,0})
AADD(aCampos,{ "NOME"	     	, "C",40,0})
AADD(aCampos,{ "CC"		     	, "C",06,0})
AADD(aCampos,{ "DTEVENTO"     	, "C",10,0})
AADD(aCampos,{ "DESCCC"	     	, "C",20,0})
AADD(aCampos,{ "HORASTRAB"   	, "N",12,2})
AADD(aCampos,{ "HORASNAOTR"   	, "N",12,2})
AADD(aCampos,{ "HORASABO"	    , "N",12,2})
AADD(aCampos,{ "HEXTRAS"   		, "N",12,2})
//AADD(aCampos,{ "DESCRICAO"     	, "C",20,0})
//AADD(aCampos,{ "MOTIVO"	     	, "C",20,0})

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa( {|| Monta() } )

GeraExcel()

*-------------------------*
Static Function Monta()
*-------------------------*
cFecMes := GetMv("MV_PONMES")
Select SRA
dbSetOrder(1)
ProcRegua(reccount())
dbGoTop()
Do while !eof()
	IncProc("Aguarde a montagem do arquivo")

	if (ra_demissa<mv_par01 .and. ra_demissa<>ctod("0")) .or. ra_admissa>mv_par02
		skip
		loop
	endif
	if ra_mat<mv_par03 .or. ra_mat>mv_par04
		skip
		loop
	endif
	dData := MV_PAR01
	Do while !eof() .and. dData <= mv_par02
		nHoras := nDescto := nAbono := nHExtra := 0
		Select SP8
		dbSetOrder(2)
		seek xFilial()+sra->RA_MAT+dtos(dData)
		Select SPC
		dbSetOrder(2)
		seek xFilial()+sra->RA_MAT+dtos(dData)
		do while !eof()
			if spc->PC_PD = '408' .or. spc->PC_PD = '447'  // Faltas per Anterior / DSR
				skip
				loop
			endif
			exit
		enddo
		if ()sp8->P8_MAT = sra->RA_MAT .or. spc->Pc_MAT = sra->RA_MAT) .and. SPC->PC_DATA = dData // Verifica se foi dia trabalhado
			nHoras := 8+(35/60)
			if spc->Pc_MAT = sra->RA_MAT .and. PC_Data = dData
				nDescto := int(PC_QUANTC)+((PC_QUANTC-int(PC_QUANTC))*100/60)
				if spc->pc_pd$'206*208'
					nHExtra	:= int(PC_QTABONO)+((PC_QTABONO-int(PC_QTABONO))*100/60)
					IF nhextra=0
						nHExtra	:= int(PC_QUANTC)+((PC_QUANTC-int(PC_QUANTC))*100/60)
					Endif
				else
					nAbono	:= int(PC_QTABONO)+((PC_QTABONO-int(PC_QTABONO))*100/60)
				endif
			endif
		endif
		Select CTT
		seek xFilial()+Sra->RA_CC
		// Grava Temporario
		Select Trb
		if (nHoras<>0 .or. nDescto<>0 .or. nHextra<>0) .AND. !EMPTY(ctt->Ctt_Desc05)
			RecLock("Trb",.t.)
			trb->Mat 		:= Sra->RA_MAT
			trb->Nome		:= Sra->RA_Nome
			trb->CC			:= Sra->RA_CC
			trb->DTEVENTO 	:= dtoc(dData)
			trb->DESCCC		:= ctt->Ctt_Desc05
			trb->HORASTRAB  := nHoras
			trb->HORASnaoTR := nDescto
			trb->HORASabo	:= nAbono
			trb->HEXTRAS	:= nHextra
			MsUnLock()
		endif
		
		dData++
	Enddo
	Select SRA
	skip
Enddo

Select Trb
cTemp1 := CriaTrab(nil,.f.)
copy structure to &cTemp1
dbUseArea( .T.,,cTemp1,"TRB1", Nil, .F. )

Select TRB
cTemp := CriaTrab(nil,.f.)
//Index on DescCC to &cTemp
IndRegua("TRB", cTemp, "DescCC", , , "Selecionando Registros...")

dbGoTop()
Do while !eof()
	cDescCC := trb->DESCCC
	nHoras := nDescto := 0
	Do while !eof() .and. cDescCC = DESCCC
		nHoras 	+= trb->HORASTRAB
		nDescto += trb->HORASnaoTR
		nHextra += trb->HExtras
		skip
	Enddo
	Select TRB1
	RecLock("Trb1",.t.)
	trb1->DESCCC	 := cDescCC
	trb1->HORASTRAB  := nHoras
	trb1->HORASnaoTR := nDescto
	trb1->HORASABO   := nHoras-nDescto
	trb1->HEXTRAS	 := nHextra
	MsUnLock()
	Select TRB
Enddo

*-------------------------*
Static Function GeraExcel()
*-------------------------*

Select Trb

//Cria o arquivo CSV
//cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
//cFile 	:= "c:\temp\HorasTrab_" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
cFile 	:= "c:\temp\HorasTrab_" + DtoS(mv_par01) + "_" + DtoS(mv_par02) + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho


AADD(aCabec,{ "Data"   			, "C","DTEVENTO"})
AADD(aCabec,{ "Matricula"   	, "C","MAT"})
AADD(aCabec,{ "Nome"		   	, "C","NOME"})
AADD(aCabec,{ "CCustos"     	, "C","CC"})
AADD(aCabec,{ "Desc_CCustos"  	, "C","DESCCC"})
AADD(aCabec,{ "Horas_Trab"		, "N","HORASTRAB"})
AADD(aCabec,{ "Horas_Nao_Trab"	, "N","HORASNAOTR"})
AADD(aCabec,{ "Horas_Extras" 	, "N","HEXTRAS"})
//AADD(aCabec,{ "Horas Abonadas" 	, "N","HORASABO"})

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


// Resumo
nHdl		:= 0
i			:= 0
cFile		:= ""
oExcel		:= Nil  
aCabec		:= {} 
cLinhaCSV	:= ""



Select Trb1
dbgotop()

//Cria o arquivo CSV
//cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	:= "c:\temp\Resumo_HorasTrab_" + DtoS(mv_par01) + "_" + DtoS(mv_par02) + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho

AADD(aCabec,{ "Desc_CCustos"  		, "C","DESCCC"})
AADD(aCabec,{ "Horas_Totais"		, "N","HORASTRAB"})
AADD(aCabec,{ "Horas_Nao_Trab"		, "N","HORASNAOTR"})
AADD(aCabec,{ "Horas_Trabalhadas"	, "N","HORASABO"})
AADD(aCabec,{ "Horas_Extras" 		, "N","HEXTRAS"})
For i := 1 To Len(aCabec)
	cLinhaCSV += aCabec[i,1] + ";"
Next i
FWrite(nHdl,cLinhaCSV+ENTER)

Select Trb1
dbgotop()
ProcRegua(reccount())

//Geracao do arquivo CSV
While TRB1->(!Eof())
	IncProc()
	cLinhaCSV := ""
	
	For i := 1 To Len(aCabec)
		If aCabec[i,2] == "C"
			cLinhaCSV += TRB1->&(aCabec[i,3])+";"
		ElseIf aCabec[i,2] == "D"
			cLinhaCSV += DToC(SToD(TRB1->&(aCabec[i,3])))+";"
		ElseIf aCabec[i,2] == "N"
			cLinhaCSV += Transform(TRB1->&(aCabec[i,3]),"@E 999,999,999.99")+";"
		EndIf
	Next i
	
	FWrite(nHdl,cLinhaCSV+ENTER)
	TRB1->(dbSkip())
EndDo

FClose(nHdl)
oExcel := MSExcel():New()
//oExcel:AddSheet("Nova Sheet") 
oExcel:WorkBooks:Open(cFile)
oExcel:SetVisible(.T.)

dbSelectArea("TRB1")
DBCLOSEAREA()

RestArea(aAreaSM0)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
static function ajustaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

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
