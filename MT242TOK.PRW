#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT242TOK  �Autor  �Fabio Cazarini      � Data �  16/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza Valida��es Adicionais                               ���
���          �                                                            ���
���          �LOCALIZA��O : Function A242TudoOK() - Respons�vel pela      ���
���          �valida��o da GetDados.                                      ���
���          �                                                            ���
���          �EM QUE PONTO : O ponto de entrada MT242TOK e utilizado para ���
���          �realizar valida��es adicionais na fun��o A242Tudook( ) que e���
���          �utilizada na confirma��o de inclus�o de desmontagem de      ���
���          �produtos.                                                   ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �Se Verdadeiro (.T.), valida a inclusao da desmontagem       ���
���          �Se Falso (.F.), nao valida a inclusao da desmontagem        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MT242TOK()
LOCAL _lRet := .T.

//IF _lRet
//	_lRet := MasTemLt()
//ENDIF

IF _lRet
	_lRet := EstDisp() // verifica se todos os itens da estrutura tem estoque disponivel
ENDIF

RETURN _lRet 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MasTemLt  �Autor  �Fabio Cazarini      � Data �  16/11/14   ���
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
STATIC FUNCTION MasTemLt()
LOCAL _lRet 	:= .T.
LOCAL _aArea	:= GetArea()

DbSelectArea("SB1")
DbSetOrder(1)
IF DbSEEK(xFILIAL("SB1") + cProduto)
	IF SB1->B1_XMASSA == 'S'
		//IF EMPTY(cLoteDigi)
		//	ALERT("� necess�rio informar o lote para produtos identificados como MASSA (� massa = SIM no cadastro de produtos)")
		//	_lRet := .F.
		//ENDIF
	ENDIF
ENDIF                           

RestArea( _aArea )

RETURN _lRet 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EstDisp   �Autor  �Fabio Cazarini      � Data �  17/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se todos os itens da estrutura tem estoque         ���
���          �disponivel                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION EstDisp()
LOCAL _lRet 	:= .T.
LOCAL _aArea	:= GetArea()
LOCAL _lCont	:= .T.
LOCAL _nX
LOCAL _nY
LOCAL _nZ
LOCAL _nTamAcols	:= LEN(aCols)
LOCAL _nPosQUANT 	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_QUANT"})
LOCAL _nPosRATEIO	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_RATEIO"})
LOCAL _nPosPROD 	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_COD"})
LOCAL _nPosLOCAL 	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_LOCAL"})

LOCAL _nQUANT 		:= 0
LOCAL _nRATEIO		:= 0
LOCAL _cPRODUTO		:= "" 
LOCAL _cLocal		:= ""   
LOCAL _aEstru0		:= {}
LOCAL _aVerEst		:= {}

LOCAL _cVerPro 		:= ""
LOCAL _cVerLoc		:= ""
LOCAL _nVerQtd		:= 0

LOCAL _cTipo		:= ""
LOCAL _cUnidade 	:= ""
LOCAL _lIntDes 		:= .T.

