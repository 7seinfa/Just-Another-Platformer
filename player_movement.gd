extends Node

const UP = Vector2(0,-1)
const GRAVITY = 30
const MAXFALL = 200
const ACCELERATION = 60
const JUMPFORCE = 1000
const MAXSPEED = 500

var motion = Vector2()
var facing_right = true
var isJump = false
var isCrouch = false
onready var parent = self.get_parent()

func movement():
	horizontal_movement()
	vertical_movement()
	motion = parent.move_and_slide(motion, UP)


func horizontal_movement():
	#### LEFT AND RIGHT MOVEMENT ####
	motion.x = clamp(motion.x,-MAXSPEED,MAXSPEED)
	if Input.is_action_pressed("Right") && !parent.magic1Attack:
		motion.x += ACCELERATION
		facing_right = true
		if parent.is_on_floor() && !parent.isAttack && !isCrouch:
			parent.animPlayer.play("Running")
	elif Input.is_action_pressed("Left") && !parent.magic1Attack:
		motion.x -= ACCELERATION
		facing_right = false
		if parent.is_on_floor() && !parent.isAttack && !isCrouch:
			parent.animPlayer.play("Running")
	elif !parent.magic1Attack:
		motion.x = lerp(motion.x,0,0.2)
		if parent.is_on_floor() && !parent.isAttack && !isCrouch:
			parent.animPlayer.play("Idle")


func vertical_movement():
	#### JUMP ####
	motion.y += GRAVITY
	if motion.y > MAXFALL:
		motion.y = MAXFALL
	
	if parent.is_on_floor() && !parent.isAttack:
		if Input.is_action_just_pressed("Jump"):
			$JumpAudio.play()
			motion.y = -JUMPFORCE
			parent.animPlayer.play("Jumping")
			isJump = true
		elif Input.is_action_pressed("Crouch"):
			parent.animPlayer.play("Crouching")
			isCrouch = true
	else:
		if motion.y > 0:
			motion.y += GRAVITY*5
			if isJump:
				parent.animPlayer.play("Falling")
			isJump = false
	
	print(parent.roof.is_colliding())
	if !Input.is_action_pressed("Crouch") && !parent.roof.is_colliding():
		isCrouch = false
	
	if isCrouch:
		parent.crouchShape.disabled = false
		parent.colShape.disabled = true
	else:
		parent.crouchShape.disabled = true
		parent.colShape.disabled = false
