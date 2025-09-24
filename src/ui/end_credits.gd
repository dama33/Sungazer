extends Control


const FINAL_SUNGLASSES_POSITION = Vector2(775, 538)
const TIME_TO_FALL_SECONDS = 4


var time_elapsed_seconds: float = 0
var glasses: Sprite2D


func _ready() -> void:
	glasses = $Glasses


func _process(delta: float) -> void:
	time_elapsed_seconds += delta
	if time_elapsed_seconds >= TIME_TO_FALL_SECONDS:
		glasses.position = FINAL_SUNGLASSES_POSITION
		set_process(false)
		return
	var animation_percent = time_elapsed_seconds / TIME_TO_FALL_SECONDS
	glasses.position = Vector2(FINAL_SUNGLASSES_POSITION.x, FINAL_SUNGLASSES_POSITION.y * animation_percent)
