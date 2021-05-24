#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FINA01a ºAutor  ³Luiz Eduardo        º Data ³  02/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para importação da planilha (reembolso)               ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Impestr1(cArqE,cOrigemE,nLinTitE,lTela)


// SX5 - Tabela 05 - criar tipo de título LOL
// SX6 - criar parametro MV_XUSRLOL

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
Private cTemp   	:= GetTempPath() //pega caminho do temp do client
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

IF SELECT("ERRMSG") # 0
	ERRMSG->(DBCLOSEAREA( ))
ENDIF

IF SELECT("LOLLA") # 0
	LOLLA->(DBCLOSEAREA( ))
ENDIF

// Cria e Abre arquivo temporário
_aStru := {}
aadd( _aStru , {'dataerro'  , 'C' , 10 , 00 } )
aadd( _aStru , {'usuario'  	, 'C' , 20 , 00 } )
aadd( _aStru , {'mensagem'  , 'C' , 80 , 00 } )
aadd( _aStru , {'pulseira'  , 'C' , 25 , 00 } )

_cErr := CriaTrab(_aStru, .T.)
dbUseArea(.T.,__LocalDriver,_cErr,"ERRMSG",.F.)

// Formato do Arquivo deve ser : PRODUTO - SALDO

cArq       += Space(20-(Len(cArq)))
cOrigem    += Space(99-(Len(cOrigem)))

aAdd(aButtons,{"RELATORIO",{|| 	U_fXGetArq() },"Arquivos"})

If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))
	
	if !lSair
		Return
	endif
	
	Define MsDialog oDlg Title 'Integração de Excel' From 7,10 To 20,50 OF oMainWnd
	
	
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

// Gravação dos dados da Planilha
IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF
if file(_cTemp+".dtc")
	dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)  // Reabre arquivo temporário
else
	Return
endif


Processa( {|| aRet:= GravaFin() } ,"Aguarde, gravando registros ... ")
ConOut("Terminou gravação do arquivo SE2 -"+Time())

Return

*-------------------------*
Static Function GravaFin()
*-------------------------*

if file("lolla2018.dtc")
	cTempLolla := CriaTrab(nil,.f.)
	dbUseArea(.T.,__LocalDriver,"lolla2018.dtc","LOLLA",.F.)  // Reabre arquivo temporário
	Index on val(usid) to &cTempLolla
endif

TMP->(dbGoTop())
ProcRegua(reccount())

If TMP->(!EOF())
	
	While TMP->(!EOF())
		IncProc("Gravando registros "+AllTrim(str(recno(),6))+" de "+AllTrim(Str(reccount(),6)))
		_nRegistro := tmp->(recno())
