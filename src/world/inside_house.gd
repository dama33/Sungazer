extends Node3D

var moving: bool = false

@export var whiteboard_scene: PackedScene
var timer: Timer = Timer.new()

func _physics_process(_delta:float) -> void:
	if moving:
		%PathFollow3D.progress_ratio = lerp(%PathFollow3D.progress_ratio, 1.0, .1)

	
func _on_timer_timeout():
	moving = true
