extends ColorRect



onready var UI:=$UI
onready var lbl_turn:=$UI/Turn
onready var options_parent:=$UI/Options
onready var confirm_popup:=$UI/ActionInfo
onready var action_stats:=$UI/ActionStats
onready var airstrike_sp:=$Spawnpoint
onready var strike_timer:=$Spawnpoint/Timer
onready var cuba:= $Cuba
onready var nuke_ctrl:=$NuclearWar
onready var ussr_control:=$"USSR-UI"
onready var missile_animator:=$"UI/Missile-Animator"
onready var anim_timer:=$"UI/Missile-Animator/AnimTimer"
onready var boom_timer:=$BoomTimer
onready var fade_anim:=$FadeAnim
onready var navy_parent:=$Ships
var nuclear_war_chance:=0.33 #How to calculate this?
var decision:=""
export(String) var response:=""
var turn:=true
var spawned_airstrikes:=0


var airstrike_prefab = preload("res://Scenes/Airstrike.tscn")
var boom_prefab = preload("res://Scenes/Explosion.tscn")
var explosion

func _ready():
	UI.hide()
	toggle_child_visibility(false, missile_animator)
	toggle_child_visibility(false, navy_parent)
	
	set_turn()
	set_process(false)
	fade_anim.play("fade_in")
	ussr_control.nuker=nuke_ctrl

func start_game():
	UI.show()	
	toggle_child_visibility(true, missile_animator)
	

func set_turn():
	if turn:
		lbl_turn.text = "Your turn"
		lbl_turn.set("custom_colors/font_color", Color.green)
		toggle_child_visibility(true, options_parent)
		if response=="negotiate":
			options_parent.get_child(0).text = "Accept"
			options_parent.get_child(1).text = "Decline"
			options_parent.get_child(2).hide()
			options_parent.get_child(3).hide()
	else:
		lbl_turn.text = "USSR's Turn"
		lbl_turn.set("custom_colors/font_color", Color.red)
		toggle_child_visibility(false,options_parent)


func toggle_child_visibility(state:bool, parent):
	if state:
		for child in parent.get_children():
			if child.has_method("show"):
				child.show()
	else:
		for child in parent.get_children():
			if child.has_method("hide"):
				child.hide()
	
func confirm_action(action:String):
	decision=action
	match action:
		"airstrike":
			confirm_popup.window_title="Launch Airstrike"
			confirm_popup.dialog_text= """Depending on the goals of the USSR, an airstrike could lead to either the USSR surrendering and removing the remainder of its missiles from Cuba, or it could lead to a counterattack that could escalate to nuclear war. It is not guaranteed that the airstrike will clear all of the missiles in Cuba.
			"""
			confirm_popup.show()

		"quarantine":
			confirm_popup.window_title="Naval Quarantine"
			confirm_popup.dialog_text= """This was the action that Kennedy decided on, calling it a  "quarantine" so it would not be legally considered an act of war. Despite this, it was still seen by the USSR as an aggressive action. The USSR may stand down if this action is taken, or it will escalate the conflict and start a war.
			"""
			confirm_popup.show()
			

		"nothing":
			confirm_popup.window_title="Negotiate"
			confirm_popup.dialog_text= """This isn't necessarily doing "nothing" but more of a peaceful negotiation. It is possible that the USSR is open to compromise and holds off on an attack.
			
		
		
			"""
			confirm_popup.show()

		
		"nuke":
			confirm_popup.window_title="Nuclear War"
			confirm_popup.dialog_text= """Upon the USSR's detection of the launched missiles, they will immediately retaliate and launch their nuclear missiles at the United States. This will 100% lead to nuclear war.
			"""

			confirm_popup.show()
		
		"accept":
			for child in ussr_control.get_children():
				if child.get_class()=="Sprite" or child.get_class()=="WindowDialog":
					child.hide()
				
			missile_animator.play("fademissiles")
			navy_parent.play_backwards("show_ships")
			fade_anim.play_backwards("fade_in")
			Global.game_end_status="compromise"
	
			anim_timer.start()

			
		"decline":
			toggle_child_visibility(false,options_parent)
			action_stats.hide()
			confirm_popup.hide()
			ussr_control.letter_display.hide()
			ussr_control.proposal.hide()
			nuke_ctrl.start_war("USSR")
			
		

func _process(delta):
	if decision=="airstrike":
		airstrike()
	else:
		quarantine()

func _on_ActionInfo_confirmed():
	if decision=="airstrike" or decision=="quarantine":
		set_process(true)
		toggle_child_visibility(false, options_parent) 
		
	elif decision=="nuke":
		nuke_ctrl.start_war("US")
		toggle_child_visibility(false, options_parent) 
	elif decision=="nothing":
		ussr_control.start_responding("nothing")
		toggle_child_visibility(false, options_parent)
		turn=!turn
		set_turn()
		

func airstrike():
	if spawned_airstrikes==3:
		turn=!turn
		set_turn()
		explosion = boom_prefab.instance()
		add_child(explosion)
		explosion.global_position=cuba.global_position
		boom_timer.start()
		missile_animator.play("fadecuba")
		set_process(false)
		ussr_control.start_responding("airstrike")
	else:
		var tmp_strike = airstrike_prefab.instance()
		tmp_strike.scale.x=.15
		tmp_strike.scale.y=.15
		airstrike_sp.add_child(tmp_strike)
		tmp_strike.global_position=airstrike_sp.global_position
		tmp_strike.global_rotation=-136
		tmp_strike.target=cuba.global_position
		tmp_strike.attack_type="airstrike"
		spawned_airstrikes+=1
		strike_timer.start()
		set_process(false)
		
func quarantine():
	set_process(false)
	toggle_child_visibility(true,navy_parent)
	navy_parent.play("show_ships")
	turn=!turn
	set_turn()
	ussr_control.start_responding("quarantine")

func _on_Option1_pressed():
	match response:
		"":
			confirm_action("airstrike")
		"negotiate":
			confirm_action("accept")
	
func _on_Option2_pressed():
	match response:
		"":
			confirm_action("quarantine")
		"negotiate":
			confirm_action("decline")

func _on_Option3_pressed():
	confirm_action("nothing")

func _on_NUKE_pressed():
	confirm_action("nuke")

func _on_ActionInfo_popup_hide(): #This is not doing anything :D
	decision=""
	print("Not today, bois")
	
func _on_Timer_timeout():
	set_process(true)
	strike_timer.stop()


func _on_BtnViewOutcome_pressed():
	action_stats.show()


func _on_AnimTimer_timeout():
	get_tree().change_scene("res://Scenes/End Game.tscn")

func _on_BoomTimer_timeout():
	explosion.queue_free()
