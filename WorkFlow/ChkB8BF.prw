#Include "Protheus.ch"
#Include "Tbiconn.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkB8BF   บAutor  ณSergio Celestino    บ Data ณ  31/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail de aviso de divergencias entre o Saldo Lote   บฑฑ
ฑฑบ          ณ e o Saldo por Endereco                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                    

User Function ChkB8BF(aParam)

Private oHtml
Private oProcess
Private aRecno    := {}
Private cMailToA  := GetMV( "MV_MAIB8BF" ,,"suporte@intermed.com.br" )
Private cSubject  := ""
Private cPath	  := GetMV( "MV_PATEST", ,"workflow\html\temp\est\" )
Private dDataAvi  := ctod("  /  /  ")
Private cReport   := ""
Private cArquivo  := ""
Private cTipo     := ""
Private nReg      := 0

Private cLocal    := "\workflow\html\"
Private cRecurso  := ""

cArquivo  := "avisob8bf.htm"
cTipo     :=  "[INTERMED] Saldo Lote x Saldo Endere็o - [ SB8 x SBF ]"

dDataAvi  := GetMV( "MV_DTB8BF" ,,dDataBase-1)
If dDataAvi < dDataBase 
   MsgRun( "Aguarde!!!", "Verificando SB8 x SBF...", { ||  VerB8BF() } ) 
Endif   

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerB8BF   บAutor  ณSergio Celestino    บ Data ณ  31/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Analise das Tabelas de Saldo em Estoque                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerB8BF

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

MontaTRB()


oProcess:= TWFProcess():New("CHKB8BF", cTipo)
oProcess:NewTask("CHKB8BF", cLocal+cArquivo)
oProcess:cSubject := cTipo
oProcess:cTo := cMailToA
oProcess:NewVersion(.T.)
oProcess:UserSiga := '000000'
oHtml := oProcess:oHTML
	
oHtml:ValByName( "CJ_EMISSAO"     , dDataBase  )    


DbSelectArea("TRB")
DbGotop()
While !Eof()
	
   AAdd( (oHtml:ValByName( "t.1"    )),  TRB->B8_PRODUTO  )     
   AAdd( (oHtml:ValByName( "t.2"    )),  TRB->B8_LOCAL   )     
   AAdd( (oHtml:ValByName( "t.3"    )),  TRANSFORM(TRB->SALDOB8,"@E 999,999,999.99")    ) 
   AAdd( (oHtml:ValByName( "t.4"    )),  TRANSFORM(TRB->SALDOBF,"@E 999,999,999.99")    )    	    
   AAdd( (oHtml:ValByName( "t.5"    )),  TRANSFORM(TRB->DIF    ,"@E 999,999,999.99")    )    	    
   AAdd( (oHtml:ValByName( "t.6"    )),  TRB->B8_LOTECTL                                )    	    

   DbSelectArea("TRB")  
   DbSkip()
End            

cReport:=DtoS(dDataBase)+"_"+cArquivo
oHTML:SaveFile(cPath+cReport)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia para os destinatarios.         			      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oProcess:AttachFile(cPath+cReport)
oProcess:nEncodeMime := 0
oProcess:Start()
oProcess:Finish()

PutMv("MV_DTB8BF",dDataBase)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaTRB  บAutor  ณSergio Celestino    บ Data ณ  31/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar tabela temporaria para envio de email                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaTRB

Local cQuery := ""

cQuery := ""
cQuery += " SELECT "
cQuery += " B8_PRODUTO, "
cQuery += " B8_LOCAL,   "
cQuery += " B8_LOTECTL, "
cQuery += " CAST(SB8.SALDOB8 AS DECIMAL(14,2)) SALDOB8, "
cQuery += " ISNULL(CAST(SBF.SALDOBF AS DECIMAL(14,2)),0) SALDOBF, "
cQuery += " CAST((SB8.SALDOB8 - ISNULL(SBF.SALDOBF,0)) AS DECIMAL(14,2)) DIF "
cQuery += " FROM (SELECT B8_PRODUTO, "
cQuery += " B8_LOCAL, "
cQuery += " B8_LOTECTL, "
cQuery += " B8_SALDO SALDOB8 "
cQuery += " 	FROM "+RetSqlName("SB8")+" SB8 WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND D_E_L_E_T_ = ' ') SB8 "
cQuery += "    LEFT OUTER JOIN "
cQuery += " 	( SELECT BF_PRODUTO, BF_LOCAL, BF_LOTECTL, CAST(SUM(BF_QUANT) AS DECIMAL(14,2)) SALDOBF "
cQuery += " 	FROM "+RetSqlName("SBF")+" SBF WHERE SBF.BF_FILIAL = '"+xFilial("SBF")+"' AND SBF.D_E_L_E_T_ = ' ' GROUP BY BF_PRODUTO, BF_LOCAL, BF_LOTECTL) SBF "
cQuery += " 	ON  SB8.B8_PRODUTO = SBF.BF_PRODUTO AND SB8.B8_LOCAL = SBF.BF_LOCAL "
cQuery += " 	AND SB8.B8_LOTECTL = SBF.BF_LOTECTL "
cQuery += " 	INNER JOIN "+RetSqlName("SB1")+" SB1 ON  SB8.B8_PRODUTO = SB1.B1_COD "
cQuery += " WHERE ABS(CAST((SB8.SALDOB8 - ISNULL(SBF.SALDOBF,0)) AS DECIMAL(14,2))) > 0 AND SB1.B1_LOCALIZ = 'S' AND SB1.B1_RASTRO <>'N' "
cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " ORDER BY 1,2,3 "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias "TRB"

Return