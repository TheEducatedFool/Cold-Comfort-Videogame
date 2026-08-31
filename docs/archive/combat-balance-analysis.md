# COLD COMFORT – Trefferchance & Schadens-Analyse der Klassen-Basiswerte (2026-08-29)

> Exakte Wahrscheinlichkeitsrechnung (keine Monte-Carlo-Simulation) auf
> Basis der Basiswerte-Tabelle aus `classes-draft.md` Abschnitt 8.4.
> **Ohne** Waffen-/Ausrüstungs-Modifikatoren, ohne Deckung, ohne Schild
> (Schild ist kein Klassen-Basiswert, kommt nur über Ausrüstung/
> Upgrades) – reiner Basiswert-gegen-Basiswert-Vergleich.
>
> **Update 2026-08-29: 2. Fassung nach Klassenkürzung.** Diese
> Erst-Analyse (unten, 9 Klassen inkl. Warden/Sergeant/Grenadier/Medic)
> ist durch Kamils Entscheidung überholt: Warden gestrichen, Rigger+
> Sergeant sowie Heavy+Grenadier zusammengelegt → 5 finale Klassen.
> Die aktualisierten Tabellen dafür stehen in Abschnitt „2. Fassung"
> **ganz unten** in diesem Dokument. Die Erst-Analyse bleibt als
> Beleg für die Merge-Entscheidung (siehe „Beobachtungen") stehen.

## Methodik (1. Fassung, 9 Klassen – historisch)

- Angriffs-Pool: 5 Würfel gegen den Fernkampf- bzw. Nahkampf-Wert des
  Angreifers. Verteidigungs-Pool: 3 Würfel gegen den
  Verteidigungs-Wert des Ziels („unterboten"-Prinzip: Wurf ≤ Wert =
  Erfolg).
- Natürliche 1 = Erfolg + kaskadierende Explosion (unbegrenzt, exakt
  berechnet über die geometrische Reihe der Kaskaden-Wahrscheinlichkeit,
  nicht simuliert). Natürliche 10 = automatischer Fehlschlag für diesen
  einen Würfel, unabhängig vom Wert.
- **Netto-Erfolge** = max(0, Treffer − Rettungen). **Trefferchance** in
  den Tabellen unten = Wahrscheinlichkeit, dass Netto-Erfolge > 0 sind
  (der Angriff also überhaupt etwas durch die Verteidigung bringt,
  noch vor Panzerung).
- **Erwarteter Schaden** = Netto-Erfolge abzüglich des Panzerungswerts
  des Ziels (Panzerung storniert Netto-Erfolge 1:1, kein Schild
  eingerechnet), im Erwartungswert über alle Würfelausgänge.
- Alle Werte exakt berechnet (Kaskaden-Trunkierung bei 40 Ebenen,
  Restfehler < 1e-30 – praktisch exakt).

## Fernkampf: Trefferchance (Angreifer-Zeile vs. Ziel-Spalte)

| Angreifer \ Ziel | Breacher | Deadeye | Warden | Rigger | Heavy | Reiver | Sergeant | Grenadier | Medic |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Breacher (Fk6) | 91.8% | 75.5% | 91.8% | 61.4% | 87.1% | 75.5% | 53.5% | 87.1% | 61.4% |
| Deadeye (Fk9) | 99.6% | 97.1% | 99.6% | 93.7% | 99.0% | 97.1% | 91.4% | 99.0% | 93.7% |
| Warden (Fk2) | 46.1% | 22.5% | 46.1% | 11.7% | 37.2% | 22.5% | 7.6% | 37.2% | 11.7% |
| Rigger (Fk5) | 85.3% | 63.8% | 85.3% | 47.7% | 78.6% | 63.8% | 39.4% | 78.6% | 47.7% |
| Heavy (Fk8) | 98.4% | 92.4% | 98.4% | 85.3% | 97.0% | 92.4% | 80.7% | 97.0% | 85.3% |
| Reiver (Fk5) | 85.3% | 63.8% | 85.3% | 47.7% | 78.6% | 63.8% | 39.4% | 78.6% | 47.7% |
| Sergeant (Fk4) | 75.8% | 50.5% | 75.8% | 34.2% | 67.3% | 50.5% | 26.6% | 67.3% | 34.2% |
| Grenadier (Fk7) | 96.0% | 85.1% | 96.0% | 74.2% | 93.1% | 85.1% | 67.6% | 93.1% | 74.2% |
| Medic (Fk4) | 75.8% | 50.5% | 75.8% | 34.2% | 67.3% | 50.5% | 26.6% | 67.3% | 34.2% |

## Fernkampf: erwarteter Schaden pro Angriff (nach Panzerung)

| Angreifer \ Ziel | Breacher | Deadeye | Warden | Rigger | Heavy | Reiver | Sergeant | Grenadier | Medic |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Breacher | 1.78 | 1.05 | 1.00 | 0.66 | 1.52 | 1.81 | 0.49 | 0.82 | 0.66 |
| Deadeye | 3.34 | 2.37 | 2.36 | 1.75 | 3.01 | 3.34 | 1.45 | 2.05 | 1.75 |
| Warden | 0.28 | 0.11 | 0.08 | 0.05 | 0.21 | 0.34 | 0.03 | 0.06 | 0.05 |
| Rigger | 1.32 | 0.72 | 0.66 | 0.42 | 1.10 | 1.36 | 0.30 | 0.53 | 0.42 |
| Heavy | 2.80 | 1.88 | 1.86 | 1.32 | 2.48 | 2.81 | 1.05 | 1.58 | 1.32 |
| Reiver | 1.32 | 0.72 | 0.66 | 0.42 | 1.10 | 1.36 | 0.30 | 0.53 | 0.42 |
| Sergeant | 0.90 | 0.46 | 0.40 | 0.25 | 0.74 | 0.96 | 0.17 | 0.31 | 0.25 |
| Grenadier | 2.27 | 1.44 | 1.40 | 0.95 | 1.98 | 2.29 | 0.74 | 1.17 | 0.95 |
| Medic | 0.90 | 0.46 | 0.40 | 0.25 | 0.74 | 0.96 | 0.17 | 0.31 | 0.25 |

## Nahkampf: Trefferchance (Angreifer-Zeile vs. Ziel-Spalte)

| Angreifer \ Ziel | Breacher | Deadeye | Warden | Rigger | Heavy | Reiver | Sergeant | Grenadier | Medic |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Breacher (Nk7) | 96.0% | 85.1% | 96.0% | 74.2% | 93.1% | 85.1% | 67.6% | 93.1% | 74.2% |
| Deadeye (Nk3) | 62.9% | 36.4% | 62.9% | 21.9% | 53.5% | 36.4% | 15.8% | 53.5% | 21.9% |
| Warden (Nk7) | 96.0% | 85.1% | 96.0% | 74.2% | 93.1% | 85.1% | 67.6% | 93.1% | 74.2% |
| Rigger (Nk3) | 62.9% | 36.4% | 62.9% | 21.9% | 53.5% | 36.4% | 15.8% | 53.5% | 21.9% |
| Heavy (Nk3) | 62.9% | 36.4% | 62.9% | 21.9% | 53.5% | 36.4% | 15.8% | 53.5% | 21.9% |
| Reiver (Nk9) | 99.6% | 97.1% | 99.6% | 93.7% | 99.0% | 97.1% | 91.4% | 99.0% | 93.7% |
| Sergeant (Nk4) | 75.8% | 50.5% | 75.8% | 34.2% | 67.3% | 50.5% | 26.6% | 67.3% | 34.2% |
| Grenadier (Nk3) | 62.9% | 36.4% | 62.9% | 21.9% | 53.5% | 36.4% | 15.8% | 53.5% | 21.9% |
| Medic (Nk3) | 62.9% | 36.4% | 62.9% | 21.9% | 53.5% | 36.4% | 15.8% | 53.5% | 21.9% |

## Nahkampf: erwarteter Schaden pro Angriff (nach Panzerung)

| Angreifer \ Ziel | Breacher | Deadeye | Warden | Rigger | Heavy | Reiver | Sergeant | Grenadier | Medic |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Breacher | 2.27 | 1.44 | 1.40 | 0.95 | 1.98 | 2.29 | 0.74 | 1.17 | 0.95 |
| Deadeye | 0.55 | 0.25 | 0.21 | 0.13 | 0.44 | 0.62 | 0.08 | 0.16 | 0.13 |
| Warden | 2.27 | 1.44 | 1.40 | 0.95 | 1.98 | 2.29 | 0.74 | 1.17 | 0.95 |
| Rigger | 0.55 | 0.25 | 0.21 | 0.13 | 0.44 | 0.62 | 0.08 | 0.16 | 0.13 |
| Heavy | 0.55 | 0.25 | 0.21 | 0.13 | 0.44 | 0.62 | 0.08 | 0.16 | 0.13 |
| Reiver | 3.34 | 2.37 | 2.36 | 1.75 | 3.01 | 3.34 | 1.45 | 2.05 | 1.75 |
| Sergeant | 0.90 | 0.46 | 0.40 | 0.25 | 0.74 | 0.96 | 0.17 | 0.31 | 0.25 |
| Grenadier | 0.55 | 0.25 | 0.21 | 0.13 | 0.44 | 0.62 | 0.08 | 0.16 | 0.13 |
| Medic | 0.55 | 0.25 | 0.21 | 0.13 | 0.44 | 0.62 | 0.08 | 0.16 | 0.13 |

## Beobachtungen

- **Warden im Fernkampf ist praktisch wehrlos** (Fk2): selbst gegen ein
  ungepanzertes Ziel wie Reiver nur 22,5% Trefferchance, 0,34
  Schadenspunkte im Schnitt. Das ist beabsichtigt (Warden ist als
  Nahkampf-Tank gedacht), aber der Abstand ist extrem – im aktuellen
  Zahlenraum kann ein Warden im Fernkampfgefecht fast nichts beitragen.
- **Deadeye dominiert den Fernkampf fast unabhängig vom Ziel** (Fk9):
  91–99% Trefferchance gegen jede Klasse, auch gegen die
  bestverteidigten (Sergeant Vt8 immer noch 91,4%). Das Verteidigungs-
  Attribut hat gegen einen Fk9-Angreifer kaum noch Einfluss, weil die
  Explosions-Kaskade bei so hohen Werten sehr viele Erfolge erzeugt.
- **Spiegelbildlich im Nahkampf:** Reiver (Nk9) trifft praktisch immer
  (91–99,6%) und verursacht mit Abstand den höchsten Schaden (bis 3,34),
  während Deadeye/Rigger/Heavy/Grenadier/Medic (alle Nk3) im Nahkampf
  fast identisch schwach sind (15,8–62,9%, 0,08–0,62 Schaden) – die
  Nahkampf-Schwäche der reinen Fernkampf-/Support-Klassen ist spürbar
  einheitlich, was das Design-Ziel „im Nahkampf verwundbar" gut trifft.
- **Sergeant/Recon (Vt8) ist der mit Abstand härteste Verteidiger**
  gegen praktisch jeden Angreifer – z. B. auch gegen Deadeye/Heavy im
  Fernkampf spürbar seltener getroffen als jede andere Klasse. Das
  passt zur Enabler-Rolle aus der zweiten Reihe.
- **❌ KORREKTUR (2026-08-29): „Panzerung wirkt kaum spürbar" war
  falsch – siehe „Korrektur: Panzerung ist ein starker Hebel" ganz
  unten im Dokument.** Ursprünglich stand hier die (fehlerhafte)
  Einschätzung, Panzerung falle gegenüber den erwarteten Netto-
  Erfolgen kaum ins Gewicht. Kamils Rückfrage hat gezeigt: genau das
  Gegenteil ist der Fall – weil die erwarteten Netto-Erfolge in den
  meisten Matchups selbst nur 1–3 betragen, storniert schon 1
  Panzerungspunkt oft 30–50% des erwarteten Schadens, 2 Punkte
  50–80%. Details und Herleitung des Fehlers siehe unten.
- **Fernkampf ist über fast das ganze Feld hinweg treffsicherer als
  Nahkampf** bei vergleichbaren Werten (z. B. Fk6-Breacher vs. Nk7-
  Warden/Breacher: Fernkampf-Trefferwerte liegen im Schnitt etwas über
  den entsprechenden Nahkampf-Werten) – das liegt aber schlicht daran,
  dass die Fernkampf-Werte im Datensatz im Schnitt etwas höher verteilt
  sind als die Nahkampf-Werte, nicht an einem Mechanik-Unterschied
  zwischen den beiden Angriffsarten (beide nutzen exakt dieselbe
  Würfelformel).

---

## 2. Fassung (2026-08-29): finale 5 Klassen nach Kürzung

Gleiche Methodik wie oben, jetzt mit dem finalen Roster: Breacher,
Deadeye, Reiver/Incursor, Rigger (Tech+Kommando), Heavy
(Dauerfeuer+Sprengstoff). Basiswerte siehe `classes-draft.md`
Abschnitt 8.4 (aktualisiert).

### Fernkampf: Trefferchance

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher (Fk6) | 91.8% | 75.5% | 75.5% | 61.4% | 87.1% |
| Deadeye (Fk9) | 99.6% | 97.1% | 97.1% | 93.7% | 99.0% |
| Reiver (Fk5) | 85.3% | 63.8% | 63.8% | 47.7% | 78.6% |
| Rigger (Fk4) | 75.8% | 50.5% | 50.5% | 34.2% | 67.3% |
| Heavy (Fk7) | 96.0% | 85.1% | 85.1% | 74.2% | 93.1% |

### Fernkampf: erwarteter Schaden (nach Panzerung)

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher | 1.78 | 1.05 | 1.81 | 0.66 | 0.82 |
| Deadeye | 3.34 | 2.37 | 3.34 | 1.75 | 2.05 |
| Reiver | 1.32 | 0.72 | 1.36 | 0.42 | 0.53 |
| Rigger | 0.90 | 0.46 | 0.96 | 0.25 | 0.31 |
| Heavy | 2.27 | 1.44 | 2.29 | 0.95 | 1.17 |

### Nahkampf: Trefferchance

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher (Nk7) | 96.0% | 85.1% | 85.1% | 74.2% | 93.1% |
| Deadeye (Nk3) | 62.9% | 36.4% | 36.4% | 21.9% | 53.5% |
| Reiver (Nk9) | 99.6% | 97.1% | 97.1% | 93.7% | 99.0% |
| Rigger (Nk4) | 75.8% | 50.5% | 50.5% | 34.2% | 67.3% |
| Heavy (Nk3) | 62.9% | 36.4% | 36.4% | 21.9% | 53.5% |

### Nahkampf: erwarteter Schaden (nach Panzerung)

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher | 2.27 | 1.44 | 2.29 | 0.95 | 1.17 |
| Deadeye | 0.55 | 0.25 | 0.62 | 0.13 | 0.16 |
| Reiver | 3.34 | 2.37 | 3.34 | 1.75 | 2.05 |
| Rigger | 0.90 | 0.46 | 0.96 | 0.25 | 0.31 |
| Heavy | 0.55 | 0.25 | 0.62 | 0.13 | 0.16 |

### Beobachtungen (2. Fassung)

- **Extremwert Warden ist weg** – die neue Matrix hat keinen
  Ausreißer mehr nach unten. Rigger (Fk4/Nk4) ist jetzt die
  schwächste Angriffsklasse in beiden Disziplinen, aber bei Weitem
  nicht so hilflos wie Warden vorher (z. B. 74,2% Fernkampf-
  Trefferchance gegen Rigger selbst, statt Wardens 7,6% Tiefstwert).
  Das ist beabsichtigt: Rigger soll unterdurchschnittlich angreifen,
  weil seine Stärke in den Fähigkeiten liegt, nicht wehrlos sein.
- **Deadeye bleibt der klare Fernkampf-Dominator** (91–99% gegen
  jedes Ziel) und Reiver der klare Nahkampf-Dominator (93–99,6%) –
  unverändert gegenüber der 1. Fassung, da beide Klassen nicht
  angefasst wurden.
- **Heavy (jetzt mit Grenadier-Fähigkeiten) ist die zweitstärkste
  Fernkampf-Klasse** (74–96%) – das ist plausibel, weil Heavy sowohl
  Fk7 mitbringt als auch thematisch jetzt die komplette
  „Rohschaden-aus-der-Distanz"-Nische abdeckt.
- **Rigger und Heavy sind im Nahkampf nahezu identisch schwach**
  (Nk3–4, 21,9–75,8% je nach Ziel) – beide sind reine Distanz-/
  Support-Rollen, was zur Klassenidentität passt.
- **❌ KORREKTUR: Panzerung ist tatsächlich ein SEHR starker Hebel**,
  keine schwache – siehe „Korrektur: Panzerung ist ein starker Hebel"
  ganz unten im Dokument. Rigger (Pz1) und Heavy (Pz2) profitieren
  davon spürbar mehr, als die erste Einschätzung nahelegte.

---

## Korrektur (2026-08-29): Panzerung ist ein starker Hebel, keine schwache

Kamils berechtigte Rückfrage: „Wenn 2 Netto-Erfolge erzielt werden und
Panzerung 1 davon storniert, halbiert das den Schaden – wie kommst du
auf 'kaum Unterschied'?" **Die Beobachtung oben war schlicht falsch.**
Der Fehler: ich habe die absolute Größe der Panzerungswerte (0–2) mit
den erwarteten Netto-Erfolgen (2–5) verglichen und daraus geschlossen,
1–2 Punkte seien "klein" dagegen – aber das ignoriert, dass Schaden
NICHT proportional zu Netto-Erfolgen sinkt, sondern **um einen festen
Betrag, der bei kleinen Netto-Erfolgs-Werten einen riesigen
prozentualen Anteil ausmacht** (und wegen der `max(0, …)`-Kappung bei
0 nie negativ werden kann). Exakte Rechnung, Verteidiger-Wert fix bei
5, Panzerung isoliert von 0 auf 1/2/3 erhöht:

| Angreifer-Wert | E[Netto-Erfolge, Pz0] | Schaden bei Pz1 (Reduktion) | Schaden bei Pz2 (Reduktion) | Schaden bei Pz3 (Reduktion) |
|---:|---:|---:|---:|---:|
| 4 | 0.96 | 0.46 (−52.6%) | 0.18 (−81.5%) | 0.06 (−94.1%) |
| 5 | 1.36 | 0.72 (−46.9%) | 0.32 (−76.7%) | 0.11 (−91.7%) |
| 6 | 1.81 | 1.05 (−41.8%) | 0.51 (−71.7%) | 0.20 (−88.8%) |
| 7 | 2.29 | 1.44 (−37.2%) | 0.77 (−66.5%) | 0.33 (−85.5%) |
| 8 | 2.81 | 1.88 (−32.9%) | 1.09 (−61.2%) | 0.51 (−81.8%) |
| 9 | 3.34 | 2.37 (−29.1%) | 1.47 (−55.9%) | 0.75 (−77.6%) |

**Fazit: 1 Panzerungspunkt reduziert den erwarteten Schaden um
grob 30–53%, 2 Panzerungspunkte um 56–82%**, je nachdem wie
treffsicher der Angreifer ist (der relative Effekt ist bei schwachen
Angreifern sogar noch größer, weil deren Netto-Erfolge ohnehin schon
niedrig sind und die `max(0,…)`-Kappung öfter komplett zuschlägt –
siehe die Verteilung: bei Angreifer-Wert 4 sind bereits 49,5% aller
Angriffe 0 Netto-Erfolge, ein einzelner Panzerungspunkt schiebt dann
einen Großteil der verbleibenden 1-Erfolg-Fälle ebenfalls auf 0).
**Panzerung ist bei unseren aktuellen Zahlen also kein schwacher,
sondern einer der stärksten Hebel im ganzen System** – das
rechtfertigt im Nachhinein auch nochmal, warum der Umrechnungskurs in
`classes-draft.md` Abschnitt 8.3 Panzerung bereits mit dem doppelten
Budget-Preis (2 statt 1 Einheit pro Punkt) ansetzt; wenn überhaupt,
könnte man argumentieren, dass selbst das noch zu günstig ist. Die
5-Klassen-Tabellen weiter oben in diesem Dokument sind rechnerisch
unverändert korrekt (die Panzerungswerte 0/1/2 sind bereits
eingerechnet) – nur die Interpretation „das macht kaum einen
Unterschied" war der Fehler, nicht die Zahlen selbst.

---

## 3. Fassung (2026-08-29): nach Einführung der ±2-Deckelung

Neue Regel: Fernkampf/Nahkampf/Verteidigung/HP dürfen zu Spielbeginn
höchstens 2 Punkte vom Standardwert 5 abweichen (Bereich 3–7).
Panzerung bleibt außen vor (eigener Standardwert 1, siehe
`classes-draft.md` Abschnitt 8.5). Angepasste Basiswerte:

| Klasse | Fernkampf | Nahkampf | Verteidigung | HP | Panzerung |
|---|---:|---:|---:|---:|---:|
| Breacher | 6 | 7 | 3 | 4 | 1 |
| Deadeye | 7 | 4 | 5 | 4 | 1 |
| Reiver/Incursor | 5 | 7 | 5 | 5 | 0 |
| Rigger | 4 | 4 | 7 | 5 | 1 |
| Heavy | 7 | 3 | 3 | 5 | 2 |

### Fernkampf: Trefferchance

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher (Fk6) | 87.1% | 75.5% | 75.5% | 61.4% | 87.1% |
| Deadeye (Fk7) | 93.1% | 85.1% | 85.1% | 74.2% | 93.1% |
| Reiver (Fk5) | 78.6% | 63.8% | 63.8% | 47.7% | 78.6% |
| Rigger (Fk4) | 67.3% | 50.5% | 50.5% | 34.2% | 67.3% |
| Heavy (Fk7) | 93.1% | 85.1% | 85.1% | 74.2% | 93.1% |

### Fernkampf: erwarteter Schaden (nach Panzerung)

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher | 1.52 | 1.05 | 1.81 | 0.66 | 0.82 |
| Deadeye | 1.98 | 1.44 | 2.29 | 0.95 | 1.17 |
| Reiver | 1.10 | 0.72 | 1.36 | 0.42 | 0.53 |
| Rigger | 0.74 | 0.46 | 0.96 | 0.25 | 0.31 |
| Heavy | 1.98 | 1.44 | 2.29 | 0.95 | 1.17 |

### Nahkampf: Trefferchance

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher (Nk7) | 93.1% | 85.1% | 85.1% | 74.2% | 93.1% |
| Deadeye (Nk4) | 67.3% | 50.5% | 50.5% | 34.2% | 67.3% |
| Reiver (Nk7) | 93.1% | 85.1% | 85.1% | 74.2% | 93.1% |
| Rigger (Nk4) | 67.3% | 50.5% | 50.5% | 34.2% | 67.3% |
| Heavy (Nk3) | 53.5% | 36.4% | 36.4% | 21.9% | 53.5% |

### Nahkampf: erwarteter Schaden (nach Panzerung)

| Angreifer \ Ziel | Breacher | Deadeye | Reiver | Rigger | Heavy |
|---|---:|---:|---:|---:|---:|
| Breacher | 1.98 | 1.44 | 2.29 | 0.95 | 1.17 |
| Deadeye | 0.74 | 0.46 | 0.96 | 0.25 | 0.31 |
| Reiver | 1.98 | 1.44 | 2.29 | 0.95 | 1.17 |
| Rigger | 0.74 | 0.46 | 0.96 | 0.25 | 0.31 |
| Heavy | 0.44 | 0.25 | 0.62 | 0.13 | 0.16 |

### Beobachtungen (3. Fassung)

- **Spannweite der Trefferchance über alle 50 Fern-/Nahkampf-Matchups:
  21,9%–93,1%** (2. Fassung ohne Deckel: 15,8%–99,6%). Die Deckelung
  wirkt also spürbar, aber nicht dramatisch – rund 6 Prozentpunkte
  weniger Spanne an beiden Enden zusammen.
- **Die Kompression trifft fast ausschließlich die Spitzenwerte, nicht
  die Talsohle:** Rigger (Fk/Nk je 4, schon vorher nah am Standard)
  ändert sich gar nicht. Deadeye, Reiver und Heavy dagegen (vorher
  Fk/Nk 8–9) verlieren am oberen Ende deutlich: Deadeyes Fernkampf-
  Bestwert fällt von 99,6% auf 93,1%, Reivers Nahkampf-Bestwert
  ebenso von 99,6% auf 93,1%. Logisch, weil die Deckelung strukturell
  nur Extremwerte kappt (Standardwert ± max. 2), Werte nahe am
  Standard aber unangetastet lässt.
- **Deadeye und Heavy sind im Fernkampf jetzt identisch** (beide
  Fk7) – reine Zahlen-Koinzidenz aus der minimal-invasiven Korrektur,
  kein Design-Problem, da sich beide Klassen über Verteidigung/HP/
  Panzerung und vor allem über ihre Fähigkeiten weiterhin klar
  unterscheiden.
- **Fazit:** Die Deckelung glättet das Kampfgefühl spürbar, ohne die
  Klassenidentitäten zu verwischen – Spezialisten bleiben klar besser
  in ihrer Nische, aber die extremsten Automatik-Ergebnisse (91–99,6%
  Trefferchance praktisch unabhängig vom Ziel) verschwinden. Das
  passt gut zum späteren Level-Aufstiegs-System, das genau diesen
  jetzt fehlenden Spitzenbereich als Fortschritts-Belohnung
  freischalten kann.

---

## Externe Kalibrierung: Punktkosten aus Halo Flashpoint (Screenshots, 2026-08-29)

Kamil hat 14 vollständig lesbare Kämpfer-Datenkarten aus dem offiziellen
Halo-Flashpoint-„Fireteam Tool" geliefert (d8-System, Zielzahl „X+" =
Erfolg bei X oder höher, Feldnamen FK=Fernkampf, NK=Nahkampf,
Ü=Überleben/Rettungswurf, BW=Bewegung, R=Rüstung, LP=Lebenspunkte).
Ziel: grob abschätzen, wie viel jeder Wert dort an Punkten kostet, um
daraus Rückschlüsse für unser d10-Budget-System (Abschnitt 8.3) zu
ziehen. **Wichtige Einschränkung vorab (wie von Kamil selbst schon
vermutet): Waffe, Traits und Basiswerte sind in den Kosten
untrennbar vermischt – jede Zahl unten ist eine grobe Schätzung, kein
exaktes Ergebnis.**

