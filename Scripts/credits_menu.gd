extends MarginContainer

signal back_pressed
signal quit_pressed
@export var start_focus:Control

func _on_back_btn_pressed():
	back_pressed.emit()

func _on_quit_btn_pressed():
	quit_pressed.emit()

func _on_visibility_changed():
	if visible:
		start_focus.grab_focus()
