#include "rwmake.ch"  

User Function Exportfis()   // Exportar arquivos Fiscal

if !Pergunte ("EXPORTFIS",.T.)
	Return
endif
Processa( {|| RunProc() } )

static function RunProc()

	Select SF2
	copy structure to &"\transf\sf2010" //+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sf2010","XF2", Nil, .F. )
	Select SD2
	copy structure to &"\transf\sd2010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sd2010","XD2", Nil, .F. )
	Select SC5
	copy structure to &"\transf\sc5010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sc5010","XC5", Nil, .F. )
	Select SC6
	copy structure to &"\transf\sc6010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sc6010","XC6", Nil, .F. )
	Select SB1
	copy structure to &"\transf\sb1010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sb1010","Xb1", Nil, .F. )
	Select SB5
	copy structure to &"\transf\sb5010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sb5010","Xb5", Nil, .F. )
	Select SA1
	copy structure to &"\transf\sa1010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sa1010","Xa1", Nil, .F. )
	Select SA2
	copy structure to &"\transf\sa2010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sa2010","Xa2", Nil, .F. )
	Select SF4
	copy structure to &"\transf\sf4010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sf4010","Xf4", Nil, .F. )
	Select SF3
	copy structure to &"\transf\sf3010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sf3010","Xf3", Nil, .F. )
	Select SFT
	copy structure to &"\transf\sfT010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sfT010","XfT", Nil, .F. )
	Select CD2
	copy structure to &"\transf\cd2010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\cd2010","Xcd2", Nil, .F. )
	Select SE1
	copy structure to &"\transf\se1010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\se1010","Xe1", Nil, .F. )
	Select SF1
	copy structure to &"\transf\sf1010" //+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sf1010","XF1", Nil, .F. )
	Select SD1
	copy structure to &"\transf\sd1010"//+dtos(mv_par01)
	dbUseArea( .T.,,"\transf\sd1010","XD1", Nil, .F. )

if mv_par03 <> 2

	Select SF2
	dbSetOrder(3)
	set softseek on 
	seek xFilial()+" "+dtos(mv_par01)
	set softseek off
	cTempF2 := CriaTrab(nil,.f.)
	ProcRegua(50)
	do while !eof() .and. f2_emissao >= mv_par01 .and. f2_emissao <= mv_par02
		IncProc(sf2->f2_doc)
		Select SD2
		dbSetOrder(3)
		seek xFilial()+sf2->f2_doc
		Do while !eof() .and. d2_doc=sf2->f2_doc
			If D2_CF<>'000' .and. d2_emissao >= mv_par01
				cTempD2 := CriaTrab(nil,.f.)
				copy to &cTempD2 next 1
			else
				skip
				loop
			Endif
			Select XD2
			append from &cTempD2

//        	GravaPed()
			Select SD2
            skip
		Enddo

       	GravaFin()
		
		Select SF2
		copy to &cTempF2 next 1
		Select XF2
		append from &cTempF2
		Select SF2
		skip
	enddo
endif

if mv_par03 <> 1
	Select Sf3
	//F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)
	set softseek on
	cChave := DTOS(mv_par01)
	seek xFilial()+cChave
	set softseek off
	ProcRegua(50)
	Do while !eof() .and. F3_ENTRADA >= MV_PAR01 .AND. F3_ENTRADA <= MV_PAR02
		if left(f3_cfo,1)>='5' .or. f3_observ='NF CANCELADA'
			skip
			loop
		endif
		IncProc("Entradas"+dtoc(sf3->entrada))
		cTempf3 := CriaTrab(nil,.f.)
		copy to &cTempf3 next 1
		Select Xf3
		append from &cTempf3
		Select Sf3
		skip
	Enddo
	
	Select Sft
	dbSetOrder(2)
	//FT_FILIAL+FT_TIPOMOV+DTOS(FT_ENTRADA)+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
	cChave := DTOS(mv_par01)
	seek xFilial()+"E"+cChave
	Do while !eof() .and. FT_ENTRADA >= MV_PAR01 .AND. FT_ENTRADA <= MV_PAR02
		if left(ft_cfo,1)>='5' .or. ft_observ='NF CANCELADA'
			skip
			loop
		endif
		cTempft := CriaTrab(nil,.f.)
		copy to &cTempft next 1
		Select Xft
		append from &cTempft
		Select Sft
		skip
	Enddo
Endif

