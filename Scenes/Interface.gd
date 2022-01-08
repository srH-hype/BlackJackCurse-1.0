extends CanvasLayer

var countBlackJack = 0

func _ready():
	$deckButton/Particles2D.emitting = true
	$shuffleAudio.play()
	GameManager.connect("drawSignal", self, "drawCard")
	GameManager.connect("discardSignal", self, "updateDiscardDeck")
	GameManager.connect("cardAudioSignal", self, "playCardAudioSignal")
	GameManager.connect("reShuffleSignal", self,"reShuffle")
	GameManager.connect("resetHandSignal", self, "startTimerHand")
	GameManager.connect("waitSignal", self,"wait")
	GameManager.connect("endWaitSignal", self, "endWait")
	GameManager.connect("endTurnSignal", self, "endTurnAnimation")
	GameManager.connect("blackJackSignal", self, "blackJack")
	GameManager.connect("lifeBarSignal", self, "updateLifeBar")
	drawCard()

func _on_deckButton_pressed():
	drawCard()

func _on_discardButton_pressed():
	$discardAudio.play()
	if ($discardHand.visible == false):
		$discardHand.visible = true
		
	else:
		$discardHand.visible = false

func _on_AnimationPlayer_animation_finished(draw):
	$hand.add_child(GameManager.newCard)
	updateHand()

func updateHand():
	updateLifeBar()
	updateDiscardDeck()

func updateLifeBar():
	$lifeBar.value = GameManager.life

func startTimerHand():
	$timerHand.start()

func wait():
	$deckButton.disabled = true

func endWait():
	$deckButton.disabled = false

func endTurn():
	endTurnAnimation()
	endWait()

func _on_timerHand_timeout():
	GameManager.resetHand()
	for n in $hand.get_children():
		$hand.remove_child(n)
		n.queue_free()
	drawCard()

func updateDiscardDeck():
	for n in range(GameManager.discardDeck.size()):
		if GameManager.discardDeck[n].get_parent() != $discardHand/discard:
			$discardHand/discard.add_child(GameManager.discardDeck[n])

func playCardAudioSignal():
	$playCardAudio.play()

func drawCard():
	$drawAudio.play()
	GameManager.drawCard()
	$AnimationPlayer.play("draw")
	wait()

func reShuffle():
	$deckButton/Particles2D.emitting = true
	$shuffleAudio.play()
	updateHand()
	updateDiscardDeck()
	for n in $discardHand/discard.get_children():
		$discardHand/discard.remove_child(n)
		n.queue_free()

func _on_endTurnButton_pressed():
	GameManager.endTurn()

func blackJack():
	$blackJack/timerBJ.set_one_shot(false)
	countBlackJack = 0
	startTimerHand()
	$blackJack.visible = true
	$blackJack/timerBJ.start()

func endTurnAnimation():
	$AnimationInterface.play("endTurn")

func _on_timerBJ_timeout():
	countBlackJack += 1
	if countBlackJack == 1:
		$blackJack/Label1.visible = true
	if countBlackJack == 2:
		$blackJack/Label2.visible = true
		$blackJack/timerBJ.set_one_shot(true)
	if countBlackJack == 3:
		$blackJack.visible = false
		$blackJack/Label1.visible = false
		$blackJack/Label2.visible = false
		$skullParticles.emitting = true
