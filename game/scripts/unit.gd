class_name Unit
extends Node3D

## Eine Einheit auf dem Raster – Soldat oder Swarm-Kreatur.
## Kümmert sich um Darstellung, Werte und die Lauf-Animation.
## Die Regeln (wer darf wann was) liegen in main.gd,
## die Kampf-Mathematik in combat.gd.

signal move_finished

## Kenney "Space Kit" Platzhalter-Figuren (CC0, siehe
## game/assets/kenney_space_kit/License.txt): Astronauten für Soldaten
## (zwei Varianten für etwas visuelle Abwechslung), Alien für den Swarm.
## Beide Modelle bestehen aus einzelnen starren Körperteilen ohne Skelett-
## Rig - Animationen laufen deshalb als Rotations-Tweens auf diesen Teilen
## (siehe _find_by_name()/play_*() unten), nicht über einen AnimationPlayer.
const PLAYER_MODELS := [
	preload("res://assets/kenney_space_kit/astronautA.glb"),
	preload("res://assets/kenney_space_kit/astronautB.glb"),
]
const ALIEN_MODEL := preload("res://assets/kenney_space_kit/alien.glb")

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

# --- Angriff (docs/dice-system.md, docs/classes.md Abschnitt 8) -----------
# Fernkampf/Nahkampf/Verteidigung: 1-10, Zielwert für den jeweiligen
# Würfelpool ("Wurf <= Wert = Erfolg"). Die eigentlichen Waffen (Reichweite,
# AP/SD/Lethal) stecken in ranged_weapon/melee_weapon, nicht direkt auf der
# Einheit. Jeder Kämpfer hat inzwischen (mindestens) eine einfache
# Behelfswaffe für beide Seiten (Pistole/Messer, siehe weapons.gd) - nur
# Swarm-Kreaturen haben oft nur eine der beiden (null = nicht vorhanden).
var ranged: int = 5
var melee: int = 5
var defense: int = 5
var ranged_weapon: Weapon
var melee_weapon: Weapon
var move_range: int = 6       # Felder pro Bewegungs-Aktion (einheitlich 6)
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

# --- Nahkampf-Sonderboni (dice-system.md Abschnitt 3, M4) -------------------
var charge_ready: bool = false   # naechster Nahkampfangriff bekommt +2 Wuerfel
var charges_used: int = 0        # Deckel: max. 2 pro Aktivierung

# --- Aktions-Wiederholungssperre (dice-system.md Abschnitt 1: "Dieselbe
# Aktion nicht zweimal in derselben Aktivierung") ---------------------------
const DASH_RANGE := 3            # zweite Bewegung in einer Aktivierung = Dash
var moves_used: int = 0          # 0 = naechste Bewegung volle move_range, sonst Dash
var used_action_types: Array[String] = []  # z.B. "ranged_attack"/"melee_attack"

var hp_label: Label3D
var shield_bubble: MeshInstance3D

# --- Paper-Doll-Animation (Körperteile ohne Skelett-Rig) --------------------
var _part_arm_left: Node3D
var _part_arm_right: Node3D
var _part_leg_left: Node3D
var _part_leg_right: Node3D
var _rest_rotation: Dictionary = {}   # Node3D -> Vector3 (Ruhepose zum Zurücksetzen)
var _walk_tween: Tween


