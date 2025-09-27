extends Control


@export var end_credits: PackedScene
var game_over_ui: PackedScene = preload("uid://c67s7krlh3p17")


func _ready() -> void:
	$OnwardButton.pressed.connect(_on_onward_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)
	SignalBus.game_over.connect(_game_over)


func load_game() -> void:
	$OnwardButton.queue_free()
	$QuitButton.queue_free()
	$TitleScreenMock.queue_free()


func show_victory_screen() -> void:
	SunData.set_process(false)
	for child in get_children():
		child.queue_free()
	var end_credits_scene = end_credits.instantiate()
	add_child(end_credits_scene)


func _on_onward_pressed() -> void:
	SignalBus.start_game.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _game_over():
	add_child(game_over_ui.instantiate())
