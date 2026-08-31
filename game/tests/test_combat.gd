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

	# Bugfix M5+: Ziel (6,5) direkt hinter der Wand (5,5) bleibt komplett
	# unsichtbar (weiterhin gueltig, unabhaengig vom Trefferauflösungs-System).
	print("kein Schuss durch echte Wand hindurch: ", \
		Combat.line_of_sight(g, Vector2i(2, 5), Vector2i(6, 5)) == false)

	# Volle Deckung bleibt als eigenstaendige Mechanik nutzbar: Wand liegt am
	# Nachbarfeld des Ziels (nicht auf der Schusslinie selbst) -> Ziel bleibt
	# sichtbar, nur mit Deckungs-Abzug.
	var g2 := GridLogic.new(12, 12)
	g2.blocked[Vector2i(6, 4)] = 2.2  # Wand nördlich neben dem Ziel
	print("volle Deckung neben Ziel blockt Sicht nicht, nur den Bonuswuerfel: ", \
		Combat.line_of_sight(g2, Vector2i(2, 3), Vector2i(6, 5)) == true \
		and Combat.cover_malus(g2, Vector2i(2, 3), Vector2i(6, 5)) == Combat.FULL_COVER_MALUS)

	# Wuerfelpool-Bonusschema (dice-system.md Abschnitt 2): keine Deckung
	# +2, leichte Deckung +1, volle Deckung +0.
	print("Bonuswuerfel keine Deckung: ", Combat.cover_bonus_dice(0) == 2)
	print("Bonuswuerfel leichte Deckung: ", Combat.cover_bonus_dice(Combat.HALF_COVER_MALUS) == 1)
	print("Bonuswuerfel volle Deckung: ", Combat.cover_bonus_dice(Combat.FULL_COVER_MALUS) == 0)

	# Zone of Control (dice-system.md Abschnitt 3, M4): rein geometrisch.
	print("angrenzendes Feld liegt in der ZoC: ", Combat.in_zoc(Vector2i(5, 5), Vector2i(5, 6)) == true)
	print("diagonal liegt NICHT in der ZoC (nur orthogonal, Manhattan 1): ", \
		Combat.in_zoc(Vector2i(5, 5), Vector2i(6, 6)) == false)
	print("zwei Felder entfernt liegt nicht in der ZoC: ", Combat.in_zoc(Vector2i(5, 5), Vector2i(7, 5)) == false)
	print("Wegzug aus angrenzendem Feld verlaesst die ZoC: ", \
		Combat.leaves_zoc(Vector2i(5, 5), Vector2i(5, 3), Vector2i(5, 6)) == true)
	print("Wegzug aus einem Feld ausserhalb der ZoC verlaesst nichts: ", \
		Combat.leaves_zoc(Vector2i(7, 5), Vector2i(8, 5), Vector2i(5, 6)) == false)
	# Ein einzelner orthogonaler Schritt kann geometrisch nie innerhalb der
	# ZoC DESSELBEN Gegners bleiben (zwei Felder mit Manhattan-Distanz 1 zum
	# selben Zentrum haben stets Manhattan-Distanz 2 zueinander) - ein Schritt
	# in ein anderes angrenzendes Feld verlaesst also immer diesen Gegner,
	# koennte aber gleichzeitig in die ZoC eines ANDEREN Gegners hineinfuehren
	# (das behandelt main.gd, nicht diese reine Funktion).
	print("Schritt in ein Feld ausserhalb bleibt kein Sonderfall: ", \
		Combat.leaves_zoc(Vector2i(5, 5), Vector2i(4, 5), Vector2i(5, 6)) == true)
	quit()
