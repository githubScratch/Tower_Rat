extends Node2D

@export var level_scenes: Array[PackedScene] = []
@export var number_of_floors: int = 20
@export var floor_size: Vector2 = Vector2(640, 320)
@onready var player: PlatformerController2D = $Player
@onready var hud: CanvasLayer = $HUD

var current_floor_index: int = 0
var max_score: int = 0  # Track the maximum distance descended

func _ready():
	print(hud)  # This should print something like [CanvasLayer:HUD].
	preload_floors()
	load_floor(current_floor_index)

func preload_floors():
	randomize() # Ensure randomization
	for i in range(number_of_floors):
		var scene = level_scenes[randi() % level_scenes.size()]
		var instance = scene.instantiate()
		instance.position = Vector2(0, i * floor_size.y)
		$level_container.add_child(instance)
		# Set alternating delay
		if i % 2 == 0:
			instance.start_with_delay = false
		else:
			instance.start_with_delay = true

func load_floor(index: int):
	# Adjust camera or player position to focus on the current floor.
	pass

func _process(delta: float) -> void:
	# Calculate the player's vertical descent
	var descent = player.position.y / 100
	if descent > max_score:
		max_score = int(descent)  
		hud.update_score(max_score) 
