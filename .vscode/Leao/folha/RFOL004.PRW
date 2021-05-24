#include "rwmake.ch"        

User Function RFOL004()        // Rela‡ao Resumida de pagtos

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
aOrdem   := {"Por Matricula","Por Centro de Custos"}  
cbtxt    := Space(10)
cbcont   := 0
cDesc	 := ""
cDesc1   := "Este programa ira emitir o Resumo da Folha de Pagto"
cDesc2   := ""
cDesc3   := ""
cPerg    := "FOL004"
cString  := "SRC"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFOL004"
titulo   := "Resumo da Folha"
wnrel    := "RFOL004"
limite   := 132
tamanho  := "M"
limite   := 220
tamanho  := "G"
//cProv00  := "101*129*119*115*841*779*713"
//cdesc00  := "401*417*503*413*432*410*445*446"


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
AADD(aCampos,{ "SALBASE" , "N",12,2}) 
AADD(aCampos,{ "CC"      , "C",09,0}) 
AADD(aCampos,{ "FUNCAO"  , "C",15,0}) 
AADD(aCampos,{ "DESCCC"  , "C",15,0}) 
AADD(aCampos,{ "NOME"    , "C",30,0}) 
AADD(aCampos,{ "VT"      , "N",12,2}) 
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
AADD(aCampos,{ "DESC51"  , "N",12,2}) 
AADD(aCampos,{ "DESC52"  , "N",12,2}) 
AADD(aCampos,{ "DESC53"  , "N",12,2}) 
AADD(aCampos,{ "DESC54"  , "N",12,2}) 
AADD(aCampos,{ "DESC55"  , "N",12,2}) 
AADD(aCampos,{ "DESC56"  , "N",12,2}) 
AADD(aCampos,{ "DESC57"  , "N",12,2}) 
AADD(aCampos,{ "DESC58"  , "N",12,2}) 
AADD(aCampos,{ "DESC59"  , "N",12,2}) 
AADD(aCampos,{ "DESC60"  , "N",12,2}) 
AADD(aCampos,{ "DESC61"  , "N",12,2}) 
AADD(aCampos,{ "DESCTOT" , "N",12,2}) 
AADD(aCampos,{ "VALLIQ"  , "N",12,2}) 

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on cc+Mat to &cTemp

//cDataINI := left(dtos(MV_PAR08),6)
//cDataFIM := left(dtos(MV_PAR09),6)

aCampos := {}
AADD(aCampos,{ "PER"     , "C",06,0}) 
AADD(aCampos,{ "TIPO"    , "C",20,0}) 
AADD(aCampos,{ "EMP"     , "C",09,0}) 
AADD(aCampos,{ "VALOR"   , "N",12,2}) 

cTempx := CriaTrab(nil,.f.)
dbCreate(cTempx,aCampos)
dbUseArea( .T.,,cTempx,"TRBX", Nil, .F. )
Index on Tipo to &cTempx

nTemp := 0
if sm0->m0_codigo=="03" // Leao filial
	Select SRA
	dbGoTop()
	Do while !eof()
		if ra_sitfolh=="A"
			nTemp++
		endif
		skip
	Enddo
endif

Select SX6
Seek xFilial()+"MV_FOLMES"

//if cDataINI<trim(X6_CONTEUD)
//  	Processa( {|| GravaSRD() } )
//else
	Processa( {|| GravaSRC() } )
//Endif

RptStatus( { ||Imprime()})
MS_FLUSH()

Select TRb              
go top
GravaRes()
Select TRb              
if sm0->m0_codigo='01'
copy to \gerencia\resum01
else
copy to \gerencia\resum02
endif
use                         

Select SX6
Seek xFilial()+"MV_FOLMES"

