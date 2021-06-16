#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/09/01

User Function Orcamento       // Impress?o de Orcamentos

SetPrvt("CNUM,OPRINT>,LINHA,NPAGINA,PTIPO,CINDEX")
SetPrvt("CCOND,NINDEX,NMARCADOS,NOLDAREA,OFONT1,OFONT2")
SetPrvt("OFONT3,OFONT4,OFONT5,OFONT6,OFONT7,OFONT8")
SetPrvt("OFONT9,OPRN,AFONTES,CCLICOMP,CSEGCOMP,CINSCRE")
SetPrvt("ACAMPOS,CNOMARQ,AHEADER,AMARCADOS,LCRIAWORK,CPICTQTDE")
SetPrvt("CPICT1TOTAL,CPICT2TOTAL,OFONT10,LEND,OFNT,CARQ")
SetPrvt("CTEXTO,NCOL,N,")


If TYPE("uPorPrograma") == "U"
	cPerg := "TMK003"
	//+--------------------------------------------------------------+
	//? Verifica as perguntas selecionadas                           ?
	//+--------------------------------------------------------------+
	pergunte(cPerg,.t.)  
	dbSelectArea("SUA")
	dbSetOrder(1)
	dbSeek(xFilial("SUA") + mv_par05) //Pedido
Else
	mv_par05 := cNumAte
	dbSelectArea("SUA")
	dbSetOrder(1)
	dbSeek(xFilial("SUA") + mv_par05) //Pedido
Endif
IF SUA->UA_OPER<>'2' // Or?amento
	return
Endif
processa()
                         
Return
                          
**************************    
Static function Processa()
**************************

