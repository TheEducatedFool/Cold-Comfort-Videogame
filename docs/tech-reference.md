# COLD COMFORT – Technische Referenz & Konventionen für Claude Code

> Zielgruppe: Claude Code, lokal im Projektordner auf Kamils PC.
> Kamil hat keine Coding-Erfahrung – Schritt für Schritt anleiten,
> Deutsch, alles wird für ihn gebaut, getestet und ausgeliefert.

## Wo was liegt

- **Design-Dokumente (Quelle der Wahrheit):** dieser `docs/`-Ordner.
  Navigations-Übersicht: `README.md`. Beschlossene Design-Entscheidungen
  gehören dorthin, nicht in Code-Kommentare.
- **Spielcode:** `game/` im Projektordner – `project.godot`,
  `scenes/main.tscn` (nur Root-Node, alles entsteht im Code),
  `scripts/main.gd` (Spielfluss, UI, KI), `scripts/unit.gd` (Einheit),
  `scripts/grid.gd` (Raster/BFS), `scripts/combat.gd` (Kampfmathe, pure
  statics), `tests/` (automatisierte Tests).
- Godot **4.7.2 (Windows, Standard, nicht .NET)**, EXE im
  Projektordner-Root. Dieselbe Installation läuft auch `--headless` für
  Testläufe.

## Aktueller Codebase-Stand (Basis, auf der aufgebaut wird)

> Stand: 2026-08-31 (nach M1–M4 und drei Playtest-Runden). Bei jeder
> Doku-Synchronisation mit prüfen.

Das **Würfelpool-System ist implementiert**, das alte Prozent-System
vollständig entfernt. Was läuft:

- **Würfelpool-Kern** in `combat.gd`: `roll_pool` (d10, unterboten,
  natürliche 10 = Fehlschlag, explodierende Krits), `net_successes`,
  `resolve_net_damage` (Schild → Panzerung → HP mit AP/SD/Lethal).
  Abgesichert durch `tests/test_dice_pool.gd` und `tests/test_damage.gd`.
- **Einheiten-Werte** in `unit.gd`: getrennte Zielwerte `ranged`,
  `melee`, `defense` (1–10) plus HP/Schild/Panzerung. `base_aim` und
  `falloff` sind entfernt.
- **Waffen** als eigene Resource (`weapon.gd`) mit Katalog
  (`weapons.gd`): Reichweite, AP, SD, Lethal, 3D-Modell. Trait-Wirkungen
  aus `traits.md` sind noch NICHT umgesetzt.
- **Roster:** die 5 aktuellen Klassen (Breacher/Deadeye/Handler/Heavy/
  Reiver) gegen 4 Drohnen + 2 Spitter. Die 4 alten Story-Charaktere sind
  raus. Die Klassen-Fähigkeiten sind aber noch die vier alten
  (Slug Rush/Mend/Shock/Bulwark), provisorisch verteilt – M7 steht aus.
- **Deckung:** die geometrische Erkennung (`cover_malus`, 0/20/40) ist
  unverändert geblieben und wird über `cover_bonus_dice` in Bonuswürfel
  übersetzt (flankiert +2, leichte Deckung +1, volle Deckung +0).
  3-Strahlen-Sichtlinie mit Debug-Taste **L**, siehe `combat.md`.
- **Nahkampf:** Charge-Bonus (+2, max. 2 Charges pro Aktivierung),
  Zone of Control (`in_zoc`/`leaves_zoc`, Gegenangriff beim Verlassen),
  Flanking-Bonus.
- **Aktivierung:** alternierende Einzelaktivierungen, Commitment ab
  erstem Aktionspunkt. Neu aus den Playtests: zweite Bewegung in einer
  Aktivierung ist ein **Dash** (3 Felder), und dieselbe Aktionsart darf
  nicht zweimal pro Aktivierung verwendet werden.
