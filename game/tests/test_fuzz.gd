extends SceneTree
var m: Node
var frames := 0
var actions_done := 0
func _initialize() -> void:
	Engine.time_scale = 6.0
	seed(Time.get_ticks_usec())
	var scene := load("res://scenes/main.tscn") as PackedScene
	m = scene.instantiate()
	root.add_child(m)
func _process(_d: float) -> bool:
	frames += 1
	if m.game_over:
		print("SPIEL ENDE: Aktionen=", actions_done, " Runde=", m.round_num, " Einheiten=", m.units.size())
		return true
	if Time.get_ticks_msec() > 170000:
		print("TIMEOUT (kein Fehler): Runde=", m.round_num, " Aktionen=", actions_done)
		return true
	if frames % 4 != 0:
		return false
	if not m.player_turn or m._any_moving() or m.anim_busy:
		return false
	var sel = m.selected
	if sel == null or not is_instance_valid(sel) or sel.activated:
		for p in m._players():
			if not p.activated:
				m._select(p)
				break
		sel = m.selected
		if sel == null or not is_instance_valid(sel) or sel.activated:
			return false
	actions_done += 1
	var r := randi() % 100
	if r < 35:
		var enemies = m._enemies()
		enemies.shuffle()
		for e in enemies:
			if m._can_attack_melee(sel, e):
				if m._commit(sel):
					m._player_attack(sel, e, true)
				return false
			if m._can_attack_ranged(sel, e):
				if m._commit(sel):
					m._player_attack(sel, e, false)
				return false
		m._end_activation()
	elif r < 65:
		var cells = m.highlight_nodes.keys()
		cells.shuffle()
		if cells.is_empty():
			m._end_activation()
		else:
			m._try_move_selected(cells[0])
	elif r < 75:
		m._do_overwatch()
	elif r < 92:
		m._use_ability_slot(randi() % 2)
		if m.pending_ability != "":
			var all = m.units.duplicate()
			all.shuffle()
			var t = all[0] if randi() % 10 > 0 else null
			m._resolve_pending_ability(t)
	else:
		m._end_activation()
	return false
