extends CanvasLayer

var hp_bar_textures = []

onready var gem_counter = get_node("GemCounter")
onready var hp_bar = get_node("HPBar")
onready var level_timer_label = get_node("LevelTimer")
onready var overtime_label = get_node("Overtime")
onready var combo_counter = get_node("ComboCounter")
onready var combo_bar = get_node("ComboBar")

onready var player = get_parent()
onready var level_timer = get_tree().get_root().get_node("Level/Timer")

func _ready():
	set_fixed_process(true)
	
	hp_bar_textures.append(load("res://assets/textures/hp_bar_0.tex"))
	hp_bar_textures.append(load("res://assets/textures/hp_bar_1.tex"))
	hp_bar_textures.append(load("res://assets/textures/hp_bar_2.tex"))
	hp_bar_textures.append(load("res://assets/textures/hp_bar_3.tex"))
	
func _fixed_process(delta):
	var gems = player.gem_count
	var hp = player.hp
	var combo = player.combo_count
	var level_time_left = level_timer.get_time_left()
	
	gem_counter.set_text(str(gems))
	hp_bar.set_texture(hp_bar_textures[hp])
	level_timer_label.set_text(str(int(round(level_time_left)), "  seconds"))
	
	if(combo > 1):
		var time_left = player.get_node("ComboTimer").get_time_left()
		var wait_time = player.get_node("ComboTimer").get_wait_time()
		combo_counter.set_hidden(false)
		combo_bar.set_hidden(false)
		combo_counter.set_text(str(combo, "x  Combo"))
		combo_bar.set_value(100 / wait_time * time_left)
		if(level_time_left == 0):
			overtime_label.set_hidden(false)
	else:
		combo_counter.set_hidden(true)
		combo_bar.set_hidden(true)
		overtime_label.set_hidden(true)
	
