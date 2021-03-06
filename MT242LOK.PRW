#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT242LOK  �Autor  �Fabio Cazarini      � Data �  16/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��es Espec�ficas de usu�rio                           ���
���          �                                                            ���
���          �LOCALIZA��O   : Function A242LinOK() respons�vel pela       ���
���          �valida��o de todos os itens da GetDados da Desmontagem de   ���
���          �Produtos.                                                   ���
���          �                                                            ���
���          �EM QUE PONTO : O ponto se encontra no final da fun��o e �   ���
���          �disparado ap�s todas as valida��es de linha efetuadas pelo  ���
���          �sistema, deve ser utilizado para valida��es especificas do  ��� 
���          �usuario onde ser� controlada pelo retorno do ponto de       ���
���          �entrada o qual se for .F. o processo ser� interrompido e se ���
���          �.T. ser� validado.                                          ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �Se Verdadeiro (.T.), valida a incl. da linha na desmontagem ���
���          �Se Falso (.F.), nao valida a inclusao linha na desmontagem  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MT242LOK()
LOCAL _lRet := .T.

IF _lRet
	_lRet := MasEstEs()
ENDIF

RETURN _lRet 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MasEstEs  �Autor  �Fabio Cazarini      � Data �  16/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �N�o deixar fazer a desmontagem sem lote dos produtos massa  ���
���          �B1_XMASSA == 'S'                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				ALERT("A massa (" + cProduto + ") n�o est� na estrutura do produto (" + _cPRODUTO + ")")
				_lRet := .F.
			ENDIF	
		ENDIF
	ENDIF
ENDIF

RestArea( _aArea )

RETURN _lRet              


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerESTRU  �Autor  �Fabio Cazarini      � Data �  16/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a explos�o de uma estrutura cadastrada no SG1       ���
���          �Somente retorna o 1o. nivel da estrutura                    ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �_cPRODUTO = Codigo do produto                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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