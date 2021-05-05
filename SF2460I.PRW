#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS2460I   ºAutor  TOTVS                º Data ³  14/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada no faturamento da nota fiscal de saida     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2460I()

Local cFilSD2 := xFilial("SD2")
Local cChavF2 := SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
Local nPesoL := 0
Local nPesoB := 0
Local nVolume:= 0
             
dbSelectArea("SB1")
aAreaSB1:= GetArea()

dbSelectArea("SD2")
//--- Filial + DOC + Serie + Cliente + Loja
aAreaSD2 := GetArea()
dbSetOrder(3)
dbSeek( cFilSD2 + cChavF2 )

While !SD2->( EOF() ) .And. ( SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == cFilSD2 + cChavF2 )
   
   dbSelectArea("SB1")
   dbSetOrder(1)
   dbSeek(xFilial("SB1")+SD2->D2_COD)	
   
   nPesoL += SD2->D2_QUANT*SB1->B1_PESO
   nPesoB += SD2->D2_QUANT*SB1->B1_PESBRU
   //nVolume+= INT(SD2->D2_QUANT/SB1->B1_CONV)
   nVolume+= Iif((SD2->D2_QUANT/SB1->B1_CONV) - INT(SD2->D2_QUANT/SB1->B1_CONV) > 0, INT(SD2->D2_QUANT/SB1->B1_CONV)+1, INT(SD2->D2_QUANT/SB1->B1_CONV)) //Andre R. Esteves - 11/10/2016
      
   dbSelectArea("SD2")
   SD2->(dbSkip())
Enddo

RestArea(aAreaSD2)
RestArea(aAreaSB1)        

RecLock("SF2",.F.)
SF2->F2_PLIQUI := nPesoL
SF2->F2_PBRUTO := nPesoB
if SF2->F2_ESPECI1= "CAIXA"
	SF2->F2_VOLUME1:= nVolume
	If nVolume > 1 
		SF2->F2_ESPECI1:= "CAIXAS"
	Else
		SF2->F2_ESPECI1:= "CAIXA"
	Endif
Endif
MsUnlock()

Return Nil   