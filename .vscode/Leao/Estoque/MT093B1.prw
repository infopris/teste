#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF

/*
*****************************************************************************
** Funcao     Ponto Entrada  Autor   Luiz Eduardo         Data   04/04/2019**
*****************************************************************************
** Descricao  Gera cadastro do produto criado através do código inteligente**
*****************************************************************************
*/

User Function MT093B1()
        
cDesc	:= sb1->B1_Desc
cTes	:= "501"
cUm		:= "PC"
cGrTrib := "001"
nPeso 	:= 0
Do Case
Case LEFT(sb1->B1_COD,2)='28'
	cPosIpi := "70052900"
	nIpi	:= 5
	cClasFis:= "E"
	cGrTrib := "002"
//	cDesc := "VIDRO CR"+SUBSTR(cDesc,14,60)
Case LEFT(sb1->B1_COD,2)='29'
	cPosIpi := "70099100"
	nIpi	:= 15	
	cClasFis:= "F"
//	cDesc := "ESPELHO"+SUBSTR(cDesc,14,60)
Case LEFT(sb1->B1_COD,2)='30'
	cPosIpi := "70099100"
	nIpi	:= 10
	cClasFis:= "F"
//	cDesc := "ESPELHO"+SUBSTR(cDesc,14,60)
Case LEFT(sb1->B1_COD,2)='38'
	cPosIpi := "70010000"
	nIpi	:= 10
	cClasFis:= "F"
	cTes	:= "519"
	cUm		:= "KG"
	nPESO 	:= 1
otherwise	
	cPosIpi := "70052900"
	nIpi	:= 5	
	cClasFis:= "E"
endcase    
nDim	:= val(substr(sb1->b1_base2,1,3))/10
nLarg 	:= val(substr(sb1->b1_base2,5,4))/1000
nAlt 	:= val(substr(sb1->b1_base2,10,4))/1000
nConv 	:= nLarg*nAlt
if nPeso=0
	nPESO 	:= iif(nDim=2,nLarg*nAlt*5,nLarg*nAlt*7.5)
endif
if LEFT(sb1->B1_COD,2)='38'
	if nDim = 3  // 3mm = 7,5kg/m2 - 2mm = 5kg/m2
//		nConv := nConv*7.5
		nConv := 0.13333
	else
//		nConv := nConv*5.0
		nConv := 0.20000
	endif
endif

if nLarg < nAlt
	Aviso("Atencao","Favor cadastrar o valor maior em seguida o menor ",{"Sair"} )
Endif

Select SB1
RecLock("SB1",.f.)
SB1->B1_UM		:= cUm
SB1->B1_GRUPO	:= "15"
SB1->B1_POSIPI	:= cPosIpi
SB1->B1_IPI 	:= nIpi
SB1->B1_TS 		:= cTes
SB1->B1_ORIGEM 	:= "0"
SB1->B1_CLASFIS	:= cClasFis
SB1->B1_GRTRIB 	:= cGrTrib
SB1->B1_DESC 	:= cDesc
SB1->B1_CONV 	:= nConv
SB1->B1_SEGUM 	:= "M2"
SB1->B1_PESO 	:= nPeso

MsunLock()
Return
