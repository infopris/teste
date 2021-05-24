#include "rwmake.ch"        

User Function RELADM()        // Rela‡ao de AdmissÆo

lCheck1 := .t.
lCheck2 := .t.
lCheck3 := .t.
lCheck4 := .t.
lCheck5 := .f.

@ 0,0 TO 250,450 DIALOG oDlg1 TITLE ""
@ 16,20 TO 77,170 TITLE "Relatorios Admissionais"
@ 23,45 CHECKBOX "Contrato Experiencia" VAR lCheck1
@ 33,45 CHECKBOX "Compensacao de Horas" VAR lCheck2
@ 43,45 CHECKBOX "Devolucao CTPS      " VAR lCheck3
@ 53,45 CHECKBOX "Vale Transporte     " VAR lCheck4
@ 63,45 CHECKBOX "Contrato Aprendiz   " VAR lCheck5

@ 20,196 BMPBUTTON TYPE 1 ACTION OkProc()
@ 35,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1

Return nil

*************************
Static Function OKProc()
*************************
if lCheck5=.t.
	cResp := space(20)
	nhoras:= 6
	@ 196,52 TO 343,505 DIALOG oDlg2 TITLE "Responsável"
	@ 10,030 Say "Nome do Responsável " 
	@ 20,030 Say "(quando menor)" 
	@ 10,100 get cResp  picture "@!" SIZE 60,20
	@ 30,030 Say "Horas/Dia" 
	@ 30,100 get nHoras picture "@E 9" SIZE 60,20 Valid (nHoras=4 .or. nHoras=6)
	@ 50,120 BUTTON "_Confirma" Size 40,15  ACTION Close(oDlg2)
	ACTIVATE DIALOG oDlg2 CENTERED
endif
aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1 }
cbtxt    := Space(10)
cbcont   := 0
cDesc1   := "Este programa ira emitir o Relatorio para admissao"
cDesc2   := ""
cDesc3   := ""
cPerg    := "FOL003"
cString  := "SRA"
li       := 80
m_pag    := 1
nLastKey := 0
nomeprog := "RFOL003"
titulo   := "Admissao"
wnrel    := "RELADM"
limite   := 80
tamanho  := "P"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas :                                                  ³
//³ mv_par01  // Matricula                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as Perguntas selecionadas.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio com os Itens do Pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus( { ||C030Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> RptStatus( { ||Execute(C030Imp)})

MS_FLUSH()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C030Imp  ³ Autor ³ Luiz Eduardo          ³ Data ³ 19/08/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C030Imp                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico p/ Espelhos Leao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 05/10/01 ==> Function C030Imp

Static Function C030Imp()                  

Cabec1 := "Num  Matr"
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7
Cabec2 := ""
Select SRA
dbSetOrder(1)
seek xFilial()+mv_par01
Select SRJ
Seek xFilial()+sra->ra_codfunc
Select SRA

