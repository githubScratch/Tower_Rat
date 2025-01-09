# FireHazard.gd
extends Area2D

@export var descent_speed: float = 65.0  # Pixels per second
@export var damage_amount: int = 1
var light_data = []



func _ready():
	#for node in get_tree().get_nodes_in_group("boom1"):
		#node.play("boom")
	#await get_tree().create_timer(1.75).timeout
	#for node in get_tree().get_nodes_in_group("boom2"):
		#node.play("boom")
	#await get_tree().create_timer(1.0).timeout
	#for node in get_tree().get_nodes_in_group("boom3"):
		#node.play("boom")
	#await get_tree().create_timer(1.5).timeout
	#for node in get_tree().get_nodes_in_group("boom4"):
		#node.play("boom")
	#print("Fire hazard ready. Monitoring: ", monitoring)
	for light in get_children():
		if light is PointLight2D:
			light_data.append({
				"node": light,
				"base_scale": light.scale,
				"base_position": light.position,
				"base_intensity": light.energy
			})

	# Set up the collision shape
	#var collision = CollisionShape2D.new()
	#var shape = RectangleShape2D.new()
	#shape.size = Vector2(1000, 50)  # Adjust width and height as needed
	#collision.shape = shape
	#add_child(collision)
	
	# Set up the visual representation
	#var visual = ColorRect.new()
	#visual.color = Color(1, 0.3, 0, 0.5)  # Semi-transparent orange
	#visual.size = Vector2(1500, 10)  # Match collision shape size
	#visual.position = Vector2(-500, -25)  # Center the rectangle
	#add_child(visual)

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