Select TRBx
if sm0->m0_codigo='01'
copy to ('\gerencia\fol1'+substr(sx6->x6_conteud,3,4))
else
copy to ('\gerencia\fol2'+substr(sx6->x6_conteud,3,4))
endif
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
cDesc   := ""
cDesc1  := "SALARIO "
cDesc2  := " BASE   "
s := 0
//For n:=1 to 9
//	cVerbas := trim(cVerbas) + substr(mv_par05,s+1,3) //+space(5)
//	Seek xFilial()+substr(cProv00,s+1,3)
//	if substr(cProv00,s+1,3)>="001"
//	cDesc := cDesc + left(srv->rv_desc,8)
//	cDesc1:= cDesc1+ substr(srv->rv_desc,1,7)+" "
// 	cDesc2:= cDesc2+ substr(srv->rv_desc,8,7)+" "
//	Endif
//	s:=s+3
//Next N            
//cVerbas := cVerbas + space(16)
//cDesc   := cDesc + space(65-len(cDesc)) + "Outros  Tot.Prov"
//cDesc1  := cDesc1+ "                "
//cDesc2  := cDesc2+ space(65-len(cDesc2)) + "Outros  Tot.Prov"
  
Select SX5
Seek xFilial()+"ZX"
Do while x5_tabela=="ZX"
	cDesc += left(sx5->x5_descri,8)
	Skip
Enddo
titulo   := "Resumo de Pagtos Folha "  //+dtoc(mv_par08)+" ate "+dtoc(mv_par09)
Cabec1 := "Funcionario " +space(29)+cVerbas
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7
Cabec2 := space(38)+cDesc

Cabec1 := space(64)+"PROVENTOS   "+space(45)+"DESCONTOS"//+space(21)+cDesc1  
Cabec2 := "Funcionario "+space(34)+"Sal.Ref.VT Empr."+cDesc+" Val.Liq"
nTotP01 := nTotP02 := nTotP03 := nTotP04 := nTotP05 := nTotP06 := nTotP07 := nTotP08 := nTotP09 := nTotP10 := 0
nTotD01 := nTotD02 := nTotD03 := nTotD04 := nTotD05 := nTotD06 := nTotD07 := nTotD08 := nTotD09 := nTotD10 := nTotD11 := 00
nTotP   := nTotD   := 0
nTotSal := nTotVT  := 0
Select TRB
dbSetOrder(1)
SetRegua(reccount())
go top
li := 80
If li > 60
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
Endif     

Do while !eof()
  IncRegua()
  cCC := CC
  @ li,000 PSAY CC+"-"+DescCC
  li := li + 1
  nSTotP01:= nSTotP02:= nSTotP03:= nSTotP04:= nSTotP05:= nSTotP06:= nSTotP07:= nSTotP08:= nSTotP09:= nSTotP10 := 0
  nSTotD01:= nSTotD02:= nSTotD03:= nSTotD04:= nSTotD05:= nSTotD06:= nSTotD07:= nSTotD08:= nSTotD09:= nSTotD10:= nSTotD11:= 00
  nSTotP  := nSTotD  := nSTotSal:= nSTotVT := 0
  Do while !eof() .and. CC==cCC
  If li > 62
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
  Endif  
  @ li,000 PSAY left(MAT,4)+"-"+left(Nome,25)
  @ li,032 PSAY FUNCAO  
  @ li,048 PSAY SALBASE picture "@E 99,999"
  @ li,056 PSAY VT      picture "@E 99,999"
  @ li,064 PSAY PROV01  picture "@E 99,999"
  @ li,072 PSAY PROV02  picture "@E 99,999"
  @ li,080 PSAY PROV03  picture "@E 99,999"
  @ li,088 PSAY PROV04  picture "@E 99,999"
  @ li,096 PSAY PROV05  picture "@E 99,999"
  @ li,104 PSAY PROV06  picture "@E 99,999"
  @ li,112 PSAY PROV10  picture "@E 99,999"

