#include "rwmake.ch"

User Function GeraPedP()   // Programa para gerar duplicatas do pedido P

// Grava parte P no SD2 e SE1

cPerg      := "GERAPEDP"
if !Pergunte (cPerg,.T.)
	Return
endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Refazer nota ?                                              ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if mv_par03=1
	nNota := 0
	@ 050,01 To 200,500 Dialog Odlg Title "Nota a ser refeita"
	@ 003,09 to 100,400
	@ 011,11 Say "Nota :"
	@ 011,45 GET nNota  Picture "@E 999999" Valid .T.
	@ 60,25 BMPBUTTON TYPE 01 ACTION Cancela()
	@ 60,65 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	Activate Dialog oDlg Centered
endif

cTmp := CriaTrab(nil,.f.)
Select SD2
copy stru to &cTmp
dbUseArea( .T.,,cTmp,"TMP", Nil, .F. )

cTemp := CriaTrab(nil,.f.)


Select SD2
dbSetOrder(5)
Set SoftSeek on
Seek xFilial()+dtos(mv_par01)
Set SoftSeek off
cDocE1 := sd2->(d2_serie+d2_doc)
lIni := .t.
lZF  := .f.
Do while !eof() .and. d2_emissao>=mv_par01 .and. d2_emissao<=mv_par02      
	do while !eof() .and. (d2_serie='002' .or. d2_serie='2  ')
		skip
		loop
	enddo
	if cDoce1<>sd2->(d2_serie+d2_doc)
		cDocE1 := sd2->(d2_serie+d2_doc)
		lIni := .t.
	endif
	select SF4
	seek xFilial()+sd2->d2_tes
	if sf4->f4_duplic='N'
		select SD2
		skip
		loop
	endif
	if lIni
		Select SA1
		seek xfilial()+sd2->(d2_cliente+d2_loja)
		if !eof()
			Select SE1
			dbSetOrder(1)
			Seek xFilial()+sd2->(d2_serie+d2_doc)
			do while !eof() .and. e1_prefixo+e1_num=sd2->(d2_serie+d2_doc) .and. e1_emissao=sd2->d2_emissao
				if e1_bco1="  "
					RecLock("SE1",.f.)
					Replace E1_OCORREN With "01"
					Replace E1_BCO1 With SA1->A1_BCO1
					Replace E1_BCO2 With SA1->A1_BCO2
					Replace E1_BCO3 With SA1->A1_BCO3
					Replace E1_BCO4 With SA1->A1_BCO4
					Replace E1_BCO5 With SA1->A1_BCO5
					MsUnLock()
				endif
				skip
			enddo
			//		Seek xFilial()+"001"+sd2->d2_doc
			//		do while !eof() .and. e1_prefixo+e1_num="001"+sd2->d2_doc .and. e1_emissao=sd2->d2_emissao
			//			if rlock() .and. e1_bco1="  "
			//				Replace E1_OCORREN With "01"
			//				Replace E1_BCO1 With SA1->A1_BCO1
			//				Replace E1_BCO2 With SA1->A1_BCO2
			//				Replace E1_BCO3 With SA1->A1_BCO3
			//				Replace E1_BCO4 With SA1->A1_BCO4
			//				Replace E1_BCO5 With SA1->A1_BCO5
			//			endif
			//			skip
			//		enddo
		endif
	endif
	Select SE1
	dbSetOrder(2)
	Seek xFilial()+sd2->(d2_cliente+d2_loja)+"001"+sd2->d2_doc
	nValSuf := 0
	if !eof()
		Select SD2
		nReg := recno()
		dbSetOrder(3)
		cDoc := d2_doc
		Seek xfilial()+cDoc+"001"
		if eof()
			GeraNota()
		endif
		Select SD2
		goto nReg
		dbSetOrder(5)
		do while !eof() .and. d2_doc=cDoc
			skip
		enddo
		loop
	endif
	Select SUA
	dbSetOrder(8)
	Seek xFilial()+sd2->d2_pedido // Elimina quaisquer duplicidades que possa encontrar - Luiz - 23/07/2018
	do while !eof() .and. sd2->(d2_cliente+d2_loja) <> sua->(ua_cliente+ua_loja) .and. sd2->d2_pedido = sua->ua_NumSC5
		skip
	enddo
	if ua_setor<>"A"
		Select SD2
		skip
		loop
	endif
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+"P"+substr(sd2->d2_pedido,2,5)
	if eof()
		Select SUA
		dbSetOrder(8)
		Seek xFilial()+sd2->d2_pedido
		do while !eof() .and. sd2->(d2_cliente+d2_loja) <> sua->(ua_cliente+ua_loja) .and. sd2->d2_pedido = sua->ua_NumSC5
			skip
		enddo
		if ua_setor=="A"
			MsgBox ("houve problemas com o pedido, verificar "+sd2->d2_pedido,"Escolha","YESNO")
		endif
		Select SD2
		skip
		loop
	endif
	cCondPg := SC5->C5_CONDPAG
	//	if !MsgBox ("gerar desdobramento para a nota "+sd2->d2_doc+" ?","Escolha","YESNO")
	//		Select SD2
	//		skip
	//		loop
	//	endif
	
	// Gera nota fiscal complementar - fazer
	
	//	Select SF2
	//	dbSetOrder(1)
	//	Seek xFilial()+sd2->(d2_doc+d2_serie+d2_cliente+d2_loja)
	//	copy to &cTemp next 1
	//	dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
	//	if rlock()
	//		trb->f2_serie := "001"
	//	endif
	use
	Select SF2
	//	appe from &cTemp
	Select SD2
	cDoc	:= d2_doc+d2_serie
	cCli 	:= d2_cliente+d2_loja
	nVal	:= 0
	nValSuf := 0
	GeraNota()
	
	// Verifica Parcelas e vencimentos
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial()+cCondPg)
	nNumParc := 1
	cParc	 := ""
	For n:=1 to len(trim(e4_cond))+1
		if substr(e4_cond,n,1)<>"," .and. substr(e4_cond,n,1)<>" "
			cParc += substr(e4_cond,n,1)
		else
			cVenc := "cVenc"+str(nNumParc,1)
			&cVenc:= cParc
			cParc := ""
			if substr(e4_cond,n,1)<>" "
				nNumParc++
			endif
		endif
	Next n
	
	
	// Gera titulo no financeiro
	
	Select SE1
	dbSetOrder(1)
	Seek xFilial()+"1  "+left(cDoc,6)
	if eof()
		dbSetOrder(2)
		Seek xFilial()+cCli+"099"+left(cDoc,6)
	endif
	if !eof()
		nVal1 := 0
		copy to &cTemp next 1
		for n:=1 to nNumParc
			dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
			if sd2->d2_tes<>"543"
				nValSuf := 0
			endif
			nValDup := (nVal+nValSuf)/nNumParc
			if n=nNumParc
				nValDup := (nVal+nValSuf)-nVal1
			endif
			dVencto  := e1_emissao+val(&("cVenc"+str(n,1)))
			Do case
				Case dow(dVencto)=7
					dVencOri := dVencto+2
				Case dow(dVencto)=1
					dVencOri := dVencto+1
				Otherwise
					dVencOri := dVencto
			endcase
			RecLock("TRB",.f.)
				trb->E1_prefixo := "001"
				trb->E1_parcela := chr(64+n)
				trb->E1_vencto  := dVencto
				trb->E1_valor   := nValDup
				trb->E1_saldo   := nValDup
				trb->E1_vencori := dVencto
				trb->E1_vencrea := dVencOri
				trb->E1_pedido  := "P"+substr(e1_pedido,2,6)
				trb->E1_vlcruz  := nValDup
				trb->E1_serie   := "001"
				trb->E1_status  := "A"
				trb->E1_baixa   := ctod("0")
				Replace E1_OCORREN With "01"
				Replace E1_BCO1 With SA1->A1_BCO1
				Replace E1_BCO2 With SA1->A1_BCO2
				Replace E1_BCO3 With SA1->A1_BCO3
				Replace E1_BCO4 With SA1->A1_BCO4
				Replace E1_BCO5 With SA1->A1_BCO5
			MsUnLock()
			nVal1+=trb->e1_valor
			use
			Select SE1
			appe from &cTemp
		Next n
	endif
	Select SD2
	dbSetOrder(5)
