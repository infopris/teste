#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} RFATE50
Verificar situação de crédito do Cliente
(C9_BLCRED="" possui crédito/C9_BLCRED="01"ou"04" nao possui
Credito não liberado -email solicitando liberação de crédito

@author		TotalIT Solutions
@since		01/11/2015
@version	1.0
@obs		Ponto de Entrada MTA410T
/*/
//-------------------------------------------------------------------
User Function RFATE50(_nOpcao, oProc, nAprov)
Local nTotal		:= 0
Local nQtdLib  	:= 0
Local oHTML
Local cTO
Local cCC
Local cBCC
Local cSubject
Local cBody
Local cWFID
Local cPedido
Local lbmotivo
Private cAprova1	:= SuperGetMV("MV_XAPRO1",,"")//E-mail aprovador 1
Private cAprova2	:= SuperGetMV("MV_XAPRO2",,"")//E-mail aprovador 2
Private nLimite1	:= SuperGetMV("MV_LIMITE1",,0)//Limite de credito aprovador 1
Private nLimite2	:= SuperGetMV("MV_LIMITE2",,0)//Limite de credito aprovador 2
Private cAprov	:= "1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³cAprov = 0 - 1 aprovador                   ³
//³cAprov = 1 - envia para o segundo aprovador|
//³cAprov = 2 - Retornou do 2 aprovador       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
If !__lBlqCred
	Return Nil
EndIf         
*/
//verifica se precisa ter mais que uma aprovacao
If Type("_nOpcao") != "U" .And. _nOpcao == 1
	If Upper(AllTrim(oProc:oHtml:RetByName("RBAPROVA"))) == "SIM" //Upper(AllTrim(oProc:oHtml:RetByName("RBAPROVA")))
		cAprov := oProc:oHtml:RetByName('cAprov')
		If cAprov == "1"
			_nOpcao	:= 2
		EndIf
	EndIf
EndIf

If Type("_nOpcao") == "U" .And. _nOpcao == Nil
	
	//soma o total do pedido
	/*/ - Deve-se utilizar o acols, pois pedido ainda não está gravado  - Andre R. Esteves - 24/11/2015
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbSeek(xFilial("SC6")+SC5->C5_NUM)
	
	While SC6->(!EOF()) .And. SC6->C6_FILIAL==xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
		nTotal += SC6->C6_VALOR
		SC6->(dbSkip())
	EndDO
	/*/
	For _ni := 1 to Len(aCols)		
		nTotal += aCols[_ni,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_PRCVEN"   })] * aCols[_ni,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_QTDLIB"   })]		
	Next _ni
	
	//Abandona caso não tenha itens a liberar
	If nTotal == 0
		Return(Nil)
	EndIf
	//verifica se o valor e baixo e nao precisa de alcada
	If nTotal < nLimite1
		U_LibPedVen(SC5->C5_NUM)
	Else
		oProcess := TWFProcess():New("000001","Pedido de Venda")
		oProcess:NewTask('Aprovacao PV',"\workflow\HTM\RFATE50.htm")
		
		dbSelectArea("SA1")              // Seleciona Cliente
		dbSetOrder(1)
		dbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
		
		//oProcess:cBCC     := ''
		oProcess:cSubject := "Ped.Venda fil./no." + xFilial("SC5") + "/" + SC5->C5_NUM + " - Cliente " + SC5->C5_CLIENTE + "  " + AllTrim(SA1->A1_NOME)
		//oProcess:cBody    := ""
		oProcess:bReturn  := "U_RFATE50(1)"
		
		//oProcess:Track("100100",,"","PROCESSO")
		//oProcess:Track("100200",,"","DECISAO")
		//oProcess:Track("100300",,"","ENVIAR MENSAGEM")
		oProcess:NewVersion(.T.)
		
		oHtml   := oProcess:oHtml
		
		cWFID := oProcess:fProcessId
		
		aItens  := {}
		
		dbSelectArea("SC6")              // Seleciona SC6 - Itens de Pedidos de Venda
		dbSetOrder(1)  //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		dbSeek(xFilial("SC6")+SC5->C5_NUM)
		
		While SC6->(!EOF()) .And. SC6->C6_FILIAL==xFilial("SC6") .And. SC6->C6_NUM==SC5->C5_NUM
			
			//Posiciona SC9 - Envia somente itens que tiveram liberacao
			dbSelectArea("SC9")
			dbSetOrder(1)   //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
			If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
				
				dbSelectArea("SC6")
				//Grava o ID do workflow
				If SC6->(FieldPos("C6_WFID")) > 0 .And.RecLock("SC6",.F.)
					SC6->C6_WFID := cWFID
					SC6->(MsUnlock())
				EndIf
				
				aAdd(aItens, {SC9->C9_ITEM  		  ,;   // 1 Numero do Item do Pedido
				SC9->C9_PRODUTO         ,;   // 2 Codigo do Produto
				Alltrim(SC6->C6_DESCRI) ,;   // 3 Descrição Auxiliar
				SC6->C6_ENTREG          ,;   // 4 Data de Entrega
				SC6->C6_UM              ,;   // 5 Unidade de Medida
				SC9->C9_QTDLIB          ,;   // 6 Quantidade Vendida
				SC9->C9_PRCVEN          ,;   // 7 Preco Unitario Liquido
				SC9->C9_PRCVEN * SC9->C9_QTDLIB  })   // 8 Valor Total do Item
			EndIf
			SC6->(dbSkip())
			
		EndDO
		
		dbSelectArea("SE4")              // Seleciona SE4 - Condicoes de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4") + SC5->C5_CONDPAG)
		
		dbSelectArea("SA3")             // Seleciona SA3 - Vendedores
		dbSetOrder(1)
		dbSeek(xFilial("SA3") + SC5->C5_VEND1)
		
		ProcessaWF(oProcess, oHtml, aItens, cWFID, cTo, cCC, _nOpcao)
		
	EndIf
	
