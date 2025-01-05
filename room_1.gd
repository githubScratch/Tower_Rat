extends Node2D

func _on_spikes_body_entered(body: Node2D) -> void:
	print("Collision detected with: ", body.name)
	
	if body.is_in_group("player") and body.velocity.y != 0:
		print(body.velocity.y)
		if body.has_method("die_spikes"):
			print("Die_spikes method detected!")
			body.die_spikes()
