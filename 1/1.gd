extends Control

var os = "WIN"
@onready var web: HTTPRequest = $HTTPRequest
@onready var next: Button = $MarginContainer/VBoxContainer2/Control/MarginContainer/HBoxContainer/Next
@onready var title: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var text: Label = $MarginContainer/VBoxContainer/Label
@onready var timer: Timer = $Timer
@onready var exit: Button = $MarginContainer/VBoxContainer2/Control/MarginContainer/HBoxContainer2/Exit
@onready var loop: AnimationPlayer = $MarginContainer/VBoxContainer2/Control/MarginContainer/HBoxContainer3/Control/AnimationPlayer
@onready var load: HBoxContainer = $MarginContainer/VBoxContainer2/Control/MarginContainer/HBoxContainer3
var release_link:String = "https://github.com/Firepixel85/Tasker-Labs/releases/download/1.0_obd1/Tasker."
var user 

func _ready() -> void:
	user = OS.get_user_data_dir().split("/")[2]
	next.grab_focus()
	
func _on_next_pressed() -> void:
	if next.text == "Install":
		load.visible = true
		loop.play("Load")
		if os == "MAC":
			next.visible = false
			exit.visible = false
			title.text = "Downloading"
			text.text = "Removing past installations"
			var output = []
			var term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && rm -rf /Applications/Tasker.app"],output)

			timer.start()
			await timer.timeout
			print(output)
			text.text = "Getting file from remote server             (This might take some time)"
			web.set_download_file("user://Tasker.zip")
			web.request(release_link+"Mac.zip")
			
			await web.request_completed
			text.text = "File retrieved, expanding ZIP"

			output = []
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && unzip '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer/Tasker.zip' -d  '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer'"],output)
			timer.start()
			await timer.timeout
			for i in output.size():
				print(output[i])
			text.text = "Moving app to Applications folder"

			output = []
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && mv '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer/Tasker.app' /Applications"],output)
			timer.start()
			await timer.timeout
			print(output)
			output = []
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && rm '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer/Tasker.zip'"],output)
			text.text = "Deleting ZIP file"
			timer.start()
			await timer.timeout
			print(output)
			
			output = []
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && ls /Applications/Tasker.app"],output)
			if output != [""]:
				get_tree().change_scene_to_file("res://2/2.tscn")
			else:
				var output1 =[]
				var output2 =[]
				term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && ls '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer/Tasker.app'"],output1)
				term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && ls '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer/Tasker.zip'"],output2)
				if output2 != [""]:
					print("ERROR: Failed to extract zip")
					text.text= "Failed to extract the zip file located at: /Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer/Tasker.zip"
					

				elif output1 != [""]:
					print("ERROR: Failed to move file")
					text.text= "Failed to move Tasker, app located at: /Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker_Installer/Tasker.app"
					
				else:
					text.text= "An unknown error ocuured with the instalation, we recomend installing Tasker manualy."
				
				exit.visible = true
				title.text = "Error"
				next.visible = true
				load.visible = false
				next.text = "Manual Install"
			#ls: /Applications/Tasker.app: No such file or directory

			
		elif os == "WIN":
			next.visible = false
			exit.visible = false
			title.text = "Downloading"
			var output = []
			var term
			
			text.text = "Getting file from remote server             (This might take some time)"
			web.set_download_file("user://Tasker.zip")
			print(release_link+"Windows.zip")
			web.request(release_link+"Windows.zip")
			
			await web.request_completed
			text.text = "Removing past installations"
			
			term = OS.execute("POWERSHELL.exe", ["Remove-Item -Path \"C:\\Tasker\\Tasker.exe\""],output)
			timer.start()
			await timer.timeout
			text.text = "File retrieved, expanding ZIP"


			term = OS.execute("POWERSHELL.exe", ["tar -xf C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker_Installer\\Tasker.zip -C C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker_Installer"],output)
			timer.start()
			await timer.timeout
			
			term = OS.execute("POWERSHELL.exe", ["Remove-Item -Path C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker_Installer\\Tasker.zip"],output)
			text.text = "Deleting ZIP file"
			timer.start()
			await timer.timeout
			
			term = OS.execute("POWERSHELL.exe", ["New-Item -Path \"C:\\Tasker\" -ItemType Directory"],output)
			text.text = "Creating storage directory"
			timer.start()
			await timer.timeout
			
			output = []
			term = OS.execute("POWERSHELL.exe", [ "Move-Item -Path \"C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker_Installer\\Tasker.exe\"  -Destination \"C:\\Tasker\""],output)
			text.text = "Moving extracted file"
			get_tree().change_scene_to_file("res://2/2.tscn")
	else:
		OS.shell_open("https://taskerapp.framer.website/manual-installation")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	loop.play("Load")
