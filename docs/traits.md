# COLD COMFORT – Traits & Waffenprofil

> Lead-Sprache im Spiel ist Englisch – alle Trait-/Status-Namen sind
> Englisch, Erklärtexte Deutsch. Baut auf `dice-system.md` auf (Würfelpool,
> Charge, Flanking, Zone of Control). Zahlen sind Diskussionsgrundlage,
> kein finales Balancing, außer wo ausdrücklich als fix markiert.

## 0. Waffenprofil: Reichweite, AP, SD, Lethal

**AP, SD und Lethal sind festes Waffenprofil, keine Traits** – jede
Waffe hat einen Wert (auch 0), das macht Waffen direkt vergleichbar und
ist trivial als typisierte Felder auf der Waffen-Resource zu
implementieren (`range`, `ap`, `sd`, `lethal`). Volle Schadenskette:
`dice-system.md` Abschnitt 6.

### 0.1 Waffenprofil-Vorlage

| Feld | Bedeutung |
|---|---|
| **Reichweite** | Felder, bis zu denen die Waffe zielen kann. Nahkampfwaffen bekommen statt einer Zahl **NK** – sie wirken nur gegen Ziele in der eigenen Zone of Control. |
| **AP** (Armor Penetration) | Reduziert die wirksame Panzerung des Ziels um AP vor der Verrechnung. |
| **SD** (Shield Disruption) | Reduziert das wirksame Schild des Ziels um SD vor der Verrechnung – exakt dieselbe Mechanik wie AP, nur auf Schild angewendet. |
| **Lethal** | Flacher Bonusschaden, einmal pro Angriff, sobald mindestens 1 Netto-Erfolg nach Schild UND Panzerung übrig bleibt. |
| **0–2 Traits** | Aus den Clustern unten. |

### 0.2 Beispiel-Waffenprofile (Diskussionsgrundlage, keine finalen Werte)

| Waffe | Reichweite | AP | SD | Lethal | Traits |
|---|---:|---:|---:|---:|---|
| Standard-Sturmgewehr | 8 | 0 | 0 | 0 | Dependable |
| Scharfschützengewehr | 12 | 1 | 0 | 2 | Sniper Scope, Bulky |
| Schildbrecher-Karabiner | 7 | 0 | 3 | 0 | Rapid Fire |
| Splittergranate | Wurfreichweite 5 | 0 | 0 | 0 | Limited (1), Blast Rating 5, Blast Radius 1, Concussive |
| Kampfmesser | NK | 0 | 0 | 0 | Dependable |
| Kettenklinge | NK | 1 | 0 | 1 | Brutal |
| Schockstab | NK | 0 | 2 | 0 | Stagger |

### 0.3 Waffen-Archetypen (Namenskonvention, `gdd.md`)

„Schildbrecher" (hoher SD), „Panzerknacker" (hoher AP), „Präzisions-
Killer" (hoher Lethal) sind Archetyp-Bezeichnungen für Waffen mit
entsprechend hohem Profilwert, keine eigenen Traits.

---

## 1. Waffen-Traits

Baukasten-Prinzip: 0–2 Traits pro Waffe aus unterschiedlichen Clustern.
Jeder Cluster enthält mindestens einen reinen Fernkampf- (FK) und einen
reinen Nahkampf-Trait (NK).

### Cluster 1 – Verlässlichkeit (Rerolls)

| Trait | Wirkung | FK/NK |
|---|---|---|
| **Dependable** | 1 Fehlwurf neu würfeln. | beide |
| **Withering Fire** | Alle Würfel mit demselben (Fehl-)Ergebnis neu würfeln. | FK |
| **Momentum Edge** | Beim Charge dürfen alle Fehlwürfe neu gewürfelt werden. | NK |
| **Full Auto** | Beliebig viele Fehlwürfe neu würfeln – gekoppelt mit **Overheat** (Cluster 5). | FK |

### Cluster 2 – Präzision (Bonuswürfel + erweiterte Krit-Schwelle)

| Trait | Wirkung | FK/NK |
|---|---|---|
| **Red Dot** | +1 Bonuswürfel, Krit-Schwelle auf 1–2 erweitert. | FK |
| **Sniper Scope** | +2 Bonuswürfel, Krit-Schwelle auf 1–2 erweitert – kostet beide Aktionspunkte. | FK |
| **Honed Edge** | Nahkampf-Pendant zu Red Dot. | NK |
| **Killing Blow** | Nahkampf-Pendant zu Sniper Scope. | NK |

### Cluster 3 – Durchdringung (Verteidiger-Würfelpool schwächen)

*Reiner Panzer-/Schild-Abbau läuft über das Profil (AP/SD, Abschnitt 0)
– hier nur Traits, die den Verteidigungs-Würfelpool selbst schwächen.*

| Trait | Wirkung | FK/NK |
|---|---|---|
| **Cover Breaker** | Der Deckungs-Würfelabzug beim Ziel entfällt für diesen Angriff. | FK |
| **Indirect Fire** | Kann auch ohne direkte Sichtlinie treffen (Mörser/Werfer). | FK |
| **Stagger** | Ziel verliert bei seiner NÄCHSTEN Verteidigung 1 Würfel. | NK |

