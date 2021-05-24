# Include 'rwmake.ch'
# Include 'avprint.ch'  

  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User function carta()
SetPrvt("CNDESC1,CNDESC2,CNDESC3,CNDESC4,CNDESC5,CNDESC6")
SetPrvt("CCOD1,CCOD2,CCOD3,CCOD4,CCOD5,CCOD6")
SetPrvt("CNOME,CTIPO,WNREL,TAMANHO,NTIPO,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,CPERG,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,LI,LIMITE,CSTRING,_ADESC,NREGS")
SetPrvt("ADRIVER,NDRIVER,NCOPIA,_XDRV,X,AREGISTRO")
SetPrvt("CALIAS,I,J,")
 
aCor := {}
aDescr:={}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 pergunte("CARTA",.T.)

cNDesc1:= cNDesc2:= cNDesc3:= cNDesc4:= cNDesc5:= cNDesc6:=Space(60)
cCod1  := cCod2  := cCod3  := cCod4  := cCod5  := cCod6:=Space(02)
@ 156,112 to 585,735 DIALOG oDlg TITLE "Carta de Correcao em Nota Fiscal Numero"
cnome :=  " "
if mv_par01==2
   dbSelectArea("SF2")     && Abertura dos arquivo de Cabecalho da NF
   dbSetOrder(1)
   dbSeek(xFilial("SF2")+mv_par02+mv_par03)
   If Found()
   dbSelectArea("SA1") 
   dbSetOrder(1)
   dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
    cnome := A1_NOME
    cdescri := SF2->F2_Cliente+"/"+SF2->F2_loja+" - "+cNome
      @ 006,008 say cdescri
         cTipo:="Saida"
   dbSelectArea("SF2")
   endif
else
   dbSelectArea("SF1")     && Abertura dos arquivo de Cabecalho da NF
   dbSetOrder(1)
   dbSeek(xFilial("SF1")+mv_par02+mv_par03)
   If Found()
   dbSelectArea("SA2") 
   dbSetOrder(1)
   dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
    cnome := A2_NOME
    cdescri := SF1->F1_FORNECE+"/"+SF1->F1_LOJA+" - "+cNome
      @ 006,008 say cdescri
     cTipo:="Entrada"     
   dbSelectArea("SF1")
   Endif
endif
 
aadd(adescr,{ "01"," Razao Social"," "})
aadd(adescr,{"02"," Endereco"," " })
aadd(adescr,{ "03"," Cid / Estado / Mun. / CEP"," "})
aadd(adescr,{ "04"," Nro Nota Fiscal"," " })
aadd(adescr,{"05"," CNPJ(MF)"," " })
aadd(adescr,{ "06"," Inscrição Estadual/Munic"," "})
aadd(adescr,{"07"," Codigo da  Operação"," "})
aadd(adescr,{ "08"," Natureza da Operação"," "})
aadd(adescr,{ "09"," Volume      "," "})
aadd(adescr,{ "10"," Data de Emissao"," "})
aadd(adescr,{ "11"," Data de Saida"," " })
aadd(adescr,{ "12"," Unidade" ," "})
aadd(adescr,{"13"," Descrição/Cód. do Produto"," "})
aadd(adescr,{"14"," Quantidade de Produto"," "})
aadd(adescr,{ "15"," Preço Unitário"," "})
aadd(adescr,{"16"," Valor Total dos Produtos"," "})
aadd(adescr,{"17"," Classificação  Fiscal"," "})
aadd(adescr,{ "18"," Aliquota de  IPI"," "})
aadd(adescr,{"19"," Valor IPI"," "})
aadd(adescr,{"20"," Base de Calculo IPI"," "})
aadd(adescr,{ "21"," Valor Total da Nota"," "})
aadd(adescr,{"22"," Aliquota de  ICMS"," "})
aadd(adescr,{"23"," Valor ICMS"," "})
aadd(adescr,{ "24"," Base de Calculo ICMS"," "})
aadd(adescr,{ "25"," Nome Transportadora"," "})
aadd(adescr,{"26"," Endereço Transportadora"," "})
aadd(adescr,{ "27"," Termo de Isenção IPI"," "})
aadd(adescr,{"28"," Termo de Isenção ICMS"," "})
aadd(adescr,{"29"," Peso Bruto / Liquido"," "})
aadd(adescr,{"30"," Especie"," "})
aadd(adescr,{"31"," Tipo Frete"," "})
aadd(adescr,{"32"," Condição de Pagamento"," "})
aadd(adescr,{"33"," Observação corpo da Nota"," "})
aadd(adescr,{"34"," Local de Entrega"," "})
aadd(adescr,{"35"," Endereço de Cobranca"," "})
aadd(adescr,{"99"," Outros"," "})

