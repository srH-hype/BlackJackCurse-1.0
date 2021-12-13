extends TextureButton

class_name SmallCard

var suit
var value
var face


func _ready():
	pass

func _init(var s, var v):
	value = v
	suit = s
	face = load("res://Assects/cardSmall/card-"+str(suit)+"-"+str(value)+".png")
	set_normal_texture(face)

