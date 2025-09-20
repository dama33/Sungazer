extends WorldEnvironment


const BLUR_INTENSITY: float = 0.15


var camera: CameraAttributesPractical


func _ready() -> void:
	EyeHealth.eyes_damaged.connect(_on_eyes_damaged)
	camera = camera_attributes


func _on_eyes_damaged(current_health: int) -> void:
	if current_health > 0:
		var percentage_health = float(current_health) / float(EyeHealth.STARTING_HEALTH)
		camera.dof_blur_amount = (1 - percentage_health) * BLUR_INTENSITY
	else:
		camera.dof_blur_amount = BLUR_INTENSITY
