#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define _EOL chr(13)+chr(10)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �Consolidado� Autor �Gilberto A Oliveira � Data �  15/08/10   ���
��������������������������������������������������������������������������͹��
���Descricao � Relatorio da Base Consolidada Contabil.                     ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � T4F / Contabilidade                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function Impressao()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local lContinua := .t.
Local lExit:= .f.
Local cPerg   := "CONSOL"

If Select("rel1") > 0
	DbSelectArea("rel1")
	DbCloseArea()
Endif
    
If  lContinua 
    Processa({|| RunProcesso() },"Processsando arquivo...")
EndIf    

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNPROCESS� Autor � Gilberto           � Data �  16/08/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunProcesso()
   
Local _cArquivo, _cPNome, _cAlias
Local cQuery:= ''

Select SF4
_cArqTrb1:= CriaTrab(nil,.f.)
Copy To &(_cArqTrb1) next 5

If Select("trb1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif
dbUseArea( .T.,,_cArqTrb1, "TRB1", Nil, .F. )

DBGOTOP()

Select SF4
_cArqTrb:= CriaTrab(nil,.f.)
Copy To &(_cArqTrb) next 5

If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif
dbUseArea( .T.,,_cArqTrb, "TRB", Nil, .F. )

DBGOTOP()


Trb->( DbGotop() )

If Trb->( !Eof() )

	_cArquivo:= "C:\temp\arquivo1"
	_cArquivo1:= "C:\temp\arquivo2"
	_cPNome := "Arquivo1"
	_cPNome1:= "Arquivo2"
	_cAlias := "Trb"
	_cAlias1:= "Trb1"
   
   If File( _cArquivo+".xml" )
      Ferase( _cArquivo+".xml")
   EndIf 
   
	MsAguarde( { || u_DB2XML(_cArquivo, _cPNome , _cAlias,,,,"2018","dtoc(dDatabase)")},"Aguarde .. Gerando arquivo...")

	MsAguarde( { || u_DB2XML(_cArquivo1, _cPNome1, _cAlias1,,,,"2018","dtoc(dDatabase)")},"Aguarde .. Gerando arquivo...")


	ApMsgInfo("Arquivo :"+_cArquivo+".xml gerado. Verifique o disco local de sua m�quina"+chr(13)+"Aperte OK para continuar gerando o relat�rio...","Informa��o","INFO")

EndIF             


Trb->( DbCloseArea() )

Return(Nil)