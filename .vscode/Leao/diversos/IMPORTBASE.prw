#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/01
#INCLUDE "TOPCONN.CH"

User Function IMPORTBASE()        // Importa base

if select("trb")<>0
	dbclosearea("TRB")
endif

dbUseArea( .T.,,"\x", "TRB", Nil, .F. )
dbgotop()
do while !eof()         
	if trb->b2_qatu > 0   
		nQuant := trb->b2_qatu
		cTm := "999"      
		cCf := "RE0"
	else
		nQuant := -trb->b2_qatu
		cTm := "001"
		cCf := "DE0"
	endif                         
	Select SB1
	dbSetOrder(1)
	seek xFilial()+trb->b2_cod
	Select SD3
	dbSetOrder(4)
	Go Bott
	cNum := d3_numseq
	reclock("SD3",.t.)
	sd3->d3_filial  := xFilial("SD3")
	sd3->d3_local   := trb->b2_local
	sd3->d3_tm      := ctm
	sd3->d3_quant   := nQuant
	sd3->d3_emissao := stod("20171231")
	sd3->d3_usuario := "Inventario"
	sd3->d3_cod     := trb->b2_cod
	sd3->d3_doc     := "Invent"
	sd3->d3_cf      := cCf
	sd3->d3_numseq  := cNum
	sd3->d3_ident   := cNum
	sd3->d3_cc      := "BX"
	sd3->d3_um      := sb1->b1_um
	sd3->d3_segum   := sb1->b1_segum
	sd3->d3_qtsegum := nQuant/sb1->b1_conv
	sd3->d3_tipo    := sb1->b1_tipo
	
	MsUnlock()
	
	Select Trb
	skip
enddo
return
