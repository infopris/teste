#include "rwmake.ch"  

User Function GeraTxt()   // Programa para gerar TXT lanctos contabeis

SetPrvt("CRESP,CRESP1,VENDIDO,CNUMC5,CNUMC6,")

cPerg      := "GTXT"
Pergunte (cPerg,.T.)

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para emiss„o do relat¢rio :                                  ³
// ³ mv_par01 => Da emissao (pedido)                                         ³
// ³ mv_par02 => Ate emissao                                                 ³
// ³ mv_par03 => Entradas / Saidas                                           ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCampos := {}
AADD(aCampos,{ "TIPOREG"  , "C",002,0}) 
AADD(aCampos,{ "EMISSAO"  , "C",004,0}) 
AADD(aCampos,{ "DIGITACAO", "C",004,0}) 
AADD(aCampos,{ "INT"      , "C",002,0}) 
AADD(aCampos,{ "ESPECIE"  , "C",003,0}) 
AADD(aCampos,{ "SERIE"    , "C",003,0}) 
AADD(aCampos,{ "NUMERO"   , "C",006,0}) 
AADD(aCampos,{ "ATENUM"   , "C",006,0}) 
AADD(aCampos,{ "CFOP"     , "C",005,0}) 
AADD(aCampos,{ "VALCONT"  , "C",012,0}) 
AADD(aCampos,{ "BASEICM1" , "C",012,0}) 
AADD(aCampos,{ "ALIQICM1" , "C",006,0}) 
AADD(aCampos,{ "VALICM1"  , "C",012,0}) 
AADD(aCampos,{ "ICMISENT1", "C",012,0}) 
AADD(aCampos,{ "ICMOUTRA1", "C",012,0}) 
AADD(aCampos,{ "BASEICM2" , "C",012,0}) 
AADD(aCampos,{ "ALIQICM2" , "C",006,0}) 
AADD(aCampos,{ "VALICM2"  , "C",012,0}) 
AADD(aCampos,{ "ICMISENT2", "C",012,0}) 
AADD(aCampos,{ "ICMOUTRA2", "C",012,0}) 
AADD(aCampos,{ "BASEICM3" , "C",012,0}) 
AADD(aCampos,{ "ALIQICM3" , "C",006,0}) 
AADD(aCampos,{ "VALICM3"  , "C",012,0}) 
AADD(aCampos,{ "ICMISENT3", "C",012,0}) 
AADD(aCampos,{ "ICMOUTRA3", "C",012,0}) 
AADD(aCampos,{ "BASEICM4" , "C",012,0}) 
AADD(aCampos,{ "ALIQICM4" , "C",006,0}) 
AADD(aCampos,{ "VALICM4"  , "C",012,0}) 
AADD(aCampos,{ "ICMISENT4", "C",012,0}) 
AADD(aCampos,{ "ICMOUTRA4", "C",012,0}) 
AADD(aCampos,{ "BASEICM5" , "C",012,0}) 
AADD(aCampos,{ "ALIQICM5" , "C",006,0}) 
AADD(aCampos,{ "VALICM5"  , "C",012,0}) 
AADD(aCampos,{ "ICMISENT5", "C",012,0}) 
AADD(aCampos,{ "ICMOUTRA5", "C",012,0}) 
AADD(aCampos,{ "BASEIPI"  , "C",012,0}) 
AADD(aCampos,{ "VALIPI"   , "C",012,0}) 
AADD(aCampos,{ "IPIISENTO", "C",012,0}) 
AADD(aCampos,{ "IPIOUTRAS", "C",012,0}) 
AADD(aCampos,{ "IPINAOAPR", "C",012,0}) 
AADD(aCampos,{ "ICMSFONTE", "C",012,0}) 
AADD(aCampos,{ "DESCONTO" , "C",012,0}) 
AADD(aCampos,{ "VALVISTA" , "C",012,0}) 
AADD(aCampos,{ "VALPRAZO" , "C",012,0}) 
AADD(aCampos,{ "ISENTOPIS", "C",012,0}) 
AADD(aCampos,{ "CONTRIB"  , "C",001,0}) 
AADD(aCampos,{ "TPNOTA"   , "C",002,0}) 
AADD(aCampos,{ "CODCONT"  , "C",002,0}) 
AADD(aCampos,{ "OBS"      , "C",014,0}) 
AADD(aCampos,{ "CNPJ"     , "C",014,0}) 
AADD(aCampos,{ "INSCR"    , "C",016,0}) 
AADD(aCampos,{ "RAZAOSOC" , "C",035,0}) 
AADD(aCampos,{ "CONTA"    , "C",018,0}) 
AADD(aCampos,{ "UF"       , "C",002,0}) 
AADD(aCampos,{ "CODMUN"   , "C",004,0}) 
AADD(aCampos,{ "VAGO"     , "C",050,0}) 