nPagina := 1
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA)
cCliente:= SA1->A1_COD +"/"+SA1->A1_LOJA + " - " + SA1->A1_NOME
cCGC    := SA1->A1_CGC
cRg     := IIf(!Empty(SA1->A1_INSCR),SA1->A1_INSCR,SA1->A1_RG)
cSuframa:= SA1->A1_SUFRAMA
cBairro := sa1->a1_bairro
cTel	:= sa1->a1_tel
//----------------------------------------------------------------------------//
// Printer
#xcommand AVPRINT [ <oPrint> ] ;
             [ <name:TITLE,NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPRINTER [ <oPrint> ] ;
             [ <name:NAME,DOC> <cDocument> ] ;
             [ <user: FROM USER> ] ;
             [ <prvw: PREVIEW> ] ;
             [ TO  <xModel> ] ;
       => ;
      [ <oPrint> := ] AvPrintBegin( [<cDocument>], <.user.>, <.prvw.>, <xModel> )

#xcommand AVPAGE => AvPageBegin()

#xcommand AVENDPAGE => AvPageEnd()

#xcommand AVNEWPAGE => AvPageEnd() ; AvPageBegin()

#xcommand AVENDPRINT   => AvPrintEnd() ; AvSetPortrait()
#xcommand AVENDPRINTER => AvPrintEnd() ; AvSetPortrait()
//----------------------------------------------------------------------------//

#xtranslate :TIMES_NEW_ROMAN_18_NEGRITO    => \[1\]
#xtranslate :TIMES_NEW_ROMAN_12            => \[2\]
#xtranslate :TIMES_NEW_ROMAN_12_NEGRITO    => \[3\]
#xtranslate :TIMES_NEW_ROMAN_12_UNDERLINE  => \[14\]
#xtranslate :TIMES_NEW_ROMAN_10_NEGRITO    => \[4\]
#xtranslate :TIMES_NEW_ROMAN_08_UNDERLINE  => \[5\]
#xtranslate :TIMES_NEW_ROMAN_10            => \[6\]
#xtranslate :TIMES_NEW_ROMAN_08            => \[7\]
#xtranslate :COURIER_NEW_09                => \[8\]
#xtranslate :COURIER_08_NEGRITO            => \[9\]
#xtranslate :COURIER_NEW_10                => \[10\]
#xtranslate :COURIER_NEW_10_NEGRITO        => \[11\]
#xtranslate :COURIER_12_NEGRITO            => \[12\]
#xtranslate :COURIER_20_NEGRITO            => \[13\]

#COMMAND    TRACO_NORMAL                   => oSend(oPrn,"Line", Linha  ,  50, Linha  , 2350 ) ;
                                           ;  oSend(oPrn,"Line", Linha+1,  50, Linha+1, 2350 )

#COMMAND    TRACO_REDUZIDO                 => oSend(oPrn,"Line", Linha  ,1200, Linha  , 2300 ) ;
                                           ;  oSend(oPrn,"Line", Linha+1,1200, Linha+1, 2300 )

#COMMAND    ENCERRA_PAGINA                 => oSend(oPrn,"oFont",aFontes:COURIER_20_NEGRITO) 
*                                          ;  TRACO_NORMAL


#COMMAND    COMECA_PAGINA                  => AVNEWPAGE                                ;
                                           ;  Linha := 180                             ;
                                           ;  nPagina := nPagina+ 1                    ;
                                           ;  pTipo := 2
*                                          ;  PO150Cabec()                      ;// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==>                                            ;  Execute(PO150Cabec)                      ;
*                                          ;  PO150Cab_Itens()// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==>                                            ;  Execute(PO150Cab_Itens)


#xTranslate  DATA_MES(<x>) =>              SUBSTR(DTOC(<x>)  ,1,2)+ " " + ;
                                           SUBSTR(CMONTH(<x>),1,3)+ " " + ;
                                           SUBSTR(DTOC(<x>)  ,7,2)



cIndex := cCond := nIndex := Nil; nMarcados:=0; nOldArea:=ALIAS()
oFont1:=oFont2:=oFont3:=oFont4:=oFont5:=oFont6:=oFont7:=oFont8:=oFont9:=Nil
oPrn:= Linha:= aFontes:= Nil; cCliComp:=""; cSegComp:=""; cInscre:=""
aCampos:={}; cNomArq:=Nil; aHeader:={}
aMarcados:={}
lCriaWork:=.T.

cPictQtde:='@EZ 999,999,999'; cPict1Total:='@EZ 999,999,999,999.99'
cPict2Total:='@EZ 99,999,999,999,999.99'


   AVPRINT oPrn NAME "Emissão do Orçamento"
      //                              Font            W  H  Bold          Device
      oFont1 := oSend(TFont(),"New","Times New Roman",0,18,,.T.,,,,,,,,,,,oPrn )
      oFont2 := oSend(TFont(),"New","Times New Roman",0,12,,.F.,,,,,,,,,,,oPrn )
      oFont3 := oSend(TFont(),"New","Times New Roman",0,12,,.T.,,,,,,,,,,,oPrn )
      oFont14:= oSend(TFont(),"New","Times New Roman",0,12,,.F.,,,,,.T.,,,,,,oPrn )
      oFont4 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,,,,,,,oPrn )
      oFont5 := oSend(TFont(),"New","Times New Roman",0,10,,.T.,,,,,.T.,,,,,,oPrn )
      oFont6 := oSend(TFont(),"New","Times New Roman",0,10,,.F.,,,,,,,,,,,oPrn )
      oFont7 := oSend(TFont(),"New","Times New Roman",0,08,,.F.,,,,,,,,,,,oPrn )
      //                                                            Underline
      oFont8  := oSend(TFont(),"New","Courier New"    ,0,09,,.T.,,,,,,,,,,,oPrn )
      oFont9  := oSend(TFont(),"New","Courier New"    ,0,08,,.T.,,,,,,,,,,,oPrn )
      oFont10 := oSend(TFont(),"New","Courier New"    ,0,10,,.F.,,,,,,,,,,,oPrn )
      oFont11 := oSend(TFont(),"New","Courier New"    ,0,10,,.T.,,,,,,,,,,,oPrn )
      oFont12 := oSend(TFont(),"New","Courier New"    ,0,12,,.T.,,,,,,,,,,,oPrn )
      oFont13 := oSend(TFont(),"New","Courier New"    ,0,26,,.T.,,,,,,,,,,,oPrn )

      aFontes := { oFont1, oFont2, oFont3, oFont4, oFont5, oFont6, oFont7, oFont8, oFont9, oFont10, oFont11, oFont12, oFont13, oFont14 }

      AVPAGE
	If TYPE("uPorPrograma") == "U"
		Do case
		Case mv_par01==mv_par02
			dbSelectArea("SUA")
			dbSetOrder(4)                                  
			set softseek on
			dbSeek(xFilial("SUA") + dtos(mv_par03)) //Emissao
			set softseek off
			do while !eof() .and. ua_emissao>=mv_par03 .and. ua_emissao<=mv_par04
				if sua->ua_vend==mv_par01
					dbSelectArea("SA1")
					dbSetOrder(1)
					dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA)
					cCliente:= SA1->A1_COD +"/"+SA1->A1_LOJA + " - " + SA1->A1_NOME
					cCGC    := SA1->A1_CGC
					cRg     := IIf(!Empty(SA1->A1_INSCR),SA1->A1_INSCR,SA1->A1_RG)
					cBairro := sa1->a1_bairro
					cTel 	:= sa1->a1_tel
					dbSelectArea("SUA")
					R02Det()
					ENCERRA_PAGINA
					//COMECA_PAGINA
				endif
				dbSelectArea("SUA")
				skip
			enddo
		Case mv_par05<>space(6)
			dbSelectArea("SUA")
			dbSetOrder(1)
			set softseek on
			dbSeek(xFilial("SUA") + mv_par05) //Pedido
			do while !eof() .and. ua_num>=mv_par05 .and. ua_num<=mv_par06
				if sua->ua_vend>=mv_par01 .and. sua->ua_vend<=mv_par02
					dbSelectArea("SA1")
					dbSetOrder(1)
					dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA)
					cCliente:= SA1->A1_COD +"/"+SA1->A1_LOJA + " - " + SA1->A1_NOME
					cCGC    := SA1->A1_CGC
					cRg     := IIf(!Empty(SA1->A1_INSCR),SA1->A1_INSCR,SA1->A1_RG)
					cBairro := sa1->a1_bairro
					cTel	:= sa1->a1_tel
					dbSelectArea("SUA")
					R02Det()
					ENCERRA_PAGINA
					//COMECA_PAGINA
				endif
				dbSelectArea("SUA")
				skip
			enddo
		Otherwise
			dbSelectArea("SUA")
			dbSetOrder(4)                                  
			set softseek on
			dbSeek(xFilial("SUA") + dtos(mv_par03)) //Emissao
			set softseek off
			do while !eof() .and. ua_emissao>=mv_par03 .and. ua_emissao<=mv_par04
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA)
				cCliente:= SA1->A1_COD +"/"+SA1->A1_LOJA + " - " + SA1->A1_NOME
				cCGC    := SA1->A1_CGC
				cRg     := IIf(!Empty(SA1->A1_INSCR),SA1->A1_INSCR,SA1->A1_RG)
				cBairro := sa1->a1_bairro
				cTel := sa1->a1_tel
				dbSelectArea("SUA")
				R02Det()
				ENCERRA_PAGINA
				//COMECA_PAGINA
				dbSelectArea("SUA")
				skip
			enddo
		endCase
	Else
         R02Det()
 	endif