//  @ li,104 PSAY PROV07  picture "@E 99,999"
//  @ li,112 PSAY PROV08  picture "@E 99,999"
//  @ li,128 PSAY PROVTOT picture "@E 999,999"
// Descontos
  @ li,120 PSAY DESC51  picture "@E 99,999"
  @ li,128 PSAY DESC52  picture "@E 99,999"
  @ li,136 PSAY DESC53  picture "@E 99,999"
  @ li,144 PSAY DESC54  picture "@E 99,999"
  @ li,152 PSAY DESC55  picture "@E 99,999"
  @ li,160 PSAY DESC56  picture "@E 99,999"
  @ li,168 PSAY DESC57  picture "@E 99,999"
  @ li,176 PSAY DESC58  picture "@E 99,999"
  @ li,184 PSAY DESC59  picture "@E 99,999"
  @ li,192 PSAY DESC60  picture "@E 99,999"
  @ li,200 PSAY DESC61  picture "@E 99,999"
//  @ li,218 PSAY DESCTOT picture "@E 999,999"
  @ li,208 PSAY VALLIQ  picture "@E 999,999"
  nSTotP01 += Prov01
  nSTotP02 += Prov02
  nSTotP03 += Prov03
  nSTotP04 += Prov04
  nSTotP05 += Prov05
  nSTotP06 += Prov06
  nSTotP07 += Prov07
  nSTotP08 += Prov08
  nSTotP09 += Prov09
  nSTotP10 += Prov10
  nSTotD01 += Desc51
  nSTotD02 += Desc52
  nSTotD03 += Desc53
  nSTotD04 += Desc54
  nSTotD05 += Desc55
  nSTotD06 += Desc56
  nSTotD07 += Desc57
  nSTotD08 += Desc58
  nSTotD09 += Desc59
  nSTotD10 += Desc60
  nSTotD11 += Desc61
  nSTotD   += valliq 
  nSTotSal += SalBase
  nSTotVT  += VT

  nTotP01 += Prov01
  nTotP02 += Prov02
  nTotP03 += Prov03
  nTotP04 += Prov04
  nTotP05 += Prov05
  nTotP06 += Prov06
  nTotP07 += Prov07
  nTotP08 += Prov08
  nTotP09 += Prov09
  nTotP10 += Prov10
  nTotP   += PROVTOT
  nTotD01 += Desc51
  nTotD02 += Desc52
  nTotD03 += Desc53
  nTotD04 += Desc54
  nTotD05 += Desc55
  nTotD06 += Desc56
  nTotD07 += Desc57
  nTotD08 += Desc58
  nTotD09 += Desc59
  nTotD10 += Desc60
  nTotD11 += Desc61
  nTotD   += valliq 
  nTotSal += salbase
  nTotVT  += vt
  li := li + 1
  Skip
  enddo
  li := li + 1
  @ li,000 psay Replicate("-",220)
   li := li + 1
  @ li,048 PSAY nSTotSAL  picture "@E 99,999"
  @ li,056 PSAY nSTotVT   picture "@E 99,999"
  @ li,064 PSAY nSTotP01  picture "@E 99,999"
  @ li,072 PSAY nSTotP02  picture "@E 99,999"
  @ li,080 PSAY nSTotP03  picture "@E 99,999"
  @ li,088 PSAY nSTotP04  picture "@E 99,999"
  @ li,096 PSAY nSTotP05  picture "@E 99,999"
  @ li,104 PSAY nSTotP06  picture "@E 99,999"
//  @ li,104 PSAY nTotP07  picture "@E 99,999"
//  @ li,112 PSAY nTotP08  picture "@E 99,999"
  @ li,112 PSAY nSTotP10  picture "@E 99,999"
  @ li,120 PSAY nSTotD01  picture "@E 99,999"
  @ li,128 PSAY nSTotD02  picture "@E 99,999"
  @ li,136 PSAY nSTotD03  picture "@E 99,999"
  @ li,144 PSAY nSTotD04  picture "@E 99,999"
  @ li,152 PSAY nSTotD05  picture "@E 99,999"
  @ li,160 PSAY nSTotD06  picture "@E 99,999"
  @ li,168 PSAY nSTotD07  picture "@E 99,999"
  @ li,176 PSAY nSTotD08  picture "@E 99,999"
  @ li,184 PSAY nSTotD09  picture "@E 99,999"
  @ li,192 PSAY nSTotD10  picture "@E 99,999"
  @ li,200 PSAY nSTotD11  picture "@E 99,999"
  @ li,208 PSAY nSTotD    picture "@E 999,999"
   li := li + 1
