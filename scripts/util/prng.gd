class_name PRNG
extends RefCounted

var state: int

func _init(seed_value: int = 1) -> void:
	state = seed_value if seed_value != 0 else 1

func next_u32() -> int:
	state = int((state ^ (state << 13)) & 0x7fffffff)
	state = int((state ^ (state >> 17)) & 0x7fffffff)
	state = int((state ^ (state << 5)) & 0x7fffffff)
	return state

func next_float() -> float:
	return float(next_u32()) / 2147483647.0

func next_int(maximum: int) -> int:
	return 0 if maximum <= 0 else next_u32() % maximum

