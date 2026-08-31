# COLD COMFORT – Game Design Document (v1.0)

> Bereinigt für den Prototyp-Neustart (2026-08-30): stellt den
> aktuellen Design-Stand dar, nicht den Weg dorthin. Setting-Details:
> `setting.md`. Aktuelle Kampfmechanik (Würfelpool, ersetzt das hier
> teilweise noch beschriebene alte Prozentsystem): `dice-system.md`,
> `traits.md`. Klassen & Skills: `classes.md`, `skills.md`. Crew &
> Kommandant: `crew.md`.

## Beschlossene Grundpfeiler

- **Genre:** Rundenbasiertes Taktikspiel (XCOM, Xenonauts, Chaos Gate,
  Phoenix Point als Referenzen – Zugstruktur nach Tabletop-Vorbild,
  siehe Aktivierungsmodell).
- **Plattform:** PC. Lead-Sprache: Englisch (deutsche Lokalisierung später).
- **Engine:** Godot 4, 3D mit Low-Poly-Stil, isometrische Kamera
  (in 90°-Schritten drehbar), Rasterfeld (Grid).
- **Spielerfigur:** Kommandant – feste Führungsfigur, kämpft nie selbst
  auf der taktischen Karte (siehe `crew.md`).
- **Trupp-Größe:** 4 Soldaten pro Mission (aus dem Rekrutierungs-Pool,
  siehe `classes.md`).
- **Klassen:** 5 feste Klassen mit klaren Rollen (siehe `classes.md`).
- **Basis:** Das Schiff Cold Comfort (mobil, reist mit).
- **Multiplayer:** Nicht geplant.
- **Zielplattform:** Steam-Veröffentlichung angestrebt (siehe `roadmap.md`).

---

## Trupp, Wunden & Tod

Kernprinzip: **Der Tod ist nie Pech – er ist immer die Folge einer
Spielerentscheidung.**

Die reguläre Crew besteht aus rekrutierten Pool-Kämpfern, nicht aus
fixen, unsterblichen Story-Charakteren – echtes XCOM-Gefühl. Der
**Kommandant ist nie in Gefahr**, da er nie selbst auf die taktische
Karte kommt (siehe `crew.md`).

- Geht ein Soldat im Gefecht zu Boden bzw. verliert während einer
  Mission HP, erleidet er eine **Wunde, gestaffelt nach Höhe des
  HP-Verlusts** – **leichte Wunde** oder **schwere Wunde** (genaue
  HP-Schwellen: Phase 2/3). Beide erfordern einen Aufenthalt im
  **Medbay-Modul** (Ausfallzeit in Tagen, schwer länger als leicht).
- Ausfallzeiten verzahnen sich mit dem Flacker-Timer: ein Verwundeter
  kostet real Missionszeit im System.
- **Permadeath tritt in zwei Fällen ein:**
  1. Ein Kämpfer wird in einer Mission **vollständig niedergeschossen**
     (nicht nur verwundet, sondern komplett ausgeschaltet).
  2. Ein noch **verwundeter** Kämpfer (leicht oder schwer, noch nicht
     im Medbay auskuriert) wird erneut auf Mission geschickt und geht
     dort wieder zu Boden.
- Ein voll ausgeheilter Kämpfer, der auf einer neuen Mission erneut zu
  Boden geht, erleidet stattdessen wieder „nur" eine neue Wunde – das
  Risiko entsteht gezielt durch das Zurückschicken von noch
  Verwundeten, nicht durch die Anzahl der Einsätze an sich.

**Noch offen:** genaue HP-Schwellen leicht/schwer, genaue Ausfalltage je
Wundstufe (Phase 4-Balancing); ob bleibende Narben/Traumata bei
wiederholten Wunden entstehen (Idee, nicht entschieden).

---

## Kampagnenstruktur: System-Kapitel & Flacker-Timer

Das Herzstück der strategischen Ebene. Die Kampagne ist eine Kette von
**System-Kapiteln**:

1. **Ankunft:** Die Cold Comfort erreicht ein Sternensystem durch ein
   Flacker-Fenster.
2. **Missions-Pool:** Im System warten mehr Missionen, als Zeit da ist –
   Story-Missionen, Fraktionsaufträge (Dominion-Feinde, Houses, Ringfolk,
   Echo), Ressourcen-Bergungen, Optionales.
3. **Der Timer:** Ship berechnet das nächste brauchbare Flacker-Fenster
   (Countdown in Tagen). Missionen, Reisen im System, Reparaturen und
   Heilung kosten Tage.
4. **Die Entscheidung:** Der Spieler wählt aktiv, welche Missionen er
   angeht und welche er auslässt. **Man schafft nie alles.**
