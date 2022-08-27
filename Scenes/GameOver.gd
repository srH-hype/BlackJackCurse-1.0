extends Control

var winSong = preload("res://Assects/audio/Transformansion ending.wav")


func _ready():
	
	if GameManager.win:
		$CenterContainer/Panel/ColorRect/gameOverLabel.text = "YOU WIN"
		$CenterContainer/Panel/ColorRect.color =Color(255,236,0,255)
		$CenterContainer/Panel/ColorRect/scoreGameOverLabel.text = "Score "+str(GameManager.currentLevel)
		$CenterContainer/Panel/ColorRect/scoreGameOverLabel.set("custom_colors/font_color",Color(0,0,0))
		$CenterContainer/Panel/ColorRect/gameOverLabel.set("custom_colors/font_color",Color(0,0,0))
		$CenterContainer/Panel/ColorRect/ButtonE.set("custom_colors/font_color",Color(0,0,0))
		$CenterContainer/Panel/ColorRect/ButtonTA.set("custom_colors/font_color",Color(0,0,0))
		$CenterContainer/Panel/ColorRect/ButtonE.set("custom_colors/font_color_hover",Color(255,255,255))
		$CenterContainer/Panel/ColorRect/ButtonTA.set("custom_colors/font_color_hover",Color(255,255,255))
		$audioGameOver.stream = winSong
		$audioGameOver.play()
	else:
		$CenterContainer/Panel/ColorRect/scoreGameOverLabel.text = "Score "+str(GameManager.currentLevel)
		$CenterContainer/Panel/ColorRect/gameOverLabel.set("custom_colors/font_color",Color(255,0,0,255))
		

func _on_Button_pressed():
	GameManager.resectGame()
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_ButtonE_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