li := 80
Cabec("","","","","P")
If li > 60
//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
Endif           
if lcheck1
@ 001,000 PSAY chr(18)
@ 001,000 PSAY "                CONTRATO DE TRABALHO A TITULO DE EXPERIENCIA                         "     
@ 002,000 PSAY ""
@ 003,000 PSAY "Por este instrumento particular, que entre si fazem a firma, LEAO INDUSTRIA E        "
@ 004,000 PSAY "COMERCIO DE ESPELHO E PLASTICOS LTDA,empresa estabelecida na Rua Echapora,   "
@ 005,000 PSAY "227/231 na cidade de Guarulhos- Estado de Sao Paulo, a seguir denominada     "
@ 006,000 PSAY "simplesmente EMPREGADORA e, de outro lado,"+sra->ra_nome
@ 007,000 PSAY "Titular da CTPS No "+sra->ra_numcp+" Serie "+sra->ra_sercp+" e do PIS "+sra->ra_pis
@ 008,000 PSAY "doravante chamado simplesmente EMPREGADO, firmam o presente contrato individual      "
@ 009,000 PSAY "de trabalho, em carater de experiencia , conforme a letra C paragrafo 2o do          "
@ 010,000 PSAY "Artigo 443 da Consolidacao  das Leis do trabalho mediante as seguintes condicoes:    "
@ 011,000 PSAY ""
@ 012,000 PSAY "1- O EMPREGADO trabalhara para a EMPREGADORA, exercendo a funcao de,"
@ 013,000 PSAY srj->rj_desc+" percebendo o salario de R$ "
@ 013,pcol()+1 PSAY sra->ra_salario picture "@E 999,999.99"
@ 013,pcol()+1 PSAY "por mes."
@ 014,000 PSAY "2- O horario de trabalho do empregado sera o seguinte:"
@ 015,000 PSAY "   2a a 6a : 08:00/12:00:13:00/17:48 com 1:00 p/descanso e alimentacao."
@ 016,000 PSAY "   Aos sabados : LIVRE"
@ 017,000 PSAY "3- Este contrato tem inicio a  partir de,"+dtoc(ra_admissa)+" vencendo-se em,"+dtoc(ra_admissa+29)
@ 018,000 PSAY "   podendo ser prorrogado, obedecido o disposto no Paragrafo inico do artigo "
@ 019,000 PSAY "   445 da CLT."
@ 020,000 PSAY "4- O Empregado se compromete a trabalhar em regime de compensacao e de  "
@ 021,000 PSAY "   prorrogacao de horas, inclusive em periodo noturno, sempre que as   "
@ 022,000 PSAY "   necessidades assim o exigirem, observadas as formalidades legais."
@ 023,000 PSAY "5- Obriga-se o EMPREGADO, alem de executar com dedicacao e lealdade seu servico,"
@ 024,000 PSAY "   a cumprir  o  Regulamento  Interno da  EMPREGADORA,  as  instrucoes  de  sua "
@ 025,000 PSAY "   administracao e as ordens de seus chefes e superiores hierarquicos, relativas"
@ 026,000 PSAY "   as peculiaridades dos servicos que lhe forem confiados."
@ 027,000 PSAY "6- Aplicam-se a este contrato todas as normas em vigor, relativas aos contratos"
@ 028,000 PSAY "   a prazo determinado, devendo sua rescisao antecipada,por justa causa obedecer"
@ 029,000 PSAY "   ao disposto nos artigos 482 e 483 da CLT, conforme o caso."
@ 030,000 PSAY "7- Vencido o periodo experimental e continuando o empregado a prestar servicos a"
@ 031,000 PSAY "   EMPREGADORA, por tempo indeterminado , ficam prorrogadas todas as clausulas"
@ 032,000 PSAY "   aqui estabelecidas , enquanto nao se reincidir o contrato de trabalho."
@ 033,000 PSAY ""
@ 034,000 PSAY "E por estarem de pleno acordo,assinam ambas as partes,em duas vias de igual teor. "
@ 035,000 PSAY ""
@ 036,000 PSAY "Guarulhos, "+dtoc(ra_admissa)
@ 037,000 PSAY ""
@ 038,000 PSAY "______________________________                    ______________________________"
@ 039,000 PSAY "LEAO IND.COM.ESP.PLAST.LTDA                       "+sra->ra_nome  
@ 040,000 PSAY ""
@ 041,000 PSAY ""
@ 042,000 PSAY "TERMO DE PRORROGACAO"
@ 043,000 PSAY "Por mutuo acordo entre as partes, fica o presente contrato de experiencia , que"
@ 044,000 PSAY "deveria vencer nesta data prorrogado ate ______/______/______"
@ 045,000 PSAY ""
@ 046,000 PSAY "Data:______/______/______    ASSINATURA _____________________________"
endif

