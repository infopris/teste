#include "rwmake.ch"        

User Function RFOL003()        // Rela‡ao Resumida de pagtos

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
aOrdem   := {"Por Matricula","Por Centro de Custos"}  
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Resumo da Folha de Pagto"
cDesc2   := ""
cDesc3   := ""
cPerg    := "FOLR03"
cString  := "SRC"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFOL003"
titulo   := "Resumo da Folha"
wnrel    := "RFOL003"
limite   := 220
tamanho  := "G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Matric. de                                      ³
//³ mv_par02  // Matric. ate                                     ³
//³ mv_par03  // Sint/Analit                                     ³
//³ mv_par04  // Sit.a Imprimir                                  ³
//³ mv_par05  // Proventos a listar                              ³
//³ mv_par06  // Desctos a Listar                                ³
//³ mv_par07  // Total liquido                                   ³
//³ mv_par08  // Data de                                         ³
//³ mv_par09  // Data ate                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,Nil,Tamanho)

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
aCampos := {}
AADD(aCampos,{ "MAT"     , "C",06,0}) 
AADD(aCampos,{ "CC"      , "C",09,0}) 
AADD(aCampos,{ "DESCCC"  , "C",15,0}) 
AADD(aCampos,{ "NOME"    , "C",30,0}) 
AADD(aCampos,{ "PROV01"  , "N",12,2}) 
AADD(aCampos,{ "PROV02"  , "N",12,2}) 
AADD(aCampos,{ "PROV03"  , "N",12,2}) 
AADD(aCampos,{ "PROV04"  , "N",12,2}) 
AADD(aCampos,{ "PROV05"  , "N",12,2}) 
AADD(aCampos,{ "PROV06"  , "N",12,2}) 
AADD(aCampos,{ "PROV07"  , "N",12,2}) 
AADD(aCampos,{ "PROV08"  , "N",12,2}) 
AADD(aCampos,{ "PROV09"  , "N",12,2}) 
AADD(aCampos,{ "PROV10"  , "N",12,2}) 
AADD(aCampos,{ "PROVTOT" , "N",12,2}) 
AADD(aCampos,{ "DESC01"  , "N",12,2}) 
AADD(aCampos,{ "DESC02"  , "N",12,2}) 
AADD(aCampos,{ "DESC03"  , "N",12,2}) 
AADD(aCampos,{ "DESC04"  , "N",12,2}) 
AADD(aCampos,{ "DESC05"  , "N",12,2}) 
AADD(aCampos,{ "DESC06"  , "N",12,2}) 
AADD(aCampos,{ "DESC07"  , "N",12,2}) 
AADD(aCampos,{ "DESC08"  , "N",12,2}) 
AADD(aCampos,{ "DESC09"  , "N",12,2}) 
AADD(aCampos,{ "DESC10"  , "N",12,2}) 
AADD(aCampos,{ "DESCTOT" , "N",12,2}) 

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on Mat to &cTemp

cDataINI := left(dtos(MV_PAR08),6)
cDataFIM := left(dtos(MV_PAR09),6)
Select SX6
Seek xFilial()+"MV_FOLMES"
if cDataINI<trim(X6_CONTEUD)
  	Processa( {|| GravaSRD() } )
else
	Processa( {|| GravaSRC() } )
Endif

RptStatus( { ||Imprime()})
MS_FLUSH()

Select TRb
use

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Imprime  ³ Autor ³ Luiz Eduardo          ³ Data ³ 22/02/2008 ³±±
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

Static Function Imprime()                  

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Define a ordem de impress„o ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nOrdem := aReturn [8]
Do Case
   Case nOrdem == 1
EndCase

Select SRV
dbSetOrder(1)
cVerbas := ""
cDesc   := cDesc1   := cDesc2 := ""
s := 0
For n:=1 to 9
	cVerbas := cVerbas + substr(mv_par05,s+1,3)+space(5)
	Seek xFilial()+substr(mv_par05,s+1,3)
	cDesc := cDesc + left(srv->rv_desc,8)
	cDesc1:= cDesc1+ substr(srv->rv_desc,1,7)+" "
	cDesc2:= cDesc2+ substr(srv->rv_desc,8,7)+" "
	s:=s+3
Next N            
cVerbas := cVerbas + space(16)
cDesc   := cDesc + "Outros  Tot.Prov"
cDesc1  := cDesc1+ "                "
cDesc2  := cDesc2+ "Outros  Tot.Prov"
s:=0
For n:=1 to 9
	cVerbas := cVerbas + substr(mv_par06,s+1,3)+space(5)
	Seek xFilial()+substr(mv_par06,s+1,3)
	cDesc := cDesc + left(srv->rv_desc,8)
	cDesc1:= cDesc1+ substr(srv->rv_desc,1,7)+" "
	cDesc2:= cDesc2+ substr(srv->rv_desc,8,7)+" "
	s:=s+3
Next N
cDesc   := cDesc + "Outros  Tot.Desc Val.Liq"
cDesc1  := cDesc1+ "                "
cDesc2  := cDesc2+ "Outros  Tot.Desc Val.Liq""

titulo   := "Resumo de Pagtos Folha "+dtoc(mv_par08)+" ate "+dtoc(mv_par09)
Cabec1 := "Funcionario "+space(29)+cVerbas
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7
Cabec2 := space(38)+cDesc

Cabec1 := "Funcionario "+space(26)+cDesc1
Cabec2 := space(38)+cDesc2

