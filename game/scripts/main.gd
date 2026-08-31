extends Node3D

## COLD COMFORT – Prototyp, Würfelpool-Umbau (M2/M3)
## ---------------------------------------
## Kampfauflösung läuft jetzt über das Würfelpool-System aus
## docs/dice-system.md (siehe combat.gd) statt über Prozent-Trefferchancen.
## Roster: die 5 aktuellen Klassen (Breacher/Deadeye/Handler/Heavy/Reiver,
## siehe docs/classes.md) als Platzhalter-Einheiten statt der 4 alten
## Story-Charaktere. Fähigkeiten auf Tasten 1/2 (Slug Rush, Bulwark Stance,
## Mend, Shock – Zuordnung provisorisch, echte Klassen-Grundfähigkeiten
## kommen erst in M7), Fernkampf-Gegner (Spitter), drehbare Kamera (Q/E)
## und einfache Animationen (Tracer-Schüsse, Treffer-Zucken, Todes-
## Schrumpfen).
##
## Nahkampf-Angriffe laufen bereits über den gleichen Würfelpool (Basis-
## Pool 3, Ziel-Feld = Nahkampf-Stat), aber noch OHNE die M4-Boni
## (Charge/Zone-of-Control-Gegenangriff/Flanking) – die kommen erst mit
## dem Nahkampf-Meilenstein.
## Steuerung:
##   Linksklick grünes Feld     -> ausgewählte Einheit bewegt sich (1 Aktion)
##   Linksklick auf Gegner      -> schießen, falls möglich (1 Aktion)
##   Klick auf Soldat oder Tab  -> Einheit wechseln
##   O                          -> Overwatch (beendet Aktivierung)
##   1 / 2                      -> Klassen-Fähigkeit (Esc bricht Zielwahl ab)
##   Q / E                      -> Kamera drehen (90°-Schritte)
##   Enter oder Button          -> Zug beenden (dann zieht der Swarm)
##   R                          -> Neustart nach Sieg/Niederlage

# --- Spielregeln / Stellschrauben -----------------------------------------

const GRID_W := 22
const GRID_H := 40
const TILE := 2.0
const ACTIONS_PER_TURN := 2

const CAM_RADIUS := 23.0
const CAM_HEIGHT := 18.0

# Kenney "Space Station Kit" Platzhalter-Modelle (CC0, siehe
# game/assets/kenney_space_station/License.txt) - passt vom Look besser
# zur Sci-Fi-Station als das generische Prototype-Kit (von Kamil
# freigegeben, 2026-08-31). Je zwei Varianten für volle/halbe Deckung für
# etwas visuelle Abwechslung, siehe _build_floor().
const MODEL_FLOOR := preload("res://assets/kenney_space_station/floor.glb")
const MODEL_WALL := preload("res://assets/kenney_space_station/wall.glb")
const MODEL_WALL_WINDOW := preload("res://assets/kenney_space_station/wall-window.glb")
const MODEL_CRATE := preload("res://assets/kenney_space_station/container.glb")
const MODEL_CRATE_WIDE := preload("res://assets/kenney_space_station/container-wide.glb")

const MEND_RANGE := 8.0
const MEND_HEAL := 2
const SHOCK_RANGE := 7.0

# Fähigkeiten-Katalog: ID -> Anzeige & Abklingzeit (in Runden).
const ABILITIES := {
	"slug_rush": {"label": "Slug Rush", "cooldown": 2},
	"bulwark": {"label": "Bulwark Stance", "cooldown": 0},
	"mend": {"label": "Mend", "cooldown": 2},
	"shock": {"label": "Shock", "cooldown": 2},
}

# Blockierte Felder der Testkarte: Vector2i -> Hindernishöhe in Metern.
# Niedrig (1.0) = Kiste / halbe Deckung, hoch (2.2) = Wand / volle Deckung.
# Wird in _generate_obstacles() befüllt (22x40 ist zu groß für eine von
# Hand aufgezählte const-Liste) - kein echtes Level-Design, nur genug
# Struktur (Raumtrenner mit Türlücken, verstreute Kisten) für Deckungs-/
# Sichtlinien-Taktik auf der größeren Karte.
var OBSTACLES: Dictionary = {}


## Baut ein einfaches "Korridor mit Räumen"-Muster: Wandreihen alle 8
## Felder mit je 2 Türlücken (Position wechselt zeilenweise), dazwischen
## verstreute Kisten als halbe Deckung.
func _generate_obstacles() -> Dictionary:
	var obs: Dictionary = {}
	var wall_rows := [8, 16, 24, 32]
	for i in wall_rows.size():
		var y: int = wall_rows[i]
		var gaps: Array = [5, 6, 15, 16] if i % 2 == 0 else [9, 10, 18, 19]
		for x in range(GRID_W):
			if x in gaps:
				continue
			obs[Vector2i(x, y)] = 2.2
	var room_bands := [[1, 6], [10, 14], [18, 22], [26, 30], [34, 38]]
	for band in room_bands:
		var y0: int = band[0]
		var y1: int = band[1]
		var span: int = y1 - y0 + 1
		for x in [2, 6, 10, 14, 18]:
			var y: int = y0 + ((x * 3 + y0) % span)
			obs[Vector2i(x, y)] = 1.0
	return obs

# Kampfwerte der 5 Klassen (docs/classes.md Abschnitt 8, exakte
# Basiswerte) plus Waffen (docs/traits.md 0.2, siehe weapons.gd). Jede
# Klasse hat inzwischen BEIDE Waffentypen: die eigentliche Klassenwaffe auf
# ihrer starken Seite, dazu eine Pistole/ein Messer ohne besondere Werte
# für die schwache Seite (Kamils Playtest-Feedback, 2026-08-31) - so kann
# jeder Kämpfer wahlweise schießen ODER im Nahkampf zuschlagen.
# Schild ist noch kein Klassen-Basiswert (kommt später über
# Werkstatt-Ausrüstung, docs/gdd.md) - Platzhalter 0 für alle.
# Fähigkeiten-Zuordnung ist provisorisch (bestehende 4 Fähigkeiten aus dem
# alten Prototyp, thematisch passend verteilt) - echte Klassen-
# Grundfähigkeiten pro docs/skills.md kommen erst in M7.
const STATS_BREACHER := {
	"hp": 4, "shield": 0, "armor": 1,
	"ranged": 6, "melee": 7, "defense": 3,
	"move": 6, "ranged_weapon": "combat_shotgun", "melee_weapon": "knife",
	"abilities": ["slug_rush"],
}
const STATS_DEADEYE := {
	"hp": 4, "shield": 0, "armor": 1,
	"ranged": 7, "melee": 4, "defense": 5,
	"move": 6, "ranged_weapon": "sniper_rifle", "melee_weapon": "knife",
	"sentry": true,  # Kern-Passiv: siehe TODO Design-Entscheidung bei _overwatch_shot
}
const STATS_HANDLER := {
	"hp": 5, "shield": 0, "armor": 1,
	"ranged": 4, "melee": 4, "defense": 7,
	"move": 6, "ranged_weapon": "standard_rifle", "melee_weapon": "knife",
	"abilities": ["mend", "shock"],
}
const STATS_HEAVY := {
	"hp": 5, "shield": 0, "armor": 2,
	"ranged": 7, "melee": 3, "defense": 3,
	"move": 6, "ranged_weapon": "heavy_machine_gun", "melee_weapon": "knife",
	"abilities": ["bulwark"],
}
const STATS_REIVER := {
	"hp": 5, "shield": 0, "armor": 0,
	"ranged": 5, "melee": 7, "defense": 5,
	"move": 6, "ranged_weapon": "pistol", "melee_weapon": "chain_blade",
}

# Swarm-Werte: noch nicht in den Docs vorgegeben - TODO Balancing, grob an
# Handler-Niveau bzw. niedriger orientiert (prototype-plan.md M2). Bleiben
# bewusst einseitig (Drohne nur Nahkampf, Spitter nur Fernkampf) - Kamils
# Pistole/Messer-Wunsch bezog sich auf die 5 Kämpfer-Klassen, nicht auf
# die Swarm-Kreaturen, die als reine Nahkampf-/Fernkampf-Archetypen
# gedacht sind (siehe gdd.md).
# Nach Kamils erstem Playtest (2026-08-31) einen Schritt staerker gemacht.
const STATS_DRONE := {
	"hp": 4, "shield": 0, "armor": 1,
	"ranged": 3, "melee": 5, "defense": 4,
	"move": 6, "melee_weapon": "drone_claws",
}
const STATS_SPITTER := {
	"hp": 3, "shield": 0, "armor": 0,
	"ranged": 5, "melee": 3, "defense": 4,
	"move": 6, "ranged_weapon": "spitter_acid",
}

const SHIP_TURN_LINES := [
	"Ship: \"Zug beendet. Die Galaxis bleibt unbeeindruckt.\"",
	"Ship: \"Beeindruckende Taktik. Für Kohlenstoff-Verhältnisse.\"",
	"Ship: \"Ich hätte da eine Abkürzung. Ihr würdet sie nicht überleben.\"",
	"Ship: \"Notiz an mich selbst: Beine sind ineffizient.\"",
]
const SHIP_KILL_LINES := [
	"Ship: \"Ziel neutralisiert. Ich tue so, als wäre das der Plan gewesen.\"",
	"Ship: \"Ein Xenoform weniger. Verbleibend: zu viele.\"",
	"Ship: \"Sauber. Und ich muss die Wand nicht mal putzen. Habe keine Arme.\"",
]
const SHIP_MISS_LINES := [
	"Ship: \"Daneben. Die Kugel führt jetzt ein eigenes Leben im All.\"",
	"Ship: \"85 Prozent sind keine 100. Ich rechne es gern noch einmal vor.\"",
]
const SHIP_HURT_LINES := [
	"Ship: \"Eine Medbay wäre jetzt praktisch. Haben wir aber noch nicht gebaut.\"",
	"Ship: \"Autsch. Sagt man das so? Autsch.\"",
]

