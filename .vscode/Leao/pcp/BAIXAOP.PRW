#include "rwmake.ch"

User Function BaixaOp()   // Programa para baixar OP's (gerando entrada no estoque)

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "BAIXOP"

if !Pergunte (cPerg,.T.)
	Return
Endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Da Op                                                       ³
// ³ mv_par04 => Ate Op                                                      ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0})
AADD(aCampos,{ "ITEM"    , "C",02,0})
AADD(aCampos,{ "SEQ"     , "C",03,0})
AADD(aCampos,{ "COD"     , "C",15,0})
AADD(aCampos,{ "PEDIDO"  , "C",06,0})
AADD(aCampos,{ "CLIENTE" , "C",30,0})
AADD(aCampos,{ "DESC"    , "C",30,0})
AADD(aCampos,{ "QTDE"    , "N",12,2})
AADD(aCampos,{ "ENTREGA" , "D",08,0})
AADD(aCampos,{ "EMISSAO" , "D",08,0})
AADD(aCampos,{ "OK"      , "C",02,0})
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on Cod to &cTemp

Processa( {|| RunProc() } )
Select TRB
Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Private dProd := dDataBase

@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Confirma"
@ 15,010 TO 55,180
@ 26,030 say "Data de Produção"
@ 40,030 get dProd  SIZE 60,20  VALID .t.
//@ 20,196 BMPBUTTON TYPE 1 ACTION AltEnt1()
@ 35,196 BMPBUTTON TYPE 1 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED
//Return .t.


Select SC2
Retindex("SC2")

dbSetOrder(6)
go top
ProcRegua(50)
Do while !eof() // .and. c2_datrf==ctod("0")
	IncProc()
	if c2_emissao<mv_par01 .or. c2_emissao>mv_par02 .or. ;
		c2_num<mv_par03 .or. c2_num>mv_par04 .or. !empty(c2_datrf)
		Skip
		loop
	Endif
	
	Select SB1
	seek xFilial()+sc2->c2_produto
	Select SC6
	seek xFilial()+sc2->c2_pedido
	Select SA1
	seek xFilial()+sc6->(c6_cli+c6_loja)
	Select TRB
	reclock("trb",.t.)
	trb->Num    := sc2->c2_num
	trb->Item   := sc2->c2_item
	trb->Seq    := sc2->c2_sequen
	trb->Cod    := sc2->c2_produto
	trb->Desc   := sb1->b1_desc
	trb->Qtde   := sc2->c2_quant-sc2->c2_quje
	trb->Entrega:= sc2->c2_datprf
	trb->Emissao:= sc2->c2_emissao
	trb->Cliente:= sa1->a1_nome
	trb->Pedido := sc2->c2_pedido
	msunlock()
	Select SC2
	Skip
Enddo

EscolheOp()
Return

