#INCLUDE 'PROTHEUS.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} MTA416PV
Ponto de Entrada antes da efetivação do Orçamento, para incluir os
campos customizados no Pedido de Venda.

@author Bruno Lazarini Garcia
@since 24/05/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function MTA416PV()  

local nPosUNS   := aScan(_aHeader,{|x| AllTrim(x[2])=='C6_UNSVEN'})  
Local aAreaSCK	:= SCK->(GetArea())
Local aArea		:= GetArea()                    
Local nUsado    := Len(_aHeader)+1 
Local xNItem    := Alltrim(Str(Len(_aCols)))
Local cNumSCJ   := SCJ->CJ_NUM 
Local xN	    := 0                                        

//Aba Cadastrais
M->C5_XOBSESP	:= SCJ->CJ_XOBSESP

//Aba Transportadora
M->C5_TRANSP	:= SCJ->CJ_TRANSP
//M->C5_XNTRANS := SCJ->CJ_TELTRANS
//M->C5_XDDDTRA	:= SCJ->CJ_DDDTRAN
//M->C5_XTELTRAN:= SCJ->CJ_TELTRANS
M->C5_XNUMCOL	:= SCJ->CJ_XNUMCOL

//Aba Outros
M->C5_PEDCLI	:= SCJ->CJ_PEDCLI
M->C5_XOC		:= SCJ->CJ_XOC
          
xNItem := PadL( Alltrim(xNItem), TamSx3("C6_ITEM")[1],"0")

DbSelectArea('SCK')
DbSetOrder(1)
If DbSeek(xFilial('SCK')+SCJ->CJ_NUM+xNItem)

	//While !SCK->(EOF()) .And. SCK->CK_NUM == cNumSCJ
	
		//xN += xN++
	
		//If _aCols[xN][nUsado] == .F. // Se a linha estiver deletada, não faz verificação
			_aCols[Len(_aCols)][nPosUNS] := SCK->CK_UNSVEN		
		//Endif
	
	 //	SCK->(DbSkip())
	                                
	//EndDo

Endif

RestArea(aArea)   
RestArea(aAreaSCK)  

Return( Nil )   