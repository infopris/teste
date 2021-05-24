//#INCLUDE "FINA280.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Fina280	³ Autor ³ Paulo Boschetti		  ³ Data ³ 27/07/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Sele‡„o de titulos para Fatura a RECEBER						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fina280()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fina280L(nPosArotina)

PRIVATE aRotina := MenuDef()
PRIVATE cFatura		:=CRIAVAR("E1_NUM")
PRIVATE cCli		:=Space(6)
PRIVATE cLoja		:=Space(2)
PRIVATE cLojaFat	:=Space(2)
PRIVATE cPrefix		:=Space(3)
PRIVATE cCliFat		:=Space(6)
PRIVATE dVencto		:=Ctod(Space(8))
PRIVATE dDataDe		:=dDataBase
PRIVATE dDataAte	:=dDataBase
PRIVATE cNat		:=Space(10)
PRIVATE nTotAbat	:=0
PRIVATE nValorFat 	:=0
PRIVATE nValorF		:=0
PRIVATE nValor 		:=0
PRIVATE nVLCruz		:=0
PRIVATE nVARURV		:=0
PRIVATE nQtdTit		:=0
PRIVATE nValtot		:=0
PRIVATE aVenc,aGets[0]
PRIVATE nMoedFat	:=1
PRIVATE nVlrAtu 	:=0
PRIVATE aMark := {}
Private cRA := Space(30)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de baixas						        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := "Faturas a Receber"

Default nPosArotina := 0

AjustaSx1()

dbSelectArea("SE1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ACIONA A FUNCAO PERGUNTE									           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI280",.T.)})
Pergunte("AFI280",.F.)

If nPosArotina > 0
	dbSelectArea('SE1')
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a Fun‡„o de BROWSE									        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SE1",,"!E1_SALDO")
Endif

Set Key VK_F12 to

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados							        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE1")
dbSetOrder(1)   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ fA280Aut ³ Autor ³ Paulo Boschetti		³ Data ³ 27/07/93   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca‡„o dos titulos para emiss„o de fatura				     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa280Aut()												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fA280Aut(cAlias,cCampo,nOpcE)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL cArquivo
LOCAL nTotal	:= 0
LOCAL nHdlPrv	:= 0
LOCAL cPadrao	:= "595"
LOCAL lPadrao  := VerPadrao(cPadrao)
LOCAL nW 		:= 1
LOCAL dDatCont	:= dDatabase
LOCAL cIndex	:= ""
LOCAL nOpca 	:= 0
LOCAL oDlg, oDlg1,oDlg2
LOCAL oValor	:= 0
LOCAL oQtdTit 	:= 0
LOCAL oValorFat := 0
LOCAL cMarca	:= GetMark()
LOCAL aMoedas	:= {}
LOCAL cVar,nO
LOCAL OCbx, nRegE1
LOCAL lUsado	:= .F.
LOCAL aCampos 	:= {}
LOCAL aTam 		:= {}
LOCAL cAliasSE1 := "SE1"
Local lHead 	:= .F.
Local nValTotal := 0
Local cFatAnt 
Local oTimer
Local nTimeOut  := SuperGetMv("MV_FATOUT",,900)*1000 	// Estabelece 15 minutos para que o usuarios selecione os titulos a faturar
Local nTimeMsg  := SuperGetMv("MV_MSGTIME",,120)*1000 	// Estabelece 02 minutos para exibir a mensagem para o usuário
                                                      	// informando que a tela fechará automaticamente em XX minutos
Local cImpostos := ""
Local aChaveLbn := {}   
Local aSize 	:= {}        
Local oPanel
Local aBut280 := {{"PESQUISA",{||Fa280Pesq(oMark,cAlias,cAliasSe1)}, "Pesquisar","Pesquisar..(CTRL-P)"}}
Local oTipoFat
LOCAL cCond := Space(3)

#IFDEF TOP
	Local lFa280Qry := ExistBlock("FA280QRY")
	Local cQuery
	Local cQueryADD
	Local aStru		:= SE1->(DbStruct())
	Local nCt := 0
#ELSE
	Local nProxReg := 0 																		
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aMoedas := FDescMoed()  
dbSelectArea( cAlias )

PRIVATE oGet
PRIVATE aHeader := {}
PRIVATE aCols	:= {}
PRIVATE oValTot
PRIVATE nValTot := 0
PRIVATE nUsado := 0
PRIVATE nValCruz:= 0
PRIVATE nVarURV := 0
PRIVATE lInverte:= .F.
PRIVATE cTipo	:= Criavar ("E1_TIPOFAT")
PRIVATE cLote
PRIVATE nOrdSE1	:= 0
PUBLIC aVlCruz	:= {} // Deve ficar como public por causa do FINA290(GravaDp)
PRIVATE nVlrAtu :=0
PRIVATE lMsErroAuto := .F.
PRIVATE cCondicao := Space(3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o campo A1_CLIFAT est  em uso   					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder( 2 )
dbSeek("A1_CLIFAT")
lUsado := x3uso(X3_USADO)

dbGotop()
dbSeek("E1_PREFIXO")
cPictPref := AllTrim(X3_PICTURE)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont("FIN")

cPrefix  := SuperGetMv("MV_FATPREF",,Space(3))      

If Len(cPrefix) < 3
	cPrefix := cPrefix + Space(3-Len(cPrefix))
EndIf

cNat     := CRIAVAR("E1_NATUREZ")
dDataDe	 :=dDataBase
dDataAte :=dDataBase
nValorFat:=0

aTam	:=TamSX3("E1_CLIENTE")
cCli	:=Space(aTam[1])
cCliFat	:=Space(aTam[1])

aTam	:=TamSX3("E1_LOJA")
cLoja 	:=Space(aTam[1])
cLojaFat:=Space(aTam[1])

dbSelectArea(cAlias)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PONTO DE ENTRADA F280PRE                                      ³
//³ Este PE serve para inicializar dados para montagem da fatura  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("F280PRE")
	ExecBlock("F280PRE",.F.,.F.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe dados a serem digitados										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cVar := aMoedas[1]
aMark := {}

If lPanelfin
	oPanelDados := FinWindow:GetVisPanel()
	oPanelDados:FreeChildren()
	aDim := DLGinPANEL(oPanelDados)
	DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³ 
	//³ -------------------------------------------------------------- ³ 		
	//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
	//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
	//³ tracao e redivisao por 2 para a centralizacao. 					 ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	nEspLarg := (((DlgWidthPanel(oPanelDados)/2) - 218) /2)-4
	nEspLin  := 0			
Else   
  	nEspLarg := 0 
  	nEspLin  := 0  	
	DEFINE MSDIALOG oDlg FROM	22,9 TO 260,540 TITLE "Faturas a Receber" PIXEL  // 
Endif
oDlg:lMaximized := .F.
oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
oPanel:Align := CONTROL_ALIGN_ALLCLIENT    			

@ 004+nEspLin, 007+nEspLarg TO 036+nEspLin, 225+nEspLarg OF oPanel PIXEL
@ 038+nEspLin, 007+nEspLarg TO 070+nEspLin, 225+nEspLarg OF oPanel PIXEL
@ 072+nEspLin, 007+nEspLarg TO 104+nEspLin, 225+nEspLarg OF oPanel PIXEL


aTam := TamSx3("E1_NUM")
cFatura	:= Soma1( GetMv("MV_NUMFAT"),  aTam[1])
cFatura	+= Space(aTam[1] - Len(cFatura))

While !MayIUseCode( "SE1"+xFilial("SE1")+cFatura)  //verifica se esta na memoria, sendo usado
	// busca o proximo numero disponivel 
	cFatura := Soma1(cFatura)                                                                                                             	
EndDo
cFatAnt := cFatura

@ 020+nEspLin, 014+nEspLarg MSGET cPrefix	Picture cPictPref 						SIZE 10, 11 OF oPanel PIXEL
@ 020+nEspLin, 040+nEspLarg MSGET oTipoFat VAR cTipo	F3 "05"	Picture "@!" Valid FA280Tipo(@cTipo);
	SIZE 10, 11 OF oPanel Hasbutton PIXEL 
oTipoFat:cReadVar := "E1_TIPOFAT"			
@ 020+nEspLin, 074+nEspLarg MSGET cFatura	Valid !Empty(cFatura) .and. FA280NUM()	SIZE 43, 11 OF oPanel PIXEL
@ 020+nEspLin, 120+nEspLarg MSGET cNat		F3 "SED" Valid Fa280Nat()       		SIZE 55, 11 OF oPanel Hasbutton PIXEL
@ 020+nEspLin, 175+nEspLarg MSCOMBOBOX oCbx VAR cVar ITEMS aMoedas 					SIZE 46, 55 OF oPanel PIXEL
oCbx:cReadVar := "E1_MOEDA"
@ 054+nEspLin, 014+nEspLarg MSGET dDataDe	Valid !Empty(dDataDe)					SIZE 50, 11 OF oPanel Hasbutton PIXEL
@ 054+nEspLin, 068+nEspLarg MSGET dDataAte Valid !Empty(dDataAte) .and. ;
	dDataAte >= dDataDe .and. dDataAte <= dDataBase	 ;
	SIZE 50, 11 OF oPanel Hasbutton PIXEL
If cPaisLoc<>"CHI"
	@ 054+nEspLin, 120+nEspLarg MSGET nValorFat Picture "@E 9,999,999,999.99"  SIZE 65, 11 OF oPanel Hasbutton PIXEL
Else
	@ 054+nEspLin, 120+nEspLarg MSGET nValorFat Picture "@E 999,999,999,999"  SIZE 65, 11 OF oPanel Hasbutton PIXEL
Endif

If lUsado                                                            
	@ 085+nEspLin, 120+nEspLarg MSGET cCliFat F3 "SA1" Valid fa280cli(cCliFat)	SIZE 70,11 OF oPanel Hasbutton PIXEL
	@ 085+nEspLin, 192+nEspLarg MSGET cLojaFat	Picture "@!" Valid Fa280Cli(cClifat,cLojaFat) SIZE 10, 11 OF oPanel PIXEL
endIf
@ 010+nEspLin, 014+nEspLarg SAY "Prefixo"  SIZE 21, 7 OF oPanel PIXEL //
@ 010+nEspLin, 040+nEspLarg SAY "Tipo"  SIZE 12, 7 OF oPanel PIXEL //"Tipo"
@ 010+nEspLin, 068+nEspLarg SAY "Nr.Fatura"  SIZE 49, 7 OF oPanel PIXEL //
@ 010+nEspLin, 120+nEspLarg SAY "Natureza"  SIZE 28, 7 OF oPanel PIXEL //
@ 010+nEspLin, 175+nEspLarg SAY "Moeda"  SIZE 28, 7 OF oPanel PIXEL //

@ 044+nEspLin, 014+nEspLarg SAY "Emissao de" SIZE 32, 7 OF oPanel PIXEL //
@ 044+nEspLin, 068+nEspLarg SAY "Ate" SIZE 32, 7 OF oPanel PIXEL //
@ 044+nEspLin, 120+nEspLarg SAY "Valor da Fatura" SIZE 50, 7 OF oPanel PIXEL //
//Implementado para GE
if getMv('MV_ACATIVO')
	GeLoad()
	
	@ 075+nEspLin, 014+nEspLarg SAY 'RA'  SIZE 40, 7 OF oPanel PIXEL
	@ 085+nEspLin, 014+nEspLarg MSGET cRA F3 "JA2001" SIZE 70,11 OF oPanel PIXEL
	
	@ 075+nEspLin, 091+nEspLarg SAY "Cliente" SIZE 35, 7 OF oPanel PIXEL //
	@ 085+nEspLin, 091+nEspLarg MSGET cCli	F3 "SA1" Valid Fa280Cli(cCli) .And. Fa280Num() SIZE 65, 11 OF oPanel PIXEL
		
	@ 075+nEspLin, 165+nEspLarg SAY "Loja" SIZE 30, 7 OF oPanel PIXEL //
	@ 085+nEspLin, 165+nEspLarg MSGET cLoja	Picture "@!" Valid Fa280Cli(cCli,cLoja) SIZE 21, 11 OF oPanel PIXEL
Else
	@ 075+nEspLin, 014+nEspLarg SAY "Cliente" SIZE 35, 7 OF oPanel PIXEL //
	@ 075+nEspLin, 086+nEspLarg SAY "Loja" SIZE 30, 7 OF oPanel PIXEL //
    
	@ 085+nEspLin, 014+nEspLarg MSGET cCli	F3 "SA1" Valid Fa280Cli(cCli) .And. Fa280Num() SIZE 65, 11 OF oPanel Hasbutton PIXEL
	@ 085+nEspLin, 086+nEspLarg MSGET cLoja	Picture "@!" Valid Fa280Cli(cCli,cLoja) SIZE 21, 11 OF oPanel PIXEL
endif

If lUsado
	@ 075+nEspLin, 120+nEspLarg SAY "Cliente a Faturar"  SIZE 40, 7 OF oPanel PIXEL //
EndIf

If lPanelFin  //Chamado pelo Painel Financeiro			
	oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
	ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
	{||nOpca:=1,IF(FA280Tipo(@cTipo) .and. FA280NUM() .and. Fa280Ok(oDlg),oDlg:End(),nOpca:=0)},;
	{||nOpca:=0,oDlg:End()})
		
Else			
	DEFINE SBUTTON FROM 07, 230 TYPE 1 ACTION (nOpca:=1,IF(FA280Tipo(@cTipo) .and. FA280NUM() .and. Fa280Ok(oDlg),oDlg:End(),nOpca:=0)) ENABLE OF oPanel
	DEFINE SBUTTON FROM 19, 230 TYPE 2 ACTION oDlg:End() ENABLE OF oPanel	
	ACTIVATE MSDIALOG oDlg CENTERED
Endif
	
If nOpca == 0
	FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
	Return
EndIf

nMoedFat := Val(Substr(cVar,1,2))
cImpostos := Fa280VerImp(cNat)

#IFDEF TOP
	cAliasSE1 := "QRYSE1"
	cQuery := ""
	FOR nCt= 1 To Len(aStru)                 
		If aStru[nCt,2] <> "M"
			cQuery+= ","+Alltrim(aStru[nCt,1])
		Endif
   Next nCt
	cQuery := "SELECT "+SubStr(cQuery,2)
	cQuery +=         ","+"SE1.R_E_C_N_O_ RECNO "
	cQuery	+= "FROM "+RetSqlName("SE1")+ " SE1 "
	cQuery	+= "WHERE "
	cQuery 	+= "E1_FILIAL='"	+ xFilial("SE1") + "'"
	cQuery	+= " AND E1_MOEDA=" + Str(nMoedFat,2,0)
   cQuery 	+= " AND E1_CLIENTE='"	+ cCli + "'"
	IF mv_par01==1
	   cQuery +=" AND E1_LOJA='"+cLoja+"'"
	EndIf
	cQuery	+= " AND E1_EMISSAO>='"+DTOS(dDataDe) + "'"
	cQuery 	+= " AND E1_EMISSAO<='"+DTOS(dDataAte)+ "'"
	cQuery	+= " AND E1_SITUACA IN ('0','F','G')"			//Carteira, Carteira Protesto e Carteira Acordo
	cQuery	+= " AND E1_SALDO>0"
	cQuery	+= " AND E1_TIPO NOT IN "+FormatIN(MVRECANT+MVPROVIS,,3)
   // Filtra para nao exibir os tx's
	cQuery	+= " AND E1_TIPO NOT IN "+FormatIN(cImpostos,,3)
	cQuery	+= " AND E1_FATURA='"+Space(Len(SE1->E1_FATURA)) +"'"
	// Verifica integracao com PMS e nao permite FATURAR titulos que tenham solicitacoes
	// de transferencias em aberto.
	cQuery 	+= " AND E1_NUMSOL= ' '"
	//Template GEM - nao podem ser faturados os titulos do GEM
	If HasTemplate("LOT")
		cQuery+= " AND E1_NCONTR= ' '"
	EndIf
	cQuery	+= " AND D_E_L_E_T_ <> '*'"
	// Permite a inclusão de uma condicao adicional para a Query
	// Esta condicao obrigatoriamente devera ser tratada em um AND ()
	// para nao alterar as regras basicas da mesma.
	IF lFa280Qry
		cQueryADD := ExecBlock("FA280QRY",.F.,.F.)
		IF ValType(cQueryADD) == "C"
			cQuery += " AND (" + cQueryADD + ")"
		ENDIF
	ENDIF
	// Exclui o tipo da ordem para que os titulos sejam exibidos por ordem de 
	// prefixo+num+parcela. O tipo sera exibido conforme cadastrado, para que um titulo
	// de abatimento nao seja exibido antes do titulo principal.
	cQuery   += " ORDER BY " + SqlOrder(SubStr(SE1->(IndexKey(1)),1,At("E1_TIPO",SE1->(IndexKey(1)))-2)+"+RECNO")

	Aadd(aStru, {"RECNO","N",10,0})
	cArqTrab := CriaTrab(aStru,.T.) // Nome do arquivo temporario
	dbUseArea(.T.,__LocalDriver,cArqTrab,cAliasSe1,.F.)
	Processa({||SqlToTrb(cQuery, aStru, cAliasSe1)}) // Cria arquivo temporario
	IndRegua (cAliasSe1,cArqTrab,"E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA",,,"Selecionando Registros...")
	DbSetOrder(0) // Fica na ordem da query
#ELSE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria indice condicional												  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SE1")
	cIndex := CriaTrab(nil,.f.)
	// Exclui o tipo da ordem para que os titulos sejam exibidos por ordem de 
	// prefixo+num+parcela. O tipo sera exibido conforme cadastrado, para que um titulo
	// de abatimento nao seja exibido antes do titulo principal.
	cChave	:= SubStr(SE1->(IndexKey(1)),1,At("E1_TIPO",SE1->(IndexKey(1)))-2)
	IndRegua("SE1",cIndex,cChave,,Fa280ChecF("FINA280L",cImpostos),"Selecionando Registros...")   //
	nIndex := RetIndex(cAlias)
	dbSelectArea(cAlias)
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
#ENDIF

DbGoTop()

If BOF() .and. EOF()
	Help(" ",1,"RECNO")
	RetIndex("SE1")
	Set Filter to
	dbSetOrder(1)
	dbGoTop()
	#IFDEF TOP
		DbSelectArea(cAliasSe1)
		DbCloseArea()
	#ELSE
		FErase(cIndex+OrdBagExt())
	#ENDIF
	FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
	Return
EndIF

nOpcA := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com capos a serem mostrados na marcacao de titulos ³
//³ Utiliza os capos em uso do SE1 mais o E1_SALDO que apesar de   ³
//³ nao estar em uso deve ser mostrado na tela.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"E1_OK","","  ",""})
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(MsSeek(cAlias))
While SX3->(!EOF()) .And. (SX3->X3_ARQUIVO == cAlias)
	IF (X3USO(SX3->X3_USADO) .or. SX3->X3_CAMPO == "E1_SALDO  ") .AND. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT != "V"
		AADD(aCampos,{SX3->X3_CAMPO,"",X3Titulo(),SX3->X3_PICTURE})
	Endif
	SX3->(dbSkip())
Enddo

dbSelectArea(cAliasSe1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia integracao com Modulo SIGAPCO                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoInilan("000014")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marca os titulos ate o valor informado para a fatura 		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValor  := 0
nQtDTit := 0
If mv_par03 == 1
	Fa280Marca(cAliasSe1,cMarca,nValorFat,aChaveLbn)
Endif	

nValorF := nValorFat

aSize := MSADVSIZE()	

DEFINE MSDIALOG oDlg1 TITLE "Fatura a Receber" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL//
oTimer:= TTimer():New((nTimeOut-nTimeMsg),{|| MsgTimer(nTimeMsg,oDlg1) },oDlg1) // Ativa timer
oTimer:Activate()
oDlg1:lMaximized := .T.     

oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,40,40,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP

@ 0.2 , 00.3	To 2.5,17 OF oPanel
@ 008 , 005	SAY "Prefixo: "	+ cPrefix				FONT oDlg1:oFont PIXEL OF oPanel					//
@ 017 , 005	SAY "Numero: "	+ cFatura				FONT oDlg1:oFont PIXEL OF oPanel					//
@ 008 , 060	SAY "Natureza: "	+ Substr(cNat,1,10) 	FONT oDlg1:oFont PIXEL OF oPanel					//
@ 017 , 060	SAY "Moeda: "	+ AllTrim(Str(nMoedFat,2,0))	FONT oDlg1:oFont PIXEL OF oPanel		//

@ 0.2 , 17	To 2.5,39 OF oPanel
@ 008 , 150	Say "Valor Fatura" FONT oDlg1:oFont PIXEL OF oPanel		//
@ 008 , 200	Say "Valor Selecionado" FONT oDlg1:oFont PIXEL OF oPanel		//
@ 008 , 250	Say "Tit. Selec." FONT oDlg1:oFont PIXEL OF oPanel		//
if cPaisLoc<>"CHI"
	@ 017 , 150	Say oValorFat	VAR nValorF		Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel
	@ 017 , 200	Say oValor		VAR nValor		Picture "@E 999,999,999.99" FONT oDlg1:oFont PIXEL OF oPanel
else
	@ 017 , 150	Say oValorFat	VAR nValorF		Picture "@E 99,999,999,999" FONT oDlg1:oFont PIXEL OF oPanel
	@ 017 , 200	Say oValor		VAR nValor		Picture "@E 99,999,999,999" FONT oDlg1:oFont PIXEL OF oPanel
endif
@ 017 , 250	Say oQtdTit 	VAR nQtdTit 	Picture "@E 999,999,999"  FONT oDlg1:oFont PIXEL OF oPanel 

oMark :=MsSelect():New(cAliasSe1,"E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarca,{45,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight})
oMark:bMark := {||Fa280Exibe(cAliasSe1,cMarca,oValor,oQtdTit,oMark,@nValor)}
oMark:bAval	:= {||Fa280bAval(cAliasSe1,cMarca,oValor,oQtdTit,oMark,@nValor,,,aChaveLbn)}
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || FA280Inverte(cAliasSe1,cMarca,oValor,oQtdTit,.T.,oMark,@nValor,,,,aChaveLbn)}
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

If lPanelFin  //Chamado pelo Painel Financeiro			
	ACTIVATE MSDIALOG oDlg1 ON INIT FaMyBar(oDlg1,{|| nOpca := 1,;
	IIF(Fa280ValOK(),IF(Fa280Soma(),oDlg1:End(),;
	Iif(Fa280Val(oValorFat),nOpca:=0,nOpca:=0)),nOpca:=0)},;
								{|| nOpca := 2,oDlg1:End()},aBut280);
								VALID (oTimer:End(),.T.) CENTERED

Else	
	ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| nOpca := 1,;
	IIF(Fa280ValOK(),IF(Fa280Soma(),oDlg1:End(),;
	Iif(Fa280Val(oValorFat),nOpca:=0,nOpca:=0)),nOpca:=0)},;
								{|| nOpca := 2,oDlg1:End()},,aBut280);
								VALID (oTimer:End(),.T.) CENTERED
