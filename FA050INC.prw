User Function FA050INC

    Local lRet := .T. 

	// Regra para valida��o do Centro de Custos no lan�amento de t�tulo a pagar (diferente de PA)
	// Luiz Eduardo - Totalit - 09/04/2021
        If Empty(M->E2_CCUSTO) .and. m->e2_tipo<>"PR"
            Aviso("Atencao","Informar o Centro de Custo ",{"Ok"},1,"CCUSTO Obrigat�rio")
            lRet := .F.
        EndIf
	// Fim *

Return lRet
