extends Node2D


export(Resource) var scene := load("res://Level2.tscn")

func _physics_process(delta):
	if $Player.coinScore.text == '5':
		Global.playerHealth = $Player.health.value
		Global.playerMana = int($Player.score.text)
		get_tree().change_scene_to(scene)
