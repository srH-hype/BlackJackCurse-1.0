extends Node

var enemiesInLevel = 14
var enemiesList = []
signal signalRemove(enemy)

var enemyDefault = {
	"hp" : 1,
	"attack" : 1,
	"spriteNode" : load("res://Assects/sprites/enemyDeafaultSS.png"),
	"boss" : false,
	"audio": load("res://Assects/audio/monster-1.wav")
}

var enemyhumanoid = {
	"hp" : 10,
	"attack" : 4,
	"spriteNode" : load("res://Assects/sprites/humanoidSS.png"),
	"doubleAttack" : false,
	"audio": load("res://Assects/audio/monster-1.wav")
}

var enemyFish = {
	"hp" : 7,
	"attack" : 2,
	"spriteNode" : load("res://Assects/sprites/fishSS.png"),
	"doubleAttack" : true,
	"audio": load("res://Assects/audio/monster-2.wav")
}

var enemySarro = {
	"hp" : 22,
	"attack" : 1,
	"spriteNode" : load("res://Assects/sprites/sarroSS.png"),
	"doubleAttack" : false,
	"audio": load("res://Assects/audio/monster-3.wav")
}

var enemyKey = {
	"hp" : 20,
	"attack" : 3,
	"spriteNode" : load("res://Assects/sprites/keySS.png"),
	"doubleAttack" : false,
	"audio": load("res://Assects/audio/monster-4.wav")
}

var enemyLock = {
	"hp" : 30,
	"attack" : 2,
	"spriteNode" : load("res://Assects/sprites/lockSS.png"),
	"doubleAttack" : false,
	"audio": load("res://Assects/audio/monster-5.wav")
}

var enemyBanana = {
	"hp" : 14,
	"attack" : 7,
	"spriteNode" : load( "res://Assects/sprites/bananaSS.png"),
	"doubleAttack" : false,
	"audio": load("res://Assects/audio/monster-6.wav")
}

var enemyTentecle = {
	"hp" : 21,
	"attack" : 3,
	"spriteNode" : load("res://Assects/sprites/tentaculeSS.png"),
	"doubleAttack" : true,
	"audio": load("res://Assects/audio/monster-7.wav")
}

func enemiesPerLevel():
	randomize()
	if GameManager.currentLevel != 1:
		enemiesInLevel = enemiesInLevel + GameManager.currentLevel
	else:
		enemiesInLevel = 14
	
	var numberEnemyType = 0
	var helperVariableEnemies = enemiesInLevel

	while enemiesList.size() != enemiesInLevel:
		numberEnemyType = numberEnemyType +1
		var enemiesOfThisType = randi()%helperVariableEnemies+1
		helperVariableEnemies = helperVariableEnemies - enemiesOfThisType
		for e in range(enemiesOfThisType):
			match numberEnemyType:
				1:
					enemiesList.insert(e,enemyhumanoid)
				2:
					enemiesList.insert(e,enemySarro)
				3:
					enemiesList.insert(e,enemyFish)
				4:
					enemiesList.insert(e,enemyKey)
				5:
					enemiesList.insert(e,enemyLock)
				6:
					enemiesList.insert(e,enemyBanana)
				7:
					enemiesList.insert(e,enemyTentecle)


func remove(enemy):
	emit_signal("signalRemove",enemy)
