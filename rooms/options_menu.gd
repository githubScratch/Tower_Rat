extends Control
@onready var controls_button: Button = $ColorRect/VBoxContainer/controls_Button
@onready var beam: ColorRect = $beam
@onready var distortion: TextureRect = $distortion

func _ready() -> void:
	controls_button.grab_focus()


func _on_reset_button_pressed() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/start_menu.tscn")


func _on_controls_button_focus_entered() -> void:
	beam.offset_bottom = 150
	distortion.position.y = -130


func _on_reset_button_focus_entered() -> void:
	beam.offset_bottom = 205
	distortion.position.y = -100


func _on_back_button_focus_entered() -> void:
	beam.offset_bottom = 260
	distortion.position.y = -75
