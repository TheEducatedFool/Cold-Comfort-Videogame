extends SceneTree
## Schadensformel selbst (Combat.resolve_net_damage) wird in
## tests/test_dice_pool.gd getestet - hier nur die Schild-Regeneration,
## die unabhaengig vom Trefferauflösungs-System funktioniert.
func _init() -> void:
	# Schild-Aufladung: bedingungslos +1/Runde, auch wenn getroffen
	# (Halo-Flashpoint-Prinzip).
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
