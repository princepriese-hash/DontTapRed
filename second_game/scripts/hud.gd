class_name SecondHUD
extends Control

var state: String = "READY"
var score: int = 0
var flash: float = 0.0

func set_state(new_state: String, new_score: int) -> void:
	state = new_state
	score = new_score
	queue_redraw()

func wrong_flash() -> void:
	flash = 0.16

func _process(delta: float) -> void:
	flash = maxf(0.0, flash - delta)
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if state != "PLAYING" and ((event is InputEventScreenTouch and event.pressed) or (event is InputEventMouseButton and event.pressed)):
		var position: Vector2 = event.position
		if Rect2(120, 500, 300, 100).has_point(position): get_parent().start_game()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	if flash > 0.0: draw_rect(Rect2(Vector2.ZERO, size), Color(1, 0.05, 0.1, flash * 0.4), true)
	draw_string(font, Vector2(24, 52), "SCORE  " + str(score), HORIZONTAL_ALIGNMENT_LEFT, -1, 32, Color.WHITE)
	if state != "PLAYING":
		draw_rect(Rect2(0, 300, size.x, 420), Color(0.043, 0.059, 0.102, 0.94), true)
		draw_string(font, Vector2(90, 400), "DON'T TAP RED", HORIZONTAL_ALIGNMENT_LEFT, -1, 42, Color.WHITE)
		if state == "GAME_OVER": draw_string(font, Vector2(170, 465), "Score: " + str(score), HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("#FFD84D"))
		draw_rect(Rect2(120, 500, 300, 100), Color("#19E3FF"), true)
		draw_string(font, Vector2(200, 565), "START" if state == "READY" else "RETRY", HORIZONTAL_ALIGNMENT_LEFT, -1, 34, Color("#0B0F1A"))

