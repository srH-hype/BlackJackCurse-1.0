extends Control

var count = 0
var sceneArray = [
preload("res://Assects/icons/scene1.png"),
preload("res://Assects/icons/scene2.png"),
preload("res://Assects/icons/scene3.png"),
preload("res://Assects/icons/scene4.png"),
preload("res://Assects/icons/scene5.png"),
preload("res://Assects/icons/scene6.png")
]

var sceneCounter = 0

func _ready():
	$Panel/ColorRect/logo1.visible = true
	$Panel/ColorRect/logo2.visible = true
	TranslationServer.set_locale(GameManager.language)
	$Panel/ColorRect/ButtonPlay.text = tr("bPlay")
	$Panel/ColorRect/ButtonHowTo.text = tr("howTo")
	$Panel/ColorRect/ButtonCredits.text = tr("credits")
	if GameManager.language == "es":
		$Panel/ColorRect/ButtonEsp.disabled = true
	if GameManager.language == "en":
		$Panel/ColorRect/ButtonEng.disabled = true
	$Cinematic/ButtonPlayScene.text = tr("skip")

func _on_Timer_timeout():
	count += 1
	if count == 1:
		$Panel/ColorRect/logo1.visible = false
	if count == 2:
		$Panel/ColorRect/logo2.visible = false
		$Panel/ColorRect/Timer.stop()

func _on_ButtonPlay_pressed():
	$Cinematic/scene.color = Color(255,0,0)
	$Cinematic/labelScene.text = tr("scene1")
	$Cinematic.visible = true
	$Cinematic/timerScene.start()

func _on_ButtonEsp_pressed():
	$Panel/ColorRect/ButtonEsp.disabled = true
	$Panel/ColorRect/ButtonEng.disabled = false
	GameManager.language = "es"
	TranslationServer.set_locale(GameManager.language)
	$Panel/ColorRect/ButtonPlay.text = tr("bPlay")
	$Panel/ColorRect/ButtonHowTo.text = tr("howTo")
	$Panel/ColorRect/ButtonCredits.text = tr("credits")
	$Cinematic/ButtonPlayScene.text = tr("skip")

func _on_ButtonEng_pressed():
	$Panel/ColorRect/ButtonEsp.disabled = false
	$Panel/ColorRect/ButtonEng.disabled = true
	GameManager.language = "en"
	TranslationServer.set_locale(GameManager.language)
	$Panel/ColorRect/ButtonPlay.text = tr("bPlay")
	$Panel/ColorRect/ButtonHowTo.text = tr("howTo")
	$Panel/ColorRect/ButtonCredits.text = tr("credits")
	$Cinematic/ButtonPlayScene.text = tr("skip")

func _on_ButtonHowTo_pressed():
	get_tree().change_scene("res://Scripts/howToPlayScene.tscn")

func _on_timerScene_timeout():
	sceneCounter += 1
	nextScene(sceneCounter)

func nextScene(sceneNum):
	$Cinematic/timerScene.start(3+sceneNum)
	if sceneNum == 3:
		$Cinematic/scene.color = Color(0,0,0)
	if sceneNum < 6:
		$Cinematic/sceneImage.texture = sceneArray[sceneNum]
		$Cinematic/labelScene.text = tr("scene"+str(sceneNum+1))
	else:
		GameManager.resectGame()
		get_tree().change_scene("res://Scenes/Game.tscn")

func _on_ButtonPlayScene_pressed():
	GameManager.resectGame()
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_ButtonCredits_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")
