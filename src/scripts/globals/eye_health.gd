extends Node


signal blindness_achieved
signal eyes_damaged(current_health: int)


## Total health the eyes should start at 
const STARTING_HEALTH: int = 100000
## The maximum damage that can be inflicted per second
const MAX_DPS: float = 2000


var current_health: int
var is_blindness_achieved: bool = false
var damage_by_pixel: Array[Array] = []


func _ready() -> void:
	current_health = STARTING_HEALTH
	# Initialize a 2D array of all the pixels on the screen
	damage_by_pixel.resize(1080)
	for pixel_row in range(1080):
		var row_array = []
		row_array.resize(1920)
		row_array.fill(0)
		damage_by_pixel[pixel_row] = row_array


func get_current_health() -> int:
	return current_health


func take_damage(dot_product_value: float, sun_screen_position: Vector2, time_delta: float) -> void:
	if is_blindness_achieved:
		return
	var damage_amount = int(floor(dot_product_value * time_delta * MAX_DPS))
	if damage_amount == 0:
		return
	var x_pixel_index = max(min(int(sun_screen_position.x), 1919), 0)
	var y_pixel_index = max(min(int(sun_screen_position.y), 1079), 0)
	damage_by_pixel[y_pixel_index][x_pixel_index] += damage_amount
	current_health -= damage_amount
	eyes_damaged.emit(current_health)
	var value = -60 + (dot_product_value * 60)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	if current_health < 0:
		blindness_achieved.emit()
