#include "RwMake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ COPPED   ³ Autor ³Luiz Eduardo           ³ Data ³25/04/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copiar pedidos empresa Leao para RM                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


// Fazer
// 1 - Pedido de Venda leao : gerar pedido RM (exportado) - ok
// 2 - Gera retorno para RM - nao esta gravando no SC6 ok
//   - Calcular o vidro gasto para o retorno - ok
//   - Informar a mao de obra 50% da b5_margem
//   - preco de venda para RM = 50% custo STD
//   - 	// Acrescenta item cobranca de MDO  - colocar na nota de saida
//  dia 24/10 - Mudei para 4 casas no pr.unit do pedido de venda
//  verificar se deu certo

User Function COPPED()

cVar := GetMv("MV_PERCBEN")
nVMP := val(substr(cVar,at("VMP",cVar)+3,6))
nVMO := val(substr(cVar,at("VMO",cVar)+3,6))
nMMP := val(substr(cVar,at("MMP",cVar)+3,6))
nMMO := val(substr(cVar,at("MMO",cVar)+3,6))

if sm0->m0_codigo=="01"
	cNum := space(6)
	@ 196,52 TO 343,505 DIALOG oDlg1 TITLE "Exporta Pedido de Vendas"
	@ 15,010 TO 45,180 
	@ 26,030 Say "Numero do Pedido " 
	@ 26,100 get cNum picture "999999" SIZE 40,20  VALID .t. F3 "SC5"
	@ 50,120 BUTTON "_Confirma" Size 40,15  ACTION Close(oDlg1)
	@ 50,170 BUTTON "_Sair" Size 40,15  ACTION Fec()
	ACTIVATE DIALOG oDlg1 CENTERED

	Select SC5
	dbSetOrder(1)
	seek xFilial()+cNum
	cRecSC5 := recno()
	if eof()
		MsgBox ("Pedido nao cadastrado, verificar","Informa‡ao","INFO")
		Return
	endif
	if sc5->c5_nota#space(6)
		MsgBox ("Pedido ja exportado/faturado, verificar","Informa‡ao","INFO")
		Return
	endif
	if rlock()
		sc5->c5_pedexp   := str(int(nVMP*100),5)+str(int(nVMO*100),5)+str(int(nMMP*100),5)+str(int(nMMO*100),5)
	endif
	
//	cTempA := CriaTrab(nil,.f.)
	cTempA := "\pedidos\C5"+cNum
	copy to &cTempA next 1
//	dbUseArea( .T.,,"TmpC5", "TRB", Nil, .F. )
//	appe from &cTempA
//	use
	Select SC5
	Seek "010"
	skip-1
	if bof()
		cNovoNum := "-00001"
	else
		nNum := val(substr(c5_num,2,5))+1
		cNovoNum := "-"+strzero(nNum,5)
	endif
	// c5_pedexp = Percentuais de MP e MDO usados no calculo
	nRec := recno()
	Appe from &cTempA 
	if rlock()
		sc5->c5_num      := cNovonum
		sc5->c5_cliente  := "110000"
		sc5->c5_lojacli  := "01"
		sc5->c5_fator    := "C"
		sc5->c5_uf       := "SP"
		sc5->c5_menpad   := "04"
		sc5->c5_pedexp   := str(int(nVMP*100),5)+str(int(nVMO*100),5)+str(int(nMMP*100),5)+str(int(nMMO*100),5)
	endif
	goto cRecSC5
	if rlock()
		sc5->c5_nota    := "EXPORT"
		sc5->c5_datafat := dDataBase
	endif
// Gerar registro no SD2 e SC9 para alimentar o historico do Call Center
	Select SD2
	cFil   := xFilial()
	cTempD2:= CriaTrab(nil,.f.)
	Copy stru to &cTempD2
	dbUseArea( .T.,,cTempD2, "XD2", Nil, .F. )
	Select SC9
	cFilC9   := xFilial()
	cTempC9  := CriaTrab(nil,.f.)
	Copy stru to &cTempC9
	dbUseArea( .T.,,cTempC9, "XC9", Nil, .F. )

	Select SC6
	dbSetOrder(1)
	seek xFilial()+cNum
	cRecSC6 := reccount()
//	cTempB := CriaTrab(nil,.f.)
	cTempB := "\pedidos\C6"+cNum

	copy to &cTempB next 100 for c6_num==cNum
