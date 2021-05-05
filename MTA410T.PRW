/*-----------------------------------------------------------------------------+
 * Programa  | MTA410T  |  Ponto de Entrada             | Data ->  04/06/2000  *
 *-----------------------------------------------------------------------------*
 * Objetivo  | Ponto de Entrada executado após confirmação do Pedido de Venda  *
 *           | (C9_BLCRED="" possui crédito / C9_BLCRED="01"ou "04" nao possui *
 *           |                                                                 *
 *-----------+-----------------------------------------------------------------+
 * Uso       | WorkFlow/AP5 - Evento Microsiga                                 *
 +-----------+-----------------------------------------------------------------+
 | Rotina    | WF_450A - Enviar email informando rejeição de crédito           |
 | Chamada   |                                                                 |
 +-----------------------------------------------------------------------------*/

User Function MTA410T()
     U_RFATE50()
Return   