class_name GameSession
extends Node

enum State { READY, PLAYING, WAVE_CLEAR, GAME_OVER }
var state: State = State.READY
var lives: int = 3
var level: int = 1
var score: int = 0
var best_score: int = 0
var wave_mistake: bool = false
var wave_time: float = 0.0
var params: DifficultyParams
var difficulty := DifficultyManager.new()
var scoring := ScoreManager.new()
var combo := ComboManager.new()
var spawn := SpawnManager.new(20261029)
@onready var arena: Arena = $Arena
@onready var input_manager: InputManager = $InputManager
@onready var hud: GameHUD = $HUD

func _ready() -> void:
	arena.arena_size = Vector2(1080, 1920)
	input_manager.setup(arena)
	input_manager.target_tapped.connect(_on_target_tapped)
	input_manager.empty_tapped.connect(_on_empty_tapped)
	hud.action_pressed.connect(start_or_retry)
	_update_hud()

func start_or_retry() -> void:
	lives = 3; level = 1; score = 0; combo.reset(); state = State.PLAYING
	_start_wave()

func _start_wave() -> void:
	state = State.PLAYING; wave_mistake = false; wave_time = 0.0; params = difficulty.get_params(level)
	arena.clear_targets(); input_manager.begin_wave(); _update_hud()
	spawn.build_wave(params, arena, input_manager.last_touch_position)

func _process(delta: float) -> void:
	if state != State.PLAYING: return
	wave_time += minf(delta, 0.05)
	var safe_left: int = 0
	for target in arena.targets:
		if is_instance_valid(target) and not target.is_red: safe_left += 1
	if safe_left == 0:
		_finish_wave(); return
	if level >= 4 and wave_time >= params.window:
		for target in arena.targets:
			if is_instance_valid(target) and not target.is_red: lives -= 1
		_finish_wave()
	elif level < 4 and wave_time >= params.window:
		# Early levels intentionally wait until the safe target is tapped.
		wave_time = 0.0

func _on_target_tapped(target: Target, reaction: float) -> void:
	if state != State.PLAYING or not is_instance_valid(target): return
	if target.is_red:
		lives -= 1; wave_mistake = true; combo.register_mistake(); _update_hud()
		if lives <= 0: _game_over()
		return
	var risky: bool = false
	for other in arena.targets:
		if other.is_red and target.position.distance_to(other.position) <= target.radius * 1.5: risky = true
	combo.register_safe_tap()
	score += scoring.points(reaction, params.window, combo.streak, level, risky)
	arena.remove_target(target); _update_hud()
	if _safe_count() == 0: _finish_wave()

func _on_empty_tapped(_position: Vector2) -> void:
	pass

func _safe_count() -> int:
	var result: int = 0
	for target in arena.targets:
		if is_instance_valid(target) and not target.is_red: result += 1
	return result

func _finish_wave() -> void:
	if state != State.PLAYING: return
	state = State.WAVE_CLEAR; input_manager.end_wave()
	if _safe_count() == 0: score += scoring.wave_bonus(level, wave_mistake)
	if lives <= 0: _game_over(); return
	if level % 10 == 0: lives = mini(3, lives + 1)
	best_score = maxi(best_score, score); _update_hud()
	await get_tree().create_timer(0.4).timeout
	level += 1; _start_wave()

func _game_over() -> void:
	state = State.GAME_OVER; input_manager.end_wave(); arena.clear_targets(); best_score = maxi(best_score, score); _update_hud()

func _update_hud() -> void:
	hud.set_values(lives, level, score, combo.streak, State.keys()[state], best_score)