@ 018,008 TO 155,300 TITLE "DESCRICAO"
nlin := 28
ncol :=10
for n=1 to 12
@ nlin,ncol Say adescr[n][1]
@ nlin,ncol+14 Say adescr[n][2] 
@ nlin,ncol+90 Say adescr[n+12][1]
@ nlin,ncol+104 Say adescr[n+12][2]
@ nlin,ncol+180 Say adescr[n+24][1]
@ nlin,ncol+194 Say adescr[n+24][2]
nlin:=nlin+10
next

@ 160,008 TO 208,300 TITLE "CORRECOES"
@ 172,011 get cCod1  PICTURE "99"
@ 172,025 get cNDesc1 PICTURE "@!"
 
@ 172,150 get cCod2  PICTURE "99"
@ 172,164 get cNDesc2 PICTURE "@!"

@ 184,011 get cCod3  PICTURE "99"
@ 184,025 get cNDesc3 PICTURE "@!"

@ 184,150 get cCod4  PICTURE "99"
@ 184,164 get cNDesc4 PICTURE "@!"

@ 196,011 get cCod5  PICTURE "99"
@ 196,025 get cNDesc5 PICTURE "@!"

@ 196,150 get cCod6  PICTURE "99"
@ 196,164 get cNDesc6 PICTURE "@!"

@ 006,180 BUTTON "_IMPRIMIR" Size 50,10 ACTION IMP()
@ 006,240 BUTTON "_SAIR" Size 50,10 ACTION Close(ODlg)
ACTIVATE DIALOG oDlg CENTERED


 
Return        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³Imp  ³ Autor ³ Crisitna Barroso    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime carta de correcao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
Static Function IMP()                        
CLOSE(ODLG)
 for i=1 to 6
ccod :="ccod"+STR(i,1)
cNdesc := "cNdesc"+STR(i,1)
aadd(acor,{&ccod,&cNdesc})
if !empty(&ccod) .and. val(&ccod)> 0 .and. val(&ccod)<= 36
adescr[val(&ccod)][3]:="X"
endif
next  




Private nPagina := 0
cStatus := Space(1) 
AVPRINT oPrn NAME "avprint"
oPrn:SetPortrait()


oFont1 := oSend(TFont(),"New","Arial"          ,0,12,,.F.,,,,,,,,,,,oPrn)  
oFont2 := oSend(TFont(),"New","Arial"           ,0,16,,.T.,,,,,,,,,,,oPrn)  
oFont3 := oSend(TFont(),"New","Arial"           ,0,12,,.F.,,,,,,,,,,,oPrn)  
oFont4 := oSend(TFont(),"New","Times New Roman"  ,0,10,,.F.,,,,,,,,,,,oPrn)  

aFontes := { oFont1, oFont2, oFont3, oFont4} 

impcarta()
 nPagina := 0    
 AvEndPage
AvEndPrint
 Return .t.


Static Function ImpCarta()

 
AVNEWPAGE
nPagina++

//oSend(oPrn,"ofont",ofont3)

oPrn:Box(0252,1440,0708,2352)  

oPrn:Box(0888,0144,0942,0228)     
oPrn:Box(0948,0144,1002,0228)  

oPrn:Box(1194,0096,1264,0252)  
oPrn:Box(1194,0252,1264,1200)  
oPrn:Box(1264,0096,2354,0156)  
oPrn:Box(1264,0156,2354,0252)  
oPrn:Box(1264,0252,2354,1200)  

oPrn:Box(1194,1248,1264,1404)  
oPrn:Box(1194,1404,1264,2352)  
oPrn:Box(1264,1248,2354,1308)  
oPrn:Box(1264,1308,2354,1404)  
oPrn:Box(1264,1404,2354,2352)  

oPrn:Box(2374,0096,2444,0396)  
oPrn:Box(2444,0096,2804,0396)  
oPrn:Box(2374,0396,2444,2352)  
oPrn:Box(2444,0396,2804,2352)  

oPrn:Say(0132,0600,SM0->M0_NOMECOM              , aFontes[2],,,,3)  
oPrn:Say(0252,0096,"SAO PAULO,"             , aFontes[3],,,,3)
oPrn:Say(0252,0464,dtoc(dDataBase)             , aFontes[3],,,,3)
oPrn:Say(0396,0096,"A(o)"             , aFontes[3],,,,3)
oPrn:Say(0336,1644,TRANS(SM0->M0_CGC,"@R 99.999.999/9999-99")             , aFontes[3],,,,3)
 
 
oPrn:Say(0450,0096, Substr(cNome,1,50) , aFontes[3],,,,3)  
//oPrn:Say(0450,1504, SUBSTR(SM0->M0_ENDENT,1,28) , aFontes[3],,,,3)
oPrn:Say(0450,1504, SUBSTR("Rua Echapora, 227 / 231 ",1,28) , aFontes[3],,,,3)
oPrn:Say(0510,0096,MV_par04 , aFontes[3],,,,3)  
oPrn:Say(0510,1504,"Cumbica - CEP 07224-090" , aFontes[3],,,,3)
 
