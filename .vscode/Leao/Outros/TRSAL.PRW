#include "rwmake.ch"

User Function TRSal()   // Programa para transferir saldo entre produtos

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

Processa( {|| RunProc() } )
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SB2
dbSetOrder(1)
Seek xFilial()+"00"
ProcRegua(recno())
// Acerto de produtos 00 faturados
Do while !eof() .and. left(b2_cod,2)=="00"
	IncProc()
	if left(b2_cod,2)=="00" .and. b2_qatu<0 .and. substr(b2_cod,5,1)=='.'
		cLoc := sb2->b2_local
		cCod1:= b2_cod
		cCod2:= "1"+substr(b2_cod,2,14)
		nQtd := -b2_qatu
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod2
		nConv := sb1->b1_conv
		nTpCv := sb1->b1_tipconv
		Select SD3
		dbSetOrder(4)
		Go Bott
		cNum := d3_numseq
		//  Select SX6
		//  seek "  MV_DOCSEQ"
		//  cPrf := left(X6_CONTEUD,1)
		//  cNum := VAL(substr(X6_CONTEUD,2,5))+1
		//  cNum := cPrf + strzero(cNum,5)
		//  If rlock()
		//    sx6->x6_conteud := cNum
		//  endif
		Select SD3
		RecLock("SD3",.t.)
		sd3->d3_filial := "01"
		sd3->d3_tm     := "999"
		sd3->d3_cod    := cCod2
		sd3->d3_um     := sb1->b1_um
		sd3->d3_quant  := nQtd
		sd3->d3_cf     := "RE4"
		sd3->d3_local  := cLoc
		sd3->d3_grupo  := sb1->b1_grupo
		sd3->d3_emissao:= date()
		sd3->d3_segum  := sb1->b1_segum
		sd3->d3_qtsegum:= nqtd/sb1->b1_conv
		sd3->d3_tipo   := sb1->b1_tipo
		sd3->d3_numseq := cNum
		sd3->d3_ident  := cNum
		MsUnlock()
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod1
		Select SD3
		RecLock("SD3",.t.)
		sd3->d3_filial := "01"
		sd3->d3_tm     := "499"
		sd3->d3_cod    := cCod1
		sd3->d3_um     := sb1->b1_um
		sd3->d3_quant  := nQtd
		sd3->d3_cf     := "DE4"
		sd3->d3_local  := cLoc
		sd3->d3_grupo  := sb1->b1_grupo
		sd3->d3_emissao:= date()
		sd3->d3_segum  := sb1->b1_segum
		sd3->d3_qtsegum:= nqtd/sb1->b1_conv
		sd3->d3_tipo   := sb1->b1_tipo
		sd3->d3_numseq := cNum
		sd3->d3_ident  := cNum
		MsUnLock()
		Select SB2
		xReg := Recno()
		RecLock("SB2",.f.)
		sb2->b2_qatu    := sb2->b2_qatu + nQtd
		if nTpCv=="D"
			sb2->b2_qtsegum := sb2->b2_qtsegum + (nQtd/nConv)
		endif
		MsUnLock()
		Seek xFilial()+cCod2+cLoc
		if !eof()
			RecLock("SB2",.f.)
			sb2->b2_qatu := sb2->b2_qatu - nQtd
			if nTpCv=="D"
				sb2->b2_qtsegum := sb2->b2_qtsegum - (nQtd/nConv)
			endif
			MsunLock()
		Endif
		MsUnlock()
		goto xReg
	endif
	Select SB2
	Skip
Enddo

