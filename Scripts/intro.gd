extends Control
class_name  Intro

signal intro_finished

@export var pages:Array[TextureRect]
@export var dialogs:Array[String]
@onready var color_rect = $ColorRect
@onready var dialog_box = $DialogBox

@onready var tree = get_tree()
@export var transition_time = .5
var curr_page=0
var prev_page=0
var changing_page:bool = false

func _ready():
	tree.paused=true
	change_dialog(dialogs[0])

func _input(event):
	if changing_page: return
	if event is InputEventMouseButton and event.pressed:
		var dir =(-2 * event.button_index)+3
		turn_page(dir)

func turn_page(offset:int):
	curr_page=clamp(curr_page+offset,1,pages.size()+1)
	print(curr_page)
	var turn=create_tween()
	if(curr_page==pages.size()+1):
		changing_page=true
		hide_page(turn,pages[prev_page-1])
		turn.tween_callback(func():intro_finished.emit())
		return
	if curr_page!=prev_page:
		changing_page=true
		if prev_page!=0:
			hide_page(turn,pages[prev_page-1])
			turn.tween_callback(func():change_dialog(dialogs[curr_page-1]))
		show_page(turn,pages[curr_page-1])
		
		turn.tween_callback(
			func(): 
				changing_page=false
				prev_page=curr_page
				)

func change_dialog(dialog:String):
	dialog_box.text=dialog.c_unescape()

func show_page(tween:Tween,p:TextureRect):
	p.show()
	tween.tween_property(p,"modulate",Color(1,1,1,1),transition_time)
	tween.parallel().tween_property(dialog_box,"modulate",Color(1,1,1,1),transition_time)

func hide_page(tween:Tween,p:TextureRect):
	tween.tween_property(p,"modulate",Color(1,1,1,0),transition_time)
	tween.parallel().tween_property(dialog_box,"modulate",Color(1,1,1,0),transition_time)
	tween.tween_callback(p.hide)
