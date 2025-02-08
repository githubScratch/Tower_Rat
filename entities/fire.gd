# FireHazard.gd
extends Area2D

@export var descent_speed: float = 0.0  # Pixels per second
@export var damage_amount: int = 1

var light_data = []



func _ready():
	for light in get_children():
		if light is PointLight2D:
			light_data.append({
				"node": light,
				"base_scale": light.scale,
				"base_position": light.position,
				"base_intensity": light.energy
			})
	await get_tree().create_timer(2).timeout
	descent_speed = 60
	await get_tree().create_timer(25).timeout
	descent_speed += 20
	await get_tree().create_timer(25).timeout
	descent_speed += 20
	await get_tree().create_timer(25).timeout
	descent_speed += 20
	await get_tree().create_timer(25).timeout
	descent_speed += 20
	await get_tree().create_timer(25).timeout
	descent_speed += 20

func _physics_process(delta):
	# Move the fire hazard downward
	position.y += descent_speed * delta

	for data in light_data:
		var light = data["node"]

		# Flicker intensity
		var intensity_variation = randf() * 0.2 - 0.1  # ±10%
		light.energy = data["base_intensity"] + intensity_variation

		# Flicker position
		var pos_variation = Vector2(randf() * 4 - 2, randf() * 4 - 2)  # ±2 px
		light.position = data["base_position"] + pos_variation

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("die_fire"):
			body.die_fire()
			Engine.time_scale = 1.0


func _on_slow_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Engine.time_scale = 0.5

func _on_slow_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		Engine.time_scale = 1.0
