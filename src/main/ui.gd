extends Control


func _ready() -> void:
	$OnwardButton.pressed.connect(_on_onward_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)


func load_game() -> void:
	$OnwardButton.queue_free()
	$QuitButton.queue_free()
	$TitleScreenMock.queue_free()


func _on_onward_pressed() -> void:
	SignalBus.start_game.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
