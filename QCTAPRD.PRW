#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QCTAPRD  ºAutor  ³Roberto Ramirez      º Data ³  27/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho do campo B1_TIPO utilizado para gravar              º±±
±±º			 ³automaticamente a conta contabil no campo B1_CONTA		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Qualita - Gatilho do campo B1_TIPO                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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