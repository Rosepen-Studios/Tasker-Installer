extends Control

@onready var next: Button = $MarginContainer/VBoxContainer2/Control/HBoxContainer/Next
@onready var tick: CheckBox = $MarginContainer/VBoxContainer/CheckBox

func _ready() -> void:
	next.grab_focus()

func _on_next_pressed() -> void:
	if tick.button_pressed == true:
		OS.shell_open("/Applications/Tasker.app")
	get_tree().quit()
	
