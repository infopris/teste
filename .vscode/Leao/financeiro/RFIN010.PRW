#include "rwmake.ch"  

User Function RFin010()   // Reconciliacao de Cheques (contabeis)

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

// EF_IMPRES="A" = CHEQUES AGLUTINADORES

cPerg      := "RFIN10"

if !Pergunte (cPerg,.T.)
  Return
Endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (CHEQUE)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Da banco                                                    ³
// ³ mv_par04 => Da agencia                                                  ³
// ³ mv_par05 => Da conta                                                    ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",15,0}) 
AADD(aCampos,{ "EMISSAO" , "D",08,0}) 
AADD(aCampos,{ "VALOR"   , "N",12,2}) 
AADD(aCampos,{ "BENEF"   , "C",20,0}) 
AADD(aCampos,{ "HISTOR"  , "C",60,0}) 
AADD(aCampos,{ "MARCA"   , "C",01,0}) 
AADD(aCampos,{ "OK"      , "C",02,0}) 
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on Num to &cTemp

Processa( {|| RunProc() } )
Select TRB
Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SEF
Retindex("SEF")
dbSetOrder(5)
set softseek on
Seek xFilial()+"S"+dtos(mv_par01)
set softseek off
ProcRegua(reccount())

Do while !eof() .and. sef->ef_data>=mv_par01 .and. sef->ef_data<=mv_par02
	IncProc()
	if EF_IMPRESS=="A" .or. left(upper(ef_benef),2)="TB"
		skip
		loop
	endif
	if sef->(ef_banco+ef_agencia+ef_conta)<>(mv_par03+mv_par04+mv_par05)
		skip
		loop
	endif
	Select TRB
	RecLock("TRB",.t.)
	trb->Num	:= sef->ef_num
	trb->Emissao	:= sef->ef_data
	trb->Valor  	:= sef->ef_valor
	trb->Histor 	:= sef->ef_hist 
	trb->Benef  	:= sef->ef_benef
	trb->Marca  	:= sef->ef_rg
	if left(sef->ef_rg,1)=="@"
		trb->Ok := "AA"
	Endif

	Select SEF
	Skip
Enddo

dbSetOrder(5)
set softseek on
Seek xFilial()+" "+dtos(mv_par01)
set softseek off

ProcRegua(reccount())
Do while !eof() .and. sef->ef_data>=mv_par01 .and. sef->ef_data<=mv_par02
	IncProc()
	if EF_IMPRESS=="A" .or. left(upper(ef_benef),2)="TB"
		skip
		loop
	endif
	if sef->(ef_banco+ef_agencia+ef_conta)<>(mv_par03+mv_par04+mv_par05)
		skip
		loop
	endif
	Select TRB
	RecLock("TRB",.t.)
	trb->Num	:= sef->ef_num
	trb->Emissao	:= sef->ef_data
	trb->Valor  	:= sef->ef_valor
	trb->Histor 	:= sef->ef_hist 
	trb->Benef  	:= sef->ef_benef
	trb->Marca  	:= sef->ef_rg
	if left(sef->ef_rg,1)=="@"
		trb->Ok := "AA"
	Endif
	Select SEF
	Skip
Enddo

Tela1()

************************
Static Function Tela1()
************************

@ 100,1 TO 600,800 DIALOG oDlg2 TITLE "Escolha de Cheques"

Select TRB
go top
aCampos := {}
AADD(aCampos,{"OK","OK"})   
AADD(aCampos,{"NUM","Cheque","@!"})
AADD(aCampos,{"EMISSAO","Emissao"}) 
AADD(aCampos,{"VALOR","Valor","@E 999,999"})
AADD(aCampos,{"HISTOR","Historico"})
AADD(aCampos,{"BENEF","Beneficiario"})
AADD(aCampos,{"MARCA","Contabil"})
@ 6,5 TO 210,400 BROWSE "TRB" FIELDS aCampos ENABLE "OK" MARK "OK"

@ 220,020 BUTTON "_Ok" SIZE 40,15 ACTION Confirm()
@ 220,070 BUTTON "_Pesquisa"      SIZE 40,15 ACTION Pesq()
@ 220,120 BUTTON "_Imprime"       SIZE 40,15 ACTION Imprime()
@ 220,170 BUTTON "_Limpa" SIZE 40,15 ACTION limpaok()
@ 220,270 BUTTON "_Cancela" SIZE 40,15 ACTION Close(oDlg2)

