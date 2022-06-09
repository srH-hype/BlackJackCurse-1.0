extends Node2D

var hp 
var attack
var spriteNode
var life = true
var boss
var tile
var timerRemove = Timer.new()

func _ready():
	timerRemove.connect("timeout", self, "remove")
	timerRemove.set_one_shot(true)
	add_child(timerRemove)

func create(enemyType,x,y):
	hp = enemyType.get("hp",1)
	attack = enemyType.get("attack",1)
	spriteNode = enemyType.get("spriteNode")
	boss = enemyType.get("boss")
	$spriteEnemy.texture = spriteNode
	$spriteEnemy.hframes = 2
	$spriteEnemy.vframes = 2
	tile = Vector2(x,y)
	

func attack(damage):
	GameManager.takeDamage(damage)

func takeDamage(damage):
	hp=-damage
	if hp <= 0:
		timerRemove.start(0.4)
	

func remove():
	queue_free()
