#include "Rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � TMKCLI   � Autor �   Alexandro Dias      � Data �25.08.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava setor de vendas.                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TLVENT(oTpMidia, cTpMidia, aTpMidia, aCodMidia, ;
oTipMar, cTipMar, aTipMar, ;
oVend, cVend, ;
oTipOpe, cTipOpe, ; 
oCampaV, cCampaV, aCampaV, aCodCampaV, ;
oLigacao, cLigacao, aLigacao, aCodLiga, ;
cDesc, oDesc, cContato,oContato, cCodCont,lFim)

Local _xAlias   := GetArea()
Local _aSetor   := {"C=Setor C","B=Setor B","A=Setor A","S=Setor S"}
Local _aTpFrete := {"C=CIF","F=FOB"}
Local _aRepres  := {"S=Sim","N=Nao"}
Local _aPagto   := {"A=Tab1-A Vista","B=Tab2-14DD","C=Tab3-30DD","D=Tab4-45DD","E=Tab5-60DD","F=Tab6-75DD","G=Tab7-90DD"}
Local _aCalcPrc := {"N=Nao","S=Sim"}

//������������������������������������������������������Ŀ
//� Estas variaveis publicas seram utilizadas no TMKVFIM �
//��������������������������������������������������������

Select SC5
dbSetOrder(1)
Seek xFilial()+sua->ua_numsc5

Public _cCalcPrc  := ""
Public _cRepres   := ""
Public _cPagto    := ""
Public _cSetor    := sc5->c5_fator
Public _cTpFrete  := sc5->c5_TPFRETE
Public _cNumPed   := sc5->c5_PEDCLI
Public _dDataEmis := DATE()
Public _cCli      := sa1->(A1_Cod+A1_Loja)

Return   // Para nao executar mesmo

//IF !lFim
	
	@ 000,000 TO 240,250 DIALOG oDlg TITLE "Dados Complementares."
	
	@ 015,005 SAY "Setor:"      SIZE 30,10
	@ 015,055 COMBOBOX _cSetor ITEMS _aSetor SIZE 50,20
	
	@ 030,005 SAY "Tipo Frete:" SIZE 30,10
	@ 030,055 COMBOBOX _cTpFrete ITEMS _aTpFrete SIZE 50,20
	
	@ 045,005 SAY "Pedido Cliente:" SIZE 50,10
	@ 045,055 Get _cNumPed Picture "@!" SIZE 50,20

	@ 060,005 SAY "Calcula Preco ?" SIZE 50,10
	@ 060,055 COMBOBOX _cCalcPrc ITEMS _aCalcPrc  SIZE 50,20

//	@ 075,005 SAY "Representante :" SIZE 50,10
//	@ 075,055 COMBOBOX _cRepres ITEMS _aRepres  SIZE 50,20

	@ 075,005 SAY "Pedido Cliente:" SIZE 50,10
	@ 075,055 COMBOBOX _cPagto  ITEMS _aPagto   SIZE 50,20
 
	@ 090,080 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	
	ACTIVATE DIALOG oDlg CENTER
//EndIF

//��������������������������������Ŀ
//� Inicializa combo do operador   �
//����������������������������������
DbSelectArea("SU7")
DbSetOrder(3)
If DbSeek(xFilial("SU7") + Alltrim(Substr(cUsuario,7,15)))
	cOperador:=U7_NOME
//	oOperador:Refresh()
EndIf

//���������������������������Ŀ
//� Inicializa combo de midia �
//�����������������������������
dbSelectArea("SUH")
dbSetOrder(1)
If dbSeek(xFilial("SUH") + "000001" )
	cTpMidia := UH_DESC
//	oTpMidia:Refresh()
EndIf

//�������������������������������Ŀ
//� Inicializa combo de marketing �
//���������������������������������
cTipMar := "ATIVO"
//oTipMar:Refresh()

//����������������������������������Ŀ
//� Posiciona cadastro de vendedores �
//������������������������������������
dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3") + SA1->A1_VEND)
	//������������������������������Ŀ
	//� Inicializa campo de vendedor �
	//��������������������������������
	cVend := A3_COD
//	oVend:Refresh()
Else
	//������������������������������Ŀ
	//� Inicializa campo de vendedor �
	//��������������������������������
	cVend := Space(06)
//	oVend:Refresh()
EndIf

//������������������������������Ŀ
//� Inicializa combo de operacao �
//��������������������������������
cTipOpe := "FATURAMENTO"
//oTipOpe:Refresh()

//��������������������������������Ŀ
//� Inicializa combo de ocorrencia �
//����������������������������������
//dbSelectArea("SU9")
//dbSetOrder(2)
//If dbSeek(xFilial("SU9") + GetMV("MV_OCOPAD"))
//    cLigacao := U9_DESC
//    oLigacao:Refresh()
//EndIf

//������������������������Ŀ
//� Devolve estado inicial �
//��������������������������

//m->UA_TPFRETE := _aTpFrete

RestArea(_xAlias)

Return()
                   