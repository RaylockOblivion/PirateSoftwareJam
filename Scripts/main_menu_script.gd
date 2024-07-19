extends Control

@export var level:PackedScene
@onready var tree:SceneTree = get_tree()

@export var transition_time:float = 0.5

var menu_origin_pos:= Vector2.ZERO
var menu_origin_size:=Vector2.ZERO

var current_menu
var menu_stack :=[]

@onready var menu_main = $TitleContainer
@onready var menu_settings = $SettingsContainer
@onready var menu_credits = $CreditsContainer


func _ready():
	menu_origin_size=get_viewport_rect().size
	current_menu=menu_main

func move_to_next_menu(next_menu_id:String):
	var next_menu=get_menu_from_id(next_menu_id)
	var tween = tree.create_tween()
	tween.tween_property(current_menu,"position",Vector2(-menu_origin_size.x,0),transition_time)
	tween.parallel().tween_property(next_menu,"position",menu_origin_pos,transition_time)
	menu_stack.append(current_menu)
	current_menu=next_menu

func move_to_prev_menu():
	var prev_menu = menu_stack.pop_back()
	if prev_menu!=null:
		var tween = tree.create_tween()
		tween.tween_property(prev_menu,"position",menu_origin_pos,transition_time)
		tween.parallel().tween_property(current_menu,"position",Vector2(menu_origin_size.x,0),transition_time)
		current_menu = prev_menu

func get_menu_from_id(id:String)->Control:
	match id:
		"main":
			return menu_main
		"settings":
			return menu_settings
		"credits":
			return menu_credits
		_:
			return menu_main

func _on_start_btn_pressed():
	tree.change_scene_to_packed(level)

func _on_settings_pressed():
	move_to_next_menu("settings")

func _on_credits_pressed():
	move_to_next_menu("credits")

func _on_quit_btn_pressed():
	tree.quit()

func _on_back_pressed():
	move_to_prev_menu()
