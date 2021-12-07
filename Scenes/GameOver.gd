extends Control



func _ready():
	get_tree().set_pause(true)

func _on_Button_pressed():
	get_tree().set_pause(false)
	GameManager.resectGame()
	queue_free()

func _on_ButtonE_pressed():
	pass