5. **Konsequenzen:** Ausgelassene Missionen haben Folgen – Fraktions-
   beziehungen verschlechtern sich, Ressourcen entgehen, Weltzustände
   ändern sich (z. B. Kolonie beim nächsten Besuch vom Swarm überrannt).
6. **Der Sprung:** Zum Fenster-Zeitpunkt springt die Crew. Flackern
   mehrere Tore im System, wählt der Spieler das Ziel →
   **Kampagnen-Verzweigung.**

**Details:** Fenster verpasst = Katastrophen-Mix (Ereignis-Kette macht
das System gefährlicher, der Orden rückt näher, Ressourcen zehren sich
auf). Rückkehr in Systeme nur, wenn die Story es vorsieht. Sternenkarte:
lineare Kette mit Verzweigungen, keine offene Karte. Countdown ist
transparent (exakte Tage) – der Druck entsteht aus den Entscheidungen,
nicht aus Regelunsicherheit.

---

## Taktik-Ebene

**Grid & Sichtlinie:** Rasterbewegung, Deckungssystem (leicht/voll),
Sichtlinien – geometrisches Modell: `combat.md`. Trefferauflösung,
Würfelpool, Schadensverrechnung: `dice-system.md`, `traits.md`.
Zerstörbare Deckung: Umfang noch offen.

### Aktivierungsmodell: Alternierende Aktivierungen