### Rohdaten (X+ in Trefferwahrscheinlichkeit auf d8 umgerechnet: P=(9−X)/8)

| Einheit | FK | NK | Ü | R | LP | Traits (zusätzlich zu Energieschild(2)) | Kosten |
|---|---:|---:|---:|---:|---:|---|---:|
| Gungnir/SPNKr | 4+ (62,5%) | 5+ (50%) | 5+ (50%) | 2 | 4 | Gedeckt, Stabil | 47 |
| Hazop/Schrotflinte | 5+ (50%) | 5+ (50%) | 5+ (50%) | 2 | 4 | Fliegen | 36 |
| Hazop/Stachelgewehr | 5+ (50%) | 5+ (50%) | 5+ (50%) | 2 | 4 | Fliegen | 38 |
| Hazop/Nadelgewehr | 5+ (50%) | 5+ (50%) | 5+ (50%) | 2 | 4 | Jetpack | 38 |
| JFO/Erschütterungsgewehr | 5+ (50%) | 5+ (50%) | 5+ (50%) | 3 | 4 | Späher, Taktiker(1) | 45 |
| Deadeye/DMR | 3+ (75%) | 5+ (50%) | 5+ (50%) | 2 | 4 | Schneller Waffenwechsel | 48 |
| Deadeye/Stalker-Gewehr | 3+ (75%) | 5+ (50%) | 5+ (50%) | 2 | 4 | Schneller Waffenwechsel | 46 |
| CQB/Partikelschwert | 5+ (50%) | 4+ (62,5%) | 6+ (37,5%) | 3 | 5 | Bedrohlich | 47 |
| CQB/Gravitationshammer | 5+ (50%) | 4+ (62,5%) | 6+ (37,5%) | 3 | 5 | Bedrohlich | 48 |
| Gungnir/Plasmawerfer | 4+ (62,5%) | 5+ (50%) | 5+ (50%) | 2* | 4* | Gedeckt, Stabil, Taktiker(1) | 45 |
| MK VII/Sturmgewehr | 4+ (62,5%) | 4+ (62,5%) | 5+ (50%) | 2 | 4 | Taktiker(1) | 45 |
| MK VII/Impulskarabiner | 4+ (62,5%) | 4+ (62,5%) | 5+ (50%) | 2 | 4 | Taktiker(1) | 40 |
| Brawler/Bulldog | 5+ (50%) | 3+ (75%) | 5+ (50%) | 2 | 4 | – | 37 |
| Brawler/Nadelwerfer | 5+ (50%) | 3+ (75%) | 5+ (50%) | 2 | 4 | – | 38 |

