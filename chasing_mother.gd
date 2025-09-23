extends CharacterBody3D

var movement_speed: float = 5
@export var nav_region: NavigationRegion3D	
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D

func _ready():
	actor_setup.call_deferred()
	
func actor_setup():
	await get_tree().physics_frame
	print(StareChecker.player.position)
	set_movement_target(StareChecker.player.global_position)
	
func _physics_process(_delta: float) -> void:
	set_movement_target(StareChecker.player.global_position)
	
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	
	look_at(Vector3(next_path_position.x*1.00001, position.y, next_path_position.z))

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
	
func set_movement_target(target_position: Vector3):
	navigation_agent.target_position=target_position

func _process(_delta: float) -> void:
	pass
