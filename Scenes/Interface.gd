extends CanvasLayer



func _ready():
	GameManager.connect("drawSignal", self, "drawCard")
	GameManager.connect("discardSignal", self, "updateDiscardDeck")
	GameManager.connect("cardAudioSignal", self, "playCardAudioSignal")
	GameManager.connect("reShuffleSignal", self,"reShuffle")

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
	$lifeBar.value = GameManager.life
	if GameManager.resetingHand:
		$timerHand.start()
		GameManager.resetingHand = false
	updateDiscardDeck()

func wait():
	$deckButton.disabled = true

func endWait():
	$deckButton.disabled = false

func _on_timerHand_timeout():
	GameManager.resetHand()
	for n in $hand.get_children():
		$hand.remove_child(n)
		n.queue_free()

func updateDiscardDeck():
	for n in range(GameManager.discardDeck.size()):
		if GameManager.discardDeck[n].get_parent() != $discardHand/discard:
			$discardHand/discard.add_child(GameManager.discardDeck[n])

func _on_timerAction_timeout():
	endWait()

func playCardAudioSignal():
	$playCardAudio.play()

func drawCard():
	$drawAudio.play()
	GameManager.drawCard()
	$AnimationPlayer.play("draw")
	wait()
	$timerAction.start()

func reShuffle():
	$deckButton/Particles2D.emitting = true
	$shuffleAudio.play()
	updateHand()
	updateDiscardDeck()
	for n in $discardHand/discard.get_children():
		$discardHand/discard.remove_child(n)
		n.queue_free()
