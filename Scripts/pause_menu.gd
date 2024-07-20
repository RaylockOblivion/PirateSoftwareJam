extends MarginContainer

@export var start_focus:Control
@onready var tree:SceneTree = get_tree()
@onready var in_game = false
signal game_paused(is_paused)
signal menu_pressed
signal settings_pressed
signal quit_pressed

var is_paused = false:
	set(value):
		is_paused = value
		tree.paused=is_paused
		game_paused.emit(is_paused)
		visible = is_paused
	
func _unhandled_input(event):
	if !in_game:
		return
	if event.is_action_pressed("ui_cancel"):
		self.is_paused=!is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_visibility_changed():
	if visible:
		start_focus.grab_focus()

func _on_main_menu_btn_pressed():
	menu_pressed.emit()

func _on_settings_btn_pressed():
	settings_pressed.emit()

func _on_quit_btn_pressed():
	quit_pressed.emit()
