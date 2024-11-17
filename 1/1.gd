extends Control


@onready var web: HTTPRequest = $HTTPRequest
@onready var next: Button = $MarginContainer/VBoxContainer2/Control/HBoxContainer/Next
@onready var title: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var text: Label = $MarginContainer/VBoxContainer/Label
@onready var timer: Timer = $Timer
@onready var exit: Button = $MarginContainer/VBoxContainer2/Control/HBoxContainer2/Exit
var user

func _ready() -> void:
	user = OS.get_user_data_dir().split("/")[2]
	next.grab_focus()
	
func _on_next_pressed() -> void:
	next.visible = false
	exit.visible = false
	title.text = "Downloading"
	text.text = "Removing past installations"
	var output = []
	var term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && rm -rf /Applications/Tasker.app"],output)
	
	timer.start()
	await timer.timeout
	text.text = "Getting file from remote server             (This might take some time)"
	web.set_download_file("user://Tasker.zip")
	web.request("https://github.com/Rosepen-Studios/Tasker/releases/download/a0.3.1/Tasker_v0.3.1_Mac.zip")
	
	await web.request_completed
	text.text = "File retrived, expanding ZIP"
	
	term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && unzip '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker Installer/Tasker.zip' -d  '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker Installer'"],output)
	timer.start()
	await timer.timeout
	text.text = "Moving app to Applications folder"
	
	term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && mv '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker Installer/Tasker.app' /Applications"],output)
	timer.start()
	await timer.timeout
	term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && rm '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker Installer/Tasker.zip'"],output)
	text.text = "Deleting ZIP file"
	timer.start()
	await timer.timeout

	get_tree().change_scene_to_file("res://2/2.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
