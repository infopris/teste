#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT242TOK  บAutor  ณFabio Cazarini      บ Data ณ  16/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza Valida็๕es Adicionais                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณLOCALIZAวรO : Function A242TudoOK() - Responsแvel pela      บฑฑ
ฑฑบ          ณvalida็ใo da GetDados.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณEM QUE PONTO : O ponto de entrada MT242TOK e utilizado para บฑฑ
ฑฑบ          ณrealizar valida็๕es adicionais na fun็ใo A242Tudook( ) que eบฑฑ
ฑฑบ          ณutilizada na confirma็ใo de inclusใo de desmontagem de      บฑฑ
ฑฑบ          ณprodutos.                                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณSe Verdadeiro (.T.), valida a inclusao da desmontagem       บฑฑ
ฑฑบ          ณSe Falso (.F.), nao valida a inclusao da desmontagem        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณQualita                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMasTemLt  บAutor  ณFabio Cazarini      บ Data ณ  16/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณNใo deixar fazer a desmontagem sem lote dos produtos massa  บฑฑ
ฑฑบ          ณB1_XMASSA == 'S'                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณQualita                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION MasTemLt()
LOCAL _lRet 	:= .T.
LOCAL _aArea	:= GetArea()

DbSelectArea("SB1")
DbSetOrder(1)
IF DbSEEK(xFILIAL("SB1") + cProduto)
	IF SB1->B1_XMASSA == 'S'
		//IF EMPTY(cLoteDigi)
		//	ALERT("ษ necessแrio informar o lote para produtos identificados como MASSA (ษ massa = SIM no cadastro de produtos)")
		//	_lRet := .F.
		//ENDIF
	ENDIF
ENDIF                           

RestArea( _aArea )

RETURN _lRet 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEstDisp   บAutor  ณFabio Cazarini      บ Data ณ  17/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se todos os itens da estrutura tem estoque         บฑฑ
ฑฑบ          ณdisponivel                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณQualita                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRealiza a explosใo de uma estrutura cadastrada no SG1ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_aEstru0 := VerESTRU(_cPRODUTO, _nQUANT)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณO item nao tem estrutura na SG1                      ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IF LEN(_aEstru0) == 0
				_lCont := MsgYesNo("Nใo foi possํvel efetuar a requisi็ใo devido a falta de estrutura do produto " + ALLTRIM(_cPRODUTO) + ". Deseja continuar mesmo assim?")
				IF !_lCont
					_lRet := .F.
					EXIT
				ENDIF
			ELSE
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAgrupa por produto                                                          ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica saldo disponivel em estoque                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF _lRet
		FOR _nZ := 1 TO LEN(_aVerEst)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณBusca o saldo em estoque do componente               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
				_lCont := MsgYesNo(	"Nใo foi possํvel efetuar a requisi็ใo devido indisponibilidade de estoque do produto " + ALLTRIM(_cVerPro) + ". " +;
									"Estoque disponํvel: " + TRANSFORM(_nSaldo, PESQPICT("SB2", "B2_QATU") ) + ". Quantidade necessแria: " + TRANSFORM(_nVerQtd, PESQPICT("SB2", "B2_QATU") ) + ". " +;
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerESTRU  บAutor  ณFabio Cazarini      บ Data ณ  11/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a explosใo de uma estrutura cadastrada no SG1       บฑฑ
ฑฑบ          ณSomente retorna o 1o. nivel da estrutura                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ_cPRODUTO = Codigo do produto                               บฑฑ
ฑฑบ          ณ_nQUANT   = Quantidade a considerar                         บฑฑ
ฑฑบ          ณ_cPROEXC  = Exceto este produto                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณQualita                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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