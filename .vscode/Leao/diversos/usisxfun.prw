#include "rwmake.ch" 
#include "protheus.ch"
#include "colors.CH"          
#include "topconn.ch"

#DEFINE _EOL chr(13) + chr(10)  // Pula a linha.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CadSX5   � Autor � Felipe Raposo      � Data �  05/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Monta browser do cadastro de tabelas somente com registros ���
���          � da tabela passada por parametro.                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _cTabelaP - tabela que sera navegada.                      ���
���          � _cDescr1P - descricao do campo X5_CHAVE.                   ���
���          � _cDescr2P - descricao do campo X5_DESCRI.                  ���
���          � _cValidP  - validacao da inclusao ou alteracao de registro.���
���          � _cVldExcP - validacao da exclusao de registro.             ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CadSX5(_cTabelaP, _cDescr1P, _cDescr2P, _cValidP, _cVldExcP, _cPict1P, _cPict2P)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _aArea    := U_GetArea({"SX5"})
Local _cArquivo := CriaTrab(nil, .F.)
Local _cIndice  := SX5->(IndexKey(1))  // Indice 1 => X5_FILIAL, X5_TABELA, X5_CHAVE.
Local _cFiltro  := "X5_FILIAL == '" + xFilial("SX5") + "' .and. X5_TABELA == '" + _cTabelaP + "'"
Local _aCampos  := {{_cDescr1P, "X5_CHAVE", _cPict1P}, {_cDescr2P, "X5_DESCRI", _cPict2P}}
Private _cTabela := _cTabelaP
Private _cDescr1 := U_ValPad(_cDescr1P, Posicione("SX3", 2, "X5_CHAVE",  "X3_TITULO"))
Private _cDescr2 := U_ValPad(_cDescr2P, Posicione("SX3", 2, "X5_DESCRI", "X3_TITULO"))
Private _cValid  := U_ValPad(_cValidP,  "AlwaysTrue()")
Private _cVldExc := U_ValPad(_cVldExcP, "AlwaysTrue()")
Private _cPict1  := U_ValPad(_cPict1P, "@!")
Private _cPict2  := U_ValPad(_cPict2P, "@!")
Private aRotina, cAlias := "SX5", cCadastro := Posicione("SX5", 1, xFilial("SX5") + "00" + _cTabela, "AllTrim(X5_DESCRI)")

// Filtra somente a tabela necessaria.
IndRegua(cAlias, _cArquivo, _cIndice,, _cFiltro, "Selecionando registros...")

// Monta menu de rotinas.
aRotina := {;
{"Pesquisar",  "U_CadSX5a", 0, 1},;
{"Visualizar", "U_CadSX5a", 0, 2},;
{"Incluir",    "U_CadSX5a", 0, 3},;
{"Alterar",    "U_CadSX5a", 0, 4},;
{"Excluir",    "U_CadSX5a", 0, 5}}

// Acerta o indice da tabela.
SX5->(dbSetOrder(1))  // X5_FILIAL, X5_TABELA, X5_CHAVE.

// Monta browser de registros.
mBrowse(06, 01, 22, 75, cAlias, _aCampos)

// Limpa o filtro.
dbSelectArea(cAlias)
Set Filter To
U_RestArea(_aArea)
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CadSX5a  � Autor � Felipe Raposo      � Data �  05/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Abre o registro posicionado para edicao.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametro � _cAlias  - Alias que esta sendo atualizado.                ���
���          � _nReg    - Registro posicionado.                           ���
���          � _nOpcPar - 2 - visualizar                                  ���
���          �            3 - incluir                                     ���
���          �            4 - alterar                                     ���
���          �            5 - remover                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Utilizado pelo programa U_CadSX5().                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CadSX5a(_cAlias, _nReg, _nOpcPar)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _oDlg1, _oSay1, _oGet1, _oSay2, _oGet2, _oBtnOk, _oBtnCan
Local _cTitulo := IIf(_nOpcPar == 1, "Pesquisa", cCadastro), _nOpcUsr := 2
Local _aObj1, _aObj2, _aObj3, _aObj4, _aObj5
Private INCLUI := (_nOpcPar == 3), ALTERA := (_nOpcPar == 4), EXCLUI := (_nOpcPar == 5)
Private _cVldSis := "IIf(empty(m->X5_CHAVE) .or. empty(m->X5_DESCRI), (MsgAlert('Preencha os campos com valores v�lidos', 'Aten��o'), .F.), .T.)"
Private _cVldChv := "ExistChav('SX5', '" + _cTabela + "' + m->X5_CHAVE)"
Private _cValida := IIf(EXCLUI, _cVldExc, IIf(INCLUI .or. ALTERA, _cValid, "AlwaysTrue()"))

// Atualiza as variaveis de memoria.
If str(_nOpcPar, 1) $ "13"  // Se for visualizacao ou inclusao.
	M->X5_CHAVE  := CriaVar("X5_CHAVE",  .F.)
	M->X5_DESCRI := CriaVar("X5_DESCRI", .F.)
Else
	M->X5_CHAVE  := SX5->X5_CHAVE
	M->X5_DESCRI := SX5->X5_DESCRI
Endif

// Posicao dos objetos.
If _nOpcPar == 1  // 1 - Pesquisa.
	_aObj1 := {08, 00, 013, 30}		// _oDlg1
	_aObj2 := {10, 04}				// _oSay1
	_aObj3 := {10, 30, 030, 04}		// _oGet1
	_aObj4 := {25, 60}				// _oBtnOk
	_aObj5 := {25, 90}				// _oBtnCan
Else
	_aObj1 := {08, 00, 017, 56}		// _oDlg1
	_aObj2 := {17, 04}				// _oSay1
	_aObj3 := {27, 04, 030, 04}		// _oGet1
	_aObj4 := {41, 04}				// _oSay2
	_aObj5 := {51, 04, 160, 04}		// _oGet2
Endif

// Monta e exibe a tela.
Define msDialog _oDlg1 title _cTitulo from _aObj1[1], _aObj1[2] to _aObj1[3], _aObj1[4] of oMainWnd
_oSay1 := TSay():New(_aObj2[1], _aObj2[2], {|| _cDescr1}, _oDlg1,,,,,,.T., CLR_BLUE,,,,,,,,)
_oGet1 := TGet():New(_aObj3[1], _aObj3[2], {|u| IIf(PCount() == 0, M->X5_CHAVE, M->X5_CHAVE := u)}, _oDlg1, _aObj3[3], _aObj3[4], _cPict1, {|| &_cVldChv}, CLR_BLACK,,,,, .T., "Chave",, {|| str(_nOpcPar, 1) $ "13"},,,,,,,,,,,)

If _nOpcPar == 1  // 1 - Pesquisa.
	_oBtnOk  := sButton():New(_aObj4[1], _aObj4[2], 1, {|| _nOpcUsr := 1, _oDlg1:End()})
	_oBtnCan := sButton():New(_aObj5[1], _aObj5[2], 2, {|| _nOpcUsr := 2, _oDlg1:End()})
	Activate msDialog _oDlg1 centered
Else
	_oSay2 := TSay():New(_aObj4[1], _aObj4[2], {|| _cDescr2}, _oDlg1,,,,,, .T., CLR_BLUE,,,,,,,,)
	_oGet2 := TGet():New(_aObj5[1], _aObj5[2], {|u| IIf(PCount() == 0, M->X5_DESCRI, M->X5_DESCRI := u)}, _oDlg1, _aObj5[3], _aObj5[4], _cPict2,, CLR_BLACK,,,,, .T., "Descri��o",, {|| str(_nOpcPar, 1) $ "34"},,,,,,,,,,,)
	Activate msDialog _oDlg1 centered on init EnchoiceBar(_oDlg1, {|| IIf(&_cVldSis .and. &_cValida, (_nOpcUsr := 1, _oDlg1:End()), nil)}, {|| _nOpcUsr := 2, _oDlg1:End()})
Endif

// Grava os dados na tabela.
If _nOpcUsr == 1
	If _nOpcPar == 1  // 1 - Pesquisa.
		SX5->(dbSeek(xFilial("SX5") + _cTabela + m->X5_CHAVE, .T.))
	ElseIf _nOpcPar > 2
		// Grava o registro.
		RecLock("SX5", _nOpcPar == 3)
		
		// Verifica se eh para excluir.
		If _nOpcPar == 5  // 5 - Excluir.
			SX5->(dbDelete())
		Else
			SX5->X5_FILIAL := xFilial("SX5")
			SX5->X5_TABELA := _cTabela
			SX5->X5_CHAVE  := m->X5_CHAVE
			SX5->(X5_DESCRI := X5_DESCSPA := X5_DESCENG := m->X5_DESCRI)
		Endif
		SX5->(msUnLock())
	Endif
Endif
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VerAlias � Autor � Felipe Raposo      � Data �  22/10/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se o alias passado por parametro esta aberto ou   ���
���          � nao. Se nao estiver, a funcao abre.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _cAlias - alias que sera aberto.                           ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VerAlias(_cAlias)

// Verifica se o alias esta aberto.
If !(_cAlias $ cArqTab)
	// Se nao estiver, abre.
	ChkFile(_cAlias, .F.)
Endif

// Seleciona o alias.
dbSelectArea(_cAlias)
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Gatilho  � Autor � Felipe Raposo      � Data �  22/10/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Executa os gatilhos cadastrados referentes ao campo passa- ���
���          � do por parametro.                                          ���
���          � Essa funcao so executa gatilhos do tipo "P" (primario).    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _cCampo  - campo que tera os gatilhos disparados.          ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Gatilho(_cCampo)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nAux1, _aAreas := U_GetArea({"SX3", "SX7"})
Private _cCDomin, _cRegra

// Posiciona o campo que tera os gatilhos disparados.
If !empty(U_ValPad(_cCampo, ""))
	SX3->(dbSetOrder(2))  // X3_CAMPO.
	If SX3->(dbSeek(upper(AllTrim(_cCampo)), .F.))
		_cCampo := SX3->X3_CAMPO
	Endif
ElseIf !empty(SX3->X3_CAMPO)
	_cCampo := SX3->X3_CAMPO
Endif

// Testa se o campo possui gatilhos.
If SX3->(!eof() .and. X3_TRIGGER == "S") .and. !empty(_cCampo)
	// Posiciona o cadastro de gatilhos.
	SX7->(dbSetOrder(1))  // X7_CAMPO + X7_SEQUENC.
	SX7->(dbSeek(SX3->X3_CAMPO, .F.))
	
	// Processa todos os gatilhos do campo.
	Do While SX7->(!eof()) .and. SX7->X7_CAMPO == _cCampo
		
		// Analisa a condicao do gatilho antes de processa-lo.
		If SX7->X7_TIPO == "P"
			
			// Posiciona o alias, se necessario.
			If SX7->X7_SEEK == "S"
				dbSelectArea(SX7->X7_ALIAS)
				dbSetOrder(SX7->X7_ORDEM) // Atencao (UPDXFUN).
				dbSeek(&(SX7->X7_CHAVE), .F.)
			Endif
			
			// Faz a validacao do gatilho antes de atualizar o contra-dominio.
			If (empty(SX7->X7_CONDIC) .or. &(SX7->X7_CONDIC))
				// Executa a regra do gatilho.
				_cCDomin := SX7->X7_CDOMIN
				_cRegra  := SX7->X7_REGRA
				m->(&_cCDomin) := &_cRegra
				
				// Se o gatilho for executado pela aCols, atualiza a aCols tambem.
				If Type("aHeader") == "A" .and. (_nAux1 := GdFieldPos(_cCDomin)) != 0
					aCols[n, _nAux1] := m->(&_cCDomin)
				Endif
			Endif
		Endif
		
		// Processa o proximo gatilho.
		SX7->(dbSkip())
	EndDo
Endif

