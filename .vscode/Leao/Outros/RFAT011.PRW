#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RFAT011()        // Relatorio de Pedidos em Carteira por Vendedor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("ARETURN,CBTXT,CBCONT,CDESC1,CDESC2,CDESC3")
SetPrvt("CPERG,CSTRING,LI,M_PAG,NLASTKEY,NOMEPROG")
SetPrvt("TITULO,WNREL,LIMITE,TAMANHO,ACPOTRB,ATAM")
SetPrvt("CNOMARQ,CKEY,CTPPED,CARQ,CFILTER,CKEY2")
SetPrvt("CARQIND,ASECAO,AVENDEDOR,NVLCOMIS,NVLNETO,NCUSTO")
SetPrvt("NLINHA,NTOTCOMI,CABEC1,CABEC2,NTGFATURA,NTGCOMIS")
SetPrvt("NTGIPI,NTGICMS,NTGVLNETO,NTGCUSTO,NTGFRETE,NTGCOMIBR")
SetPrvt("NTGCOMIAL,NTGEXTRAS,NTGVLCOMI,ATOTAL,LCABECPRIM,CTPPEDIDO")
SetPrvt("CTIT,I,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFAT011  ³ Autor ³ Luiz Eduardo          ³ Data ³ 06/11/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico p/ Espelhos Leao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de Pedidos em Carteira "
cDesc2   := "por vendedor"
cDesc3   := ""
cPerg    := "RFT011"
cString  := "SC5"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT011"
titulo   := "Pedidos em Carteira"
wnrel    := "RFAT011"
aOrdem   := {"Por Vendedor","Por Produto"}  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Representante de                                ³
//³ mv_par02  // representante ate                               ³
//³ mv_par03  // Regiao de                                       ³
//³ mv_par04  // Regiao ate                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

limite  := 080
tamanho := "P"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()

Return Nil

*************************
Static Function C030Imp()
*************************

nOrdem := aReturn [8]
if nOrdem==2

endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Select SC6
dbSetOrder(3)
SetRegua(recCount())
cTrb1 := Criatrab(nil,.f.)
set softseek on
Seek xFilial()+dtos(mv_par07)
set softseek off

Copy to &cTrb1 next 10000000 for c6_entreg>=mv_par07 .and. c6_entreg<=mv_par08 .and. left(c6_blq,1)<>"R"
dbUseArea( .T.,, cTrb1,"TRB", .F., .F. )
SetRegua(recCount())
Do while !eof()
   IncRegua()
   Select SB1
   Seek xFilial()+trb->c6_produto
   Select trb
   if sb1->b1_tipo#"PA" .or. left(c6_blq,1)="R"
       If rlock()
        Dele
       Endif
      Skip
      loop
   endif
   Select SC5  
   dbSetOrder(1)
   seek xFilial()+trb->c6_num
   Select SE1
   dbSetOrder(20)
   seek xFilial()+sc5->c5_num
   if !eof() .and. sc5->c5_tipo='C'
      Select trb
       If rlock()
         Dele
       Endif
      Skip
      loop
   endif
   Select trb
   if trb->c6_qtdven-trb->c6_qtdent<=0 .and. sc5->c5_tipo<>"C"
       If rlock()
         Dele
       Endif
      Skip
      loop
   endif

   Select SA1
   seek xFilial()+trb->(c6_cli+c6_loja)
   Select TRB
   IF SC5->C5_TIPO$"N*C";
	.and. SC5->C5_VEND1 >= mv_par01 .And. SC5->C5_VEND1 <= mv_par02 ;
	.and. trim(sa1->a1_regiao) >= trim(mv_par03);
	.and. trim(sa1->a1_regiao) <= mv_par04;
	.and. SC5->C5_EMISSAO >= mv_par05 .And. SC5->C5_EMISSAO <= mv_par06 ;
	.and. trb->C6_Entreg >= mv_par07 .And. trb->C6_Entreg <= mv_par08
	If rlock()
		trb->c6_la     := sc5->c5_vend1
		trb->c6_datfat := sc5->c5_emissao
		if left(trb->c6_produto,1)=="0"
		 	trb->c6_produto := "1"+substr(trb->c6_produto,2,14)
		endif
       Endif
   Else
       If rlock()
        Dele
       Endif
   Endif
   Skip
Enddo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Cabec1 := "Pedido  Emissao     Cliente                                  Quant.       Valor"
Cabec2 := ""
//                   1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

nOrdem := aReturn [8]
do Case
Case nOrdem==1
	Index on c6_la+dtos(c6_datfat) to &cTrb1
	RelVend()
Case nOrdem==2
	Index on c6_produto to &cTrb1
	RelProd()
EndCase

///
IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Spool de Impressao.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil


*************************
Static Function RelVend()
*************************

dbGotop()

SetRegua(recCount())

Do While !Eof()
	
	IncRegua()
	
        cVend := left(c6_la,6)
        Select SA1
        seek xFilial()+trb->(c6_cli+c6_loja)
        Select SA3
        Seek xFilial()+cVend
        If li > 60
	    cTit := Titulo+" por Vendedor"
	    Cabec(cTit,Cabec1,Cabec2,NomeProg,Tamanho)
        Endif
        LI := LI +1
        @ li,000 PSAY cVend+"-"+sa3->a3_nome
        LI := LI +1
        Select TRB
        nQtd := nVal := 0
        Do while !eof() .and. left(c6_la,6)==cVend
          If li > 60
	    Cabec(cTit,Cabec1,Cabec2,NomeProg,Tamanho)
            LI := LI +1
            @ li,000 PSAY cVend+"-"+sa3->a3_nome
            LI := LI +1
          Endif
          Select SA1
          seek xFilial()+trb->(c6_cli+c6_loja)
          Select TRB
          @ li,000 PSAY TRB->c6_num
          @ li,008 PSAY TRB->c6_datfat
          @ li,020 PSAY left(sa1->a1_nome,37)
          cPed := trb->c6_Num
          nQtdPed := nValPed := 0
          Do while !eof() .and. cPed == trb->c6_num
            nQtdPed := nQtdPed + TRB->(c6_qtdven-c6_qtdent)
            nValPed := nValPed + (TRB->(c6_qtdven-c6_qtdent)*trb->c6_prcven)
            Skip
          enddo          
          @ li,059 PSAY nQtdPed picture "999,999"
          @ li,067 PSAY nValPed picture "99,999,999.99"
          nQtd := nQtd + nQtdPed
          nVal := nVal + nValPed
          LI := LI +1
        Enddo
        @ li,020 PSAY "total do Vendedor "+cVend
        @ li,059 PSAY nQtd picture "999,999"
        @ li,067 PSAY nVal picture "99,999,999.99"
        LI := LI +1

Enddo
Return


*************************
Static Function RelProd()
*************************
Cabec1 := "Produto  Quant.       Valor"

Select TRB
dbGotop()

SetRegua(recCount())

nQtd := nVal := 0

Do While !Eof()
	
	IncRegua()
	
	Select TRB
	cProd1  := left(c6_produto,2)
	nQtdPed1:= nValPed1:= 0
	Do while !eof() .and. left(c6_produto,2)==cProd1
		cProd := left(c6_produto,5)
		nQtdPed := nValPed := 0
		Do while !eof() .and. left(c6_produto,5)==cProd
			nQtdPed := nQtdPed + TRB->(c6_qtdven-c6_qtdent)
			//            nValPed := nValPed + trb->c6_valor/TRB->c6_qtdven*(TRB->(c6_qtdven-c6_qtdent))
			nQtdPed1:= nQtdPed1+ TRB->(c6_qtdven-c6_qtdent)
			//            nValPed1:= nValPed1+ trb->c6_valor/TRB->c6_qtdven*(TRB->(c6_qtdven-c6_qtdent))
			if c6_qtdent==0
				nValPed := nValPed + trb->c6_valor
				nValPed1:= nValPed1+ trb->c6_valor
			else
				nValPed := nValPed + trb->c6_valor/TRB->c6_qtdven*(TRB->(c6_qtdven-c6_qtdent))
				nValPed1:= nValPed1+ TRB->c6_valor/TRB->c6_qtdven*(TRB->(c6_qtdven-c6_qtdent))
			endif
			Skip
		Enddo
		If li > 60
			cTit := Titulo+" por Grupo"
			Cabec(cTit,Cabec1,Cabec2,NomeProg,Tamanho)
		Endif
		if at(".",cProd)<>0
			@ li,001 PSAY left(cProd,4)
		else
			@ li,001 PSAY cProd
		endif
		@ li,015 PSAY nQtdPed picture "999,999"
		@ li,025 PSAY nValPed picture "99,999,999.99"
		nQtd := nQtd + nQtdPed
		nVal := nVal + nValPed
		nQtdPed := nValPed := 0
		LI := LI +1
	enddo
	@ li,001 PSAY "Sub-Tot.Grupo"
	@ li,015 PSAY nQtdPed1 picture "999,999"
	@ li,025 PSAY nValPed1 picture "99,999,999.99"
	LI := LI + 2
Enddo
LI := LI +1
@ li,001 PSAY "Total Geral"
@ li,015 PSAY nQtd picture "9,999,999"
@ li,025 PSAY nVal picture "99,999,999.99"

Return