const INFO_DEFAULT := "Klick: bewegen/schießen · Tab: Einheit · O: Overwatch · 1/2: Fähigkeit · Q/E: Kamera · L: Sichtlinien · Enter: Aktivierung beenden"

# --- Zustand ---------------------------------------------------------------

var grid: GridLogic
var units: Array[Unit] = []
var selected: Unit = null
var player_turn := true
var game_over := false
var pending_ability := ""     # Fähigkeit wartet auf Zielklick ("mend"/"shock")
var anim_busy := false        # Animation läuft -> Eingaben kurz sperren

# Alternierende Aktivierungen (Kill-Team-Prinzip):
# Spieler aktiviert EINEN Soldaten, dann aktiviert der Swarm EINE Einheit
# (Drohnen paarweise, Spitter einzeln) – im Wechsel, bis alle dran waren.
# Erst dann endet die Runde (Schild-Regeneration, Cooldowns).
var round_num := 1
var active_unit: Unit = null      # Soldat, dessen Aktivierung gerade läuft
var enemy_queue: Array = []       # Warteschlange der Swarm-Aktivierungsgruppen

var camera: Camera3D
var cam_yaw := 45.0
var cam_tween: Tween
var map_center := Vector3.ZERO

var highlight_nodes: Dictionary = {}   # Vector2i -> MeshInstance3D
var hover_marker: MeshInstance3D       # weiß: Bewegungs-Vorschau
var target_marker: MeshInstance3D      # rot: Schuss-Vorschau
var select_ring: MeshInstance3D        # gelb: ausgewählte Einheit

var turn_label: Label
var actions_label: Label
var info_label: Label
var ship_label: Label
var overlay_label: Label
var round_banner_label: Label
var end_turn_button: Button
var overwatch_button: Button
var ability_buttons: Array[Button] = []
var ui_layer: CanvasLayer
var stat_panel: RichTextLabel
var log_panel: RichTextLabel
var roll_log_lines: Array[String] = []
const ROLL_LOG_MAX := 10

# Gemeinsame Materialien
var mat_highlight: StandardMaterial3D
var mat_hover: StandardMaterial3D
var mat_target: StandardMaterial3D
var mat_ring: StandardMaterial3D
var mat_los_ok: StandardMaterial3D
var mat_los_far: StandardMaterial3D
var mat_los_blocked: StandardMaterial3D

# Sichtlinien-Debug (Taste L)
var los_debug := false
var los_nodes: Array = []


func _ready() -> void:
	randomize()
	OBSTACLES = _generate_obstacles()
	_make_materials()
	_build_grid_logic()
	_build_floor()
	_build_camera_and_light()
	_spawn_units()
	_build_ui()
	_build_enemy_queue()
	_select(_players()[0])
	ship_label.text = "Ship: \"Volle Besatzung an Deck. Statistisch verbessert das nichts, aber es sieht besser aus.\""


# --- Aufbau ----------------------------------------------------------------

func _make_materials() -> void:
	mat_highlight = _unshaded(Color(0.35, 0.85, 0.5, 0.3))
	mat_hover = _unshaded(Color(1.0, 1.0, 1.0, 0.25))
	mat_target = _unshaded(Color(0.95, 0.35, 0.3, 0.4))
	mat_ring = _unshaded(Color(0.95, 0.8, 0.3, 0.45))
	mat_los_ok = _unshaded(Color(0.4, 0.9, 1.0, 0.22))
	mat_los_far = _unshaded(Color(0.55, 0.6, 0.75, 0.12))
	mat_los_blocked = _unshaded(Color(0.9, 0.3, 0.3, 0.18))


func _unshaded(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return mat


func _build_grid_logic() -> void:
	grid = GridLogic.new(GRID_W, GRID_H)
	for c in OBSTACLES:
		grid.blocked[c] = OBSTACLES[c]


func _build_floor() -> void:
	for x in GRID_W:
		for y in GRID_H:
			var c := Vector2i(x, y)
			if OBSTACLES.has(c):
				var h: float = OBSTACLES[c]
				var inst: Node3D
				var variant := (x + y) % 2 == 0
				# Kenney-Modelle sind an der Basis pivotiert (Y=0 = Boden),
				# ihre AABB in der Ursprungsgröße bestimmt den Skalierungsfaktor
				# auf die Zielmaße (Feldbreite x Höhe x Feldtiefe). wall.glb/
				# wall-window.glb: (1.0, 1.0, 0.3). container.glb: (0.575, 0.6,
				# 0.575). container-wide.glb: (0.6, 0.7, 0.6).
				if h >= Combat.FULL_COVER_HEIGHT:
					inst = MODEL_WALL.instantiate() if variant else MODEL_WALL_WINDOW.instantiate()
					inst.scale = Vector3(TILE * 0.96, h, (TILE * 0.96) / 0.3)
				elif variant:
					inst = MODEL_CRATE.instantiate()
					inst.scale = Vector3((TILE * 0.8) / 0.575, h / 0.6, (TILE * 0.8) / 0.575)
				else:
					inst = MODEL_CRATE_WIDE.instantiate()
					inst.scale = Vector3((TILE * 0.8) / 0.6, h / 0.7, (TILE * 0.8) / 0.6)
				inst.position = Vector3(x * TILE, 0.0, y * TILE)
				add_child(inst)
			else:
				var tile := MODEL_FLOOR.instantiate()
				tile.scale = Vector3(TILE * 0.98, 1.0, TILE * 0.98)
				tile.position = Vector3(x * TILE, 0.0, y * TILE)
				add_child(tile)

	hover_marker = _make_quad(mat_hover, 0.03)
	hover_marker.visible = false
	add_child(hover_marker)

	target_marker = _make_quad(mat_target, 0.03)
	target_marker.visible = false
	add_child(target_marker)

	select_ring = _make_quad(mat_ring, 0.02)
	select_ring.visible = false
	add_child(select_ring)


func _make_quad(mat: StandardMaterial3D, height: float) -> MeshInstance3D:
	var quad := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(TILE * 0.9, TILE * 0.9)
	quad.mesh = plane
	quad.material_override = mat
	quad.position.y = height
	return quad


func _build_camera_and_light() -> void:
	map_center = Vector3((GRID_W - 1) * TILE / 2.0, 0.0, (GRID_H - 1) * TILE / 2.0)

	camera = Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 24.0
	add_child(camera)
	_apply_cam_yaw(cam_yaw)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, -35, 0)
	sun.shadow_enabled = true
	sun.light_energy = 1.2
	add_child(sun)

	var world_env := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("0b0e14")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("41506b")
	env.ambient_light_energy = 1.0
	world_env.environment = env
	add_child(world_env)


## Setzt die Kamera auf einen Winkel (Grad) auf ihrer Kreisbahn um die Karte.
func _apply_cam_yaw(yaw_deg: float) -> void:
	cam_yaw = yaw_deg
	var rad := deg_to_rad(yaw_deg)
	camera.position = map_center + Vector3(cos(rad) * CAM_RADIUS, CAM_HEIGHT, sin(rad) * CAM_RADIUS)
	camera.look_at(map_center)


## Zentriert die Kamera weich auf eine Weltposition - auf der 22x40-Karte
## ist sonst immer nur ein kleiner Ausschnitt sichtbar. Wird bei
## Auswahlwechsel und nach Bewegung der ausgewählten Einheit aufgerufen.
func _center_camera_on(pos: Vector3) -> void:
	var target := Vector3(pos.x, 0.0, pos.z)
	if map_center.distance_to(target) < 0.01:
		return
	if cam_tween != null and cam_tween.is_valid():
		cam_tween.kill()
	cam_tween = create_tween()
	cam_tween.tween_method(_set_map_center, map_center, target, 0.3) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _set_map_center(pos: Vector3) -> void:
	map_center = pos
	_apply_cam_yaw(cam_yaw)


## Dreht die Kamera weich um 90° nach links (-1) oder rechts (+1).
func _rotate_camera(dir: int) -> void:
	if camera == null:
		return
	var target := cam_yaw + 90.0 * float(dir)
	if cam_tween != null and cam_tween.is_valid():
		cam_tween.kill()
	cam_tween = create_tween()
	cam_tween.tween_method(_apply_cam_yaw, cam_yaw, target, 0.35) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _spawn_units() -> void:
	# Platzhalter-Trupp aus den 5 aktuellen Klassen (docs/classes.md) -
	# noch keine benannten Rekruten (kommt mit dem Rekrutierungs-Pool
	# später), Werte siehe STATS_* oben.
	# Startraum am "Eingang" (niedrige y) des 22x40-Korridors.
	_add_unit("Breacher", Unit.Faction.PLAYER, Color("d08a3e"), STATS_BREACHER, Vector2i(4, 3))
	_add_unit("Deadeye", Unit.Faction.PLAYER, Color("6f9fd8"), STATS_DEADEYE, Vector2i(8, 3))
	_add_unit("Handler", Unit.Faction.PLAYER, Color("c9b458"), STATS_HANDLER, Vector2i(12, 3))
	_add_unit("Heavy", Unit.Faction.PLAYER, Color("7a8a6f"), STATS_HEAVY, Vector2i(16, 3))
	_add_unit("Reiver", Unit.Faction.PLAYER, Color("8a6f9e"), STATS_REIVER, Vector2i(20, 3))
	# Der Swarm: über die weiteren Räume des Korridors verteilt.
	_add_unit("Drohne A", Unit.Faction.SWARM, Color("a33d33"), STATS_DRONE, Vector2i(8, 12))
	_add_unit("Drohne B", Unit.Faction.SWARM, Color("a33d33"), STATS_DRONE, Vector2i(16, 13))
	_add_unit("Drohne C", Unit.Faction.SWARM, Color("a33d33"), STATS_DRONE, Vector2i(8, 27))
	_add_unit("Drohne D", Unit.Faction.SWARM, Color("a33d33"), STATS_DRONE, Vector2i(16, 28))
	_add_unit("Spitter A", Unit.Faction.SWARM, Color("7d5a9e"), STATS_SPITTER, Vector2i(12, 20))
	_add_unit("Spitter B", Unit.Faction.SWARM, Color("7d5a9e"), STATS_SPITTER, Vector2i(12, 35))


