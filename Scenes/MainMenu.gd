extends Control


func _ready():
	pass


func _on_Button_pressed():
	print("Jala")
	get_tree().change_scene("res://Scenes/Game.tscn")
