extends Node
## Responsible for keeping track of when the player is and is not staring at the
## sun. Physics process will only run once the player and sun nodes have been
## set up and registered themselves with this global.


signal sun_entered_view
signal sun_exited_view


const VISION_PULL_STRENGTH = PI / 8
const ZOOM_IN_SPEED = 0.3
const ZOOM_OUT_SPEED = 2.0


var sun_on_screen_notifier: VisibleOnScreenNotifier3D = null
var player: Player
var sun: Sun
var is_sun_in_view: bool = false
var is_sun_on_screen: bool = false
var base_energy

func _ready() -> void:
	set_physics_process(false)
	EyeHealth.blindness_achieved.connect(_on_blindness_achieved)
	set_physics_process_priority(-1)


## Check every frame if the sun has become obstructed or was obstructed and is
## no longer.
func _physics_process(delta: float) -> void:
	#print(player.pivot_point.rotation.x)
	var dot_product = player.player_camera.global_transform.basis.z.dot(player.player_camera.global_position.direction_to(sun.sun_raycast.global_position))

	if is_sun_on_screen and is_sun_in_view:
		EyeHealth.take_damage(abs(dot_product), delta)
		#IF YOU WANT TO TEST WITHOUT THE ZOOM IN AND ENERGY, COMMENT OUT THESE LINES
		visual_sun_effects(delta)
	else:
		player.player_camera.fov = lerpf(player.player_camera.fov, player.FOV_DEFAULT, delta * ZOOM_OUT_SPEED)

	if not is_sun_on_screen:
		return
	var is_visibility_obstructed_now = is_visibility_obstructed(sun.sun_raycast)
	if is_visibility_obstructed_now and is_sun_in_view:
		sun.directional_light.light_energy = base_energy
		sun_exited_view.emit()
		is_sun_in_view = false
	elif not is_visibility_obstructed_now and not is_sun_in_view:
		sun_entered_view.emit()
		is_sun_in_view = true


func visual_sun_effects(delta: float):
	var invert_correction: int = -1 if (SunData.path_follow.progress_ratio >= 0.5) else 1
	var camera_center_direction = -1 * player.player_camera.global_transform.basis.z
	var player_position = player.player_camera.global_position
	var sun_position = sun.sun_raycast.global_position
	var direction_to_sun = player_position.direction_to(sun_position)

	var camera_center_yaw_angle = Vector2(camera_center_direction.x, camera_center_direction.z).angle()
	var target_yaw_angle = Vector2(direction_to_sun.x, direction_to_sun.z).angle()
	var yaw_rotation = camera_center_yaw_angle - rotate_toward(camera_center_yaw_angle, target_yaw_angle, VISION_PULL_STRENGTH * delta)
	#print(str(player.rotation.y) + "    " + str(camera_center_yaw_angle) + "    " + str(target_yaw_angle) + "    " + str(sign(yaw_rotation)))
	player.rotation.y += yaw_rotation
	
	var camera_center_pitch_angle = Vector2(camera_center_direction.y, camera_center_direction.z).angle()
	var target_pitch_angle = min(Vector2(direction_to_sun.y, direction_to_sun.z).angle(), PI / 2)
	var pitch_rotation = camera_center_pitch_angle - rotate_toward(camera_center_pitch_angle, target_pitch_angle, VISION_PULL_STRENGTH * delta)
	player.pivot_point.rotation.x += pitch_rotation * invert_correction
	
	var dot_product = (-camera_center_direction).dot(direction_to_sun)
	if dot_product < 0:
		var target_light_energy = 1+(6*-dot_product)
		sun.directional_light.light_energy = lerpf(sun.directional_light.light_energy, target_light_energy, delta * 0.2)
		var target_fov = player.FOV_DEFAULT-(pow(65,abs(dot_product)))
		player.player_camera.fov = lerpf(player.player_camera.fov, target_fov, delta * ZOOM_IN_SPEED)


func is_looking_at_sun() -> bool:
	return is_sun_in_view


## Gets the current global position of the sun
func get_sun_global_position() -> Vector3:
	assert(sun.sun_raycast != null, "sun's raycast was not registered before calling this method!")
	return sun.sun_raycast.global_position


## Should be called in the _ready function of the sun node
func register_sun(sun_value: Sun):
	sun_on_screen_notifier = sun_value.on_screen_notifier
	self.sun = sun_value
	base_energy = sun.directional_light.light_energy
	
	if player != null:
		set_physics_process.call_deferred(true)
		if !sun_on_screen_notifier.screen_entered.is_connected(_on_notifier_entered_screen):
			sun_on_screen_notifier.screen_entered.connect(_on_notifier_entered_screen)
		if !sun_on_screen_notifier.screen_exited.is_connected(_on_notifier_exited_screen):
			sun_on_screen_notifier.screen_exited.connect(_on_notifier_exited_screen)


## Should be called in the _ready function of the player node
func register_player(init_player: Player) -> void:
	player = init_player
	if sun_on_screen_notifier != null and sun.sun_raycast != null:
		set_physics_process.call_deferred(true)
		if !sun_on_screen_notifier.screen_entered.is_connected(_on_notifier_entered_screen):
			sun_on_screen_notifier.screen_entered.connect(_on_notifier_entered_screen)
		if !sun_on_screen_notifier.screen_exited.is_connected(_on_notifier_exited_screen):
			sun_on_screen_notifier.screen_exited.connect(_on_notifier_exited_screen)


## Checks if there is a line of sight between the player and the sun. Returns
## true if the player can see the sun.
func is_visibility_obstructed(raycast: RayCast3D) -> bool:
	raycast.target_position = raycast.to_local(player.player_camera.global_position)
	raycast.force_raycast_update()
	return raycast.get_collider() is not Player


func _on_notifier_entered_screen() -> void:
	is_sun_on_screen = true
	if not is_visibility_obstructed(sun.sun_raycast):
		sun_entered_view.emit()
		is_sun_in_view = true


func _on_notifier_exited_screen() -> void:
	is_sun_on_screen = false
	if is_sun_in_view:
		sun.directional_light.light_energy = base_energy
		sun_exited_view.emit()
		is_sun_in_view = false


func _on_blindness_achieved() -> void:
	set_physics_process(false)
