#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


User Function CpvCadX6()

Local aArea     := GetArea()
Local nOpcao    := 0
Local aBotoes   := {}
Local cMensag   := ""
Local _dDataPar := CTOD("") 
Local _cUserPerm := GETMV("XX_PEREST")

  
if !Alltrim(Upper(substr(cUserName,1,6))) $ Alltrim(Upper(_cUserPerm))
	ALERT('Usuario sem Permissao')
	Return .T.
endif



DbSelectArea("SX6") //Abre a tabela SX6
DbSetOrder(1) //Se posiciona no primeiro indice
If DbSeek("04"+"MV_ULMES") 
	IF eof()
		ALERT('Parametro não encontrado')
		Return()		
	Else				
		//Adiciona os botões
			aAdd(aBotoes, "Retroceder")   //Opção 1
			aAdd(aBotoes, "Avançar") 	  //Opção 2
			aAdd(aBotoes, "Cancelar")     //Opção 3			
		//Mostra o aviso e pega o botão
			cMensag := "Data Atual " +SX6->X6_CONTEUD+" " + CRLF
			cMensag += "Deseja alterar?"
			nOpcao := Aviso("Atenção", cMensag, aBotoes, 2)				
			If nOpcao != 3				
				If nOpcao == 1	
					
				_dDataPar := SX6->X6_CONTEUD
				_dRetRetro := CTOD(_dDataPar)
				_dRetRetro := FirstDate(_dRetRetro) - 1 
				
				RecLock("SX6",.F.) //Abre o registro para edição
					SX6->X6_CONTEUD := DTOC(_dRetRetro)
				MsUnLock() //salva o registro					
				
				ElseIf nOpcao == 2					
					
					_dDataPar := SX6->X6_CONTEUD
					_dDataPar := CTOD(_dDataPar)+1
					_dRetAvan  := LastDate(_dDataPar)

					RecLock("SX6",.F.) //Abre o registro para edição
					SX6->X6_CONTEUD := DTOC(_dRetAvan)
					MsUnLock() //salva o registro					
				EndIf
			EndIf	
		EndIf
	EndIf
RestArea(aArea)
Return()
