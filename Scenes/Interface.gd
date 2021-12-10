extends CanvasLayer




func _ready():
	pass
	

func _on_deckButton_pressed():
	GameManager.drawCard()
	$AnimationPlayer.play("draw")
	endTurn()

func _on_discardButton_pressed():
	if ($discardHand.visible == false):
		$discardHand.visible = true
	else:
		$discardHand.visible = false

func _on_AnimationPlayer_animation_finished(draw):
	$hand.add_child(GameManager.newCard)

func endTurn():
	$lifeBar.value = GameManager.life
	if GameManager.resetingHand:
		for n in $hand.get_children():
			$hand.remove_child(n)
			n.queue_free()
		GameManager.resetingHand = false