- **Overwatch** unterbricht Bewegung – aktuell **ohne Malus**, weil die
  Design-Frage offen ist (siehe unten). Das Sentry-Passiv des Deadeye
  ist dadurch bis auf Weiteres wirkungslos.
- **Karte & Kamera:** 18×18 Felder, freie Kamera mit WASD-Pan und
  Q/E-Drehung, Anti-Aliasing, UI-Panels, Tracer-/Flinch-/Todes-
  Animationen, Sieg/Niederlage mit Neustart (R).
- **Assets:** Kenney-Platzhalter (Space Kit, Space Station, Blaster Kit,
  Prototype) unter `game/assets/`.

**Noch offen:** Guarded-Haltung (M5), Statuseffekte Pinned/Overheat/
Shaken (M6), echte Klassen-Grundfähigkeiten (M7), Waffen-Traits.
Der Stand pro Meilenstein steht in `prototype-plan.md`.

## Code-Konventionen

- GDScript mit Tabs, deutsche Kommentare (Kamil lernt daran), sprechende
  deutsche UI-Texte; In-Game-Begriffe englisch (Glossar in `setting.md`
  und `traits.md` Abschnitt „Englische Namen").
- Logik von Darstellung trennen: Regeln in `combat.gd`/`grid.gd` (testbar,
  pure Funktionen), Spielfluss/Anzeige in `main.gd`.
- Ship kommentiert Ereignisse (`ship_label`, `SHIP_*_LINES`) – trocken,
  sarkastisch; Ton-Regeln in `setting.md`.
- Vorsicht bei freigegebenen Objekten: Einheiten sterben mit `queue_free`
  + Todes-Tween; Referenzen (`enemy_queue`!) immer erst mit
  `is_instance_valid(x) and units.has(x)` prüfen. Während Zugübergängen
  `player_turn=false` setzen, BEVOR awaits laufen (Eingabe-Race).

## Debugging & Testen im Godot-Editor

1. Projekt im Editor öffnen, mit **F5** starten (nicht die exportierte EXE).
2. Fehler erscheinen unten im Panel **„Debugger" → Tab „Fehler"** (rot)
   mit Stack-Trace; allgemeine Meldungen im Panel **„Ausgabe"**.
3. Für einen Bericht: roten Fehlertext + Stack-Trace kopieren. Zusätzlich
   hilfreich: Was war die letzte Aktion?
4. Log-Dateien: `%APPDATA%\Godot\app_userdata\Cold Comfort\logs\`.
5. Automatisierte Tests: `Godot --headless --path game -s tests/test_fuzz.gd`
   spielt eine komplette Zufalls-Partie und meldet Skript-Fehler
   (bei neuen Gameplay-Features 2–3 Läufe; „SPIEL ENDE" ohne
   SCRIPT ERROR = grün). Weitere Regel-Tests in `game/tests/`.

## Modell-Rollenteilung (Kamils Präferenz)

- **Design- und Story-Entscheidungen, neue Systeme entwerfen:** in
  Cowork/Projektwissen klären (dieses `docs/`-Set ist dort die primäre
  Quelle).
- **Implementierung nach etabliertem Muster:** Claude Code – weitere
  Fähigkeiten/Gegner nach Schema, Balancing-Zahlen, Bugfixes, Karten.
  Bei echten offenen Design-Fragen: notieren statt selbst zu entscheiden,
  zurück an eine Design-Session verweisen.

## Token-Effizienz-Hinweise

- Nie den `.godot/`-Cache-Ordner (Shader-/Import-Cache) rekursiv auflisten
  oder einlesen – nur `scripts/`, `tests/`, `scenes/`, `project.godot`
  gezielt ansehen.
- Bei sehr großen Dateien (z. B. `main.gd`) nur die relevanten
  Funktionsbereiche lesen statt der ganzen Datei.
- Feedback nach Möglichkeit bündeln statt über viele kurze Nachrichten
  verteilen.