Select XF2
COPY TO \transf\sf2010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sf2010.Dtc", "D:\P12\data\transf", .F. )
use
Select XD2
COPY TO \transf\sd2010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sd2010.Dtc", "D:\P12\data\transf", .F. )
use
Select XC5
COPY TO \transf\sc5010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sc5010.Dtc", "D:\P12\data\transf", .F. )
use
Select XC6
COPY TO \transf\sc6010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sc6010.Dtc", "D:\P12\data\transf", .F. )
use
Select XB1
COPY TO \transf\sb1010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sb1010.Dtc", "D:\P12\data\transf", .F. )
use
Select XB5
COPY TO \transf\sb5010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sb5010.Dtc", "D:\P12\data\transf", .F. )
use
Select XA1
COPY TO \transf\sa1010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sa1010.Dtc", "D:\P12\data\transf", .F. )
use
Select XA2
COPY TO \transf\sa2010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sa2010.Dtc", "D:\P12\data\transf", .F. )
use
Select XF4
COPY TO \transf\sf4010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sf4010.Dtc", "D:\P12\data\transf", .F. )
use
Select XF3
COPY TO \transf\sf3010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sf3010.Dtc", "D:\P12\data\transf", .F. )
use
Select XFT
COPY TO \transf\sft010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sft010.Dtc", "D:\P12\data\transf", .F. )
use
Select xCD2
COPY TO \transf\cd2010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\cd2010.Dtc", "D:\P12\data\transf", .F. )
use
Select xE1
COPY TO \transf\se1010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\se1010.Dtc", "D:\P12\data\transf", .F. )
use
Select XF1
COPY TO \transf\sf1010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sf1010.Dtc", "D:\P12\data\transf", .F. )
use
Select XD1
COPY TO \transf\sd1010 VIA "CTREECDX"
bOk := CpyS2T( "\transf\sd1010.Dtc", "D:\P12\data\transf", .F. )
use


Static Function GravaPed()

Select SC5
dbSetOrder(1)
seek xFilial()+sd2->d2_pedido
cTempC5 := CriaTrab(nil,.f.)
copy to &cTempC5 next 1
Select XC5
append from &cTempC5
Select SC6
seek xFilial()+sd2->(d2_pedido+d2_itempv)
Do while !eof() .and. sd2->(d2_pedido+d2_itempv)=sc6->(c6_num+c6_item)
	cTempC6 := CriaTrab(nil,.f.)
	copy to &cTempC6 next 1
	Select XC6
	append from &cTempC6
	Select SC6
	skip
Enddo

Select SB1
dbSetOrder(1)
seek xFilial()+sd2->d2_cod
cTempb1 := CriaTrab(nil,.f.)
copy to &cTempb1 next 1
Select XB1
append from &cTempb1

Select SB5
dbSetOrder(1)
seek xFilial()+sd2->d2_cod
cTempb5 := CriaTrab(nil,.f.)
copy to &cTempb5 next 1
Select XB5
append from &cTempb5

if sd2->d2_tipo$"B*D"
	Select SA2
	dbSetOrder(1)
	seek xFilial()+sd2->(d2_cliente+d2_loja)
	cTempa2 := CriaTrab(nil,.f.)
	copy to &cTempa2 next 1
	Select XA2
	append from &cTempA2
else
	Select SA1
	dbSetOrder(1)
	seek xFilial()+sd2->(d2_cliente+d2_loja)
	cTempa1 := CriaTrab(nil,.f.)
	copy to &cTempa1 next 1
	Select XA1
	append from &cTempA1
endif

Select SF4
dbSetOrder(1)
seek xFilial()+sd2->d2_tes
cTempf4 := CriaTrab(nil,.f.)
copy to &cTempf4 next 1
Select Xf4
append from &cTempf4

Static Function GravaFin() // SE1

Select SE1
dbSetOrder(1)
//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
cChave := sf2->(f2_SERIE+f2_DOC+f2_CLIENTE+f2_LOJA)
seek xFilial()+cChave
Do while !eof() .and. cChave = se1->(E1_PREFIXO+E1_NUM)
	cTempe1 := CriaTrab(nil,.f.)
	copy to &cTempe1 next 1
	Select Xe1
	append from &cTempe1
	Select SE1
	skip
Enddo

Select Sf3
//F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)
cChave := DTOS(SD2->D2_EMISSAO)+sd2->(d2_DOC+d2_SERIE+D2_CLIENTE+D2_LOJA)
seek xFilial()+cChave
Do while !eof() .and. cChave = dtos(sf3->f3_entrada)+sf3->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)
	cTempf3 := CriaTrab(nil,.f.)
	copy to &cTempf3 next 1
	Select Xf3
	append from &cTempf3
	Select Sf3
	skip
Enddo

Select Sft
dbSetOrder(2)
//FT_FILIAL+FT_TIPOMOV+DTOS(FT_ENTRADA)+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
cChave := DTOS(SD2->D2_EMISSAO)+sd2->(d2_SERIE+d2_DOC+D2_CLIENTE+D2_LOJA)
seek xFilial()+"S"+cChave
Do while !eof() .and. cChave = DTOS(FT_ENTRADA)+sft->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA)
	cTempft := CriaTrab(nil,.f.)
	copy to &cTempft next 1
	Select Xft
	append from &cTempft
	Select Sft
	skip
Enddo

Select CD2
dbSetOrder(1)
//CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO+CD2_IMP
cChave := sd2->(d2_SERIE+d2_DOC+D2_CLIENTE+D2_LOJA+d2_item+d2_cod)
seek xFilial()+"S"+cChave
Do while !eof() .and. cChave = cd2->(CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO)
	cTempcd2 := CriaTrab(nil,.f.)
	copy to &cTempcd2 next 1
	Select Xcd2
	append from &cTempcd2
	Select CD2
	skip
Enddo