ElseIf _nOpcao == 1   // Retorno do email de Liberação de Crédito
	
	//_cAprovar := oProc:oHtml:RetByName('Aprovacao')
	cPedido   := oProc:oHtml:RetByName('C5_NUM')         // Numero do P.V.
	lbmotivo  := oProc:oHtml:RetByName('lbmotivo')            // observacao da rejeicao
	nTotal    := Val(oProc:oHtml:RetByName("vlrtot"))
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cPedido)
	
	cTo := ""
	dbSelectArea("SA3")
	dbSeek(xFilial("SA3") + SC5->C5_VEND1)
	If !Empty(SA3->A3_EMAIL)
		cTo := AllTrim(SA3->A3_EMAIL)
	EndIf
	
	cCc := ""
	If SC5->(FieldPos("C5_USERLGI")) > 0
		cUserLGI := FWLeUserlg("C5_USERLGI")
		PswOrder(2)
		If PswSeek(cUserLGI)
			aUserLGI := PswRet()
			cCC := AllTrim(aUserLGI[1][14])
		Endif
	EndIf
	
	//ConOut( "RBAPROVA -> " + Upper(AllTrim(oProc:oHtml:RetByName("RBAPROVA"))) )
	//ConOut("nTotal -> ValType() --> " + ValType(nTotal))
	//ConOut("nLimite2 -> ValType() --> " + ValType(nLimite2))
	
	If Upper(AllTrim(oProc:oHtml:RetByName("RBAPROVA"))) == "SIM" //oProc:oHtml:RetByName("RBAPROVA") == "S"
		
		If nTotal >= nLimite2
			
			dbSelectArea("SA1")              // Seleciona Cliente
			dbSetOrder(1)
			dbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
			
			oProcess := TWFProcess():New("000001","Pedido de Venda")
			oProcess:NewTask('Inicio',"\workflow\HTM\RFATE50.htm")
			
			//oProcess:cBCC     := ''
			//oProcess:cSubject := "Ped.Venda fil./no." + xFilial("SC5") + "/" + SC5->C5_NUM + " - Cliente " + SC5->C5_CLIENTE + "  " + AllTrim(SA1->A1_NOME)
			//oProcess:cBody    := ""
			oProcess:bReturn  := "U_RFATE50(2)"
			
			//oProcess:Track("100100",,"","PROCESSO")
			//oProcess:Track("100200",,"","DECISAO")
			//oProcess:Track("100300",,"","ENVIAR MENSAGEM")
			oHtml   := oProcess:oHtml
			
			cWFID := oProcess:fProcessID
			
			aItens  := {}
			dbSelectArea("SC6")              // Seleciona SC6 - Itens de Pedidos de Venda
			dbSetOrder(1)
			dbSeek(xFilial("SC6")+SC5->C5_NUM)
			
			While SC6->(!EOF()) .And. SC6->C6_FILIAL==xFilial("SC6") .And. SC6->C6_NUM==SC5->C5_NUM
				
				//Posiciona SC9 - Envia somente itens que tiveram liberacao
				dbSelectArea("SC9")
				dbSetOrder(1)   //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
				If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
					
					dbSelectArea("SC6")
					//Grava o ID do workflow
					If SC6->(FieldPos("C6_WFID")) > 0 .And.RecLock("SC6",.F.)
						SC6->C6_WFID := cWFID
						SC6->(MsUnlock())
					EndIf
					
					aAdd(aItens, {SC6->C6_ITEM,;   				// 1 Numero do Item do Pedido
					SC6->C6_PRODUTO,;   		// 2 Codigo do Produto
					Alltrim(SC6->C6_DESCRI),;	// 3 Descrição Auxiliar
					SC6->C6_ENTREG,;   			// 4 Data de Entrega
					SC6->C6_UM,;   				// 5 Unidade de Medida
					SC6->C6_QTDVEN,;   			// 6 Quantidade Vendida
					SC6->C6_PRCVEN,;   			// 7 Preco Unitario Liquido
					SC6->C6_VALOR})   			// 8 Valor Total do Item
				EndIf
				SC6->(dbSkip())
			EndDO
			
			dbSelectArea("SE4")              // Seleciona SE4 - Condicoes de Pagamento
			dbSetOrder(1)
			dbSeek(xFilial("SE4") + SC5->C5_CONDPAG)
			
			dbSelectArea("SA3")             // Seleciona SA3 - Vendedores
			dbSetOrder(1)
			dbSeek(xFilial("SA3") + SC5->C5_VEND1)
			
			ProcessaWF(oProcess, oHtml, aItens, cWFID, cTo, cCC, _nOpcao)
			
		Else
			//faz liberacao do pedido
			U_LibPedVen(SC5->C5_NUM)
			
			If Type("cTo") != "U"
				ConOut("cTo -> "  + cTo)
			EndIf
			If Type("cCC") != "U"
				ConOut("cCC -> "  + cCc)
			EndIf
			If Type("lbmotivo") != "U"
				ConOut("lbmotivo -> "  + lbmotivo)
			EndIf
			
			EnviarMail(SC5->C5_NUM, cTo, cCC, lbmotivo, "L") //Aprovado
		EndIf
		
	Else // Enviar e-mail para vendedor avisando da não aprovação do crédito
		
		EnviarMail(SC5->C5_NUM, cTo, cCC, lbmotivo, "B") // Reprovado
		
	Endif
	