AADD(aCampos,{ "VAGO1"    , "C",008,0}) 
AADD(aCampos,{ "NCM"      , "C",010,0}) 
AADD(aCampos,{ "DESCRICAO", "C",025,0}) 
AADD(aCampos,{ "BASEIPI2" , "C",012,0}) 
AADD(aCampos,{ "IPI2"     , "C",012,0}) 
AADD(aCampos,{ "ISENTOIP2", "C",012,0}) 
AADD(aCampos,{ "VAGO2"    , "C",050,0}) 

cTemp := CriaTrab(nil,.f.)
dbCreate(cTemp,aCampos)
dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Processa( {|| RunProc() } )
Select TRB
Use
//Select DIPI
//Use
Return

*-------------------------*
Static Function RunProc()
*-------------------------*
Select SF3
ProcRegua(Reccount())
dbSetOrder(1)
set softseek on
seek xFilial()+dtos(mv_par01)
set softseek off
Do while !eof() .and. sf3->f3_entrada>=mv_par01 .and. sf3->f3_entrada<=mv_par02
	IncProc()
	if mv_par03==1 .and. sf3->f3_cfo>'499'
		skip
		loop
	endif
	if mv_par03==2 .and. sf3->f3_cfo<'500'
		skip
		loop
	endif
	if sf3->f3_serie=="001" .or. sf3->f3_serie=="002"
		skip
		loop
	endif
	cContrib := "0"
	cCliFor  := SF3->(f3_cliefor+f3_loja)
	if (sf3->f3_cfo>="500" .and. !sf3->f3_tipo$"B*D") .or. (sf3->f3_cfo<"500" .and. sf3->f3_tipo$"B*D")
		Select SA1
		dbSetOrder(1)
		Seek xFilial()+cCliFor
		if LEFT(sa1->a1_inscr,4)$"ISEN*    " .or. sa1->a1_pessoa=="F"
			cContrib := "1"
			cInscr	 := "ISENTO"
		else
			cInscr := sa1->a1_inscr
		endif
		cCNPJ  := sa1->a1_cgc
		cNome  := sa1->a1_nome
		cCodMun:= sa1->a1_codmun
	else
		Select SA2
		dbSetOrder(1)
		Seek xFilial()+cCliFor
		cCNPJ  := sa2->a2_cgc
		cInscr := sa2->a2_inscr
		cNome  := sa2->a2_nome
		cCodMun:= sa2->a2_codmun
	endif                                
	Select SF3
	cDoc	  := F3_NFISCAL
	cDocEnt	  := sf3->(f3_nfiscal+f3_serie+f3_cliefor+f3_loja)
	nValCont  := 0
	nBASEICM2 := nALIQICM2 := nVALICM2 := nICMISENT2 := nICMOUTRA2 := 0
	nBASEICM3 := nALIQICM3 := nVALICM3 := nICMISENT3 := nICMOUTRA3 := 0
	nBASEICM4 := nALIQICM4 := nVALICM4 := nICMISENT4 := nICMOUTRA4 := 0
	nBASEICM5 := nALIQICM5 := nVALICM5 := nICMISENT5 := nICMOUTRA5 := 0
	nPassag   := 1
	Do while !eof() .and. sf3->f3_nfiscal==cDoc .and. cCliFor==SF3->(f3_cliefor+f3_loja)
		Select TRB
		Set date ansi
		cData  := dtos(sf3->f3_entrada)
		cEmis  := dtos(sf3->f3_emissao)
		cCf	   := sf3->f3_cfo
		Set date brit
		Do Case
		Case nPassag == 1
		Reclock("TRB",.t.)
		trb->TIPOREG	:= "R1"
		trb->EMISSAO	:= substr(cEmis,7,2)+substr(cEmis,5,2)
		trb->DIGITACAO	:= substr(cData,7,2)+substr(cData,5,2)
		trb->INT	:= "00"
		trb->ESPECIE	:= iif(left(SF3->F3_CFO,1)>="5","NFF","NF")
		trb->SERIE	:= "M-1" // SF3->F3_SERIE
		trb->NUMERO	:= strzero(val(SF3->F3_NFISCAL),6)
		trb->ATENUM	:= strzero(val(SF3->F3_NFISCAL),6)
		trb->CFOP	:= SF3->F3_CFO
		nBaseIPI := nOutras := 0
		CalcIPI()
		trb->BASEIPI	:= STRZERO(nBaseiPI*100,12)  // IIF(SF3->F3_BASEIPI<>0,STRZERO(SF3->F3_BASEIPI*100,12),STRZERO(SF3->F3_BASEICM*100,12))
		trb->VALIPI	:= STRZERO(SF3->F3_VALIPI*100,12)
		trb->IPIISENTO	:= STRZERO(SF3->F3_ISENIPI*100,12)
		trb->IPIOUTRAS	:= STRZERO(nOutras*100,12)
		trb->IPINAOAPR	:= STRZERO(0,12)
		trb->ICMSFONTE	:= STRZERO(0,12)
		trb->DESCONTO	:= STRZERO(0,12)
		trb->VALVISTA	:= STRZERO(0,12)
		trb->VALPRAZO	:= STRZERO(0,12)
		trb->ISENTOPIS	:= STRZERO(0,12)
		trb->CONTRIB	:= iif(SF3->F3_ESTADO<>"SP",cCONTRIB,"0")
		trb->TPNOTA	:= iif(SF3->F3_DTCANC<>CTOD("0"),"99","00") //iif(SF3->F3_DTCANC<>CTOD("0"),"99",iif(SF3->F3_CFO=="6109","105","00"))
		trb->CODCONT	:= "01" //"00"
		trb->OBS	:= sf3->f3_observ
		trb->CNPJ	:= cCnpj
		trb->INSCR	:= cInscr
		trb->RAZAOSOC	:= cNome
		trb->CONTA	:= ""
		trb->UF		:= SF3->F3_ESTADO
		trb->CODMUN	:= "0000" // cCodMun 
		trb->VAGO	:= " "
		// icms
		nValCont	:= sf3->f3_valcont
		trb->BASEICM1	:= STRZERO(SF3->F3_BASEICM*100,12)
		trb->ALIQICM1	:= STRZERO(SF3->F3_ALIQICM*10000,06)
		trb->VALICM1	:= STRZERO(SF3->F3_VALICM*100,12)
		trb->ICMISENT1	:= STRZERO(SF3->F3_ISENICM*100,12)
		trb->ICMOUTRA1	:= STRZERO(SF3->F3_OUTRICM*100,12)

		Case nPassag==2
		nValCont	:= nValCont + sf3->f3_valcont
		nBASEICM2	:= SF3->F3_BASEICM
		nALIQICM2	:= SF3->F3_ALIQICM
		nVALICM2	:= SF3->F3_VALICM
		nICMISENT2	:= SF3->F3_ISENICM
		nICMOUTRA2	:= SF3->F3_OUTRICM
		Case nPassag==3
		nValCont	:= nValCont + sf3->f3_valcont
		nBASEICM3	:= SF3->F3_BASEICM
		nALIQICM3	:= SF3->F3_ALIQICM
		nVALICM3	:= SF3->F3_VALICM
		nICMISENT3	:= SF3->F3_ISENICM
		nICMOUTRA3	:= SF3->F3_OUTRICM
		Case nPassag==4
		nValCont	:= nValCont + sf3->f3_valcont
		nBASEICM4	:= SF3->F3_BASEICM
		nALIQICM4	:= SF3->F3_ALIQICM
		nVALICM4	:= SF3->F3_VALICM
		nICMISENT4	:= SF3->F3_ISENICM
		nICMOUTRA4	:= SF3->F3_OUTRICM
		Case nPassag==5
		nValCont	:= nValCont + sf3->f3_valcont
		nBASEICM5	:= SF3->F3_BASEICM
		nALIQICM5	:= SF3->F3_ALIQICM
		nVALICM5	:= SF3->F3_VALICM
		nICMISENT5	:= SF3->F3_ISENICM
		nICMOUTRA5	:= SF3->F3_OUTRICM
		EndCase
		MsUnLock()
		nPassag++
		Select SF3
		Skip
	Enddo
	Select Trb
	Reclock("TRB",.f.)
	trb->VALCONT	:= STRZERO(nVALCONT*100,12)
	trb->BASEICM2	:= STRZERO(nBASEICM2*100,12)
	trb->ALIQICM2	:= STRZERO(nALIQICM2*10000,06)
	trb->VALICM2	:= STRZERO(nVALICM2*100,12)
	trb->ICMISENT2	:= STRZERO(nICMISENT2*100,12)
	trb->ICMOUTRA2	:= STRZERO(nICMOUTRA2*100,12)

	trb->BASEICM3	:= STRZERO(nBASEICM3*100,12)
	trb->ALIQICM3	:= STRZERO(nALIQICM3*10000,06)
	trb->VALICM3	:= STRZERO(nVALICM3*100,12)
	trb->ICMISENT3	:= STRZERO(nICMISENT3*100,12)
	trb->ICMOUTRA3	:= STRZERO(nICMOUTRA3*100,12)

	trb->BASEICM4	:= STRZERO(nBASEICM4*100,12)
	trb->ALIQICM4	:= STRZERO(nALIQICM4*10000,06)
	trb->VALICM4	:= STRZERO(nVALICM4*100,12)
	trb->ICMISENT4	:= STRZERO(nICMISENT4*100,12)
	trb->ICMOUTRA4	:= STRZERO(nICMOUTRA4*100,12)

	trb->BASEICM5	:= STRZERO(nBASEICM5*100,12)
	trb->ALIQICM5	:= STRZERO(nALIQICM5*10000,06)
	trb->VALICM5	:= STRZERO(nVALICM5*100,12)
	trb->ICMISENT5	:= STRZERO(nICMISENT5*100,12)
	trb->ICMOUTRA5	:= STRZERO(nICMOUTRA5*100,12)

	MsUnLock()

	if cCf < "5"
		Select SD1
		dbSetOrder(1)
		Seek xfilial()+cDocEnt  // Verificar Fornecedor
		Do while !eof() .and. sd1->(d1_doc+d1_serie+d1_fornece+d1_loja)==cDocEnt
			cProd	:= sd1->d1_cod
			nBase	:= sd1->d1_baseipi
			nTotal	:= iif(nBase=0,sd1->d1_total,0)
			nIPI	:= sd1->d1_valipi
			Select SB1
			dbSetOrder(1)
			Seek xFilial()+cProd
			Select SYD
			dbSetOrder(1)
			Seek xFilial()+sb1->b1_posipi
			cNCM  := sb1->b1_posipi
			cNCM1 := left(cNCM,at(".",cNCM)-1)+substr(cNCM,at(".",cNCM)+1,10)
			cNCM2 := left(cNCM1,at(".",cNCM1)-1)+substr(cNCM1,at(".",cNCM1)+1,10)
			if eof()
				Seek xFilial()+cNCM2
			endif
