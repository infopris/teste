#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QCTAPRD  �Autor  �Roberto Ramirez      � Data �  27/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho do campo B1_TIPO utilizado para gravar              ���
���			 �automaticamente a conta contabil no campo B1_CONTA		  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Qualita - Gatilho do campo B1_TIPO                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION QCTAPRD()   

LOCAL cGRPCTB		:= M->B1_XGRPCTB
LOCAL cCTA 		:= ""

IF cGRPCTB = "MPR"
	cCTA = "11070101001"
ELSE
	IF cGRPCTB = "EMB"
		cCTA = "11070101003"
	ELSE
		IF cGRPCTB = "PA"
			cCTA = "11070101005"
		ELSE
			IF cGRPCTB = "MTE"      
				cCTA = "51010204001"
			ELSE
				IF cGRPCTB = "IMOB"      
					cCTA = "12040101100"
				ELSE
					IF cGRPCTB = "MTC"      
						cCTA = "51010205005"

					ELSE
						IF cGRPCTB = "MTU"      
							cCTA = "41010301008"

						ELSE
							IF cGRPCTB = "CTB"      
								cCTA = "51010205012"

							ELSE
								IF cGRPCTB = "EPI"      
									cCTA = "41010301010"
								ELSE
									IF cGRPCTB = "HIG"      
										cCTA = "51010204002"
									ELSE
										IF cGRPCTB = "INS"      
											cCTA = "41010301010"

										ELSE
											IF cGRPCTB = "LAB"      
												cCTA = "41010301015"
											ELSE
												cCTA = "   "	
											ENDIF
										ENDIF
									ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
ENDIF
RETURN cCTA