func _add_unit(p_name: String, p_faction: int, color: Color, stats: Dictionary, start: Vector2i) -> void:
	var u := Unit.new()
	add_child(u)  # zuerst in den Szenenbaum haengen, dann Kindfiguren aufbauen
	u.setup(p_name, p_faction, color, stats)
	u.cell = start
	u.position = _cell_to_world(start)
	u.actions = ACTIONS_PER_TURN if p_faction == Unit.Faction.PLAYER else 0
	u.move_finished.connect(_on_any_move_finished)
	units.append(u)


func _build_ui() -> void:
	var ui := CanvasLayer.new()
	add_child(ui)
	ui_layer = ui

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 16)
	ui.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "COLD COMFORT – Prototyp (Würfelpool)"
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	turn_label = Label.new()
	turn_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(turn_label)

	actions_label = Label.new()
	actions_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(actions_label)

	# Fähigkeiten-Leiste der ausgewählten Einheit
	var ability_row := HBoxContainer.new()
	ability_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(ability_row)

	overwatch_button = Button.new()
	overwatch_button.text = "Overwatch  [O]"
	overwatch_button.pressed.connect(_do_overwatch)
	ability_row.add_child(overwatch_button)

	for i in range(2):
		var btn := Button.new()
		btn.visible = false
		btn.pressed.connect(_use_ability_slot.bind(i))
		ability_row.add_child(btn)
		ability_buttons.append(btn)

	end_turn_button = Button.new()
	end_turn_button.text = "Aktivierung beenden  [Enter]"
	end_turn_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	end_turn_button.pressed.connect(_end_activation)
	vbox.add_child(end_turn_button)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(spacer)

	info_label = Label.new()
	info_label.add_theme_font_size_override("font_size", 15)
	info_label.add_theme_color_override("font_color", Color("aab4c8"))
	info_label.text = INFO_DEFAULT
	vbox.add_child(info_label)

	ship_label = Label.new()
	ship_label.add_theme_font_size_override("font_size", 16)
	ship_label.add_theme_color_override("font_color", Color("8fb0e8"))
	vbox.add_child(ship_label)

	overlay_label = Label.new()
	overlay_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	overlay_label.add_theme_font_size_override("font_size", 42)
	overlay_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay_label.visible = false
	ui.add_child(overlay_label)

	# Kurzes Banner beim Rundenwechsel ("RUNDE 3"), blendet ein und wieder aus –
	# damit der Übergang zur nächsten Runde nicht nur am kleinen turn_label
	# oben links zu erkennen ist.
	round_banner_label = Label.new()
	round_banner_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	round_banner_label.offset_top = 70
	round_banner_label.offset_bottom = 130
	round_banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	round_banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	round_banner_label.add_theme_font_size_override("font_size", 34)
	round_banner_label.add_theme_color_override("font_color", Color("ffd479"))
	round_banner_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	round_banner_label.modulate = Color(1, 1, 1, 0)
	round_banner_label.visible = false
	ui.add_child(round_banner_label)

	# Statustabelle: Werte der gerade gehoverten/ausgewählten Einheit.
	var stat_box := PanelContainer.new()
	stat_box.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	stat_box.offset_left = -300
	stat_box.offset_top = 16
	stat_box.offset_right = -16
	stat_box.offset_bottom = 260
	stat_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(stat_box)

	stat_panel = RichTextLabel.new()
	stat_panel.bbcode_enabled = true
	stat_panel.scroll_active = false
	stat_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stat_panel.add_theme_font_size_override("normal_font_size", 14)
	stat_panel.add_theme_font_size_override("bold_font_size", 16)
	stat_box.add_child(stat_panel)

	# Würfel-Log: Aufschlüsselung der letzten Angriffswürfe.
	var log_box := PanelContainer.new()
	log_box.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	log_box.offset_left = -460
	log_box.offset_top = -240
	log_box.offset_right = -16
	log_box.offset_bottom = -16
	log_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(log_box)

	log_panel = RichTextLabel.new()
	log_panel.bbcode_enabled = true
	log_panel.scroll_active = true
	log_panel.scroll_following = true
	log_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	log_panel.add_theme_font_size_override("normal_font_size", 12)
	log_box.add_child(log_panel)

	_update_labels()


# --- Hilfsfunktionen -------------------------------------------------------

func _players() -> Array[Unit]:
	var result: Array[Unit] = []
	for u in units:
		if u.faction == Unit.Faction.PLAYER:
			result.append(u)
	return result


func _enemies() -> Array[Unit]:
	var result: Array[Unit] = []
	for u in units:
		if u.faction == Unit.Faction.SWARM:
			result.append(u)
	return result


func _unit_at(c: Vector2i) -> Unit:
	for u in units:
		if u.cell == c:
			return u
	return null


func _occupied_cells(except: Unit) -> Dictionary:
	var result: Dictionary = {}
	for u in units:
		if u != except:
			result[u.cell] = true
	return result


## Zusätzliche Deckungsquellen für ein Ziel: Bulwark Stance (Heavy) macht
## ihr Feld zu hoher Deckung – aber nur für verbündete Ziele.
func _extra_cover_for(target: Unit) -> Dictionary:
	var result: Dictionary = {}
	if target.faction != Unit.Faction.PLAYER:
		return result
	for p in _players():
		if p.bulwark and p != target:
			result[p.cell] = Combat.FULL_COVER_HEIGHT + 0.2
	return result


func _can_shoot(u: Unit) -> bool:
	return u.actions > 0 or u.free_shot


## Kann 'attacker' 'target' im Nahkampf angreifen (Messer/Nahkampfwaffe,
## Ziel in der eigenen Zone of Control - inklusive Diagonalen)?
func _can_attack_melee(attacker: Unit, target: Unit) -> bool:
	if attacker.melee_weapon == null:
		return false
	return Combat.in_zoc(attacker.cell, target.cell)


## Kann 'attacker' 'target' im Fernkampf angreifen (Sichtlinie, Waffen-
## reichweite)? Neue Regel aus Kamils Playtest: steht man in der Zone of
## Control DIESES Ziels (also direkt neben ihm), kann man nicht auf es
## schießen, sondern ist gegen es auf Nahkampf beschränkt - ein anderes,
## nicht angrenzendes Ziel darf man weiterhin normal beschießen.
func _can_attack_ranged(attacker: Unit, target: Unit) -> bool:
	if attacker.ranged_weapon == null:
		return false
	if Combat.in_zoc(attacker.cell, target.cell):
		return false
	if not Combat.line_of_sight(grid, attacker.cell, target.cell):
		return false
	return _dist(attacker.cell, target.cell) <= float(attacker.ranged_weapon.weapon_range)


## Kann 'attacker' 'target' irgendwie angreifen (Fernkampf ODER Nahkampf)?
func _can_attack(attacker: Unit, target: Unit) -> bool:
	return _can_attack_ranged(attacker, target) or _can_attack_melee(attacker, target)


func _can_move(u: Unit) -> bool:
	return u.actions > 0 or u.rush_move


func _any_moving() -> bool:
	for u in units:
		if u.is_moving:
			return true
	return false


func _manhattan(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)


func _dist(a: Vector2i, b: Vector2i) -> float:
	return Vector2(a).distance_to(Vector2(b))


func _cell_to_world(c: Vector2i) -> Vector3:
	return Vector3(c.x * TILE, 0.0, c.y * TILE)


# --- Eingabe ---------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_update_hover(event.position)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_click(event.position)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER:
				_end_activation()
			KEY_TAB:
				_select_next()
			KEY_O:
				_do_overwatch()
			KEY_1:
				_use_ability_slot(0)
			KEY_2:
				_use_ability_slot(1)
			KEY_Q:
				_rotate_camera(-1)
			KEY_E:
				_rotate_camera(1)
			KEY_L:
				los_debug = not los_debug
				_refresh_los_debug()
			KEY_ESCAPE:
				pending_ability = ""
				info_label.text = INFO_DEFAULT
				_update_labels()
			KEY_R:
				if game_over:
					get_tree().reload_current_scene()


func _cell_under_mouse(screen_pos: Vector2) -> Variant:
	var origin := camera.project_ray_origin(screen_pos)
	var direction := camera.project_ray_normal(screen_pos)
	var hit = Plane(Vector3.UP, 0.0).intersects_ray(origin, direction)
	if hit == null:
		return null
	var c := Vector2i(roundi(hit.x / TILE), roundi(hit.z / TILE))
	if grid.is_inside(c):
		return c
	return null


func _handle_click(screen_pos: Vector2) -> void:
	if not player_turn or game_over or _any_moving() or anim_busy:
		return
	var cv = _cell_under_mouse(screen_pos)
	if cv == null:
		return
	var c: Vector2i = cv
	var u := _unit_at(c)

	# 0) Wartet eine Fähigkeit auf ein Ziel?
	if pending_ability != "":
		_resolve_pending_ability(u)
		return

	# 1) Eigenen Soldaten angeklickt -> auswählen
	if u != null and u.faction == Unit.Faction.PLAYER:
		if active_unit != null and u != active_unit:
			info_label.text = "Erst die Aktivierung von %s abschließen [Enter]." % active_unit.unit_name
			return
		_select(u)
		return

	# 2) Gegner angeklickt -> Aktionsmenü (Schießen/Nahkampf/passende Skills)
	if u != null and u.faction == Unit.Faction.SWARM and selected != null:
		_open_action_menu(selected, u, screen_pos)
		return

	# 3) Erreichbares Feld angeklickt -> bewegen
	_try_move_selected(c)


