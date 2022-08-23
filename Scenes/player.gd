extends Sprite

var cardFireAudio= preload("res://Assects/audio/flame(themightyglider).ogg")
var stepAudio = preload("res://Assects/audio/stone01.ogg")
var failAudio = preload("res://Assects/audio/witch_cackle-1(AntumDeluge).ogg")

func _ready():
	GameManager.connect("cardFireSignal", self, "cardFire")
	GameManager.connect("takeDamegeSignal", self, "damage")
	GameManager.connect("failSignal", self, "fail")

func cardFire(value):
	$audioPlayer.stream = cardFireAudio
	$audioPlayer.volume_db = -7
	$audioPlayer.play()
	$Sprite.visible = true
	$AnimationCardFire.play("cardFire")
	$AnimationPlayer.play("attack")

func move():
	$audioPlayer.stream = stepAudio
	$audioPlayer.volume_db = 14
	$audioPlayer.play()
	$AnimationPlayer.play("move")

func damage():
	$AnimationPlayer.play("damage")

func fail():
	$audioPlayer.stream = failAudio
	$audioPlayer.volume_db = -7
	$audioPlayer.play()

func _on_AnimationCardFire_animation_finished(name):
	if name == "cardFire":
		$Sprite.visible = false
