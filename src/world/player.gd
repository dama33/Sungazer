extends Area3D
class_name Player

var mouse_sensitivity = .005
var eye_health:float = 1000
var DAMAGE_MODIFER = 1
@onready var player_camera = $Pivot/Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	StareChecker.register_player(self)
	StareChecker.sun_entered_view.connect(_temp_enter)
	StareChecker.sun_exited_view.connect(_temp_exit)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		%Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		%Pivot.rotation.x = clamp(%Pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func take_damage(dot_product_value: float) -> bool:
	eye_health-= dot_product_value*DAMAGE_MODIFER
	print(eye_health)
	if(eye_health < 0):
		return false
	return true

func _temp_enter() -> void:
	print("sun entered view")

func _temp_exit() -> void:
	print("sun exited view")
