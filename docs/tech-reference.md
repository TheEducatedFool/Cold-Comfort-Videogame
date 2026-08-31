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

**Wichtiger Vorbehalt:** Der lauffähige Prototyp-Code implementiert noch
das **alte Prozent-Trefferchancen-System**. Dieses wird durch das in
`dice-system.md` beschriebene Würfelpool-System ersetzt – das ist der
nächste große Umbauschritt (siehe `prototype-plan.md`). Folgendes
funktioniert bereits und bleibt größtenteils bestehen (Grid, Bewegung,
Aktivierungsmodell, Sichtlinie) bzw. wird gezielt ersetzt (Trefferchance,
Schadenswürfel, Werte-Tabellen):

- Alternierende Einzelaktivierungen (Kill-Team-Prinzip), Commitment ab
  erstem Aktionspunkt, schwache Gegner aktivieren paarweise.
- Deckung halb/voll mit Flanking, 3-Strahlen-Sichtlinie mit Kantenglättung
  (Debug-Taste **L**) – **bleibt unverändert**, siehe `combat.md`.
- Overwatch (unterbricht Bewegung, −20 % Malus im alten System – entfällt
  mit dem Würfelpool-Umbau).
- Schadensmodell Schild → Panzerung → HP als Schichtenreihenfolge –
  **die Reihenfolge bleibt**, die Verrechnung ändert sich (Netto-Erfolge
  statt Zufallsschaden, siehe `dice-system.md`).
- 4 Story-Soldaten (Kane/Roan/Okafor/Reyes – **spielerisch nicht mehr
  aktuell**, siehe `crew.md`) vs. 4 Drohnen + 2 Spitter, Fähigkeiten
  Slug Rush/Bulwark/Mend/Shock (Tasten 1/2 – **veraltete Fähigkeitsnamen**,
  aktuelle Klassen/Skills: `classes.md`, `skills.md`).
- Drehbare Kamera (Q/E), Tracer/Flinch/Todes-Animationen, Sieg/Niederlage
  + Neustart (R), Rundenwechsel-Banner.

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
