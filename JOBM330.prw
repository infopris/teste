/*
#include "rwmake.ch"
#include "TbiConn.ch"
User Function jobm330()
Local PARAMIXB1 := .T. // - Caso a rotina seja rodada em batch(.T.), senão (.F.)
Local PARAMIXB2 := {"01"} // - Lista com as filiais a serem consideradas (Batch)
Local PARAMIXB3 := .T. // - Se considera o custo em partes do processamento
Local PARAMIXB4 := {} // -Parametros para execução da rotina
Local aEmp := {"01","00"} // Empresa Filial
PREPARE ENVIRONMENT EMPRESA aemp[1] FILIAL aemp[2] USER 'usuário' PASSWORD 'senha' TABLES "AF9","SB2","SB9","SBD","SC2","SD1","SD3","SD8","SF4","SF5","SI1","SI2","SI3","SI5","SI6","SI7","SM2" MODULO "EST"

dData := LastDay(Date()) // Pega o ultimo dia do mês corrente
PARAMIXB4 := { dData ,1,1,1,0,2," " ,"ZZZZZZZZZZZZZZZ" ,2,2,2,3,2,1,1,1,2,1,2,1,2} //Parametros
MSExecAuto({|x,y,z,w|mata330(x,y,z,w)},PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4)
RESET ENVIRONMENT
Return Nil
*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"


User Function JOBM330()
Local lCPParte := .F. //-- Define que não será processado o custo em partes
Local lBat := .T. //-- Define que a rotina será executada em Batch
Local aListaFil := {} //-- Carrega Lista com as Filiais a serem processadas
Local cCodFil := '' //-- Código da Filial a ser processada
Local cNomFil := '' //-- Nome da Filial a ser processada
Local cCGC := '' //-- CGC da filial a ser processada
Local aParAuto := {} //-- Carrega a lista com os 21 parâmetros

ConOut(Repl("-",80))
ConOut(PadC("Rotina Recalculo Custo Medio",80))
ConOut(PadC("Conectando Ambiente.....",80))

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'TOTALIT' PASSWORD 'Totalit@2021' MODULO "EST" TABLES "AF9","SB1","SB2","SB3","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SF5","SG1","SI1","SI2","SI3","SI5","SI6","SI7","SM2","ZAX","SAH","SM0","STL"

dData := LastDay(Date()) // Pega o ultimo dia do mês corrente
aParAuto := { dData ,1,1,1,0,2," " ,"ZZZZZZZZZZZZZZZ" ,2,2,2,3,2,1,1,1,2,1,2,1,2} //Parametros
ConOut(PadC("Ambiente Conectado com Sucesso...",80))
ConOut(Repl("-",80))

Conout("Início da execução do JOBM330")

//-- Adiciona filial a ser processada
dbSelectArea("SM0")
dbSeek(cEmpAnt)

Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt

cCodFil := SM0->M0_CODFIL
cNomFil := SM0->M0_FILIAL
cCGC := SM0->M0_CGC
//-- Somente adiciona a Filial 01
If cCodFil == "01"

//-- Adiciona a filial na lista de filiais a serem processadas
Aadd(aListaFil,{.T.,cCodFil,cNomFil,cCGC})

EndIf
dbSkip()

EndDo

//-- Executa a rotina de recálculo do custo médio
MATA330(lBat,aListaFil,lCPParte, aParAuto)
ConOut("Término da execução do JOBM330")

Return
*/
