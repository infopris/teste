#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA242IN  �Autor  �Fabio Cazarini      � Data �  07/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajustes nos itens desmontados                               ���
���          �                                                            ���
���          �LOCALIZA��O : Function A242Proces() - Respons�vel por fazer ���
���          �o processamento da inclus�o.                                ���
���          �                                                            ���
���          �EM QUE PONTO : O ponto de entrada MTA242IN e utilizado apos ���
���          �a grava��o da desmontagem de produtos para ajustes nos itens���
���          �desmontados.                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MTA242IN()

GeraSD3() // Saida do est. das MPs de acordo com a estrut. do prod. destino

//��������������������������������������������������������������Ŀ
//� Ativa tecla F4 para comunicacao com Saldos dos Lotes         �
//����������������������������������������������������������������
Set Key VK_F4 TO ShowF4()

RETURN


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraSD3   �Autor  �Fabio Cazarini      � Data �  07/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Saida do est. das MPs de acordo com a estrut. do prod.      ���
���          �destino                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION GeraSD3()
LOCAL _aArea		:= GetArea()
LOCAL _aAreaSD3		:= SD3->( GetArea() )
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

LOCAL _aEstruD	:= {} // array para gerar as devolucoes de montagem do ultimo nivel da estrutura
LOCAL _nItEstr	:= 0
LOCAL _nSaldo	:= 0
LOCAL _cDoc  	:= ""
LOCAL _dEmissao	:= CTOD("//")
LOCAL _cLocal	:= ""
LOCAL _cSEQDMG	:= SPACE(06)
LOCAL _aEstru0	:= {}
LOCAL _cTPMovR 	:=  SuperGetMv( "MV_XTMDESR" , .F. , "501" ,  ) 	// indica o tipo de movimentacao de requisicao
LOCAL _aCusto	:= {}
LOCAL _nPosCus	:= 0
LOCAL _aSaldos	:= {}
LOCAL _nCusto1	:= 0
LOCAL _nCusto2	:= 0
LOCAL _nCusto3	:= 0
LOCAL _nCusto4	:= 0
LOCAL _nCusto5	:= 0
LOCAL _lTudoOK	:= .T.

