#include "RwMake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ TMKVFIM  ³ Autor ³Airton Lira (9659.5776)³ Data ³05/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza dados do pedido de venda.                         ³±±
±±³          ³ Atualiza volume, peso liquido e bruto do pedido, Margem    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TMKVFIM()

Local _nVolume := 0
Local _nValPed := 0
Local _nPesoLi := 0
Local _nPesoBr := 0
Local _xAlias  := GetArea()

Local _nICms := 0
Local _nMargem := 0
Local _nMargemt:= 0
Local _nTotCust:= 0
Local _nTotMg  := 0
Local _nMargPer:= 0
Local _nValSetor := 0
Local _Valini  := 0
Local _nTotLiq := 0

Public nVlped
Public nValLiq
Public mv_par05
cSuper 	:= space(6)
nComS  	:= 0
_cSetor	:= sua->ua_setor

if M->ua_oper<>'1'
	RestArea(_xAlias)
	Return(.T.)
endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando alteracao de pedido, atualiza o mesmo com a data de inclusao do pedido. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !Empty(_dDataEmis)
	Reclock("SUA",.F.)
	Replace UA_EMISSAO With _dDataEmis
	MsUnLock()
EndIF

if left(SUA->UA_NUMSC5,1)=="P"
	MsgBox ("houve problemas com a numeracao do pedido, favor aprovar novamente","Escolha","YESNO")
	
	Select SC5
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)
	RecLock("SC5",.f.)
	delete
	MsUnLock()
	DbSeek(xFilial("SC5")+"P")
	skip -1
	cNum := strzero(val(sc5->c5_num)+1,6)
	Select SC6
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SUA->UA_NUMSC5)
	do while !eof() .and. sc6->c6_num==SUA->UA_NUMSC5
		RecLock("SC6",.f.)
		delete
		MsUnLock()
		skip
	enddo
	Select SXE
	dbgotop()
	do while !eof()
		if xe_alias == "SC5"
			RecLock("SXE",.f.)
			sxe->xe_numero := cNum
			MsUnLock()
		endif
		skip
	enddo
	Select SUA
	reclock("SUA",.f.)
	SUA->UA_NUMSC5 := " "
	MsUnlock()
	
endif


dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC5->C5_CONDPAG)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

Select SA3
dbSetOrder(1)
Seek xFilial()+sc5->c5_vend1
if sc5->c5_comis1#sa3->a3_comis .and. sc5->c5_comis1#sa1->a1_comis
	Select SC5
	RecLock("SC5",.F.)
	sc5->c5_comis1 := sa3->a3_comis
	MsUnLock()
endif

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(xFilial("SC6")+SUA->UA_NUMSC5)
nMgStdP := nMgReal := nValLiq:= 0

While !Eof() .and. SC6->C6_FILIAL == xFilial("SC6");
	.and. SC6->C6_NUM == SUA->UA_NUMSC5
	
	************ Alteracao Luiz Eduardo - 08-06-2005
	
	cCod	:= sc6->c6_produto
	nPonto	:= at(".",cCod)
	cCod	:= left(cCod,nPonto-1)
	cCod1	:= sc6->c6_produto
	Select SUB
	dbSetOrder(3)
	Seek xFilial()+sc6->(C6_NUM+C6_ITEM)
	Select SB1
	dbSetOrder(1)
	Seek xFilial()+sc6->c6_produto
	
	if left(sc6->c6_produto,2)=="00" .and. substr(sc6->c6_produto,3,1)#"."
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+sc6->c6_produto
		nPerIpi  := sb1->b1_ipi
		if left(b1_codbar,1)=='2'
			cCod     := left(sb1->b1_codbar,7)
			cCod1    := left(sc6->c6_produto,7)
		else
			cCod     := "1"+substr(sc6->c6_produto,2,3)
			cCod1    := "1"+substr(sc6->c6_produto,2,14)
		endif
		
	endif
	
	if left(sc6->c6_produto,2)=="28" .or. left(sc6->c6_produto,2)=="29"
		cCod := sc6->c6_produto
		cCod1:= cCod
	endif
	nPonto := at(".",sc6->c6_produto)
	Select SB5
	Seek xFilial()+LEFT(cCod,iif(nPonto<>0,nPonto-1,6)) 
	nMgStd := SC6->C6_QTDVEN*SB5->B5_PRV7
	nMgStdP += nMgStd
	nMgReal += SUB->UB_MGREALV
	//  Cadstro do Pedido do Cliente
	
	Select SC6
	RecLock("SC6",.f.)
	SC6->C6_NUMPCOM := SUA->UA_NUMPED
	SC6->C6_PEDCLI  := SUA->UA_NUMPED
	sc6->c6_descri	:= sb1->b1_desc
	SC6->C6_MARGEM  := SUB->UB_MGREAL
	SC6->C6_MARGEMV := SUB->UB_MGREALV
	// REAL := VALOR lÍQUIDO / CUSTO STD
	If left(sc6->c6_produto,2)='29'
		sc6->c6_descri	:= trim(sb1->b1_desc)+" ("+alltrim(str(sc6->C6_UNSVEN))+" M2)"  // LE - 04/11/2019 - Inclusão da qtde em M2
	endif
	If left(sc6->c6_produto,2)='38'
		sc6->c6_descri	:= trim(sb1->b1_desc)+" ("+alltrim(str(sub->ub_qtdpc))+" PC)"  // LE - 04/11/2019 - Inclusão da qtde em M2
	endif
	msunlock()
	
	Select SB1
	Seek xFilial()+cCod1
	Select SB5
