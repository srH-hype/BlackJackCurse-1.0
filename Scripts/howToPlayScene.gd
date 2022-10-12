extends Control

func _ready():
	$background/labelTitle.text = tr("howTo")
	$background/label1.text = tr("move")
	$background/label2.text = tr("redCards")
	$background/label3.text = tr("blackCards")
	$background/label4.text = tr("clickCards")
	$background/label5.text = tr("discard")
	$background/label6.text = tr("drawCard")
	$background/label7.text = tr("beCareful")
	$background/label8.text = tr("blackjack")
	$background/label9.text = tr("lifeBar")
	$background/label10.text = tr("deck")
	$background/label11.text = tr("defeatAll")
	$background/label12.text = tr("restart")
	$background/label13.text = tr("goal")

func _on_buttonBack_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
