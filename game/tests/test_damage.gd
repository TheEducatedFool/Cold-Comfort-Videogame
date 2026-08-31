extends SceneTree
func _init() -> void:
	# resolve_damage(roll, ap, lethal, shield, armor) -> {"shield","hp"}
	var r: Dictionary

	r = Combat.resolve_damage(3, 0, 0, 0, 3)
	print("Panzerung schluckt alles: ", r["shield"] == 0 and r["hp"] == 0)

	r = Combat.resolve_damage(3, 0, 1, 2, 0)
	print("Schild 2 bricht, 1 durch +Toedlich 1 = 2 HP: ", r["shield"] == 2 and r["hp"] == 2)

	r = Combat.resolve_damage(2, 0, 5, 3, 0)
	print("Voll vom Schild geschluckt, Toedlich wirkungslos: ", r["shield"] == 2 and r["hp"] == 0)

	r = Combat.resolve_damage(3, 2, 1, 0, 2)
	print("AP 2 neutralisiert Panzerung 2 -> 3+1=4 HP: ", r["shield"] == 0 and r["hp"] == 4)

	r = Combat.resolve_damage(1, 0, 5, 0, 1)
	print("Panzerung blockt, Toedlich wirkungslos: ", r["hp"] == 0)

	r = Combat.resolve_damage(4, 1, 0, 1, 2)
	print("Gemischt: 1 Schild, Rest 3 - (2-1) = 2 HP: ", r["shield"] == 1 and r["hp"] == 2)

	# Schild-Aufladung (v0.9: bedingungslos +1/Runde, auch wenn getroffen –
	# regen_shield() hat "took_damage_this_round"/recharge_shield() ersetzt).
	var u := Unit.new()
	u.max_shield = 2; u.shield = 0
	u.regen_shield()
	print("Rundenende (auch nach Treffer) -> +1 Schild: ", u.shield == 1)
	u.regen_shield()
	print("Zweites Rundenende -> voll aufgeladen: ", u.shield == 2)
	u.regen_shield()
	print("Deckelt bei max_shield: ", u.shield == 2)
	u.free()
	quit()
