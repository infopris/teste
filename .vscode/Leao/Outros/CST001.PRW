#include "rwmake.ch"  

User Function CST001()   // Formacao de precos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CST001    ³ Autor ³ Luiz Eduardo Tapajos  ³ Data ³ 14.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtra OPs para Programacao da producao                     ³±±
±±³Telas     ³oDlg  - Tela Inicial do sistema de movimentacao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa  ³Especifico Espelhos Leao  o@&L2004                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Fazer - Cadastrar grupos de MDO de Moldura
*/

cCod   := space(15)
cCodFim:= space(15)
cCombo := "Nao "
aItems := {"Standard","Custo Medio","Ult.Prc","Simulado"}
nValt  := 0
cCop   := cSeg := cSeg1 := "N"
@ 096,52 TO 343,505 DIALOG oDlg TITLE "Produto"
@ 001,010 TO 80,200
@ 12,015 say "Codigo "
@ 12,120 get cCod SIZE 050,20 Valid .T. F3 "SB1"
@ 24,015 say "Copiar custo Std para Simulado ? "
@ 24,120 get cCop picture "@!" SIZE 020,20 Valid cCop$"S*N"
@ 36,015 say "Deixe em branco para gerar todos os produtos"
@ 48,015 say "Espelho Comprado      ? "
@ 48,120 get cSeg  picture "@!" SIZE 020,20 Valid cSeg$"S*N"
@ 60,015 say "Moldura comprada      ? "
@ 60,120 get cSeg1 picture "@!" SIZE 020,20 Valid cSeg1$"S*N"
//@ 36,015 Say "Tipo custo:"
//@ 48,015 COMBOBOX cCombo ITEMS aItems SIZE 50,50
@ 90,160 BMPBUTTON TYPE 1 ACTION Calcula()
@ 90,190 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return

*************************
Static Function Calcula()
*************************
Select SG1
Seek xFilial()+cCod
if eof() .and. cCod # space(15)
  MsgBox ("Produto nao encontrado, favor verificar estrutura","Erro!!!","STOP")
  Return
endif

// Componentes (TRBA)
aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "NIV"     , "C",03,0}) 
AADD(aCampos,{ "DESC"    , "C",40,0}) 
AADD(aCampos,{ "COMP"    , "C",15,0}) 
AADD(aCampos,{ "UM"      , "C",02,0}) 
AADD(aCampos,{ "QTDE"    , "N",14,8}) 
AADD(aCampos,{ "PERDA"   , "N",06,2}) 
AADD(aCampos,{ "VALBASE" , "N",12,4}) 
AADD(aCampos,{ "PERC"    , "N",06,3}) 
AADD(aCampos,{ "CSTSTD"  , "N",12,4}) 
//AADD(aCampos,{ "CSTMED"  , "N",12,4}) 
AADD(aCampos,{ "SIMULA"  , "N",12,4}) 
//AADD(aCampos,{ "ULTPRC"  , "N",12,4}) 
//AADD(aCampos,{ "DTULT"   , "D",08,0}) 
AADD(aCampos,{ "IPI"     , "N",06,3}) 
AADD(aCampos,{ "ICMS"    , "N",06,3}) 
AADD(aCampos,{ "FATOR"   , "N",06,3}) 
AADD(aCampos,{ "PRC"     , "N",12,4}) 
AADD(aCampos,{ "SICMSIPI", "N",12,4}) 
AADD(aCampos,{ "SICMCIPI", "N",12,4}) 
AADD(aCampos,{ "CICMCIPI", "N",12,4}) 
AADD(aCampos,{ "NIVANT"  , "C",15,0}) 

cTempA := CriaTrab(nil,.f.)
dbCreate(cTempA,aCampos)
dbUseArea( .T.,,cTempA, "TRBA", Nil, .F. )
Index on Cod+Niv+NivAnt+Comp to &cTempA

aCampos := {}
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "DESC"    , "C",40,0}) 
AADD(aCampos,{ "VALSTD"  , "N",12,4}) 
AADD(aCampos,{ "VALCM"   , "N",12,4}) 
AADD(aCampos,{ "VALULT"  , "N",12,4}) 
AADD(aCampos,{ "VALSIM"  , "N",12,4}) 

cTempB := CriaTrab(nil,.f.)
dbCreate(cTempB,aCampos)
dbUseArea( .T.,,cTempB, "TRBB", Nil, .F. )
Index on Cod to &cTempB

Processa( {|| RunProc() } )

Select TRBB
use
Select TRBA
//appe from &cTempB
if left(cCodfim,3)=="ZZZ"
  copy to "\FORMPRC"
  MsgBox ("Arquivo gerado com sucesso \FormPrc.dbf","Informa‡Æo","INFO")
Endif
use
Return


************************
Static Function RunProc()  // Executa o processamento
*************************

