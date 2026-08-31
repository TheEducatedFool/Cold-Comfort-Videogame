# COLD COMFORT – Meilensteinplan: Würfelpool-Prototyp

> Konkretisiert `roadmap.md` Phase 2 (Design ✅ abgeschlossen) und den
> Anfang von Phase 3 für die anstehenden Claude-Code-Sessions. Ziel:
> den lauffähigen Prototyp (aktuell noch Prozent-Trefferchance, 4 alte
> Charaktere) Schritt für Schritt auf das in `dice-system.md`/`traits.md`
> beschriebene Würfelpool-System und die 5 aktuellen Klassen
> (`classes.md`/`skills.md`) umstellen – ohne dass das Spiel zwischen
> den Meilensteinen längere Zeit unspielbar/ungetestet ist.
>
> Fertige Prompts zum Kopieren für jeden Meilenstein: `code-session-prompts.md`.
> Technischer Rahmen (Codebase-Konventionen, Debugging): `tech-reference.md`.

## Arbeitsprinzipien für alle Meilensteine

1. **Kleine, spielbare Schritte.** Nach jedem Meilenstein: Godot startet
   fehlerfrei, `test_fuzz.gd` läuft grün, Kamil kann kurz probespielen.
2. **Numerische Lücken pragmatisch füllen.** Wo ein Wert in den Docs als
   „offen"/„Diskussionsgrundlage" markiert ist (Cooldowns, KP-Ökonomie,
   Trait-Zahlen), einen plausiblen Platzhalter setzen und im Code/Commit
   klar als `# TODO Balancing` markieren – nicht bei jedem Einzelwert
   nachfragen. Design-Entscheidungen (neue Mechaniken, Regeländerungen)
   dagegen: notieren und an eine Design-Session zurückgeben, nicht selbst
   entscheiden (siehe `tech-reference.md`, Modell-Rollenteilung).
3. **Ein bekannter Design-Lücke vorab klären:** Das alte System hatte
   einen **Overwatch-Reaktionsschuss-Malus (−20 %)**. `dice-system.md`
   erwähnt für Overwatch aktuell keinen Würfelpool-Äquivalent-Malus.
   **Bevor Meilenstein 4 (Overwatch) umgesetzt wird, mit Kamil klären:**
   bekommt ein Reaktionsschuss einen Bonuswürfel-Abzug (z. B. −1), oder
   entfällt der Malus im neuen System bewusst? Bis geklärt: als
   `# TODO Design-Entscheidung` ohne Malus implementieren (einfachster
   Default), NICHT eigenmächtig einen Malus-Wert erfinden.
4. **Commits nach jedem Meilenstein**, falls Kamil sich für ein
   Git-Repo entscheidet (offene Frage aus `roadmap.md` Phase 1) – sonst
   zumindest ein klar benannter Godot-Speicherpunkt/Backup der
   `scripts/`-Dateien.

---

## M0 – Baseline sichern & Docs einspielen

**Zweck:** Sauberer, überprüfbarer Ausgangspunkt, bevor Kampfmathe
angefasst wird.

- Bereinigten `docs/`-Ordner (dieses Set) auf dem PC ablegen, alte
  `*-draft.md`-Dateien und `handover.md` entfernen/durch die neuen
  Dateien ersetzen (siehe `README.md` für die vollständige Liste).
- Bestehenden Prototyp einmal headless durchlaufen lassen
  (`tests/test_fuzz.gd`) und Ergebnis festhalten – das ist die
  Vergleichsbasis, um spätere Regressionen zu erkennen.
- Falls gewünscht: Git-Repository initialisieren, erster Commit als
  „Stand vor Würfelpool-Umbau".

**Fertig, wenn:** Godot startet fehlerfrei, Fuzz-Test grün, Ausgangsstand
gesichert.

---

## M1 – Würfelpool-Kernmathematik (reine Logik, ohne UI)

**Zweck:** Die eigentliche Würfelmechanik als testbare, von der
Darstellung getrennte Funktionsbibliothek bauen – Grundlage für alles
Weitere.

**Umfang** (`dice-system.md` Abschnitte 1, 4, 5, 6):

- Pool-Wurf: N d10, unterboten gegen einen Zielwert, natürliche 10 =
  automatischer Fehlschlag pro Würfel.
  Cold Comfort ist ein Hobby-Projekt ohne Zeitdruck: bei Unklarheiten
  hier ruhig kurze Testfälle von Hand nachrechnen, bevor der Code steht.
- Explodierende Kritische Treffer (Wurf = 1 → zusätzlicher Würfel,
  unbegrenzte Kaskade), für Angriffs- UND Verteidigungswürfe.
- Netto-Erfolge = max(0, Treffer − Rettungen).
- Schadenskette: effektives Schild (Schild − SD) → effektive Panzerung
  (Panzerung − AP) → Schaden → + Lethal einmalig, falls Schaden ≥ 1.
