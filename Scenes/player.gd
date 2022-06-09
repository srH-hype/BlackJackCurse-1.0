extends Sprite


func _ready():
	GameManager.connect("cardFireSignal", self, "cardFire")
	GameManager.connect("takeDamegeSignal", self, "damage")

func cardFire(value):
	$Sprite.visible = true
	$AnimationCardFire.play("cardFire")
	$AnimationPlayer.play("attack")

func move():
	$AnimationPlayer.play("move")

func damage():
	$AnimationPlayer.play("damage")

func _on_AnimationCardFire_animation_finished(name):
	if name == "cardFire":
		$Sprite.visible = false
