extends Node


signal blindness_achieved
signal eyes_damaged(current_health: int)


## Total health the eyes should start at 
const STARTING_HEALTH: int = 10000
## The maximum damage that can be inflicted per second
const MAX_DPS: float = 2000


var current_health: int
var is_blindness_achieved: bool = false


func _ready() -> void:
	current_health = STARTING_HEALTH


func get_current_health() -> int:
	return current_health


func take_damage(dot_product_value: float, time_delta: float) -> void:
	if is_blindness_achieved:
		return
	var damage_amount = int(floor(dot_product_value * time_delta * MAX_DPS))
	if damage_amount == 0:
		return
	current_health -= damage_amount
	eyes_damaged.emit(current_health)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -60 + (dot_product_value * 60))
	if current_health < 0:
		blindness_achieved.emit()
