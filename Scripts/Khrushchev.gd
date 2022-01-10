extends Control


var angry:=0
var us_decision:=""

onready var animator:=$"Choice-Animator"
onready var escalate_img:=$"Choice-Animator/escalate-unselect"
onready var negotiate_img:=$"Choice-Animator/negotiate-unselect"
onready var letter_display:=$Letter
onready var proposal:=$ProposalWindow
onready var proposal_label:=$ProposalWindow/Label
onready var anim_timer:=$AnimTimer
var nuker


#var letter_proposal = """[. . .] We are willing to remove from Cuba the means which you regard as offensive. We are willing to carry this out and to make this pledge in the United Nations. Your representatives will make a declaration to the effect that the United States, for its part, considering the uneasiness and anxiety of the Soviet State, will remove its analogous means from Turkey. Let us reach agreement as to the period of time needed by you and by us to bring this about. And, after that, persons entrusted by the United Nations Security Council could inspect on the spot the fulfillment of the pledges made. Of course, the permission of the Governments of Cuba and Turkey is necessary for the entry into those countries of these representatives and for the inspection of the fulfillment of the pledge made by each side. Of course it would be best if these representatives enjoyed the confidence of the Security Council as well as yours and mine--both the United States and the Soviet Union--and also that of Turkey and Cuba. I do not think it would be difficult to select people who would enjoy the trust and respect of all parties concerned. . ."""


func _ready():
	set_process(false) #not sure if going to use process anyways
	randomize()
	angry=randi()%2 + 1
	print(angry)	
	set_choice_visibility(false)
	#Fix letter display
	
func start_responding(us_move:String):
	us_decision=us_move
	if us_decision!="nuke":
		animate_react()

func set_choice_visibility(state):
	if state:
		escalate_img.show()
		negotiate_img.show()
	else:
		escalate_img.hide()
		negotiate_img.hide()

func animate_react():
	set_choice_visibility(true)
	if angry==1:
		animator.play("escalate")
	else:
		animator.play("negotiate")
	anim_timer.start()
		
	
func decide_react():
	set_choice_visibility(true)
	match us_decision:
#		"nuke": Do nothing because the nuclear war node will take care of this
#			pass
		"nothing":
			if angry==1:
				nuker.start_war("USSR")
			else:
				get_parent().response="negotiate"
				get_parent().turn=true
				get_parent().set_turn()
				letter_display.show()
				proposal.show()
				proposal_label.text = """To avoid the escalation of this crisis, the USSR has decided to propose a compromise with the US. If the US removes its nuclear weapons from Turkey and Italy then the USSR  promises to remove its nuclear weapons from Cuba. The USSR recognizes that a global nuclear war would have a devastating impact on the world and hopes to use this compromise as a step towards world peace.""" 
				set_choice_visibility(false)
		_:
			if angry==1:
				nuker.start_war("USSR")
			else:
				get_parent().response="negotiate"
				get_parent().turn=true
				get_parent().set_turn()
				letter_display.show()
				proposal.show()
				proposal_label.text = """In wake of the %s on Cuba, the USSR has decided to negotiate a compromise with the United States.

If the US removes its nuclear weapons from Turkey and Italy then the USSR promises to remove its nuclear weapons from Cuba. The USSR recognizes that a global nuclear war would have a devastating impact on the world and hopes to use this compromise as a step towards world peace.""" % us_decision
				
				set_choice_visibility(false)
		
		
	

func _on_AnimTimer_timeout():
	decide_react()
