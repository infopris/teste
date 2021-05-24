#include "rwmake.ch"

User Function AlegrFat()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ ALEGRFAT ¦ Autor ¦   Alexandro Dias  ¦ Data ¦ 10/07/2001   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Emissao de faturas.                                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+--------------------------------------------------------------+
//¦ Define Variaveis.                                            ¦
//+--------------------------------------------------------------+

tamanho := "P"
limite  := 80
titulo  := "EMISSAO DE FATURAS"
cDesc1  := "Este programa irá emitir as Faturas conforme"
cDesc2  := "parametros especificados."
cDesc3  := ""
cString := "SE1"
aReturn := { "Zebrado", 1,"Administracao", 2, 3, 1, "",1 }
cPerg   := "MTR750"
nLastKey:= 0
_nlinha := 04

//+---------------------------------------------+
//¦ Variaveis utilizadas para parametros	    ¦
//¦ mv_par01		// Duplicata de		        ¦
//¦ mv_par02		// Duplicata ate	        ¦
//¦ mv_par03		// Serie                    ¦
//+---------------------------------------------+

pergunte("MTR750",.F.)

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT.                       ¦
//+--------------------------------------------------------------+

wnrel:="FATURA"

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif

DbSelectArea("SE1")
DbSetOrder(1)
IF dbSeek(xFilial("SE1")+Mv_Par03+Alltrim(Mv_Par01),.T.)
	
	While !Eof() .and. xFilial("SE1") == SE1->E1_FILIAL .and. SE1->E1_NUM <= Mv_Par02 ;
	             .And. SE1->E1_PREFIXO == Mv_Par03
		
		IF SE1->E1_TIPO == "NF "
			
			@ _nLinha,054 PSAY SE1->E1_EMISSAO
						
			_nLinha := _nLinha + 4
			
			DbSelectArea("SF2")
			DbSetOrder(1)
			
			IF DbSeek(xFilial("SF2")+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA)
			   @ _nLinha,002 PSAY SF2->F2_VALFAT Picture "@E@Z 99,999,999.99"
			EndIF
			
			@ _nLinha,018 PSAY SE1->E1_NUM
			@ _nLinha,029 PSAY SE1->E1_VALOR Picture "@E@Z 99,999,999.99"
			@ _nLinha,045 PSAY SE1->E1_NUM+"/"+SE1->E1_PARCELA
			@ _nLinha,057 PSAY SE1->E1_VENCTO
			
			_nLinha := _nLinha + 5
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			
			IF DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				
				@ _nLinha,026 PSAY SA1->A1_NOME
				@ _nLinha,072 PSAY SE1->E1_VEND1 
				_nLinha := _nLinha + 2
				
				@ _nLinha,026 PSAY Alltrim(SA1->A1_END)+" - "+SA1->A1_CEP
				_nLinha := _nLinha + 1
				
				@ _nLinha,026 PSAY SA1->A1_MUN
				@ _nLinha,062 PSAY SA1->A1_EST
				_nLinha := _nLinha + 1
				
				@ _nLinha,000 PSAY CHR(15)
				@ _nLinha,046 PSAY Alltrim(SA1->A1_ENDCOB)+" - "+Alltrim(SA1->A1_MUNC)+" - "+SA1->A1_ESTC+" - "+SA1->A1_CEPC
				@ _nLinha,078 PSAY CHR(18)
				_nLinha := _nLinha + 1
				
				@ _nLinha,026 PSAY SA1->A1_CGC
				@ _nLinha,054 PSAY SA1->A1_INSCR
				_nLinha := _nLinha + 2
				
			Endif
							
			@ _nLinha,027 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),01,52)) + REPLICATE("*",51),1,51)
			_nLinha := _nLinha + 1
			@ _nLinha,027 PSAY Subs(RTRIM(SUBS(EXTENSO(SE1->E1_VALOR),53,52)) + REPLICATE("*",51),1,51)
			_nLinha := _nLinha + 15
			@ _nLinha,002 PSAY " "
			
		EndIF
		
		_nlinha := 04
		SetPrc(0,0)
		
		DbSelectArea("SE1")
		Dbskip()
		Loop
		
	EndDO
EndIf

Set Device to Screen
DbSelectArea("SE1")
DbSetOrder(1)
DbSelectArea("SA1")
DbSetOrder(1)
//+------------------------------------------------------------------+
//¦ Se impressao em Disco, chama Spool.                              ¦
//+------------------------------------------------------------------+
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

//+------------------------------------------------------------------+
//¦ Libera relatorio para Spool da Rede.                             ¦
//+------------------------------------------------------------------+
FT_PFLUSH()