class_name SecondGameManager
extends Node2D

enum GameState { READY, PLAYING, GAME_OVER }

var state: GameState = GameState.READY
var score: int = 0
@onready var spawn_manager: SecondSpawnManager = $SpawnManager
@onready var hud: SecondHUD = $HUD

func _ready() -> void:
	spawn_manager.shape_spawned.connect(_on_shape_spawned)
	_update_hud()

func start_game() -> void:
	score = 0
	state = GameState.PLAYING
	spawn_manager.start_spawning()
	_update_hud()

func _on_shape_spawned(shape: FallingShape) -> void:
	shape.tapped.connect(_on_shape_tapped)

func _unhandled_input(event: InputEvent) -> void:
	if state != GameState.PLAYING: return
	var pressed: bool = event is InputEventScreenTouch and event.pressed
	if event is InputEventMouseButton: pressed = event.pressed
	if not pressed: return
	var touch_position: Vector2 = event.position
	for shape in spawn_manager.shapes:
		if is_instance_valid(shape) and shape.active and Rect2(shape.position - Vector2(shape.size * 0.5, shape.size * 0.5), Vector2.ONE * shape.size).has_point(touch_position):
			shape.tapped.emit(shape)
			return

func _on_shape_tapped(shape: FallingShape) -> void:
	if state != GameState.PLAYING or not shape.active: return
	shape.active = false
	if shape.danger:
		state = GameState.GAME_OVER
		spawn_manager.stop_spawning()
		spawn_manager.clear_shapes()
		hud.wrong_flash()
	else:
		score += 1
		shape.queue_free()
	_update_hud()

func _update_hud() -> void:
	hud.set_state(GameState.keys()[state], score)

