#Include "Protheus.ch"
#Include "Tbiconn.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkExec  cบAutor  ณSergio Celestino    บ Data ณ  22/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail de aviso de vencimento de Or็amentos          บฑฑ
ฑฑบ          ณ Ponto de Entrada Executado apos acionar qualquer rotina    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                    

User Function ChkExec(nOpc)
Local cAcesso   := GetMv("MV_PERMFIL")

Private oHtml
Private oProcess
Private aRecno    := {}
Private dEmissao  := GetMv( "MV_DTEMISO",, CtoD("01/07/10") )
Private cMailToA   := GetMV( "MV_MAIORC1" ,,"suporte@intermed.com.br" )
Private cMailToB   := GetMV( "MV_MAIORC2" ,,"suporte@intermed.com.br" )
Private cSubject  := ""
Private cPath	  := GetMV( "MV_PATORC", ,"workflow\html\temp\orc\" )
Private dDataAvi  := ctod("  /  /  ")
Private cReport   := ""
Private cArquivo  := ""
Private cTipo     := ""
Private nReg      := 0

Private cLocal    := "\workflow\html\"
Private cRecurso  := ""

If cEmpAnt <> "02"
   Return
Endif                            

//If Alltrim(cModulo) == "QDO"
//  MsgInfo("O Modulo Controle de Documentos esta bloqueado para utiliza็ใo.")
//  Return .F.
//  FINAL()
//Endif  


cArquivo  := "avisoorc.htm"
cTipo     :=  "[INTERMED] Or็amentos Vencidos"

If Alltrim(cModulo) == "FAT"
   dDataAvi  := GetMV( "MV_DTAVOR" ,,dDataBase-1)
   If dDataAvi < dDataBase 
      MsgRun( "Aguarde!!!", "Verificando Proprostas Vencidas...", { ||  OrcVenc() } ) 
   Endif   
Endif  

If Alltrim(cModulo) == "QDO" //.Or. FunName() == "QDOA050"
   dDataAvi  := GetMV( "MV_DTAVOR" ,,dDataBase-1)
   If dDataAvi < dDataBase 
      MsgRun( "Aguarde!!!", "Verificando Documentos Vencidos...", { ||  DocVenc() } ) 
   Endif   		
Endif
	
	
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVISOORC  บAutor  ณMicrosiga           บ Data ณ  07/16/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออ?ออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OrcVenc(nOpc)

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

MontaTRB()

DbSelectArea("TRB")
DbGotop()
While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//Crio o objeto oProcess, que recebe a inicializa็ใo da classe TWFProcess //
	//Repare que o primeiro Parโmetro ้ o c๓digo do processo que cadastramos  //
	//acima e o segundo uma descri็ใo qualquer.                               //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cTipo     :=  "[INTERMED] Or็amento Vencido Numero: "+TRB->CJ_NUM
	oProcess:= TWFProcess():New("ORCVENC", cTipo)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//Crio uma task. Um Processo pode ter vแrias Tasks(tarefas). Para cada    //
	//Task informo um nome para ela e o HTML envolvido. Repare que o path do  //
	//HTML ้ sempre abaixo do RootPath do Protheus.                           //
	oProcess:NewTask("ORCVENC", cLocal+cArquivo)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//Informo o tํtulo do e-mail.                                       //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oProcess:cSubject := cTipo
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//Informo quais e-mail estarao recebendo a mensagem                      //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	IF TRB->CJ_EMIT == "DVEN"
	   cEmailToA :=  GetMV( "MV_MAIORC1" ,,"suporte@intermed.com.br" )
	   oProcess:cTo := cMailToA
	Else
	   cEmailToB :=  GetMV( "MV_MAIORC2" ,,"suporte@intermed.com.br" )   
	   oProcess:cTo := cMailToB
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//Modelo de ativa็ใo                                                      //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oProcess:NewVersion(.T.)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//Informo o c๓digo do usuแrio no Protheus que receberแ o e-mail. Isto ้   //
	//๚til para usar a consulta de Processos por usuแrio.                     //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oProcess:UserSiga := '000000'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//Simplesmente passo o valor da propriedade oProcess:oHTML  para uma      //
	//variแvel local para facilitar                                           //
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oHtml := oProcess:oHTML
	
	oHtml:ValByName( "CJ_FILIAL"     , TRB->CJ_FILIAL  )    
	oHtml:ValByName( "CJ_NUM"         , TRB->CJ_NUM  )    
	oHtml:ValByName( "CJ_EMISSAO"     , STOD(TRB->CJ_EMISSAO)  )    
	oHtml:ValByName( "CJ_VEND1"       , TRB->CJ_VEND1  )    
	oHtml:ValByName( "CJ_SOLCLI"     , STOD(TRB->CJ_SOLCLI)  )    
	oHtml:ValByName( "CJ_TIPORC"     , TRB->CJ_TIPORC  )    
	oHtml:ValByName( "CJ_SOLICIT"     , IIF(TRB->CJ_SOLICIT=="E","Escrita","Verbal")  )
	oHtml:ValByName( "CJ_LICIT"     , IIF(TRB->CJ_LICIT=="S","SIM","NAO")  )
	oHtml:ValByName( "CJ_IDINTER"     , TRB->CJ_IDINTER  )
	oHtml:ValByName( "CJ_CLIENTE"     , TRB->CJ_CLIENTE  )
	oHtml:ValByName( "CJ_NOMCLI"     , Posicione("SA1",1,xFilial("SA1") + TRB->CJ_CLIENTE  + TRB->CJ_LOJA ,"A1_NREDUZ")  )
	oHtml:ValByName( "CJ_ORCANT"     , IIF(TRB->CJ_ORCANT=="S","SIM","NAO")  )
	oHtml:ValByName( "CJ_CONDPAG"     , TRB->CJ_CONDPAG  )
	oHtml:ValByName( "E4_DESCRI"     , Posicione("SE4",1,xFilial("SE4") + TRB->CJ_CONDPAG,"E4_DESCRI")  )
	oHtml:ValByName( "CJ_VALIDI"     , STOD(TRB->CJ_VALIDI)  )
	oHtml:ValByName( "CJ_EMIT"     , TRB->CJ_EMIT  )
	oHtml:ValByName( "ZA1_PROJET"  , dDataBase    )    //Data
	
//LISTA OS ITENS
Vtotalger:=0

	DbSelectArea("SCK")
	DbSetOrder(1)
	DbGotop()
	DbSeek(xFilial("SCK") + TRB->CJ_NUM )
	
	While !Eof() .And. TRB->CJ_NUM == SCK->CK_NUM
	
   	    AAdd( (oHtml:ValByName( "t2.1"    )),  SCK->CK_ITEM  )     
	    AAdd( (oHtml:ValByName( "t2.2"    )),  SCK->CK_PRODUTO   )     
   	    AAdd( (oHtml:ValByName( "t2.3"    )),  SCK->CK_DESCRI   ) 
   	    AAdd( (oHtml:ValByName( "t2.4"    )),  SCK->CK_QTDVEN   )    	    
   	    AAdd( (oHtml:ValByName( "t2.5"    )),  TRANSFORM(SCK->CK_PRCVEN,"@E 999,999,999.99")   )    	    
   	    AAdd( (oHtml:ValByName( "t2.6"    )),  TRANSFORM(SCK->CK_VALOR,"@E 999,999,999.99")   )    	    
   	    AAdd( (oHtml:ValByName( "t2.7"    )),  TRANSFORM(SCK->CK_VALDESC,"@E 999,999,999.99")   )   	       	    

	    Vtotalger+=SCK->CK_VALOR	    
	    DbSelectArea("SCK")  
	      DbSkip()
	End            
		oHtml:ValByName( "TOTALGER"  , TRANSFORM(Vtotalger,"@E 999,999,999.99")    )    //TOTAL                                                               
   	       	    

	
	cReport   := DtoS(dDataBase)+"_"+cArquivo+"_"+TRB->CJ_NUM
	oHTML:SaveFile(cPath+cReport)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envia para os destinatarios.         			      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oProcess:AttachFile(cPath+cReport)
	oProcess:nEncodeMime := 0
	oProcess:Start()
	oProcess:Finish()

    DbSelectArea("SCJ")
    dbGoTo(TRB->SCJRECNO)
     Reclock("SCJ",.F.)
	 SCJ->CJ_STATUS := "C"
	 SCJ->CJ_MARCA  := "EXPIROU VALIDADE"
	 MsUnlock()
	
	DbSelectArea("TRB")
	DbSkip()
End

PutMv("MV_DTAVOR",dDataBase)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaTRB  บAutor  ณSergio Celestino    บ Data ณ  22/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar tabela temporaria para envio de email                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaTRB(nOpc)

Local cQuery := ""

cQuery := " SELECT SCJ.R_E_C_N_O_ AS SCJRECNO,SCJ.CJ_FILIAL,SCJ.CJ_NUM,SCJ.CJ_EMISSAO,SCJ.CJ_VEND1,SCJ.CJ_SOLCLI,SCJ.CJ_TIPORC,SCJ.CJ_SOLICIT,SCJ.CJ_LICIT,SCJ.CJ_IDINTER,SCJ.CJ_LOJA,SCJ.CJ_CLIENTE,SCJ.CJ_ORCANT,SCJ.CJ_CONDPAG,SCJ.CJ_VALIDI,SCJ.CJ_EMIT "
cQuery += " FROM "+RetSqlName("SCJ")+" SCJ "
cQuery += " WHERE "
cQuery += " SCJ.CJ_FILIAL='"+xFilial("SCJ")+"' AND SCJ.CJ_VALIDI <= '"+DtoS(dDataBase)+"' AND SCJ.D_E_L_E_T_ = ' ' AND SCJ.CJ_EMIT IN ('DVEN','DATE') "
cQuery += " AND SCJ.CJ_STATUS NOT IN ('B','C') AND SCJ.CJ_EMISSAO >= '"+DtoS(dEmissao)+"' "
cQuery += " ORDER BY CJ_NUM,CJ_EMIT "


cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "TRB"

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDocVenc  บAutor  ณRenato Rocha    บ Data ณ  06/10/17        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Disparo aviso documento vencido QDO                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DocVenc()  

Local nErro			:= 0
local lEnviado 		:= .t.
local cEmailTo		:= GETMV("MV_MAILQDO")
local cAssunto		:= "Rela็ใo de documentos vencidos"
local cMensagem		:= "  "
local cAttach		:= Nil
local cChave		:= Nil
LOCAL cAviso    	:= "FAVOR VERIFICAR OS DOCUMENTOS VENCIDOS ABAIXO:"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤผ5เฟ
//ณAutenticacao WFณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤผ5เู
Local lMailAuth     := GetMV('MV_RELAUTH')									//Verifica se Necessita de Autenticacao
Local _cChave		:= ""				//#ECV20130516.


If Select("TRB2") > 0
	DbSelectArea("TRB2")
	DbCloseArea()
Endif

MontaTRB2()

DbSelectArea("TRB2")
DbGotop()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta mensagem a ser enviada.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cMensagem:='<html><title>.:: '+ cAssunto +' ::.</title> '
cMensagem+='<body>                                      '
cMensagem+='<h3><center>'+ cAssunto +'</center></h3><br>'
cMensagem+='<i>'+cAviso+'</i><br><br>'
While !Eof()                          
cMensagem+='<b>Documento: </b><i>'+TRB2->QDH_DOCTO+'</i> -  '
cMensagem+='<b>Revisใo: </b><i>'+TRB2->QDH_RV+'</i><br>'
cMensagem+='<b>Nome do Documento: </b><i>'+TRB2->QDH_TITULO+'</i><br><br>' 
TRB2->(DbSkip())
End Do   
cMensagem+='Atenciosamente,<br><p><p>                   '
cMensagem+='Intermed Equipamento M้dico Hospitalar      '
cMensagem+='</body>                                     '
cMensagem+='</html>                                     '

  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConexao com o servidor!ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

CONNECT SMTP SERVER ALLTRIM(GETMV('MV_RELSERV')) ;
ACCOUNT     ALLTRIM(GETMV('MV_RELACNT')) ;
PASSWORD    ALLTRIM(GETMV('MV_RELAPSW')) ;
RESULT _lOK

If ( _lOk )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEnvio da mensagemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lMailAuth
		MailAuth(ALLTRIM(GETMV('MV_RELACNT')),ALLTRIM(GETMV('MV_RELAPSW')))
	endif
	
	SEND MAIL FROM GETMV("MV_RELACNT") ;
	TO cEmailTo ;
	SUBJECT cAssunto ; 
	BODY cMensagem ;
	RESULT _lOk
	
	If ( ! _lOk )
		GET MAIL ERROR _cErro
		MsgAlert( _cErro, 'Erro durante o envio' ) //'Erro durante o envio'
	EndIf
	
	DISCONNECT SMTP SERVER RESULT _lOK
	
	LjMsgRun("Executando verifica็ใo de documentos vencidos...",,,) //"E-mail Enviado Com Sucesso"
	
	If ( ! _lOk )
		GET MAIL ERROR _cErro
		MsgAlert( _cErro, 'Erro durante a desconexao' )
	EndIf	
ENDIF


RETURN NIL                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaTRB2  บAutor  ณRenato Rocha       บ Data ณ  06/10/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar tabela temporaria para envio de email QDO            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Intermed                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaTRB2()

Local cQuery := ""
local cTipoDoc		:= ALLTRIM(GETMV("MV_TPDOC"))

cQuery := " SELECT QDH_DOCTO, QDH_RV, QDH_TITULO "
cQuery += " FROM "+RetSqlName("QDH")+" QDH "
cQuery += " WHERE "
cQuery += " QDH_CODTP IN ("+cTipoDoc+") "
cQuery += " AND QDH_DTLIM <= '"+DtoS(dDataBase)+"' AND QDH_DTLIM <> ' ' AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY QDH_DEPTOD "


cQuery := ChangeQuery(cQuery)
TcQuery cQuery New Alias "TRB2"

Return   

