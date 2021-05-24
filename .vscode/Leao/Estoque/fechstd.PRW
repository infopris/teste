#include "rwmake.ch"

User Function FechStd()   // Programa para fechamento do custo Std
                     
//mv_par01 = data do fechamento

if !Pergunte ("FECSTD",.T.)
	Return
endif

Select SZ3          
dbSetOrder(2)
seek '  '+dtos(mv_par01)
if !eof()
	if MsgBox ("Fechamento já executado no período, deseja refazer ? ","Escolha","YESNO")
		if MsgBox ("Esse processo irá sobrepor os custos anteriores, confirma ? ","Escolha","YESNO")
			Processa( {|| Fech() } )
		endif
	endif
else
	Processa( {|| Fech() } )
endif

Return

***************************
Static Function Fech()
***************************

Select SB1
dbSetOrder(1)
ProcRegua(reccount())
dbGoTop()
Do while !eof()
	IncProc("Aguarde termino do processamento...")
	IF SB1->B1_TIPO='MP' .and. SB1->B1_PRODPAI<>B1_COD
		skip
		loop
	endif
	IF SB1->B1_TIPO='PA' .and. at(".",SB1->B1_COD)<>0 .and. left(SB1->b1_cod,2)<>"28"  .and. left(SB1->b1_cod,2)<>"29" 
		skip
		loop
	endif
	IF SB1->B1_TIPO='RV' .and. at(".",SB1->B1_COD)<>0
		skip
		loop
	endif
	if !SB1->b1_tipo$"MP*PA*RV"
		skip
		loop
	endif      
	cGrp := sb1->b1_grupo
	nCust  := iif(cGrp<'30' .or. sb1->b1_grupo='999',b1_custd,b1_custd3)
	nSimul := iif(cGrp<'30' .or. sb1->b1_grupo='999',b1_custsim,b1_cstsim3)

	Select SB2
	dbSetOrder(1)
	Seek xFilial()+sb1->(b1_cod+b1_locpad)
	if eof()
		Seek xFilial()+sb1->b1_cod
	endif

	Select SB5
	dbSetOrder(1)
	Seek xFilial()+sb1->(b1_cod)

	Select SZ3
	dbSetOrder(1)
	seek '  '+sb1->B1_COD+dtos(mv_par01)

	RecLock("SZ3",eof())
	sz3->z3_cod	:= sb1->b1_cod
	sz3->z3_tipo:= sb1->b1_tipo
	sz3->z3_data:= mv_par01
	sz3->z3_stdcipi	:= iif(sb1->b1_tipo='PA',sb5->b5_prv7,SB1->B1_CUSTD3)
	sz3->z3_stdsipi	:= iif(sb1->b1_tipo='PA',sb5->b5_prv7,SB1->B1_CUSTD)
	sz3->z3_medcipi	:= sb2->b2_cmff4
	sz3->z3_medsipi	:= sb2->b2_cmff3
	sz3->z3_ultcipi	:= sb2->b2_cmff5
	sz3->z3_ultsipi	:= sb1->b1_XUPRCSI
//	sz3->z3_atucipi	:= iif(sb1->b1_tipo='PA',sb5->b5_cstatu,iif(z3_medcipi>z3_ultcipi,z3_medcipi,z3_ultcipi))
//	sz3->z3_atusipi	:= iif(sb1->b1_tipo='PA',sb5->b5_cstatu,iif(z3_medsipi>z3_ultsipi,z3_medsipi,z3_ultsipi))
	sz3->z3_atucipi	:= iif(sb1->b1_tipo='PA',sb5->b5_cstatu,sb1->b1_cstatu2)
	sz3->z3_atusipi	:= iif(sb1->b1_tipo='PA',sb5->b5_cstatu,sb1->b1_cstatu)
	sz3->z3_simcipi	:= iif(sb1->b1_tipo='PA',sb5->b5_custsim,sb1->B1_CSTSIM2)
	sz3->z3_simsipi	:= iif(sb1->b1_tipo='PA',sb5->b5_custsim,sb1->B1_CUSTSIM)
	sz3->z3_margem	:= sb5->b5_margem
	MsUnLock()
	Select SB1
	Skip
Enddo

