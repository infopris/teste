User Function FA050INC

    Local lRet := .T. 

	// Regra para validação do Centro de Custos no lançamento de título a pagar (diferente de PA)
	// Luiz Eduardo - Totalit - 09/04/2021
        If Empty(M->E2_CCUSTO) .and. m->e2_tipo<>"PR"
            Aviso("Atencao","Informar o Centro de Custo ",{"Ok"},1,"CCUSTO Obrigatório")
            lRet := .F.
        EndIf
	// Fim *

Return lRet
