extends Control
class_name  Intro

signal intro_finished

@export var pages:Array[TextureRect]
@onready var color_rect = $ColorRect
@onready var tree = get_tree()
@export var transition_time = .5
var curr_page=0
var prev_page=0
var changingPage:bool = false

func _ready():
	tree.paused=true

func _input(event):
	if changingPage: return
	if event is InputEventMouseButton and event.pressed:
		turn_page((-2 * event.button_index)+3)

func turn_page(offset:int):
	curr_page=clamp(curr_page+offset,1,7)
	var turn=create_tween()
	if(curr_page==7):
		changingPage=true
		hide_page(turn,pages[prev_page-1])
		turn.tween_callback(func():intro_finished.emit())
		return
	if curr_page!=prev_page:
		changingPage=true
		if prev_page!=0:
			hide_page(turn,pages[prev_page-1])
		show_page(turn,pages[curr_page-1])
		
		turn.tween_callback(
			func(): 
				changingPage=false
				prev_page=curr_page
				)

func show_page(tween:Tween,p:TextureRect):
	p.show()
	tween.tween_property(p,"modulate",Color(1,1,1,1),transition_time)

func hide_page(tween:Tween,p:TextureRect):
	tween.tween_property(p,"modulate",Color(1,1,1,0),transition_time)
	tween.tween_callback(p.hide)