@ 240,155 SAY "- Clicar nas cheques a serem enviados"

ACTIVATE DIALOG oDlg2 CENTERED
Return


Return

*--------------------------*
Static Function confirm()   // Marca Cheque para envio a contabilidade
*--------------------------*
Close(oDlg2)
Select Trb
Go top
Do while !eof()
  if empty(trb->Ok)
    Skip
    Loop
  endif
  Select SEF
  dbSetOrder(1)
  seek xFilial()+mv_par03+mv_par04+mv_par05+trb->Num
  do while !eof() .and. sef->(ef_banco+ef_agencia+ef_conta+ef_num)==(mv_par03+mv_par04+mv_par05+trb->Num)
	if !eof() .and. rlock() .and. ef_impress<>"A"
		sef->ef_rg := "@-"+dtoc(ddatabase)
	Endif
	skip
  enddo
  MsUnlock()
  Select TRB
  Skip
Enddo

Return

*-------------------------*
Static Function LimpaOk()
*-------------------------*
Close(oDlg2)
Select TRB
if MsgBox ("Retornar cheque "+trb->Num,"Escolha","YESNO")
  if rlock()
     trb->ok     := "  "
  Endif
  Select SEF
  dbSetOrder(1)
  seek xFilial()+mv_par03+mv_par04+mv_par05+trb->Num
  Do while !eof() .and. trb->Num == sef->ef_num
	if EF_IMPRESS=="A" .or. left(upper(ef_benef),2)="TB"
		skip
		loop
	endif
	if sef->(ef_banco+ef_agencia+ef_conta)<>(mv_par03+mv_par04+mv_par05)
		skip
		loop
	endif
	if !eof() .and. rlock() .and. left(ef_RG,1)=="@"
		sef->ef_rg := "  "
	Endif
	skip
  Enddo
Endif
Tela1()
return


***************************
Static Function Pesq()
***************************
cChave := space(20)
cArq := space(1)
aArq := {}
AADD(aArq,"Cheque Numero")

@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Pesquisa"
@ 15,010 TO 55,180
@ 26,030 COMBOBOX cArq   ITEMS aArq SIZE 140,50
@ 40,030 get cChave picture "@!" SIZE 140,20  VALID .t.
@ 20,196 BMPBUTTON TYPE 1 ACTION Pesq1()
@ 35,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
Return .t.

***************************
Static Function Pesq1()
***************************
Close(oDlg1)

cTempB := CriaTrab(nil,.f.)
Select TRB
Seek trim(cChave)

Return

Do case
 Case trim(cArq)=="Codigo Produto"
 Index on Cod to &cTempB
Case trim(cArq)=="Data Entrega"
 Index on Dtos(Entrega)+Cod to &cTempB
Case trim(cArq)=="Numero da OP"
 Index on Num+Item to &cTempB
Endcase

Seek trim(cChave)
Return

*************************
Static Function Imprime()
*************************

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Vendas por Margem"
cDesc2   := ""
cDesc3   := ""
cString  := "SC5"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFIN010"
titulo   := "Cheques enviados para a Contabilidade"
wnrel    := "RFIN010"
limite   := 132
tamanho  := "M"
nValPed  := 0

Cabec1 := "Cheque    Emissao     Valor tit   Historico"
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec2 := "Data de "+dtoc(mv_par01)+" ate' "+dtoc(mv_par02)+" Banco "+mv_par03+" "+mv_par04+" "+mv_par05

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho)

If nLastKey == 27
Set Filter To
	Return Nil
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf    
  
nTot := 0
RptStatus({|| Imprime1() })

**************************
Static Function Imprime1()
**************************
Select TRB
SetRegua(recCount())
nTot := nQtd := 0
li   := 80
dbGoTop()
Do while !eof()
	IncRegua()
	if empty(trb->Ok)
		Skip
		Loop
	Endif
	If li > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
	Endif
	@ li,000 PSAY trb->Num
	@ li,010 PSAY trb->Emissao
	@ li,022 PSAY trb->Valor picture "@E 9999,999.99"
	@ li,034 PSAY trb->Histor
	@ li,096 PSAY trb->Benef
	nTot+= trb->valor
	nQtd++
	li++
	Skip
Enddo
li := li + 1
@ li,022 PSAY nTot picture "@E 9999,999.99"
@ li,034 PSAY "Numero de Titulos Enviados "+str(nQtd,4)
go top

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
