#INCLUDE "PROTHEUS.CH"

User Function F470ALLF()
Local lAllfil := ParamIxb[1]

If !lAllfil
	 If MessageBox ("Deseja consolidar movimentos da conta corrente de todas as filiais        ?", "Aten��o!!!", "MB_YESNO" ) 
     lAllfil := .T.
  	Endif
Endif
   
Return lAllfil