IF FUNNAME() == "MATA242" .AND. (INCLUI .OR. ALTERA) // desmontagem de produtos
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
			IF LEN(_aEstru0)  = 0
				//Alert(	"N�o foi poss�vel efetuar a requisi��o devido a falta de estrutura do produto " + ALLTRIM(_cPRODUTO) + ". " +;
				//"O procedimento de requisi��o dever� ser manual." )
			ELSE
				//����������������������������������������������������������������������������Ŀ
				//�Somente adiciona os produtos com saldo disponivel em estoque                �
				//������������������������������������������������������������������������������
				_nCusto1 := 0
				_nCusto2 := 0
				_nCusto3 := 0
				_nCusto4 := 0
				_nCusto5 := 0
				FOR _nZ := 1 TO LEN(_aEstru0)
					//�����������������������������������������������������Ŀ
					//�Calcula o custo atual de cada MP                     �
					//�������������������������������������������������������
					IF ALLTRIM(cPRODUTO) <> ALLTRIM(_aEstru0[_nZ][03]) // nao considera o custo da MASSA, pois ele ja esta no custo do PA atraves do rateio
						_aSaldos := CALCEST(_aEstru0[_nZ][03], _cLocal, dDATABASE)
						
						_nCusto1 += (_aSaldos[2]/_aSaldos[1]*_aEstru0[_nZ][04]) // Custo inicial na data na moeda 1
						_nCusto2 += (_aSaldos[3]/_aSaldos[1]*_aEstru0[_nZ][04]) // Custo inicial na data na moeda 2
						_nCusto3 += (_aSaldos[4]/_aSaldos[1]*_aEstru0[_nZ][04]) // Custo inicial na data na moeda 3
						_nCusto4 += (_aSaldos[5]/_aSaldos[1]*_aEstru0[_nZ][04]) // Custo inicial na data na moeda 4
						_nCusto5 += (_aSaldos[6]/_aSaldos[1]*_aEstru0[_nZ][04]) // Custo inicial na data na moeda 5
					ENDIF
					
					//�����������������������������������������������������Ŀ
					//�Busca o saldo em estoque do componente               �
					//�������������������������������������������������������
					DbSelectArea("SB2")
					DbSetOrder(1)
					IF DbSeek(xFilial("SB2")+ _aEstru0[_nZ][03] + _cLocal)
						_nSaldo := SaldoSB2() // calcula o saldo atual do produto, descontando os valores empenhados, reservados,...
					ELSE
						_nSaldo := 0
					ENDIF  
					
					//IF (_nSaldo - _aEstru0[_nZ][04]) <= 0
					//	Alert(	"N�o foi poss�vel efetuar a requisi��o devido a falta de estoque dispon�vel do produto " + ALLTRIM(_aEstru0[_nZ][03]) + ". " +;
					//	"Estoque dispon�vel: " + TRANSFORM(_nSaldo, PESQPICT("SB2", "B2_QATU") ) + ". " +;
					//	"O procedimento de requisi��o dever� ser manual." )
					//				
					//ELSE
						
						//�����������������������������������������������������������������Ŀ
						//�Movimentacao de devolucao (do ultimo nivel da entrutura)         �
						//�������������������������������������������������������������������
						AADD(_aEstruD, {  ;
						_aEstru0[_nZ][01] ,;
						_aEstru0[_nZ][02] ,;
						_aEstru0[_nZ][03] ,;
						_aEstru0[_nZ][04] ,;
						_aEstru0[_nZ][05] ,;
						_aEstru0[_nZ][06] ,;
						_aEstru0[_nZ][07] ,;
						_cLocal ;
						})
					//ENDIF
				NEXT _nZ
				
				//�����������������������������������������������������Ŀ
				//�Custo total das MPs para o PA                        �
				//�������������������������������������������������������
				_nPosCus := ASCAN(_aCusto,{|x| ALLTRIM(x[1])==ALLTRIM(_cPRODUTO)})
				IF _nPosCus > 0
					_aCusto[_nPosCus][2] += _nCusto1
					_aCusto[_nPosCus][3] += _nCusto2
					_aCusto[_nPosCus][4] += _nCusto3
					_aCusto[_nPosCus][5] += _nCusto4
					_aCusto[_nPosCus][6] += _nCusto5
				ELSE
					AADD(_aCusto, {_cPRODUTO, _nCusto1, _nCusto2, _nCusto3, _nCusto4, _nCusto5})
				ENDIF
			ENDIF
		ENDIF
	NEXT _nX
	
	//������������������������������������������������������Ŀ
	//�Saida do est. das MPs de acordo com a estrut. do prod.�
	//�destino - ExecAuto                                    �
	//��������������������������������������������������������
	IF LEN(_aEstruD) > 0
		_cSEQDMG := GetSXENum("SD3","D3_XSEQDMG")
		ConfirmSX8()
		
		//�����������������������������������������������������������������Ŀ
		//�Movimentacao de devolucao (do ultimo nivel da entrutura)         �
		//�������������������������������������������������������������������
		BEGIN TRANSACTION

			_lTudoOK	:= .T.
			FOR _nY := 1 TO LEN(_aEstruD)
				_lTudoOK := GRAVA_SD3(_aEstruD[_nY], _cSEQDMG, _cTPMovR)
				IF !_lTudoOk
					EXIT
				ENDIF
			NEXT _nY
	
			IF !_lTudoOK
				DISARMTRANSACTION()
				
				Alert(	"N�o foi poss�vel efetuar a requisi��o devido � problemas na grava��o da movimenta��o de estoque. " +;
						"A desmontagem n�o foi conclu�da. Favor executar o procedimento de requisi��o manualmente." )
			ENDIF
			
		END TRANSACTION
		
		IF _lTudoOK
			//������������������������������������������������������Ŀ
			//�Atualiza a sequencida da desmontagem no movimento     �
			//�origem                                                �
			//��������������������������������������������������������
			DbSelectArea("SD3")
			DbSetOrder(8) // D3_FILIAL+D3_DOC+D3_NUMSEQ
			IF DbSEEK(xFILIAL("SD3")+cDocumento+cNumSeq)
				DO WHILE !EOF("SD3") .AND. (D3_FILIAL+D3_DOC+D3_NUMSEQ) == (xFILIAL("SD3")+cDocumento+cNumSeq)
					//�����������������������������������������������������Ŀ
					//�Custo total das MPs para o PA                        �
					//�������������������������������������������������������
					_nCusto1 := 0
					_nCusto2 := 0
					_nCusto3 := 0
					_nCusto4 := 0
					_nCusto5 := 0
					IF ALLTRIM(SD3->D3_CF) == "DE7" // se for a movimentacao do PA
						_nPosCus := ASCAN(_aCusto,{|x| ALLTRIM(x[1])==ALLTRIM(SD3->D3_COD)})
						IF _nPosCus > 0
							_nCusto1 := _aCusto[_nPosCus][2]
							_nCusto2 := _aCusto[_nPosCus][3]
							_nCusto3 := _aCusto[_nPosCus][4]
							_nCusto4 := _aCusto[_nPosCus][5]
							_nCusto5 := _aCusto[_nPosCus][6]
						ENDIF
					ENDIF
					
					DbSelectArea("SD3")
					RecLock("SD3", .F.)
					SD3->D3_XSEQDMG	:= _cSEQDMG
					MsUnLock()
					
					//��������������������������������������������Ŀ
					//� Grava o custo da movimentacao              �
					//����������������������������������������������
					IF ALLTRIM(SD3->D3_CF) == "DE7" // se for a movimentacao do PA
						IF SD3->D3_QUANT > 0
							_nCusto1 += SD3->D3_CUSTO1
							_nCusto2 += SD3->D3_CUSTO2
							_nCusto3 += SD3->D3_CUSTO3
							_nCusto4 += SD3->D3_CUSTO4
							_nCusto5 += SD3->D3_CUSTO5
							
							GravaCusD3({_nCusto1/SD3->D3_QUANT,_nCusto2/SD3->D3_QUANT,_nCusto3/SD3->D3_QUANT,_nCusto4/SD3->D3_QUANT,_nCusto5/SD3->D3_QUANT})
						ENDIF
					ENDIF
					
					DbSkip()
				ENDDO
			ENDIF
		ENDIF
	ENDIF