Enddo
  @ li,000 psay Replicate("=",220)
   li := li + 1
  @ li,048 PSAY nTotSAL  picture "@E 99,999"
  @ li,056 PSAY nTotVT   picture "@E 99,999"
  @ li,064 PSAY nTotP01  picture "@E 99,999"
  @ li,072 PSAY nTotP02  picture "@E 99,999"
  @ li,080 PSAY nTotP03  picture "@E 99,999"
  @ li,088 PSAY nTotP04  picture "@E 99,999"
  @ li,096 PSAY nTotP05  picture "@E 99,999"
  @ li,104 PSAY nTotP06  picture "@E 99,999"
//  @ li,104 PSAY nTotP07  picture "@E 99,999"
//  @ li,112 PSAY nTotP08  picture "@E 99,999"
  @ li,112 PSAY nTotP10  picture "@E 99,999"
  @ li,120 PSAY nTotD01  picture "@E 99,999"
  @ li,128 PSAY nTotD02  picture "@E 99,999"
  @ li,136 PSAY nTotD03  picture "@E 99,999"
  @ li,144 PSAY nTotD04  picture "@E 99,999"
  @ li,152 PSAY nTotD05  picture "@E 99,999"
  @ li,160 PSAY nTotD06  picture "@E 99,999"
  @ li,168 PSAY nTotD07  picture "@E 99,999"
  @ li,176 PSAY nTotD08  picture "@E 99,999"
  @ li,184 PSAY nTotD09  picture "@E 99,999"
  @ li,192 PSAY nTotD10  picture "@E 99,999"
  @ li,200 PSAY nTotD11  picture "@E 99,999"
  @ li,208 PSAY nTotD    picture "@E 999,999"

