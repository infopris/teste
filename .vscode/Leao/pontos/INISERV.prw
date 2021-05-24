#include "protheus.ch"
#include "rwmake.ch"

User Function INISERV
if MsgBox ("Reiniciar Servi�o Protheus ?","Escolha","YESNO")
//     WaitRunSrv( "net stop Totvs" , .T. , "d:\" ) // Baixa servi�o Protheus
     WaitRunSrv( "net start Totvs" , .T. , "d:\" ) 
endif

if MsgBox ("Reiniciar Servi�o TSS ?","Escolha","YESNO")
     WaitRunSrv( "net stop TSS_Protheus11" , .T. , "d:\" ) // Baixa servi�o TSS
     WaitRunSrv( "net start TSS_Protheus11" , .T. , "d:\" ) 
Endif

MsgBox("Fim do Processamento !!!","Atencao","INFO")
return                                                              



//WaitRunSrv( cCommandLine , lWaitRun , cPath ) : lSuccess 
//Onde: 
//cCommandLine : Instru��o a ser executada 
//lWaitRun     : Se deve aguardar o t�rmino da Execu��o 
//Path        : Onde, no server, a fun��o dever� ser executada 
//Retorna      : .T. Se conseguiu executar o Comando, caso contr�rio, .F. 