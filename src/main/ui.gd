extends Control


@export var end_credits: PackedScene
var game_over_ui: PackedScene = preload("uid://c67s7krlh3p17")
var has_started: bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_game") and not has_started:
		has_started = true
		SignalBus.start_game.emit()


func _ready() -> void:
	SignalBus.game_over.connect(_game_over)


func load_game() -> void:
	if $TitleScreenMock:
		$TitleScreenMock.queue_free()


func show_victory_screen() -> void:
	SunData.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	for child in get_children():
		child.queue_free()
	var end_credits_scene = end_credits.instantiate()
	add_child(end_credits_scene)


func _game_over():
	add_child(game_over_ui.instantiate())
