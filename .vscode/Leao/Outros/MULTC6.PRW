/* ===========================================================================

=========================================================================== */
User Function MultC6()    
local _nProd	:= aScan(aHeader,{|x| Upper(Alltrim(x[2])) == "UB_PRODUTO"})
local _lRet    	:= .T.

dbSelectArea("SUB")
	dbSelectArea("SB1")
	dbSetOrder(1)
	if dbSeek(xFilial("SB1")+aCols[n][_nProd])
		if B1_CONV <> 0 .AND. B1_SEGUM<>"M2"
			if M->UB_QUANT % B1_CONV <> 0
				msgstop("Em Cada Caixa Possui: "+str(B1_CONV,5,0))
			endif			                                        
		endif
	endif
Return(m->ub_quant)