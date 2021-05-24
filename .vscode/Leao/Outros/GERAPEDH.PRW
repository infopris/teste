#include "rwmake.ch"  

User Function GeraPedH()   // Programa para gerar duplicatas do pedido P (serie 002)

// Grava parte P no SD2 e SE1

cPerg      := "GERAPEDP"
if !Pergunte (cPerg,.T.)
	Return
endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
Do while !eof() .and. d2_emissao>=mv_par01 .and. d2_emissao<=mv_par02  
	do while !eof() .and. (d2_serie='001' .or. d2_serie='1  ')
		skip
		loop
	enddo
	if cDoce1<>sd2->(d2_serie+d2_doc)
		cDocE1 := sd2->(d2_serie+d2_doc)
		lIni := .t.
	endif
	if lIni 
	Select SA1
	seek xfilial()+sd2->(d2_cliente+d2_loja)
	if !eof()
		Select SE1
		dbSetOrder(1)
		Seek xFilial()+sd2->(d2_serie+d2_doc)
		do while !eof() .and. e1_prefixo+e1_num=sd2->(d2_serie+d2_doc) .and. e1_emissao=sd2->d2_emissao
			if rlock() .and. e1_bco1="  "
				Replace E1_OCORREN With "01"
				Replace E1_BCO1 With SA1->A1_BCO1
				Replace E1_BCO2 With SA1->A1_BCO2
				Replace E1_BCO3 With SA1->A1_BCO3
				Replace E1_BCO4 With SA1->A1_BCO4
				Replace E1_BCO5 With SA1->A1_BCO5
			endif
			skip
		enddo
	endif
	endif
	Select SE1
	dbSetOrder(2)
	Seek xFilial()+sd2->(d2_cliente+d2_loja)+"002"+sd2->d2_doc
	nValSuf := 0
	if !eof()
		Select SD2
		nReg := recno()
		dbSetOrder(3)
		cDoc := d2_doc
		Seek xfilial()+cDoc+"002"
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
	Select SC5
	dbSetOrder(1)
	Seek xFilial()+"P"+substr(sd2->d2_pedido,2,5)
	if eof()
		Select SUA
		dbSetOrder(8)
		Seek xFilial()+sd2->d2_pedido
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

	use
	Select SF2
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
	Seek xFilial()+"2  "+left(cDoc,6) 
	if eof()
		dbSetOrder(2)
		Seek xFilial()+cCli+"099"+left(cDoc,6) 
	endif
	if !eof()
		nVal1 := 0
		copy to &cTemp next 1
		for n:=1 to nNumParc
			dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
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
			if rlock()
			trb->E1_prefixo := "002"
			trb->E1_parcela := chr(64+n)
			trb->E1_vencto  := dVencto
			trb->E1_valor   := nValDup
			trb->E1_saldo   := nValDup
			trb->E1_vencori := dVencto
			trb->E1_vencrea := dVencOri
			trb->E1_pedido  := "P"+substr(e1_pedido,2,6)
			trb->E1_vlcruz  := nValDup
			trb->E1_serie   := "002"
			trb->E1_status  := "A"
			trb->E1_baixa   := ctod("0")
				Replace E1_OCORREN With "01"
				Replace E1_BCO1 With SA1->A1_BCO1
				Replace E1_BCO2 With SA1->A1_BCO2
				Replace E1_BCO3 With SA1->A1_BCO3
				Replace E1_BCO4 With SA1->A1_BCO4
				Replace E1_BCO5 With SA1->A1_BCO5

			endif
			nVal1+=trb->e1_valor
			use
			Select SE1
			appe from &cTemp
		Next n
	endif
	Select SD2
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
do while !eof() .and. left(d2_doc,6)=left(cDoc,6)
	if d2_serie<>'2  ' .and. d2_serie<>'099'
		skip
		loop
	endif
	Select SC6
	dbSetOrder(1)
	Seek xFilial()+"P"+substr(sd2->d2_pedido,2,5)+sd2->d2_itempv
	if !eof() .and. rlock()
		sc6->c6_nota   := sd2->d2_doc
		sc6->c6_datfat := sd2->d2_emissao
	endif
	Select SUB
	dbSetOrder(3)
	seek xFilial()+sd2->(d2_pedido+d2_itempv)
	Select SD2
	nDescZFR := sd2->d2_desczfr
	copy to &cTemp next 1
	dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
	if rlock()
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
		trb->d2_serie  := '002'
		trb->d2_tipo   := 'C'
		trb->d2_baseicm:= 0
		trb->d2_icmsret:= 0
		trb->d2_basimp5:= 0
		trb->d2_basimp6:= 0
		trb->d2_valimp5:= 0
		trb->d2_valimp6:= 0
		trb->d2_desczfr:= nDescZFR
	endif
	nVal	+=trb->d2_total
	nValSuf	+=nDescZFR
	use
	Select TMP
	appe from &cTemp
	Select SD2
	skip
enddo
Return
