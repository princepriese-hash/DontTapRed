class_name FallingShape
extends Node2D

signal tapped(shape: FallingShape)

var danger: bool = false
var size: float = 64.0
var fall_speed: float = 260.0
var active: bool = true

func configure(is_danger: bool, square_size: float, speed: float) -> void:
	danger = is_danger
	size = square_size
	fall_speed = speed
	queue_redraw()

func _process(delta: float) -> void:
	position.y += fall_speed * minf(delta, 0.05)
	queue_redraw()
	if position.y > 1020.0:
		active = false
		queue_free()

func _draw() -> void:
	var color := Color("#FF334D") if danger else Color("#2EE6A6")
	draw_rect(Rect2(-size * 0.5, -size * 0.5, size, size), color, true)
	draw_rect(Rect2(-size * 0.5, -size * 0.5, size, size), Color.WHITE, false, 4.0)
	if danger:
		draw_line(Vector2(-18, -18), Vector2(18, 18), Color.WHITE, 5.0)
		draw_line(Vector2(18, -18), Vector2(-18, 18), Color.WHITE, 5.0)