if lcheck2
@ 001,000 PSAY "                   ACORDO PARA COMPENSACAO DE HORAS DE TRABALHO"
@ 002,000 PSAY ""
@ 003,000 PSAY ""
@ 004,000 PSAY "Entre a LEAO INDUSTRIA E COMERCIO DE ESPELHOS E PLASTICOS LTDA, estabalecida em 
@ 005,000 PSAY "Guarulhos, Estado de Sao Paulo a RUA ECHAPORA, 227/231, com o ramo de Ind. e 
@ 006,000 PSAY "Comercio de Espelhos e Plasticos, e o seu empregado abaixo assinado, portador
@ 007,000 PSAY "da Carteira Profissional No."+ra_numcp+" Serie "+ra_sercp+" fica convencionado
@ 008,000 PSAY "de acordo com o disposto no Art. 59 e seu paragrafo 2o (Aprovado pelo Decreto 
@ 009,000 PSAY "Lei No 5.452 de 01 de Maio de 1943), (Consolidacao das Leis do Trabalho), que 
@ 010,000 PSAY "o horario de Trabalho Normal sera o seguinte:"
@ 011,000 PSAY ""
@ 012,000 PSAY "De 2a a 6a Feira: 08:00/12:00:13:00/17:48 com 1:00 p/ Descanso e Refeicao."
@ 013,000 PSAY ""
@ 014,000 PSAY "Aos sabados: LIVRE"
@ 015,000 PSAY ""
@ 016,000 PSAY "Perfazendo o total de 44 horas semanais."
@ 017,000 PSAY ""
@ 018,000 PSAY "E, por estarem de pleno acordo, as partes contratantes assinam o presente acordo "
@ 019,000 PSAY "em duas vias , o qual vigorara por prazo indeterminado."
@ 020,000 PSAY ""
@ 021,000 PSAY ""
@ 022,000 PSAY "Guarulhos,"+dtoc(ra_admissa)
@ 023,000 PSAY ""
@ 024,000 PSAY ""
@ 025,000 PSAY "________________________"
@ 026,000 PSAY sra->ra_nome
@ 027,000 PSAY ""
@ 028,000 PSAY "______________________________"
@ 029,000 PSAY "LEAO IND.COM.ESP.PLAST.LTDA"
Endif

if lcheck3
@ 001,000 PSAY "COMPROVANTE DE DEVOLUCAO DE CARTEIRA DE TRABALHO"
@ 002,000 PSAY ""
@ 003,000 PSAY ""
@ 004,000 PSAY "Nome da Empresa:  LEAO IND. E COM. DE ESPELHOS E PLAST.LTDA"
@ 005,000 PSAY ""
@ 006,000 PSAY "Nome do Empregado:"+sra->ra_nome
@ 007,000 PSAY ""
@ 008,000 PSAY "Carteira Trabalho:"+ra_numcp+"  Serie:"+ra_sercp
@ 009,000 PSAY ""
@ 010,000 PSAY "Cargo/Funcao: "+srj->rj_desc+" Admissao: "+dtoc(ra_admissa)
@ 011,000 PSAY ""
@ 012,000 PSAY ""
@ 013,000 PSAY ""
@ 014,000 PSAY "Recebi em devolucao a Carteira de Trabalho e Previdencia Social, com as devidas"
@ 015,000 PSAY " anotacoes."
@ 016,000 PSAY ""
@ 017,000 PSAY ""
@ 018,000 PSAY "GUARULHOS, "+dtoc(ra_admissa)
@ 019,000 PSAY ""
@ 020,000 PSAY "________________________"
@ 021,000 PSAY sra->ra_nome
Endif

