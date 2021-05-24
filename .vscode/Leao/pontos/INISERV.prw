#include "protheus.ch"
#include "rwmake.ch"

User Function INISERV
if MsgBox ("Reiniciar Serviço Protheus ?","Escolha","YESNO")
//     WaitRunSrv( "net stop Totvs" , .T. , "d:\" ) // Baixa serviço Protheus
     WaitRunSrv( "net start Totvs" , .T. , "d:\" ) 
endif

if MsgBox ("Reiniciar Serviço TSS ?","Escolha","YESNO")
     WaitRunSrv( "net stop TSS_Protheus11" , .T. , "d:\" ) // Baixa serviço TSS
     WaitRunSrv( "net start TSS_Protheus11" , .T. , "d:\" ) 
Endif

MsgBox("Fim do Processamento !!!","Atencao","INFO")
return                                                              



//WaitRunSrv( cCommandLine , lWaitRun , cPath ) : lSuccess 
//Onde: 
//cCommandLine : Instrução a ser executada 
//lWaitRun     : Se deve aguardar o término da Execução 
//Path        : Onde, no server, a função deverá ser executada 
//Retorna      : .T. Se conseguiu executar o Comando, caso contrário, .F. 