func setup(p_name: String, p_faction: int, color: Color, stats: Dictionary) -> void:
	unit_name = p_name
	faction = p_faction
	max_hp = stats.get("hp", 5)
	hp = max_hp
	max_shield = stats.get("shield", 0)
	shield = max_shield
	armor = stats.get("armor", 0)
	ranged = stats.get("ranged", 5)
	melee = stats.get("melee", 5)
	defense = stats.get("defense", 5)
	ranged_weapon = Weapons.make(stats["ranged_weapon"]) if stats.has("ranged_weapon") else null
	melee_weapon = Weapons.make(stats["melee_weapon"]) if stats.has("melee_weapon") else null
	move_range = stats.get("move", 6)
	sentry = stats.get("sentry", false)
	abilities = stats.get("abilities", [])

	# Platzhalter-Körper: Astronaut für Soldaten (zwei Varianten,
	# klassengebunden ausgewählt), Alien für den Swarm.
	var model_scene: PackedScene
	if faction == Faction.SWARM:
		model_scene = ALIEN_MODEL
	else:
		model_scene = PLAYER_MODELS[hash(p_name) % PLAYER_MODELS.size()]
	var figure: Node3D = model_scene.instantiate()
	add_child(figure)
	figure.scale = Vector3.ONE * 2.2
	_recenter_paperdoll(figure)
	_tint_all(figure, color)

	_part_arm_left = _find_by_name(figure, "armLeft")
	_part_arm_right = _find_by_name(figure, "armRight")
	_part_leg_left = _find_by_name(figure, "legLeft")
	_part_leg_right = _find_by_name(figure, "legRight")
	for part in [_part_arm_left, _part_arm_right, _part_leg_left, _part_leg_right]:
		if part != null:
			_rest_rotation[part] = part.rotation

	# Fernkampfwaffe sichtbar in die rechte Hand geben, falls die Waffe ein
	# Modell hat (Nahkampfwaffen/Swarm-Waffen haben aktuell keins, siehe
	# weapons.gd). Ruhehaltung: schräg nach unten am Körper getragen, nicht
	# nach vorne zeigend - Position/Rotation grob geschätzt (kein visueller
	# Check möglich), ggf. nach Rückmeldung nachjustieren.
	if ranged_weapon != null and ranged_weapon.model_path != "" and _part_arm_right != null:
		var weapon_scene: PackedScene = load(ranged_weapon.model_path)
		var weapon_inst: Node3D = weapon_scene.instantiate()
		_part_arm_right.add_child(weapon_inst)
		weapon_inst.position = Vector3(0.05, -0.3, 0.0)
		weapon_inst.rotation_degrees = Vector3(-75.0, 0.0, 0.0)
		weapon_inst.scale = Vector3.ONE * 0.7
	play_idle()

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
	# Höhere font_size + passend kleinere pixel_size hält die Weltgröße
	# gleich, gibt aber mehr Textur-Auflösung für die Mipmap-Kette -
	# zusammen mit LINEAR_WITH_MIPMAPS verhindert das Pixel-Flimmern beim
	# Herauszoomen (Kamils Meldung).
	hp_label.font_size = 80
	hp_label.outline_size = 20
	hp_label.pixel_size = 0.004
	hp_label.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	add_child(hp_label)
	_update_visuals()


## Setzt die Materialfarbe aller MeshInstance3D-Kindknoten rekursiv - die
## importierten Kenney-Modelle zeigen sonst alle dieselbe geteilte
## Prototype-Textur statt der Team-/Einheitenfarbe.
func _tint_all(node: Node, color: Color) -> void:
	if node is MeshInstance3D:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = color
		node.material_override = mat
	for c in node.get_children():
		_tint_all(c, color)


## Sucht einen Kindknoten mit dem gegebenen Namen (Körperteile der Kenney-
## Figuren heißen einheitlich armLeft/armRight/legLeft/legRight/body/head).
func _find_by_name(node: Node, part_name: String) -> Node3D:
	if node.name == part_name:
		return node
	for c in node.get_children():
		var found := _find_by_name(c, part_name)
		if found != null:
			return found
	return null


## Diese Kenney-Modelle sind nicht am eigenen Ursprung zentriert (Erbe aus
## der Sammel-Szene, in der die einzelnen Objekte ursprünglich nebeneinander
## lagen) - ohne Korrektur stünde die Figur seitlich neben der Rasterzelle.
## Verschiebt sie so, dass ihre Grundfläche mittig auf (0,0) im lokalen Raum
## steht. Nutzt reine Kindtransformationen statt global_transform, weil
## setup() läuft, bevor die Einheit selbst im Szenenbaum hängt.
## WICHTIG: 'model' muss schon seine endgültige scale haben, BEVOR das hier
## aufgerufen wird - der Ausgleichs-Versatz wird mit skaliert (model.position
## liegt im UNSKALIERTEN Elternraum, die gemessene AABB aber im skalierten
## Innenraum von 'model'), sonst passt die Korrektur nur bei scale = 1.
func _recenter_paperdoll(model: Node3D) -> void:
	var aabb := _local_aabb(model, Transform3D.IDENTITY)
	if aabb.size == Vector3.ZERO:
		return
	var center_x := aabb.position.x + aabb.size.x / 2.0
	var center_z := aabb.position.z + aabb.size.z / 2.0
	model.position -= Vector3(center_x, 0.0, center_z) * model.scale.x


