extends Node


@export var world_scene: PackedScene


var UI: Control
var world: Node3D


func _ready() -> void:
	SignalBus.start_game.connect(_on_start_game)
	EyeHealth.blindness_achieved.connect(_on_blindness_achieved)
	UI = %UI
	world = %World


func _on_start_game() -> void:
	UI.load_game()
	var world_scene_instance = world_scene.instantiate()
	world.add_child(world_scene_instance)


func _on_blindness_achieved() -> void:
	UI.show_victory_screen()
	world.queue_free()
