extends Area2D

func _on_Coin_body_entered(body):
	if body == get_tree().get_root().get_node(get_tree().current_scene.name+"/"+"Player"):
		body.coinScore.text = str(int(body.coinScore.text) + 1)
		body.coinAudio.play()
		get_parent().remove_child(self)

func _ready():
	$AnimationPlayer.play("Spin")