//			if val(cNCM2)<>0
				Select Trb
				Reclock("TRB",.t.)
				trb->TIPOREG	:= "R2"
				trb->NCM	:= cNCM2
				trb->DESCRICAO	:= syd->yd_desc_p
				trb->BASEIPI2	:= STRZERO(val(BaseIPI2)+(nBASE*100),12)
				trb->IPI2    	:= STRZERO(val(IPI2)+(nIPI*100),12)
				trb->ISENTOIP2 	:= STRZERO(val(IsentoIP2)+(nTotal*100),12)
//			Endif
			Select SD1
			skip
		enddo
	else
		Select SD2
		dbSetOrder(3)
		Seek xfilial()+cDoc
		Do while !eof() .and. sd2->d2_doc==cDoc
			cProd	:= sd2->d2_cod
			nBase	:= iif(sd2->d2_valipi<>0,sd2->d2_baseipi,0)
			nIsen	:= iif(sd2->d2_valipi=0 ,sd2->d2_total,0)
			nTotal	:= iif(nBase=0,sd2->d2_total,0)
			nIPI	:= sd2->d2_valipi
			Select SB1
			dbSetOrder(1)
			Seek xFilial()+cProd
			Select SYD
			dbSetOrder(1)
			Seek xFilial()+sb1->b1_posipi
			if eof()
				cDescIPI := sb1->b1_desc
			else
				cDescIPI := syd->yd_desc_p
			endif
			if at(".",sb1->b1_posipi)<>0
			cNCM  := sb1->b1_posipi
			cNCM1 := left(cNCM,at(".",cNCM)-1)+substr(cNCM,at(".",cNCM)+1,10)
			cNCM2 := left(cNCM1,at(".",cNCM1)-1)+substr(cNCM1,at(".",cNCM1)+1,10)
			else
			cNCM2 := sb1->b1_posipi
			Endif
			Select Trb
			if eof()
				Seek xFilial()+cNCM2
			endif
