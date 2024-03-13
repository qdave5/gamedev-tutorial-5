extends Node2D

var player : Node2D
var camera : Camera2D

var currMusic = 0
var musicList = [
	preload("res://assets/sound/bgm.wav"),
	preload("res://assets/sound/アトリエと電脳世界_2.mp3")
]

onready var audioStreamPlayer = get_node("AudioStreamPlayer2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	camera = get_node("Camera2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position
	if Input.is_action_just_pressed("ui_restart"):
		reset_player_position()
	if Input.is_action_just_pressed("ui_music"):
		change_music()

func reset_player_position():
	player.position = Vector2.ZERO

func change_music():
	currMusic += 1
	if currMusic >= musicList.size():
		currMusic = 0
	
	audioStreamPlayer.stream = musicList[currMusic]
	audioStreamPlayer.play(0)

