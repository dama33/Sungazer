extends Control


const NORMAL = "normal"
const CAUGHT = "caught"
const WORRIED = "worried"
const STARING = "staring"


var animation: AnimatedSprite2D
var is_staring: bool = false
var is_worried: bool = false
var is_caught: bool = false
var is_initialized: bool = false


func _ready() -> void:
	StareChecker.sun_entered_view.connect(_on_sun_entered_view)
	StareChecker.sun_exited_view.connect(_on_sun_exited_view)
	SignalBus.mom_is_watching.connect(_on_mom_watching)
	SignalBus.mom_is_not_watching.connect(_on_mom_not_watching)
	SignalBus.mom_is_chasing.connect(_on_mom_chasing)
	SignalBus.mom_is_not_chasing.connect(_on_mom_not_chasing)
	SignalBus.player_enter_tree.connect(_on_player_enter_tree)
	animation = $ExpressionAnimation
	animation.play(NORMAL)
	is_initialized = true


func update_animation() -> void:
	if not is_initialized:
		return
	if is_caught:
		animation.play(CAUGHT)
	elif is_worried:
		animation.play(WORRIED)
	elif is_staring:
		animation.play(STARING)
	else:
		animation.play(NORMAL)


func _on_sun_entered_view() -> void:
	is_staring = true
	update_animation()


func _on_sun_exited_view() -> void:
	is_staring = false
	update_animation()


func _on_mom_watching() -> void:
	is_worried = true
	update_animation()


func _on_mom_not_watching() -> void:
	is_worried = false
	update_animation()


func _on_mom_chasing() -> void:
	is_caught = true
	update_animation()


func _on_mom_not_chasing() -> void:
	is_caught = false
	update_animation()


func _on_player_enter_tree() -> void:
	is_caught = false
	is_worried = false
	is_staring = false
	update_animation()
