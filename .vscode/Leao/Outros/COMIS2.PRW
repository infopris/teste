#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function COMIS2()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³COMIS2    ³ Autor ³ Luiz Eduardo          ³ Data ³ 30.11.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera comissao coordenador de vendas                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Sigafin                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

dDti:= date()
dDtf:= date()

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Rotina de Processamento"
@ 8,10 TO 84,222
@ 15,15 say "Data inicial : "
@ 15,55 get  dDti  SIZE 40,20
@ 30,15 say "Data Final   : "
@ 30,55 get  dDtf  SIZE 40,20

@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OkProc    ³ Autor ³ Ary Medeiros          ³ Data ³ 15.02.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Confirma o Processamento                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function OkProc()
Close(oDlg)
Processa( {|| RunProc() } )
Return

*-------------------------*
Static Function RunProc()
*-------------------------*

Select SE3
dbSetOrder(2)
Seek xFilial()+'2'
do while !eof() .and. left(e3_vend,1)=="2"
	if e3_emissao>=dDti .and. e3_emissao<=dDtf .and. rlock()
		dele
	endif
	skip
enddo
Seek xFilial()+'3'
do while !eof() .and. left(e3_vend,1)=="3"
	if e3_emissao>=dDti .and. e3_emissao<=dDtf .and. rlock() .and. val(e3_vend)<40
		dele
	endif
	skip
enddo
nRec := reccount()
goto nRec-2000
do while !eof()
	if e3_tipo="CH" .and. rlock()
		dele
	endif
	nRec:= recno()+1
	goto nRec
enddo

dbSetOrder(1)

if 1==2 // Não calcular mais comissões de Coordenadoras a partir de janeiro 2018
	dbGoTop()
	cTRBCOM := CriaTrab(nil,.f.)
	copy to &cTRBCOM for e3_emissao>=dDti .and. e3_emissao<=dDtf
	dbUseArea( .T.,,cTRBCOM,"TRBCOM", Nil, .F. )
	
	ProcRegua(reccount())
	x := 1
	goto x
	do while !eof()
		IncProc()
		Select SE1
		dbSetOrder(1)
		Seek xFilial()+TRBCOM->(e3_prefixo+e3_num)
		
		if e1_naturez='106'.and. e1_comis1<>0 .and. e1_tipo='CH' .and. rlock()
			se1->e1_comis1 := 0
		endif
		
		Select SC5
		dbSetOrder(1)
		Seek xFilial()+se1->e1_pedido
		Select SA3
		if sc5->c5_super#space(6)
			cSuper := sc5->c5_super
		else
			seek xFilial()+TRBCOM->e3_vend
			if se1->e1_emissao<=a3_altsupe
				cSuper := sa3->a3_oldsupe
			else
				cSuper := sa3->a3_super
			endif
		Endif
		seek xFilial()+cSuper
		Select TRBCOM
		if (sa3->a3_comis==0 .or. sa3->(eof())) .and. rlock()
			delete
		endif
		if rlock() .and. sa3->a3_comis#0 .AND. year(se1->e1_emissao)<2018
			TRBCOM->e3_vend := cSuper
			TRBCOM->e3_porc := sa3->a3_comis
			TRBCOM->e3_comis:= e3_base*e3_porc/100
			TRBCOM->e3_data := ctod("0")
		endif
		goto x
		x:=x+1
	Enddo
	use
	Select SE3
	appe from &cTRBCOM
Endif   // Comissões de coordenadoras


Return
