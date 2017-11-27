#Include "Protheus.ch"
#Include "Tbiconn.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkB2B8   บAutor  ณSergio Celestino    บ Data ณ  31/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail de aviso de divergencias entre o Saldo Fisico บฑฑ
ฑฑบ          ณ e o Saldo por Lote                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                    

User Function ChkB2B8(aParam)

Private oHtml
Private oProcess
Private aRecno    := {}
Private cMailToA  := GetMV( "MV_MAIB2B8" ,,"suporte@intermed.com.br" )
Private cSubject  := ""
Private cPath	  := GetMV( "MV_PATEST", ,"workflow\html\temp\est\" )
Private dDataAvi  := ctod("  /  /  ")
Private cReport   := ""
Private cArquivo  := ""
Private cTipo     := ""
Private nReg      := 0

Private cLocal    := "\workflow\html\"
Private cRecurso  := ""

cArquivo  := "avisob2b8.htm"
cTipo     :=  "[INTERMED] Saldo Fisico x Saldo Lote - [ SB2 x SB8 ]"

dDataAvi  := GetMV( "MV_DTB2B8" ,,dDataBase-1)
If dDataAvi < dDataBase 
   MsgRun( "Aguarde!!!", "Verificando SB2 x SB8...", { ||  VerB2B8() } ) 
Endif   

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerB2B8   บAutor  ณSergio Celestino    บ Data ณ  31/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Analise das Tabelas de Saldo em Estoque                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerB2B8

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

MontaTRB()

DbSelectArea("TRB")
DbGotop()
While !Eof()
	
   AAdd( (oHtml:ValByName( "t.1"    )),  TRB->B2_COD  )     
   AAdd( (oHtml:ValByName( "t.2"    )),  TRB->B2_LOCAL   )     
   AAdd( (oHtml:ValByName( "t.3"    )),  TRANSFORM(TRB->SALDOB8,"@E 999,999,999.99")    ) 
   AAdd( (oHtml:ValByName( "t.4"    )),  TRANSFORM(TRB->SALDOBF,"@E 999,999,999.99")    )    	    
   AAdd( (oHtml:ValByName( "t.5"    )),  TRANSFORM(TRB->DIF    ,"@E 999,999,999.99")    )    	    
   AAdd( (oHtml:ValByName( "t.6"    )),  xFilial("SB2")                                 )    	    

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

PutMv("MV_DTB2B8",dDataBase)

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
cQuery += " B2_COD, "
cQuery += " B2_LOCAL, "
cQuery += " B1_RASTRO, "
cQuery += " CAST(SB2.SALDOB2 AS DECIMAL(14,2)) SALDOB2, "
cQuery += " ISNULL(CAST(SB8.SALDOB8 AS DECIMAL(14,2)),0) SALDOB8, "
cQuery += " ABS(CAST((SB2.SALDOB2 - ISNULL(SB8.SALDOB8,0)) AS DECIMAL(14,2))) DIF "
cQuery += " FROM (SELECT B2_COD, B2_LOCAL, B2_QATU SALDOB2 "
cQuery += " 	FROM "+RetSqlName("SB2")+" SB2 WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND D_E_L_E_T_ = ' ') SB2 LEFT JOIN "
cQuery += " 	( SELECT B8_PRODUTO, B8_LOCAL, CAST(SUM(B8_SALDO) AS DECIMAL(14,2)) SALDOB8 "
cQuery += " 	FROM "+RetSqlName("SB8")+" SB8 WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND D_E_L_E_T_ = ' ' GROUP BY B8_PRODUTO, B8_LOCAL) SB8 "
cQuery += " 	ON SB2.B2_COD = SB8.B8_PRODUTO AND B2_LOCAL = B8_LOCAL INNER JOIN "+RetSqlName("SB1")+" SB1 ON B2_COD = B1_COD "
cQuery += " WHERE ABS(CAST((SB2.SALDOB2 - ISNULL(SB8.SALDOB8,0)) AS DECIMAL(14,2))) > 0 AND B1_RASTRO <> 'N' AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " ORDER BY 2,1 "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias "TRB"

Return