Select TRB
dbSetOrder(1)
SetRegua(reccount())
go top
nNum := 0
li := 80
Do while !eof()
  IncRegua()
  If li > 60
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
  Endif
  @ li,000 PSAY MAT+"-"+Nome
  @ li,038 PSAY PROV01 picture "@E 99,999"
  @ li,046 PSAY PROV02 picture "@E 99,999"
  @ li,054 PSAY PROV03 picture "@E 99,999"
  @ li,062 PSAY PROV04 picture "@E 99,999"
  @ li,070 PSAY PROV05 picture "@E 99,999"
  @ li,078 PSAY PROV06 picture "@E 99,999"
  @ li,086 PSAY PROV07 picture "@E 99,999"
  @ li,094 PSAY PROV08 picture "@E 99,999"
  @ li,102 PSAY PROV09 picture "@E 99,999"
  @ li,110 PSAY PROV10 picture "@E 99,999"
  @ li,118 PSAY PROVTOT picture "@E 99,999"
  @ li,126 PSAY DESC01 picture "@E 99,999"
  @ li,134 PSAY DESC02 picture "@E 99,999"
  @ li,142 PSAY DESC03 picture "@E 99,999"
  @ li,150 PSAY DESC04 picture "@E 99,999"
  @ li,158 PSAY DESC05 picture "@E 99,999"
  @ li,166 PSAY DESC06 picture "@E 99,999"
  @ li,174 PSAY DESC07 picture "@E 99,999"
  @ li,182 PSAY DESC08 picture "@E 99,999"
  @ li,190 PSAY DESC09 picture "@E 99,999"
  @ li,198 PSAY DESC10 picture "@E 99,999"
  @ li,206 PSAY DESCTOT picture "@E 99,999"
  @ li,214 PSAY PROVTOT-DESCTOT picture "@E 99,999"

  li := li + 1
  Skip
Enddo

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

**************************
Static Function GravaSRD()
**************************
Select SRD
ProcRegua(reccount())
dbSetOrder(1)
Set SoftSeek On
Seek xFilial()+mv_par01
Set SoftSeek Off
Do while !eof() .and. rd_MAT<=mv_par02
	IncProc()
	if rd_datarq<cDataIni .or. rd_datarq>cDataFim
		skip
		loop
	endif
	Select SRA
	Seek xFilial()+srd->rd_mat
	Select SI3
	Seek xFilial()+sra->ra_cc
	Select SRV
	Seek xFilial()+srd->rd_pd
	Select TRB
	Seek srd->rd_mat
	RecLock("TRB",eof())
	trb->Mat	:= srd->rd_mat
	trb->cc		:= srd->rd_cc
	trb->Desccc	:= si3->i3_desc
	trb->Nome  	:= sra->ra_nome
	if srv->rv_tipocod == "1"
		if at(srd->rd_pd,MV_PAR05)<>0 .and. at(srd->rd_pd,MV_PAR05)<10
			n := (at(srd->rd_pd,MV_PAR05)+2)/3
			cVerb := "trb->Prov"+strzero(n,2)
			&cVerb := &cVerb + SRD->RD_VALOR
		Else
			trb->Prov10 := trb->Prov10 + SRD->RD_VALOR
		Endif
		trb->ProvTot += SRD->RD_VALOR
	endif
	if srv->rv_tipocod == "2"
		if at(srd->rd_pd,MV_PAR06)<>0 .and. at(srd->rd_pd,MV_PAR06)<10
			n := (at(srd->rd_pd,MV_PAR06)+2)/3
			cVerb := "trb->desc"+strzero(n,2)
			&cVerb := &cVerb + SRD->RD_VALOR
		Else
			trb->desc10 := trb->desc10 + SRD->RD_VALOR
		Endif
		trb->descTot += SRD->RD_VALOR
	endif
	MsUnlock()
	Select SRD
	skip
Enddo


**************************
Static Function GravaSRC()
**************************
Select SRC
ProcRegua(reccount())
dbSetOrder(1)
Set SoftSeek On
Seek xFilial()+mv_par01
Set SoftSeek Off
Do while !eof() .and. rc_MAT<=mv_par02
	IncProc()
	Select SRA
	Seek xFilial()+SRC->rc_mat
	Select SI3
	Seek xFilial()+sra->ra_cc
	Select SRV
	Seek xFilial()+SRC->rc_pd
	Select TRB
	Seek SRC->rc_mat
	RecLock("TRB",eof())
	trb->Mat	:= SRC->rc_mat 
	trb->cc		:= SRC->rc_cc
	trb->Desccc	:= si3->i3_desc
	trb->Nome  	:= sra->ra_nome
	if srv->rv_tipocod == "1"
		if at(SRC->rc_pd,"MV_PAR05")<>0 .and. at(SRC->rc_pd,"MV_PAR05")<10
			n := (at(SRC->rc_pd,"MV_PAR05")+2)/3
			cVerb := "trb->Prov"+strzero(n,2)
			&cVerb := &cVerb + SRC->rc_VALOR
		Else
			trb->Prov10 := trb->Prov10 + SRC->rc_VALOR
		Endif
		trb->ProvTot += SRC->rc_VALOR
	endif
	if srv->rv_tipocod == "2"
		if at(SRC->rc_pd,"MV_PAR06")<>0 .and. at(SRC->rc_pd,"MV_PAR06")<10
			n := (at(SRC->rc_pd,"MV_PAR06")+2)/3
			cVerb := "trb->desc"+strzero(n,2)
			&cVerb := &cVerb + SRC->rc_VALOR
		Else
			trb->desc10 := trb->desc10 + SRC->rc_VALOR
		Endif
		trb->descTot += SRC->rc_VALOR
	endif
	MsUnlock()
	Select SRC
	skip
Enddo

