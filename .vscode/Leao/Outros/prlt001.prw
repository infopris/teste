#include "Rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �PRLT001   � Autor �Airton Lira            � Data �15/05/2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Tela para Entrada da Data Programada de Entrega no Pedido   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PRLT001()

Private cString
Private cCadastro := "Manuten��o datas de Programas"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             	     {"Datas" ,"U_Data",0,5} } 

mBrowse( 6, 1,22,75,"SC5",,"C5_CLIENTE")

Return
