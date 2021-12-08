extends CanvasLayer



func _ready():
	pass
	

func _on_deckButton_pressed():
	GameManager.drawCard()
	$AnimationPlayer.play("draw")
	



func _on_discardButton_pressed():
	if ($discardHand.visible == false):
		$discardHand.visible = true
	else:
		$discardHand.visible = false

func _draw(card):
	get_node('hand').add_child(card)
	print("Jala")


func _on_AnimationPlayer_animation_finished(draw):
	$hand.add_child(GameManager.newCard)
