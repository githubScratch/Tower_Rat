extends Node2D

var velocity: Vector2 = Vector2.ZERO
var previous_position: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var current_position = global_position
	velocity = (current_position - previous_position) / delta
	previous_position = current_position

func get_velocity() -> Vector2:
	return velocity

func _on_spikes_body_entered(body: Node2D) -> void:
	print("Collision detected with: ", body.name)
	
	if body.is_in_group("player") and body.velocity.y > 0:
		print("Player velovity at spikes: ", body.velocity.y)
		if body.has_method("die_spikes"):
			print("Die_spikes method detected!")
			body.die_spikes()
	elif body.is_in_group("player"):
		print("Player velocity failed check: ",body.velocity.y)