## Bewegt die ausgewählte Einheit zu Feld 'c' (Klick-Logik; auch vom
## automatisierten Testlauf genutzt). Rückgabe: ob bewegt wurde.
func _try_move_selected(c: Vector2i) -> bool:
	if selected == null or not _can_move(selected) or not highlight_nodes.has(c):
		return false
	var path := grid.find_path(selected.cell, c, _occupied_cells(selected))
	if path.is_empty():
		return false
	if not _commit(selected):
		return false
	if selected.rush_move:
		# Slug Rush: Bewegung ist Teil der Fähigkeit, Freischuss wird scharf.
		selected.rush_move = false
		selected.free_shot = true
		ship_label.text = "Ship: \"Vorwärtssprint registriert. Ich empfehle allen anderen: aus dem Weg.\""
	else:
		selected.actions -= 1
	if selected.bulwark:
		selected.set_bulwark(false)  # Bewegung beendet Bulwark Stance
	_clear_highlights()
	hover_marker.visible = false
	_track_charge(selected, path[0], path[path.size() - 1])
	_walk_with_reactions(selected, path)
	_update_labels()
	return true


## Klick auf einen Gegner: statt automatisch zu feuern, ein Menü mit den
## tatsächlich möglichen Aktionen gegen dieses Ziel - Schießen/Nahkampf
## (je nachdem, was die ausgerüstete Waffe hergibt und ob Reichweite/
## Sichtlinie bzw. Angrenzung passen), dazu passende aktive Skills wie
## Shock. Ist nichts davon möglich, öffnet sich kein Menü.
func _open_action_menu(attacker: Unit, target: Unit, screen_pos: Vector2) -> void:
	var menu := PopupMenu.new()
	ui_layer.add_child(menu)
	var actions: Array[Callable] = []

	if _can_shoot(attacker) and _can_attack_ranged(attacker, target):
		menu.add_item("Schießen (%s)" % attacker.ranged_weapon.weapon_name)
		actions.append(func() -> void:
			if _commit(attacker):
				_player_attack(attacker, target, false))

	if _can_shoot(attacker) and _can_attack_melee(attacker, target):
		menu.add_item("Nahkampf (%s)" % attacker.melee_weapon.weapon_name)
		actions.append(func() -> void:
			if _commit(attacker):
				_player_attack(attacker, target, true))

	for aid in attacker.abilities:
		if aid == "shock" and attacker.actions > 0 and attacker.cooldown_of("shock") == 0 \
				and _dist(attacker.cell, target.cell) <= SHOCK_RANGE:
			menu.add_item("Shock (%s)" % ABILITIES["shock"]["label"])
			actions.append(func() -> void: _cast_shock(attacker, target))

	if actions.is_empty():
		menu.queue_free()
		info_label.text = "Keine Aktion gegen %s möglich." % target.unit_name
		return

	menu.id_pressed.connect(func(id: int) -> void: actions[id].call())
	menu.popup_hide.connect(menu.queue_free)
	menu.position = Vector2i(screen_pos)
	menu.popup()


func _update_hover(screen_pos: Vector2) -> void:
	hover_marker.visible = false
	target_marker.visible = false
	if not player_turn or game_over or _any_moving() or anim_busy:
		return

	var cv = _cell_under_mouse(screen_pos)

	# Zielwahl-Modus (Mend/Shock): nur gültige Ziele markieren.
	if pending_ability != "":
		if cv == null or selected == null:
			return
		var t := _unit_at(cv)
		if t == null:
			return
		if pending_ability == "mend" and t.faction == Unit.Faction.PLAYER \
				and _dist(selected.cell, t.cell) <= MEND_RANGE:
			hover_marker.position = _cell_to_world(t.cell) + Vector3(0, 0.03, 0)
			hover_marker.visible = true
		elif pending_ability == "shock" and t.faction == Unit.Faction.SWARM \
				and _dist(selected.cell, t.cell) <= SHOCK_RANGE:
			target_marker.position = _cell_to_world(t.cell) + Vector3(0, 0.03, 0)
			target_marker.visible = true
		return

	info_label.text = INFO_DEFAULT
	if cv == null:
		_show_unit_stats(selected)
		return
	var c: Vector2i = cv
	var u := _unit_at(c)
	_show_unit_stats(u if u != null else selected)

	if u != null and u.faction == Unit.Faction.SWARM and selected != null and _can_shoot(selected):
		target_marker.position = _cell_to_world(c) + Vector3(0, 0.03, 0)
		target_marker.visible = true
		var previews: Array[String] = []
		if _can_attack_ranged(selected, u):
			var w := selected.ranged_weapon
			var cm := Combat.cover_malus(grid, selected.cell, u.cell, _extra_cover_for(u))
			var bonus := Combat.cover_bonus_dice(cm)
			var cover_txt := "flankiert"
			if cm == Combat.FULL_COVER_MALUS:
				cover_txt = "volle Deckung"
			elif cm == Combat.HALF_COVER_MALUS:
				cover_txt = "halbe Deckung"
			previews.append("Schießen %d Würfel (%s) · AP %d · SD %d · Tödlich %d" \
				% [3 + bonus, cover_txt, w.ap, w.sd, w.lethal])
		if _can_attack_melee(selected, u):
			var w := selected.melee_weapon
			var bonus := (2 if selected.charge_ready else 0) + (1 if _flanking(selected, u) else 0)
			previews.append("Nahkampf %d Würfel · AP %d · SD %d · Tödlich %d" \
				% [3 + bonus, w.ap, w.sd, w.lethal])
		if previews.is_empty():
			if Combat.in_zoc(selected.cell, u.cell) and selected.ranged_weapon != null and selected.melee_weapon == null:
				info_label.text = "Ziel: %s – zu nah zum Schießen, keine Nahkampfwaffe" % u.unit_name
			else:
				info_label.text = "Ziel: %s – keine Sichtlinie, außer Reichweite oder nicht angrenzend" % u.unit_name
		else:
			var def_txt := ""
			if u.shield > 0:
				def_txt += " · Ziel-Schild %d" % u.shield
			if u.armor > 0:
				def_txt += " · Ziel-Panzerung %d" % u.armor
			info_label.text = "Ziel: %s – %s%s · Klick für Aktionsmenü" \
				% [u.unit_name, " / ".join(previews), def_txt]
	elif highlight_nodes.has(c):
		hover_marker.position = _cell_to_world(c) + Vector3(0, 0.03, 0)
		hover_marker.visible = true


# --- Fähigkeiten -----------------------------------------------------------

## Overwatch: kostet die restliche Aktivierung. Die Einheit feuert im
## Gegnerzug einen Reaktionsschuss auf den ersten Gegner, der sich durch
## ihre Sichtlinie bewegt (mit Malus – außer beim Sentry-Passiv).
func _do_overwatch() -> void:
	if not player_turn or game_over or selected == null or _any_moving() or anim_busy:
		return
	if selected.actions <= 0 or selected.overwatch:
		return
	if not _commit(selected):
		return
	selected.actions = 0
	selected.rush_move = false
	pending_ability = ""
	selected.set_overwatch(true)
	_clear_highlights()
	_update_labels()
	_after_player_action()


func _use_ability_slot(slot: int) -> void:
	if not player_turn or game_over or selected == null or _any_moving() or anim_busy:
		return
	if slot >= selected.abilities.size():
		return
	if active_unit != null and active_unit != selected:
		return
	var ability_id: String = selected.abilities[slot]
	if selected.actions <= 0 or selected.cooldown_of(ability_id) > 0:
		return

	match ability_id:
		"slug_rush":
			if selected.rush_move or selected.free_shot:
				return
			if not _commit(selected):
				return
			selected.actions -= 1
			selected.rush_move = true
			selected.cooldowns["slug_rush"] = ABILITIES["slug_rush"]["cooldown"]
			_refresh_highlights()
		"bulwark":
			if selected.bulwark:
				return
			if not _commit(selected):
				return
			selected.actions -= 1
			selected.set_bulwark(true)
			ship_label.text = "Ship: \"Bulwark-Haltung aktiv. Offiziell Teil der Architektur.\""
			_after_player_action()
		"mend":
			pending_ability = "mend"
			info_label.text = "Mend: Verbündeten anklicken (Reichweite %d, heilt %d HP) · Esc: abbrechen" \
				% [int(MEND_RANGE), MEND_HEAL]
		"shock":
			pending_ability = "shock"
			info_label.text = "Shock: Gegner anklicken (Reichweite %d, streicht dessen nächste Aktivierung) · Esc: abbrechen" \
				% int(SHOCK_RANGE)
	_update_labels()


## Shock: 1 Schaden auf den Schild - oder, falls keiner da ist, 1 direkt
## auf die HP (ignoriert Panzerung), plus der Shocked-Status. Aufrufbar
## sowohl über die alte Tasten-1/2-Zielwahl als auch direkt über das
## Aktionsmenü beim Klick auf einen Gegner.
func _cast_shock(caster: Unit, target: Unit) -> void:
	if not _commit(caster):
		return
	caster.actions -= 1
	caster.cooldowns["shock"] = ABILITIES["shock"]["cooldown"]
	info_label.text = INFO_DEFAULT
	await _drone_flight(caster, target)
	var res := {"shield": 0, "hp": 0}
	if target.shield > 0:
		res["shield"] = 1
	else:
		res["hp"] = 1
	target.take_hit(res["shield"], res["hp"])
	_flinch(target)
	_show_hit_popup(target, res)
	if not target.is_alive():
		_kill_unit(target)
	else:
		target.set_shocked(true)
	ship_label.text = "Ship: \"Zzzt. Elektroschock zugestellt. Ich applaudiere innerlich.\""
	_update_labels()
	_refresh_highlights()
	_after_player_action()


func _resolve_pending_ability(target: Unit) -> void:
	var caster := selected
	var ability_id := pending_ability

	if ability_id == "mend" and target != null and caster != null \
			and target.faction == Unit.Faction.PLAYER \
			and _dist(caster.cell, target.cell) <= MEND_RANGE:
		if not _commit(caster):
			pending_ability = ""
			return
		pending_ability = ""
		caster.actions -= 1
		caster.cooldowns["mend"] = ABILITIES["mend"]["cooldown"]
		info_label.text = INFO_DEFAULT
		await _drone_flight(caster, target)
		target.heal(MEND_HEAL)
		_spawn_popup(target.position, "+%d" % MEND_HEAL, Color("9fe6a0"))
		ship_label.text = "Ship: \"Patch flickt. Nomen est omen.\""
		_update_labels()
		_refresh_highlights()
		_after_player_action()
		return

	if ability_id == "shock" and target != null and caster != null \
			and target.faction == Unit.Faction.SWARM \
			and _dist(caster.cell, target.cell) <= SHOCK_RANGE:
		pending_ability = ""
		await _cast_shock(caster, target)
		return

	# Ungültiges Ziel -> Zielwahl abbrechen
	pending_ability = ""
	info_label.text = INFO_DEFAULT
	_update_labels()


