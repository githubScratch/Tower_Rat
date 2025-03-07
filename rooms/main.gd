extends Node2D

@export var level_scenes: Array[PackedScene] = []
@export var wall_scenes: Array[PackedScene] = []
@export var number_of_floors: int = 40
@export var number_of_walls: int = 40
@export var floor_size: Vector2 = Vector2(640, 320)
@export var wall_size: Vector2 = Vector2(640, 320)
@onready var player: PlatformerController2D = $Player
@onready var hud: CanvasLayer = $HUD

@export var special_item_levels: Array[int] = [4, 9, 14]  # 5th, 10th, 15th (zero-based indices)
@export var special_scene: PackedScene  # Assign the special scene in the Inspector

var current_floor_index: int = 0
var max_score: int = 0  # Track the maximum distance descended
var item_collected: bool = false
var highest_level_generated: int = -1  # Tracks the highest level index that has been generated
var levels_to_keep_ahead: int = 10  # How many levels to generate ahead of the player
var highest_wall_generated: int = -1  # Tracks the highest wall index generated

func _ready():
	generate_new_floors(max_score)
	generate_new_walls(max_score)

func _process(delta: float) -> void:
	# Calculate the player's vertical descent
	var descent = player.position.y / 320
	if descent > max_score:
		max_score = int(descent)  
		hud.update_score(max_score) 
		generate_new_floors(max_score)
		generate_new_walls(max_score)
		remove_old_floors(max_score)
		remove_old_walls(max_score)

func remove_old_floors(current_score: int) -> void:
	# Calculate the threshold for removing levels
	var threshold = current_score - 2  # Keep levels up to two floors behind
	
	# Iterate through the children of the level container
	for child in $level_container.get_children():
		# Check the level's vertical position
		var level_index = int(child.position.y / 320)  # Derive level index from position
		if level_index < threshold:
			# Remove the floor if it's below the threshold
			#print(level_index, " removed")
			$level_container.remove_child(child)
			child.queue_free()

func remove_old_walls(current_score: int) -> void:
	# Calculate the threshold for removing walls
	var threshold = current_score - 2  # Keep walls up to two levels behind
	
	# Iterate through the children of the wall container
	for child in $wall_container.get_children():
		# Check the wall's vertical position
		var wall_index = int(child.position.y / wall_size.y)  # Derive wall index
		if wall_index < threshold:
			# Remove the wall if it's below the threshold
			$wall_container.remove_child(child)
			child.queue_free()

func generate_new_floors(current_score: int) -> void:
	# Calculate the target level index to generate up to
	var target_level = current_score + levels_to_keep_ahead
	
	while highest_level_generated < target_level:
		highest_level_generated += 1  # Move to the next level to generate
		
		# Select the scene to use for this level
		var scene
		if highest_level_generated in special_item_levels and not item_collected:
			scene = special_scene  # Use the special scene
		else:
			scene = level_scenes[randi() % level_scenes.size()]  # Use a random scene
		var instance = scene.instantiate()
		instance.position = Vector2(32, highest_level_generated * 320)
		#print("Generated level: ", highest_level_generated)
		$level_container.add_child(instance)

func generate_new_walls(current_score: int) -> void:
	# Calculate the target wall index to generate up to
	var target_wall = current_score + levels_to_keep_ahead
	
	while highest_wall_generated < target_wall:
		highest_wall_generated += 1  # Move to the next wall index to generate
		
		# Select a random wall scene
		var scene = wall_scenes[randi() % wall_scenes.size()]
		var instance = scene.instantiate()
		
		# Position the wall based on its index
		instance.position = Vector2(0, highest_wall_generated * wall_size.y)
		
		# Add the wall to the container
		$wall_container.add_child(instance)