/*
Select SRV
dbSetOrder(1)
cVerbas := ""
cDesc   := cDesc1   := cDesc2 := ""
cDesc   := "        "
cDesc1  := "SALARIO "
cDesc2  := " BASE   "
s := 0
For n:=1 to 9
	cVerbas := cVerbas + substr(cDesc00,s+1,3)+space(5)
	Seek xFilial()+substr(cDesc00,s+1,3)
	if substr(cDesc00,s+1,3)>="001"
		cDesc := cDesc + left(srv->rv_desc,8)
		cDesc1:= cDesc1+ substr(srv->rv_desc,1,7)+" "
		cDesc2:= cDesc2+ substr(srv->rv_desc,8,7)+" "
    Endif
	s:=s+3
Next N
cDesc   := cDesc + space(65-len(cDesc)) + "Outros  Tot.Desc"
cDesc1  := cDesc1+ "                "
cDesc2  := cDesc2+ space(65-len(cDesc2)) + "Outros  Tot.Desc"

Cabec1 := "DESCONTOS   "+space(21)+cDesc1
Cabec2 := "Funcionario "+space(21)+cDesc2

Select TRB
go top
li := 80
If li > 60
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
Endif
Do while !eof()
  IncRegua()
  cCC := CC
  @ li,000 PSAY CC+"-"+DescCC
  li := li + 1
  Do while !eof() .and. CC==cCC
  If li > 62
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
  Endif
  @ li,000 PSAY MAT+"-"+left(Nome,25)
  @ li,032 PSAY SALBASE picture "@E 99,999"

  @ li,040 PSAY DESC01  picture "@E 99,999"
  @ li,048 PSAY DESC02  picture "@E 99,999"
  @ li,056 PSAY DESC03  picture "@E 99,999"
  @ li,064 PSAY DESC04  picture "@E 99,999"
  @ li,072 PSAY DESC05  picture "@E 99,999"
  @ li,080 PSAY DESC06  picture "@E 99,999"
  @ li,088 PSAY DESC07  picture "@E 99,999"
  @ li,096 PSAY DESC08  picture "@E 99,999"
  @ li,104 PSAY DESC10  picture "@E 99,999"
  @ li,112 PSAY DESCTOT picture "@E 999,999"
  @ li,120 PSAY FUNCAO  
  nTotD01 += Desc01
  nTotD02 += Desc02
  nTotD03 += Desc03
  nTotD04 += Desc04
  nTotD05 += Desc05
  nTotD06 += Desc06
  nTotD07 += Desc07
  nTotD08 += Desc08
  nTotD09 += Desc09
  nTotD10 += Desc10
  nTotD   += DESCTOT
  li := li + 1
  Skip
  Enddo
  li := li + 1

Enddo
  @ li,000 psay Replicate("-",132)
  li := li + 1
  @ li,040 PSAY nTotD01  picture "@E 99,999"
  @ li,048 PSAY nTotD02  picture "@E 99,999"
  @ li,056 PSAY nTotD03  picture "@E 99,999"
  @ li,064 PSAY nTotD04  picture "@E 99,999"
  @ li,072 PSAY nTotD05  picture "@E 99,999"
  @ li,080 PSAY nTotD06  picture "@E 99,999"
  @ li,088 PSAY nTotD07  picture "@E 99,999"
  @ li,096 PSAY nTotD08  picture "@E 99,999"
  @ li,104 PSAY nTotD10  picture "@E 99,999"
  @ li,112 PSAY nTotD    picture "@E 99,999"
*/
  li := li + 1
  @ li,002 PSAY "Total de Temporarios : "+TRANSFORM(nTemp,"@E 999")

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
	Select SRJ
	Seek xFilial()+SRA->ra_codfunc
	Select SI3
	Seek xFilial()+sra->ra_cc
	Select SRV
	Seek xFilial()+srd->rd_pd
	Select TRB
	Seek srd->rd_cc+srd->rd_mat
	RecLock("TRB",eof())
	trb->Mat	:= srd->rd_mat
	trb->SalBase	:= sra->ra_salario
	trb->cc		:= srd->rd_cc
	trb->Desccc	:= si3->i3_desc
	trb->Funcao	:= srj->rj_desc
	trb->Nome  	:= sra->ra_nome
	if srv->rv_tipocod == "1"
		if at(srd->rd_pd,cProv00)<>0 .and. at(srd->rd_pd,cProv00)<10
			n := (at(srd->rd_pd,cProv00)+2)/3
			cVerb := "trb->Prov"+strzero(n,2)
			&cVerb := &cVerb + SRD->RD_VALOR
		Else
			trb->Prov10 := trb->Prov10 + SRD->RD_VALOR
		Endif
		trb->ProvTot += SRD->RD_VALOR
	endif
	if srv->rv_tipocod == "2"
		if at(srd->rd_pd,cDesc00)<>0 .and. at(srd->rd_pd,cDesc00)<10
			n := (at(srd->rd_pd,cDesc00)+2)/3
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
nHExtra := nSal := 0
Do while !eof() .and. rc_MAT<=mv_par02
	IncProc()
	Select SRA
	Seek xFilial()+SRC->rc_mat
	if ra_demissa>=date()-90
		Select SRC
		skip
		loop
	endif
	Select SRJ
	Seek xFilial()+SRA->ra_codfunc
	Select SI3
	Seek xFilial()+sra->ra_cc
	Select SRV
	Seek xFilial()+SRC->rc_pd
	Select TRB
	Seek SRC->rc_cc+SRC->rc_mat
	RecLock("TRB",eof())
	trb->Mat	:= SRC->rc_mat 
	trb->SalBase:= sra->ra_salario
	trb->cc		:= SRC->rc_cc
	trb->Desccc	:= si3->i3_desc
	trb->Funcao	:= srj->rj_desc
	trb->Nome  	:= sra->ra_nome   
	if srv->rv_tipocod == "1" //.or. srv->rv_tipocod == "3" 
