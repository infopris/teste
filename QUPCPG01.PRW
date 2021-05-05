#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUPCPG01  ºAutor  ³Fabio Cazarini      º Data ³  05/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ao digitar a quantidade de cada produto destino, preencher  º±±
±±º          ³automaticamente o campo de %rateio                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Qualita - Gatilho do campo D3_QUANT ou validacao PE MTA242V º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION QUPCPG01(cTpChamada)   
LOCAL _nX                    
LOCAL _nTamAcols	:= 0
LOCAL _nPosQUANT 	:= 0
LOCAL _nPosRATEIO	:= 0
LOCAL _nDecRATEIO	:= 0
LOCAL _nTotQUANT	:= 0
LOCAL _nRATEIO 		:= 0
LOCAL _nTotRATEIO	:= 0      
LOCAL _nRet			:= 0
LOCAL _nProc		:= 0
LOCAL _lCont		:= .T.
LOCAL _cProc		:= ""
		
IF FUNNAME() == "MATA242" .AND. (INCLUI .OR. ALTERA) // desmontagem de produtos
	_nProc	:= 0
	_lCont	:= .T.
	DO WHILE .T.
		_nProc++
		_cProc := ProcName(_nProc)
		
		IF _cProc == "GRAVA_SD3" .OR. _cProc == "MSROTAUTO"// nao chama o gatilho se a chamada for pela rotina GRAVA_SD3
			_lCont := .F.
			EXIT
		ENDIF
		
		IF EMPTY(_cProc)
			EXIT
		ENDIF
	ENDDO
	
	IF _lCont
		_nTamAcols	:= LEN(aCols)
		_nPosQUANT 	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_QUANT"})
		_nPosRATEIO	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_RATEIO"})
		_nDecRATEIO	:= TAMSX3("D3_RATEIO")[2]
		
		FOR _nX := 1 TO _nTamAcols
			IF !aCols[_nX][ LEN(aCols[_nX]) ] // se o item nao esta deletado
				_nTotQUANT += aCols[_nX][_nPosQUANT]
			ENDIF
		NEXT
		
		IF _nTotQUANT > 0
			FOR _nX := 1 TO _nTamAcols
				IF !aCols[_nX][ LEN(aCols[_nX]) ] // se o item nao esta deletado
					_nRATEIO 	:= ROUND(aCols[_nX][_nPosQUANT] * 100 / _nTotQUANT ,_nDecRATEIO)
					_nTotRATEIO += _nRATEIO
					
					IF _nX < _nTamAcols
						aCols[_nX][_nPosRATEIO] := _nRATEIO
					ELSE
						aCols[_nX][_nPosRATEIO] := ROUND(_nRATEIO + (100 - _nTotRATEIO), _nDecRATEIO)
					ENDIF
				ENDIF
			NEXT
		ENDIF
		
		IF cTpChamada == "G" // se a chamada for pelo gatilho
			IF !aCols[n][ LEN(aCols[n]) ] // se o item nao esta deletado
				_nRet := aCols[n][_nPosRATEIO]
			ENDIF
		ENDIF
	ENDIF
ENDIF

RETURN _nRet