extends Control
@onready var begin_button: Button = $ColorRect/VBoxContainer/begin_Button
@onready var beam: ColorRect = $beam
@onready var distortion: TextureRect = $distortion

func _ready() -> void:
	begin_button.grab_focus()

func _on_begin_button_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/Main.tscn")


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://rooms/options_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_begin_button_focus_entered() -> void:
	beam.offset_bottom = 150
	distortion.position.y = -130
	

func _on_options_button_focus_entered() -> void:
	beam.offset_bottom = 205
	distortion.position.y = -100

func _on_quit_button_focus_entered() -> void:
	beam.offset_bottom = 260
	distortion.position.y = -75
