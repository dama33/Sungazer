extends Control


const NORMAL = "normal"
const CAUGHT = "caught"
const WORRIED = "worried"
const STARING = "staring"


var animation: AnimatedSprite2D


func _ready() -> void:
	StareChecker.sun_entered_view.connect(_on_sun_entered_view)
	StareChecker.sun_exited_view.connect(_on_sun_exited_view)
	animation = $ExpressionAnimation
	animation.play(NORMAL)


func _on_sun_entered_view() -> void:
	animation.play(STARING)


func _on_sun_exited_view() -> void:
	animation.play(NORMAL)
