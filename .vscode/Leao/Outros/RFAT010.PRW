#include "rwmake.ch" 

User Function RFAT010()  // Estatistico de Vendas por Vendedor/Grupo (SCT)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFAT010  ³ Autor ³ Luiz Eduardo          ³ Data ³ 30/09/2003 ³±±
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
cDesc1   := "Este programa ira emitir o Relatorio Estatistico"
cDesc2   := "de vendas por vendedor/grupo de produtos"
cDesc3   := ""
cPerg    := "RFT010"
cString  := "SC6"
li       := 132
tamanho  := "G"
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT010"
titulo   := "Relacao de Vendas por Grupo"
wnrel    := "RFAT010"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Periodo de                                      ³
//³ mv_par02  // Periodo ate                                     ³
//³ mv_par03  // Vendedor de                                     ³
//³ mv_par04  // Vendedor Ate                                    |
//| mv_par05  // Grupo de                                        |
//| mv_par06  // Grupo Ate                                       |
//| mv_par07  // Ultima data Base                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MV_PAR07:= CTOD("31/12/2002")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

limite  := 132
tamanho := "M"
nNumMes := month(mv_par02)-month(mv_par01)+1

RptStatus( { ||C030Imp()})
MS_FLUSH()

Return Nil

**************************
Static Function C030Imp()
**************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVendas := {}
AADD(aVendas,{"GRUPO" ,"C",04,0})
AADD(aVendas,{"VEND"  ,"C",06,0})
AADD(aVendas,{"PEDIDO","C",06,0})
AADD(aVendas,{"VEN01" ,"N",12,2})
AADD(aVendas,{"VEN02" ,"N",12,2})
AADD(aVendas,{"VEN03" ,"N",12,2})
AADD(aVendas,{"VEN04" ,"N",12,2})
AADD(aVendas,{"VEN05" ,"N",12,2})
AADD(aVendas,{"VEN06" ,"N",12,2})
AADD(aVendas,{"VEN07" ,"N",12,2})
AADD(aVendas,{"VEN08" ,"N",12,2})
AADD(aVendas,{"VEN09" ,"N",12,2})
AADD(aVendas,{"VEN10" ,"N",12,2})
AADD(aVendas,{"VEN11" ,"N",12,2})
AADD(aVendas,{"VEN12" ,"N",12,2})

ctrb1 := CriaTrab( aVendas, .T.)
dbUseArea( .T.,, cTrb1,"TRB1", .F., .F. )
Index on Vend+Grupo+Pedido to &cTrb1
Select SA3
go top
SetRegua(recCount())
Do while !eof()
  IncRegua()
  cVend := sa3->a3_cod
  if left(sa3->a3_inscrm,1)=='X'
     skip
     loop
  endif
  Select SBM
  go top
  Do while !eof()
    Select TRB1
    if rlock()
      Appe Blan
      trb1->grupo := sbm->bm_grupo
      trb1->vend  := cVend
    Endif
    Select SBM
    Skip
  Enddo
  Select SA3
  Skip
Enddo
Select SC5
dbSetOrder(2)
Seek xFilial()+dtos(mv_par01)
SetRegua(recCount())
While !Eof()
   IncRegua()
   IF SC5->C5_EMISSAO < MV_PAR01 .or. SC5->C5_EMISSAO > MV_PAR02 .or.; 
      SC5->C5_VEND1   < MV_PAR03 .or. SC5->C5_VEND1   > MV_PAR04 
      Skip
      Loop
   Endif
   Select SC6
   Seek xFilial()+sc5->c5_num
   Do while !eof() .and. sc6->c6_num==sc5->c5_num
      Select SF4
      Seek xFilial()+sc6->c6_tes
      Select SC6
      if sf4->f4_duplic=="N"
         Skip
         Loop
      Endif
      Select SB1
      Seek xFilial()+sc6->c6_produto
      Select TRB1
      Seek sc5->c5_vend1+sb1->b1_grupo
      if eof() .and. rlock()
         Appe Blan
      Endif
      cMes := "VEN"+strzero(month(sc5->c5_emissao),2)
      if rlock()
         trb1->grupo := sb1->b1_grupo
         trb1->vend  := sc5->c5_vend1
         &cMes       := sc6->c6_qtdven + &cMes
      Endif
      Select SC6
      Skip
   Enddo
   Select SC5
   Skip
