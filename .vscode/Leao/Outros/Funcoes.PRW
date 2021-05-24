#include "rwmake.ch

/*/
*****************************************************************************
** Funcao     PSTRING     Autor   Alexandro Dias          Data   02.07.01  **
*****************************************************************************
** Descricao  Retira caracters de separação de qualquer string             **
*****************************************************************************
/*/

User Function PString(_cString)

_cString    := _cString
_cSeparador := "=.,-\|/*"

For _nPosSep := 1 to Len(_cSeparador)
	
	 _nPos := 1
	
	While _nPos > 0
		_nPos := At(Substr(_cSeparador,_nPosSep,1),_cString)
		IF _nPos > 0
			_cString := Subst(_cString,1,_nPos-1) + Subst(_cString,_nPos+1,Len(_cString) )
		EndIF
	EndDo
	
Next

Return(_cString)

/*/
********************************************************************************
** Funcao     CEP_End     Autor   Alexandro Dias             Data   13.07.01  **
********************************************************************************
** Descricao  Retorna o Endereco, Bairro e Municipio conforme o Cep informado **
********************************************************************************
/*/

User Function CEP_End(_cTipo,_cCep)

 _cRet  := ""
 _cCep  := _cCep
 _cTipo := _cTipo
 _xAlias:= { Alias(), IndexOrd(), Recno() }

DbSelectArea("SZB")
Dbsetorder(2)
IF DbSeek( xFilial() + _cCep )
	
	IF _cTipo == "1"
		
		//****************************************************************
		// Pesquisa e retorna o Endereco
		//****************************************************************
		
		DbSelectArea("SZA")
		Dbsetorder(1)
		IF DbSeek(xFilial()+SZB->ZB_TIT)
			
			_cNum := Space(10)
			_cRet := SZA->ZA_TITULO + SZB->ZB_LOGRA
			
			@ 000,000 TO 100,400 DIALOG oDlg TITLE "Informe o _cNumero."
			
			@ 010,010 GET _cRet When .F. Size 120,020
			@ 010,140 GET _cNum PICTURE "@!" ValID !Empty(_cNum) Size 040,20
			
			@ 30,150 BMPBUTTON TYPE 1 ACTION Close(oDlg)
			
			ACTIVATE DIALOG oDlg CENTER
			
			_cRet := Alltrim(_cRet) + ", " + _cNum
			
		EndIF
		
	ElseIF _cTipo == "2"
		
		//****************************************************************
		// Pesquisa e retorna o Bairro
		//****************************************************************
		
		DbSelectArea("SZ6")
		Dbsetorder(1)
		
		IF DbSeek(xFilial()+SZB->ZB_CODMUN+SZB->ZB_CODBAI)
			_cRet := SZ6->Z6_BAIRRO
		EndIF
		
	ElseIF _cTipo == "3"
		
		//****************************************************************
		// Pesquisa e retorna o Municipio
		//****************************************************************
		
		DbSelectArea("SZ0")
		Dbsetorder(1)
		IF DbSeek(xFilial()+SZB->ZB_CODMUN)
			_cRet := SZ0->Z0_MUNIC
		EndIF
		
	EndIF
	
Else
	MsgBox("O Cep informado nao esta cadastrado, atualize o cadastro de CEP !!!","Atencao","ALERT")
EndIF

DbSelectArea(_xAlias[1])
DbSetOrder(_xAlias[2])
DbGoto(_xAlias[3])

Return(_cRet)

/*/
*****************************************************************************
** Funcao     GeraHexa    Autor   Alexandro Dias          Data   23.08.01  **
*****************************************************************************
** Descricao  Gera _cNumero hexadecimal.                                     **
*****************************************************************************
/*/

User Function GeraHexa(_cValor)

Private _cNumero := Space(06)
Private _nResto  := 0

IF "A1_" $ Upper(Readvar())

	IF Len(Alltrim(M->A1_CGC)) > 11
		_nDiv  := Val(Substr(M->A1_CGC,1,8))
	Else
		_nDiv  := Int(Val(Alltrim(M->A1_CGC))/100)
	EndIF

ElseIF "A2_" $ upper(Readvar())

	IF Len(Alltrim(M->A2_CGC)) > 11
		_nDiv  := Val(Substr(M->A2_CGC,1,8))
	Else
		_nDiv  := Int(Val(Alltrim(M->A2_CGC))/100)

	EndIF

Else

	IF Len(_cValor) > 11
		_nDiv  := Val(Substr(_cValor,1,8))
	Else
		_nDiv  := Int(Val(Alltrim(_cValor))/100)
	EndIF

EndIF

Retorno_Conv := Space(06)

While _nDiv >= 35
	_nResto := _nDiv % 35
	_nDiv     := int(_nDiv / 35)
	_cNumero:= ConvHexa(_nResto)+Alltrim(_cNumero)
End

_cNumero:= ConvHexa(_nDiv)+Alltrim(_cNumero)

Retorno_Conv := replicate("0",6-Len(Alltrim(_cNumero)))+Alltrim(_cNumero)

M->A1_COD:= Retorno_Conv

Return(Retorno_Conv)

// Funcao que converte _cNumeros em letras(base 35)

Static Function ConvHexa(y)

Do Case
	Case (y < 10)
		Return(str(Y))
	Case (y ==10)
		Return("A")
	Case y ==11
		Return("B")
	Case y ==12
		Return("C")
	Case y ==13
		Return("D")
	Case y ==14
		Return("E")
	Case y ==15
		Return("F")
	Case y ==16
		Return("G")
	Case y ==17
		Return("H")
	Case y ==18
		Return("I")
	Case y ==19
		Return("J")
	Case y ==20
		Return("K")
	Case y ==21
		Return("L")
	Case y ==22
		Return("M")
	Case y ==23
		Return("N")
	Case y ==24
		Return("O")
	Case y ==25
		Return("P")
	Case y ==26
		Return("Q")
	Case y ==27
		Return("R")
	Case y ==28
		Return("S")
	Case y ==29
		Return("T")
	Case y ==30
		Return("U")
	Case y ==31
		Return("V")
	Case y ==32
		Return("W")
	Case y ==33
		Return("X")
	Case y ==34
		Return("Y")
		
EndCase

Return