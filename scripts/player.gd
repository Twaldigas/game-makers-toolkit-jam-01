extends KinematicBody2D

const HP_MAX = 3
const WEAPON_DAMAGE = 1
const GRAVITY = 2000.0
const WALK_SPEED = 400
const JUMP_FORCE = 600
const MAX_JUMP_COUNT = 1

var velocity = Vector2()

var hp = HP_MAX
var jump_count = 0
var combo_count = 0
var max_combo = 0
var gem_count = 0

var is_attacking = false
var is_invulnerable = false
var is_dead = false

onready var anim_sprite = get_node("CharAnimatedSprite")
onready var anim_sprite2 = get_node("SlashAnimatedSprite")
onready var weap_area2d = get_node("WeaponArea2D")
onready var combo_timer = get_node("ComboTimer")
onready var invulnerable_timer = get_node("InvulnerableTimer")
onready var sampl_pl = get_node("CharAnimatedSprite/SamplePlayer")

onready var lvl_timer = get_parent().get_node("Timer")

func _ready():
	set_fixed_process(true)
	
	anim_sprite.connect("finished", self, "_not_attacking")
	anim_sprite2.connect("finished", self, "_not_slashing")
	weap_area2d.connect("body_enter", self, "_damage_enemy")
	combo_timer.connect("timeout", self, "_combo_break")
	invulnerable_timer.connect("timeout", self, "_not_invulnerable")
	
func _fixed_process(delta):
	
	_process_dead()
	_process_attack(delta)
	_process_movement(delta)
	
	anim_sprite.play(anim_sprite.get_animation())
	
	if(is_invulnerable):
		set_opacity(0.5)
	else:
		set_opacity(1)

func _process_movement(delta):
	
	velocity.y += delta * GRAVITY
	
	  # Stand, walk left or walk right
	
	if(Input.is_action_pressed("ui_left")):
		velocity.x = -WALK_SPEED
		if(is_attacking == false):
			anim_sprite.set_animation("walking")
		anim_sprite.set_flip_h(true)
		anim_sprite2.set_flip_h(true)
		weap_area2d.get_node("CollisionShape2D").set_pos(Vector2(-19, 4))
	elif(Input.is_action_pressed("ui_right")):
		velocity.x = WALK_SPEED
		if(is_attacking == false):
			anim_sprite.set_animation("walking")
		anim_sprite.set_flip_h(false)
		anim_sprite2.set_flip_h(false)
		weap_area2d.get_node("CollisionShape2D").set_pos(Vector2(19, 4))
	else:
		velocity.x = 0
		if(is_attacking == false):
			anim_sprite.set_animation("standing")
	
	# Jump
	
	if(Input.is_action_pressed("ui_up") and jump_count < MAX_JUMP_COUNT):
		velocity.y = -JUMP_FORCE
		jump_count += 1
	
	var motion = velocity * delta
	motion = move(motion)
	
	if(is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
		
		if(n == Vector2(0, -1)):
			jump_count = 0
	
func _process_attack(delta):
	
	if(Input.is_action_pressed("ui_accept")):
		anim_sprite.set_animation("attacking")
		weap_area2d.set_collision_mask(1)
		weap_area2d.set_layer_mask(1)
		is_attacking = true
		anim_sprite2.set_animation("slashing")
		anim_sprite2.set_hidden(false)
		anim_sprite2.play(anim_sprite2.get_animation())
		

func _process_dead():
	
	if(is_dead):
		get_parent().finish_lvl(self)
	
	var level_time_left = lvl_timer.get_time_left()
	if(level_time_left == 0 && combo_count < 2):
		is_dead = true
		

func _not_attacking():
	
	if(anim_sprite.get_animation() == "attacking"):
		weap_area2d.set_collision_mask(0)
		weap_area2d.set_layer_mask(0)
		is_attacking = false

func _not_invulnerable():
	is_invulnerable = false

func _not_slashing():
	anim_sprite2.stop()
	anim_sprite2.set_hidden(true)
	anim_sprite2.set_frame(0)
	
func _combo_break():
	if(combo_count > max_combo):
		max_combo = combo_count
	combo_count = 0

func take_damage(damage):
	
	if(is_invulnerable == false):
		
		hp += - damage
		_combo_break()
		is_invulnerable = true
		invulnerable_timer.start()
		sampl_pl.play("Hit_Hurt", true)
	
	if(hp <= 0):
		hp = 0
		is_dead = true
	
func _heal(health):
	
	if(hp + health > HP_MAX):
		hp = HP_MAX
	else:
		hp += health
		
func gather_gem():
	gem_count += 1
	combo_count += 1
	combo_timer.stop()
	combo_timer.start()
	sampl_pl.play("Pickup_Coin", true)
	
func _damage_enemy(body):
	if(body != self && body extends KinematicBody2D):
		body.take_damage(WEAPON_DAMAGE)
	
func enemy_destroyed():
	combo_count += 1
	combo_timer.stop()
	combo_timer.start()