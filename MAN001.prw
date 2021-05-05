#INCLUDE "PROTHEUS.CH"

User Function MAN001(lAlterar)
Local cQuery
Local cAliasSql  := GetNextAlias()
Local cAliasTmp  := GetNextAlias()      
DEFAULT lAlterar := .F.

cQuery := "SELECT "
cQuery += "Z00.R_E_C_N_O_ RECZ00, E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, Count(*) AS 'QTDE' "
cQuery += "FROM " + RetSqlName("Z00") + " Z00 "
cQuery += "INNER JOIN " + RetSqlName("SE2") + " SE2 ON (Z00_FILIAL=E2_FILIAL AND Z00_NUM=E2_PREFIXO+E2_NUM AND Z00_ITEM=E2_PARCELA AND Z00_SEQUEN=E2_TIPO AND SE2.D_E_L_E_T_=' ') "
cQuery += "WHERE "
cQuery += "Z00.D_E_L_E_T_=' ' "
cQuery += "AND Z00_ORIGEM='SE2' "
cQuery += "AND Z00_CLIFOR=' ' "
cQuery += "GROUP BY "
cQuery += "Z00.R_E_C_N_O_, E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO "
cQuery += "HAVING "
cQuery += "Count(*) = 1 "
cQuery += "ORDER BY "
cQuery += "Z00.R_E_C_N_O_"

cQuery    := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSql,.F.,.T.)

While (cAliasSql)->(!EOF()) 
	
	dbSelectArea("Z00")
	dbSetOrder(1)
	dbGoTo((cAliasSql)->RECZ00) 
	
	cQuery := "SELECT "
	cQuery += "E2_FILIAL,E2_PREFIXO,E2_NUM,E2_TIPO,E2_FORNECE,E2_LOJA "
	cQuery += "FROM " + RetSqlName("SE2") + " SE2 "
	cQuery += "WHERE "
	cQuery += "SE2.D_E_L_E_T_=' ' "
	cQuery += "AND E2_FILIAL ='"+(cAliasSql)->E2_FILIAL+"' "
	cQuery += "AND E2_PREFIXO='"+(cAliasSql)->E2_PREFIXO+"' "
	cQuery += "AND E2_NUM    ='"+(cAliasSql)->E2_NUM+"' "
	cQuery += "AND E2_PARCELA='"+(cAliasSql)->E2_PARCELA+"' "			
	cQuery += "AND E2_TIPO   ='"+(cAliasSql)->E2_TIPO+"' "				
	
	cQuery    := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T.)	
	
	If Z00->(Recno()) == (cAliasSql)->RECZ00 .And. (cAliasTmp)->(!EOF()) .And. lAlterar
		If RecLock("Z00",.F.)
			Z00_CLIFOR := (cAliasTmp)->E2_FORNECE
			Z00_LOJA   := (cAliasTmp)->E2_LOJA			
			Z00->(MsUnlock())
		EndIf
	EndIf    
	(cAliasTmp)->(dbCloseArea())
	
	(cAliasSql)->(dbSkip())
EndDO                      
(cAliasSql)->(dbCloseArea())

Return( Nil )