*--------------------------*
Static Function BxOp()   // Baixas Op / Entrada no Estoque / Baixa MP
*--------------------------*
Close(oDlg2)
Select Trb
Go top
Do while !eof()
	//if Marked("OK")
	if empty(trb->Ok)
		Skip
		Loop
	endif
	Select SC2
	dbSetOrder(1)
	seek xFilial()+trb->(Num+Item+Seq)
	if !eof()
		reclock("sc2",.f.)
		sc2->c2_quje := sc2->c2_quje + trb->qtde
		if sc2->c2_quje >= sc2->c2_quant
			sc2->c2_datrf:= date()
		endif
	Endif
	MsUnlock()
	Select SB1
	dbSetOrder(1)
	seek xFilial()+trb->(Cod)
	Select SB2
	dbSetOrder(1)
	seek xFilial()+trb->(Cod)+sc2->c2_local
	if !eof()
		reclock("sb2",.f.)
		sb2->b2_qatu := sb2->b2_qatu + trb->qtde
		if sb1->b1_tipconv=="D"
			sb2->b2_qtsegum := sb2->b2_qatu/sb1->b1_conv
		else
			sb2->b2_qtsegum := sb2->b2_qatu*sb1->b1_conv
		endif
		MsUnLock()
	Endif
	cNum := cNum1 := " "
	VerX6()
	Select SD3
	reclock("SD3",.t.)
	* If rlock()
	*   appe blan
	sd3->d3_filial := xFilial()
	sd3->d3_tm     := "001"
	sd3->d3_cod    := trb->Cod
	sd3->d3_um     := sb1->b1_um
	sd3->d3_quant  := trb->qtde
	sd3->d3_cf     := "PR0"
	sd3->d3_op     := sc2->(c2_num+c2_item+c2_sequen)
	sd3->d3_local  := sc2->c2_local
	sd3->d3_doc    := sc2->c2_num
	sd3->d3_emissao:= dProd
	sd3->d3_grupo  := sb1->b1_grupo
	sd3->d3_parctot:= "T"
	sd3->d3_chave  := "R0"
	sd3->d3_segum  := sb1->b1_segum
	sd3->d3_qtsegum:= trb->qtde/sb1->b1_conv
	sd3->d3_tipo   := sb1->b1_tipo
	sd3->d3_numseq := cNum
	sd3->d3_ident  := cNum1
	* Endif
	MsUnlock()
	dbSelectArea("SG1")
	dbSetOrder(1)
	cCod := left(trb->Cod,at(".",trb->Cod)-1)
	Seek xFilial()+cCod
	Do while !eof() .and. trim(sg1->g1_cod)==trim(cCod)
		cComp := SG1->G1_COMP
		// Desabilitei as funcoes abaixo pois as molduras nao serao mais controladas por cor
		if left(cComp,6)#"12.091" .and. 1==2
			if left(cComp,3)=='12.' .or. left(cComp,3)=='32.'
				cComp := Trim(cComp)+"."+substr(trb->Cod,6,4)
			endif
		Endif
		if left(cComp,2)='12' .and. substr(trb->cod,8,1)=="V" .and. 1==2
			Select SX5
			seek xFilial()+"C9V"+substr(trb->Cod,9,1)
			if !eof()
				aCores := {}
				n:=1
				Do while .t.
					cCor := substr(X5_Descri,n,2)
					nQtd := val(substr(X5_Descri,n+2,2))
					if cCor==space(2)
						exit
					endif
					aAdd(aCores,{cCor,nQtd})
					n:=n+5
				Enddo
				For x:=1 to len(aCores)
					nDiv := 1/(aCores[x][2]/100)
					if left(cComp,6)#"12.091"
						cComp := left(cComp,6)+"."+substr(trb->Cod,6,2)+aCores[x][1]+space(4)
					endif
					Select SB2
					Seek xFilial()+cComp+sb1->b1_locpad
					gravad3()
				Next x
			else
				nDiv := 1
				gravad3()
			endif
		else
			nDiv := 1
			gravad3()
		endif
		Select SG1
		Skip
	Enddo
	
	Select TRB
	Skip
Enddo

Return


*-------------------------*
Static Function EscolheOp()
*-------------------------*

@ 100,1 TO 600,700 DIALOG oDlg2 TITLE "Escolha Ordens de Producao"

Select TRB
go top
aCampos := {}
AADD(aCampos,{"OK","OK"})
AADD(aCampos,{"Num","Pedido","@!"})
AADD(aCampos,{"Cod","Cod.Prod."})
AADD(aCampos,{"Desc","Descricao do Produto"})
AADD(aCampos,{"qtde","Quantidade","@E 999,999"})
AADD(aCampos,{"Emissao","Emissao"})
AADD(aCampos,{"Cliente","Nome do Cliente"})
AADD(aCampos,{"Pedido","Pedido"})
@ 6,5 TO 210,350 BROWSE "TRB" FIELDS aCampos ENABLE "OK" MARK "OK"

@ 220,020 BUTTON "_Ok" SIZE 40,15 ACTION BxOp()
@ 220,070 BUTTON "_Pesquisa"      SIZE 40,15 ACTION Pesq()
@ 220,120 BUTTON "_Altera Quant" SIZE 40,15 ACTION AltQtd()
@ 220,170 BUTTON "_Limpa" SIZE 40,15 ACTION limpaok()
@ 220,220 BUTTON "_Encerra OP" SIZE 40,15 ACTION encerra()
@ 220,270 BUTTON "_Cancela" SIZE 40,15 ACTION Close(oDlg2)

@ 10,155 SAY "- Clicar nas ordens a serem baixadas"
ACTIVATE DIALOG oDlg2 CENTERED
Return

