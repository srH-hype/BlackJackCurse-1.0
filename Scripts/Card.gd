extends TextureButton

class_name Card

var suit
var value
var face
var back
var scale = Vector2(2,2)

func _ready():
	pass

func _init(var s, var v):
	value = v
	suit = s
	face = load("res://Assects/cards/card-"+str(suit)+"-"+str(value)+".png")
	back = GameManager.cardBack
	set_normal_texture(face)
	set_scale(Vector2(2,2))
	


