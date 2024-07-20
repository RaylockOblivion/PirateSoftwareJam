extends Control

@export var game_scene:PackedScene
@onready var tree:SceneTree = get_tree()

@export var transition_time:float = 0.5

var menu_origin_pos:= Vector2.ZERO
var menu_origin_size:=Vector2.ZERO

var current_menu
var menu_stack :=[]
var game_inst:Node

@onready var menu_main = $TitleContainer
@onready var menu_settings = $SettingsContainer
@onready var menu_credits = $CreditsContainer
@onready var menu_pause = $PauseContainer
@onready var bg_gradiant = $BgGradiant

func _ready():
	menu_origin_size=get_viewport_rect().size
	current_menu=menu_main
	menu_main.show()

func move_to_next_menu(next_menu_id:String):
	#hide the menu once the transition finishes
	var next_menu=get_menu_from_id(next_menu_id)
	var tween = tree.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	next_menu.show()
	tween.tween_property(current_menu,"position",Vector2(-menu_origin_size.x,0),transition_time)
	tween.parallel().tween_property(next_menu,"position",menu_origin_pos,transition_time)
	tween.tween_callback(current_menu.hide)
	menu_stack.append(current_menu)
	current_menu=next_menu

func move_to_prev_menu():
	var prev_menu = menu_stack.pop_back()
	if prev_menu!=null:
		var tween = tree.create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		prev_menu.show()
		tween.tween_property(prev_menu,"position",menu_origin_pos,transition_time)
		tween.parallel().tween_property(current_menu,"position",Vector2(menu_origin_size.x,0),transition_time)
		tween.tween_callback(current_menu.hide)
		current_menu = prev_menu

func get_menu_from_id(id:String)->Control:
	match id:
		"main":
			return menu_main
		"settings":
			return menu_settings
		"credits":
			return menu_credits
		"pause":
			return menu_pause
		_:
			return menu_main

func _on_start_btn_pressed():
	game_inst = game_scene.instantiate()
	tree.root.add_child(game_inst)
	bg_gradiant.set_modulate(Color(1,1,1,.5))
	bg_gradiant.hide()
	menu_main.hide()
	menu_pause.in_game=true
	current_menu=menu_pause

func _on_settings_pressed():
	print("signal reaching")
	move_to_next_menu("settings")

func _on_credits_pressed():
	move_to_next_menu("credits")

func _on_quit_btn_pressed():
	tree.quit()

func _on_back_pressed():
	move_to_prev_menu()

func _on_game_paused(paused):
	bg_gradiant.visible=paused

func _on_pause_menu_pressed():
	#Remove the game
	game_inst.queue_free()
	#Change Alpha of bg back to 1
	bg_gradiant.set_modulate(Color(1,1,1,1))
	menu_pause.in_game=false
	menu_pause.is_paused=false
	#Change current Scene back to title
	current_menu=menu_main
	menu_main.show()
	bg_gradiant.show()