if lcheck4
@ 001,000 PSAY "              VALE TRANPORTE / DECLARACAO / TERMO DE COMPROMISSO"
@ 002,000 PSAY "1- O Vale Transporte sera pago pelo beneficiario ate o limite de 6% (seis por "
@ 003,000 PSAY "   cento) de seu salario (excluido quaisquer adicionais ou vantagens) e pelo  "
@ 004,000 PSAY "   empregador, no que exceder a esse limite."
@ 005,000 PSAY "2- No caso em que o valor total dos vales recebidos for inferior a 6% (seis "
@ 006,000 PSAY "   por cento) do salario , o empregado podera optar pelo recebimento antecipado"
@ 007,000 PSAY "   do Vale-Transporte,cujo o valor sera integralmente descontado por ocasiao "
@ 008,000 PSAY "   do pagamento do respectivo salario."
@ 009,000 PSAY "3- Nao e permitido substituir o fornecimento de Vale Transporte por antecipacao"
@ 010,000 PSAY "   em dinheiro ou qualquer outra forma de pagamento salvo no caso de falta ou "
@ 011,000 PSAY "   insuficiencia de estoque de Vale-Transporte."
@ 012,000 PSAY "==============================================================="
@ 013,000 PSAY "EMPREGADOR"
@ 014,000 PSAY "Nome: LEAO IND. E COM. DE ESP. E PLASTICOS LTDA"
@ 015,000 PSAY "End.    RUA ECHAPORA, 227/231"
@ 016,000 PSAY "================================================================="
@ 017,000 PSAY "EMPREGADO"
@ 018,000 PSAY "Nome:"+sra->ra_nome
@ 019,000 PSAY "CTPS/SERIE:"+ra_numcp+"/"+ra_sercp
@ 020,000 PSAY "================================================================"
@ 021,000 PSAY "OPCAO PELO SISTEMA DO VALE TRANSPORTE"
@ 022,000 PSAY "O vale-Transporte e um direito do trabalhador. Faca sua opcao por recebe-lo"
@ 023,000 PSAY "ou nao assinalando um dos quadros abaixo."
@ 024,000 PSAY ""
@ 025,000 PSAY "(       ) SIM         (       ) NAO         ________________________________"
@ 026,000 PSAY "                                            "+sra->ra_nome
@ 027,000 PSAY "Obs. Qualquer que seja sua opcao, o formulario total ou parcialmente preenchido"
@ 028,000 PSAY " e assinado, deve ser encaminhado ao setor de pessoal."
@ 029,000 PSAY "================================================================"
@ 030,000 PSAY "DECLARACAO"
@ 031,000 PSAY "Para fazer uso do Vale-Transporte, declaro:"
@ 032,000 PSAY "1- Residir "+trim(ra_enderec)+" "+trim(ra_complem)+"-"+trim(ra_bairro)+"-"+trim(ra_Municip)+"-"+trim(ra_estado)
@ 033,000 PSAY "2- Utilizar o (s) seguinte (s) meio(s) de transporte de minha residencia ao  "
@ 034,000 PSAY "trabalho e vice -versa."
@ 035,000 PSAY "(   ) ONIBUS   (   ) METRO  (    ) TREM  (      ) OUTROS (especificar)"
@ 036,000 PSAY "2.1- No perimetro: (     ) MUNICIPAL (     ) INTERMUNICIPAL   "
@ 037,000 PSAY "2.2- Atraves da(s) seguinte(s) operadora(s) .Somente nos casos intermunicipais "
@ 038,000 PSAY "     e interestaduais)."
@ 039,000 PSAY "_______________________________________________________________________________"
@ 040,000 PSAY "_______________________________________________________________________________"
@ 041,000 PSAY "2.3- Utilizar diariamente _______conducoes para locomover-me de minha residencia"
@ 042,000 PSAY "     ao trabalho e vice-versa."
@ 043,000 PSAY "TERMO DE COMPROMISSO /  AUTORIZACAO PARA DESCONTO"
@ 044,000 PSAY "Comprometo-me a atualizar as informacoes acima,anualmente ou sempre que ocorre-"
@ 045,000 PSAY "rem alteracoes e a utilizar os Vales-Tranportes que me forem concedidos exclu-"
@ 046,000 PSAY "sivamente no pecurso residencia-trabalho e vice-versa. Estou ciente de que, na "
@ 047,000 PSAY "hipotese de infrigir tal compromisso, a empresa podera dispensar-me por justa "
@ 048,000 PSAY "causa,nos termos do art. 7o do Decreto no 95.247/87."
@ 049,000 PSAY "Autorizo a empresa a descontar mensalmente dos meus vencimentos, ate o limite de"
@ 050,000 PSAY "6% (seis por cento) do meu salario, o valor destinado a cobrir o fornecimento de "
@ 051,000 PSAY "Vales-Transportes por mim utilizados."
@ 052,000 PSAY ""
@ 053,000 PSAY "Guarulhos, "+dtoc(ra_admissa)
@ 054,000 PSAY ""
@ 055,000 PSAY ""
@ 056,000 PSAY "_____________________________________     _____________________________________"
@ 057,000 PSAY  sra->ra_nome+"            Leao Ind.e Com.de Esp.E Plast.Ltda"
Endif

if lcheck5
if nHoras = 6
	cHoras := 'Seis'
else 
	cHoras := 'Quatro'