Endif
								
dbSelectArea("SE1")

If nOpcA == 1
	
		
	If !((ExistBlock("F280CON")))	
		
	aSize := MsAdvSize(,.F.,400)
	DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDLg2:lMaximized := .T.
	
	oPanel1 := TPanel():New(0,0,'',oDlg2, oDlg2:oFont, .T., .T.,, ,45,45,.T.,.T. )
	oPanel1:Align := CONTROL_ALIGN_TOP
	
	oPanel2 := TPanel():New(0,0,'',oDlg2, oDlg2:oFont, .T., .T.,, ,20,20,.T.,.T. )
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
		
		@	003,010 TO 040,125 OF oPanel1 Pixel
		@	003,127 TO 040,500 OF oPanel1 Pixel
		
		@	015,015 	Say "Condicao: " Of oPanel1 Pixel   //
		@	015,045	MSGET cCond F3 "SE4" Picture "!!!" Of oPanel1 Pixel Hasbutton Valid ExistCpo("SE4",cCond) .And.;
																			  Fa290Cond(cCond)		
		
		DEFINE SBUTTON FROM 015,085	TYPE 1 ACTION (If(!Empty(cCond) .And. ExistCpo("SE4",cCond) .And. Fa290Cond(cCond),;
																	nOpca:=F280SelFat(oDlg2,1,@cCond,@nValor,@nValTot,@aVenc,@cPrefix,@cFatura,@cTipo,dDatCont,oPanel2,oPanel1),;
																	nOpca:=0)) ENABLE OF oPanel1
		
		
		If lPanelFin  //Chamado pelo Painel Financeiro			
			ACTIVATE MSDIALOG oDlg2 ON INIT FaMyBar(oDlg2,;
														{||nOpca:=1,if( !Empty( cCond ) .And. Len(aCols) > 0 .AND. ExistCpo( "SE4", cCond ) .AND. Fa290Cond( cCond ) .AND. oGet:TudoOk(), oDlg2:End(), nOpca := 0 )},;
														{||oDlg2:End()})
																												
		Else	
			ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,;
														{||nOpca:=1,if( !Empty( cCond ) .And. Len(aCols) > 0 .AND. ExistCpo( "SE4", cCond ) .AND. Fa290Cond( cCond ) .AND. oGet:TudoOk(), oDlg2:End(), nOpca := 0 )},;
														{||oDlg2:End()})
      Endif				
		
		//ACTIVATE MSDIALOG oDlg2 CENTERED
														 
		cCondicao := If(nOpca=0,"   ",cCond)
		aVenc := Condicao(nValor,cCondicao,0)												 													 
														 
	Else	   	
		aVenc := Execblock("F280CON",.f.,.f.,{nValor,cCondicao,cMarca,cAliasSe1})		
	Endif  	
	
      
Else
	nOpca := 2
EndIf
	
If nOpcA == 1
	#IFNDEF TOP
		RetIndex("SE1")
		If !Empty(cIndex)
			fErase(cIndex+OrdBagExt())
		Endif	
	#ENDIF
	If Fa280Num(@cFatAnt) // Se nao existir o mesmo numero de fatura
		Begin Transaction	
			nTotAbat :=0
			dbSelectArea("SE1")
			nRegE1 := Nil
			nFirstE1 := NIL  // Esta variavel será utilizada no PE FA280 (Fortymil)
			For nW := 1 To Len(aMark)
				MsGoto(aMark[nW])
				cNumero		:=	SE1->E1_NUM
				cPrefixo		:=	SE1->E1_PREFIXO
				cParcela		:=	SE1->E1_PARCELA
				nRegE1		:=	aMark[nW]
				nFirstE1 := IIF(nFirstE1==Nil,aMark[nW],nFirstE1)
				FA280MonFa("SE1",xFilial("SE1"),cPrefixo,cNumero,cParcela,nRegE1,cFatura,cPrefix,cTipo,,,@cArquivo,@nTotal,@nHdlPrv)
				dbSelectArea("SE1")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000014","02","FINA280L")
			Next
			nValTotal := 0
			For nW:=1 To Len(aCols)
				If ! aCols[nW,8] // .F. == Ativo  .T. == Deletado
					cPrefix		:= aCols[nW][1]
					cParcela		:= aCols[nW][3]
					cTipo			:= aCols[nW][4]
					cVencmto		:= aCols[nW][5]
					nValDup		:= aCols[nW][6]
					nValCruz		:= xMoeda(aCols[nW,6],nMoedFat,1)
					cBanco		:= aCols[nW][7]
					
					//Gera fatura atraves da rotina automatica do Fina040 para que faca o recalculo 
					//e gere os abatimentos referente ao valor total titulos que serao selecionados;
					nValTotal	:= 0 
					nLen			:= Len(aCols)            
						
					IncProc("Incluindo a fatura...")
					If ! GdDeleted(nW) // .F. == Ativo  .T. == Deletado
						dbSelectArea("SA1")
						If Empty( cCliFat )
							MsSeek(xFilial("SA1")+cCli+cLoja)
						Else
							MsSeek(xFilial("SA1")+cCliFat+cLojaFat)
						Endif
						aTit := {}
						AADD(aTit , {"E1_FILIAL"	, xFilial("SE1")									, NIL})						
						AADD(aTit , {"E1_PREFIXO"	, cPrefix											, NIL})
						AADD(aTit , {"E1_NUM"    	, cFatura											, NIL})
						AADD(aTit , {"E1_PARCELA"	, cParcela											, NIL})
						AADD(aTit , {"E1_TIPO"   	, cTipo												, NIL})
						AADD(aTit , {"E1_NATUREZ"	, cNat												, NIL})
						AADD(aTit , {"E1_SITUACA"	, "0"													, NIL})
						AADD(aTit , {"E1_VENCTO" 	, cVencmto											, NIL})
						AADD(aTit , {"E1_VENCREA"	, DataValida(cVencmto,.T.)						, NIL})
						AADD(aTit , {"E1_VENCORI"	, DataValida(cVencmto,.T.)						, NIL})
						AADD(aTit , {"E1_EMISSAO"	, dDataBase											, NIL})
						AADD(aTit , {"E1_EMIS1"		, dDataBase											, NIL})
						AADD(aTit , {"E1_CLIENTE"	, IIF( Empty( cCliFat ), cCli, cCliFat )	, NIL})
						AADD(aTit , {"E1_LOJA"   	, IIF( Empty(cCliFat),cLoja,cLojaFat )		, NIL})
						AADD(aTit , {"E1_NOMCLI" 	, SA1->A1_NREDUZ									, NIL})
						AADD(aTit , {"E1_MOEDA"  	, nMoedFat											, NIL})
						AADD(aTit , {"E1_VALOR"  	, nValDup											, NIL})
						AADD(aTit , {"E1_SALDO"  	, nValDup											, NIL})
						AADD(aTit , {"E1_VLCRUZ" 	, xMoeda(nValDup,nMoedFat,1)					, NIL})
						AADD(aTit , {"E1_STATUS" 	, "A"													, NIL})
						AADD(aTit , {"E1_OCORREN"	, "01"												, NIL})
						AADD(aTit , {"E1_ORIGEM" , "FINA280"											, NIL})
						AADD(aTit , {"E1_FATURA" , "NOTFAT"												, NIL})
						AADD(aTit , {"E1_CREDIT"   ,  SE1->E1_CREDIT		   						    , NIL})
						AADD(aTit , {"E1_DEBITO"   ,  SE1->E1_DEBITO		   						    , NIL})
						AADD(aTit , {"E1_CCC"      ,  SE1->E1_CCC			   						    , NIL})
						AADD(aTit , {"E1_ITEMC"    ,  SE1->E1_ITEMC									    , NIL}) 
						AADD(aTit , {"E1_CLVLCR"   ,  SE1->E1_CLVLCR									, NIL})
						AADD(aTit , {"E1_CCD"      ,  SE1->E1_CCD			   						    , NIL})
						AADD(aTit , {"E1_ITEMD"    ,  SE1->E1_ITEMD									    , NIL}) 
						AADD(aTit , {"E1_CLVLDB"   ,  SE1->E1_CLVLDB									, NIL})
						if getMv('MV_ACATIVO')
							AADD(aTit , {"E1_NUMRA" , alltrim(cRA)								    	, NIL})
						endif

						//Ponto de entrada para adicionar mais campos antes da geração das novas faturas.
						If ExistBlock("A280GERF")
							ExecBlock("A280GERF",.F.,.F.,{cPrefix,cFatura,cParcela,cTipo,DTOC(cVencmto)})
						EndIf
						
						MSExecAuto({|x, y| FINA040(x, y)}, aTit, 3)

                     //Verifica se a gravacao ocorreu normalmente, e possibilita o uso do PE FA280
                     //para complementar a gravacao.
						If  lMsErroAuto
						    MOSTRAERRO() 
						    DisarmTransaction()
						Else
							If ExistBlock("FA280")
								ExecBlock("FA280",.f.,.f.,nRegE1)
							Endif
							
							IF lPadrao
								If nHdlPrv <= 0
									nHdlPrv:=HeadProva(cLote,"FINA280L",Substr(cUsuario,7,6),@cArquivo)
									lHead := .T.
								Endif
								nTotal+=DetProva(nHdlPrv,cPadrao,"FINA280L",cLote)
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							PcoDetLan("000014","01","FINA280L")
						EndIf
						dbSelectArea("SE1")
					Endif

					nValTotal += xMoeda(nValDup,nMoedFat,1)  // nValCruz
					dbSelectArea("SE1")
				Endif
			Next nW
			If nTotal > 0
				FA280ConFa(nValTotal,cPadrao,cArquivo,nHdlPrv,@nTotal)
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava no SX6 o numero da ultima fatura gerada. 						  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			GetMv("MV_NUMFAT")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cFatura
			msUnlock()
		End Transaction
		If ExistBlock("FA280GRV")
			ExecBlock("FA280GRV",.F.,.F.)
		Endif
	Endif
