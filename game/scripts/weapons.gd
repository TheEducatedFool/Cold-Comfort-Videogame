class_name Weapons
extends RefCounted

## Startwaffen-Katalog für M2 (docs/prototype-plan.md): einfache
## Waffenprofile ohne Traits, Zahlenwerte aus traits.md Abschnitt 0.2, wo
## vorhanden - sonst plausibler Platzhalter, markiert als # TODO Balancing.
## 'make(id)' wird von Unit.setup() über die STATS_*-Dictionaries in
## main.gd aufgerufen (Resources können nicht direkt in einem 'const'
## Dictionary erzeugt werden, deshalb der Umweg über eine String-ID).

static func make(id: String) -> Weapon:
	match id:
		"standard_rifle":
			return standard_rifle()
		"sniper_rifle":
			return sniper_rifle()
		"heavy_machine_gun":
			return heavy_machine_gun()
		"combat_shotgun":
			return combat_shotgun()
		"chain_blade":
			return chain_blade()
		"pistol":
			return pistol()
		"knife":
			return knife()
		"drone_claws":
			return drone_claws()
		"spitter_acid":
			return spitter_acid()
	push_error("Unbekannte Waffen-ID: %s" % id)
	return standard_rifle()


const BLASTER_KIT := "res://assets/kenney_blaster_kit/"

## traits.md 0.2: Reichweite 8, kein AP/SD/Lethal.
static func standard_rifle() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Standard-Sturmgewehr"
	w.weapon_range = 8
	w.model_path = BLASTER_KIT + "blaster-j.glb"
	return w


## traits.md 0.2: Reichweite 12, AP 1, Tödlich 2.
static func sniper_rifle() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Scharfschützengewehr"
	w.weapon_range = 12
	w.ap = 1
	w.lethal = 2
	w.model_path = BLASTER_KIT + "blaster-d.glb"
	return w


## TODO Balancing: nicht in traits.md 0.2 vorgegeben - AP passend zu
## Heavys Rolle (Dauerfeuer/Panzerdurchdringung, classes.md), Zahlenwert
## als Diskussionsgrundlage.
static func heavy_machine_gun() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Schweres MG"
	w.weapon_range = 9
	w.ap = 1
	w.model_path = BLASTER_KIT + "blaster-f.glb"
	return w


## TODO Balancing: Breachers Schrotflinte (classes.md) steht nicht in
## traits.md 0.2 - kurze Reichweite, kleiner Tödlich-Bonus passend zur
## Nahdistanz-Rolle.
static func combat_shotgun() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Kampfschrotflinte"
	w.weapon_range = 4
	w.lethal = 1
	w.model_path = BLASTER_KIT + "blaster-a.glb"
	return w


## traits.md 0.2: Nahkampf, AP 1, Tödlich 1.
static func chain_blade() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Kettenklinge"
	w.weapon_range = 1
	w.is_melee = true
	w.ap = 1
	w.lethal = 1
	return w


## Behelfswaffe ohne besondere Werte (Kamils Playtest-Feedback,
## 2026-08-31): jeder Kämpfer ohne eigene Fernkampfwaffe bekommt sie, damit
## er trotzdem schießen kann - reine Reichweite, kein AP/SD/Lethal.
static func pistol() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Pistole"
	w.weapon_range = 6
	w.model_path = BLASTER_KIT + "blaster-b.glb"
	return w


## Siehe pistol() - dasselbe Prinzip für den Nahkampf.
static func knife() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Kampfmesser"
	w.weapon_range = 1
	w.is_melee = true
	return w


## TODO Balancing: Swarm-Waffen stehen nicht in traits.md, grob an
## Handler-Niveau bzw. niedriger orientiert (prototype-plan.md M2).
static func drone_claws() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Klauen"
	w.weapon_range = 1
	w.is_melee = true
	return w


## TODO Balancing: siehe drone_claws - leichter Schild-Abbau passend zur
## Säure-Flavor.
static func spitter_acid() -> Weapon:
	var w := Weapon.new()
	w.weapon_name = "Säurespucke"
	w.weapon_range = 7
	w.sd = 1
	return w
