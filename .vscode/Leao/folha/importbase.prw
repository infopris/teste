#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/01
#INCLUDE "TOPCONN.CH"

User Function IMPORTBASE()        // Importa base

dbUseArea( .T.,,"\sr0.dbf", "TRB", Nil, .F. )
cTemp := CriaTrab(nil,.f.)
Index on R0_Mat to &cTemp
Select SR0
dbgotop()
do while !eof()
	if !empty(R0_MEIO)
		skip
		loop
	endif
	Select Trb
	seek sr0->r0_mat
	Select SR0      
	if rlock()
	sr0->r0_meio := trb->R0_meio
	endif
	skip
enddo                           
return
/*
dbUseArea( .T.,,"\spg-jun15.dbf", "TRB", Nil, .F. )
copy to \x  next 1
index on PG_MAT+dtos(PG_DATA)+str(PG_HORA) to \trb 
//copy to \x3          
dbUseArea( .T.,,"\x.dbf", "TRB1", Nil, .F. )
dbgotop()
if rlock()
 delete
endif
Select TRB
dbgotop()
do while !eof()
	x:=PG_MAT+dtos(PG_DATA)
	x1 :=PG_HORA
	lvazio := .t.      
	if x='592   20150525'
		a=1
	endif
	do while x=PG_MAT+dtos(PG_DATA) .and. x1=PG_HORA .and. !eof()
		if !empty(PG_TPMARCA) .or. PG_FLAG="M"
			lvazio := .f.
			copy to \x2 next 1
			skip
			loop
		endif
		copy to \x1 next 1  
		skip
	enddo
	Select trb1
	if lVazio
		append from \x1
	else
		append from \x2
	endif
	Select trb
Enddo
select trb1
copy to \xx
Return

Processa( {|| RunProc() } )
Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RunProc   ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa o Processamento                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunProc()

if !MsgBox ("Confirma processamento ?","Escolha","YESNO")
    Return
endif


ProcRegua(81)

Select ct0
if reccount()=0
	IncProc()
	Append from \data\bkp\ct0010.dbf
endif
Select ct5
if reccount()=0
	IncProc()
	Append from \data\bkp\ct5010.dbf
endif
Select cto
if reccount()=0
	IncProc()
	Append from \data\bkp\cto010.dbf
endif
Select ctt
if reccount()=0
	IncProc()
	Append from \data\bkp\ctt010.dbf
endif
Select cva
if reccount()=0
	IncProc()
	Append from \data\bkp\cva010.dbf
endif
Select cvg
if reccount()=0
	IncProc()
	Append from \data\bkp\cvg010.dbf
endif
Select cvj
if reccount()=0
	IncProc()
	Append from \data\bkp\cvj010.dbf
endif
Select cw0
if reccount()=0
	IncProc()
	Append from \data\bkp\cw0010.dbf
endif
Select la1
if reccount()=0
	IncProc()
	Append from \data\bkp\la1010.dbf
endif
Select rc2
if reccount()=0
	IncProc()
	Append from \data\bkp\rc2010.dbf
endif
Select rc3
if reccount()=0
	IncProc()
	Append from \data\bkp\rc3010.dbf
endif
Select rc4
if reccount()=0
	IncProc()
	Append from \data\bkp\rc4010.dbf
endif
Select rc5
if reccount()=0
	IncProc()
	Append from \data\bkp\rc5010.dbf
endif
Select rca
if reccount()=0
	IncProc()
	Append from \data\bkp\rca010.dbf
endif
Select rcb
if reccount()=0
	IncProc()
	Append from \data\bkp\rcb010.dbf
endif
Select rcc
if reccount()=0
	IncProc()
	Append from \data\bkp\rcc010.dbf
endif
Select rce
if reccount()=0
	IncProc()
	Append from \data\bkp\rce010.dbf
endif
Select rcf
if reccount()=0
	IncProc()
	Append from \data\bkp\rcf010.dbf
endif
Select rcn
if reccount()=0
	IncProc()
	Append from \data\bkp\rcn010.dbf
endif
Select rd0
if reccount()=0
	IncProc()
	Append from \data\bkp\rd0010.dbf
endif
Select rdk
if reccount()=0
	IncProc()
	Append from \data\bkp\rdk010.dbf
endif
Select rfb
if reccount()=0
	IncProc()
	Append from \data\bkp\rfb010.dbf
endif
Select rfe
if reccount()=0
	IncProc()
	Append from \data\bkp\rfe010.dbf
endif
Select rg3
if reccount()=0
	IncProc()
	Append from \data\bkp\rg3010.dbf
endif
Select ses
if reccount()=0
	IncProc()
	Append from \data\bkp\ses010.dbf
endif
Select sp0
if reccount()=0
	IncProc()
	Append from \data\bkp\sp0010.dbf
endif
Select sp1
if reccount()=0
	IncProc()
	Append from \data\bkp\sp1010.dbf
endif
Select sp2
if reccount()=0
	IncProc()
	Append from \data\bkp\sp2010.dbf
endif
Select sp5
if reccount()=0
	IncProc()
	Append from \data\bkp\sp5010.dbf
endif
Select sp8
if reccount()=0
	IncProc()
	Append from \data\bkp\sp8010.dbf
endif
Select spa
if reccount()=0
	IncProc()
	Append from \data\bkp\spa010.dbf
endif
Select spb
if reccount()=0
	IncProc()
	Append from \data\bkp\spb010.dbf
endif
Select spc
if reccount()=0
	IncProc()
	Append from \data\bkp\spc010.dbf
endif
Select spe
if reccount()=0
	IncProc()
	Append from \data\bkp\spe010.dbf
endif
Select spf
if reccount()=0
	IncProc()
	Append from \data\bkp\spf010.dbf
endif
Select spg
if reccount()=0
	IncProc()
	Append from \data\bkp\spg010.dbf
endif
Select sph
if reccount()=0
	IncProc()
	Append from \data\bkp\sph010.dbf
endif
Select spi
if reccount()=0
	IncProc()
	Append from \data\bkp\spi010.dbf
endif
Select spj
if reccount()=0
	IncProc()
	Append from \data\bkp\spj010.dbf
endif
Select spk
if reccount()=0
	IncProc()
	Append from \data\bkp\spk010.dbf
endif
Select spl
if reccount()=0
	IncProc()
	Append from \data\bkp\spl010.dbf
endif
Select spm
if reccount()=0
	IncProc()
	Append from \data\bkp\spm010.dbf
endif
Select spn
if reccount()=0
	IncProc()
	Append from \data\bkp\spn010.dbf
endif
Select sps
if reccount()=0
	IncProc()
	Append from \data\bkp\sps010.dbf
endif
Select spt
if reccount()=0
	IncProc()
	Append from \data\bkp\spt010.dbf
endif
Select spu
if reccount()=0
	IncProc()
	Append from \data\bkp\spu010.dbf
endif
Select spv
if reccount()=0
	IncProc()
	Append from \data\bkp\spv010.dbf
endif
Select spx
if reccount()=0
	IncProc()
	Append from \data\bkp\spx010.dbf
endif
Select spy
if reccount()=0
	IncProc()
	Append from \data\bkp\spy010.dbf
endif
Select spz
if reccount()=0
	IncProc()
	Append from \data\bkp\spz010.dbf
endif
Select sq3
if reccount()=0
	IncProc()
	Append from \data\bkp\sq3010.dbf
endif
Select sqb
if reccount()=0
	IncProc()
	Append from \data\bkp\sqb010.dbf
endif
Select sr1
if reccount()=0
	IncProc()
	Append from \data\bkp\sr1010.dbf
endif
Select sr3
if reccount()=0
	IncProc()
	Append from \data\bkp\sr3010.dbf
endif
Select sr6
if reccount()=0
	IncProc()
	Append from \data\bkp\sr6010.dbf
endif
Select sr7
if reccount()=0
	IncProc()
	Append from \data\bkp\sr7010.dbf
endif
Select sr8
if reccount()=0
	IncProc()
	Append from \data\bkp\sr8010.dbf
endif
Select sra
if reccount()=0
	IncProc()
	Append from \data\bkp\sra010.dbf
endif
Select srb
if reccount()=0
	IncProc()
	Append from \data\bkp\srb010.dbf
endif
Select src
if reccount()=0
	IncProc()
	Append from \data\bkp\src010.dbf
endif
Select srd
if reccount()=0
	IncProc()
	Append from \data\bkp\srd010.dbf
endif
Select srf
if reccount()=0
	IncProc()
	Append from \data\bkp\srf010.dbf
endif
Select srg
if reccount()=0
	IncProc()
	Append from \data\bkp\srg010.dbf
endif
Select srj
if reccount()=0
	IncProc()
	Append from \data\bkp\srj010.dbf
endif
Select srk
if reccount()=0
	IncProc()
	Append from \data\bkp\srk010.dbf
endif
Select srm
if reccount()=0
	IncProc()
	Append from \data\bkp\srm010.dbf
endif
Select srn
if reccount()=0
	IncProc()
	Append from \data\bkp\srn010.dbf
endif
Select sro
if reccount()=0
	IncProc()
	Append from \data\bkp\sro010.dbf
endif
Select srq
if reccount()=0
	IncProc()
	Append from \data\bkp\srq010.dbf
endif
Select srr
if reccount()=0
	IncProc()
	Append from \data\bkp\srr010.dbf
endif
Select srv
if reccount()=0
	IncProc()
	Append from \data\bkp\srv010.dbf
endif
Select srw
if reccount()=0
	IncProc()
	Append from \data\bkp\srw010.dbf
endif
Select srx
if reccount()=0
	IncProc()
	Append from \data\bkp\srx010.dbf
endif
Select sry
if reccount()=0
	IncProc()
	Append from \data\bkp\sry010.dbf
endif
Select su7
if reccount()=0
	IncProc()
	Append from \data\bkp\su7010.dbf
endif
Select syp
if reccount()=0
	IncProc()
	Append from \data\bkp\syp010.dbf
endif
Select tmr
if reccount()=0
	IncProc()
	Append from \data\bkp\tmr010.dbf
endif