ElseIf _nOpcao == 2 //envia para o segundo aprovador apos primeiro aprovador ter aprovado
	
	//_cAprovar := oProc:oHtml:RetByName('Aprovacao')
	cPedido   := oProc:oHtml:RetByName('C5_NUM')         // Numero do P.V.
	lbmotivo  := oProc:oHtml:RetByName('lbmotivo')            // observacao da rejeicao
	//nTotal    := oProc:oHtml:RetByBame("vlrtot")
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+cPedido)
	
	cTo := ""
	dbSelectArea("SA3")
	dbSeek(xFilial("SA3") + SC5->C5_VEND1)
	If !Empty(SA3->A3_EMAIL)
		cTo := AllTrim(SA3->A3_EMAIL)
	EndIf
	
	cCc := ""
	If SC5->(FieldPos("C5_USERLGI")) > 0
		cUserLGI := FWLeUserlg("C5_USERLGI")
		PswOrder(2)
		If PswSeek(cUserLGI)
			aUserLGI := PswRet()
			cCC := AllTrim(aUserLGI[1][14])
		Endif
	EndIf
	
	If Upper(AllTrim(oProc:oHtml:RetByName("RBAPROVA"))) == "SIM" //oProc:oHtml:RetByName("RBAPROVA") == "S"
		
		//faz liberacao do pedido
		U_LibPedVen(SC5->C5_NUM)
		EnviarMail(SC5->C5_NUM, cTo, cCC, lbmotivo, "L")//Aprovado
		
	Else
		
		EnviarMail(SC5->C5_NUM, cTo, cCC, lbmotivo, "B")//Reprovado
		
	EndIf
	
EndIf

Return Nil
//-------------------------------------------------------------------
/*/{Protheus.doc} ProcessaWF
Envia e-mail para os aprovadores

@author		TotalIT Solutions
@since		01/11/2015
@version	1.0
@obs		Ponto de Entrada MTA410T
/*/
//-------------------------------------------------------------------
Static Function ProcessaWF(oProcess, oHtml, aItens, cWFID, cTo, cCC, nOpcA)
Local nTotal		:= 0
Local nCount		:= 0
Local cURL			:= ""
Local cSubj			:= "Ped.Venda fil./no." + xFilial("SC5") + "/" + SC5->C5_NUM + " - Cliente " + SC5->C5_CLIENTE + "  " + AllTrim(SA1->A1_NOME)
Local cBCc			:= SuperGetMV("MV_XWFADM",,"")
Local cUserLGI
Local aUserLGI
Local oMail
Local cMailID
Local cAprovador 	:= ""
DEFAULT cTo  	:= ""
DEFAULT cCC  	:= ""
DEFAULT nOpcA		:= 0

