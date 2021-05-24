#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF

User Function ACERTNUM()  // Luiz Eduardo - Corrige a numeração do pedido de Vendas para não criar "P" na numeração

CnUM := ""
cNumPed := GetSxeNum("SC5","C5_NUM")

if left(cNumPed,1)="P"
	//	MsgGet2( "Indique o numero correto para a tabela: SC5" , "Campo:", @cNumPed, , , )
	u_CRIASXE()  // Ponto de entrada para verificar numeração da tabela SC5 na SXE e SXf
	
	DbSelectArea("SUA")
	DbOrderNickName("NUMSC5")
	do while .t.
		DbSeek(xFilial("SUA")+"P")
		if !eof()
			RecLock("SUA",.F.)
			Replace UA_NUMSC5 With " "
			MsUnLock()
		ELSE
			Exit
		endif
	enddo
	
	cLog := ""
	cLog += 'Antes Confirm: ' + cNumPed
	ConfirmSX8()
	cLog += CRLF + 'Depois Confirm: ' + GETSXENUM('SC5','C5_NUM')
	MsgInfo( 'GETSXENUM: ' + cLog, 'Luiz Eduardo' )
	
endif

Return

User function CRIASXE()

Local cNum := NIL
Local aArea := getarea()
Local aArea2 := {}
//[1] - cAlias - Nome da tabela;
//[2] - cCpoSX8 - Nome do campo que será utilizado para verificar o próximo sequencial;
//[3] - cAliasSX8 - Filial e nome da tabela na base de dados que será utilizada para verificar o sequencial;
//[4] - nOrdSX8 - Índice de pesquisa a ser usada na tabela.
Local cAlias    := "SC5"
Local cCpoSx8   := "C5_NUM"
Local cAliasSx8 := "01SC5"
Local nOrdSX8   := 1
Local cUsa := "SC5"  // colocar os alias que irão permitir a execução do P.E.

//GetSXENum("SC5","C5_NUM","C5_NUM" + cEmpAnt + cFilAnt)

if cAlias $ cUsa .and.  ! ( Empty(cAlias) .and. empty(cCpoSx8) .and. empty(cAliasSx8) )
	dbselectarea(cAlias)
	aArea2 := getarea()
	dbsetorder(nOrdSX8)
	dbseek(xfilial()+"P")
	dbskip(-1)
	cNum := strzero(val(SC5->C5_NUM)+1,6) //&(cCpoSx8)
//	cnum := soma1(cNum)	// fazer o tratamento aqui para a numeracao
	
	//	MsgGet2( "Indique o numero correto para a tabela:" + calias, "Campo:"+cCposx8, @cNum, , , )
	restarea(aArea2)
	restarea(aArea)
	
	//	Begin Transaction
	//Pegando o último código do cliente conforme a SXE / SXF
	
	//	If MsgYesNo("Deseja confirmar o código "+cNum+"?", "Atenção")
	//		cLog := ""
	//		cLog += 'Antes Confirm: ' + GETSXENUM('SC5','C5_NUM')
	//		ConfirmSX8()
	//		cLog += CRLF + 'Depois Confirm: ' + GETSXENUM('SC5','C5_NUM')
	//		MsgInfo( 'GETSXENUM: ' + cLog, 'Luiz Eduardo' )
	//Senão, volta a numeração onde estava
	//	Else
	//		RollBackSX8()
	//	EndIf
	//	End Transaction
end

return cNum

