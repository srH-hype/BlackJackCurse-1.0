extends Node2D

var hp 
var attack
var spriteNode
var life = true
var boss
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

func create(enemyType,x,y):
	hp = enemyType.get("hp",1)
	attack = enemyType.get("attack",1)
	spriteNode = enemyType.get("spriteNode")
	boss = enemyType.get("boss")
	$spriteEnemy.texture = spriteNode
	$spriteEnemy.hframes = 2
	$spriteEnemy.vframes = 2
	tile = Vector2(x,y)
	

func attackFrame():
	if life:
		$spriteEnemy.frame = 2
		GameManager.takeDamage(attack)

func takeDamage(damage):
	$spriteEnemy.frame = 3
	hp=-damage
	if hp <= 0:
		life = false
		timerRemove.start(0.35)
	

func resetFrame():
	$spriteEnemy.frame = 0

func move():
	if life == true:
		$spriteEnemy.frame = 1
		timeFrame.start(0.14)
	else:
		$spriteEnemy.frame = 3
	

func remove():
	EnemiesSingelton.remove(self)