oPrn:Say(0630,0096, "Prezado(s) Senhor(es)"  , aFontes[3],,,,3) 
oPrn:Say(0570,1694,SUBSTR(SM0->M0_CIDENT,1,10) + " - " + SM0->M0_ESTENT , aFontes[3],,,,3)
 
 
 
oPrn:Say(0780,0096,"Ref.: COMUNICADO DE IRREGULARIDADES EM DOCUMENTO FISCAL.              " , aFontes[3],,,,3)
cDoc  := cDoc1:= space(6)
cData := cData1:= space(8)

if ctipo=="Saida"
oPrn:Say(0890,0172,"X" , aFontes[3],,,,3)
*oPrn:Say(0890,0756,SF2->F2_Doc, aFontes[3],,,,3)
*oPrn:Say(0890,1356,DTOC(SF2->F2_Emissao), aFontes[3],,,,3)
cDoc := sf2->f2_doc
cData:= dtoc(sf2->f2_emissao)
else
oPrn:Say(0950,0172,"X" , aFontes[3],,,,3)
*oPrn:Say(0950,0756,SF1->F1_Doc, aFontes[3],,,,3)
*oPrn:Say(0950,1356,DTOC(SF1->F1_DTDIGIT), aFontes[3],,,,3)
cDoc1 := sf1->f1_doc
cData1:= dtoc(sf1->f1_emissao)
endif
*oPrn:Say(0890,0264,"       N/ Nota Fiscal Nro                       Serie  Unica  De                " , aFontes[3],,,,3)
*oPrn:Say(0950,0264,"       S/ Nota Fiscal Nro                       Serie  Unica  De                " , aFontes[3],,,,3)
oPrn:Say(0890,0264,"       N/ Nota Fiscal Nro "+cDoc +" Serie  Unica  De "+cData , aFontes[3],,,,3)
oPrn:Say(0950,0264,"       S/ Nota Fiscal Nro "+cDoc1+" Serie  Unica  De "+cData1, aFontes[3],,,,3)

oPrn:Say(1070,0096, "Em atendimento as disposicoes da Lesgislacao Fiscal, comunicamos que a Nota Fiscal em referencia contem", aFontes[4],,,,3)
oPrn:Say(1130,0096, "a(s) irregularidade(s)  que  abaixo  apontamos, cuja  correcao solicitamos providenciar(em):", aFontes[4],,,,3)

*oPrn:Say(1200,0124," Cod           Especificacao                                                          Cod           Especificacao    ", aFontes[3],,,,3)       
//oPrn:Say(1200,0124," Cod           Especificacao                  Cod         Especificacao    ", aFontes[3],,,,3)       
  oPrn:Say(1200,0124," Cod           Especificacao                                                         Cod         Especificacao    ", aFontes[3],,,,3) 
nlin := 1264
for i=1 to 18
oPrn:Say(nlin,0110,adescr[i][3] , aFontes[3],,,,3)
oPrn:Say(nlin,0172,adescr[i][1] , aFontes[3],,,,3)
oPrn:Say(nlin,0268,adescr[i][2] , aFontes[3],,,,3)
oPrn:Say(nlin,1262,adescr[i+18][3] , aFontes[3],,,,3)
oPrn:Say(nlin,1324,adescr[i+18][1] , aFontes[3],,,,3)
oPrn:Say(nlin,1420,adescr[i+18][2] , aFontes[3],,,,3)
nlin := nlin + 60
next
 nlin := nlin + 40
oPrn:Say(nlin,0100,"    Codigos             Retificacoes a serem consideradas                    ", aFontes[3],,,,3)
 nlin := nlin + 70
for i=1 to len(acor)
oPrn:Say(nlin,0172,acor[i][1] , aFontes[3],,,,3)
oPrn:Say(nlin,0405,acor[i][2] , aFontes[3],,,,3)
nlin := nlin + 60
next
nlin := nlin + 20   

oPrn:Say(nlin,0096, "Para evitar-se qualquer sancao fiscal,solicitamos acusarem o recebimento desta,na copia que a acompanha,", aFontes[4],,,,3)
oPrn:Say(nlin+60,0096, "devendo a via de V.Sa(s) ficar  arquivada junto a Nota Fiscal em questao.", aFontes[4],,,,3)
oPrn:Say(nlin+120,0096, "Acusamos o recebimento da 1a. VIA                                     Atenciosamente,     ", aFontes[3],,,,3)
oPrn:Say(nlin+360,0096,"  _______________________        ____________________      ___________________________________", aFontes[3],,,,3)
oPrn:Say(nlin+420,0096,"   Carimbo e Assinatura                          Local e Data                       "+SUBSTR(SM0->M0_NOMECOM,1,27), aFontes[3],,,,3)

Return .t.
 
