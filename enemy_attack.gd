extends Node

onready var parent = self.get_parent()

var playerInRange = false
export var damage := 20
var didDamage = false

func _on_Attack_body_entered(body):
	if body == get_tree().get_root().get_node(get_tree().current_scene.name+"/"+"Player"):
		playerInRange = true
		
func attack():
	
	if playerInRange && !parent.isAttack && !parent.isJump:
		parent.isAttack = true
		yield(get_tree().create_timer(parent.timeout), "timeout")
		if !parent.dead:
			parent.animPlayer.play("Attack")
			$AttackAudio.play()
	if !parent.animPlayer.is_playing():
		parent.isAttack = false
		didDamage = false
	if parent.animPlayer.current_animation == "Attack" && !didDamage:
		if playerInRange:
			parent.player.health.change_health(-damage)
			didDamage = true


func _on_Attack_body_exited(body):
	if body == get_tree().get_root().get_node(get_tree().current_scene.name+"/"+"Player"):
		playerInRange = false
