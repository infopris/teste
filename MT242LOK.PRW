#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT242LOK  ºAutor  ³Fabio Cazarini      º Data ³  16/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validações Específicas de usuário                           º±±
±±º          ³                                                            º±±
±±º          ³LOCALIZAÇÃO   : Function A242LinOK() responsável pela       º±±
±±º          ³validação de todos os itens da GetDados da Desmontagem de   º±±
±±º          ³Produtos.                                                   º±±
±±º          ³                                                            º±±
±±º          ³EM QUE PONTO : O ponto se encontra no final da função e é   º±±
±±º          ³disparado após todas as validações de linha efetuadas pelo  º±±
±±º          ³sistema, deve ser utilizado para validações especificas do  º±± 
±±º          ³usuario onde será controlada pelo retorno do ponto de       º±±
±±º          ³entrada o qual se for .F. o processo será interrompido e se º±±
±±º          ³.T. será validado.                                          º±±
±±º          ³                                                            º±±
±±º          ³Retorno:                                                    º±±
±±º          ³Se Verdadeiro (.T.), valida a incl. da linha na desmontagem º±±
±±º          ³Se Falso (.F.), nao valida a inclusao linha na desmontagem  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Qualita                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MT242LOK()
LOCAL _lRet := .T.

IF _lRet
	_lRet := MasEstEs()
ENDIF

RETURN _lRet 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MasEstEs  ºAutor  ³Fabio Cazarini      º Data ³  16/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Não deixar fazer a desmontagem sem lote dos produtos massa  º±±
±±º          ³B1_XMASSA == 'S'                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Qualita                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION MasEstEs()
LOCAL _aArea	:= GetArea()
LOCAL _lRet 	:= .T.
LOCAL _nPosPROD := 0
LOCAL _cPRODUTO	:= ""
LOCAL _aEstru	:= {}

DbSelectArea("SB1")
DbSetOrder(1)
IF DbSEEK(xFILIAL("SB1") + cProduto)
	IF SB1->B1_XMASSA == 'S'
		_nPosPROD 	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_COD"})
		_cPRODUTO	:= aCols[n][ _nPosPROD ]

		IF !EMPTY(_cPRODUTO)
			_aEstru := VerEstru(_cPRODUTO)
			
			IF ASCAN(_aEstru,{|x| AllTrim(x[1])==ALLTRIM(cPRODUTO)}) = 0
				ALERT("A massa (" + cProduto + ") não está na estrutura do produto (" + _cPRODUTO + ")")
				_lRet := .F.
			ENDIF	
		ENDIF
	ENDIF
ENDIF

RestArea( _aArea )

RETURN _lRet              


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerESTRU  ºAutor  ³Fabio Cazarini      º Data ³  16/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a explosão de uma estrutura cadastrada no SG1       º±±
±±º          ³Somente retorna o 1o. nivel da estrutura                    º±±
±±º          ³                                                            º±±
±±º          ³Parametros:                                                 º±±
±±º          ³_cPRODUTO = Codigo do produto                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Qualita                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION VerESTRU(_cPRODUTO)
LOCAL _aRet		:= {}

DbSelectArea("SB1")
DbSetOrder(1) // B1_FILIAL + B1_COD
DbSEEK(xFILIAL("SB1") + _cPRODUTO)

DbSelectArea("SG1")
DbSetOrder(1) // G1_FILIAL + G1_COD + G1_COMP + G1_TRT
DbSEEK(xFILIAL("SG1") + _cPRODUTO)

DO WHILE !EOF("SG1") .AND. SG1->(G1_FILIAL + G1_COD) == (xFILIAL("SG1") + _cPRODUTO)
	// data da validade
	IF SG1->G1_INI > DDATABASE .OR. SG1->G1_FIM < DDATABASE 
		DbSelectArea("SG1")
		DbSkip()
		LOOP
	ENDIF
    
	// revisao
	IF SB1->B1_REVATU < SG1->G1_REVINI .OR. SB1->B1_REVATU > SG1->G1_REVFIM
		DbSelectArea("SG1")
		DbSkip()
		LOOP
	ENDIF

	AADD(_aRet, {  ;
		SG1->G1_COMP ;
	})                 
	
	DbSelectArea("SG1")
	DbSkip()
ENDDO

RETURN _aRet