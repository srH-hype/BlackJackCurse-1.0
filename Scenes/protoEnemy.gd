extends Node2D

var hp 
var attack
var spriteNode
var life = true
var doubleAttack
var firstMove = true
var tile
var timerRemove = Timer.new()
var timeFrame = Timer.new()

func _ready():
	timerRemove.connect("timeout", self, "remove")
	timerRemove.set_one_shot(true)
	add_child(timerRemove)
	timeFrame.connect("timeout",self,"resetFrame")
	timeFrame.set_one_shot(true)
	add_child(timeFrame)
	GameManager.connect("newTurnSignal", self,"resetFirstMove")
	GameManager.connect("blackJackSignal", self, "blackJackEnemy")
	GameManager.connect("charlieSevenSignal", self,"charlie7Enemy")

func create(enemyType,x,y):
	hp = enemyType.get("hp")
	attack = enemyType.get("attack")
	spriteNode = enemyType.get("spriteNode")
	doubleAttack = enemyType.get("doubleAttack")
	$audioEnemy.stream = enemyType.get("audio")
	$audioEnemy.volume_db = -14
	$spriteEnemy.texture = spriteNode
	$spriteEnemy.hframes = 2
	$spriteEnemy.vframes = 2
	$spriteEnemy.scale = Vector2(0.1,0.1)
	tile = Vector2(x,y)

func attackFrame():
	if life:
		$audioEnemy.play()
		$spriteEnemy.frame = 2
		GameManager.takeDamage(attack)

func takeDamage(damage):
	$spriteEnemy.frame = 3
	hp = hp-damage
	if hp <= 0:
		life = false
		timerRemove.start(0.35)

func resetFrame():
	$spriteEnemy.frame = 0

func firstMoveM():
	firstMove = false

func resetFirstMove():
	firstMove = true

func move():
	if life == true:
		$spriteEnemy.frame = 1
		timeFrame.start(0.14)
	else:
		$spriteEnemy.frame = 3
	

func blackJackEnemy():
	if $VisibilityNotifier2D.is_on_screen():
		takeDamage(21)

func charlie7Enemy():
	if $VisibilityNotifier2D.is_on_screen():
		takeDamage(777)

func remove():
	EnemiesSingelton.remove(self)