- Erweiterte Krit-Schwelle als Parameter (Standard 1, per Upgrade/Skill
  auf 1–2 erweiterbar).

**Tests:** `tests/test_dice_pool.gd` (neu) mit Fällen für: normaler Pool,
Krit-Kaskade, natürliche 10 inmitten eines Pools, volle Schadenskette
mit AP/SD/Lethal, Netto-Erfolge = 0 (kompletter Fehlschlag).

**Fertig, wenn:** Alle neuen Unit-Tests grün, Funktionen sind pure
Statics in `combat.gd` (kein Godot-Node-Zugriff nötig) – noch nicht ans
Spiel angebunden.

---

## M2 – Einheiten- & Waffenprofil-Umbau

**Zweck:** `unit.gd` und die Waffen-Resource auf die neuen Datenfelder
umstellen.

**Umfang** (`dice-system.md` Abschnitt 1, `traits.md` Abschnitt 0):

- `unit.gd`: `base_aim`/`falloff` ersetzen durch drei getrennte Werte
  Fernkampf, Nahkampf, Verteidigung (1–10) plus HP und Panzerung.
- Neue Waffen-Resource mit Feldern `range`, `ap`, `sd`, `lethal`,
  `traits` (Array von Trait-IDs, zunächst leer/Platzhalter – volle
  Trait-Wirkungen kommen in M6).
- Die 5 aktuellen Klassen (`classes.md` Abschnitt 8.5) als neue
  Platzhalter-Einheiten anlegen, dabei die 4 alten Story-Charaktere
  (Kane/Roan/Okafor/Reyes) aus dem spielbaren Roster entfernen (bleiben
  nur als Doku-Referenz, siehe `archive/crew-legacy-characters.md`).
- Je Klasse eine einfache Startwaffe mit plausiblem Profil aus
  `traits.md` Abschnitt 0.2 zuordnen (keine Traits nötig, reine
  Zahlenwerte reichen fürs Erste).
- Swarm-Gegner (Drohne, Spitter): neue Dice-Pool-taugliche Werte
  festlegen (aktuell nicht in den Docs vorgegeben – naheliegende
  Übersetzung: ähnliche Rolle wie bisher, Werte grob an Handler-Niveau
  bzw. niedriger orientieren, als `# TODO Balancing` markieren).

**Fertig, wenn:** Neue Einheiten-Datensätze existieren und lassen sich
im Editor/Debugger inspizieren; alte `aim`/`falloff`-Felder sind aus
`unit.gd` entfernt (keine toten Felder).

---

## M3 – Fernkampf-Auflösung & Deckung anbinden

**Zweck:** Den ersten tatsächlich spielbaren Schuss mit dem neuen System.

**Umfang** (`dice-system.md` Abschnitt 2, 6; `combat.md` bleibt
unverändert für Deckungs-/Sichtlinien-Erkennung):

- Bestehende Deckungserkennung (`grid.gd`/`combat.gd`, geometrisch
  unverändert) mit dem neuen Bonuswürfel-Schema verbinden: keine Deckung
  +2, leichte Deckung +1, volle Deckung +0 (Basis-Pool 3).
- Schadenskette aus M1 an einen tatsächlichen Schuss anbinden:
  Angriffswurf → Verteidigungswurf des Ziels (3 Würfel) → Netto-Erfolge
  → Schild/Panzerung/HP.
