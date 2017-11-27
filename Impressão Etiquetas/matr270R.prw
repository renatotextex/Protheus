#INCLUDE "MATR270.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁUMATR270  Ё Autor Ё Renato S. Parreira    Ё Data Ё 08.01.07 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁEtiquetas para Inventario                                   Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Generico                                                   Ё╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function Matr270R()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL titulo   := STR0001	//"Etiquetas para Inventario"
LOCAL cDesc1   := STR0002	//"Este programa ira emitir etiquetas para contagem do estoque."
LOCAL cDesc2   := STR0003	//"Sera emitido em 3 colunas para cada produto."
LOCAL cDesc3   := ""
LOCAL cString  := "SB1"
LOCAL wnrel    := "MATR270"
LOCAL aOrd     := {}



//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea1	:= Getarea()

/*BEGINDOC
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд\©
//ЁNA GestЦo de concessionАrias nЦo serА utilizado a ordem Por Localizacao Fisica   Ё
//Ёpor isso que nЦo serЦo exibidos as perguntas mv_par15 - Localizacao Fisica De e  Ё
//Ёmv_par16 - Localizacao Fisica Ate, atravИs das variАveis lPymeSx1a e lT          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд\ы
//ENDDOC*/
Local lPymeSx1a:= __lPymeSx1 // ConteЗdo do __lPymeSx1 antes de entrar nesse relatorio

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Private lVEIC		:= UPPER(GETMV("MV_VEICULO"))=="S"
Private aSB1Cod	:= {}
Private aSB1Ite	:= {}
Private cCABPROD  := ""
Private lT			:= .T.
Private cCodZB    := "AG"+Alltrim(Str(Ano(dDataBase)))
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Tratamento da Ordem para utilizacao do Siga Pyme e           Ё
//Ё da GestЦo de ConcessionАrias Tratamento, pois nЦo tem o      Ё
//Ё conceito de Localizacao Fisica. Marcos Hirakawa              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If __lPyme
	lT := .F.
Else
	If lVEIC
		lT := .F.
	Endif
Endif
If lT
	aOrd := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0026)}   //" Por Codigo         "###" Por Tipo           "###" Por Descricao    "###" Por Grupo        "###" Por Localizacao Fisica "
Else
	aOrd := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007)}   //" Por Codigo         "###" Por Tipo           "###" Por Descricao    "###" Por Grupo        "
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis tipo Private padrao de todos os relatorios         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PRIVATE aReturn:= { OemToAnsi(STR0008), 1,OemToAnsi(STR0009), 2, 2, 1, "",1 }    //"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 ,cPerg := "MTR270"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01     // Almox. de                                    Ё
//Ё mv_par02     // Almox. ate                                   Ё
//Ё mv_par03     // Produto de                                   Ё
//Ё mv_par04     // Produto ate                                  Ё
//Ё mv_par05     // tipo de                                      Ё
//Ё mv_par06     // tipo ate                                     Ё
//Ё mv_par07     // grupo de                                     Ё
//Ё mv_par08     // grupo ate                                    Ё
//Ё mv_par09     // descricao de                                 Ё
//Ё mv_par10     // descricao ate                                Ё
//Ё mv_par11     // Numero da primeira ficha                     Ё
//Ё mv_par12     // Data de Selecao de                           Ё
//Ё mv_par13     // Data de Selecao ate                          Ё
//Ё mv_par14     // Qual Ordem de Coluna                         Ё
//Ё mv_par15     // Localizacao Fisica De                        Ё
//Ё mv_par16     // Localizacao Fisica Ate                       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

