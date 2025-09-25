extends Node2D

var correct_count:int = 0
var layer:int = 1
var next_layer_target:int = 1
var current_camera:int = 0
var direction:int = -1
@export var array: Array[Node2D]
@export var camera_array: Array[Camera2D]

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_forward"):
		direction = 0
	if Input.is_action_just_pressed("debug_right"):
		direction = 90
	if Input.is_action_just_pressed("debug_back"):
		direction = 180
	if Input.is_action_just_pressed("debug_left"):
		direction = 270
	if direction == int(rad_to_deg(array[correct_count].rotation)):
		correct_count+=1
		print(correct_count)

	if correct_count >= next_layer_target:
		layer += 1
		next_layer_target += layer
		%Camera2D.limit_top = %Camera2D.limit_bottom
		%Camera2D.limit_bottom += 30
		current_camera+=1
		camera_array[current_camera].make_current()
	
	direction = -1
