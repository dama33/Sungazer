extends CharacterBody3D

var input_direction: Vector3

func _ready() -> void:
	StareChecker.register_sun_stuff($VisibleOnScreenNotifier3D, $RayCast3D)
	
func _process(_delta:float): 
	$DirectionalLight3D.look_at(StareChecker.player.player_camera.global_position)

func _physics_process(delta: float) -> void:
	input_direction.z = Input.get_axis("debug_back","debug_forward")
	input_direction.x = Input.get_axis("debug_right", "debug_left")
	
	velocity = input_direction * 10
	move_and_slide()
	
	