ENDIF

RestArea( _aAreaSD3 )
RestArea( _aArea )

RETURN


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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GRAVA_SD3 �Autor  �Fabio Cazarini      � Data �  09/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Saida do est. das MPs de acordo com a estrut. do prod.      ���
���          �destino - ExecAuto                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION GRAVA_SD3(_aEstrSG1, _cSEQDMG, _cTPMov)
LOCAL _aVetor
LOCAL _lRet 		:= .T.
LOCAL _nOpc			:= 3
LOCAL _cComp		:= ""
LOCAL _lIntDes 		:=  .F. 	// indica se o produto devem ter quantidade inteira
LOCAL _cUnidade     := ""
LOCAL _cTipo		:= ""
LOCAL _nQuantSD3	:= 0

LOCAL cLinha	:= ""
LOCAL aErros	:= {}
LOCAL cCRLF		:= CHR(13) + CHR(10)
LOCAL nY		:= 0
LOCAL _nSaldo 	:= 0

PRIVATE lMsHelpAuto 		:= .T.
PRIVATE lMsErroAuto 		:= .F.
//PRIVATE lMsAutoErrNoFile 	:= .F.
PRIVATE lMsAutoErrNoFile 	:= .T.
PRIVATE lAutoErrNoFile 		:= .T.

_cComp 		:= _aEstrSG1[03]
_nQuantSD3	:= _aEstrSG1[04]