endif
@ 001,030 PSAY "CONTRATO DE APRENDIZAGEM"
@ 004,000 PSAY "Pelo presente instrumento particular, nesta e na melhor forma de direito que "
@ 005,000 PSAY "entre si firmam, de um lado a empresa Leao Ind. e Com. de Esp. e  Plast.Ltda,"
@ 006,000 PSAY "em Guarulhos-SP, inscrita no CNPJ do Ministério da Fazenda sob "
@ 007,000 PSAY "nº 62.356.969/0001-57,com sede á Rua Echapora,227/231, neste ato representada"
@ 008,000 PSAY "por seu procurador/diretor abaixo assinado, doravante designada EMPREGADOR, e"
@ 009,000 PSAY "do outro lado o (a)menor/senhor(a)"+trim(sra->ra_nome)+", residente e "
@ 010,000 PSAY "domiciliado(a) em "+trim(ra_enderec)+" "+trim(ra_complem)+" "+trim(ra_bairro)+"-"+trim(ra_Municip)+"-"+trim(ra_estado)+","
@ 011,000 PSAY "portador(a) da CTPS :"+ra_numcp+" SERIE:"+ra_sercp+", doravante designado(a) APRENDIZ,"
@ 012,000 PSAY "neste ato assistido(a) pelo seu(sua) responsável legal,Sr.(a)"+cResp
@ 013,000 PSAY "(quando menor), ao final assinado, fica justo e acertado o presente CONTRATO DE"
@ 014,000 PSAY "APRENDIZAGEM, mediante as cláusulas e condições seguintes:"
@ 015,000 PSAY ""
@ 016,000 PSAY "Cláusula Primeira - O EMPREGADOR admite a seus serviços o (a) APRENDIZ, "
@ 017,000 PSAY "comprometendo-se a propiciar formação profissional na ocupação de "
@ 018,000 PSAY trim(srj->rj_desc)+" ,sob regime de aprendizagem."
@ 019,000 PSAY ""
@ 020,000 PSAY "Cláusula Segunda -A aprendizagem referida na Cláusula Primeira desenvolver-se-á em"
@ 021,000 PSAY "duas fases: a primeira no SENAI (SENAC)(SENAT) e a segunda, sob a forma de estágio"
@ 022,000 PSAY "de prática profissional,no estabelecimento do EMPREGADOR."
@ 023,000 PSAY ""
@ 024,000 PSAY "Cláusula Terceira -A duração máxima da fase de Prática Profissional na empresa "
@ 025,000 PSAY "será de 24 (vinte e quatro) meses,com jornada diária de "+Transform(nHoras,"@E 9")+"("+cHoras+") horas."
@ 026,000 PSAY ""
@ 027,000 PSAY "Cláusula Quarta -O salário do (a) APRENDIZ, como forma de contraprestação será de"
@ 028,000 PSAY "R$"+Transform(sra->ra_salario,"@E 999,999.99")+"("+EXTENSO(SRA->RA_SALARIO)+")"
@ 029,000 PSAY "não sendo, em nenhuma hipótese,inferior ao salário mínimo hora, conforme dispõe "
@ 030,000 PSAY "a Lei nº 10.097/00."
@ 031,000 PSAY ""
@ 032,000 PSAY "Cláusula Quinta -O EMPREGADOR declara ser conhecedor de toda legislação pertinente"
@ 033,000 PSAY "ao objeto do presente contrato, bem como se compromete a cumprir os dispositivos"
@ 034,000 PSAY "legais preconizados nos artigos 428 a 433 da Consolidação das Leis do Trabalho,"
@ 035,000 PSAY "com a alteração dada pela Lei 10.097/00, como também as Portarias 20/2001 e "
@ 036,000 PSAY "04/2002,da Secretaria de Inspeção do Trabalho e da Diretoria do Departamento de " 
@ 037,000 PSAY "Segurança e Saúde do Trabalho do Ministério do Trabalho e Emprego e ainda a "
@ 038,000 PSAY "Medida Provisória de nº 251, de 14/06/2005."
@ 039,000 PSAY ""
@ 040,000 PSAY "Cláusula Sexta - O EMPREGADOR obriga-se a registrar na Carteira de Trabalho e 
@ 041,000 PSAY "Previdência Social do (a)APRENDIZ,a vigência do presente CONTRATO DE APRENDIZAGEM."
@ 042,000 PSAY ""
@ 043,000 PSAY "Cláusula Sétima - O (A) APRENDIZ compromete-se a exibir ao EMPREGADOR, sempre que "
@ 044,000 PSAY "solicitado, o documento emitido pela Instituição de ensino profissionalizante que "
@ 045,000 PSAY "comprove sua freqüência às aulas e registre o seu aproveitamento escolar."
@ 046,000 PSAY ""
@ 047,000 PSAY "Cláusula Oitava - Sempre que o (a) APRENDIZ deixar de comparecer à instituição de"
@ 048,000 PSAY "ensino profissionalizante, durante a fase escolar da aprendizagem, ou ao"
@ 049,000 PSAY "estabelecimento do EMPREGADOR durante o período de prática profissional, sem"
@ 050,000 PSAY "justificativa fundamentada, perderá o salário dos dias faltosos."
@ 051,000 PSAY ""
@ 052,000 PSAY "Cláusula Nona - Durante o período de recesso escolar, o (a) APRENDIZ poderá ser"
@ 053,000 PSAY "convocado (a) pelo EMPREGADOR para prestação de serviços em seu estabelecimento,"
@ 054,000 PSAY " observando-se a Consolidação das Leis do Trabalho no que concerne a férias e"
@ 055,000 PSAY "limites de trabalho diário."
@ 056,000 PSAY ""
@ 059,000 PSAY "1/2"
@ 006,000 PSAY "Cláusula Décima - O (A) APRENDIZ obriga-se a:"
@ 007,000 PSAY "a)	Participar regularmente das aulas e demais atos escolares na instituição de"
@ 008,000 PSAY "ensino profissionalizante em que estiver matriculado, bem como a cumprir o"
@ 009,000 PSAY "Regulamento e disposições disciplinares existentes naquela Unidade;"
@ 010,000 PSAY "b)	Obedecer às normas e regulamentos vigentes no estabelecimento do EMPREGADOR,
@ 011,000 PSAY "mormente às relativas à saúde e Segurança do Trabalho, durante a fase de "
@ 012,000 PSAY "realização da prática profissional."
@ 013,000 PSAY "Cláusula Décima Primeira - O não cumprimento pelo (a) APRENDIZ de seus deveres,"
@ 014,000 PSAY "bem como a falta de razoável aproveitamento na aprendizagem, ou a inobservância"
@ 015,000 PSAY "pelo EMPREGADOR das obrigações assumidas neste Instrumento, serão consideradas" 
@ 016,000 PSAY "causas justas para a rescisão do presente CONTRATO DE APRENDIZAGEM, como também"
@ 017,000 PSAY " a conclusão do Curso, o atingimento da idade limite (24 anos) ou o período "
@ 018,000 PSAY "máximo de 02 (dois) anos de contrato."
@ 019,000 PSAY ""
@ 020,000 PSAY "E por estarem justos e contratados, assinam o presente instrumento em 03 (três) 
@ 021,000 PSAY "vias de igual teor e forma, na presença das testemunhas abaixo nomeadas."
@ 021,000 PSAY ""
@ 033,000 PSAY "Guarulhos, "+dtoc(ra_admissa)
@ 035,000 PSAY ""
@ 036,000 PSAY ""
@ 037,000 PSAY "_____________________________________     _____________________________________"
@ 038,000 PSAY  sra->ra_nome+"            Leao Ind.e Com.de Esp.E Plast.Ltda"
@ 039,000 PSAY ""
@ 040,000 PSAY "__________________________"
@ 041,000 PSAY "RESPONSÁVEL LEGAL (se menor)"
@ 059,000 PSAY "2/2"


Endif

//@ li,000 PSAY nNum picture "999"
//@ li,005 PSAY src->rc_mat
//@ li,012 PSAY sra->ra_nome
//@ li,045 PSAY Replicate("_",30)
//li := li + 1



IF LI <> 80
	RODA(CBCONT,CBTXT,Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Spool de Impressao.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil
