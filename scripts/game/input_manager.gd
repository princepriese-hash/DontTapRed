class_name InputManager
extends Node

signal target_tapped(target: Target, reaction: float)
signal empty_tapped(position: Vector2)
var arena: Arena
var enabled: bool = false
var last_touch_position: Vector2 = Vector2.INF
var last_tap_time: float = -100.0
var wave_started_at: int = 0

func setup(target_arena: Arena) -> void:
	arena = target_arena

func begin_wave() -> void:
	wave_started_at = Time.get_ticks_msec()
	enabled = true

func end_wave() -> void:
	enabled = false

func _unhandled_input(event: InputEvent) -> void:
	if not enabled or not (event is InputEventScreenTouch) or not event.pressed: return
	var touch := event as InputEventScreenTouch
	var now: float = Time.get_ticks_msec() / 1000.0
	if now - last_tap_time < 0.08 and touch.position.distance_squared_to(last_touch_position) < 1.0: return
	last_tap_time = now; last_touch_position = touch.position
	var reaction: float = now - float(wave_started_at) / 1000.0
	for target in arena.targets:
		if is_instance_valid(target) and target.active and touch.position.distance_squared_to(target.position) <= (target.radius + 8.0) ** 2:
			target_tapped.emit(target, reaction); return
	empty_tapped.emit(touch.position)

