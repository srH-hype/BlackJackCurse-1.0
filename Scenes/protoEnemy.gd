extends Node2D

var hp 
var attack
var spriteNode
var life = true
var boss
var tile

func create(enemyType,x,y):
	hp = enemyType.get("hp",1)
	attack = enemyType.get("attack",1)
	spriteNode = enemyType.get("spriteNode")
	boss = enemyType.get("boss")
	$spriteEnemy.texture = spriteNode
	$spriteEnemy.hframes = 2
	$spriteEnemy.vframes = 2
	tile = Vector2(x,y)
	

func remove():
	queue_free()
