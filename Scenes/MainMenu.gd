extends Control


func _ready():
	TranslationServer.set_locale("en")
	
	$CenterContainer/Panel/ColorRect/ButtonPlay.text = tr("bPlay")
	$CenterContainer/Panel/ColorRect/ButtonExit.text = tr("bExit")
	


func _on_Button_pressed():
	GameManager.resectGame()
	get_tree().change_scene("res://Scenes/Game.tscn")