if cCop=="S"
  if MsgBox ("Esta rotina ira sobrepor o custo simulado existente, confirma ?","Escolha","YESNO")
  Select SB1
  dbGoTop()
  ProcRegua(recCount())
  do while !eof()
	IncProc()
        if rlock()
		sb1->b1_custsim := sb1->b1_custd
	endif
	skip
  enddo
  Endif
endif

Select SG1
dbSetOrder(1)
go top
if cCod == space(15)
   cCod:="ZZZ"
else
   Seek xFilial()+cCod
endif
cCodFim := cCod
nCel := 1
nVal := 0
ProcRegua(recCount())
Do while !eof() .and. sg1->g1_Cod<=cCod
	IncProc()
	tValStd := tValCM := tValUlt := tValSim := 0
	cCod1 := sg1->g1_cod
	Do while !eof() .and. sg1->g1_cod==cCod1
		lProc := .f.
		nCel   := 1
		nFatDiv:= 1
		GrvTrbA()
		nValt :=nValt + nVal
		MsUnlock()
		Sele SG1
		nRecG1 := recno()
//		nFatDiv:= sg1->g1_quant
		cComp  := sg1->g1_comp
		Seek xFilial()+cComp
		if !eof() .and. cSeg=='N' .or. cSeg1=='N'
			nCel   := 2
			Select SG1
			Seek xFilial()+cComp
			lProc := .t.
			if left(cComp,2)=='19' .and. cSeg=="S" // Vidro Comprado
				lProc := .f.
			endif
			if left(cComp,2)=='12' .and. cSeg1=="S" //Mold.Comprada
				lProc := .f.
			endif
			Do while !eof() .and. sg1->g1_cod==cComp .and. lProc
				GrvTrbA()                               
				Select SG1
				Skip
			Enddo
		endif
		Select SG1
		goto nRecG1
	    Skip
	Enddo
	Select TRBA
	reclock("TRBA",.t.)
	trba->Cod   := cCod1
	trba->Niv   := "Tot"
	trba->Desc  := "TOTAL"
	trba->CstStd:= tValStd
//	trba->CstMed:= tValCM
//	trba->ultprc:= tValUlt
	trba->Simula:= tValSim

	Select TRBB
	reclock("TRBB",.t.)
 	trbb->Cod   := cCod1
 	trbb->Desc  := "Total"
	trbb->ValStd:= tValStd
	trbb->ValCM := tValCM
	trbb->ValUlt:= tValUlt
	trbb->ValSim:= tValSim
	msunlock()
	Select SG1
Enddo
Select TRBA
dbGoTop()
if cSeg == "N" .or. cSeg1== "N"            // Atualiza nivel superior
  do while !eof()
	aGrupo := {}
	cCod   := Cod
	Do while !eof() .and. Cod==cCod
		if nivant==space(15)
			skip
			loop
		endif
		nLinha := Ascan(aGrupo, {|x|x[1] == NivAnt})
		If nLinha != 0
			aGrupo[nLinha][2] := aGrupo[nLinha][2] + CstStd
		Else
			aAdd(aGrupo,{NivAnt,CstStd})
		Endif
		skip
	Enddo
	nRec := recno()
	For i:=1 to len(aGrupo)
		Seek cCod+"001"+space(15)+aGrupo[i][1]
		if rlock() .and. !eof()
			trba->ValBase:= aGrupo[i][2]
			trba->CstStd := aGrupo[i][2]*trba->Qtde*(1+perda/100)
		endif
	Next	
	goto nRec
  enddo   
endif
Select TRBA
dbGoTop()
Do while !eof()
	cCod   := Cod
	tValStd := tValCM := tValUlt := tValSim := 0
	Do while !eof() .and. Cod==cCod
		if val(Niv)==1
			tValStd := tValStd + cstStd
			tValSim := tValSim + Simula
		endif
		skip
		if upper(niv)=="TOT" .and. rlock()
			trba->cststd := tValStd
			trba->simula := tValSim
			exit
		endif
	Enddo
Enddo
Do while !eof()
   Select TRBB
   Seek trba->Cod
   Select TRBA
   if rlock() .and. trbb->valstd#0
//    trba->perc := trba->cststd/trbb->Valstd
   endif
   skip   
Enddo
dbGoTop()
if cCodFim#"ZZZ"
  Tela1()
else
  Close(oDlg)
endif

Return

*************************
Static Function GrvTrbA()
*************************
Select SB2
Seek xFilial()+sg1->g1_comp
Select SB1
Seek xFilial()+sg1->g1_cod
cGrupo := sb1->b1_grupo
Seek xFilial()+trim(sg1->g1_cod)+"."
nIpi := sb1->b1_IPI
Select SB1
Seek xFilial()+sg1->g1_comp
if nIPI<>0
	nCst := sb1->b1_custd
else
	nCst := sb1->b1_prv1
