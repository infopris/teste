#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFINR01  ³ Autor ³ Osmil Squarcine       ³ Data ³ 05/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO DO BRASIL COM CODIGO DE BARRAS   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFINR02()
LOCAL cQuery, cAlias                                  
LOCAL	aPergs 		:= {} 
PRIVATE lExec    	:= .F.
PRIVATE cIndexName 	:= ''
PRIVATE cIndexKey  	:= ''
PRIVATE cFilter    	:= ''
Private cLogoCli  	:= "LogoCli.bmp"
Private cLogoBB  	:= "BBrasil.bmp"

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras"
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLBBRA"
lEnd     := .F.
cPerg    := "BLGJHA1XXX"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",2,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",2,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Banco      ","","","mv_ch7","C",3,0,0,"G","MV_PAR07 $ '001/033' .And. ExistCpo('SEE',MV_PAR07) ","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Agencia  ","","","mv_ch8","C",5,0,0,"G","ExistCpo('SEE',MV_PAR07+MV_PAR08)","MV_PAR08","","","","05843","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Conta    ","","","mv_ch9","C",10,0,0,"G","ExistCpo('SEE',MV_PAR07+MV_PAR08+MV_PAR09)","MV_PAR09","","","","17229-4","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Sub-Conta","","","mv_cha","C",10,0,0,"G","ExistCpo('SEE',MV_PAR07+MV_PAR08+MV_PAR09+MV_PAR10)","MV_PAR10","","","","17","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_chb","C",6,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_chc","C",6,0,0,"G","","MV_PAR12","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_chd","C",2,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_che","C",2,0,0,"G","","MV_PAR14","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/01","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/49","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chh","D",8,0,0,"G","","MV_PAR17","","","","01/01/01","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_chi","D",8,0,0,"G","","MV_PAR18","","","","31/12/49","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aPergs,{"Valor Multa",	"","","mv_chj","C",10,0,0,"G","","MV_PAR19","",	"",		"",		"1,00",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})
aAdd(aPergs,{"Juros Mensal","","","mv_chk","N",11,2,0,"G","","MV_PAR20","",	"",		"",		"5",			"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","","",""})


AjustaSx1(cperg,aPergs)

Pergunte (cPerg,.F.)

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR11 + "'.And.E1_CLIENTE<='" + MV_PAR12 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR13 + "'.And.E1_LOJA<='"+MV_PAR14+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par15)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par16)+"'.And."
cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par17)+"'.and.DTOS(E1_VENCREA)<='"+DTOS(mv_par18)+"'.And."
cFilter		+= "!(E1_TIPO$MVABATIM)"
//cFilter     += "E1_PORTADO=='"+MV_PAR07+"'.And.E1_AGEDEP=='"+MV_PAR08+"'.And.E1_CONTA=='"+MV_PAR09+"' "
//cFilter     += ".And. !Empty(E1_NUMBOR) "

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()

cQuery := "SELECT "
cQuery += "SE1.R_E_C_N_O_ RECSE1,E1_FILIAL,E1_NUM,E1_PARCELA,E1_TIPO "
cQuery += "FROM "+RetSQLName("SE1")+" SE1 "
cQuery += "WHERE "
cQuery += "SE1.D_E_L_E_T_=' ' "
cQuery += "AND E1_FILIAL='"+xFilial("SE1")+"' AND E1_SALDO>0 AND "
cQuery += "E1_PREFIXO>='" + MV_PAR01 + "' AND E1_PREFIXO<='" + MV_PAR02 + "' AND " 
cQuery += "E1_NUM>='" + MV_PAR03 + "' AND E1_NUM<='" + MV_PAR04 + "' AND "
cQuery += "E1_PARCELA>='" + MV_PAR05 + "' AND E1_PARCELA<='" + MV_PAR06 + "' AND "
cQuery += "E1_CLIENTE>='" + MV_PAR11 + "' AND E1_CLIENTE<='" + MV_PAR12 + "' AND "
cQuery += "E1_LOJA>='" + MV_PAR13 + "' AND E1_LOJA<='"+MV_PAR14+"' AND "
cQuery += "E1_EMISSAO>='"+DTOS(mv_par15)+"' AND E1_EMISSAO<='"+DTOS(mv_par16)+"' AND "
cQuery += "E1_VENCREA>='"+DTOS(mv_par17)+"' AND E1_VENCREA<='"+DTOS(mv_par18)+"' AND "
cQuery += "E1_TIPO NOT IN ('AB-','FB-','FC-','FU-','IR-','IN-','IS-','PI-','CF-','CS-','FE-','IV-') AND "
cQuery += "E1_NUMBCO=' ' "                                                                          
//cQuery += "E1_PORTADO='"+MV_PAR07+"' AND E1_AGEDEP='"+MV_PAR08+"' AND E1_CONTA='"+MV_PAR09+"' "
//cQuery += "AND E1_NUMBOR <> ' ' "AND E1_NUMBCO=' ' "                                                                  

