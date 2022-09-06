extends Control

var count = 0

func _ready():
	$Panel/ColorRect/logo1.visible = true
	$Panel/ColorRect/logo2.visible = true
	TranslationServer.set_locale("en")
	
	$Panel/ColorRect/ButtonPlay.text = tr("bPlay")
	$Panel/ColorRect/ButtonHowTo.text = tr("howTo")
	

func _on_Timer_timeout():
	count += 1
	if count == 1:
		$Panel/ColorRect/logo1.visible = false
	if count == 2:
		$Panel/ColorRect/logo2.visible = false
		$Panel/ColorRect/Timer.stop()

func _on_ButtonPlay_pressed():
	GameManager.resectGame()
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_ButtonEsp_pressed():
	$Panel/ColorRect/ButtonEsp.disabled = true
	$Panel/ColorRect/ButtonEng.disabled = false
	TranslationServer.set_locale("es")
	$Panel/ColorRect/ButtonPlay.text = tr("bPlay")
	$Panel/ColorRect/ButtonHowTo.text = tr("howTo")

func _on_ButtonEng_pressed():
	$Panel/ColorRect/ButtonEsp.disabled = false
	$Panel/ColorRect/ButtonEng.disabled = true
	TranslationServer.set_locale("en")
	$Panel/ColorRect/ButtonPlay.text = tr("bPlay")
	$Panel/ColorRect/ButtonHowTo.text = tr("howTo")
