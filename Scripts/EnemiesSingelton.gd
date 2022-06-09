extends Node

signal signalRemove(enemy)

var enemyDefault = {
	"hp" : 1,
	"attack" : 1,
	"spriteNode" : load("res://Assects/sprites/enemyDeafaultSS.png"),
	"boss" : false
}

func remove(enemy):
	emit_signal("signalRemove",enemy)
