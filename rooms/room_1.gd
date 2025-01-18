extends Node2D

var velocity: Vector2 = Vector2.ZERO
var previous_position: Vector2 = Vector2.ZERO


@export var pan_distance: float = -200
@export var pan_duration: float = 12
@export var pan_delay: float = 4
@export var start_with_delay: bool = false

func _ready():
	if start_with_delay:
		await get_tree().create_timer(4).timeout
	#start_panning()

#func start_panning():
	# Get starting and target positions
	var start_position = position
	var target_position = position + Vector2(pan_distance, 0)

	# Create a tween using create_tween()
	var tween = create_tween()

	# Tween to the target position
	tween.tween_property(self, "position", target_position, pan_duration / 2)

	# Add a callback to tween back after reaching the target
	tween.tween_property(self, "position", start_position, pan_duration / 2).set_delay(pan_duration / 2)

	# Set it to loop indefinitely
	tween.set_loops()


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
