extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animated_sprite_2d.play("default")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("rip")