//	Seek xFilial()+cCod
	_nMargem := 0
	nValLiq  := 0
	cC6_Num := sc6->C6_Num
	cTpVend := "S"
	cQuery := " SELECT * "
	cQuery += " FROM SC5010 "
	cQuery += " WHERE C5_NUM='"+cC6_NUM+"'" 
	cQuery += " AND SC5010.D_E_L_E_T_ <>'*'  "
	cQuery := ChangeQuery(cQuery)

	if select("TRB1")<>0
		dbCloseArea("TRB1")
	Endif
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB1", .F., .T.)
	nVlPed  := iif(trim(sc6->c6_blq)#"R",SC6->C6_VALOR,(SC6->C6_VALOR/SC6->C6_QTDVEN*SC6->C6_QTDENT))
	nValLiq := nVCpmf := nIcms1 := nIcm   := nIpi1 := nIcmST   := 0
	nCom1   := nCom2  := nFin1  := nFrete := nIr   := nValAdic := 0
	nPC     := nTotZFR:= 0
	mv_par05 := 0
	
	u_pCalcVLiq(nVlPed)
	
	Select Trb1
	Use
	
	nQtdV := SC6->C6_QTDVEN
	if sc6->C6_TES <>"569"
		nqtdeM2 := iif(sb1->b1_segum="M2",nQtdV*sb1->b1_conv,0)
		if nqtdeM2<>0 .and. sb1->b1_um<>"KG"
			nQtdV := nQtdV*sb1->b1_conv
		endif
	Endif

//	CalcMarg()
	if cTpVend#"N"
		_nTotLiq  := _nTotLiq  +  nValLiq
		_nTotCust :=(_nTotCust + (SB5->B5_PRV7 * nQtdV))
		_nTotMg   :=(_nTotMg   + (SB5->B5_MARGEM * nQtdV ))//*1.05))
		_nValPed  := _nValPed  +  sc6->c6_valor
		Select SC6
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena dados do peso, peso liq e volume.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If left(sc6->c6_produto,2)<>'38'
		_nPesoBr := _nPesoBr + (SC6->C6_QTDVEN * SB1->B1_PESO)
		_nPesoLi := _nPesoLi + SB1->B1_PESO
	else
		_nPesoBr := _nPesoBr + SC6->C6_QTDVEN
		_nPesoLi := _nPesoLi + SC6->C6_QTDVEN
	endif
	
	cTpEsp := "Caixa(s)"
	if left(sb1->B1_BASE,2)$"28*29*30*31*32*33*34*35*36*37*38"
		cTpEsp := "A Granel"
	endif
	if SC5->C5_CLIENTE="113967"
		cTpEsp := "Pecas"
		_nVolume := _nVolume + SC6->C6_QTDVEN
	else
		_nVolume := _nVolume + SC6->C6_UNSVEN
	Endif
	/*	if SC6->C6_UNSVEN > int(SC6->C6_UNSVEN)
	_nVolume := _nVolume + int(SC6->C6_UNSVEN)+1
	else
	_nVolume := _nVolume + SC6->C6_UNSVEN
	endif
	*/
	Select SC6
	skip
	loop
EndDo

if _nTotCust#0
	_nMargPer := ((_nTotLiq-_nTotCust)/_nTotMg)*100
else
	_nMargPer := 0
endif

Select SUA
RecLock("SUA",.f.)
Replace UA_MGSTD  With _nMargPer
Replace UA_MGSTDV With _nTotLiq-_nTotCust
if _nTotCust<>0
	Replace UA_MGREAL  With (_nTotLiq-_nTotCust)/_nTotCust*100
Endif
MsUnLock()

dbSelectArea("SA1")
dbSeek(xFilial()+SUA->UA_CLIENTE+SUA->UA_LOJA)

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)

