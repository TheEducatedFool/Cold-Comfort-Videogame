class_name Combat
extends RefCounted

## Kampf-Mathematik – bewusst als reine Funktionen ohne eigenen Zustand,
## damit sie leicht zu testen und später leicht zu erweitern sind.
##
## Regeln:
## - Sichtlinie (Line of Sight): hohe Hindernisse (>= 2 m) blockieren den
##   Schuss komplett, sobald sie WIRKLICH auf der Linie zwischen Schütze und
##   Ziel liegen. Drei leicht versetzte Strahlen (Mittellinie + 2 seitlich)
##   fangen nur das Rasterungs-Problem an Wandkanten ab (siehe unten) –
##   sie blenden keine echten Wände aus, die direkt im Weg stehen.
## - Deckung: Ein Hindernis auf einem Nachbarfeld des Ziels, das grob in
##   Richtung des Schützen liegt, gibt dem Ziel Deckung.
##   Niedrig = halbe Deckung, hoch = volle Deckung.
##   Steht kein Hindernis dazwischen, ist das Ziel FLANKIERT: kein Abzug.
##   'extra_cover' erlaubt zusätzliche, temporäre Deckungsquellen –
##   z. B. Bulwark Stance (das eigene Feld zählt als hohe Deckung).
## - Trefferauflösung: Würfelpool-System, siehe Abschnitt weiter unten
##   sowie docs/dice-system.md. Der Deckungs-Malus hier wird über
##   cover_bonus_dice() in Bonuswürfel übersetzt.

const HALF_COVER_MALUS := 20
const FULL_COVER_MALUS := 40
const FULL_COVER_HEIGHT := 2.0


## Können sich zwei Felder "sehen"? Großzügige Prüfung mit DREI Strahlen:
## der Mittellinie plus zwei seitlich versetzten Linien (das simuliert das
## Lehnen um eine Kante). Sichtlinie besteht, sobald EINER der Strahlen
## frei ist – so blockieren Wandkanten keine Schüsse mehr, die optisch
## offensichtlich frei wären ("Corner-Clipping"-Problem).
static func line_of_sight(grid: GridLogic, from: Vector2i, to: Vector2i) -> bool:
	var a := Vector2(from)
	var b := Vector2(to)
	if _ray_clear(grid, a, b, from, to):
		return true
	var dir := (b - a).normalized()
	var perp := Vector2(-dir.y, dir.x) * 0.4
	if _ray_clear(grid, a + perp, b + perp, from, to):
		return true
	return _ray_clear(grid, a - perp, b - perp, from, to)


## Ein einzelner Sichtstrahl: die Linie wird in kleinen Schritten abgetastet
## und jedes berührte Feld auf hohe Hindernisse geprüft. Nur Schütze- und
## Zielfeld selbst zählen nicht (man blockiert sich nicht selbst die Sicht) –
## ein echtes Wandfeld direkt daneben, das auf der Linie liegt, blockiert
## weiterhin (sonst sieht man durch die eigene Deckung hindurch).
static func _ray_clear(grid: GridLogic, a: Vector2, b: Vector2, from: Vector2i, to: Vector2i) -> bool:
	var steps := int(a.distance_to(b) * 4.0) + 1
	for i in range(1, steps):
		var p := a.lerp(b, float(i) / float(steps))
		var c := Vector2i(roundi(p.x), roundi(p.y))
		if c == from or c == to:
			continue
		if grid.cover_at(c) >= FULL_COVER_HEIGHT:
			return false
	return true


## Deckungs-Abzug für einen Schuss von 'shooter' auf 'target' (0 / 20 / 40).
## 'extra_cover': zusätzliche Deckungsquellen {Feld -> Höhe}, z. B. Bulwark.
static func cover_malus(grid: GridLogic, shooter: Vector2i, target: Vector2i, extra_cover: Dictionary = {}) -> int:
	var dir := Vector2(shooter - target).normalized()
	var best := 0
	for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var n: Vector2i = target + d
		var h: float = maxf(grid.cover_at(n), float(extra_cover.get(n, 0.0)))
		if h <= 0.0:
			continue
		# Zählt das Hindernis als Deckung gegen DIESEN Schützen?
		# Nur, wenn es grob in seine Richtung zeigt (Skalarprodukt > 0.3).
		if Vector2(d).dot(dir) > 0.3:
			var malus := FULL_COVER_MALUS if h >= FULL_COVER_HEIGHT else HALF_COVER_MALUS
			best = maxi(best, malus)
	return best


