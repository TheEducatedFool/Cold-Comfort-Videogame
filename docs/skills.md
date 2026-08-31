# COLD COMFORT – Skill-Trees pro Klasse

> Baut auf `classes.md` (Klassen, Basiswerte), `dice-system.md` (Charge,
> Flanking, Zone of Control, Pinned, Höhenbonus, Kommando-Manöver) und
> `traits.md` (Waffenprofil, Statuseffekte) auf. Struktur pro Klasse:
> **1 Grundfähigkeit** (Level 1, alle Klassenmitglieder) → **2 Zweige**
> (XCOM-Prinzip), je **2 aktive + 2–3 passive Fähigkeiten** → **1
> Ultimate** (1× pro Mission, Krönung des Baums). Zahlen/Werte sind
> Diskussionsgrundlage, kein finales Balancing.

## Design-Regeln für alle Klassen (beim Erweitern beachten)

- Jede Klasse hat genau eine Grundfähigkeit, die einen bereits
  bestehenden Kampfmechanismus (Charge, Deckung, Zone of Control,
  Overwatch, Patch Up) leicht verstärkt, statt einen neuen Mechanismus
  einzuführen.
- **Charge-Boni sind pro Aktivierung hart auf 2 gedeckelt** (reguläre
  Bewegung + Dash, siehe `dice-system.md`) – neue Fähigkeiten dürfen
  zusätzliche Bewegung gewähren, aber nie einen dritten Charge-Bonus in
  derselben Aktivierung auslösen.
- **Flanking bleibt fest bei +1**, unabhängig von der Zahl der
  Verbündeten – nicht durch neue Skills skalierbar machen.
- Faustregel gegen Würfel-Inflation: ein einzelner Angriffswurf sollte
  auch im Extremfall (alle Boni gleichzeitig) spürbar unter 12 Würfeln
  bleiben.
