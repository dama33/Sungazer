extends Node3D
var mouse_sensitivity = .005

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	StareChecker.register_player_camera($Pivot/Camera3D)
	StareChecker.sun_entered_view.connect(_temp_enter)
	StareChecker.sun_exited_view.connect(_temp_exit)
	
func _process(_delta: float):
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		%Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		%Pivot.rotation.x = clamp(%Pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _temp_enter() -> void:
	print("sun entered view")

func _temp_exit() -> void:
	print("sun exited view")
