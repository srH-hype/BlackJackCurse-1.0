extends Control

func _ready():
	$Button.text = tr("bExit")
	$creditsMove/programing1.text = tr("programing")
	$creditsMove/translation1.text = tr("translation")
	$creditsMove/assets1.text = tr("assets")
	$creditsMove/thanks.text = tr("thanks")

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
