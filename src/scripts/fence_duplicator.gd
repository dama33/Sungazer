@tool
class_name FenceDuplicator
extends Node3D
## spacing on corner: (6.5, 0, -5)


const SPACING: float = 11.75
const PREFIX: String = "Fence"


@onready var fence_scene: PackedScene = load("uid://dxie4ougs2s3h")
@export var count: int = 1
@export_tool_button("Update", "CreateNewSceneFrom") var instantiate_action = update


func update() -> void:
	if not Engine.is_editor_hint() or not (fence_scene and fence_scene.can_instantiate()):
		return

	for n in get_children():
		remove_child(n)
		n.queue_free()

	for index in range(count):
		var new_fence: Node3D = fence_scene.instantiate()
		new_fence.position.x = SPACING * index

		new_fence.set_name("%s%d" % [PREFIX, index])
		add_child(new_fence)
		new_fence.set_owner(get_tree().get_edited_scene_root())
