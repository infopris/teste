#Include "RwMake.ch"

/*
*****************************************************************************
** Funcao       ; IMPFORNE.PRW   Autor   Alexandro Dias   Data   04.07.01  **
*****************************************************************************
** Descricao    : Importacao do arquivos de Fornecedores                   **
*****************************************************************************
** Alterado por : Dante Puccia Neto - 09/08/2001                           **
*****************************************************************************
*/

User Function IMPFORNE()

Processa({|| PFornece() })

Return

Static Function PFornece()

Local _nTotReg := 0
Local _nRegAtu := 0
Local _nCgc    := ""

Do While .T.
	DbUseArea (.T.,, "\IMPORT\FORNEC.DBF",'CADFOR', .T., .T. )
	If Select ( "CADFOR" ) == 0
		MsgBox(" Nao foi possivel abrir o arquivo de clientes","Atencao","INFO")
		Return ( Nil )
	Endif
	Exit
Enddo

_nTotReg := RecCount()

DbGoTop()

ProcRegua(_nTotReg)

Do While !CADFOR->(Eof())
	

	DbSelectArea("SA2")
	DbSetOrder(3)
	
	_cCgc := Alltrim(U_PString(CADFOR->CGC))

	IF Empty(_cCgc)
	   
	   DbSetOrder(2)
	   IF DbSeek( xFilial("SA2") + Alltrim(CADFOR->NOME) )
	      Atualiza(.F.)
	   Else 
	      Atualiza(.T.)
	   EndIF   	
		
	ElseIF DbSeek(xFilial("SA2") + _cCgc )
	
		IF ( Len(Alltrim(SA2->A2_NOME)) < Len(Alltrim(CADFOR->NOME)) )
		   Atualiza(.F.)
		EndIF
	
	Else
		Atualiza(.T.)
	EndIF
	
	_nRegAtu++
	IncProc(StrZero(_nRegAtu,6)+"/"+StrZero(_nTotReg,6)+" - "+Substr(CADFOR->NOME,1,20))
		
	DbSelectArea("CADFOR")
	DbSkip()

EndDo

CADFOR->( DbCloseArea() )

MsgBox("Fim do Processamento !!!","Atencao","INFO")

Return

Static Function Atualiza(_lRet)

Local _lRet       := _lRet
Local _cCodigo    := ""

IF _lRet
	_cCodigo := GetSX8Num("SA2","A2_COD")
	ConfirmSx8()
Else
	_cCodigo := SA2->A2_COD
EndIF

RecLock("SA2",_lRet)
Replace A2_FILIAL   With xFilial("SA2")
Replace A2_COD      With _cCodigo      
Replace A2_LOJA     With "01"
Replace A2_TIPO     WITh "J"
Replace A2_NOME     With CADFOR->NOME
Replace A2_NREDUZ   With Substr(CADFOR->NOME,1,15)
Replace A2_CGC      With U_PString(CADFOR->CGC)
Replace A2_END      With CADFOR->ENDERECO
Replace A2_BAIRRO   With CADFOR->BAIRRO
Replace A2_MUN      With CADFOR->CIDADE
Replace A2_EST      With CADFOR->ESTADO
Replace A2_EMAIL    With CADFOR->EMAIL
Replace A2_TELEX    With CADFOR->TELEX
Replace A2_CX_POSTA With CADFOR->CX_POST
Replace A2_CEP      With U_PString(CADFOR->CEP)
Replace A2_TEL      With CADFOR->FONE1
Replace A2_TEL2     With CADFOR->FONE2
Replace A2_FAX      With CADFOR->FONE3
Replace A2_CONTATO  With CADFOR->CONTAT1
Replace A2_CONTAT2  With CADFOR->CONTAT2
Replace A2_CONTAT3  With CADFOR->CONTAT3
Replace A2_PRICOM   With CADFOR->CADASTRO
Replace A2_INSCR    With U_PString(CADFOR->INSCRICAO)
Replace A2_TRANSP   With CADFOR->TRANSPORT
Replace A2_INSCRM   With CADFOR->CCM
Replace A2_REPRES   With CADFOR->REPRESENTA
MsUnLock()

Return