- **UI-Konzept nötig:** Die alte Prozent-Anzeige („54 % Trefferchance")
  entfällt ersatzlos – braucht eine neue Darstellung (z. B. Anzahl
  Würfel im Pool des Schützen vor dem Schuss, plus Würfelergebnisse
  nach dem Schuss). Naheliegender einfacher erster Wurf: Pool-Größe
  anzeigen („5 Würfel") statt einer Erfolgswahrscheinlichkeit –
  Feinschliff später.
- `tests/test_combat.gd` auf das neue Modell umschreiben.

**Fertig, wenn:** Ein Fernkampf-Schuss im Spiel läuft komplett über das
Würfelpool-System, inklusive Deckung, sichtbar im Log/UI, Fuzz-Test grün.

---

## M4 – Nahkampf: Charge, Zone of Control, Flanking

**Zweck:** Nahkampf auf denselben Basis-Pool umstellen und die neuen
räumlichen Mechaniken einbauen.

**Umfang** (`dice-system.md` Abschnitt 3):

- Locked-In-Zustand: rein räumlich, jede Runde aus der aktuellen
  Position abgeleitet (kein gespeicherter Zustand nötig).
- ZoC-Gegenangriff beim Verlassen einer gegnerischen Zone of Control
  (3-Würfel-Basispool, Mehrfach-Gegner-Fall mit +1-Deckel).
- Charge-Bonus (+2) beim aktiven Hineinbewegen, inkl. der
  Zwei-Charges-pro-Aktivierung-Grenze aus `skills.md` („Design-Regeln").
- Flanking-Bonus (+1, fest gedeckelt).
- **Vorher klären (siehe „Overwatch-Malus"-Hinweis oben):** betrifft
  Nahkampf zwar nicht direkt, aber gleiche Vorsicht gilt hier: keine
  neuen Boni erfinden, die in `dice-system.md` nicht stehen.

**Fertig, wenn:** Ein Nahkampfangriff inkl. Charge/Flanking/ZoC-
Gegenangriff im Spiel funktioniert, mit Tests abgesichert.

---

## M5 – Guarded/Engaged-Haltung & Overwatch-Integration

**Zweck:** Die Aktivierungs-Haltungswahl einbauen.

**Umfang** (`dice-system.md` Abschnitt 8):

- Guarded als wählbare Aktivierungs-Option: −2 Bonuswürfel additiv,
  gilt nur Fernkampf, verbietet Schießen & aktives ZoC-Vorrücken,
  erlaubt weiterhin den reaktiven ZoC-Gegenangriff.
- Gegenseitiger Ausschluss mit Overwatch.
- **Vor dieser Umsetzung die offene Overwatch-Malus-Frage (siehe oben,
  Arbeitsprinzip 3) mit Kamil klären**, da beide Mechaniken hier
  zusammentreffen.

**Fertig, wenn:** Eine Einheit kann pro Aktivierung zwischen normalem
Handeln, Overwatch und Guarded wählen, alle drei sichtbar im UI.

---

## M6 – Statuseffekte: Pinned, Overheat, Shaken

**Zweck:** Die Debuff-Mechaniken einbauen, die mehrere Klassen-Skills
voraussetzen.

**Umfang** (`traits.md` Abschnitt 2, Cluster 5/6):

- Pinned: +1 Bonuswürfel für Nahkampf gegen das Ziel, erzwungene
  „Aufstehen"-Aktion zu Beginn der nächsten Aktivierung.
- Overheat: Zusatzwurf nach Schuss, 9–10 = Waffe nächste Aktivierung
  gesperrt.
- Shaken: Platzhalter-Implementierung (wird erst von Reivers „Harrow"
  gebraucht, kann als generischer Status-Baustein vorgezogen werden).

**Fertig, wenn:** Mindestens eine Waffe/Quelle pro Statuseffekt diesen
im Spiel auslösen kann, sichtbar als Status-Icon o. Ä.

---

## M7 – 5 Klassen mit Grundfähigkeit

**Zweck:** Das alte 4-Charaktere-Roster final durch die 5 aktuellen
Klassen ersetzen, jede mit ihrer Grundfähigkeit aus `skills.md` (noch
ohne die vollen Skill-Bäume – die sind Phase-3/7-Inhalt für spätere
Sessions).

**Umfang:** Breacher (Full Contact), Deadeye (Steady Aim), Handler
(Patch Up), Heavy (Dug In), Reiver (Silent Step) – je auf Tasten 1/2
wie bisher, plus Bewegung/Schießen/Nahkampf über die neuen Mechaniken.

**Fertig, wenn:** Ein Trupp aus den 5 neuen Klassen (statt der alten 4)
gegen die Swarm-Gegner spielbar ist, inkl. je einer Grundfähigkeit.

---

## M8 – Regression, Balancing-Pass, Playtest

**Zweck:** Absichern und erste Zahlen anhand von echtem Spielgefühl
justieren.

- Mehrere `test_fuzz.gd`-Läufe.
- Kamil spielt mehrere Gefechte, sammelt Eindrücke zu: Würfelmengen
  („fühlt sich 5 vs. 3 Würfel richtig an?"), Guarded-Nützlichkeit,
  Charge-Aggressivität, Pinned-Häufigkeit.
- Auffällige `# TODO Balancing`-Marker aus M1–M7 anhand des Playtests
  mit konkreten Werten füllen.

**Fertig, wenn:** Kamil ist mit dem Spielgefühl des neuen Kampfsystems
grundsätzlich zufrieden – danach geht es weiter mit `roadmap.md` Phase 3
(volle Skill-Bäume, Gegner-KI, weitere Klassen-Inhalte).

---

## Übersicht

```
M0  Baseline sichern & Docs einspielen
M1  Würfelpool-Kernmathematik (reine Logik)
M2  Einheiten- & Waffenprofil-Umbau
M3  Fernkampf-Auflösung & Deckung anbinden      ← erster spielbarer Meilenstein
M4  Nahkampf: Charge, Zone of Control, Flanking
M5  Guarded/Engaged-Haltung & Overwatch
M6  Statuseffekte: Pinned, Overheat, Shaken
M7  5 Klassen mit Grundfähigkeit
M8  Regression, Balancing-Pass, Playtest
```

M0–M3 sind ein realistischer Umfang für den morgigen Sessionstart.
M4–M8 folgen in weiteren Sessions, jeweils mit eigenem Prompt in
`code-session-prompts.md`.