// Produtos para revenda
Select SB2
dbSetOrder(1)
Seek xFilial()+"0."
ProcRegua(recno())
Do while !eof() .and. left(b2_cod,2)=="0."
	IncProc()
	if left(b2_cod,2)=="0." .and. b2_qatu>0
		cLoc := sb2->b2_local
		cCod1:= b2_cod
		cCod2:= substr(b2_cod,3,14)
		nQtd := b2_qatu
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod1
		nConv := sb1->b1_conv
		nTpCv := sb1->b1_tipconv
		Select SD3
		dbSetOrder(4)
		Go Bott
		cNum := d3_numseq
		Select SD3
		RecLock("SD3",.T.)
		sd3->d3_filial := "01"
		sd3->d3_tm     := "999"
		sd3->d3_cod    := cCod1
		sd3->d3_um     := sb1->b1_um
		sd3->d3_quant  := nQtd
		sd3->d3_cf     := "RE4"
		sd3->d3_local  := cLoc
		sd3->d3_grupo  := sb1->b1_grupo
		sd3->d3_emissao:= date()
		sd3->d3_segum  := sb1->b1_segum
		sd3->d3_qtsegum:= nqtd/sb1->b1_conv
		sd3->d3_tipo   := sb1->b1_tipo
		sd3->d3_numseq := cNum
		sd3->d3_ident  := cNum
		MsUnlock()
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod2
		Select SD3
		RecLock("SD3",.t.)
		sd3->d3_filial := "01"
		sd3->d3_tm     := "499"
		sd3->d3_cod    := cCod2
		sd3->d3_um     := sb1->b1_um
		sd3->d3_quant  := nQtd
		sd3->d3_cf     := "DE4"
		sd3->d3_local  := cLoc
		sd3->d3_grupo  := sb1->b1_grupo
		sd3->d3_emissao:= date()
		sd3->d3_segum  := sb1->b1_segum
		sd3->d3_qtsegum:= nqtd/sb1->b1_conv
		sd3->d3_tipo   := sb1->b1_tipo
		sd3->d3_numseq := cNum
		sd3->d3_ident  := cNum
		MsUnlock()
		Select SB2
		xReg := Recno()
		RecLock("SB2",.f.)
		sb2->b2_qatu    := sb2->b2_qatu + nQtd
		if nTpCv=="D"
			sb2->b2_qtsegum := sb2->b2_qtsegum + (nQtd/nConv)
		endif
		MsUnLock()
		Seek xFilial()+cCod2+cLoc
		if !eof()
			RecLock("SB2",.f.)
			sb2->b2_qatu := sb2->b2_qatu - nQtd
			if nTpCv=="D"
				sb2->b2_qtsegum := sb2->b2_qtsegum - (nQtd/nConv)
			endif
			MsunLock()
		Endif
		MsUnlock()
		goto xReg
	endif
	Select SB2
	Skip
Enddo


Select SB2
dbSetOrder(1)
Seek xFilial()+"1"
ProcRegua(recno())
// Acerto de produtos tipo A e tipo B faturados
Do while !eof() .and. left(b2_cod,1)=="1"
	IncProc()
	if !sb2->b2_local$"01*CB"
		skip
		loop
	endif
	cPos := at(".",b2_cod)
	if (substr(b2_cod,cPos+1,1)=="1" .or. substr(b2_cod,cPos+1,1)=="2") .and. b2_qatu<>0 .and. substr(b2_cod,cPos,1)=='.' .and. left(b2_cod,1)='1'
		cLoc := sb2->b2_local
		if b2_qatu<0
			cCod1:= b2_cod
			cCod2:= left(b2_cod,cPos-1)+".0"+substr(b2_cod,cPos+2,14)
		else
			cCod2:= b2_cod
			cCod1:= left(b2_cod,cPos-1)+".0"+substr(b2_cod,cPos+2,14)
		endif
		nQtd := iif(sb2->b2_qatu<0,-b2_qatu,b2_qatu)
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod2
		nConv := sb1->b1_conv
		nTpCv := sb1->b1_tipconv
		Select SD3
		dbSetOrder(4)
		Go Bott
		cNum := d3_numseq
		Select SD3
		RecLock("SD3",.t.)
		sd3->d3_filial := "01"
		sd3->d3_tm     := "999"
		sd3->d3_cod    := cCod2
		sd3->d3_um     := sb1->b1_um
		sd3->d3_quant  := nQtd
		sd3->d3_cf     := "RE4"
		sd3->d3_local  := cLoc
		sd3->d3_grupo  := sb1->b1_grupo
		sd3->d3_emissao:= ddatabase
		sd3->d3_segum  := sb1->b1_segum
		sd3->d3_qtsegum:= nqtd/sb1->b1_conv
		sd3->d3_tipo   := sb1->b1_tipo
		sd3->d3_numseq := cNum
		sd3->d3_ident  := cNum
		
		MsUnlock()
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod1
		Select SD3
		RecLock("SD3",.t.)
		sd3->d3_filial := "01"
		sd3->d3_tm     := "499"
		sd3->d3_cod    := cCod1
		sd3->d3_um     := sb1->b1_um
		sd3->d3_quant  := nQtd
		sd3->d3_cf     := "DE4"
		sd3->d3_local  := cLoc
		sd3->d3_grupo  := sb1->b1_grupo
		sd3->d3_emissao:= ddatabase
		sd3->d3_segum  := sb1->b1_segum
		sd3->d3_qtsegum:= nqtd/sb1->b1_conv
		sd3->d3_tipo   := sb1->b1_tipo
		sd3->d3_numseq := cNum
		sd3->d3_ident  := cNum
		MsUnlock()
		Select SB2
		Seek xFilial()+cCod1+cLoc
		xReg := Recno()
		if !eof()
			RecLock("SB2",.f.)
			sb2->b2_qatu    := sb2->b2_qatu + nQtd
			if nTpCv=="D"
				sb2->b2_qtsegum := sb2->b2_qtsegum + (nQtd/nConv)
			endif
			MsUnLock()
		Endif
		Seek xFilial()+cCod2+cLoc
		if !eof()
			RecLock("SB2",.f.)
			sb2->b2_qatu := sb2->b2_qatu - nQtd
			if nTpCv=="D"
				sb2->b2_qtsegum := sb2->b2_qtsegum - (nQtd/nConv)
			endif
			msunLock()
		Endif
		goto xReg
	endif
	Select SB2
	Skip
