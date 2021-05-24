#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  MTA410  ºAutor  ³   Alexandro Dias   º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza volume, peso liquido e bruto do pedido.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA410()

Local _nVolume := 0
Local _nPesoLi := 0                             
Local _nPesoBr := 0
Local _xAlias  := GetArea()
Local _nPosProd:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" })
Local _nPosVol := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_UNSVEN" })
Local _nPosQt  := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN" })
Local _nPosCF  := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_CLASFIS" })
Local _nPosTes := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_TES" })

For _nLin := 1 to Len(aCols)
    
    _nVolume := _nVolume + aCols[_nLin,_nPosVol]
   
    SB1->(DbSetOrder(1))
    IF SB1->(DbSeek(xFilial("SB1")+aCols[_nLin,_nPosProd]))
    	_nPesoBr := _nPesoBr + (aCols[_nLin,_nPosQt] * SB1->B1_PESO)
    	_nPesoLi := _nPesoLi + SB1->B1_PESO
    EndIF

    SF4->(DbSetOrder(1))
    IF SF4->(DbSeek(xFilial("SF4")+aCols[_nLin,_nPosTES]))
   		aCols[n,_nPosCF] :=  left(sb1->B1_ORIGEM,1)+left(sf4->F4_SITTRIB,2)
    EndIF
    
Next

M->C5_PBRUTO  := _nPesoBr
M->C5_PESOL   := _nPesoBr //_nPesoLi Alterado para NFE - Luiz Eduardo 
M->C5_VOLUME1 := IIF(upper(left(M->C5_ESPECI1,3))$"CHA*CX ",m->c5_volume1,_nVolume)
M->C5_ESPECI1 := IIF(Empty(M->C5_ESPECI1),"Caixa(s)",M->C5_ESPECI1)

RestArea(_xAlias)

Return(.T.)
