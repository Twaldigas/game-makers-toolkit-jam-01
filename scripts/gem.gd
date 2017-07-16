extends Node2D

onready var area2d = get_node("Area2D")

onready var player = get_tree().get_root().get_node("Level/Player")

func _ready():
	area2d.connect("body_enter", self, "_give_gem_to_player")
	
func _give_gem_to_player(body):
	if(body.get_name() == player.get_name()):
		body.gather_gem()
		self.queue_free()