DbSelectArea("SC5")
If SC5->(FieldPos("C5_WFID")) > 0 .And. RecLock("SC5")
	SC5->C5_WFID := cWFID
	SC5->(MsUnlock())
EndIf

oHtml:ValByName("c5_num"    , SC5->C5_NUM)
oHtml:ValByName("c5_cliente", SC5->C5_CLIENTE)
oHtml:ValByName("a1_nome"   , SA1->A1_NOME)
oHtml:ValByName("a1_end"    , SA1->A1_END)
oHtml:ValByName("a1_mun"    , SA1->A1_MUN)
oHtml:ValByName("a1_est"    , SA1->A1_EST)
oHtml:ValByName("a1_cgc"    , SA1->A1_CGC)
oHtml:ValByName("a1_inscr"  , SA1->A1_INSCR)
oHtml:ValByName("a1_inscrm" , SA1->A1_INSCRM)
oHtml:ValByName("c5_condpag", AllTrim(SC5->C5_CONDPAG))
oHtml:ValByName("e4_descri" , AllTrim(SE4->E4_DESCRI))
oHtml:ValByName("c5_vend1"  , SC5->C5_VEND1)
oHtml:ValByName("a3_nome"   , SA3->A3_NOME)

For nCount := 1 to Len(aItens)
	
	aAdd(oHtml:ValByName("it.it")     , aItens[nCount,1])
	aAdd(oHtml:ValByName("it.codprod"), aItens[nCount,2])
	aAdd(oHtml:ValByName("it.desc")   , aItens[nCount,3])
	aAdd(oHtml:ValByName("it.prev")   , aItens[nCount,4])
	aAdd(oHtml:ValByName("it.um")     , aItens[nCount,5])
	aAdd(oHtml:ValByName("it.qtd")    , TRANSFORM( aItens[nCount,6] ,'@E 9999,999.99'))
	aAdd(oHtml:ValByName("it.vlruni") , TRANSFORM( aItens[nCount,7] ,'@E 9999,999.99'))
	aAdd(oHtml:ValByName("it.vlrtot") , TRANSFORM( aItens[nCount,8] ,'@E 9999,999.99'))
	
	nTotal += (aItens[nCount,6]*aItens[nCount,7])
	
Next

oHtml:ValByName("vlrtot"    ,TRANSFORM(nTotal         ,'@E 9999,999.99'))
oHtml:ValByName("a1_lc"     ,TRANSFORM(SA1->A1_LC     ,'@E 9999,999.99'))
oHtml:ValByName("a1_saldup" ,TRANSFORM(SA1->A1_SALDUP ,'@E 9999,999.99'))
oHtml:ValByName("a1_salpedl",TRANSFORM(SA1->A1_SALPEDL,'@E 9999,999.99'))
oHtml:ValByName("a1_sallim" ,TRANSFORM(SA1->A1_LC - ABS(SA1->A1_SALDUP),'@E 9999,999.99'))
oHtml:ValByName("a1_pedatu" ,TRANSFORM(nTotal,'@E 9999,999.99'))
oHtml:ValByName("a1_salped" ,TRANSFORM(SA1->A1_SALPED,'@E 9999,999.99'))
oHtml:ValByName("a1_pricom" ,SA1->A1_PRICOM)
oHtml:ValByName("a1_nrocom" ,TRANSFORM(SA1->A1_NROCOM ,'@E 9999,999.99'))
oHtml:ValByName("a1_dtultit",SA1->A1_DTULTIT)
oHtml:ValByName("a1_titprot",TRANSFORM(SA1->A1_TITPROT,'@E 9999,999.99'))
oHtml:ValByName("a1_chqdevo",TRANSFORM(SA1->A1_CHQDEVO,'@E 9999,999.99'))
oHtml:ValByName("a1_mcompra",TRANSFORM(SA1->A1_MCOMPRA,'@E 9999,999.99'))
oHtml:ValByName("a1_maidupl",TRANSFORM(SA1->A1_MAIDUPL,'@E 9999,999.99'))
oHtml:ValByName("a1_atr"    ,TRANSFORM(SA1->A1_ATR    ,'@E 9999,999.99'))
oHtml:ValByName("a1_venclc" ,SA1->A1_VENCLC)
oHtml:ValByName("a1_matr"   ,SA1->A1_MATR )
oHtml:ValByName("a1_ultcom" ,SA1->A1_ULTCOM)
oHtml:ValByName("a1_vacum"  ,TRANSFORM(SA1->A1_VACUM,'@E 9999,999.99'))
oHtml:ValByName("a1_dtulchq",SA1->A1_DTULCHQ)