func _update_ability_buttons() -> void:
	var s := selected
	var ok := player_turn and not game_over and s != null and is_instance_valid(s)
	overwatch_button.disabled = not (ok and s.actions > 0 and not s.overwatch)
	for i in range(ability_buttons.size()):
		var btn := ability_buttons[i]
		if not ok or i >= s.abilities.size():
			btn.visible = false
			continue
		var aid: String = s.abilities[i]
		var cd := s.cooldown_of(aid)
		var txt: String = "%s  [%d]" % [ABILITIES[aid]["label"], i + 1]
		if cd > 0:
			txt = "%s (noch %d)  [%d]" % [ABILITIES[aid]["label"], cd, i + 1]
		if pending_ability == aid:
			txt = "» " + txt
		btn.text = txt
		btn.visible = true
		var usable := s.actions > 0 and cd == 0
		if aid == "slug_rush" and (s.rush_move or s.free_shot):
			usable = false
		if aid == "bulwark" and s.bulwark:
			usable = false
		btn.disabled = not usable


# --- Auswahl & Anzeige -----------------------------------------------------

func _select(u: Unit) -> void:
	selected = u
	pending_ability = ""
	if select_ring.get_parent() != null:
		select_ring.get_parent().remove_child(select_ring)
	u.add_child(select_ring)
	select_ring.position = Vector3(0, 0.02, 0)
	select_ring.visible = true
	_center_camera_on(u.position)
	_refresh_highlights()
	_refresh_los_debug()
	_show_unit_stats(u)
	_update_labels()


func _select_next() -> void:
	if not player_turn or game_over or active_unit != null:
		return
	var open: Array[Unit] = []
	for p in _players():
		if not p.activated:
			open.append(p)
	if open.is_empty():
		return
	var idx := open.find(selected)
	_select(open[(idx + 1) % open.size()])


## Zeigt die Werte von 'u' als saubere Tabelle im Statuspanel (oben rechts) -
## fuer die gehoverte Einheit (egal ob eigen oder Gegner) oder, wenn gerade
## keine gehovert wird, fuer die aktuell ausgewaehlte.
func _show_unit_stats(u: Unit) -> void:
	if stat_panel == null:
		return
	if u == null or not is_instance_valid(u):
		stat_panel.text = ""
		return
	var rows: Array = [
		["Fraktion", "Spieler" if u.faction == Unit.Faction.PLAYER else "Swarm"],
		["HP", "%d/%d" % [u.hp, u.max_hp]],
	]
	if u.max_shield > 0:
		rows.append(["Schild", "%d/%d" % [u.shield, u.max_shield]])
	rows.append(["Panzerung", str(u.armor)])
	rows.append(["Fernkampf", str(u.ranged)])
	rows.append(["Nahkampf", str(u.melee)])
	rows.append(["Verteidigung", str(u.defense)])
	if u.ranged_weapon != null:
		var rw := u.ranged_weapon
		rows.append(["FK-Waffe", "%s (Reichw. %d)" % [rw.weapon_name, rw.weapon_range]])
		rows.append(["  AP / SD / Tödlich", "%d / %d / %d" % [rw.ap, rw.sd, rw.lethal]])
	if u.melee_weapon != null:
		var mw := u.melee_weapon
		rows.append(["NK-Waffe", mw.weapon_name])
		rows.append(["  AP / SD / Tödlich", "%d / %d / %d" % [mw.ap, mw.sd, mw.lethal]])
	var status: Array[String] = []
	if u.overwatch:
		status.append("Overwatch")
	if u.bulwark:
		status.append("Bulwark")
	if u.shocked:
		status.append("Geschockt")
	if u.activated:
		status.append("Aktiviert")
	if not status.is_empty():
		rows.append(["Status", ", ".join(status)])

	var bb := "[b]%s[/b]\n[table=2]" % u.unit_name
	for row in rows:
		bb += "[cell]%s[/cell][cell]%s[/cell]" % [row[0], row[1]]
	bb += "[/table]"
	stat_panel.text = bb


func _update_labels() -> void:
	var open_players := 0
	for p in _players():
		if not p.activated:
			open_players += 1
	if player_turn:
		turn_label.text = "Runde %d · Wähle einen Soldaten und aktiviere ihn (offen: %d Trupp / %d Swarm)" \
			% [round_num, open_players, enemy_queue.size()]
	else:
		turn_label.text = "Runde %d · Der Swarm aktiviert …" % round_num
	if selected != null and is_instance_valid(selected):
		var def_txt := ""
		if selected.max_shield > 0:
			def_txt += " · Schild %d/%d" % [selected.shield, selected.max_shield]
		if selected.armor > 0:
			def_txt += " · Panzerung %d" % selected.armor
		var status_txt := ""
		if selected.overwatch:
			status_txt += " · OVERWATCH"
		if selected.bulwark:
			status_txt += " · BULWARK"
		if selected.rush_move:
			status_txt += " · Rush: Zielfeld wählen!"
		if selected.free_shot:
			status_txt += " · Freischuss bereit!"
		actions_label.text = "%s · HP %d/%d%s · Aktionen %d/%d%s" \
			% [selected.unit_name, selected.hp, selected.max_hp, def_txt,
				selected.actions, ACTIONS_PER_TURN, status_txt]
	else:
		actions_label.text = ""
	_update_ability_buttons()


func _clear_highlights() -> void:
	for node in highlight_nodes.values():
		node.queue_free()
	highlight_nodes.clear()


func _refresh_highlights() -> void:
	_clear_highlights()
	if not player_turn or game_over or selected == null:
		return
	if not _can_move(selected) or selected.is_moving:
		return
	var reach := grid.reachable(selected.cell, selected.move_range, _occupied_cells(selected))
	for c in reach:
		if c == selected.cell:
			continue
		var quad := _make_quad(mat_highlight, 0.02)
		quad.position = _cell_to_world(c) + Vector3(0, 0.02, 0)
		add_child(quad)
		highlight_nodes[c] = quad


func _on_any_move_finished() -> void:
	_refresh_los_debug()
	if selected != null and is_instance_valid(selected):
		_center_camera_on(selected.position)
	if player_turn:
		_refresh_highlights()
		_update_labels()
		_after_player_action()


## Sichtlinien-Debug (Taste L): färbt jedes freie Feld danach, ob die
## ausgewählte Einheit es sehen kann – cyan = Sichtlinie & in Waffenreichweite,
## blassblau = Sichtlinie, aber außer Reichweite, rot = keine Sichtlinie.
func _refresh_los_debug() -> void:
	for n in los_nodes:
		n.queue_free()
	los_nodes.clear()
	if not los_debug or selected == null or not is_instance_valid(selected):
		return
	for x in GRID_W:
		for y in GRID_H:
			var c := Vector2i(x, y)
			if OBSTACLES.has(c) or c == selected.cell:
				continue
			var mat := mat_los_blocked
			if Combat.line_of_sight(grid, selected.cell, c):
				var rng := selected.ranged_weapon.weapon_range if selected.ranged_weapon != null else 1
				if _dist(selected.cell, c) <= float(rng):
					mat = mat_los_ok
				else:
					mat = mat_los_far
			var quad := _make_quad(mat, 0.015)
			quad.position = _cell_to_world(c) + Vector3(0, 0.015, 0)
			add_child(quad)
			los_nodes.append(quad)


# --- Animationen -----------------------------------------------------------

## Kleiner schwebender Text (Schaden / Daneben) über einer Einheit.
func _spawn_popup(world_pos: Vector3, text: String, color: Color) -> void:
	var lbl := Label3D.new()
	lbl.text = text
	lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lbl.no_depth_test = true
	lbl.font_size = 56
	lbl.outline_size = 12
	lbl.pixel_size = 0.012
	lbl.modulate = color
	lbl.position = world_pos + Vector3(0, 2.6, 0)
	add_child(lbl)
	var tw := lbl.create_tween()
	tw.tween_property(lbl, "position:y", lbl.position.y + 1.2, 0.8)
	tw.parallel().tween_property(lbl, "modulate:a", 0.0, 0.8)
	tw.finished.connect(lbl.queue_free)


## Leuchtspur-Projektil vom Schützen zum Ziel; Fehlschüsse fliegen sichtbar
## vorbei.
func _fire_tracer(shooter: Unit, target: Unit, hit: bool, color: Color) -> void:
	var tracer := MeshInstance3D.new()
	var m := BoxMesh.new()
	m.size = Vector3(0.09, 0.09, 0.7)
	tracer.mesh = m
	tracer.material_override = _unshaded(Color(color.r, color.g, color.b, 0.95))
	add_child(tracer)
	var from := shooter.position + Vector3(0, 1.2, 0)
	var to := target.position + Vector3(0, 1.0, 0)
	if not hit:
		to += Vector3(randf_range(-1.4, 1.4), randf_range(0.0, 0.9), randf_range(-1.4, 1.4))
	tracer.position = from
	if from.distance_to(to) > 0.01:
		tracer.look_at(to)
	var tw := tracer.create_tween()
	tw.tween_property(tracer, "position", to, clampf(from.distance_to(to) * 0.014, 0.08, 0.25))
	await tw.finished
	tracer.queue_free()


## Spielt die passende Angriffsanimation der Figur (Fernkampf/Nahkampf).
func _play_attack_anim(attacker: Unit, use_melee: bool) -> void:
	if use_melee:
		attacker.play_attack_melee()
	else:
		attacker.play_attack_ranged()


## Kurzes Zucken beim Einschlag.
func _flinch(u: Unit) -> void:
	if u.is_moving:
		return
	var origin := u.position
	var tw := u.create_tween()
	tw.tween_property(u, "position",
		origin + Vector3(randf_range(-0.18, 0.18), 0.0, randf_range(-0.18, 0.18)), 0.06)
	tw.tween_property(u, "position", origin, 0.1)


