extends RigidBody2D

func _integrate_forces(state):
	for contact in state.get_contact_count():
		var collider = state.get_contact_collider_object(contact)
		if collider.name == "player":
			var contact_point = state.get_contact_local_position(contact)
			var impact_force = Vector2(0, -300)  # Apply a downward force.
			apply_impulse(contact_point, impact_force)


func _on_timer_timeout() -> void:
	var wind_force = Vector2(randf() * 1750 - 500, 0)  # Random horizontal force.
	apply_impulse(Vector2.ZERO, wind_force)
	apply_torque_impulse(randf() * 5 - 2.5)  # Add slight rotation.
