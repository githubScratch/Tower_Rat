extends Control
@onready var begin_button: Button = $ColorRect/VBoxContainer/begin_Button
@onready var beam: ColorRect = $beam
@onready var distortion: TextureRect = $distortion
@onready var begin_sfx: AudioStreamPlayer2D = $beginSFX
@onready var select_sfx: AudioStreamPlayer2D = $selectSFX
@onready var focus_sfx: AudioStreamPlayer2D = $focusSFX

func _ready() -> void:
	begin_button.grab_focus()

func _on_begin_button_pressed() -> void:

	begin_sfx.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://rooms/Main.tscn")


func _on_options_button_pressed() -> void:
	select_sfx.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://rooms/options_menu.tscn")

func _on_quit_button_pressed() -> void:
	begin_sfx.play()
	await get_tree().create_timer(1).timeout
	get_tree().quit()


func _on_begin_button_focus_entered() -> void:
	beam.offset_bottom = 150
	distortion.position.y = -130
	focus_sfx.play()

func _on_options_button_focus_entered() -> void:
	beam.offset_bottom = 205
	distortion.position.y = -100
	focus_sfx.play()
	
func _on_quit_button_focus_entered() -> void:
	beam.offset_bottom = 260
	distortion.position.y = -75
	focus_sfx.play()
