extends Control


@export var end_credits: PackedScene


func _ready() -> void:
	$OnwardButton.pressed.connect(_on_onward_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)


func load_game() -> void:
	$OnwardButton.queue_free()
	$QuitButton.queue_free()
	$TitleScreenMock.queue_free()


func show_victory_screen() -> void:
	for child in get_children():
		child.queue_free()
	var end_credits_scene = end_credits.instantiate()
	add_child(end_credits_scene)
	end_credits_scene.find_child("CreditsAnimation").play("credits")


func _on_onward_pressed() -> void:
	SignalBus.start_game.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
