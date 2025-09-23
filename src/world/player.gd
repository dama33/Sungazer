extends CharacterBody3D
class_name Player

var mouse_sensitivity: float = .005
@onready var player_camera: Camera3D = %Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
var FOV_DEFAULT
@onready var animation_tree: AnimationTree = $AnimationTree

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
	velocity = direction * 400 * delta
	var state_machine = animation_tree["parameters/playback"]
	if velocity.length()>0:
		state_machine.travel("Run")
	else:
		state_machine.travel("Idle")
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