//	dbUseArea( .T.,,"TmpC6", "TRB", Nil, .F. )
	appe from &cTempB
	goto cRecSC6                             
	nReg := recno()
	nReg1:= recno()
	nQtd := nIt := nMDO := qMDO := 0
	Do while !eof() 
		if left(sc6->c6_produto,1)#"0"
			cProd := left(sc6->c6_produto,4)
			cPrd  := sc6->c6_produto
		else
			cProd := "1"+substr(sc6->c6_produto,2,3)
			cPrd  := "1"+substr(sc6->c6_produto,2,14)
		endif
		Select SB5
		dbSetOrder(1)
		Seek xFilial()+cProd
		Select SC6
		if recno()>cRecSC6 .and. sc6->c6_num==cNum
			GravaD2()
			nVunit := round((sb5->b5_prv7)*nMMP/100,4)
			Select SC6
			if rlock()
				sc6->c6_num    := cNovonum
				sc6->c6_produto:= cPrd
				sc6->c6_prcven := nVUnit
				sc6->c6_prunit := nVUnit
				sc6->c6_valor  := nVUnit*sc6->c6_qtdven
				sc6->c6_tes    := "542"
				sc6->c6_cf     := "5124"
			endif
			nReg1 := recno()
			nMdo  += round(sb5->b5_margem*nMMO/100,2)*sc6->c6_qtdven // Mao de Obra = Margem/perc
			qMdo  += sc6->c6_qtdven 
			nIt++
			Select SG1
			dbSetOrder(1)
			Seek xFilial()+cProd+space(11)+"19"
  			nQtd := nQtd + (sc6->c6_qtdven*g1_quant*0.5) // sem perda com Fator
//			nQtd := nQtd + (sc6->c6_qtdven*g1_quant*(1+g1_perda/100))
		endif     
		Select SC6
		nReg++
		goto nReg
	Enddo
	Select SB1
	seek xFilial()+"2902.CH" //"19.017"
	Select SC6
	// Acrescenta item da devolucao do material
	cTempc := "\pedidos\CT"+cNum
	goto nReg1
	copy to &cTempc next 1 for c6_num==cNovoNum
	appe from &cTempC
	if rlock() .and. recno()>cRecSC6 .and. sc6->c6_num==cNovoNum
		sc6->c6_num := cNovonum
		sc6->c6_item:= strzero(nIt+1,2)
		sc6->c6_tes := "540"
		sc6->c6_cf  := "5902"
		sc6->c6_produto := "2902.CH" // "19.017"
		sc6->c6_qtdven  := nQtd
		sc6->c6_prcven  := round(sb1->b1_custd,2)
		sc6->c6_valor   := round(sb1->b1_custd,2)*sc6->c6_qtdven
	endif     

	appe from &cTempC
	if rlock() .and. recno()>cRecSC6 .and. sc6->c6_num==cNovoNum
  		nMdo := round(nMdo/qMdo,2)
		sc6->c6_num    := cNovonum
		sc6->c6_produto:= "2700"
		sc6->c6_qtdven := qMdo
		sc6->c6_um     := "PC" 
		sc6->c6_prcven := nMdo
		sc6->c6_prunit := nMdo
		sc6->c6_valor  := nMdo*qMdo
		sc6->c6_tes    := "541"
		sc6->c6_cf     := "5124"
		sc6->c6_item   := strzero(nIt+2,2)
	endif     
	erase &(trim(cTempc)+".dbf")
	erase &(trim(cTempc)+".fpt")

	Seek xFilial()+cNum
	do while !eof() .and. sc6->c6_num==cNum
		if rlock()
			sc6->c6_qtdent := sc6->c6_qtdven
			sc6->c6_nota   := " "+substr(sc6->c6_num,2,5)
			sc6->c6_datfat := dDataBase
			sc6->c6_serie  := "RM"
		endif
		skip
	Enddo
	// Acrescenta item cobranca de MDO  - colocar na nota de saida
/*	appe from &cTempC   
	if rlock() .and. recno()>cRecSC6 .and. sc6->c6_num==cNovoNum
		sc6->c6_num := cNovonum
		sc6->c6_item:= strzero(nIt+2,2)
		sc6->c6_tes := "546"
		sc6->c6_qtdven := 1
		sc6->c6_prcven := nMDO
		sc6->c6_valor  := nMDO		
		sc6->c6_cf  := left(sc6->c6_cf,1)+"902"
		sc6->c6_produto := "2700"
		sc6->c6_qtdven  := nQtd
	endif     */
//	use
	Select xd2
	nrecxd2 := reccount()
	use
	if nRecxD2>0
		Select SD2
		appe from &cTempD2
	endif
	Select xc9
	nrecxc9 := reccount()
	use
	if nRecxc9>0
		Select SC9
		appe from &cTempC9
	endif

	MsgBox ("Favor faturar o Pedido "+cNovonum+" para a RM","Informa‡ao","INFO")
