# COLD COMFORT – Fertige Prompts für Claude-Code-Sessions

> Zum Kopieren in den Claude-Code-Chat (Desktop-App, Code-Tab, lokal im
> Projektordner). Jeder Prompt ist als eigenständige erste Nachricht
> einer neuen Session gedacht – Claude Code startet ohne Erinnerung an
> frühere Sessions. Reihenfolge folgt `prototype-plan.md`.

---

## Prompt 0 – Einmalig: Projekt-Setup

```
Wir bauen Cold Comfort, ein rundenbasiertes Taktikspiel in Godot 4
(GDScript). Ich habe keine Coding-Erfahrung – erkläre Schritte kurz und
verständlich, bevor du sie ausführst, und teste alles selbst, bevor du
mir sagst, dass etwas fertig ist.

Lies zuerst diese Dokumente im docs/-Ordner, in dieser Reihenfolge:
1. README.md (Übersicht, was wo steht)
2. tech-reference.md (wo der Code liegt, Konventionen, wie getestet wird)
3. gdd.md (Spielkonzept im Überblick)
4. prototype-plan.md (der Meilensteinplan, an dem wir gerade arbeiten)

Lies NICHT den archive/-Unterordner – das ist rein historisches
Material, für die Arbeit nicht relevant.

Danach: lege eine CLAUDE.md im Projekt-Root an, die kurz zusammenfasst,
wo die Design-Dokumente liegen (docs/), wo der Code liegt (game/), und
die wichtigsten Konventionen aus tech-reference.md – damit jede
zukünftige Session das automatisch mitbekommt.

Bestätige danach kurz, dass du den aktuellen Spielstand verstanden hast
(alter Prototyp mit Prozent-Trefferchance läuft, soll auf ein
Würfelpool-System umgebaut werden) und wir mit Meilenstein M0 aus
prototype-plan.md beginnen.
```

---

## Prompt 1 – Session „Würfelpool-Fundament" (Meilensteine M0–M3)

```
Wir setzen Cold Comfort auf das in docs/dice-system.md und docs/traits.md
beschriebene Würfelpool-Kampfsystem um. Lies zuerst docs/prototype-plan.md
Abschnitte M0–M3 komplett – das ist unser Arbeitsauftrag für diese
Session, mit genauem Umfang und Fertig-Kriterien pro Meilenstein.

Arbeite die Meilensteine der Reihe nach ab (M0 → M1 → M2 → M3), teste
nach jedem Meilenstein wie in docs/tech-reference.md beschrieben
(Godot --headless --import, relevante Tests, test_fuzz.gd), und
gib mir nach jedem Meilenstein eine kurze Zusammenfassung, bevor du
weitermachst.

Wichtig:
- M1 ist reine Logik ohne UI-Anbindung – erst in M3 wird tatsächlich
  geschossen.
- Wo Zahlen in den Docs als "offen"/"Diskussionsgrundlage" markiert
  sind, setz einen plausiblen Platzhalter und markiere ihn im Code als
  `# TODO Balancing` – frag mich nicht bei jedem einzelnen Wert.
- prototype-plan.md nennt eine echte offene Design-Frage (Overwatch-
  Reaktionsschuss-Malus) – die betrifft diese Session noch nicht direkt
  (kommt erst bei M5), aber wenn du im Weg dorthin etwas findest, das
  nicht in den Docs steht, frag lieber nach statt zu raten.

Wenn du fertig bist: sag mir, was ich jetzt im Spiel ausprobieren kann.
```

---

## Prompt 2 – Session „Nahkampf & Haltung" (Meilensteine M4–M5)

```
Weiter am Würfelpool-Umbau von Cold Comfort. Lies docs/prototype-plan.md
Meilensteine M4 und M5, sowie docs/dice-system.md Abschnitte 3 und 8 für
die Details (Charge, Zone of Control, Flanking, Guarded/Engaged).

Bevor du M5 beginnst: docs/prototype-plan.md nennt eine offene
Design-Frage zum Overwatch-Reaktionsschuss-Malus im neuen System (das
alte System hatte -20%, das neue Würfelsystem sagt dazu nichts). Frag
mich das direkt, bevor du Overwatch/Guarded verdrahtest – rate nicht.

Arbeite M4 dann M5 ab, teste nach jedem Meilenstein (siehe
docs/tech-reference.md), fass kurz zusammen, was fertig ist.
```

---

## Prompt 3 – Session „Status-Effekte & neue Klassen" (Meilensteine M6–M7)

```
Weiter am Würfelpool-Umbau von Cold Comfort. Lies docs/prototype-plan.md
Meilensteine M6 und M7.

M6: Pinned, Overheat und Shaken einbauen (Details: docs/traits.md
Abschnitt 2 und Cluster 5/6).

M7: Das alte Vier-Charaktere-Roster (Kane/Roan/Okafor/Reyes) endgültig
durch die 5 aktuellen Klassen ersetzen (Breacher, Deadeye, Handler,
Heavy, Reiver – siehe docs/classes.md und docs/skills.md), jede mit
ihrer Grundfähigkeit aus docs/skills.md. Volle Skill-Bäume sind NICHT
Teil dieser Session (das ist späterer Content, siehe roadmap.md Phase 3/7).

Teste nach jedem Meilenstein, fass kurz zusammen.
```

---

## Prompt 4 – Session „Balancing-Pass & Playtest" (Meilenstein M8)

```
Cold Comfort läuft jetzt komplett auf dem neuen Würfelpool-System mit
den 5 aktuellen Klassen. Lies docs/prototype-plan.md Meilenstein M8.

Führe mehrere test_fuzz.gd-Läufe durch und melde Auffälligkeiten. Danach
spiele ich selbst ein paar Gefechte und gebe dir Feedback zu Würfelmengen,
Guarded-Nützlichkeit, Charge-Aggressivität und Pinned-Häufigkeit – sammle
das, und schlage konkrete Werte für die `# TODO Balancing`-Marker vor,
die wir in den vorherigen Sessions gesetzt haben (durchsuch dafür
scripts/ nach `TODO Balancing`).
```

---

## Hinweis für Design-Rückfragen während des Codens

Wenn eine Claude-Code-Session auf eine echte, nicht in den Docs
festgelegte Design-Entscheidung stößt (nicht nur einen fehlenden
Zahlenwert), soll sie das notieren und dich fragen – nicht selbst
entscheiden. Antworten auf solche Fragen anschließend in einer
Cowork/Projektwissen-Session festhalten, damit sie beim nächsten
`docs/`-Sync erhalten bleiben (siehe `tech-reference.md`, Modell-
Rollenteilung).
