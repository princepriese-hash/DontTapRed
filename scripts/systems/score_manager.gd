class_name ScoreManager
extends RefCounted

func points(reaction: float, window: float, streak: int, level: int, risky: bool) -> int:
	var speed_factor: float = 1.0 + 0.5 * clampf(1.0 - reaction / maxf(window, 0.001), 0.0, 1.0)
	var combo_mult: float = 3.0 if streak >= 35 else (2.5 if streak >= 20 else (2.0 if streak >= 10 else (1.5 if streak >= 5 else 1.0)))
	var diff_mult: float = 1.0 + 0.015 * mini(level, 100)
	var risk_factor: float = 1.2 if risky else 1.0
	return roundi(10.0 * speed_factor * combo_mult * diff_mult * risk_factor)

func wave_bonus(level: int, mistake: bool) -> int:
	return roundi(20.0 * level * (1.0 if mistake else 1.5))

