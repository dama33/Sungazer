extends Node


signal blindness_achieved
signal eyes_damaged(current_health: int)


## Total health the eyes should start at 
const STARTING_HEALTH: int = 90000
## The maximum damage that can be inflicted per second
const MAX_DPS: float = 2000


var current_health: int
var is_blindness_achieved: bool = false
#var last_damaged_pixel: Vector3 = Vector3.ZERO


func _ready() -> void:
	current_health = STARTING_HEALTH
	set_physics_process_priority(-2)


#func _physics_process(_delta: float) -> void:
	#last_damaged_pixel = Vector3.ZERO uid://d1aquttp0twy5


func get_current_health() -> int:
	return current_health


func take_damage(dot_product_value: float, time_delta: float) -> void:
	if is_blindness_achieved:
		return
	var damage_amount = int(floor(dot_product_value * time_delta * MAX_DPS))
	if damage_amount == 0:
		return
	#var x_pixel_index = max(min(int(sun_screen_position.x), 1919), 0)
	#var y_pixel_index = max(min(int(sun_screen_position.y), 1079), 0)
	#last_damaged_pixel = Vector3(x_pixel_index, y_pixel_index, damage_amount)
	current_health -= damage_amount
	eyes_damaged.emit(current_health)
	var value = -60 + (dot_product_value * 60)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Eye Burn"), value)
	if current_health < 0:
		blindness_achieved.emit()
