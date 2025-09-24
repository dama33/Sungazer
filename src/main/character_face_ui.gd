extends TextureRect


#@onready var smirk_texture = preload("uid://b2l4dyskl1ky4")
#@onready var looking_at_sun_texture = preload("uid://bvvnwbfm5kueo")


func _ready() -> void:
	#texture = smirk_texture
	StareChecker.sun_entered_view.connect(_on_sun_entered_view)
	StareChecker.sun_exited_view.connect(_on_sun_exited_view)


func _on_sun_entered_view() -> void:
	#texture = looking_at_sun_texture
	pass


func _on_sun_exited_view() -> void:
	#texture = smirk_texture
	pass
