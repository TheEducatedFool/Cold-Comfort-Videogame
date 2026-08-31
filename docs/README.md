# COLD COMFORT – Dokumenten-Übersicht

> Bereinigt für den Prototyp-Neustart (2026-08-30). Diese Dokumente
> stellen den **aktuellen Design-Stand** dar, nicht den Weg dorthin.
> Für eine Claude-Code-Session: die Dokumente unten (nicht `archive/`)
> reichen aus, um das Spiel zu bauen.

## Lesereihenfolge für eine neue Session

1. **`tech-reference.md`** – wo der Code liegt, Konventionen, wie
   getestet wird. Zuerst lesen, wenn es um Implementierung geht.
2. **`gdd.md`** – Game Design Document: Grundpfeiler, Kampagnenstruktur,
   Taktik-Ebene im Überblick, Schadensmodell, strategische Ebene.
   Verweist von dort auf die Detail-Dokumente.
3. **`dice-system.md`** – die komplette Kampfmechanik (Würfelpool,
   Deckung, Nahkampf/Charge, Kritische Treffer, Schadensmodell, Höhe,
   Guarded/Engaged-Haltung, Kommando-Manöver).
4. **`traits.md`** – Waffenprofil (Reichweite/AP/SD/Lethal), alle Waffen-,
   Ausrüstungs- und Charakter-Traits, Statuseffekt Pinned.
5. **`classes.md`** – die 5 Klassen, Rekrutierungs-Pool, Trait-System,
   Basiswerte.
6. **`skills.md`** – vollständige Skill-Trees pro Klasse.
7. **`crew.md`** – Kommandant, Ship, Rekrutierungs-Pool-Prinzip,
   Story-Zugänge (Silencer/Vector).
8. **`setting.md`** – Welt, Fraktionen, Story-Rahmen, Ton.
9. **`combat.md`** – geometrische Sichtlinien-/Deckungserkennung (bleibt
   durch den Würfelpool-Umbau unverändert).
10. **`roadmap.md`** – die große Gesamt-Roadmap (Phase 0–9, Asset-Quellen,
    Steam-Ziel).
11. **`prototype-plan.md`** – der konkrete Meilenstein-/Schrittplan für
    den nächsten Bauabschnitt (Würfelpool implementieren).
12. **`code-session-prompts.md`** – fertige, kopierbare Prompts pro
    Meilenstein für Claude Code.

## Was NICHT mehr aktuell ist

- **`archive/`** – rein historisches Material: die ursprünglichen vier
  Story-Charaktere (`crew-legacy-characters.md`), die alte
  Cowork-Workflow-Übergabe (`handover-2026-08-28.md`) und die
  Rohrecherche/Wahrscheinlichkeitsanalysen, aus denen `classes.md` und
  `traits.md` hervorgegangen sind (`weapon-equipment-trait-research.md`,
  `combat-balance-analysis.md`). Für den Prototyp-Bau nicht nötig – nur
  bei Interesse an der Design-Historie relevant.
- Alte Dateinamen `*-draft.md` (`dice-system-draft.md`, `traits-draft.md`,
  `classes-draft.md`, `skills-draft.md`) existieren nicht mehr – ersetzt
  durch die gleichnamigen Dateien ohne `-draft`-Suffix oben.

## Bekannte Diskrepanzen zwischen Docs und aktuellem Code

Der lauffähige Godot-Prototyp implementiert noch das **alte
Prozent-Trefferchancen-System** mit den 4 alten Story-Charakteren
(Kane/Roan/Okafor/Reyes) statt der 5 aktuellen Klassen. Das ist der
Gegenstand des nächsten Bauabschnitts, siehe `prototype-plan.md`. Bis
dahin gilt: **die Dokumente hier sind die Zielvorgabe, der Code ist der
Ausgangspunkt, nicht die Wahrheit über den aktuellen Design-Stand.**

## Offene Design-Fragen, die noch eine Antwort brauchen

- Vorname des Kommandanten (`crew.md`).
- Overwatch-Reaktionsschuss-Malus im neuen Würfelsystem – gibt es einen,
  und wenn ja, wie groß (`prototype-plan.md`, Arbeitsprinzip 3)?
- Diverse Zahlenwerte (Cooldowns, Trait-Boni, Kommando-Punkt-Ökonomie,
  Wundstufen/Ausfalltage) – bewusst als Phase-2/3/4-Playtesting-Arbeit
  offengelassen, siehe die jeweiligen „Noch offen"-Abschnitte.