//faz a verificacao de quantos aprovadores serao necessarios
/*If nTotal >= nLimite2
cAprov := "0"
If nTotal >= nLimite2
cAprov := "1"
EndIf
Else
cAprov := "2"
EndIf

oHtml:ValByName("cAprov", cAprov)*/

If Type("cUserName") != "U" .And. ValType(cUserName) == "C"
	oProcess:ClientName(cUserName)
EndIf
If Type("__cUserID") != "U" .And. ValType(__cUserID) == "C"
	oProcess:UserSiga := __cUserID
EndIf

oProcess:NewVersion(.T.)

If Empty(cTo)
	If nOpcA >= 0 .And. nOpcA <= 1
		cTo := cAprova1
	Else
		cTo := cAprova2
	EndIf
EndIf

If nOpcA >= 0 .And. nOpcA <= 1
	cAprovador := AllTrim(SuperGetMV("MV_XAPROV1",,"Claudio Buarque"))
Else
	cAprovador := AllTrim(SuperGetMV("MV_XAPROV2",,"Aprovador 2"))
EndIf
/*
If Empty(cCC)
	If SC5->(FieldPos("C5_USERLGI")) > 0
		cUserLGI := FWLeUserlg("C5_USERLGI")
		PswOrder(2)
		If PswSeek(cUserLGI)
			aUserLGI := PswRet()[1]
			cCC := AllTrim(aUserLGI[14])
		Endif
	EndIf
EndIf
*/
// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
// a ser executado o método Start() para se gerado todo processo e enviar a mensagem
// ao destinatário.
//oProcess:Start()

//RastreiaWF( ID do Processo, Codigo do Processo, Codigo do Status, Descricao Especifica, Usuario )
//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,"000003",'1003',"Email Enviado Para liberação1 de Crédito",cUsername)

oProcess:cTo  	:= ""
oProcess:cCC  	:= ""
oProcess:cBCC 	:= ""

cMailID := oProcess:Start("\workflow\messenger\emp"+cEmpAnt+"\pedven")

cURL			:= "http://"
cURL			+= AllTrim(SuperGetMV("MV_WFDHTTP",,""))
cURL			+= "/messenger/emp"
cURL			+= cEmpAnt
cURL			+= "/pedven/"
cURL			+= cMailID
cURL			+= ".htm"

oMail := TWFProcess():New( "000010", "Link de Processos de Workflow" )
oMail:NewTask("Link de Processos Workflow", "\workflow\WFLINK.HTM")  // Html com link para envio

//oProcess:NewTask("link", "\workflow\wflink.htm")
//oProcess:oHtml:ValByName("proc_link","http://127.0.0.1/wf/messenger/emp"+cempant+"/pedven/"+ cMailID + ".htm")
//oMail:oHtml:ValByName("proc_link", "\workflow\emp"+cEmpAnt+"\pedven\"+ cMailID + ".htm")
oMail:oHtml:ValByName("proc_link", cURL)
//oMail:oHtml:ValByName("proc_link", AllTrim(SuperGetMV("MV_WFDHTTP",,""))+"/"+ cMailID + ".htm")

oMail:oHtml:ValByName("usuario"  , Upper(cAprovador) + ",")
oMail:oHtml:ValByName("referente", "alçada de vendas." )

oMail:cTo      := cTo
oMail:cCC      := cCc
oMail:cBCC     := cBCc
oMail:csubject := cSubj

// Apos ter repassado todas as informacoes necessarias para o workflow, solicite a
// a ser executado o método Start() para se gerado todo processo e enviar a mensagem
// ao destinatário.
oMail:Start()

oMail:Free()
oMail:= Nil

//WFSendMail()

Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} EnviarMail
Envia e-mail de notificação