### Cluster 4 – Flächenwirkung

| Trait | Wirkung | FK/NK |
|---|---|---|
| **Blast X** | Trifft zusätzliche Ziele im Radius X um das Hauptziel. | FK |
| **Shockwave** | Entlädt das Schild aller Ziele im Wirkungsbereich (unabhängig vom Trefferwurf). | FK |
| **Cleave** | Trifft gleichzeitig ALLE Gegner in der eigenen Zone of Control (ein Angriffswurf je Ziel). | NK |

### Cluster 5 – Risiko/Kosten für mehr Stärke

| Trait | Wirkung | FK/NK |
|---|---|---|
| **Bulky** | Kein Bewegen und Schießen in derselben Aktivierung. | FK |
| **Overheat** | Nach dem Schuss: 1 zusätzlicher d10-Wurf – bei 9 oder 10 überhitzt die Waffe (Details unten). | FK |
| **Ponderous** | Kostet beide Aktionspunkte für einen einzigen Angriff. | beide |
| **Brutal** | Sehr hohe AP/Lethal, aber der Charge-Bonus entfällt bei dieser Waffe (auch beim ersten Angriff nur 3 statt 5 Würfel). | NK |

**Overheat – volle Regel:** Nach jedem Schuss mit einer Overheat-Waffe
wird zusätzlich 1 d10 geworfen (unabhängig vom Angriffswurf) – bei einer
**9 oder 10** überhitzt die Waffe. **Konsequenz:** Die Waffe kann in der
NÄCHSTEN Aktivierung des Trägers nicht genutzt werden (Bewegung und
Nahkampf bleiben unberührt). Kein Selbstschaden. Heavys Skill „Cooling
System" (`skills.md`) senkt die Schwelle auf nur noch 10 (halbiert das
Risiko).

### Cluster 6 – Kontrolle & Sprengwirkung

| Trait | Wirkung | FK/NK |
|---|---|---|
| **Suppressing Fire** | Jeder Treffer verursacht zusätzlich Pinned beim Ziel – unabhängig davon, ob am Ende Schaden durchkommt. | FK |
| **Rapid Fire** | Alternativer Feuermodus, vor dem Angriff gewählt (schließt sich mit normalem Schuss derselben Waffe aus): +1 Bonuswürfel, verursacht **niemals Schaden**. Bei mindestens 1 Netto-Erfolg: Ziel verliert 1 Schild-Punkt (falls vorhanden) und wird Pinned. | FK |
| **Limited (meist 1)** | Nur X-mal pro Mission nutzbar. | – |

**Explosivwaffen/Granaten – volle Ablaufmechanik:** zwei getrennte Proben.

1. **Wurf-Probe** (bestimmt nur die Abweichung, keinen Schaden): normale
   Fernkampf-Probe des Werfers, ausgewertet nach Erfolgsanzahl (kein
   Verteidiger würfelt dagegen):
   - **2+ Erfolge:** kein Abweichen, trifft exakt das Zielfeld.
   - **1 Erfolg:** Abweichung um 1 Feld – Richtung per **d8 auf die 8
     Kompass-Nachbarrichtungen** (N/NO/O/SO/S/SW/W/NW).
   - **0 Erfolge:** Abweichung um 2 Felder (dieselbe d8-Bestimmung,
     Implementierungsdetail ob zweimal angewendet oder direkt 2 Felder).
2. **Explosions-Probe** (bestimmt den Schaden, für jedes Ziel im
   tatsächlichen Radius einzeln): die Granate greift mit einem festen,
   vom Werfer unabhängigen **Blast Rating X** an (= X Angriffswürfel).
   Jedes Ziel im Blast Radius würfelt seine normale Verteidigung (3
   Würfel), **ohne Deckungsboni** (eine Explosion kümmert sich nicht um
   Sichtdeckung gegen Kugeln). Danach normale Schadenskette
   (`dice-system.md` Abschnitt 6) inkl. AP/SD/Lethal der Granate.

| Feld/Trait | Bedeutung |
|---|---|
| **Throw Range** | Eigenes Feld statt normaler Reichweite. |
| **Blast Rating X** | Angriffswürfel der Explosions-Probe – unabhängig vom Fernkampf-Wert des Werfers. |
| **Blast Radius X** | Felder um den Einschlagspunkt, die von der Explosions-Probe betroffen sind. |
| **Concussive** | Jedes Ziel im Explosionsradius wird Pinned – auch wer sich erfolgreich verteidigt. |
| **Limpet Charge** | Bei Treffer wird das Schild des Ziels vollständig entladen, unabhängig von Netto-Erfolgen. |

---

## 2. Statusmechanik: Pinned

Zwei Effekte:

