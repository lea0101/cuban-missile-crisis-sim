extends Control

var opening_text:Array
var index:=0

func _ready():
	for child in get_children():
		opening_text.append(child)
	
	opening_text[0].show()
	opening_text[4].show()
	index+=1
	
	
func text_fade_in(label:Label):
	# It just appears rather than fading in because it looks better that way
	# Would just require "Opening" to be an animation player and modify the alpha of the text
	label.show()
	index+=1

func _process(delta):
	if Input.is_action_just_pressed("click"):
		if index==4:
			get_parent().start_game()
			self.hide()
		else:
			text_fade_in(opening_text[index])