//		cCpf := tmp->CPF // Buscar CPF da Planilha
		cCpf := replicate("0",11-len(alltrim(tmp->CPF)))+alltrim(tmp->CPF)
		Select SA2
		dbSetOrder(3)
		Seek xFilial()+cCpf
		// Cadastra fornecedor
		CadForn()
		If Empty(TRIM(tmp->Nome)+" "+trim(tmp->sobrenome)) .Or. Empty(tmp->cpf) .Or. Empty(tmp->banco) .Or. Empty(tmp->conta)
			select tmp
			skip
			loop
		endif
		if sa2->(eof())
			Select Tmp
			skip
			loop
		Endif
		Select TMP
		_cParcela	:= tmp->valor     //XXX
		
		Select SE2
		dbSetOrder(6)
		Seek xFilial()+sa2->(a2_cod+a2_loja)+"LOL"
		lExiste := .f.
		do while !eof() .and. sa2->(a2_cod+a2_loja)+"LOL" = SE2->(e2_fornece+e2_loja+e2_prefixo)
			if year(e2_emissao)=year(date())
				lExiste := .t.                  
				exit
			endif
			skip
		enddo
		if !eof()  .AND. val(tmp->cep)<>0 .and. lExiste  // Grava erro - título já existe para esse CPF ou valor menor que permitido
			RecLock("ERRMSG",.t.)
			ERRMSG->DATAERRO := dtoc(dDataBase)
			ERRMSG->USUARIO  := substr(cUsuario,7,15)
			ERRMSG->MENSAGEM := "Já existe título cadastrado para esse CPF "+alltrim(cCpf)+" ,não será importado"
			ERRMSG->PULSEIRA := alltrim(tmp->uid)
			Select Tmp
			skip
			loop
		endif
		
		Select SE2
		dbSetOrder(1)
		Seek xFilial()+"LOL"+alltrim(tmp->uid)+alltrim(tmp->parc)
		if (alltrim(tmp->uid)==alltrim(se2->e2_num) .OR. empty(cCpf))  .AND. val(tmp->cep)<>0 .and. year(e2_emissao)=year(date())// Grava erro - título já existe para essa pulseira
			RecLock("ERRMSG",.t.)
			ERRMSG->DATAERRO := dtoc(dDataBase)
			ERRMSG->USUARIO  := substr(cUsuario,7,15)
			ERRMSG->MENSAGEM := "Pulseira já cadastrada ou CPF em branco, não será importada"
			ERRMSG->PULSEIRA := alltrim(tmp->uid)
			Select Tmp
			skip
			loop
		endif
		
		if file("lolla2017.dtc")
			Select Lolla
			seek val(tmp->uid)
			if eof() .or. saldo1<tmp->Valor
				RecLock("ERRMSG",.t.)
				ERRMSG->DATAERRO := dtoc(dDataBase)
				ERRMSG->USUARIO  := substr(cUsuario,7,15)
				ERRMSG->MENSAGEM := "Pulseira "+tmp->uid+" sem saldo suficiente para reembolso - verificar"
				ERRMSG->PULSEIRA := alltrim(tmp->uid)
				Select Tmp
				skip
				loop
			endif
			Select SE2
		endif
		
		if empty(cCpf)  // Grava erro - CPF não preenchido
			RecLock("ERRMSG",.t.)
			ERRMSG->DATAERRO := dtoc(dDataBase)
			ERRMSG->USUARIO  := substr(cUsuario,7,15)
			ERRMSG->MENSAGEM := "Pulseira "+tmp->uid+" sem CPF informado na planilha, não será importada"
			ERRMSG->PULSEIRA := alltrim(tmp->uid)
			Select Tmp
			skip
			loop
		endif
		
		dVencRea := DataValida(dDataBase+3)
		if day(dVencRea)=5 .or. day(dVencRea)=15 .or. day(dVencRea)=25
			dVencRea := dVencRea + 1
		endif
		//		aAdd(aVetorSE2,{"E2_BCOPAG"	,tmp->Banco			  													,Nil})
		//		aAdd(aVetorSE2,{"E2_AGPAG"	,tmp->Agencia															,Nil})
		//		aAdd(aVetorSE2,{"E2_CTAPAG"	,tmp->Conta																,Nil})
		
		aVetorSE2 := {}
		aAdd(aVetorSE2,{"E2_FILIAL"		,xFilial("SE2")														,Nil})
		aAdd(aVetorSE2,{"E2_PREFIXO"	,'LOL'																,Nil})
		aAdd(aVetorSE2,{"E2_NUM"		,alltrim(tmp->uid)													,Nil})
		aAdd(aVetorSE2,{"E2_PARCELA"	,alltrim(tmp->parc)			 										,Nil})
		aAdd(aVetorSE2,{"E2_TIPO"		,'LOL'																,Nil})
		aAdd(aVetorSE2,{"E2_NUMPC" 		,'LOLLA'															,Nil})
		aAdd(aVetorSE2,{"E2_NUMSPA"		,trim(tmp->(uid+parc))												,Nil})
		aAdd(aVetorSE2,{"E2_NATUREZ"	,'500501'															,Nil}) //500100
		aAdd(aVetorSE2,{"E2_FORNECE"	,sa2->a2_cod														,Nil})
		aAdd(aVetorSE2,{"E2_LOJA"		,sa2->a2_LOJA														,Nil})
		aAdd(aVetorSE2,{"E2_EMISSAO"	,dDataBase															,Nil})
		aAdd(aVetorSE2,{"E2_VENCTO"		,dDataBase+3														,Nil})
		aAdd(aVetorSE2,{"E2_VENCREA"	,dVencRea															,Nil})
		aAdd(aVetorSE2,{"E2_VALOR"		,tmp->Valor															,Nil})
		aAdd(aVetorSE2,{"E2_MOEDA"		,1																	,Nil})
		aAdd(aVetorSE2,{"E2_TXMOEDA"	,1																	,Nil})
		aAdd(aVetorSE2,{"E2_CONTAD"		,'1104010007'														,Nil})
		aAdd(aVetorSE2,{"E2_CCONTAB"	,'1104010007'														,Nil})
		aAdd(aVetorSE2,{"E2_CCUSTO"		,'03031109'															,Nil})
		aAdd(aVetorSE2,{"E2_ITEM"		,'PEIFF190405'														,Nil})
		aAdd(aVetorSE2,{"E2_APROVA"		,'Rudney Rodrigues Filho'											,Nil})
		aAdd(aVetorSE2,{"E2_HIST"		,sa2->(A2_COD+A2_LOJA)+' '+trim(tmp->uid)+' Reemb.Loll 2019'		,Nil})
		aAdd(aVetorSE2,{"E2_VLCRUZ"		,tmp->valor															,Nil})
		
		//		GravaSE2()
		IF SELECT("TMP") # 0
			if file("lolla2018.dtc")
				Select Lolla
				seek val(tmp->uid)
				if !eof()
					RecLock("LOLLA",.t.)
					LOLLA->SALDO1 := SALDO1 - tmp->valor
					MSUnlock()
				endif
				Select Tmp
			endif
			
			TMP->(DBCLOSEAREA( ))
		ENDIF
		
		lMsErroAuto := .f.
		MsExecAuto({|x,y| Fina050(x,y)},aVetorSE2,3)
		
		If lMsErroAuto
			SE2->(RollBackSXE())
			MostraErro()
		Else
			_lOk	:= .T.
		Endif
		
		dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)
		//		DbUseArea(.T.,"DBFCDX",_cTemp1,"TMP",.F.,.F.)
		_nRegistro++
		dbgoto(_nRegistro)
		
		//		Select TMP
		//		TMP->(dbSkip())
	EndDo
	
	If _lOk
		cObs1 :=""
		if ERRMSG->(RecCount( )) > 0
			cObs1 := "Ocorreram erros na impotação, favor verificar planilha gerada"
		endif
		//		Aviso(	"Processo de importação finalizado "  + CRLF  ,{"OK"})
		//		Aviso(	"Titulos a pagar gerados com sucesso","Para a Solicitação de Pagamento Antecipado/Avulso " + CRLF + ;
		//		"Titulo(s) gerado(s) : " + CRLF + "Prefixo \ Numero \ Parcela. " + CRLF  ,{"OK"})
	EndIf
