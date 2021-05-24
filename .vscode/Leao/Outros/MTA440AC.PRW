#include "rwmake.ch"

/*/
Ponto de entrada na liberação dos pedidos de vendas

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA440AC º Autor ³   Luiz Eduardo     º Data ³  21/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica margem                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA440AC()

Local _xAlias  := GetArea()

//if sc5->c5_margem<95 .and. sc5->c5_margem#0
if sc5->c5_margem<95
	ALERT("Margem abaixo de 95% - Verificar ")
endif

Select SA1
dbSetOrder(1)
Seek xFilial()+SC5->(C5_CLIENTE+C5_LOJACLI)
if sa1->a1_codbar=='S'
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+sc5->c5_num
	Do while !eof() .and. sc6->c6_num==sc5->c5_num
		if sa1->a1_codbar=='S'
			RecLock("SC6",.f.)
			sc6->c6_local := "CB"
			MsUnLock()
		endif
		Select SB1
		SB1->(DbSetOrder(1))
		Seek(xFilial("SB1")+SC6->C6_PRODUTO)
		Select SF4
		SF4->(DbSetOrder(1))
		Seek(xFilial("SF4")+SC6->C6_TES)
		Reclock("SC6",.f.)
		SC6->C6_CLASFIS := left(sb1->B1_ORIGEM,1)+left(sf4->F4_SITTRIB,2)
		MsUnLock()
		
		Select SB2
		seek xFilial()+sc6->c6_produto+"CB"
		if eof() .and. rlock()
			*     appe blan
			*     sb2->b2_filial := xFilial()
			*     sb2->b2_cod    := sc6->c6_produto
			*     sb2->b2_local  := "CB"
		endif
		Select SC6
		skip
	Enddo
Endif

// Não bloquear para notas de remessa de beneficiamento

Select SC6
dbSetOrder(1)
Seek xFilial()+sc5->c5_num
Do while !eof() .and. sc6->c6_num==sc5->c5_num
	Select SF4
	seek xFilial()+sc6->C6_TES
	if f4_poder3='R'
		Select SC9
		dbSetOrder(1)
		seek xFilial()+sc6->(c6_num+c6_item)
		if !eof()
			RecLock("SC9",.f.)
			sc9->C9_BLEST  := " "
			sc9->C9_BLCRED := " "
			MsUnLock()
		endif
	endif
	Select SC6
	skip
enddo

RestArea(_xAlias)

Return({})
