extends Node

export(int) var next_lvl_main
export(int) var next_lvl_sub

onready var finish = get_node("Finish")
onready var player = get_node("Player")
onready var timer = get_node("Timer")

func _ready():
	
	finish.connect("body_enter", self, "finish_lvl")
	
func finish_lvl(body):
	if(body extends KinematicBody2D):
		
		global.lvl_gems_count = player.gem_count
		global.lvl_time_left = round(int(timer.get_time_left()))
		
		if(player.combo_count > player.max_combo):
			global.lvl_max_combo = player.combo_count
		else:
			global.lvl_max_combo = player.max_combo
		
		if(player.is_dead == false):
			global.lvl_completed = true
			global.lvl_index_main = next_lvl_main
			global.lvl_index_sub = next_lvl_sub
		else:
			global.lvl_time_left = 0
			global.lvl_max_combo = 0
		
		get_tree().change_scene("res://scenes/lvl_finished.xml")