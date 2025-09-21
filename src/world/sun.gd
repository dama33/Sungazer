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
	$DirectionalLight3D.look_at(StareChecker.player.player_camera.global_position)
	if parent is PathFollow3D:
		parent.set_progress(parent.get_progress() + (10 * delta))

func _physics_process(_delta: float) -> void:
	input_direction.z = Input.get_axis("debug_back","debug_forward")
	input_direction.x = Input.get_axis("debug_right", "debug_left")
	
	velocity = input_direction * 50
	move_and_slide()
	
	