@author		TotalIT Solutions
@since		01/11/2015
@version	1.0
@obs		Ponto de Entrada MTA410T
/*/
//-------------------------------------------------------------------
Static Function EnviarMail(cPedVen, cTo, cCC, lbmotivo, cAprova)
Local lResult	:= .F.
Local cBCc	    := SuperGetMV("MV_XWFADM",,"gmuniz@totalitsolutions.com.br")
Local cServer   := SuperGetMV("MV_RELSERV",,"")
Local cFrom	   	:= SuperGetMV("MV_RELACNT",,"")
Local cConta   	:= SuperGetMV("MV_RELACNT",,"")
Local cSenha   	:= SuperGetMV("MV_RELPSW" ,,"")
Local lAuth 	:= SuperGetMV("MV_RELAUTH",,.F.)
Local cContAuth	:= Iif(!lAuth,"",Trim( GetMV( 'MV_RELACNT',, '' ) ))
Local cPswAuth	:= Iif(!lAuth,"",Trim( GetMV( 'MV_RELAPSW',, '' ) ))
Local nA		:= 0
Local cError   	:= ""
Local cSubject 	:= ""
Local cHtml		:= ""
Local cNotific	:= ""
Local nTotal	:= 0
Local lRet		:= .T.

If cAprova == "L"
	cSubject := "Aprovacao Ped.Venda fil./no."+xFilial("SC5")+"/"+cPedVen
	cNotific := "Ped.Venda fil./no." + xFilial("SC5") + "/" + cPedVen + " aprovado"
Else
	cSubject := "Rejeicao Ped.Venda fil./no."+xFilial("SC5")+"/"+cPedVen
	cNotific := "Ped.Venda fil./no." + xFilial("SC5") + "/" + cPedVen + " reprovado"
EndIf

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+ cPedVen)

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI)

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(xFilial("SA3") + SC5->C5_VEND1)

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4") + SC5->C5_CONDPAG)

cHtml := "<html>"
cHtml += "<head>"
cHtml += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
cHtml += "<meta name='GENERATOR' content='Microsoft FrontPage Express 2.0'>"
cHtml += "<title>Liberação de Credito</title>"
cHtml += "</head>"
cHtml += "<body background='file:///e:/ap6/workflow/evento/fundo609.jpg' bgcolor='#FFFFFF' bgproperties='fixed'>"
cHtml += "<tr>"
cHtml += "<td width='9%'>&nbsp;</td>"
cHtml += "<td width='40%'><div align='center'>"
cHtml += "<p style='text-align: center;' align='center'><b><span style='font-size: 18pt; font-family: Arial; '></span></b></p>"
cHtml += "<table style='text-align: left; width: 746px; height: 112px;' border='1' cellpadding='2' cellspacing='2'>"
cHtml += "<tbody>"
cHtml += "<tr>"
cHtml += "<td style='background-color: rgb(255, 255, 255);'>"
cHtml += "<p style='text-align: center;' align='center'><b><span style='font-size: 18pt; font-family: Arial;'>"+cNotific+"</span></b></p>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "</tbody>"
cHtml += "</table>"
cHtml += "<br>"
cHtml += "</td>"
cHtml += "<td></td>"
cHtml += "</tr>"
cHtml += "<table border='0' cellspacing='0' width='100%'>"
cHtml += "<tr>"
cHtml += "<td width='9%'>&nbsp;</td>"
cHtml += "<td width='40%'><div align='center'><center>"
cHtml += "<table border='0' cellspacing='0' width='100%'>"
cHtml += "<tr>"
cHtml += "<td width='55%' bgcolor='#DFEFFF' bordercolor='#FFFFFF'><p align='left'><font size='4' face='Arial'><strong>Cliente</strong></font></p></td>"
cHtml += "<td width='45%' bgcolor='#DFEFFF' bordercolor='#FFFFFF'><p align='right'><font size='4' face='Arial'><b>Pedido Venda </b>: "+SC5->C5_NUM+"</font></p></td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "</center>"
cHtml += "</div>"
cHtml += "<div align='center'><center><table border='0' width='100%' height='50'>"
cHtml += "<tr>"
cHtml += "<td valign='top' width='132%' height='20'><font size='2' face='Arial'><b>Nome</b> : "+SC5->C5_CLIENTE+" - "+AllTrim(SA1->A1_NOME)
cHtml += "</font>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "<tr>"
cHtml += "<td width='100%' height='18'>"
cHtml += "<font size='2' face='Arial'><b>Endereco</b>: " + AllTrim(SA1->A1_END)
cHtml += "</font>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "</center>"
cHtml += "</div>"
cHtml += "<table border='0' width='100%' height='26'>"
cHtml += "<tr>"
cHtml += "<td width='51%' height='22'>"
cHtml += "<font size='2' face='Arial'><b>Municipio/UF</b>: "+AllTrim(SA1->A1_MUN)+" - "+SA1->A1_EST
cHtml += "</font>"
cHtml += "</td>"
cHtml += "<td width='13%' height='22'>"
cHtml += "<font size='2' face='Arial'><b>CNPJ/CPF</b>"
cHtml += "</font>"
cHtml += "</td>"
cHtml += "<td width='36%' height='22'><p align='left'>"
cHtml += "<font size='2' face='Arial'>" + Transform(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))
cHtml += "</font>"
cHtml += "</p>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "<table border='0' width='679'>"
cHtml += "<tr>"
cHtml += "<td width='340'>"
cHtml += "<font size='2' face='Arial'><b>I.E.</b> : " + AllTrim(SA1->A1_INSCR)
cHtml += "</font>"
cHtml += "</td>"
cHtml += "<td width='81' height='22'>"
cHtml += "<font size='2' face='Arial'><b>C.C.M </b>"
cHtml += "</font>"
cHtml += "</td>"
cHtml += "<td width='238'>"
cHtml += "<font size='2' face='Arial'>" + AllTrim(SA1->A1_INSCRM)
cHtml += "</font>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "<table border='0' width='100%'>"
cHtml += "<tr>"
cHtml += "<td width='51%' height='1'>"
cHtml += "<font size='2' face='Arial'><b>Cond.Pagto.:</b> " + SC5->C5_CONDPAG + " - " + AllTrim(SE4->E4_DESCRI)
cHtml += "</font>"
cHtml += "</td>"
cHtml += "<td width='49%' height='1'>"
cHtml += "<font size='2' face='Arial'><b>Vendedor </b>: " + SC5->C5_VEND1 + " - " + AllTrim(SA3->A3_NOME)
cHtml += "</font>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "<table border='1' cellpadding='2' cellspacing='1' width='677'>"
cHtml += "<tr>"
cHtml += "<td width='50' bgcolor='#DFEFFF' height='19'>"
cHtml += "<p align='center'>"
cHtml += "<font face='Arial'>Item</font>"
cHtml += "</p>"
cHtml += "</td>"
cHtml += "<td width='234' bgcolor='#DFEFFF' height='19'>"
cHtml += "<p align='center'>"
cHtml += "<font face='Arial'>Descricao Produto</font>"
cHtml += "</p>"
cHtml += "</td>"
cHtml += "<td width='73' bgcolor='#DFEFFF' height='19'>"
cHtml += "<font face='Arial'>Prev. Entrega</font>"
cHtml += "</td>"
cHtml += "<td width='55' bgcolor='#DFEFFF' height='19'>"
cHtml += "<p align='center'>"
cHtml += "<font face='Arial'>Unid<strong>.</strong></font>"
cHtml += "</p>"
cHtml += "</td>"
cHtml += "<td width='58' bgcolor='#DFEFFF' height='19'>"
cHtml += "<p align='center'>"
cHtml += "<font face='Arial'>Qtde<strong>.</strong></font>"
cHtml += "</p>"
cHtml += "</td>"
cHtml += "<td width='69' bgcolor='#DFEFFF' height='19'>"
cHtml += "<p align='center'>"
cHtml += "<font face='Arial'>Vlr.Unit.</font>"
cHtml += "</p>"
cHtml += "</td>"
cHtml += "<td width='78' bgcolor='#DFEFFF' height='19'>"
cHtml += "<p align='center'>"
cHtml += "<font face='Arial'>Vlr. Total</font>"
cHtml += "</p>"
cHtml += "</td>"
cHtml += "</tr>"

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+SC5->C5_NUM)

While SC6->(!Eof()) .And. SC6->C6_FILIAL==xFilial("SC6") .And. SC6->C6_NUM==SC5->C5_NUM
	
	cHtml += "<tr>"
	cHtml += "<td width='50' height='18'>"
	cHtml += "<font size='2' face='Arial'>"+SC6->C6_ITEM+"</font></td>"
	cHtml += "<td width='234' height='18'>"
	cHtml += "<font size='2' face='Arial'>"+AllTrim(SC6->C6_PRODUTO)+" - "+AllTrim(SC6->C6_DESCRI)+"</font></td>"
	cHtml += "<td width='73' height='18'>"
	cHtml += "<font size='2' face='Arial'>"+DToC(SC6->C6_ENTREG)+"</font></td>"
	cHtml += "<td width='55' height='18'>"
	cHtml += "<font size='2' face='Arial'>"+SC6->C6_UM+"</font></td>"
	cHtml += "<td width='58' height='18'>"
	cHtml += "<p align='right'><font size='2' face='Arial'>"+Transform(SC6->C6_QTDVEN,'@E 9999,999.99')+"</font></p></td>"
	cHtml += "<td width='69' height='18'><p align='right'>"
	cHtml += "<font size='2' face='Arial'>"+Transform(SC6->C6_PRCVEN,'@E 9999,999.99')+"</font></p></td>"
	cHtml += "<td width='78' height='18'><p align='right'>"
	cHtml += "<font size='2' face='Arial'>"+Transform(SC6->C6_VALOR,'@E 9999,999.99')+"</font></p></td>"
	cHtml += "</tr>"
	
	nTotal += SC6->C6_VALOR
	
	SC6->(dbSkip())
EndDO

cHtml += "<tr>"
cHtml += "<td colspan='6' width='520'><p align='right'>"
cHtml += "<font size='2' face='Arial'><strong>Valor Total</strong></font><strong></strong></p>"
cHtml += "</td>"
cHtml += "<td width='78'><p align='right'>"
cHtml += "<font size='2' face='Arial'>"+Transform(nTotal,'@E 9999,999.99')+"</font></p>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "<table border='0' width='100%'>"
cHtml += "<tr>"
cHtml += "<td>&nbsp;</td>"
cHtml += "</tr>"
cHtml += "<tr>"
cHtml += "<td width='101%' height='118'>Motivo : <p><textarea name='S1' rows='3' cols='64'>"+lbmotivo+"</textarea></p></td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "</td>"
cHtml += "</tr>"
cHtml += "</table>"
cHtml += "</form>"
cHtml += "</body>"
cHtml += "</html>"

CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenha RESULT lResult

If !lResult
	Get MAIL ERROR cError
	ConOut("MAIL ERROR: " + cError)
	DISCONNECT SMTP SERVER
	Return  .F.
EndIf

If lAuth
	//
	// Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	//
	If ! ( lRet := MailAuth( cContAuth, cPswAuth )	 )
		//
		// Se nao conseguiu fazer a Autenticacao usando o E-mail completo,
		// tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
		//
		If !lRet
			nA 	      := At( '@', cContAuth )
			cContAuth := If( nA > 0, SubStr( cContAuth, 1, nA - 1 ), cContAuth )
			
			If !( lRet  := MailAuth( cContAuth, cPswAuth ) )
				GET MAIL ERROR cError
				Conout( 'Não conseguiu autenticar conta ( ' + cContAuth + ' )...MAIL ERROR: ' + cError )
				DISCONNECT SMTP SERVER
				Return  .F.
			EndIf
			
		EndIf
	EndIf
Endif   

SEND MAIL From cFrom TO cTo CC cCC SUBJECT cSubject BODY cHtml RESULT lResult

If !lResult
	GET MAIL ERROR cError
	ConOut("MAIL ERROR: " + cError)
Endif

DISCONNECT SMTP SERVER

Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} LibPedVen
Libera Pedido

@author		TotalIT Solutions
@since		01/11/2015
@version	1.0                                                                                       U
@obs		Ponto de Entrada MTA410T
/*/
//-------------------------------------------------------------------
//Static Function LibPedVen(cC5Num) 
User Function LibPedVen(cC5Num)
Local nQtdLib

