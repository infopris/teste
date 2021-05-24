#include "rwmake.ch"        

User Function RFOL002()        // Rela‡ao de PLR

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio de PLR"
cDesc2   := ""
cDesc3   := ""
cPerg    := "FOL002"
cString  := "SRC"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFOL002"
titulo   := "Relacao de PLR"
wnrel    := "RFOL002"
limite   := 132
tamanho  := "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Data de pagamento                               ³
//³ mv_par02  // Valor da parcela                                ³
//³ mv_par03  // Ano referencia                                  ³
//³ mv_par04  // Verba PLR (172)                                 ³
//³ mv_par05  // Gera lancto folha ?                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C030Imp  ³ Autor ³ Luiz Eduardo          ³ Data ³ 10/12/2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C030Imp                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico p/ Espelhos Leao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> Function C030Imp
Static Function C030Imp()                  

titulo   := "Relacao PLR "+strzero(month(mv_par01),2)+"/"+str(year(mv_par01),4)
Cabec1 := "Matr.   Nome                            Admissao    Demissao    Base Calc. Avos Proporcional"
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         0         1         2         3         4         5         6         7         8         9       100
Cabec2 := ""

Select SRA
dbSetOrder(2)

SetRegua(reccount())
go top
nNum := 0
li := 80
nBase := nVal := 0
Do while !eof()
  if left(sra->ra_cc,3)=='100'
     Skip
     Loop
  Endif
  IncRegua()
  If li > 60
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
    li := 9
  Endif
  Select SI3
  Seek xFilial()+sra->ra_cc
  Select SRA
  @ li,000 PSAY "Centro de Custos - "+sra->ra_cc+"-"+si3->i3_desc
  li := li + 2
  nCC := sra->ra_cc
  nBasecc := nValcc := 0
  Do while sra->ra_cc == nCC .and. !eof()
    if year(ra_admissa)>mv_par03 .or. (year(sra->ra_demissa)<mv_par03 .and. sra->ra_demissa#ctod("0"))
       Skip
       Loop
    Endif
    If li > 60
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
      li := 9
    Endif
    nAvos := 0
    CalcAvos()
    @ li,000 PSAY sra->ra_mat+"-"+sra->ra_nome
    @ li,040 PSAY sra->ra_admissa
    @ li,050 PSAY sra->ra_demissa
    @ li,064 PSAY mv_par02 picture '@E 999,999.99'
    @ li,075 PSAY nAvos picture '99'
    @ li,080 PSAY mv_par02/12*nAvos picture '999,999.99'
    li := li + 1
    nBase   := nBase   + mv_par02
    nVal    := nVal    + mv_par02/12*nAvos
    nBasecc := nBasecc + mv_par02
    nValcc  := nValcc  + mv_par02/12*nAvos
    if mv_par05 == 1
      Select SR1
      dbSetOrder(1)
      Seek xFilial()+sra->ra_mat+"01"+mv_par04
      if eof() .and. rlock()
        appe blan
      endif
      if rlock()
        sr1->r1_filial := "01"
        sr1->r1_mat    := sra->ra_mat
        sr1->r1_pd     := mv_par04
        sr1->r1_tipo1  := "V"
        sr1->r1_horas  := 1
        sr1->r1_valor  := mv_par02/12*nAvos
        sr1->r1_data   := mv_par01
        sr1->r1_semana := "02"
        sr1->r1_parcela:=  1
        sr1->r1_cc     := sra->ra_cc
        sr1->r1_tipo2  := "I"
      Endif
      Select SRC
      dbSetOrder(1)
      Seek xFilial()+sra->ra_mat+mv_par04
      if eof() .and. rlock()
        appe blan
      endif
      if rlock()
        src->rc_filial := "01"
        src->rc_mat    := sra->ra_mat
        src->rc_pd     := mv_par04
        src->rc_tipo1  := "V"
        src->rc_valor  := mv_par02/12*nAvos
        src->rc_data   := mv_par01
        src->rc_cc     := sra->ra_cc
        src->rc_tipo2  := "A"
        src->rc_semana := "02"
      Endif
      Seek xFilial()+sra->ra_mat+'523'
      if eof() .and. rlock()
        appe blan
      endif
      if rlock()
        src->rc_filial := "01"
        src->rc_mat    := sra->ra_mat
        src->rc_pd     := '523'
        src->rc_tipo1  := "V"
        src->rc_valor  := mv_par02/12*nAvos
        src->rc_data   := mv_par01
        src->rc_cc     := sra->ra_cc
        src->rc_tipo2  := "I"
        src->rc_semana := "02"
      Endif
    Endif
    Select SRA
    Skip
  Enddo
  li := li + 1
  @ li,000 PSAY "Totais do Centro de Custos "+si3->i3_desc+":"  
  @ li,064 PSAY nBasecc picture '999,999.99'
  @ li,080 PSAY nValcc  picture '999,999.99'
  nLi := li
  li := 80
Enddo
li := nLi + 2
@ li,001 PSAY "Totais Geral :"  
@ li,064 PSAY nBase  picture '999,999.99'
@ li,080 PSAY nVal   picture '999,999.99'

IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

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

************************
Static Function CalcAvos
************************
Do case
Case year(sra->ra_demissa)<mv_par03 .and. sra->ra_demissa#ctod("0")
  nAvos := 0
Case year(sra->ra_admissa)<mv_par03 .and. year(sra->ra_demissa)#mv_par03
  nAvos := 12
Case year(sra->ra_admissa)=mv_par03 .and. year(sra->ra_demissa)#mv_par03
  if day(sra->ra_admissa)<=15
    nAvos := 12-month(sra->ra_admissa)+1
  else
    nAvos := 12-month(sra->ra_admissa)
  Endif
Case year(sra->ra_admissa)=mv_par03 .and. year(sra->ra_demissa)==mv_par03
  if day(sra->ra_admissa)<=15
    nAvos := 12-month(sra->ra_admissa)+1
  else
    nAvos := 12-month(sra->ra_admissa)
  Endif
  nDem := 0
  if day(sra->ra_demissa)<=15
    nDem := 12-month(sra->ra_demissa)+1
  else
    nDem := 12-month(sra->ra_demissa)
  Endif
  nAvos := nAvos - nDem
Case year(sra->ra_admissa)#mv_par03 .and. year(sra->ra_demissa)==mv_par03
  nAvos := 12
  nDem  := 0
  if day(sra->ra_demissa)<=15
    nDem := 12-month(sra->ra_demissa)+1
  else
    nDem := 12-month(sra->ra_demissa)
  Endif
  nAvos := nAvos - nDem
EndCase
Return
