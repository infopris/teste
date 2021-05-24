#include "rwmake.ch"

User Function BaixaOp1()   // Programa para baixar componentes com base nas OPs produzidas num período

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "BAIXOP"
/*
dbUseArea( .T.,,"\tab.dbf","TRB", Nil, .F. )
do while !eof()
	Select SB5
	seek xFilial()+trb->cod1
	if !eof()
	Reclock("SB5",.f.)
	sb5->b5_margem	:= trb->Margem
	MsUnLock()
	endif
	Select TRB
	skip
enddo                               
return
// Fora de uso
dbUseArea( .T.,,"\XB7.dbf","TRB", Nil, .F. )
do while !eof()
	Select SB9
	seek xFilial()+dtos(trb->B7_data)+trb->(B7_COD+B7_LOCAL)
	if eof()
	Reclock("SB9",.t.)
	sb9->b9_filial	:= xFilial()
	sb9->b9_cod		:= trb->B7_COD
	sb9->b9_data	:= trb->B7_DATA
	sb9->b9_local	:= trb->B7_local
	sb9->b9_qini	:= trb->B7_quant
	MsUnLock()
	endif
	Select TRB              
	skip
enddo                               

return
*/

if !Pergunte (cPerg,.T.)
	Return
Endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Da Op                                                       ³
// ³ mv_par04 => Ate Op                                                      ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa( {|| RunProc() } )
Select TRB
Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SD3      
dbSetOrder(6)
set softseek on 
seek xFilial()+dtos(MV_PAR01)
set softseek off            

cTemp := CriaTrab(nil,.f.)
copy to &cTemp for D3_EMISSAO>=MV_PAR01 .and. D3_EMISSAO<=MV_PAR02 .and. D3_CF="PR0" next 2000000
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
Index on D3_COD to &cTemp


ProcRegua(reccount())
Do while !eof() // .and. c2_datrf==ctod("0")
	IncProc(D3_COD)
	dbSelectArea("SG1")
	dbSetOrder(1)
	cCod := left(TRB->D3_cod,at(".",trb->d3_cod)-1)
	Seek xFilial()+cCod
	Do while !eof() .and. trim(sg1->g1_cod)==trim(cCod)
		cComp := SG1->G1_COMP
		gravad3()
		Select SG1
		Skip
	Enddo

	Select TRB
	Skip
Enddo

Return


***********************
Static Function GravaD3() // Grava arquivo SD3 e SB2
***********************
Select SB1
Seek xFilial()+cComp
dbSelectArea("SD3")
reclock("SD3",.t.)
sd3->d3_filial  := trb->d3_filial
sd3->d3_op      := trb->(D3_OP)
sd3->d3_quant   := (SG1->G1_QUANT*(trb->d3_quant)*(1+(sg1->g1_perda/100)))
sd3->d3_emissao := trb->D3_EMISSAO
sd3->d3_usuario := trb->d3_usuario
sd3->d3_cod     := cComp
sd3->d3_doc     := trb->d3_doc
sd3->d3_local   := "02"
sd3->d3_tm      := "999"
sd3->d3_cf      := "RE0"
sd3->d3_numseq  := trb->d3_NumSeq
sd3->d3_ident   := trb->d3_ident
sd3->d3_cc      := "BX"
sd3->d3_um      := sb1->b1_um
sd3->d3_segum   := sb1->b1_segum
sd3->d3_qtsegum := trb->d3_qtsegum
sd3->d3_tipo    := trb->d3_tipo
msunlock()

Return

