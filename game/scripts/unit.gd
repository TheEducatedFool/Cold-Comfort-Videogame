class_name Unit
extends Node3D

## Eine Einheit auf dem Raster – Soldat oder Swarm-Kreatur.
## Kümmert sich um Darstellung, Werte und die Lauf-Animation.
## Die Regeln (wer darf wann was) liegen in main.gd,
## die Kampf-Mathematik in combat.gd.

signal move_finished

enum Faction { PLAYER, SWARM }

var unit_name: String = ""
var faction: int = Faction.PLAYER

## Auf welchem Rasterfeld die Einheit (logisch) steht.
var cell: Vector2i = Vector2i.ZERO

## true, solange die Lauf-Animation spielt – dann werden Klicks ignoriert.
var is_moving: bool = false

# --- Verteidigung (Schadensmodell: Schild -> Panzerung -> HP) -------------
# * HP bleiben NIEDRIG (3–6) und wachsen kaum.
# * SCHILD schluckt Schaden zuerst, 1:1. Regeneriert um GENAU 1 Punkt pro
#   Runde – unabhängig davon, ob die Einheit getroffen wurde
#   (Halo-Flashpoint-Prinzip).
# * PANZERUNG reduziert danach den Restschaden um ihren festen Wert –
#   ein Treffer kann komplett abprallen, es gibt KEINEN Mindestschaden.
var max_hp: int = 5
var hp: int = 5
var max_shield: int = 0
var shield: int = 0
var armor: int = 0

# --- Angriff ---------------------------------------------------------------
var base_aim: int = 80        # Grund-Trefferchance in %
var aim_falloff: float = 2.0  # Abzug pro Feld Entfernung
var dmg_min: int = 1
var dmg_max: int = 3
var ap: int = 0               # Panzerbrech-Wert
var lethal: int = 0           # Tödlich-Wert
var attack_range: int = 10    # in Feldern; 1 = Nahkampf
var move_range: int = 5       # Felder pro Bewegungs-Aktion
var actions: int = 0          # verbleibende Aktionen in diesem Zug

# --- Status & Fähigkeiten --------------------------------------------------
var activated: bool = false      # hat diese Runde schon aktiviert
var overwatch: bool = false      # wartet auf Reaktionsschuss
var sentry: bool = false         # Roan-Passiv: Overwatch ohne Malus
var bulwark: bool = false        # Okafor: wirkt als hohe Deckung für Nachbarn
var shocked: bool = false        # Gegner: nächste Aktivierung fällt aus
var rush_move: bool = false      # Slug Rush aktiviert, Bewegung steht aus
var free_shot: bool = false      # nächster Schuss kostet keine Aktion
var abilities: Array = []        # Fähigkeits-IDs, z. B. ["mend", "shock"]
var cooldowns: Dictionary = {}   # Fähigkeits-ID -> verbleibende Runden

var hp_label: Label3D
var shield_bubble: MeshInstance3D