dbSelectArea("SC5")
dbSetOrder(1)
MsSeek(xFilial("SC5") + cC5Num)

dbSelectArea("SC6")
dbSetOrder(1)
MsSeek(xFilial("SC6") + cC5Num)

While SC6->(!EOF()) .And. SC6->C6_FILIAL==xFilial("SC6") .And. SC6->C6_NUM==cC5Num
	
	//Posiciona SC9 - Envia somente itens que tiveram liberacao
	dbSelectArea("SC9")
	dbSetOrder(1)   //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	If dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
		
		
		If RecLock("SC5")
			//nQtdLib  := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) ) 
			nQtdLib  := SC9->C9_QTDLIB
			RecLock("SC6")
			Begin Transaction
//			MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.T.,.F.,.T.,.F.,.F.)
//			MaLibDoFat(SC6->(RecNo()),@nQtdLib,,,.F.,.T.,.F.,.F.)
//			MaLibDoFat(nRegSC6,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lGeraDCF,nVlrCred,nQtdalib2)
			a450Grava(1,.T.,.F.,.F.)
			
			End Transaction
		EndIf
		SC6->(MsUnLock())
		
		Begin Transaction
		SC6->(MaLiberOk({cC5Num},.F.))
		End Transaction
	EndIf
	SC6->(dbSkip())
EndDo
Return .T.
