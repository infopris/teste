#include "protheus.ch"
#include "rwmake.ch"

#DEFINE EOFL CRLF

User Function SIGAFAT()

// Incluído dia 06/09 - Luiz Eduardo para mostrar automaticamente a agenda do tmkt

Select SU7
dbSetOrder(4)
seek xFilial()+__cUserID
if !eof()

	Select SZ5
	dbSetOrder(1)
	Seek "  "+dtos(dDataBase)+su7->U7_COD
	if !eof()
		aCampos := {}
		AADD(aCampos,{ "UA_OPERADO", "C",06,0})
		AADD(aCampos,{ "UA_NUM"  , "C",06,0})
		AADD(aCampos,{ "Cliente" , "C",06,0})
		AADD(aCampos,{ "Loja"    , "C",06,0})
		AADD(aCampos,{ "Nome"	 , "C",40,0})
		AADD(aCampos,{ "DataCont", "C",10,0})
		AADD(aCampos,{ "OK"      , "C",1,0})
		if Select("TRB")<>0
			TRB->(DBCLOSEAREA( ))
		endif
		cNome := CriaTrab(aCampos,.T.)
		dbUseArea(.T.,,cNome,"TRB", .F. )
		
		Select SZ5
		do while !eof() .and. su7->U7_COD = Z5_OPERADO //.and. dtos(dDataBase)+su7->U7_COD = dtos(DataCont)+UA_OPERADO
			if dtos(dDataBase) <> dtos(SZ5->Z5_CONTATO)
				skip
				loop
			endif
//			if efetivado<>" "
//				skip
//				loop
//			endif   
			Select SA1
			dbSetOrder(1)
			Seek xFilial()+SZ5->(Z5_Cliente+z5_loja)
			Select TRB
			RecLock("TRB",.t.)
			trb->UA_OPERADO	:= SZ5->Z5_OPERADO
			trb->UA_NUM		:= SZ5->Z5_NUMTMK
			trb->Cliente	:= SZ5->Z5_Cliente
			trb->Loja		:= SZ5->Z5_Loja
			trb->Nome		:= SA1->a1_Nome
			trb->DataCont	:= dtoc(SZ5->Z5_CONTATO)
			MsUnLock()
			Select SZ5
			skip
		enddo
		Select Trb
		dbGoTop()
		aCampos := {}
		
		//		AADD(aCampos,{ "OK"      , "ok","@!"})
		AADD(aCampos,{ "UA_OPERADO", "Operador","@!"})
		AADD(aCampos,{ "UA_NUM"  , "Atendimento","@!"})
		AADD(aCampos,{ "Cliente" , "Cliente","@!"})
		AADD(aCampos,{ "Loja"    , "Loja","@!"})
		AADD(aCampos,{ "Nome"	 , "Nome","@!"})
		AADD(aCampos,{ "DataCont", "C","@!"})
		
		@ 010,1 TO 500,750 DIALOG oDlg TITLE "Ligações Programadas para o dia"
		@ 005,5 TO 215,360 BROWSE "TRB" FIELDS aCampos
		@ 225,310 BUTTON "_Sai" SIZE 40,15 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED
		//		Return
	Endif
	if Select("TRB")<>0
		TRB->(DBCLOSEAREA( ))
	endif
Endif
// Final da alteração 06/09


Return

