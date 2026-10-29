class_name Target
extends Node2D

var is_red: bool = false
var radius: float = 100.0
var velocity: Vector2 = Vector2.ZERO
var pulse_time: float = 0.0
var active: bool = true

func setup(red: bool, target_radius: float, movement: Vector2) -> void:
	is_red = red
	radius = target_radius
	velocity = movement
	queue_redraw()

func _process(delta: float) -> void:
	pulse_time += delta
	queue_redraw()

func _draw() -> void:
	if not active: return
	if is_red:
		var octagon := PackedVector2Array()
		for index in 8:
			var angle: float = TAU * float(index) / 8.0 + PI / 8.0
			octagon.append(Vector2(cos(angle), sin(angle)) * radius)
		draw_colored_polygon(octagon, Color("#FF2D3D"))
		var outline_alpha: float = 0.35 + 0.3 * (0.5 + 0.5 * sin(pulse_time * 2.2))
		draw_polyline(octagon + PackedVector2Array([octagon[0]]), Color(1, 1, 1, outline_alpha), 7.0, true)
		var cross: float = radius * 0.42
		draw_line(Vector2(-cross, -cross), Vector2(cross, cross), Color.WHITE, 12.0, true)
		draw_line(Vector2(cross, -cross), Vector2(-cross, cross), Color.WHITE, 12.0, true)
	else:
		draw_circle(Vector2.ZERO, radius, Color("#2EE6A6"))
		draw_circle(Vector2.ZERO, radius * 0.72, Color("#19E3FF" if int(position.x + position.y) % 3 == 0 else "#FFD84D"))

