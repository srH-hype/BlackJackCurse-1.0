extends Sprite


func _ready():
	GameManager.connect("cardFireSignal", self, "cardFire")

func cardFire():
	$Sprite.visible = true
	$AnimationPlayer.play("cardFire")

func move():
	$AnimationPlayer.play("move")


func _on_AnimationPlayer_animation_finished(name):
	if name == "cardFire":
		$Sprite.visible = false
