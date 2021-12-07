extends Node

onready var Game = get_node('/root/Game/')
var deck = Array()
var cardBack = preload("res://Assects/cards/card_back.png")
var handValue = 0
var handSize = 0
var popUpGO = preload("res://Scenes/GameOver.tscn")
signal signalDraw(Card)


func _ready():
	fillDeck()
	randomize()
	deck.shuffle()
	var gameOverS = popUpGO.instance()

func fillDeck():
	deck.clear()
	var s = 1
	var v = 1
	while s < 5:
		v = 1
		while v < 14:
			deck.append(Card.new(s,v))
			v = v + 1
		s += 1

func drawCard():
	var interface = Game.get_node('Interface')
	interface.get_node('hand').add_child(deck[0])
	updateCard(deck[0].value)
	handSize += 1
	print(handValue)
	deck.remove(0)
	checkHand()

func updateCard(value):
	if (value >=2 && value <= 10):
		handValue += value
	elif(value == 1):
		if(handValue == 10):
			handValue += 11
		else:
			handValue += 1
	else:
		handValue += 10

func checkHand():
	if(handValue >21 ):
		gameOver()

func gameOver():
	deleteHand()
	var gameOverS = popUpGO.instance()
	Game.add_child(gameOverS) 
	
func resectGame():
	for c in range(deck.size()-handSize):
		deck[c].queue_free()
	deck.clear()
	handSize = 0
	handValue = 0
	Game.get_node('Interface').get_node('hand') 
	fillDeck()
	randomize()
	deck.shuffle()

func deleteHand():
	var hand = Game.get_node('Interface').get_node('hand')
	for n in hand.get_children():
		hand.remove_child(n)
		n.queue_free()
