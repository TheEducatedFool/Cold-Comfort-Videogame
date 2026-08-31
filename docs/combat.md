# COLD COMFORT – Sichtlinie & Deckungserkennung (Referenz)

> Geometrische Regeln, wie sie im Code stehen (`grid.gd`/`combat.gd`).
> **Bleiben unverändert** durch den Umbau auf das Würfelpool-System
> (`dice-system.md`) – nur WIE viele Bonuswürfel Deckung/Höhe geben,
> hat sich geändert, nicht WIE Sichtlinie/Deckung geometrisch erkannt
> werden. Aktuelle Kampfmechanik (Trefferauflösung, Schaden): siehe
> `dice-system.md` und `traits.md`. Technische Debugging-Schritte:
> siehe `tech-reference.md`.

## Sichtlinie (Line of Sight)

- Nur **hohe Hindernisse (≥ 2 m, „Wände")** blockieren die Sicht.
  Kisten (1 m) geben Deckung, blockieren aber nie die Sicht.
- Geprüft werden **drei Strahlen** von Feldmitte zu Feldmitte: die
  Mittellinie plus zwei um 0,4 Felder seitlich versetzte Linien
  („um die Kante lehnen"). **Ein freier Strahl genügt.** Das verhindert,
  dass Wandkanten optisch freie Schüsse blockieren.
- Sichtlinie ist symmetrisch: sieht A das Feld von B, gilt auch das
  Umgekehrte.
- **Im Spiel prüfbar: Taste L** schaltet das Sichtlinien-Raster der
  ausgewählten Einheit ein – cyan = sichtbar & in Waffenreichweite,
  blassblau = sichtbar, aber außer Reichweite, rot = keine Sichtlinie.
- Regressionstests: `tests/test_los3.gd`, `tests/test_combat.gd`.

## Deckung – geometrische Erkennung

- Geprüft werden die 4 orthogonalen Nachbarfelder des **Ziels**. Ein
  Hindernis dort zählt als Deckung, wenn es grob **in Richtung des
  Schützen** liegt (Skalarprodukt Richtung·Hindernis > 0,3 – deckt auch
  schräge Schusswinkel ab).
- Niedriges Hindernis (Kiste, 1 m): **leichte Deckung**.
  Hohes Hindernis (Wand, ≥ 2 m): **volle Deckung**.
- Kein passendes Hindernis: **FLANKIERT** – kein Deckungsbonus für das Ziel.
- Deckung gilt nicht im Nahkampf.
- Wie viele Bonuswürfel diese drei Stufen dem Angreifer geben (0/1/2):
  siehe `dice-system.md` Abschnitt „Basis-Pool & Deckung".

## Höhe/Verticality

Geometrisches Höhenmodell (Feldgrößen-Einheiten, Klettern kostet
Bewegungspunkte 1:1) und wie Höhe mit Deckung zusammenwirkt: siehe
`dice-system.md` Abschnitt „Verticality".
