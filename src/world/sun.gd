extends MeshInstance3D


func _ready() -> void:
	StareChecker.register_sun_stuff($VisibleOnScreenNotifier3D, $RayCast3D)