//			if val(cNCM2)<>0
				Select Trb
				goto reccount()
				if TIPOREG="R2" .and. NCM=syd->yd_tec
					Reclock("TRB",.f.)
				else
					Reclock("TRB",.t.)
				Endif
				trb->TIPOREG	:= "R2"
				trb->NCM	:= cNCM2
				trb->DESCRICAO	:= cDescIPI
				trb->BASEIPI2	:= STRZERO(val(BaseIPI2)+(nBASE*100),12)
				trb->IPI2    	:= STRZERO(val(IPI2)+(nIPI*100),12)
				trb->ISENTOIP2	:= STRZERO(val(IsentoIP2)+(nIsen*100),12)
//			Endif
			Select SD2
			skip
		enddo
	endif

	Select SF3

Enddo
//Select DIPI
//cNom := "\DIPI"+left(dtos(mv_par01),4)+iif(mv_par03==1,".E",".S")+strzero(month(mv_par01),2)
//cNom1:= "\DIPI"+substr(dtos(mv_par01),5,2)+iif(mv_par03==1,"E","S")
//copy to &cNom SDF
//copy to &cNom1 
Select TRB
cNom := "\LEAO"+left(dtos(mv_par01),4)+iif(mv_par03==1,".E",".S")+strzero(month(mv_par01),2)
cNom1:= "\LEAO"+substr(dtos(mv_par01),5,2)+iif(mv_par03==1,"E","S")
//copy to &cNom SDF
copy to &cNom1 


