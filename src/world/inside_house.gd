extends Node3D

@export var whiteboard_scene: PackedScene

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_packed(whiteboard_scene)
