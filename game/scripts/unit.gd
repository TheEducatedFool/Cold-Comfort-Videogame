class_name Unit
extends Node3D

## Eine Einheit auf dem Raster – Soldat oder Swarm-Kreatur.
## Kümmert sich um Darstellung, Werte und die Lauf-Animation.
## Die Regeln (wer darf wann was) liegen in main.gd,
## die Kampf-Mathematik in combat.gd.

signal move_finished

## Kenney "Prototype Kit" Platzhalter-Figur für Soldaten (CC0, siehe
## game/assets/kenney_prototype/License.txt). Kein passendes Kreatur-
## Modell im Kit für den Swarm - der bleibt eine einfache Kugel.
const FIGURE_MODEL := preload("res://assets/kenney_prototype/figurine.glb")

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
# Würfelpool ("Wurf <= Wert = Erfolg"). Die eigentliche Waffe (Reichweite,
# AP/SD/Lethal) steckt in 'weapon', nicht direkt auf der Einheit.
var ranged: int = 5
var melee: int = 5
var defense: int = 5
var weapon: Weapon
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

var hp_label: Label3D
var shield_bubble: MeshInstance3D
var anim_player: AnimationPlayer


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
	weapon = Weapons.make(stats.get("weapon", "standard_rifle"))
	move_range = stats.get("move", 6)
	sentry = stats.get("sentry", false)
	abilities = stats.get("abilities", [])

	# Platzhalter-Körper: Kenney-Figur für Soldaten, gedrungene Kugel für
	# den Swarm (kein passendes Kreatur-Modell im Prototype Kit).
	if faction == Faction.SWARM:
		var body := MeshInstance3D.new()
		var blob := SphereMesh.new()
		blob.radius = 0.55
		blob.height = 0.9
		body.mesh = blob
		body.position.y = 0.45
		var mat := StandardMaterial3D.new()
		mat.albedo_color = color
		body.material_override = mat
		add_child(body)
	else:
		var figure := FIGURE_MODEL.instantiate()
		figure.scale = Vector3.ONE * 2.2
		add_child(figure)
		_tint_all(figure, color)
		anim_player = _find_animation_player(figure)
		if anim_player != null:
			anim_player.animation_finished.connect(_on_anim_finished)
			anim_player.play("idle")

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


## Sucht den AnimationPlayer im importierten Kenney-Modell (die Figur hat
## fertige Animationen: idle, walk, sprint, attack-melee-*, holding-*-shoot,
## die, ... - siehe game/assets/kenney_prototype/).
func _find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for c in node.get_children():
		var found := _find_animation_player(c)
		if found != null:
			return found
	return null


## Die "walk"-Animation ist nicht als Loop importiert - solange die Einheit
## noch läuft, einfach neu starten, statt in der letzten Pose einzufrieren.
func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "walk" and is_moving:
		anim_player.play("walk")


func play_idle() -> void:
	if anim_player != null:
		anim_player.play("idle")


func play_walk() -> void:
	if anim_player != null:
		anim_player.play("walk")


func play_attack_ranged() -> void:
	if anim_player != null:
		anim_player.play("holding-both-shoot")


func play_attack_melee() -> void:
	if anim_player != null:
		anim_player.play("attack-melee-right")


func play_die() -> void:
	if anim_player != null:
		anim_player.play("die")


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