if lVEIC
	/******/
	__lPymeSx1 := .F. // para nЦo exibir as perguntas mv_par15 e mv_par16 - ALTERADO EM 23/01/007 MARCOS A. MARCHESINI
	/******/
	DBSELECTAREA("SX1")
	DBSETORDER(1)
	DBSEEK(cPerg)
	DO WHILE SX1->X1_GRUPO == cPerg .AND. !SX1->(EOF())
		IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
			(SX1->X1_TAMANHO <> aSB1Ite[1] .OR. UPPER(SX1->X1_F3) <> "VR4")
			
			RECLOCK("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Ite[1]
			SX1->X1_F3 := "VR4"
			DBCOMMIT()
			MSUNLOCK()
		ELSEIF UPPER(SX1->X1_F3) == "SBE"
			RECLOCK("SX1",.F.)
			SX1->X1_PYME := 'N'
			DBCOMMIT()
			MSUNLOCK()
		ENDIF
		
		DBSKIP()
	ENDDO
	DBCOMMITALL()
	RESTAREA(aArea1)
else
	DBSELECTAREA("SX1")
	DBSETORDER(1)
	DBSEEK(cPerg)
	DO WHILE SX1->X1_GRUPO == cPerg .AND. !SX1->(EOF())
		IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
			(SX1->X1_TAMANHO <> aSB1Cod[1] .OR. UPPER(SX1->X1_F3) <> "SB1")
			
			RECLOCK("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Cod[1]
			SX1->X1_F3 := "SB1"
			DBCOMMIT()
			MSUNLOCK()
		ELSEIF UPPER(SX1->X1_F3) == "SBE" .AND.  UPPER(SX1->X1_PYME) == 'N'
			RECLOCK("SX1",.F.)
			SX1->X1_PYME := 'S'
			DBCOMMIT()
			MSUNLOCK()
		ENDIF
		DBSKIP()
	ENDDO
	DBCOMMITALL()
	RESTAREA(aArea1)
endif

pergunte(cPerg,.F.)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

dbSelectArea("SB1")
If nLastKey = 27
	dbClearFilter()
	__lPymeSx1	:= lPymeSx1a // volta com a situaГЦo do __lPymeSx1 anterior.
	Return
Endif

SetDefault(aReturn,cString)

dbSelectArea("SB1")
If nLastKey = 27
	dbClearFilter()
	__lPymeSx1	:= lPymeSx1a // volta com a situaГЦo do __lPymeSx1 anterior.
	Return
Endif

//  lT -> .T. = Por Localizacao Fisica
lT := iif(aReturn[8] == 5, .T., .F.)

titulo	:= ALLTRIM(titulo) + ' - ' + alltrim(aOrd[aReturn[8]])

//If aReturn[8] == 5
//	RptStatus({|lEnd| A270ImpEnd(aOrd,@lEnd,wnrel,cString,titulo)},titulo)
//Else
RptStatus({|lEnd| C270Imp(aOrd,@lEnd,wnrel,cString,titulo)},titulo)
//Endif

__lPymeSx1	:= lPymeSx1a // volta com a situaГЦo do __lPymeSx1 anterior.
Return NIL

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё C270IMP  Ё Autor ЁRenato S. Parreira     Ё Data Ё 08.01.07 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Chamada do Relatorio                                       Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё MATR270			                                          Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function C270Imp(aOrd,lEnd,wnrel,cString,titulo)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis locais exclusivas deste programa                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL cLinha,cLinha1,cColuna,nNum
LOCAL nTipo := 0
LOCAL cOrd  := ""
LOCAL cLocal:=cLocaliz :=""
LOCAL nC	:= 0
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
local cArq1 := ""
local nInd1 := 0

Local aPrint := {}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Contador de linha                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PRIVATE li		:= 80
PRIVATE limite	:= 132
Private aMat    := {}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis privadas exclusivas deste programa                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PRIVATE cCondicao,lContinua,cCondSB

cQuery := ""
If (mv_par20 == 1)

	cQuery := ""
	cQuery += "SELECT B1_COD,B8_LOTECTL, B2_LOCAL BF_LOCAL,B8_NUMLOTE,B1_DESC,B1_TIPO,B8_DATA, "
	cQuery += "B1_GRUPO,B1_UM,B1_CODITE,ISNULL(BF_LOCALIZ,' ') AS BF_LOCALIZ "
	cQuery += "FROM "+RetSqlName("SB2")+" SB2 "
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB2.B2_FILIAL = SB1.B1_FILIAL AND "
	cQuery += "                         SB2.B2_COD = SB1.B1_COD       AND "
	cQuery += "                         SB1.B1_FILIAL='"+xFilial("SB1")+"'            AND "
	cQuery += "						    SB1.B1_TIPO  BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'  AND "
	cQuery += "						    SB1.B1_GRUPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'  AND "
	cQuery += "						    SB1.B1_DESC  BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'  AND "
	cQuery += "                         SB1.B1_RASTRO ='L' AND "
    if mv_par26==1
 	  cQuery += "                         SB1.B1_LOCALIZ='S' AND "
 	else  
 	  cQuery += "                         SB1.B1_LOCALIZ<>'S' AND "
    Endif
	cQuery += "                         SB1.D_E_L_E_T_ = ' ' "
	cQuery += "INNER JOIN "+RetSqlName("SB8")+" SB8 ON SB2.B2_FILIAL = SB8.B8_FILIAL  AND "
	cQuery += "                         SB2.B2_COD    = SB8.B8_PRODUTO AND "
	cQuery += "                         SB2.B2_LOCAL  = SB8.B8_LOCAL   AND "
	cQuery += "                         SB8.B8_FILIAL = '"+xFilial("SB8")+"' AND "
	cQuery += "                         SB8.D_E_L_E_T_ = ' ' AND "
	If (mv_par17 == 1)  // Com Saldo
	  cQuery += "                         SB8.B8_SALDO > 0     AND "
    Else
	  cQuery += "                         SB8.B8_SALDO = 0     AND "
	Endif  
	cQuery += "                         SB8.B8_QACLASS =0    AND "
	cQuery += "                         SB8.B8_LOTECTL BETWEEN '"+mv_par22+"' AND '"+mv_par23+"' "
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SBF")+" SBF ON SB8.B8_FILIAL  = SBF.BF_FILIAL  AND "
	cQuery += "                               SB8.B8_PRODUTO = SBF.BF_PRODUTO AND "
	cQuery += "                               SB8.B8_LOCAL   = SBF.BF_LOCAL   AND "
	cQuery += "                               SB8.B8_LOTECTL = SBF.BF_LOTECTL AND "
	cQuery += "                               SBF.BF_FILIAL = '"+xFilial("SBF")+"' AND "
    if mv_par26==1
	 cQuery += "                               SBF.BF_LOCALIZ BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' AND "
    Endif
	cQuery += "                               SBF.BF_QUANT > 0 AND "
	cQuery += "                               SBF.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery += "     SB2.B2_FILIAL = '"+xFilial("SB2")+"' AND "
	cQuery += "     SB2.B2_LOCAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	If (mv_par17 == 1)  // Com Saldo
	   cQuery += "     SB2.B2_QATU > 0 "
	Else
	   cQuery += "     SB2.B2_QATU = 0  "
	Endif   
    cQuery += "	AND SB2.D_E_L_E_T_ = ' ' AND "
	cQuery += "     SB2.B2_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
    if mv_par26==1
	 cQuery += " AND SBF.BF_LOCALIZ BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' "
    Endif
	If (aReturn[8] == 1)
		cQuery += "ORDER BY B2_COD,B2_LOCAL,B8_LOTECTL "
	ElseIf (aReturn[8] == 2)
		cQuery += "ORDER BY B1_TIPO,B2_COD,B2_LOCAL,B8_LOTECTL "
	ElseIf (aReturn[8] == 3)
		cQuery += "ORDER BY B1_DESC,B2_COD,B2_LOCAL,B8_LOTECTL"
	ElseIf (aReturn[8] == 4)
		cQuery += "ORDER BY B1_GRUPO,B2_COD,B2_LOCAL,B8_LOTECTL "
	ElseIf (aReturn[8] == 5)
		cQuery += "ORDER BY BF_LOCALIZ,B8_LOTECTL,B2_COD,B2_LOCAL "
	ElseIf (aReturn[8] == 6)
	    cQuery += "ORDER BY B8_LOTECTL,BF_LOCALIZ,B2_COD,B2_LOCAL "
	Endif	
	
ElseIf (mv_par20 == 2 .OR. mv_par20 == 3)

	cQuery :=""
	cQuery += "SELECT B1_COD,ZA8_COD,ZA8_LOTECT,ISNULL(ZA8_LOCALI,' ') AS ZA8_LOCALI,ZA8_LOCAL, "
	cQuery += "ZA8_NUMLOT,B1_DESC,B1_TIPO,B1_GRUPO,B1_UM,B1_CODITE,ZA8_DOC,ZA8_ETIQUE "
	cQuery += "FROM "+RetSqlName("ZA8")+" ZA8 "
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = ZA8.ZA8_FILIAL AND SB1.B1_COD = ZA8.ZA8_COD AND SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
	cQuery += "						 SB1.B1_TIPO    BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	cQuery += "						 SB1.B1_GRUPO   BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
	cQuery += "						 SB1.B1_DESC    BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' AND "
	cQuery += "						 SB1.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery += "ZA8.ZA8_FILIAL = '"+xFilial("ZA8")+"' AND "
	cQuery += "ZA8.ZA8_LOCAL  BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery += "ZA8.ZA8_COD    BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQuery += "ZA8.ZA8_DATA   BETWEEN '"+dtos(mv_par12)+"' AND '"+dtos(mv_par13)+"' AND "
	cQuery += "ZA8.ZA8_LOTECT BETWEEN '"+mv_par22+"' AND '"+mv_par23+"' AND "
	cQuery += "ZA8.ZA8_LOCALI BETWEEN '"+mv_par15+"' AND '"+mv_par16+"' AND " 
	cQuery += "ZA8.ZA8_ETIQUE BETWEEN '"+mv_par24+"' AND '"+mv_par25+"' AND "
	cQuery += "ZA8.ZA8_DOC = '"+cCodZB+"' "
	If (mv_par20 == 2)
		cQuery += " AND ZA8_QTD2 = 0 AND ZA8_CONTAG = 1 "
	ElseIf (mv_par20 == 3)
		cQuery += " AND ZA8_QTD3 = 0 AND ZA8_CONTAG = 2 "
	Endif

	If     mv_par21 == 1
		cQuery += " AND ZA8_ENCERR = 'S' "
	Elseif mv_par21 == 2
		cQuery += " AND ZA8_ENCERR = 'N' "
	Elseif mv_par21 == 3	
		cQuery += " AND ZA8_ENCERR IN ('S','N',' ')  "	
	Endif
	
	If (aReturn[8] == 1)
		cQuery += "ORDER BY ZA8.ZA8_COD,ZA8.ZA8_LOCAL,ZA8.ZA8_LOTECT"
	ElseIf (aReturn[8] == 2)
		cQuery += "ORDER BY SB1.B1_TIPO,ZA8.ZA8_COD,ZA8.ZA8_LOCAL,ZA8.ZA8_LOTECT"
	ElseIf (aReturn[8] == 3)
		cQuery += "ORDER BY SB1.B1_DESC,ZA8.ZA8_COD,ZA8.ZA8_LOCAL,ZA8.ZA8_LOTECT"
	ElseIf (aReturn[8] == 4)
		cQuery += "ORDER BY SB1.B1_GRUPO,ZA8.ZA8_COD,ZA8.ZA8_LOCAL,ZA8.ZA8_LOTECT"
	ElseIf (aReturn[8] == 5)
		cQuery += "ORDER BY ZA8.ZA8_LOCALI,ZA8.ZA8_COD,ZA8.ZA8_LOCAL,ZA8.ZA8_LOTECT"
	Endif
Endif

TCQUERY cQuery NEW ALIAS "TQRY"

Dbselectarea("TQRY")
TQRY->(Dbgotop())

_nItens := 0

Count To _nItens

cLinha  := "|"+Replicate("-",128)+"|"
cLinha1 := Replicate("=",130)
cColuna := "|"+Space(42)+"|"+Space(42)+"|"+Space(42)+"|"
lContinua := .T.


Dbselectarea("TQRY")
TQRY->(Dbgotop())
nNum := IIF(mv_par20==1,VerMax(cCodZB)+1,TQRY->ZA8_ETIQUE)

SetRegua(_nItens)

While !TQRY->(EOF())
	

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Faz manualmente porque nao chama a funcao Cabec()            Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	@ 0,0 PSay AvalImp(Limite)
	
    aPrint := {}
	If (mv_par20 == 1)
		aadd(aPrint,{TQRY->BF_LOCALIZ,TQRY->BF_LOCAL,TQRY->B1_COD,TQRY->B8_LOTECTL,TQRY->B8_NUMLOTE,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE,nNum})
	Else
		aadd(aPrint,{TQRY->ZA8_LOCALI,TQRY->ZA8_LOCAL,TQRY->B1_COD,TQRY->ZA8_LOTECT,TQRY->ZA8_NUMLOT,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE,Val(TQRY->ZA8_ETIQUE)})
	Endif
	
	aPrint2 := {}
	TQRY->(Dbskip())
	nNum++
	If (mv_par20 == 1)
		aadd(aPrint2,{TQRY->BF_LOCALIZ,TQRY->BF_LOCAL,TQRY->B1_COD,TQRY->B8_LOTECTL,TQRY->B8_NUMLOTE,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE,nNum})
	Else
		aadd(aPrint2,{TQRY->ZA8_LOCALI,TQRY->ZA8_LOCAL,TQRY->B1_COD,TQRY->ZA8_LOTECT,TQRY->ZA8_NUMLOT,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE,Val(TQRY->ZA8_ETIQUE)})
	Endif
	
	aPrint3 := {}
	TQRY->(Dbskip())
	nNum++
	If (mv_par20 == 1)
		aadd(aPrint3,{TQRY->BF_LOCALIZ,TQRY->BF_LOCAL,TQRY->B1_COD,TQRY->B8_LOTECTL,TQRY->B8_NUMLOTE,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE,nNum})
	Else
		aadd(aPrint3,{TQRY->ZA8_LOCALI,TQRY->ZA8_LOCAL,TQRY->B1_COD,TQRY->ZA8_LOTECT,TQRY->ZA8_NUMLOT,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE,Val(TQRY->ZA8_ETIQUE)})
	Endif
	
	nNum++
	
	aSort(aPrint ,,,{|x,y|  x[2] + x[1] + x[3] + x[4] < y[2] + y[1] + y[3] + y[4] })
	aSort(aPrint2,,,{|x,y|  x[2] + x[1] + x[3] + x[4] < y[2] + y[1] + y[3] + y[4] })
	aSort(aPrint3,,,{|x,y|  x[2] + x[1] + x[3] + x[4] < y[2] + y[1] + y[3] + y[4] })
	
	SB8->(DbSetOrder(3))
	
	For _nx := 1 to len(aPrint)
		
		If Li > 50
			Li := 3
		EndIf
		
		
		@ Li,000 PSay cLinha
		Li++
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Faz a mudanca da ordem selecionada pelo mv_par14.       Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		
		For nC:= 1 To 3
			IncRegua()
			If mv_par20 == 1 //Val(Subs(mv_par14,nC,1)) == 1
				cOrd:= OemtoAnsi(STR0023)   //   "|          A-INVENTARIO No. "
			ElseIf mv_par20 == 2 //Val(Subs(mv_par14,nC,1)) == 2
				cOrd:= OemtoAnsi(STR0024)   //   "|          B-INVENTARIO No. "
			ElseIf mv_par20 == 3 //Val(Subs(mv_par14,nC,1)) == 3
				cOrd:= OemtoAnsi(STR0025)   //   "|          C-INVENTARIO No. "
			Endif
			If nC == 1
			   DbSelectArea("ZB4")
		       DbSetOrder(1)//ZB4_FILIAL, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT,  ZB4_LOCALI,ZB4_LOCAL ,ZB4_ETIQUE, R_E_C_N_O_, D_E_L_E_T_
		       If DbSeek(xFilial("ZB4")+ cCodZB +aPrint[_nx][3]+aPrint[_nx][4]+aPrint[_nx][1]+aPrint[_nx][2] ) .And. mv_par20 == 1
		         aPrint[_nX][11]:=Val(ZB4->ZB4_ETIQUE)
		       Endif  
			   @ Li,000 PSay cOrd+StrZero(aPrint[_nX][11],6)
			ElseIf nC == 2
			   DbSelectArea("ZB4")
		       DbSetOrder(1)//ZB4_FILIAL, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT,  ZB4_LOCALI,ZB4_LOCAL ,ZB4_ETIQUE, R_E_C_N_O_, D_E_L_E_T_
		       If DbSeek(xFilial("ZB4")+ cCodZB +aPrint2[_nx][3]+aPrint2[_nx][4]+aPrint2[_nx][1]+aPrint2[_nx][2] )  .And. mv_par20 == 1
		         aPrint2[_nX][11]:=Val(ZB4->ZB4_ETIQUE)
			   Endif
				@ Li,043 PSay cOrd+StrZero(aPrint2[_nX][11],6)
			ElseIf nC == 3
			   DbSelectArea("ZB4")
		       DbSetOrder(1)//ZB4_FILIAL, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT,  ZB4_LOCALI,ZB4_LOCAL ,ZB4_ETIQUE, R_E_C_N_O_, D_E_L_E_T_
		       If DbSeek(xFilial("ZB4")+ cCodZB +aPrint3[_nx][3]+aPrint3[_nx][4]+aPrint3[_nx][1]+aPrint3[_nx][2])  .And. mv_par20 == 1
		         aPrint3[_nX][11]:=Val(ZB4->ZB4_ETIQUE)
		       Endif  
			   @ Li,086 PSay cOrd+StrZero(aPrint3[_nX][11],6)
			Endif
		 Next nC
		@ Li,129 PSay "|"
		dbSelectArea("SB1")
		Li++
		
		IF !lVEIC
			@ Li,000 PSay cColuna
		ELSE
			//cCABPROD	:= SUBSTR("[ " + B1_CODITE + " ]" + SPACE(42),1,42)
			cCABPROD	:= SUBSTR("[ " + aPrint[_nx][10] + " ]" + SPACE(42),1,42)
			cCABPROD2	:= SUBSTR("[ " + aPrint2[_nx][10] + " ]" + SPACE(42),1,42)
			cCABPROD3	:= SUBSTR("[ " + aPrint3[_nx][10] + " ]" + SPACE(42),1,42)
			@ Li,000 PSay "|" + cCABPROD + "|" + cCABPROD + "|" + cCABPROD + "|"
		ENDIF
		
		Li++
		@ Li,000 PSay "|"+OemToAnsi(STR0011)+aPrint[_nx][3]+OemToAnsi(STR0012)+aPrint[_nx][7]+OemToAnsi(STR0013)+aPrint[_nx][8]+OemToAnsi(STR0014)+aPrint[_nx][9]+"|"+OemToAnsi(STR0011)+aPrint2[_nx][3]+OemToAnsi(STR0012)+aPrint2[_nx][7]+OemToAnsi(STR0013)+aPrint2[_nx][8]+OemToAnsi(STR0014)+aPrint2[_nx][9]+"|"+OemToAnsi(STR0011)+aPrint3[_nx][3]+OemToAnsi(STR0012)+aPrint3[_nx][7]+OemToAnsi(STR0013)+aPrint3[_nx][8]+OemToAnsi(STR0014)+aPrint3[_nx][9]+"|"    //"Codigo:"###" Tp:"###" Gr:"###" Um:"
		Li++
		@ Li,000 PSay OemToAnsi(STR0015)+SubStr(aPrint[_nx][6],1,33)   //"|Descri.: "
		@ Li,043 PSay OemToAnsi(STR0015)+SubStr(aPrint2[_nx][6],1,33)   //"|Descri.: "
		@ Li,086 PSay OemToAnsi(STR0015)+SubStr(aPrint3[_nx][6],1,33)   //"|Descri.: "
		@ Li,129 PSay "|"
		Li++
		aPrint[_nx][4]
		@ Li,000 PSay OemToAnsi(STR0016)+aPrint[_nx][2]+OemToAnsi(STR0017)+SubStr(aPrint[_nx][1],1,15)    //"|Almox..: "###" Localizacao : "
		@ Li,043 PSay OemToAnsi(STR0016)+aPrint2[_nx][2]+OemToAnsi(STR0017)+SubStr(aPrint2[_nx][1],1,15)    //"|Almox..: "###" Localizacao : "
		@ Li,086 PSay OemToAnsi(STR0016)+aPrint3[_nx][2]+OemToAnsi(STR0017)+SubStr(aPrint3[_nx][1],1,15)    //"|Almox..: "###" Localizacao : "
		@ Li,129 PSay "|"
		Li++
		
		@ Li,000 psay "|Lote: " + aPrint[_nx][4] + " Sub-lote: " + aPrint[_nx][5]
		@ Li,043 psay "|Lote: " + aPrint2[_nx][4] + " Sub-lote: " + aPrint2[_nx][5]
		@ Li,086 psay "|Lote: " + aPrint3[_nx][4] + " Sub-lote: " + aPrint3[_nx][5]
		@ Li,129 Psay "|"
		Li++
		@ Li,000 PSay cLinha
		Li++
		@ Li,000 PSay cColuna
		Li++
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Faz a mudanca da ordem selecionada pelo mv_par14.       Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		For nC:= 1 To 3
			If mv_par20 == 1 //Val(Subs(mv_par14,nC,1)) == 1
				cOrd:= OemToAnsi(STR0018)	//"| Data da 1a. contagem : ____/____/____"
			ElseIf mv_par20 == 2 //Val(Subs(mv_par14,nC,1)) == 2
				cOrd:= OemToAnsi(STR0019)	//"| Data da 2a. contagem : ____/____/____"
			ElseIf mv_par20 == 3 //Val(Subs(mv_par14,nC,1)) == 3
				cOrd:= OemToAnsi(STR0020)	//"| Data da 3a. contagem : ____/____/____"
			Endif
			If nC == 1
				@ Li,000 PSay cOrd
			ElseIf nC == 2
				@ Li,043 PSay cOrd
			ElseIf nC == 3
				@ Li,086 PSay cOrd
			Endif
		Next nC
		@ Li,129 PSay "|"
		Li++
		@ Li,000 PSay cLinha
		Li++
		@ Li,000 PSay cColuna
		Li++
		@ Li,000 PSay OemToAnsi(STR0021)	//"| Quantidade apurada:"
		@ Li,043 PSay OemToAnsi(STR0021)	//"| Quantidade apurada:"
		@ Li,086 PSay OemToAnsi(STR0021)	//"| Quantidade apurada:"
		@ Li,129 PSay "|"
		
		Li++
		
	    DbSelectArea("ZB4")
		DbSetOrder(1)//ZB4_FILIAL,  ZB4_DOC, ZB4_PRODUT    ,ZB4_LOTECT    , ZB4_ETIQUE     , ZB4_LOCALI 
		If !DbSeek(xFilial("ZB4")+  cCodZB +aPrint[_nx][3]+aPrint[_nx][4]+aPrint[_nx][1]+aPrint[_nx][2]) .And. mv_par20 == 1
		  If !Empty(Alltrim(aPrint[_nx][3]))		  
			  Reclock("ZB4",.T.)
			  ZB4->ZB4_FILIAL := xFilial("ZB4")
			  ZB4->ZB4_DOC    := cCodZB                                                                         
			  ZB4->ZB4_PRODUT := aPrint[_nx][3]
			  ZB4->ZB4_LOTECT := aPrint[_nx][4]
			  ZB4->ZB4_NUMLOT := ""
			  ZB4->ZB4_LOCALI := aPrint[_nx][1]
			  ZB4->ZB4_ETIQUE := StrZero(aPrint[_nx][11],6)
			  ZB4->ZB4_LOCAL  := aPrint[_nx][2]			  
			  IF MV_PAR20 == 1
			   ZB4->ZB4_QTD1 := 1
			  ELSEIF MV_PAR20 == 2
			   ZB4->ZB4_QTD2 := 1
			  ELSEIF MV_PAR20 == 3
			   ZB4->ZB4_QTD3 := 1
			  ENDIF  
			  MsUnlock()
		  Endif	  
		Else
		  DbSelectArea("ZB4")
		  DbSetOrder(2)
		  DbGotop()
		  If DbSeek(xFilial("ZB4")+ StrZero(aPrint[_nx][11],6) + cCodZB )//ZB4_FILIAL, ZB4_ETIQUE, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT, ZB4_LOCALI, ZB4_LOCAL, R_E_C_N_O_, D_E_L_E_T_
			  Reclock("ZB4",.F.)  
			  IF MV_PAR20 == 1
			   ZB4->ZB4_QTD1 += 1
			  ELSEIF MV_PAR20 == 2
			   ZB4->ZB4_QTD2 += 1
			  ELSEIF MV_PAR20 == 3
			   ZB4->ZB4_QTD3 += 1
			  ENDIF  		  
			  MsUnlock()
		  Endif
		Endif  
		  
		@ Li,000 PSay cLinha
		Li++
        @ Li,000 PSay "| Contagem Nr. "+Alltrim(Str(mv_par20))+" - "+" Qtd. Impressa: "+ IIF(mv_par20==1,Alltrim(Str(ZB4->ZB4_QTD1)),IIF(mv_par20==2,Alltrim(Str(ZB4->ZB4_QTD2)),IIF(mv_par20==3,Alltrim(Str(ZB4->ZB4_QTD3)),"")))  + "   "
        
        DbSelectArea("ZB4")
		DbSetOrder(1)//ZB4_FILIAL, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT, ZB4_ETIQUE, ZB4_LOCALI, R_E_C_N_O_, D_E_L_E_T_
		If !DbSeek(xFilial("ZB4")+ cCodZB +aPrint2[_nx][3]+aPrint2[_nx][4]+aPrint[_nx][1]+aPrint2[_nx][2]) .And. mv_par20 == 1
		  If !Empty(Alltrim(aPrint2[_nx][3]))		  
			  Reclock("ZB4",.T.)
			  ZB4->ZB4_FILIAL := xFilial("ZB4")
			  ZB4->ZB4_DOC    := cCodZB                                                                         
			  ZB4->ZB4_PRODUT := aPrint2[_nx][3]
			  ZB4->ZB4_LOTECT := aPrint2[_nx][4]
			  ZB4->ZB4_NUMLOT := ""
			  ZB4->ZB4_LOCALI := aPrint2[_nx][1]
			  ZB4->ZB4_ETIQUE := StrZero(aPrint2[_nx][11],6)
			  ZB4->ZB4_LOCAL  := aPrint[_nx][2]			  
			  IF MV_PAR20 == 1
			   ZB4->ZB4_QTD1 := 1
			  ELSEIF MV_PAR20 == 2
			   ZB4->ZB4_QTD2 := 1
			  ELSEIF MV_PAR20 == 3
			   ZB4->ZB4_QTD3 := 1
			  ENDIF  
			  MsUnlock()
		  Endif	  
		Else
		  DbSelectArea("ZB4")
		  DbSetOrder(2)
		  DbGotop()
		  If DbSeek(xFilial("ZB4")+ StrZero(aPrint2[_nx][11],6) + cCodZB )//ZB4_FILIAL, ZB4_ETIQUE, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT, ZB4_LOCALI, ZB4_LOCAL, R_E_C_N_O_, D_E_L_E_T_
			  Reclock("ZB4",.F.)  
			  IF MV_PAR20 == 1
			   ZB4->ZB4_QTD1 += 1
			  ELSEIF MV_PAR20 == 2
			   ZB4->ZB4_QTD2 += 1
			  ELSEIF MV_PAR20 == 3
			   ZB4->ZB4_QTD3 += 1
			  ENDIF  		  
			  MsUnlock()
		  Endif
		Endif  
		
        @ Li,043 PSay "| Contagem Nr. "+Alltrim(Str(mv_par20))+" - "+" Qtd. Impressa: "+ IIF(mv_par20==1,Alltrim(Str(ZB4->ZB4_QTD1)),IIF(mv_par20==2,Alltrim(Str(ZB4->ZB4_QTD2)),IIF(mv_par20==3,Alltrim(Str(ZB4->ZB4_QTD3)),"")))  + "   "
        
        DbSelectArea("ZB4")
		DbSetOrder(1)//ZB4_FILIAL, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT, ZB4_ETIQUE, ZB4_LOCALI, R_E_C_N_O_, D_E_L_E_T_
		If !DbSeek(xFilial("ZB4")+ cCodZB +aPrint3[_nx][3]+aPrint3[_nx][4]+aPrint3[_nx][1]+aPrint3[_nx][2]) .And. mv_par20 == 1
		  If !Empty(Alltrim(aPrint3[_nx][3]))
			  Reclock("ZB4",.T.)
			  ZB4->ZB4_FILIAL := xFilial("ZB4")
			  ZB4->ZB4_DOC    := cCodZB                                                                         
			  ZB4->ZB4_PRODUT := aPrint3[_nx][3]
			  ZB4->ZB4_LOTECT := aPrint3[_nx][4]
			  ZB4->ZB4_NUMLOT := ""
			  ZB4->ZB4_LOCALI := aPrint3[_nx][1]
			  ZB4->ZB4_ETIQUE := StrZero(aPrint3[_nx][11],6)
			  ZB4->ZB4_LOCAL  := aPrint[_nx][2]			  
			  IF MV_PAR20 == 1
			   ZB4->ZB4_QTD1 := 1
			  ELSEIF MV_PAR20 == 2
			   ZB4->ZB4_QTD2 := 1
			  ELSEIF MV_PAR20 == 3
			   ZB4->ZB4_QTD3 := 1
			  ENDIF  
			  MsUnlock()
		  Endif  
		Else
		  DbSelectArea("ZB4")
		  DbSetOrder(2)
		  DbGotop()
		  If DbSeek(xFilial("ZB4")+ StrZero(aPrint3[_nx][11],6) + cCodZB )//ZB4_FILIAL, ZB4_ETIQUE, ZB4_DOC, ZB4_PRODUT, ZB4_LOTECT, ZB4_LOCALI, ZB4_LOCAL, R_E_C_N_O_, D_E_L_E_T_
			  Reclock("ZB4",.F.)  
			  IF MV_PAR20 == 1
			   ZB4->ZB4_QTD1 += 1
			  ELSEIF MV_PAR20 == 2
			   ZB4->ZB4_QTD2 += 1
			  ELSEIF MV_PAR20 == 3
			   ZB4->ZB4_QTD3 += 1
			  ENDIF  		  
			  MsUnlock()
		  Endif
		Endif  
        
        @ Li,86 PSay "|Contagem Nr. "+Alltrim(Str(mv_par20))+" - "+" Qtd. Impressa: "+ IIF(mv_par20==1,Alltrim(Str(ZB4->ZB4_QTD1)),IIF(mv_par20==2,Alltrim(Str(ZB4->ZB4_QTD2)),IIF(mv_par20==3,Alltrim(Str(ZB4->ZB4_QTD3)),"")))       
   		@ Li,129 Psay "|"

  		Li++
		@ Li,000 PSay cColuna
		Li++
		@ Li,000 PSay "|"+Replicate(" -------------------- ------------------- |",3)
		Li++
		@ Li,000 PSay "|"+Replicate(OemToAnsi(STR0022),3)    //"  Visto funcionario     Visto Conferente  |"
		Li++
		@ Li,000 PSay cLinha
		Li += 2
		@ Li,000 PSay cLinha1
		Li += 2
	
	Next
	
	aPrint := {}
	TQRY->(Dbskip())
End
//Next

TQRY->(DBCLOSEAREA())
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Devolve a condicao original do arquivo principal             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SB1")
RetIndex("SB1")
Set Filter To
dbSetOrder(1)

If File(cArq1+OrdBagExt())
	Ferase(cArq1+OrdBagExt())
EndIf

If aReturn[5] = 1
	Set Printer TO
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()


RETURN

Static Function Alimdados()
aPrint2 := {}
TQRY->(Dbskip())
If (mv_par20 == 1)
	aadd(aPrint2,{TQRY->BF_LOCALIZ,TQRY->BF_LOCAL,TQRY->B1_COD,TQRY->B8_LOTECTL,TQRY->B8_NUMLOTE,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE})
Else
	aadd(aPrint2,{TQRY->BF_LOCALIZ,TQRY->BF_LOCAL,TQRY->B1_COD,TQRY->B8_LOTECTL,TQRY->ZA8_NUMLOT,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE})
Endif

aPrint3 := {}
TQRY->(Dbskip())
If (mv_par20 == 1)
	aadd(aPrint3,{TQRY->BF_LOCALIZ,TQRY->BF_LOCAL,TQRY->B1_COD,TQRY->B8_LOTECTL,TQRY->B8_NUMLOTE,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE})
Else
	aadd(aPrint3,{TQRY->BF_LOCALIZ,TQRY->BF_LOCAL,TQRY->B1_COD,TQRY->B8_LOTECTL,TQRY->ZA8_NUMLOT,TQRY->B1_DESC,TQRY->B1_TIPO,TQRY->B1_GRUPO,TQRY->B1_UM,TQRY->B1_CODITE})
Endif

Return
//------------------------
static function VerMax(cCodZB)

cQuery := "SELECT ISNULL(MAX(ZB4_ETIQUE),0) AS ZB4ETIQUE FROM ZB4020 WHERE D_E_L_E_T_ = ' ' AND ZB4_FILIAL = '"+xFilial("ZB4")+"' AND ZB4_DOC='"+cCodZB+"'"

If Select("TRB")>0
  DbSelectArea("TRB")
  DbCloseArea()
Endif  

TcQuery cQuery New Alias "TRB"

Return Val(TRB->ZB4ETIQUE)