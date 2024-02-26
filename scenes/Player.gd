extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var curr_texture_index = 0
var texture_list = [
	preload("res://assets/kenney_platformercharacters/PNG/Adventurer/adventurer_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Female/female_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Player/player_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Soldier/soldier_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Zombie/zombie_tilesheet.png"),
]

export (int) var speed = 400
export (int) var jump_speed = -600
export (int) var dash_multiplier = 2
export (int) var GRAVITY = 1200

export (bool) var can_double_jump = true

const IDLE = 'idle'
const IS_MOVING = 'is_moving'
const IS_CROUCHING = 'is_crouching'
const DASH = 'dash'
const JUMP = 'jump'

const UP = Vector2(0,-1)

var velocity = Vector2()
var direction : Vector2 = Vector2.ZERO # for animation

var player_sprite
var animation_player

# Called when the node enters the scene tree for the first time.
func _ready():
	player_sprite = get_node("Sprite")
	animation_player = get_node("AnimationPlayer")

func get_input():
	velocity.x = 0
	if is_on_floor():
		can_double_jump = true
		if Input.is_action_pressed("ui_crouch"):
			speed = 200
		else:
			speed = 400
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
		elif can_double_jump:
			velocity.y = jump_speed
			can_double_jump = false
	if Input.is_action_pressed("ui_dash"):
		velocity.x *= dash_multiplier

func update_animation():
	if is_on_floor():
		if Input.is_action_pressed("ui_crouch"):
			animation_player.play("crouch")
		elif direction != Vector2.ZERO:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	else:
		if velocity.y < 0:
			animation_player.play("jump_up")
		else:
			animation_player.play("jump_down")
	
	if Input.is_action_pressed("ui_dash") and direction.x != 0:
		animation_player.play("dash")
	
	if Input.is_action_pressed("ui_right"):
		player_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		player_sprite.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	update_animation()
	
	if Input.is_action_just_pressed("ui_interact"):
		increase_curr_texture_index()
		player_sprite.texture = texture_list[curr_texture_index]

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)

func increase_curr_texture_index():
	curr_texture_index += 1
	if curr_texture_index >= texture_list.size():
		curr_texture_index = 0
