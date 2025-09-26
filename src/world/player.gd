extends CharacterBody3D
class_name Player

var move_velocity: int = 2500
var mouse_sensitivity: float = .005
@onready var player_camera: Camera3D = $Pivot/Camera3D
var FOV_DEFAULT

func _exit_tree() -> void:
	StareChecker.sun_entered_view.disconnect(_temp_enter)
	StareChecker.sun_exited_view.disconnect(_temp_exit)

func _ready():
	StareChecker.register_player(self)
	FOV_DEFAULT = player_camera.fov
	random_time_for_countdown_start_timer()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	StareChecker.sun_entered_view.connect(_temp_enter)
	StareChecker.sun_exited_view.connect(_temp_exit)
	SignalBus.mother_movement_end.connect(%CountdownStartTimer.start)

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("debug_left","debug_right","debug_forward","debug_back")
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	velocity = direction * move_velocity * delta
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion && Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		rotate_y(-event.relative.x * mouse_sensitivity)
		%Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		%Pivot.rotation.x = clamp(%Pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func random_time_for_countdown_start_timer():
	%CountdownStartTimer.wait_time = (randf()*6)+5

func _temp_enter() -> void:
	print("sun entered view")
	%Sizzle.play()
	

func _temp_exit() -> void:
	print("sun exited view")
	%Sizzle.stop()

func _on_countdown_start_timer_timeout() -> void:
	SignalBus.mother_movement_start.emit()
	random_time_for_countdown_start_timer()
