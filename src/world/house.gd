extends Node3D


enum DoorAnimation {
	NONE,
	OPENING,
	CLOSING,
}

## The degree of rotation from 0 that is the maximum distance the door can rotate
const DOOR_OPEN_ROTATION = -70
## Number of degrees the door rotates per second during the animation
const ROTATION_PER_SECOND = 50


var door_rotation_point: Node3D
var current_animation: DoorAnimation = DoorAnimation.NONE


func _ready():
	door_rotation_point = $DoorRotationPoint
	set_physics_process(false)
	SignalBus.close_door.connect(close_door)
	SignalBus.open_door.connect(open_door)


func _physics_process(delta: float) -> void:
	if current_animation == DoorAnimation.OPENING:
		door_rotation_point.rotation_degrees.y = max(
			DOOR_OPEN_ROTATION,
			door_rotation_point.rotation_degrees.y - (ROTATION_PER_SECOND * delta),
		)
	elif current_animation == DoorAnimation.CLOSING:
		door_rotation_point.rotation_degrees.y = min(
			0,
			door_rotation_point.rotation_degrees.y + (ROTATION_PER_SECOND * delta),
		)

	if is_door_open() or is_door_closed():
		current_animation = DoorAnimation.NONE
		set_physics_process(false)
		if is_door_open():
			SignalBus.door_opened.emit()
		if is_door_closed():
			SignalBus.door_closed.emit()


func is_door_open() -> bool:
	return is_equal_approx(door_rotation_point.rotation_degrees.y, DOOR_OPEN_ROTATION)


func is_door_closed() -> bool:
	return is_equal_approx(door_rotation_point.rotation_degrees.y, 0)


func open_door() -> void:
	if current_animation != DoorAnimation.NONE or not is_door_closed():
		return
	current_animation = DoorAnimation.OPENING
	set_physics_process(true)


func close_door() -> void:
	if current_animation != DoorAnimation.NONE or not is_door_open():
		return
	current_animation = DoorAnimation.CLOSING
	set_physics_process(true)
