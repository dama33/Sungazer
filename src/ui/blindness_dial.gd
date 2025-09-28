extends Control


const MIN_ROTATION = -90.0
const MAX_ROTATION = 63.0
const TOTAL_ROTATION = MAX_ROTATION - MIN_ROTATION


var progress_arrow: Control


func _ready() -> void:
	EyeHealth.eyes_damaged.connect(_on_eyes_damaged)
	progress_arrow = $ProgressArrow
	progress_arrow.rotation_degrees = MIN_ROTATION
	#progress_arrow.pivot_offset = Vector2(progress_arrow.size.x / 2, progress_arrow.size.y)


func _on_eyes_damaged(current_health: int) -> void:
	var percent_damaged = float(EyeHealth.STARTING_HEALTH - current_health) / float(EyeHealth.STARTING_HEALTH)
	progress_arrow.rotation_degrees = (percent_damaged * TOTAL_ROTATION) + MIN_ROTATION
