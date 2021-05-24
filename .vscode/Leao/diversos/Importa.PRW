#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImporta   บAutor  ณLuiz Eduardo        บ Data ณ  18/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo das estruturas e compara็ใo com o protheus      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Irineu                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function Importa(cArqE,cOrigemE,nLinTitE,lTela)

Local bOk        := {||lOk:=.T.,oDlg:End()}
Local bCancel    := {||lOk:=.F.,oDlg:End()}
Local lOk        := .F.
Local nLin       := 20
Local nCol1      := 15
Local nCol2      := nCol1+30
Local cMsg       := ""
Local oDlg
Local oArq
Local oOrigem
Local oMacro
Local aButtons := {}
Local _aStru	:= {}

Default lTela := .T.

Private cArq       	:= ""//If(ValType(cArqE)=="C",cArqE,"")
Private cArqMacro  	:= "XLS2DBF.XLA"
Private _cTemp   	:= GetTempPath() //pega caminho do temp do client
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private aArquivos  := {}
Private aRet       := {}
Private lUsr	   := .f.


Static lSair := .t.
Static _nRegistro := 0


IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF

// Formato do Arquivo deve ser :
// Bco;Bco1;Bco2;Cod;Comp;Desc ;Um;Quant;Perda;ScIcmsIpi;vScIcmsIpi;Bco3;SsIcmsIpi;vSsIcmsIpi;Bco4;SsIcmcIpi;vSsIcmcIpi;Bco5;ScIcmcIpi;vScIcmcIpi;Bco6;Bco7;Bco8;Bco9;Bco10;Bco11;Bco12;Bco13;Bco14;Bco15;Bco16;Bco17;Bco18;Bco19;Bco20;Bco21;Bco22;Bco23;Bco24;Bco25;Bco26;Bco27;Bco28;Bco29;Bco30;Bco31;Bco32;Bco33

cArq       += Space(20-(Len(cArq)))
cOrigem    += Space(99-(Len(cOrigem)))

aAdd(aButtons,{"RELATORIO",{|| fXGetArq() },"Arquivos"})

If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))
	
	if !lSair
		Return
	endif
	
	Define MsDialog oDlg Title 'Integra็ใo de Excel' From 7,10 To 20,50 OF oMainWnd
	
	
	nLin -= 12
	@ nLin,nCol1  Say      'Estrutura excel deve ter colunas conforme acordado entre os departamentos'  Of oDlg Pixel
	nLin += 12
	
	@ nLin,nCol1  Say      'Arquivo :'                                Of oDlg Pixel
	@ nLin,nCol2  MsGet    oArq   Var cArq            Size 60,09 Of oDlg Pixel
	
	nLin += 15
	
	@ nLin,nCol1  Say      'Caminho do arquivo :'                     Of oDlg Pixel
	nLin += 10
	@ nLin,nCol1  MsGet    oOrigem Var cOrigem            Size 130,09 Of oDlg Pixel
	
	nLin += 15
	
	//	@ nLin,nCol1  Say      'Nome da Macro :'                          Of oDlg Pixel
	//	nLin += 10
	//	@ nLin,nCol1  MsGet    oMacro  Var cArqMacro When .F. Size 130,09 Of oDlg Pixel
	
	
	Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel,.F.,aButtons) Centered
	
Else
	lOk := .T.
EndIf

If lOk
	cMsg := validaCpos()
	aAdd(aArquivos, cArq)
	If	Empty(cMsg)
		LjMsgRun(OemToAnsi("importando Excel. Por favor aguarde!"),,{||fIntArq()} )
	Else
		MsgStop(cMSg)
		Return
	EndIf
EndIf

// Grava็ใo dos dados da Planilha
IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF
if file(_cTemp+".dtc") .or. file(_cTemp+".dbf")
	dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)  // Reabre arquivo temporแrio
else
	Return
endif