cQuery := ChangeQuery(cQuery)
cAlias := GetNextAlias()
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)                 
//Estava Gerando o Nosso número - Bruno
/*
While (cAlias)->(!EOF())
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbGoTo((cAlias)->RECSE1)
	If Empty(SE1->E1_NUMBCO)
	
		dbSelectArea("SEE")
		dbSetOrder(1)
		If SEE->(dbSeek(xFilial("SEE") + MV_PAR07 + MV_PAR08 + MV_PAR09 + MV_PAR10))
			U_GrvDadBol(SE1->E1_PREFIXO,SE1->E1_NUM ,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SEE->EE_CODIGO,SUBSTR(SEE->EE_AGENCIA,1,5),SUBSTR(SEE->EE_CONTA,1,10),Alltrim(SEE->EE_SUBCTA))	
		EndIf
	EndIf		
	(cAlias)->(dbSkip())
EndDO
*/
(cAlias)->(dbCloseArea())

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
	
dbGoTop()
If lExec

	//Posiciona o SA6 (Parametros de Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA6") + MV_PAR07 + MV_PAR08 + MV_PAR09 )
       Aviso( "Atenção ! " , "O Banco : " + Alltrim(MV_PAR07) + " Agencia : " + Alltrim(MV_PAR08) + " Conta : " + Alltrim(MV_PAR09) + " nào foram encontrados no cadastro de bancos !" , {"Ok"} , 1 , "Banco não encontrado !" )
       Return
	Endif
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	If !DbSeek(xFilial("SEE") + MV_PAR07 + MV_PAR08 + MV_PAR09 + MV_PAR10)
       Aviso( "Atenção ! " , "Não existem parametros de bancos Cnab (SEE) cadastrados para a o Banco : " + Alltrim(MV_PAR07) + " Agencia : " + Alltrim(MV_PAR08) + " Conta : " + Alltrim(MV_PAR09) + " e Sub-Conta : " + Alltrim(MV_PAR10) + " . Cadastre os Parametros de Bancos antes de Imprimir o Boleto !" , {"Ok"} , 1 , "Parametros Bancos" )
       Return
    Endif   
                            
	Processa({|lEnd| MontaRel()})
	
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel  ³ Autor ³ Osmil Squarcine     ³ Data ³ 05/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO BANCO BRASIL CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	Iif(MV_PAR07=='033',SM0->M0_NOME,SM0->M0_NOMECOM)					  ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                     						  ,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          	   ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {" "		,;  //[1]Validade Boleto
 					   " "  	,;  //[2]Valor da Multa
 					   " "      ,;  //[3]Mora Diaria
					   " "	}       //[4]Protesto


LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

