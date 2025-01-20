extends Node2D

@export var level_scenes: Array[PackedScene] = []
@export var wall_scenes: Array[PackedScene] = []
@export var number_of_floors: int = 40
@export var number_of_walls: int = 40
@export var floor_size: Vector2 = Vector2(640, 320)
@export var wall_size: Vector2 = Vector2(640, 320)
@onready var player: PlatformerController2D = $Player
@onready var hud: CanvasLayer = $HUD

var current_floor_index: int = 0
var max_score: int = 0  # Track the maximum distance descended

func _ready():
	preload_floors()
	preload_walls()
	#load_floor(current_floor_index)

func preload_floors():
	randomize() # Ensure randomization
	for i in range(number_of_floors):
		var scene = level_scenes[randi() % level_scenes.size()]
		var instance = scene.instantiate()
		instance.position = Vector2(32, i * floor_size.y)
		$level_container.add_child(instance)
		# Set alternating delay
		if i % 2 == 0:
			instance.start_with_delay = false
		else:
			instance.start_with_delay = true

func preload_walls():
	randomize() # Ensure randomization
	for i in range(number_of_walls):
		var scene = wall_scenes[randi() % wall_scenes.size()]
		var instance = scene.instantiate()
		instance.position = Vector2(0, i * wall_size.y)
		$wall_container.add_child(instance)

func load_floor(index: int):
	# Adjust camera or player position to focus on the current floor.
	pass

func _process(delta: float) -> void:
	# Calculate the player's vertical descent
	var descent = player.position.y / 340
	if descent > max_score:
		max_score = int(descent)  
		hud.update_score(max_score) 
