extends KinematicBody2D

const HP = 1
const GRAVITY = 2000.0
const WALK_SPEED = 400

var hp = HP
var movement = 50

var is_dying = false

onready var anim_sprite = get_node("AnimatedSprite")
onready var area2d = get_node("Area2D")
onready var sample_pl = get_node("SamplePlayer")

onready var player = get_tree().get_root().get_node("Level/Player")

func _ready():
	set_fixed_process(true)
	
	anim_sprite.connect("finished", self, "_delete_object")
	area2d.connect("body_enter", self, "_damage_player")
	
func _fixed_process(delta):
	get_parent().set_offset(get_parent().get_offset() + (movement * delta))
	
func _delete_object():
	if(anim_sprite.get_animation() == "dying"):
		self.queue_free()
	
func _damage_player(body):
	if(is_dying == false):
		if(body != self && body extends KinematicBody2D):
			player.take_damage(1)
	
func take_damage(damage):
		hp += -damage
		if(hp >= 0):
			_die()
		
func _die():
	player.enemy_destroyed()
	set_collision_mask(0)
	set_layer_mask(0)
	set_opacity(0.5)
	movement = 0
	is_dying = true
	sample_pl.play("Dying", true)
	anim_sprite.set_animation("dying")