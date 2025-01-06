extends Node2D
@onready var flask_falls: AnimationPlayer = $Flask/FlaskFalls
var fire_started = false
@onready var fire: Node2D = $fire

func _ready():
	fire.process_mode = Node.PROCESS_MODE_DISABLED

func _on_spikes_body_entered(body: Node2D) -> void:
	print("Collision detected with: ", body.name)
	
	if body.is_in_group("player") and body.velocity.y != 0:
		print(body.velocity.y)
		if body.has_method("die_spikes"):
			print("Die_spikes method detected!")
			body.die_spikes()


func _input(event):
	if event is InputEventKey and event.pressed and !fire_started:
		# Replace "your_animation_name" with the actual animation name
		flask_falls.play("fall")
		fire_started = true
