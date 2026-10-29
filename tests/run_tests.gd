extends SceneTree

var failures: int = 0

func _init() -> void:
	_test_difficulty()
	_test_score()
	_test_combo()
	_test_prng()
	if failures == 0: print("ALL TESTS PASSED")
	else: print("TEST FAILURES: ", failures)
	quit(1 if failures > 0 else 0)

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1; print("FAIL: ", message)

func _test_difficulty() -> void:
	var manager := DifficultyManager.new()
	for level in range(1, 501):
		var p := manager.get_params(level)
		check(p.object_count >= 1 and p.object_count <= 14, "count bounds")
		check(p.red_count <= p.object_count / 2 and p.red_count < p.object_count, "red bounds")
		check(p.radius >= 64.0 and p.window >= 0.9, "size/window bounds")
		if p.object_count > 8: check(p.window >= 1.2, "large wave window")

func _test_score() -> void:
	var score := ScoreManager.new()
	check(score.points(0.0, 4.0, 0, 1, false) == 15, "base fast score")
	check(score.points(0.0, 4.0, 35, 100, true) == 135, "135 point maximum")
	check(score.wave_bonus(2, false) == 60 and score.wave_bonus(2, true) == 40, "wave bonus")

func _test_combo() -> void:
	var combo := ComboManager.new()
	for i in range(5): combo.register_safe_tap()
	check(combo.multiplier() == 1.5, "five streak")
	for i in range(5): combo.register_safe_tap()
	check(combo.multiplier() == 2.0, "ten streak")
	combo.register_mistake(); check(combo.streak == 5, "halving")

func _test_prng() -> void:
	var a := PRNG.new(99); var b := PRNG.new(99)
	for i in range(20): check(a.next_u32() == b.next_u32(), "PRNG determinism")