Enddo
Select TMP
use
Select SD2
appe from &cTmp

Aviso("Fim","Processamento finalizado",{"Sair"} )

Return

Static Function GeraNota()

Select SD2
dbSetOrder(3)
Seek xfilial()+cDoc
nVal := 0
nValC6 := 0
do while !eof() .and. left(d2_doc,6)=left(cDoc,6)
	if d2_serie<>'1  ' .and. d2_serie<>'099'
		skip
		loop
	endif
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+"P"+substr(sd2->d2_pedido,2,5)+sd2->d2_itempv
	if !eof() .and. sd2->(d2_cliente+d2_loja) = sc6->(c6_cli+c6_loja)
		RecLock("SC6",.f.)
		sc6->c6_nota   := sd2->d2_doc
		sc6->c6_datfat := sd2->d2_emissao
		MsUnLock()
		nValC6 += sc6->c6_valor
	endif
	Select SUA
	dbSetOrder(8)
	Seek xFilial()+sd2->d2_pedido // Elimina quaisquer duplicidades que possa encontrar - Luiz - 23/07/2018
	do while !eof() .and. sd2->(d2_cliente+d2_loja) <> sua->(ua_cliente+ua_loja) .and. sd2->d2_pedido = sua->ua_NumSC5
		skip
	enddo
	cNumTmk := SUA->UA_NUM
	Select SUB
	dbSetOrder(3)
	seek xFilial()+sd2->(d2_pedido+d2_itempv)
	do while !eof() .and. sd2->(d2_pedido+d2_itempv) = sub->(ub_NumPV+ub_itempv) .and. sub->UB_NUM <> cNumTmk
		skip
	enddo
	Select SD2
	nDescZFR := sd2->d2_desczfr
	copy to &cTemp next 1
	dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
	RecLock("trb",.f.)
		trb->d2_quant  := 0
		trb->d2_prcven := sub->ub_vlritem/2 //c6_prcven
		trb->d2_total  := sub->ub_vlritem/2 //sd2->d2_total + nDescZFR
		trb->d2_valipi := 0
		trb->d2_valicm := 0
		trb->d2_tes    := '539'
		trb->d2_cf     := '000'
		trb->d2_ipi    := 0
		trb->d2_picm   := 0
		trb->d2_quant  := 0
		trb->d2_pedido := sc6->c6_num
		trb->d2_serie  := '001'
		trb->d2_tipo   := 'C'
		trb->d2_baseicm:= 0
		trb->d2_icmsret:= 0
		trb->d2_basimp5:= 0
		trb->d2_basimp6:= 0
		trb->d2_valimp5:= 0
		trb->d2_valimp6:= 0
		trb->d2_desczfr:= nDescZFR
	MsUnLock()
	nVal	+=trb->d2_total
	nValSuf	+=nDescZFR
	use
	Select TMP
	appe from &cTemp
	Select SD2
	skip
enddo
if nValSuf>0
	if abs(nValC6-nValSuf-nVal)<1
		nValSuf := 0
	endif
endif
select SD2
do while !eof() .and. left(d2_doc,6)=left(cDoc,6)
	skip
enddo
do while !eof() .and. d2_emissao<mv_par01
	skip
enddo
dbSetOrder(5)
Return

*************************
Static Function Cancela()
*************************
Select SE1
dbSetOrder(1)
seek xFilial()+"001"+strzero(nNota,6)
Do while !eof() .and. "001"+strzero(nNota,6)=left(se1->(E1_PREFIXO+E1_NUM),9)
	if rlock()
		delete
	endif
	skip
Enddo
Close(oDlg)