Else
	Processa( {|| importar() } )
Endif                                      
Select SC6
Return
                                                    
static function Fec()
Close(oDlg1)
return

Static Function Importar()

if !MsgBox ("Confirma importacao de pedidos ?","Escolha","YESNO")
	Return
endif
cNum := 0
ProcRegua(100000)
Do while cNum<=100000
	IncProc()
	cNum := cNum + 1
	cArq := "\pedidos\C5"+strzero(cNum,6)+".dbf"
	cArq1:= "\pedidos\C6"+strzero(cNum,6)+".dbf"
	cArq2:= "\pedidos\C6"+strzero(cNum,6)+".fpt"
	if File(cArq)
		Select SC5
		seek xFilial()+strzero(cNum,6)
		if !eof()
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
			Select SC5
			if MsgBox ("Pedido "+strzero(cNum,6)+" "+sa1->a1_nreduz+" ja importado,sobrepor ?","Escolha","YESNO")
				if val(sc5->c5_nota)#0
					MsgBox ("Pedido faturado, impossivel sobrepor","Informa‡ao","INFO")
					erase &cArq
					erase &cArq1
					erase &cArq2
					loop
				endif
				Select SC5   
				seek xFilial()+strzero(cNum,6)				
				if rlock()
					dele
				endif
				Select SC6
				seek xFilial()+strzero(cNum,6)
				do while !eof() .and. sc6->c6_num==strzero(cNum,6) .and. rlock()
					dele                                                        
					skip
				enddo
			endif
		endif                                 
		Select SC5
		appe from &cArq
		if rlock()
			sc5->c5_datalib := ctod("0")
			sc5->c5_liberok := " "
		endif
		Select SC6
		appe from &cArq1
		seek xFilial()+strzero(cNum,6)
		Do while !eof() .and. sc6->c6_num==strzero(cNum,6)
			Select SB1
			Seek xFilial()+sc6->c6_produto
			nIpi := 0
			do case
			Case sc5->c5_fator == "A"
				nIpi := sb1->b1_ipi*0.5
			Case sc5->c5_fator == "B"
				nIpi := sb1->b1_ipi*0.2
			Case sc5->c5_fator == "C"
				nIpi := sb1->b1_ipi*1.0
			endcase
			nVUnit := round(sc6->c6_prcven*(1+nIpi/100),4)
			Select SB5
			Seek xFilial()+left(sc6->c6_produto,4)
			Select SC6
			if rlock()
				sc6->c6_qtdlib := 0
				sc6->c6_qtdemp := 0
//				sc6->c6_prcven := round(sb5->b5_prv7*nMMP/100,2)
//				sc6->c6_valor  := round(sb5->b5_prv7*nMMP/100,2)*sc6->c6_qtdven
				sc6->c6_prcven := nVUnit
				sc6->c6_prunit := nVUnit
				sc6->c6_valor  := nVUnit*sc6->c6_qtdven
			endif
			skip
		enddo
		erase &cArq
		erase &cArq1
		erase &cArq2
	endif
Enddo
Return

***********************
Static Function GravaD2
***********************
Select XD2
Reclock("xD2",.t.)
xd2->d2_filial  := cFil
xd2->d2_doc     := " "+substr(sc6->c6_num,2,5)
xd2->d2_serie   := "RM"
xd2->d2_cod     := sc6->c6_produto
xd2->d2_quant   := sc6->c6_qtdven
xd2->d2_prcven  := sc6->c6_prcven
xd2->d2_total   := sc6->c6_valor
xd2->d2_cod     := sc6->c6_produto
xd2->d2_pedido  := sc6->c6_num
xd2->d2_itempv  := sc6->c6_item
xd2->d2_emissao := dDatabase
xd2->d2_tes     := "524"
xd2->d2_cf      := "5949"
MsUnlock()

Select XC9
Reclock("xC9",.t.)
xc9->c9_filial  := cFil
xc9->c9_pedido  := sc6->c6_num
xc9->c9_item    := sc6->c6_item
xc9->c9_cliente := sc6->c6_cli
xc9->c9_loja    := sc6->c6_loja
xc9->c9_produto := sc6->c6_produto
xc9->c9_qtdlib  := sc6->c6_qtdven
xc9->c9_nfiscal := " "+substr(sc6->c6_num,2,5)
xc9->c9_serienf := "RM"
xc9->c9_datalib := dDatabase
xc9->c9_blest   := "10"
xc9->c9_blcred  := "10"
MsUnlock()

