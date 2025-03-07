extends Control
@onready var controls_button: Button = $ColorRect/VBoxContainer/controls_Button
@onready var beam: ColorRect = $beam
@onready var distortion: TextureRect = $distortion

@onready var select_sfx: AudioStreamPlayer2D = $selectSFX
@onready var focus_sfx: AudioStreamPlayer2D = $focusSFX



func _ready() -> void:
	controls_button.grab_focus()


func _on_reset_button_pressed() -> void:
	select_sfx.play()


func _on_back_button_pressed() -> void:
	select_sfx.play()
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_file("res://rooms/start_menu.tscn")


func _on_controls_button_focus_entered() -> void:
	beam.offset_bottom = 150
	distortion.position.y = -130
	focus_sfx.play()

func _on_reset_button_focus_entered() -> void:
	beam.offset_bottom = 205
	distortion.position.y = -100
	focus_sfx.play()

func _on_back_button_focus_entered() -> void:
	beam.offset_bottom = 260
	distortion.position.y = -75
	focus_sfx.play()

func _on_controls_button_pressed() -> void:
	select_sfx.play()
