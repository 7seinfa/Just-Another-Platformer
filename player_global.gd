extends KinematicBody2D

var isAttack = false
var magic1Attack = false
onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var health = $CanvasLayer/Health
onready var coinScore = $CanvasLayer/Coin
onready var colShape = $CollisionShape2D
onready var crouchShape = $CrouchShape
onready var score = $CanvasLayer/Score
onready var meleeDamage = $MeleeDamage
onready var coinAudio = $CoinAudio
onready var roof = $roof
var enemy = null
var magicEnemy = null
var dead = false
var points = 0

func _ready():
	health.value = Global.playerHealth
	score.text  = str(Global.playerMana)

func _physics_process(delta):
	var move_direction = 1 if $Movement.facing_right else -1
	sprite.scale.x = abs($Sprite.scale.x) * move_direction
	$CollisionShape2D.scale.x = move_direction
	$CollisionShape2D.position.x = abs($CollisionShape2D.position.x) * move_direction
	$Attack.scale.x = abs($Attack.scale.x) * move_direction
	
	if health.value > 0:
		$Movement.movement()
		$Attack.attack()
	elif dead == false:
		dead = true
		animPlayer.play("Dying")
		$DyingAudio.play()
		Global.currScene = load("res:///"+get_tree().get_current_scene().get_name()+".tscn")
		Global.playerHealth = 100
		Global.playerMana = 0
	else:
		if !animPlayer.is_playing() && !$DyingAudio.is_playing():
			get_tree().change_scene("res://GameOver.tscn")
