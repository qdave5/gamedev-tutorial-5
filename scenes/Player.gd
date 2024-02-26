extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var curr_texture_index : int = 0
var texture_list : Array = [
	preload("res://assets/kenney_platformercharacters/PNG/Adventurer/adventurer_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Female/female_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Player/player_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Soldier/soldier_tilesheet.png"),
	preload("res://assets/kenney_platformercharacters/PNG/Zombie/zombie_tilesheet.png"),
]

var speed : int = 400
var jump_speed : int = -600
var dash_multiplier : int = 2
var GRAVITY : int = 1200

var can_double_jump : bool = true

const UP = Vector2(0,-1)

var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2.ZERO # for animation

var player_sprite : Node2D
var animation_player : AnimationPlayer

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
