class_name GridLogic
extends RefCounted

## Reine Logik-Klasse für das Raster.
## Sie weiß, welche Felder existieren, welche blockiert sind (und wie hoch
## das Hindernis dort ist), und rechnet Erreichbarkeit und Wege aus.
## Sie zeichnet NICHTS – Darstellung ist Sache von main.gd.
## Kampf-Mathematik (Sichtlinie, Deckung, Trefferchance): siehe combat.gd.

var width: int
var height: int

# Blockierte Felder: Vector2i -> Hindernishöhe in Metern.
# Niedrig (~1.0) = Kiste / halbe Deckung, hoch (>= 2.0) = Wand / volle Deckung.
var blocked: Dictionary = {}


func _init(w: int, h: int) -> void:
	width = w
	height = h


func is_inside(c: Vector2i) -> bool:
	return c.x >= 0 and c.x < width and c.y >= 0 and c.y < height


func is_walkable(c: Vector2i) -> bool:
	return is_inside(c) and not blocked.has(c)


## Hindernishöhe auf einem Feld (0.0 = frei).
func cover_at(c: Vector2i) -> float:
	return blocked.get(c, 0.0)


## Die vier orthogonalen Nachbarfelder, sofern begehbar und nicht durch
## eine andere Einheit besetzt ('occupied': Vector2i -> true).
func neighbors(c: Vector2i, occupied: Dictionary = {}) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var n: Vector2i = c + d
		if is_walkable(n) and not occupied.has(n):
			result.append(n)
	return result


## Breitensuche (BFS): alle Felder, die von 'start' aus in höchstens
## 'max_cost' Schritten erreichbar sind.
## Rückgabe: Dictionary { Feld (Vector2i) -> Schrittkosten (int) }.
func reachable(start: Vector2i, max_cost: int, occupied: Dictionary = {}) -> Dictionary:
	var cost: Dictionary = {start: 0}
	var frontier: Array[Vector2i] = [start]
	while not frontier.is_empty():
		var current: Vector2i = frontier.pop_front()
		if cost[current] >= max_cost:
			continue
		for n in neighbors(current, occupied):
			if not cost.has(n):
				cost[n] = cost[current] + 1
				frontier.append(n)
	return cost


## Kürzester Weg von 'start' nach 'goal' (BFS mit Vorgänger-Merken).
## Rückgabe: Liste der Felder inklusive Start und Ziel – oder leer,
## wenn kein Weg existiert.
func find_path(start: Vector2i, goal: Vector2i, occupied: Dictionary = {}) -> Array[Vector2i]:
	var empty: Array[Vector2i] = []
	if start == goal or not is_walkable(goal) or occupied.has(goal):
		return empty

	var came_from: Dictionary = {start: start}
	var frontier: Array[Vector2i] = [start]
	while not frontier.is_empty():
		var current: Vector2i = frontier.pop_front()
		if current == goal:
			break
		for n in neighbors(current, occupied):
			if not came_from.has(n):
				came_from[n] = current
				frontier.append(n)

	if not came_from.has(goal):
		return empty

	# Weg rückwärts vom Ziel zum Start einsammeln, dann umdrehen.
	var path: Array[Vector2i] = [goal]
	var c: Vector2i = goal
	while c != start:
		c = came_from[c]
		path.push_front(c)
	return path
