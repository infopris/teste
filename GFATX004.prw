#INCLUDE 'PROTHEUS.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} GFATX004
Inicializador padrão do campo CK_ENTREG, para inicializar o campo 
com 4 dias útei

@author Bruno Lazarini Garcia
@since 24/05/2016
@version P11
/*/
//-------------------------------------------------------------------
User Function GFATX004() 

Local dDateHJ    := dDataBase  
Local nTipoDia   := 0 
Local nQtdDiasUt := 3 
Local nX		 := 0 
Local nQdtDias	 := 0
Local lPrim      := .T.

//------------------------------------------------
// Valida o dia atual + 1 - Que é o proximo. 
//------------------------------------------------
dDateHJ := (dDateHJ+1)

//-> Trata os dias Util e Nao Util
nTipoDia := DateWorkDay( dDateHJ, dDateHJ , .F., .F., .F. )  

If nTipoDia == 0 //Fim de Semana ou Feriado - Nao util

	 While nTipoDia == 0 //.and. !EOF()
		
		//nX += nX++
	
		dDateHJ := (dDateHJ+1)
		
		nTipoDia := DateWorkDay( dDateHJ, dDateHJ , .F., .F., .F. )  
		
	  	//DbSkip()
	
	EndDo

Endif

//------------------------------------------------
// Valida a proxima data atual + 3
//------------------------------------------------
//dDateHJ  := (dDateHJ+nQtdDiasUt)                
nTipoDia := 0                                     

If DOW( dDataBase ) == 3

	While nQtdDiasUt >= nQdtDias  
	
		//-> Trata os dias Util e Nao Util
		nTipoDia := DateWorkDay( dDateHJ, dDateHJ , .F., .F., .F. )  
		
		If nQtdDiasUt == nQdtDias .And. nTipoDia == 1 
			Exit
		Endif
		
		If nTipoDia == 1 //1= Útil | 0= Fim de Semana ou Feriado - Nao util
			//nX += nX++
	   		dDateHJ := (dDateHJ+1)   
			nQdtDias++
		Else 
	   		dDateHJ := (dDateHJ+1) 
		Endif  
		  
	Enddo

Else

	While nQdtDias < nQtdDiasUt     

	//-> Trata os dias Util e Nao Util
	nTipoDia := DateWorkDay( dDateHJ, dDateHJ , .F., .F., .F. )  
	
	If nTipoDia == 1 //1= Útil | 0= Fim de Semana ou Feriado - Nao util
		//nX += nX++
   		dDateHJ := (dDateHJ+1)   
		nQdtDias++
	Else 
   		dDateHJ := (dDateHJ+1) 
	Endif
	  
	Enddo


Endif 

Return( dDateHJ ) 