While !Eof() .and. SUA->UA_NUMSC5 == SC5->C5_NUM
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Esta variaveis publicas foram declaradas e inicializadas no Tmkcli.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	reclock("SC5",.F.)
	if trim(C5_VEND1)$"11*12"
		Replace C5_COMIS1  With 0.01
	endif
	if empty(SC5->C5_MENPAD)
		Replace C5_MENPAD With SUA->UA_XMENPAD
	endif
	if nMgStd<>0
//		_nTotLiq  //  nValLiq
//		_nTotCust // Custo Std
		Replace C5_MARGEM  With (_nTotLiq-_nTotCust)/_nTotCust*100
	Else
		if nMgStdP<>0
			Replace C5_MARGEM  With nMgReal/nMgStdP*100
		Else
			Replace C5_MARGEM  With _nMargPer
		Endif
	Endif
//	Replace C5_MARGEM  With _nMargPer
	Replace C5_MARGEMV With _nTotLiq-_nTotCust
	Replace C5_NUMTMK  With SUA->UA_NUM
	Replace C5_FATOR   With sua->ua_setor // Alltrim(_cSetor)
	Replace C5_TPFRETE With sua->ua_tpfrete // Alltrim(_cTpFrete)
	Replace C5_PEDCLI  With sua->ua_numped // Alltrim(_cNumPed)
	Replace C5_VALPED  With _nValPed
	Replace C5_PBRUTO  With _nPesoBr
	Replace C5_PESOL   With _nPesoBr // _nPesoLi alterado para acertar NFE
	if cTpEsp <>"A Granel"
		Replace C5_VOLUME1 With _nVolume
	else
		Replace C5_VOLUME1 With 0
	endif
	Replace C5_ESPECI1 With cTpEsp
	Replace C5_UF      With SA1->A1_EST
	Replace C5_MENPAD1 With SA1->A1_MENPAD1
	Replace C5_DESCONT With 0
	Replace C5_SUPER   With cSuper
	Replace C5_USUARIO With Alltrim(Substr(cUsuario,7,15))
	//	Replace C5_COMIS2  With nComS
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quando alteracao de pedido, atualiza o mesmo com a data de inclusao do pedido. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Replace C5_EMISSAO With IIF(!Empty(_dDataEmis),_dDataEmis,SC5->C5_EMISSAO)
	MsUnLock()
	DbSkip()
EndDo

GeraP() // Gera Parte "P"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Reinicializa as variaveis declaradas no ponto Tmkcli. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_dDataEmis := ""

Select SC5
DbSetOrder(1)
DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)

Select SC6
DbSetOrder(1)
DbSeek(xFilial("SC6")+SUA->UA_NUMSC5)

RestArea(_xAlias)

Return(.T.)

**************************
Static Function CalcMarg()
**************************

// Declaracao das Variaveis
// nFator  (n,1)    - Fator de reducao
// nValPed (n,12,2) - Valor do Pedido
// cTpVend (c,2)    - Venda ou Nao (S/N)
// cCod1   (c,6)    - Grupo de Produtos
// cCod    (c,15)   - Codigo do Produto

// 1   - Carrega Variaveis
// 1.1 - Tipo do Pedido - nFator
nFator := 0
do Case
	Case Alltrim(_cSetor) == "A"
		nFator := 2
	Case Alltrim(_cSetor) == "B"
		nFator := 5
	Case Alltrim(_cSetor) == "C"
		nFator := 1
	Case Alltrim(_cSetor) == "S"
		nFator := 0
