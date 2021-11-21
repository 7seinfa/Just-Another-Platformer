extends Node

onready var parent = self.get_parent()
var didDamage = false
export var damage := 30
export var magic1Damage := 60
export var magic1Mana := 20
var scene = load("res://Damage.tscn")
var scene_instance

func attack():
	#### ATTACK ####
	if Input.is_action_just_pressed("Attack") && !parent.isAttack:
		parent.animPlayer.play("Melee")
		$MeleeAttackAudio.play()
		parent.isAttack = true
	elif Input.is_action_just_pressed("Skill1") && !parent.isAttack && int(parent.score.text) >= magic1Mana:
		parent.score.text = str(int(parent.score.text) - magic1Mana)
		parent.animPlayer.play("Magic")
		parent.isAttack = true
		$MagicAnimPlayer.play("magic1")
		$Magic1AttackAudio.play()
		$Magic.visible = true
		parent.magic1Attack = true
	if (!parent.animPlayer.is_playing()):
		parent.isAttack = false
		didDamage = false
		$Magic.visible = false
		$MagicAnimPlayer.play("RESET")
		if parent.magic1Attack && parent.magicEnemy != null:
			scene_instance = scene.instance()
			scene_instance.set_name("damage")
			scene_instance.text = str(magic1Damage)
			scene_instance.rect_position.x = parent.magicEnemy.position.x
			scene_instance.rect_position.y = parent.magicEnemy.position.y - 100
			get_tree().get_root().add_child(scene_instance)
			parent.magicEnemy.health.change_health(-magic1Damage)
			if parent.magicEnemy.health.value<=0:
				parent.score.text = str(int(parent.score.text) + parent.magicEnemy.health.deathPoints)
		parent.magic1Attack = false
	if parent.animPlayer.current_animation=="Melee" && !didDamage:
		if parent.enemy != null:
			scene_instance = scene.instance()
			scene_instance.set_name("damage")
			scene_instance.text = str(damage)
			scene_instance.rect_position.x = parent.enemy.position.x
			scene_instance.rect_position.y = parent.enemy.position.y - 100
			get_tree().get_root().add_child(scene_instance)
			parent.enemy.health.change_health(-damage)
			if parent.enemy.health.value<=0:
				parent.score.text = str(int(parent.score.text) + parent.enemy.health.deathPoints)
			didDamage = true
	
	

func _on_Attack_body_entered(body):
	if body.has_node("Health") && body!=self.parent:
		parent.enemy = body


func _on_Attack_body_exited(body):
	if body.has_node("Health") && body!=self.parent:
		parent.enemy = null


func _on_Area2D_magic_body_entered(body):
	if body.has_node("Health") && body!=self.parent:
		parent.magicEnemy = body


func _on_Area2D_magic_body_exited(body):
	if body.has_node("Health") && body!=self.parent:
		parent.magicEnemy = null