Enddo
Imprime()
//Select Trb1
//use
Select SC5
Return

*************************
Static Function Imprime()
*************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTit  := Titulo+" - "+dtoc(mv_par01)+" a "+dtoc(mv_par02)
Cabec1:= "       Grupo      Jan     Fev     Mar     Abr     Mai     Jun     Jul     Ago     Set     Out     Nov     Dez     Total  Media"
Cabec2:= ""
//                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
//        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890



dbSelectArea("TRB1")
index on Vend+Grupo to &cTrb1
dbGotop()

SetRegua(recCount())

Do While !Eof()
	
	IncRegua()

        IF TRB1->VEND < MV_PAR03 .or. TRB1->VEND > MV_PAR04
          Skip
          Loop
        Endif

        IF TRB1->GRUPO < MV_PAR05 .or. TRB1->GRUPO > MV_PAR06
          Skip
          Loop
        Endif
	
	If li > 60
	   Cabec(cTit,Cabec1,Cabec2,NomeProg,Tamanho)
 	   Select SA3
           dbSetOrder(1)
           seek xFilial()+TRB1->Vend
           @ li,000 PSAY TRB1->Vend+"-"+sa3->a3_nome
           li := li + 2
	Endif
        cVend := trb1->Vend
        nTot := trb1->(ven01+ven02+ven03+ven04+ven05+ven06+ven07+ven08+ven09+ven10+ven11+ven12)
	@ li,001 PSAY "VENDAS - "+trim(TRB1->Grupo)
	@ li,015 PSAY TRB1->ven01 picture "99,999"
	@ li,023 PSAY TRB1->ven02 picture "99,999"
	@ li,031 PSAY TRB1->ven03 picture "99,999"
	@ li,039 PSAY TRB1->ven04 picture "99,999"
	@ li,047 PSAY TRB1->ven05 picture "99,999"
	@ li,055 PSAY TRB1->ven06 picture "99,999"
	@ li,063 PSAY TRB1->ven07 picture "99,999"
	@ li,071 PSAY TRB1->ven08 picture "99,999"
	@ li,079 PSAY TRB1->ven09 picture "99,999"
	@ li,087 PSAY TRB1->ven10 picture "99,999"
	@ li,095 PSAY TRB1->ven11 picture "99,999"
	@ li,103 PSAY TRB1->ven12 picture "99,999"
	@ li,111 PSAY nTot         picture "999,999"
	@ li,120 PSAY nTot/nNumMes picture "999,999"
        Select SCT
        dbSetOrder(2)
        seek xFilial()+DTOS(MV_PAR07)+cVend+trb1->grupo
        If !eof() .and. sct->ct_quant#0
          li := li + 1
          nMeta := (sct->ct_quant/12)/100
          @ li,001 PSAY "META - "
          @ li,015 PSAY TRB1->ven01/nMeta picture "99,999%"
	  @ li,023 PSAY TRB1->ven02/nMeta picture "99,999%"
	  @ li,031 PSAY TRB1->ven03/nMeta picture "99,999%"
	  @ li,039 PSAY TRB1->ven04/nMeta picture "99,999%"
	  @ li,047 PSAY TRB1->ven05/nMeta picture "99,999%"
	  @ li,055 PSAY TRB1->ven06/nMeta picture "99,999%"
	  @ li,063 PSAY TRB1->ven07/nMeta picture "99,999%"
	  @ li,071 PSAY TRB1->ven08/nMeta picture "99,999%"
	  @ li,079 PSAY TRB1->ven09/nMeta picture "99,999%"
	  @ li,087 PSAY TRB1->ven10/nMeta picture "99,999%"
	  @ li,095 PSAY TRB1->ven11/nMeta picture "99,999%"
	  @ li,103 PSAY TRB1->ven12/nMeta picture "99,999%"
	  @ li,111 PSAY sct->ct_quant     picture "999,999"
	  @ li,120 PSAY sct->ct_quant/12  picture "999,999"
        Endif
	li := li + 2
        @ li,000 PSAY Replicate("-",132)
	li := li + 2
	
	dbSelectArea("TRB1")
	dbSkip()
        if cVend # trb1->Vend
           li := 80
        endif

Enddo


///
IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB1")
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
