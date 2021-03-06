#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RFINR02  � Autor � Osmil Squarcine       � Data � 05/03/10 ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao que grava campos adicionais na impressao do bolet   ���
���          � bancario do contas a receber                               ���
�������������������������������������������������������������������������͹��
���Uso       � Microsiga                                                  ���
�������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

User Function GrvDadBol( cPrefixo , cNumero , cParcela , cTipo , cCliente , cLoja , cBanco , cAgencia , cConta , cCarteira )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local aArea    := GetArea()
Local aAreaSE1 := SE1->( GetArea() )
Local lOk      := .T.
Local aNossNum := {}
                  
/*����������������������������������������������������������������������������Ŀ
  �         Verifica se a Rotina recebeu todos os parametros necessarios       �
  ������������������������������������������������������������������������������*/

If cPrefixo == Nil .Or. ;
   cNumero  == Nil .Or. ;
   cParcela == Nil .Or. ;
   cTipo    == Nil .Or. ;
   cCliente == Nil .Or. ;
   cLoja    == Nil .Or. ;
   cBanco   == Nil .Or. ;
   cAgencia == Nil .Or. ;
   cConta   == Nil .Or. ;
   cCarteira== Nil
                   
   Aviso( "Aten��o - Problema na Rotina GrvDadBol" , "Alguns parametros nao foram passados de forma adequada para a rotina que grava o Nosso N�mero do Boleto Banc�rio !" , {"Ok"} , 1 , "Problema na Impress�o" )
   lOk := .F.

Endif

/*����������������������������������������������������������������������������Ŀ
  �                           Gera o Nosso Numero                              �
  ������������������������������������������������������������������������������*/

aNossNum  := u_GerNosNum( cBanco , cAgencia , cConta , cCarteira )

/*����������������������������������������������������������������������������Ŀ
  �    Posicao 1 do Array - Gerou o Nosso Numero (.T. ) ou Nao Gerou (.F.)     �
  �    Posicao 2 do Array - Nosso Numero                                       �
  ������������������������������������������������������������������������������*/

lOk     := aNossNum[1]
cNumBco := aNossNum[2]

 /*����������������������������������������������������������������������������Ŀ
   �                  Caso esteja tudo Ok grava o Nosso Numero                  �
   ������������������������������������������������������������������������������*/

If lOk

 /*����������������������������������������������������������������������������Ŀ
   �                     Abre a Tabela do Contas a Receber                      �
   ������������������������������������������������������������������������������*/

   DbSelectArea("SE1")
   DbSetOrder(1)

 /*����������������������������������������������������������������������������Ŀ
   �                       Posiciona no Titulo a Receber                        �
   ������������������������������������������������������������������������������*/

   If !DbSeek ( xFilial ("SE1") + cPrefixo + cNumero + cParcela + cTipo + cCliente + cLoja )
      Aviso( "Aten��o !" , "O Titulo a Receber " + " " + cPrefixo + " " + cNumero + " " + cParcela + " " + cTipo + " n�o foi encontrado ! O Nosso n�mero n�o poder� ser gravado ! " , {"Ok"} , 1 , "Titulo n�o Encontrado !" )
      lOk := .F.
   Endif

 /*����������������������������������������������������������������������������Ŀ
   �                       Posiciona no Titulo a Receber                        �
   ������������������������������������������������������������������������������*/
   
   If cBanco == "033"
   		cNumBco  := Right('000000000000' + AllTrim(Left(cNumBco,12)),12)    
   		cDvNsNum := Modulo11A(cNumBco, cBanco)
   		If ValType(cDvNsNum) == "N"
   			cDvNsNum := AllTrim(Str(cDvNsNum))
   		EndIf
   		cNumBco  := cNumBco + AllTrim(cDvNsNum)
   EndIf                            
   
   If DbSeek ( xFilial ("SE1") + cPrefixo + cNumero + cParcela + cTipo + cCliente + cLoja )
      RecLock("SE1" , .F. )
      SE1->E1_NUMBCO  := cNumBco
      MsUnlock()
   Else
      Aviso( "Aten��o !" , "O Titulo a Receber " + " " + cPrefixo + " " + cNumero + " " + cParcela + " " + cTipo + " n�o foi encontrado ! O Nosso n�mero n�o poder� ser gravado ! " , {"Ok"} , 1 , "Titulo n�o Encontrado !" )
      lOk := .F.
   Endif


/*����������������������������������������������������������������������������Ŀ
  �                       Restaura as Areas Utilizadas                         �
  �����������������������������������������������������������������������������*/

   RestArea(aAreaSE1)
   RestArea(aArea)

Endif  

