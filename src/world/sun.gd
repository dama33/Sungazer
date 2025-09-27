extends CharacterBody3D
class_name Sun

var input_direction: Vector3
@onready var on_screen_notifier: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var directional_light: DirectionalLight3D = $DirectionalLight3D
@onready var sun_raycast: RayCast3D = %RayCast3D
@onready var parent = get_parent()
func _ready() -> void:
	
		
	StareChecker.register_sun(self)
	if parent is PathFollow3D:
		if SunData.path_follow != null:
			parent.progress = SunData.path_follow.progress
		SunData.register_path_follow_3D(parent)
		SunData.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
func _process(_delta:float): 
	$DirectionalLight3D.look_at(StareChecker.player.player_camera.global_position)
