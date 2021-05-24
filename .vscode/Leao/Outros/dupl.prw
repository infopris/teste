#include "rwmake.ch" 

User Function Dupl()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("CPERG,NLASTKEY,LI,CSAVSCR1,CSAVCUR1,CSAVROW1")
SetPrvt("CSAVCOL1,CSAVCOR1,WNREL")

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ DUPLI    ¦ Autor ¦ MICROSIGA             ¦ Data ¦ 09.09.94 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦EMITE DUPLICATA PADRAO MICROSIGA                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ DUPLI  (void)                                              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
//+--------------------------------------------------------------+
//¦ Define Variaveis                                             ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Define Variaveis.                                            ¦
//+--------------------------------------------------------------+
tamanho := "P" 
limite  := 80
titulo  := "EMISSAO DE DUPLICATAS"
cDesc1  := "IMPRIMIR DIRETO NA PORTA, EPSON. SE NECESSARIO CONFIGURAR"
cDesc2  := "A IMPRESSORA MATRICIAL NO WINDOWS"
cDesc3  := ""
cString := "SE1"
aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
cPerg   :="MTR750"
nLastKey := 0
li := 0
//+---------------------------------------------+
//¦ Variaveis utilizadas para parametros	¦
//¦ mv_par01		// Duplicata de		¦
//¦ mv_par02		// Duplicata ate	¦
//¦ mv_par03		// Serie                ¦
//+---------------------------------------------+
//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
pergunte("MTR750",.F.)

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT.                       ¦
//+--------------------------------------------------------------+
wnrel:="DUPLI" 

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

dbSelectArea("SE1")
dbSetOrder(1)
set softseek on
dbSeek(Xfilial()+mv_par03+mv_par01)
set softseek off
	
If Found()
//Set Print On   
//Set Device to Print
@ prow(),000 PSAY CHR(15)
	
	While E1_NUM >= mv_par01 .and. E1_NUM <= mv_par02 .And. E1_PREFIXO == mv_par03 .and. !Eof() 
                Select sd2
		dbSetOrder(3)
		Seek xFilial()+se1->e1_num+se1->e1_prefixo
                Select sc5
		dbSetOrder(1)
		Seek xFilial()+sd2->d2_pedido
                Select sa4
		dbSetOrder(1)
		Seek xFilial()+sc5->c5_transp
                Select sF4
		dbSetOrder(1)
		Seek xFilial()+sd2->d2_tes
		Select SE1
//		If E1_FATURA == "NOTFAT"
                        li:= li + 2
			@ prow()+2,086 PSAY sd2->d2_cf + " - "+sf4->f4_texto
                        li:= li + 1
			@ prow()+1,086 PSAY sa4->a4_via
                        li:= li + 1
			@ prow()+1,086 PSAY E1_EMISSAO	
			li:= li + 4
			@ prow()+4,022 PSAY E1_NUM
			@ prow()+0,044 PSAY E1_VALOR PICTURE "@E 999,999.99"
			@ prow()+0,067 PSAY E1_PREFIXO+" "+E1_NUM+E1_PARCELA
			@ prow()+0,092 PSAY E1_VENCTO
			li:= li + 5
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(Xfilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
			If found()
                                if left(A1_ENDCOB,20)==space(20)
                                  cEndc := "- O MESMO"
				else
                                  cEndc :=  "-"+trim(A1_ENDCOB) + "-"+trim(A1_munc)+ "-"+A1_ESTC
				endif
				@ prow()+5,035 PSAY A1_NOME
				li:= li + 1
				@ prow()+1,035 PSAY A1_END+"- CEP "+left(a1_cep,5)+"-"+substr(a1_cep,6,3)
				li:= li +1
				@ prow()+1,035 PSAY A1_MUN
				@ prow()+0,086 PSAY A1_EST
//				@ prow()+0,116 PSAY se1->e1_pedido
				li := li + 1
				@ prow()+1,035 PSAY left(a1_cepc,5)+"-"+substr(a1_cepc,6,3)+cEndc
				li := li + 1
                                @ prow()+1,035 PSAY SA1->A1_CGC PICTURE IIF(LEN(ALLTRIM(SA1->A1_CGC)) == 11,'@R 999.999.999-99','@R 99.999.999/9999-99')
				@ prow()+0,090 PSAY A1_INSCR
				@ prow()+0,116 PSAY sc5->c5_vend1
				li := li + 2
			Endif	
			DbSelectArea("SE1")
			@ prow()+2,035 PSAY Substr(RTRIM(SUBSTR(EXTENSO(SE1->E1_VALOR),  1,71)) + REPLICATE("*",71),1,71)
			li:= li + 1
         	        @ prow()+1,035 PSAY Substr(RTRIM(SUBSTR(EXTENSO(SE1->E1_VALOR), 72,71)) + REPLICATE("*",71),1,71)
                        li:= li + 1
          	        @ prow()+1,035 PSAY Substr(RTRIM(SUBSTR(EXTENSO(SE1->E1_VALOR),143,71)) + REPLICATE("*",71),1,71)
			li:= li + 1
	                @ prow()+1,035 PSAY Substr(RTRIM(SUBSTR(EXTENSO(SE1->E1_VALOR),214,71)) + REPLICATE("*",71),1,71)
	                DbSelectArea("SE1")
			DbSkip()
//		Else
//            DbSelectArea("SE1")
//			Dbskip()
//			Loop
//		Endif
		li := li + 14
		@ prow()+14,0 Psay " "
	EndDO
EndIf
@ prow(),000 PSAY CHR(18)
//Set Device to Screen
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
FT_PFLUSH()