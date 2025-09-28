extends Node2D

var current_position:Vector2

var line_array: Array[Vector2] = []
var array_array: Array[Array] = []
var index: int = 0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		current_position = get_tree().get_root().get_mouse_position()
		print(current_position)
		line_array.append(Vector2(current_position.x - 500, current_position.y - 150))
		queue_redraw()
	elif Input.is_action_just_released("left_click"):
		if(line_array.size()>=2):
			array_array.append(line_array)
		line_array = []
		
func _draw() -> void:
	
	if line_array.size()>=2:
		draw_polyline(line_array,Color.BLACK, 20)
	for entry in array_array:
		draw_polyline(entry,Color.BLACK,20)
