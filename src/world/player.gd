extends Area3D
class_name Player

var mouse_sensitivity:float = .005
var eye_health:float = 1000
var DAMAGE_MODIFER:float = 1
var currently_looking:bool = false
@onready var player_camera = $Pivot/Camera3D
@onready var game_over_ui = preload("res://src/ui/game_over_ui.tscn")

func _ready():
	random_time_for_mom_timer()
	random_time_for_countdown_start_timer()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	StareChecker.register_player(self)
	StareChecker.sun_entered_view.connect(_temp_enter)
	StareChecker.sun_exited_view.connect(_temp_exit)
	
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

func take_damage(dot_product_value: float) -> bool:
	eye_health-= dot_product_value*DAMAGE_MODIFER
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -60 + (dot_product_value*60))
	if(eye_health < 0):
		return false
	return true

func random_time_for_countdown_start_timer():
	%CountdownStartTimer.wait_time = (randf()*6)+2

func random_time_for_mom_timer():
	%MomTimer.wait_time = (randf()*4)+1

func _temp_enter() -> void:
	print("sun entered view")
	currently_looking = true
	%Sizzle.play()
	

func _temp_exit() -> void:
	print("sun exited view")
	currently_looking = false
	%Sizzle.stop()


func _on_countdown_start_timer_timeout() -> void:
	%Danger.play()
	random_time_for_countdown_start_timer()
	%MomTimer.start()


func _on_mom_timer_timeout() -> void:
	%Danger.stop()
	if currently_looking:
		add_child(game_over_ui.instantiate())
	random_time_for_mom_timer()
	%CountdownStartTimer.start()
