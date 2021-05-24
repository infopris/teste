#include "protheus.CH"
#include "colors.CH"
#include "TOPCONN.CH"
#INCLUDE "TCBROWSE.CH" 
#include "rwmake.ch"   


// Instrucoes
// - Cadastrar o grupo do produto como "200"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³D1_COD    º Autor ³Luiz Eduardo        º Data ³  17/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilho para verificar o grupo do produto                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Entrada de Notas Fiscais                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function D1_COD()

Local aAreaAtual 	:= GetArea()
Private cDesc01,cDesc02,cDesc03,cDesc04
Private lCheck01,lCheck02,lCheck03,lCheck04
Private aItens
Private nList

dbSelectArea( "SB1" )
dbSetOrder(1)      
cCod := M->D1_COD
Seek xFilial()+cCod
if sb1->b1_grupo<>"200 "
	Return( cCod )
else
Select SB1
nPos := len(trim(cCod))
nregistro := recno() 
nList := 0
Do while !eof() .and. left(cCod,nPos)==left(sb1->b1_cod,nPos)
	if sb1->b1_cod<>cCod
		nList++
		cVar1 := "lCheck"+strzero(nList,2)
		cVar2 := "cDesc" +strzero(nList,2)
		&cVar1 := .f.
		&cVar2 := sb1->b1_cod+"-"+sb1->b1_desc
//		aAdd(aItens,{sb1->b1_cod,sb1->b1_desc})
	endif
	skip
Enddo
goto nRegistro

	Tela()                                                
	do case
	Case lCheck01 
		cCod := left(cDesc01,15)
	Case lCheck02
		cCod := left(cDesc02,15)
	Case lCheck03
		cCod := left(cDesc03,15)
	Case lCheck04
		cCod := left(cDesc04,15)
	endcase
Endif

//Retorna todos os alias para a situacao atual
RestArea(aAreaAtual)

Return( cCod )
                                                                               


**********************
Static Function Tela()
**********************

Local cTitle   := "Produto: "+sb1->b1_desc
Local oDlg01
Local oFont1
//Local nList
Local aItens

//nList:= 0
aItens := {}

Define msDialog oDlg01 From 00,00 To 318,400 Title cTitle Pixel
Define Font oFont1 Name "Courier New" Size 0,-14 Bold

nLin := 20

@ 10,10 SAY "Lista dos Itens disponiveis para digitacao:" Font oFont1 of oDlg01 Pixel
//@ 20,10 LISTBOX nList ITEMS aItens SIZE 100,50 Font oFont1 of oDlg01 Pixel
For n:= 1 to nList
	@ nLin,10 CHECKBOX &("cDesc" +strzero(n,2)) VAR &("lCheck"+strzero(n,2))
//  	@ nLin,20 SAY &("cDesc" +strzero(n,2))  Font oFont1 of oDlg01 Pixel
	nLin := nLin + 10
Next N
n:=1
@145,170 BmpButton Type 1 Action Close(oDlg01)
Activate Dialog oDlg01 Centered

Return .T.
