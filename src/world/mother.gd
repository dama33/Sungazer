extends CharacterBody3D
class_name Mother

var mother_speed = 10
var target_position: Vector3
var state: State
var game_over_ui: PackedScene = preload("uid://c67s7krlh3p17")
@export var position_list: Array[Node3D]
var current_index:int

enum State{
	GOING_UP,
	LOOKING,
	GOING_DOWN,
	IDLE
}

func _ready() -> void:
	state = State.IDLE
	SignalBus.mother_movement_start.connect(_mother_movement_start)
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	var magnitude = 0 
	if state == State.GOING_UP:
		magnitude = delta * 3
	elif state == State.GOING_DOWN:
		magnitude = delta * 5 
	position = position.move_toward(target_position,magnitude)
	if state == State.GOING_UP && abs(position.y) < 0.001:
		%Rumbling.stop()
		state = State.LOOKING
		%LookTimer.start()
	elif state == State.GOING_DOWN && abs(position.y+17.26) < 0.001:
		%Rumbling.stop()
		SignalBus.mother_movement_end.emit()
		set_physics_process(false)

func _process(_delta: float) -> void:
	if  state == State.LOOKING && !StareChecker.is_visibility_obstructed(%RayCast3D):
		add_child(game_over_ui.instantiate())

func _mother_movement_start():
	current_index = randi() % 4
	position = position_list.get(current_index).position
	rotation = position_list.get(current_index).global_rotation
	state = State.GOING_UP
	target_position = Vector3(position.x, 0, position.z)
	%Rumbling.play()
	set_physics_process(true)


func _on_look_timer_timeout() -> void:
	state = State.GOING_DOWN
	target_position = Vector3(position.x, -17.26, position.z)
	%Rumbling.play()
