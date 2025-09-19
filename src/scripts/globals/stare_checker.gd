extends Node
## Responsible for keeping track of when the player is and is not staring at the
## sun. Physics process will only run once the player and sun nodes have been
## set up and registered themselves with this global.


signal sun_entered_view
signal sun_exited_view


var sun_on_screen_notifier: VisibleOnScreenNotifier3D = null
var player: Player
var sun_raycast: RayCast3D = null
var is_sun_in_view: bool = false
var is_sun_on_screen: bool = false


func _ready() -> void:
	set_physics_process(false)


## Check every frame if the sun has become obstructed or was obstructed and is
## no longer.
func _physics_process(_delta: float) -> void:
	if not is_sun_on_screen:
		return
	elif is_sun_on_screen and is_sun_in_view:
		if not player.take_damage(abs(player.player_camera.global_transform.basis.z.dot(player.player_camera.global_position.direction_to(sun_raycast.global_position)))):
			print("EYES ARE MELTED")
		
	var is_visibility_obstructed_now = is_visibility_obstructed()
	if is_visibility_obstructed_now and is_sun_in_view:
		sun_exited_view.emit()
		is_sun_in_view = false
	elif not is_visibility_obstructed_now and not is_sun_in_view:
		sun_entered_view.emit()
		is_sun_in_view = true


## Gets the current global position of the sun
func get_sun_global_position() -> Vector3:
	assert(sun_on_screen_notifier != null, "sun's on screen notifier was not registered before calling this method!")
	return sun_on_screen_notifier.global_position


## Should be called in the _ready function of the sun node
func register_sun_stuff(notifier: VisibleOnScreenNotifier3D, raycast: RayCast3D) -> void:
	sun_on_screen_notifier = notifier
	sun_raycast = raycast
	sun_on_screen_notifier.screen_entered.connect(_on_notifier_entered_screen)
	sun_on_screen_notifier.screen_exited.connect(_on_notifier_exited_screen)
	if player.player_camera != null:
		set_physics_process.call_deferred(true)


## Should be called in the _ready function of the player node
func register_player(player: Player) -> void:
	self.player = player
	if sun_on_screen_notifier != null and sun_raycast != null:
		set_physics_process.call_deferred(true)


## Checks if there is a line of sight between the player and the sun. Returns
## true if the player can see the sun.
func is_visibility_obstructed() -> bool:
	sun_raycast.target_position = sun_raycast.to_local(player.player_camera.global_position)
	sun_raycast.force_raycast_update()
	return sun_raycast.get_collider() is not Player


func _on_notifier_entered_screen() -> void:
	is_sun_on_screen = true
	print("on screen")
	if not is_visibility_obstructed():
		sun_entered_view.emit()
		is_sun_in_view = true


func _on_notifier_exited_screen() -> void:
	print("off screen")
	is_sun_on_screen = false
	if is_sun_in_view:
		sun_exited_view.emit()
		is_sun_in_view = false