Endif


If !Empty(aChaveLbn)
	aEval(aChaveLbn, {|e| UnLockByName(e,.T.,.F.) } ) // Libera Lock
Endif

cFatura		:= CriaVar("E1_NUM")
cCli			:= Space(6)
cNat			:= Space(10)
cPrefix		:= Space(3)
cLoja 		:= Space(2)
dDataDe		:= dDatabase
dDataAte		:= dDataBase
nValorF		:= 0
nValorFat	:= 0
nValCruz 	:= 0
nVarURV		:= 0
nVlrAtu 	:= 0
aVlCruz		:= {}

#IFDEF TOP
	DbSelectArea(cAliasSe1)
	DbCloseArea()
#ELSE
	RetIndex("SE1")
	If !Empty(cIndex)
		fErase(cIndex+OrdBagExt())
	Endif	
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()

dbSelectArea("SE1")
Set Filter to
dbSetOrder( 1 )
dbSeek(xFilial())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza integracao com Modulo PCO                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000014")

Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ fa280num ³ Autor ³ Paulo Boschetti		³ Data ³ 27/07/93   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se ja  existe numero do titulo.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa280num()												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FuncTion fa280num(cFatAnterior)
Local lRet:=.T.
Local aArea 	:= GetArea()
Local aAreaSe1	:= SE1->(GetArea())

dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+cPrefix+cFatura)
	While !Eof() .and.SE1->E1_FILIAL == xFilial("SE1") .and. ;
		cPrefix+cFatura == SE1->(E1_PREFIXO+E1_NUM)
		If E1_TIPO == cTipo
			Help(" ",1,"A280EXIST")
			lRet:=.F.
			Exit
		Else
			dbSkip()
		Endif
	Enddo
Else
	If cFatura <> cFatAnterior
		FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()	aqui
	Endif	
	If	!MayIUseCode( "SE1"+xFilial("SE1")+cFatura)
		lRet:=.F.
	Endif	
Endif
SE1->(RestArea(aAreaSe1))
RestArea(aArea)
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ fa280nat ³ Autor ³ Paulo Boschetti		³ Data ³ 27/07/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica validade da natureza.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa280nat()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION FA280NAT(cNatAux)   
Local cAlias	 := Alias()
Local lRet		 := .T.    
Local lFIN280NAT := ExistBlock("FIN280NAT")
Local lValidBloq	:= SED->(FieldPos("ED_MSBLQL")) > 0

Default cNatAux  := ""

If Type("cNat") == "C"
	cNatAux := cNat
EndIf	  

dbSelectArea("SED")
IF !dbSeek(cFilial+cNatAux)
	Help(" ",1,"A280NAT")
	lRet:=.F.
Endif                  

If lRet .And. lValidBloq
	If SED->ED_MSBLQL == "1"
		Help(" ",1,"EDBLOCKED",,"Natureza bloqueada para novas movimentações",1,0)	 //
		lRet := .F.
	Endif
EndIf

If lRet .And. lFIN280NAT
	lRet := ExecBlock("FIN280NAT")
Endif

dbSelectArea(cAlias)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o     ³ fa280Cli ³ Autor ³ Paulo Boschetti       ³ Data ³ 27/07/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o  ³ Verifica validade do Cliente                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³ fa280Cli()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ FINA280                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa280Cli(cCli280,cLoja280,dVencFat,nMaxFat,nQtdCtrc,lTms)
Local cAlias:=Alias()
Local nOldRec
Local aPerfil
Local aCondPagto := {}

DEFAULT lTms := .F.

cLoja280:=Iif(cLoja280 == Nil,"",cLoja280)

If Empty(cCli280)
	Return .F.                                        	
Endif

dbSelectArea("SA1")
dbSetOrder(1)
nOldRec := Recno()

IF !(MsSeek(xFilial("SA1")+cCli280+cLoja280))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nÆo encontrou o registro, retorna para o registro salvo pois, se a busca ³
	//³ estiver ocorrendo para o cliente a faturar e nÆo for encontrado, o SA1 fi - ³
	//³ car  desposicionado.																												³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbGoTo(nOldRec)
	Help(" ",1,"A280CLI")
	Return .F.
Endif

If lTms
	//-- Verifica se devera ser considerado a loja do cliente
	If ReadVar() == "_CLOJA" .Or. ReadVar() == "CCLI"
		// Calcula a data de vencto da fatura
		If Empty(dVencFat)
			aCondPagto := Condicao(1,SA1->A1_COND,0)
			If Len(aCondPagto) > 0 .And. ValType(aCondPagto[1][1]) == 'D'
				dVencFat := DataValida(aCondPagto[1][1],.T.)
			Else
				dVencFat := CriaVar('E1_VENCTO',.F.)
			EndIf
		EndIf
		If MV_PAR01 == 2
			aPerfil 	:= TmsPerfil(SA1->A1_COD,_cLoja)
		Else
			aPerfil 	:= TmsPerfil(SA1->A1_COD,SA1->A1_LOJA)
		EndIf
		
		If Len(aPerfil) > 0
			nMaxFat	:= If(Empty(nMaxFat), aPerfil[10], nMaxFat) // Valor maximo da fatura
			nQtdCtrc	:= If(Empty(nQtdCtrc), aPerfil[11], nQtdCtrc) // Qtde.CTRC por fatura
		Else
			nMaxFat := If(Empty(nMaxFat), 0, nMaxFat)
			nQtdCtrc := If(Empty(nQtdCtrc), 0, nQtdCtrc)
		Endif	
	EndIf
Endif

dbSelectArea(cAlias)

Return .T.


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GravaDp	³ Autor ³ Paulo Boschetti		³ Data ³ 12/11/93   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Formata Array com os desdobramentos dos titulos 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina280										  			              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaDp(nDup,cPrefixo,cNumero,nValor,dVencto,aVenc,cTipo,cPrograma)

LOCAL nValorTit := iif(cpaisLoc=="CHI",round((nValor/nDup),0),noround((nValor/nDup)))
LOCAL nValDup	:= nValor
Local nTamParcela := TamSx3("E1_PARCELA")[1]
Local cParcela := Padr(nTamParcela,nTamParcela)
Local cTmpParcela := Padr(nTamParcela,nTamParcela)
Local nPosPrefixo
Local nPosNum
Local nPosParcela
Local nPosTipo
Local nPosValor
Local nPosVenc
Local nPosReserv
Local nI := 0
Local nMaxParc := 1
Local i := 1
Local cParcSE1 := SuperGetMv("MV_1DUP")

DEFAULT cPrograma := "FINA280L"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da matriz aHeader																	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aHeader,{ "Prf" ,"E1_PREFIXO" ,"@!" 	  ,TamSx3("E1_PREFIXO")[1]+2,0,"","û","C","SE1" } ) //
If cPrograma = "FINA280L" // No fina281 o numero da fatura nao eh exibido
	AADD(aHeader,{ "Numero" ,"E1_NUM"     ,"@!"     ,TamSx3("E1_NUM")[1],0,"","û","C","SE1" } ) //
Endif	
AADD(aHeader,{ "Ord" ,"E1_PARCELA" ,PesqPict("SE1","E1_PARCELA"),TamSx3("E1_PARCELA")[1],0,"","û","C","SE1" } ) //
AADD(aHeader,{ "Tipo" ,"E1_TIPO"		,"@!"		  ,TamSx3("E1_TIPO")[1],0,"","û","C","SE1" } ) //
AADD(aHeader,{ "Vencimento" ,"E1_DTFATUR" ,"99/99/99",8  ,0,"fa280data()","û","D","SE1" } ) //
if cPaisLoc<>"CHI"
	AADD(aHeader,{ "Valor Duplicata" ,"E1_VLCRUZ"   ,"@E 9,999,999,999.99",14,2,"Fa280AtuVl(.T.)","û","N","SE1"}) //
else
	AADD(aHeader,{ "Valor Duplicata" ,"E1_VLCRUZ"   ,"@E 999,999,999,999",14,0,"Fa280AtuVl(.T.)","û","N","SE1"}) //
endif
AADD(aHeader,{ "Banco" ,"A6_COD"     ,"@!"      ,15,0,"","û","C","SA6" }) //

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava aCols com os valores das duplicatas				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aCOLS[nDup][If(cPrograma!="FINA281",8,7)]
// Varifica o tamnho da parcela
If nDup > 1
	//Verifica a validade do parametro
	If Len(GetMV("mv_1dup")) >= 1
		cTmpParcela := Substr(GetMV("mv_1dup"),Len(GetMV("mv_1dup"))+1-nTamParcela,nTamParcela)
	Else
		IW_MSGBOX("Número máximo de parcelas permitido " + Str(nMaxParc,2) + CHR(13)+ ;  //
					 "Número de parcelas da condição de pagto. " + Str(nDup,4) + CHR(13)+; //
					 "Verifique parâmetro MV_1DUP.", "Atenção","STOP") //###		
		Return {}
	EndIf
	// Se parcela tiver apenas um digito, ou o parametro tiver apenas um digito, verifica a quantidade maxima de parcelas
	If nTamParcela == 1 .Or. Len(AllTrim(GetMV("mv_1dup"))) == 1
		// Verifica a quantidade maxima de parcelas
		cParcela := cTmpParcela
		For i := 1 To 63
			cParcela:=Soma1( cParcela,, .T. )
			If AllTrim(cParcela) == "*"
				Exit
			Endif
		   nMaxParc++
		Next
		If nDup > nMaxParc
			IW_MSGBOX("Número máximo de parcelas permitido " + Str(nMaxParc,2) + CHR(13)+ ;  //
						 "Número de parcelas da condição de pagto. " + Str(nDup,4) + CHR(13)+; //
						 "Verifique parâmetro MV_1DUP.", "Atenção","STOP") //###
			Return {}
		Endif
	Endif
EndIf
nPosPrefixo	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_PREFIXO"} )
nPosNum		:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_NUM"} )
nPosParcela	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_PARCELA"} )
nPosTipo		:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_TIPO"} )
nPosValor	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_VLCRUZ"} )
nPosVenc		:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_DTFATUR"} )
nPosReserv	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "A6_COD"} )

FOR nI:=1 TO Len(aCols)
	nValorTit	:= aVenc[ni][2]
	cParcSE1 := Right("000"+cParcSE1,nTamParcela)		
	aCols[ni][nPosPrefixo]	:= cPrefixo
	If nPosNum > 0
		aCols[ni][nPosNum]	:= cNumero
	Endif	
	aCols[ni][nPosParcela]	:= cParcSE1
	aCols[ni][nPosTipo]		:= cTipo
	aCols[ni][nPosVenc]		:= aVenc[ni][1]
	aCols[ni][nPosValor]		:= IIf(nI<nDup,nValorTit,nValDup)
	aCols[ni][nPosReserv]	:= Space(15)
	aCols[ni][Len(aCols[1])]:= .F.
	cParcSE1 := Soma1(cParcSE1,nTamParcela,.T.)
	nValDup-=nValortit
NEXT
Return(aCols)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa280ChecF³ Autor ³ Valter G. Nogueira Jr.³ Data ³ 14/03/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Sele‡„o para a cria‡„o do indice condicional 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280ChecF(cPrograma,cImpostos)
LOCAL cFiltro 		:= ""
LOCAL cFiltroAdd	:= ""
Local cFilDeb		:= SuperGetMv("MV_FATFIL",,"")

Default cPrograma := "FINA280L"
Default cImpostos := Fa280VerImp(cNat)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATENCAO !!!!                                               ³
//³ N„o adiconar mais nada a chave do filtro pois a mesma est  ³
//³ com 254 caracteres. Nao trocar os <> por !$ pois no SQL    ³
//³ o processamento fica uma carro‡a.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPrograma = "FINA281"
	If !Empty(cFilDeb)
		cFiltro += 'E1_FILIAL$"'	+ cFilDeb						+ '".And.'
	Else
		cFiltro += 'E1_FILIAL="'	+ xFilial("SE1")         	+ '".And.'	
	Endif	
Else
	cFiltro += 'E1_FILIAL="'	+ xFilial("SE1")         	+ '".And.'
Endif	
cFiltro += 'E1_MOEDA='  + AllTrim(Str(nMoedFat,2,0)) + '.And.'
cFiltro += 'E1_CLIENTE=="'+ cCli                       + '".And.'
IF mv_par01==1
	cFiltro += 'E1_LOJA=="'+cLoja+'".And.'
EndIf
cFiltro += 'DTOS(E1_EMISSAO)>="' +DTOS(dDataDe)        + '".And.'
cFiltro += 'DTOS(E1_EMISSAO)<="' +DTOS(dDataAte)       + '".And.'
cFiltro += 'E1_SITUACA$"0FG".And.'
cFiltro += 'E1_SALDO>0.And.'
IF cPaisLoc<>"CHI"
	cFiltro += '!(E1_TIPO$"'+MVRECANT+"/"+MVPROVIS+'").And.'
	cFiltro += '!(E1_TIPO$"'+cImpostos+'").And.'
	cFiltro += 'E1_FATURA=="' +Space(Len(E1_FATURA)) +'"'
Else
	cFiltro += 'E1_TIPO$"'+MVRECANT+"/"+MVPROVIS+'")'
Endif
// Verifica integracao com PMS e nao permite FATURAR titulos que tenham solicitacoes
// de transferencias em aberto.
cFiltro += ' .And. Empty(E1_NUMSOL)'
//Template GEM - nao podem ser faturados os titulos do GEM
If HasTemplate("LOT")
	cFiltro += ' .And. Empty(E1_NCONTR)'
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acrescentado Ponto de Entrada p/ Comollati - Vers„o SQL    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("FA280FIL")
	cFiltroADD := ExecBlock("FA280FIL",.F.,.F.,cFiltro)
	If !Empty(cFiltroAdd)
		cFiltro := cFiltroAdd
	Endif
Endif

Return cFiltro

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA280CAN   ³ Autor ³ Cesar C S Prado		  ³ Data ³ 27/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cancelamento de fatura										³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280CAN()													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION FA280CAN(cAlias,cCampo,nOpcE)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL cArquivo
LOCAL nTotal	:=0
LOCAL nHdlPrv	:=0
LOCAL nTitulos	:=0
LOCAL nFaturas	:=0
Local	lPadrao527 := (mv_par05 == 1 .and. VerPadrao("527"))
LOCAL lPadrao
LOCAL cPadrao 	:="592"
LOCAL oDlg
LOCAL nOpca 	:= 0
LOCAL nValor	:= 0
LOCAL cNewFat	:= " "
LOCAL l280CalCn := .F.
LOCAL cChaveSe1 :=""
Local lHead 	:= .F.
Local nValTotal := 0
Local nRecSe1	:= 0
Local aAreaSa1	:= SA1->(GetArea())
Local lRet := .T.
Local lAcreDecre := .F.
Local	nAcresc := 0
Local nDecresc := 0
Local dBaixa := CTOD("//")
Local nAbatim := 0  
Local cChave  := ""
Local aArea:= {}
Local aRecDel := {}
//verifica se existem os campos de valores de acrescimo e decrescimo no SE5
If SE5->(FieldPos("E5_VLACRES")) > 0 .and. SE5->(FieldPos("E5_VLDECRE")) > 0
	lAcreDecre := .T.
Endif

PRIVATE cIndex	:=""
PRIVATE cPrefCan:= CriaVar("E1_PREFIXO", .F.)
PRIVATE cFatCan	:= CriaVar("E1_NUM")
PRIVATE cTipoCan:= CriaVar("E1_TIPOFAT")
PRIVATE cLote
PRIVATE oValCan
PRIVATE oQtdCan

// Efetua abertura do __SE1 (espelho do SE1) para deletar os abatimentos do titulo
// principal que não foram selecionados no filtro.
SomaAbat("","","","R")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont("FIN")

