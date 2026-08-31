# Cold Comfort – Projekt-Kontext für Claude

Rundentaktik-Spiel (Godot 4, GDScript) im Grimdark-Sci-Fi-Setting.
Hobby-Projekt von Kamil, **keine Coding-Erfahrung** – Schritte kurz
erklären bevor sie ausgeführt werden, alles selbst testen bevor etwas
als fertig gemeldet wird, auf Deutsch kommunizieren.

## Wo was liegt

- **Design-Dokumente (Quelle der Wahrheit fürs Design):** `docs/`.
  Einstiegspunkt: **`docs/README.md`** (Übersicht, Lesereihenfolge,
  was aktuell ist). Kurzfassung:
  - `docs/tech-reference.md` – Konventionen, Codebase-Stand, Debugging
    (ersetzt das frühere `handover.md`).
  - `docs/gdd.md` – Game Design Document im Überblick.
  - `docs/dice-system.md` – das aktuelle Würfelpool-Kampfsystem (d10,
    Halo-Flashpoint-/Kill-Team-inspiriert) – fertig entschieden, aber
    **noch nicht implementiert** (siehe `docs/prototype-plan.md`).
  - `docs/traits.md` – Waffenprofil (Reichweite/AP/SD/Lethal), Traits,
    Statuseffekte.
  - `docs/classes.md`, `docs/skills.md` – die 5 aktuellen Klassen und
    ihre Skill-Trees.
  - `docs/combat.md` – geometrische Sichtlinien-/Deckungserkennung
    (bleibt unverändert, unabhängig vom Kampfsystem-Umbau).
  - `docs/crew.md`, `docs/setting.md` – Kommandant/Ship/Story-Zugänge,
    Welt/Glossar.
  - `docs/roadmap.md` – Gesamt-Roadmap (Phase 0–9).
  - `docs/prototype-plan.md` – konkreter Meilensteinplan für den
    aktuellen Bauabschnitt (Würfelpool-Umbau), mit Fertig-Kriterien.
  - `docs/code-session-prompts.md` – fertige Prompts pro Meilenstein.
  - `docs/archive/` – rein historisches Material (alte Rechercheunterlagen,
    die vier ursprünglichen Story-Charaktere, alte Session-Übergabe).
    **Nicht lesen, wenn es um die aktuelle Implementierung geht.**
  - Beschlossene Design-Entscheidungen gehören immer in die Dokumente
    oben, nicht nur ins Gespräch.

- **Spielcode:** `game/`
  - `project.godot`, `scenes/main.tscn` (nur Root-Node, der Rest entsteht
    im Code).
  - `scripts/main.gd` – Spielfluss, UI, KI.
  - `scripts/unit.gd` – Einheit.
  - `scripts/grid.gd` – Raster/BFS.
  - `scripts/combat.gd` – Kampfmathe, pure statics (testbar, ohne
    Godot-Node-Abhängigkeiten). **Implementiert aktuell noch das alte
    Prozent-Trefferchancen-System** – wird gerade auf das Würfelpool-
    System aus `docs/dice-system.md` umgebaut, siehe
    `docs/prototype-plan.md` für den Stand.
  - `tests/` – `test_combat.gd`, `test_damage.gd`, `test_los3.gd`
    (gezielte Tests) und `test_fuzz.gd` (Zufalls-Spieltest, spielt eine
    ganze Partie durch, deckt Laufzeitfehler auf).
  - Godot 4.7.2 (Windows, Standard, nicht .NET) liegt unter
    `Godot_v4.7.2-stable/` im Projekt-Root.

## Wichtigste Konventionen (Details: `docs/tech-reference.md`)

- GDScript mit Tabs, **deutsche Kommentare** (Kamil lernt daran),
  sprechende deutsche UI-Texte; In-Game-Begriffe englisch (Glossar in
  `docs/setting.md` und `docs/traits.md`).
- Logik von Darstellung trennen: Regeln in `combat.gd`/`grid.gd` (pure,
  testbar), Spielfluss/Anzeige in `main.gd`.
- Vorsicht bei freigegebenen Objekten: Einheiten sterben mit
  `queue_free` + Todes-Tween; Referenzen auf Einheiten immer erst mit
  `is_instance_valid(x) and units.has(x)` prüfen. Bei Zugübergängen
  `player_turn=false` setzen, BEVOR awaits laufen (Eingabe-Race).
- Vor jeder Auslieferung testen:
  - `Godot --headless --import .` im `game`-Ordner (Parse-Fehler-Check),
  - relevante Tests aus `tests/` mit `--headless --path . -s tests/<datei>`,
  - bei neuen Gameplay-Features 2–3 Läufe von `tests/test_fuzz.gd`
    (`Engine.time_scale=6`, ~60–120s); „SPIEL ENDE" ohne SCRIPT ERROR = grün.
- Nie den `.godot/`-Cache-Ordner (Shader-/Import-Cache) rekursiv lesen
  oder auflisten. Bei sehr großen Dateien (`main.gd`) nur die relevanten
  Funktionsbereiche lesen statt der ganzen Datei.
- Numerische Lücken (Cooldowns, Trait-Zahlen) pragmatisch mit
  Platzhalter + `# TODO Balancing` füllen, nicht bei jedem Wert
  nachfragen. Echte Design-Entscheidungen (neue Mechaniken,
  Regeländerungen) dagegen: notieren und zurückfragen statt selbst zu
  entscheiden.
