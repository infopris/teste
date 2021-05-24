#include "rwmake.ch"        

User Function RFOL001()        // Rela�ao de Cesta B�sica

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio Cesta B�sica no M�s"
cDesc2   := ""
cDesc3   := ""
cPerg    := "FOL001"
cString  := "SRC"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFOL001"
titulo   := "Relacao de Cest Basica no Mes"
wnrel    := "RFOL001"
limite   := 80
tamanho  := "P"

//��������������������������������������������������������������Ŀ
//� Perguntas :                                                  �
//� mv_par01  // Periodo de                                      �
//� mv_par02  // Periodo ate                                     �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Verifica as Perguntas selecionadas.                          �
//����������������������������������������������������������������
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


//��������������������������������������������������������������Ŀ
//� Impressao do Relatorio com os Itens do Pedido.               �
//����������������������������������������������������������������
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()

Return Nil

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � C030Imp  � Autor � Luiz Eduardo          � Data � 10/12/2002 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Relatorio                                       ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � C030Imp                                                      ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Especifico p/ Espelhos Leao                                  ���
���������������������������������������������������������������������������Ĵ��
��� Atualizacoes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> Function C030Imp
Static Function C030Imp()                  

titulo   := "Relacao Cesta Basica "+strzero(month(mv_par01),2)+"/"+str(year(mv_par01),4)
Cabec1 := "Num  Matr.  Nome                             Assinatura"
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7
Cabec2 := ""

Select SRC
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
  if src->rc_pd#"432"
    Skip
    Loop
  Endif
  Select SRA
  dbSetOrder(1)
  Seek xFilial()+src->rc_mat
  Select SRC
  nNum := nNum + 1
  @ li,000 PSAY nNum picture "999"
  @ li,005 PSAY src->rc_mat
  @ li,012 PSAY sra->ra_nome
  @ li,045 PSAY Replicate("_",30)
  li := li + 1
  Skip
Enddo

IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//��������������������������������������������������������������Ŀ
//� Carrega Spool de Impressao.                                  �
//����������������������������������������������������������������
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
