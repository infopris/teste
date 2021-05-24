#Include 'Protheus.ch'
#Include 'TBICONN.ch'
#Include "Totvs.ch"
#Include "RWMake.ch"
#Include "TopConn.ch"

USER FUNCTION IMP_PONTO()

// Le arquivo com itens do de para
Local nTamFile   := 0
Local nTamLin    := 33
Local nBtLidos   := 0
Local cBuffer   := ""
Local cFileOpen := ""
Local cTitulo1 := "Selecione o arquivo"
Local cExtens       := "Arquivo TXT | *.txt"
Local nTam
Local nItem       := 0   
Local _aVetor := {}
_cData     :=""
_chora     :=""
_cPIS      :=""


cFile := cGetFile("*.TXT",OemToAnsi("Selecione o Arquivo de Ponto ") )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Le arquivo de Entrada      ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FT_FUse(cFile) == -1
	MsgStop( "Não foi possíel abrir o arquivo "+cFile )
	return
Endif

FT_FUSE(cFile)                //ABRIR
FT_FGOTOP()                        //PONTO NO TOPO
ProcRegua(FT_FLASTREC())   //QTOS REGISTROS LER

While !FT_FEOF()
     IncProc()
     cBuffer := FT_FREADLN()
     nTam    := Len( cBuffer )
 
     _cData    := SubStr(cBuffer,11,08) + Chr(13)+Chr(10)
     _cHora    := SubStr(cBuffer,19,04) + Chr(13)+Chr(10)
     _cPIS     := SubStr(cBuffer,24,05) + Chr(13)+Chr(10)
	 
	//aAdd(aVendedor,{SC5->C5_VEND1,nTotQtde,nTotPedido,nTotFatura})
	 
	Aadd(_aVetor,{SubStr(cBuffer,15,04),;
	SubStr(cBuffer,13,02),;
	SubStr(cBuffer,11,02),;
	SubStr(cBuffer,19,04),;
	SubStr(cBuffer,24,10)})
//{{"Ano"  , SubStr(cBuffer,15,04) ,NIL},;
//{ "Mes"  , SubStr(cBuffer,13,02) ,NIL},;
//{ "Dia"  , SubStr(cBuffer,11,02) ,NIL},;
//{ "Hora" , SubStr(cBuffer,19,04) ,NIL},;
//{ "PIS"  , SubStr(cBuffer,24,10) ,NIL}})

    FT_FSKIP()
	
endDo

 EXCELOG(_aVetor)

FT_FUSE()
     MsgInfo("Processo finalizada")
Return Nil

//----------------------
Static Function EXCELOG(_aLog)
//----------------------

Local cDirDocs	:= MsDocPath()
Local cArquivo	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local nHandle	:= 0

If len(_aLog) > 0
	
	nHdl2    := fCreate("C:\TEMP\"+cEmpAnt+"Mvto.txt")
 	
 	If nHdl2 == -1
		MsgAlert("nao pode ser criado ! Verifique os parametros.","Atencao!")
		Return .F.
	Endif
	
	cLinha1:=""
	cLinha1 += CHR(13)+CHR(10)
	
	 fWrite(nHdl2,cLinha1) // != Len(cLinha1) //Testa por erros durante a gravacao da linha montada.
	
	For _c:=1 to len(_aLog)

		cAno := (_aLog[_c][1])
		cMes := (_aLog[_c][2])
		cDia := (_aLog[_c][3])
		cHora:= (_aLog[_c][4])
		cPIS := (_aLog[_c][5])

		Select SRA
		dbSetOrder(6)
		seek xFilial()+cPIS
		if dtoc(sra->ra_demissa)<>0 .or. sra->ra_demissa<date()-30
		 	skip
		endif
		
	 	if cPIS = SRA->RA_PIS 
	 		cLinha1 :="01000000000000"+trim(sra->ra_mat)+"1"+cAno+cMes+cDia+cHora+"07"
	 		cLinha1 += CHR(13)+CHR(10)
	 	endif 
		
		IF fWrite(nHdl2,cLinha1,LEN(cLinha1) )  != Len(cLinha1) //Testa por erros durante a gravacao da linha montada.
			alert("GErro ->"+cLinha1)
		exit
		Endif
	Next
	
	fClose(nHdl2)//Fechamen	to do objeto Dialog
	MsgAlert("Gerado o Arquivo TXT ")
Else
	MsgAlert("N? h?logs a apresentar.")
EndIf

RETURN
