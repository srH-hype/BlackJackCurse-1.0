extends Control

func _ready():
	pass

func _on_Button_pressed():
	GameManager.resectGame()
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_ButtonE_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
