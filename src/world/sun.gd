extends CharacterBody3D
class_name Sun

var input_direction: Vector3
@onready var on_screen_notifier: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var directional_light: DirectionalLight3D = $DirectionalLight3D
@onready var sun_raycast: RayCast3D = %RayCast3D
@onready var parent = get_parent()
func _ready() -> void:
	StareChecker.register_sun(self)
	
func _process(delta:float): 
	$DirectionalLight3D.look_at(StareChecker.player.collision_shape.global_position)
	if parent is PathFollow3D:
		parent.set_progress(parent.get_progress() + (10 * delta))