## Handlers Drohne fliegt zum Ziel und zurück (Mend/Shock).
func _drone_flight(from_u: Unit, to_u: Unit) -> void:
	anim_busy = true
	var drone := MeshInstance3D.new()
	var cube := BoxMesh.new()
	cube.size = Vector3(0.3, 0.3, 0.3)
	drone.mesh = cube
	var dmat := StandardMaterial3D.new()
	dmat.albedo_color = Color("8fd8e8")
	drone.material_override = dmat
	add_child(drone)
	var from := from_u.position + Vector3(0.7, 1.6, 0.3)
	var to := to_u.position + Vector3(0, 1.6, 0)
	drone.position = from
	var tw := drone.create_tween()
	tw.tween_property(drone, "position", to, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_interval(0.15)
	tw.tween_property(drone, "position", from, 0.3).set_trans(Tween.TRANS_SINE)
	await tw.finished
	drone.queue_free()
	anim_busy = false


# --- Kampf -----------------------------------------------------------------

## Würfelt einen kompletten Angriff (Fernkampf ODER Nahkampf) nach dem
## Würfelpool-System durch (dice-system.md), wendet aber noch NICHTS an -
## reine Vorausberechnung, damit die Tracer-Animation vorher weiß, ob sie
## als Treffer oder Fehlschuss fliegen soll. "net" > 0 heißt: der Angriff
## hat die Verteidigung durchbrochen (auch wenn am Ende 0 HP-Schaden
## durchkommt, weil Panzerung/Schild alles auffangen).
## 'use_melee': welche Waffe genutzt wird - true für Nahkampf
## (melee_weapon, Nahkampf-Stat, Charge-/Flanking-Boni), false für
## Fernkampf (ranged_weapon, Fernkampf-Stat, Deckungs-Bonus). Jeder
## Kämpfer hat inzwischen beide Waffentypen (mind. Pistole/Messer als
## Behelfswaffe, siehe weapons.gd) - für den seltenen Fall, dass eine
## Waffe fehlt (z. B. Swarm-Gegner), wird mit AP/SD/Lethal 0 gerechnet.
## 'extra_bonus': situative Zusatzwürfel, die nicht aus Deckung/Charge/
## Flanking stammen (z. B. der +1-Deckel beim ZoC-Gegenangriff aus
## mehreren gleichzeitig verlassenen Zonen, siehe _resolve_zoc_exit -
## der dort auch für Fernkämpfer immer 'use_melee=true' übergibt, da
## jeder Kämpfer seine Zone of Control unabhängig von der Waffe
## kontrolliert, dice-system.md Abschnitt 3).
func _roll_attack(attacker: Unit, target: Unit, use_melee: bool, extra_bonus: int = 0) -> Dictionary:
	var w: Weapon = attacker.melee_weapon if use_melee else attacker.ranged_weapon
	var ap := w.ap if w != null else 0
	var sd := w.sd if w != null else 0
	var lethal := w.lethal if w != null else 0
	var bonus := extra_bonus
	var pool_parts: Array[String] = ["Basis 3"]
	if extra_bonus != 0:
		pool_parts.append("Sonderbonus %+d" % extra_bonus)
	if use_melee:
		if attacker.charge_ready:
			bonus += 2
			attacker.charge_ready = false
			pool_parts.append("Charge +2")
		if _flanking(attacker, target):
			bonus += 1
			pool_parts.append("Flanking +1")
	else:
		var cm := Combat.cover_malus(grid, attacker.cell, target.cell, _extra_cover_for(target))
		var cover_bonus := Combat.cover_bonus_dice(cm)
		bonus += cover_bonus
		var cover_label := "flankiert"
		if cm == Combat.FULL_COVER_MALUS:
			cover_label = "volle Deckung"
		elif cm == Combat.HALF_COVER_MALUS:
			cover_label = "leichte Deckung"
		pool_parts.append("%s %+d" % [cover_label, cover_bonus])
	var pool_txt := "%s = %d Würfel" % [" + ".join(pool_parts), 3 + bonus]
	var skill := attacker.melee if use_melee else attacker.ranged
	var atk := Combat.roll_pool(3 + bonus, skill)
	var def := Combat.roll_pool(3, target.defense)
	var net := Combat.net_successes(atk["hits"], def["hits"])
	var res := Combat.resolve_net_damage(net, ap, sd, lethal, target.shield, target.armor)
	res["net"] = net
	_log_roll(attacker, target, atk, def, net, res, pool_txt)
	return res


## Hängt eine Zeile mit der vollen Würfel-Aufschlüsselung ans Log an
## (letzte ROLL_LOG_MAX Angriffe, neueste unten) - inklusive, wie sich der
## Angriffspool zusammensetzt (Basis + Deckung/Charge/Flanking/Sonderbonus),
## damit sich deren Wirkung auf den Pool nachvollziehen lässt.
func _log_roll(attacker: Unit, target: Unit, atk: Dictionary, def: Dictionary, net: int, res: Dictionary, pool_txt: String) -> void:
	if log_panel == null:
		return
	var line := "[b]%s[/b] -> %s\n  Pool: %s\n  Angriff %s = %d Treffer (%d Krit) · Verteidigung %s = %d Erfolge\n  Netto %d" \
		% [attacker.unit_name, target.unit_name, pool_txt, \
			str(atk["rolls"]), atk["hits"], atk["crits"], str(def["rolls"]), def["hits"], net]
	if net > 0:
		line += " · Schild -%d · HP -%d" % [res["shield"], res["hp"]]
	else:
		line += " · kein Durchbruch"
	roll_log_lines.append(line)
	while roll_log_lines.size() > ROLL_LOG_MAX:
		roll_log_lines.pop_front()
	log_panel.text = "\n".join(roll_log_lines)


## Wendet ein bereits gewürfeltes Ergebnis (aus _roll_attack) an: Schaden,
## Popup, Flinch, ggf. Tod.
func _apply_attack_result(target: Unit, res: Dictionary) -> Dictionary:
	target.take_hit(res["shield"], res["hp"])
	if res["shield"] > 0 or res["hp"] > 0:
		_flinch(target)
	_show_hit_popup(target, res)
	res["killed"] = not target.is_alive()
	if res["killed"]:
		_kill_unit(target)
	return res


func _show_hit_popup(target: Unit, res: Dictionary) -> void:
	if res["hp"] > 0:
		var txt := "-%d" % res["hp"]
		if res["shield"] > 0:
			txt += " (Schild -%d)" % res["shield"]
		_spawn_popup(target.position, txt, Color("ff6b5e"))
	elif res["shield"] > 0:
		_spawn_popup(target.position, "SCHILD -%d" % res["shield"], Color("6fd8e8"))
	else:
		_spawn_popup(target.position, "ABGEPRALLT", Color("cfd6e4"))


## 'use_melee': Schießen (false) oder Nahkampf (true) - siehe _roll_attack.
func _player_attack(attacker: Unit, target: Unit, use_melee: bool) -> void:
	# Charge (dice-system.md Abschnitt 3): der ausgelöste Nahkampfangriff
	# direkt nach dem aktiven Reinbewegen in eine gegnerische ZoC kostet
	# KEINEN zusätzlichen Aktionspunkt - _roll_attack verbraucht
	# charge_ready gleich mit, daher hier VOR dem Aufruf sichern.
	var charge_free := use_melee and attacker.charge_ready
	var roll := _roll_attack(attacker, target, use_melee)
	if attacker.free_shot:
		attacker.free_shot = false  # Slug-Rush-Freischuss verbraucht
	elif charge_free:
		pass  # Charge-Angriff ist Teil der Bewegung, kein Extra-Aktionspunkt
	else:
		attacker.actions -= 1
	target_marker.visible = false

	var hit: bool = roll["net"] > 0
	anim_busy = true
	_play_attack_anim(attacker, use_melee)
	await _fire_tracer(attacker, target, hit, Color(1.0, 0.9, 0.5))
	anim_busy = false
	if hit:
		var res := _apply_attack_result(target, roll)
		if res["killed"] and not game_over:
			ship_label.text = SHIP_KILL_LINES.pick_random()
	else:
		_spawn_popup(target.position, "DANEBEN", Color("cfd6e4"))
		ship_label.text = SHIP_MISS_LINES.pick_random()

	_update_labels()
	_refresh_highlights()
	_after_player_action()


func _kill_unit(u: Unit) -> void:
	units.erase(u)
	if select_ring.get_parent() == u:
		u.remove_child(select_ring)
		add_child(select_ring)
		select_ring.visible = false
	if selected == u:
		selected = null
	u.play_die()
	# Todes-Animation: kurz zusammenschrumpfen, dann entfernen.
	var tw := u.create_tween()
	tw.tween_property(u, "scale", Vector3(0.05, 0.05, 0.05), 0.25)
	tw.finished.connect(u.queue_free)
	_check_end_conditions()


func _check_end_conditions() -> void:
	if _enemies().is_empty():
		game_over = true
		overlay_label.text = "BEREICH GESICHERT\n[R] Neustart"
		overlay_label.add_theme_color_override("font_color", Color("a5e6b0"))
		overlay_label.visible = true
		ship_label.text = "Ship: \"Bereich gesichert. Ich habe schon dreimal neue Probleme gefunden.\""
		_clear_highlights()
	elif _players().is_empty():
		game_over = true
		overlay_label.text = "DIE EINHEIT IST GEFALLEN\n[R] Neustart"
		overlay_label.add_theme_color_override("font_color", Color("ff8d84"))
		overlay_label.visible = true
		ship_label.text = "Ship: \"… Ich bin dann wohl wieder allein. Das war nicht als Wunsch gemeint.\""
		_clear_highlights()


# --- Alternierende Aktivierungen (Kill-Team-Prinzip) -----------------------

## Bindet den ersten Aktionspunkt eines Soldaten an dessen Aktivierung:
## Sobald er handelt, ist er "der aktive Soldat", bis seine Aktivierung
## endet – erst dann ist der Swarm mit einer Einheit dran.
func _commit(u: Unit) -> bool:
	if active_unit == u:
		return true
	if active_unit != null:
		return false
	if u.activated:
		return false
	active_unit = u
	u.charges_used = 0
	u.charge_ready = false
	if u.overwatch:
		u.set_overwatch(false)  # Eine neue Aktivierung ersetzt alten Overwatch
	_update_labels()
	return true


## Prüft nach jeder Spieler-Aktion, ob die Aktivierung damit beendet ist.
func _after_player_action() -> void:
	if active_unit == null or game_over:
		return
	if active_unit.actions <= 0 and not active_unit.rush_move \
			and not active_unit.free_shot and pending_ability == "":
		_finish_player_activation()


## Button/Enter: beendet die Aktivierung des aktuellen Soldaten manuell.
## Ohne begonnene Aktivierung "passt" der ausgewählte Soldat (Overwatch
## aus der Vorrunde bleibt ihm dabei erhalten).
func _end_activation() -> void:
	if not player_turn or game_over or _any_moving() or anim_busy:
		return
	if active_unit == null:
		if selected == null or not is_instance_valid(selected) or selected.activated:
			return
		active_unit = selected
	_finish_player_activation()


func _finish_player_activation() -> void:
	# Sofort sperren: Während Atempause und Swarm-Zug darf kein weiterer
	# Spieler-Befehl starten (sonst laufen zwei Swarm-Züge parallel).
	player_turn = false
	end_turn_button.disabled = true
	var u := active_unit
	active_unit = null
	if u != null and is_instance_valid(u):
		u.rush_move = false
		u.free_shot = false
		u.actions = 0
		u.set_activated(true)
	pending_ability = ""
	_clear_highlights()
	_update_labels()

	# Pacing: erst alle laufenden Animationen zu Ende schauen lassen,
	# dann eine kurze Atempause, bevor der Swarm antwortet.
	while _any_moving() or anim_busy:
		await get_tree().process_frame
	if not enemy_queue.is_empty():
		await get_tree().create_timer(0.8).timeout

	await _swarm_step()
	if game_over:
		return
	if _all_players_activated():
		# Trupp ist durch – der Swarm zieht seine restlichen Aktivierungen.
		while not enemy_queue.is_empty() and not game_over:
			await _swarm_step()
		if game_over:
			return
		_start_new_round()
	else:
		player_turn = true
		end_turn_button.disabled = false
		_select_next_unactivated()
		_refresh_highlights()
		_update_labels()


func _all_players_activated() -> bool:
	for p in _players():
		if not p.activated:
			return false
	return true


func _select_next_unactivated() -> void:
	var players := _players()
	if selected != null and is_instance_valid(selected) and not selected.activated:
		return  # aktuelle Auswahl ist noch offen – nichts umwählen
	for p in players:
		if not p.activated:
			_select(p)
			return
	if not players.is_empty():
		_select(players[0])


## Baut die Aktivierungs-Warteschlange des Swarm für diese Runde:
## Spitter aktivieren einzeln, schwache Nahkampf-Drohnen als Zweier-Einheit.
func _build_enemy_queue() -> void:
	enemy_queue.clear()
	var drones: Array[Unit] = []
	for e in _enemies():
		if e.melee_weapon != null:
			drones.append(e)
		else:
			enemy_queue.append([e])
	var i := 0
	while i < drones.size():
		var group: Array = [drones[i]]
		if i + 1 < drones.size():
			group.append(drones[i + 1])
		enemy_queue.append(group)
		i += 2
	enemy_queue.shuffle()


## Eine Swarm-Aktivierung: die nächste Gruppe aus der Warteschlange handelt.
func _swarm_step() -> void:
	if enemy_queue.is_empty() or game_over:
		return
	player_turn = false
	end_turn_button.disabled = true
	hover_marker.visible = false
	target_marker.visible = false
	_update_labels()

	var group: Array = enemy_queue.pop_front()
	for enemy in group:
		if game_over:
			return
		# Wichtig: erst auf Gültigkeit prüfen – die Einheit kann bereits
		# gefallen und freigegeben sein, während sie noch in der
		# Warteschlange stand ('is'-Check auf freigegebene Objekte crasht).
		if not is_instance_valid(enemy) or not units.has(enemy):
			continue
		enemy.charges_used = 0
		enemy.charge_ready = false
		# Ankündigung: Wer handelt gerade? (Marker + Name, kurze Pause)
		turn_label.text = "Runde %d · Swarm: %s …" % [round_num, enemy.unit_name]
		target_marker.position = _cell_to_world(enemy.cell) + Vector3(0, 0.03, 0)
		target_marker.visible = true
		await get_tree().create_timer(0.5).timeout
		target_marker.visible = false
		if not is_instance_valid(enemy) or not units.has(enemy):
			continue
		# Shock-Effekt: die Aktivierung fällt komplett aus.
		if enemy.shocked:
			_spawn_popup(enemy.position, "GESCHOCKT", Color("ffe28a"))
			enemy.set_shocked(false)
			await get_tree().create_timer(0.4).timeout
			continue
		if _players().is_empty():
			return
		if enemy.melee_weapon != null:
			await _drone_activation(enemy)
		else:
			await _spitter_activation(enemy)
		if game_over:
			return
		if units.has(enemy):
			enemy.set_activated(true)
		await get_tree().create_timer(0.25).timeout


## Blendet kurz ein Banner ein ("RUNDE 3") und wieder aus – das klare,
## unübersehbare Signal für den Rundenwechsel.
func _flash_round_banner(text: String) -> void:
	round_banner_label.text = text
	round_banner_label.modulate = Color(1, 1, 1, 0)
	round_banner_label.visible = true
	var tw := round_banner_label.create_tween()
	tw.tween_property(round_banner_label, "modulate:a", 1.0, 0.25)
	tw.tween_interval(1.0)
	tw.tween_property(round_banner_label, "modulate:a", 0.0, 0.45)
	tw.finished.connect(func() -> void: round_banner_label.visible = false)


## Rundenende: JETZT regenerieren die Schilde (+1, beide Seiten), Cooldowns
## laufen ab, alle Aktivierungen werden zurückgesetzt.
func _start_new_round() -> void:
	round_num += 1
	_flash_round_banner("RUNDE %d" % round_num)
	for u in units:
		u.regen_shield()
		u.set_activated(false)
	for p in _players():
		p.actions = ACTIONS_PER_TURN
		p.tick_cooldowns()
		p.rush_move = false
		p.free_shot = false
	_build_enemy_queue()
	player_turn = true
	end_turn_button.disabled = false
	ship_label.text = SHIP_TURN_LINES.pick_random()
	if selected == null or not is_instance_valid(selected):
		var players := _players()
		if not players.is_empty():
			_select(players[0])
	_refresh_highlights()
	_update_labels()


## Nahkampf-Drohne: auf den nächsten Soldaten zulaufen, dann beißen.
func _drone_activation(enemy: Unit) -> void:
	var players := _players()
	var target: Unit = players[0]
	for p in players:
		if _manhattan(enemy.cell, p.cell) < _manhattan(enemy.cell, target.cell):
			target = p

	if not Combat.in_zoc(enemy.cell, target.cell):
		var occ := _occupied_cells(enemy)
		var reach := grid.reachable(enemy.cell, enemy.move_range, occ)
		var best := enemy.cell
		var best_d := _manhattan(enemy.cell, target.cell)
		for c in reach:
			var d := _manhattan(c, target.cell)
			if d < best_d:
				best_d = d
				best = c
		if best != enemy.cell:
			var path := grid.find_path(enemy.cell, best, occ)
			if path.size() >= 2:
				_track_charge(enemy, path[0], path[path.size() - 1])
				await _walk_enemy_with_reactions(enemy, path)
	if not units.has(enemy):
		return  # im Overwatch-Feuer oder ZoC-Gegenangriff gefallen

	for p in _players():
		if Combat.in_zoc(enemy.cell, p.cell):
			await _enemy_attack(enemy, p)
			break


## Fernkampf-Spitter: bestes Ziel suchen; wenn keins beschießbar ist,
## eine Schussposition anlaufen und dann spucken.
func _spitter_activation(enemy: Unit) -> void:
	var best := _best_shot_target(enemy)
	if best["score"] < 0:
		# Keine Schusslinie: Feld mit der besten Schuss-Aussicht anlaufen.
		var occ := _occupied_cells(enemy)
		var reach := grid.reachable(enemy.cell, enemy.move_range, occ)
		var best_cell := enemy.cell
		var best_score := _spitter_shot_score(enemy.cell, enemy)
		var nearest := _nearest_player(enemy.cell)
		var best_d := _manhattan(enemy.cell, nearest.cell)
		for c in reach:
			var score := _spitter_shot_score(c, enemy)
			var d := _manhattan(c, nearest.cell)
			if score > best_score or (score == best_score and d < best_d):
				best_score = score
				best_d = d
				best_cell = c
		if best_cell != enemy.cell:
			var path := grid.find_path(enemy.cell, best_cell, occ)
			if path.size() >= 2:
				await _walk_enemy_with_reactions(enemy, path)
		if not units.has(enemy):
			return
		best = _best_shot_target(enemy)
	if best["score"] >= 0 and best["target"] != null:
		await _enemy_ranged_attack(enemy, best["target"])


func _nearest_player(from: Vector2i) -> Unit:
	var players := _players()
	var result: Unit = players[0]
	for p in players:
		if _manhattan(from, p.cell) < _manhattan(from, result.cell):
			result = p
	return result


## Bester Spieler als Ziel vom aktuellen Feld aus. Grobe KI-Heuristik ohne
## echte Erfolgswahrscheinlichkeit: größerer eigener Würfelpool und ein
## schwächer verteidigendes Ziel sind besser (TODO Balancing: eine
## Bewertung über die tatsächliche Trefferwahrscheinlichkeit wäre
## genauer, hier bewusst einfach gehalten).
func _best_shot_target(sp: Unit) -> Dictionary:
	var bt: Unit = null
	var bs := -1
	for p in _players():
		if not _can_attack_ranged(sp, p):
			continue
		var cm := Combat.cover_malus(grid, sp.cell, p.cell, _extra_cover_for(p))
		var pool := 3 + Combat.cover_bonus_dice(cm)
		var score := pool * 2 - p.defense
		if score > bs:
			bs = score
			bt = p
	return {"target": bt, "score": bs}


## Wie gut könnte dieser Spitter von Feld 'from' aus schießen? (-1 = gar
## nicht erreichbar) Gleiche Heuristik wie _best_shot_target.
func _spitter_shot_score(from: Vector2i, sp: Unit) -> int:
	var best := -1
	for p in _players():
		if Combat.in_zoc(from, p.cell):
			continue  # zu nah dran -> von dort aus nicht beschiessbar
		if _dist(from, p.cell) > float(sp.ranged_weapon.weapon_range):
			continue
		if not Combat.line_of_sight(grid, from, p.cell):
			continue
		var cm := Combat.cover_malus(grid, from, p.cell, _extra_cover_for(p))
		var pool := 3 + Combat.cover_bonus_dice(cm)
		best = maxi(best, pool * 2 - p.defense)
	return best


func _enemy_ranged_attack(enemy: Unit, target: Unit) -> void:
	var roll := _roll_attack(enemy, target, false)
	var hit: bool = roll["net"] > 0
	_play_attack_anim(enemy, false)
	await _fire_tracer(enemy, target, hit, Color(0.72, 0.91, 0.43))  # Säure
	if hit:
		var res := _apply_attack_result(target, roll)
		if res["hp"] > 0 and not game_over:
			ship_label.text = SHIP_HURT_LINES.pick_random()
	else:
		_spawn_popup(target.position, "VERFEHLT", Color("cfd6e4"))
	_update_labels()
	await get_tree().create_timer(0.2).timeout


## Alle Overwatch-Einheiten, die das Feld 'c' sehen und in Reichweite haben.
func _overwatchers_seeing(c: Vector2i) -> Array[Unit]:
	var result: Array[Unit] = []
	for p in _players():
		if not p.overwatch:
			continue
		if _dist(p.cell, c) > float(p.ranged_weapon.weapon_range):
			continue
		if Combat.line_of_sight(grid, p.cell, c):
			result.append(p)
	return result


## Bewegt einen Gegner Feld für Feld, wertet dabei ZoC-Gegenangriffe aus
## (siehe _resolve_zoc_exit) und unterbricht die Bewegung, sobald er in die
## Sichtlinie einer Overwatch-Einheit läuft – die dann feuert.
func _walk_enemy_with_reactions(enemy: Unit, path: Array[Vector2i]) -> void:
	var i := 1
	while i < path.size():
		var stop := -1
		for j in range(i, path.size()):
			if not _overwatchers_seeing(path[j]).is_empty():
				stop = j
				break
		var end_idx := path.size() - 1
		if stop != -1:
			end_idx = stop
		var sub: Array[Vector2i] = []
		for k in range(i - 1, end_idx + 1):
			sub.append(path[k])
		enemy.walk_path(sub, TILE)
		await enemy.move_finished
		if not units.has(enemy):
			return
		for k in range(i, end_idx + 1):
			await _resolve_zoc_exit(enemy, path[k - 1], path[k])
			if not units.has(enemy):
				return
		if stop == -1:
			return
		for w in _overwatchers_seeing(enemy.cell):
			await _overwatch_shot(w, enemy)
			if not units.has(enemy):
				return  # Ziel gefallen, Bewegung endet hier
		i = end_idx + 1


## Bewegt eine Spieler-Einheit Feld für Feld und wertet dabei ZoC-
## Gegenangriffe der Gegner aus - läuft NACH der Bewegungsanimation, um
## die bestehende move_finished-Signalkette (Aktivierungsende etc.) nicht
## zu stören (siehe _on_any_move_finished).
func _walk_with_reactions(mover: Unit, path: Array[Vector2i]) -> void:
	mover.walk_path(path, TILE)
	await mover.move_finished
	if not units.has(mover):
		return
	for i in range(1, path.size()):
		await _resolve_zoc_exit(mover, path[i - 1], path[i])
		if not units.has(mover):
			return


## ZoC-Gegenangriff (dice-system.md Abschnitt 3): verlässt 'mover' beim
## Schritt von 'from_cell' nach 'to_cell' die Zone of Control eines oder
## mehrerer Gegner (angrenzend vorher, nicht mehr angrenzend danach),
## greift EINER von ihnen kostenlos im Nahkampf an (3-Würfel-Basispool,
## kein Charge-Bonus) - der mit dem höchsten Nahkampf-Wert, bei Gleichstand
## zufällig. Werden gleichzeitig mehrere ZoCs verlassen, bekommt dieser
## Angriff maximal +1 Bonuswürfel (fester Deckel, unabhängig von der
## Zahl der verlassenen ZoCs). Funktioniert unabhängig vom
## Aktivierungsstatus des Gegners - ein ZoC-Gegenangriff kostet ihn nichts.
func _resolve_zoc_exit(mover: Unit, from_cell: Vector2i, to_cell: Vector2i) -> void:
	var opponents := _enemies() if mover.faction == Unit.Faction.PLAYER else _players()
	var leaving: Array[Unit] = []
	for o in opponents:
		if is_instance_valid(o) and units.has(o) and Combat.leaves_zoc(from_cell, to_cell, o.cell):
			leaving.append(o)
	if leaving.is_empty():
		return
	leaving.shuffle()  # Zufalls-Tiebreak bei gleichem Nahkampf-Wert
	var attacker: Unit = leaving[0]
	for o in leaving:
		if o.melee > attacker.melee:
			attacker = o
	var bonus := 1 if leaving.size() > 1 else 0
	_spawn_popup(attacker.position, "ZOC!", Color("ff9d6a"))
	await get_tree().create_timer(0.2).timeout
	attacker.play_attack_melee()  # ZoC-Gegenangriff ist immer Nahkampf
	var roll := _roll_attack(attacker, mover, true, bonus)
	if roll["net"] > 0:
		_apply_attack_result(mover, roll)
	else:
		_spawn_popup(mover.position, "AUSGEWICHEN", Color("cfd6e4"))
	await get_tree().create_timer(0.15).timeout


## Liegt 'cell' in der Zone of Control mindestens eines Gegners von
## 'mover_faction' (siehe Combat.in_zoc)?
func _in_enemy_zoc(cell: Vector2i, mover_faction: int) -> bool:
	var opponents := _enemies() if mover_faction == Unit.Faction.PLAYER else _players()
	for o in opponents:
		if is_instance_valid(o) and units.has(o) and Combat.in_zoc(cell, o.cell):
			return true
	return false


## Charge (dice-system.md Abschnitt 3): bewegt sich 'mover' aktiv NEU in
## gegnerische ZoC hinein (vorher nicht angrenzend, danach schon), bekommt
## sein nächster Nahkampfangriff +2 Bonuswürfel - gedeckelt auf 2x pro
## Aktivierung (reguläre Bewegung + Dash).
func _track_charge(mover: Unit, from_cell: Vector2i, to_cell: Vector2i) -> void:
	if mover.charges_used >= 2:
		return
	if not _in_enemy_zoc(from_cell, mover.faction) and _in_enemy_zoc(to_cell, mover.faction):
		mover.charge_ready = true
		mover.charges_used += 1


## Flanking (dice-system.md Abschnitt 3): +1 Bonuswürfel (fest gedeckelt),
## wenn mindestens ein Verbündeter des Angreifers ebenfalls in der Zone of
## Control desselben Ziels steht. Skaliert NICHT mit der Zahl der
## Verbündeten.
func _flanking(attacker: Unit, target: Unit) -> bool:
	var allies := _players() if attacker.faction == Unit.Faction.PLAYER else _enemies()
	for a in allies:
		if a != attacker and is_instance_valid(a) and units.has(a) and Combat.in_zoc(a.cell, target.cell):
			return true
	return false


## Ein einzelner Reaktionsschuss. Kostet den Overwatch-Status.
## TODO Design-Entscheidung (prototype-plan.md Arbeitsprinzip 3): ob
## Reaktionsschüsse im Würfelpool-System einen Bonuswürfel-Malus bekommen,
## ist noch offen - bis geklärt bewusst OHNE Malus (Sentry-Passiv bleibt
## bis dahin wirkungslos, statt hier eigenmächtig einen Wert zu erfinden).
func _overwatch_shot(w: Unit, enemy: Unit) -> void:
	w.set_overwatch(false)
	if not _can_attack_ranged(w, enemy):
		return
	var roll := _roll_attack(w, enemy, false)
	var hit: bool = roll["net"] > 0
	_spawn_popup(w.position, "OVERWATCH!", Color("8fd8ff"))
	await get_tree().create_timer(0.35).timeout
	_play_attack_anim(w, false)
	await _fire_tracer(w, enemy, hit, Color(1.0, 0.9, 0.5))
	if hit:
		var res := _apply_attack_result(enemy, roll)
		if res["killed"] and not game_over:
			ship_label.text = "Ship: \"Reaktionszeit vorbildlich. Für organische Verhältnisse.\""
	else:
		_spawn_popup(enemy.position, "DANEBEN", Color("cfd6e4"))
	await get_tree().create_timer(0.25).timeout


func _enemy_attack(enemy: Unit, target: Unit) -> void:
	# Kurzer "Biss"-Ausfall in Richtung Ziel.
	_play_attack_anim(enemy, true)
	var origin := enemy.position
	var tw := enemy.create_tween()
	tw.tween_property(enemy, "position", origin.lerp(target.position, 0.35), 0.12)
	tw.tween_property(enemy, "position", origin, 0.12)
	await tw.finished

	var roll := _roll_attack(enemy, target, true)
	if roll["net"] > 0:
		var res := _apply_attack_result(target, roll)
		if res["hp"] > 0 and not game_over:
			ship_label.text = SHIP_HURT_LINES.pick_random()
	else:
		_spawn_popup(target.position, "VERFEHLT", Color("cfd6e4"))
	_update_labels()