*         Processa({|end| lEnd := end, R02Det() })// Substituido pelo assistente de conversao do AP5 IDE em 05/09/01 ==>          Processa({|end| lEnd := end, Execute(R02Det) })

      AVENDPAGE

      oSend(oFont1,"End")
      oSend(oFont2,"End")
      oSend(oFont3,"End")
      oSend(oFont4,"End")
      oSend(oFont5,"End")
      oSend(oFont6,"End")
      oSend(oFont7,"End")
      oSend(oFont8,"End")
      oSend(oFont9,"End")
      oSend(oFont10,"End")
      oSend(oFont11,"End")
      oSend(oFont12,"End")
      oSend(oFont13,"End")
      oSend(oFont14,"End")

   AVENDPRINT


Return .T.

*----------------*
Static Function R02Det()
*----------------*

nPg := 1
cRespons := substr(cUsuario,7,10)
Select SA4
Seek xFilial()+sua->ua_transp
Select SA3
Seek xFilial()+sua->ua_vend

*cCgc := sa1->a1_cgc
If(LEN(TRIM(SA1->A1_CGC)))== 11
   cCgc := left(SA1->A1_CGC,3)+"."+substr(SA1->A1_CGC,4,3)+"."+substr(SA1->A1_CGC,7,3)+"-"+substr(SA1->A1_CGC,10,2)
else
   cCgc := left(SA1->A1_CGC,2)+"."+substr(SA1->A1_CGC,3,3)+"."+substr(SA1->A1_CGC,6,3)+"/"+substr(SA1->A1_CGC,09,4)+"-"+substr(SA1->A1_CGC,13,2)
Endif      

