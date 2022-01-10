extends Control




var missile_prefab = preload("res://Scenes/Warhead.tscn")
var explosion_prefab = preload("res://Scenes/Explosion.tscn")

onready var launch_timer:=$LaunchTimer
onready var warhead_parent:=$WarheadParent
onready var disclaimer:=$Disclaimer
onready var explosion_timer:=$BoomTimer


var boom_cnt:=0
var instigator = ""

func _ready():
	set_process(false) 
	randomize()
#	for x in us_animator.get_children():
#		x.hide()


func start_war(country:String):
	disclaimer.show()
	if instigator=="":
		instigator=country
		launch_timer.start()
	else:
		launch_timer.stop()

	for i in range(20):
		var temp_warhead = missile_prefab.instance()
		temp_warhead.country=country
		warhead_parent.add_child(temp_warhead)
		temp_warhead.start_launch()
	
	


func _on_InstigatorTimer_timeout():
	if instigator=="US":
		start_war("USSR")
	else:
		start_war("US")
		
	explosion_timer.start()
	

func _on_BoomTimer_timeout():
	if boom_cnt==5:
		Global.game_end_status="nuke"
		get_tree().change_scene("res://Scenes/End Game.tscn")
	var boom = explosion_prefab.instance()
	add_child(boom)
	boom.get_child(0).emitting=true
	boom.global_position =  warhead_parent.get_child(randi()%warhead_parent.get_child_count()).global_position
	boom_cnt+=1
