extends Control

onready var compromise_ctrl:=$Compromised
onready var nuked_ctrl:=$Nuked

func _ready():
	print("Global status: ", Global.game_end_status)
	match Global.game_end_status:
		"compromise":
			compromise_ctrl.show()
			nuked_ctrl.hide()
		"nuke":
			nuked_ctrl.show()
			compromise_ctrl.hide()
		_:
			print("?")


func _on_Button_pressed():
	play_again()
	

func _on_Button2_pressed():
	play_again()
	
func play_again():
	Global.game_end_status=""
	get_tree().change_scene("res://Scenes/Main.tscn")
