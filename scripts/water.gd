extends Area2D

onready var player = get_parent().get_node("Player")

func _ready():
	connect("body_enter", self, "_player_dies")
	
func _player_dies(body):
	if(body == player):
		player.take_damage(10)
