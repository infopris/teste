#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

#DEFINE ENTER chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          º Autor ³Luiz Eduardo        º Data ³  05/05/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funçao que realiza a importação da estruturas              º±±
±±º          ³ Arquivo xls                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParâmetros³ cArqE    - Nome do arquivo XLS a ser carregado             º±±
±±º          ³ cOrigemE - Local onde está o arquivo XLS                   º±±
±±º          ³ cOrigemE - Local onde está o arquivo XLS                   º±±
±±º          ³ nLinTitE - Quantas linhas de cabeçalho que não serão       º±±
±±º          ³ integradas possui o arquivo								  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function impestr(cArqE,cOrigemE,nLinTitE,lTela)

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

Private cArq       := If(ValType(cArqE)=="C",cArqE,"")
Private cArqMacro  := "XLS2DBF.XLA"
Private cTemp      := GetTempPath() //pega caminho do temp do client
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private aArquivos  := {}
Private aRet       := {}
Private cTipo      := ""

IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF
                                                   
cTipo := ""

@ 010,1 TO 100,550 DIALOG oDlg2 TITLE "Importar Arquivo"

@ 025,020 BUTTON "_Estruturas"  SIZE 40,15 ACTION EstrTmp() // COD/COMP/FATOR/PERDA
@ 025,065 BUTTON "_Margem"     	SIZE 40,15 ACTION MgTmp() // MARGEM / PERC/ VALOR
@ 025,110 BUTTON "_Custo Std" 	SIZE 40,15 ACTION StdTmp()
@ 025,200 BUTTON "_Sai" 		SIZE 40,15 ACTION Close(oDlg2)

ACTIVATE DIALOG oDlg2 CENTERED
if cTipo=""
	Return     
endif

//CriaTmp()

cArq       += Space(20-(Len(cArq)))
cOrigem    += Space(99-(Len(cOrigem)))

aAdd(aButtons,{"RELATORIO",{|| 	U_fGetArq() }		,"Arquivos"})

If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))
	
	Define MsDialog oDlg Title 'Integração de Excel' From 7,10 To 20,50 OF oMainWnd
	
	
	@ nLin,nCol1  Say      'Arquivo :'                                Of oDlg Pixel
	@ nLin,nCol2  MsGet    oArq   Var cArq            Size 60,09 Of oDlg Pixel
	
	nLin += 15
	
	@ nLin,nCol1  Say      'Caminho do arquivo :'                     Of oDlg Pixel
	nLin += 10
	@ nLin,nCol1  MsGet    oOrigem Var cOrigem            Size 130,09 Of oDlg Pixel
	
	nLin += 15
	
	@ nLin,nCol1  Say      'Nome da Macro :'                          Of oDlg Pixel
	nLin += 10
	@ nLin,nCol1  MsGet    oMacro  Var cArqMacro When .F. Size 130,09 Of oDlg Pixel
	
	Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel,.F.,aButtons) Centered
Else
	lOk := .T.
EndIf

If lOk
	cMsg := XvalidaCpos()
	aAdd(aArquivos, cArq)
	If	Empty(cMsg)
		LjMsgRun(OemToAnsi("importando Excel. Por favor aguarde!"),,{||fIntArq()} )
	Else
		MsgStop(cMSg)
		Return
	EndIf
EndIf

Processa({|| Imp() })

Select TMP
use

Return aRet


********************
Static Function Imp()
********************
Select Tmp
dbgotop()
ProcRegua(Reccount())
Do while !eof()
	IncProc("Processando Arquivo")
	Do Case
		Case cTipo = "1"
			Select SG1
			seek xFilial()+tmp->Cod
			if !eof()
				do while !eof() .and. tmp->cod==sg1->G1_COD
					if rlock()
						replace g1_filial with '02'
					endif
					seek xFilial()+tmp->Cod
				enddo
			endif
			Select Tmp
			cCod := tmp->Cod
			do while !eof() .and. cCod = tmp->Cod
				if at(".",tmp->Comp)=0
					if val(tmp->Comp)>9999
						cComp := left(tmp->Comp,2)+"."+substr(tmp->Comp,3,4)
					else
						cComp := left(tmp->Comp,1)+"."+substr(tmp->Comp,2,4)
					endif
				else
					cComp := tmp->Comp
				endif
				Select SB1
				seek xFilial()+cComp
				if !eof() //.and. 1=2
					nPos := at(",",tmp->Fator)
					nFator := left(tmp->Fator,nPos-1)+"."+substr(tmp->Fator,nPos+1,6)
					Select SG1
					Reclock("SG1",.t.)
					sg1->g1_filial	:= xFilial()
					sg1->g1_cod		:= cCod
					sg1->g1_comp	:= cComp
					sg1->g1_quant	:= val(nFator)
					sg1->g1_perda	:= val(tmp->Perda)
					sg1->g1_ini		:= date()
					sg1->g1_fim		:= date()+20000
					sg1->g1_niv		:= "01"
					sg1->g1_nivinv	:= "99"
					MsUnLock()
				endif
				Select Tmp
				skip
			Enddo
		Case cTipo="2"
			Select SB5
			seek xFilial()+tmp->Cod
			if !eof() .AND. RLOCK()
			     sb5->b5_codcli := TMP->VALOR
            endif                       
            Select Tmp
            skip
	Endcase