dbSelectArea("SE1")
cPrefCan	:= SE1->E1_PREFIXO
cFatCan		:= SE1->E1_NUM
cTipoCan	:= SE1->E1_TIPO
nValor		:= 0
nTitulos	:= 0
nFaturas	:= 0
VALOR := 0

FA280CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l280CalCn,.F.)

aSize := MSADVSIZE()
If lPanelFin //Chamado pelo Painel Financeiro			
	oPanelDados := FinWindow:GetVisPanel()
	oPanelDados:FreeChildren()
	aDim := DLGinPANEL(oPanelDados)
	DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )							
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³ 
	//³ -------------------------------------------------------------- ³ 		
	//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
	//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
	//³ tracao e redivisao por 2 para a centralizacao. 					 ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 115) /2		 					
	nEspLin  := 0		
	
Else   
  	nEspLarg := 0 
  	nEspLin  := 0
	DEFINE MSDIALOG oDlg FROM	20,1 TO 181,340 TITLE "Cancelamento de Fatura a Receber" PIXEL //
Endif	
oDlg:lMaximized := .F.
oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		


@ 006+nEspLin, 011+nEspLarg TO 034+nEspLin, 126+nEspLarg OF oPanel PIXEL
@ 039+nEspLin, 011+nEspLarg TO 070+nEspLin, 126+nEspLarg OF oPanel PIXEL
@ 021+nEspLin, 014+nEspLarg MSGET cPrefCan 						SIZE 21, 08 OF oPanel PIXEL
@ 021+nEspLin, 040+nEspLarg MSGET cTipoCan		F3 "05" Picture "@!" SIZE 12, 08 OF oPanel Hasbutton PIXEL ;
		Valid !Empty (cTipoCan) .and. FA280Tipo(cTipoCan)

@ 021+nEspLin, 073+nEspLarg MSGET cFatCan Valid !Empty(cFatCan) .and. ;
	FA280CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l280CalCn,.T.) ;
	SIZE 49, 08 OF oPanel PIXEL

@ 056+nEspLin, 014+nEspLarg MSGET nTitulos When .F. SIZE 28, 08 OF oPanel PIXEL
@ 056+nEspLin, 058+nEspLarg MSGET nValor When .F. Picture "@E 9,999,999,999.99" SIZE 63, 08 OF oPanel PIXEL
@ 011+nEspLin, 014+nEspLarg SAY "Prefixo" SIZE 21, 07 OF oPanel PIXEL //
@ 011+nEspLin, 040+nEspLarg SAY "Tipo" SIZE 12, 07 OF oPanel PIXEL //
@ 011+nEspLin, 073+nEspLarg SAY "Numero Titulo" SIZE 49, 07 OF oPanel PIXEL //
@ 046+nEspLin, 014+nEspLarg SAY "Total Notas" SIZE 35, 07 OF oPanel PIXEL //
@ 046+nEspLin, 058+nEspLarg SAY "Valor da Fatura" SIZE 53, 07 OF oPanel PIXEL //


If lPanelFin //Chamado pelo Painel Financeiro					
	oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
	ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
	{||nOpca:=1,IF(IF(l280CalCn,.T.,Fa280CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l280CalCn,.T.)),oDlg:End(),nOpca:=0)},;
	{||oDlg:End()})
Else	
	DEFINE SBUTTON FROM 10, 133 TYPE 1 ACTION (nOpca:=1,;
		IF(IF(l280CalCn,.T.,Fa280CalCn(@nTitulos,@nValor,cAlias,@nFaturas,@l280CalCn,.T.)),;
		oDlg:End(),nOpca:=0)) ENABLE OF oPanel
	DEFINE SBUTTON FROM 23, 133 TYPE 2 ACTION oDlg:End() ENABLE OF oPanel	
	ACTIVATE MSDIALOG oDlg CENTERED
Endif
	
