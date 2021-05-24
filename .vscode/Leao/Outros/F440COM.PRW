#include "RwMake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MSD2UM2  ³ Autor ³Luiz Eduardo           ³ Data ³09/09/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Separa frete do valor do item da NF/Descto Z.Franca Manaus ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function F440COM()

Local _nFrete  := 0
Local _nValPed := 0
Local _xAlias  := GetArea()

if sd2->d2_desczfr=0

  RestArea(_xAlias)
  Return
endif

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJAENT)

DbSelectArea("SD2")
// alert("recno() SD2 "+sd2->d2_doc)

nDesc := 0
dbSetOrder(3)
Seek xFilial()+sf2->f2_doc
Do while !eof() .and. sf2->(f2_doc+f2_serie)==sd2->(d2_doc+d2_serie)
  nDesc := nDesc + sd2->d2_cusff4 + sd2->d2_cusff5 
  skip
Enddo

DbSelectArea("SE1")
// alert("recno() SD2"+strzero(sd2->(Recno()),6))
// alert("recno() SE1 "+se1->e1_num)
dbSetOrdeR(1)
Seek xFilial()+sf2->f2_serie+sf2->f2_doc
n:=0
Do while !eof() .and. sf2->f2_serie+sf2->f2_doc==se1->(e1_prefixo+e1_num)
  n:=n+1
  skip
Enddo

Seek xFilial()+sf2->f2_serie+sf2->f2_doc
Do while !eof() .and. sf2->f2_serie+sf2->f2_doc==se1->(e1_prefixo+e1_num)
	if !eof()
		reclock("SE1",.f.)
		se1->e1_valor  := se1->e1_valor   - (nDesc)/n
		se1->e1_saldo  := se1->e1_saldo   - (nDesc)/n
		se1->e1_vlcruz := se1->e1_vlcruz  - (nDesc)/n
		MsUNLock()
	endif
	skip
Enddo

  RestArea(_xAlias)

Return
