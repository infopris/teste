#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

#DEFINE ENTER chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บ Autor ณLuiz Eduardo Tapajosบ Data ณ  27/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ao que realiza a importa็ใo da cartira de pedidos pelo บฑฑ
ฑฑบ          ณ Arquivo xls                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณ cArqE    - Nome do arquivo XLS a ser carregado             บฑฑ
ฑฑบ          ณ cOrigemE - Local onde estแ o arquivo XLS                   บฑฑ
ฑฑบ          ณ cOrigemE - Local onde estแ o arquivo XLS                   บฑฑ
ฑฑบ          ณ nLinTitE - Quantas linhas de cabe็alho que nใo serใo       บฑฑ
ฑฑบ          ณ integradas possui o arquivo								  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function imparq(cArqE,cOrigemE,nLinTitE,lTela)


// Campo B1_LINDYNA = Linha do produto
// Texto na tabela Z1 (Z1_DESC)
// "DY_MRPUSR"       // Parametro para indicar quais usuแrios terใo acesso ao campo custo (ID do usuario)

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
Local cPerg := "PREV01"

Default lTela := .T.

Private cArq       := If(ValType(cArqE)=="C",cArqE,"")
Private cArqMacro  := "XLS2DBF.XLA"
Private cTemp      := GetTempPath() //pega caminho do temp do client
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private aArquivos  := {}
Private aRet       := {}
Private lUsr	   := .f.


IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF

IF SELECT("TRBC1") # 0
	TRBC1->(DBCLOSEAREA( ))
ENDIF

//Select SC1                      
//copy stru to \xc1
//cTempC1 := CriaTrab(nil,.f.)
//dbUseArea( .T.,,cTempC1, "TRBC1", Nil, .F. )

// PERGUNTAS

// mv_par01 - Tipo : 01 - MRP , 02- Inventario , 03 - Sintel, 04 - Producao Dia
// mv_par02 - Nome da posicao

// Formato do Arquivo deve ser : PRODUTO - SALDO

lResp := .f.
Do while .t.
	If !Pergunte(cPerg,.T.)
		lResp := .t.
		exit
	endif
	if empty(mv_par02)
		MsgBox ("Favor  preencher o parametro Nome ","Escolha","YESNO")
		loop
	endif
	cPar := strzero(mv_par01,2)
	lCompara := .f.
	if cPar = "03"
		if !MsgBox ("Importar arquivos ?","Escolha","YESNO")
			if MsgBox ("Gerar comparativo do m๊s ?","Escolha","YESNO")
				lCompara := .t.
			else
				Return
			endif
		endif
	endif
	dbSelectArea("SZH")
	dbSetOrder(1)
	Seek xFilial()+cPar+MV_PAR02
	if !eof() .and. mv_par01=4
		do while zh_chave=cPar+MV_PAR02
			IF RLOCK()
				delete    
			ENDIF
			skip
		enddo
	endif
	if !eof() .and. lCompara=.f.
		IF MV_PAR01<>3
			MsgBox ("Nome jแ existente , favor alterar ","Escolha","YESNO")
		Endif
		loop
	endif
	
	do case
		case mv_par01=2
			nMes := val(left(mv_par02,2))
			nAno := val(right(mv_par02,4))
			if (nMes<1.or. nMes>12) .or. (nAno<2016 .or. nAno>2020)
				MsgBox ("Para inventario preencher data valida no formato MMAAAA","Escolha","YESNO")
				loop
			endif
		case mv_par01=3 .and. !lCompara  // Apenas importa arquivos
			nAno := val(left(mv_par02,2))
			nMes := val(substr(mv_par02,3,2))
			nSemana := val(right(mv_par02,2))
			if (nSemana<1.or. nSemana>05) .or. (nMes<1.or. nMes>12) .or. (nAno<16 .or. nAno>20)
				MsgBox ("Para SINTEL preencher data valida no formato AAMM+Semana","Escolha","YESNO")
				loop
			endif
		case mv_par01=3 .and. lCompara  // Apenas gera relat๓rio
			nAno := val(left(mv_par02,2))
			nMes := val(substr(mv_par02,3,2))
			nSemana := val(right(mv_par02,2))
			if (nSemana<1.or. nSemana>05) .or. (nMes<1.or. nMes>12) .or. (nAno<16 .or. nAno>20)
				MsgBox ("Para SINTEL preencher data valida no formato AAMM+Semana","Escolha","YESNO")
				loop
			endif
			Processa( {|| GeraCompara() }, "Gerando arquivo comparativo SINTEL, aguarde!..." )
//			LjMsgRun(OemToAnsi("Gerando arquivo comparativo SINTEL, aguarde!"),,{||GeraCompara()} )  
			Return
	Endcase
	exit
Enddo
if lResp
	Return
endif

Select SZH

cArq       += Space(20-(Len(cArq)))
cOrigem    += Space(99-(Len(cOrigem)))

aAdd(aButtons,{"RELATORIO",{|| 	U_xxfXGetArq() }		,"Arquivos"})

If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))
	
	Define MsDialog oDlg Title 'Integra็ใo de Excel' From 7,10 To 20,50 OF oMainWnd
	
	nLin -= 12
	@ nLin,nCol1  Say      'Estrutura excel deve ter colunas PRODUTO e SALDO'  Of oDlg Pixel
	nLin += 12
	
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
		LjMsgRun(OemToAnsi("importando Excel. Por favor aguarde!"),,{||fIntArqX()} )
	Else
		MsgStop(cMSg)
		Return
	EndIf
EndIf

IF MV_PAR01=1
	LjMsgRun(OemToAnsi("Gerando planilha Excel, aguarde!"),,{||GeraNecessidade()} )
	//	GeraNecessidade()
ENDIF

IF MV_PAR01=2
	LjMsgRun(OemToAnsi("Gerando planilha Excel, aguarde!"),,{||GeraInv()} )
	MsgBox ("Arquivo do inventแrio importado com sucesso ","Escolha","YESNO")
ENDIF

IF MV_PAR01=4
	LjMsgRun(OemToAnsi("Gerando planilha Excel, aguarde!"),,{||GeraNec1()} )
	//	GeraNecessidade()
ENDIF

Return aRet




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIntArq   บAutor  ณReginaldo G. Ribeiroบ Data ณ 18/02/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma das rotinas referentes a integra็ใo                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 					                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fIntArqX()
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