Inspiration: Kill Team & Halo Flashpoint. Ersetzt die klassische
XCOM-Struktur („erst mein ganzes Team, dann deins").

- Eine Runde besteht aus **abwechselnden Aktivierungen**: der Spieler
  aktiviert EINEN Soldaten (beide Aktionen), dann aktiviert der Swarm
  EINE Einheit, dann wieder der Spieler – bis alle einmal dran waren.
- **Schwache Gegner aktivieren als Gruppe** (z. B. zwei Nahkampf-Drohnen
  als eine „Einheit"), Elite-/Spezialgegner einzeln. So bleibt die
  Aktivierungszahl beider Seiten ausbalanciert, auch bei Gegnermassen.
- **Commitment:** Mit dem ersten Aktionspunkt ist der Soldat gebunden –
  seine Aktivierung muss abgeschlossen werden, bevor ein anderer handeln
  darf. Die Reihenfolge der eigenen Aktivierungen ist damit selbst eine
  taktische Entscheidung.
- **Passen:** Ein Soldat kann seine Aktivierung ungenutzt abgeben
  (behält dabei einen noch scharfen Overwatch aus der Vorrunde).
- **Rundenende:** Erst wenn alle Soldaten und alle Gegner-Einheiten
  aktiviert haben, endet die Runde – **dann** regenerieren die Schilde
  (+1), laufen Cooldowns ab und alle Aktivierungen werden frisch.
- **Pro Aktivierung: 2 Aktionen** (bewegen, schießen, Fähigkeit,
  Overwatch, Guarded-Haltung – siehe `dice-system.md`).
- **Overwatch:** Kostet die restliche Aktivierung. Ein Reaktionsschuss
  auf den ersten Gegner, der sich durch Sichtlinie und Reichweite
  bewegt; die Bewegung wird unterbrochen. Bleibt scharf, bis er feuert
  oder die Einheit erneut aktiviert. Schließt sich mit Guarded aus.
- **Verwundeter Kommandant:** entfällt – der Kommandant kämpft nie mit
  (siehe `crew.md`).
- **Missionskarten:** Story-Missionen handgebaut, Nebenmissionen
  prozedural generiert.

### Klassen & Fähigkeiten

5 feste Klassen (Breacher, Deadeye, Handler, Heavy, Reiver), volle
Beschreibung, Basiswerte und Trait-System: `classes.md`. Vollständige
Skill-Trees pro Klasse: `skills.md`.

### Ship im Gefecht

Ship ist in **jeder Mission** präsent, unabhängig von der Trupp-
Zusammensetzung – als **truppweite Fähigkeitsleiste**, kein Bodenkämpfer:

- Eigene kleine Leiste mit Unterstützungs-Fähigkeiten auf Cooldown –
  z. B. Sensor-Scan (deckt Gegner auf), Türen/Systeme hacken,
  Störimpuls (unterbricht gegnerische Fähigkeiten).
- Gespeist und erweitert durch den Ausbau von **Ships Kern**: Das Modul
  verbessert Strategisches (Fenster-Berechnung, Erinnerungsfragmente)
  *und* schaltet neue Gefechts-Fähigkeiten für die Leiste frei.
- Nebenbei ist Ship damit die Kommentarspur jeder Mission – der
  Galgenhumor kommt von oben.
- **Timing:** Ship darf seine Gefechts-Fähigkeiten **frei zwischen den
  Aktivierungen der Kämpfer** einsetzen, nicht gebunden an die
  Aktivierung eines bestimmten Kämpfers – nur durch die Cooldowns der
  jeweiligen Fähigkeit begrenzt.

### Roster & Progression

- **Wachsende Crew:** Im Spielverlauf werden mehrere Kämpfer pro Klasse
  rekrutiert – als Ersatz für Verwundete/Gefallene und für Aufstellungen
  mit doppelten Klassen.
- **Rang-Aufstiege mit Wahl:** Feste Klasse, aber bei jedem Aufstieg
  eine Entscheidung zwischen zwei Fähigkeiten (XCOM-Prinzip, linear pro
  Zweig – siehe `skills.md`) → zwei Kämpfer derselben Klasse können
  unterschiedlich gebaut sein. Aufstiege geben Fähigkeiten, kaum Werte.

### Kommando-Manöver-System

Der Kommandant (nie im Feld) wirkt über Strategie-/Taktik-Manöver auf
das Gefecht ein, finanziert durch Kommando-Punkte. Volle Mechanik:
`dice-system.md` Abschnitt „Kommando-Manöver-System".

### Offene Kern-Fragen

1. Volle Fähigkeits-Bäume pro Klasse über die Grundstruktur aus
   `skills.md` hinaus (weitere Rang-Aufstiege) – nach dem Prototyp.
2. Assimilations-Mechanik des Vector – zurückgestellt, siehe `classes.md`.

---

## Schadensmodell: Schild → Panzerung → HP

Drei Schichten, feste Verrechnungsreihenfolge:

1. **Energieschild (Shield):** Schluckt Schaden zuerst. **Regeneriert am
   Rundenende um genau 1 Punkt – bedingungslos**, egal ob die Einheit
   getroffen wurde. Wer in Deckung bleibt und dem Schild Zeit gibt,
   bleibt geschützt – fokussiertem Feuer hält ein Schild nicht lange
   stand.
2. **Panzerung (Armor):** Fester Wert je Kämpfer, reduziert den
   Restschaden. **Kann einen Treffer komplett abfangen – kein
   Mindestschaden.**
3. **HP:** Niedrig (Soldaten ~4–6) und wachsen kaum. Rang-Aufstiege geben
   Fähigkeiten, keine HP-Inflation.

**Wie die Schadenszahl selbst entsteht** (Netto-Erfolge aus dem
Würfelpool statt Zufallswurf, AP/SD/Lethal als Waffenprofil-Stellschrauben):
volle Mechanik in `dice-system.md` Abschnitt 6 und `traits.md` Abschnitt 0.
Aktuelle Basiswerte pro Klasse (Fernkampf/Nahkampf/Verteidigung/HP/
Panzerung): `classes.md` Abschnitt 8.

**Waffen-Archetypen (Design-Absicht):** **Schildbrecher** (hoher SD),
**Panzerknacker** (hoher AP) und **Präzisions-Killer** (hoher Lethal):
verheerend, wenn er durchkommt, aber von Schild und Panzerung leicht
abzuwehren.

**Warum dieses Modell:** Vier unabhängige Stellschrauben (Reichweite,
AP, SD, Lethal) geben Waffen- und Rüstungs-Upgrades, Buffs, Debuffs und
Fähigkeiten je eigene Hebel – Werkstatt-Progression über Schild-/
Panzerungs-Tiers statt HP-Balken. Kämpfer bleiben dauerhaft verletzlich
(„Gewalt hat Gewicht"), Verrechnung bleibt kopfrechenbar.

**Mechanik-Familie „Armor-Shred":** Kandidat für zukünftige Skills, die
Panzerung stärker als AP dauerhaft senken. Denkbare Erweiterungen:
Schild-Brecher (EMP/Ship-Fähigkeit), Waffen, die Schilde umgehen.

---

## Missionsumgebungen

1. **Tote Stationen & Wracks** – enge Korridore, Schleusen, Vakuum-
   Abschnitte. **Prototyp-Umgebung Nr. 1** – hier spielt auch Mission 1
   (Bergung des KI-Kerns).
2. **Überwucherte Kolonien** – Swarm-Biomasse, Nester, verlorene
   Siedlungen. Der Horror des Swarm wird sichtbar.
3. **Dominion-Städte & Kathedralschiffe** – Gotik im All: Prunk,
   Bürokratie-Paläste, Ordens-Festungen. Schauplatz der Menschen-Gegner.

*Offene Torwelten (Wüsten, Eis, fremde Vegetation) sind als spätere
Erweiterung vorgemerkt, nicht im Kern-Scope.*

---

## Strategische Ebene: Die Cold Comfort

- **Modul-System:** Kein Raum-Management à la XCOM, sondern
  freischaltbare und ausbaubare Module mit Synergien untereinander –
  z. B. schaltet das Forschungslabor Upgrades frei, die dann in der
  Werkstatt produziert werden.
- **Ökonomie – zwei Währungen:**
  1. **Credits** – universell, für Alltägliches (Ausrüstung, Vorräte,
     Rekruten, Bestechung).
  2. **Vor-Silence-Relikte (Pre-Silence Relics)** – geborgene alte
     Technik, selten, für Forschung und High-Tier-Upgrades. Ship stammt
     selbst aus der Vor-Silence-Zeit und ist der Einzige, der Relikte
     identifizieren kann; manche Relikte lösen Ships Erinnerungs-
     fragmente aus. Die Crew macht damit genau das, was das Dominion
     unter der Artefakt-Doktrin heimlich tut (siehe `setting.md`) – nur
     ehrlicher.
- **Rekrutierung:** An Zufluchtsorten (Ringfolk-Häfen etc.) *und* als
  Missions-Belohnung (Befreite, Überläufer).

**Noch offen:** Fraktions-Reputation (beschlossen, dass es sie gibt –
Ausgestaltung offen, siehe `roadmap.md` Phase 4).

### Die Module

Jedes Modul hat 3 Ausbaustufen. Start: Medbay + Werkstatt auf Stufe 1,
Rest wird im Kampagnenverlauf freigeschaltet.

1. **Krankenstation (Medbay)** – verkürzt Ausfallzeiten (Tage!). Direktes
   Gegenstück zum Wund-System und zum Flacker-Timer.
2. **Werkstatt (Workshop)** – produziert Ausrüstung nach Bauplänen aus
   dem Labor; Ausbau = höhere Stufen, schnellere Produktion. Schild- und
   Panzerungs-Tiers, Waffen mit AP-/SD-/Lethal-Profilen.
3. **Forschungslabor (Lab)** – erforscht Swarm-Proben, Relikte, Torwissen;
   liefert Baupläne. Story-Pfad zur Vector-Klasse. Voraussetzung für
   Xenobiologist-Spezialisierungs-Projekte (`traits.md`).
4. **Ships Kern (Ship's Core)** – Relikte direkt in Ship investieren:
   bessere Fenster-Berechnung, Erinnerungsfragmente entschlüsseln, neue
   Fähigkeiten für Ships truppweite Gefechtsleiste. Voraussetzung für
   Relic-Keeper-Spezialisierungs-Projekte.
5. **Quartiere (Quarters)** – Roster-Größe; ausgebaut: Training für
   Reservisten.
6. **Frachtraum & Schmuggelversteck (Hold)** – mehr Beute, bessere
   Schwarzmarktpreise, verbirgt Ship bei Kontrollen (Event-Material).
7. **Hangar** – Landungs-Shuttles (ISS-Vanguard-Prinzip): kurze,
   entscheidungsbasierte Landungssequenz. Shuttle-Qualität/-Ausbau wirkt
   in die Mission (Kapazität = mehr Beute, Bewaffnung = Gegner vorab
   schwächen, schlechte Wartung = Crew startet mit weniger HP/Ausrüstung).
8. **Brücke (Bridge)** – Interface-Hub (Missionswahl, Story, Sternenkarte,
   Handel) *und* ausbaubares Intel-Modul: mehr Missions-Vorabinfos,
   bessere Handelspreise, Fraktions-Kommunikation.

**Schiffswerte statt Weltraumkampf:** Bewaffnung und Panzerung der Cold
Comfort sind Ausbau-Werte, die in skriptete Ereignis-Sequenzen einfließen
(Blockaden, Abfangjäger, Überfälle). **Kein eigenes Schiffskampf-System**
– zu großer Scope.

---

## Produktions-Leitplanken

- Hobby-Projekt, kein Zeitdruck, Lernziel: Vibe-Coding.
- Assets: freie Bibliotheken (Kenney, Quaternius, Poly Pizza), ggf. Synty.
  Kein eigenes 3D-Modelling durch Claude – Details/Quellen: `roadmap.md`.
- Claude schreibt: Code, Shader, UI, Daten, Texte, einfache SVG-Icons.
- Scope-Disziplin: Erst vertikaler Prototyp (eine Karte, ein Trupp,
  ein Gegnertyp), dann erweitern.

## Roadmap

Aktuelle Gesamt-Roadmap (Phasen, Asset-Quellen, Steam-Ziel): `roadmap.md`.
Detaillierter Meilenstein-/Schrittplan für den nächsten Bauabschnitt
(Würfelpool-Umbau): `prototype-plan.md`.
