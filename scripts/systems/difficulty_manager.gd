class_name DifficultyManager
extends RefCounted

const ANCHORS: Array[Dictionary] = [
	{"level": 1, "objects": 2.0, "red": 1.0, "radius": 150.0, "speed": 0.0, "window": 4.0},
	{"level": 5, "objects": 3.0, "red": 1.0, "radius": 135.0, "speed": 0.0, "window": 3.2},
	{"level": 10, "objects": 5.0, "red": 2.0, "radius": 115.0, "speed": 40.0, "window": 2.6},
	{"level": 25, "objects": 8.0, "red": 3.0, "radius": 90.0, "speed": 160.0, "window": 1.9}
]

func get_params(level: int, performance: float = 0.0) -> DifficultyParams:
	var clamped_level: int = clampi(level, 1, 25)
	var lower: Dictionary = ANCHORS[0]
	var upper: Dictionary = ANCHORS[-1]
	for anchor in ANCHORS:
		if anchor.level <= clamped_level:
			lower = anchor
		if anchor.level >= clamped_level:
			upper = anchor
			break
	var span: float = maxf(1.0, float(upper.level - lower.level))
	var t: float = float(clamped_level - lower.level) / span
	var count: int = clampi(roundi(lerpf(lower.objects, upper.objects, t)), 1, 14)
	var reds: int = clampi(roundi(lerpf(lower.red, upper.red, t)), 0, mini(count / 2, count - 1))
	var wave_window: float = maxf(0.9, lerpf(lower.window, upper.window, t))
	if count > 8:
		wave_window = maxf(1.2, wave_window)
	return DifficultyParams.new(count, reds, maxf(64.0, lerpf(lower.radius, upper.radius, t)), lerpf(lower.speed, upper.speed, t), wave_window)

