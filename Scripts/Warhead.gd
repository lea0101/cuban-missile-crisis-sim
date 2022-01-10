extends Sprite


#USSR BOUNDS
# y: 0 to 130
# x: same as US

export(String) var country
var start_pos:Vector2

var ussr_texture = preload("res://Images/ussr-warhead.png")
var us_texture = preload("res://Images/us-warhead.png")

var x_step:=0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	randomize()
	


func start_launch():
	if country=="USSR":
		texture=ussr_texture
		start_pos=Vector2(randi()%(300) + 140, randi()%130) 
		flip_h=true
		x_step=-1
	else:
		texture=us_texture
		start_pos=Vector2(randi()%(-140) - 300, randi()%170 + 44) #Position relative to warhead parent
		x_step=1
	position=start_pos
	rotation_degrees=120 * x_step
	set_process(true)

func _process(delta):
	if position.x==-start_pos.x:
		set_process(false)
	elif position.x<0:
		position.x+= 3 * x_step
		position.y-= .5
#		if rotation_degrees<80:
#			rotation_degrees+=.25 * x_step
	else:
		position.x+= 3 * x_step
		position.y+= .5
#		if rotation_degrees<120:
#			rotation_degrees+=.25 * x_step
