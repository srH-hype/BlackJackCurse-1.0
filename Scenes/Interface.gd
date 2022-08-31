extends CanvasLayer

var countBlackJack = 0
var timerLabel = Timer.new()

func _ready():
	$deckButton/Particles2D.emitting = true
	$shuffleAudio.play()
	GameManager.connect("drawSignal", self, "drawCard")
	GameManager.connect("discardSignal", self, "updateDiscardDeck")
	GameManager.connect("cardAudioSignal", self, "playCardAudioSignal")
	GameManager.connect("reShuffleSignal", self,"reShuffle")
	GameManager.connect("resetHandSignal", self, "startTimerHand")
	GameManager.connect("endTurnSignal", self, "endTurn")
	GameManager.connect("blackJackSignal", self, "blackJack")
	GameManager.connect("charlieSevenSignal", self, "charlieSeven")
	GameManager.connect("lifeBarSignal", self, "updateLifeBar")
	GameManager.connect("gameOverAudio", self, "playGameOVerAudio")
	GameManager.connect("invalidCardAudio", self, "playInvalidCardAudio")
	GameManager.connect("newTurnSignal", self, "newTurn")
	GameManager.connect("newLevelSignal", self, "newLevel")
	$levelLabel.text = "Level "+str(GameManager.currentLevel)
	timerLabel.connect("timeout",self,"turnOffLabel")
	timerLabel.set_one_shot(true)
	add_child(timerLabel)
	timerLabel.start(1.4)
	drawCard()

func _on_deckButton_pressed():
	if GameManager.enemyTurn == false:
		drawCard()

func _on_discardButton_pressed():
	$discardAudio.play()
	if ($discardHand.visible == false):
		$discardHand.visible = true
		
	else:
		$discardHand.visible = false

func _on_AnimationPlayer_animation_finished(name):
	if (name == "draw"):
		$hand.add_child(GameManager.newCard)
		updateHand()


func updateHand():
	updateLifeBar()
	updateDiscardDeck()

func updateLifeBar():
	$lifeBar.value = GameManager.life

func startTimerHand():
		$timerHand.start()

func newTurn():
	$deckButton.disabled = false
	$endTurnButton.disabled = false

func endTurn():
	$deckButton.disabled = true
	endTurnAnimation()
	updateLifeBar()
	print("end turn")

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

func reShuffle():
	$deckButton/Particles2D.emitting = true
	$shuffleAudio.play()
	updateHand()
	updateDiscardDeck()
	for n in $discardHand/discard.get_children():
		$discardHand/discard.remove_child(n)
		n.queue_free()

func _on_endTurnButton_pressed():
	$endTurnButton.disabled = true
	GameManager.endTurn()

func blackJack():
	$blackJack/timerBJ.set_one_shot(false)
	countBlackJack = 0
	startTimerHand()
	$blackJack.visible = true
	$blackJack/timerBJ.start()
	$blackJackAudio.play()

func charlieSeven():
	startTimerHand()
	$charlieSeven.play("seven")
	$charlie7Audio.play()

func endTurnAnimation():
	$AnimationEndTurn.play("endTurn")

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

func playGameOVerAudio():
	$gameOverAudio.play()

func playInvalidCardAudio():
	$invalidCardAudio.play()

func _on_charlieSeven_animation_finished():
	$charlieSeven.play("null")

func newLevel():
	$levelLabel.visible = true
	$levelLabel.text = "Level "+str(GameManager.currentLevel)
	timerLabel.start(1.4)

func turnOffLabel():
	$levelLabel.visible = false
