extends MarginContainer

signal quit_pressed
signal back_pressed
@export var start_focus:Control

func _ready():
	#Get Current Setting values from autoloads
	pass 

func _on_back_btn_pressed():
	back_pressed.emit()

func _on_quit_btn_pressed():
	quit_pressed.emit()

func _on_visibility_changed():
	if visible:
		start_focus.grab_focus()
