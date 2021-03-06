#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QUPCPG02  �Autor  �Fabio Cazarini      � Data �  12/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho do campo D3_OP para compor o lote, sendo a          ���
���          �f�rmula: MMSSS(+letra), onde MM � o m�s da database do      ���
���          �apontamento  e SSS � um n�mero sequencial dentro do m�s e a ���
���          �letra do campo B1_XIDELOT                                   ���
���          �                                                            ���
���          �Exemplo: para outubro, 10001T, 10002,10003,10004T           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita - Gatilho do campo D3_OP                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION QUPCPG02()   
LOCAL _aArea	:= GETAREA()
LOCAL _cRET		:= M->D3_LOTECTL
LOCAL _nSeqLot	:= 0
		
IF FUNNAME() == "MATA250" .AND. INCLUI // Apontamento de producao
	IF !EMPTY(M->D3_COD)
		DbSelectArea("SB1")
   		DbSetOrder(1)
    	IF DbSEEK(xFILIAL("SB1") + M->D3_COD)
			IF !EMPTY(SB1->B1_XIDELOT)
				DbSelectArea("SX5")
				DbSetOrder(1)
				IF DbSEEK(xFILIAL("SX5") + "Z1" + STRZERO( MONTH(dDATABASE),2 ))
					IF VAL(SX5->X5_DESCRI) = 0
						_nSeqLot := 1
					ELSE
						_nSeqLot := VAL(SX5->X5_DESCRI) + 1
					ENDIF
					
					DO WHILE .T.
						_cRET := PADR(STRZERO( MONTH(dDATABASE),2 ) + STRZERO(_nSeqLot,3) + SB1->B1_XIDELOT, LEN(SD3->D3_LOTECTL) ) 
						
						DbSelectArea("SB8")
						DbSetOrder(3) // B8_FILIAL + B8_PRODUTO + B8_LOCAL + B8_LOTECTL
						IF !DbSEEK(xFILIAL("SB8")+M->D3_COD+M->D3_LOCAL+_cRET) 
							EXIT
						ELSE
							_nSeqLot++
						ENDIF
					ENDDO	
				ENDIF
			ENDIF
		ENDIF	
    ENDIF

	RESTAREA( _aArea )
ENDIF

RETURN _cRET