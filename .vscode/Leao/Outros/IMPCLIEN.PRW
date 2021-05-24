#Include "RwMake.ch"

/*
*****************************************************************************
** Funcao     ImpClien    Autor   Alexandro Dias          Data   02.07.01  **
*****************************************************************************
** Descricao  Importação do arquivos de Clientes                           **
*****************************************************************************
** Alterado por : Dante Puccia Neto - 09/08/2001                           **
*****************************************************************************
*/

User Function IMPCLIEN()

Processa({|| PCliente() })

Return

Static Function PCliente()

Local _nTotReg := 0
Local _nRegAtu := 0
Local _nCgc    := ""

DbUseArea (.T.,, "\SIGAADV\IMPCLI.DBF",'CADCLI', .T., .T. )

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

dbSelectArea("CADCLI")
Index On A1_FILIAL+A1_COD+A1_LOJA to TMP01

dbSelectArea("SA1")
dbSetOrder(1)

While !Eof()
	If SA1->A1_TIPO == "*"
		dbSelectArea("CADCLI")
		dbSeek(xFilial()+SA1->A1_COD+A1_LOJA)
		If Found()
			dbSelectArea("SA1")
			RecLock("SA1",.F.)
			SA1->A1_TIPO := CADCLI->A1_TIPO
			SA1->A1_CEP  := CADCLI->A1_CEP
			SA1->A1_INSCR:= CADCLI->A1_INSCR
			SA1->A1_ENDCOB := CADCLI->A1_ENDCOB
			MsUnlock()
		Endif
	Endif 
	_nRegAtu++
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" - "+CADCLI->A1_COD)
	DbSelectArea("SA1")
	DbSkip()
EndDo                                                                                     

CADCLI->( DbCloseArea() )

MsgBox("Fim do Processamento !!!","Atencao","INFO")

Return

