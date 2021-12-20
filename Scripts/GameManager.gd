extends Node

onready var Game = get_node('/root/Game/')
var deck = Array()
var cardBack = preload("res://Assects/cards/card_back.png")
var handValue = 0
var newCard 
var life = 21
var resetingHand = false
var discardDeck = Array()
var hand = Array()
var timerGameOver = Timer.new()


func _ready():
	timerGameOver.connect("timeout",self,"gameOver")
	timerGameOver.set_one_shot(true)
	add_child(timerGameOver)
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

func fillDiscardDeck():
	for n in range(hand.size()):
		discardDeck.append(SmallCard.new(hand[n].suit,hand[n].value))

func cardToDiscardDeck(var c):
	updateCard(-c.value)
	print(handValue)
	hand.erase(c)
	discardDeck.append(SmallCard.new(c.suit,c.value))
	if (hand.empty()):
		drawCard()

func drawCard():
	newCard = deck[0]
	updateCard(deck[0].value)
	hand.append(deck[0])
	print(handValue)
	deck.remove(0)
	endTurn()
	

func updateCard(value):
	if (value > 0):
		if (value >=2 && value <= 10):
			handValue += value
		elif(value == 1):
			if(handValue == 10):
				handValue += 11
			else:
				handValue += 1
		else:
			handValue += 10
	else:
		if (value <=-1 && value >= -10):
			handValue += value
		else:
			handValue += -10

func checkHand():
	if(handValue >21 ):
		handUpTo21()

func gameOver():
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func handUpTo21():
	var damage = handValue - 21
	takeDamage(damage)
	fillDiscardDeck()
	resetingHand = true

func takeDamage(damage):
	life = life - damage

func endTurn():
	checkHand()
	if life <= 0:
		timerGameOver.start(1)

func resetHand():
	hand.clear()
	handValue = 0 

func cardPressed(var c):
	print("Card played ",c.value)

func resectGame():
	resetingHand = false
	resetHand()
	print("Hand ",handValue)
	handValue = 0
	discardDeck.clear()
	deck.clear()
	life = 21
	fillDeck()
	randomize()
	deck.shuffle()


