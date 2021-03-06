#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QL04A010 � Autor � TOTALIT            � Data �  03/04/2020 ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para ler CSV e popular a tabela SB9                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function QL04A010()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt
//Private OkGeraTxt



//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo CSV")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo CSV, conforme"
@ 18,018 Say " os parametros definidos pelo usuario e ir� fazer a carga da tabela SB9"
@ 26,018 Say " Saldos Iniciais para 31/12/2019                "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  10/05/17   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/



Static Function OkGeraTxt()
Processa({|| RunCont() },"Processando...")

//Close(Txt)

Return

Static Function RunCont()

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������


Local cLinha  := ""
Local lPrim   := .T.
Local aCampos := {}
Local aDados  := {}
Local i := 0



//Private aErro := {}
Private cArqTxt := fGetPath()


FT_FUSE(cArqTxt)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()
	
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
	
	FT_FSKIP()
EndDo

//Begin Transaction
ProcRegua(Len(aDados))
For i:=1 to Len(aDados)
	IncProc("Incluindo Saldo Inicial Qualita 31/12/2019...")
	_cRastro := ""
	
	If SB1->(DbSeek(xFilial("SB1")+ Padr(aDados[I][1],TamSx3("B1_COD")[1])))
			Reclock("SB1",.F.)
			_cRastro := SB1->B1_RASTRO
			SB1->B1_RASTRO := "N"
			SB1->(MsUnlock())
		
		DbSelectArea("SB9")
		SB9->(DbSetOrder(1))
		Reclock("SB9",.T.)
		SB9->B9_FILIAL := xFilial("SB9")
		SB9->B9_COD    := aDados[I][1]
		SB9->B9_LOCAL  := aDados[I][2]
		SB9->B9_QINI   := Val(StrTran(aDados[I][3],',','.'))
		SB9->B9_VINI1  := Val(StrTran(aDados[I][4],',','.'))
		SB9->B9_DATA   := Ctod(aDados[I][5])
		SB9->B9_MCUSTD := "1"
		SB9->(MsUnlock())
		If !SB2->(DbSeek(xFilial("SB9")+Padr(aDados[I][1],TamSx3("B1_COD")[1])+aDados[I][2]))
			criaSB2(aDados[I][1],aDados[I][2])
		EndIf
		
		
	EndIf
	
	//	If !Empty(_cRastro)
	//	    Reclock("SB1",.F.)
	//	    SB1->B1_RASTRO := _cRastro
	//	    SB1->(MsUnlock())
	//	 EndIf
	
Next

//End Transaction

FT_FUSE()

ApMsgInfo("Importacao Realizada!","Saldos Iniciais")

Return



Static Function fGetPath()

Local cRet	:= Alltrim(ReadVar())
Local cPath	:= " "

oWnd := GetWndDefault()

While .T.
	If Empty(cPath)
		cPath := cGetFile( "Arquivos Texto de Importacao | *.CSV ",OemToAnsi("Selecione Arquivo"))
	EndIf
	
	If Empty(cPath)
		Return .F.
	EndIf
	&cRet := cPath
	Exit
EndDo

If oWnd != Nil
	GetdRefresh()
EndIf

Return(cPath)