// Novo processo de geracao de TXT

cNom := "\L"+left(dtos(mv_par01),4)+iif(mv_par03==1,".E",".S")+strzero(month(mv_par01),2)
Private nHdl    := fCreate(cNom)

Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif
dbGoTop()
Do while !eof()
	if TIPOREG == "R1"
	cLin := ""
	cLin += PADR( TIPOREG  ,002) 
	cLin += PADR( EMISSAO  ,004) 
	cLin += PADR( DIGITACAO,004) 
	cLin += PADR( INT      ,002) 
	cLin += PADR( ESPECIE  ,003) 
	cLin += PADR( SERIE    ,003) 
	cLin += PADR( NUMERO   ,006) 
	cLin += PADR( ATENUM   ,006) 
	cLin += PADR( CFOP     ,005) 
	cLin += PADR( VALCONT  ,012) 
	cLin += PADR( BASEICM1 ,012) 
	cLin += PADR( ALIQICM1 ,006) 
	cLin += PADR( VALICM1  ,012) 
	cLin += PADR( ICMISENT1,012) 
	cLin += PADR( ICMOUTRA1,012) 
	cLin += PADR( BASEICM2 ,012) 
	cLin += PADR( ALIQICM2 ,006) 
	cLin += PADR( VALICM2  ,012) 
	cLin += PADR( ICMISENT2,012) 
	cLin += PADR( ICMOUTRA2,012) 
	cLin += PADR( BASEICM3 ,012) 
	cLin += PADR( ALIQICM3 ,006) 
	cLin += PADR( VALICM3  ,012) 
	cLin += PADR( ICMISENT3,012) 
	cLin += PADR( ICMOUTRA3,012) 
	cLin += PADR( BASEICM4 ,012) 
	cLin += PADR( ALIQICM4 ,006) 
	cLin += PADR( VALICM4  ,012) 
	cLin += PADR( ICMISENT4,012) 
	cLin += PADR( ICMOUTRA4,012) 
	cLin += PADR( BASEICM5 ,012) 
	cLin += PADR( ALIQICM5 ,006) 
	cLin += PADR( VALICM5  ,012) 
	cLin += PADR( ICMISENT5,012) 
	cLin += PADR( ICMOUTRA5,012) 
	cLin += PADR( BASEIPI  ,012) 
	cLin += PADR( VALIPI   ,012) 
	cLin += PADR( IPIISENTO,012) 
	cLin += PADR( IPIOUTRAS,012) 
	cLin += PADR( IPINAOAPR,012) 
	cLin += PADR( ICMSFONTE,012) 
	cLin += PADR( DESCONTO ,012) 
	cLin += PADR( VALVISTA ,012) 
	cLin += PADR( VALPRAZO ,012) 
	cLin += PADR( ISENTOPIS,012) 
	cLin += PADR( CONTRIB  ,001) 
	cLin += PADR( TPNOTA   ,002) 
	cLin += PADR( CODCONT  ,002) 
	cLin += PADR( OBS      ,014) 
	cLin += PADR( CNPJ     ,014) 
	cLin += PADR( INSCR    ,016) 
	cLin += PADR( RAZAOSOC ,035) 
	cLin += PADR( CONTA    ,018) 
	cLin += PADR( UF       ,002) 
	cLin += PADR( CODMUN   ,004) 
	cLin += PADR( VAGO     ,050) 
	cLin += cEOL

	Else // TipoReg="R2"
	cLin := ""
	cLin += PADR( TIPOREG  ,002 ) 
	cLin += PADR( VAGO     ,008 ) 
	cLin += PADR( NCM      ,010 ) 
	cLin += PADR( DESCRICAO,025 ) 
	cLin += PADR( BASEIPI2 ,012 ) 
	cLin += PADR( IPI2     ,012 ) 
	cLin += PADR( ISENTOIP2,012 ) 
	cLin += PADR( VAGO1    ,050 ) 
	cLin += cEOL

	Endif

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif

	skip
