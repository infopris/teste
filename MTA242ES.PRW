#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA242ES  �Autor  �Fabio Cazarini      � Data �  09/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajustes p�s-grava��o dos itens estornados pela rotina de    ���
���          �desmontagem de produtosAjustes nos itens desmontados        ���
���          �                                                            ���
���          �LOCALIZA��O : Function A242PrEsto() - Respons�vel por fazer ���
���          �o processamento do estorno.                                 ���
���          �                                                            ���
���          �DESCRI��O : O ponto de entrada MTA242ES e utilizado para    ���
���          �ajustes apos a grava��o de TODOS os item estornados pela    ���
���          �rotina de desmontagem de produtos.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MTA242ES()

EstorSD3() // Estorno do est. das MPs de acordo com a estrut. do prod. destino

RETURN                                                                     


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EstorSD3  �Autor  �Fabio Cazarini      � Data �  09/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Estorno do est. das MPs de acordo com a estrut. do prod.    ���
���          �destino                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION EstorSD3()                                                     
LOCAL _aArea		:= GetArea()
LOCAL _aAreaSD3		:= SD3->( GetArea() )
LOCAL _cSEQDMG		:= ""
LOCAL _aEstorna		:= {}
LOCAL _nX			:= 0

//��������������������������������������������������������������Ŀ
//� Pega a seq. do movimento para achar a origem e recupera os   �
//� dados da origem.                                             �
//����������������������������������������������������������������
dbSelectArea("SD3")
dbSetOrder(4) // D3_FILIAL + D3_NUMSEQ + D3_CHAVE + D3_COD
IF dbSeek(xFilial("SD3")+cSeqEst)  
	_cSEQDMG := SD3->D3_XSEQDMG
	IF !EMPTY(_cSEQDMG)
		dbSelectArea("SD3")
		dbSetOrder(8) // D3_FILIAL + D3_DOC + D3_NUMSEQ
		IF dbSeek(xFilial("SD3")+cDocumento)  
			DO WHILE !EOF() .AND. SD3->(D3_FILIAL + D3_DOC) == (xFilial("SD3")+cDocumento)
				IF _cSEQDMG == SD3->D3_XSEQDMG // se for a mesma sequencia de desmontagem Qualita
					IF SD3->D3_TM == "999" .OR. SD3->D3_TM == "499" // desconsidera a requisicao e devolucao padrao
						DbSelectArea("SD3")
						DbSkip()
						LOOP	
					ENDIF
					
					IF SD3->D3_ESTORNO <> "S"
						AADD(_aEstorna, SD3->D3_NUMSEQ ) // adiciona o nr da sequencia da movimentacao Qualita
					ENDIF	
				ENDIF
				
				DbSelectArea("SD3")
				DbSkip()
			ENDDO
			
			//��������������������������������������������������������������Ŀ
			//�Executa o estorno                                             �
			//����������������������������������������������������������������
			IF LEN(_aEstorna) > 0
				FOR _nX := 1 TO LEN(_aEstorna)
					ESTOR_SD3(_aEstorna[_nX])
				NEXT _nX	  
			ELSE
				ALERT("N�o existem requisi��es desta desmontagem. Verifique se houve processo manual.")
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
���Programa  �ESTOR_SD3 �Autor  �Fabio Cazarini      � Data �  09/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Estorno do est. das MPs de acordo com a estrut. do prod.    ���
���          �destino - ExecAuto                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION ESTOR_SD3(_cNUMSEQ)
LOCAL _aVetor
LOCAL _lRet 		:= .T.
LOCAL _nOpc			:= 5     // estorno

PRIVATE lMsHelpAuto 		:= .T.
PRIVATE lMsErroAuto 		:= .F.
PRIVATE lMsAutoErrNoFile 	:= .F.

dbSelectArea("SD3")
dbSetOrder(4) // D3_FILIAL + D3_NUMSEQ + D3_CHAVE + D3_COD
dbSeek(xFilial("SD3")+_cNUMSEQ)  

_aVetor := {}            

aadd(_aVetor,{"D3_NUMSEQ"	, SD3->D3_NUMSEQ	, NIL }) 	// Aqui dever� ser colocado o D3_NUMSEQ do registro que foi incluido e agora esta sendo estornado.   
aadd(_aVetor,{"INDEX"		, 4					, NIL })	// Aqui dever� ser indicado o n�mero do indice da tabela SD3 que ser� utilizado.Desta forma, o movimento ser� estornado.

Begin Transaction
MSExecAuto({|x,y| mata240(x,y)}, _aVetor, _nOpc) // Estorno
	
If lMsErroAuto
	Alert("Problemas na gravacao do estorno da movimentacao de estoque")
		
	MOSTRAERRO()
	DisarmTransaction()
		
	_lRet := .F.
Endif
End Transaction

RETURN _lRet