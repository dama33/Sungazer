extends CharacterBody3D


const Voicelines = {
	"ALRIGHT": "ALRIGHT",
	"FINE_YOU_WIN": "FINE_YOU_WIN",
	"PESTERING": "PESTERING",
	"SIGH_1": "SIGH_1",
	"SIGH_2": "SIGH_2",
	"SIGH_3": "SIGH_3",
	"UP_TO_NO_GOOD": "UP_TO_NO_GOOD",
	"WHERE_IS_HE": "WHERE_IS_HE"
}
const idle_voicelines: Array[String] = [
	Voicelines.WHERE_IS_HE,
	Voicelines.WHERE_IS_HE,
	Voicelines.SIGH_1,
	Voicelines.SIGH_2,
	Voicelines.SIGH_3,
]
const chasing_voicelines: Array[String] = [
	Voicelines.UP_TO_NO_GOOD,
	Voicelines.PESTERING,
]
const foiled_voicelines: Array[String] = [
	Voicelines.ALRIGHT,
	Voicelines.FINE_YOU_WIN,
]
const VOICELINE_DELAY_SECONDS = 4
const IDLE_MOVE_SPEED = 5
const CHASE_MOVE_SPEED = 10


var movement_speed: float = IDLE_MOVE_SPEED
@export var mesh_instance: MeshInstance3D	
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D
var aabb: AABB
var state: State = State.IDLE
var player_in_view: bool = false
var is_watching_player: bool = false
@export var origin_point: Vector3
var voiceline_streams: Dictionary[String, AudioStream] = {}
var voiceline_uids: Dictionary = {
	Voicelines.ALRIGHT: "uid://d28o112gegltn",
	Voicelines.FINE_YOU_WIN: "uid://ddpadc7sw08yn",
	Voicelines.PESTERING: "uid://v0hbyadjkuf8",
	Voicelines.SIGH_1: "uid://dcyckigps81uq",
	Voicelines.SIGH_2: "uid://bavpp4jhrsg4k",
	Voicelines.SIGH_3: "uid://d2ygwdohws3g1",
	Voicelines.UP_TO_NO_GOOD: "uid://ws4yrfl61btn",
	Voicelines.WHERE_IS_HE: "uid://bh7a1fliw8rjw",
}
var time_since_voiceline: float = 0
var is_attempting_to_go_inside: bool = false


enum State {
	IDLE,
	CHASING
}

func _exit_tree() -> void:
	state = State.IDLE
	%ExitHouseTimer.stop()
	%EnterHouseTimer.stop()
	%NavTimer.stop()
	%EnterHouseTimer.timeout.disconnect(_on_enter_house_timer_timeout)
	%ExitHouseTimer.timeout.disconnect(_on_exit_house_timer_timeout)

func _ready():
	%EnterHouseTimer.timeout.connect(_on_enter_house_timer_timeout)
	%ExitHouseTimer.timeout.connect(_on_exit_house_timer_timeout)
	SignalBus.door_opened.connect(_on_door_opened)
	aabb = mesh_instance.get_aabb()
	visible = false
	if origin_point != Vector3.ZERO:
		position = origin_point
	actor_setup.call_deferred()
	set_physics_process(false)
	for voiceline in Voicelines:
		var asset_uid = voiceline_uids.get(voiceline)
		voiceline_streams[voiceline] = load(asset_uid)
	
func get_random_point() -> Vector3:
	return Vector3(randf_range(aabb.position.x, aabb.end.x), global_position.y, randf_range(aabb.position.z, aabb.end.z))
	

func actor_setup():
	await get_tree().physics_frame
	#print(StareChecker.player.position)
	set_movement_target(get_random_point())


func say_voiceline(voiceline_name: String, ignore_cooldown: bool = false) -> void:
	if time_since_voiceline < VOICELINE_DELAY_SECONDS and not ignore_cooldown:
		return
	%VoicelinePlayer.stream = voiceline_streams[voiceline_name]
	%VoicelinePlayer.play()
	time_since_voiceline = 0


func _physics_process(delta: float) -> void:
	time_since_voiceline += delta
	say_voiceline(idle_voicelines.pick_random())
	if player_in_view and !StareChecker.is_visibility_obstructed(%RayCast3D):
		if not is_watching_player:
			is_watching_player = true
			print("mom WATCHING")
			SignalBus.mom_is_watching.emit()
	elif is_watching_player:
		is_watching_player = false
		print("mom NOT WATCHING")
		SignalBus.mom_is_not_watching.emit()

	if state != State.CHASING and is_watching_player and StareChecker.is_looking_at_sun():
		say_voiceline(chasing_voicelines.pick_random(), true)
		state = State.CHASING
		movement_speed = CHASE_MOVE_SPEED
		SignalBus.mom_is_chasing.emit()
		
	if state == State.CHASING:
		set_movement_target(StareChecker.player.global_position)
		
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	
	if(not navigation_agent.is_target_reached()):
		velocity = current_agent_position.direction_to(Vector3(next_path_position.x, global_position.y, next_path_position.z)) * movement_speed
	else:
		velocity = Vector3.ZERO
		if is_attempting_to_go_inside:
			SignalBus.open_door.emit()
	move_and_slide()
	
func set_movement_target(target_position: Vector3):
	var adjusted_position = Vector3(target_position.x, global_position.y, target_position.z)
	navigation_agent.target_position = adjusted_position
	look_at(adjusted_position)
	
func _on_nav_timer_timeout() -> void:
	if state != State.CHASING:
		set_movement_target(get_random_point())

func _on_vision_cone_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_view = true


func _on_vision_cone_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_view = false

func _on_grab_range_body_entered(body: Node3D) -> void:
	if not body is Player or state != State.CHASING:
		return
	elif State.CHASING:
		SignalBus.swap_levels.emit()
		

func _on_enter_house_timer_timeout():
	if state == State.CHASING:
		say_voiceline(foiled_voicelines.pick_random(), true)
	%NavTimer.stop()
	state = State.IDLE
	set_movement_target(origin_point)
	is_attempting_to_go_inside = true
	

func _on_exit_house_timer_timeout():
	SignalBus.open_door.emit()

func despawn_mom():
	hide()
	state = State.IDLE
	position = origin_point
	set_physics_process(false)
	is_attempting_to_go_inside = false
	%ExitHouseTimer.wait_time = randi() % 5 + 5
	%ExitHouseTimer.start()
	%EnterHouseTimer.stop()
	SignalBus.mom_is_not_chasing.emit()


func spawn_mom():
	show()
	state = State.IDLE
	position = origin_point
	set_physics_process(true)
	is_attempting_to_go_inside = false
	%NavTimer.start()
	_on_nav_timer_timeout()
	%ExitHouseTimer.stop()
	%EnterHouseTimer.start()


func _on_door_opened() -> void:
	if is_attempting_to_go_inside:
		despawn_mom()
	else:
		spawn_mom()
	SignalBus.close_door.emit()
