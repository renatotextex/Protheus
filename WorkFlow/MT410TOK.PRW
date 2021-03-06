# Include "Protheus.ch"    
# Include "AP5MAIL.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Empresa  � Agility Solutions                                          ���
���          � Rua Cancioneiro de Evora, 553 - Sao Paulo - SP             ���
���          � Fone: (11) 2935-6911                                       ���
���          � Site: www.agilitysolutions.com.br                          ���
���          � e-mail: agility@agilitysolutions.com.br                    ���
�������������������������������������������������������������������������Ĵ��
��� Funcao   � MT410TOK  � Autor � Welinton Martins     � Data � 02/08/10 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada na confirmacao do pedidio de venda.       ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Revisao 01� MT410TOK  � Autor � Welinton Martins     � Data � 03/08/10 ���
�������������������������������������������������������������������������Ĵ��
���Alteracoes� Removido lRet .F. no primeiro aviso porque a Assistencia   ���
���          � tecnica utiliza a data de entrega em branco, adicionado    ���
���          � pergunta para que usuario informe se deseja gravar o pedido���
���          � mesmo com a data divergente.                               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MT410TOK()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Intermed Equipamento Medico e Hospitalar Ltda.             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function MT410TOK()

Local lRet 		:= .T.
Local nPos 		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPosIt 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local nX		:= 0
Local cItens	:= ""
Local _nOpc		:= ParamIxb[1]

//��������������������������������������������������������������������������������������������������������������������������Ŀ
//�Validacao da data de programacao menor que emissao do pedido, caso for, este deve retornar falso e nao permitir a gravacao�
//����������������������������������������������������������������������������������������������������������������������������
If M->C5_ENTREGA < M->C5_EMISSAO
	MsgAlert("Data de Entrega informada no cabe�alho do pedido est� em BRANCO ou MENOR que a Emiss�o.","Aten��o !!!")
EndIf

If Alltrim(Upper(FunName(0))) == "MATA410" 
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
	IF SA1->A1_EST == "EX" 
	   If Empty(M->C5_CODLOC) .Or. Empty(M->C5_UFEMB)
	      MsgInfo("Favor Informar C�digo e UF de Embarque no cabe�alho do Pedido!")
	      Return .F.
	   Endif
	Endif      
Endif
//����������������������������������������������������������������������������������������������������������������������Ŀ
//�Validacao da data de programacao do pedido com a data de programacao dos itens desse pedido, caso forem diferentes,   �
//�deve retornar falso e nao gravar. 																					 �
//������������������������������������������������������������������������������������������������������������������������
If nPos > 0
	For nX := 1 to Len(aCols)
		If aCols[nX][nPos] < M->C5_ENTREGA
			lRet		:=	.F.
			cItens	+=  AllTrim(aCols[nX][nPosIt]) + " "
		EndIf
	Next nX
	
	If !lRet
		Aviso("Aten��o !!!","Data de Entrega dos item(s) ( " + cItens + ") encontra-se diferente(s) da data de entrega do pedido.",{"Ok"},3,"Acertar a data de Entrega dos Item(s)")
	EndIf
	
	If !lRet
		If MsgYesNo("Deseja gravar o pedido com as datas de entrega divergentes ?","Aten��o !!!")
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
		If APMsgNoYes("Existem itens sem c�lculo de IPI. Deseja continuar sem o c�lculo?","Valida��o do Pedido")
			lRet := .T.
		Else 
			lRet := U_AFAT002()
		EndIf
	EndIf
EndIf

//������������������������������������������������������������������������Ŀ
//� Verifica Cliente final (LEMBRETE WF)������
�
//��������������������������������������������������������������������������
�����
If _nOpc == 3 //3 = inclus�o
    
	
	If M->C5_TIPOCLI != "R" .AND. M->C5_EMIT == "DVEN"
����������
�����    VerifClient()
		 MsgAlert("Pedido de Venda para clientes Finais. Lembrete enviado por e-mail.")
	Else
          
		 //MsgAlert("E-mail N�o enviado.")
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
local cAssunto		:= "LEMBRETE (ACORDO DE REMUNERA��O)"
local cMensagem		:= "  "
local cAttach		:= Nil
local cChave		:= Nil
LOCAL cAviso    	:= "FAVOR CONFECCIONAR O ACORDO DE REMUNERA��O REFERENTE A ESTE PEDIDO."
//�������������������������������������5�
//�Autenticacao WF�
//�������������������������������������5��
Local lMailAuth     := GetMV('MV_RELAUTH')									//Verifica se Necessita de Autenticacao
Local _nOpc			:= ParamIxb	   		//
Local _cNum			:= M->C5_NUM 		//N�mero do Pedido
Local _cData		:= M->C5_EMISSAO	//Data de Emiss�o
Local _cCliente		:= M->C5_CLIENTE	//C�digo do Cliente
Local _NomeClien	:= M->C5_CNOME	//Nome do Cliente
Local _cTipo		:= M->C5_TIPOCLI	//#Tipo Cliente 
Local _cChave		:= ""				//#ECV20130516.
Local _cVend		:= ""               //Nome Vendedor
Local _cCodVend	    := M->C5_VEND1    //C�d. Vendedor
 
_cVend := POSICIONE("SA3", 1, xFilial("SA3")+M->C5_VEND1, "A3_NOME")


//�����������������������������Ŀ
//�Monta mensagem a ser enviada.�
//�������������������������������

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
cMensagem+='Intermed Equipamento M�dico Hospitalar      '
cMensagem+='</body>                                     '
cMensagem+='</html>                                     '
  
//�����������������������Ŀ
//�Conexao com o servidor!�
//�������������������������


CONNECT SMTP SERVER ALLTRIM(GETMV('MV_RELSERV')) ;
ACCOUNT     ALLTRIM(GETMV('MV_RELACNT')) ;
PASSWORD    ALLTRIM(GETMV('MV_RELAPSW')) ;
RESULT _lOK

If ( _lOk )

	//�����������������Ŀ
	//�Envio da mensagem�
	//�������������������
	
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


