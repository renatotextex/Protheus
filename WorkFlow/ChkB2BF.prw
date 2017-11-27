#Include "Protheus.ch"
#Include "Tbiconn.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ChkB2BF   �Autor  �Sergio Celestino    � Data �  31/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia e-mail de aviso de divergencias entre o Saldo Fisico ���
���          � e o Saldo por Endereco                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Intermed                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                    

User Function ChkB2BF(aParam)

Private oHtml
Private oProcess
Private aRecno    := {}
Private cMailToA  := GetMV( "MV_MAIB2BF" ,,"suporte@intermed.com.br" )
Private cSubject  := ""
Private cPath	  := GetMV( "MV_PATEST", ,"workflow\html\temp\est\" )
Private dDataAvi  := ctod("  /  /  ")
Private cReport   := ""
Private cArquivo  := ""
Private cTipo     := ""
Private nReg      := 0

Private cLocal    := "\workflow\html\"
Private cRecurso  := ""

cArquivo  := "avisob2bf.htm"
cTipo     :=  "[INTERMED] Saldo Fisico x Saldo Endere�o - [ SB2 x SBF ]"

dDataAvi  := GetMV( "MV_DTB2BF" ,,dDataBase-1)
If dDataAvi < dDataBase 
   MsgRun( "Aguarde!!!", "Verificando SB2 x SBF...", { ||  VerB2BF() } ) 
Endif   

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerB2BF   �Autor  �Sergio Celestino    � Data �  31/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Analise das Tabelas de Saldo em Estoque                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Intermed                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerB2BF

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

//�������������������������������������������������������Ŀ
//� Envia para os destinatarios.         			      �
//���������������������������������������������������������
oProcess:AttachFile(cPath+cReport)
oProcess:nEncodeMime := 0
oProcess:Start()
oProcess:Finish()

PutMv("MV_DTB2BF",dDataBase)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaTRB  �Autor  �Sergio Celestino    � Data �  31/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gerar tabela temporaria para envio de email                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Intermed                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaTRB

Local cQuery := ""

cQuery := ""
cQuery += " SELECT  "
cQuery += " B2_COD, "
cQuery += " B2_LOCAL, "
cQuery += " B1_RASTRO,"
cQuery += " CAST(SB2.SALDOB2 AS DECIMAL(14,2)) SALDOB2, "
cQuery += " ISNULL(CAST(SBF.SALDOBF AS DECIMAL(14,2)),0) SALDOBF, "
cQuery += " ABS(CAST((SB2.SALDOB2 - ISNULL(SBF.SALDOBF,0)) AS DECIMAL(14,2))) DIF "
cQuery += " FROM (SELECT B2_COD, B2_LOCAL, B2_QATU SALDOB2 "
cQuery += " 	FROM "+RetSqlName("SB2")+" SB2 WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND D_E_L_E_T_ = ' ') SB2 LEFT JOIN "
cQuery += " 	( SELECT BF_PRODUTO, BF_LOCAL, CAST(SUM(BF_QUANT) AS DECIMAL(14,2)) SALDOBF "
cQuery += " 	FROM "+RetSqlName("SBF")+" WHERE BF_FILIAL = '"+xFilial("SBF")+"' AND D_E_L_E_T_ = ' ' GROUP BY BF_PRODUTO, BF_LOCAL) SBF "
cQuery += " 	ON SB2.B2_COD = SBF.BF_PRODUTO AND SB2.B2_LOCAL = SBF.BF_LOCAL INNER JOIN "+RetSqlName("SB1")+" ON B2_COD = B1_COD "
cQuery += " WHERE ABS(CAST((SB2.SALDOB2 - ISNULL(SBF.SALDOBF,0)) AS DECIMAL(14,2))) > 0 AND B1_RASTRO <> 'N' AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " AND B1_LOCALIZ = 'S' "
cQuery += " ORDER BY 2,1 "

cQuery := ChangeQuery(cQuery)

TcQuery cQuery New Alias "TRB"

Return