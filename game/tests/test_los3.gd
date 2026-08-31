extends SceneTree
func _init() -> void:
	var g := GridLogic.new(12, 12)
	g.blocked[Vector2i(5, 5)] = 2.2
	# Linie streift die Wandkante (rundet auf die Wandzelle) -> alter Code blockierte
	print("Kanten-Streifschuss jetzt frei: ", Combat.line_of_sight(g, Vector2i(2, 4), Vector2i(8, 5)) == true)
	print("Gegenrichtung ebenso: ", Combat.line_of_sight(g, Vector2i(8, 5), Vector2i(2, 4)) == true)

	# Regressionstest: eine echte Wand direkt neben dem Schützen, die auf der
	# geraden Linie zum Ziel liegt, muss weiterhin blockieren (Bugfix M5+:
	# "Herauslehnen"-Regel hat das fälschlich durchgewinkt).
	var g2 := GridLogic.new(12, 12)
	g2.blocked[Vector2i(3, 2)] = 2.2
	print("Wand direkt neben Schütze blockiert weiterhin: ", Combat.line_of_sight(g2, Vector2i(2, 2), Vector2i(6, 2)) == false)

	# Gleiche Wand direkt neben dem ZIEL (statt dem Schützen) muss ebenso blockieren.
	var g3 := GridLogic.new(12, 12)
	g3.blocked[Vector2i(5, 2)] = 2.2
	print("Wand direkt neben Ziel blockiert weiterhin: ", Combat.line_of_sight(g3, Vector2i(2, 2), Vector2i(6, 2)) == false)
	quit()