*(R/LP für Gungnir/Plasmawerfer auf dem Screenshot abgeschnitten, hier
analog zum anderen Gungnir angenommen.)*

### Saubere Paar-Vergleiche (nur Waffe unterschiedlich, Rest identisch)

Diese fünf Paare isolieren den reinen Waffen-Preis, weil Statwerte UND
Traits jeweils exakt gleich sind:

| Chassis | Waffe A → B | Kostendifferenz |
|---|---|---:|
| Hazop | Schrotflinte(36) → Stachelgewehr(38) | +2 |
| Deadeye | Stalker-Gewehr(46) → DMR(48) | +2 |
| CQB | Partikelschwert(47) → Gravitationshammer(48) | +1 |
| MK VII | Impulskarabiner(40) → Sturmgewehr(45) | +5 |
| Brawler | Bulldog(37) → Nadelwerfer(38) | +1 |

**Befund: Waffen kosten in Halo Flashpoint typischerweise nur 1–5
Punkte Unterschied** bei einem Gesamtpreis von 36–48 – also grob
2–12% des Gesamtpreises. Die Waffe ist ein kleiner Modifikator auf
einem viel teureren Chassis (Statwerte + Traits), nicht der
Hauptkostentreiber.

### Grobe Schätzung der Stat-Kosten (Chassis-Vergleiche + Ridge-Regression)