Endcase

// 1.2 - Dados do Cliente/fornecedor

select SA1
dbSetOrder(1)
seek xFilial()+sc5->c5_cliente+sc5->c5_lojacli
select SA2
dbSetOrder(1)
seek xFilial()+sc5->c5_cliente+sc5->c5_lojacli

// 1.3 - Dados do TES

Select SF4
dbSetOrder(1)
Seek xFilial()+sc6->C6_Tes
cTpVend := "S"
if sf4->f4_duplic=="N" .or. sc5->c5_tipo$'D*I'
	cTpVend := "N"
	RecLock("SC6",.F.)
	if SC5->C5_CLIENTE<>'113967' // Condição especial preçolandia - Vendas por peça
		Replace C6_SEGUM  With SB1->B1_SEGUM
		Replace C6_UNSVEN With IIF(SB1->B1_TIPCONV=="D",SC6->C6_QTDVEN/SB1->B1_CONV,SC6->C6_QTDVEN*SB1->B1_CONV)
	Endif
	Replace	c6_prunit With c6_prcven  // LE 12-05-2010 - Estava gerando desconto na nota
	MsUnlock()
	Return
endif
if trim(sc6->c6_cf)="6107" .and. sa1->a1_pessoa="J" .and. sa1->a1_contrib$" *1"
	RecLock("SC6",.F.)
	Replace	c6_cf With "6"+substr(sf4->f4_cf,2,3) // LE 24-09-2010 - Estava gerando cf errada para PJ
	MsUnlock()
endif

// 1.4 - Dados do item do pedido

Select SA3
dbSetOrder(1)
Seek xFilial()+sc5->c5_vend1
cSuper := sa3->a3_super
Seek xFilial()+sa3->a3_super
nComS := sa3->a3_comis
Seek xFilial()+sc5->c5_vend1
Select SB1
dbSetOrder(1)
Seek xFilial()+cCod1

if sf4->f4_ipi=="N"
	nIpi := 0
else
	nIpi := sb1->b1_ipi
endif

Select SUB
dbsetOrder(3)
seek xFilial()+sc6->(c6_num+c6_item)
nValLiq := nVCpmf := nIcms1 := nIcm   := nIpi1 := 0
nCom1   := nCom2  := nFin1  := nIr    := nValAdic :=  0
nPC     := nTotZFR:= 0
nVlPed  := SUB->UB_VRUNIT*SUB->UB_QUANT
nQtdEnt := SUB->UB_QUANT
if sub->ub_tes$'512*543*559'
	if sub->ub_tes$'543*559' // Z.Franca = ICMS + PIS + Cofins
		nAliqZF := 0.1065
	else
		nAliqZF := 0.07
	endif
	if nFator#0
		nTotZFR := (nVlPed/nfator)*nAliqZF
		nVlPed  := nVlPed-nTotZFR
	endif
endif

CalcVLiq()

**************************
Static Function CalcVLiq()
**************************
dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial()+"MV_PCI")
nPCI  := Val(Alltrim(SX6->X6_CONTEUD))
dbSeek(xFilial()+"MV_CPMF")
nCPMF := Val(Alltrim(SX6->X6_CONTEUD))

// 1 - Calcula precentual do ICMS

dbSelectArea("SA1")
dbSeek(xFilial()+SC6->C6_CLI+SC6->C6_LOJA)
Do Case
	Case SA1->A1_EST $ "AC/AL/AM/AP/BA/CE/DF/ES/GO/MA/MS/MT/PA/PE/PB/PI/SE/RN/RO/RR/TO"
		nIcm := 7
	Case SA1->A1_EST $ "RJ/MG/PR/SC/RS"
		nIcm := 12
	Case SA1->A1_EST == "SP"
		nIcm := 18
	Otherwise
		nIcm := 18
EndCase
nBase := nVlPed
if sc5->C5_TIPOCLI == "F" .OR. (LEN(TRIM(SA1->A1_CGC))>=9 .AND. LEN(TRIM(SA1->A1_CGC))<=11)
	//	nBase:= nVlPed*(1+(nIpi)/100)
	nBase:= nVlPed
	nIcm := 18
