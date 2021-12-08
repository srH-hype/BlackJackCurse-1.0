extends Node

onready var Game = get_node('/root/Game/')
var deck = Array()
var cardBack = preload("res://Assects/cards/card_back.png")
var handValue = 0
var handSize = 0
var newCard 


func _ready():
	fillDeck()
	randomize()
	deck.shuffle()

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
	newCard = deck[0]
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
	get_tree().change_scene("res://Scenes/GameOver.tscn")


func resectGame():
	deck.clear()
	handSize = 0
	handValue = 0 
	fillDeck()
	randomize()
	deck.shuffle()


