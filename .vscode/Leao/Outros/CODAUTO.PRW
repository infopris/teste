#include "rwmake.ch"   

* Numeração automática SC2,SA4,SC7
* Stat -> Ok

//------------------------//
User Function SC2_COD()
//------------------------//

SetPrvt("CCOD")

//cAlias     := Alias()
cCod       := 0

dbSelectArea( "SC2" )
dbSetOrder(1)     
DbGoBottom()
cCod := VAL(SC2->C2_NUM)+1

IF cCod>=1 .and. cCod<=999999
  cCod := cCod
else          
	Select SD3
	dbSetOrder(1)
	DbGoBottom()
	cCod := left(d3_op,6)
	cCod := val(cCod)+1
Endif

cCod :=strzero(cCod,6)

Return( cCod )

//------------------------//
User Function SC7_COD()
//------------------------//
SetPrvt("CCOD")

cAlias     := Alias( )
cCod       := 0

dbSelectArea( "SC7" )
dbSetOrder(1)     
DbGoBottom()
cCod := VAL(SC7->C7_NUM)+1

IF cCod>=1 .and. cCod<=999999
	cCod :=strzero(cCod,6)
else          
	cCod := GetNumSC7()
Endif

dbSelectArea( cAlias )
Return( cCod )

//------------------------//
User Function SA4_COD()
//------------------------//
SetPrvt("CCOD")

cAlias     := Alias( )
cCod       := 0

dbSelectArea( "SA4" )
dbSetOrder(1)     
nReg := RECCOUNT()
dbgoto(nReg)

cCod := VAL(SA4->A4_COD)+1

Seek xFilial()+str(cCod,4)
do while !eof()
	cCod := VAL(ccod)+1
	Seek xFilial()+str(cCod,4)
enddo

dbSelectArea( cAlias )
Return( cCod )


//------------------------//
User Function SUS_COD()
//------------------------//
SetPrvt("CCOD")

cAlias     := Alias( )
cCod       := 0

dbSelectArea( "SUS" )
dbSetOrder(1)     
nReg := RECCOUNT()
dbgoto(nReg)


cCod := cNum := GetSXENum("SUS", "US_COD")

dbSetOrder(1)     
DbGoBottom()
cCod := VAL(SUS->US_COD)+1

IF cCod>=1 .and. cCod<=999999
	cCod :=strzero(cCod,6)
else          
	cCod := GetNumSUS()
Endif

ConfirmSX8(.T.)

Return( cCod )

User Function AcInv()

	Local cQuery := ""

	cQuery := "SELECT B2_COD,B2_QATU,B2_LOCAL "
	cQuery += "FROM SB2010 "
	cQuery += " WHERE "
	cQuery += "B2_QATU<>0 AND "
	cQuery += "B2_LOCAL='CB' AND "
	cQuery += "SB2010.D_E_L_E_T_ <>'*'  "
	cQuery := ChangeQuery(cQuery)
	IF SELECT("TRB") # 0
		TRB->(DBCLOSEAREA( ))
	ENDIF
	IF SELECT("TRB1") # 0
		TRB1->(DBCLOSEAREA( ))
	ENDIF
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
	Select SB7
	cTemp := CriaTrab(nil,.f.)
	copy structure to &cTemp 
	dbUseArea( .T.,,cTemp,"TRB1", Nil, .F. )
	
	Select Trb
	dbgotop()
	Do while !eof()
		Select Trb1
		RecLock("TRB1",.t.)
		trb1->b7_filial := "01"
		trb1->b7_cod 	:= trb->b2_cod
		trb1->b7_local 	:= trb->b2_local
		trb1->b7_tipo 	:= "PA"
		trb1->b7_doc 	:= dtos(date())
		trb1->b7_data 	:= date()
		trb1->b7_dtvalid:= date()
		trb1->b7_status	:= "1"
		trb1->b7_origem	:= "MATA270"
		MsUnLock()
		Select Trb
		skip
	Enddo
	Select Trb1
	copy to \x
	use
	Select SB7
	append from &cTemp
	Return
	