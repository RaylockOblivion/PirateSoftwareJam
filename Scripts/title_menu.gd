extends MarginContainer

signal start_pressed
signal settings_pressed
signal credits_pressed
signal quit_pressed
@export var start_focus:Control

func _ready():
	start_focus.grab_focus()

func _on_start_btn_pressed():
	start_pressed.emit()

func _on_settings_btn_pressed():
	settings_pressed.emit()

func _on_credits_btn_pressed():
	credits_pressed.emit()

func _on_quit_btn_pressed():
	quit_pressed.emit()

func _on_visibility_changed():
	if visible:
		start_focus.grab_focus()