IF FUNNAME() == "MATA242" .AND. (INCLUI .OR. ALTERA) // desmontagem de produtos
	_aVerEst := {}

	FOR _nX := 1 TO _nTamAcols
		IF !aCols[_nX][ LEN(aCols[_nX]) ] // se o item nao esta deletado
			_nQUANT 	:= aCols[_nX][ _nPosQUANT ]
			_nRATEIO	:= aCols[_nX][ _nPosRATEIO ]
			_cPRODUTO	:= aCols[_nX][ _nPosPROD ]
			_cLocal 	:= aCols[_nX][ _nPosLOCAL ]
			
			//�����������������������������������������������������Ŀ
			//�Realiza a explos�o de uma estrutura cadastrada no SG1�
			//�������������������������������������������������������
			_aEstru0 := VerESTRU(_cPRODUTO, _nQUANT)
			
			//�����������������������������������������������������Ŀ
			//�O item nao tem estrutura na SG1                      �
			//�������������������������������������������������������
			IF LEN(_aEstru0) == 0
				_lCont := MsgYesNo("N�o foi poss�vel efetuar a requisi��o devido a falta de estrutura do produto " + ALLTRIM(_cPRODUTO) + ". Deseja continuar mesmo assim?")
				IF !_lCont
					_lRet := .F.
					EXIT
				ENDIF
			ELSE
				//����������������������������������������������������������������������������Ŀ
				//�Agrupa por produto                                                          �
				//������������������������������������������������������������������������������
				FOR _nY := 1 TO LEN(_aEstru0)
					_cVerPro 	:= _aEstru0[_nY][03]
					_cVerLoc	:= _cLocal
					_nVerQtd	:= _aEstru0[_nY][04]
				
					_cTipo		:= Posicione("SB1",1,xFilial("SB1")+_cVerPro,"B1_TIPO")
					_cUnidade 	:= Posicione("SB1",1,xFilial("SB1")+_cVerPro,"B1_UM")
					
					IF _cTipo == "MP" .AND. _cUnidade == "CX" // Produto eh CAIXA?
						_lIntDes := .T.
					ELSE
						_lIntDes := .F.
					ENDIF
					
					IF _lIntDes // se o produto deve ter quantidade arredondada para cima
						IF _nVerQtd <> INT(_nVerQtd)
							_nVerQtd := INT(_nVerQtd) + 1
						ENDIF
					ENDIF
					
					_nPosItem := ASCAN(_aVerEst,{|x| x[1]+x[2] == _cVerPro+_cVerLoc })
					IF _nPosItem == 0
						AADD(_aVerEst, {_cVerPro, _cVerLoc, _nVerQtd})					
					ELSE
						_aVerEst[_nPosItem][03] += _nVerQtd
					ENDIF
				NEXT _nY
			ENDIF
		ENDIF
	NEXT _nX
	
	//����������������������������������������������������������������������������Ŀ
	//�Verifica saldo disponivel em estoque                                        �
	//������������������������������������������������������������������������������
	IF _lRet
		FOR _nZ := 1 TO LEN(_aVerEst)
			//�����������������������������������������������������Ŀ
			//�Busca o saldo em estoque do componente               �
			//�������������������������������������������������������
			_cVerPro 	:= _aVerEst[_nZ][01]
			_cVerLoc	:= _aVerEst[_nZ][02]
			_nVerQtd	:= _aVerEst[_nZ][03]
			
			DbSelectArea("SB2")
			DbSetOrder(1)
			IF DbSeek(xFilial("SB2")+ _cVerPro + _cVerLoc)
				_nSaldo := SaldoSB2() // calcula o saldo atual do produto, descontando os valores empenhados, reservados,...
			ELSE
				_nSaldo := 0
			ENDIF
			
			IF (_nSaldo - _nVerQtd) < 0
				_lCont := MsgYesNo(	"N�o foi poss�vel efetuar a requisi��o devido indisponibilidade de estoque do produto " + ALLTRIM(_cVerPro) + ". " +;
									"Estoque dispon�vel: " + TRANSFORM(_nSaldo, PESQPICT("SB2", "B2_QATU") ) + ". Quantidade necess�ria: " + TRANSFORM(_nVerQtd, PESQPICT("SB2", "B2_QATU") ) + ". " +;
									"Deseja continuar mesmo assim?")
				IF !_lCont
					_lRet := .F.
					EXIT
				ENDIF
			ENDIF
		NEXT _nZ
	ENDIF
ENDIF

RestArea( _aArea )

RETURN _lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerESTRU  �Autor  �Fabio Cazarini      � Data �  11/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a explos�o de uma estrutura cadastrada no SG1       ���
���          �Somente retorna o 1o. nivel da estrutura                    ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �_cPRODUTO = Codigo do produto                               ���
���          �_nQUANT   = Quantidade a considerar                         ���
���          �_cPROEXC  = Exceto este produto                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION VerESTRU(_cPRODUTO, _nQUANT)
LOCAL _aRet		:= {}
LOCAL _nESQUANT	:= 0
LOCAL _cComp	:= ""
LOCAL _nQB		:= 0

// busca a quantidade base da estrutura
DbSelectArea("SB1")
DbSetOrder(1) // B1_FILIAL + B1_COD
IF DbSEEK(xFILIAL("SB1") + _cPRODUTO)
	IF SB1->B1_QB > 0
		_nQB := SB1->B1_QB
	ELSE
		_nQB := 1
	ENDIF
ELSE
	_nQB := 1
ENDIF

DbSelectArea("SG1")
DbSetOrder(1) // G1_FILIAL + G1_COD + G1_COMP + G1_TRT
DbSEEK(xFILIAL("SG1") + _cPRODUTO)

DO WHILE !EOF("SG1") .AND. SG1->(G1_FILIAL + G1_COD) == (xFILIAL("SG1") + _cPRODUTO)
	// produto que deve ser desconsiderado
	_cComp := SG1->G1_COMP
	DbSelectArea("SB1")
	DbSetOrder(1) // B1_FILIAL + B1_COD
	IF DbSEEK(xFILIAL("SB1") + _cComp)
		IF ALLTRIM(SB1->B1_XMASSA) == "S"
			DbSelectArea("SG1")
			DbSkip()
			LOOP
		ENDIF
	ENDIF
	
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
	
	_nESQUANT := SG1->G1_QUANT  * _nQUANT / _nQB					// Quantidade * Qtd.mp / Quantidade base
	_nESQUANT := _nESQUANT - (_nESQUANT * SG1->G1_PERDA / 100) 	// Perda
	_nESQUANT := ROUND(_nESQUANT, TAMSX3("G1_QUANT")[2]) 			// Arredonda
	
	AADD(_aRet, {  ;
	SG1->G1_NIV ,;
	SG1->G1_COD ,;
	SG1->G1_COMP ,;
	_nESQUANT ,;
	SG1->G1_TRT ,;
	SG1->G1_GROPC ,;
	SG1->G1_OPC ;
	})
	
	DbSelectArea("SG1")
	DbSkip()
ENDDO

RETURN _aRet