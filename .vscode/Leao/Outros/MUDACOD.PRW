#include "rwmake.ch"  

User Function Mudacod()   // Programa para gerar novos codigos dos produtos

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Entradas / Saidas                                           ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbUseArea( .T.,,"\depara","DEP", Nil, .F. )
index on b1_de to depara

//dbUseArea( .T.,,"\xbase","TRB", Nil, .F. )
//index on b1_cod to \xbase

Processa( {|| RunProc() } )
Select dep
Use

Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SB1
dbSetOrder(1)
Select SC0
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof() .and. 1=2
	IncProc()
	Select SB1

	seek xFilial()+left(sc0->c0_produto,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select SC0
		skip      
		loop
	endif
	Select DEP
	Seek left(sc0->c0_produto,5)
	Select SB1
	cCod := left(sc0->c0_produto,at('.',sc0->c0_produto))       
	if at('.',sc0->c0_produto)=5
		cCd := dep->b1_para+dep->mold+substr(sc0->c0_produto,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sc0->c0_produto,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sc0->c0_produto)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select SC0
		if rlock()
			sc0->c0_produto := sb1->b1_cod
		endif
	else
		Select SC0
	endif
	skip
Enddo

Select Sc6
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof()  .and. 1=2
	IncProc()
	Select SB1

	seek xFilial()+left(sc6->c6_produto,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select Sc6
		skip      
		loop
	endif
	Select DEP
	Seek left(sc6->c6_produto,5)
	Select SB1
	cCod := left(sc6->c6_produto,at('.',sc6->c6_produto))       
	if at('.',sc6->c6_produto)=5
		cCd := dep->b1_para+dep->mold+substr(sc6->c6_produto,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sc6->c6_produto,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sc6->c6_produto)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select Sc6
		if rlock()
			sc6->c6_produto := sb1->b1_cod
		endif
	else
		Select Sc6
	endif
	skip
Enddo

Select Sc2
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof()   .and. 1==2
	IncProc()
	Select SB1

	seek xFilial()+left(sc2->c2_produto,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select Sc2
		skip      
		loop
	endif
	Select DEP
	Seek left(sc2->c2_produto,5)
	Select SB1
	cCod := left(sc2->c2_produto,at('.',sc2->c2_produto))       
	if at('.',sc2->c2_produto)=5
		cCd := dep->b1_para+dep->mold+substr(sc2->c2_produto,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sc2->c2_produto,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sc2->c2_produto)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select Sc2
		if rlock()
			sc2->c2_produto := sb1->b1_cod
		endif
	else
		Select Sc2
	endif
	skip
Enddo

Select SUB
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof()  .and. 1==2
	IncProc()
	Select SB1

	seek xFilial()+left(sub->ub_produto,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select Sub
		skip      
		loop
	endif
	Select DEP
	Seek left(sub->ub_produto,5)
	Select SB1
	cCod := left(sub->ub_produto,at('.',sub->ub_produto))       
	if at('.',sub->ub_produto)=5
		cCd := dep->b1_para+dep->mold+substr(sub->ub_produto,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sub->ub_produto,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sub->ub_produto)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select Sub
		if rlock()
			sub->ub_produto := sb1->b1_cod
		endif
	else
		Select Sub
	endif
	skip
Enddo

Select SD2
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof() 
	IncProc()
if left(sd2->d2_cod,5)<>"1006."
	skip
	loop
endif
	Select SB1
	seek xFilial()+left(sd2->d2_cod,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select Sd2
		skip      
		loop
	endif
	Select DEP
	Seek left(sd2->d2_cod,5)
	Select SB1
	cCod := left(sd2->d2_cod,at('.',sd2->d2_cod))       
	if at('.',sd2->d2_cod)=5
		cCd := dep->b1_para+dep->mold+substr(sd2->d2_cod,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sd2->d2_cod,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sd2->d2_cod)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select Sd2
		if rlock()
			sd2->d2_cod := sb1->b1_cod
		endif
	else
		Select Sd2
	endif
	skip
Enddo

Select SB2
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof() .and. 1==2
	IncProc()
	Select SB1

	seek xFilial()+left(sb2->b2_cod,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select sb2
		skip      
		loop
	endif
	Select DEP
	Seek left(sb2->b2_cod,5)
	Select SB1
	cCod := left(sb2->b2_cod,at('.',sb2->b2_cod))       
	if at('.',sb2->b2_cod)=5
		cCd := dep->b1_para+dep->mold+substr(sb2->b2_cod,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sb2->b2_cod,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sb2->b2_cod)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select sb2
		if rlock()
			sb2->b2_cod := sb1->b1_cod
		endif
	else
		Select sb2
	endif
	skip
Enddo

Select sb9
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof() .and. 1==2
	IncProc()
if left(sb9->b9_cod,5)="1006."
x=1
endif
	Select SB1
	seek xFilial()+sb9->b9_cod
	if !eof()
		select sb9
		skip      
		loop
	endif		

	seek xFilial()+left(sb9->b9_cod,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select sb9
		skip      
		loop
	endif
	Select DEP
	Seek left(sb9->b9_cod,5)
	Select SB1
	cCod := left(sb9->b9_cod,at('.',sb9->b9_cod))       
	if at('.',sb9->b9_cod)=5
		cCd := dep->b1_para+dep->mold+substr(sb9->b9_cod,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sb9->b9_cod,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sb9->b9_cod)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select sb9
		if rlock()
			sb9->b9_cod := sb1->b1_cod
		endif
	else
		Select sb9
	endif
	skip
Enddo

Select sc9
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof() .and. 1==2
	IncProc()
	Select SB1

	seek xFilial()+left(sc9->c9_produto,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select sc9
		skip      
		loop
	endif
	Select DEP
	Seek left(sc9->c9_produto,5)
	Select SB1
	cCod := left(sc9->c9_produto,at('.',sc9->c9_produto))       
	if at('.',sc9->c9_produto)=5
		cCd := dep->b1_para+dep->mold+substr(sc9->c9_produto,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sc9->c9_produto,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sc9->c9_produto)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select sc9
		if rlock()
			sc9->c9_produto := sb1->b1_cod
		endif
	else
		Select sc9
	endif
	skip
Enddo

Select Sd1
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof()  .and. 1==2
	IncProc()
	Select SB1
	seek xFilial()+sb9->b9_cod
	if !eof()
		select sb9
		skip      
		loop
	endif		

	seek xFilial()+left(sd1->d1_cod,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select Sd1
		skip      
		loop
	endif
	Select DEP
	Seek left(sd1->d1_cod,5)
	Select SB1
	cCod := left(sd1->d1_cod,at('.',sd1->d1_cod))       
	if at('.',sd1->d1_cod)=5
		cCd := dep->b1_para+dep->mold+substr(sd1->d1_cod,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sd1->d1_cod,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sd1->d1_cod)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select Sd1
		if rlock()
			sd1->d1_cod := sb1->b1_cod
		endif
	else
		Select Sd1
	endif
	skip
Enddo

Select Sd3
set index to
dbGoTop()
ProcRegua(Reccount())
Do while !eof() .and. 1==2
	IncProc()
	Select SB1
	seek xFilial()+left(sd3->d3_cod,5)
	if b1_locpad<>"01" .or. b1_grupo > "20"
		select Sd3
		skip      
		loop
	endif
	Select DEP
	Seek left(sd3->d3_cod,5)
	Select SB1
	cCod := left(sd3->d3_cod,at('.',sd3->d3_cod))       
	if at('.',sd3->d3_cod)=5
		cCd := dep->b1_para+dep->mold+substr(sd3->d3_cod,8,2)
		Seek xFilial()+cCd
	else
		cCd := dep->b1_para+'.'+dep->mold+substr(sd3->d3_cod,9,2)
		Seek xFilial()+cCd
	endif  
	if eof()
		if at('.',sd3->d3_cod)=5
			cCd := dep->b1_para+dep->mold+'VA'
			Seek xFilial()+cCd
		else
			cCd := dep->b1_para+'.'+dep->mold+'VA'
			Seek xFilial()+cCd
		endif
	endif
	if !eof()
		Select Sd3
		if rlock()
			sd3->d3_cod := sb1->b1_cod
		endif
	else
		Select Sd3
	endif
	skip
Enddo
