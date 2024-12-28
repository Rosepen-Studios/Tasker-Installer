extends Control

@onready var next: Button = $MarginContainer/VBoxContainer2/Control/MarginContainer/HBoxContainer/Next
@onready var tick: CheckBox = $MarginContainer/VBoxContainer/CheckBox
var os = "WIN"
func _ready() -> void:
	next.grab_focus()

func _on_next_pressed() -> void:
	if os == "MAC":
		if tick.button_pressed == true:
			OS.shell_open("/Applications/Tasker.app")
		get_tree().quit()
	elif  os == "WIN":
		if tick.button_pressed == true:
			OS.shell_open("C:\\Tasker\\Tasker.exe")
		get_tree().quit()
	
