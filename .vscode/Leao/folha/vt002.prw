#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/01
#INCLUDE "TOPCONN.CH"

User Function VT002()        // Exclui lanctos de VT da Folha de Pagto


@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Exclusao de Lanctos VT"
@ 8,10 TO 84,222
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa exclui os lancamentos do Vale Transporte pagos no Adiantamento."
ACTIVATE DIALOG oDlg5

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �OkProc    � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Confirma o Processamento                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

Static Function OkProc()
Close(oDlg5)
//Processa( {|| RunProc() } )
//Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RunProc   � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o Processamento                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
//Static Function RunProc()
      
Select SR1
go top
//ProcRegua(reccount())
Do while !eof()
//    IncProc()
    if rlock() .and. r1_pd=='127'
      Dele
    Endif
    Skip
Enddo
Return

Select SRC
go top
//ProcRegua(reccount())
Do while !eof()
//    IncProc()
    if rlock() .and. rc_pd=='127'
      Dele
    Endif
    Skip
Enddo
Return