If nOpca == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PONTO DE ENTRADA F280PCAN                                     ³
	//³ Este PE serve para permitir ou não o cancelamento da fatura   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("F280PCAN")
		lRet := ExecBlock("F280PCAN",.F.,.F.)
	Endif		

	aRecDel := {}

	If lRet
		// O indice temporario foi montado anteriormente
		dbGoTop()
		nValTotal := 0
		While !Eof() .And. SE1->E1_FILIAL == cFilial
			
			dbSkip()
			nRecSe1 := RecNo()
			dbSkip(-1)
			
			If SE1->E1_FATURA == cFatCan .and. SE1->E1_TIPOFAT == cTipoCan
				cChaveSe1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
				nAcresc := 0
				nDecresc := 0
				dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+cChaveSE1)
					While !Eof() .and. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cChaveSE1
						If SE5->E5_MOTBX== "FAT" .and. SE5->E5_RECPAG == "R"
							If lAcreDecre
								nAcresc += SE5->E5_VLACRES
								nDecresc += SE5->E5_VLDECRE
								dBaixa := SE5->E5_DATA
							Endif

							//Gravo dados utilizados pela contabilizacao e estorno da baixa por fatura
							RecLock("SE1")
							SE1->E1_VALLIQ  := SE5->E5_VALOR
							SE1->E1_DESCONT := SE5->E5_VLDESCO
							SE1->E1_MULTA   := SE5->E5_VLMULTA
							SE1->E1_JUROS   := SE5->E5_VLJUROS
							SE1->E1_CORREC  := SE5->E5_VLCORRE
							MSUnlock()						

							//Contabiliza cancelamento da baixa dos titulos geradores da fatura
							IF lPadrao527 .and. SE5->E5_LA = "S "
								If nHdlPrv <= 0
									nHdlPrv:=HeadProva(cLote,"FINA280L",Substr(cUsuario,7,6),@cArquivo)
								Endif
								nTotal+=DetProva(nHdlPrv,"527","FINA280L",cLote)
							Endif			

							//Excluo registro da baixa da geracao da fatura
							RecLock("SE5")
							dbDelete()
							MsUnlock()
						Endif
						dbSkip()
					Enddo
				Endif
				
				// Se a pergunta "Considera lojas" for igual a nao, deve-se atualizar o saldo das 
				// duplicadas das diferentes lojas
				If mv_par01 == 2
					SA1->(MsSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))
					SA1->(AtuSalDup("+",SE1->E1_VALLIQ,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO))
					SA1->(RestArea(aAreaSa1))
				Endif	
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se for um titulo que gerou a fatura, desfaz o processo		³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nAbatim := If( ! SE1->E1_TIPO$MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT,SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA),0)
				dbSelectArea("SE1")
				If !(SE1->E1_TIPO $ MVABATIM)
					RecLock("SE1")
					SE1->E1_SALDO		+= SE1->E1_VALLIQ - SE1->E1_JUROS + SE1->E1_DESCONT + nAbatim
					SE1->E1_MOVIMEN	:= dDataBase
					//Adiciona o Recno() dos tíulos para depois zerar os campos que fazem parte do filtro,
					//devido a problemas que ocorrem com ambiente AS400 e CTREE/LINUX.
					If Ascan(aRecDel, SE1->(Recno())) == 0
						AAdd(aRecDel, SE1->(Recno()))
					Endif	
					SE1->E1_DTFATUR	:= CtoD("  /  /  ")
					SE1->E1_STATUS 	:= Iif(SE1->E1_SALDO>0.01,"A","B")
					SE1->E1_JUROS		:= 0
					SE1->E1_DESCONT	:= 0
					SE1->E1_VALLIQ		:= 0
					SE1->E1_CORREC := 	0
					If SE1->E1_SALDO == SE1->E1_VALOR
						SE1->E1_BAIXA		:= CtoD("  /  /  ")
						SE1->E1_SDACRES	:= SE1->E1_ACRESC
						SE1->E1_SDDECRE	:= SE1->E1_DECRESC
					ElseIf lAcreDecre
						SE1->E1_SDACRES	:= Round(NoRound(xMoeda(SE1->E1_ACRESC,1,SE1->E1_MOEDA,dBaixa,3),3),2)
						SE1->E1_SDDECRE	:= Round(NoRound(xMoeda(SE1->E1_DECRESC,1,SE1->E1_MOEDA,dBaixa,3),3),2)
					Endif
					SE1->E1_FLAGFAT   := Space(Len(SE1->E1_FLAGFAT))
					MsUnlock()    
					
					//Volto saldo dos abatimentos do titulo principal.
					If nAbatim > 0
						dbSelectArea("__SE1")
						DbSetOrder(2)
			
						If dbSeek(xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA))
							cTitAnt := __SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
							While __SE1->(!Eof()) .and. cTitAnt == __SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
								If !__SE1->E1_TIPO $ MVABATIM
									dbSkip()
									Loop
								Endif
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Volta t¡tulo para carteira                                       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								Reclock("__SE1")
								__SE1->E1_BAIXA   := CtoD("  /  /  ")
								__SE1->E1_SALDO   := __SE1->E1_VALOR
								__SE1->E1_FATURA 	:= " "
								__SE1->E1_FATPREF	:= " "
								__SE1->E1_TIPOFAT	:= " "
								__SE1->E1_DTFATUR	:= CtoD("  /  /  ")
								__SE1->E1_VALLIQ  := 0
								__SE1->E1_STATUS  := "A"
								__SE1->E1_MOVIMEN := Ctod("  /  /  ")
								MsUnlock()
	
								dbSkip()
							EndDo
						Endif
				   Endif
				Endif
				dbSelectArea("SE1")
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Integracao Modulo de Transporte (TMS).                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                         
				If IntTms()
					dbSelectArea("DT6")
					DT6->(dbSetOrder(1))
					If MsSeek(xFilial("DT6")+SE1->E1_MSFIL+SE1->E1_NUM+SE1->E1_SERIE)
						Reclock("DT6",.F.)
						DT6->DT6_FATURA := Space(TamSx3("DT6_FATURA")[1])
						MsUnlock()
					EndIf
				EndIf
			Else
				nReg:=RecNo()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se for uma parcela da fatura contabiliza o canceel. e deleta	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lPadrao:=VerPadrao(cPadrao)
				If lPadrao
					If !lHead
						nHdlPrv:=HeadProva(cLote,"FINA280L",Substr(cUsuario,7,6),@cArquivo)
						lHead := .T.
					Endif
					nTotal+=DetProva(nHdlPrv,cPadrao,"FINA280L",cLote)
				Endif
				dbSelectArea("SE1")
				nReg:=IIf(RecNo() != nReg, dbGoTo(nReg), nReg)
				nValTotal += SE1->E1_VLCRUZ
				
				// Se a pergunta "Considera lojas" for igual a nao, deve-se atualizar o saldo das 
				// duplicadas das diferentes lojas
				If mv_par01 == 2
					SA1->(MsSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))
					SA1->(AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO))
					SA1->(RestArea(aAreaSa1))
				Endif	
                       
				// Apaga os registros agregados ao titulo (fatura) principal.
				If !( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
				    aArea:=GetArea()
					cChave := xFilial("SE1") + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
					__SE1->(dbSetOrder(1))
					__SE1->(MsSeek(cChave))
					While __SE1->(!EOF()) .And. __SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == cChave
						If __SE1->E1_TIPO $ MVPIABT+"/"+MVCFABT+"/"+MVCSABT+"/"+MVABATIM+"/"+MVISABT   // AB-/IR-/IN-/IS-
							RecLock("__SE1" ,.F.)
							dbDelete()
							MsUnlock()
						EndIf
						__SE1->(dbSkip())
					Enddo
					__SE1->(dbSetOrder(1))
					RestArea(aArea)
				Endif
	
	         // Apaga o titulo principal (fatura) posicionado.
				RecLock("SE1",.F.,.T.)
				dbDelete()
				MsUnlock()
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PONTO DE ENTRADA F280CAN                                      ³
			//³ Este PE serve para grava‡äes complementares ap¢s cancelamento ³
			//³ do titulo na fatura.                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF ExistBlock("F280CAN")
				ExecBlock("F280CAN",.F.,.F.)
			Endif
			dbSelectArea("SE1")
			dbSkip()
		Enddo
		//Apaga registros gerados pela fatura, pois estes campos fazem parte do filtro e ocasionavam EOF no SE1
		//quando se utiliza os ambientes AS400 e CTREE/LINUX.
		aEval(aRecDel,{|n| dbGoto(n),;
							RecLock("SE1",.F.),;
							SE1->E1_FATURA 	:= " ",;
							SE1->E1_FATPREF	:= " ",;
							SE1->E1_TIPOFAT	:= " ",;
							MsUnlock() } )
		If nTotal > 0
			dbSelectArea("SE1")
			nRecSe1 := Recno()
			SE1->(DBGoBottom())
			SE1->(dbSkip())
			VALOR := nValTotal
			nTotal+=DetProva(nHdlPrv,cPadrao,"FINA280L",cLote)
			RodaProva(nHdlPrv,nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lancamento Contabil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita:=IIF(mv_par02==1,.T.,.F.)
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)
			VALOR := 0
			dbSelectArea("SE1")
			SE1->(DBGoTo(nRecSe1))
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Volta Ultimo Numero do Parametro de Fatura	07/12/95 	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNewFat := GetMV("MV_NUMFAT")
		IF alltrim(cNewFat) == alltrim(cFatCan)
			RecLock("SX6",.F.)
			Replace X6_CONTEUD with Tira1(cFatCan)
			MsUnlock()
		Endif
	Endif
	//
	//Função Específica do Modulo Sigapls para atualizar Status de Guias Compradas
	//
	If FindFunction("PL090TITCP")
		DBGoTop()
		While .T.
			PL090TITCP(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,"5")
			SE1->(dbSkip())
			If SE1->(EoF())
				Exit
			EndIf
		Enddo		
	EndIf		
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
Set Filter to
RetIndex(cAlias)
If !Empty(cIndex)
	fErase(cIndex+OrdBagExt())
	cIndex := ""
Endif
dbSetOrder(1)    
MsSeek(xFilial(cAlias))
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa280CAlCn  ³ Autor ³ Cesar C S Prado		  ³ Data ³ 27/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria o indice temporario para o cancelamento da fatura		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa280CalCn()													³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION FA280CALCN(nTitulos,nValor,cAlias,nFaturas,l280CalCn,lHelpCan)

Local lBanco := .F.

lHelpCan := IIF(lHelpCan == NIL, .T.,lHelpCan)
l280CalCn := .F.

If Empty(cFatCan)
	Help(" ",1,"INDVAZIO")
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria indice condicional separando os titulos que deram origem a fatura ³
//³ e as respectivas faturas que foram geradas								      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex := CriaTrab(nil,.f.)
cChave := IndexKey()
IndRegua("SE1",cIndex,cChave,,FA280FCAN(),"Selecionando Registros...")  //
nIndex := RetIndex(cAlias)
dbSelectArea(cAlias)
#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
dbGoTop()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Certifica se foram encontrados registros na condi‡„o selecionada 		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If BOF() .and. EOF()
	If lHelpCan
		Help(" ",1,"INDVAZIO")
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura os indices do SE1 e deleta o arquivo de trabalho				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	#IFDEF TOP
		Set Filter to
	#ELSE
		RetIndex(cAlias)
		fErase(cIndex+OrdBagExt())
		cIndex := ""
	#ENDIF
	dbSetOrder(1)
	Return .F.
Endif

dbSelectArea("SE1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso tenha ocorrido a baixa de alguma parcela da fatura, nao sera pos- ³
//³ sivel a opera‡„o de cancelamento.													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValor	 :=  0
lCancelar := .T.   
lBanco := .F.
While !Eof()
	If SE1->E1_NUM == cFatCan .And. Day(SE1->E1_BAIXA) > 0 .AND. ;
		SE1->E1_PREFIXO == cPrefCan .and. E1_TIPO == cTipoCan
		lCancelar:=.F.
	ElseIf !(SE1->E1_SITUACA $ "0FG")
		lBanco := .T.
	Else
		If !SE1->E1_TIPO $ MV_CRNEG+"/"+MVABATIM
			nValor += IIF(E1_SALDO == 0, E1_VALLIQ, 0)
		Endif
		nTitulos+= IIF(!Empty(E1_TIPOFAT), 1, 0)
	Endif
	dbSkip()
Enddo

If !lCancelar .or. lBanco
	dbSelectArea("SE1")
	#IFDEF TOP
		Set Filter to
	#ELSE
		RetIndex(cAlias)
		fErase(cIndex+OrdBagExt())
		cIndex := ""
	#ENDIF
	dbSetOrder(1)
	If lHelpCan
		If !lCancelar
			Help(" ",1,"FATJABX") // Nao aceita se ja houve baixa em fatura
		ElseIf lBanco
			Help(" ",1,"TITBCO",,"Esta fatura possui parcela transferida para banco. Retorne os titulos para carteira antes de cancelar a fatura",1,0) //
		Endif
	Endif
	Return .F.
Endif
l280CalCn := .T.
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA280FCan  ³ Autor ³ Cesar C S Prado		  ³ Data ³ 27/04/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Sele‡„o para a cria‡„o do indice condicional no CANCELAMENTO ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina280														³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280FCan()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devera selecionar todos os registros que atendam a seguinte condi‡„o : 	³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ 1. Prefixo e N£mero do Titulo iguais aos selecionados							³
//³ 2. Ou titulos que tenham originado a fatura selecionada 						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cFiltro
cFiltro := 'E1_FILIAL=="'+xFilial("SE1")+'".And.'
cFiltro += 'E1_FATURA <> "'+Space(Len(SE1->E1_FATURA))+'" .And.'
cFiltro += '((E1_NUM=="'+Pad(cFatCan,Len(E1_NUM)) +'".And.'
cFiltro += 'E1_PREFIXO=="'+cPrefCan+'".And.'
cFiltro += 'E1_FATURA=="'+Pad("NOTFAT",Len(E1_FATURA))+'".And.'
cFiltro += 'E1_TIPO=="'+cTipoCan+'").Or.'
cFiltro += '(E1_FATURA=="'+Pad(cFatCan,Len(E1_FATURA)) + '".And.'
cFiltro += 'E1_FATPREF=="'+cPrefCan+'".And.'
cFiltro += 'E1_TIPOFAT=="'+cTipoCan+'"))'
Return cFiltro

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ F280VLCRUZ ³ Autor ³ Cesar C S Prado		  ³ Data ³ 26/05/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta Array com o E?_VLCRUZ para o desdobramento de titulos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina280													    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F280VLCRUZ(nDup,nValor)

LOCAL i
LOCAL nValorTit := iif(cpaisLoc=="CHI",round((nValor/nDup),0),noround((nValor/nDup)))
LOCAL nValDup	:= nValor

For i:=1 TO nDup
	AAdd(aVlCruz,IIf(I<nDup,nValorTit,nValDup))
	nValDup-=nValortit
NEXT i

Return(aVlCruz)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280Ok	³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 07/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe mensagem de OK para dados digitados da fatura		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280OK()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280Ok(oDlg)
Local lRet := .T.
If ExistBlock("FA280OK")
	lRet := Execblock("FA280OK",.F.,.F.,oDlg)
Endif
Return (lRet .And. MsgYesNo("Confirma Dados?","Atenção")) //###"Aten‡„o"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa280Marca³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 21/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata o valor	para marcar e desmarcar item			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa280Marca(ExpN1,ExpD1,ExpD2) 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa280Marca(cAliasSe1,cMarca,nLimite,aChaveLbn)
LOCAL nRec
LOCAL cAliasAnt := Alias()
Local nValorFat
Local nRecSe1
Local lFa280Show := Existblock("FA280SHOW")
Local cChaveLbn
//Local lDescISS := IIF(SA1->A1_RECISS == "1" .And. GetNewPar("MV_DESCISS",.F.) .And. GetNewPar("MV_TPABISS", "1") == "1",.T.,.F.)
Local nJuros := 0

dbSelectArea(cAliasSe1)
nRec := Recno()
While !Eof()
	cChaveLbn := "FAT" + (cAliasSe1)->(xFilial("SE1")+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
	If LockByName(cChaveLbn,.T.,.F.)
		If RecLock(cAliasSe1) // Se conseguir travar o registro			
			nJuros := faJuros((cAliasSe1)->E1_VALOR,(cAliasSe1)->E1_SALDO,(cAliasSe1)->E1_VENCTO,(cAliasSe1)->E1_VALJUR,(cAliasSe1)->E1_PORCJUR,(cAliasSe1)->E1_MOEDA,(cAliasSe1)->E1_EMISSAO,dDataBase,If(cPaisLoc=="BRA",(cAliasSe1)->E1_TXMOEDA,0),,(cAliasSe1)->E1_VENCREA)
			nValorFat := If((cAliasSe1)->E1_TIPO$MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT,(cAliasSe1)->E1_VALOR + nJuros,(cAliasSe1)->(E1_SALDO+E1_SDACRES-E1_SDDECRE)+ nJuros)//+If( lDescISS,(cAliasSe1)->E1_ISS,0)
			
			If nValor <= nLimite .Or. Empty(nLimite)
				(cAliasSe1)->E1_OK := cMarca
				// Marcando
				#IFDEF TOP
					If (cAliasSe1)->(FieldPos("RECNO")) > 0
						nRecSe1 := (cAliasSe1)->RECNO
					Else
						nRecSe1 := (cAliasSe1)->(Recno())
					Endif	
				#ELSE	
					nRecSe1 := (cAliasSe1)->(Recno())
				#ENDIF
				If Ascan(aMark, nRecSe1) == 0
					Aadd(aMark,nRecSe1)
				Endif
				If Ascan(aChaveLbn, cChaveLbn) == 0
					Aadd(aChaveLbn,cChaveLbn)
				Endif
				If (cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MV_CRNEG+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
					nValor 	-= nValorFat
					nValCruz -= (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2)
					nVARURV 	-= (cAliasSe1)->E1_VARURV
					nVlrAtu 	-= (cAliasSe1)->E1_VLRREAL
					nQtdTit++
				Else
					nValor 	+= nValorFat
					nValCruz += (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2)
					nVARURV 	+= (cAliasSe1)->E1_VARURV
					nVlrAtu 	+= (cAliasSe1)->E1_VLRREAL
					nQtdTit++
				Endif
			Else
				(cAliasSe1)->E1_OK := "  "
			EndIf
			(cAliasSe1)->(MsUnlock())
			If lFa280Show 
	   	   ExecBlock("FA280SHOW",.f.,.f.,{cAliasSe1,.T.})
	      Endif
		Else
			UnlockByName(cChaveLbn, .T., .F.)
		Endif
	Endif	
	(cAliasSe1)->(dbSkip())
EndDo
(cAliasSe1)->(dbGoto(nRec))
dbSelectArea(cAliasAnt)
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280Exibe³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 07/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe Totais de titulos selecionados						  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280Exibe()												  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280Exibe(cAliasSe1,cMarca,oValor,oQtdTit,oMark,nValor,nTotExcluido,lExclui)
Local nValorFat := If((cAliasSe1)->E1_TIPO$MVABATIM+"/"+MVINABT+"/"+MVIRABT,(cAliasSe1)->E1_VALOR,(cAliasSe1)->(E1_SALDO+E1_SDACRES-E1_SDDECRE))
Local lFa280Show := Existblock("FA280SHOW")

DEFAULT nTotExcluido := 0
DEFAULT lExclui		:= .F.

if lFa280Show
   ExecBlock("FA280SHOW",.f.,.f.,{cAliasSe1,.F.})
Endif

If (cAliasSe1)->E1_OK == cMarca
	If (cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MV_CRNEG+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
		nValor 	:= If(lExclui,nValor + nValorFat,nValor - nValorFat)
		nValCruz := If(lExclui,	nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
										nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
		nVARURV 	:= If(lExclui,nVarUrv + (cAliasSe1)->E1_VARURV,nVarUrv - (cAliasSe1)->E1_VARURV)  
		nVlrAtu 	:= If(lExclui,nVlrAtu + (cAliasSe1)->E1_VLRREAL,nVlrAtu - (cAliasSe1)->E1_VLRREAL)  
		nQtdTit++
		nTotExcluido := nTotExcluido - If(lExclui,nValorFat,0)
	Else
		nValor 	:= If(lExclui,nValor - nValorFat,nValor + nValorFat)
		nValCruz := If(lExclui,	nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
										nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
		nVARURV 	:= If(lExclui,nVarUrv - (cAliasSe1)->E1_VARURV,nVarUrv + (cAliasSe1)->E1_VARURV)    
		nVlrAtu 	:= If(lExclui,nVlrAtu - (cAliasSe1)->E1_VLRREAL,nVlrAtu + (cAliasSe1)->E1_VLRREAL)  
		nQtdTit++
		nTotExcluido := nTotExcluido + If(lExclui,nValorFat,0)
	Endif
Else
	If (cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MV_CRNEG+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
		nValor 	:= If(lExclui,nValor - nValorFat,nValor + nValorFat)
		nValCruz := If(lExclui,	nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
										nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
		nVARURV 	:= If(lExclui,nVarUrv - (cAliasSe1)->E1_VARURV,nVarUrv + (cAliasSe1)->E1_VARURV)
		nVlrAtu 	:= If(lExclui,nVlrAtu - (cAliasSe1)->E1_VLRREAL,nVlrAtu + (cAliasSe1)->E1_VLRREAL)  
		nQtdTit--
		nTotExcluido := nTotExcluido + If(lExclui,nValorFat,0)
	Else
		nValor 	:= If(lExclui,nValor + nValorFat,nValor - nValorFat)
		nValCruz := If(lExclui,	nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
										nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
		nVARURV 	:= If(lExclui,nVarUrv + (cAliasSe1)->E1_VARURV,nVarUrv - (cAliasSe1)->E1_VARURV)
		nVlrAtu 	:= If(lExclui,nVlrAtu + (cAliasSe1)->E1_VLRREAL,nVlrAtu - (cAliasSe1)->E1_VLRREAL)  
		nQtdTit--
		nTotExcluido := nTotExcluido - If(lExclui,nValorFat,0)
	Endif
Endif

nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
oValor:Refresh()
oQtdTit:Refresh()

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA280Invert³ Autor ³ Wagner Xavier		    ³ Data ³ 09/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca / Desmarca titulos							  				    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fina280																		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa280Inverte( cAliasSe1,cMarca,oValor,oQtdTit,lTodos,oMark,nValor,;
							  nTotExcluido,lExclui,lRecursiva,aChaveLbn,cChaveLbn)
							  
Local nReg := (cAliasSe1)->(Recno())
Local cAlias := Alias()
Local nOrderSe1 := (cAliasSe1)->(IndexOrd())
Local nAscan
Local nValorFat
Local cTitAnt
Local bWhile 
Local nRecSe1
Local lFa280Show := Existblock("FA280SHOW")
Local lDescISS := IIF(SA1->A1_RECISS == "1" .And. GetNewPar("MV_DESCISS",.F.) .And. GetNewPar("MV_TPABISS", "1") == "1",.T.,.F.)

DEFAULT lTodos  := .T.
DEFAULT nTotExcluido := 0
DEFAULT lExclui := .F.
DEFAULT lRecursiva := .F.

If !lRecursiva .And. (cAliasSe1)->E1_TIPO $ MVABATIM+"/"+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
//	IW_MsgBox("Este é um título de abatimento, não pode ser marcado/desmarcado, posicione sobre o titulo principal para esta operação",STR0061,"STOP")
	IW_MsgBox("Este é um título de abatimento, não pode ser marcado/desmarcado, posicione sobre o titulo principal para esta operação","","STOP")
	Return
Endif

dbSelectArea(cAliasSe1)
#IFNDEF TOP
	If lTodos
		dbSeek(xFilial("SE1"))
		bWhile := {|| xFilial("SE1") == (cAliasSe1)->E1_FILIAL}
	Endif	
#ELSE
	If lTodos
		DbGoTop()
		bWhile := {||.T.}
	Endif	
#ENDIF	
While !lTodos .Or.;
		((cAliasSe1)->(!Eof()) .And. Eval(bWhile))

	If lFa280Show
  	  ExecBlock("FA280SHOW",.f.,.f.,{cAliasSe1,.F.})
   Endif

	#IFDEF TOP
		If (cAliasSe1)->(FieldPos("RECNO")) > 0
			DbSelectArea("SE1")
			MsGoto((cAliasSe1)->RECNO)
			DbSelectArea(cAliasSe1)
		Endif	
	#ENDIF
	
	nValorFat := If((cAliasSe1)->E1_TIPO$MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT .Or. lExclui,(cAliasSe1)->(E1_VALOR+E1_ACRESC-E1_DECRESC+E1_JUROS-E1_DESCONT),(cAliasSe1)->(E1_SALDO+E1_SDACRES-E1_SDDECRE)) + If( lDescISS,(cAliasSe1)->E1_ISS,0)
	
	If lTodos .Or. cChaveLbn == Nil
		cChaveLbn := "FAT" + SE1->(xFilial("SE1")+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
	Endif
	If (lTodos .And. LockByName(cChaveLbn,.T.,.F.)) .Or. !lTodos
		IF (cAliasSe1)->E1_OK == cMarca
			// Desmarcando
			#IFDEF TOP
				If (cAliasSe1)->(FieldPos("RECNO")) > 0
					nRecSe1 := (cAliasSe1)->RECNO
				Else
					nRecSe1 := (cAliasSe1)->(Recno())
				Endif	
			#ELSE	
				nRecSe1 := (cAliasSe1)->(Recno())
			#ENDIF
			nAscan := Ascan(aMark, nRecSe1)
			If nAscan > 0
				aDel(aMark,nAscan)
				aSize(aMark,Len(aMark)-1)
			Endif
			nAscan := Ascan(aChaveLbn, cChaveLbn )
			If nAscan > 0
				UnLockByName(aChaveLbn[nAscan],.T.,.F.) // Libera Lock
			Endif
			RecLock(cAliasSe1)
			(cAliasSe1)->E1_OK := "  "
			(cAliasSe1)->(MsUnlock())
			If (cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MV_CRNEG+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
				nValor 	:= If(lExclui,nValor-nValorFat,nValor + nValorFat)
				nValCruz := If(lExclui,	nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
												nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
				nVARURV 	:= If(lExclui,nVarUrv - (cAliasSe1)->E1_VARURV,nVarUrv + (cAliasSe1)->E1_VARURV)
				nVlrAtu 	:= If(lExclui,nVlrAtu - (cAliasSe1)->E1_VLRREAL,nVlrAtu + (cAliasSe1)->E1_VLRREAL)  
				nQtdTit--
				nTotExcluido := nTotExcluido + If(!lExclui,nValorFat,0)
			Else
				nValor 	:= If(lExclui,nValor + nValorFat,nValor - nValorFat)
				nValCruz := If(lExclui,	nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
												nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
				nVARURV 	:= If(lExclui,nVarUrv + (cAliasSe1)->E1_VARURV,nVarUrv - (cAliasSe1)->E1_VARURV)
				nVlrAtu 	:= If(lExclui,nVlrAtu + (cAliasSe1)->E1_VLRREAL,nVlrAtu - (cAliasSe1)->E1_VLRREAL)  
				nQtdTit--
				nTotExcluido := nTotExcluido - If(lExclui,nValorFat,0)
			Endif
		Else
			// Marcando
			#IFDEF TOP
				If (cAliasSe1)->(FieldPos("RECNO")) > 0
					nRecSe1 := (cAliasSe1)->RECNO
				Else
					nRecSe1 := (cAliasSe1)->(Recno())
				Endif	
			#ELSE	
				nRecSe1 := (cAliasSe1)->(Recno())
			#ENDIF
			If Ascan(aChaveLbn, cChaveLbn) == 0
				Aadd(aChaveLbn,cChaveLbn)
			Endif	
			If Ascan(aMark, nRecSe1) == 0
				Aadd(aMark,nRecSe1)
			Endif
			RecLock(cAliasSe1)
			(cAliasSe1)->E1_OK := cMarca
			(cAliasSe1)->(MsUnlock())
			If (cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MV_CRNEG+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
				nTotExcluido := nTotExcluido - nValorFat
				nValor 	:= If(lExclui,nValor+nValorFat,nValor - nValorFat)
				nValCruz := If(lExclui,	nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
												nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
				nVARURV 	:= If(lExclui,nVarUrv + (cAliasSe1)->E1_VARURV,nVarUrv - (cAliasSe1)->E1_VARURV)
				nVlrAtu 	:= If(lExclui,nVlrAtu + (cAliasSe1)->E1_VLRREAL,nVlrAtu - (cAliasSe1)->E1_VLRREAL)  
				nQtdTit  := If(lExclui,nQtdTit-1,nQtdTit+1)
			Else
				nTotExcluido := nTotExcluido + nValorFat
				nValor 	:= If(lExclui,nValor - nValorFat,nValor + nValorFat)
				nValCruz := If(lExclui,	nValCruz - (cAliasSe1)->E1_VLCRUZ-Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2),;
												nValCruz + (cAliasSe1)->E1_VLCRUZ+Round(NoRound(xMoeda(E1_SDACRES-E1_SDDECRE,E1_MOEDA,1,E1_EMISSAO,3),3),2))
				nVARURV 	:= If(lExclui,nVarUrv - (cAliasSe1)->E1_VARURV,nVarUrv + (cAliasSe1)->E1_VARURV)
				nVlrAtu 	:= If(lExclui,nVlrAtu - (cAliasSe1)->E1_VLRREAL,nVlrAtu + (cAliasSe1)->E1_VLRREAL)  
				nQtdTit  := If(lExclui,nQtdTit-1,nQtdTit+1)
			Endif
		Endif
	Endif	
	If lTodos
		(cAliasSe1)->(dbSkip())
	Else
		// Localiza o titulo de abatimento e inverte a marca dele tambem
		If !(cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
			cChaveLbn := "FAT" + (cAliasSe1)->(xFilial("SE1")+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
			nReg := (cAliasSe1)->(Recno())
			#IFNDEF TOP
				(cAliasSe1)->(DbSetOrder(2))
				If (cAliasSe1)->(dbSeek(xFilial("SE1")+(cAliasSe1)->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)))
					cTitAnt := (cAliasSe1)->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
					While (cAliasSe1)->(!Eof()) .And. cTitAnt == (cAliasSe1)->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
						If !(cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
							(cAliasSe1)->(dbSkip())
							Loop
						Endif
						(cAliasSe1)->(DbSetOrder(nOrderSe1))
						// Verifica se o registro nao esta sendo utilizado em outro terminal
						If LockByName(cChaveLbn,.T.,.F.)
						   If Ascan(aChaveLbn, cChaveLbn) == 0
								Aadd(aChaveLbn,cChaveLbn)
							Endif	
						   Fa280Inverte(cAliasSe1,cMarca,oValor,oQtdTit,lTodos,oMark,@nValor,@nTotExcluido,lExclui,.T.,aChaveLbn,cChaveLbn)
						Else
							IW_MsgBox("Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura","Atenção","STOP") //###"Atenção"
						Endif	
						(cAliasSe1)->(dbSkip())
					End	
				Endif	
			#ELSE
				If Left((cAliasSe1)->(IndexKey()),57) != "E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA"
					(cAliasSe1)->(DbSetOrder(1))
				Endif	
				If (cAliasSe1)->(MsSeek(xFilial("SE1")+(cAliasSe1)->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)))
					cTitAnt := (cAliasSe1)->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
					While (cAliasSe1)->(!Eof()) .And. cTitAnt == (cAliasSe1)->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
						If !(cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
							(cAliasSe1)->(dbSkip())
							Loop
						Endif
						If (cAliasSe1)->(FieldPos("RECNO")) > 0
							DbSelectArea("SE1")
							MsGoto((cAliasSe1)->RECNO)
							DbSelectArea(cAliasSe1)
						Endif	
						// Verifica se o registro nao esta sendo utilizado em outro terminal
						If LockByName(cChaveLbn,.T.,.F.)
							If Ascan(aChaveLbn, cChaveLbn) == 0
								Aadd(aChaveLbn,cChaveLbn)
							Endif
						   Fa280Inverte(cAliasSe1,cMarca,oValor,oQtdTit,lTodos,oMark,@nValor,@nTotExcluido,lExclui,.T.,aChaveLbn,cChaveLbn)
						Else
							IW_MsgBox("Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura","Atenção","STOP") //###
						Endif	
						(cAliasSe1)->(DbSkip())
					End	
				Endif	
			#ENDIF
			(cAliasSe1)->(DbSetOrder(nOrderSe1))
			(cAliasSe1)->(dbGoto(nReg))
		Endif	
		Exit	
	Endif
Enddo
oValor:Refresh()
oQtdTit:Refresh()
If lTodos
	(cAliasSe1)->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)
Endif	
Return Nil


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa280ValOK³ Autor ³ Mauricio Pequim Junior³ Data ³ 06/05/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o valor da fatura ‚ v lido (maior que zero)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa280ValOK() 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280ValOK(nValFatura)
Default nValFatura := nValor

IF nValFatura <= 0
	Help(" ",1,"VLFATNEG")
	Return .F.
Endif
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa280Soma ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o valor da fatura ‚ o mesmo dos tit. marcados  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa280Soma() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280Soma()

IF Str(nValorF,16,2) != Str(nValor,16,2) .and. nValorF != 0
	Help(" ",1,"VALFAT")
	Return .F.
Endif
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa280Val	³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pede que se digite o valor correto da fatura 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fa280Val(ExpO1)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280Val(oValorFat)

LOCAL oDlg
LOCAL nOpca := 0

DEFINE MSDIALOG oDlg FROM 10, 5 TO 17, 33 TITLE "Informe valor correto da Fatura" //
@	.3,1 TO 2.3,12 OF oDlg
@	1.0,2 	Say "Valor : "
@	1.0,4.5	MSGET nValorF Picture "@E 999,999,999.99"
DEFINE SBUTTON FROM 034,042	TYPE 1 ACTION (nOpca := 1,If(!Empty(nValorF),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
DEFINE SBUTTON FROM 034,069.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg
oValorFat:Refresh()

Return .F.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa280PedCd³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pede que se digite a condicao de pagamento				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa280PedCd(ExpO1) 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280PedCd()

LOCAL oDlg
LOCAL nOpca := 0
LOCAL cCond := Space(3)

DEFINE MSDIALOG oDlg FROM 10, 5 TO 17, 33 TITLE "Informe Condi‡„o de Pagamento"
@	1.0,2 	Say "Condicao: "
@	1.0,5.5	MSGET cCond F3 "SE4" Picture "!!!" Valid ExistCpo("SE4",cCond) .And.;
																	  Fa290Cond(cCond)
@	.3,1 TO 2.3,11.9 OF oDlg

DEFINE SBUTTON FROM 034,069.1	TYPE 1 ACTION (nOpca := 1,If(	!Empty(cCond)	.And. ;
															ExistCpo("SE4",cCond) 			.And. ;
															Fa290Cond(cCond),oDlg:End(),nOpca:=0)) ;
												 ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

Return If(nOpca=0,"   ",cCond)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa280LinOk³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confere se a linha digitada esta OK 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa280LinOk()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FuncTion Fa280LinOk()
Local lRet := .T.
Local nX, lDuplicado := .F.
Local nPosPrefixo	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_PREFIXO"} )
Local nPosNum		:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_NUM"} )
Local nPosParcela	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_PARCELA"} )
Local nPosTipo		:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_TIPO"} )
Local nPosValor	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_VLCRUZ"} )

// Se a linha nao estiver deletada e o prefixo foi alterado
IF !(GdDeleted( n, aHeader, aCols)) .And. nPosPrefixo > 0 .And. aCols[n][nPosPrefixo] != cPrefix
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite alterar PREFIXO !                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"IGUALPREF")
	lRet := .F.
Endif
// Se a linha nao estiver deletada e o TIPO foi alterado
IF !(GdDeleted( n, aHeader, aCols)) .and. nPosTipo > 0 .And. aCols[n][nPosTipo] != cTipo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite alterar PREFIXO !                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	Help(" ",1,"IGUALTIPO",,STR0057,1,0)	//"Nao e permitida alteracao do tipo do titulo."+CHR(13)+"Deve-se manter o tipo definido no inicio da rotina")
	Help(" ",1,"IGUALTIPO",,"",1,0)	//"Nao e permitida alteracao do tipo do titulo."+CHR(13)+"Deve-se manter o tipo definido no inicio da rotina")
	lRet := .F.
Endif
// Se a linha nao estiver deletada e o NUMERO foi alterado
IF !(GdDeleted( n, aHeader, aCols)) .and. nPosNum > 0 .And. aCols[n][nPosNum] != cFatura
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite alterar NUMERO !                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"IGUALNUM",,"Nao e permitida alteracao do numero do titulo."+CHR(13)+"Deve-se manter o numero definido no inicio da rotina"	,1,0)	 //###
	lRet := .F.
Endif
// Se o usuario informa o numero da fatura, valida a sua existencia
If nPosNum > 0
	// Pesquisa por titulos ja cadastrados
	For nX := 1 To Len(aCols)
		// Se encontrou um titulo igual ao ja cadastrado, avisa e nao permite continuar
		If !(GdDeleted( n, aHeader, aCols)) .And.;
			aCols[nX][nPosPrefixo]+aCols[nX][nPosNum]+aCols[nX][nPosParcela]+aCols[nX][nPosTipo] == ;
			aCols[n][nPosPrefixo]+aCols[nX][nPosNum]+aCols[n][nPosParcela]+aCols[n][nPosTipo] .And. nX != n						
			lDuplicado := .T.
			Exit
		Endif	
	Next
Endif	
// Se encontrou um titulo igual ao ja cadastrado, avisa e nao permite continuar
If !(GdDeleted( n, aHeader, aCols)) .And. lDuplicado
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao permite duplicar o numero !                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Help(" ",1,"A280EXIST")
Endif
// Se passou por todas as validacoes, valida o valor
If lRet .And. !(GdDeleted( n, aHeader, aCols))
	lRet := NaoVazio(aCols[n][nPosValor])
Endif	
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa280TudOK³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se aCols esta preenchida corretamente			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa280TudOk(ExpO1) 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FuncTion Fa280TudOk()
LOCAL nX, nValTot := 0
LOCAL lFa280Tok := Existblock("FA280TOK")
LOCAL lRet := .T.
Local nPosValor	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_VLCRUZ"} )

For nx:=1 To Len(aCols)
	If !(GdDeleted( nx, aHeader, aCols))
		nValTot += aCols[nx][nPosValor]
	Endif
Next nx
IF Str(nValor,16,2) != Str(nValTot,16,2)
	Help(" ",1,"VALFAT1",,"Valor das notas " + Transform(nValor,"@E 99,999,999,999.99")+chr(13)+; //
								  "Valor da fatura  " + Transform(nValTot,"@E 99,999,999,999.99"),4,0) //
	lRet := .F.
Endif
If lFa280TOk .and. lRet
	If !(Execblock("FA280TOK",.F.,.F.))
		lRet := .F.
	Endif
Endif
oValTot:Refresh()
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa280AtuVl³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza valor da fatura na tela 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa280AtuVl()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FuncTion Fa280AtuVl(lVldCampo)
LOCAL nx
Local nPosValor	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "E1_VLCRUZ"} )
DEFAULT lVldCampo := .T.
nValTot := 0
For nx:=1 To Len(aCols)
	If !GdDeleted(nx)
		If nx = n .And. lVldCampo
			nValTot+= &(ReadVar())
		Else	
			nValTot+= aCols[nx][nPosValor]
		Endif
	Endif
Next

oValTot:Refresh()
Return .T.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280Tipo ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 19/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Checa o Tipo do titulo informado 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280Tipo() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion FA280Tipo(cTipoDoc)
LOCAL lRetorna := .T.
Local cArea := Alias()

If !Empty(cTipoDoc)
	dbSelectArea("SX5")
	If !dbSeek(cFilial+"05"+cTipoDoc)
		Help(" ",1,"E1_TIPO")
		lRetorna := .F.
	Elseif !NewTipCart(cTipoDoc,"1")
		Help(" ",1,"TIPOCART")
		lRetorna := .F.
	Else
		If cTipoDoc $ MVPAGANT+"/"+MV_CPNEG
			Help(" ",1,"E1_TIPO")
			lRetorna := .F.
		ElseIf cTipoDoc $ MVRECANT+"/"+MVTAXA+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVISABT
			Help(" ",1,"TIPOFAT")
			lRetorna := .F.
		Endif
	Endif
Else
	Help(" ",1,"TIPOFAT")
	lRetorna := .F.
Endif

dbSelectArea(cArea)
Return lRetorna

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280MonFa ³ Autor ³ Deny B. de Mendonca  ³ Data ³ 29/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta a Fatura no SE1            								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280MonFa()															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Filial do SE1                            ³±±
±±³          ³ ExpC2 = Prefixo do Titulo                                  ³±±
±±³          ³ ExpC3 = Numero do Titulo                                   ³±±
±±³          ³ ExpC4 = Parcela do Titulo                                  ³±±
±±³          ³ ExpN5 = Registro do SE1                                    ³±±
±±³          ³ ExpC6 = Numero da Fatura                                   ³±±
±±³          ³ ExpC7 = Prefixo da Fatura                                  ³±±
±±³          ³ ExpC8 = Tipo da Fatura                                     ³±±
±±³          ³ ExpD9 = Data da baixa da Fatura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion FA280MonFa(	cAliasSe1,cFilSE1,cPrefSE1,cNumSE1,cParcSE1,nRegSE1,cNumFat,;
							cPreFat,cTipoFat,dDataBx,lElimResid,cArquivo,nTotal,nHdlPrv)
Local bWhile
Local bFor
Local nInd := SE1->(IndexOrd())
Local nJuros 	 := 0
Local nDesconto := 0
Local nValCorr	:= 0

Default dDataBx := dDatabase
Default lElimResid := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procura pelos Titulos de Abatimentos			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAliasSe1)
#IFDEF TOP
	DbGotop()	
	bWhile := { || .T. }
	bFor	 := { ||	(cAliasSe1)->E1_FILIAL==cFilSE1 .And. (cAliasSe1)->E1_PREFIXO=cPrefSE1 .And. ;
				  		alltrim((cAliasSe1)->E1_NUM)==alltrim(cNumSE1) .And. (cAliasSe1)->E1_PARCELA==cParcSE1 }
#ELSE
	DbSetOrder(1)
	DbSeek(cFilSE1+cPrefSE1+cNumSE1+cParcSE1)
	bWhile := { ||	(cAliasSe1)->E1_FILIAL==cFilSE1 .And. (cAliasSe1)->E1_PREFIXO=cPrefSE1 .And. ;
					  	alltrim((cAliasSe1)->E1_NUM)==alltrim(cNumSE1) .And. (cAliasSe1)->E1_PARCELA==cParcSE1 }
	bFor	 := { || .T. }					  	
#ENDIF

While (cAliasSe1)->(!EOF()) .And. Eval(bWhile) .And. Eval(bFor)
	If	(cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT .And. (cAliasSe1)->E1_SALDO > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua a Baixa dos Titulos de Abatimento   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FA280Baixa(cAliasSe1,cNumFat,cPrefat,cTipoFat,dDataBx,mv_par01,lElimResid,0,0,0,@cArquivo,@nTotal,@nHdlPrv)
	Endif
	(cAliasSe1)->(dbSkip())
Enddo

dbGoto(nRegSE1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza a Baixa do Titulo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !((cAliasSe1)->E1_TIPO $ MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT) .And. (cAliasSe1)->E1_SALDO > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a Baixa do Titulo Principal         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nJuros	 := (cAliasSe1)->E1_SDACRES
	nDesconto := (cAliasSe1)->E1_SDDECRE
	nValCorr:= fa280Correc(dDataBx,cAliasSe1)
	FA280Baixa(cAliasSe1,cNumFat,cPrefat,cTipoFat,dDataBx,mv_par01,lElimResid,nJuros,nDesconto,nValCorr,@cArquivo,@nTotal,@nHdlPrv)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera movimento da Baixa do Titulo no SE5   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FA280Movim("SE1",cFilSE1,cNumFat,dDataBx,,,,,cNumFat,cPreFat,nJuros,nDesconto,nValCorr)
Endif
SE1->(DbSetOrder(nInd))
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280Baixa³ Autor ³ Deny B. de Mendonca   ³ Data ³ 29/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Baixa o Titulo posicionado       						 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280Baixa()												 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Numero da Fatura para Baixa do SE1                 ³±±
±±³          ³ ExpC2 = Prefixo da Fatura para baixa do SE1                ³±±
±±³          ³ ExpC3 = Tipo da Fatura para Baixa do SE1                   ³±±
±±³          ³ ExpD4 = Data da Baixa para SE1                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion FA280Baixa(	cAliasSe1,cNumFat,cPrefat,cTipoFat,dDtbaixa,nCondLoja,;
							lElimResid,nJur280,nDesc280,nValCorr,cArquivo,nTotal,nHdlPrv)
Local nAscan
Local nValorFat
Local aArea	   := GetArea()
Local aAreaSa1 := SA1->(GetArea())
Local nAbatimentos := 0
Local cImpostos := Fa280VerImp(cNat)

Local cKeySE1 := ""
Local	lPadrao520 := .f.

Default dDtbaixa 	 := dDatabase
Default lElimResid := .T.
Default nJur280	 := 0
Default nDesc280	 := 0
Default nValCorr	 := 0

Default cArquivo  := ""
Default nTotal    := 0
Default nHdlPrv	:= 0
// Efetua abertura do __SE1 (espelho do SE1) para deletar os abatimentos do titulo
// principal que não foram selecionados no filtro.
If Select("__SE1") == 0
	SomaAbat("","","","R")
Endif	

//Essa rotina pode ser chamada por outros modulos.
//Garanto que o grupo de perguntas esta OK
AjustaSx1()
Pergunte("AFI280",.F.)
//Verificação para contabilização on-line
lPadrao520 := (mv_par04 == 1 .and. VerPadrao("520"))

// Verifica a matriz que contem os valores a faturar, pois no FINA281 o usuario
// podera alterar o valor a faturar do titulo, nao sendo necessariamente o saldo total
If Type("aVlrFat") != "A"
	aVlrFat	:= {{0, 0}} // Valores a faturar
Endif

// Se a pergunta "Considera lojas" for igual a nao, deve-se atualizar o saldo das 
// duplicadas das diferentes lojas
If nCondLoja == 2
	SA1->(MsSeek(xFilial("SA1")+(cAliasSe1)->(E1_CLIENTE+E1_LOJA)))
	SA1->(AtuSalDup("-",(cAliasSe1)->E1_SALDO,(cAliasSe1)->E1_MOEDA,(cAliasSe1)->E1_TIPO,,(cAliasSe1)->E1_EMISSAO))
	SA1->(RestArea(aAreaSa1))
Endif	

#IFDEF TOP
	If (cAliasSe1)->(FieldPos("RECNO")) > 0
		DbSelectArea("SE1")
		MsGoto((cAliasSe1)->RECNO)
	Endif	
#ENDIF

nAscan := Ascan(aVlrFat,{|e| e[1] == (cAliasSe1)->(Recno())})

// Soma os abatimentos do titulo principal
If !(cAliasSe1)->E1_TIPO$MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT
	nAbatimentos := SomaAbat((cAliasSe1)->E1_PREFIXO,(cAliasSe1)->E1_NUM,(cAliasSe1)->E1_PARCELA,"R",1,dDataBase,(cAliasSe1)->E1_CLIENTE,(cAliasSe1)->E1_LOJA)
Endif	

If nAscan > 0
	nValorFat := aVlrFat[nAscan][2]
Else
	nValorFat := If((cAliasSe1)->E1_TIPO$MVABATIM+"/"+MVINABT+"/"+MVIRABT+"/"+MVISABT,(cAliasSe1)->E1_VALOR,(cAliasSe1)->(E1_SALDO+E1_SDACRES-E1_SDDECRE-nAbatimentos))
Endif

RecLock("SE1",.F.)
SE1->E1_BAIXA		:= dDtbaixa
If lElimResid // Elimina residuos
	SE1->E1_VALLIQ		:= SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE - nAbatimentos
	SE1->E1_SALDO		:= 0
Else	
	SE1->E1_VALLIQ		:= nValorFat
	SE1->E1_SALDO		:= If(nAscan > 0, SE1->E1_SALDO - nValorFat, 0)
Endif	
SE1->E1_MOVIMEN	:= dDtbaixa
SE1->E1_FATURA 	:= cNumFat
SE1->E1_FATPREF 	:= cPrefat
SE1->E1_TIPOFAT 	:= cTipofat
SE1->E1_DTFATUR 	:= dDtbaixa
SE1->E1_STATUS 	:= Iif(SE1->E1_SALDO>0.01,"A","B")
SE1->E1_FLAGFAT	:= "S"
SE1->E1_SDDECRE	:= 0
SE1->E1_SDACRES	:= 0
SE1->E1_JUROS		:= nJur280
SE1->E1_DESCONT	:= nDesc280 
SE1->E1_CORREC	:=nValCorr
MsUnlock()             
IF lPadrao520
	If nHdlPrv <= 0
		nHdlPrv:=HeadProva(cLote,"FINA280L",Substr(cUsuario,7,6),@cArquivo)
	Endif
	nTotal+=DetProva(nHdlPrv,"520","FINA280L",cLote)
Endif			
                                     
//
//Função Específica do Modulo Sigapls para atualizar Status de Guias Compradas
//
If FindFunction("PL090TITCP")
	PL090TITCP(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,"1")
EndIf
//Baixo todos os abatimentos do titulo independente de terem sido
//marcados. 
If nAbatimentos > 0
	cKeySE1 := xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
	dbSelectArea("__SE1")
	__SE1->(dbSetOrder(2))
	__SE1->(dbSeek(cKeySE1))
	While !EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA == cKeySE1
		IF E1_TIPO $ cImpostos + MVABATIM
			RecLock("__SE1")
			Replace E1_SALDO		With 0
			Replace E1_BAIXA		With dDataBase
			Replace E1_MOVIMEN	With dDtbaixa
			Replace E1_STATUS		With "B"
			Replace E1_SDACRES	With 0
			Replace E1_SDDECRE	With 0
			Replace E1_FATURA 	With cNumFat
			Replace E1_FATPREF 	With cPrefat
			Replace E1_TIPOFAT 	With cTipofat
			Replace E1_DTFATUR 	With dDtbaixa
			MsUnLock()
		EndIF
		dbSkip()
	Enddo
	__SE1->(dbSetOrder(1))
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para manipular/gravar dados nos titulos que originaram a fatura.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("F280ORI")
	ExecBlock("F280ORI",.F.,.F.)
Endif

SE1->(RestArea(aArea))
RestArea(aArea)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280Movim³ Autor ³ Deny B. de Mendonca   ³ Data ³ 29/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Baixa o Titulo posicionado       						  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280Movim()												  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Filial para gravacao do SE5              ³±±
±±³          ³ ExpC2 = Numero da Fatura para gravacao do SE5              ³±±
±±³          ³ ExpD3 = Data do Movimento para gravacao do SE5             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion FA280Movim(	cAliasSe1,cFilSE5,cFatSE5,dDtMovSE5,cRecPag,cTipoDoc,cHistor,;
							cMotBx,cFatura,cFatPref,nJur280,nDesc280,nValCorr)
Local aTipoDoc	:= {}
Local nA
Local cSequencia := "00"
Local aArea	   := GetArea()
Local bCampo
Local cTpDoc
Local lAcreDecre := .F.
Local lFa280GrE5 := ExistBlock("Fa280GrE5")
Local nTxMoeda	:= 0
Default dDtMovSE5 := dDatabase
DEFAULT cRecPag	:= "R"
DEFAULT cTipoDoc	:= "BA"
DEFAULT cHistor	:= "Bx.p/Emiss.Fatura "+cFatSE5  // 
DEFAULT cMotBx		:= "FAT"
DEFAULT nJur280	:= 0
DEFAULT nDesc280	:= 0 
DEFAULT nValCorr	:=0 
//verifica se existem os campos de valores de acrescimo e decrescimo no SE5
If SE5->(FieldPos("E5_VLACRES")) > 0 .and. SE5->(FieldPos("E5_VLDECRE")) > 0
	lAcreDecre := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza a sequencia da baixa ( CP,BA,VL,V2,LJ )				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTipoDoc := {"CP","BA","VL","V2"}

SE5->(dbSetOrder(2))
For nA:= 1 to len(aTipoDoc)
	SE5->(dbSeek(cFilSE5 + aTipoDoc[nA] + (cAliasSe1)->E1_PREFIXO + (cAliasSe1)->E1_NUM + ;
	(cAliasSe1)->E1_PARCELA + (cAliasSe1)->E1_TIPO) )
	While !SE5->(Eof())								.And. ;
		SE5->E5_FILIAL		== cFilSE5				.And. ;
		SE5->E5_TIPODOC	== aTipoDoc[nA]    	.And. ;
		SE5->E5_PREFIXO	== (cAliasSe1)->E1_PREFIXO	.And. ;
		SE5->E5_NUMERO		== (cAliasSe1)->E1_NUM			.And. ;
		SE5->E5_PARCELA	== (cAliasSe1)->E1_PARCELA	.And. ;
		SE5->E5_TIPO		== (cAliasSe1)->E1_TIPO
		If ( SE5->E5_CLIFOR+SE5->E5_LOJA == (cAliasSE1)->E1_CLIENTE+(cAliasSE1)->E1_LOJA .And. SE5->E5_RECPAG=="R" )
			If cSequencia < SE5->E5_SEQ
				cSequencia := SE5->E5_SEQ
			Endif
		EndIf
		SE5->(dbSkip())
	EndDo
Next I
cSequencia := Soma1(cSequencia,2)

For nA := 1 To 4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza a Movimenta‡„o Banc ria									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nA==1
		bCampo  := { || (cAliasSe1)->E1_VALLIQ } // Valor recebido total
		cTpDoc  := cTipoDoc
	Elseif nA==2
		bCampo  := { || nJur280 } // Valor dos juros
		cTpDoc  := "JR"
	Elseif nA==3
		bCampo  := { || nDesc280 } // Valor do desconto
		cTpDoc  :="DC"
	Elseif nA==4
		bCampo  := { || nValCorr } // Valor do desconto
		cTpDoc  :="CM"
	Endif

	If Eval(bCampo) != 0 .or. nA == 1

        nTxMoeda	:= RecMoeda(dDtMovSE5,(cAliasSE1)->E1_MOEDA)
		RecLock("SE5",.T.)
		SE5->E5_FILIAL		:= xFilial("SE5")
		SE5->E5_DATA		:= dDtMovSE5
		SE5->E5_VALOR		:= Iif(nA ==4 ,nValCorr,xMoeda(Eval(bCampo),(cAliasSE1)->E1_MOEDA,1,dDtMovSE5,3))
		SE5->E5_NATUREZ		:= (cAliasSe1)->E1_NATUREZ
		SE5->E5_RECPAG		:= cRecPag
		SE5->E5_TIPO		:= (cAliasSe1)->E1_TIPO
		SE5->E5_LA			:= "S"
		SE5->E5_TIPODOC		:= cTpDoc
//		SE5->E5_HISTOR		:= Iif(nA <> 4,cHistor,STR0075 + cHistor)
		SE5->E5_HISTOR		:= Iif(nA <> 4,cHistor,"" + cHistor)
		SE5->E5_PREFIXO	:= (cAliasSe1)->E1_PREFIXO
		SE5->E5_NUMERO		:= (cAliasSe1)->E1_NUM
		SE5->E5_PARCELA	:= (cAliasSe1)->E1_PARCELA
		SE5->E5_CLIFOR		:= (cAliasSe1)->E1_CLIENTE
		SE5->E5_CLIENTE	:= (cAliasSe1)->E1_CLIENTE
		SE5->E5_LOJA		:= (cAliasSe1)->E1_LOJA
		SE5->E5_DTDIGIT	:= dDtMovSE5
		SE5->E5_MOTBX		:= cMotBx
		SE5->E5_VLCORRE	:= 	Iif(nA ==1, nValCorr,0)
		SE5->E5_VLMOED2	:= 	Iif(nA <> 4,Eval(bCampo),0)
		SE5->E5_SEQ		:= cSequencia
		SE5->E5_DTDISPO	:= dDtMovSE5
		SE5->E5_BENEF  	:= (cAliasSe1)->E1_NOMCLI
		SE5->E5_TXMOEDA	:=	nTxMoeda
		If nA == 1 //Movimento principal
			SE5->E5_VLJUROS	:= nJur280
			SE5->E5_VLDESCO	:= nDesc280
			If lAcredecre
				SE5->E5_VLACRES	:= Round(NoRound(xMoeda(nJur280,(cAliasSe1)->E1_MOEDA,1,dDtMovSE5,3),3),2)
				SE5->E5_VLDECRE	:= Round(NoRound(xMoeda(nDesc280,(cAliasSe1)->E1_MOEDA,1,dDtMovSE5,3),3),2)
			Endif							
			If lFa280GrE5			
				ExecBlock("Fa280GrE5",.F.,.F.)
			Endif
		Endif			
		SE5->E5_FATURA	:= cFatura
		SE5->E5_FATPREF := cFatPref
		MsUnlock()
	Endif
Next		
RestArea(aArea)
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280GrFat³ Autor ³ Deny B. de Mendonca   ³ Data ³ 29/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava a Fatura no SE1            						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280GrFat()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Cliente para Geracao da Fatura           ³±±
±±³          ³ ExpC2 = Codigo da Loja do Cliente para Geracao da Fatura   ³±±
±±³          ³ ExpC3 = Codigo do Cliente                                  ³±±
±±³          ³ ExpC4 = Loja do Cliente                                    ³±±
±±³          ³ ExpC5 = Numero da Fatura                                   ³±±
±±³          ³ ExpC6 = Prefixo da Fatura                                  ³±±
±±³          ³ ExpC7 = Parcela da Fatura                                  ³±±
±±³          ³ ExpC8 = Tipo da Fatura                                     ³±±
±±³          ³ ExpC9 = Vencimento da Parcela da Fatura                    ³±±
±±³          ³ ExpC10= Natureza da Fatura                                 ³±±
±±³          ³ ExpC11= Banco da Fatura                                    ³±±
±±³          ³ ExpN12= Valor da Duplicata                                 ³±±
±±³          ³ ExpN13= ValCruz                                            ³±±
±±³          ³ ExpN14= ValrURV                                            ³±±
±±³          ³ ExpN15= Moeda da Fatura                                    ³±±
±±³          ³ ExpN16= Registro do SE1                                    ³±±
±±³          ³ ExpC17= Codigo do lancamento Padronizado                   ³±±
±±³          ³ ExpN18= Valor Total da Fatura                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280												 					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion FA280GrFat(cCliFat,cLojaFat,cCli,cLoja,cFatura,cPrefix,cParcela,cTipo,;
							dVencto,cNat,cBanco,nValDup,nValCruz,nVARURV,nMoedFat,nRegE1,;
							cPadrao,nTotal,lHead,cArquivo,nHdlPrv,dDatEmis,cPrograma,;
							cFilDeb, cSitFat, lConsLoja, nAcresc, nDecresc )
Local lPadrao
Local aArea	:= GetArea()

Default dDatEmis := dDataBase
Default cPrograma := "FINA280L"
Default cFilDeb   := cFilAnt
Default cPadrao	:= ""
Default cSitFat 	:= "1"
Default lConsLoja := (mv_par01 == 1)
Default nAcresc   := 0
Default nDecresc  := 0

dbSelectArea("SA1")
If Empty( cCliFat )
	dbSeek(cFilial+cCli+cLoja)
Else
	dbSeek(cFilial+cCliFat+cLojaFat)
Endif

// Se a pergunta "Considera lojas" for igual a nao, deve-se atualizar o saldo das 
// duplicadas das diferentes lojas
If ! lConsLoja
	SA1->(AtuSalDup("+",nValDup,nMoedFat,cTipo,,dDatEmis))
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Implanta‡„o da Fatura		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SE1",.T.)
Replace E1_FILIAL	With xFilial("SE1")
Replace E1_NUM 	 	With cFatura
Replace E1_PARCELA	With cParcela
Replace E1_PREFIXO	With cPrefix
Replace E1_NATUREZ	With cNat
Replace E1_SITUACA	With "0"
Replace E1_VENCTO		With dVencto
Replace E1_VENCREA	With DataValida(E1_VENCTO,.T.)
Replace E1_VENCORI	With E1_VENCREA
Replace E1_EMISSAO	With dDatEmis
Replace E1_EMIS1		With dDatEmis
IF cPaisLoc<>"CHI"
	Replace E1_TIPO	 With cTipo
else
	Replace E1_TIPO	 With "LT"
endif
Replace E1_CLIENTE With IIF( Empty( cCliFat ), cCli, cCliFat )
Replace E1_LOJA	 With IIF( Empty(cCliFat),cLoja,cLojaFat )
Replace E1_NOMCLI  With SA1->A1_NREDUZ
Replace E1_MOEDA	 With nMoedFat
Replace E1_VALOR	 With nValDup
Replace E1_SALDO	 With nValDup
Replace E1_FATURA  With "NOTFAT"
Replace E1_VLCRUZ  With xMoeda(nValDup,nMoedFat,1)  // nValCruz
Replace E1_VARURV  With nVARURV
Replace E1_STATUS  With Iif(E1_SALDO>0.01,"A","B")
Replace E1_OCORREN With "01"
Replace E1_ORIGEM  With cPrograma
Replace E1_FILDEB  With cFilAnt
Replace E1_FILORIG With cFilAnt
Replace E1_ACRESC  With nAcresc
Replace E1_DECRESC With nDecresc
Replace E1_SDACRES With nAcresc
Replace E1_SDDECRE With nDecresc
Replace E1_CREDIT  With SE1->E1_CREDIT
Replace E1_DEBITO  With SE1->E1_DEBITO
Replace E1_CCC     With SE1->E1_CCC
Replace E1_ITEMC   With SE1->E1_ITEMC
Replace E1_CLVLCR  With SE1->E1_CLVLCR
Replace E1_CCD     With SE1->E1_CCD
Replace E1_ITEMD   With SE1->E1_ITEMD
Replace E1_CLVLDB  With SE1->E1_CLVLDB



If ! Empty(cPadrao)
	lPadrao := VerPadrao(cPadrao)
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Flag de Lancamento contabil	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPadrao
	Replace E1_LA With "S"
End
MsUnlock()

If ExistBlock("FA280")
	ExecBlock("FA280",.f.,.f.,nRegE1)
Endif

VALOR = 0
IF lPadrao
	If !lHead
		nHdlPrv:=HeadProva(cLote,cPrograma,Substr(cUsuario,7,6),@cArquivo)
		lHead := .T.
	Endif
	nTotal+=DetProva(nHdlPrv,cPadrao,cPrograma,cLote)
Endif
RestArea(aArea)

Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FA280ConFa ³ Autor ³ Deny B. de Mendonca  ³ Data ³ 29/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava a Fatura no SE1            						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA280ConFa()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Valor Total do Lancamento                          ³±±
±±³          ³ ExpC2 = Codigo do lancamento Padronizado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion FA280ConFa(nValTotal,cPadrao,cArquivo,nHdlPrv,nTotal,cPrograma)
Local nRecSe1
Default cPrograma := "FINA280L"

dbSelectArea("SE1")
nRecSe1 := Recno()
SE1->(DBGoBottom())
SE1->(dbSkip())
VALOR := nValTotal
nTotal+=DetProva(nHdlPrv,cPadrao,cPrograma,cLote)
RodaProva(nHdlPrv,nTotal)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia para Lancamento Contabil				    	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lDigita:=IIF(mv_par02==1,.T.,.F.)
cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.)

dbSelectArea("SE1")
SE1->(DBGoTo(nRecSe1))

Return()

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Fa280bAval ³ Autor ³ Mauricio Pequim Jr.  ³ Data ³ 02/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Bloco de marcacoo       			          						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Fa280bAval()		  													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA280																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion Fa280bAval(cAliasSe1,cMarca,oValor,oQtdTit,oMark,nValor,nTotExcluido,lExclui,aChaveLbn)
Local lRet 		:= .T.
Local cChaveLbn 

DEFAULT nTotExcluido := 0
DEFAULT lExclui		:= .F.
#IFDEF TOP
	If (cAliasSe1)->(FieldPos("RECNO")) > 0
		DbSelectArea("SE1")
		MsGoto((cAliasSe1)->RECNO)
		DbSelectArea(cAliasSe1)
	Endif	
#ENDIF
cChaveLbn := "FAT" + (cAliasSe1)->(xFilial("SE1")+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
// Verifica se o registro nao esta sendo utilizado em outro terminal
//-- Parametros da Funcao LockByName() :
//   1o - Nome da Trava
//   2o - usa informacoes da Empresa na chave
//   3o - usa informacoes da Filial na chave 
If LockByName(cChaveLbn,.T.,.F.)
	Fa280Inverte(cAliasSe1,cMarca,oValor,oQtdTit,.F.,oMark,@nValor,@nTotExcluido,lExclui,,aChaveLbn,cChaveLbn) // Marca o registro e trava
	lRet := .T.
Else
	IW_MsgBox("Este titulo está sendo utilizado em outro terminal, não pode ser utilizado na fatura","Atenção","STOP") //###"Atenção"
	lRet := .F.
Endif	
oMark:oBrowse:Refresh(.t.)
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA280DATA ºAutor  ³Mauricio Pequim Jr  º Data ³21.06.2004   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica data de vencimento das parcelas a serem geradas    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA280                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FuncTion fa280data()
Local lRet := .F.
Local dDataVc := &(ReadVar())

//Nao permite data de vencimento menor que data de inclusão
lRet := dDataVc >= dDataBase   

If ExistBlock("F280DTVC")
	lRet := ExecBlock("F280DTVC",.f.,.f.,{dDataVc})
Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa280VerImºAutor  ³Claudio D. de Souza º Data ³08.07.2005   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica os impostos a serem considerados na selecao dos	  º±±
±±º          ³titulos que farao parte da fatura.								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA280                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa280VerImp(cNaturez)
Local cRet := ""
Local aAreaSed := SED->(GetArea())

SED->(MsSeek(xFilial("SED")+cNaturez))
If SED->ED_CALCPIS$"1S" .and. SA1->A1_RECPIS $ "S#P"
	cRet += MVPIABT
Endif
If SED->ED_CALCCOF$"1S" .and. SA1->A1_RECCOFI $ "S#P"
	cRet += MVCFABT
Endif
If SED->ED_CALCCSL$"1S" .And. SA1->A1_RECCSLL $ "S#P"
	cRet += MVCSABT
Endif
If SED->ED_CALCIRF$"1S"
	cRet += MVIRABT
Endif

SED->(RestArea(aAreaSed))

Return cRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fa280Corre³ Autor ³ Paulo Augusto 		³ Data ³ 21/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Calcula a corre‡„o monet ria.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa280Correc()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Gen‚rico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FuncTion fa280Correc(dDtBaixa,cAlias)

Local nCorrecao := 0
Local nValAtual := 0
Local nValEmiss := 0

DEFAULT dDtBaixa  := dDataBase
DEFAULT cAlias :="SE1"

IF (cAlias)->E1_MOEDA > 1
	//Caso seja a primeira apuracao de variacao monetaria
	If Empty((cAlias)->E1_TXMOEDA) .and. Empty((cAlias)->E1_DTVARIA)
		nValEmiss := (cAlias)->E1_VLCRUZ
	Else
		nValEmiss  :=  xMoeda((cAlias)->E1_SALDO,(cAlias)->E1_MOEDA,1,IF(Empty((cAlias)->E1_DTVARIA),(cAlias)->E1_EMISSAO,(cAlias)->E1_DTVARIA),,If(cPaisLoc=="BRA",(cAlias)->E1_TXMOEDA,0))
	Endif

	nValAtual := xMoeda( (cAlias)->E1_SALDO, (cAlias)->E1_MOEDA, 1, dDtBaixa)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica atraves do parametro MV_CALCCM se sera calculada a cor-³
	//³ recao monetaria.                                           	  ³
	//³ Caso o parametro nao exista, sera assumido "S"						  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If GetMv("MV_CALCCM") == "S"
		nCorrecao := nValAtual - nValEmiss
	Else
		nCorrecao := 0
	Endif
Endif
Return nCorrecao

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa280Pesq ³ Autor ³ Claudio D de Souza    ³ Data ³28.09.06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ tela de pesquisa - WINDOWS 							      	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Financeiro - FINA280												     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion Fa280Pesq(oMark, cAlias,cAliasSe1)
Local cAliasAnt := Alias()
Local nRecno
Local nOrdInd := IndexOrd()		
Local cCampos
Local nOrderSe1 := (cAliasSe1)->(IndexOrd())

cCampos := (cAliasSe1)->(IndexKey(1))
nRecno := (cAliasSe1)->(Recno())
		
dbSelectArea(cAlias)
AxPesqui()

cCampos := cAlias + "->(" + cCampos + ")"

(cAliasSe1)->(DbSetOrder(1))
If (cAliasSe1)->(MSSeek(&cCampos))
	// Se o que foi digitado para pesquisa nao estiver dentro do filtro
	// Continua no mesmo registro que estava antes de selecionar CTRL-P
	If !&(Fa280ChecF())
		(cAliasSe1)->(dbGoto(nRecNo))
	Endif
Else	
	(cAliasSe1)->(dbGoto(nRecNo))
Endif	

DbSelectArea(cAliasAnt)
dbSetOrder(nOrdInd)

(cAliasSe1)->(dbSetOrder(nOrderSe1))
oMark:oBrowse:Refresh(.T.)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³23/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Local aRotina := {	{ "Pesquisar","AxPesqui"  , 0 , 1,,.F.},; //
							{ "Visualizar","FA280Visua", 0 , 2 },; //
							{ "Selecionar","fA280Aut"  , 0 , 3 },; //
							{ "Cancelar","FA280Can"  , 0 , 6 }}  //
Return(aRotina)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FinA280T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 27.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA280                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion FinA280T(aParam)

	cRotinaExec := "FINA280L"
	ReCreateBrow("SE1",FinWindow)      	
	FinA280L(aParam[1])
	dbSelectArea("SE1")
	FinVisual("SE1",FinWindow,SE1->(Recno()),.T.)
	ReCreateBrow("SE1",FinWindow)      	

	dbSelectArea("SE1")
	
	INCLUI := .F.
	ALTERA := .F.
	
Return .T.	



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³F280SelFat ³ Autor ³ Marcelo Celi Marques ³ Data ³ 12.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Markbrowse da Faturas a Receber					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto onde se encaixara a MarkBrowse				  ³±±
±±³			 ³ ExpC1 = Tratamento aplicado a outras moedas (<>1)			  ³±±
±±³			 ³ ExpN1 = Valor dos titulos selecionados							  ³±±
±±³			 ³ ExpN2 = Quantidade de titulos selecionados					  ³±±
±±³			 ³ ExpC2 = Marca (GetMark())				 							  ³±±
±±³			 ³ ExpO2 = Objeto Valor dos titulos selecionados p/ refresh	  ³±±
±±³			 ³ ExpO3 = Objeto Quantidade de titulos selecionados p/refresh³±±
±±³			 ³ ExpN3 = Moeda da Substituicao             					  ³±±
±±³			 ³ ExpO4 = Objeto Painel superior a ser desabilitado			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA280                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion F280SelFat(oDlg,nOpca,cCond,nValor,nValTot,aVenc,cPrefix,cFatura,cTipo,dDatCont,oPanel,oPanel2)
	Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
	Local no := 0
	Local oFnt 
	Local oFnt2
	DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD 
	DEFINE FONT oFnt2 NAME "Arial" SIZE 10,14 BOLD
	
	oPanel2:Disable()
	
	cCondicao := If(nOpca=0,"   ",cCond)
	aVenc := Condicao(nValor,cCondicao,0)												 													 	
	nDup	:= Len(aVenc)
	
	aCols := GravaDp(nDup,cPrefix,cFatura,nValor,dDatabase,aVenc,cTipo,"FINA280L")
					
	If !Empty(aCols)
		aVlCruz := {}
		aVlCruz := F280VlCruz(nDup,nValCruz)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mostra tela com os diversos titulos						³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For no:=1 To Len(aCols)
			nValTot += aCols[no][6]
		Next
		
		nOpca := 0
		//DEFINE MSDIALOG oDlg2 TITLE STR0028	From 9,0 To 28,80 OF oMainWnd //"Dados Cont beis Financeiros"
		@ 015,135	SAY "Data Contabiliza‡„o : " OF oPanel2 SIZE 80,14 Pixel//
		@ 015,190	Say dDatCont OF oPanel2 SIZE 80,14  Pixel //FONT oDlg2:oFont
		@ 015,248	Say "Condicao de Pagamento : " OF oPanel2 SIZE 80,14 Pixel //
		@ 015,315	Say cCondicao OF oPanel2 SIZE 80,14  Pixel
		@ 015,375	Say "Valor Total:" OF oPanel2 Pixel SIZE 80,14 //
		
		@ 025,248	Say SE4->E4_DESCRI OF oPanel2 Pixel FONT oFnt2 COLOR CLR_HBLUE
		
		if cPaisLoc<>"CHI"
			@ 015,400 Say oValTot VAR nValTot Picture "@E 9,999,999,999.99" OF oPanel2 PIXEL FONT oFnt COLOR CLR_HBLUE //FONT oDlg2:oFont
		else
			@ 015,400 Say oValTot VAR nValTot Picture "@E 999,999,999,999"  OF oPanel2 PIXEL FONT oFnt COLOR CLR_HBLUE //FONT oDlg2:oFont
		endif
		
		oGet := MSGetDados():New(34,5,128,315,3,"Fa280LinOk","Fa280TudOk","",.T.,,,,,,"",,"Fa280AtuVl(.F.)")
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT			
	
   Endif  

Return 





/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³AjustaSx1  ³ Autor ³ Cristiano Denardi    ³ Data ³ 15/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajusta SX1            			          				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1()

Local aArea 	:= GetArea()
Local aHelpPor  := {}
Local aHelpEng  := {}
Local aHelpEsp  := {}

////////////////////////
// Contabiliza on-line a
// a Baixa
	// Portugues
	Aadd(aHelpPor,"Informe se devem ser contabilizados "    )
	Aadd(aHelpPor,"on-line as baixas dos titulos faturados.")
	// Ingles
	Aadd(aHelpEng,"Enter if the invoiced bills posting "    )
	Aadd(aHelpEng,"accounting must be entered on-line."     )
	// Espanhol
	Aadd(aHelpEsp,"Informe si deben contabilizarse on-line ")
	Aadd(aHelpEsp,"las bajas de los titulos facturados."    )
	
	PutSx1(	"AFI280", "04", "Contabiliza Baixa on-line", "Contabiliza Baja on-line", "On-line posting accounting", ;
			"mv_ch4", "N", 01, 0, 0, "C", "", "", "", "", ;
			"mv_par04", "Sim", "Si", "Yes", "", "Nao", "No", "No", "", ;
			"", "", "", "", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )        

// Contabiliza on-line a
// a Baixa		
////////////////////////

aHelpPor  := {}
aHelpEng  := {}
aHelpEsp  := {}

////////////////////////
// Contabiliza on-line o
// Cancelamento da baixa
	// Portugues
	Aadd(aHelpPor,"Informe se devem ser contabilizados "    )
	Aadd(aHelpPor,"on-line o cancelamento das baixas "      )
	Aadd(aHelpPor,"dos titulos faturados."                  )
	// Ingles
	Aadd(aHelpEng,"Enter if cancellation of the invoiced "  )
	Aadd(aHelpEng,"bills postings accounting must be "      )
	Aadd(aHelpEng,"entered on-line."                        )
	// Espanhol
	Aadd(aHelpEsp,"Informe si debe contabilizarse on-line  ")
	Aadd(aHelpEsp,"la anulación de las bajas de los títulos")
	Aadd(aHelpEsp,"facturados."                             )
	
	PutSx1(	"AFI280", "05", "Contab. Canc. da Baixa on-line", "Contab. Anulacion Baja on-line", "Canc. posting account. on-line", ;
			"mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", ;
			"mv_par05", "Sim", "Si", "Yes", "", "Nao", "No", "No", "", ;
			"", "", "", "", "", "", "", "", ;
			aHelpPor, aHelpEng, aHelpEsp )        		
// Contabiliza on-line o
// Cancelamento da baixa
////////////////////////

RestArea(aArea)
Return
