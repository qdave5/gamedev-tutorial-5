extends Node2D

var player : Node2D
var camera : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	camera = get_node("Camera2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position
	if Input.is_action_just_pressed("ui_restart"):
		reset_player_position()

func reset_player_position():
	player.position = Vector2.ZERO