//		if at(SRC->rc_pd,cProv00)<>0 .and. at(SRC->rc_pd,cProv00)<21
		if srv->rv_grp>="01" .and. srv->rv_grp<"07"
			cVerb := "trb->Prov"+srv->rv_grp
			replace &cVerb with &cVerb + SRC->rc_VALOR
		Else
			trb->Prov10 := trb->Prov10 + SRC->rc_VALOR
		Endif
		if srv->rv_tipocod == "1"
			trb->ProvTot += SRC->rc_VALOR
		endif
	endif
	if srv->rv_tipocod == "2"
//		if at(SRC->rc_pd,cDesc00)<>0 .and. at(SRC->rc_pd,cDesc00)<21
		if srv->rv_grp>="50" .and. srv->rv_grp<="60"
			//n := (at(SRC->rc_pd,cDesc00)+2)/3
			cVerb := "trb->Desc"+srv->rv_grp
			replace &cVerb with &cVerb + SRC->rc_VALOR
		Else
			trb->desc61 := trb->desc61 + SRC->rc_VALOR
		Endif
		trb->descTot += SRC->rc_VALOR
	endif
	if src->rc_pd == "713"   // Valor Liq.
		trb->valliq := src->rc_valor
	endif
	if src->rc_pd == "779"   // Valte Transporte
		trb->vt := src->rc_valor
	endif
	if sm0->m0_codigo#'01'
		if src->rc_pd$'841*116*119*206'
			nSal += src->rc_valor
		endif
		if src->rc_pd$'190*413*445*447'
			nSal -= src->rc_valor
		endif
	endif
	MsUnlock()
	if src->rc_pd$'206*116*119'
		nHExtra += src->rc_valor
	endif
	Select SRC
	skip
Enddo
Select SRA
dbGoTop()
nSal1 := 0
Do while !eof()       
	if ra_sitfolh='D' .or. ra_catfunc='P'
		skip
		loop
	endif
	nSal1 += ra_salario
	skip
enddo

Select SRZ
dbGoTop()
nInss := nFGTS := 0
Do while !eof()
	if rz_filial='zz' .and. left(rz_cc,2)='zz'
		if srz->rz_pd$'841*116*119*206'
			nSal += srz->rz_val
		endif
		if srz->rz_pd$'190*413*445*447'
			nSal -= srz->rz_val
		endif
		if srz->rz_pd$'747*748*749' .and. sm0->m0_codigo='01'
			nInss += srz->rz_val
		endif
		if srz->rz_pd$'115' .and. sm0->m0_codigo='01'
			nInss -= srz->rz_val
		endif
		if srz->rz_pd$'708'
			nFGTS := srz->rz_val
		endif
	endif
	skip
enddo

//Luiz
Select SX6
seek xFilial()+'MV_FOLMES'
Select TRBx
if rlock()
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'Salario'
	trbx->Emp	:= sm0->m0_codigo
	trbx->Valor	:= nSal
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'Extras'
	trbx->Emp	:= sm0->m0_codigo
	trbx->Valor	:= nHExtra
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'Provisao Ferias'
	trbx->Emp	:= sm0->m0_codigo
	trbx->Valor	:= (nSal1/12)+(nSal1/12)/3
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'Provisao 13o'
	trbx->Emp	:= sm0->m0_codigo
	trbx->Valor	:= (nSal1/12)
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'Enc.Provisao'
	trbx->Emp	:= sm0->m0_codigo
	nEncProv := 0
	if sm0->m0_codigo='01'
		nEncProv := ((nSal/12)+(nSal/12)+(nSal/12)/3)*.20
		trbx->Valor	:= ((nSal/12)+(nSal/12)+(nSal/12)/3)*.20
	endif
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'INSS'
	trbx->Emp	:= sm0->m0_codigo
	trbx->Valor	:= nInss
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'FGTS'
	trbx->Emp	:= sm0->m0_codigo
	trbx->Valor	:= nFgts
	appe blan
	trbx->Per	:= sx6->x6_conteud
	trbx->Tipo	:= 'X-TOTAL'
	trbx->Emp	:= sm0->m0_codigo
	trbx->Valor	:= nSal+nINSS+nFGTS+(nSal1/12)+(nSal1/12)+(nSal1/12)/3+nEncProv