*-------------------------*
Static Function LimpaOk()
*-------------------------*
Close(oDlg2)
Select TRB
//go top
//Do while !eof()
if MsgBox ("Retornar produto "+trb->Cod,"Escolha","YESNO")
	reclock("trb",.f.)
	trb->ok     := "  "
	msunlock()
Endif
//  Skip
//Enddo
EscolheOp()
return

*-------------------------*
Static Function AltQtd()
*-------------------------*
Select TRB
xRecTrb := Recno()
//Close(oDlg2)
nQtd := trb->qtde
@ 196,52 TO 343,505 DIALOG oDlg6 TITLE "Altera quantidade de pecas"
@ 15,010 TO 45,250
@ 18,020 say "Produto : "+trb->Cod
@ 26,020 say trb->desc
@ 18,145 say "Qtde"
@ 26,140 get nQtd picture "99999" SIZE 25,25
@ 50,168 BMPBUTTON TYPE 1 ACTION GrvAlt()
@ 50,196 BMPBUTTON TYPE 2 ACTION FecTel6()
ACTIVATE DIALOG oDlg6 CENTERED

Select TRB
goto xRecTrb

Return .t.

****************************
Static function FecTel6()
****************************
Close(oDlg6)
//Close(oDlg2)
//EscolheOp()
Return

************************
Static function GrvAlt()
************************
Select TRB
reclock("trb",.f.)
trb->qtde := nQtd
trb->ok   := "xx"
msunlock()
Close(oDlg2)
Close(oDlg6)
EscolheOp()
return

**************************
Static Function Encerra()
**************************
if !MsgBox ("Confirma OP "+trb->(Num+Item+Seq),"Escolha","YESNO")
	Return
endif
Close(oDlg2)
Select SC2
dbSetOrder(1)
seek xFilial()+trb->(Num+Item+Seq)
if !eof()
	reclock("sc2",.f.)
	sc2->c2_datrf:= date()
	MsUnLock()
Endif
Select TRB
if rlock()
	delete
Endif
go top
EscolheOp()

return

***********************
Static Function GravaD3() // Grava arquivo SD3 e SB2
***********************
Select SB1
Seek xFilial()+cComp
dbSelectArea("SD3")
reclock("SD3",.t.)
sd3->d3_quant   := (SG1->G1_QUANT*(trb->qtde)*(1+(sg1->g1_perda/100)))/nDiv
sd3->d3_emissao := dProd // dDataBase
sd3->d3_usuario := Alltrim(Substr(cUsuario,7,15))
sd3->d3_cod     := cComp
sd3->d3_doc     := trb->Num
sd3->d3_filial  := xFilial("SD3")
sd3->d3_local   := "02"
sd3->d3_tm      := "999"
sd3->d3_cf      := "RE0"
sd3->d3_numseq  := cNum
sd3->d3_ident   := cNum1
sd3->d3_cc      := "BX"
sd3->d3_um      := sb1->b1_um
sd3->d3_op      := trb->(num+item+seq)
sd3->d3_segum   := sb1->b1_segum
sd3->d3_qtsegum := trb->qtde/sb1->b1_conv
sd3->d3_tipo    := sb1->b1_tipo
msunlock()
Select SB2
Seek xFilial()+trim(cComp)+space(15-len(trim(cComp)))+"02"
if !eof()
	reclock("sb2",.f.)
	sb2->b2_filial := xFilial()
	sb2->b2_qatu   := sb2->b2_qatu - sd3->d3_quant
	sb2->b2_local  := "02"
	sb2->b2_cod    := cComp
	MsUnlock()
endif

Return

***********************
Static Function VerX6()  // Verifica Pr¢ximo n£mero na seqencia
***********************
Select SD3
dbSetOrder(4)
Go Bott
cNum := d3_numseq

Return

Select SX6
seek "  MV_DOCSEQ"
cPrf := left(X6_CONTEUD,1)
cNum := VAL(substr(X6_CONTEUD,2,5))+1
cNum1:= VAL(substr(X6_CONTEUD,2,5))+2
cNum := cPrf + strzero(cNum,5)
cNum1:= cPrf + strzero(cNum1,5)
reclock("SX6",.f.)
sx6->x6_conteud := cNum1
msUnLock()

***************************
Static Function Pesq()
***************************
cChave := space(20)
cArq := space(1)
aArq := {}
AADD(aArq,"Codigo Produto")
AADD(aArq,"Data Entrega")
AADD(aArq,"Numero da OP")

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
