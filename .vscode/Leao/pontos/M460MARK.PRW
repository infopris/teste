#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460MARK º Autor ³   Alexandro Dias   º Data ³  24/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ verifica se o cliente possui titulos em aberto (atraso)    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M460MARK()

_xAlias  := GetArea()

dbSelectArea("SE1")                // * Verifica Titulos em Aberto Cliente
dbSetOrder(8)
Seek xFilial()+sc9->c9_cliente
if !eof()
x:= paramixb[1]
x:= paramixb[2]

	lAberto := .f.
	cNom := se1->e1_nomcli
	nAberto := 0
	Do while !eof() .and. sc9->c9_cliente == se1->e1_cliente
		if se1->e1_status=="A" .and. se1->e1_vencrea<date()
			lAberto := .t.
			nAberto += se1->e1_saldo
		endif
		Skip
	Enddo
	if laberto
		dbSelectArea("SA1") // * Cadastro de Clientes
		dbSetOrder(1)
		dbSeek(xFilial()+sc9->(c9_cliente+c9_loja))
		if !MsgBox ("Pedido : "+sc9->c9_pedido+"  Cliente : "+sa1->a1_nome+" com duplicatas em ATRASO (R$"+str(nAberto)+"), continua ? ","Escolha","YESNO")
			Return(.f.)
		endif
	Endif                // Final da Verifica‡ao do arquivo de titulos em aberto
Endif

RestArea(_xAlias)

Return(.t.)
