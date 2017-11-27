# Include "Protheus.ch"    
# Include "AP5MAIL.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ Agility Solutions                                          ³±±
±±³          ³ Rua Cancioneiro de Evora, 553 - Sao Paulo - SP             ³±±
±±³          ³ Fone: (11) 2935-6911                                       ³±±
±±³          ³ Site: www.agilitysolutions.com.br                          ³±±
±±³          ³ e-mail: agility@agilitysolutions.com.br                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³ MT410TOK  ³ Autor ³ Welinton Martins     ³ Data ³ 02/08/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada na confirmacao do pedidio de venda.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³Revisao 01³ MT410TOK  ³ Autor ³ Welinton Martins     ³ Data ³ 03/08/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracoes³ Removido lRet .F. no primeiro aviso porque a Assistencia   ³±±
±±³          ³ tecnica utiliza a data de entrega em branco, adicionado    ³±±
±±³          ³ pergunta para que usuario informe se deseja gravar o pedido³±±
±±³          ³ mesmo com a data divergente.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MT410TOK()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Intermed Equipamento Medico e Hospitalar Ltda.             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT410TOK()

Local lRet 		:= .T.
Local nPos 		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPosIt 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nX		:= 0
Local cItens	:= ""
Local _nOpc		:= ParamIxb[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacao da data de programacao menor que emissao do pedido, caso for, este deve retornar falso e nao permitir a gravacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If M->C5_ENTREGA < M->C5_EMISSAO
	MsgAlert("Data de Entrega informada no cabeçalho do pedido está em BRANCO ou MENOR que a Emissão.","Atenção !!!")
EndIf

If Alltrim(Upper(FunName(0))) == "MATA410" 
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
	IF SA1->A1_EST == "EX" 
	   If Empty(M->C5_CODLOC) .Or. Empty(M->C5_UFEMB)
	      MsgInfo("Favor Informar Código e UF de Embarque no cabeçalho do Pedido!")
	      Return .F.
	   Endif
	Endif      
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacao da data de programacao do pedido com a data de programacao dos itens desse pedido, caso forem diferentes,   ³
//³deve retornar falso e nao gravar. 																					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPos > 0
	For nX := 1 to Len(aCols)
		If aCols[nX][nPos] < M->C5_ENTREGA
			lRet		:=	.F.
			cItens	+=  AllTrim(aCols[nX][nPosIt]) + " "
		EndIf
	Next nX
	
	If !lRet
		Aviso("Atenção !!!","Data de Entrega dos item(s) ( " + cItens + ") encontra-se diferente(s) da data de entrega do pedido.",{"Ok"},3,"Acertar a data de Entrega dos Item(s)")
	EndIf
	
	If !lRet
		If MsgYesNo("Deseja gravar o pedido com as datas de entrega divergentes ?","Atenção !!!")
			lRet := .T.
		Else
			Return(.F.)
		EndIf
	EndIf
	
	For nX := 1 to Len(aCols)
		
/*
		If GDFIELDPOS("C6_REC_WT") > 0 .AND. GDFIELDGET("C6_REC_WT",NX) > 0
			SC6->(dbGoTo(GDFIELDGET("C6_REC_WT",NX)))
		*/
		SC6->(dbSetOrder(1))
		If GDDeleted(nX) .OR. SC6->(dbSeek(xFilial("SC6")+M->C5_NUM+GDFIELDGET("C6_ITEM",NX)+GDFIELDGET("C6_PRODUTO",NX))) .AND. ;
			SC6->C6_QTDVEN <= IIf(!SubStr(SC6->C6_BLQ,1,1)$"RS" .And. Empty(SC6->C6_BLOQUEI),SC6->C6_QTDENT,SC6->C6_QTDVEN)
			Loop
		EndIf
		//EndIf
		
		If SC6->(FieldPos("C6_VALUN"))>0 .AND. GDFIELDGET("C6_VALOR",nX) <> GDFIELDGET("C6_VALUN",nX) .OR. Empty(GDFIELDGET("C6_VALUN",nX))
			lRet := .F.
		EndIf
	Next nX
	
	If !lRet
		If APMsgNoYes("Existem itens sem cálculo de IPI. Deseja continuar sem o cálculo?","Validação do Pedido")
			lRet := .T.
		Else 
			lRet := U_AFAT002()
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Cliente final (LEMBRETE WF)      
³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
If _nOpc == 3 //3 = inclusão
    
	
	If M->C5_TIPOCLI != "R" .AND. M->C5_EMIT == "DVEN"
          
         VerifClient()
		 MsgAlert("Pedido de Venda para clientes Finais. Lembrete enviado por e-mail.")
	Else
          
		 //MsgAlert("E-mail Não enviado.")
         lRet := .T.
	End
	Endif
 
RETURN lRet
//

Return(lRet)

Static Function VerifClient


Local nErro			:= 0
local lEnviado 		:= .t.
local cEmailTo		:= GETMV("MV_MAILFAT")
local cAssunto		:= "LEMBRETE (ACORDO DE REMUNERAÇÃO)"
local cMensagem		:= "  "
local cAttach		:= Nil
local cChave		:= Nil
LOCAL cAviso    	:= "FAVOR CONFECCIONAR O ACORDO DE REMUNERAÇÃO REFERENTE A ESTE PEDIDO."
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼5à¿
//³Autenticacao WF³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼5àÙ
Local lMailAuth     := GetMV('MV_RELAUTH')									//Verifica se Necessita de Autenticacao
Local _nOpc			:= ParamIxb	   		//
Local _cNum			:= M->C5_NUM 		//Número do Pedido
Local _cData		:= M->C5_EMISSAO	//Data de Emissão
Local _cCliente		:= M->C5_CLIENTE	//Código do Cliente
Local _NomeClien	:= M->C5_CNOME	//Nome do Cliente
Local _cTipo		:= M->C5_TIPOCLI	//#Tipo Cliente 
Local _cChave		:= ""				//#ECV20130516.
Local _cVend		:= ""               //Nome Vendedor
Local _cCodVend	    := M->C5_VEND1    //Cód. Vendedor
 
_cVend := POSICIONE("SA3", 1, xFilial("SA3")+M->C5_VEND1, "A3_NOME")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta mensagem a ser enviada.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMensagem:='<html><title>.:: '+ cAssunto +' ::.</title> '
cMensagem+='<body>                                      '
cMensagem+='<h3><center>'+ cAssunto +'</center></h3><br>'
//cMensagem+='<b>Responsavel : </b><i>'+ SUBSTR(cUserName,1,6) +'</i><br>'
cMensagem+='<i>'+cAviso+'</i><br><br>                   '       
cMensagem+='<b>Pedido: </b><i>'+_cNum+'</i><br><br>     '
cMensagem+='<b>Data: </b><i>'+dtoc(_cData)+'</i><br><br>'
cMensagem+='<b>Cliente: </b><i>'+_cCliente+' - <b><i>'+_NomeClien+'</b></i></i><br><br>'
cMensagem+='<b>Vendedor: </b><i>'+_cCodVend+' - <b><i>'+_cVend+'</b></i></i><br><br>'
cMensagem+='Atenciosamente,<br><p><p>                   '
cMensagem+='Intermed Equipamento Médico Hospitalar      '
cMensagem+='</body>                                     '
cMensagem+='</html>                                     '
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Conexao com o servidor!³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


CONNECT SMTP SERVER ALLTRIM(GETMV('MV_RELSERV')) ;
ACCOUNT     ALLTRIM(GETMV('MV_RELACNT')) ;
PASSWORD    ALLTRIM(GETMV('MV_RELAPSW')) ;
RESULT _lOK

If ( _lOk )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envio da mensagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
	
	LjMsgRun("E-mail Enviado Com Sucesso",,,) //"E-mail Enviado Com Sucesso"
	
	If ( ! _lOk )
		GET MAIL ERROR _cErro
		MsgAlert( _cErro, 'Erro durante a desconexao' )
	EndIf	
ENDIF


RETURN NIL