## Bonuswürfel aus dem geometrischen Deckungs-Malus (0/20/40) ableiten –
## Brücke zwischen der Deckungserkennung oben und dem Würfelpool-
## Bonusschema (dice-system.md Abschnitt 2): keine Deckung (flankiert)
## +2, leichte Deckung +1, volle Deckung +0.
static func cover_bonus_dice(malus: int) -> int:
	if malus >= FULL_COVER_MALUS:
		return 0
	if malus >= HALF_COVER_MALUS:
		return 1
	return 2


## ---------------------------------------------------------------------
## Würfelpool-System (docs/dice-system.md) – hat das alte Prozent-System
## (hit_chance/roll_damage/resolve_damage) ab M3 vollständig abgelöst.
##
## Regeln (dice-system.md Abschnitt 1, 4, 5):
## - d10, Erfolg = Wurf <= Zielwert ("unterboten").
## - Natürliche 10 = automatischer Fehlschlag, unabhängig vom Zielwert.
## - Wurf <= crit_threshold (Standard 1, per Upgrade auf 1-2 erweiterbar)
##   ist ein kritischer Erfolg UND löst einen zusätzlichen Bonuswürfel aus
##   (unbegrenzte Kaskade, gilt für Angriffs- und Verteidigungswürfe).
## ---------------------------------------------------------------------

## Würfelt einen Pool von 'dice' d10 gegen 'target'. 'forced_rolls' ist
## eine optionale, fest vorgegebene Wurffolge für Tests (der Reihe nach
## verbraucht, auch für durch Krits ausgelöste Bonuswürfel) – reicht sie
## nicht aus, wird für die restlichen Würfel echter Zufall verwendet.
## Ohne 'forced_rolls': komplett echter Zufall.
## Rückgabe: {"rolls": alle gewürfelten Werte inkl. Bonuswürfel,
##            "hits": Zahl der Erfolge, "crits": Zahl der Krit-Auslöser}
static func roll_pool(dice: int, target: int, crit_threshold: int = 1, forced_rolls: Array = []) -> Dictionary:
	var rolls: Array[int] = []
	var hits := 0
	var crits := 0
	var pending := dice
	var forced_index := 0
	while pending > 0:
		var this_round := pending
		pending = 0
		for i in this_round:
			var r: int
			if forced_index < forced_rolls.size():
				r = forced_rolls[forced_index]
				forced_index += 1
			else:
				r = randi_range(1, 10)
			rolls.append(r)
			if r == 10:
				continue
			if r <= target:
				hits += 1
			if r <= crit_threshold:
				crits += 1
				pending += 1
	return {"rolls": rolls, "hits": hits, "crits": crits}


## Netto-Erfolge = max(0, Treffer des Angreifers - Erfolge der Verteidigung).
static func net_successes(attack_hits: int, defense_hits: int) -> int:
	return maxi(0, attack_hits - defense_hits)


## Verrechnet Netto-Erfolge durch Schild -> Panzerung -> HP
## (dice-system.md Abschnitt 6). Ein Netto-Erfolg = 1 Schadenspunkt.
## AP/SD senken die jeweilige effektive Schicht vor der Verrechnung,
## Lethal ist ein einmaliger Flat-Bonus, sobald mindestens 1 Punkt HP-
## Schaden übrig bleibt. Kein Mindestschaden – ein Treffer kann komplett
## abgefangen werden.
## Rückgabe: {"shield": Schildschaden, "hp": HP-Schaden}
static func resolve_net_damage(p_net_successes: int, p_ap: int, p_sd: int, p_lethal: int, shield: int, armor: int) -> Dictionary:
	var eff_shield := maxi(shield - p_sd, 0)
	var to_shield := mini(p_net_successes, eff_shield)
	var after_shield := p_net_successes - to_shield
	var eff_armor := maxi(armor - p_ap, 0)
	var damage := maxi(after_shield - eff_armor, 0)
	if damage >= 1:
		damage += p_lethal
	return {"shield": to_shield, "hp": damage}
