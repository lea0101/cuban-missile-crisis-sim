extends Sprite



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var main_ctrl:=$MainControl
onready var win_ctrl:=$WinningControl
onready var extra_ctrl:=$SourcesControl

# Called when the node enters the scene tree for the first time.
func _ready():
	main_ctrl.show()
	win_ctrl.hide()
	extra_ctrl.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	#OS.shell_open("https://godotengine.org")


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_ReadPaper_pressed():
	main_ctrl.hide()
	extra_ctrl.show()

func _on_Sources_pressed(): # It's called sources but it's really for the how to win window...
	main_ctrl.hide()
	win_ctrl.show()


func _on_Back_pressed():
	main_ctrl.show()
	win_ctrl.hide()
	extra_ctrl.hide()


func _on_Source3_pressed():
	OS.shell_open("https://plus.maths.org/content/game-theory-and-cuban-missile-crisis")


func _on_Source1_pressed():
	OS.shell_open("https://microsites.jfklibrary.org/cmc/")


func _on_Source2_pressed():
	OS.shell_open("https://www.archives.gov/publications/prologue/2012/fall/cuban-missiles.html")

