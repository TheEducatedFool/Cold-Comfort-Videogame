class_name Weapon
extends Resource

## Waffenprofil (docs/traits.md Abschnitt 0): AP, SD und Lethal sind
## festes Waffenprofil, keine Traits - jede Waffe hat einen Wert (auch 0).
## Volle Schadenskette: docs/dice-system.md Abschnitt 6.
##
## Nahkampfwaffen (is_melee = true) wirken nur gegen angrenzende Ziele
## (Zone of Control, dice-system.md Abschnitt 3) - weapon_range bleibt bei
## ihnen auf 1, wird aber für echte Reichweiten-Prüfungen nicht benutzt
## (main.gd prüft Nahkampf über Feldabstand, nicht über weapon_range).

@export var weapon_name: String = ""
@export var weapon_range: int = 0
@export var ap: int = 0
@export var sd: int = 0
@export var lethal: int = 0
@export var is_melee: bool = false

## Trait-IDs (0-2 pro Waffe, siehe traits.md Abschnitt 1) - volle
## Trait-Wirkungen kommen erst in M6, hier zunächst nur Platzhalter.
@export var trait_ids: Array[String] = []
