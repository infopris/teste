/*-----------------------------------------------------------------------------+
 * Programa  | MTA410T  |  Ponto de Entrada             | Data ->  04/06/2000  *
 *-----------------------------------------------------------------------------*
 * Objetivo  | Ponto de Entrada executado ap�s confirma��o do Pedido de Venda  *
 *           | (C9_BLCRED="" possui cr�dito / C9_BLCRED="01"ou "04" nao possui *
 *           |                                                                 *
 *-----------+-----------------------------------------------------------------+
 * Uso       | WorkFlow/AP5 - Evento Microsiga                                 *
 +-----------+-----------------------------------------------------------------+
 | Rotina    | WF_450A - Enviar email informando rejei��o de cr�dito           |
 | Chamada   |                                                                 |
 +-----------------------------------------------------------------------------*/

User Function MTA410T()
     U_RFATE50()
Return   