Endif

**************************
Static Function GravaRes()
**************************
Select TRB
copy to x.txt sdf
aCampos := {}
AADD(aCampos,{ "MAT"     , "C",06,0}) 
AADD(aCampos,{ "SALBASE" , "C",12,2}) 
AADD(aCampos,{ "CC"      , "C",09,0}) 
AADD(aCampos,{ "FUNCAO"  , "C",15,0}) 
AADD(aCampos,{ "DESCCC"  , "C",15,0}) 
AADD(aCampos,{ "NOME"    , "C",30,0}) 
AADD(aCampos,{ "VT"      , "C",12,0}) 
AADD(aCampos,{ "PROV01"  , "C",12,0}) 
AADD(aCampos,{ "PROV02"  , "C",12,0}) 
AADD(aCampos,{ "PROV03"  , "C",12,0}) 
AADD(aCampos,{ "PROV04"  , "C",12,0}) 
AADD(aCampos,{ "PROV05"  , "C",12,0}) 
AADD(aCampos,{ "PROV06"  , "C",12,0}) 
AADD(aCampos,{ "PROV07"  , "C",12,0}) 
AADD(aCampos,{ "PROV08"  , "C",12,0}) 
AADD(aCampos,{ "PROV09"  , "C",12,0}) 
AADD(aCampos,{ "PROV10"  , "C",12,0}) 
AADD(aCampos,{ "PROVTOT" , "C",12,0}) 
AADD(aCampos,{ "DESC51"  , "C",12,0}) 
AADD(aCampos,{ "DESC52"  , "C",12,0}) 
AADD(aCampos,{ "DESC53"  , "C",12,0}) 
AADD(aCampos,{ "DESC54"  , "C",12,0}) 
AADD(aCampos,{ "DESC55"  , "C",12,0}) 
AADD(aCampos,{ "DESC56"  , "C",12,0}) 
AADD(aCampos,{ "DESC57"  , "C",12,0}) 
AADD(aCampos,{ "DESC58"  , "C",12,0}) 
AADD(aCampos,{ "DESC59"  , "C",12,0}) 
AADD(aCampos,{ "DESC60"  , "C",12,0}) 
AADD(aCampos,{ "DESC61"  , "C",12,0}) 
AADD(aCampos,{ "DESCTOT" , "C",12,0}) 
AADD(aCampos,{ "VALLIQ"  , "C",12,0}) 

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB1", Nil, .F. )
if rlock()
	appe blan
endif
cVar:= "trb1->PROV"              
n	:= 1
m	:= 1
cDesc := space(8)+cDesc
Do while .t.
	cDesc := substr(cDesc,9,200)
	cDesc1 := left(cDesc,8)
	if rlock() .and. n<=8
		cVar1  := cVar+strzero(n,2)       
		&cVar1 := cDesc1
		n++
	endif                                     
	if rlock() .and. n>8 .and. trim(cDesc1)<>''
		cVar1:= "trb1->DESC"+strzero(50+m,2)
		&cVar1 := cDesc1
		m++
	endif
	if trim(cDesc)=''
		exit
	endif
enddo

appe from x.txt sdf
if sm0->m0_codigo='01'
copy to \gerencia\res01
else
copy to \gerencia\res02
endif
use
