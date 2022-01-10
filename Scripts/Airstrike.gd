extends Sprite

var airstrike_img = preload("res://Images/airstrike.png")

var target:Vector2

export(String) var attack_type = "none"


func _process(delta):
	if global_position==target or ((abs(target.x-global_position.x)<10) and (abs(target.y-global_position.y)<10)):
		queue_free()
	global_position.x+=1
	global_position.y+=1
	

	
