extends TextureButton

class_name Card

var suit
var value
var face
var back

func _ready():
	GameManager.connect("endTurnSignal", self, "endTurn")
	GameManager.connect("newTurnSignal", self, "newTurn")
	disabled = true

func _init(var s, var v):
	value = v
	suit = s
	face = load("res://Assects/cards/card-"+str(suit)+"-"+str(value)+".png")
	back = GameManager.cardBack
	set_normal_texture(face)
	if suit == 1 || suit == 4:
		set_pressed_texture(load("res://Assects/cards/card_heal.png"))
	else:
		set_pressed_texture(load("res://Assects/cards/card_attack.png"))
	set_scale(Vector2(2,2))

func newTurn():
	if suit == 1 || suit == 4:
		if GameManager.life == 21:
			set_pressed_texture(load("res://Assects/cards/card_NoHeal.png"))
	disabled = false

func _pressed():
	GameManager.cardPressed(self)

func endTurn():
	disabled = true

