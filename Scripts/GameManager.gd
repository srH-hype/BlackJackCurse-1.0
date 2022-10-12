extends Node

var deck = Array()
var cardBack = preload("res://Assects/cards/card_back.png")
var handValue = 0
var newCard 
var asInHand = 0
var life = 21
var discardDeck = Array()
var hand = Array()
var timerGameOver = Timer.new()
var timerTurn = Timer.new()
var timerPlayerAction = Timer.new()
var drawingCard = false
var enemyTurn = false
var currentLevel = 1
var win = false
var language = "en"
signal drawSignal
signal discardSignal
signal cardAudioSignal
signal reShuffleSignal
signal resetHandSignal
signal endTurnSignal
signal newTurnSignal
signal blackJackSignal
signal charlieSevenSignal
signal lifeBarSignal
signal gameOverAudio
signal invalidCardAudio
signal cardFireSignal(value)
signal takeDamegeSignal
signal failSignal
signal newLevelSignal

#Initializing the game.
func _ready():
	timerGameOver.connect("timeout",self,"gameOver")
	timerGameOver.set_one_shot(true)
	timerTurn.connect("timeout", self, "newTurn")
	timerTurn.set_one_shot(true)
	timerPlayerAction.connect("timeout",self,"endAnimationTimer")
	timerPlayerAction.set_one_shot(true)
	add_child(timerTurn)
	add_child(timerGameOver)
	add_child(timerPlayerAction)
	fillDeck()
	randomize()
	deck.shuffle()


#Removing the cards that are in the player's hand from the deck.
func eraseDuplicateCards():
	for c1 in range(hand.size()):
		for c2 in range(deck.size()):
			if deck[c2].value == hand[c1].value && deck[c2].suit == hand[c1].suit :
				deck.remove(c2)
				break

#Creating a deck of cards.
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


#Adding the cards in the player's hand to the discard deck.
func fillDiscardDeck():
	if life >= 0:
		for n in range(hand.size()):
			discardDeck.append(SmallCard.new(hand[n].suit,hand[n].value))

#This function is drawing a card from the deck. It is checking if the deck is empty. 
#If it is not, it is adding the card to the player's hand.also checking if the player's hand has 7 cards. 
#If it does, it is calling the charlieSeven function. If the deck is empty, it is calling the reShuffleDeck function.
#also calling the endTurn function.
func drawCard():
	if !deck.empty():
		newCard = deck[0]
		countAs(deck[0].value)
		updateCard(deck[0].value)
		hand.append(deck[0])
		deck.remove(0)
		if hand.size() == 7 && handValue < 21:
			charlieSeven()
	else:
		reShuffleDeck()
	endTurn()

func reShuffleDeck():
	emit_signal("reShuffleSignal")
	fillDeck()
	randomize()
	deck.shuffle()
	discardDeck.clear()
	eraseDuplicateCards()
	if drawingCard == false :
		emit_signal("drawSignal")

#This function is counting the number of Aces in the player's hand.
func countAs(value):
	if value == 1 :
		asInHand += 1
	if value == -1 :
		asInHand -= 1

#This function is updating the hand value. It is checking if the card is an Ace, a face card or a number card.
#If it is an Ace, it checks if the hand value is 10. If it is, it adds 21 to the hand value. If it is not, it adds 11 to the hand value.
#If it is a face card, it adds 10 to the hand value. If it is a number card, it adds the value of the card to the hand value.
#If the card is a negative number, it checks if the hand value is 10. If it is, it subtracts 21 from the hand value.
#If it is not, it subtracts the value of the card from the hand value.
func updateCard(value):
	if (value > 0):
		if (value >=1 && value <= 10):
			if asInHand != 0 && handValue + value == 11:
				handValue += value + 10
			else:
				handValue += value 
		else:
			if asInHand != 0 && handValue + 10 == 11:
				handValue += 10 + 10
			else:
				handValue += 10 
	else:
		if handValue + value == 11 && asInHand !=0:
			handValue = 21
		elif (value <=-1 && value >= -10):
			if value == 1 && handValue + 11 <= 21:
				handValue -= 11
			else:
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
	if handValue >21 :
		handUpTo21()
	if handValue == 21:
		blackJack()

func charlieSeven():
	timerGameOver.start(0.5)
	win = true
	life = 21
	fillDiscardDeck()
	emit_signal("charlieSevenSignal")

func blackJack():
	life = 21
	fillDiscardDeck()
	emit_signal("blackJackSignal")

func gameOver():
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func handUpTo21():
	emit_signal("failSignal")
	if !deck.empty(): 
		drawingCard = true
	var damage = handValue - 21
	takeDamage(damage)
	fillDiscardDeck()
	emit_signal("resetHandSignal")

func takeDamage(damage):
	life = life - damage
	emit_signal("takeDamegeSignal")

func checkLife():
	checkHand()
	if life <= 0:
		emit_signal("gameOverAudio")
		timerGameOver.start(0.5)

func healing(value):
	if life + value >= 21:
		life = 21
	else:
		life += value
	emit_signal("lifeBarSignal")

func resetHand():
	asInHand = 0
	hand.clear()
	handValue = 0 

#This function is called when a card is pressed. It checks if it is the player's turn 
#and if the card is a heart or a diamond. If it is, it checks if the player's life is less than 21.
#If it is, it heals the player and ends the turn. If it is not, it plays an invalid card sound. 
#If the card is not a heart or a diamond, it deals damage to the enemy and ends the turn.
func cardPressed(var c):
	if enemyTurn == false:
		if c.suit == 1 or c.suit == 4:
			if life < 21:
				healing(cardValue(c.value))
				endTurn()
				emit_signal("cardAudioSignal")
				updateCard(-c.value)
				hand.erase(c)
				c.queue_free()
				discardDeck.append(SmallCard.new(c.suit,c.value))
				if (hand.empty()):
					emit_signal("drawSignal")
				emit_signal("discardSignal")
			else:
				emit_signal("invalidCardAudio")
		else:
			emit_signal("cardFireSignal",cardValue(c.value))
			endTurn()
			emit_signal("cardAudioSignal")
			updateCard(-c.value)
			hand.erase(c)
			c.queue_free()
			discardDeck.append(SmallCard.new(c.suit,c.value))
			if (hand.empty()):
				emit_signal("drawSignal")
			emit_signal("discardSignal")
		checkHand()

#This function is called when the player ends his turn. It is checking if the player's 
#life is less than or equal to 0. If it is, it is calling the gameOver function.
#also setting the drawingCard variable to false and the enemyTurn variable to false. 
#It is also emitting the newTurnSignal.
func endTurn():
	checkLife()
	enemyTurn = true
	timerTurn.start(1)
	timerPlayerAction.start(0.35)

#This function is called when the enemy's turn is over. It is checking if the player's 
#life is less than or equal to 0. If it is, it is calling the gameOver function.
#also setting the drawingCard variable to false and the enemyTurn variable to false. 
#It is also emitting the newTurnSignal.
func newTurn():
	checkLife()
	drawingCard = false
	enemyTurn = false
	emit_signal("newTurnSignal")

func endAnimationTimer():
	emit_signal("endTurnSignal")

#Reseting the game.
func resectGame():
	resetHand()
	handValue = 0
	discardDeck.clear()
	deck.clear()
	life = 21
	fillDeck()
	randomize()
	deck.shuffle()
	currentLevel = 1

func newLevel():
	currentLevel = currentLevel + 1
	emit_signal("newLevelSignal")

func _input(event):
	if event.is_action_pressed("restart"):
		if get_tree().current_scene.name == "Game":
			resectGame()
			get_tree().reload_current_scene()
