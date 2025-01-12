extends TileMapLayer

var velocity: Vector2 = Vector2.ZERO
var previous_position: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var current_position = global_position
	velocity = (current_position - previous_position) / delta
	previous_position = current_position

func get_velocity() -> Vector2:
	return velocity