Enddo


fClose(nHdl)

// Final do novo TXT

MsgBox ("Arquivo gerado com sucesso "+cNom,"Informa‡Æo","INFO")

Return

*************************
Static Function CalcIPI()
*************************

Select SD2
dbSetOrder(3)
Seek xfilial()+cDoc
nBaseIPI := nOutras := 0
Do while !eof() .and. sd2->d2_doc==cDoc
	if d2_valipi=0
		nOutras += d2_total
	else
		nBaseIpi += d2_total
	endif
	skip
Enddo



/*
// Arquivo para geração de informações contábeis

                 ***        LAYOUT PARA IMPORTACAO DO FATURAMENTO/COMPRAS    (P/ NOVOS CFOP) ***                 FOLHA 1/2

  << REGISTRO MESTRE (Tipo 01) >>

  campo              formato         tamho posicao   descricao
  --------------------------------------------------------------------------------------------------------------------------------
  |TIPO REGISTRO    | XX             | 02 |  01 | Tipo de registro. Constante  R1  
  |EMISSAO NOTA     | 9999           | 04 |  03 | DDMM dia e mes da emissao da nota ex: 2509
  |DATA CIRCULACAO  | 9999           | 04 |  07 | Data da Entrada/Saida da mercadoria DDMM
  |DIA DA INTEGRACAO| 99             | 02 |  11 | (opcional) permite imprimir livros parciais conf esse dia p/conferencia(lote)
  |ESPECIE          | XXX            | 03 |  13 | Especie ex.: NF NFF PDV CMR ECF
  |SERIE            | XXX            | 03 |  16 | Serie da nota
  |NUMERO           | 999999         | 06 |  19 | Numero da Nota
  |ATE NUMERO       | 999999         | 06 |  25 | Para quem deseja agrupar notas
  |CODIGO FISCAL    | XXXXX          | 05 |  31 | CFOP. Tanto faz digitar com ponto ou sem ponto ex.: 5.101 ou 5101
  |VALOR CONTABIL   | 9999999999V99  | 12 |  36 | Valor Total da Nota
  |BASE1 ICMS       | 9999999999V99  | 12 |  48 | Valor das mercadorias tributadas de icms
  |ALIQ1 ICMS       | 99V9999        | 06 |  60 | Aliq.icms 18 12 2.1526  3.1008 etc
  |IMPOSTO1 ICMS    | 9999999999V99  | 12 |  66 | imposto de icms
  |ISENTO1 ICMS     | 9999999999V99  | 12 |  78 | Valor das mercadorias isentas de icms
  |OUTRAS1 ICMS     | 9999999999V99  | 12 |  90 | Valor das mercadorias nem tributadas nem isentas
  |BASE2 ICMS       | 9999999999V99  | 12 |  102| Valor das mercadorias tributadas de icms
  |ALIQ2 ICMS       | 99V9999        | 06 |  114| Aliq.icms 18 12 2.1526  3.1008 etc
  |IMPOSTO2 ICMS    | 9999999999V99  | 12 |  120| imposto de icms
  |ISENTO2 ICMS     | 9999999999V99  | 12 |  132| Valor das mercadorias isentas de icms
  |OUTRAS2 ICMS     | 9999999999V99  | 12 |  144| Valor das mercadorias nem tributadas nem isentas
  |BASE3 ICMS       | 9999999999V99  | 12 |  156| Valor das mercadorias tributadas de icms
  |ALIQ3 ICMS       | 99V9999        | 06 |  168| Aliq.icms 18 12 2.1526  3.1008 etc
  |IMPOSTO3 ICMS    | 9999999999V99  | 12 |  174| imposto de icms
  |ISENTO3 ICMS     | 9999999999V99  | 12 |  186| Valor das mercadorias isentas de icms
  |OUTRAS3 ICMS     | 9999999999V99  | 12 |  198| Valor das mercadorias nem tributadas nem isentas
  |BASE4 ICMS       | 9999999999V99  | 12 |  210| Valor das mercadorias tributadas de icms
  |ALIQ4 ICMS       | 99V9999        | 06 |  222| Aliq.icms 18 12 2.1526  3.1008 etc
  |IMPOSTO4 ICMS    | 9999999999V99  | 12 |  228| imposto de icms
  |ISENTO4 ICMS     | 9999999999V99  | 12 |  240| Valor das mercadorias isentas de icms
  |OUTRAS4 ICMS     | 9999999999V99  | 12 |  252| Valor das mercadorias nem tributadas nem isentas
  |BASE5 ICMS       | 9999999999V99  | 12 |  264| Valor das mercadorias tributadas de icms
  |ALIQ5 ICMS       | 99V9999        | 06 |  276| Aliq.icms 18 12 2.1526  3.1008 etc
  |IMPOSTO5 ICMS    | 9999999999V99  | 12 |  282| imposto de icms
  |ISENTO5 ICMS     | 9999999999V99  | 12 |  294| Valor das mercadorias isentas de icms
  |OUTRAS5 ICMS     | 9999999999V99  | 12 |  306| Valor das mercadorias nem tributadas nem isentas
  |BASE IPI         | 9999999999V99  | 12 |  318| Valor das mercadorias tributadas de ipi
  |IMPOSTO IPI      | 9999999999V99  | 12 |  330| Valor total dos impostos de IPI
  |ISENTOS IPI      | 9999999999V99  | 12 |  342| Valor das mercadorias isentas de IPI
  |OUTRAS IPI       | 9999999999V99  | 12 |  354| Valor das mercadorias nao tributadas nem isentas de IPI
  |IPI NAO APROVEITV| 9999999999V99  | 12 |  366| Valor do ipi nao aproveitavel se houver (somente para industrias)
  |ICMS NA FONTE    | 9999999999V99  | 12 |  378| Valor do icms na fonte se houver
  |DESCONTO         | 9999999999V99  | 12 |  390| Valor do desconto de houver
  |VALOR A VISTA    | 9999999999V99  | 12 |  402| (opcional) Valor da Compra/Venda a vista p/ quem quer contabilizar
  |VALOR A PRAZO    | 9999999999V99  | 12 |  414| Vlr.Compras/Vendas a prazo p/contabilizar (perceba que o tamanho do campo e' 11)
  |ISENTO PIS       | 9999999999V99  | 12 |  426| Nas compras/vendas ou devolucoes das mesmas, a base isenta de pis se houver
  |CONTRIBUINTE     | 9              | 01 |  438| Nas saidas p/outro estado responda 0 (p/contribuinte) ou 1 (p/Nao contribuinte)
  |TIPO DA NOTA     | 99             | 02 |  439| Pergunte ao operador do sistema da Contmatic
  |COD CONTABIL     | 99             | 02 |  441| Opcional, se deseja contabilizar
  |OBS LIVRE        | XXXXXXXXXXXXXX | 14 |  443| opcional, uma frase para sair impressa na observacao do livro
  |CGC              | XXXXXXXXXXXXXX | 14 |  457| CNPJ do emitente/destinatario
  |INSCR.ESTADUAL   | X------------X | 16 |  471| Inscricao Estadual do emitente/destinatario
  |RAZAO SOCIAL     | X------------X | 35 |  487| Razao Social do emitente/destinatario
  |CONTA CTBL FORNEC| X------------X | 18 |  522| opcional. Conta contabil do Fornecedor/Destinatario se contabilizacao analitica
  |UF               | XX             | 02 |  540| Sigla da unidade da federacao do emitente/destinatario
  |No.DO MUNICIPIO  | 9999           | 04 |  542| No.do municipio se quiser verso de Dipam
  |Vago             | x------------X | 50 |  546| vago preencher com brancos
  --------------------------------------------------------------------------------------------------------------------------------




                 ***        LAYOUT PARA IMPORTACAO DO FATURAMENTO/COMPRAS    (P/ NOVOS CFOP) ***                 FOLHA 2/2

  << REGISTRO DIPI (Tipo 02) >>

  campo              formato         tamho posicao   descricao
  --------------------------------------------------------------------------------------------------------------------------------
  |TIPO REGISTRO    | XX             | 02 |  01 | Tipo de registro. Constante  R2  
  |VAGO             | XXXXXXXX       | 08 |  03 | vAGO Preencher com brancos
  |NCM              | XXXXXXXXXX     | 10 |  11 | Codigo da Mercadoria conf.tabela NCM 
  |Descricao        | X------------X | 25 |  21 | Descricao Mercadoria conf.Tabela NCM  
  |Base IPI         | 999999999V99   | 12 |  46 | Base ipi dessa mercadoria
  |IPI              | 999999999V99   | 12 |  58 | ipi dessa mercadoria
  |isento IPI       | 999999999V99   | 12 |  70 | isento ipi dessa mercadoria
  |Vago             | x------------X | 50 |  82 | vago preencher com brancos
  --------------------------------------------------------------------------------------------------------------------------------






  NOME DO ARQUIVO
    NOTAS DE SAIDAS (VENDAS)
    ------------------------
      apelido.Snn
      onde apelido e' o nome que o operador do Contmatic utiliza para acessar e escriturar as empresas
      Snn : a letra S significa que as notas sao de saidas
            nn -> troque pelo mes base das notas, isto e', cada arquivo contem todas as notas de um determinado mes
                  e somente de um mes.

    NOTAS DE ENTRADAS (COMPRAS)
    ---------------------------
      apelido.Enn
      onde apelido e' o nome que o operador do Contmatic utiliza para acessar e escriturar as empresas
      Enn : a letra E significa que as notas sao de Entradas
            nn -> troque pelo mes base das notas, isto e', cada arquivo contem todas as notas de um determinado mes
                  e somente de um mes.

   EXEMPLO: O nome do arquivo p/ empresa cujo apelido seja 001 e que contenha as notas de SAIDA de abril, deve ser: 001.S04


   DIRETORIO: O diretorio padrao inicial ‚ c:\CONTFAT\ (mas o operador pode trocar)

   PADRAO : ASCII (texto). Os valores nao devem ter ponto decimal, pois o Contmatic considera como casas decimais 
            o que vem depois da letra V   
           XXX    -> Alfanumerico
           999    -> Numerico inteiro
           999V99 -> Numerico onde as 3 primeiras posicoes eh a parte inteira e as 2 ultimas decimais
           99V9999 -> Numerico onde as 2 primeiras posicoes eh a parte inteira e as 4 ultimas decimais
          

   Os registros devem terminar com CRLF (Carriage Return + Line Feed "Asc 13+10")


  Nao eh obrigatorio o registro tipo R2 (DIPi). Este tipo eh necessario somente para industrias, nos cfops que exigem.
  Então voce pode usar esse lay-lout para atender tanto empresas que usam a dipi como as outras. Resumindo esse
  lay-out eh o que eu recomendo. O outro(mais antigo) deixei no programa para manter.
  Mesmo aqueles que nao querem integrar dipi pode usar esse lay-out. Apenas nao criar tipo R2

  Para cada nota fiscal deve-se criar o tipo R1
  Se voce for gerar os registros R2(dipi) eles deve ser precedido do seu respectivo R1
  Para cada nota pode existir varios registros tipo R2. 
  Exemplo suponha 3 notas A,B,C sendo a nota A com dois itens de DIPI, a nota B com nenhum e a nota C com 1 item de dipi
  o arquivo ficaria assim:
    
                              TIPO R1 (NOTA A)
                              TIPO R2 (primeiro item de dipi da nota A)
                              TIPO R2 (segundo  item de dipi da nota A)
                              TIPO R1 (NOTA B)
                              TIPO R1 (NOTA C)
                              TIPO R2 (primeiro item de dipi da nota C)

  


  EXPLICACOES DE ALGUNS CAMPOS QUE VOCE DEVE ESTAR ATENTO:
  Exporte CNPJ, Razao Social, inscricao estadual tanto dos fornecedore como dos destinatarios pois o governo
  exige isso para que eu possa fazer o arquivo texto que eles pedem. Alem do que se o cliente fizer contabilidade
  analitica eu preciso dessas informacoes.
   
  CONTA CTBL FORNEC ->  Se voce faz contabilidade analitica, eu preciso da conta contabil do
                       fornecedor ou destinatario.

  VALOR A VISTA     -> o valor da compra ou venda a vista se voce deseja que meu sistema contabilize.

  VALOR A PRAZO    -> se deseja que o sistema contabilize.

  CONTRIBUINTE     -> Para que eu possa fazer a ginter nas vendas para outro estado coloque
                       0 se for contribuinte
                       1 se for Nao contribuinte


/*
