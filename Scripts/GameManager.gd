extends Node

onready var Game = get_node('/root/Game/')
var deck = Array()
var cardBack = preload("res://Assects/cards/card_back.png")
var handValue = 0
var newCard 
var life = 21
var discardDeck = Array()
var hand = Array()
var timerGameOver = Timer.new()
var timerWait = Timer.new()
signal drawSignal
signal discardSignal
signal cardAudioSignal
signal reShuffleSignal
signal resetHandSignal
signal waitSignal
signal endWaitSignal
signal endTurnSignal

func _ready():
	timerGameOver.connect("timeout",self,"gameOver")
	timerGameOver.set_one_shot(true)
	timerWait.connect("timeout", self, "endWait")
	timerWait.set_one_shot(true)
	add_child(timerGameOver)
	add_child(timerWait)
	fillDeck()
	randomize()
	deck.shuffle()

func reCheckHand():
	handValue = 0
	for n in range(hand.size()):
		updateCard(hand[n].value)

func eraseDuplicateCards():
	for c1 in range(hand.size()):
		for c2 in range(deck.size()):
			if deck[c2].value == hand[c1].value && deck[c2].suit == hand[c1].suit :
				deck.remove(c2)
				break
	print("Deck ", deck.size())

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

func drawCard():
	waitAndTimer()
	if !deck.empty():
		newCard = deck[0]
		updateCard(deck[0].value)
		hand.append(deck[0])
		print(handValue)
		deck.remove(0)
	else:
		reShuffleDeck()
	checkLife()

func reShuffleDeck():
	emit_signal("reShuffleSignal")
	fillDeck()
	randomize()
	deck.shuffle()
	discardDeck.clear()
	eraseDuplicateCards()
	if hand.empty():
		emit_signal("drawSignal")


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

func cardValue(value):
	if value >= 2 && value <= 10:
		return value
	elif value == 1:
		return 11
	else:
		return 10

func checkHand():
	reCheckHand()
	if(handValue >21 ):
		handUpTo21()

func gameOver():
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func handUpTo21():
	endTurn()
	var damage = handValue - 21
	takeDamage(damage)
	fillDiscardDeck()
	emit_signal("resetHandSignal")

func takeDamage(damage):
	life = life - damage

func checkLife():
	checkHand()
	if life <= 0:
		timerGameOver.start(0.5)

func resetHand():
	hand.clear()
	handValue = 0 

func cardPressed(var c):
	endTurn()
	waitAndTimer()
	emit_signal("cardAudioSignal")
	updateCard(-c.value)
	hand.erase(c)
	discardDeck.append(SmallCard.new(c.suit,c.value))
	if (hand.empty()):
		emit_signal("drawSignal")
	emit_signal("discardSignal")
	if c.suit == 1 or c.suit == 4:
		print(cardValue(c.value), " Healing")
	else:
		print(cardValue(c.value), " Damage")

func wait():
	emit_signal("waitSignal")

func endWait():
	emit_signal("endWaitSignal")

func endTurn():
	emit_signal("endTurnSignal")

func waitAndTimer():
	wait()
	timerWait.start(0.7)

func resectGame():
	resetHand()
	handValue = 0
	discardDeck.clear()
	deck.clear()
	life = 21
	fillDeck()
	randomize()
	deck.shuffle()

