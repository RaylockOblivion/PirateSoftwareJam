extends Control

@export var level:PackedScene
@onready var tree:SceneTree = get_tree()

func _on_start_btn_pressed():
	tree.change_scene_to_packed(level)

func _on_quit_btn_pressed():
	tree.quit()