// Restaura as condicoes anteriores dos alias.
U_RestArea(_aAreas)
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AjustaX1 � Autor � Felipe Raposo      � Data �  13/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ajusta a tabela de perguntas (SX1) de acordo com os para-  ���
���          � metros passados.                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametro � _cPerg - grupo das perguntas passadas.                     ���
���          � _aAjustaX1 - matriz com as perguntas de acordo com o lay-  ���
���          �              out abaixo:                                   ���
���          �    1 - Ordem da pergunta (obrigatorio)                     ���
���          �    2 - Descricao da pergunta (obrigatorio)                 ���
���          �    3 - Objeto  =>   C=Combo / G=Get (obrigatorio)          ���
���          �    4 - Array com opcoes do parametro (obrigatorio)         ���
���          �      No caso de Get (texto):                               ���
���          �        4.1 - Tipo  =>  C=Caracter / N=Numerico / D=Data    ���
���          �        4.2 - Tamanho (obrigatorio, exceto em campo data)   ���
���          �        4.3 - Decimal (opcional)                            ���
���          �        4.4 - Consulta padrao F3 (opcional)                 ���
���          �        4.5 - Validacao do Get                              ���
���          �      No caso de Combo:                                     ���
���          �        4.1 - Selecao padrao (opcional)                     ���
���          �        4.2 - Opcao 1 em portugues (obrigatorio)            ���
���          �        4.3 - Opcao 2 em portugues (obrigatorio)            ���
���          �        4.4 - Opcao 3 em portugues (opcional)               ���
���          �        4.5 - Opcao 4 em portugues (opcional)               ���
���          �        4.6 - Opcao 5 em portugues (opcional)               ���
���          �    5 - Help do parametro em portugues (opcional)           ���
���          �    6 - Help do parametro em ingles (opcional)              ���
���          �    7 - Help do parametro em espanhol (opcional)            ���
���          �        Esses tres parametros de help deverao ser matrizes  ���
���          �        contendo as linhas do help.                         ���
���          �        Ex: {"linha 1", "linha 2", "linha 3"}               ���
���          � _lRefaz - sobrescreve as perguntas existentes (.T./.F.)?   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � Nenhum.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AjustaX1(_cPerg, _aAjustaX1, _lRefaz)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nAux1, _lAchou
Local _cKey, _aHelpPor, _aHelpEng, _aHelpSpa

// Acerta os valores padroes dos parametros.
_cPerg  := PadR(_cPerg, 10, " ")  // Completa espacos caso _cPerg tenha menos que 6 caracteres.
_lRefaz := U_ValPad(_lRefaz, .F.)

// Acerta a tabela SX1.
SX1->(dbSetOrder(1))  // X1_GRUPO, X1_ORDEM.
For _nAux1 := 1 to len(_aAjustaX1)
	
	// Posiciona o registro da pergunta e o abre para alteracao.
	// Se nao encontrar o registro, cria um novo.
	_lAchou := SX1->(dbSeek(_cPerg + _aAjustaX1[_nAux1, 1], .F.))
	RecLock("SX1", !_lAchou)  // Abre registro para edicao ou cria novo registro.
	
	// Atualiza a descricao da pergunta.
	SX1->X1_PERGUNT := _aAjustaX1[_nAux1, 2]
	
	// Se for inclusao ou esta marcado para refazer de qualquer jeito,
	// o sistema atualiza os outros campos.
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := _aAjustaX1[_nAux1, 1]
	SX1->X1_GSC     := _aAjustaX1[_nAux1, 3]
	If _aAjustaX1[_nAux1, 3] == "G"  // Get (texto).
		SX1->X1_TIPO    := _aAjustaX1[_nAux1, 4, 1]
		SX1->X1_TAMANHO := IIf(_aAjustaX1[_nAux1, 4, 1] == "D", 8, _aAjustaX1[_nAux1, 4, 2])
		SX1->X1_DECIMAL := IIf(len(_aAjustaX1[_nAux1, 4]) >= 3 .and. _aAjustaX1[_nAux1, 4, 1] == "N", _aAjustaX1[_nAux1, 4, 3], 0)
		SX1->X1_F3      := IIf(len(_aAjustaX1[_nAux1, 4]) >= 4, _aAjustaX1[_nAux1, 4, 4], "")
		SX1->X1_VALID   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 5, _aAjustaX1[_nAux1, 4, 5], "")		
		If !_lAchou .or. _lRefaz
			SX1->X1_CNT01 := ""  // Cria com conteudo em branco.
		Endif
	ElseIf _aAjustaX1[_nAux1, 3] == "C"  // Combo.
		SX1->X1_TIPO    := "N"  // Numerico.
		SX1->X1_TAMANHO := 01
		SX1->X1_DECIMAL := 00
		If !_lAchou .or. _lRefaz
			SX1->X1_PRESEL := U_ValPad(_aAjustaX1[_nAux1, 4, 1], 1)  // Nao obrigatorio.
		Endif
		SX1->X1_DEF01   := _aAjustaX1[_nAux1, 4, 2]  // Obrigatorio.
		SX1->X1_DEF02   := _aAjustaX1[_nAux1, 4, 3]  // Obrigatorio.
		SX1->X1_DEF03   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 4, _aAjustaX1[_nAux1, 4, 4], "")  // Nao obrigatorio.
		SX1->X1_DEF04   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 5, _aAjustaX1[_nAux1, 4, 5], "")  // Nao obrigatorio.
		SX1->X1_DEF05   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 6, _aAjustaX1[_nAux1, 4, 6], "")  // Nao obrigatorio.
	Endif
	
	// Monta o help para o item.
	_aHelpPor := IIf(len(_aAjustaX1[_nAux1]) >= 5, aClone(_aAjustaX1[_nAux1, 5]), {})
	_aHelpEng := IIf(len(_aAjustaX1[_nAux1]) >= 6, aClone(_aAjustaX1[_nAux1, 6]), {})
	_aHelpSpa := IIf(len(_aAjustaX1[_nAux1]) >= 7, aClone(_aAjustaX1[_nAux1, 7]), {})
	If !empty(_aHelpPor) .or. !empty(_aHelpEng) .or. !empty(_aHelpSpa)
		_cKey := "P." + AllTrim(_cPerg) + AllTrim(_aAjustaX1[_nAux1, 1]) + "."
		PutSX1Help(_cKey, _aHelpPor, _aHelpEng, _aHelpSpa)
	Endif
	
	// Salva as alteracoes na tabela.
	SX1->(msUnLock())
Next _nAux1
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CriaLog  � Autor � Felipe Raposo      � Data �  06/11/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Cria o arquivo de log na pasta \LOG.                       ���
���          � Caso o arquivo ja exista, apenas o abre.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametro � _cArquivo - nome do arquivo a ser aberto ou criado.        ���
���          � _lCabec   - indica se a mensagem de abertura ou criacao do ���
���          �             arquivo de log deve ser gravada.               ���
�������������������������������������������������������������������������͹��
���Retorno   � Numero do arquivo aberto.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CriaLog(_cArquivo, _lCabec)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nHd, _cArqLog
Local _nAux1, _cMsg
Local _cDir := "\" + CurDir()

// Acerta valores padroes dos parametros.
_lCabec := U_ValPad(_lCabec, .F.)

