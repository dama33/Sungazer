extends WorldEnvironment


const BLUR_INTENSITY: float = 0.25


var camera: CameraAttributesPractical


func _ready() -> void:
	EyeHealth.eyes_damaged.connect(_on_eyes_damaged)
	camera = camera_attributes

func _process(_delta: float) -> void:
	if SunData.process_mode == ProcessMode.PROCESS_MODE_ALWAYS:
		if SunData.path_follow.progress_ratio >.75:
			if environment.sky.sky_material is ProceduralSkyMaterial:
				environment.sky.sky_material.sky_horizon_color = environment.sky.sky_material.sky_horizon_color.lerp(Color("bc610b"),.01)

func _on_eyes_damaged(current_health: int) -> void:
	if current_health > 0:
		var percentage_health = float(current_health) / float(EyeHealth.STARTING_HEALTH)
		camera.dof_blur_amount = (1 - percentage_health) * BLUR_INTENSITY
	else:
		camera.dof_blur_amount = BLUR_INTENSITY
