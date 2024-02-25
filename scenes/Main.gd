extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_restart"):
		reset_player_position()

func reset_player_position():
	player.position = get_viewport_rect().size / 2.0