IF _nQuantSD3 > 0
	_cTipo		:= Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_TIPO")
	_cUnidade 	:= Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_UM")
	
	IF _cTipo == "MP" .AND. _cUnidade == "CX" // Produto eh CAIXA?
		_lIntDes := .T.
	ELSE
		_lIntDes := .F.
	ENDIF
	
	IF _lIntDes // se o produto deve ter quantidade arredondada para cima
		IF _nQuantSD3 <> INT(_nQuantSD3)
			_nQuantSD3 := INT(_nQuantSD3) + 1
		ENDIF
	ENDIF
	
	_aVetor := {}
	
	aadd(_aVetor,{"D3_TM"		, _cTPMov		, NIL})
	aadd(_aVetor,{"D3_COD"		, _cComp		, NIL})
	aadd(_aVetor,{"D3_UM"		, _cUnidade		, NIL})
	aadd(_aVetor,{"D3_QUANT"	, _nQuantSD3	, NIL})
	aadd(_aVetor,{"D3_DOC"		, cDocumento	, NIL})
	aadd(_aVetor,{"D3_EMISSAO"	, dEmis260		, NIL})
	aadd(_aVetor,{"D3_LOCAL"	, _aEstrSG1[08]	, NIL})
	aadd(_aVetor,{"D3_XSEQDMG"	, _cSEQDMG		, NIL})
	
	//aadd(_aVetor,{"D3_CUSTO1"		,	,NIL})
	//aadd(_aVetor,{"D3_CONTA"		,	,NIL})
	//aadd(_aVetor,{"D3_CC"			,	,NIL})
	//aadd(_aVetor,{"D3_LOTECTL"	,	,NIL})
	//aadd(_aVetor,{"D3_NUMLOTE"	,	,NIL})
	//aadd(_aVetor,{"D3_DTVALID"	,	,NIL})
	
	_aVetor := FWVetByDic( _aVetor, 'SD3' )
	
	DbSelectArea("SD3")
	//Begin Transaction
	MSExecAuto({|x,y| mata240(x,y)}, _aVetor, _nOpc) //Inclusao
	
	If lMsErroAuto
		//
		//CAZARINI - 17.03.2015 - Exibir o erro somente no final do processo
		//
		//Alert(	"N�o foi poss�vel efetuar a requisi��o devido � problemas na grava��o da movimenta��o de estoque. " +;
		//"Ser� exibido mais detalhes sobre o problema na pr�xima tela." +;
		//"O procedimento de requisi��o dever� ser manual." )
		
		//MOSTRAERRO()
		//DisarmTransaction()

		DbSelectArea("SB2")
		DbSetOrder(1)
		IF DbSeek(xFilial("SB2")+ _cComp + _aEstrSG1[08])
			_nSaldo := SaldoSB2() // calcula o saldo atual do produto, descontando os valores empenhados, reservados,...
		ELSE
			_nSaldo := 0
		ENDIF

		cLinha	:= ""
		cLinha	+= "Produto: " 	+ _cComp + cCRLF
		cLinha	+= "Estoque dispon�vel: " + TRANSFORM(_nSaldo, PESQPICT("SB2", "B2_QATU") ) + cCRLF
		cLinha	+= "Quantidade necess�ria: " + TRANSFORM(_nQuantSD3, PESQPICT("SD3","D3_QUANT") ) + cCRLF
		cLinha	+= "Local: " + _aEstrSG1[08] + cCRLF
		cLinha	+= "--------------------------------------------------------------------------------" + cCRLF
		cLinha	+= cCRLF

		aErros 	:= GetAutoGRLog()   
		FOR nY := 1 TO LEN(aErros)
			cLinha += aErros[nY] + cCRLF
		NEXT                                

		MsgTexto("Erro na movimenta��o de estoque - MTA242IN - GRAVA_SD3", cLinha)		
		
		_lRet := .F.
	Endif
	//End Transaction
ENDIF

RETURN _lRet


/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa  � FUNCOES  � Autor � Fabio Cazarini        � Data � 22.03.2010  ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � MsgTexto(cTitulo, cTexto)                                     ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � cTitulo  = Titulo da mensagem                                 ���
���          � cTexto   = Texto com a mensagem a ser exibida                 ���
����������������������������������������������������������������������������Ĵ��
���Exemplo   �MsgTexto("Itens com problema","Texto" + chr(13) + "Linha")     ���
����������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                        ���
����������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                      ���
����������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
Static Function MsgTexto(cTitulo, cTexto)
Local oButton1
Local oSay1
Static oDlg

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 300, 550 COLORS 0, 16777215 PIXEL
@ 003, 003 GET oMultiGe1 VAR cTexto OF oDlg MULTILINE SIZE 268, 128 COLORS 0, 16777215 READONLY HSCROLL PIXEL
@ 133, 118 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 OF oDlg ACTION odlg:end() PIXEL
ACTIVATE MSDIALOG oDlg CENTERED

Return