Processa( {|| aRet:= GravaArq() } ,"Aguarde, gravando registros ... ")  // TESTAR UTILIZAวรO GRAVAARQ1 OU TESTE OU GERA1
ConOut("Terminou grava็ใo do arquivo SN3 -"+Time())

Return


*-------------------------*
Static Function validaCpos()
*-------------------------*
Local cMsg := ""

If Empty(cArq)
	cMsg += "Campo Arquivo deve ser preenchido!"+ENTER
EndIf

If Empty(cOrigem)
	cMsg += "Campo Caminho do arquivo deve ser preenchido!"+ENTER
EndIf

If Empty(cArqMacro)
	cMsg += "Campo Nome da Macro deve ser preenchido!"
EndIf


Return cMsg


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIntArq   บAutor  ณLuiz Eduardo        บ Data ณ 02/03/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma das rotinas referentes a integra็ใo                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 					                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fIntArq()
Local lConv     := .F.
Local lCabcOK	:= .F.
local cCliAnt	:= ""
local aCabec	:= {}
Local aItens	:= {}
local aLinha	:= {}
Local nItem		:= 0
local lErrPrd	:= .F.
Local lPrim		:= .T.
Local cAntPedC	:= ""
Private cDescErr:= ""
Private lErro	:= .F.
Private lMsErroAuto	:= .F.
Private lDescErr:= .F.
Private cBrwMsg	:= ""
Private nProc	:= 0


// Cria e Abre arquivo temporแrio
_aStru := {}