endif
nValStd := nCST*sg1->g1_quant*(1+sg1->g1_perda/100)*nFatDiv
nValCM  := sb2->b2_cm1*sg1->g1_quant*(1+sg1->g1_perda/100)*nFatDiv
nValUlt := sb1->b1_uprc*sg1->g1_quant*(1+sg1->g1_perda/100)*nFatDiv
dDtUltC := sb1->b1_ucom
nValSim := sb1->b1_custsim*sg1->g1_quant*(1+sg1->g1_perda/100)*nFatDiv
if nCel=1
	tValStd := tValStd + nValStd
	tValCM  := tValCM  + nValCM 
	tValUlt := tValUlt + nValUlt
	tValSim := tValSim + nValSim
endif
Select TRBA
reclock("TRBA",.t.)
nIcm := nCST*((sb1->b1_picm*sb1->b1_fator)/100)
nIpi := nCST*((sb1->b1_ipi *sb1->b1_fator)/100)
trba->SICMSIPI := nCST-nIcm        // Custo de Espelhos
trba->SICMCIPI := nCST+nIpi-nIcm   // Custo de Quadros e Outros prds
trba->CICMCIPI := nCST+nIpi        // Custo Nova Empresa
nVal := nCST
/*
do case
case val(sb1->b1_grupo)<=20
  nFat    := sb1->b1_picm*sb1->b1_fator
  nVal    := nCST*(1-nFat/100)
case val(sb1->b1_grupo)>20
  nFat    := (1-sb1->b1_picm*sb1->b1_fator/100)*(1-sb1->b1_ipi*sb1->b1_fator/100)
  nVal    := nCST*nFat
  nValSim := nValSim*nFat
Endcase*/
nQtd := nFatDiv*sg1->g1_quant*(1+sg1->g1_perda/100)
trba->Cod    := cCod1
trba->Niv    := strzero(nCel,3)
trba->Desc   := sb1->b1_desc
trba->Comp   := sg1->g1_comp
trba->Um     := sb1->b1_um
trba->Perda  := sg1->g1_perda
trba->Qtde   := sg1->g1_quant
trba->ValBase:= nVal
trba->CstStd := nVal*nQtd
//trba->CstMed := nValCM
//trba->ultprc := nValUlt
trba->Simula := nValSim*nQtd
//trba->dtult  := dDtUltC   
trba->ipi    := sb1->b1_ipi
trba->icms   := sb1->b1_picm
trba->fator  := sb1->b1_fator
trba->Prc    := nCST
if lProc 
  trba->NivAnt := sg1->g1_cod
endif
Return

*************************
Static Function Tela1()
*************************
return
aCampos := {}
*AADD(aCampos,{ "CEL"     ,"Cel"}) 
*AADD(aCampos,{ "NIV"     ,"Nivel"}) 
AADD(aCampos,{ "DESC"    ,"Descricao"}) 
AADD(aCampos,{ "COMP"    ,"Compon."}) 
AADD(aCampos,{ "UM"      ,"Um"}) 
AADD(aCampos,{ "QTDE"    ,"Qtde","@E 999.9999"}) 
AADD(aCampos,{ "PERDA"   ,"Perda","999"}) 
AADD(aCampos,{ "VALOR"   ,"Valor","@E 9,999.99"}) 
AADD(aCampos,{ "PERC"    ,"Perc","999.99"}) 

@ 010,1 TO 500,750 DIALOG oDlg2 TITLE "Formacao de Precos do produto "+cCod

@ 005,5 TO 180,360 BROWSE "TRBA" FIELDS aCampos
@ 200,10 say "Total : "
@ 200,25 say nValt picture "@E 999,999.99"

*@ 225,220 BUTTON "_Pesquisa"       SIZE 40,15 ACTION Pesq2()
*@ 225,265 BUTTON "_Exclui Pedido"  SIZE 40,15 ACTION Exclui2()
*@ 225,040 BUTTON "_Totaliza"       SIZE 40,15 ACTION TotPed()
*@ 225,085 BUTTON "_Faturar "       SIZE 40,15 ACTION FatPed()
*@ 225,130 BUTTON "_Inclui Pedido"  SIZE 40,15 ACTION IncPed()
*@ 225,175 BUTTON "_Altera Entrega" SIZE 40,15 ACTION AltEnt()
*@ 225,220 BUTTON "_Atualiza Saldo" SIZE 40,15 ACTION AtuSal()
*@ 225,265 BUTTON "_Pesquisa"       SIZE 40,15 ACTION Pesq()
@ 225,265 BUTTON "_Editar" SIZE 40,15 ACTION Close(Editar)
@ 225,310 BUTTON "_Sai" SIZE 40,15 ACTION Close(oDlg2)

ACTIVATE DIALOG oDlg2 CENTERED
Return

**************************
Static Function Editar()
**************************
Select TRBA
Return

**************************
Static Function CalcTudo()
**************************
Select TRBA
Return

