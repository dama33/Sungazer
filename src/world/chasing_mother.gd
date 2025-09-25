extends CharacterBody3D

var movement_speed: float = 5
@export var mesh_instance: MeshInstance3D	
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D
var aabb: AABB
var state: State = State.IDLE
var player_in_view: bool = false

enum State {
	IDLE,
	CHASING
}

func _ready():
	aabb = mesh_instance.get_aabb()
	actor_setup.call_deferred()
	
func get_random_point() -> Vector3:
	return Vector3(randf_range(aabb.position.x, aabb.end.x), position.y, randf_range(aabb.position.z, aabb.end.z))
	

func actor_setup():
	await get_tree().physics_frame
	print(StareChecker.player.position)
	set_movement_target(get_random_point())
	
func _physics_process(_delta: float) -> void:
	if player_in_view && !StareChecker.is_visibility_obstructed(%RayCast3D) && StareChecker.is_looking_at_sun():
		state = State.CHASING
		movement_speed = 20
		%AggroTimer.start()
		
	if state == State.CHASING:
		set_movement_target(StareChecker.player.global_position)
		
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	
	look_at(Vector3(next_path_position.x, position.y, next_path_position.z))

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
	
func set_movement_target(target_position: Vector3):
	navigation_agent.target_position=target_position

func _process(_delta: float) -> void:
	pass

func _on_nav_timer_timeout() -> void:
	if state != State.CHASING:
		set_movement_target(get_random_point())

func _on_vision_cone_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_view = true


func _on_vision_cone_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_view = false

func _on_aggro_timer_timeout() -> void:
	state = State.IDLE
	movement_speed = 5
	set_movement_target(get_random_point())

func _on_grab_range_body_entered(body: Node3D) -> void:
	if body is Player:
		if StareChecker.is_looking_at_sun():
			SignalBus.game_over.emit()
		