DbSelectArea("SE1")
dbGoTop()
ProcRegua(RecCount())
Do While SE1->(!EOF()) 
	
	//Bruno
	If !Marked("E1_OK")
		dbSkip()
		loop
	Endif

	//If Marked("E1_OK")
			//Posiciona o SA1 (Cliente)
			DbSelectArea("SA1")
			DbSetOrder(1) 
		
			If !DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA )
	           Aviso( "Atenção !" , "O Cliente  : " + SE1->E1_CLIENTE + " Loja : " + SE1->E1_LOJA + " não foi encontrado ! O Boleto não será Impresso !" , {"Ok"} , 1 , "Cliente não Encontrado !" )
		       DbSelectArea("SE1")
	    	   DbSkip()
	    	   Loop
	    	Endif

			If Empty (SE1->E1_NUMBCO)
		   		U_GrvDadBol( SE1->E1_PREFIXO , SE1->E1_NUM , SE1->E1_PARCELA , SE1->E1_TIPO , SE1->E1_CLIENTE , SE1->E1_LOJA , SEE->EE_CODIGO , SUBSTR(SEE->EE_AGENCIA, 1, 5) , SUBSTR(SEE->EE_CONTA,1,10) , Alltrim(SEE->EE_SUBCTA) )
			EndIf   

	    	DbSelectArea("SEE")
			DbSetOrder(1)
			aDadosBanco  := {SEE->EE_CODIGO                    						       ,;	// [1]Numero do Banco
	   	                   	Iif(SEE->EE_CODIGO=="001","BANCO DO BRASIL","BANCO SANTANDER") ,; 	// [2]Nome do Banco
			               	SUBSTR(ALLTRIM(SEE->EE_AGENCIA)+SEE->EE_DVAGE, 1, 5)  	       ,;	// [3]Agência
	   	                   	SUBSTR(SEE->EE_CONTA,1,5)								       ,; 	// [4]Conta Corrente
	   	                   	SEE->EE_DVCTA                                       	       ,; 	// [5]Dígito da conta corrente
	   	                   	Iif(SEE->EE_CODIGO=="001",SEE->EE_SUBCTA,SEE->EE_CODCART)      ,;   // [6]Codigo da Carteira
	   	                   	0				 										       ,;	// [7]Vazio
	   	                   	SUBSTR(SEE->EE_CODEMP,1,7)								}	        // [8]Codigo do Convenio do Cliente no Banco do Brasil

	   	
			If Empty(SA1->A1_ENDCOB) .OR. Empty(SA1->A1_CEPC) 
				aDatSacado   := {AllTrim(SA1->A1_NOME)           	,;     	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;     	// [2]Código
				AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;     	// [3]Endereço
				AllTrim(SA1->A1_MUN )                            	,;  	// [4]Cidade
				SA1->A1_EST                                      	,;    	// [5]Estado
				SA1->A1_CEP                                      	,;     	// [6]CEP
				SA1->A1_CGC										 	,;  	// [7]CGC
				SA1->A1_PESSOA										}		// [8]PESSOA
			Else
				aDatSacado   := {AllTrim(SA1->A1_NOME)          	,;   	// [1]Razão Social
				AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;   	// [2]Código
				AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
				AllTrim(SA1->A1_MUNC)	                     		,;   	// [4]Cidade
				SA1->A1_ESTC	                                    ,;   	// [5]Estado
				SA1->A1_CEPC                                    	,;   	// [6]CEP
				SA1->A1_CGC											,;		// [7]CGC
				SA1->A1_PESSOA										}		// [8]PESSOA
			Endif
			
   	
			//Aqui esta o Calculo do Digito Verificador do Nosso Numero do Banco do Brasil
			//Modulo 11 da juncao do Nr do Conveio + Seguencial de Nr Bancario do SEE
			nNrBancario := Iif(SEE->EE_CODIGO == '033',Alltrim(SE1->E1_NUMBCO),StrZero(Val(Alltrim(SE1->E1_NUMBCO)),10))
			nNrConvenio := SUBSTR(SEE->EE_CODEMP,1,7)
			nNrBanc		:= Alltrim(nNrConvenio) + Alltrim(nNrBancario)
			nDVNrBanc	:= modulo11A(nNrBanc) // Div verifacador Convenio + Seguencial do Nosso Num 

	
			aDadosTit	:= {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)		,;  // [1] Número do título
								SE1->E1_EMISSAO                      			,;  // [2] Data da emissão do título
								dDataBase                    	     			,;  // [3] Data da emissão do boleto
								SE1->E1_VENCREA                       			,;  // [4] Data do vencimento
								U_CalcVal()                          			,;  // [5] Valor do título  								
								SE1->E1_NUMBCO					     			,;  // [6] Nosso número (Ver fórmula para calculo)
								SE1->E1_PREFIXO                      			,;  // [7] Prefixo da NF
								SE1->E1_TIPO	                     			,;	// [8] Tipo do Titulo
								SE1->E1_DESCFIN									}	// [9] Desconto Financeiro

			//Monta codigo de barras
			aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[8],nNrBancario,aDadosTit[5],SE1->E1_VENCREA,nDVNrBanc,aDadosBanco[6])
			

			aBolText[1] := "APÓS O VENCIMENTO MORA DIA R$ "+Alltrim(Transform((SE1->E1_VALOR*(MV_PAR20/100))/30,"@E 99,999,999.99"))
			aBolText[2] := "MULTA DE "+ALLTRIM(MV_PAR19)+"% APÓS O VENCIMENTO."
			aBolText[4] := "PROTESTO: 3 DIAS UTEIS, CONSIDERANDO O DIA DO VENCIMENTO."
			                                                                                    
			If SEE->EE_CODIGO == "001" 
				BolBBrasil(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,nDVNrBanc)// Boleto BB
			Else
				BolSantander(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,nDVNrBanc)// Boleto Santander				
			Endif
			
			nX := nX + 1
        
        //dbSkip()
        //loop
	//EndIf
	SE1->(dbSkip())
	IncProc()
	nI := nI + 1
EndDo
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BolBBrasil ³ Autor ³ Microsiga          ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESS BOLETO LASER DO BCO DO BRASIL COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BolBBrasil(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,nDVNrBanc)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

oPrint:SayBitmap(0137,100,cLogoBB,405,080)		// Imprime o Logo do Banco
oPrint:SayBitmap(0480,850,cLogoCli,600,600)	// Imprime o Logo do Cliente - Marca D'agua

oPrint:Line (nRow2+0210,100,nRow2+0210,2300)
oPrint:Line (nRow2+0210,500,nRow2+0130, 500)
oPrint:Line (nRow2+0210,710,nRow2+0130, 710)

