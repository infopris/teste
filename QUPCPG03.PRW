#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QUPCPG03  ºAutor  ³Fabio Cazarini      º Data ³  12/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho do campo D3_COD para, ao efetuar a Desmontagem, e aoº±±
±±º          ³digitar o produto destino, deve-se preencher o campo do loteº±±
±±º          ³com o mesmo número do lote do produto de origem PI (Massa)  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Qualita - Gatilho do campo D3_COD                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION QUPCPG03()   
LOCAL _cRET			:= ""
LOCAL _lCont		:= .T.
LOCAL _cProc		:= "" 
LOCAL _nPosLOTE		:= 0
LOCAL _nPosVALID	:= 0

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
		IF !EMPTY(cLoteDigi)
			_nPosLOTE := ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_LOTECTL"})
			IF _nPosLOTE > 0
				_cRET 				:= cLoteDigi
				aCols[n][_nPosLOTE]	:= cLoteDigi
			ENDIF	
		ENDIF       
		
		IF !EMPTY(dDtValid)
			_nPosVALID := ASCAN(aHeader,{|x| AllTrim(x[2])=="D3_DTVALID"})
			IF _nPosVALID > 0
				aCols[n][_nPosVALID]	:= dDtValid
			ENDIF	
		ENDIF
	ENDIF
ENDIF

RETURN _cRET