extends ColorRect


var condensed_damage: Array[float] = []


func _ready() -> void:
	condensed_damage.resize(4080)
	condensed_damage.fill(0.0)
	#condensed_damage[4000] = 0.7
	#condensed_damage[4001] = 0.7
	#condensed_damage[4002] = 0.7
	#condensed_damage[4003] = 0.7


func _physics_process(_delta: float) -> void:
	var last_damaged_pixel = EyeHealth.last_damaged_pixel
	if last_damaged_pixel == Vector3.ZERO:
		return
	var x_pixel_index = int(last_damaged_pixel.x)
	var y_pixel_index = int(last_damaged_pixel.y)
	var condensed_index = int((floor(float(y_pixel_index) / 16) * 60) + (float(x_pixel_index) / 32))
	var additional_alpha = float(last_damaged_pixel.z * 200.0) / float(EyeHealth.STARTING_HEALTH)
	condensed_damage[condensed_index] = (
				min(
					# convert the damage into a value between 0 and 1
					condensed_damage[condensed_index] + additional_alpha,
					# Don't allow values greater than 1
					1.0
				)
			)
	#var counter = 0
	#for index in range(condensed_damage.size()):
		#if condensed_damage[index] > 0.0:
			#counter += 1
	#print("number of cells with a value set: " + str(counter))
	material.set_shader_parameter("sun_damage", condensed_damage)
