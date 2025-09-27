extends Node


@export var world_scene: PackedScene
@export var inside_house: PackedScene
var scene_instance: Node


var UI: Control
var world: Node3D
var level: int = 0


func _ready() -> void:
	SignalBus.start_game.connect(_on_start_game)
	EyeHealth.blindness_achieved.connect(_on_blindness_achieved)
	UI = %UI
	world = %World
	SignalBus.swap_levels.connect(_swap_levels)
	_on_start_game.call_deferred()

func _on_start_game() -> void:
	UI.load_game()
	scene_instance = world_scene.instantiate()
	world.add_child(scene_instance)


func _on_blindness_achieved() -> void:
	UI.show_victory_screen()
	world.queue_free()
	
func _swap_levels():
	if level == 0:
		level = 1
		world.remove_child.call_deferred(scene_instance)
		scene_instance = inside_house.instantiate()
		world.add_child.call_deferred(scene_instance)
		StareChecker.set_physics_process(false)
		StareChecker.is_sun_in_view = false
		StareChecker.is_sun_on_screen = false
		%BlindnessDial.visible=false
	elif level == 1:
		level = 0
		world.remove_child.call_deferred(scene_instance)
		scene_instance = world_scene.instantiate()
		world.add_child.call_deferred(scene_instance)
		StareChecker.set_physics_process(true)
		%BlindnessDial.visible=true
		
