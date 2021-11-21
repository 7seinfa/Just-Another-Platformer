extends Node

const UP = Vector2(0,-1)
const GRAVITY = 30
const MAXFALL = 200
export var ACCELERATION := 40
export var JUMPFORCE := 600
export var MAXSPEED := 300

var motion = Vector2()
var facing_right = true
var roared = false

onready var parent = self.get_parent()

func _ready():
	pass # Replace with function body.

func movement():
	horizontal_movement()
	vertical_movement()
	
	motion = parent.move_and_slide(motion, UP)


func _on_Movement_body_entered(body):
	if body == get_tree().get_root().get_node(get_tree().current_scene.name+"/"+"Player"):
		parent.player = body
		if !roared:
			$GrowlAudio.play()
			roared = true


func _on_Movement_body_exited(body):
	if body == get_tree().get_root().get_node(get_tree().current_scene.name+"/"+"Player"):
		parent.player = null

func vertical_movement():
	motion.y += GRAVITY
	if motion.y > MAXFALL:
		motion.y = MAXFALL
	
	#### JUMP ####
	if $Wall.is_colliding() && parent.is_on_floor() && !parent.isAttack && parent.player != null:
		motion.y = -JUMPFORCE
		parent.animPlayer.play("Jumping")
		parent.isJump = true
	elif !parent.is_on_floor():
		if motion.y > 0:
			motion.y += GRAVITY*5
			if parent.isJump:
				parent.animPlayer.play("Falling")
			parent.isJump = false

func horizontal_movement():
	#### LEFT AND RIGHT MOVEMENT ####
	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
	if parent.player != null && !parent.isAttack:
		var dir = parent.position.direction_to(parent.player.position)
		if (dir.x > 0):
			facing_right = true
		elif (dir.x < 0):
			facing_right = false
		motion.x += dir.x * ACCELERATION
		if parent.is_on_floor():
			parent.animPlayer.play("Running")
	elif !parent.isAttack && parent.is_on_floor() && parent.player == null:
		if !(($Wall.is_colliding()&&$Wall2.is_colliding()) || ($Wall2.is_colliding()&&!$Ground.is_colliding())):
			if !$Ground.is_colliding():
				facing_right = !facing_right
				motion.x = 0
			if $Wall.is_colliding():
				facing_right = !facing_right
				motion.x = 0
			parent.animPlayer.play("Running")
			var move_direction = 1 if facing_right else -1
			motion.x = move_direction * ACCELERATION * 5
		else:
			motion.x = lerp(motion.x,0,0.2)
			if parent.is_on_floor() && !parent.isAttack:
				parent.animPlayer.play("Idle")
			
			
