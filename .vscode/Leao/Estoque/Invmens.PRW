#include "rwmake.ch"

User Function Invmens()   // Programa para fazer os ajustes do Inventário Mensal

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "BAIXOP"

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

cTemp := "\sb2neg2902"
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa( {|| RunProc() } )
Select TRB
Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SB2
Retindex("SB2")

go top
ProcRegua(reccount())
Do while !eof() 
	IncProc()
	if b2_qfim>=0
		Skip
		loop
	Endif
	
	Select SB1
	seek xFilial()+sb2->b2_cod
	VerX6()
	Select SD3
	reclock("SD3",.t.)
	sd3->d3_filial := xFilial()
	sd3->d3_tm     := "050"
	sd3->d3_cod    := sb2->b2_cod
	sd3->d3_um     := sb1->b1_um
	sd3->d3_quant  := sb2->b2_qfim*(-1)
	sd3->d3_cf     := "DE0"
	sd3->d3_local  := sb2->b2_local
	sd3->d3_doc    := "INVENT"
	sd3->d3_emissao:= mv_par01+1
	sd3->d3_grupo  := sb1->b1_grupo
	sd3->d3_parctot:= "T"
	sd3->d3_chave  := "R0"
	sd3->d3_segum  := sb1->b1_segum
	sd3->d3_qtsegum:= sb2->b2_qfim*(-1)sb1->b1_conv
	sd3->d3_tipo   := sb1->b1_tipo
	sd3->d3_numseq := cNum
	sd3->d3_ident  := cNum1
	MsUnlock()

	Select Sb2
	Skip
Enddo

Return



***********************
Static Function VerX6()  // Verifica Pr¢ximo n£mero na seqencia
***********************
Select SD3
dbSetOrder(4)
Go Bott
cNum := d3_numseq

Return

Select SX6
seek "  MV_DOCSEQ"
cPrf := left(X6_CONTEUD,1)
cNum := VAL(substr(X6_CONTEUD,2,5))+1
cNum1:= VAL(substr(X6_CONTEUD,2,5))+2
cNum := cPrf + strzero(cNum,5)
cNum1:= cPrf + strzero(cNum1,5)
reclock("SX6",.f.)
sx6->x6_conteud := cNum1
msUnLock()