- Aktive Fähigkeiten kosten 1 oder 2 Aktionspunkte PLUS einen
  XCOM-artigen **Cooldown von X Runden** (keine separate Ressource wie
  „Fokus"). Richtwert: kleine, häufige Fähigkeiten 1–2 Runden Cooldown,
  starke Fähigkeiten mit großem Bonussprung 3–4 Runden. Ultimates
  bleiben bei „1× pro Mission" (kein zusätzlicher Cooldown).
- **Freischalt-Reihenfolge: linear pro Zweig** (XCOM-Prinzip) – Aktiv 1
  vor Aktiv 2, Passiv-Reihenfolge analog. Ultimate erst nach Abschluss
  des gewählten Zweigs.

## English-Glossar der Kernbegriffe

| Deutsch (Konzept) | Englisch (verwendet ab hier) |
|---|---|
| Sturmangriff | **Charge** |
| Kontrollreichweite/-bereich | **Zone of Control (ZoC)** |
| Gebunden | **Locked In** |
| Flankierungs-Bonus | **Flanking** |
| Niedergehalten | **Pinned** |
| Erschüttert | **Shaken** |

---

## Breacher – aggressiver Nahdistanz-Kämpfer

**Grundfähigkeit – Full Contact:** Wird der Charge-Bonus in derselben
Aktivierung nach regulärer Bewegung UND einem zusätzlichen Dash
ausgelöst, erhält der Breacher einen dritten Bonuswürfel (+3 statt +2) –
einer der beiden im Grundregelwerk bereits eingebauten Charges pro
Aktivierung, keine zusätzliche Bewegung.

### Zweig A – Demolition (Fernkampf & Kontrolle)

**Aktiv:**
1. **Shotgun Blast** – Nahbereichs-Fernkampfangriff (Reichweite 3); bei
   Treffer wird das Ziel gepinnt, unabhängig vom Schaden.
2. **Breach Charge** – Zerstört ein Deckungselement in Reichweite; jeder
   Gegner, der dadurch seine Deckung verliert, wird gepinnt.

**Passiv:**
1. **Short Fuse** – +1 AP auf alle vom Breacher genutzten
   Explosivwaffen/Granaten.
2. **Unflinching** – Immun gegen die Overheat-Downside eigener Waffen.
3. **Forward Momentum** – +1 Bewegungsreichweite, solange sich der
   Breacher in der aktuellen Runde noch nicht in eine gegnerische ZoC
   bewegt hat.

### Zweig B – Onslaught (Nahkampf & Charge)

**Aktiv:**
1. **Relentless** – Schaltet der Breacher einen Gegner im Nahkampf aus,
   darf er sich sofort bis zu 3 Felder bewegen (Dash-Distanz) –
   kostenlos, aber diese Bewegung löst NIEMALS einen Charge-Bonus aus,
   selbst wenn sie in eine neue gegnerische ZoC führt (ein daraus
   folgender Angriff nutzt nur den 3-Würfel-Basispool plus ggf.
   Flanking/Pinned).
2. **Put Down** – Nahkampfangriff, der das Ziel unabhängig vom Schaden
   pinnt.

**Passiv:**
1. **Choke Hold** – Gegner, die die ZoC des Breachers verlassen wollen,
   würfeln mit 1 Würfel weniger Verteidigung gegen den Gegenangriff.
2. **Hardened** – +1 Panzerung, solange der Breacher Locked In ist.
3. **Dead Man's Laugh** – Nach dem Ausschalten eines Gegners im Nahkampf
   regeneriert der Breacher 1 HP.

**Ultimate – Kick the Door Down** (1× pro Mission): innerhalb der
Bewegung, die der Breacher in dieser Aktivierung ohnehin ausführt
(regulär + Dash, keine zusätzliche Bewegung), löst JEDE neu betretene
gegnerische ZoC einen vollen Charge-Angriff aus (nicht nur die erste),
und der Breacher fällt bis Rundenende nicht in den Locked-In-Zustand.

---

## Deadeye – fragiler Präzisionsschütze

**Grundfähigkeit – Steady Aim:** Hat sich der Deadeye in der aktuellen
Aktivierung noch nicht bewegt, bevor er schießt, erhält sein
Fernkampfangriff +1 Bonuswürfel.

### Zweig A – Marksman (Präzision)

**Aktiv:**
1. **Called Shot** – Kostet beide Aktionspunkte: +2 Bonuswürfel,
   Krit-Schwelle auf 1–2 erweitert (klasseneigen, stapelt sogar mit
   einer Waffe, die selbst schon Sniper Scope trägt).
2. **Clean Shot** – Ignoriert Deckung für diesen einen Angriff.

**Passiv:**
1. **Long Sight** – +2 Felder Reichweite auf alle Fernkampfwaffen.
2. **First Blood** – Der erste Schuss des Deadeye in jeder Mission
   bekommt automatisch Krit-Schwelle 1–2, ohne Zusatzkosten.
3. **Iron Nerve** – Immun gegen den Nahkampf-Anfälligkeits-Malus von
   Pinned.

### Zweig B – Vantage (Mobilität & Übersicht)

**Aktiv:**
1. **Fighting Retreat** – Nach einem Fernkampfangriff darf sich der
   Deadeye kostenlos 2 Felder bewegen.
2. **Heightened Awareness** – Alle Overwatch-Schüsse des Deadeye in
   dieser Runde bekommen +1 Bonuswürfel.

**Passiv:**
1. **High Ground** – Höhenbonus verdoppelt sich für den Deadeye: +1
   Würfel je 1 Feld Höhenunterschied statt je 2.
2. **Spotter** – Der Deadeye kann ein Ziel markieren; markierte Ziele
   gelten für alle Verbündeten als flankiert.
3. **Ice in the Veins** – +1 Verteidigungswürfel, solange sich der
   Deadeye in der aktuellen Runde nicht bewegt hat.

**Ultimate – Last Rites** (1× pro Mission): ein Schuss ohne
Reichweitenbegrenzung (ignoriert das Reichweite-Profilfeld, nicht
Deckung/Sichtlinie), +3 Bonuswürfel, garantierter Lethal-Bonus in Höhe
des doppelten Waffen-Lethal-Werts.

---

## Reiver – fragiler Hit-and-Run-Nahkämpfer

**Grundfähigkeit – Silent Step:** Bewegung durch gegnerische ZoC löst
beim Reiver niemals den kostenlosen Gegenangriff aus – dauerhaft, nicht
nur in einer bestimmten Aktivierung.

### Zweig A – Wraith (Tarnung & Mobilität)

**Aktiv:**
1. **Vanish** – Nach einem Angriff wechselt der Reiver sofort wieder in
   die Guarded-Haltung (bricht die normale Regel, dass Angreifen die
   Haltung offenlegt).
2. **Blade Throw** – Fernkampf-Ersatzangriff (Reichweite 3) unter
   Verwendung des Nahkampf-Werts statt Fernkampf.

**Passiv:**
1. **First Strike** – Charge-Angriffe des Reivers bekommen einen
   zusätzlichen Bonuswürfel (+3 statt +2).
2. **Fleet of Foot** – +2 Felder Bewegungsreichweite.
3. **Unseen** – Wird von Overwatch-Schüssen nicht erfasst, solange er
   sich in Guarded-Haltung befindet.

### Zweig B – Butcher (Aggression & Furcht)

**Aktiv:**
1. **Harrow** – Nahkampfangriff, der bei Treffer zusätzlich **Shaken**
   verursacht: das Ziel würfelt bei seiner nächsten Aktion mit 1 Würfel
   weniger. Shaken ist ein eigener Status, getrennt von Pinned – beide
   gleichzeitig auf ein Ziel zu stapeln ist erlaubt.
2. **Bleed Out** – Nahkampfangriff, der bei Treffer eine Blutungs-Wunde
   verursacht: das Ziel verliert zu Beginn seiner nächsten beiden
   Aktivierungen je 1 zusätzlichen Netto-Erfolg an Schaden (Damage over
   Time).

**Passiv:**
1. **Blood Frenzy** – Nach dem Ausschalten eines Gegners im Nahkampf:
   +1 Bonuswürfel auf alle Nahkampfangriffe des Reivers für den Rest
   der Runde.
2. **Long Reach** – Kontrolliert zusätzlich zu den direkt angrenzenden
   auch die diagonal angrenzenden Felder.
3. **Unstoppable** – Charge-Angriffe verlieren nie ihren Bonus, selbst
   bei Waffen mit dem Brutal-Trait.

**Ultimate – Kill Chain** (1× pro Mission): innerhalb der Bewegung
dieser Aktivierung (regulär + Dash, keine zusätzliche Bewegung) löst
JEDE neu betretene gegnerische ZoC einen vollen Charge-Angriff aus,
nicht nur die erste.

---

## Handler (vormals Rigger/„Patch") – Kommando-/Support-Klasse

Vorbild: XCOM EU/EW Support-Klasse (Field Medic, Covering Fire,
Sentinel) – bewusst NICHT der Drohnen-/Hacking-lastige XCOM-2-Specialist,
passend zur Dominion-Stagnations-Lore aus `setting.md`.

**Grundfähigkeit – Patch Up:** Reparatur-/Heilaktion: entfernt eine
Wunde bei einem Verbündeten ODER stellt 1 Panzerungspunkt eines
Verbündeten/Moduls wieder her.

### Zweig A – Triage (Feldmedizin)

**Aktiv:**
1. **Field Dressing** – Verbesserte Heilaktion: entfernt eine Wunde UND
   den Pinned-Status bei einem Verbündeten in Reichweite.
2. **Adrenaline Shot** – Ein Verbündeter in Reichweite bekommt +1
   Bonuswürfel auf seinen nächsten Wurf in dieser Aktivierung.

**Passiv:**
1. **Combat Triage** – Verbündete mit einer schweren Wunde in
   Reichweite erhalten +1 Verteidigungswürfel.
2. **Battlefield Salvage** – Vom Handler ausgerüstete Verbündete
   erleiden seltener Ausrüstungsschaden/-verschleiß.
3. **Combat Medic** – Patch Up (Grundfähigkeit) heilt 1 zusätzliche
   Wunde.

### Zweig B – Command

**Aktiv:**
1. **Move Out!** – Ein Verbündeter in Reichweite erhält sofort eine
   Extra-Aktion. Keine Redundanz zum selteneren, größeren
   Kommando-Manöver-System des Kommandanten (`dice-system.md`) – zwei
   bewusste Ebenen desselben Prinzips.
2. **Mark Target** – Markiert einen Gegner: der nächste Angriff eines
   Verbündeten gegen dieses Ziel bekommt +1 Bonuswürfel.

**Passiv:**
1. **Coordination** – Verbündete in Bewegungsreichweite des Handlers
   erhalten +1 Feld Bewegungsreichweite.
2. **Battle-Hardened** – Der Handler selbst erhält +1 Verteidigungswürfel,
   solange mindestens 2 Verbündete in Sichtweite sind.
3. **Lay of the Land** – Freie Aktion, 1× pro Runde: deckt die Position
   eines gegnerischen Modells auf.

**Ultimate – Rally the Line** (1× pro Mission): alle Verbündeten in
Sichtweite erhalten gleichzeitig +1 Schild-Punkt (Triage) UND eine
Extra-Aktion (Command).

---

## Heavy – schwere Feuerkraft mit zwei Zweigen

**Grundfähigkeit – Dug In:** Bewegt sich der Heavy in seiner
Aktivierung nicht, erhält sein nächster Fernkampfangriff +1 Bonuswürfel.

### Zweig A – Suppression

**Aktiv:**
1. **Suppressing Salvo** – Fernkampfangriff mit garantiertem
   Pinned-Effekt bei Treffer.
2. **Special Ammo** – Für den nächsten Angriff wählt der Spieler: +2 AP
   ODER +2 SD.

**Passiv:**
1. **Sling Mount** – Waffen mit dem Trait „Bulky" verlieren ihre
   Bewegungseinschränkung für den Heavy.
2. **Cooling System** – Senkt die Overheat-Schwelle (`traits.md`) für
   den Heavy von 9–10 auf nur noch 10 – halbiert das Risiko.
3. **Bracing** – +1 Panzerung, solange sich der Heavy in seiner
   Aktivierung nicht bewegt hat.

### Zweig B – Ordnance

**Aktiv:**
1. **Trip Charge** – Platziert eine Falle auf einem Feld in Reichweite;
   löst bei gegnerischem Betreten automatisch eine Explosions-Probe aus.
2. **Barrage** – Wirft zwei Granaten in einer Aktion (kostet beide
   Aktionspunkte), gegen zwei unterschiedliche Zielfelder.

**Passiv:**
1. **Demolitions Expert** – Bekommt bei der Wurf-Probe einen
   zusätzlichen Bonuswürfel – reduziert die Abweichungswahrscheinlichkeit
   spürbar.
2. **Full Payload** – Granaten mit dem Limited-Trait bekommen +1
   zusätzliche Nutzung pro Mission.
3. **Controlled Blast** – Verbündete im Blast Radius eigener
   Granaten/Fallen werden automatisch ausgenommen (Friendly-Fire-Schutz).

**Ultimate – Scorched Earth** (1× pro Mission): eine einzelne Explosion
mit verdoppeltem Blast Rating und +2 Blast Radius; Verbündete
automatisch ausgenommen (Controlled Blast gilt), alle getroffenen
Gegner werden gepinnt, unabhängig vom Verteidigungswurf.

---

## Waffenarchetypen pro Klasse

Jede Klasse kommt mit jeder Waffe zurecht (keine harten
Waffen-Restriktionen), glänzt aber mit bestimmten Waffengattungen –
entsteht emergent aus Basiswerten (`classes.md` Abschnitt 8) und Skills,
die auf bestimmte Waffentraits referenzieren.

- **Breacher:** Schrotflinten/kurzreichweitige Fernkampfwaffen, schwere
  Nahkampfwaffen mit Brutal-Trait; Short Fuse belohnt Explosivwaffen.
- **Deadeye:** Scharfschützengewehre mit Sniper-Scope-Trait (stapelt mit
  Called Shot), generell hohe Reichweite (Long Sight verstärkt das).
- **Reiver:** leichte Nahkampfklingen mit Honed-Edge/Killing-Blow-Trait,
  Wurfwaffen (Blade Throw), schallgedämpfte Sidearms.
- **Handler:** bewusst keine Waffen-Spezialisierung – neutrale
  Sidearms/Karabiner, starke Synergie mit Ausrüstung (Field Med Kit,
  Trauma Plate).
- **Heavy:** schwere Waffen mit Bulky-Trait (Sling Mount hebt die
  Bewegungseinschränkung auf), Granaten/Explosivwaffen.

---

## Noch offen für Phase 2/3

- Konkrete Cooldown-Zahl pro aktiver Fähigkeit (Richtwerte siehe
  „Design-Regeln" oben).
- Konkrete Zahlenwerte für Adrenaline Shot, Combat Triage und weitere
  neue Handler-Fähigkeiten.
- Ob beide Zweige eines Klassenmitglieds vollständig sein müssen, bevor
  die Ultimate verfügbar wird, oder nur der zuletzt gewählte
  (Implementierungsdetail).