//aadd( _aStru , {'Bco00'     , 'C' , 20 , 00 } )
//aadd( _aStru , {'Bco01'     , 'C' , 20 , 00 } )
//aadd( _aStru , {'Bco02'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Cod'     		, 'C' , 20 , 00 } )
aadd( _aStru , {'Comp'     		, 'C' , 20 , 00 } )
aadd( _aStru , {'Desc'     	, 'C' , 20 , 00 } )
aadd( _aStru , {'Um'     		, 'C' , 10 , 00 } )
aadd( _aStru , {'Quant'     	, 'N' , 15 , 08 } )
aadd( _aStru , {'Perda'     	, 'N' , 10 , 00 } )
aadd( _aStru , {'ScIcmsIpi'     , 'N' , 14 , 04 } )
aadd( _aStru , {'vScIcmsIpi'    , 'N' , 14 , 04 } )
aadd( _aStru , {'Bco03'     	, 'C' , 02 , 00 } )
aadd( _aStru , {'SsIcmsIpi'     , 'N' , 14 , 04 } )
aadd( _aStru , {'vSsIcmsIpi'    , 'N' , 14 , 04 } )
aadd( _aStru , {'Bco04'     	, 'C' , 02 , 00 } )
aadd( _aStru , {'SsIcmcIpi'     , 'N' , 14 , 04 } )
aadd( _aStru , {'vSsIcmcIpi'    , 'N' , 14 , 04 } )
aadd( _aStru , {'Bco05'     	, 'C' , 02 , 00 } )
aadd( _aStru , {'ScIcmcIpi'     , 'N' , 14 , 04 } )
aadd( _aStru , {'vScIcmcIpi'    , 'N' , 14 , 04 } )
aadd( _aStru , {'Bco06'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco07'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco08'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco09'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco10'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco11'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco12'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco13'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco14'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco15'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco16'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco17'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco18'     , 'C' , 20 , 00 } )
aadd( _aStru , {'Bco19'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim01'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim02'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim03'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim04'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim05'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim06'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim07'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim08'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim09'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim10'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim11'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim12'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim13'     , 'C' , 20 , 00 } )
aadd( _aStru , {'sim14'     , 'C' , 20 , 00 } )


_cTemp := CriaTrab(_aStru, .T.)
dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
//Index on Produto to _cTemp


//converte arquivos xls para csv copiando para a pasta temp
//MsAguarde( {|| ConOut("Come็ou conversใo do arquivo "+cArq+ " - "+Time()),;
//lConv := fXconvArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
If lConv .or. 1=1
	//carrega do xls no array
	ConOut("Terminou conversใo do arquivo "+cArq+ " - "+Time())
	ConOut("Come็ou carregamento do arquivo "+cArq+ " - "+Time())
	Processa( {|| aRet:= XCargaArray(AllTrim(cArq)) } ,;
	"Aguarde, carregando planilha... Pode demorar")
	ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
	
//	cBco00:= ASCAN(aRet[2,1],'Bco00')
//	cBco01:= ASCAN(aRet[2,1],'Bco01')
//	cBco02:= ASCAN(aRet[2,1],'Bco02')
	cCod:= ASCAN(aRet[2,1],'Cod')
	cComp:= ASCAN(aRet[2,1],'Comp')
	cDesc := ASCAN(aRet[2,1],'Desc')
	cUm:= ASCAN(aRet[2,1],'Um')
	cQuant:= ASCAN(aRet[2,1],'Quant')
	cPerda:= ASCAN(aRet[2,1],'Perda')
	cScIcmsIpi:= ASCAN(aRet[2,1],'ScIcmsIpi')
	cvScIcmsIpi:= ASCAN(aRet[2,1],'vScIcmsIpi')
	cBco03:= ASCAN(aRet[2,1],'Bco03')
	cSsIcmsIpi:= ASCAN(aRet[2,1],'SsIcmsIpi')
	cvSsIcmsIpi:= ASCAN(aRet[2,1],'vSsIcmsIpi')
	cBco04:= ASCAN(aRet[2,1],'Bco04')
	cSsIcmcIpi:= ASCAN(aRet[2,1],'SsIcmcIpi')
	cvSsIcmcIpi:= ASCAN(aRet[2,1],'vSsIcmcIpi')
	cBco05:= ASCAN(aRet[2,1],'Bco05')
	cScIcmcIpi:= ASCAN(aRet[2,1],'ScIcmcIpi')
	cvScIcmcIpi:= ASCAN(aRet[2,1],'vScIcmcIpi')
	cBco06:= ASCAN(aRet[2,1],'Bco06')
	cBco07:= ASCAN(aRet[2,1],'Bco07')
	cBco08:= ASCAN(aRet[2,1],'Bco08')
	cBco09:= ASCAN(aRet[2,1],'Bco09')
	cBco10:= ASCAN(aRet[2,1],'Bco10')
	cBco11:= ASCAN(aRet[2,1],'Bco11')
	cBco12:= ASCAN(aRet[2,1],'Bco12')
	cBco13:= ASCAN(aRet[2,1],'Bco13')
	cBco14:= ASCAN(aRet[2,1],'Bco14')
	cBco15:= ASCAN(aRet[2,1],'Bco15')
	cBco16:= ASCAN(aRet[2,1],'Bco16')
	cBco17:= ASCAN(aRet[2,1],'Bco17')
	cBco18:= ASCAN(aRet[2,1],'Bco18')
	cBco19:= ASCAN(aRet[2,1],'Bco19')
	cBco20:= ASCAN(aRet[2,1],'sim01')
	cBco21:= ASCAN(aRet[2,1],'sim02')
	cBco22:= ASCAN(aRet[2,1],'sim03')
	cBco23:= ASCAN(aRet[2,1],'sim04')
	cBco24:= ASCAN(aRet[2,1],'sim05')
	cBco25:= ASCAN(aRet[2,1],'sim06')
	cBco26:= ASCAN(aRet[2,1],'sim07')
	cBco27:= ASCAN(aRet[2,1],'sim08')
	cBco28:= ASCAN(aRet[2,1],'sim09')
	cBco29:= ASCAN(aRet[2,1],'sim10')
	cBco30:= ASCAN(aRet[2,1],'sim11')
	cBco31:= ASCAN(aRet[2,1],'sim12')
	cBco32:= ASCAN(aRet[2,1],'sim13')
	cBco33:= ASCAN(aRet[2,1],'sim14')
	
	dbSelectArea("TMP")
	For _nR:= 1 to len(aRet[1])         
		nQuant:= nPerda := cScIcmsIpi := cvScIcmsIpi := cSsIcmsIpi := cvSsIcmsIpi := cvSsIcmcIpi := cSsIcmcIpi := cScIcmcIpi := cvScIcmcIpi :=0
/*		if val(aRet[1,_nR,cPerda])<> 0
			nPerda:= val(aRet[1,_nR,cPerda])+val(substr(aRet[1,_nR,cPerda],at(",",aRet[1,_nR,cPerda])+1,2))/100
		endif                                   
		if val(aRet[1,_nR,cScIcmsIpi])<>0
			nScIcmsIpi:= val(aRet[1,_nR,cScIcmsIpi])+val(substr(aRet[1,_nR,cScIcmsIpi],at(",",aRet[1,_nR,cScIcmsIpi])+1,2))/100
		endif                                     
		if val(aRet[1,_nR,cvScIcmsIpi])<>0
		nvScIcmsIpi:= val(aRet[1,_nR,cvScIcmsIpi])+val(substr(aRet[1,_nR,cvScIcmsIpi],at(",",aRet[1,_nR,cvScIcmsIpi])+1,2))/100
		endif
		if val(aRet[1,_nR,cSsIcmsIpi])<>0
		nSsIcmsIpi:= val(aRet[1,_nR,cSsIcmsIpi])+val(substr(aRet[1,_nR,cSsIcmsIpi],at(",",aRet[1,_nR,cSsIcmsIpi])+1,2))/100
		endif
		if val(aRet[1,_nR,cvSsIcmsIpi])<>0
		nvSsIcmsIpi:= val(aRet[1,_nR,cvSsIcmsIpi])+val(substr(aRet[1,_nR,cvSsIcmsIpi],at(",",aRet[1,_nR,cvSsIcmsIpi])+1,2))/100
		endif
		if val(aRet[1,_nR,cSsIcmcIpi])<>0
		nSsIcmcIpi:= val(aRet[1,_nR,cSsIcmcIpi])+val(substr(aRet[1,_nR,cSsIcmcIpi],at(",",aRet[1,_nR,cSsIcmcIpi])+1,2))/100
		endif
		if val(aRet[1,_nR,cvSsIcmcIpi])<>0
		nvSsIcmcIpi:= val(aRet[1,_nR,cvSsIcmcIpi])+val(substr(aRet[1,_nR,cvSsIcmcIpi],at(",",aRet[1,_nR,cvSsIcmcIpi])+1,2))/100
		endif
		if val(aRet[1,_nR,cScIcmcIpi])<>0
		nScIcmcIpi:= val(aRet[1,_nR,cScIcmcIpi])+val(substr(aRet[1,_nR,cScIcmcIpi],at(",",aRet[1,_nR,cScIcmcIpi])+1,2))/100
		endif
		if val(aRet[1,_nR,cvScIcmcIpi])<>0
		nvScIcmcIpi:= val(aRet[1,_nR,cvScIcmcIpi])+val(substr(aRet[1,_nR,cvScIcmcIpi],at(",",aRet[1,_nR,cvScIcmcIpi])+1,2))/100
		endif
*/
		cCod1:= aRet[1,_nR,cCod]
		cComp1 := iif(empty(aRet[1,_nR,cComp]),".",aRet[1,_nR,cComp])
		if at(".",cComp1)=0
			if val(cComp1)>=0 .and. val(cComp1)<10000
				cComp1 := left(cComp1,1)+"."+substr(cComp1,2,4)
			elseif val(cComp1)>=10000 .and. val(cComp1)<100000
				cComp1 := left(cComp1,2)+"."+substr(cComp1,3,4)
			endif
		endif
		dbSelectArea("SB1")
		seek xFilial()+cCod1
		if eof()
			if left(cCod1,2)='12'.and. at(".",cCod1)=0
				cCod1 := left(cCod1,2)+"."+substr(cCod1,3,10)
			else
				cCod1 := trim(cCod1)+"Nao Encontrado"
			endif
		endif
		dbSelectArea("TMP")                                                                                                     
		if left(cComp1,1)>='0' .and. left(cComp1,1)<='9' .and. left(cComp1,3)<>'0. ' // .and. trim(sb1->b1_cod)=trim(cComp)		
//		if left(trim(aRet[1,_nR,cComp]),1)>='0' .and. left(trim(aRet[1,_nR,cComp]),1)<='9'// .and. trim(sb1->b1_cod)=trim(cComp)

		if val(aRet[1,_nR,cQuant])<>0 .or. at(",",aRet[1,_nR,cQuant])<>0
			nInt  	:= val(aRet[1,_nR,cQuant])
			nLen 	:= len(aRet[1,_nR,cQuant])
			nAt  	:= at(",",aRet[1,_nR,cQuant])
			nMilhar := "1"+replicate("0",nLen-nAt)
			ndeci 	:= val(substr(aRet[1,_nR,cQuant],at(",",aRet[1,_nR,cQuant])+1,8))-nInt
			nQuant	:= if(nDeci>=0,nint+(ndeci/val(nMilhar)),nInt)
		endif                           
		if val(aRet[1,_nR,cPerda])<> 0 .or. at(",",aRet[1,_nR,cPerda])<>0
			nPerda:= val(aRet[1,_nR,cPerda])+iif(at(",",aRet[1,_nR,cPerda])<>0,val(substr(aRet[1,_nR,cPerda],at(",",aRet[1,_nR,cPerda])+1,4))/1000,0)
		endif                                   

		RecLock("TMP",.T.)
//		tmp->Bco00:= aRet[1,_nR,cBco00]
//		tmp->Bco01:= aRet[1,_nR,cBco01]
//		tmp->Bco02:= aRet[1,_nR,cBco02]
		tmp->Cod:= cCod1
		tmp->Comp:= cComp1
		tmp->Desc := aRet[1,_nR,cDesc]
		tmp->Um:= aRet[1,_nR,cUm]
		tmp->Quant:= nQuant
		tmp->Perda:= nPerda
/*		tmp->ScIcmsIpi:= nScIcmsIpi
		tmp->vScIcmsIpi:= nvScIcmsIpi
		tmp->SsIcmsIpi:= nSsIcmsIpi
		tmp->vSsIcmsIpi:= nvSsIcmsIpi
		tmp->SsIcmcIpi:= nSsIcmcIpi
		tmp->vSsIcmcIpi:= nvSsIcmcIpi
		tmp->ScIcmcIpi:= nScIcmcIpi
		tmp->vScIcmcIpi:= nvScIcmcIpi  
		*/
		MsUnLock()
		Endif
	Next _nR
	
EndIf
Select tmp
copy to \x

Return

/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parโmetros  : cArq - nome do arquivo que serแ usado
Autor       : Kanaใm L. R. Rodrigues
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function XCargaArray(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 1
Local nTotLin := 0
Local aDados  := {}
//Local cFile   := cTemp + cArq + ".csv"
Local cFile   := cOrigem + cArq + ".csv"
Local nHandle := 0
Local aCabecM	:= {}


//abre o arquivo csv gerado na temp
nHandle := Ft_Fuse(cFile)
If nHandle == -1
	Return aDados
EndIf
Ft_FGoTop()
nLinTot := FT_FLastRec()-1
ProcRegua(nLinTot)
//Pula as linhas de cabe็alho
/*
While nLinTit > 0 .AND. !Ft_FEof()
Ft_FSkip()
nLinTit--
EndDo
*/
cLinha := Ft_FReadLn()    //transforma as aspas duplas em aspas simples
cLinha := StrTran(cLinha,'"',"'")
cLinha := '{"'+cLinha+'"}'
//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
cLinha := StrTran(cLinha,';','","')
aAdd(aCabecM, &cLinha)
For _nREG:= 1 To Len(aCabecM[1])
	aCabecM[1,_nREG]:=Alltrim(aCabecM[1,_nREG])
Next _nREG
Ft_FSkip()
//percorre todas linhas do arquivo csv
Do While !Ft_FEof()
	//exibe a linha a ser lida
	IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
	nLin++
	//le a linha
	cLinha := Ft_FReadLn()
	//verifica se a linha estแ em branco, se estiver pula
	If Empty(AllTrim(StrTran(cLinha,';','')))
		Ft_FSkip()
		Loop
	EndIf
	//transforma as aspas duplas em aspas simples
	
	cLinha := StrTran(cLinha,'"',"'")
	
	If substr(cLinha,1,1)==";"
		Exit
	Endif
	cLinha := '{"'+cLinha+'"}'
	//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
	cLinha := StrTran(cLinha,';','","')
	aAdd(aDados, &cLinha)
	
	//passa para a pr๓xima linha
	FT_FSkip()
	//
EndDo

//libera o arquivo CSV
FT_FUse()

//Exclui o arquivo csv
If File(cFile)
	//	FErase(cFile)
EndIf

Return {aDados,aCabecM}

//------------------------
Static Function GravaArq()
//------------------------
Local nReg
//Local aArea

// Cria e Abre arquivo temporแrio
_aStru := {}
aadd( _aStru , {'Cod'     		, 'C' , 20 , 00 } )
aadd( _aStru , {'Comp'     		, 'C' , 20 , 00 } )
aadd( _aStru , {'Desc'     	, 'C' , 20 , 00 } )
aadd( _aStru , {'Um'     		, 'C' , 10 , 00 } )
aadd( _aStru , {'Quant'     	, 'N' , 15 , 08 } )


_cErr := CriaTrab(_aStru, .T.)
dbUseArea(.T.,__LocalDriver,_cErr,"ERR",.F.)

Select Tmp
do while !eof()
	cCod := trim(tmp->cod)
	Select SG1
	seek xFilial()+trim(tmp->cod)
	if !eof()
		do while !eof() .and. trim(tmp->cod)==trim(sg1->g1_cod)
			Reclock("SG1",.f.)
			delete
			MsUnLock()
			skip
		enddo
	endif
	Select Tmp
	Do while !eof() .and. cCod = trim(tmp->cod)
		Select SB1
		seek xFilial()+	tmp->Comp
		if eof()
			Select Err
			RecLock("ERR",.t.)
			err->Cod	:= tmp->Cod
			err->Comp	:= tmp->Comp
			MsUnLock()
			Select Tmp
			skip
		endif
		Select SB1
		seek xFilial()+	tmp->Cod
		if eof()
			Select Err
			RecLock("ERR",.t.)
			err->Cod	:= tmp->Cod
			err->Comp	:= tmp->Comp
			MsUnLock()
			Select Tmp
			skip
		endif
		
		Select SG1
		RecLock("SG1",.t.)
		SG1->G1_FILIAL	:= 	xFilial()
		SG1->G1_COD		:= tmp->Cod
		SG1->G1_COMP	:= tmp->Comp
		SG1->G1_QUANT	:= tmp->Quant
		SG1->G1_PERDA	:= tmp->Perda
		SG1->G1_INI		:= date()
		SG1->G1_FIM		:= date()+20000
		SG1->G1_NIV		:= "01"
		SG1->G1_NIVINV	:= "99"
		MsUnLock()
		Select Tmp
		skip
	Enddo
Enddo
Select Err
copy to \erro_imp
use

//RestArea(aArea)

Return


Static Function fXGetArq()

Local cMask		:="*.*"
Local cArqAt   	:= cGetFile(cMask, '')
Local cFileEDI	:= RIGHT(cArqAt,  LEN(cArqAt) -RAT("\", cArqAt))
Local cCamEDI	:= left(cArqAt,RAT("\", cArqAt))
cFileEDI:=LEFT(cFileEDI,  RAT(".", cFileEDI)-1)
cArq:=cFileEDI
cOrigem:=cCamEDI

Return cFileEDI