Enddo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ        
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±                                               
±±ºPrograma  ³fIntArq   ºAutor  ³Reginaldo G. Ribeiroº Data ³ 18/02/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa das rotinas referentes a integração                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±            
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//converte arquivos xls para csv copiando para a pasta temp
MsAguarde( {|| ConOut("Começou conversão do arquivo "+cArq+ " - "+Time()),;
lConv := fXconvArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
If lConv
	//carrega do xls no array
	ConOut("Terminou conversão do arquivo "+cArq+ " - "+Time())
	ConOut("Começou carregamento do arquivo "+cArq+ " - "+Time())
	Processa( {|| aRet:= XCargaArray(AllTrim(cArq)) } ,;
	"Aguarde, carregando planilha..."+ENTER+"Pode demorar")
	ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
	
	Do Case
		case cTipo='1'
			nPosPrd	:= ASCAN(aRet[2,1], "COD")
			nPosDesc	:= ASCAN(aRet[2,1], "COMP")
			nPosMont	:= ASCAN(aRet[2,1], "FATOR")
			nPosSld	:= ASCAN(aRet[2,1], "PERDA")
		case cTipo='2'
			nPosPrd	:= ASCAN(aRet[2,1], "COD")
			nPosDesc	:= ASCAN(aRet[2,1], "MARGEM")
			nPosMont	:= ASCAN(aRet[2,1], "VALOR")
	EndCase
	
	dbSelectArea("TMP")
	dbSetOrder(1)
	
	For _nR:= 1 to len(aRet[1])
		RecLock("TMP",.T.)
		Do Case
			case cTipo='1'
				TMP->COD := aRet[1,_nR,nPosPrd]
				TMP->COMP := aRet[1,_nR,nPosDesc]
				TMP->FATOR := aRet[1,_nR,nPosMont]
				TMP->PERDA := aRet[1,_nR,nPosSld]
			case cTipo='2'
				TMP->COD := aRet[1,_nR,nPosPrd]
				TMP->MARGEM := aRet[1,_nR,nPosDesc]
				TMP->VALOR := aRet[1,_nR,nPosMont]
		EndCase
		
		MsUnLock()
	Next _nR
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ        
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±                                               
±±ºPrograma  ³fconvArqs ºAutor  ³Reginaldo G. Ribeiroº Data ³ 18/02/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que converte os arquivos .xls para .csv            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±            
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fXconvArqs(aArqs)

Local oExcelApp
Local cNomeXLS  := ""
Local cFile     := ""
Local cExtensao := ""
Local i         := 1
Local j         := 1
Local aExtensao := {}

private cPar:= "savechanges:=False"

cOrigem := AllTrim(cOrigem)

//Verifica se o caminho termina com "\"
If !Right(cOrigem,1) $ "\"
   cOrigem := AllTrim(cOrigem)+"\"
EndIf


//loop em todos arquivos que serão convertidos
For i := 1 To Len(aArqs)      

   If !"." $ AllTrim(aArqs[i])
      //passa por aqui para verifica se a extensão do arquivo é .xls ou .xlsx
      aExtensao := Directory(cOrigem+AllTrim(aArqs[i])+".*")
      For j := 1 To Len(aExtensao)
         If "XLS" $ Upper(aExtensao[j][1])
            cExtensao := SubStr(aExtensao[j][1],Rat(".",aExtensao[j][1]),Len(aExtensao[j][1])+1-Rat(".",aExtensao[j][1]))
            Exit
         EndIf
      Next j
   EndIf
   //recebe o nome do arquivo corrente
   cNomeXLS := AllTrim(aArqs[i])
   cFile    := cOrigem+cNomeXLS+cExtensao
   
   If !File(cFile)
      MsgInfo("O arquivo "+cFile+" não foi encontrado!" ,"Arquivo")      
      Return .F.
   EndIf
     
   //verifica se existe o arquivo na pasta temporaria e apaga
   If File(cTemp+cNomeXLS+cExtensao)
      fErase(cTemp+cNomeXLS+cExtensao)
   EndIf                 
   
   //Copia o arquivo XLS para o Temporario para ser executado
   If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.) 
      MsgInfo("Problemas na copia do arquivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
      Return .F.
   EndIf                                       
   
   //apaga macro da pasta temporária se existir
   If File(cTemp+cArqMacro)
      fErase(cTemp+cArqMacro)
   EndIf

   //Copia o arquivo XLA para o Temporario para ser executado
   If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.) 
      MsgInfo("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
      Return .F.
   EndIf
   
   //Exclui o arquivo antigo (se existir)
   If File(cTemp+cNomeXLS+".csv")
      fErase(cTemp+cNomeXLS+".csv")
   EndIf
   
   //Inicializa o objeto para executar a macro
   oExcelApp := MsExcel():New()             
   //define qual o caminho da macro a ser executada
   oExcelApp:WorkBooks:Open(cTemp+cArqMacro)       
   //executa a macro passando como parametro da macro o caminho e o nome do excel corrente
   oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cNomeXLS)
   //fecha a macro sem salvar
   //cPar:= "savechanges:=False"
   oExcelApp:WorkBooks:Close()
   //sai do arquivo e destrói o objeto
   oExcelApp:Quit()
   oExcelApp:Destroy()

   //Exclui o Arquivo excel da temp
   fErase(cTemp+cNomeXLS+cExtensao)
   fErase(cTemp+cArqMacro) //Exclui a Macro no diretorio temporario
   //
Next i
//
Return .T. 

/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parâmetros  : cArq - nome do arquivo que será usado      
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function XCargaArray(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 1 
Local nTotLin := 0
Local aDados  := {}
Local cFile   := cTemp + cArq + ".csv"
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
//Pula as linhas de cabeçalho
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
   //verifica se a linha está em branco, se estiver pula
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
   
   //passa para a próxima linha
   FT_FSkip()
   //
EndDo

//libera o arquivo CSV
FT_FUse()             

//Exclui o arquivo csv
If File(cFile)
   FErase(cFile)
EndIf

Return {aDados,aCabecM}


/*
Funcao      : validaCpos
Objetivos   : faz a validação dos campos da tela de filtro
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function XvalidaCpos()
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


User Function xxfXGetArq

Local cMask		:="*.*" 
Local cArqAt   	:= cGetFile(cMask, '')
Local cFileEDI	:= RIGHT(cArqAt,  LEN(cArqAt) -RAT("\", cArqAt))
Local cCamEDI	:= left(cArqAt,RAT("\", cArqAt))
cFileEDI:=LEFT(cFileEDI,  RAT(".", cFileEDI)-1)
cArq:=cFileEDI
cOrigem:=cCamEDI
Return cFileEDI

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
Local cMaior := "&lt;"
Local cMenor := "&gt;"

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

************************
Static Function CriaTemp()
************************
      
aadd( _aStru , {"PRODUTO"    , "C" , 15 , 00 } )
aadd( _aStru , {"DESCRICAO"  , "C" , 40 , 00 } )
aadd( _aStru , {"MONTADORA"  , "C" , 15 , 00 } )
aadd( _aStru , {"PREVINI"    , "C" , 30 , 00 } ) 
aadd( _aStru , {"ORDENS"     , "C" , 15 , 00 } )
aadd( _aStru , {"ESTOQUE"    , "C" , 15 , 00 } )
aadd( _aStru , {"FATURADO"   , "C" , 15 , 00 } ) 
aadd( _aStru , {"SEM1", "C"  , 15 , 00 } ) 
aadd( _aStru , {"SEM2", "C"  , 15 , 00 } ) 
aadd( _aStru , {"SEM3", "C"  , 15 , 00 } ) 
aadd( _aStru , {"SEM4", "C"  , 15 , 00 } ) 
aadd( _aStru , {"SEM5", "C"  , 15 , 00 } ) 
aadd( _aStru , {"DIF" , "C"  , 15 , 00 } ) 

// Criar arquivo temporário e gerar o cabeçalho
_cTemp := CriaTrab(_aStru, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
Index on Produto to _cTemp

RecLock("TMP",.T.)
TMP->PRODUTO:= GetSx3Cache( "C2_PRODUTO", "X3_TITULO" )
TMP->DESCRICAO:= GetSx3Cache( "B1_DESC", "X3_TITULO" )
TMP->MONTADORA:= "Montadora"
TMP->PREVINI := "Previsao Ini"
TMP->ORDENS:= "Ordens de Prod."
TMP->ESTOQUE:= "Estoque"
TMP->FATURADO	:= "Faturado"
TMP->SEM1 := "Semana 1" 
TMP->SEM2 := "Semana 2" 
TMP->SEM3 := "Semana 3" 
TMP->SEM4 := "Semana 4" 
TMP->SEM5 := "Semana 5" 
TMP->DIF  := "Diferenca" 
MsUnLock()

// Verifica previsão de Vendas do Início do mes

cQry:=" SELECT  C4_PRODUTO,SUM(C4_QUANT) AS QUANT FROM SC4010 "
cQry+=" WHERE C4_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQry+=" AND SC4010.D_E_L_E_T_<>'*'"
cQry+=" GROUP BY C4_PRODUTO"

If Select("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
cQry := ChangeQuery(cQry)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)

// Verifica ordens de producao em aberto

cQry:=" SELECT  C2_PRODUTO,SUM(C2_QUANT-C2_QUJE) AS QUANT FROM SC2010 "
cQry+=" WHERE C2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQry+=" AND SC2010.D_E_L_E_T_<>'*'"
cQry+=" GROUP BY C2_PRODUTO"

If Select("TRBC2")>0
	dbSelectArea("TRBC2")
	dbCloseArea()
EndIf
cQry := ChangeQuery(cQry)

If Select("TRBC2")>0
	dbSelectArea("TRBC2")
	dbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRBC2",.T.,.T.)

// Verifica faturamento no periodo

cQry:=" SELECT  D2_COD,SUM(D2_QUANT) AS QUANT FROM SD2010 "
cQry+=" WHERE D2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQry+=" AND SD2010.D_E_L_E_T_<>'*'"
cQry+=" GROUP BY D2_COD"

If Select("TRBD2")>0
	dbSelectArea("TRBD2")
	dbCloseArea()
EndIf
cQry := ChangeQuery(cQry)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRBD2",.T.,.T.)
           
Select TMP
dbgotop()
Do while !eof()
	Select Tmp
	seek trb->C4_Produto
	RecLock("TMP",.t.)
	tmp->Produto := trb->C4_Produto
	tmp->Previni := trb->quant
	MsUnlock()       
	Select Tmp
Enddo           

************************
Static Function EstrTmp()
************************
cTipo := "1"
If Select("TMP")>0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

_aStru := {}
aadd( _aStru , {"COD"  , "C" , 15 , 00 } )
aadd( _aStru , {"COMP" , "C" , 15 , 00 } )
aadd( _aStru , {"FATOR", "C" , 40 , 00 } )
aadd( _aStru , {"PERDA" , "C" , 15 , 00 } )

// Criar arquivo temporário e gerar o cabeçalho
_cTemp := CriaTrab(_aStru, .T.)
dbUseArea( .T.,,_cTemp,"TMP", Nil, .F. )
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
Index on Cod to _cTemp

RecLock("TMP",.T.)
TMP->COD   := "G1_COD"
TMP->COMP  := "G1_COMP"
TMP->FATOR := "G1_QUANT"
TMP->PERDA := "G1_PERDA"
MsUnLock()

Close(oDlg2)

Return

************************
Static Function MgTmp()
************************
cTipo := "2"
If Select("TMP")>0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

_aStru := {}
aadd( _aStru , {"COD" , "C" , 15 , 00 } )
aadd( _aStru , {"MARGEM" , "C" , 15 , 00 } )
aadd( _aStru , {"VALOR", "C" , 40 , 00 } )

// Criar arquivo temporário e gerar o cabeçalho
_cTemp := CriaTrab(_aStru, .T.)
dbUseArea( .T.,,_cTemp,"TMP", Nil, .F. )
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
Index on Cod to _cTemp

RecLock("TMP",.T.)
TMP->COD   := "COD"
TMP->MARGEM   := "MARGEM"
TMP->VALOR := "VALOR"
MsUnLock()

Close(oDlg2)

Return
**********************
User Function fGetArq
**********************

Local cMask		:="*.*" 
Local cArqAt   	:= cGetFile(cMask, '')
Local cFile 	:= RIGHT(cArqAt,  LEN(cArqAt) -RAT("\", cArqAt))
Local cCam  	:= left(cArqAt,RAT("\", cArqAt))
cFile:=LEFT(cFile,  RAT(".", cFile)-1)
cArq:=cFile
cOrigem:=cCam
Return cFile

