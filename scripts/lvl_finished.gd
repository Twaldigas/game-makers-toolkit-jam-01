extends Node

const GEM_POINTS = 10
const TIME_LEFT_POINTS = 10
const COMBO_POINTS = 10
const LVL_COMPL_POINTS = 100

const TXT_CONTINUE = "Press SPACE to continue"
const TXT_FINISHED = "You finished all levels! Thank you for playing. \nPress SPACE to restart."

onready var gems_text = get_node("GemsScore")
onready var time_left_text = get_node("TimeLeftScore")
onready var max_combo_text = get_node("MaxComboScore")
onready var lvl_compl_text = get_node("LVLComplScore")
onready var sum_score = get_node("SumScore")
onready var cont_label = get_node("Continue")

func _ready():

	set_fixed_process(true)

	var gems_score = global.lvl_gems_count * GEM_POINTS
	
	var time_score = global.lvl_time_left * TIME_LEFT_POINTS
	
	var combo_score = global.lvl_max_combo * COMBO_POINTS
	
	var lvl_completed = global.lvl_completed
	var lvl_compl_score = 0
	if(lvl_completed):
		lvl_compl_score = LVL_COMPL_POINTS

	var score = gems_score + time_score + combo_score + lvl_compl_score

	gems_text.set_text(str(global.lvl_gems_count, " x ", GEM_POINTS, " = ", gems_score))
	time_left_text.set_text(str(global.lvl_time_left, " x ", TIME_LEFT_POINTS, " = ", time_score))
	max_combo_text.set_text(str(global.lvl_max_combo, " x ", COMBO_POINTS, " =", combo_score))
	lvl_compl_text.set_text(str(lvl_compl_score))
	sum_score.set_text(str(score, " Points"))
	
	if(global.lvl_index_main == 0):
		cont_label.set_text(TXT_FINISHED)
	else:
		cont_label.set_text(TXT_CONTINUE)

func _fixed_process(delta):
	
	if(Input.is_action_pressed("ui_accept")):
		if(global.lvl_index_main == 0):
			get_tree().change_scene("res://scenes/lvl-1-1.xml")
		else:
			get_tree().change_scene(str("res://scenes/lvl-", global.lvl_index_main, "-", global.lvl_index_sub, ".xml"))