EndIf

ImprimeErr()

lSair := .f.
cArq := "Sair"

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fIntArq   ºAutor  ³Luiz Eduardo        º Data ³ 02/03/2017  º±±
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


// Cria e Abre arquivo temporário
_aStru := {}
aadd( _aStru , {'Nome'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Sobrenome'  , 'C' , 20 , 00 } )
aadd( _aStru , {'UID'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Parc'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Munic'  , 'C' , 20 , 00 } )
aadd( _aStru , {'CEP'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Tel'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Email'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Titular'  , 'C' , 20 , 00 } )
aadd( _aStru , {'CPF'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Banco'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Agencia'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Conta'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Digito'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Valor'  , 'N' , 12 , 02 } )

_cTemp := CriaTrab(_aStru, .T.)
dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
//Index on Produto to _cTemp


//converte arquivos xls para csv copiando para a pasta temp
//MsAguarde( {|| ConOut("Começou conversão do arquivo "+cArq+ " - "+Time()),;
//lConv := fXconvArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
If lConv .or. 1=1
	//carrega do xls no array
	ConOut("Terminou conversão do arquivo "+cArq+ " - "+Time())
	ConOut("Começou carregamento do arquivo "+cArq+ " - "+Time())
	Processa( {|| aRet:= XCargaArray(AllTrim(cArq)) } ,;
	"Aguarde, carregando planilha... Pode demorar")
	ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
	
	cNome      := ASCAN(aRet[2,1],'Nome')
	//	cSobrenome := ASCAN(aRet[2,1],'Sobrenome')
	cUID       := ASCAN(aRet[2,1],'UID')
	cMunic	   := ASCAN(aRet[2,1],'Munic')
	cCEP	   := ASCAN(aRet[2,1],'CEP')
	cTel       := ASCAN(aRet[2,1],'Tel')
	cEmail     := ASCAN(aRet[2,1],'Email')
//	cTitular   := ASCAN(aRet[2,1],'TITULAR')
	cCPF       := ASCAN(aRet[2,1],'CPF')
	cBanco     := ASCAN(aRet[2,1],'Banco')
	cAgencia   := ASCAN(aRet[2,1],'Agencia')
	cConta     := ASCAN(aRet[2,1],'Conta')
	cDigito    := ASCAN(aRet[2,1],'Digito')
	cValor     := ASCAN(aRet[2,1],'Valor')
	
	if cNome =0 .or. cUID  =0 .or. cTel  =0 .or. cEmail=0 .or. cCPF  =0 .or. cBanco=0 .or. cAgencia=0 .or. cConta=0 .or. cDigito=0 .or. cValor=0
		Aviso("Help", 	"Verifique as colunas do arquivo a ser importado, o cabeçalho deverá obedecer ao padrão definido entre as equipes" ,{"Ok"},1)
		return
	endif
	//	nPosPrd	:= ASCAN(aRet[2,1], "PRODUTO")
	//	nPosSld	:= ASCAN(aRet[2,1], "SALDO")
	
	//	if nPosPrd=0 .or. nPosSld=0
	//			MsgBox ("Verifique o arquivo a ser importado, deverá ter apenas duas colunas . Na célula A1 deverá constar a palavra PRODUTO e B1 com SALDO (maiúsculas) ","Escolha","YESNO")
	//			return
	//	endif
	
	dbSelectArea("TMP")
	For _nR:= 1 to len(aRet[1])
		RecLock("TMP",.T.)
		tmp->Nome    := aRet[1,_nR,cNome]
		//		tmp->Sobrenome := aRet[1,_nR,cSobrenome]
		tmp->UID     := right(strzero(val(aRet[1,_nR,cUID]),10),9)
		tmp->Parc    := left(strzero(val(aRet[1,_nR,cUID]),10),1)
		tmp->Munic	 := aRet[1,_nR,cMunic]
		tmp->CEP	 := aRet[1,_nR,cCEP]
		tmp->Tel     := aRet[1,_nR,cTel]
		tmp->Email   := aRet[1,_nR,cEmail]
		//		tmp->Titular := aRet[1,_nR,cTitular]
		tmp->CPF     := aRet[1,_nR,cCPF]
		tmp->Banco   := aRet[1,_nR,cBanco]
		tmp->Agencia := aRet[1,_nR,cAgencia]
		tmp->Conta   := aRet[1,_nR,cConta]
		tmp->Digito  := aRet[1,_nR,cDigito]
		if at(",",aRet[1,_nR,cValor])<>0
			tmp->Valor   := val(aRet[1,_nR,cValor])+val(substr(aRet[1,_nR,cValor],at(",",aRet[1,_nR,cValor])+1,2))/100 //val(aRet[1,_nR,cValor])
		else
			tmp->Valor   := val(aRet[1,_nR,cValor])
		endif
		MsUnLock()
		//		copy to \x
	Next _nR
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fconvArqs ºAutor  ³Luiz Eduardo       º Data ³ 06/03/2017   º±±
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

//if MsgBox ("Processo 2","Escolha","YESNO")
//	x:=1
//endif

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
//	cFile    := cOrigem+cNomeXLS+cExtensao
	cFile    := cOrigem+cNomeXLS+".csv"
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
Local aDados1 := {}
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
	aAdd(aDados , &cLinha)
	aAdd(aDados1, cLinha)
	
	//passa para a próxima linha
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


User Function fXGetArq

Local cMask		:="*.*"
Local cArqAt   	:= cGetFile(cMask, '')
Local cFileEDI	:= RIGHT(cArqAt,  LEN(cArqAt) -RAT("\", cArqAt))
Local cCamEDI	:= left(cArqAt,RAT("\", cArqAt))
cFileEDI:=LEFT(cFileEDI,  RAT(".", cFileEDI)-1)
cArq:=cFileEDI
cOrigem:=cCamEDI
//if MsgBox ("Processo 4","Escolha","YESNO")
//	x:=1
//endif

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

*************************
Static Function	CadForn()
*************************

If 1==2 .AND. Empty(TRIM(tmp->Nome)+" "+trim(tmp->sobrenome)) .Or. Empty(tmp->cpf) .Or. Empty(tmp->banco) .Or. Empty(tmp->conta) .Or. "."$tmp->cpf .Or. "-"$tmp->cpf
	// Aviso("Atencao!", "Existem campos obrigatórios em branco. Por favor preenche-los!" ,{"Ok"},1)
	if "."$tmp->cpf .Or. "-"$tmp->cpf
		cObs := "O campo CPF só poderá conter números "
	else
		cObs := "Campo(s) não preenchido(s)"
	endif
	if Empty(TRIM(tmp->Nome)+" "+trim(tmp->sobrenome))
		cObs += " Nome"
	endif
	if Empty(tmp->cpf)
		cObs += " CPF"
	endif
	if Empty(tmp->banco)
		cObs += " Banco"
	endif
	if Empty(tmp->conta)
	endif
	RecLock("ERRMSG",.t.)
	ERRMSG->DATAERRO := dtoc(dDataBase)
	ERRMSG->USUARIO  := substr(cUsuario,7,15)
	ERRMSG->MENSAGEM := cObs
	ERRMSG->PULSEIRA := alltrim(tmp->uid)
	MsUnLock()
Else
	if sa2->(eof())      // Verifica próxima numeração começamdo com W
		Select SA2
		dbSetOrder(1)
		_cLojFor	:= "01"
		seek xFilial()+"Z"
		skip-1
		do while .t.
			if left(sa2->a2_cod,1)<>'W' .or. sa2->a2_cod='WO51ST'
				skip-1
			endif
			exit
		enddo
		cNum := val(substr(sa2->a2_cod,2,5))+1
		seek xFilial()+"W"+strzero(cNum,5)
		_cCodFor	:= "W"+strzero(cNum,5)
	else
		_cLojFor	:= sa2->a2_loja
		_cCodFor	:= sa2->a2_cod
	endif
	_cCContab	:= PadR("2101010002",TAMSX3("A2_CONTA")[1])
	
	
	If RecLock("SA2", eof())
		SA2->A2_FILIAL	:= xFilial("SA2")
		SA2->A2_TIPO	:= "F"
		SA2->A2_SBTIPO	:= "1"
		SA2->A2_COD		:= _cCodFor
		SA2->A2_LOJA	:= _cLojFor
		SA2->A2_NOME	:= upper(ALLTRIM(tmp->Nome)+" "+ALLtrim(tmp->sobrenome))
		SA2->A2_NREDUZ	:= upper(ALLTRIM(tmp->Nome)+" "+ALLtrim(tmp->sobrenome))
		SA2->A2_TEL		:= upper(ALLTRIM(tmp->tel))
		SA2->A2_EMAIL	:= upper(ALLTRIM(tmp->email))
		//		SA2->A2_EST		:= ""//tmp->Estado
		//		SA2->A2_MUN		:= ""//tmp->Municipio
		SA2->A2_CEP		:= upper(tmp->cep)
		SA2->A2_MUN		:= upper(tmp->munic)
		SA2->A2_RECISS	:= 'S'
		SA2->A2_SIMPNAC	:= 'N'
		SA2->A2_CGC		:= cCpf
		SA2->A2_BANCO	:= tmp->Banco
		SA2->A2_AGENCIA	:= tmp->Agencia
		SA2->A2_NUMCON	:= alltrim(tmp->Conta)
		SA2->A2_DVCONTA := alltrim(tmp->Digito)
		SA2->A2_CONTA	:= _cCContab
		//	SA2->A2_MSBLQL	:= SubStr(_cBloq,1,1)
		SA2->(MsUnlock())
	EndIf
EndIf

Return

*************************
Static Function	GravaSE2()
*************************

REClOCK("SE2",.T.)
SE2->E2_FILIAL := xFilial("SE2")
SE2->E2_PREFIXO :='LOL'
SE2->E2_NUM :=alltrim(tmp->uid)
SE2->E2_PARCELA :='2'
SE2->E2_TIPO:='DV'
SE2->E2_BCOPAG := tmp->Banco
SE2->E2_AGPAG := tmp->Agencia
SE2->E2_CTAPAG:=tmp->Conta
SE2->E2_NUMPC:='LOLLA'
SE2->E2_NUMSPA:=trim(tmp->uid)
SE2->E2_NATUREZ:='500501'
SE2->E2_FORNECE:=sa2->a2_cod
SE2->E2_LOJA :=sa2->a2_LOJA
SE2->E2_EMISSAO:= dDataBase
SE2->E2_VENCTO:=dDataBase+2
SE2->E2_VENCREA:= DataValida(dDataBase+2)
SE2->E2_VALOR :=tmp->Valor
SE2->E2_MOEDA:=1
SE2->E2_TXMOEDA:= 1
SE2->E2_CONTAD :='1104010007'
SE2->E2_CCUSTO :='03031109'
SE2->E2_ITEM :='PEIFF180323'
SE2->E2_APROVA := 'Rudney Rodrigues Filho'
SE2->E2_HIST :=sa2->(A2_COD+A2_LOJA)+' '+trim(tmp->uid)+' Reemb.Loll 2018'
SE2->E2_VLCRUZ:=tmp->valor
msunlock()

Static Function ImprimeErr()

Select ERRMSG
nTotReg := reccount()
if nTotReg =0
	return
endif
dbgotop()

//Cria o arquivo CSV
cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	+= "\Msg_erro" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
aCabec	:= {}
cLinhaCSV	:= ""


AAdd(aCabec,{'Data Erro','C','dataerro'})
AAdd(aCabec,{'usuario','C','usuario'})
AAdd(aCabec,{'Mensagem de erro','C','mensagem'})
AAdd(aCabec,{'Pulseira','C','pulseira'})

For i := 1 To Len(aCabec)
	cLinhaCSV += aCabec[i,1] + ";"
Next i
FWrite(nHdl,cLinhaCSV+ENTER)

ProcRegua(nTotReg)

Select ERRMSG

//Geracao do arquivo CSV
While ERRMSG->(!Eof())
	IncProc()
	cLinhaCSV := ""
	
	For i := 1 To Len(aCabec)
		If aCabec[i,2] == "C"
			cLinhaCSV += ERRMSG->&(aCabec[i,3])+";"
		ElseIf aCabec[i,2] == "D"
			cLinhaCSV += DToC(SToD(ERRMSG->&(aCabec[i,3])))+";"
		ElseIf aCabec[i,2] == "N"
			cLinhaCSV += Transform(ERRMSG->&(aCabec[i,3]),"@E 999,999,999.99")+";"
		EndIf
	Next i
	
	FWrite(nHdl,cLinhaCSV+ENTER)
	ERRMSG->(dbSkip())
EndDo

FClose(nHdl)
oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cFile)
oExcel:SetVisible(.T.)

dbSelectArea("ERRMSG")
DBCLOSEAREA()

//RestArea(aAreaSM0)

Return