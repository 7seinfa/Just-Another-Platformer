extends KinematicBody2D

var isAttack = false
var isJump = false
var player = null
onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var health = $Health
onready var followArea
var dead = false
export var timeout := 1.0

func _physics_process(delta):
	var move_direction = 1 if $Movement.facing_right else -1
	sprite.scale.x = abs($Sprite.scale.x) * move_direction
	$CollisionShape2D.scale.x = move_direction
	$CollisionShape2D.position.x = abs($CollisionShape2D.position.x) * move_direction
	$Attack.scale.x = abs($Attack.scale.x) * move_direction
	$Attack.position.x = abs($Attack.position.x) * move_direction
	$Movement.scale.x = abs($Movement.scale.x) * move_direction
	$Movement.position.x = abs($Movement.position.x) * move_direction
	
	if health.value>0:
		$Attack.attack()
		$Movement.movement()
	elif !dead:
		dead = true
		animPlayer.play("Dying")
		$DyingAudio.play()
	else:
		if !animPlayer.is_playing() && !$DyingAudio.is_playing():
			get_parent().remove_child(self)
