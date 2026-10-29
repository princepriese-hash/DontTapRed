class_name GameHUD
extends Control

signal action_pressed
var lives: int = 3
var level: int = 1
var score: int = 0
var streak: int = 0
var screen_state: String = "READY"
var best_score: int = 0
var wrong_flash: float = 0.0
var debug_enabled: bool = false
var debug_objects: int = 0
var debug_reaction: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	queue_redraw()

func set_values(new_lives: int, new_level: int, new_score: int, new_streak: int, state: String, session_best: int) -> void:
	lives = new_lives; level = new_level; score = new_score; streak = new_streak; screen_state = state; best_score = session_best; queue_redraw()

func set_debug(objects: int, reaction: float) -> void:
	debug_objects = objects; debug_reaction = reaction; queue_redraw()

func wrong_tap_flash() -> void:
	wrong_flash = 0.12; queue_redraw()

func _process(delta: float) -> void:
	wrong_flash = maxf(0.0, wrong_flash - delta)
	queue_redraw()

func _unhandled_key_input(event: InputEvent) -> void:
	if OS.is_debug_build() and event is InputEventKey and event.pressed and event.keycode == KEY_F3:
		debug_enabled = not debug_enabled

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		var touch := event as InputEventScreenTouch
		if screen_state != "PLAYING" and Rect2(size.x * 0.2, size.y * 0.58, size.x * 0.6, 150).has_point(touch.position): action_pressed.emit()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	if wrong_flash > 0.0: draw_rect(Rect2(Vector2.ZERO, size), Color(1, 0.05, 0.1, wrong_flash * 0.35), true)
	draw_string(font, Vector2(40, 70), "LIVES  " + str(lives), HORIZONTAL_ALIGNMENT_LEFT, -1, 38, Color.WHITE)
	draw_string(font, Vector2(size.x * 0.5 - 70, 70), "LEVEL " + str(level), HORIZONTAL_ALIGNMENT_LEFT, -1, 38, Color.WHITE)
	draw_string(font, Vector2(size.x - 300, 70), "SCORE  " + str(score), HORIZONTAL_ALIGNMENT_LEFT, -1, 38, Color.WHITE)
	draw_string(font, Vector2(40, 125), "STREAK  " + str(streak), HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("#19E3FF"))
	if screen_state != "PLAYING":
		draw_rect(Rect2(0, size.y * 0.35, size.x, size.y * 0.45), Color(0.043, 0.059, 0.102, 0.92))
		var title: String = "DON'T TAP RED" if screen_state == "READY" else "GAME OVER"
		draw_string(font, Vector2(size.x * 0.5 - 230, size.y * 0.45), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 58, Color.WHITE)
		if screen_state == "GAME_OVER":
			draw_string(font, Vector2(size.x * 0.5 - 190, size.y * 0.52), "Score %d   Level %d   Best %d" % [score, level, best_score], HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("#FFD84D"))
		draw_rect(Rect2(size.x * 0.2, size.y * 0.58, size.x * 0.6, 150), Color("#2EE6A6"), true)
		draw_string(font, Vector2(size.x * 0.5 - 90, size.y * 0.58 + 95), "START" if screen_state == "READY" else "RETRY", HORIZONTAL_ALIGNMENT_LEFT, -1, 46, Color("#0B0F1A"))
	if OS.is_debug_build() and debug_enabled:
		draw_string(font, Vector2(40, size.y - 80), "FPS %d  OBJECTS %d  REACTION %.3fs" % [Engine.get_frames_per_second(), debug_objects, debug_reaction], HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("#FFD84D"))

