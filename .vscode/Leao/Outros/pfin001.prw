#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/10/01

User Function PFIN001()        // Processa comissoes para ornamentos

aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira calcular o valor correto das comiss�es"
cDesc2   := ""
cDesc3   := ""
cPerg    := "RFIN05"
cString  := "SE3"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "PFIN001"
titulo   := "Relacao de Comissoes a Pagar"
wnrel    := "PFIN001"
limite   := 080
tamanho  := "P"

//��������������������������������������������������������������Ŀ
//� Perguntas :                                                  �
//� mv_par01  // Periodo de                                      �
//� mv_par02  // Periodo ate                                     �
//| mv_par03  // Vendedor de                                     �
//| mv_par04  // Vendedor ate                                    �
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

//��������������������������������������������������������������Ŀ
//� Cria array para gerar arquivo de trabalho                    �
//����������������������������������������������������������������
Cabec1 := "Vendedor                                              Valor Base  Valor Comissao"
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         0         1         2         3         4         5         6         7         8
Cabec2 := ""
titulo   := "Comissoes a Pagar "+dtoc(mv_par01)+"-"+dtoc(mv_par02)

Select SD2
cTemp := CriaTrab(nil,.f.)
copy stru to &cTemp
dbUseArea( .T.,,cTemp, "TRB", Nil, .F. )

Select SE3
SetRegua(recCount())
dbSetOrder(2)
set softseek on
Seek xFilial()+mv_par03 
set softseek off
li := 80
nTB := nTC := nBase := nCom := 0
Do while !eof() .and. se3->e3_vend<=mv_par04
   IncRegua()
   if se3->e3_emissao<mv_par01 .or. se3->e3_emissao>mv_par02
      skip 
      loop
   endif
   Select SC5
   dbSetOrder(1)
   Seek xFilial()+se3->e3_pedido   
   Do case
   Case sc5->c5_fator=="A"
     nFator := 2
   Case sc5->c5_fator=="B"
     nFator := 5
   Case sc5->c5_fator=="C"
     nFator := 1
   Endcase
   Select SD2
   dbSetOrder(8)
   Seek xFilial()+se3->e3_pedido   
   lOrc := .f.
   xDif := 0
   nTot := 0
   Do while !eof() .and. sd2->d2_pedido==se3->e3_pedido 
     if left(sd2->d2_cod,2)#"00"
        Skip
        loop
     Endif
     Select SB1
     dbSetOrder(1)
     seek xFilial()+'1'+substr(sd2->d2_cod,2,14)
     nIpi := sb1->b1_ipi
     nTot := (sd2->d2_total*nFator)/(1+(nIpi/nFator)/100)
     xDif := nTot - sd2->d2_total*nFator
     Select TRB
     if rlock()
       Appe blan
       trb->d2_cod   := sd2->d2_cod
       trb->d2_total := sd2->d2_total
       trb->d2_serie := se3->e3_serie
       trb->d2_doc   := sd2->d2_doc
       trb->d2_pedido:= sd2->d2_pedido
       trb->d2_tp    := sc5->c5_fator
       trb->d2_ipi   := nIpi
       trb->d2_custo1:= xDif
       trb->d2_custo2:= nTot
     Endif
     Select SD2
     Skip
   Enddo   
   Select SE3
   Skip
Enddo


IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

Select TRB
Use

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