1. **Anfälliger im Nahkampf:** jeder Nahkampfangriff gegen ein Pinned-
   Ziel bekommt **+1 Bonuswürfel** – stapelt additiv mit Charge und
   Flanking (ein flankierter Charge gegen ein Pinned-Ziel: 3 Basis + 2
   Charge + 1 Flanking + 1 Pinned = 7 Würfel).
2. **Entzieht Handlungsfreiheit:** zu Beginn der NÄCHSTEN Aktivierung
   muss der Kämpfer eine **„Aufstehen"-Aktion** ausführen, die nur den
   Pinned-Status entfernt (verbraucht 1 der 2 Aktionspunkte, nicht mit
   Bewegung/Schießen/Nahkampf kombinierbar). Bleibt dabei normal
   angreifbar.

**Quellen:** Waffen-Traits Suppressing Fire, Rapid Fire, Concussive
(Abschnitt 1); Klassen-Skills (`skills.md`).

---

## 3. Ausrüstungs-Traits (an Gegenstände gebunden)

| Trait | Wirkung |
|---|---|
| **Stealth Field** | Reduziert/verhindert den gegnerischen Flanking-Bonus, solange das Schild des Trägers noch voll ist. |
| **Personal Shield Generator** | Zusätzliche Schild-Punkte zusätzlich zum Basiswert. |
| **Jump Pack** | Ignoriert Klettern-Bewegungskosten bzw. gewährt zusätzliche Höhenbewegung. |
| **Trauma Plate** | Einmal pro Mission wird ein Treffer, der den Träger eigentlich vollständig ausschalten würde, stattdessen zu einer (schweren) Wunde. |
| **Sniper Scope** (Ausrüstung) | +1 Würfel oder erweiterte Krit-Schwelle bei Fernkampf-Angriffen. |
| **Suppressor** | Erlaubt Schießen, ohne die Guarded-Haltung zu brechen. |
| **Load-Bearing Rig** | Mehr gleichzeitig tragbare Ausrüstungs-Slots. |
| **Combat Stims** | Bonus-Würfel bei Sprint/Dash im selben Zug. |
| **Stabilizers** | Träger kann nicht Pinned werden. |
| **Field Med Kit** | Aktion: entfernt eine Wunde bei einem Verbündeten im selben/angrenzenden Feld. |

---

## 4. Charakter-Traits

Genau ein Charakter-Trait pro Rekrut. Wirkt auf Gefecht ODER
Schiffsmanagement ODER beides. Zahlen offen, Wirkrichtung entschieden.

| Trait | Wirkung |
|---|---|
| **Jack of All Trades** | Kleiner Bonus sowohl im zugewiesenen Modul als auch auf Missionen (seltener „Premium"-Rekrut). |
| **Methodical** | Deutlicher Produktions-/Forschungsbonus im Modul, kleiner Malus im Feld. |
| **Resourceful** | Deutlicher Mission-Bonus (z. B. mehr geborgene Ressourcen), kein Modul-Bonus. |
| **Savant** | Sehr hoher Bonus in EINEM bestimmten Modul, dafür im Feld unterdurchschnittlich. |
| **Battle-Scarred** | Träger kann nicht Pinned werden (volle Pinned-Immunität), im Modul durchschnittlich. |
| **Xenobiologist** | Spezialisierung → **Lab**: Voraussetzung für Swarm-Proben-Forschungszweige (z. B. Bestiarium/Schwächen-Daten, Gegenmittel-Projekte) und für das spätere Vector-Forschungsprojekt. |
| **Weapons Engineer** | Spezialisierung → **Workshop**: Voraussetzung für High-Tier-Blaupausen der drei Waffenarchetypen (z. B. „Schildbrecher-Karabiner Mk. II", „Panzerknacker-Munition", „Präzisions-Killer-Sniper"). |
| **Relic Keeper** | Spezialisierung → **Ship's Core**: Voraussetzung für Relikt-Investitionsprojekte (bessere Fenster-Berechnung, Erinnerungsfragmente, neue Ship-Gefechtsfähigkeiten). |

Spezialisierungs-Traits sind selten im Pool. Konkrete Kosten/Zahlen:
Phase-4-Balancing (`roadmap.md`). Rein flavor-Traits ohne Mechanik-Effekt
sind ebenfalls denkbar (reine Persönlichkeit/Dialogfarbe).

---

## 5. Englische Namen – Kernbegriffe (Referenz)

| Deutsch | Englisch |
|---|---|
| Niedergehalten | **Pinned** |
| Erschüttert | **Shaken** |
| Gebunden | **Locked In** |
| Sturmangriff | **Charge** |
| Kontrollreichweite/-bereich | **Zone of Control (ZoC)** |
| Flankierungs-Bonus | **Flanking** |
| AP (Panzerungsdurchdringung) | **AP** (Armor Penetration) |
| SD (Schild-Abbau) | **SD** (Shield Disruption) |
| Tödlich | **Lethal** |

---

## Noch offen

- Konkrete Zahlenwerte für alle Charakter-/Ausrüstungs-Traits (Phase 2/3
  Balancing).
- Konkrete Kosten der Spezialisierungs-Trait-Projekte (Phase 4).
