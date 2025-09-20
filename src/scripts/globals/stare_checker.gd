extends Node
## Responsible for keeping track of when the player is and is not staring at the
## sun. Physics process will only run once the player and sun nodes have been
## set up and registered themselves with this global.


signal sun_entered_view
signal sun_exited_view


var sun_on_screen_notifier: VisibleOnScreenNotifier3D = null
var player: Player
var sun: Sun
var is_sun_in_view: bool = false
var is_sun_on_screen: bool = false


func _ready() -> void:
	set_physics_process(false)
	EyeHealth.blindness_achieved.connect(_on_blindness_achieved)


## Check every frame if the sun has become obstructed or was obstructed and is
## no longer.
func _physics_process(delta: float) -> void:
	var dot_product = player.player_camera.global_transform.basis.z.dot(player.player_camera.global_position.direction_to(sun.sun_raycast.global_position))
	
	#IF YOU WANT TO TEST WITHOUT THE ZOOM IN AND ENERGY, COMMENT OUT THESE LINES
	#visual_sun_effects(dot_product)
	
	if not is_sun_on_screen:
		return
	elif is_sun_on_screen and is_sun_in_view:
		EyeHealth.take_damage(abs(dot_product),delta)
	var is_visibility_obstructed_now = is_visibility_obstructed()
	if is_visibility_obstructed_now and is_sun_in_view:
		sun_exited_view.emit()
		is_sun_in_view = false
	elif not is_visibility_obstructed_now and not is_sun_in_view:
		sun_entered_view.emit()
		is_sun_in_view = true

func visual_sun_effects(dot_product: float):
	if dot_product<0:
		sun.directional_light.light_energy = 1+(6*-dot_product)
		player.player_camera.fov = player.FOV_DEFAULT-(pow(65,abs(dot_product)))

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
	
	if player != null:
		set_physics_process.call_deferred(true)
		sun_on_screen_notifier.screen_entered.connect(_on_notifier_entered_screen)
		sun_on_screen_notifier.screen_exited.connect(_on_notifier_exited_screen)


## Should be called in the _ready function of the player node
func register_player(init_player: Player) -> void:
	player = init_player
	if sun_on_screen_notifier != null and sun.sun_raycast != null:
		set_physics_process.call_deferred(true)
		sun_on_screen_notifier.screen_entered.connect(_on_notifier_entered_screen)
		sun_on_screen_notifier.screen_exited.connect(_on_notifier_exited_screen)


## Checks if there is a line of sight between the player and the sun. Returns
## true if the player can see the sun.
func is_visibility_obstructed() -> bool:
	sun.sun_raycast.target_position = sun.sun_raycast.to_local(player.player_camera.global_position)
	sun.sun_raycast.force_raycast_update()
	return sun.sun_raycast.get_collider() is not Player


func _on_notifier_entered_screen() -> void:
	is_sun_on_screen = true
	if not is_visibility_obstructed():
		sun_entered_view.emit()
		is_sun_in_view = true


func _on_notifier_exited_screen() -> void:
	is_sun_on_screen = false
	if is_sun_in_view:
		sun_exited_view.emit()
		is_sun_in_view = false


func _on_blindness_achieved() -> void:
	set_physics_process(false)
	print("EYES MELTED!!")