//if MsgBox ("Processo 1","Escolha","YESNO")
//	x:=1
//endif
//converte arquivos xls para csv copiando para a pasta temp
MsAguarde( {|| ConOut("Come็ou conversใo do arquivo "+cArq+ " - "+Time()),;
lConv := fXconvArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
If lConv
	//carrega do xls no array
	ConOut("Terminou conversใo do arquivo "+cArq+ " - "+Time())
	ConOut("Come็ou carregamento do arquivo "+cArq+ " - "+Time())
	Processa( {|| aRet:= XCargaArray(AllTrim(cArq)) } ,;
	"Aguarde, carregando planilha..."+ENTER+"Pode demorar")
	ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
	
	nPosPrd	:= ASCAN(aRet[2,1], "PRODUTO")
	nPosSld	:= ASCAN(aRet[2,1], "SALDO")
	if mv_par01<>4
		nPosDesc	:= ASCAN(aRet[2,1], "DESCRICAO")
		nPosMont	:= ASCAN(aRet[2,1], "MONTADORA")
	endif
	
	if nPosPrd=0 .or. nPosSld=0
			MsgBox ("Verifique o arquivo a ser importado, deverแ ter apenas duas colunas . Na c้lula A1 deverแ constar a palavra PRODUTO e B1 com SALDO (mai๚sculas) ","Escolha","YESNO") 
			return
	endif
	cPar := strzero(mv_par01,2)
	dbSelectArea("SZH")
	dbSetOrder(1)
	Seek xFilial()+cPar+MV_PAR02
	if !eof()
		if !MsgBox ("Arquivo jแ importado, deseja refazer ?","Escolha","YESNO")
			Return
		endif
	endif
	For _nR:= 1 to len(aRet[1])
		RecLock("SZH",.T.)
		SZH->ZH_CHAVE	:= cPar+MV_PAR02
		//		SZH->ZH_CLIENTE :=
		//		SZH->ZH_LOJA    :=
		SZH->ZH_CODIGO	:= aRet[1,_nR,nPosPrd]
		SZH->ZH_QUANT	:= Val(aRet[1,_nR,nPosSld]) //Val(strtran(aRet[1,_nR,nPosSld],",","."))
		MsUnLock()
	Next _nR
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfconvArqs บAutor  ณReginaldo G. Ribeiroบ Data ณ 18/02/2006  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma que converte os arquivos .xls para .csv            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 					                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//if MsgBox ("Processo 2","Escolha","YESNO")
//	x:=1
//endif

cOrigem := AllTrim(cOrigem)

//Verifica se o caminho termina com "\"
If !Right(cOrigem,1) $ "\"
	cOrigem := AllTrim(cOrigem)+"\"
EndIf


//loop em todos arquivos que serใo convertidos
For i := 1 To Len(aArqs)
	
	If !"." $ AllTrim(aArqs[i])
		//passa por aqui para verifica se a extensใo do arquivo ้ .xls ou .xlsx
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
		MsgInfo("O arquivo "+cFile+" nใo foi encontrado!" ,"Arquivo")
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
	
	//apaga macro da pasta temporแria se existir
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
	//sai do arquivo e destr๓i o objeto
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
Local cFile   := cTemp + cArq + ".csv"
Local nHandle := 0
Local aCabecM	:= {}


//if MsgBox ("Processo 3","Escolha","YESNO")
//	x:=1
//endif

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
	FErase(cFile)
EndIf

Return {aDados,aCabecM}


/*
Funcao      : validaCpos
Objetivos   : faz a valida็ใo dos campos da tela de filtro
Autor       : Kanaใm L. R. Rodrigues
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


static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "แ้ํ๓๚"+"มษอำฺ"
Local cCircu := "โ๊๎๔๛"+"ยสฮิÛ"
Local cTrema := "ไ๋๏๖ü"+"ฤหฯึÜ"
Local cCrase := "เ่์๒๙"+"ภศฬาู"
Local cTio   := "ใ๕รี"
Local cCecid := "็ว"
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

*****************************
Static Function GeraCompara()
*****************************
Local cCrLf 	:= Chr(13) + Chr(10)

_aStru := {}
aadd( _aStru , {"MONTADORA"  , "C" , 20 , 00 } )
aadd( _aStru , {"PRODUTO"    , "C" , 15 , 00 } )
aadd( _aStru , {"DESCRICAO"  , "C" , 40 , 00 } )
aadd( _aStru , {"LINHA"  , "C" , 15 , 00 } )
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

// Criar arquivo temporแrio e gerar o cabe็alho
_cTemp := CriaTrab(_aStru, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
Index on Produto to _cTemp

RecLock("TMP",.T.)
TMP->MONTADORA:= "Montadora"
TMP->PRODUTO:= "  "+GetSx3Cache( "C2_PRODUTO", "X3_TITULO" )
TMP->DESCRICAO:= GetSx3Cache( "B1_DESC", "X3_TITULO" )
TMP->LINHA:= "Linha de Produto"
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

// Verifica previsใo de Vendas do Inํcio do mes
cData := stod("20"+left(mv_par02,4)+"01")
dIni := firstday(cData)
dfim := lastday(cData)

cQry:=" SELECT  C4_PRODUTO,SUM(C4_QUANT) AS QUANT FROM SC4010 "
cQry+=" WHERE C4_DATA BETWEEN '"+DTOS(dIni)+"' AND '"+DTOS(dFim)+"'"
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
cQry+=" WHERE C2_LOCAL='01' AND C2_EMISSAO BETWEEN '"+DTOS(dIni)+"' AND '"+DTOS(dFim)+"'"
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

cQry:=" SELECT  D2_COD,D2_TES,SUM(D2_QUANT) AS QUANT FROM SD2010 "
cQry+=" WHERE D2_EMISSAO BETWEEN '"+DTOS(dIni)+"' AND '"+DTOS(dFim)+"'"
cQry+=" AND SD2010.D_E_L_E_T_<>'*'"
cQry+=" GROUP BY D2_COD,D2_TES "

If Select("TRBD2")>0
	dbSelectArea("TRBD2")
	dbCloseArea()
EndIf
cQry := ChangeQuery(cQry)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TRBD2",.T.,.T.)


Select Trb
ProcRegua(RecCount())
dbgotop()
Do while !eof()
	IncProc("1/6")
	Select Tmp
	seek trb->C4_Produto
	RecLock("TMP",eof())
	tmp->Produto := trb->C4_Produto
	tmp->Previni := Transform(trb->quant, "@E 999999999999999.99" )
	MsUnlock()
	Select TRB
	skip
Enddo

Select SZH
dbgotop()
Seek xFilial()+"03"+substr(dtos(cData),3,4)
Do while !eof() .and. left(SZH->ZH_CHAVE,6)="03"+substr(dtos(cData),3,4)
	IncProc("1/6")
	Select tmp
	seek szh->zh_codigo
	if rlock() 
		RecLock("TMP",eof())
		tmp->Produto := szh->zh_codigo
		do case
			case right(SZH->ZH_CHAVE,2)="01"
				TMP->SEM1 := Transform(SZH->ZH_QUANT, "@E 999999999999999.99" )
			case right(SZH->ZH_CHAVE,2)="02"
				TMP->SEM2 := Transform(SZH->ZH_QUANT, "@E 999999999999999.99" )
			case right(SZH->ZH_CHAVE,2)="03"
				TMP->SEM3 := Transform(SZH->ZH_QUANT, "@E 999999999999999.99" )
			case right(SZH->ZH_CHAVE,2)="04"
				TMP->SEM4 := Transform(SZH->ZH_QUANT, "@E 999999999999999.99" )
			case right(SZH->ZH_CHAVE,2)="05"
				TMP->SEM5 := Transform(SZH->ZH_QUANT, "@E 999999999999999.99" )
		EndCase
		//	TMP->DIF  :=
		
	endif
	Select SZH
	Skip
Enddo

Select TRBC2
ProcRegua(RecCount())
dbgotop()
Do while !eof()
	IncProc("2/6")
	Select Tmp
	seek trbc2->C2_Produto
	RecLock("TMP",eof())
	tmp->Produto := trbc2->C2_Produto
	tmp->Ordens := Transform(trbC2->quant, "@E 999999999999999.99" )
	MsUnlock()
	Select TRBC2
	skip
Enddo

Select TRBD2
dbgotop()
Do while !eof()
	IncProc("3/6")
	Select SF4
	seek xFilial()+trbd2->d2_tes
	if f4_duplic<>"S"
		Select TRBD2
		skip
		loop
	endif
	Select Tmp
	seek trbd2->d2_cod
	RecLock("TMP",eof())
	tmp->Produto := trbd2->d2_cod
	tmp->Faturado := Transform(trbd2->quant, "@E 999999999999999.99" )
	MsUnlock()
	
	Select TRBD2
	skip
Enddo

Select TMP
dbgotop()
Do while !eof()
	IncProc("4/6")
	Select SB1
	seek xFilial()+tmp->Produto
	if !eof()
		Select SZE
		Seek xFilial()+sb1->B1_xCLIENT
		Select SZ1
		seek xFilial()+sb1->B1_LINDYNA // Texto na tabela Z1 (Z1_DESC)
		Select SB2
		seek xFilial()+tmp->Produto+"01"
		RecLock("TMP",.f.)
		tmp->MONTADORA	:= sze->ze_cliente
		tmp->DESCRICAO	:= sb1->b1_desc
		tmp->LINHA		:= sz1->z1_desc
		tmp->ESTOQUE	:= Transform(SB2->B2_QATU, "@E 999999999999999.99" )
		MsUnlock()
	Endif
	Select Tmp
	skip
Enddo



Select Tmp
dbgotop()

_cTemp := CriaTrab(nil,.f.)
nHandle := MsfCreate(Lower(_cTemp)+".csv",0)

If nHandle > 0
	ProcRegua(0)
	
	IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...")
	Tmp->(DbGoTop())
	while !tmp->(Eof())
		For nJ := 1 To tmp->(Fcount())
			fWrite(nHandle, tmp->(FieldGet(nJ)) + ";" )
		Next nJ
		fWrite(nHandle, cCrLf ) // Pula linha
		tmp->(DbSkip())
	end
	
	IncProc("Aguarde! Abrindo o arquivo...")
	
	fClose(nHandle)
	cPath := Lower(AllTrim(GetTempPath()))
	__CopyFIle(Lower(_cTemp)+".csv", cPath+_ctemp+".csv")
	
	oExcelApp:= MsExcel():New()
	//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".dbf")
	oExcelApp:WorkBooks:Open(cPath+_ctemp+".csv")
	oExcelApp:SetVisible(.T.)
	tmp->(DbCloseArea())
	Ferase(_cTemp+GetDbExtension())
	
endif

//copy to \tmpzh
//use

Return

//xxxxx



************************
Static Function CriaTmp()
************************
If Select("TMP")>0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

_aStru := {}
aadd( _aStru , {"MONTADORA"  , "C" , 15 , 00 } )
aadd( _aStru , {"PRODUTO"    , "C" , 15 , 00 } )
aadd( _aStru , {"DESCRICAO"  , "C" , 40 , 00 } )
aadd( _aStru , {"SALDO"      , "C" , 15 , 00 } )

// Criar arquivo temporแrio e gerar o cabe็alho
_cTemp := CriaTrab(_aStru, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
Index on Produto to _cTemp

RecLock("TMP",.T.)
TMP->PRODUTO:= GetSx3Cache( "C2_PRODUTO", "X3_TITULO" )
TMP->DESCRICAO:= GetSx3Cache( "B1_DESC", "X3_TITULO" )
TMP->MONTADORA:= "Montadora"
TMP->SALDO := "Saldo"
MsUnLock()

/*/Estrutura do arquivo de trabalho (SZH)

ZH_CHAVE
ZH_CLIENTE
ZH_LOJA
ZH_CODIGO
ZH_QUANT
/*/


*xxxxxx

******************************
Static Function GeraNecessidade()
******************************
IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

IF SELECT("FINAL") # 0
	FINAL->(DBCLOSEAREA( ))
ENDIF

cMRPUSR := GetMv("DY_MRPUSR")       // Parametro para indicar quais usuแrios terใo acesso ao campo custo 
cCodUsu :=  __cUserID
cNomUsu	:=	UsrRetName(__cUserID)      
cNomUsu1:=	cUserName
lUsr := .f.
if trim(cCodUsu)$cMRPUSR
	lUsr := .t.
endif

aCampos := {}
AADD(aCampos,{"CODVND" ,"C",15,0})
AADD(aCampos,{"COD"    ,"C",15,0})
AADD(aCampos,{"CODORI" ,"C",15,0})
AADD(aCampos,{"COMPON" ,"C",15,0})
AADD(aCampos,{"DESCRI" ,"C",30,0})
AADD(aCampos,{"TIPO"   ,"C",10,0})
AADD(aCampos,{"FANTASM","C",01,0})
AADD(aCampos,{"LINHA"  ,"C",05,0})
AADD(aCampos,{"VENDAS" ,"N",20,2})
AADD(aCampos,{"QTD"    ,"N",20,4})
AADD(aCampos,{"PERDA"  ,"N",20,2})
AADD(aCampos,{"TOTAL"  ,"N",20,4})
AADD(aCampos,{"NIVEL"  ,"N",10,0})
AADD(aCampos,{"NIV"    ,"N",10,0})
AADD(aCampos,{"ORDEM"  ,"N",10,0})
if lUsr
	AADD(aCampos,{"CUSUNIT"  ,"N",10,2})
	AADD(aCampos,{"CUSTOTAL" ,"N",10,2})
	AADD(aCampos,{"ENTRADA"	,"D",08,0})
	AADD(aCampos,{"TPNOTA"	,"C",20,0})
endif

_cTemp := CriaTrab( aCampos, .T.)
dbUseArea( .T.,, _cTemp,"TRB", .F., .F. )

cQuery := "SELECT * FROM SZH010 WHERE ZH_CHAVE='"+STRZERO(MV_PAR01,2)+mv_par02+"'"
cQuery += "AND SZH010.D_E_L_E_T_ <>'*'"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPZH", .F., .T.)
cTempSZH := CriaTrab(nil,.f.)
copy to &cTempSZH
USE
dbUseArea( .T.,,cTempSZH, "TRBSZH", Nil, .F. )
ProcRegua(RecCount())
dbgotop()
nNum:=0
do while !eof()
	IncProc("6/6")
	nNum++
	Select sb1
	seek xFilial()+TRBSZH->ZH_CODIGO
	cLinha := sb1->b1_linDyna
	Select SG1
	seek xFilial()+TRBSZH->ZH_CODIGO
	do while !eof() .and. TRBSZH->ZH_CODIGO == sg1->g1_cod
		if sg1->g1_fim<date()
			skip
			loop
		endif
		nPerda := 1
		if sg1->g1_perda<>0
			nPerda := (100-sg1->g1_perda)/100
		endif
		Select SB2
		dbSetOrder(1)
		Seek xFilial()+sg1->g1_comp+"02"
		if eof() .or. b2_cm1<=0
			Seek xFilial()+sg1->g1_comp+"06"
		endif
		Select sb1
		seek xFilial()+sg1->g1_comp
		Select TRB
		RecLock("TRB",.t.)
		trb->CodVnd	:= TRBSZH->ZH_CODIGO
		trb->Cod	:= sg1->g1_cod
		trb->Compon	:= sg1->g1_comp
		trb->Descri	:= sb1->b1_desc
		trb->Tipo	:= sb1->b1_tipo
		trb->Fantasm:= sb1->b1_fantasm
		trb->Linha	:= cLinha
		trb->Vendas := TRBSZH->ZH_QUANT //Transform(sc4->c4_quant, "@E 999999999999999.99" )
		trb->Qtd	:= SG1->G1_QUANT //Transform(sg1->g1_quant, "@E 999999999999999.99" )
		trb->perda	:= SG1->G1_PERDA //Transform(sg1->g1_perda, "@E 999999999999999.99" )
		trb->total	:= sg1->g1_quant*TRBSZH->ZH_quant*nPerda //Transform(sg1->g1_quant*sc4->c4_quant, "@E 999999999999999.99" )
		trb->nivel	:= 1
		trb->ordem	:= nNum
		if lUsr .and. sg1->g1_comp<"A"
//			TRB->cusunit  := cPreco //sb2->b2_cm1
//			TRB->custotal := trb->total*cPreco //sb2->b2_cm1
//			TRB->entrada  := dEntrada
//			TRB->tpnota	  := cTp
		endif
		MsUnLock()
		Select SG1
		skip
	enddo
	Select TRBSZH
	skip
enddo
use

Select Trb
ProcRegua(RecCount())
dbgotop()
Do while !eof()
	IncProc("2/6")
	cCodVnd := trb->CodVnd
	cLinha 	:= trb->Linha
	nVendas := (trb->Vendas)
	nNivel	:= 1
	Do while trb->CodVnd=cCodVnd
		nNivel++
		nOrdem := 1
		cCod	:= trb->cod
		cComp 	:= trb->compon
		nTot 	:= trb->Total
		cFantasm := trb->Fantasm
		cNivel	:= trb->Nivel
		nOrdem  := trb->Ordem
		nReg 	:= recno()

		Select SB2   
		dbSetOrder(1)
		Seek xFilial()+trb->Compon+"02"
		if eof() .or. b2_cm1<=0
			Seek xFilial()+trb->Compon+"06"
		endif
		Select sb1
		seek xFilial()+trb->Compon
		Select SG1
		seek xFilial()+cComp
		if sb1->b1_fantasm<>"S" .and. !eof() .and. sg1->g1_fim>date()
			nNum++
		endif
		do while !eof() .and. cComp == sg1->g1_cod
			Select SG1
			if sg1->g1_fim<date()
				skip
				loop
			endif
			nPerda := 1
			if sg1->g1_perda<>0
				nPerda := (100-sg1->g1_perda)/100
			endif
			if cFantasm="S"
				cCodOri:= cComp
				cCod2  := cCod
				cNivel1:= cNivel
			else
				cCodOri:= ""
				cCod2 := cComp
				cNivel1:= nNivel
				nOrdem := nNum
			endif
			Select sb1
			seek xFilial()+sg1->g1_comp
			Select TRB
			RecLock("TRB",.t.)
			trb->CodVnd	:= cCodVnd
			trb->Cod	:= cCod2
			trb->CodOri	:= cCodOri
			trb->Compon	:= sg1->g1_comp
			trb->Descri	:= sb1->b1_desc
			trb->Tipo	:= sb1->b1_tipo
			trb->Fantasm:= sb1->b1_fantasm
			trb->Linha	:= cLinha
			trb->Vendas := nVendas //Transform(sc4->c4_quant, "@E 999999999999999.99" )
			trb->Qtd	:= SG1->G1_QUANT //Transform(sg1->g1_quant, "@E 999999999999999.99" )
			trb->perda	:= SG1->G1_PERDA //Transform(sg1->g1_perda, "@E 999999999999999.99" )
			trb->total	:= sg1->g1_quant*nTot*nPerda //Transform(sg1->g1_quant*sc4->c4_quant, "@E 999999999999999.99" )
			trb->nivel	:= cNivel1
			trb->ordem	:= nOrdem
			if lUsr .and. sg1->g1_comp<"A"
//				TRB->cusunit  := cPreco // sb2->b2_cm1
//				TRB->custotal := trb->total*cPreco // sb2->b2_cm1
//				TRB->entrada  := dEntrada
//				TRB->tpnota	  := cTp
			endif
			MsUnLock()
			Select SG1
			skip
		enddo
		Select Trb
		Goto nReg
		skip
	enddo
Enddo

Select Trb
copy to \mrp1_01


GravaFinal()


*************************
Static Function GravaFinal()
*************************
Local cCrLf 	:= Chr(13) + Chr(10)

IF SELECT("INVENT") # 0
	INVENT->(DBCLOSEAREA( ))
ENDIF

cTemp2 := CriaTrab(nil,.f.)

aCampos := {}
AADD(aCampos,{"CODVND" ,"C",20,0})
AADD(aCampos,{"COD"    ,"C",20,0})
AADD(aCampos,{"COMPON" ,"C",20,0})
AADD(aCampos,{"DESCRI" ,"C",30,0})
AADD(aCampos,{"TIPO"   ,"C",10,0})
AADD(aCampos,{"LINHA"  ,"C",05,0})
AADD(aCampos,{"VENDAS" ,"C",20,0})
AADD(aCampos,{"QTD"    ,"C",20,0})
AADD(aCampos,{"PERDA"  ,"C",20,0})
AADD(aCampos,{"TOTAL"  ,"C",20,0})
if lUsr
	AADD(aCampos,{"CUSUNIT"  ,"C",20,0})
	AADD(aCampos,{"CUSTOTAL" ,"C",20,0})
	AADD(aCampos,{"ENTRADA","C",20,0})
	AADD(aCampos,{"TPNOTA" ,"C",20,0})
endif
AADD(aCampos,{"NIVEL"  ,"C",10,0})
if mv_par01=4
	AADD(aCampos,{"ESTOQUE"  ,"C",20,0})
endif

_cTemp1 := CriaTrab( aCampos, .T.)
dbUseArea( .T.,, _cTemp1,"FINAL", .F., .F. )

RecLock("Final",.T.)
Final->CODVND:= "  Vendido"
Final->COD:= GetSx3Cache( "G1_COD", "X3_TITULO" )
Final->COMPON:= GetSx3Cache( "G1_COMP", "X3_TITULO" )
Final->DESCRI:= GetSx3Cache( "B1_DESC", "X3_TITULO" )
Final->LINHA:= GetSx3Cache( "B1_LINDYNA", "X3_TITULO" )
Final->TIPO:= GetSx3Cache( "B1_TIPO", "X3_TITULO" )
Final->VENDAS:= "Qtd.Vendida"
Final->QTD  := "Quantidade"
Final->PERDA  := "Perda"
Final->TOTAL  := "Qtd.Total"
Final->NIVEL  := "Nivel"
if lUsr
	Final->CUSUNIT  := "Custo Unit."
	Final->CUSTOTAL := "Custo Tot."
	Final->ENTRADA  := "Data Entr."
	Final->TPNOTA	:= "Tipo Nota"
Endif
if mv_par01=4
	Final->ESTOQUE := "Sld.Estoque"
endif
MsUnlock()

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

_cTemp := CriaTrab(nil,.f.)
if mv_par01=1
dbUseArea( .T.,,"\MRP1_01", "TRB", Nil, .F. )
else
dbUseArea( .T.,,"\MRP1_02", "TRB", Nil, .F. )
endif

Select Trb
index on CodVnd + str(nivel,2) + Compon to &_cTemp
dbgotop()

DbSelectArea("trb")
dbgotop()
Do while !eof()
	IncProc("6/6")
		if lUsr  // Busca ultimo preco de entrada - solicitacao Ricardo - 27/07/2016
			cQuery := "SELECT D1_COD,D1_DOC,D1_SERIE,D1_FORNECE,MAX(D1_DTDIGIT) AS EMISSAO "
			cQuery += "FROM SD1010 "
			cQuery += "WHERE D1_COD = '"+trb->Compon+"' AND "
			cQuery += "SD1010.D_E_L_E_T_=' ' GROUP BY D1_COD,D1_DOC,D1_SERIE,D1_FORNECE "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP", .F., .T.)
			SELECT SD1
			dbSetOrder(2)
			SEEK xFilial()+tmp->(D1_COD+D1_DOC+D1_SERIE+D1_FORNECE)
			cPreco 	:= D1_VUNIT
			dEntrada:= STOD(TMP->EMISSAO)
			cTp		:= Posicione( "SF4", 1, xFilial("SF4") + SD1->D1_TES, "F4_TEXTO" )                      
			Select TMP
			Use
		endif

	Select Final
	RecLock("Final",.t.)
	final->CodVnd	:= "Vnd: "+trb->CodVnd
	final->Cod	:= "Cod.: "+trb->Cod
	final->Compon	:= "Comp : "+trb->Compon
	final->Descri	:= trb->Descri
	final->Tipo	:= trb->Tipo
	final->Linha  := trb->Linha
	if trb->Descri	= "NIVEL INTERMEDIARIO"
		final->nivel	:= str(trb->Nivel,2)+"XX"
	else
		final->nivel	:= Transform(trb->Nivel, "@E 99" )
	endif
	final->Vendas := Transform(trb->Vendas, "@E 999999999999999.99" )
	final->Qtd	:= Transform(trb->qtd, "@E 9999999999999.9999" )
	final->perda	:= Transform(trb->perda, "@E 999999999999999.99" )
	//	final->total	:= Transform(trb->total-Invent->Quant	, "@E 9999999999999.9999" )
	final->total	:= Transform(trb->total	, "@E 9999999999999.9999" )
	if lUsr
		Final->CUSUNIT	:= Transform(cPreco	, "@E 9999999999999.9999" )
		Final->CUSTOTAL	:= Transform(trb->total*cPreco	, "@E 9999999999999.9999" )
		Final->ENTRADA	:= dtoc(trb->Entrada)
		Final->TPNOTA	:= cTp
	Endif

	if mv_par01=4
		Final->ESTOQUE := Transform(trb->estoque	, "@E 9999999999999.9999" )
	endif
	MsUnLock()
	Select TRB
	skip
Enddo

if  mv_par01=1 .and. 1==2 // Gera Solicita็ใo de compras - Ativar assim que obtiver autorizacao - Incluir estoque de seguranca
	dbSelectArea("SC1")
	dbSetOrder(1)
	go bott
	nNumC1 := strzero(val(C1_NUM)+1,6)
	nIt1 := 0
	
	Select TRB
	nIt1++
	if nIt1 > 99
		nIt1 := 1
		nNumC1 := strzero(val(nNumC1)+1,6)
	endif
	_cTempx := CriaTrab(nil,.f.)
	Index on Compon to _cTempx
	dbgotop()
	lIni := .t.
	Do while !eof()
		IncProc("Gerando SC")
		cComp := trb->Compon
		cDesc := trb->Descri
		nVendas := trb->Vendas
		nTot  :=0
		Do while !eof() .and. trb->Compon = cComp
			nTot += trb->Total
			Select TRB
			skip
		Enddo
		dbSelectArea("SB1")
		dbSeek(xFilial()+cComp)
		dbSelectArea("SB2")
		dbSeek(xFilial()+cComp+"02")
		nSaldo := iif(B2_QATU>0,B2_QATU - SB1->B1_ESTSEG,0)
		if (nTot-nSaldo) > 0 .and. !left(cComp,1)$"M*G"
			GeraSC(cComp,nTot-nSaldo,nNumC1,nIt1)
		endif
	Enddo
endif

if mv_par01=4
	//Qtd Insuficiente
	
	_cTempx := CriaTrab(nil,.f.)
	Index on Compon to _cTempx
	dbgotop()
	lIni := .t.
	Do while !eof()
		cComp := trb->Compon
		cDesc := trb->Descri
		nVendas := trb->Vendas
		nTot  :=0
		nEst  := Estoque
		Do while !eof() .and. trb->Compon = cComp
			nTot += trb->Total
			Select TRB
			skip
		Enddo
		if lIni
			RecLock("Final",.t.)
			RecLock("Final",.t.)
			final->CodVnd	:= "Qtd Insuficiente"
			final->Compon	:= "Produto"
			final->total	:= "Quantidade Necess."
			Final->ESTOQUE  := "Saldo em Estoque"
			MsUnLock()
			lIni := .f.
		endif
		if nTot > nEst .and. cComp<"GG"
			RecLock("Final",.t.)
			final->Compon	:= "Comp : "+cComp
			final->Descri	:= cDesc
			final->total	:= Transform(nTot	, "@E 9999999999999.9999" )
			Final->ESTOQUE  := Transform(nEst	, "@E 9999999999999.9999" )
			MsUnLock()
		Endif
		Select Trb
	Enddo
	
	//Ordens de Producao
	
	_cTempx1 := CriaTrab(nil,.f.)
	Index on Cod to _cTempx1
	dbgotop()
	lIni := .t.
	Do while !eof()
		cQryC2:=" SELECT  C2_NUM,C2_ITEM,C2_SEQUEN,C2_QUANT,C2_QUJE FROM SC2010 "
		cQryC2+=" WHERE C2_PRODUTO ='"+TRB->COD+"' AND C2_QUANT-C2_QUJE > 0 AND C2_DATRF='        ' "
		cQryC2+=" AND SC2010.D_E_L_E_T_<>'*'"
		cQryC2 := ChangeQuery(cQryC2)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryC2),"TRBC2",.T.,.T.)
		select trb
		cCod 	:= trb->Cod
		nVendas := trb->Vendas
		nTot  	:=0
		Do while !eof() .and. trb->Cod = cCod
			nTot += trb->Vendas
			Select TRB
			skip
		Enddo
		if lIni
			RecLock("Final",.t.)
			RecLock("Final",.t.)
			final->CodVnd	:= "Ordens de Producao"
			final->Cod		:= "Produto"
			final->Descri	:= "Ordem de Producao"
			Final->Vendas  := "Quantidade Prod"
			Final->Total   := "Saldo OP"
			MsUnLock()
			lIni := .f.
		endif
		select trbc2
		if eof()
			Select SB1
			dbSetOrder(1)
			seek xFilial()+cCod
			if eof()
				cObs := "Produto nao encontrado"
			else
				cObs := "Nao existem ordens"
			endif			
			RecLock("Final",.t.)
			final->Cod	:= "Cod : "+cCod
			final->Vendas	:= Transform(nVendas	, "@E 9999999999999.9999" )
			final->Descri	:= cObs
			MsUnLock()
		endif
		select trbc2
		dbGoTop() 
		lIni1 := .t.
		Do while !eof()
			RecLock("Final",.t.)
			if lIni1
			final->Cod	:= "Cod : "+cCod
			final->Vendas	:= Transform(nVendas	, "@E 9999999999999.9999" )
			lIni1 := .f.
			endif
			final->Descri	:= trbc2->(C2_NUM+C2_ITEM+C2_SEQUEN)
			final->Total	:= Transform(trbc2->(C2_QUANT-C2_QUJE), "@E 9999999999999.9999" )
			MsUnLock()
			Select TRBC2
			skip
		Enddo     
		use
		Select Trb
	Enddo
	
endif

Select Trb
copy to &_cTemp
use
dbUseArea( .T.,,_cTemp, "TRB", Nil, .F. )
if mv_par01=1
	copy to \MRP1_01
endif
Use

Select Final
dbgotop()

_cTemp := CriaTrab(nil,.f.)
nHandle := MsfCreate(Lower(_cTemp)+".csv",0)

If nHandle > 0
	ProcRegua(0)
	
	IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...")
	final->(DbGoTop())
	while !final->(Eof())
		For nJ := 1 To final->(Fcount())
			fWrite(nHandle, final->(FieldGet(nJ)) + ";" )
		Next nJ
		fWrite(nHandle, cCrLf ) // Pula linha
		final->(DbSkip())
	end
	
	IncProc("Aguarde! Abrindo o arquivo...")
	
	fClose(nHandle)
	cPath := Lower(AllTrim(GetTempPath()))
	__CopyFIle(Lower(_cTemp)+".csv", cPath+_ctemp+".csv")
	
	oExcelApp:= MsExcel():New()
	//oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+_ctemp+".dbf")
	oExcelApp:WorkBooks:Open(cPath+_ctemp+".csv")
	oExcelApp:SetVisible(.T.)
	final->(DbCloseArea())
	Ferase(_cTemp+GetDbExtension())
	
endif

Return

******************************
Static Function GeraNec1()
******************************
IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

IF SELECT("FINAL") # 0
	FINAL->(DBCLOSEAREA( ))
ENDIF


aCampos := {}
AADD(aCampos,{"CODVND" ,"C",15,0})
AADD(aCampos,{"COD"    ,"C",15,0})
AADD(aCampos,{"CODORI" ,"C",15,0})
AADD(aCampos,{"COMPON" ,"C",15,0})
AADD(aCampos,{"DESCRI" ,"C",30,0})
AADD(aCampos,{"TIPO"   ,"C",10,0})
AADD(aCampos,{"FANTASM","C",01,0})
AADD(aCampos,{"LINHA"  ,"C",05,0})
AADD(aCampos,{"VENDAS" ,"N",20,2})
AADD(aCampos,{"QTD"    ,"N",20,4})
AADD(aCampos,{"PERDA"  ,"N",20,2})
AADD(aCampos,{"TOTAL"  ,"N",20,4})
AADD(aCampos,{"NIVEL"  ,"N",10,0})
AADD(aCampos,{"NIV"    ,"N",10,0})
AADD(aCampos,{"ORDEM"  ,"N",10,0})
AADD(aCampos,{"ESTOQUE","N",20,4})

_cTemp := CriaTrab( aCampos, .T.)
dbUseArea( .T.,, _cTemp,"TRB", .F., .F. )

cQuery := "SELECT * FROM SZH010 WHERE ZH_CHAVE='"+STRZERO(MV_PAR01,2)+mv_par02+"'"
cQuery += "AND SZH010.D_E_L_E_T_ <>'*'"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPZH", .F., .T.)
cTempSZH := CriaTrab(nil,.f.)
copy to &cTempSZH
USE
dbUseArea( .T.,,cTempSZH, "TRBSZH", Nil, .F. )
ProcRegua(RecCount())
dbgotop()
nNum:=0
do while !eof()
	IncProc("6/6")
	nNum++
	Select sb1
	seek xFilial()+TRBSZH->ZH_CODIGO
	cLinha := sb1->b1_linDyna
	if eof()
		RecLock("TRB",.t.)
		trb->CodVnd	:= TRBSZH->ZH_CODIGO
		trb->Cod	:= TRBSZH->ZH_CODIGO
		trb->Descri	:= "Produto nao existente"
		trb->Vendas := TRBSZH->ZH_QUANT //Transform(sc4->c4_quant, "@E 999999999999999.99" )
		MsUnLock()
	endif
	Select SG1
	seek xFilial()+TRBSZH->ZH_CODIGO
	do while !eof() .and. TRBSZH->ZH_CODIGO == sg1->g1_cod
		if sg1->g1_fim<date()
			skip
			loop
		endif
		nPerda := 1
		if sg1->g1_perda<>0
			nPerda := (100-sg1->g1_perda)/100
		endif
		Select sb2
		seek xFilial()+sg1->g1_comp+"06"
		Select sb1
		seek xFilial()+sg1->g1_comp
		Select TRB
		RecLock("TRB",.t.)
		trb->CodVnd	:= TRBSZH->ZH_CODIGO
		trb->Cod	:= sg1->g1_cod
		trb->Compon	:= sg1->g1_comp
		trb->Descri	:= sb1->b1_desc
		trb->Tipo	:= sb1->b1_tipo
		trb->Fantasm:= sb1->b1_fantasm
		trb->Linha	:= cLinha
		trb->Vendas := TRBSZH->ZH_QUANT //Transform(sc4->c4_quant, "@E 999999999999999.99" )
		trb->Qtd	:= SG1->G1_QUANT //Transform(sg1->g1_quant, "@E 999999999999999.99" )
		trb->perda	:= SG1->G1_PERDA //Transform(sg1->g1_perda, "@E 999999999999999.99" )
		trb->total	:= sg1->g1_quant*TRBSZH->ZH_quant*nPerda //Transform(sg1->g1_quant*sc4->c4_quant, "@E 999999999999999.99" )
		trb->nivel	:= 1
		trb->ordem	:= nNum
		trb->estoque:= sb2->b2_qatu
		MsUnLock()
		Select SG1
		skip
	enddo
	Select TRBSZH
	skip
enddo
use

Select Trb
ProcRegua(RecCount())
dbgotop()
Do while !eof()
	IncProc("2/6")
	cCodVnd := trb->CodVnd
	cLinha 	:= trb->Linha
	nVendas := (trb->Vendas)
	nNivel	:= 1
	Do while trb->CodVnd=cCodVnd
		nNivel++
		nOrdem := 1
		cCod	:= trb->cod
		cComp 	:= trb->compon
		nTot 	:= trb->Total
		cFantasm := trb->Fantasm
		cNivel	:= trb->Nivel
		nOrdem  := trb->Ordem
		nReg 	:= recno()
		Select sb1
		seek xFilial()+trb->Compon
		Select SG1
		seek xFilial()+cComp
		if sb1->b1_fantasm<>"S" .and. !eof() .and. sg1->g1_fim>date()
			nNum++
		endif
		do while !eof() .and. cComp == sg1->g1_cod
			Select SG1
			if sg1->g1_fim<date()
				skip
				loop
			endif
			nPerda := 1
			if sg1->g1_perda<>0
				nPerda := (100-sg1->g1_perda)/100
			endif
			if cFantasm="S"
				cCodOri:= cComp
				cCod2  := cCod
				cNivel1:= cNivel
			else
				Select SG1
				skip
				loop
			endif
			Select sb2
			seek xFilial()+sg1->g1_comp+"06"
			Select sb1
			seek xFilial()+sg1->g1_comp
			Select TRB
			RecLock("TRB",.t.)
			trb->CodVnd	:= cCodVnd
			trb->Cod	:= cCod2
			trb->CodOri	:= cCodOri
			trb->Compon	:= sg1->g1_comp
			trb->Descri	:= sb1->b1_desc
			trb->Tipo	:= sb1->b1_tipo
			trb->Fantasm:= sb1->b1_fantasm
			trb->Linha	:= cLinha
			trb->Vendas := nVendas //Transform(sc4->c4_quant, "@E 999999999999999.99" )
			trb->Qtd	:= SG1->G1_QUANT //Transform(sg1->g1_quant, "@E 999999999999999.99" )
			trb->perda	:= SG1->G1_PERDA //Transform(sg1->g1_perda, "@E 999999999999999.99" )
			trb->total	:= sg1->g1_quant*nTot*nPerda //Transform(sg1->g1_quant*sc4->c4_quant, "@E 999999999999999.99" )
			trb->nivel	:= cNivel1
			trb->ordem	:= nOrdem
			trb->estoque:= sb2->b2_qatu
			MsUnLock()
			Select SG1
			skip
		enddo
		Select Trb
		Goto nReg
		skip
	enddo
Enddo

Select Trb
copy to \mrp1_02
use

GravaFinal()

Return

**************************
//Static Function GeraCompara()
**************************

IF SELECT("COMPARA") # 0
	INVENT->(DBCLOSEAREA( ))
ENDIF

cTemp2 := CriaTrab(nil,.f.)

_aStru	:= {}

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


// Criar arquivo temporแrio e gerar o cabe็alho
_cTemp := CriaTrab(_aStru, .T.)
DbUseArea(.T.,"DBFCDX",_cTemp,"COMPARA",.F.,.F.)
Index on Produto to _cTemp

dIni := stod("20"+right(mv_par02,2)+substr(mv_par02,3,2)+"01")
dFim:= lastday(dIni)

cQry:=" SELECT  C4_PRODUTO,SUM(C4_QUANT) AS QUANT FROM SC4010 "
cQry+=" WHERE C4_DATA BETWEEN '"+DTOS(dIni)+"' AND '" + DTOS(dFim) +"'"
cQry+=" AND SC4010.D_E_L_E_T_<>'*'"
cQry+=" GROUP BY C4_PRODUTO"

cQuery := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPC4", .F., .T.)
cTempsC4 := CriaTrab(nil,.f.)
copy to &cTempsC4
dbUseArea( .T.,,cTempSc4, "TRBSc4", Nil, .F. )
ProcRegua(RecCount())
dbgotop()
nNum:=0
do while !eof()
	IF TRBSC4->C4_DATA < DTOS(dIni) .or. TRBSC4->C4_DATA > DTOS(dFim)
		skip
		loop
	endif
	Select SB1
	dbSetOrder(1)
	seek xFilial()+TRBSC4->C4_PRODUTO
	Select SZ1
	dbSetOrder(1)
	Seek xFilial()+sb1->B1_LINDYNA
	// Campo B1_LINDYNA = Linha do produto
	// Texto na tabela Z1 (Z1_DESC)
	
	Select COMPARA
	RecLock("COMPARA",.t.)
	COMPARA->PRODUTO	:= TRBSC4->C4_PRODUTO
	COMPARA->DESCRICAO	:= SB1->B1_DESC
	COMPARA->MONTADORA	:= SZ1->Z1_DESC
	COMPARA->QUANT		:= TRBSC4->QUANT
	MsUnLock()
	Select TrbSc4
	Skip
Enddo

cQry:=" SELECT  ZH_CODIGO,ZH_CHAVE,SUM(ZH_QUANT) AS QUANT FROM SZH010 "
cQry+=" WHERE LEFT(ZH_CHAVE,2)='03' AND RIGHT(ZH_CHAVE,4)='"+RIGHT(ZH_CHAVE,4)+"' "
cQry+=" AND SZH010.D_E_L_E_T_<>'*'"
cQry+=" GROUP BY ZH_CODIGO,ZH_CHAVE"
cQry+=" ORDER BY ZH_CODIGO,ZH_CHAVE"

cQuery := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPZH", .F., .T.)
cTempsC4 := CriaTrab(nil,.f.)

Do while !eof()
	Select Compara
	Seek tmpzh->ZH_CODIGO
	if !eof()
		recLock("Compara",.t.)
	else
		recLock("Compara",.f.)
	endif
	Select SB1
	dbSetOrder(1)
	seek xFilial()+tmpzh->ZH_CODIGO
	Select SZ1
	dbSetOrder(1)
	Seek xFilial()+sb1->B1_LINDYNA
	Select COMPARA
	RecLock("COMPARA",.t.)
	COMPARA->PRODUTO	:= tmpzh->ZH_CODIGO
	COMPARA->DESCRICAO	:= SB1->B1_DESC
	COMPARA->MONTADORA	:= SZ1->Z1_DESC
	DO Case
		Case left(tmpzh->ZH_Chave,4)="0301"
			COMPARA->SEM1		+= tmpzh->ZH_QUANT
		Case left(tmpzh->ZH_Chave,4)="0302"
			COMPARA->SEM2		+= tmpzh->ZH_QUANT
		Case left(tmpzh->ZH_Chave,4)="0303"
			COMPARA->SEM3		+= tmpzh->ZH_QUANT
		Case left(tmpzh->ZH_Chave,4)="0304"
			COMPARA->SEM4		+= tmpzh->ZH_QUANT
		Case left(tmpzh->ZH_Chave,4)="0305"
			COMPARA->SEM5		+= tmpzh->ZH_QUANT
	EndCase
	MsUnLock()
	
	Select TmpZH
	skip
Enddo

Select Compara
Do while !eof()
	cQry:=" SELECT  C2_PRODUTO,SUM(C2_QUANT-C2_QUJE) AS QUANT FROM SC2010 "
	cQry+=" WHERE C2_PRODUTO='"+tmpzh->ZH_codigo+"' AND C2_EMISSAO BETWEEN '"+DTOS(dIni)+"' AND '" + DTOS(dFim) +"'"
	cQry+=" AND SC2010.D_E_L_E_T_<>'*'"
	cQry+=" GROUP BY C2_PRODUTO"
	
	cQuery := ChangeQuery(cQry)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPC2", .F., .T.)
	c2quant := quant
	USE
	
	cQry:=" SELECT  D2_COD,SUM(D2_QUANT) AS QUANT FROM SD2010 "
	cQry+=" WHERE D2_COD='"+tmpzh->ZH_codigo+"' AND D2_EMISSAO BETWEEN '"+DTOS(dIni)+"' AND '" + DTOS(dFim) +"'"
	cQry+=" AND SD2010.D_E_L_E_T_<>'*'"
	cQry+=" GROUP BY D2_PRODUTO"
	
	cQuery := ChangeQuery(cQry)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPD2", .F., .T.)
	D2quant := quant
	USE
	
	Select SB2
	Seek xFilial()+tmpzh->ZH_CODIGO+"01"
	Select Compara
	Seek tmpzh->ZH_CODIGO
	if !eof()
		recLock("Compara",.t.)
	else
		recLock("Compara",.f.)
	endif
	COMPARA->ORDENS		+= c2quant
	COMPARA->ESTOQUE	+= SB2->B2_QATU
	COMPARA->FATURADO	+= c2quant
	Select TMPZH
	skip
	
Enddo
copy to \tmpzh
use

Static Function GeraSC(cComp,nTot,nNumC1,nIt1)

dbSelectArea("SC3")
dbSeek(xFilial()+cComp)
               
cDat := "20"+left(mv_par02,04)+"01"
dDat := lastday(stod(dDat))

Select SC1                      

//RecLock("SC1",.t.)
RecLock("TRBC1",.t.)
//C1_FILIAL := xFilial()
C1_FILIAL := "0101"
C1_PRODUTO:= cComp  
C1_QUANT  := nTot
//	C1_PRECO  := nVal
//	C1_PRC    := nVal
C1_DESCRI := sb1->b1_desc
C1_UM     := sb1->b1_um
C1_ITEM   := strzero(nIt1,2)
C1_NUM    := nNumC1
C1_MOED   := "01"
C1_SEGUM  := sb1->b1_segum
C1_QTSEGUM:= IIF(sb1->b1_tipconv="M",ROUND(nTot*sb1->B1_conv,0),ROUND(nTot/sb1->B1_conv,0))
C1_DATPRF := dDat
C1_LOCAL  := "01"
//	C1_OBS    := cObs
C1_EMISSAO:= firstday(ddatabase)
C1_FORNECE:= SC3->C3_FORNECE
C1_LOJA   := SC3->C3_LOJA
C1_SOLICIT:= "MRP" //substr(cUsuario,7,10)
//	C1_SOLICIT:= Left(UsrRetName(RetCodUsr()),10)
C1_COTACAO:= "" //"IMPORT"
C1_IMPORT := "" //cImp
C1_CODCOMP:= "01"
C1_CLASS  := "1"
MsUnlock()

Return

******************************
Static Function GeraInv()
******************************
IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF

IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
ENDIF

IF SELECT("FINAL") # 0
	FINAL->(DBCLOSEAREA( ))
ENDIF

aCampos := {}
AADD(aCampos,{"COD" ,"C",15,0})
AADD(aCampos,{"LOC" ,"C",02,0})
AADD(aCampos,{"QUANT"    ,"N",15,2})
_cTemp := CriaTrab( aCampos, .T.)
dbUseArea( .T.,, _cTemp,"TRB", .F., .F. )

cQuery := "SELECT * FROM SZH010 WHERE ZH_CHAVE='"+STRZERO(MV_PAR01,2)+mv_par02+"'"
cQuery += "AND SZH010.D_E_L_E_T_ <>'*'"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPZH", .F., .T.)
cTempSZH := CriaTrab(nil,.f.)
copy to &cTempSZH
USE
dbUseArea( .T.,,cTempSZH, "TRBSZH", Nil, .F. )
ProcRegua(RecCount())
dbgotop()
nNum:=0
do while !eof()
	IncProc("6/6")
	nNum++
	Select sb1
	seek xFilial()+TRBSZH->ZH_CODIGO
	IF !EOF() .AND. RLOCK()
		sb1->b1_localiz := "S"
		sb1->b1_locPAD := "02"
	Endif
	Select SB7
	dbsetorder(1)
	Seek xFilial()+"20161130"+TRBSZH->ZH_CODIGO+"02"
	if eof() 	.AND. TRBSZH->ZH_QUANT<>0 .and. 1==2
	recLock("SB7",.t.)
	sb7->B7_FILIAL	:= xFilial()
	sb7->B7_COD := 	TRBSZH->ZH_CODIGO
	sb7->B7_LOCAL := "02"
	sb7->B7_TIPO := 'MP"
	sb7->B7_DOC := 	"161130"
	sb7->B7_QUANT := TRBSZH->ZH_QUANT
	sb7->B7_QTSEGUM	:= iif(sb1->b1_tipconv="D",TRBSZH->ZH_QUANT/sb1->b1_conv,TRBSZH->ZH_QUANT*sb1->b1_conv)
	sb7->B7_DATA	:= stod("20161130")
	sb7->B7_DTVALID	:= stod("20161130")
	sb7->B7_LOCALIZ := "C010101"
	sb7->B7_STATUS := "1"
	sb7->B7_ORIGEM :=	"MATA270"
	MsUnLock()	
	endif
/*	Select sb2
	seek xFilial()+TRBSZH->ZH_CODIGO .and. 1==2
	do while !eof() .and. sb2->b2_cod=TRBSZH->ZH_CODIGO
		if sb2->b2_qatu<>0
			Select Trb
			Reclock("TRB",.t.)
			trb->Cod := sb2->b2_cod
			trb->Loc := sb2->b2_local
			trb->quant := sb2->b2_qatu
			MsUnLock()
		endif
		Selec SB2                                                                
		skip
	enddo */
	Select TRBSZH
	skip
enddo
use
Select Trb
copy to \trb
use
