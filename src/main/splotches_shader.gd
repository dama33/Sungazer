extends ColorRect


var condensed_damage: Array[float] = []
var time_since_last_update: float = 0


func _ready() -> void:
	condensed_damage.resize(4080)
	condensed_damage.fill(0.0)
	#condensed_damage[4000] = 0.7
	#condensed_damage[4001] = 0.7
	#condensed_damage[4002] = 0.7
	#condensed_damage[4003] = 0.7


func _process(delta: float) -> void:
	time_since_last_update += delta
	if time_since_last_update < 1:
		return
	var damage_by_pixel = EyeHealth.damage_by_pixel
	var y_size = damage_by_pixel.size()
	var x_size = damage_by_pixel[0].size()
	var og_counter = 0
	for pixel_y_index in range(y_size):
		for pixel_x_index in range(x_size):
			var condensed_index = (floor(pixel_y_index / 16) * 60) + (pixel_x_index / 32)
			# Keep in mind that multiple pixels will write to the same condensed group,
			# so we have to add the alpha values rather than setting them each time.
			var additional_alpha = float(damage_by_pixel[pixel_y_index][pixel_x_index] * 200) / float(EyeHealth.STARTING_HEALTH)
			#condensed_damage[condensed_index] = float(condensed_index) / float(condensed_damage.size())
			condensed_damage[condensed_index] = (
				min(
					# convert the damage into a value between 0 and 1
					condensed_damage[condensed_index] + additional_alpha,
					# Don't allow values greater than 1
					1.0
				)
			)
			#if damage_by_pixel[pixel_y_index][pixel_x_index] > 0:
				#print(str(float(damage_by_pixel[pixel_y_index][pixel_x_index] * 20) / float(EyeHealth.STARTING_HEALTH)))
				#print(str(condensed_damage[(floor(pixel_y_index / 16) * 60) + (pixel_x_index / 32)]))
				#og_counter += 1
	print("OG cells with a value set: " + str(og_counter))
	var counter = 0
	for index in range(condensed_damage.size()):
		if condensed_damage[index] > 0.0:
			counter += 1
	print("number of cells with a value set: " + str(counter))
	material.set_shader_parameter("sun_damage", condensed_damage)
	time_since_last_update = 0