//���������������������������������������������������������������������Ŀ
//� Monta o arquivo de log.                                             �
//�����������������������������������������������������������������������
// Separa o arquivo do diretorio.
_cArquivo := StrTran(_cArquivo, "/", "\")  // Substitui as barras normais pelas invertidas.
If (_nAux1 := rat("\", _cArquivo)) != 0  // Separa o caminho (path) do nome do arquivo.
	_cAux1    := AllTrim(left(_cArquivo, _nAux1))
	_cAux1    := IIf(left(_cAux1, 1) == "\", right(_cAux1, len(_cAux1) - 1), _cAux1)
	_cDir     += _cAux1
	_cArquivo := AllTrim(right(_cArquivo, len(_cArquivo) - _nAux1))
Endif

// Cria o arquivo log com extensao .LOG no diretorio \LOGS.
_cArqLog := _cDir + "Logs\" + IIf((_nAux1 := at(".", _cArquivo)) == 0, _cArquivo, SubStr(_cArquivo, 1, _nAux1 - 1)) + ".LOG"
If file(_cArqLog)  // Cria um arquivo de log novo se ja nao existir.
	_nHd  := fOpen(_cArqLog, 2)  // Abre o arquivo para edicao.
	_cMsg := _EOL + _EOL + "*** Arquivo de log reaberto em " + dtoc(dDataBase) + ", �s " + time() + " ***" + _EOL
Else
	_nHd  := fCreate(_cArqLog)   // Cria o arquivo novo.
	_cMsg := "*** Arquivo de log criado em " + dtoc(dDataBase) + ", �s " + time() + " ***" + _EOL
Endif
If _lCabec
	fSeek(_nHd, 0, 2)    // Vai para o fim do arquivo.
	fWrite(_nHd, _cMsg)  // Grava a mensagem no arquivo de log.
Endif
//

Return(_nHd)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ValPad   � Autor � Felipe Raposo      � Data �  08/03/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna um valor padrao para a variavel, caso ela nao      ���
���          � tenha valor ainda.                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _uValor  - valor original. O que sera comparado.           ���
���          � _uValPad - caso o valor original seja invalido, sera retor-���
���          �            nado o valor passado nesse parametro.           ���
�������������������������������������������������������������������������͹��
���Retorno   � Sera retornado o valor original, caso esse seja validado;  ���
���          � senao sera retornado o valor padrao (segundo parametro).   ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ValPad(_uValor, _uValPad)
Return(IIf(ValType(_uValor) == ValType(_uValPad), _uValor, _uValPad))


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TamBytes � Autor � Felipe Raposo      � Data �  11/03/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna o valor passado no 1o parametro, ja formatado em   ���
���          � caracter ou numerico, de acordo com os parametros passados ���
���          � pelo usuario.                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _nTam   - valor original, que sera formatado e retornado.  ���
���          � _cTipo  - indica a grandeza do valor passado. Pode ser:    ���
���          �           B  - bytes (padrao)                              ���
���          �           KB - kilobytes (1024 bytes)                      ���
���          �           MB - megabytes (1024 kilobytes)                  ���
���          �           GB - gigabytes (1024 megabytes)                  ���
���          �           TB - terabytes (1024 gigabytes)                  ���
���          � _nSaida - indica o tipo de retorno da funcao. Pode ser:    ���
���          �           1 - saida caracter. Ex: "7,56 MB" (padrao).      ���
���          �           2 - saida matricial. Ex: {7.56, "MB"}.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TamBytes(_nTam, _cTipo, _nSaida)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _uRet, _nValSai, _cTpVal

// Acerta os valores padroes das variaveis, caso alguma nao tenha sido passada.
_cTipo  := U_ValPad(upper(_cTipo), "")
_nSaida := U_ValPad(_nSaida, 1)  // Saida padrao: 1 - caracter.
_nTam   := U_ValPad(_nTam, 0)
_nTam   := IIf(_nTam < 0, -_nTam, _nTam)  // Nao aceita valor negativo.

// Trata o valor passado por parametro e transforma em bytes.
Do Case
	Case empty(_cTipo) .or. _cTipo == "B" // Nao fazer nada.
	Case _cTipo == "KB"; _nTam *= 1024
	Case _cTipo == "MB"; _nTam *= (1024 ^ 2)
	Case _cTipo == "GB"; _nTam *= (1024 ^ 3)
	Case _cTipo == "TB"; _nTam *= (1024 ^ 4)
EndCase

// Calcula os valores da saida.
Do Case
	Case _nTam == 1;					_nValSai := _nTam;				_cTpVal := " byte"
	Case _nTam < 1000;	  				_nValSai := _nTam;				_cTpVal := " bytes"
	Case (_nTam / 1024) < 1000;			_nValSai := _nTam / 1024;		_cTpVal := " KB"  // Kilobytes.
	Case (_nTam / (1024 ^ 2)) < 1000;	_nValSai := _nTam / (1024 ^ 2);	_cTpVal := " MB"  // Megabytes.
	Case (_nTam / (1024 ^ 3)) < 1000;	_nValSai := _nTam / (1024 ^ 3);	_cTpVal := " GB"  // Gigabytes.
	OtherWise;							_nValSai := _nTam / (1024 ^ 4);	_cTpVal := " TB"  // Terabytes.
EndCase

// Transforma os valores da saida no formato escolhido.
If _nSaida == 1  // Saida caractere.
	If _nValSai >= (10 ^ 6)  // Se for maior ou igual a 1 milhao.
		_uRet := AllTrim(Transform(_nValSai / (10 ^ 6), "@E 999,999,999.99")) + " milh�o(�es) de" + _cTpVal
	Else
		_uRet := AllTrim(Transform(_nValSai, IIf("byte" $ _cTpVal, "@E 9,999", "@E 999,999.99"))) + _cTpVal
	Endif
ElseIf _nSaida == 2  // Saida em matriz.
	_uRet := {_nValSai, AllTrim(_cTpVal)}  // 1 - Valor; 2 - Grandeza.
Endif

Return(_uRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Agora    � Autor � Felipe Raposo      � Data �  31/10/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna a data e a hora correntes no seguinte formato:     ���
���          �  Formato texto                                             ���
���          �  AAAAMMDD - hh:mm:ss                                       ���
���          � Onde:                                                      ���
���          �  AAAA - ano                                                ���
���          �  MM   - mes                                                ���
���          �  DD   - dia                                                ���
���          �  hh   - horas                                              ���
���          �  mm   - minutos                                            ���
���          �  ss   - segundos                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Agora(_cFormat)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _uRet, _dData, _cHora
Local _dRef, _nDif, _nDias, _nHoras, _nMins, _nSegs

// Atribui um valor padrao ao formato de data.
_cFormat := U_ValPad(_cFormat, "S")

// Busca um valor para a data.
_dData := date()
_cHora  := AllTrim(time())
Do Case
	Case _cFormat == "S"
		_uRet := dtos(_dData) + " - " + _cHora
	Case _cFormat == "C"
		_uRet := dtoc(_dData) + " " + _cHora
	Case _cFormat == "N"
		_dRef   := ctod("01/01/2006")  // Data referencia.
		_nDias  := _dData - _dRef  // Quantidade de dias.
		_nHoras := val(SubStr(_cHora, 1, 2))
		_nMins  := val(SubStr(_cHora, 4, 2))
		_nSegs  := val(SubStr(_cHora, 7, 2))
		_uRet   := (_nDias * 86400) + (_nHoras * 3600) + (_nMins * 60) + _nSegs
EndCase

Return(_uRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TRemain  � Autor � Felipe Raposo      � Data �  01/03/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna o tempo restante de processamento, de acordo com   ���
���          � os dados passados por parametros.                          ���
���          �                                                            ���
���          � _nAtual   - Quantidade de unidades processadas.            ���
���          � _nTotal   - Quantidade de unidades total.                  ���
���          � _cTimeIni - Hora do inicio do processamento.               ���
���          � _cTimeAtu - Hora atual (opcional).                         ���
���          � _cTRemain - Tempo restante calculado na passagem anterior. ���
���          � _nFreq    - Frequencia de atualizacao do cronometro (em    ���
���          �             passagens / unidades).                         ���
���          � _nMedia   - Variavel que contara unidades por segundo.     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TRemain(_nAtual, _nTotal, _cTimeIni, _cTimeAtu, _cTRemain, _nFreq, _nMedia)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cRet, _nSegRest, _nSegIni, _nSegAtu

// Pega a hora atual, caso nao tenha sido passada por parametro.
_cTimeAtu := U_ValPad(_cTimeAtu, time())
_cTRemain := U_ValPad(_cTRemain, "")
_nFreq    := U_ValPad(_nFreq, 1)

// Atualiza o cronometro considerando a frequencia de atualizacao.
If (_nAtual % _nFreq) == 0 .or. _nAtual == 1
	// Converte os tempos iniciais e finais para segundo.
	_nSegIni := HoraToSeg(_cTimeIni)
	_nSegAtu := HoraToSeg(_cTimeAtu) + IIf(_cTimeAtu < _cTimeIni, 86400, 0)  // 24 horas = 86400 segundos.
	
	// Calcula a media de processamento (unidades por segundo).
	// Media = quantidade processada / tempo processado.
	_nMedia := _nAtual / (_nSegAtu - _nSegIni)
	
	// Calcula o tempo estimado para o processamento das unidades restantes.
	// Tempo restante = quantidade restante / media (resultado em segundos).
	_nSegRest := (_nTotal - _nAtual) / _nMedia
	
	// Converte tudo para horas (caracter).
	_cRet := IIf(_nSegRest > 0, SegToHora(_nSegRest), "--:--:--")
Else
	_cRet := _cTRemain
Endif

Return(_cRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TDecor   � Autor � Felipe Raposo      � Data �  01/12/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Calcula o tempo decorrido, de acordo com os paramentros    ���
���          � passados.                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TDecor(_cTIni, _cTFim, _lSegs)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _uRet, _nSegIni, _nSegFim

// Desmembra as horas de caractere para numerico.
_nSegIni := HoraToSeg(_cTIni)
_nSegFim := HoraToSeg(_cTFim) + IIf(_cTFim < _cTIni, 86400, 0)  // 86400 segundos tem um dia.
_uRet    := IIf(U_ValPad(_lSegs, .F.), _nSegFim - _nSegIni, SegToHora(_nSegFim - _nSegIni))

Return(_uRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HoraToSeg � Autor � Felipe Raposo      � Data �  01/03/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte o tempo passado por parametro (caracter) para se- ���
���          � gundos (numerico).                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function HoraToSeg(_cTempo)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nRet, _nHoras, _nMinutos, _nSegundos

// Desmembra as horas de caractere para numerico.
_nHoras    := val(SubStr(_cTempo, 1, 2))
_nMinutos  := val(SubStr(_cTempo, 4, 2))
_nSegundos := val(SubStr(_cTempo, 7, 2))

// Converte para segundos.
_nRet := (_nHoras * 3600) + (_nMinutos * 60) + _nSegundos

Return(_nRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SegToHora � Autor � Felipe Raposo      � Data �  01/03/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte os segundos passados por parametro (numerico) em  ���
���          � formado de hora (texto hhh:mm:ss).                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SegToHora(_nSegs)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cRet, _nHoras, _nMinutos, _nSegundos

// Divide os segundos entre horas, minutos e segundos.
_nHoras    := int(_nSegs / 3600)							// Busca as horas.
_nMinutos  := int((_nSegs / 60) % 60)						// Busca os minutos.
_nSegundos := _nSegs - (_nMinutos * 60) - (_nHoras * 3600)	// Busca os segundos.

// Converte para caracter.
_cRet := IIf(_nHoras >= 100, AllTrim(str(_nHoras)), StrZero(_nHoras, 2))	// Horas...
_cRet += ":" + StrZero(_nMinutos, 2) + ":" + StrZero(_nSegundos, 2)		// Minutos e segundos.

Return(_cRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GetArea  � Autor � Felipe Raposo      � Data �  26/02/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna informacoes correntes referentes as areas passadas ���
���          � por parametro.                                             ���
���          � A diferenca dessa funcao para o GetArea() padrao do siste- ���
���          � ma eh que essa funcao pega varios alias de uma vez so, in- ���
���          � clusive o alias selecionado no momento da chamada dessa    ���
���          � funcao.                                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GetArea(_aAreas)

// Declaracao de variaveis.
Local _aRet[0]      
Local i     

// Armazena o alias corrente.
Local _aAreaAtu:= GetArea()

// Valores Padroes
_aAreas:= u_ValPad(_aAreas, {_aAreaAtu[1]})

// Adiciona a area corrente na ultima posicao.
// Apenas se nao estiver vazio e se for diferente do ultimo alias que ja veio no parametro.
If !Empty(_aAreaAtu[1]) .And. ( _aAreaAtu[1] != _aAreas[ Len(_aAreas) ] )
	aAdd(_aAreas, _aAreaAtu[1])
EndIf

//Armazena as condicoes dos alias passados por parametro.
For i:= 1 to Len(_aAreas)
    If Select(_aAreas[i]) != 0 .And. !Empty(_aAreas[i])
       DbSelectArea(_aAreas[i])
       AAdd(_aRet,GetArea())
    EndIf   
Next       

// Restaura area anterior.
RestArea(_aAreaAtu)

Return(_aRet)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RestArea � Autor � Felipe Raposo      � Data �  26/02/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Restaura as areas dos alias passados por parametro. O pa-  ���
���          � rametro passado devera ter sido formado pela funcao de     ���
���          � usuario U_GetArea().                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RestArea(_aAreas)     
Return(aEval(_aAreas, {|x| RestArea(x)}))
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ProgLock � Autor � Felipe Raposo      � Data �  06/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Tenta alocar o sistema para a execucao de um programa, para���
���          � evitar que um mesmo programa seja executado duas vezes ao  ���
���          � mesmo tempo, ou que um programa nao seja executado enquanto���
���          � uma outra instancia desse mesmo programa nao tenha termina-���
���          � do de processar.                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Paramentro� _cProg - nome do programa a ser alocado.                   ���
�������������������������������������������������������������������������͹��
���Retorno   � Retorna o numero da alocacao conseguida. Se a funcao nao   ���
���          � conseguir fazer a alocacao, eh retornado o valor 0 (zero). ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ProgLock(_cProg)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nRet := 0
Local _cArqCtrl := AllTrim(_cProg) + ".CTR"

// Controle para saber se essa rotina ja esta rodando no servidor.
// Se o arquivo de controla ja estiver no servidor e nao puder ser
// excluido, entao o programa ainda esta em execucao.

// Testa se o arquivo nao existe ou pode ser apagado.
// Se o arquivo existir e o sistema nao conseguir apagar esse arquivo,
// a funcao retorna zero, indicando que o programa ja esta em uso.
If !file(_cArqCtrl) .or. fErase(_cArqCtrl) == 0
	_nRet := fCreate(_cArqCtrl, 0)  // Aloca o programa.
Endif

Return(_nRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProgUnLock� Autor � Felipe Raposo      � Data �  06/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Desaloca um programa em execucao.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Paramentro� _cProg - nome do programa a ser desalocado.                ���
���          � _nAloc - numero da alocacao                                ���
�������������������������������������������������������������������������͹��
���Retorno   � Nenhum.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ProgUnLock(_cProg, _nAloc)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cArqCtrl := AllTrim(_cProg) + ".CTR"

// Fecha e apaga o arquivo de controle.
fClose(_nAloc)
If file(_cArqCtrl)
	fErase(_cArqCtrl)
Endif

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GrvEnch  � Autor � Felipe Raposo      � Data �  29/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Grava os dados da enchoice na tabela.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametro � _nOpc   - 2 - visualizar                                   ���
���          �           3 - incluir                                      ���
���          �           4 - alterar                                      ���
���          �           5 - remover                                      ���
���          � _cAlias - alias da tabela que terao os dados gravados.     ���
���          � _nOrdem - indice que sera utilizado na pesquisa.           ���
���          � _cChave - chave de pesquisa para posicionar o registro que ���
���          �           vai ser atualizado.                              ���
���          � _cMsg   - parametro para armazenar qualquer eventual erro. ���
���          � _bExec  - bloco de comandos que sera executado antes da    ���
���          �           gravacao do registro, com o registro bloqueado.  ���
�������������������������������������������������������������������������͹��
���Retorno   � Retorno logico, informando se tudo ocorreu bem.            ���
�������������������������������������������������������������������������͹��
���Observacao� Eh recomendavel que seja utilizado o controle de transa-   ���
���          � coes para a execucao dessa rotina, e que a transacao seja  ���
���          � desfeita (rollback) caso a rotina retorne valor falso.     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GrvEnch(_nOpc, _cAlias, _nOrdem, _cChave, _cMsg, _bExec)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nAux1, _lRet := .T.

// Testa a opcao do usuario.
If U_ValPad(_nOpc, 0) > 2
	
	// Acerta os valores padroes dos parametros.
	_cAlias := U_ValPad(_cAlias, Alias())
	_nOrdem := U_ValPad(_nOrdem, 0)
	_cChave := U_ValPad(_cChave, "")
	
	// Seleciona a tabela e posiciona o registro, se nao for uma inclusao.
	dbSelectArea(_cAlias)
	If _nOpc != 3  // 3 - incluir.
		If !empty(_nOrdem) .and. !empty(_cChave)
			// Acerta os valores padroes dos parametros.
			_nOrdem := U_ValPad(_nOrdem, 1)
			_cChave := U_ValPad(_cChave, xFilial(_cAlias))
			
			// Posiciona o registro.
			dbSetOrder(_nOrdem) // Atencao (UPDXFUN).
			If !dbSeek(_cChave, .F.)
				_cMsg := "Registro n�o encontrato" + _EOL +;
				"Alias..: [" + _cAlias + "]" + _EOL +;
				"Indice.: [" + AllTrim(str(_nOrdem)) + " - " + AllTrim(IndexKey()) + "]" + _EOL +;
				"Chave..: [" + _cChave + "]"
				_lRet := .F.
			Endif
		ElseIf eof()
			_cMsg := "Tentativa de grava��o no final da tabela" + _EOL +;
			"Alias.: [" + _cAlias + "]" + _EOL +;
			"Opcao.: [" + IIf(_nOpc == 4, "Alterar", "Remover") + "]"
			_lRet := .F.
		Endif
	Endif
	
	// Testa se nao houve nenhum erro ate agora.
	If _lRet
		// Aloca o registro.
		RecLock(_cAlias, _nOpc == 3)
		
		// Atualiza os campos.
		If _nOpc == 5  // Excluir.
			dbDelete()
		Else
			If _nOpc == 3  // Incluir.
				// Atualiza a filial.
				Private _cFilial := _cAlias + "->" + PrefixoCpo(_cAlias) + "_FILIAL"
				&_cFilial := xFilial(_cAlias)
			Endif
			
			// Atualiza todos os campos.
			aEval(array(FCount()), {|x, y| FieldPut(y, m->&(Field(y)))})
		Endif
		
		// Executa o bloco de comandos, se for passado por parametro.
		If ValType(_bExec) == "B"
			Eval(_bExec)
		Endif
		
		// Grava as alteracoes do registro.
		msUnLock()
	Endif
Endif

Return _lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MontaGD  � Autor � Felipe Raposo      � Data �  06/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Monta as variaveis aCols e aHeader de acordo com os para-  ���
���          � metros passados.                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametro � _nOpc   - 2 - visualizar                                   ���
���          �           3 - incluir                                      ���
���          �           4 - alterar                                      ���
���          �           5 - remover                                      ���
���          � _cAlias - alias referente as variaveis.                    ���
���          � _nOrder - ordem que o sistema devera utilizar para filtrar ���
���          �           os registros que irao para a aCols.              ���
���          � _cSeek  - string utilizada para buscar o primeiro registro ���
���          �           que devera aparecer na aCols.                    ���
���          � _cWhile - condicao para filtrar os registros seguintes que ���
���          �           tambem deverao aparecer na aCols. A diferenca    ���
���          �           desse parametro para o parametro _cFor, eh que o ���
���          �           sistema saira do looping assim que encontrar o   ���
���          �           primeiro registro que nao satisfaca essa condi-  ���
���          �           cao; enquanto que no _cFor, o sistema simples-   ���
���          �           mente pula para o proximo registro.              ���
���          � _cFor   - condicao para filtrar os registros que deverao   ���
���          �           aparecer na aCols. O sistema nao sai do looping  ���
���          �           caso nao satisfaca essa condicao, ao contrario   ���
���          �           do _cWhile.                                      ���
���          � _aInsCpos - campos que serao inseridos no inicio.          ���
���          � _aExcCpos - campos que nao poderao ser inseridos.          ���
���          � _aCampos  - campos que serao considerados. Se esse parame- ���
���          �             tro for passado, todos os campos que nao esti- ���
���          �             verem nesse parametro nao serao considerados.  ���
���          � _cCpoSeq  - campos caracter que sera sequencial na aCols.  ���
���          �             Ex: "C6_ITEM".                                 ���
���          � _lSLock   - indica se os registros retornados serao trava- ���
���          �             dos pelo comando SoftLock().                   ���
���          � _aSLock   - matriz que armazenara os registros travados,   ���
���          �             caso o parametro _lSLock sea passada como true.���
�������������������������������������������������������������������������͹��
���Retorno   � Numerico - a quantidade de campos disponiveis na aCols.    ���
�������������������������������������������������������������������������͹��
���Observacao� As variaveis aHeader, aCols, n e nUsado precisam ser cria- ���
���          � das como Private ou Public antes da chamada dessa funcao.  ���
���          � O recomendavel eh que elas sejam criadas como Private, para���
���          � que sejam eliminadas apos o termino da funcao principal.   ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MontaGD(_nOpc, _cAlias, _nOrder, _cSeek, _cWhile, _cFor, _aInsCpos, _aExcCpos, _aCampos, _cCpoSeq, _lSLock, _aSLock)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nAux1, _aAux1, _uAux1
Local _bInsCpo, _bForS, _bForU, _bFor, _bWhile
Local _aArea := GetArea()  // Armazena as informacoes da area corrente.
Private _uCampo

// Monta o bloco que insere os campos na aHeader.
_bInsCpo := {|| SX3->(aAdd(aHeader, {AllTrim(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO,;
X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})), nUsado++}

// Atualiza os valores padroes dos parametros.
_cFor     := U_ValPad(_cFor,     "")
_aInsCpos := U_ValPad(_aInsCpos, {})
_aExcCpos := U_ValPad(_aExcCpos, {})
_aCampos  := U_ValPad(_aCampos,  {})
_cCpoSeq  := U_ValPad(_cCpoSeq,  "")
_lSLock   := U_ValPad(_lSLock,  .F.)
_aSLock   := U_ValPad(_aSLock,   {})

// Variavel que contem a linha posicionada na GetDados.
n := 1

// Variavel que contem a quantidade de campos visiveis existente na aCols.
nUsado := 0

//������������������������������������������������������Ŀ
//� Monta aHeader.                                       �
//��������������������������������������������������������
SX3->(dbSetOrder(2))  // X3_CAMPO.
aHeader := {}
If !empty(_aCampos)
	// Se o usuario definiu os campos manualmente, so serao inseridos esses.
	aEval(_aCampos, {|x| SX3->(dbSeek(x)), Eval(_bInsCpo)})
Else
	// Insere os campos que o usuario solicitou na frente.
	aEval(_aInsCpos, {|x| SX3->(dbSeek(x)), Eval(_bInsCpo)})
	
	// Insere os outros campos.
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(_cAlias))  // X3_ARQUIVO + X3_ORDEM.

	_bForS  := {|| SX3->(X3Uso(X3_USADO) .and. cNivel >= X3_NIVEL)}
	_bForU  := {|| SX3->(GdFieldPos(X3_CAMPO) == 0 .and. aScan(_aExcCpos, {|x| upper(AllTrim(x)) == upper(AllTrim(X3_CAMPO))}) == 0)}
	_bFor   := {|| Eval(_bForS) .and. Eval(_bForU)}
	_bWhile := {|| SX3->(!eof() .and. X3_ARQUIVO == _cAlias)}
	
	SX3->(dbEval(_bInsCpo, _bFor, _bWhile,,, .T.))
	
Endif

//������������������������������������������������������Ŀ
//� Monta aCols.                                         �
//��������������������������������������������������������
aCols := {}
If _nOpc != 3
	SX3->(dbSetOrder(2))  // X3_CAMPO.
	dbSelectArea(_cAlias); dbSetOrder(_nOrder) // Atencao (UPDXFUN).
	dbSeek(_cSeek, .F.)
	Do While !eof() .and. &_cWhile
		// Verifica se o usuario nao solicitou que alguns registros fossem filtrados.
		// O comando SoftLock() trava o registro, caso necessario (_lSLock for true).
		If (empty(_cFor) .or. &_cFor) .and. (!_lSLock .or. SoftLock(_cAlias))
			// Se travou o registro, armazena o ocorrido na matriz _aSLock.
			If _lSLock
				aAdd(_aSLock, {_cAlias, RecNo()})
			Endif
			
			// Inclui uma linha na aCols.
			_aAux1 := {}
			For _nAux1 := 1 to nUsado
				_uCampo := aHeader[_nAux1, 2]
				SX3->(dbSeek(_uCampo, .F.))
				If SX3->X3_CONTEXT == "V"
					_uAux1 := CriaVar(_uCampo, .T.)
					_uAux1 := IIf(ValType(_uAux1) == "D" .and. empty(_uAux1), dDataBase, _uAux1)
					aAdd(_aAux1, _uAux1)
				Else
					aAdd(_aAux1, &_uCampo)
				Endif
			Next _nAux1
			aAdd(_aAux1, .F.)  // Campos de apagado tem que estar como falso.
			aAdd(aCols, aClone(_aAux1))
		Endif
		
		// Vai para o proximo item da aCols.
		dbSelectArea(_cAlias); dbSkip()
	EndDo
Endif
//
// Se a aCols estiver vazia, cria uma linha em branco.
If empty(aCols)
	aCols := {Array(nUsado + 1)}
	aCols[1, nUsado + 1] := .F.
	For _nAux1 := 1 to nUsado
		_uAux1 := CriaVar(aHeader[_nAux1, 2], .T.)
		_uAux1 := IIf(ValType(_uAux1) == "D" .and. empty(_uAux1), dDataBase, _uAux1)
		aCols[1, _nAux1] := _uAux1
	Next _nAux1
	
	// Acerta o campo sequencial.
	If !empty(_cCpoSeq) .and. empty(aCols[1, _nAux1 := GdFieldPos(_cCpoSeq)])
		aCols[1, _nAux1] := StrZero(1, len(aCols[1, _nAux1]))
	Endif
Endif

// Restaura as condicoes da area anterior (alias, indice e registro).
RestArea(_aArea)
Return(nUsado)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � InsLinGD � Autor � Felipe Raposo      � Data �  08/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Insere uma linha em branco no final da aCols.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametro � _cCpoSeq - campo sequencial. Sera incrementado um ao valor ���
���          �            desse campo da linha anterior na linha inserida.���
�������������������������������������������������������������������������͹��
���Retorno   � O numero da linha criada. A sintaxe recomendavel e:        ���
���          � n := InsLinGD(_cCpoSeq)                                    ���
�������������������������������������������������������������������������͹��
���Observacao� As variaveis aHeader, aCols, n e nUsado devem estar cria-  ���
���          � das e acessiveis como Private (recomendavel) ou Public.    ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function InsLinGD(_cCpoSeq)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nRet, _psSeq
Local _nUsado := IIf(Type("nUsado") == "N", nUsado, len(aHeader))

// Verifica o valor padrao do parametro passado.
_cCpoSeq := U_ValPad(_cCpoSeq, "")

// Insere uma linha na aCols sem valor nenhum (somente nulos).
aAdd(aCols, array(_nUsado + 1))

// Pega o numero da ultima linha da aCols (recem criada).
_nRet := len(aCols)

// Atualiza os campos de nulo para os valores corretos deles.
aCols[_nRet, _nUsado + 1] := .F.
aEval(aHeader, {|x, y| aCols[_nRet, y] := CriaVar(x[2], .T.)})

// Atualiza o campo sequencial.
If !empty(_cCpoSeq) .and. (_psSeq := GdFieldPos(_cCpoSeq)) != 0
	If _nRet > 1
		aCols[_nRet, _psSeq] := Soma1(aCols[_nRet - 1, _psSeq])
	Else
		aCols[_nRet, _psSeq] := StrZero(1, len(aCols[_nRet, _psSeq]))
	Endif
Endif

// Retorna o tamanho atualizado do aCols.
Return(_nRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GrvGD    � Autor � Felipe Raposo      � Data �  03/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Grava os dados da aCols na tabela.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _nOpc =>  2 - visualizar (nao faz nada).                   ���
���          �           3 - incluir                                      ���
���          �           4 - alterar                                      ���
���          �           5 - remover                                      ���
���          � _cAlias   - alias a qual a getdados se refere.             ���
���          � _nIndice  - indice utilizado para pesquisa do registro.    ���
���          � _cChFixa  - chave fixa utilizada no inicio da pesquisa.    ���
���          � _cChVarP  - chave que varia a cada registro, utilizada na  ���
���          �             sequencia do _cChFixa na pesquisa.             ���
���          � _bExeCpo  - bloco de comandos a ser executado na gravacao  ���
���          �             de cada campo. Utilize esse recurso com caute- ���
���          �             la, pois pode fazer o sistema ficar lento.     ���
���          � _bExeReg  - bloco de comandos a ser executado na gravacao  ���
���          �             de cada registro.                              ���
���          � _bExeFim  - bloco de comandos a ser executado apos a gra-  ���
���          �             vacao de todos os registros.                   ���
���          � _lSLock   - indica se os registros ja estao bloqueados pe- ���
���          �             lo comando SoftLock() ou nao.                  ���
�������������������������������������������������������������������������͹��
���Retorno   � Retorno logico, informando se tudo ocorreu bem.            ���
�������������������������������������������������������������������������͹��
���Observacao� Eh recomendavel que seja utilizado o controle de transa-   ���
���          � coes para a execucao dessa rotina, e que a transacao seja  ���
���          � desfeita (rollback) caso a rotina retorne valor falso.     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GrvGD(_nOpc, _cAlias, _nIndice, _cChFixa, _cChVarP, _bExeCpo, _bExeReg, _bExeFim, _lSLock)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _lExc, _lAchou
Local _nAux1, _lRet := .T.
Private _cChVar, n

// Abre o registro para alteracao ou inclusao.
If _nOpc > 2
	
	// Acerta os valores padroes dos parametros.
	_bExeCpo := U_ValPad(_bExeCpo, {|_nLin, _nCol| })
	_bExeReg := U_ValPad(_bExeReg, {|_nLin| })
	_bExeFim := U_ValPad(_bExeFim, {|| })
	_cChVar  := U_ValPad(_cChVarP, "")
	_lSLock  := U_ValPad(_lSLock, .F.)
	
	//������������������������������������������������������Ŀ
	//� Grava as variaveis de memoria da getdados.           �
	//��������������������������������������������������������
	
	// Seleciona o alias e acerta o indice passado por parametro.
	dbSelectArea(_cAlias); dbSetOrder(_nIndice) // Atencao (UPDXFUN).
	
	// Grava cada linha da aCols.
	For _nAux1 := 1 to len(aCols)
		
		// Cria variaveis private para que a chave de busca possa usa-las.
		aEval(aHeader, {|x, y| m->(&(x[2])) := aCols[_nAux1, y]})
		
		// Testa se eh para excluir o registro.
		_lExc := (aCols[_nAux1, nUsado + 1] .or. _nOpc == 5)
		
		// Posiciona o registro.
		_lAchou := dbSeek(_cChFixa + IIf(!empty(_cChVar), m->(&_cChVar), ""), .F.)
		
		// Grava os campos na tabela. Nao passa por esse bloco de comandos
		// somente se for exclusao e nao encontrar o registro na tabela.
		If !_lExc .or. _lAchou
			// Abre o registro para alteracao ou inclusao.
			If !_lAchou
				// Se for inclusao, ou se for alteracao e nao achou o registro; entao inclui registro novo.
				RecLock(_cAlias, .T.)
				&(_cAlias)->(&(PrefixoCpo(_cAlias) + "_FILIAL")) := xFilial(_cAlias)
			ElseIf !_lSLock
				// Senao abre o registro para alteracao.
				RecLock(_cAlias, .F.)
			Endif
			
			// Testa se eh para excluir o registro.
			If _lExc
				&(_cAlias)->(dbDelete())  // Exclui o registro.
			Else
				// Atualiza todos os campos.
				aEval(aHeader, {|x, y| &(_cAlias)->(&(x[2])) := aCols[_nAux1, y], Eval(_bExeCpo, _nAux1, y)})
			Endif
			
			// Executa rotina passada pelo parametro a cada registro antes de gravar.
			_lRet := _lRet .and. U_ValPad(Eval(_bExeReg, _nAux1), .T.)
			
			// Grava as alteracoes na tabela.
			&(_cAlias)->(msUnLock())
		Endif
	Next _nAux1
	
	// Executa rotina passada pelo parametro depois de gravar todos os registros.
	_lRet := _lRet .and. U_ValPad(Eval(_bExeFim), .T.)
Endif
Return _lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Rateio   � Autor � Felipe Raposo      � Data �  19/10/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua o rateio de uma certa quantidade em uma matriz.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _nRateio - quantidade a ser rateada.                       ���
���          � _aMatriz - matriz base a ser considerada para o rateio.    ���
���          �            Essa matriz devera conter os fatores para rece- ���
���          �            ber o rateio.                                   ���
���          � _nPrecis - precisao do valor rateado (numero de casas de-  ���
���          �            cimais).                                        ���
�������������������������������������������������������������������������͹��
���Retorno   � _aRet - matriz, com o mesmo tamanho que a matriz base, com ���
���          �         a quantidade rateada de cada item, respectivamente.���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Rateio(_nRateio, _aMatriz, _nPrecis)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _aRet, _nSaldo, _nBase := 0, _nFator, _aAux1[0], _bAux1, _nAux1, _nAux2

// Acerta os valores padroes dos parametros.
_aMatriz := U_ValPad(_aMatriz, {0})
_nPrecis := U_ValPad(_nPrecis, 0)
_aRet    := array(len(_aMatriz))
_nSaldo  := _nRateio
_nFator  := 10 ^ _nPrecis
aEval(_aMatriz, {|x| _nBase += x})

// Efetua o rateio.
If _nBase == 0
	_bAux1 := {|x, y| _aRet[y] := int((_nRateio / len(_aMatriz)) * _nFator) / _nFator, _nSaldo -= _aRet[y]}
Else
	_bAux1 := {|x, y| _aRet[y] := int((_nRateio / _nBase) * x * _nFator) / _nFator, _nSaldo -= _aRet[y]}
Endif
aEval(_aMatriz, _bAux1)

// Rateia o saldo restante, se houver.
If _nSaldo != 0
	// Define a ordem dos que receberao o rateio primeiro.
	aEval(_aMatriz, {|x, y| aAdd(_aAux1, {x, y})})
	aSort(_aAux1,,, {|x, y| x[1] > y[1]})
	
	// Faz o rateio do saldo restante.
	_nAux2 := _nSaldo * _nFator
	// _nAux2 - esse numero nao pode ser maior que len(_aAux1). Se
	// isso ocorrer, eh porque alguma formula acima esta errada.
	For _nAux1 := 1 to _nAux2
		_aRet[_aAux1[_nAux1, 2]] += (1 / _nFator)
		_nSaldo--
	Next _nAux1
Endif

// Retorna os valores rateados.
Return(_aRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExistX6Fun� Autor � Gilberto           � Data �  17/05/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se um determinado parametro existe no SX6 ou nao. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Geral.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ExistX6Fun(nomeParam)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local bkpArea := u_GetArea({"SX6"})  // Grava area anterior
Local existOuNao := .f.

// Verifica se o parametro foi passado.
If nomeParam != nil
	// verifica se o parametro existe no SX6.
	SX6->(dbSetOrder(1))
	existOuNao := SX6->(dbSeek(xFilial("SX6") + nomeParam , .F.))
EndIf

u_RestArea(bkpArea)
Return(existOuNao)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PutMV    � Autor � Felipe Raposo      � Data �  24/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza o valor de um parametro do sistema.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Geral.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PutMV(_cParam, _uValor)
Local bkpArea := u_GetArea({"SX6"})  // Grava area anterior
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cType

// Atualiza o parametro do lote.
SX6->(dbSetOrder(1))  // X6_FIL, X6_VAR.
If SX6->(dbSeek(xFilial() + _cParam, .F.))
	RecLock("SX6", .F.)
	_cType := SX6->X6_TIPO
Else
	_cType := ValType(_uValor)
	RecLock("SX6", .T.)
	SX6->X6_FIL  := xFilial("SX6")
	SX6->X6_TIPO := _cType
Endif
Do Case
	Case _cType == "C"  // Nao faz nada
	Case _cType == "N"; _uValor := AllTrim(str(_uValor))
	Case _cType == "D"; _uValor := dtoc(_uValor)
	Case _cType == "L"; _uValor := IIf(_uValor, "T", "F")
EndCase
SX6->X6_CONTEUD := _uValor
SX6->X6_CONTSPA := _uValor
SX6->X6_CONTENG := _uValor
SX6->(msUnLock())
u_RestArea(bkpArea)
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DB2XML   � Autor � Felipe Raposo      � Data �  05/06/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte um alias aberto para um arquivo XML, no formato   ���
���          � Excel 2006.                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _cArquivo - arquivo a ser gerado.                          ���
���          � _PNome    - nome da planilha a ser criada no arquivo.      ���
���          � _cAlias   - alias que sera convertido para XML (opcional). ���
���          � _aStruct  - matriz com a estrutura da planilha. A sintaxe  ���
���          �             da matriz e' a seguinte:                       ���
���          �             1 - Cabecalho (opcional).                      ���
���          �             2 - Campo.                                     ���
���          �             3 - Largura da coluna (XML - opcional).        ���
���          � _bWhile   - converte os registros enquanto o retorno do    ���
���          �             bloco passado for verdadeiro.                  ���
���          � _bFor     - converte somente os registros cujo o bloco pas-���
���          �             sado nesse parametro retornar verdadeiro.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � Retorna o numero de registros que foram convertidos para o ���
���          � arquivo XML.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function DB2XML(_cArquivo, _cPNome, _cAlias, _aStruct, _bWhile, _bFor,_cVrs,_cCampoChave)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cMsg, _nAux1, _nAux2, _cAux1, _aAux1
Local _nLinhas := 0
Local _cCabec, _cColuna := "", _aColuna[0]
Local _cLinha, _aPlanilha[0], _aPlans[0], _cArqXML
Local _nCSVArq, _nCount := 0
Local _cDataBase := dtos(dDataBase)
Local _cDataHora := left(_cDataBase, 4) + "-" + SubStr(_cDataBase, 5, 2) + "-" + right(_cDataBase, 2) + "T" + Time() + "Z"
Local _bGrvErr := {|_cArq| MsgAlert("Ocorreu um erro na grava��o do arquivo " + _cArq + ". Favor avisar sistemas.", "Aten��o")}
Local _bGrvArq := {|_nArq, _cTxt, _cArq| IIf(fWrite(_nArq, _cTxt, len(_cTxt)) != len(_cTxt), Eval(_bGrvErr, _cArq), nil)}
Local _nSupLin

//���������������������������������������������������������������������Ŀ
//� Monta o nome do arquivo a ser gravado.                              �
//�����������������������������������������������������������������������
_cArquivo := AllTrim(_cArquivo)
_cArquivo := _cArquivo + IIf(upper(right(_cArquivo, 4)) == ".XML", "", ".xml")

// Cria e testa se o arquivo foi criado com sucesso.
If (_nCSVArq := fCreate(_cArquivo)) <= 0 .or. !file(_cArquivo)
	_cMsg := "O arquivo XML n�o p�de ser criado." + _EOL + _cArquivo + _EOL +;
	"Verifique se o disco est� cheio ou protegido contra grava��es."
	MsgAlert(_cMsg, "Aten��o")
	Return .F.
Endif

// Analista os parametros passados para a funcao.
_cAlias  := U_ValPad(_cAlias, Alias())
_cPNome  := U_ValPad(_cPNome, _cAlias)
_aStruct := U_ValPad(_aStruct, {})
_bWhile  := U_ValPad(_bWhile,  {|| .T.})
_bFor    := U_ValPad(_bFor,    {|| .T.})
_cVrs    := U_ValPad(_cVrs, "2003")
_cCampoChave:= U_ValPad(_cCampoChave,'Space(01)')

// Versao do Excel: A versao 2007 suporta um numero maior de linhas.
// Gilberto - 16/08/2010
If _cVrs == "2007"
   _nSupLin:= 1000000
Else 
   _nSupLin:= 65536
EndIf
   
// Seleciona o alias que sera convertido para XML.
dbSelectArea(_cAlias); dbGoTop()

// Analista a estrutura passada.
If empty(_aStruct)
	SX3->(dbSetOrder(2))  // X3_CAMPO.
	_aAux1 := dbStruct()
	For _nAux1 := 1 to len(_aAux1)
		
		SX3->(dbSeek(_aAux1[_nAux1, 1], .F.))
        _cAux1:= Alltrim(X3Titulo())
        // Gilberto - 23/01/2007 - Retira os eventuais acentos ou caracteres especiais do cabecalho.
        _cAux1:= u_TiraAct(_cAux1,.t.,"XML")
        If Empty(_cAux1); _cAux1:=  _aAux1[_nAux1, 1]; EndIf
		//IIf(empty(_cAux1 := AllTrim(X3Titulo())), _cAux1 := _aAux1[_nAux1, 1], nil)
		aAdd(_aStruct, {_cAux1, &("{|| " +  AllTrim(_aAux1[_nAux1, 1]) + "}")})
		
	Next _nAux1
Endif

aEval(_aStruct, {|x, y| _aStruct[y] := {IIf(ValType(x[1]) == "B", x[1], Capital(x[1])), x[2], IIf(len(x) >= 3, x[3], 0), 0, .T.}})

//���������������������������������������������������������������������Ŀ
//� Converte os registros em linhas XML.                                �
//�����������������������������������������������������������������������
Do While Eval(_bWhile) .and. !eof()

	If Eval(_bFor)

		// Atualizacao das informacoes na tela.         
		msProcTxt("Criando linhas do XML "+&(_cCampoChave)  )	
		
		// Monta a linha corrente.
		_cLinha := '   <Row>' + _EOL
		For _nAux1 := 1 to len(_aStruct)
			_cCampo := Eval(_aStruct[_nAux1, 2])
			_cTipo  := ValType(_cCampo)
			Do Case
				Case _cTipo == "N"; _cCampo := AllTrim(str(_cCampo))
				Case _cTipo == "C"; _cCampo := AllTrim(U_TiraAct(_cCampo, .T.,"XML"))
				Case _cTipo == "D"; _cCampo := dtoc(_cCampo)
				OtherWise; _cCampo := ""
			EndCase
			_aStruct[_nAux1, 4] := max(_aStruct[_nAux1, 4], len(_cCampo))     // Armazena o maior registro desse campo.
			_aStruct[_nAux1, 5] := (_cTipo == "N" .and. _aStruct[_nAux1, 5])  // Indica se todos os registros do campo sao numericos.
			
			// Adiciona o campo a linha que sera retornada.
			If _cTipo == "N"
				_cLinha += '    <Cell ss:StyleID="s22"><Data ss:Type="Number">' + _cCampo + '</Data></Cell>' + _EOL
			Else
				_cLinha += '    <Cell><Data ss:Type="String">' + _cCampo + '</Data></Cell>' + _EOL
			Endif
		Next _nAux1                  
		
		_cLinha += '   </Row>' + _EOL
		
		// Limite de linhas por tabela no Excel.
		//If _nLinhas < 65536 - 1  // Subtrai um porque e' a linha utilizada pelo cabecalho.
		If _nLinhas < _nSupLin - 1
		
			aAdd(_aPlanilha, _cLinha)
			_nLinhas ++
			
		Else
		
			If empty(_aPlans)
				_cPNome += "_1"
			Endif
			
			aAdd(_aPlans, {_cPNome, aClone(_aPlanilha), _nLinhas})
			_cPNome := Soma1(_cPNome)
			_aPlanilha := {_cLinha}
			 _nLinhas := 1
			 
		Endif
		
	Endif
	
	// Vai para o proximo registro.
	dbSelectArea(_cAlias)
	dbSkip()
	
EndDo

aAdd(_aPlans, {_cPNome, _aPlanilha, _nLinhas})

// Configura as colunas e monta a linha de cabecalho.
_cCabec  := '   <Row ss:StyleID="s21">' + _EOL
For _nAux1 := 1 to len(_aStruct)
	_cAux1 := AllTrim(IIf(ValType(_aStruct[_nAux1, 1]) == "B", Eval(_aStruct[_nAux1, 1]), _aStruct[_nAux1, 1]))
	// Se nao houver uma largura informada no parametro, o sistema calcula.
	If (_nAux2 := _aStruct[_nAux1, 3]) == 0
		_nAux2 := IIf(_aStruct[_nAux1, 5], 72.75, _aStruct[_nAux1, 4] * 10.5)
	Endif
	IIf(!empty(_aColuna) .and. _aColuna[len(_aColuna), 1] == _nAux2, _aColuna[len(_aColuna), 2]++, aAdd(_aColuna, {_nAux2, 0}))
	_cCabec += '    <Cell><Data ss:Type="String">' + _cAux1 + '</Data></Cell>' + _EOL
Next _nAux1
_cCabec += '   </Row>' + _EOL
aEval(_aColuna, {|x| _cColuna += '   <Column ss:Width="' + AllTrim(str(x[1])) + '"' + IIf(x[2] > 0, ' ss:Span="' + AllTrim(str(x[2])) + '"', '') + '/>' + _EOL})

//���������������������������������������������������������������������Ŀ
//� Monta o arquivo XML propriamente dito.                              �
//�����������������������������������������������������������������������
_cArqXML :=;
'<?xml version="1.0"?>' + _EOL +;
'<?mso-application progid="Excel.Sheet"?>' + _EOL +;
'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + _EOL +;
' xmlns:o="urn:schemas-microsoft-com:office:office"' + _EOL +;
' xmlns:x="urn:schemas-microsoft-com:office:excel"' + _EOL +;
' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + _EOL +;
' xmlns:html="http://www.w3.org/TR/REC-html40">' + _EOL +;
' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + _EOL +;
'  <LastAuthor>' + AllTrim(cUserName) + '</LastAuthor>' + _EOL +;
'  <Created>' + _cDataHora + '</Created>' + _EOL +;
'  <Version>11.5606</Version>' + _EOL +;
' </DocumentProperties>' + _EOL +;
' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + _EOL +;
'  <WindowHeight>9000</WindowHeight>' + _EOL +;
'  <WindowWidth>9000</WindowWidth>' + _EOL +;
'  <WindowTopX>100</WindowTopX>' + _EOL +;
'  <WindowTopY>100</WindowTopY>' + _EOL +;
'  <ProtectStructure>False</ProtectStructure>' + _EOL +;
'  <ProtectWindows>False</ProtectWindows>' + _EOL +;
' </ExcelWorkbook>' + _EOL +;
' <Styles>' + _EOL +;
'  <Style ss:ID="Default" ss:Name="Normal">' + _EOL +;
'   <Alignment ss:Vertical="Bottom"/>' + _EOL +;
'   <Borders/>' + _EOL +;
'   <Font/>' + _EOL +;
'   <Interior/>' + _EOL +;
'   <NumberFormat/>' + _EOL +;
'   <Protection/>' + _EOL +;
'  </Style>' + _EOL +;
'  <Style ss:ID="s21">' + _EOL +;
'   <Font x:Family="Swiss" ss:Bold="1"/>' + _EOL +;
'  </Style>' + _EOL +;
'  <Style ss:ID="s22">' + _EOL +;
'   <NumberFormat ss:Format="Standard"/>' + _EOL +;
'  </Style>' + _EOL +;
' </Styles>' + _EOL
Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.

// Monta as planilhas dentro do arquivo.
For _nAux1 := 1 to len(_aPlans)
	// Interpreta a linha.
	_cPNome    := _aPlans[_nAux1, 1]
	_aPlanilha := aClone(_aPlans[_nAux1, 2])
	_nLinhas   := _aPlans[_nAux1, 3]
	_nCount    += _nLinhas
	
	// Monta a string da planilha.
	_cArqXML :=;
	' <Worksheet ss:Name="' + _cPNome + '">' + _EOL +;
	'  <Table ss:ExpandedColumnCount="' + AllTrim(str(len(_aStruct))) + '" ss:ExpandedRowCount="' + AllTrim(str(_nLinhas + 1)) + '" x:FullColumns="1" x:FullRows="1">' + _EOL +;
	_cColuna + _cCabec
	Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
	
	// Grava cada linha de registro.
	For _nAux2 := 1 to len(_aPlanilha)
		_cArqXML := _aPlanilha[_nAux2]
		Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
	Next _nAux2
	
	// Finaliza a tabela.
	_cArqXML :=;
	'  </Table>' + _EOL +;
	'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + _EOL +;
	'   <PageSetup>' + _EOL +;
	'    <Header x:Margin="0.49"/>' + _EOL +;
	'    <Footer x:Margin="0.49"/>' + _EOL +;
	'    <PageMargins x:Left="0.8" x:Right="0.8"/>' + _EOL +;
	'   </PageSetup>' + _EOL +;
	'   <Selected/>' + _EOL +;
	'   <FreezePanes/>' + _EOL +;
	'   <FrozenNoSplit/>' + _EOL +;
	'   <SplitHorizontal>1</SplitHorizontal>' + _EOL +;
	'   <TopRowBottomPane>1</TopRowBottomPane>' + _EOL +;
	'   <ActivePane>2</ActivePane>' + _EOL +;
	'  </WorksheetOptions>' + _EOL +;
	' </Worksheet>' + _EOL
	Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
Next _nAux1

// Finaliza o arquivo.
_cArqXML := '</Workbook>' + _EOL
Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.

// Fecha os arquivos XML.
fClose(_nCSVArq)

Return _nCount

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DB2TXT   � Autor � GILBERTO           � Data �  02/02/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Converte um alias aberto para um arquivo XML, no formato   ���
���          � Excel 2006.                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _cArquivo - arquivo a ser gerado.                          ���
���          � _PNome    - nome da planilha a ser criada no arquivo.      ���
���          � _cAlias   - alias que sera convertido para XML (opcional). ���
���          � _aStruct  - matriz com a estrutura da planilha. A sintaxe  ���
���          �             da matriz e' a seguinte:                       ���
���          �             1 - Cabecalho (opcional).                      ���
���          �             2 - Campo.                                     ���
���          �             3 - Largura da coluna (XML - opcional).        ���
���          � _bWhile   - converte os registros enquanto o retorno do    ���
���          �             bloco passado for verdadeiro.                  ���
���          � _bFor     - converte somente os registros cujo o bloco pas-���
���          �             sado nesse parametro retornar verdadeiro.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � Retorna o numero de registros que foram convertidos para o ���
���          � arquivo XML.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Generico.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Db2Txt(_cArquivo,_aEstruct,_cAlias,_cCampoChave,_cDelim)

Local _lRet := .T.
Local _nCSVArq
Private _cLinha := ""

//&(_cAlias)->(DbStruct())
// Analista os parametros passados para a funcao.
_cArquivo:= u_ValPad(_cArquivo, _cAlias)
_cAlias  := u_ValPad(_cAlias, Alias())
_cCampoChave:= u_ValPad(_cCampoChave," ")
_aEstruct := u_ValPad(_aEstruct, {})
_cDelim:= u_ValPad(_cDelim,";")

If File(_cArquivo)
   If ApMsgYesNo("Arquivo: "+_cArquivo+" j� existe." + _EOL +"Deseja substituir ?")
      Ferase(_cArquivo)                                                                          	
   Else
	  _lRet:= .F.
   EndIf
EndIf

// Cria os arquivos textos.
_nCSVArq := fCreate(_cArquivo)
	
// Testa se o arquivo foi criado com sucesso.
If ( _lRet ) .And. ( _nCSVArq <= 0 ) .or. !File(_cArquivo)
	_cMsg := "O arquivo texto n�o p�de ser criado." + _EOL + ;
	"Verifique tamb�m se o disco est� cheio ou protegido contra grava��es."
	ApMsgAlert(_cMsg, "Aten��o")
	_lRet:= .F.
Endif

If   _lRet

	// Analista a estrutura passada.
	If Empty(_aEstruct)

		SX3->(dbSetOrder(2))  // X3_CAMPO.
		_aAux1 := dbStruct()
		
		For _nAux1 := 1 to Len(_aAux1)
			SX3->(dbSeek(_aAux1[_nAux1, 1], .F.))
	        _cAux1:= Alltrim(X3Titulo())
	        // Gilberto - 23/01/2007 - Retira os eventuais acentos ou caracteres especiais do cabecalho.
	        _cAux1:= u_TiraAct(_cAux1,.t.,"XML")
	        If Empty(_cAux1)
	           _cAux1:=  _aAux1[_nAux1, 1]
	        EndIf
			aAdd(_aEstruct, {_cAux1, &("{|| " +  AllTrim(_aAux1[_nAux1, 1]) + "}")})
		Next _nAux1
		
	Endif
	
	aEval(_aEstruct, {|x, y| _aEstruct[y] := {IIf(ValType(x[1]) == "B", x[1], Capital(x[1])), x[2], IIf(len(x) >= 3, x[3], 0), 0, .T.}})


	// Monta a linha do cabecalho.	
	aEval(_aEstruct, {|_aCabec| _cLinha += _aCabec[1] + _cDelim})
	_cLinha += _EOL
	
	// Gravacao o arquivo texto ja testando por erros.
	If fWrite(_nCSVArq, _cLinha, len(_cLinha)) != len(_cLinha)
		MsgAlert("Ocorreu um erro na grava��o do arquivo " + _cArquivo + ". Favor avisar sistemas.", "Aten��o")
		_lRet := .F.
	Endif

	// Processa todos os produtos.
	Private lEnd:= .f.
	Private _nCount:= 0
	MsAguarde({|lEnd| RunProc(@lEnd,_cAlias,_cCampoChave,_aEstruct,_nCSVArq,_lRet,_cDelim)}, "Aguarde...", "Gerando arquivo...",.t.)
	
	// Fecha o arquivo texto gerado.
	fClose(_nCSVArq)

EndIf

Return( _nCount)
//---
Static Function RunProc(lEnd,_cAlias,_cCampoChave,_aEstruct,_nCSVArq,_lRet,_cDelim)

Local _cLinha:= ""
DbSelectArea(_cAlias)
DbGotop()

While !Eof() .and. _lRet
	
	// Atualiza tela de processamento.
	If !Empty(_cCampoChave)
		msProcTxt("Exportando pre�os " + &(_cCampoChave))
	Else
		msProcTxt("Exportando pre�os ")
	EndIf
	ProcessMessages()  // Atualiza a pintura da janela.
	
	// Monta a linha que sera gravada.
	_cLinha := ""
	For _nAux1 := 1 to len(_aEstruct)
		_cCampo := Eval(_aEstruct[_nAux1, 2])
		_cTipo  := ValType(_cCampo)
		Do Case
			Case _cTipo == "C"; _cCampo := "'"+AllTrim(_cCampo)
			//Case _cTipo == "N"; _cCampo := AllTrim(Transform(_cCampo,"@e 999,9999.99"))
			Case _cTipo == "N"; _cCampo := AllTrim(Transform(_cCampo,"@e 9999999999.99"))			
			Case _cTipo == "D"; _cCampo := DtoC(_cCampo)
			OtherWise; _cCampo := ""
		EndCase
		_cLinha += _cCampo + _cDelim
	Next _nAux1
	_cLinha += _EOL
	
	// Gravacao o arquivo texto ja testando por erros.
	If fWrite(_nCSVArq, _cLinha, len(_cLinha)) == len(_cLinha)
		_nCount++
	Else
		MsgAlert("Ocorreu um erro na grava��o do arquivo " + _cArquivo + ". Favor avisar sistemas.", "Aten��o")
		_lRet := .F.
		Exit
	Endif
	
	// Vai a proxima nota.
	dbSelectArea(_cAlias)
	dbSkip()
	
End-While

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MsgMatriz � Autor � Felipe Raposo      � Data �  19/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exibe uma matriz bi-dimensional na tela, em uma grade      ���
���          � ListBox.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Geral.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MsgMatriz(_aMatriz, _aHeader, _cTitulo, _cMens)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _SaveArea:= u_GetArea()
Local _oDlg1, _oSay1, _oListBox1, _nRetUser := 1
Local _aPosObj[0], _aObjetos[0], _aInfo[0], _aTam[0]
Local _aMatRet:={}  // Matriz de retorno

// Valores padroes.
_cTitulo := U_ValPad(_cTitulo, "Aten��o")
_cMens   := U_ValPad(_cMens, "Matriz de dados")
If Len(_aMatriz) == 0
   Private _aAux[ Len(_aHeader) ]
   Afill(_aAux,"")
   Aadd(_aMatriz,_aAux)
EndIf

AAdd(_aObjetos, {000, 010, .T., .F.})
AAdd(_aObjetos, {000, 000, .T., .T., .T.})
_aTam    := {000, 012, 210, 100, 420, 200, 000}
_aInfo   := {_aTam[1], _aTam[2], _aTam[3], _aTam[4], 3, 3}
_aPosObj := MsObjSize(_aInfo, _aObjetos)

// Desenha a tela.
DEFINE MSDIALOG _oDlg1 TITLE _cTitulo FROM _aTam[7], 0 TO _aTam[6], _aTam[5] PIXEL STYLE 128 STATUS
//Define msDialog _oDlg1 title _cTitulo from _aTam[7], 0 to _aTam[6], _aTam[5] pixel STYLE DS_MODALFRAME STATUS

// Desabilita o uso do ESC para cancelar a janela.
_oDlg1:lEscClose:= .f.

// Botoes ok e cancelar no topo da tela.
_bBntOk:= {|| _nRetUser:= _oListBox1:nAt ,_oDlg1:End()}
_bBntCan:= {|| _nRetUser:= 0, _oDlg1:End()}

// Label no top da tela.
_oSay1 := TSay():New(_aPosObj[1, 1], _aPosObj[1, 2], {|| _cMens}, _oDlg1,,,,,, .T.,,,, 007)

// Monta o ListBox com as datas.
_oListBox1 := TWBrowse():New(_aPosObj[2, 1], _aPosObj[2, 2], _aPosObj[2, 3], _aPosObj[2, 4], {|| nil}, _aHeader,, _oDlg1,,,,,,,,,,, _cMens,,, .T.,,,,,)
_oListBox1:SetArray(_aMatriz)
_oListBox1:bLine := {|| _aLin := {}, aEval(_aMatriz[_oListBox1:nAt], {|x| aAdd(_aLin, x)}), _aLin}

// Exibe a tela montada para o usuario.
Activate msDialog _oDlg1 center on init EnchoiceBar(_oDlg1, _bBntOk, _bBntCan)

u_RestArea(_SaveArea)

// _nRetUser retorna o valor da linha em que esta posicionado quando eh pressionado o botao verde "Ok".
// Se for pressionado vermelho "cancela", entao o valor a ser retornado eh zero (0).
Return(_nRetUser)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AtuSXE   � Autor � Felipe Raposo      � Data �  26/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para manutencao das tabelas SXE e SXF do sistema. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Italian Coffee do Brasil.                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AtuSXE

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _oDlg1, _oSay1, _oBtn1, _oGetDXE, _oGetDXF, _nRetUser := 0
Local _cLinOk, _cTudoOk, _cFldOk, _lDelOk, _aAlter
Local _nOpc := 4  // 4 - Alterar.
Local _aPosObj[0], _aObjetos[0], _aInfo[0], _aTam[0]
Local _aHeaderXE, _aColsXE, _aRecNoXE, _aHeaderXF, _aColsXF, _aRecNoXF
Private VISUAL := (_nOpc == 2)
Private INCLUI := (_nOpc == 3)
Private ALTERA := (_nOpc == 4)
Private EXCLUI := (_nOpc == 5)
Private _cTabela := Space(3)

//������������������������������������������������������������������Ŀ
//� Solicita que o usuario seleciona a tabela que deseja visualizar. �
//��������������������������������������������������������������������
// Se o usuario cancelou, o sistema retorna aqui.
If !FilAlias(@_cTabela)
	Return .F.
Endif

//������������������������������������������������������������������Ŀ
//� Abre a tela com os registros filtrados.                          �
//��������������������������������������������������������������������

// Abre os arquivo SXE e SXF.
IIf(empty(select("SXE")), dbUseArea(.T.,, "SXE", "SXE", .T., .F.), nil)
IIf(empty(select("SXF")), dbUseArea(.T.,, "SXF", "SXF", .T., .F.), nil)

// Calcula as dimensoes da tela.
_aObjetos := {}
aAdd(_aObjetos, {000, 010, .T., .F.})
aAdd(_aObjetos, {000, 000, .T., .T.})
aAdd(_aObjetos, {000, 000, .T., .T.})
_aTam    := MsAdvSize()  // {000, 012, 210, 100, 420, 200, 000}
_aInfo   := {_aTam[1], _aTam[2], _aTam[3], _aTam[4], 3, 3}
_aPosObj := MsObjSize(_aInfo, _aObjetos)

// Desenha a tela.
Define msDialog _oDlg1 title "Manuten��o do n�mero sequencial" from _aTam[7], 0 to _aTam[6], _aTam[5] pixel

// Botoes ok e cancelar no topo da tela.
_bBntOk   := {|| _nRetUser := 1, _oDlg1:End()}
_bBntCan  := {|| _nRetUser := 0, _oDlg1:End()}

// Label no top da tela.
_oSay1 := TSay():New(_aPosObj[1, 1], _aPosObj[1, 2], {|| "Manuten��o do n�mero sequencial"}, _oDlg1,,,,,, .T.,,,, 007)

// Botao de refresh.
_oBtn1 := TButton():New(_aPosObj[1, 1], _aPosObj[1, 2] + 120, "Atualizar", _oDlg1, {|| FilAlias(@_cTabela, @_oGetDXE, @_aRecNoXE, @_oGetDXF, @_aRecNoXF)}, 50, 10,,,, .T.,, "Atualiza os dados baixo")

// Configuracao comum as duas tabelas.
_cLinOk  := "AlwaysTrue()"
_cTudoOk := "AlwaysTrue()"
_cFldOk  := "AlwaysTrue()"
_lDelOk  := .F.
_nAlter  := GD_UPDATE  // + GD_INSERT + GD_DELETE

//��������������������������������������������������������������Ŀ
//� Monta o aHeader e o aCols do SXE.                            �
//����������������������������������������������������������������
SXE->(CriaGD(@_aHeaderXE, @_aColsXE, @_aRecNoXE))
_oGrpXE  := TGroup():New(_aPosObj[2, 1], _aPosObj[2, 2], _aPosObj[2, 3], _aPosObj[2, 4], "SXE - Pr�ximo n�mero",,,, .T.)
_aAlter  := {"XE_TAMANHO", "XE_NUMERO"}
_oGetDXE := MsNewGetDados():New(_aPosObj[2, 1] + 7, _aPosObj[2, 2] + 3, _aPosObj[2, 3] - 3, _aPosObj[2, 4] - 3, _nAlter, _cLinOk, _cTudoOk,, _aAlter,,, _cFldOk,, _lDelOk, _oDlg1, _aHeaderXE, _aColsXE)

//��������������������������������������������������������������Ŀ
//� Monta o aHeader e o aCols do SXF.                            �
//����������������������������������������������������������������
SXF->(CriaGD(@_aHeaderXF, @_aColsXF, @_aRecNoXF))
_oGrpXF  := TGroup():New(_aPosObj[3, 1], _aPosObj[3, 2], _aPosObj[3, 3], _aPosObj[3, 4], "SXF - N�mero em uso / n�meros liberados",,,, .T.)
_aAlter  := {"XF_TAMANHO", "XF_NUMERO"}
_oGetDXF := MsNewGetDados():New(_aPosObj[3, 1] + 7, _aPosObj[3, 2] + 3, _aPosObj[3, 3] - 3, _aPosObj[3, 4] - 3, _nAlter, _cLinOk, _cTudoOk,, _aAlter,,, _cFldOk,, _lDelOk, _oDlg1, _aHeaderXF, _aColsXF)

// Exibe a tela montada para o usuario.
Activate msDialog _oDlg1 center on init EnchoiceBar(_oDlg1, _bBntOk, _bBntCan)

// Se o usuario confirmou, grava nas tabelas.
If _nRetUser == 1
	// Grava as tabelas.
	GrvXEXF("SXE", _oGetDXE:aHeader, _oGetDXE:aCols, _aRecNoXE)
	GrvXEXF("SXF", _oGetDXF:aHeader, _oGetDXF:aCols, _aRecNoXF)
Endif

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FilAlias � Autor � Felipe Raposo      � Data �  26/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Abre tela para o usuario digitar o alias que ele quer fil- ���
���          � trado na tela.                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Italian Coffee do Brasil.                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FilAlias(_cTabelaP, _oObjXE, _aRecNoXE, _oObjXF, _aRecNoXF)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _oDlg1, _oSay1, _oGet1, _oBtnOk, _oBtnCan
Local _aPosObj[0], _aObjetos[0], _aInfo[0], _aTam[0]
Private _cTabela := _cTabelaP

//������������������������������������������������������������������Ŀ
//� Solicita que o usuario seleciona a tabela que deseja visualizar. �
//��������������������������������������������������������������������

// Calcula as dimensoes da tela.
aAdd(_aObjetos, {000, 010, .T., .F.})
aAdd(_aObjetos, {000, 000, .T., .T.})
aAdd(_aObjetos, {000, 015, .T., .F.})
_aTam    := {000, 000, 140, 050, 280, 100, 000}
_aInfo   := {_aTam[1], _aTam[2], _aTam[3], _aTam[4], 3, 3}
_aPosObj := MsObjSize(_aInfo, _aObjetos)

// Desenha a tela.
Define msDialog _oDlg1 title "Manuten��o do n�mero sequencial" from _aTam[7], 0 to _aTam[6], _aTam[5] pixel

// Label no top da tela.
_oSay1 := TSay():New(_aPosObj[1, 1], _aPosObj[1, 2], {|| "Digite o alias da tabela que se deseja dar manuten��o"}, _oDlg1,,,,,, .T.,,,, 007)

// Label no top da tela.
_oGet1 := TGet():New(_aPosObj[2, 1], _aPosObj[2, 2], {|u| IIf(PCount() == 0, _cTabela, _cTabela := u)}, _oDlg1,, 10, "@!", {|| !empty("SX2", 1, _cTabela, "X2_CHAVE")},,,, .T.,, .T., "Alias da tabela",,,,,, .F.)

// Botoes OK e Cancelar.
_oBtnOk  := sButton():New(_aPosObj[3, 1], _aPosObj[3, 4] - 60, 1, {|| _nRetUser := 1, _oDlg1:End()}, _oDlg1)
_oBtnCan := sButton():New(_aPosObj[3, 1], _aPosObj[3, 4] - 30, 2, {|| _nRetUser := 0, _oDlg1:End()}, _oDlg1)

// Exibe a tela montada para o usuario.
Activate msDialog _oDlg1 center

// Se o usuario cancelou, o sistema retorna falso.
If _nRetUser != 1
	Return .F.
Endif
_cTabelaP := _cTabela

// Se os objetos foram passados por parametro, os atualiza tambem.
If ValType(_oObjXE) == "O"
	SXE->(CriaGD(@_oObjXE:aHeader, @_oObjXE:aCols, @_aRecNoXE)); _oObjXE:Refresh()
	SXF->(CriaGD(@_oObjXF:aHeader, @_oObjXF:aCols, @_aRecNoXF)); _oObjXF:Refresh()
Endif

Return .T.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CriaGD   � Autor � Felipe Raposo      � Data �  26/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Cria as matrizes aHeader, aCols e aRecNo da tabela sele-   ���
���          � cionada (SXE ou SXF).                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Italian Coffee do Brasil.                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CriaGD(_aHeader, _aCols, _aRecNo)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cUsado := "���������������"
Local _cAlias := Alias()
Local _cFiltro := right(_cAlias, 2) + "_ALIAS == '" + _cTabela + "'"
Local _nAux1, _aAux1

//��������������������������������������������������������������Ŀ
//� Monta o aHeader e o aCols do SXE ou SXF.                     �
//����������������������������������������������������������������
_aHeader := {}; _aCols := {}; _aRecNo := {}
aEval(dbStruct(), {|x| aAdd(_aHeader, {Capital(SubStr(x[1], 4)), x[1], "@!", x[3], x[4], "", _cUsado, x[2], _cAlias, "S"})})
dbGoTop()
Do While !eof()
	If &_cFiltro
		// Inclui o registro na _aColsXE.
		_aAux1 := {}; aEval(_aHeader, {|x| aAdd(_aAux1, &(x[2]))})
		aAdd(_aAux1, .F.)  // Campos de apagado tem que estar como falso.
		aAdd(_aCols, aClone(_aAux1))
		
		// Armazena o RecNo do registro.
		aAdd(_aRecNo, {RecNo(), len(_aCols)})
	Endif
	
	// Vai para o proximo item da tabela.
	dbSkip()
EndDo

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GrvXEXF  � Autor � Felipe Raposo      � Data �  26/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Cria as matrizes aHeader, aCols e aRecNo da tabela sele-   ���
���          � cionada (SXE ou SXF).                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Italian Coffee do Brasil.                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GrvXEXF(_cAlias, _aHeader, _aCols, _aRecNo)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nAux1
Private _cCampo

dbSelectArea(_cAlias)
For _nAux1 := 1 to len(_aCols)
	dbGoTo(_aRecNo[_nAux1, 1])
	RecLock(_cAlias, .F.)
	// Atualiza todos os campos.
	aEval(_aHeader, {|x, y| &(x[2]) := _aCols[_nAux1, y]})
	msUnLock()
Next _nAux1
Return



/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Funcao    �TranSqlString �Autor  �Microsiga           � Data �  18/10/06   ���
�����������������������������������������������������������������������������͹��
���Desc.     �Inseri em uma matriz os dados de uma string delimitada por      ���
���          �caracter especial ( virgula, ponto-e-virgula, etc..)            ���
�����������������������������������������������������������������������������͹��
���Uso       � AP                                                             ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function TranSqlString(_cString)

Local _aLista:= {}

If !Empty(u_ValPad(_cString, ""))

	_aChar:= {",",";","/",".","-"}

	If Len(_cString) > 1
	
	    // A string deve ter separacao de itens feita por um dos caracteres do array acima.
	    nPos:= 0
	    For c:= 1 to Len(_aChar)
	        nPos:= At(_aChar[c],_cString)
		    If nPos > 0
		       Exit
		    EndIf
        Next

        If nPos > 0
	        _cChar:= _aChar[c]
            _nPos2:= 99
            _cPart:= ""
            _cStringAux:= _cString
            While (_nPos2 > 0)
                 _nPos2:= At( _cChar, _cStringAux)
                 _cPart:= Substr(_cStringAux,1, iif( _nPos2>0, (_nPos2-1), Len(_cStringAux) ) )
  			     aAdd(_aLista, Alltrim(_cPart) )
                 _cStringAux:= Alltrim(Substr( _cStringAux,_nPos2+1)  )
            End-While

            If Substr(_cString, Len(Alltrim(_cString)),1) == _cChar
               aAdd( _aLista, Space(Len(_cStringAux)) )
            EndIf
    	Else
    	    // Adiciona o que provavelmente e' o unico item.
		    aAdd(_aLista,AllTrim(_cString))
     	Endif
     	
	EndIf		

Else
    aAdd(_aLista,_cString)
EndIf

Return(_aLista)

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Funcao    �TranSqlString �Autor  �Gilberto            � Data �  18/10/06   ���
�����������������������������������������������������������������������������͹��
���Desc.     �Retorna uma expressao no formato necessario para ser aplicada   ���
���          �na clausula IN do SQL a partir de itens de um array.            ���
�����������������������������������������������������������������������������͹��
���Uso       � AP                                                             ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function MontaInSql(_aLista)

Local _cExpress:= "'"

If Len( u_ValPad(_aLista,{}) ) > 0
	
	For x:= 1 to Len(_aLista)
		_cExpress+= _aLista[x]+"'"+iif( X<Len(_aLista),",'","")
	Next
	
EndIf

Return(_cExpress)



/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ValidNumLiq �Autor  �Gilberto            � Data �  14/12/06   ���
���������������������������������������������������������������������������͹��
���Desc.     �Pega sempre um numero valido NAO DUPLICADO para utilizar.     ���
���          �Verifica antes se tem duplicidade no SE1.                     ���
���������������������������������������������������������������������������͹��
���Uso       � AP                                                           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function ValidNumLiq()

Local _Area:= u_GetArea({"SE1"})
Local _cNumLiq:= Soma1(GetMv("MV_NUMLIQ"),6)

While (_lLiquida:= SeekLiq(_cNumLiq) )
      _cNumLiq:= Soma1(_cNumLiq,6)
End-While

u_PutMV("MV_NUMLIQ", _cNumLiq)

u_RestArea(_Area)

Return(_cNumLiq)


/*
Verifica se existem liquidacoes ja feitas com o numero fornecido como parametro.
*/
Static Function SeekLiq(_cNumLiq)

Local _lRet:= .f.
Local _cQuery:= ""

_cQuery+= "SELECT COUNT(*) AS TOTREG FROM "+RetSqlName("SE1")+" "
_cQuery+= "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "+" E1_NUMLIQ = '"+_cNumLiq+"' AND D_E_L_E_T_ <> '*'"
dbUseArea(.T., "TOPCONN", TcGenQry(,, _cQuery), "CONT", .T., .T.)
_lRet:= (CONT->TOTREG>0)
CONT->(DbCloseArea())

Return(_lRet)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � DeleteFiles �Autor  �Gilberto            � Data �  07/11/07   ���
����������������������������������������������������������������������������͹��
���Desc.     �Deleta arquivos de um diretorio especifico, deixando de lado   ���
���          �o que for excessao, antes fazendo um backup do q for excluido. ���
����������������������������������������������������������������������������͹��
���Uso       � AP                                                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

// _cPasta -> Pasta a ser analisada a partir do RootPath do Protheus.
// _cPastaBackup -> Pasta Backup onde serao gravados os arquivos que serao eliminados
// _cCoringa -> Caracteres coringa (Exemplos: *.* , *.xnu) para pesquisar o arquivo na Pasta indicada por _cPasta
// _aListaExcessao -> Lista de arquivos que nao devem ser apagados.
User Function DeleteFiles( _cPasta, _cPastaBackup,_cCoringa,_aListaExcessao)

Local _aArea := u_GetArea()
Local _aTodosMenus:={}
Local _cFileName:= ""
Local _cFileBackup:= ""
Local _nQtdDeletados:= 0
Local _lBackupOK:= .t.

// Valores padrao
If ValType(_cPasta) == NIL
   ApMsgStop("Erro: Parametro 1 � obrigat�rio !")
   Return(0)
EndIf

_cPastaBackup:= u_ValPad(_cPastaBackup,"|SEMBACKUP|")
_cCoringa:= u_ValPad(_cCoringa,"*.*")
_aListaExcessao:= u_ValPad(_aListaExcessao, {} )

If ( _cPastaBackup == "|SEMBACKUP|" )
   If !ApMsgYesNo( "Foi feita op��o pela EXCLUSAO DE ARQUIVOS sem a realizacao de Backup dos mesmos."+Chr(13)+"Confirma a Exclusao?")
      Return(0)
   EndIf
EndIf

// Se o diretorio de backup nao existir, entao cria.
If !File(_cPastaBackup)
	If MakeDir(_cPastaBackup) != 0
	   ApMsgStop("Nao foi possivel criar a pasta de backup solicitada"+chr(13)+"A dele��o dos arquivos n�o ser� feita.")
	   Return(0)
	EndIf
EndIf

_cCoringa:= _cPasta+"\"+_cCoringa
_aArquivos:= Directory(_cCoringa)

For Ind:= 1 to Len(_aArquivos)
	
	_cFileName:= Alltrim(_aArquivos[Ind,1])
	_cFileName:= _cPasta+"\"+_cFileName
	// Quando nao encontrar o arquivo na lista de excessoes, faz o backup
	If AScan( _aListaExcessao,_cFileName  ) == 0
	
	   If (_cPastaBackup != "|SEMBACKUP|")
	      _cFileBackup:= _cPastaBackup+"\"+_cFilename
		   COPY FILE (_cFileName) TO (_cFileBackup)  // Copia o arquivo para a pasta de "sem conexao".
	   EndIf
	   // Caso o backup esteja ok, entao confirma a exclusao do arquivo.	
	   If _lBackupOK
  	   	  Ferase(_cFileName)
	      _nQtdDeletados+= 1		
	   EndIf
	EndIf
	
Next
u_RestArea(_aArea)
Return(_nQtdDeletados)


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//���������������������������Ŀ
	//�Tratamento para tema "Flat"�
	//�����������������������������
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

User Function NumFinAjuste(cNum)
Local cPrefixo:= Subs(cNum,1,3)
Local cTitulo:= PadR(Subs(cNum,4,6),9)
Local cParcela:= Subs(cNum,10,1)
Local cTipo:= Subs(cNum,11)                
Return(cPrefixo+cTitulo+cParcela+cTipo)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RetSx3Tipo�Autor  �Gilberto            � Data �  08/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o tipo do campo de acordo com o SX3.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Sx3RetTipo(cCampo)

Local aArea:= u_GetArea({"SX3"})
Local cTipo:= ""
                         
SX3->(DbSetOrder(2))
SX3->(DbSeek(cCampo))   
If SX3->(Found())
   cTipo:= SX3->X3_TIPO 
EndIf

//Restaura area anterior.
u_RestArea(aArea)
                
Return(cTipo)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WinCliLoja�Autor  �Gilberto            � Data �  10/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Solicita a digitacao do Codigo do Cliente e da Loja         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WinCliLoja()

Local _lSaida:= .f.
Local _cCliente:= Space(06)
Local _cLoja:= Space(02)   
Local oTelinha

@ 144,99 TO 276,371 DIALOG oTelinha TITLE "CONFIRME Codigo e Loja do Cliente"
@ 004,07 TO 030,078 TITLE "Cliente"
@ 014,11 GET _cCliente PICTURE "@!" Size 60,10 Valid !Empty(_cCliente) F3 "SA1"
@ 036,07 To 062,078 Title "Loja"
@ 046,12 Get _cLoja Picture "@!" Size 60,10 Valid !Empty(_cLoja)
@ 007,86 BmpButton Type 1 Action Close(oTelinha)
@ 027,86 BmpButton Type 2 Action (_lSaida:= .t., Close(oTelinha) )
ACTIVATE DIALOG oTelinha CENTERED

If ( _lSaida )
	_cCliente:= Space(06)
	_cLoja:= Space(02)
EndIf	

Return( {_cCliente,_cLoja} )
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �FSaida()  �Autor  �Protheus            � Data �  24/07/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                
Static Function FSaida()
_lSaida:= .T.
Close(oTelinha)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RetGrupo  �Autor  �Gilberto            � Data �  24/10/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna o nome do grupo a que pertence o usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RetGrupo( cUsuario )

Local aArea:= GetArea()
Local aArray := {}
Local cIdGrupo:= ''
Local cGrupo:= ''

// Ordem por nome de usuario.
PswOrder(2)

// Pesquisa por nome de usuario.
If PswSeek( cUsuario, .T. )

  // Retorna vetor com informacoes do usuario, de acordo com o segundo parametro de PswSeek
  aArray := PswRet() 

  // Pega o Id do Grupo na posicao que ele ocupa no array.
  cIdGrupo:= aArray[1,10,1]  

  If !Empty(cIdGrupo)      
	 
	 // Colocar por ordem de Id.
     PswOrder(1)               

     // Procura o grupo pelo Id. ( Segundo Parametro igual a .F. indica que buscar ser pelo iD)
	 If PswSeek( cIdGrupo, .F. )  
	    // Retorna nome do Grupo de Usu�rio  		 
	  	cGrupo := PswRet()[1][2] 
     EndIf
     
  EndIf   
  
EndIf

// Restaura area.
RestArea(aArea)

Return(cGrupo)

User Function TiraAct(_cTexto, _lChar,_cSaida)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cRet
Local _nAux1, _nAux2, _cAux1, _cAux2, _cAux3, _aAux1

// Acerta parametros.
_lChar := U_ValPad(_lChar, .F.)

// Acerta parametros.
_cSaida := Upper(U_ValPad(_cSaida, Space(01) ))

// Trata os acentos do texto que sera exibido no console.
_aAux1 := {;
{"�����", "a"},;
{"�", "c"},; 
{"�", "c"},;
{"����", "e"},;
{"����", "i"},;
{"�", "n"},;
{"�����", "o"},;
{"����", "u"},;
{"�����", "A"},;
{"�", "C"},;
{"����", "E"},;
{"����", "I"},;
{"�", "N"},;
{"�����", "O"},;
{"����", "U"}}

// Quando a saida eh XML (para Excel ou OpenOffice), troca o "&" . 
If (_cSaida == "XML") 
   aAdd(_aAux1,{"&" ,"&amp;"})
EndIf   

// Substitui os acentos.
_cRet := _cTexto
For _nAux1 := 1 to len(_aAux1)
	_cAux1 := _aAux1[_nAux1, 1]  // Caracteres as serem substituidos.
	_cAux2 := _aAux1[_nAux1, 2]  // Caracter substituto.
	For _nAux2 := 1 to len(_cAux1)
		_cAux3 := SubStr(_cAux1, _nAux2, 1)    // Caracter a ser excluido (da vez).
		_cRet  := StrTran(_cRet, _cAux3, _cAux2)
	Next _nAux2
Next _nAux1

// Retira os caracteres especiais.
If _lChar
	_cAux1 := ""
	For _nAux1 := 1 to len(_cRet)
		_cAux2 := SubStr(_cRet, _nAux1, 1)
		_nAux2 := asc(_cAux2)
		_cAux1 += IIf(_nAux2 >= 32 .and. _nAux2 <= 125, _cAux2, "")
	Next _nAux1
	_cRet := _cAux1
Endif

Return(_cRet)