endif
if sf4->f4_codigo$'536*541*512*543*559'
	nBase:= 0
	nIcm := 0
endif

// final 1 - Calcula precentual do ICMS (nBase,nIcm)

// 2 - Calcula PIS/Cofins/IR e deducoes Zona Franca

nZFR := 0
* Verifica PIS/Cofins/IR
if sf4->f4_piscof#"4"
	nTotNf  := (nVlPed+nTotZFR)/nFator-nTotZfr
	nPC     := (nTotNf * nPCI)/100
	nIR     := (nTotNf * 2.88)/100
	if left(sa1->a1_codmun,5)=="00255" .and. sub->ub_tes$'512*543*559' // Zona Franca de Manaus
		nICM    := 0
		nIR     := ((ntotNF-nTotNF*.1065) * 2.88)/100
		nVCpmf  := ((nVlPed-nTotNF*.1065) * nCpmf)/100
		nZFr    := nTotZFR
	else
		nVCpmf  := ((nVlPed * nCPMF)/100)
	endif
else
	if left(sa1->a1_codmun,5)=="00255" .and. sub->ub_tes$'512*543*559'  // Zona Franca de Manaus
		nTotNf  := (nVlPed+nTotZFR)/nFator-nTotZFR
		nICM    := 0
		nIR     := ((ntotNF-nTotNF*.1065) * 2.88)/100
		nVCpmf  := ((nVlPed-nTotNF*.1065) * nCpmf)/100
		nZFr    := nTotZFR
	else
		nVCpmf  := ((nVlPed * nCPMF)/100)
	endif
endif

// final 2 - Calcula PIS/Cofins/IR e deducoes Zona Franca

// 3 - Calculo do valor de despesas com frete

nFrete := 0
if year(sc5->c5_emissao)>=2014
	Do case
		Case sa1->a1_est$"BA*CE" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nvlped*0.10
			if sa1->a1_est="CE" .and. trim(sa1->a1_cod_mun)="12908"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C"//"SOBRAL"
				nFrete := nvlped*0.12
			endif
		Case sa1->a1_est$"MG" .and. trim(sa1->a1_cod_mun)="06200"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C" //"BELO HORIZONTE"
			nFrete := nvlped*0.06
		Case sa1->a1_est$"RJ"  .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nvlped*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"SANTOS*SAO VICENTE*GUARUJA*CARAGUATATUBA*UBATUBA" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nvlped*0.065
		Case sa1->a1_est$"SP" .and. ;
			trim(sa1->a1_mun)$"PRAIA GRANDE*CUBATAO*ITANHAEM*MONGAGUA*PERUIBE*SAO SEBASTIAO" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nvlped*0.065
		Case sa1->a1_est$"SP" .and. sa1->a1_cod_mun$"50308*05708*25003*18800" // SP / Barueri / Jandira / Guarulhos ;
			//		"SAO"$sa1->a1_mun .and. "PAULO"$sa1->a1_mun
			nFrete := 0
		Case sa1->a1_est$"RS" .and. Substr(Alltrim(_cTpFrete),1,1)=="C"
			nFrete := nvlped*0.12
		Otherwise
			if Substr(Alltrim(_cTpFrete),1,1)=="C"
				nFrete := nvlped*0.15
			else
				nFrete := 0
			endif
	EndCase
Else
	Do case
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"CE"
			nFrete := nVlPed-nVlPed/1.10
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"BA*PE"
			nFrete := nVlPed-nVlPed/1.08
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"RJ"
			nFrete := nVlPed-nVlPed/1.045
		Case Substr(Alltrim(_cTpFrete),1,1)=="C" .and. sa1->a1_est$"SP"
			nFrete := nVlPed-nVlPed/1.03
		Otherwise
			if Substr(Alltrim(_cTpFrete),1,1)=="C"
				nFrete := nVlPed-nVlPed/1.15
			else
				nFrete := 0
			endif
	EndCase
Endif

// final 3 - Calculo do valor de despesas com frete

// 4 - Calculo do valor de despesas do financeiro

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+sc5->C5_CONDPAG)
_cPagto := se4->e4_indefla