oPrint:Say  (nRow2+0135,515,"001-9"				,oFont20)		// [1]Numero do Banco
oPrint:Say  (nRow2+0144,1800,"Recibo do Sacado"	,oFont10)

oPrint:Line (nRow2+0310,100,nRow2+0310,2300 )
oPrint:Line (nRow2+0410,100,nRow2+0410,2300 )
oPrint:Line (nRow2+0480,100,nRow2+0480,2300 )
oPrint:Line (nRow2+0550,100,nRow2+0550,2300 )

oPrint:Line (nRow2+0410,500,nRow2+0550,500)
oPrint:Line (nRow2+0480,750,nRow2+0550,750)
oPrint:Line (nRow2+0410,1000,nRow2+0550,1000)
oPrint:Line (nRow2+0410,1300,nRow2+0480,1300)
oPrint:Line (nRow2+0410,1480,nRow2+0550,1480)

oPrint:Say  (nRow2+0210,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0225,400 ,"Pagavel em qualquer Banco até o Vencimento, após, somente nas agências",oFont10)
oPrint:Say  (nRow2+0265,400 ,"do Banco do Brasil.                       ",oFont10)

oPrint:Say  (nRow2+0210,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow2+0250,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0310,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (nRow2+0350,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0310,1810,"Agência/Código Cedente",oFont8)
cString :=  SUBSTR(aDadosBanco[3],1,4)+"-"+SUBSTR(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
nCol := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow2+0350,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0410,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0440,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0410,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+0440,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0410,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0440,1050,"DM"     										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0410,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0440,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0410,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0440,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0410,1810,"Nosso Número"                                   ,oFont8)
cString :=  Alltrim(aDadosBanco[8])+Alltrim(aDadosTit[6])
nCol := 1660+(594-(len(cString)*22))
oPrint:Say  (nRow2+0440,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0480,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+0480,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+0510,555 ,aDadosBanco[6]+"/019"                            ,oFont10)

oPrint:Say  (nRow2+0480,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+0510,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+0480,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0480,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0480,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1915+(374-(len(cString)*22))
oPrint:Say  (nRow2+0510,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+0550,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)

oPrint:Say  (nRow2+0600,100 ,aBolText[1],oFont8)
oPrint:Say  (nRow2+0650,100 ,aBolText[2],oFont8)
oPrint:Say  (nRow2+0700,100 ,aBolText[3]  ,oFont8)
oPrint:Say  (nRow2+0750,100 ,aBolText[4]  ,oFont8)

oPrint:Say  (nRow2+0550,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+0620,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow2+0690,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+0760,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow2+0830,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow2+0900,100 ,"Sacado"                                         ,oFont10)
oPrint:Say  (nRow2+0930,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (nRow2+0983,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+1036,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1089,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1089,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow2+1145,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1185,1500,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+0210,1800,nRow2+0900,1800 ) 
oPrint:Line (nRow2+0620,1800,nRow2+0620,2300 )
oPrint:Line (nRow2+0690,1800,nRow2+0690,2300 )
oPrint:Line (nRow2+0760,1800,nRow2+0760,2300 )
oPrint:Line (nRow2+0830,1800,nRow2+0830,2300 )
oPrint:Line (nRow2+0900,100 ,nRow2+0900,2300 )
oPrint:Line (nRow2+1140,100 ,nRow2+1140,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1380, nI, nRow3+1380, nI+30)
Next nI

oPrint:SayBitmap(1427,100,cLogoBB,405,080)       	// Imprime o Logo do Banco
oPrint:SayBitmap(1770,850,cLogoCli,600,600)		// Imprime o Logo da Cliente - Marca D'agua

oPrint:Line (nRow3+1500,100,nRow3+1500,2300)
oPrint:Line (nRow3+1500,500,nRow3+1420, 500)
oPrint:Line (nRow3+1500,710,nRow3+1420, 710)

oPrint:Say  (nRow3+1425,515,"001-9"				,oFont20 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1434,755,aCB_RN_NN[2]		,oFont14n)	//	Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+1600,100,nRow3+1600,2300 )
oPrint:Line (nRow3+1700,100,nRow3+1700,2300 )
oPrint:Line (nRow3+1770,100,nRow3+1770,2300 )
oPrint:Line (nRow3+1840,100,nRow3+1840,2300 )

oPrint:Line (nRow3+1700,500 ,nRow3+1840,500 )
oPrint:Line (nRow3+1770,750 ,nRow3+1840,750 )
oPrint:Line (nRow3+1700,1000,nRow3+1840,1000)
oPrint:Line (nRow3+1700,1300,nRow3+1770,1300)
oPrint:Line (nRow3+1700,1480,nRow3+1840,1480)

oPrint:Say  (nRow3+1500,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+1515,400 ,"Pagavel em qualquer Banco até o Vencimento , após , somente nas agências",oFont10)
oPrint:Say  (nRow3+1555,400 ,"do Banco do Brasil  ",oFont10)

oPrint:Say  (nRow3+1500,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow3+1540,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1600,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+1640,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+1600,1810,"Agência/Código Cedente",oFont8)
cString :=  SUBSTR(aDadosBanco[3],1,4)+"-"+SUBSTR(aDadosBanco[3],5,1)+"/"+aDadosBanco[8]
nCol 	 := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow3+1640,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+1700,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+1730,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+1700,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+1730,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+1700,1005,"Espécie Doc."                                   ,oFont8)
//oPrint:Say  (nRow3+1730,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
oPrint:Say  (nRow3+1730,1050,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+1700,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+1730,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+1700,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+1730,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+1700,1810,"Nosso Número"                                   ,oFont8)
cString :=  Alltrim(aDadosBanco[8])+Alltrim(aDadosTit[6])
nCol 	 := 1660+(594-(len(cString)*22))
oPrint:Say  (nRow3+1730,nCol,cString,oFont11c)


oPrint:Say  (nRow3+1770,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+1770,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+1800,555 ,aDadosBanco[6]+"/019"                            ,oFont10)

oPrint:Say  (nRow3+1770,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+1800,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+1770,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+1770,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+1770,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1915+(374-(len(cString)*22))
oPrint:Say  (nRow3+1800,nCol,cString,oFont11c)

oPrint:Say  (nRow2+1840,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+1890,100 ,aBolText[1],oFont8)


oPrint:Say  (nRow2+1940,100 ,aBolText[2],oFont8)

oPrint:Say  (nRow2+1990,100 ,aBolText[3]  ,oFont8)
oPrint:Say  (nRow2+2040,100 ,aBolText[4]  ,oFont8)

oPrint:Say  (nRow3+1840,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+1910,1810,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (nRow3+1980,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+2050,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow3+2120,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow3+2190,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow3+2200,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2200,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2200,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2253,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2306,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (nRow3+2355,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+2395,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRow3+1500,1800,nRow3+2190,1800 )
oPrint:Line (nRow3+1910,1800,nRow3+1910,2300 )
oPrint:Line (nRow3+1980,1800,nRow3+1980,2300 )
oPrint:Line (nRow3+2050,1800,nRow3+2050,2300 )
oPrint:Line (nRow3+2120,1800,nRow3+2120,2300 )
oPrint:Line (nRow3+2190,100 ,nRow3+2190,2300 )

oPrint:Line (nRow3+2350,100,nRow3+2350,2300  )

//MSBAR("INT25",11,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.014,0.7,Nil,Nil,"A",.F.)


//If nTipo = 2
//	MSBAR("INT25",13.0,1.0,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.7,Nil,Nil,"A",.F.)				// Código de Barras
//Else
	MSBAR("INT25",21.1,0.8,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)				// Código de Barras/
//EndIf




oPrint:EndPage() // Finaliza a página

Return Nil                                    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BolSantander ³ Autor ³ Microsiga        ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESS BOLETO LASER DO BCO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function BolSantander(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,nDVNrBanc)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
LOCAL cLogoBco := "SANTANDER.bmp"
LOCAL cDvNsNum
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0
                                            
oPrint:SayBitmap(nRow2+0137,100,cLogoBco,405,080)	// Imprime o Logo do Banco
oPrint:SayBitmap(nRow2+0480,850,cLogoCli,600,600)	// Imprime o Logo do Cliente - Marca D'agua

oPrint:Line (nRow2+0210,100,nRow2+0210,2300)
oPrint:Line (nRow2+0210,500,nRow2+0130, 500)
oPrint:Line (nRow2+0210,710,nRow2+0130, 710)

oPrint:Say  (nRow2+0135,0515,"033-7"			,oFont20)		// [1]Numero do Banco

oPrint:Say  (nRow2+0124,0755,"Beneficiário:"	,oFont10)                                                       
oPrint:Say  (nRow2+0124,1005,AllTrim(aDadosEmp[1])+" "+aDadosEmp[6],oFont8) //Nome + CNPJ
oPrint:Say  (nRow2+0164,1005,Upper(aDadosEmp[2]),oFont8)//Endereço

oPrint:Say  (nRow2+0220,0100,"RECIBO DO PAGADOR",oFont10) //Nome + CNPJ

//oPrint:Say  (nRow2+0280,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+0330,100 ,aBolText[1],oFont8)
oPrint:Say  (nRow2+0380,100 ,aBolText[2],oFont8)
oPrint:Say  (nRow2+0430,100 ,aBolText[4],oFont8)
//oPrint:Say  (nRow2+0480,100 ,aBolText[4],oFont8)


oPrint:Line (nRow2+0310,1800,nRow2+0310,2300 )
oPrint:Line (nRow2+0410,1800,nRow2+0410,2300 )
oPrint:Line (nRow2+0510,1800,nRow2+0510,2300 )
oPrint:Line (nRow2+0610,1800,nRow2+0610,2300 )
oPrint:Line (nRow2+0710,1800,nRow2+0710,2300 )

//oPrint:Line (nRow2+0410,500,nRow2+0550,500)
//oPrint:Line (nRow2+0480,750,nRow2+0550,750)
//oPrint:Line (nRow2+0410,1000,nRow2+0550,1000)
//oPrint:Line (nRow2+0410,1300,nRow2+0480,1300)
//oPrint:Line (nRow2+0410,1480,nRow2+0550,1480)

oPrint:Say  (nRow2+0210,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow2+0250,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0310,1810,"Nosso Número"                                   ,oFont8)
cString := Right('0000000000000' + AllTrim(Left(nNrBancario,13)),13)
//cDvNsNum := Modulo11A(cString, "033")
//If ValType(cDvNsNum)=="N"
//	cDvNsNum := AllTrim(Str(cDvNsNum))
//EndIf	
//cString :=  cString + cDvNsNum
nCol := 1660+(594-(len(cString)*22))
oPrint:Say  (nRow2+0350,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0410,1810 ,"Nro.Documento"                                  ,oFont8)
cString := AllTrim(aDadosTit[7]+aDadosTit[1])
nCol := 1660+(594-(Len(cString)*22))
oPrint:Say  (nRow2+0450,nCol ,cString,oFont11c) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0510,1810,"Agência/Código Beneficiário",oFont8)
cString :=  SUBSTR(aDadosBanco[3],1,4)+"-"+SUBSTR(aDadosBanco[3],5,1)+"/"+aDadosBanco[8]
nCol := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow2+0550,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0610,1810,"(=) Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1915+(374-(len(cString)*22))
oPrint:Say  (nRow2+0650,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+0725,0100,"Pagador",oFont8)
oPrint:Say  (nRow2+0725,1810,"Autenticação Mecânica",oFont8)

oPrint:Say  (nRow2+0785,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
If aDatSacado[8] = "J"
	oPrint:Say  (nRow2+0785,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+0785,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf
oPrint:Say  (nRow2+0838,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+0891,400 ,Alltrim(aDatSacado[6])+Iif(Empty(aDatSacado[6]),"","    ")+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Line (nRow2+0210,1800,nRow2+0710,1800 ) 
oPrint:Line (nRow2+0710,0100,nRow2+0710,2300 )
//oPrint:Line (nRow2+0690,1800,nRow2+0690,2300 )
//oPrint:Line (nRow2+0760,1800,nRow2+0760,2300 )
//oPrint:Line (nRow2+0830,1800,nRow2+0830,2300 )
//oPrint:Line (nRow2+0900,100 ,nRow2+0900,2300 )
//oPrint:Line (nRow2+1140,100 ,nRow2+1140,2300 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := -300
oPrint:Say  (nRow3+1340,100 ,"Sacador/Avalista",oFont8)
For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1380, nI, nRow3+1380, nI+30)
Next nI

oPrint:SayBitmap(nRow3+1427,100,cLogoBco,405,080)     // Imprime o Logo do Banco
oPrint:SayBitmap(nRow3+1770,850,cLogoCli,600,600)		// Imprime o Logo da Cliente - Marca D'agua

oPrint:Line (nRow3+1500,100,nRow3+1500,2300)
oPrint:Line (nRow3+1500,500,nRow3+1420, 500)
oPrint:Line (nRow3+1500,710,nRow3+1420, 710)

oPrint:Say  (nRow3+1425,515,"033-7"				,oFont20 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1434,755,aCB_RN_NN[2]		,oFont14n)	//	Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+1600,100,nRow3+1600,2300 )
oPrint:Line (nRow3+1700,100,nRow3+1700,2300 )
oPrint:Line (nRow3+1770,100,nRow3+1770,2300 )
oPrint:Line (nRow3+1840,100,nRow3+1840,2300 )

oPrint:Line (nRow3+1700,500 ,nRow3+1770,500 )
oPrint:Line (nRow3+1770,750 ,nRow3+1840,750 )
oPrint:Line (nRow3+1700,1000,nRow3+1840,1000)
oPrint:Line (nRow3+1700,1300,nRow3+1770,1300)
oPrint:Line (nRow3+1700,1480,nRow3+1840,1480)

oPrint:Say  (nRow3+1500,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+1515,400 ,"PAGAR PREFERENCIALMENTE NO BANCO SANTANDER",oFont10)

oPrint:Say  (nRow3+1500,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow3+1540,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1600,100 ,"Beneficiário",oFont8)
oPrint:Say  (nRow3+1640,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+1600,1810,"Agência/Código Cedente",oFont8)
cString :=  SUBSTR(aDadosBanco[3],1,4)+"-"+SUBSTR(aDadosBanco[3],5,1)+"/"+aDadosBanco[8]
nCol 	 := 1910+(374-(len(cString)*22))
oPrint:Say  (nRow3+1640,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+1700,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+1730,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+1700,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+1730,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+1700,1005,"Espécie Doc."                                   ,oFont8)
//oPrint:Say  (nRow3+1730,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
oPrint:Say  (nRow3+1730,1050,"DM"										,oFont10) //Tipo do Titulo
                            	
oPrint:Say  (nRow3+1700,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+1730,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+1700,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+1730,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+1700,1810,"Nosso Número"                                   ,oFont8)
cString := Right('0000000000000' + AllTrim(Left(nNrBancario,13)),13)
//cDvNsNum := Modulo11A(cString, "033")
//If ValType(cDvNsNum)=="N"
//	cDvNsNum := AllTrim(Str(cDvNsNum))
//EndIf	
//cString :=  cString + cDvNsNum
nCol 	 := 1660+(594-(len(cString)*22))
oPrint:Say  (nRow3+1730,nCol,cString,oFont11c)


//oPrint:Say  (nRow3+1770,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+1770,100 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+1800,100 ,"COBRANCA SIMPLES RCR"         ,oFont11c) //aDadosBanco[6]

oPrint:Say  (nRow3+1770,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+1800,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+1770,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+1770,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+1770,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1915+(374-(len(cString)*22))
oPrint:Say  (nRow3+1800,nCol,cString,oFont11c)

oPrint:Say  (nRow3+1840,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow3+1890,100 ,aBolText[1],oFont8)
oPrint:Say  (nRow3+1940,100 ,aBolText[2],oFont8)
oPrint:Say  (nRow3+1990,100 ,aBolText[4],oFont8)
//oPrint:Say  (nRow3+2040,100 ,aBolText[4],oFont8)

oPrint:Say  (nRow3+1840,1810,"(-)Desconto"                         			  ,oFont8)
oPrint:Say  (nRow3+1910,1810,"(-)Abatimento"	                              ,oFont8)
oPrint:Say  (nRow3+1980,1810,"(+)Mora"  	                                  ,oFont8)
oPrint:Say  (nRow3+2050,1810,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow3+2120,1810,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (nRow3+2190,100 ,"Pagador"                                         ,oFont8)
oPrint:Say  (nRow3+2200,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2200,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2200,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2253,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2306,400 ,Alltrim(aDatSacado[6])+Iif(Empty(aDatSacado[6]),"","    ")+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (nRow3+2355,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+2355,1500,"Autenticação Mecânica - FICHA DE COMPENSAÇÃO"   ,oFont8)

oPrint:Line (nRow3+1500,1800,nRow3+2190,1800 )
oPrint:Line (nRow3+1910,1800,nRow3+1910,2300 )
oPrint:Line (nRow3+1980,1800,nRow3+1980,2300 )
oPrint:Line (nRow3+2050,1800,nRow3+2050,2300 )
oPrint:Line (nRow3+2120,1800,nRow3+2120,2300 )
oPrint:Line (nRow3+2190,100 ,nRow3+2190,2300 )

oPrint:Line (nRow3+2350,100,nRow3+2350,2300  )

//MSBAR("INT25",11,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.014,0.7,Nil,Nil,"A",.F.)

//If nTipo = 2
//	MSBAR("INT25",13.0,1.0,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.013,0.7,Nil,Nil,"A",.F.)				// Código de Barras
//Else
	MSBAR("INT25",19.1,0.8,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)				// Código de Barras/
//EndIf

oPrint:EndPage() // Finaliza a página

Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 12/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do Modulo 10                                       ³±±
±±³          ³ para calcular os Digitos Verificadores da Linha Digitavel  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 12/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do Modulo 11                                       ³±±
±±³          ³ para calcular o Dig Verificador do Codigo de Barras        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11A³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo Modulo 11  										  ³±±
±±³          ³ especifico para Nosso Numero do Banco do Brasil            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11A(cData, cBanco)
LOCAL nResto, L, D, P := 0       
DEFAULT cBanco:= ""

L := Len(cData)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

If cBanco == "033"
	nResto := mod(D,11)
	//D := D - (nResto * 11)
Else
	D := 11 - (mod(D,11))
EndIf
                                       
If cBanco == "033"
	If (nResto >= 0 .And. nResto <= 1)
		D := 0
	ElseIf (nResto == 10)
		D := 1
	Else
		D := 11 - nResto
	End
Else
	If (D == 10)
		D := "X"
	ElseIf (D == 11)
		D := 0
	End
EndIf
Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Prepara os dados do Codigo de Barras e Linha Digitavel     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,nNrConvenio,nNrBancario,nValor,dVencto,nDVNrBanc,nCarteira)

LOCAL cValorFinal := Iif(SubStr(cBanco,1,3)=="001",strzero(int(nValor*100),10),strzero(nValor*100,10))
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator      	:= strzero(dVencto - ctod("07/10/97"),4)
LOCAL cCmpltoNsNr	:= '000000'
LOCAL cDvNsNum      := ''

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
If SubStr(cBanco,1,3) == "001"
	cS:= cBanco + cFator +  cValorFinal + cCmpltoNsNr + nNrConvenio + nNrBancario + nCarteira
ElseIf SubStr(cBanco,1,3) == "033"   
//	nNrBancario := Right('000000000000' + AllTrim(Left(nNrBancario,12)),12)                                                            
//	cDvNsNum := Modulo11A(nNrBancario, SubStr(cBanco,1,3))
//	If ValType(cDvNsNum)=="N"
//		cDvNsNum := AllTrim(Str(cDvNsNum))
//	EndIf		
//	cS:= cBanco + cFator +  cValorFinal + '9' + nNrConvenio + nNrBancario + cDvNsNum + '0' + nCarteira 
	cS:= cBanco + cFator +  cValorFinal + '9' + nNrConvenio + nNrBancario + '0' + nCarteira
EndIf                                                                                        

nDvcb := modulo11(Substr(cS,1,43))                                                           
cCB   := SubStr(cS, 1, 4) + Alltrim(str(nDvcb)) + SubStr(cS,5,39)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
If SubStr(cBanco,1,3) == "001"
	cS1   := cBanco + SubStr(cCmpltoNsNr,1,5)
	nDv1  := modulo10(cS1)
	cLD1  := SubStr(cS1, 1, 5) + '.' + SubStr(cS1, 6, 4) + AllTrim(Str(nDv1)) + '  '
	
	// 	CAMPO 2:
	//	DDDDDD = Restante do Nosso Numero
	//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
	//	   FFF = Tres primeiros numeros que identificam a agencia
	//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	
	cS2	:= SubStr(cCmpltoNsNr,6,1) + Alltrim(nNrConvenio)+ SubStr(nNrBancario,1,2)
	nDv2:= modulo10(cS2)
	cLD2:= SubStr(cS2, 1, 5) + '.' + SubStr(cS2, 6, 5) + AllTrim(Str(nDv2)) + '  '
	
	// 	CAMPO 3:
	//	     F = Restante do numero que identifica a agencia
	//	GGGGGG = Numero da Conta + DAC da mesma
	//	   HHH = Zeros (Nao utilizado)
	//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
	cS3   := SubStr(nNrBancario,3,8) + SubStr(nCarteira,1,2) 
	nDv3  := modulo10(cS3)
	cLD3  := SubStr(cS3, 1, 5) + '.' + SubStr(cS3, 6, 5) + AllTrim(Str(nDv3)) + '   '
	
	//	CAMPO 4:
	//	     K = DAC do Codigo de Barras
	cLD4  := AllTrim(Str(nDvcb)) + '   '
	
	// 	CAMPO 5:
	//	      UUUU = Fator de Vencimento
	//	VVVVVVVVVV = Valor do Titulo
	cLD5  := cFator + cValorFinal
Else
	cS1   := cBanco + '9' + SubStr(nNrConvenio,1,4)
	nDv1  := modulo10(cS1)                         	
	cLD1  := SubStr(cS1, 1, 10) +'.'+ SubStr(cS1, 11) + AllTrim(Str(nDv1)) + ' '
	
	cS2	:= SubStr(nNrConvenio,5,3) + SubStr(nNrBancario,1,7)
	nDv2:= modulo10(cS2)
	cLD2:= SubStr(cS2, 1, 10) +'.'+ SubStr(cS2, 11) + AllTrim(Str(nDv2)) + ' '
	
//	cS3   := SubStr(nNrBancario,8)+ cDvNsNum + '0' + SubStr(nCarteira,1,3)  
	cS3   := SubStr(nNrBancario,8)+ '0' + SubStr(nCarteira,1,3) 
	nDv3  := modulo10(cS3)
	cLD3  := SubStr(cS3, 1, 10) + '.' + SubStr(cS3, 11) + AllTrim(Str(nDv3)) + ' '
	
	cLD4  := AllTrim(Str(nDvcb)) + ' '
	cLD5  := cFator + cValorFinal
EndIf	

cLD	  := cLD1 + cLD2 + cLD3 + cLD4 + cLD5

Return({cCB,cLD})


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