Enddo

Select SB2
dbSetOrder(1)
Seek xFilial()+"32"
ProcRegua(recno())
// Molduras
Do while !eof() .and. left(b2_cod,2)=="32"
	IncProc()
	if sb2->b2_local#"02"
		Skip
		loop
	Endif
	if left(b2_cod,2)=="32" .and. b2_qatu>0 .and. substr(b2_cod,3,1)=='.'
		cCod1:= "1"+substr(b2_cod,2,14)
		cCod2:= b2_cod
		nQtd := b2_qatu
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+cCod2
		nConv := sb1->b1_conv
		nTpCv := sb1->b1_tipconv
		
		transfere() // Efetua os lancamentos no SD3
	endif
	Select SB2
	Skip
Enddo

Select SB1
//set filt to b2_cod>0 .and. at(".",substr(b1_cod,at(".",b1_cod)+1,15))<>0
dbSetOrder(4)
Seek xFilial()+"200"
Do while sb1->b1_grupo="200 "
	IncProc()
	nReg := recno()
	//	cCod := left(b1_cod,at(".",substr(b1_cod,at(".",b1_cod)+1,15))-1)
	cCod := sb1->b1_cod
	Select SB2
	dbSetOrder(1)
	seek xFilial()+cCod
	Do while !eof() .and. left(b2_cod,len(cCod))=trim(cCod)
		if b2_qatu>0 .and. b2_local=="02" .and. b2_cod<>cCod
			cCod2	:= sb2->b2_cod
			cCod1	:= cCod
			nQtd	:= sb2->b2_qatu
			transfere()
		endif
		Select SB2
		skip
	Enddo
	Select SB1
	dbSetOrder(4)
	goto nReg
	skip
Enddo

Return


Static Function Transfere()

Select SB1
dbSetOrder(1)
Seek xFilial()+cCod2
nConv	:= sb1->b1_conv
nTpCv	:= sb1->b1_tipconv

Select SD3
dbSetOrder(4)
Go Bott
cNum := d3_numseq
RecLock("SD3",.t.)
sd3->d3_filial := "01"
sd3->d3_tm     := "999"
sd3->d3_cod    := cCod2
sd3->d3_um     := sb1->b1_um
sd3->d3_quant  := nQtd
sd3->d3_cf     := "RE4"
sd3->d3_local  := "02"
sd3->d3_grupo  := sb1->b1_grupo
sd3->d3_emissao:= date()
sd3->d3_segum  := sb1->b1_segum
sd3->d3_qtsegum:= iif(sb1->b1_conv<>0,nqtd/sb1->b1_conv,0)
sd3->d3_tipo   := sb1->b1_tipo
sd3->d3_numseq := cNum
sd3->d3_ident  := cNum
MsUnlock()
Select SB1
dbSetOrder(1)
Seek xFilial()+cCod1
Select SD3
RecLock("SD3",.t.)
sd3->d3_filial := "01"
sd3->d3_tm     := "499"
sd3->d3_cod    := cCod1
sd3->d3_um     := sb1->b1_um
sd3->d3_quant  := nQtd
sd3->d3_cf     := "DE4"
sd3->d3_local  := "02"
sd3->d3_grupo  := sb1->b1_grupo
sd3->d3_emissao:= date()
sd3->d3_segum  := sb1->b1_segum
sd3->d3_qtsegum:= nqtd/sb1->b1_conv
sd3->d3_tipo   := sb1->b1_tipo
sd3->d3_numseq := cNum
sd3->d3_ident  := cNum
MsUnlock()
Select SB2
xReg := Recno()
RecLock("SB2",.f.)
sb2->b2_qatu    := sb2->b2_qatu - nQtd
if nTpCv=="D"
	sb2->b2_qtsegum := sb2->b2_qtsegum - (nQtd/nConv)
endif
MsUnLock()
Seek xFilial()+cCod1+"02"
if !eof()
	RecLock("SB2",.f.)
	sb2->b2_qatu := sb2->b2_qatu + nQtd
	if nTpCv=="D"
		sb2->b2_qtsegum := sb2->b2_qtsegum + (nQtd/nConv)
	endif
Endif
MsUnlock()
goto xReg


