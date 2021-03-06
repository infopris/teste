#include "rwmake.ch" 

User Function RFAT017()        // Faturamento por Vendedor

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Faturam por Vendedor"
cDesc2   := ""
cDesc3   := ""
cPerg    := "RFT001"
cString  := "SD2"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFAT017"
titulo   := "Faturamento por Representante"
wnrel    := "RFAT017"
limite   := 132
tamanho  := "M"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Perguntas :                                                  �
//� mv_par01  // Periodo de                                      �
//� mv_par02  // Periodo ate                                     �
//| mv_par03  // Vendedor de                                     �
//| mv_par04  // Vendedor ate                                    �
//| mv_par05  // Regiao de         		     		 �
//| mv_par06  // Regiao Ate                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as Perguntas selecionadas.                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Impressao do Relatorio com os Itens do Pedido.               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})
Processa( {|| C030Imp() } )

MS_FLUSH()

Return Nil

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴컴엽�
굇쿑un뇚o    � C030Imp  � Autor � Luiz Eduardo          � Data � 10/12/2002 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴컴눙�
굇쿏escri뇚o � Impressao do Relatorio                                       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � C030Imp                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico p/ Espelhos Leao                                  낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Atualizacoes sofridas desde a Construcao Inicial.                       낢�
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Programador  � Data   � BOPS �  Motivo da Alteracao                     낢�
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�              �        �      �                                          낢�
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> Function C030Imp
Static Function C030Imp()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria array para gerar arquivo de trabalho                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aCampos := {}
AADD(aCampos,{ "NUM"     , "C",06,0}) 
AADD(aCampos,{ "ITEM"    , "C",02,0}) 
AADD(aCampos,{ "CODCLI"  , "C",08,0}) 
AADD(aCampos,{ "COD"     , "C",15,0}) 
AADD(aCampos,{ "DESC"    , "C",30,0}) 
AADD(aCampos,{ "CLI"     , "C",30,0}) 
AADD(aCampos,{ "CGC"     , "C",15,0}) 
AADD(aCampos,{ "UF"      , "C",02,0}) 
AADD(aCampos,{ "VEND"    , "C",06,0}) 
AADD(aCampos,{ "QTDE"    , "N",12,2}) 
AADD(aCampos,{ "VALNF"   , "N",12,2}) 
AADD(aCampos,{ "DATAFAT" , "D",08,0}) 
AADD(aCampos,{ "OK"      , "C",02,0}) 
cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Select SD2
dbSetOrder(5)
set softseek on
Seek xFilial()+dtos(mv_par01)
set softseek off
cTrb1 := Criatrab(nil,.f.)
Copy to &cTrb1 next 1000000 for d2_emissao<=mv_par02 .and. d2_tipo=="N"
dbUseArea( .T.,, cTrb1,"TRB1", .F., .F. )
ProcRegua(reccount())
go top
Do while !eof()
  IncProc()
  select SC5
  dbSetOrder(1)
  Seek xFilial()+trb1->d2_pedido
  select Sf4
  dbSetOrder(1)
  Seek xFilial()+trb1->d2_tes
  select SA1
  dbSetOrder(1)
  seek xFilial()+trb1->d2_cliente+trb1->d2_loja
  Select TRB1
  if trb1->d2_emissao<mv_par01 .or. trb1->d2_emissao>mv_par02
    Skip
    loop
  Endif
  if sc5->c5_vend1<mv_par03 .or. sc5->c5_vend1>mv_par04
    Skip
    loop
  Endif
  if sf4->f4_duplic=='N'
    Skip
    loop
  Endif
  if (sa1->a1_regiao<mv_par05 .or. sa1->a1_regiao>mv_par06) .and. !empty(sa1->a1_regiao)
    Skip
    loop
  Endif
//Select SD2
//dbSetOrder(3)
//Seek xFilial()+trb1->d2_doc
//do while !eof() .and. trb1->d2_doc==sd2->d2_doc
     if left(TRB1->d2_cod,2)=="00" .and. substr(TRB1->d2_cod,3,1)#"."
       cCodProd := "1"+substr(TRB1->d2_cod,2,14)
     else
       cCodProd := TRB1->d2_cod
     endif
     Select SB1
     dbSetOrder(1)
     Seek xFilial()+cCodProd
     Select TRB
     reclock("trb",.t.)
     //  Appe blan
       trb->num    := trb1->d2_doc
       trb->item   := TRB1->d2_item
       trb->cod    := left(cCodProd,4)
       trb->desc   := sb1->b1_desc
       trb->codcli := trb1->(d2_cliente+d2_loja)
       trb->cgc    := sa1->a1_cgc
       trb->cli    := sa1->a1_nome
       trb->uf     := sa1->a1_est
       trb->vend   := sc5->c5_vend1
       trb->qtde   := TRB1->d2_quant
       trb->valnf  := TRB1->d2_total
       trb->datafat:= TRB1->d2_emissao
     MsUnLock()
//     endif
//   Select SD2
//   Skip
//enddo
  Select TRB1
  Skip
Enddo
RptStatus({|| Imprime() })
//Imprime()
Select TRB
Use
Select TRB1
Use
Select SC5
Return

Static function Imprime()

Cabec1 := "CNPJ                Cod.Cli. Razao Social                   UF         Emissao    N.F.  Valor Faturado"
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec2 := ""
Select TRB
index on vend+num to &cTemp
dbGotop()
SetRegua(recCount())
li := 80
nTot := 0
Do while !eof()
   IncRegua()                                      
   Select SA3
   Seek xFilial()+trb->Vend
   Select TRB
   titulo   := "Faturamento do Representante "+Vend+" "+sa3->a3_nreduz
   If li > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif
   cVend := Vend
   Do while !eof() .and. Vend==cVend
   If li > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif
   cCgc    := trb->CGC
   cCodCli := trb->CodCli
   cCli    := trb->Cli
   cUF     := trb->Uf
   dDataFat:= trb->DataFat
   cNum    := trb->Num
   nVal    := 0
   do while !eof() .and. trb->Num == cNum
      nVal  := nVal  + Valnf
      Skip
   Enddo
   If len(AllTrim(cCgc))==11
  	cPictCGC:="@R 999.999.999-99"
   Else
	cPictCGC:="@R 99.999.999/9999-99"
   EndIf
   @ li,000 PSAY cCGC picture cPictCGC 
   @ li,020 PSAY cCodCli+"-"+cCli+" "+cUF
   @ li,070 PSAY dDataFat
   @ li,082 PSAY cNum
   @ li,092 PSAY nVal picture "@E 99,999,999.99"
   nTot := nTot + nVal
   li:=li+1
   Enddo
Enddo
@ li,000 PSAY "------------------------"
li:=li+1
@ li,000 PSAY "Valor Faturado no Periodo"
@ li,092 PSAY nTot picture "@E 99,999,999.99"


IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Carrega Spool de Impressao.                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