oFnt := aFontes:COURIER_20_NEGRITO
pTipo := 5
// Monta Cabe?alho
	oSend(oPrn, "SayBitmap", 0150, 0200, "lgrl01.BMP" , 200, 150 )
	oSend( oPrn, "Say", 250, 1050, "ORÇAMENTO ", aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
//	oSend( oPrn, "Say", 150, 1650, "RUA ECHAPOR?, 227/231 - CUMBICA ", aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
//	oSend( oPrn, "Say", 200, 1650, "GUARULHOS - SP 07224-090 ", aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
//	oSend( oPrn, "Say", 250, 1650, "TELEFONE: (11) 2462-3070 ", aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
	oSend( oPrn, "Say", 150, 1650, "RUA ECHAPORÃ, 227/231 - CUMBICA ", aFontes:TIMES_NEW_ROMAN_12 )
	oSend( oPrn, "Say", 220, 1650, "GUARULHOS - SP 07224-090 ", aFontes:TIMES_NEW_ROMAN_12 )
	oSend( oPrn, "Say", 290, 1650, "TELEFONE: (11) 2462-3070 ", aFontes:TIMES_NEW_ROMAN_12 )
//	oSend( oPrn, "Say", 150, 0150, "Espelhos Leao"  , aFontes:TIMES_NEW_ROMAN_12_NEGRITO )

//oPrn:Box(0200,0130,0500,2400)  
//oSend(oPrn,"Line", 0200, 1790, 0500, 1790 ) 
oPrn:Box(0350,0130,0900,2400)  
oSend(oPrn,"Line", 0350, 1790, 0900, 1790 ) 

//cContat := Trim(Posicione("SU5",1,xFilial("SU5")+SUA->UA_CODCONT,"U5_CONTAT"))
//if empty(cContat)
	cContat := sa1->a1_contato
//endif

linha := 400
oSend( oPrn, "Say", Linha    , 0150, "Código   Razão Social (Nome)" , aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
oSend( oPrn, "Say", Linha    , 1800, "PROPOSTA : "+sua->(ua_num+" "+ua_setor) , aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
Linha := Linha + 70
oSend( oPrn, "Say", Linha    , 0150, sa1->a1_cod+"-"+sa1->a1_loja+" "+ALLTRIM(sa1->a1_nome) , aFontes:TIMES_NEW_ROMAN_12 )
Linha := Linha + 70
if !empty(cContat)
	oSend( oPrn, "Say", Linha    , 0150, "Contato  :" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 0300, cContat , aFontes:TIMES_NEW_ROMAN_10 )
Endif
oSend( oPrn, "Say", Linha    , 1800, "Emissão : "+dtoc(SUA->UA_emissao)+"  Hora :"+time() , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha + 70
oSend( oPrn, "Say", Linha    , 0150, "Endereço de Faturamento"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1000, iif(!empty(cBairro),"Bairro","")  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1700, "UF"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1800, "Cond.Pagto : "+sua->UA_CONDPG +"  "+se4->e4_descri  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha + 70
oSend( oPrn, "Say", Linha    , 0150, ALLTRIM(sa1->a1_end ), aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1000, iif(!empty(cBairro),cBairro,"")  , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1700, sa1->a1_est  , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1800, "Frete : "+iif(sua->ua_TPFRETE='C','CIF','FOB') , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha + 70
oSend( oPrn, "Say", Linha    , 0150, "CEP   : " , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 0300, left(sa1->a1_cep,5)+"-"+right(sa1->a1_cep,3)+"  "+trim(sa1->a1_mun)+"-"+sa1->a1_est , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1000, iif(!empty(cTel),"Telefone:","")  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1150, iif(!empty(cTel),cTel,"")  , aFontes:TIMES_NEW_ROMAN_10 )
cOperador := Trim(Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_NOME"))
oSend( oPrn, "Say", Linha    , 1800, "Operador : "+AllTrim(SUA->UA_OPERADO)+" - "+cOperador, aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha + 70
oSend( oPrn, "Say", Linha    , 0150, "CNPJ : ", aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 0300, cCgc, aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1000, " I.E./RG:" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1150, cRG , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1450, "Suframa :" , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1600, cSuframa , aFontes:TIMES_NEW_ROMAN_10 )
Select SA3
Seek xFilial()+sua->ua_vend
oSend( oPrn, "Say", Linha    , 1800, "Vend.:"+left(sa3->a3_nome,20)  , aFontes:TIMES_NEW_ROMAN_10 )
Linha := Linha + 100
oSend( oPrn, "Say", Linha    , 1800, "Validade da proposta 15 dias ", aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
Linha := Linha + 100
Select SD2
dbSetOrder(3)
Seek xFilial()+sua->ua_numsc5
dFat := ctod("0")
cNota :=""
if !eof()
	dFat  := sd2->d2_emissao
	cNota := sd2->d2_doc
endif
Select SUB       
dbSetOrder(1)
Seek xFilial()+trim(SUA->UA_NUM)
Select SE4
Seek xFilial()+sua->ua_condpg
Select SA4
Seek xFilial()+sua->ua_transp
// Montagem do segundo Box
oPrn:Box(0980,0130,1350,2400)  
//oSend(oPrn,"Line", 0850, 1790, 1250, 1790 ) 

//Linha := Linha + 30
oSend( oPrn, "Say", Linha    , 0150, "Transportadora  "  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1900, "Previsão de Entrega  "  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha + 50
oSend( oPrn, "Say", Linha    , 0150, sa4->a4_nome  , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1900, dtoc(sub->UB_DTENTRE) , aFontes:TIMES_NEW_ROMAN_10 )
Linha := Linha + 50
oSend( oPrn, "Say", Linha    , 0150, "Endereço Entrega  "  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1100, "Bairro  "  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1700, "Cidade"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 2000, "UF"  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha + 50
oSend( oPrn, "Say", Linha    , 0150, SUA->UA_ENDENT , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1100, SUA->UA_BAIRROE  , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 1700, SUA->UA_MUNE , aFontes:TIMES_NEW_ROMAN_10 )
oSend( oPrn, "Say", Linha    , 2000, SUA->UA_ESTE , aFontes:TIMES_NEW_ROMAN_10 )
Linha := Linha + 70
//oSend( oPrn, "Say", Linha    , 0150, "N?mero da Nota  "  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
//oSend( oPrn, "Say", Linha    , 1100, "Data do Faturamento  "  , aFontes:TIMES_NEW_ROMAN_10_NEGRITO )
Linha := Linha + 50
//oSend( oPrn, "Say", Linha    , 0150, cNota  , aFontes:TIMES_NEW_ROMAN_10 )
//oSend( oPrn, "Say", Linha    , 1100, dtoc(dFat)   , aFontes:TIMES_NEW_ROMAN_10 )

//cabec()
oPrn:Box(1370,0130,1450,2400)  

Linha := 1400 //Linha + 070
oSend( oPrn, "Say", Linha    , 0140, "It."       	, aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 0220, "Código"     	, aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 0500, "Produto"    	, aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 0500, ""           	, aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1550, "UM"         	, aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1750, "Qtde"		 	, aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 1950, "Val.Unit"		, aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha    , 2150, "Val.Total"	, aFontes:COURIER_NEW_10_NEGRITO )

Linha := 1500

nTotQtd := 0
nTotVal := 0
nTotIpi := nTotSol := nTotIcm := nValorTot := tDescZFM := 0
nDescZfr:= nTotimp := 0
lSuframa := .f.                    
dentr := sub->ub_dtentre // iif(!empty(sub->ub_dtentre),sub->ub_dtentre,date())
Do while !eof() .and. SUB->UB_NUM == SUA->UA_NUM

    Select SF4
    Seek xFilial()+SUB->UB_TES
    Select SB1
    Seek xFilial()+SUB->UB_PRODUTO

	nValIpi := nValSol := nValIcm := nDescZFM := 0
	CalcImp01()
//	CalcImp()
	do Case
	Case Alltrim(SUA->UA_SETOR) == "A"
		nFator := 2
		nValIpi := nValIpi*.5
		nValSol := nValSol*.5
		nDescZFM:= nDescZFM*.5
		tDescZFM+= nDescZFM
	Case Alltrim(SUA->UA_SETOR) == "B"
		nFator := 5
		nValIpi := nValIpi*.2
		nValSol := nValSol*.2
		nDescZFM:= nDescZFM*.2
		tDescZFM+= nDescZFM
	Case Alltrim(SUA->UA_SETOR) == "C"
		nFator := 1
	Case Alltrim(SUA->UA_SETOR) == "S"
		nFator := 0
		nValIpi:= 0
		nValSol:= 0
		nDescZFM:= 0
		tDescZFM:= 0
	Endcase
	
	nTotImp += (nValIpi +  nValSol - nDescZFM)

    Select SUB
	cDescri	:= sb1->b1_desc
	If left(sc6->c6_produto,2)='38'
		cDescri	:= trim(sb1->b1_desc)+" ("+alltrim(str(sub->ub_qtdpc))+" PC)"  // LE - 04/11/2019 - Inclus?o da qtde em M2
	endif
    oSend( oPrn, "Say", Linha    , 0140, sub->ub_item+"-"+ALLTRIM(sb1->b1_cod)    , aFontes:COURIER_NEW_09 )
//    oSend( oPrn, "Say", Linha    , 0500, ALLTRIM(left(sb1->b1_desc,50))   , aFontes:COURIER_NEW_10 )
    oSend( oPrn, "Say", Linha    , 0500, ALLTRIM(cDescri)   , aFontes:COURIER_NEW_10 )
    oSend( oPrn, "Say", Linha    , 1550, ALLTRIM(sb1->b1_UM)     , aFontes:COURIER_NEW_10 )
	if sub->ub_quant - int(sub->ub_quant) <> 0
	    oSend( oPrn, "Say", Linha    , 1700, trans(sub->ub_quant  ,"@E 9,999.99")      , aFontes:COURIER_NEW_09 )
	else
	    oSend( oPrn, "Say", Linha    , 1700, trans(sub->ub_quant  ,"@E 999,999")      , aFontes:COURIER_NEW_09 )
    endif
    oSend( oPrn, "Say", Linha    , 1900, trans((sub->ub_vlritem+nValIpi+nValSol-nDescZFM)/sub->ub_quant ,"@E 999,999.9999") , aFontes:COURIER_NEW_09 )
//    oSend( oPrn, "Say", Linha    , 1900, trans(sub->ub_valipi ,"@E 999,999.9999") , aFontes:COURIER_NEW_09 )
	if sub->ub_dtentre = dDatabase
		reclock("SUB",.f.)
		sub->ub_dtentre := dEntr
		MsUnLock()
	endif

	if sub->ub_tes$"543*559"
	    oSend( oPrn, "Say", Linha    , 2100, trans(sub->(ub_quant*ub_vrunit),"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
//		nDescZfr += sub->(ub_quant*ub_vrunit) - sub->ub_vlritem
//		nDescZfr += sub->(ub_quant*ub_vrunit)* 0.1065
		nDescZfr += sub->(ub_quant*ub_valipi) - sub->ub_vlritem
		nDescZfr += sub->(ub_quant*ub_valipi)* 0.1065
		lSuframa := .t.
	else
//	    oSend( oPrn, "Say", Linha    , 2120, trans(sub->(ub_quant*ub_vrunit),"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
	    oSend( oPrn, "Say", Linha    , 2120, trans((sub->ub_vlritem+nValIpi+nValSol-nDescZFM),"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
		if sub->(ub_quant*ub_vrunit) <> sub->ub_vlritem
			RecLock("SUB",.F.)
			sub->ub_vlritem := sub->(ub_quant*ub_vrunit)
			MsUnLock()
		endif
//	    oSend( oPrn, "Say", Linha    , 2140, trans(sub->ub_vlritem,"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
    endif
	if sf4->f4_ipi=="N"
		nIpi := 0
	else
		nIpi := sb1->b1_ipi
	endif
	
    Linha := Linha+50 
//    If Linha >= 2500
    If Linha >= 2650
	Linha := Linha+200
	oSend( oPrn, "Say", Linha, 0150, "Continua ..."  , aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
	ENCERRA_PAGINA
	COMECA_PAGINA
	nPg++
	Linha := 100
	oSend( oPrn, "Say", Linha, 1100, "Pag. "+strzero(npg,3), aFontes:TIMES_NEW_ROMAN_12_NEGRITO )

// Monta Cabe?alho
	oSend(oPrn, "SayBitmap", 0150, 0200, "lgrl01.BMP" , 200, 150 )
	oSend( oPrn, "Say", 250, 1050, "ORÇAMENTO ", aFontes:TIMES_NEW_ROMAN_12_NEGRITO )
	oSend( oPrn, "Say", 150, 1650, "RUA ECHAPORÃ, 227/231 - CUMBICA ", aFontes:TIMES_NEW_ROMAN_12 )
	oSend( oPrn, "Say", 220, 1650, "GUARULHOS - SP 07224-090 ", aFontes:TIMES_NEW_ROMAN_12 )
	oSend( oPrn, "Say", 290, 1650, "TELEFONE: (11) 2462-3070 ", aFontes:TIMES_NEW_ROMAN_12 )

//	Cabec()
	Linha := 400 //Linha + 070
	oPrn:Box(0370,0130,0450,2400)  
	oSend( oPrn, "Say", Linha    , 0140, "It."       	, aFontes:COURIER_NEW_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 0220, "Código"     	, aFontes:COURIER_NEW_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 0500, "Produto"    	, aFontes:COURIER_NEW_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 0500, ""           	, aFontes:COURIER_NEW_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 1550, "UM"         	, aFontes:COURIER_NEW_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 1750, "Qtde"		 	, aFontes:COURIER_NEW_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 1950, "Val.Unit"		, aFontes:COURIER_NEW_10_NEGRITO )
	oSend( oPrn, "Say", Linha    , 2150, "Val.Total"	, aFontes:COURIER_NEW_10_NEGRITO )

	Linha := 500

    Endif
	nTotQtd += sub->ub_quant
//	nTotVal += sub->(ub_quant*ub_vrunit) //sub->ub_vlritem
	nTotVal += sub->ub_vlritem //sub->ub_vlritem
	Select SC6
	Seek xFilial()+sub->(UB_NumPV+UB_itemPV)
	//RecLock("SC6",.f.)
	//sc6->C6_ENTREG := dEntr            
	//MsUnLock()
	if sua->ua_setor = 'A'
		Seek xFilial()+"P"+substr(sub->UB_NumPV,2,5)+sub->UB_itemPV
		//RecLock("SC6",.f.)
		//sc6->C6_ENTREG := dEntr            
		//MsUnLock()
	Endif
	
    Select SUB
    Skip
Enddo
/*nFator := 1         
if sua->ua_setor = 'A'
	nFator := 2
endif
*/
// Montagem do primeiro Box Rodap?
//oPrn:Box(2650,0130,2800,2400)  
if lSuframa
	oPrn:Box(2550,0130,2800,2400)
else
	oPrn:Box(2650,0130,2800,2400)
Endif

Select SC5
dbSetOrder(1)
dbSeek(xFilial()+sua->ua_numsc5)
if lSuframa
	linha := 2575
Else
	linha := 2675
Endif
oSend( oPrn, "Say", Linha    , 0140, "Peso Bruto :", aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha+50 , 0140, Transform(SC5->C5_PBruto, "@E 99,999.99" )+" Kg", aFontes:COURIER_NEW_09 )

oSend( oPrn, "Say", Linha    , 0500, "Volumes :", aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha+50 , 0450, Transform(SC5->C5_Volume1, "@E 99999" )+" "+SC5->C5_Especi1, aFontes:COURIER_NEW_09 )

oSend( oPrn, "Say", Linha    , 0800, "Total de Pecas  " , aFontes:COURIER_NEW_10_NEGRITO )
oSend( oPrn, "Say", Linha , 2100, "Total a pagar    " , aFontes:COURIER_NEW_10_NEGRITO )
linha := linha + 50 //2725
if sub->ub_quant - int(sub->ub_quant) <> 0
oSend( oPrn, "Say", Linha    , 0800, trans(nTotQtd ,"@E 9,999.99") , aFontes:COURIER_NEW_09 )
else
oSend( oPrn, "Say", Linha    , 0800, trans(nTotQtd ,"@E 999,999") , aFontes:COURIER_NEW_09 )
endif
oSend( oPrn, "Say", Linha  , 2100, trans(nTotVal+nTotImp+tDescZFM  ,"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
if lSuframa // nDescZfr <> 0                                                       
//	nValSuframa := (ntotval+ (nDescZfr)-sua->ua_valbrut)/nFator
	linha := linha + 50
	oSend( oPrn, "Say", Linha    , 1400, "Desc.Zona Franca " , aFontes:COURIER_NEW_09 )
	oSend( oPrn, "Say", Linha    , 2100, trans(tDescZFM ,"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
//	oSend( oPrn, "Say", Linha    , 2100, trans(nValSuframa ,"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
	linha := linha + 50
	oSend( oPrn, "Say", Linha    , 1400, "Total Liquido    " , aFontes:COURIER_NEW_09 )
	oSend( oPrn, "Say", Linha    , 2100, trans(nTotVal + nTotImp  ,"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
//	oSend( oPrn, "Say", Linha    , 2100, trans(nTotVal - nValSuframa  ,"@E 99,999,999.99") , aFontes:COURIER_NEW_09 )
endif

** Rodap? do relat?rio
// Montagem do SEGUNDO Box Rodap?

oPrn:Box(2850,0130,3000,2400)  

oSend( oPrn, "Say", 2900    , 0140, "Obs:"+sua->ua_obs1 , aFontes:COURIER_NEW_09 )

nLin := 2950

cMemo     := alltrim( MSMM(SUA->UA_CODOBS) )
nMemCount := MlCount( cMemo ,100 )

cLinha := ''
If !Empty( nMemCount )
	For nLoop := 1 To nMemCount
		cLinha += trim(MemoLine( cMemo, 100, nLoop ,2,.t.))+"  "
		if len(trim(cLinha))>80 .or. nLoop = nMemCount     // novo - para quebrar a linha apenas com 132 caracteres
//			oSend( oPrn, "Say", nLin , 0130, StrTran( StrTran( cLinha, Chr(13), "" ), Chr(10), "" ) , aFontes:COURIER_NEW_09 )
			nLin := nLin + 50
			cLinha := ''
		endif
	Next
Endif


Return .T.


//C?lculo de Impostos
Static Function CalcImp01()

 nItAtu := 1
 NQTDPESO := 0
 //nTotIPI := 0
 nValorTot := 0

nBasICM := nValICM := nValIPI := nAlqICM := 0
nAlqIPI := nValSol := nBasSol := nPrcUniSol := nDescZFM := 0 

//Posicionar na SC5 com DbSeek antes desse trecho
 
MaFisIni(SUA->UA_CLIENTE,;                   // 01 - Codigo Cliente/Fornecedor
    SUA->UA_LOJA,;                        // 02 - Loja do Cliente/Fornecedor
    "C",;    // 03 - C:Cliente , F:Fornecedor
    "N",;                           // 04 - Tipo da NF
    SUA->UA_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
    MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
    ,;                                       // 07 - Tipo de complemento
    ,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
    "SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
    "MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao
         
//Enquanto houver itens
//SUB->(DbSeek(FWxFilial('SUB') + SUA->UA_NUM))
//While ! SUB->(EoF()) .And. SUB->UB_NUM == SUA->UA_NUM
     
    //Adiciona o item nos tratamentos de impostos
    SB1->(DbSeek(FWxFilial("SB1")+SUB->UB_PRODUTO))
    MaFisAdd(SUB->UB_PRODUTO,;    // 01 - Codigo do Produto                    ( Obrigatorio )
        SUB->UB_TES,;             // 02 - Codigo do TES                        ( Opcional )
        SUB->UB_QUANT,;          // 03 - Quantidade                           ( Obrigatorio )
        SUB->UB_VRUNIT,;          // 04 - Preco Unitario                       ( Obrigatorio )
        SUB->UB_VALDESC,;         // 05 - Desconto
        SC6->C6_NFORI,;           // 06 - Numero da NF Original                ( Devolucao/Benef )
        SC6->C6_SERIORI,;         // 07 - Serie da NF Original                 ( Devolucao/Benef )
        0,;                       // 08 - RecNo da NF Original no arq SD1/SD2
        0,;                       // 09 - Valor do Frete do Item               ( Opcional )
        0,;                       // 10 - Valor da Despesa do item             ( Opcional )
        0,;                       // 11 - Valor do Seguro do item              ( Opcional )
        0,;                       // 12 - Valor do Frete Autonomo              ( Opcional )
        SUB->UB_VLRITEM,;           // 13 - Valor da Mercadoria                  ( Obrigatorio )
        0,;                       // 14 - Valor da Embalagem                   ( Opcional )
        SB1->(RecNo()),;          // 15 - RecNo do SB1
        0)                        // 16 - RecNo do SF4
     
    MaFisLoad("IT_VALMERC", SUB->UB_VLRITEM, nItAtu)                
    MaFisAlt("IT_PESO", nQtdPeso, nItAtu)
     
//    SUB->(DbSkip())
//EndDo
         
//Altera dados do cabe?alho
MaFisAlt("NF_FRETE", SC5->C5_FRETE)
MaFisAlt("NF_SEGURO", SC5->C5_SEGURO)
MaFisAlt("NF_DESPESA", SC5->C5_DESPESA) 
MaFisAlt("NF_AUTONOMO", SC5->C5_FRETAUT)
If SC5->C5_DESCONT > 0
    MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, SC5->C5_DESCONT+MaFisRet(, "NF_DESCONTO")) )
EndIf
If SC5->C5_PDESCAB > 0
    MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*SC5->C5_PDESCAB/100, "C6_VALOR") + MaFisRet(, "NF_DESCONTO"))
EndIf
 
//Agora reposiciona nos itens para poder pegar os dados
//SUB->(DbGoTop())
//SUB->(DbSeek(FWxFilial('SUB') + SUA->UA_NUM))
//While ! SUB->(EoF()) .And. SUB->UB_NUM == SUA->UA_NUM                
    //Pega os valores
    nBasICM    += MaFisRet(nItAtu, "IT_BASEICM")
    nValICM    += MaFisRet(nItAtu, "IT_VALICM")
    nValIPI    += MaFisRet(nItAtu, "IT_VALIPI")
    nAlqICM    += MaFisRet(nItAtu, "IT_ALIQICM")
    nAlqIPI    += MaFisRet(nItAtu, "IT_ALIQIPI")
    nValSol    += (MaFisRet(nItAtu, "IT_VALSOL")) /// SUB->UB_QUANT) 
    nBasSol    += MaFisRet(nItAtu, "IT_BASESOL")
    nPrcUniSol += SC6->C6_PRCVEN + nValSol
    //nTotSol    += nPrcUniSol * SC6->C6_QTDVEN
    //nTotalST   += MaFisRet(nItAtu, "IT_VALSOL")
	nDescZFM += MaFisRet(nItAtu,"IT_DESCZF" ) //Desconto Zona Franca

    nTotIPI    += nValIPI
    nTotSol    += nValSol
    nTotIcm    += nValICM
    nValorTot  += SUB->UB_VLRITEM
     
//    SUB->(DbSkip())
//EndDo
nTotFrete := MaFisRet(, "NF_FRETE")
//nTotVal := MaFisRet(, "NF_TOTAL")
MaFisEnd()

//Agora reposiciona nos itens para poder pegar os dados
//SUB->(DbGoTop())
//SUB->(DbSeek(FWxFilial('SUB') + SUA->UA_NUM))
 
//Alert(nTotIPI)