func setup(p_name: String, p_faction: int, color: Color, stats: Dictionary) -> void:
	unit_name = p_name
	faction = p_faction
	max_hp = stats.get("hp", 5)
	hp = max_hp
	max_shield = stats.get("shield", 0)
	shield = max_shield
	armor = stats.get("armor", 0)
	base_aim = stats.get("aim", 80)
	aim_falloff = stats.get("falloff", 2.0)
	dmg_min = stats.get("dmg_min", 1)
	dmg_max = stats.get("dmg_max", 3)
	ap = stats.get("ap", 0)
	lethal = stats.get("lethal", 0)
	attack_range = stats.get("range", 10)
	move_range = stats.get("move", 5)
	sentry = stats.get("sentry", false)
	abilities = stats.get("abilities", [])

	# Platzhalter-Körper: Kapsel für Soldaten, gedrungene Kugel für den Swarm.
	var body := MeshInstance3D.new()
	if faction == Faction.SWARM:
		var blob := SphereMesh.new()
		blob.radius = 0.55
		blob.height = 0.9
		body.mesh = blob
		body.position.y = 0.45
	else:
		var capsule := CapsuleMesh.new()
		capsule.radius = 0.4
		capsule.height = 1.6
		body.mesh = capsule
		body.position.y = 0.8
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	body.material_override = mat
	add_child(body)

	# Rigger-Drohne: kleiner schwebender Würfel, der neben der Einheit wippt.
	if abilities.has("mend") or abilities.has("shock"):
		var drone := MeshInstance3D.new()
		var cube := BoxMesh.new()
		cube.size = Vector3(0.3, 0.3, 0.3)
		drone.mesh = cube
		var dmat := StandardMaterial3D.new()
		dmat.albedo_color = Color("8fd8e8")
		drone.material_override = dmat
		drone.position = Vector3(0.7, 1.5, 0.3)
		add_child(drone)
		var bob := drone.create_tween()
		bob.set_loops()
		bob.tween_property(drone, "position:y", 1.75, 0.9) \
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		bob.tween_property(drone, "position:y", 1.5, 0.9) \
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Sichtbare Energieschild-Blase (nur bei Einheiten mit Schild).
	if max_shield > 0:
		shield_bubble = MeshInstance3D.new()
		var bubble := SphereMesh.new()
		bubble.radius = 0.8
		bubble.height = 1.9
		shield_bubble.mesh = bubble
		var smat := StandardMaterial3D.new()
		smat.albedo_color = Color(0.4, 0.85, 1.0, 0.14)
		smat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		smat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		shield_bubble.material_override = smat
		shield_bubble.position.y = 0.9
		add_child(shield_bubble)

	# Schwebendes Namens-/Werte-Schild, dreht sich immer zur Kamera.
	hp_label = Label3D.new()
	hp_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	hp_label.no_depth_test = true
	hp_label.position.y = 2.1
	hp_label.font_size = 40
	hp_label.outline_size = 10
	hp_label.pixel_size = 0.008
	add_child(hp_label)
	_update_visuals()


func is_alive() -> bool:
	return hp > 0


## Wendet einen bereits verrechneten Treffer an (Werte aus
## Combat.resolve_damage).
func take_hit(to_shield: int, to_hp: int) -> void:
	shield = maxi(shield - to_shield, 0)
	hp = maxi(hp - to_hp, 0)
	_update_visuals()


func heal(amount: int) -> void:
	hp = mini(hp + amount, max_hp)
	_update_visuals()


## Rundenwechsel: Schild regeneriert um genau 1 Punkt – unabhängig davon,
## ob die Einheit getroffen wurde (Halo-Flashpoint-Prinzip).
func regen_shield() -> void:
	shield = mini(shield + 1, max_shield)
	_update_visuals()


func set_activated(value: bool) -> void:
	activated = value
	_update_visuals()


func set_overwatch(value: bool) -> void:
	overwatch = value
	_update_visuals()


func set_bulwark(value: bool) -> void:
	bulwark = value
	_update_visuals()


func set_shocked(value: bool) -> void:
	shocked = value
	_update_visuals()


func cooldown_of(ability: String) -> int:
	return int(cooldowns.get(ability, 0))


func tick_cooldowns() -> void:
	for key in cooldowns:
		if cooldowns[key] > 0:
			cooldowns[key] -= 1


func _update_visuals() -> void:
	if hp_label != null:
		var extra := ""
		if max_shield > 0:
			extra += "  S%d" % shield
		if armor > 0:
			extra += "  P%d" % armor
		if overwatch:
			extra += "  [OW]"
		if bulwark:
			extra += "  [BULWARK]"
		if shocked:
			extra += "  [SCHOCK]"
		hp_label.text = "%s  %d/%d%s" % [unit_name, hp, max_hp, extra]
		if faction == Faction.PLAYER:
			hp_label.modulate = Color("5c7a63") if activated else Color("a5e6b0")
		else:
			hp_label.modulate = Color("8a5a55") if activated else Color("ff9d94")
	if shield_bubble != null:
		shield_bubble.visible = shield > 0


## Läuft die Felder des Wegs nacheinander ab (per Tween animiert).
## 'path' enthält Start- und Zielfeld; das Startfeld überspringen wir.
func walk_path(path: Array[Vector2i], tile_size: float) -> void:
	if path.size() < 2:
		return
	is_moving = true
	cell = path[path.size() - 1]  # Logisch steht die Einheit sofort am Ziel

	var tween := create_tween()
	for i in range(1, path.size()):
		var step: Vector2i = path[i]
		var target := Vector3(step.x * tile_size, 0.0, step.y * tile_size)
		tween.tween_property(self, "position", target, 0.16)
	tween.finished.connect(_on_walk_done)


func _on_walk_done() -> void:
	is_moving = false
	move_finished.emit()
