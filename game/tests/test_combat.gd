extends SceneTree
func _init() -> void:
	var g := GridLogic.new(12, 12)
	g.blocked[Vector2i(5, 5)] = 2.2  # Wand
	g.blocked[Vector2i(3, 5)] = 1.0  # Kiste

	# Sichtlinie: Wand bei (5,5) liegt mitten zwischen (1,5) und (9,5)
	print("LOS durch Wand blockiert: ", Combat.line_of_sight(g, Vector2i(1, 5), Vector2i(9, 5)) == false)
	print("LOS auf freier Reihe: ", Combat.line_of_sight(g, Vector2i(1, 1), Vector2i(9, 1)) == true)
	# Bugfix M5+: ein Ziel direkt HINTER einer echten Wand (Wand liegt
	# mitten auf der Schusslinie) darf NICHT sichtbar sein, auch wenn die
	# Wand dem Ziel benachbart ist. Vorher blendete die "Herauslehnen"-Regel
	# jedes wandnahe Feld aus und erlaubte so Sicht/Schuss durch echte Wände.
	print("Ziel direkt hinter echter Wand bleibt verdeckt: ", Combat.line_of_sight(g, Vector2i(1, 5), Vector2i(6, 5)) == false)

	# Deckung: Kiste bei (3,5); Ziel (2,5); Schuetze im Osten (4,5) -> halbe Deckung
	print("halbe Deckung: ", Combat.cover_malus(g, Vector2i(4, 5), Vector2i(2, 5)) == 20)
	# Gleicher Schuetze von Sueden (2,8): Kiste zeigt nicht zu ihm -> flankiert
	print("flankiert: ", Combat.cover_malus(g, Vector2i(2, 8), Vector2i(2, 5)) == 0)
	# Wand bei (5,5); Ziel (6,5); Schuetze im Westen (2,5) -> volle Deckung
	print("volle Deckung: ", Combat.cover_malus(g, Vector2i(2, 5), Vector2i(6, 5)) == 40)

	# Bugfix M5+: Ziel (6,5) direkt hinter der Wand (5,5) ist jetzt komplett
	# unsichtbar -> kein Schuss möglich, nicht mehr "32% durch die Wand".
	var s := Unit.new()
	s.cell = Vector2i(2, 5); s.base_aim = 80; s.aim_falloff = 2.0; s.attack_range = 10
	var t := Unit.new()
	t.cell = Vector2i(6, 5)
	print("kein Schuss durch echte Wand hindurch: ", Combat.hit_chance(s, t, g) == -1)
	# Ausser Reichweite
	s.attack_range = 3
	print("ausser Reichweite -1: ", Combat.hit_chance(s, t, g) == -1)
	s.free(); t.free()

	# Volle Deckung bleibt als eigenständige Mechanik nutzbar: Wand liegt am
	# Nachbarfeld des Ziels (nicht auf der Schusslinie selbst) -> Ziel bleibt
	# sichtbar und treffbar, nur mit Abzug. aim 80, falloff 2.0, Distanz
	# sqrt(20)=4.47, volle Deckung -> 80-40-int(8.94) = 32.
	var g2 := GridLogic.new(12, 12)
	g2.blocked[Vector2i(6, 4)] = 2.2  # Wand nördlich neben dem Ziel
	var s2 := Unit.new()
	s2.cell = Vector2i(2, 3); s2.base_aim = 80; s2.aim_falloff = 2.0; s2.attack_range = 10
	var t2 := Unit.new()
	t2.cell = Vector2i(6, 5)
	print("volle Deckung neben Ziel blockt Sicht nicht, nur Trefferchance (32): ", \
		Combat.line_of_sight(g2, s2.cell, t2.cell) == true and Combat.hit_chance(s2, t2, g2) == 32)
	s2.free(); t2.free()
	quit()
