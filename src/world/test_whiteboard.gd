extends Node2D

var correct_count:int = 0
var layer:int = 1
var next_layer_target:int = 1
var current_camera:int = 0
var direction:int = -1
@export var array: Array[Node2D]
var target_position:Vector2 

func _ready() -> void:
	%GreenBox.position = array[0].position
	%GreenBox.scale = Vector2(.04,.04)
	target_position = array[0].position

func _process(_delta: float) -> void:
	if %GreenBox.position.distance_to(target_position) > 0.001:
		%GreenBox.position = lerp(%GreenBox.position, target_position, .1)
	
	if Input.is_action_just_pressed("debug_forward"):
		direction = 0
	if Input.is_action_just_pressed("debug_right"):
		direction = 90
	if Input.is_action_just_pressed("debug_back"):
		direction = 180
	if Input.is_action_just_pressed("debug_left"):
		direction = 270
	if direction == int(rad_to_deg(array[correct_count].rotation)):
		if correct_count >= array.size()-1:
			SignalBus.swap_levels.emit()
		else:	
			correct_count+=1
			print(correct_count)
			target_position = array[correct_count].position

	if correct_count >= next_layer_target:
		layer += 1
		next_layer_target += layer
	match layer:
		1:
			%GreenBox.scale = Vector2(.04,.04)
		2:
			%GreenBox.scale = Vector2(.03,.03)
		3:
			%GreenBox.scale = Vector2(.02,.02)
		_:
			%GreenBox.scale = Vector2(.01,.01)
	direction = -1
