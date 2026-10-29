class_name SpawnManager
extends RefCounted

var prng: PRNG

func _init(seed_value: int = 12345) -> void:
	prng = PRNG.new(seed_value)

func build_wave(params: DifficultyParams, arena: Arena, last_touch: Vector2) -> void:
	var positions: Array[Vector2] = []
	for index in params.object_count:
		var position := _find_position(params.radius, positions, last_touch, arena.arena_size)
		positions.append(position)
		var target := Target.new()
		var red: bool = index < params.red_count
		var angle: float = prng.next_float() * TAU
		target.position = position
		target.setup(red, params.radius, Vector2(cos(angle), sin(angle)) * params.speed)
		arena.add_target(target)
		await arena.get_tree().create_timer(0.4 / maxf(1, params.object_count)).timeout

func _find_position(radius: float, existing: Array[Vector2], last_touch: Vector2, size: Vector2) -> Vector2:
	for attempt in 80:
		var candidate := Vector2(lerpf(radius, size.x - radius, prng.next_float()), lerpf(size.y * 0.12 + radius, size.y * 0.92 - radius, prng.next_float()))
		var valid: bool = last_touch == Vector2.INF or candidate.distance_to(last_touch) >= 150.0 + radius * 0.0
		for other in existing:
			if candidate.distance_to(other) < radius * 2.0 + 16.0: valid = false
		if valid: return candidate
	return Vector2(size.x * 0.5, size.y * 0.55)