Zwei Chassis unterscheiden sich NUR in Fernkampf (plus einem
Trait-Swap): Deadeye (FK 75%, ⌀47 Pkt., Trait „Schneller
Waffenwechsel") vs. Hazop (FK 50%, ⌀37,3 Pkt., Trait „Fliegen/
Jetpack"). Differenz: **+25 Prozentpunkte FK ≈ +9,7 Punkte** – grob
**4–5 Punkte pro Zielzahl-Schritt (12,5%) Fernkampf**, vorausgesetzt
die beiden Traits sind ähnlich viel wert (unsicher).

Ein zweiter Vergleich, NUR Nahkampf unterschiedlich: Brawler (NK 75%,
⌀37,5 Pkt., kein Zusatz-Trait) vs. Hazop (NK 50%, ⌀37,3 Pkt., Trait
„Fliegen/Jetpack"). Differenz: **+25 Prozentpunkte NK ≈ +0,2 Punkte**
– praktisch nichts, ABER Brawler hat dafür auch kein Bewegungs-Trait,
das Fliegen/Jetpack bei Hazop ja Kosten sollte. Vorsichtige
Interpretation: **Nahkampf-Genauigkeit scheint in Halo Flashpoints
Preisgefüge deutlich billiger zu sein als Fernkampf-Genauigkeit** für
denselben prozentualen Sprung – oder Fliegen/Jetpack sind ungefähr so
viel wert wie +25% Nahkampf, was dieselbe Schlussfolgerung nahelegt.

Zur Absicherung eine Ridge-Regression (leicht regularisiert wegen
weniger Datenpunkte und starker Kollinearität zwischen Traits und
Chassis) über alle 14 Einheiten, Kosten als Funktion von FK/NK/
Ü-Wahrscheinlichkeit, Rüstung, LP und Trait-Dummies:

| Merkmal | geschätzter Punktwert | Einordnung |
|---|---:|---|
| Fernkampf (pro 12,5%-Schritt) | ≈ +4 | passt zur Chassis-Schätzung oben |
| Nahkampf (pro 12,5%-Schritt) | ≈ −3 (!) | unplausibles Vorzeichen – Artefakt der Kollinearität, siehe unten |
| Überleben/Rettung (pro 12,5%-Schritt) | ≈ −1 | ebenfalls unsicher/verrauscht |
| Rüstung (pro +1 Punkt) | ≈ +1,8 | grobe Untergrenze, siehe Chassis-Schätzung |
| Lebenspunkte (pro +1 Punkt) | ≈ +1,5 | grob in derselben Größenordnung wie Rüstung |

Erklärte Varianz nur R² ≈ 0,67 (Restfehler bis zu ±4 Punkte bei
Gesamtkosten von 36–48) – **die Regression ist bei nur 14
Datenpunkten und massiver Kollinearität zwischen Traits und Chassis
statistisch nicht robust** (das negative Nahkampf-Vorzeichen ist
sicher kein echter Effekt, sondern Rauschen). Sie bestätigt aber
grob dieselbe Größenordnung wie die sauberen Paar-Vergleiche oben:
**Fernkampf ist der teuerste Wert, Rüstung und LP liegen im
Mittelfeld, Nahkampf und Überleben wirken günstiger** – exakte
Zahlen sind aus dieser Stichprobe nicht seriös ableitbar.

### Rückschlüsse für unser d10-System

1. **Bestätigt unsere bestehende Entscheidung, die Waffe klein zu
   halten und über den Basiswert zu differenzieren:** Wenn selbst in
   einem etablierten, jahrelang balancierten Tabletop die Waffe nur
   2–12% der Gesamtkosten ausmacht, ist unser Ansatz „Pool fest bei
   5/3, Waffen unterscheiden sich über Zielwert/AP/Tödlich/Traits,
   nicht über eine eigene Basis-Punktzahl" (Abschnitt 4, Punkt 7 in
   `dice-system-draft.md`) genau richtig kalibriert.
2. **Mögliche Überlegung: Fernkampf teurer bemessen als Nahkampf.**
   Halo scheint Fernkampf-Genauigkeit strukturell höher zu bewerten
   als Nahkampf-Genauigkeit (vermutlich weil Fernkampf ohne
   Gegenrisiko wirkt, Nahkampf Annäherung und Zone-of-Control-Risiko
   erfordert – bei uns sogar noch verstärkt durch die neue
   Kontrollreichweite-Regel). Unser aktueller Umrechnungskurs
   (Abschnitt 8.3) behandelt Fernkampf und Nahkampf gleich (1:1). Das
   ist eine bewusste Design-Entscheidung, die man beibehalten kann,
   aber die Halo-Daten liefern ein Argument dafür, Fernkampf
   testweise etwas teurer zu bepreisen als Nahkampf, falls das
   gewünschte Balance-Gefühl das hergibt. **Keine Änderungsempfehlung
   meinerseits, nur ein Hinweis, den man im Hinterkopf behalten
   kann.**
3. **Rüstung/HP NICHT direkt nach Halos Preisen kalibrieren.** Halo
   bepreist Rüstung und LP moderat (grob im selben Bereich, ~2 Punkte
   pro Stufe von 40–48 Gesamtkosten). Das würde falsch nahelegen,
   Rüstung sei bei uns ähnlich schwach zu bewerten wie HP. **Das
   greift zu kurz:** Halos Rüstungsmechanik funktioniert anders als
   unsere (vermutlich ein zusätzlicher Rettungswurf oder eine
   Würfel-Reduktion, nicht unsere „storniert Netto-Erfolge mit
   0-Kappung"-Logik). Unsere EIGENE exakte Rechnung von vorhin hat
   gezeigt, dass Panzerung bei UNS 30–80% des erwarteten Schadens
   storniert – ein weit stärkerer Hebel, als Halos Preisgefüge
   suggerieren würde. **Der bereits bestehende 2:1-Umrechnungskurs für
   Panzerung (Abschnitt 8.3) bleibt also richtig, unabhängig davon,
   was Halo dafür verlangt** – die eigene Wahrscheinlichkeitsrechnung
   ist hier die verlässlichere Quelle als ein Punktevergleich aus
   einem strukturell anderen System.
4. **Nebenbefund:** kleine Utility-Traits (Fliegen, Jetpack, Späher,
   Taktiker(1), Schneller Waffenwechsel, Bedrohlich) scheinen bei
   Halo jeweils nur 1–3 Punkte wert zu sein (grobe Schätzung aus den
   Chassis-Differenzen) – relativ zu Gesamtkosten von 36–48 also
   ebenfalls ein kleiner Anteil. Falls wir unsere eigenen Traits
   (Abschnitt 3) später ebenfalls in Budget-Einheiten bepreisen
   wollen, spricht das dafür, sie klein gegenüber vollen
   Stat-Verschiebungen zu halten, nicht gleichrangig.

---

## Erweiterte Halo-Kalibrierung (2026-08-29): 50 Einheiten + Waffendaten + Regelklärung

Kamil hat 16 weitere Screenshots geliefert (fast der komplette
Fireteam-Katalog: Jiralhanae/Banished, Sangheili, ODST, Noble Team,
Spartans) sowie **entscheidende Regel-Klarstellungen**, die die
Analyse oben teilweise korrigieren:

- **Schild UND Panzerung/Rüstung (R) funktionieren in Halo Flashpoint
  exakt wie bei uns:** 1 Punkt storniert 1 Netto-Erfolg, 1:1. Das
  widerlegt meine bisherige Vorsichts-Einschränkung („Halos
  Rüstungsmechanik könnte anders funktionieren als unsere") – sie
  funktioniert nachweislich GENAUSO. Der Punktkosten-Vergleich für R
  ist also direkt aussagekräftiger, als ich vorher angenommen hatte.
- **Fernkampf: immer 5 Würfel** (außer bei Deckung, dann reduziert) –
  identisch zu unserem Basis-Pool.
- **Verteidigung/Überleben (Ü): immer 3 Würfel** – identisch zu
  unserem Verteidigungs-Pool.
- **Nahkampf: NICHT immer 5 Würfel wie Fernkampf, sondern 3 Würfel im
  Normalfall – nur beim „Sturmangriff" 5 Würfel.** Sturmangriff =
  der erste Nahkampfangriff, nachdem sich ein Kämpfer in die
  Kontrollreichweite eines Gegners hineinbewegt hat – kostet
  KEINEN Aktionspunkt. Danach sind beide Kämpfer im Nahkampf
  „gebunden", jeder weitere Nahkampfangriff läuft nur noch mit 3
  Würfeln. **Das erklärt strukturell, warum Nahkampf in der
  Kostenanalyse günstiger wirkte als Fernkampf** (siehe unten) – es
  ist kein reiner Preis-Unterschied, sondern eine Pool-Größen-
  Asymmetrie, die im Normalfall gilt.

### Erweiterter Datensatz

50 eindeutige Kämpfer-/Waffen-Kombinationen aus allen bisherigen
Screenshots (UNSC Spartans, ODST, Noble Team, Banished/Jiralhanae,
Sangheili). Vollständige Rohdaten liegen im Analyse-Skript, hier nur
die Regressions-Ergebnisse (Ridge, λ=1,5, jetzt mit Schild und
Taktiker(N) als eigene numerische Merkmale statt nur Dummy-Traits):

| Merkmal | geschätzter Punktwert pro Stufe | Bemerkung |
|---|---:|---|
| Fernkampf (pro 12,5%-Schritt) | ≈ +5,2 | bestätigt: teuerster Kampfwert |
| Nahkampf (pro 12,5%-Schritt) | ≈ +2,3 | ~halb so teuer wie Fernkampf – jetzt mechanisch erklärt (3 statt 5 Würfel im Normalfall) |
| Überleben/Ü (pro 12,5%-Schritt) | ≈ +3,7 | zwischen Fern- und Nahkampf |
| Rüstung/R (pro +1 Punkt) | ≈ +2,1 | mechanisch identisch mit unserer Panzerung |
| Energieschild (pro +1 Punkt) | ≈ +4,8 | **gut doppelt so teuer wie Rüstung** – vermutlich weil Schild sich jede Runde regeneriert (siehe unten) |
| Lebenspunkte/LP (pro +1 Punkt) | ≈ +4,9 | überraschend: **teurer als Rüstung**, nicht billiger |
| Taktiker(N) (pro Stufe) | ≈ +8,0 | teuerster Einzel-Trait – passt zu einer mächtigen, mehrfach nutzbaren Sonderregel |

Modellgüte R² ≈ 0,90 bei 50 Einheiten und 20 Merkmalen – deutlich
robuster als die erste Fassung mit nur 14 Einheiten (R²=0,67), aber
mit denselben Grundeinschränkungen (viele Traits korrelieren mit
bestimmten Fraktionen/Archetypen).

### Rückschlüsse und konkrete Schritte für unser System

1. **Fernkampf ~2× teurer als Nahkampf ist jetzt mechanisch erklärt,
   nicht nur statistisch beobachtet:** Halo Flashpoint erreicht diese
   Asymmetrie nicht über einen unterschiedlichen Umrechnungskurs im
   Punktesystem, sondern strukturell über die Würfelpool-Größe
   (Nahkampf würfelt meistens nur 3 statt 5 Würfel). **Konkreter
   Vorschlag für Cold Comfort:** Wir könnten dasselbe Prinzip
   übernehmen – **Nahkampf im Normalfall nur mit dem
   3-Würfel-Verteidigungspool, volles 5-Würfel-Pool nur beim
   „Sturmangriff"** (erster Nahkampfangriff direkt nach Bewegung in
   die gegnerische Kontrollreichweite, kostenlos wie in Halo). Das
   hätte mehrere Vorteile für uns: (a) es macht unsere bereits
   beschlossene Kontrollreichweite-Regel noch relevanter (Timing des
   Hineinbewegens wird taktisch wichtig), (b) es erklärt/rechtfertigt
   automatisch, warum Nahkampf-Klassen wie Reiver einen hohen
   Nahkampf-Wert brauchen, um auch im „gebundenen" Zustand mit nur 3
   Würfeln noch zu treffen, (c) es macht unseren aktuellen flachen
   1:1-Umrechnungskurs zwischen Fernkampf und Nahkampf (Abschnitt 8.3)
   unproblematischer, weil die Asymmetrie dann strukturell aus der
   Würfelmechanik kommt statt aus einem künstlichen Preisaufschlag.
   **Das ist eine echte Kampfsystem-Entscheidung, keine reine
   Zahlenkorrektur – siehe Rückfrage im Chat.**
2. **Energieschild sollte teurer bepreist werden als Panzerung, wenn
   wir beides irgendwann in Budget-Einheiten für Ausrüstungs-Traits
   umrechnen** (Abschnitt 3.2) – Halos ~2:1-Verhältnis (Schild teurer)
   ergibt Sinn, wenn Schild bei uns ebenfalls rundenweise regeneriert
   (wie im alten Prototyp: „Schild +1 am Rundenende") und Panzerung
   das nicht tut. Ein Ausrüstungs-Trait wie „Persönlicher
   Schildgenerator" sollte also mechanisch wertvoller gewertet werden
   als ein hypothetisches Panzerungs-Äquivalent mit derselben
   Punktzahl.
3. **Offene Spannung, die ich nicht auflöse, sondern nur aufzeige:**
   Halos Daten legen nahe, dass LP (Lebenspunkte) sogar TEURER ist
   als Rüstung – das widerspricht unserer eigenen Design-Entscheidung
   in Abschnitt 8.3 (Panzerung kostet doppelt so viel wie HP pro
   Punkt, weil sie bei jedem Treffer erneut wirkt). Möglich, dass
   Halos Punktevergabe hier nicht perfekt mathematisch optimiert ist
   (Punktesysteme in Tabletop-Spielen sind oft grobe Heuristiken,
   keine exakte Wahrscheinlichkeitsrechnung), oder dass ihre
   Rüstungs-/LP-Werte in einem Bereich liegen, wo LP tatsächlich
   wertvoller ist. **Empfehlung: unserer eigenen Wahrscheinlichkeits-
   rechnung vertrauen (Panzerung > HP pro Punkt), nicht Halos
   Punktepreis** – aber im Playtest im Auge behalten, ob sich das
   bestätigt.
4. **Taktiker(N) als teuerster Einzel-Trait** bestätigt, dass unsere
   geplanten Kommando-Manöver/Taktische-Manöver-artigen Fähigkeiten
   (vgl. `dice-system-draft.md` Abschnitt 6) zurecht als mächtig
   gelten dürfen – Halo bepreist genau diese Art wiederverwendbarer
   taktischer Sonderaktion am höchsten von allen untersuchten
   Merkmalen.
