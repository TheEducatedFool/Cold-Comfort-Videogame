extends SceneTree
func _init() -> void:
	# roll_pool(dice, target, crit_threshold, forced_rolls) -> {"rolls","hits","crits"}
	var r: Dictionary

	# Normaler Pool: keine Krits, keine natuerliche 10.
	var seq1: Array[int] = [3, 8, 6]
	r = Combat.roll_pool(3, 6, 1, seq1)
	print("normaler Pool - 2 Treffer, keine Krits, keine Kaskade: ", \
		r["hits"] == 2 and r["crits"] == 0 and r["rolls"].size() == 3)

	# Krit-Kaskade: zwei aufeinanderfolgende Einsen loesen je einen
	# Bonuswuerfel aus, die Kaskade endet erst, wenn kein Bonuswuerfel mehr
	# selbst eine 1 wuerfelt.
	var seq2: Array[int] = [1, 5, 1, 9]
	r = Combat.roll_pool(2, 8, 1, seq2)
	print("Krit-Kaskade - 3 Treffer, 2 Krits, 4 Wuerfel insgesamt: ", \
		r["hits"] == 3 and r["crits"] == 2 and r["rolls"] == seq2)

	# Natuerliche 10 inmitten eines Pools: automatischer Fehlschlag, auch
	# wenn der Zielwert 10 waere (0 waere sonst ein Treffer).
	var seq3: Array[int] = [5, 10, 3]
	r = Combat.roll_pool(3, 10, 1, seq3)
	print("natuerliche 10 zaehlt nicht als Treffer, Rest normal: ", \
		r["hits"] == 2 and r["crits"] == 0 and r["rolls"] == seq3)

	# Netto-Erfolge.
	print("Netto-Erfolge 5 vs 2 Verteidigung = 3: ", Combat.net_successes(5, 2) == 3)
	print("Netto-Erfolge 0, wenn Verteidigung gewinnt: ", Combat.net_successes(2, 3) == 0)

	# Volle Schadenskette mit AP/SD/Lethal.
	# resolve_net_damage(netto, ap, sd, lethal, shield, armor)
	# Schild 3 - SD 1 = eff. Schild 2 -> 2 Punkte absorbiert, Rest 3.
	# Panzerung 2 - AP 1 = eff. Panzerung 1 -> Schaden 3-1=2, + Lethal 2 = 4.
	r = Combat.resolve_net_damage(5, 1, 1, 2, 3, 2)
	print("volle Schadenskette AP/SD/Lethal - 2 Schild, 4 HP: ", \
		r["shield"] == 2 and r["hp"] == 4)

	# Netto-Erfolge = 0 -> kompletter Fehlschlag, Lethal greift nicht.
	r = Combat.resolve_net_damage(0, 0, 0, 5, 0, 0)
	print("Netto-Erfolge 0 - kein Schaden trotz Lethal: ", \
		r["shield"] == 0 and r["hp"] == 0)

	quit()