nValFin := 0
Do case
	Case _cPagto == "A"  // A Vista
		nValFin := 1.000
	Case _cPagto == "B"  // 14 dd
		nValFin := 1.015
	Case _cPagto == "C"  // 30 dd
		nValFin := 1.030
	Case _cPagto == "D"  // 45 dd
		nValFin := 1.045
	Case _cPagto == "E"  // 60 dd
		nValFin := 1.060
	Case _cPagto == "F"  // 75 dd
		nValFin := 1.075
	Case _cPagto == "G"  // 90 dd
		nValFin := 1.090
	Otherwise  // Outros
		nValFin := 1.000
EndCase

// final 4 - Calculo do valor de despesas do financeiro

// 5 - Calculo de comissoes

_cSetor := Alltrim(_cSetor)

Select SA3
seek xFilial()+sc5->c5_vend1
nValComis := 0
If sc5->C5_COMIS1 > 0
	nValComis := ((nVlPed-nFrete)*(sc5->C5_COMIS1+nComS))/100
Endif

// final 5 - Calculo de comissoes


// Finalizando os calculos

IF _cSetor == "C"
	nipi1   := ((nVlPed * nIpi)/100)
	nIcms1  := ((nBase  * (nIcm))/100)
ElseIf _cSetor  == "B"
	nipi1   := ((nVlPed * nIpi)/100)*.20
	nIcms1  := ((nBase  * (nIcm))/100) *.20
ElseIf _cSetor  == "A"
	nipi1   := ((nVlPed * nIpi)/100) *.50
	nIcms1  := ((nBase  * (nIcm))/100) *.50
ElseIf _cSetor  == "S"
	nIcms1  := 0
	nIpi1   := 0
Endif


nCom1   := ((((nVlPed-nZFr)-nFrete)*sc5->C5_COMIS1)/100)
nCom2   := iif(nCom1#0,((((nVlPed-nZFr)-nFrete)*nComS)/100),0)
nValAdic:= (nVlPed-nZFr)*(sa1->a1_mgextra/100)

nFin1   := (nVlPed+nIpi1)-((nVlPed+nIpi1)/nValFin) //financeiro abate apos desconto dos impostos
nValLiq := nVlPed - nIcms1 - nValComis - nFrete - nValAdic - nPC - nIR - nVCpmf - nFin1
//nValLiq := nValliq - nFin1

Select SUB
dbsetOrder(3)
seek xFilial()+sc6->(c6_num+c6_item)

dbSelectArea("SC6")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Segunda Unidade de medida e volume ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SC6",.F.)
Replace C6_SEGUM  With SB1->B1_SEGUM
Replace C6_UNSVEN With IIF(SB1->B1_TIPCONV=="D",SC6->C6_QTDVEN/SB1->B1_CONV,SC6->C6_QTDVEN*SB1->B1_CONV)
Replace	c6_prunit With c6_prcven  // LE 12-05-2010 - Estava gerando desconto na nota

if SB5->B5_MARGEM*SUB->UB_QUANT > 0 .and. cTpVend == "S"
	// Atencao - no calculo da margem esta embutido um acrescimo de 5% (gordura)
		Replace C6_MARGEM  With SUB->UB_MGSTD //((nValLiq-(SB5->B5_PRV7*SC6->C6_QTDVEN))/(sb5->b5_margem*SC6->C6_QTDVEN*1.05))*100
		Replace C6_MARGEMV With SUB->UB_MGSTDV //nValLiq-(SB5->B5_PRV7*SC6->C6_QTDVEN)
endif
MsUnLock()

Return

*******************************
Static Function VerCod(cTp,cIt)
*******************************
if cTp=1
	cCod := tmp->c6_produto
else
	cCod := sc6->c6_produto
endif

select Sb1
dbSetOrder(1)
seek xFilial()+cCod
if !trim(sb1->b1_grupo)$"10*20"
	Return
endif
nPonto := at(".",cCod)
cCod := left(cCod,nPonto)+"1"+substr(cCod,nPonto+2,10)
/*
do case
case sc5->c5_fator=="A"
cCod := left(c6_produto,nPonto)+"1"+substr(c6_produto,nPonto+2,10)
case sc5->c5_fator=="B"
cCod := left(c6_produto,nPonto)+"2"+substr(c6_produto,nPonto+2,10)
Otherwise
Return
endcase
*/
Select SB1
dbSetOrder(1)
Seek xFilial()+cCod
if eof()
	if cTp=1
		cCod := tmp->c6_produto
	else
		cCod := sc6->c6_produto
	endif
endif
Select SUB
dbSetOrder(3)
Seek xFilial()+SUA->UA_NUMSC5+cIt
if !eof()
	if left(ub_produto,5)==left(cCod,5)
		reclock("SUB",.F.)
		sub->ub_produto := cCod
		MsUnLock()
	endif
endif
Return

***************************
static Function	VerCondPg()
***************************

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC5->C5_CONDPAG)
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
do case
	Case nNumParc==2
		dbGoTop()
		cParc1 := cParc2 := ""
		cCond1 := trim(cVenc1)
		cCond2 := trim(cVenc2)
		do while !eof()
			if trim(e4_cond)==trim(cVenc1) .and. e4_tipo='1'
				cParc1 := e4_codigo
			endif
			if trim(e4_cond)==trim(cVenc2) .and. e4_tipo='1'
				cParc2 := e4_codigo
			endif
			if cParc1<>"" .and. cParc2<>""
				exit
			endif
			skip
		Enddo
	Case nNumParc==3
		dbGoTop()
		cParc1 := cParc2 := cParc3 := ""
		cCond1 := trim(cVenc2)
		cCond2 := trim(cVenc1)+','+trim(cVenc3)
		do while !eof()
			if trim(e4_cond)==trim(cVenc2) .and. e4_tipo='1'
				cParc1 := e4_codigo
			endif
			if trim(e4_cond)==trim(cVenc1)+','+trim(cVenc3) .and. e4_tipo='1'
				cParc2 := e4_codigo
			endif
			if cParc1<>"" .and. cParc2<>""
				exit
			endif
			skip
		Enddo
		
	Case nNumParc==4
		dbGoTop()
		cParc1 := cParc2 := cParc3 := cParc4 := ""
		cCond1 := trim(cVenc1)+','+trim(cVenc2)
		cCond2 := trim(cVenc3)+','+trim(cVenc4)
		do while !eof()
			if trim(e4_cond)==trim(cVenc1)+','+trim(cVenc2) .and. e4_tipo='1'
				cParc1 := e4_codigo
			endif
			if trim(e4_cond)==trim(cVenc3)+','+trim(cVenc4) .and. e4_tipo='1'
				cParc2 := e4_codigo
			endif
			if cParc1<>"" .and. cParc2<>""
				exit
			endif
			skip
		Enddo
	Case nNumParc==6
		dbGoTop()
		cParc1 := cParc2 := cParc3 := cParc4 := cParc5 := cParc6 := ""
		cCond1 := trim(cVenc1)+','+trim(cVenc2)+','+trim(cVenc3)
		cCond2 := trim(cVenc4)+','+trim(cVenc5)+','+trim(cVenc6)
		do while !eof()
			if trim(e4_cond)==trim(cVenc1)+','+trim(cVenc2)+','+trim(cVenc3) .and. e4_tipo='1'
				cParc1 := e4_codigo
			endif
			if trim(e4_cond)==trim(cVenc4)+','+trim(cVenc5)+','+trim(cVenc6) .and. e4_tipo='1'
				cParc2 := e4_codigo
			endif
			if cParc1<>"" .and. cParc2<>""
				exit
			endif
			skip
		Enddo


endcase
// Grava nova condicao no pedido de vendas
if nNumParc>1 .and. nNumParc<=6
	if cParc1<>"" .and. cParc2<>""
		Select SC5
		DbSeek(xFilial("SC5")+SUA->UA_NUMSC5) // Parte C
		reclock("SC5",.f.)
		replace SC5->C5_CONDPAG with cParc1
		MsUnLock()
		DbSeek(xFilial("SC5")+"P"+substr(SUA->UA_NUMSC5,2,5)) // Parte P
		reclock("SC5",.f.)
		replace SC5->C5_CONDPAG with cParc2
		MsUnLock()
	else
		cAviso := ""
		if cParc1=""
			cAviso := " Condicao "+cCond1
		endif
		if cParc2=""
			cAviso += " Condicao "+cCond2
		endif
		Aviso("Atencao","Nao encontrada forma de pagto para demembrar, verificar "+cAviso,{"Sair"} )
	endif
Endif

Return

***********************
Static Function GeraP()
***********************


DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+SUA->UA_NUMSC5)

if sua->ua_setor=="A" .and. sua->ua_oper='1'
	
	if !eof()
		reclock("SC5",.f.)
		replace c5_fator with "C"
		MsUnLock()
	endif
	cTRB := CriaTrab(nil,.f.)
	do while .t.
		if file(ctrb+".dbf")
			inkey(1)
			cTRB := CriaTrab(nil,.f.)
		else
			exit
		endif
	enddo
	copy to &cTRB next 1
	dbUseArea( .T.,,cTRB,"TRBXPED", Nil, .F. )
	reclock("TRBXPED",.f.)
	replace c5_num with "P"+substr(c5_num,2,5)
	replace c5_tipo with "C"
	MsUnLock()
	use
	// Grava nova empresa
	//	dbUseArea( .T.,,"\data\sc5030.dbf","XC5", Nil, .F. )
	//	if file("\data\sc5030.cdx")
	//		dbSetIndex("\data\sc5030.cdx")
	//		DbSeek(xFilial("XC5")+"P"+substr(SUA->UA_NUMSC5,2,5))
	//		if !eof() .and. rlock()
	//			delete
	//		endif
	//	endif
	//	appe from &cTrb
	//	use
	Select SC5
	DbSeek(xFilial("SC5")+"P"+substr(SUA->UA_NUMSC5,2,5))
	if !eof() .and. rlock()
		delete
	endif
	appe from &cTrb
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SUA->UA_NUMSC5)
	cTRB := CriaTrab(nil,.f.)
	copy to &cTRB next 100 for c6_num==SUA->UA_NUMSC5
	dbUseArea( .T.,,cTRB,"TMP", Nil, .F. )
	dbgotop()
	Do while !eof()
		cCod := tmp->c6_produto
		VerCod(1,tmp->c6_item)
		Select Tmp
		reclock("TMP",.f.)
		tmp->c6_num 	:= "P"+substr(SUA->UA_NUMSC5,2,5)
		tmp->c6_qtdven 	:= 0
		tmp->c6_prcven 	:= c6_valor/2
		tmp->c6_valor 	:= c6_valor/2
		tmp->c6_tes 	:= "539"
		tmp->c6_cf 	:= "000"
		tmp->c6_prunit	:= c6_prunit/2
		tmp->c6_produto	:= cCod
		tmp->c6_pedcli 	:= " "
		MsUnLock()
		skip
	enddo
	use
	Select SC6
	DbSeek(xFilial("SC6")+"P"+substr(SUA->UA_NUMSC5,2,5))
	do while !eof() .and. c6_num=="P"+substr(SUA->UA_NUMSC5,2,5)
		if rlock()
			delete
		endif
		skip
	enddo
	
	Select SC6
	DbSeek(xFilial("SC6")+SUA->UA_NUMSC5)
	do while !eof() .and. c6_num==SUA->UA_NUMSC5
		VerCod(2,sc6->c6_item)
		Select SB1
		dbSetOrder(1)
		Seek xFilial()+sc6->c6_produto
		
		Select SC6
		reclock("SC6",.f.)
		sc6->c6_prcven 	:= c6_prcven/2
		sc6->c6_valor 	:= c6_valor/2
		sc6->c6_prunit	:= c6_prcven
		sc6->c6_produto	:= cCod
		If left(cCod,2)<>'29'
			sc6->c6_descri	:= sb1->b1_desc
		else
			sc6->c6_descri	:= trim(sb1->b1_desc)+" "+trim(str(sc6->C6_UNSVEN))+" M2"  // LE - 04/11/2019 - Inclusão da qtde em M2
		endif
		MsUnLock()
		skip
	enddo
	
	appe from &cTrb
	IF SELECT("XC6") # 0
		XC6->(DBCLOSEAREA( ))
	ENDIF
	
	//	appe from &cTrb
	//	use
	VerCondPg()
	
endif

if sua->ua_setor=="A" .and. sua->ua_oper='1'
	Select SC5
	DbSeek(xFilial("SC5")+"P"+substr(SUA->UA_NUMSC5,2,5))
	if eof()
		MsgBox ("houve problemas com a geracao do pedido, favor aprovar novamente","Escolha","YESNO")
	endif
endif

Return
