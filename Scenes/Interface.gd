extends CanvasLayer




func _ready():
	pass
	

func _on_deckButton_pressed():
	GameManager.drawCard()
	$AnimationPlayer.play("draw")
	wait()

func _on_discardButton_pressed():
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
	endWait()

func wait():
	$deckButton.disabled = true

func endWait():
	$deckButton.disabled = false

func _on_timerHand_timeout():
	for n in $hand.get_children():
		$hand.remove_child(n)
		n.queue_free()
