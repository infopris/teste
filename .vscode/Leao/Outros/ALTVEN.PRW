#INCLUDE "rwmake.ch"
User Function AltVen


cVend1 := "000000"
cVend2 := "000000"
cSen   := space(6)
@ 050,01 To 200,350 Dialog Odlg Title "Altera Vendedor Cadastro Clientes"
@ 003,09 to 100,150
@ 010,10 Say "Vendedor Atual :"
@ 010,60 GET cVend1  Picture "@X" Valid .T. F3 "SA3"
@ 025,10 Say "Novo Vendedor  :"
@ 025,60 GET cVend2  Picture "@X" Valid .T. F3 "SA3"
@ 040,10 Say "Senha          :"
@ 040,60 GET cSen    Picture "@!" size 40,20 valid .t. PASSWORD

@ 60,25 BMPBUTTON TYPE 01 ACTION OkProc()
@ 60,65 BMPBUTTON TYPE 02 ACTION Cancela()
Activate Dialog oDlg Centered

Static Function OkProc
if cSen#"LEAO05"
  Alert("Senha invalida, operacao nao permitida")
  Return
endif
Select SA3
dbSetOrder(1)
seek xFilial()+cVend1
if eof()
  Alert("Vendedor "+cVend1+" inexistente, operacao cancelada")
  Return
endif
cVen1 := trim(sa3->a3_nreduz)
seek xFilial()+cVend2
if eof()
  Alert("Vendedor "+cVend2+" inexistente, operacao cancelada")
  Return
endif
cVen2 :=trim(sa3->a3_nreduz)

if !MsgBox ("Confirma alteracao do vendedor "+cVen1+" para "+cVen2,"Escolha","YESNO")
    Return
endif

Processa( {|| RunProc() } )

Return

static Function RunProc()

Select SA1
dbSetOrder(1)
dbGoTop()
ProcRegua(reccount())
n:=1
do while !eof()
    IncProc()
    if sa1->a1_vend==cVend1 .and. rlock()
       sa1->a1_vend:=cVend2
       n:=n+1
    endif
    skip
enddo
Alert("Alterados "+strzero(n,5)+"Vendedor(es) ")
Return



Static Function Cancela
Close(oDlg)
Return (.T.)
