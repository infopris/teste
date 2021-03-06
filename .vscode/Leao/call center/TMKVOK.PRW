#include "RwMake.ch"

User Function Tmkvok()

Local _xAlias   := GetArea()
/*/
Local _nPosCFOP := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_CF" })
For _xLin :=1 to Len(aCols)
	
	IF SA1->A1_EST != "SP"
		
		aCols[_xLin,_nPosCFOP] := "6" + Substr(aCols[_xLin,_nPosCFOP],2,Len(aCols[_xLin,_nPosCFOP]) )
	Else
		
		aCols[_xLin,_nPosCFOP] := "5" + Substr(aCols[_xLin,_nPosCFOP],2,Len(aCols[_xLin,_nPosCFOP]) )
		
	EndIF
	
Next
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� * Armazena data original da emissao do pedido para atualiza- �
//� cao atraves do ponto de entrata TMKVFIM.                     �
//� * Quando o TMK altera um pedido ele atualiza o campo da data �
//� de emissao do pedido, esta situacao e contraria ao FAT que   �
//� nao atualiza o campo da emissao do pedido na alteracao.      �
//� * A condicao abaixo esta sendo utilizada para padronizar o   �
//� TMK conforme o FAT, segundo definicao da Espelhos Leao.      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
DbSelectArea("SC5")
DbSetOrder(1)
IF DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Estas variavel publica foi declarada no TMKCLI e sera utilizada no TMKVFIM �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_dDataEmis := SC5->C5_EMISSAO
Else
	_dDataEmis := ""
EndIF

// Inclu�do dia 06/09 - Luiz Eduardo para gerar automaticamente a agenda do tmkt
if !empty(sua->ua_dtcont)
	Select SA1
	dbSetOrder(1)
	seek xFilial()+sua->(UA_CLIENTE+UA_LOJA)
	Select SZ5
	dbSetOrder(1)
	Seek "  "+dtos(sua->UA_DTCONT)+sua->(UA_OPERADO+UA_NUM)
	if eof()
		RecLock("SZ5",.t.)
		SZ5->Z5_OPERADO  := SUA->UA_OPERADO
		SZ5->Z5_NUMTMK 	 := SUA->UA_NUM
		SZ5->Z5_CLIENTE	 := sua->UA_CLIENTE
		SZ5->Z5_Loja	 := sua->UA_LOJA
		SZ5->Z5_CONTATO  := SUA->UA_DTCONT
		MsUnLock()
	Endif
endif
/*
Select SZ5
dbSetOrder(2)
Seek "  "+sua->(UA_CLIENTE+UA_LOJA)+dtos(dDataBase)
if !eof() .and. SUA->UA_DTCONT>=dDataBase
	RecLock("SZ5",.F.)
	DtRet->Efetivado := "S"
	MsUnLock()
endif
*/
RestArea(_xAlias)

Return