func _local_aabb(node: Node, xform: Transform3D) -> AABB:
	var result := AABB()
	var got_any := false
	if node is MeshInstance3D:
		result = xform * node.get_aabb()
		got_any = true
	for c in node.get_children():
		if c is Node3D:
			var child_aabb := _local_aabb(c, xform * c.transform)
			if got_any:
				result = result.merge(child_aabb)
			else:
				result = child_aabb
				got_any = true
	return result


func _stop_walk_tween() -> void:
	if _walk_tween != null and _walk_tween.is_valid():
		_walk_tween.kill()


## Setzt Arme/Beine sanft zurück in ihre Ruhepose (z. B. nach Angriff/Lauf).
func _reset_to_rest() -> void:
	for part in _rest_rotation:
		var rest: Vector3 = _rest_rotation[part]
		var t := create_tween()
		t.tween_property(part, "rotation", rest, 0.15)


func play_idle() -> void:
	_stop_walk_tween()
	_reset_to_rest()


## Kein Skelett-Rig vorhanden - der "Laufzyklus" ist ein simples
## gegenläufiges Bein-Pendeln in Dauerschleife, solange die Einheit läuft.
func play_walk() -> void:
	_stop_walk_tween()
	if _part_leg_left == null or _part_leg_right == null:
		return
	var amp := 0.5
	_walk_tween = create_tween()
	_walk_tween.set_loops()
	_walk_tween.tween_property(_part_leg_left, "rotation:x", amp, 0.18)
	_walk_tween.parallel().tween_property(_part_leg_right, "rotation:x", -amp, 0.18)
	_walk_tween.tween_property(_part_leg_left, "rotation:x", -amp, 0.18)
	_walk_tween.parallel().tween_property(_part_leg_right, "rotation:x", amp, 0.18)


## Fernkampf: kurzer Rückstoß im rechten (Waffen-)Arm.
## Fernkampf: kurzer, kleiner Rückstoß-Zucker.
func play_attack_ranged() -> void:
	if _part_arm_right == null:
		return
	var rest: Vector3 = _rest_rotation.get(_part_arm_right, _part_arm_right.rotation)
	var t := create_tween()
	t.tween_property(_part_arm_right, "rotation:x", rest.x - 0.4, 0.08)
	t.tween_property(_part_arm_right, "rotation:x", rest.x, 0.18)


## Nahkampf: bewusst anders als der Schuss-Rückstoß - deutliches Ausholen
## nach hinten/oben, dann kraftvoller Schlag nach vorne/unten, erst danach
## zurück in die Ruhepose (3 Phasen statt 2, größerer Ausschlag).
func play_attack_melee() -> void:
	if _part_arm_right == null:
		return
	var rest: Vector3 = _rest_rotation.get(_part_arm_right, _part_arm_right.rotation)
	var t := create_tween()
	t.tween_property(_part_arm_right, "rotation:x", rest.x - 2.0, 0.14) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	t.tween_property(_part_arm_right, "rotation:x", rest.x + 0.7, 0.12) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_property(_part_arm_right, "rotation:x", rest.x, 0.16)


## Kippt die ganze Einheit zur Seite - main.gd lässt sie danach zusätzlich
## zusammenschrumpfen und entfernt sie (siehe _kill_unit()).
func play_die() -> void:
	_stop_walk_tween()
	var t := create_tween()
	t.tween_property(self, "rotation:z", deg_to_rad(85.0), 0.35) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


## Reichweite der NÄCHSTEN Bewegungsaktion: volle move_range beim ersten
## Mal in dieser Aktivierung, danach nur noch DASH_RANGE (Dash).
func effective_move_range() -> int:
	return move_range if moves_used == 0 else DASH_RANGE


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
	play_walk()

	var tween := create_tween()
	for i in range(1, path.size()):
		var step: Vector2i = path[i]
		var target := Vector3(step.x * tile_size, 0.0, step.y * tile_size)
		tween.tween_property(self, "position", target, 0.16)
	tween.finished.connect(_on_walk_done)


func _on_walk_done() -> void:
	is_moving = false
	play_idle()
	move_finished.emit()
