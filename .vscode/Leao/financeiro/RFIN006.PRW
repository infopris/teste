#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function RFIN006()        // Relacao de Comissoes Oficial

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Comissoes "
cDesc2   := ""
cDesc3   := ""
cPerg    := "RFIN05"
cString  := "SE3"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFIN006"
titulo   := "Relacao de Comissoes a Pagar (Vendedor)"
wnrel    := "RFIN006"
limite   := 132
tamanho  := "M"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Perguntas :                                                  �
//� mv_par01  // Periodo de                                      �
//� mv_par02  // Periodo ate                                     �
//| mv_par03  // Vendedor de                                     �
//| mv_par04  // Vendedor ate                                    �
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
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

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
Cabec1 := "Documento     Cod.Cli    Nome Cliente                       Dt.Comis.   Pedido    Base Comis.  %Com.     Valor Comiss. UF"
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         0         1         2         3         4         5         6         7         8
Cabec2 := ""
titulo   := "Comissoes a Pagar "+dtoc(mv_par01)+"-"+dtoc(mv_par02)

Select SE3
dbSetOrder(2)
set softseek on
Seek xFilial()+mv_par03 
set softseek off
SetRegua(recCount())
li := 80
nTB := nTC := nBase := nCom := 0
Do while !eof() .and. se3->e3_vend<=mv_par04
   IncRegua()
   if se3->e3_emissao<mv_par01 .or. se3->e3_emissao>mv_par02
      skip 
      loop
   endif
   nBase := nCom := 0
   nVend := se3->e3_vend
   lIni := .t.
   Select SA3
   dbSetOrder(1)
   Seek xFilial()+nVend
   Select SE3
   Do while !eof() .and. se3->e3_vend==nVend
    IncRegua()
    If li > 58
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
        lIni := .t.
    Endif
    if se3->e3_emissao<mv_par01 .or. se3->e3_emissao>mv_par02 .or. e3_baiemi#"B"
      skip 
      loop
     endif
     if se3->e3_serie=="001"
      skip 
      loop
     endif
     if lIni
        @ li,000 PSAY nVend+"-"+sa3->a3_Nome
        li := li + 1
        lIni := .f.
     endif
     Select SA1
     dbSetOrder(1)
     Seek xFilial()+se3->e3_codcli+se3->e3_loja
     Select SE3
     @ li,000 PSAY se3->e3_serie+" "+se3->e3_num+" "+se3->e3_parcela+"  "+se3->e3_codcli+" "+se3->e3_loja
     @ li,025 PSAY left(sa1->a1_nome,33)
     @ li,060 PSAY se3->e3_emissao
     @ li,072 PSAY se3->e3_pedido
     @ li,080 PSAY se3->e3_base picture "@E 99,999,999.99"
     @ li,095 PSAY se3->e3_porc picture "@E 99.99"
     @ li,102 PSAY se3->e3_comis picture "@E 99,999,999.99"
     @ li,120 PSAY sa1->a1_est
     nBase := nBase + se3->e3_base
     nCom  := nCom  + se3->e3_comis
     li := li + 1
     Skip
   Enddo
   If li > 58
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
   Endif
   Select SE3
   @ li,000 PSAY "Total do Vendedor "+nVend+"-"+sa3->a3_Nome
   @ li,080 PSAY nBase picture "@E 99,999,999.99"
   @ li,102 PSAY nCom  picture "@E 99,999,999.99"
   nTB := nTB + nBase
   nTC := nTC + nCom
   li:=li+2
// Skip
Enddo
li:=li+1
@ li,020 PSAY "Total Geral : "
@ li,080 PSAY nTB picture "@E 99,999,999.99"
@ li,102 PSAY nTC picture "@E 99,999,999.99"


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
