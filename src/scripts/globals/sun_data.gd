extends Node

var path_follow: PathFollow3D

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	path_follow.progress += 4*delta
	if 1-path_follow.progress_ratio <0.001:
		SignalBus.game_over.emit()
	
func register_path_follow_3D(path_follow_value: PathFollow3D):
	path_follow = path_follow_value