Return ( { lOk , cNumBco } ) 

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �GeraNossoNum� Autor � Osmil Squarcine    � Data � 05/03/2010  ���
���������������������������������������������������������������������������͹��
���Descricao � Funcao que gera o Nosso N�mero de Acordo com o Banco         ���
���������������������������������������������������������������������������͹��
���Parametros� Banco , Agencia e Conta Corrente                             ���
���������������������������������������������������������������������������͹��
���Retorno   � lGerou    - .T. Gerou o Nosso Numero Correto .F. - Nao Gerou ���
���          � cNossoNum - Nosso Numero Gerado                              ���
���������������������������������������������������������������������������͹��
���Uso       � Microsiga                                                    ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/

User Function GerNosNum( cBco , cAge , cCC , cCarteira )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Locais Utilizadas na Rotina              �
  ������������������������������������������������������������������������������*/

Local aArea     := GetArea()
Local aAreaSEE  := SEE->( GetArea() )
Local lGerou    := .T.
Local cNossoNum := ""
Local cListBco  := SuperGetMV("MV_LISTBCO",,"001/033")

/*����������������������������������������������������������������������������Ŀ
  �         Verifica se a Rotina recebeu todos os parametros necessarios       �
  ������������������������������������������������������������������������������*/

If cBco == Nil .Or. ;
   cAge == Nil .Or. ;
   cCC  == Nil

   Aviso( "Aten��o ! Problema na Rotina GerNosNum" , "Alguns parametros nao foram passados de forma adequada para a rotina que gera o Nosso N�mero do Boleto Banc�rio ! Este boleto n�o ser� impresso !" , {"Ok"} , 1 , "Calculo do Nosso N�mero" )
   lGerou := .F.
   Return ( { lGerou , cNossoNum } )

Endif

/*����������������������������������������������������������������������������Ŀ
  �                    Abre o Arquivo de Parametros Bancos Cnab                �
  ������������������������������������������������������������������������������*/

DbSelectArea("SEE")
DbSetOrder(1)

/*����������������������������������������������������������������������������Ŀ
  �              Posiciona no Arquivo de Parametros Bancos Cnab                �
  ������������������������������������������������������������������������������*/

If DbSeek ( xFilial("SEE") + cBco + cAge + cCC + cCarteira)
   
/*����������������������������������������������������������������������������Ŀ
  �                                                                            �
  �                             Banco do Brasil                                �
  � Nosso Numero com Registro : Sequencial de 10 digitos                       �
  �                                                                            �
  ������������������������������������������������������������������������������*/
 
/*����������������������������������������������������������������������������Ŀ
  �                  Calcula o Nosso Numero para o Real                        �
  ������������������������������������������������������������������������������*/

   If cBco $ cListBco   // C�DIGO DO BCO
      cNossoNum := Soma1 ( StrZero( Val( SEE->EE_FAXATU ) , 10 ) )
      RecLock( "SEE" , .F. )
      SEE->EE_FAXATU := SubStr(cNossoNum, 1, 10)
      MsUnlock()
   Endif
     
/*����������������������������������������������������������������������������Ŀ
  �                       Atualiza o Ultimo Numero Gerado                      �
  ������������������������������������������������������������������������������*/

Else
   Aviso( "Aten��o ! Problema na Rotina GerNosNum" , "N�o existem parametros de bancos Cnab (SEE) cadastrados para a o Banco : " + Alltrim(cBco) + " Agencia : " + Alltrim(cAge) + " e Conta : " + Alltrim(cCC) + " . Cadastre os Parametros de Bancos para que o Nosso N�mero possa ser gerado !" , {"Ok"} , 1 , "Calculo do Nosso N�mero" )
   lGerou := .F.
Endif

/*����������������������������������������������������������������������������Ŀ
  �                  Restaura as Areas Anteriores a Rotina                     �
  ������������������������������������������������������������������������������*/

RestArea(aAreaSEE)
RestArea(aArea)

Return ( { lGerou , cNossoNum } ) 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � Modulo11A� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo Modulo 11  										  ���
���          � especifico para Nosso Numero do Banco do Brasil            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Modulo11A(cData, cBanco)
LOCAL nResto, L, D, P := 0       
DEFAULT cBanco:= ""

L := Len(cData)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

If cBanco == "033"
	nResto := mod(D,11)
	//D := D - (nResto * 11)
Else
	D := 11 - (mod(D,11))
EndIf
                                       
If cBanco == "033"
	If (nResto >= 0 .And. nResto <= 1)
		D := 0
	ElseIf (nResto == 10)
		D := 1
	Else
		D := 11 - nResto
	End
Else
	If (D == 10)
		D := "X"
	ElseIf (D == 11)
		D := 0
	End
EndIf
Return(D)