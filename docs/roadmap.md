# COLD COMFORT – Gesamt-Roadmap (v1.0)

> Stand: 2026-08-28. Erste Gesamt-Roadmap nach Umstieg auf lokales
> Claude Code (Desktop-App, Code-Tab). Baut auf `setting.md`, `crew.md`,
> `gdd.md` und `combat.md` auf. Ziel dieses Dokuments: die grobe Kette
> der Milestones von „laufender Kampf-Prototyp" bis „Steam-Release"
> festzuhalten. **Die einzelnen Milestones werden danach nacheinander
> im Detail ausgearbeitet** (eigene Arbeits-Sessions) – dieses Dokument
> bleibt bewusst auf grober Flughöhe.
>
> Format: Jeder Milestone hat einen Zweck, grobe Inhalte, und – wo
> relevant – **offene Entscheidungen**, die beim Ausarbeiten getroffen
> werden müssen. Bereits von Kamil getroffene Grundsatzentscheidungen
> sind mit ✅ markiert.

## Kamils Grundsatzentscheidungen (2026-08-28)

Diese vier Entscheidungen prägen die ganze Roadmap:

1. ✅ **Umfang:** Mittleres Kampagnenziel – **8–10 System-Kapitel**,
   grobe Spielzeit 20–30 Stunden.
2. ✅ **Story-Format:** Textbasierte Dialogszenen mit Charakterportraits
   (Visual-Novel-Stil) zwischen den Einsätzen.
3. ✅ **Kampfsystem:** **Größerer Umbau Richtung Würfelpool**,
   Halo-Flashpoint-inspiriert – ersetzt das aktuell implementierte
   Prozent-Trefferchancen-System (nicht nur punktuelle Akzente).
4. ✅ **Zielplattform:** **Steam-Veröffentlichung** angestrebt (nicht nur
   privates Hobby-Ziel) – das bringt zusätzliche Milestones für
   Store-Page, Achievements, Testing.

---

## Phase 0 – Fundament (erledigt)

Konzept, Setting, Charaktere und ein spielbarer Taktik-Prototyp stehen:

- Setting, Fraktionen, Story-Rahmen (`setting.md`), Startquartett +
  Kommandant (`crew.md`), Kernmechaniken (`gdd.md`).
- Godot-4-Prototyp: Rasterbewegung, Deckung/Sichtlinie, alternierende
  Aktivierungen (Kill-Team-Prinzip), Schadensmodell Schild→Panzerung→HP,
  Overwatch, vier Fähigkeiten, 4 Soldaten vs. 4 Drohnen + 2 Spitter,
  automatisierte Tests (`game/tests/`).

Das ist die Ausgangsbasis für alles Folgende.

---

## Phase 1 – Werkzeug-Umzug (läuft gerade)

Zweck: Von Cowork (Cloud-Sandbox + Geräte-Brücke) auf lokales Claude
Code im Desktop-App-Code-Tab umsteigen, um Token-Overhead zu sparen und
direkt auf Kamils PC zu arbeiten.

- Projekt-Dokumente liegen ab sofort unter `docs/` auf dem PC (dieses
  Dokument eingeschlossen) statt nur im claude.ai-Projekt. Bereinigter,
  aktueller Dokumentensatz: siehe `README.md` in diesem Ordner.
- Git for Windows installieren (Voraussetzung für den Code-Tab).
- Technische Konventionen/Codebase-Stand für Claude Code:
  `tech-reference.md` (ersetzt das alte `handover.md`).
- Optional, aber empfohlen: eine `CLAUDE.md` im Projekt-Root anlegen,
  die auf `docs/` verweist und die wichtigsten Konventionen kurz
  zusammenfasst – dann liest jede lokale Code-Tab-Session sie automatisch.

**Offene Entscheidung:** Soll das Projekt zusätzlich ein Git-Repository
werden (Commits, evtl. später GitHub für Backups/Versionshistorie)? Der
Code-Tab nutzt Git ohnehin intern für Sitzungs-Isolation (Worktrees) –
ein „richtiges" Repo mit eigenen Commits ist trotzdem Kamils Entscheidung
und kommt in einer der nächsten Sessions dran.

---

## Phase 2 – Kampfsystem-Neuausrichtung: Würfelpool ✅ Design abgeschlossen

**Zweck:** Das Kernkampfsystem auf Würfelpool-Mechanik (d10,
Halo-Flashpoint-/Kill-Team-inspiriert) umstellen, BEVOR weitere Inhalte
(mehr Klassen, mehr Gegner, mehr Karten) auf dem alten Prozentsystem
aufgebaut werden.

**Design-Stand:** Das komplette Würfelsystem ist fertig entschieden –
siehe `dice-system.md` (Basis-Pool, Deckung, Charge, Zone of Control,
Flanking, Kritische Treffer, Schadensmodell, Verticality, Guarded/Engaged,
Kommando-Manöver-System) und `traits.md` (Waffenprofil AP/SD/Lethal,
Waffen-/Ausrüstungs-/Charakter-Traits, Pinned-Status). **Noch nicht
implementiert** – das ist der nächste konkrete Bauabschnitt, siehe
`prototype-plan.md` für den Meilenstein-/Schrittplan und fertige Claude-
Code-Prompts.

### Umsetzungsschritte (grob – Details in `prototype-plan.md`)

1. `combat.gd` und die zugehörigen Tests (`tests/test_combat.gd`,
   `tests/test_damage.gd`, `tests/test_los3.gd`) auf das Würfelpool-Modell
   umschreiben.
2. Neue Werte-Tabelle nach `classes.md` Abschnitt 8 (5 Klassen) statt der
   alten Kane/Roan/Okafor/Reyes-Werte einsetzen.
3. Mehrere Fuzz-Testläufe (`tests/test_fuzz.gd`) zur Absicherung.
4. Kamil spielt den umgebauten Prototyp gegen, bevor weitere Klassen/
   Gegner darauf aufbauen.

**Offen:** genaue Zahlenwerte für Cooldowns, Trait-Boni und
Kommando-Punkt-Ökonomie – Playtesting-Feinschliff nach dem Umbau.

---

## Phase 3 – Taktik-Ebene fertigstellen

**Zweck:** Das Gefecht selbst auf den vollen Kern-Umfang bringen, auf
Basis des neuen Würfelsystems aus Phase 2.

- **Gegner-KI:** Spitter nutzen Deckung aktiv, Drohnen flankieren statt
  nur geradewegs anzugreifen (bereits in gdd.md als nächster Schritt
  vorgesehen).
- **Alle 5 Klassen** aus `classes.md`/`skills.md` umsetzen (Breacher,
  Deadeye, Handler, Heavy, Reiver) – der Silencer nutzt mechanisch eine
  bestehende Klasse (Story-Moment früh in Akt 1, siehe `crew.md`) statt
  eine eigene zu sein. Vector bleibt zurückgestellt.
- **Zerstörbare Deckung** (aktuell „Umfang offen") – naheliegend jetzt
  zu entscheiden, da Breachers Breach Charge und Heavys Sprengstoff-Zweig
  direkt davon abhängen.
- **Missionsziele/Zieltypen** über „alle Gegner ausschalten" hinaus:
  Extraktion, Konsole hacken/verteidigen, Zeitlimit-Missionen (passend
  zum Flacker-Timer-Thema – „das Fenster schließt sich" als Missions-
  Uhr, inspiriert von zeitkritischen XCOM-2-Missionen).
- **Stretch/optional:** Vertikalität (Ebenen, Klettern) – Halo Flashpoint
  nutzt ein 3D-Würfel-Rastersystem für Höhenunterschiede. Das wäre ein
  spürbarer Zusatzaufwand (Kamera, Pfadfindung, Sichtlinien in 3D); als
  spätere Erweiterung vormerken, nicht Teil des Kern-Umfangs.

**Inspiration aus anderen Genrevertretern (Empfehlung für diese Phase):**

| Spiel | Idee | Warum es zu Cold Comfort passt |
|---|---|---|
| XCOM 2 | Zeitlimit-Missionen, Concealment/Stealth-Start | Passt zum Flacker-Timer-Thema; die Reiver-Klasse (siehe classes.md) profitiert direkt von Stealth-Start |
| Mutant Year Zero | Hinterhalt-Phase vor offenem Kampf (isolierte Gegner lautlos ausschalten) | Passt zum Reiver & zu Dominion-/Orden-Patrouillen-Encountern |
| Phoenix Point | Gezielte Trefferzonen (z. B. Waffe/Panzerung eines Gegners gezielt zerstören) | Erweitert die bereits geplante „Armor-Shred"-Mechanikfamilie aus gdd.md |
| Gears Tactics | Exekutionen an niedergestreckten Gegnern für Tempo-Bonus | Lässt sich mit dem Wund-statt-Tod-System verzahnen (Gnadenstoß als Entscheidung, nicht Automatik) |
| Jagged Alliance 3 / Xenonauts 2 | Team-Chemie-Boni zwischen bestimmten Figuren | Passt zu crew.md („eigene Haltung zu Ship" & Beziehungen untereinander) – z. B. Bonus, wenn zwei bestimmte Pool-Rekruten zusammen agieren |

**Offene Entscheidung:** Welche dieser Ideen wirklich aufgenommen werden,
wird beim Ausarbeiten dieser Phase entschieden – hier nur als Angebot
gelistet.

---

## Phase 4 – Strategische Ebene: Schiff & Crew-Management

**Zweck:** Die in gdd.md bereits beschlossenen Module (Medbay, Werkstatt,
Lab, Ships Kern, Quartiere, Hold, Hangar, Brücke) tatsächlich bauen,
inklusive Wund-/Permadeath-System mit konkreten Zahlen.

- Wundstufen, Ausfalltage, Permadeath-Wahrscheinlichkeit konkret
  festlegen (aktuell offene Detailfrage in gdd.md).
- Ressourcen-Ökonomie: Credits & Pre-Silence Relics, Modul-Ausbaustufen,
  Werkstatt-Produktion.
- Fraktions-Reputation ausgestalten (Dominion, Houses, Ringfolk, Echo,
  Order of Silence) – aktuell nur „dass es sie gibt" beschlossen.

**Inspiration aus anderen Spielen (Empfehlung):**

| Spiel | Idee | Warum es passt |
|---|---|---|
| Battletech (2018) | Söldnertruppen-Management, Schiffs-Ausbau (Argo), Verträge unter Zeit-/Budgetdruck, Piloten-Verletzungen mit Genesungstagen | Der bislang engste Vergleich zu Cold Comforts Ship-Modul-System + Flacker-Timer + Wund-System – als strategische Hauptreferenz empfohlen |
| FTL: Faster Than Light | Zufalls-Events während der Reise, Schiffssysteme mit Schaden/Reparatur, Crew an Stationen zuweisen | Könnte „Reise-Ereignisse" *innerhalb* eines System-Kapitels liefern (nicht nur die Missionsliste), im selben Dialog-Format wie die Story (Phase 6) |
| Wasteland 3 | Fraktionsreputation schaltet Missionen/Preise/Verbündete frei, Begleiter-Entscheidungen mit dauerhaften Folgen | Direktes Vorbild für die offene Fraktions-Reputations-Frage |
| Star Traders: Frontiers | Nicht-Kampf-Begegnungen als Skill-Checks statt immer volle Gefechte | Günstige Möglichkeit, Abwechslung in Fringe-/Ringfolk-Begegnungen zu bringen, ohne neue Kampfinhalte bauen zu müssen |

**Offene Entscheidungen:** konkrete Wundzahlen, Ausgestaltung der
Fraktions-Reputation (nur Ansehen oder auch Preise/verfügbare Missionen?),
Ships Gefechts-Fähigkeiten (siehe Phase 2 – Command-Point-Lösung?).

---

## Phase 5 – Kampagnenstruktur: System-Kapitel & Sternenkarte

**Zweck:** Die in gdd.md beschlossene System-Kapitel-Struktur (Ankunft →
Missionspool → Flacker-Timer → Entscheidung → Sprung) tatsächlich als
Spielschleife bauen, für **8–10 System-Kapitel** (Kamils Umfangs-
Entscheidung).

- Sternenkarte als lineare Kette mit Verzweigungen (kein offenes
  Sternennetz, wie in gdd.md festgelegt).
- Missionspool-Generierung pro System (Story-Missionen handgebaut,
  Nebenmissionen prozedural, siehe gdd.md).
- Konsequenz-System für verpasste Flacker-Fenster.
- Grobe Content-Rechnung für 8–10 Kapitel: pro Kapitel realistisch
  3–5 Missionen (Story + Fraktionsaufträge + optional) plus 1–2
  Reise-Ereignisse (siehe FTL-Idee aus Phase 4) – das ergibt die
  ungefähre Mission-/Content-Stückzahl für Phase 7.

**Offene Entscheidung:** Wie viele Systeme sind reine „Content"-Systeme
(prozedural, austauschbar) vs. handgebaute Story-Systeme? Ein grobes
Verhältnis (z. B. 6 Story-Kapitel + 2–4 Zwischenstationen) hilft, den
Content-Aufwand für Phase 7 realistisch zu planen.

---

## Phase 6 – Story & Dialogsystem

**Zweck:** Die Geschichte zwischen den Einsätzen erzählen – **textbasiert
mit Charakterportraits** (Kamils Entscheidung).

- **Dialog-Engine:** Textboxen, Charakterportraits, Entscheidungsoptionen,
  Verzweigungen. Technisch überschaubar in Godot (Dialogic- oder
  Eigenbau-Lösung – Abwägung beim Ausarbeiten dieser Phase).
- **Portrait-Kunststil festlegen** (siehe offene Entscheidung unten) –
  hat direkten Einfluss auf Asset-/Werkzeugwahl.
- Akt-1-Story ausarbeiten: Eröffnung (Mission 1, bereits in setting.md
  beschrieben), Silencer-Überläufer-Kapitel, erste Ships-Erinnerungs-
  fragmente.
- Bord-Banter-System: wie viel Dialog zwischen Missionen (offene Frage
  aus `crew.md`).
- Vector-Konzept: komplett zurückgestellt, inkl. der Grundfrage, ob die
  Klasse überhaupt ins Spiel kommt (siehe `classes.md`).

**Offene Entscheidung – Portrait-Kunststil:** Cold Comfort ist als 3D-
Low-Poly-Spiel geplant; für Dialogportraits gibt es mehrere Optionen,
die unterschiedlich viel Zusatzaufwand bedeuten:

- Stilisierte Renders der 3D-Low-Poly-Modelle selbst (konsistent mit dem
  Spiel, aber Low-Poly-Gesichter sind für Nahaufnahmen oft zu grob).
- Eigene 2D-Illustrationen/Portraits in einem separaten Kunststil
  (mehr visuelle Tiefe, aber Stilbruch zum 3D-Spiel und braucht eine
  Kunst-Pipeline, die es aktuell nicht gibt).
- KI-generierte Portraits in einem festgelegten, konsistenten Stil.
- Rein textbasiert ganz ohne Portraits, nur Namen + Farbcodierung
  (minimaler Aufwand, aber weniger Charakter-Präsenz).

Diese Entscheidung sollte getroffen werden, sobald diese Phase im Detail
ausgearbeitet wird.

---

## Phase 7 – Content-Fülle

**Zweck:** Genug Inhalt für 8–10 System-Kapitel produzieren.

- Missionskarten (handgebaut für Story-Kapitel, prozedural für
  Nebenmissionen/Zwischenstationen).
- Gegnervarianten: menschliche Gegner (Dominion-Truppen, Order-of-
  Silence-Einheiten) als Pendant zu den Swarm-Gegnern.
- Fraktions-Encounter für Houses, Ringfolk, Echo.
- Roster-Wachstum & Rang-Aufstiege (aus gdd.md).
- Vollständige Fähigkeits-Bäume pro Klasse (Rang-Aufstiege mit Wahl,
  siehe gdd.md offene Kern-Frage 1).

---

## Phase 8 – Politur & Zugänglichkeit

**Zweck:** Aus „Inhalt vorhanden" ein rundes, spielbares Gesamtprodukt
machen.

- Audio: Musik, Soundeffekte, Ships Sprachausgabe (optional – zumindest
  Textausgabe mit gutem Sounddesign).
- VFX-Politur (Treffer, Explosionen, Umgebungsdetails).
- Tutorial/Onboarding für neue Spieler (bei Steam-Ziel besonders
  wichtig – Kamil kennt das Spiel, neue Spieler nicht).
- Gesamt-Balancing-Pass über Taktik- und Strategie-Ebene zusammen.
- Optionsmenü (Grafik, Steuerung, Lautstärke), Speichersystem (Kampagne
  UND Gefechtsstand müssen sauber speicherbar sein).
- Controller-Unterstützung (durch Steam-Ziel relevant).

---

## Phase 9 – Steam-Release-Vorbereitung

**Zweck:** Vom fertigen Spiel zur Veröffentlichung (Kamils Steam-Ziel).

- Steam-Store-Page (Beschreibung, Screenshots, Trailer).
- Achievements definieren und einbauen.
- Community-/Freundes-Playtesting vor Launch, Feedback einarbeiten.
- Preisgestaltung, Veröffentlichungsplan, Steamworks-Einrichtung/
  Zertifizierungsanforderungen prüfen.
- Lokalisierung prüfen: Lead-Sprache ist laut gdd.md Englisch, deutsche
  Lokalisierung „später" vorgesehen – Umfang für Release-Zeitpunkt hier
  festlegen.

---

## Freie Low-Poly-Asset-Quellen (Sci-Fi/Grimdark passend)

Für den 3D-Low-Poly-Look ohne eigenes Modelling (Produktions-Leitplanke
aus gdd.md). Alle Links Stand 2026-08-28 geprüft.

**Kostenlos:**

- **[Kenney.nl](https://kenney.nl/)** – CC0 (gemeinfrei, keine
  Namensnennung nötig, uneingeschränkt kommerziell nutzbar – wichtig
  fürs Steam-Ziel). Direkt passende Packs: [Space Kit](https://kenney.nl/assets/space-kit),
  [Space Station Kit](https://kenney.nl/assets/space-station-kit),
  [Modular Space Kit](https://kenney.nl/assets/modular-space-kit).
  Erste Anlaufstelle – deckt Stationen/Wracks (Missionsumgebung 1) gut ab.
- **[Quaternius](https://quaternius.com/)** – ebenfalls kostenlos, u. a.
  ein [Spaceships Pack](https://quaternius.com/packs/spaceships.html).
  Charaktere und Requisiten in konsistentem Low-Poly-Stil.
- **[Poly Pizza](https://poly.pizza/)** – durchsuchbarer Aggregator, der
  u. a. Quaternius-Modelle bündelt; hat auch fertige
  [Asset-Bundles](https://poly.pizza/bundles). Guter Ausgangspunkt, um
  schnell mehrere Quellen gleichzeitig zu durchsuchen.
- **[OpenGameArt.org](https://opengameart.org/)** – gemischte Lizenzen
  (CC0 und CC-BY, **Lizenz pro Asset prüfen**, CC-BY braucht
  Namensnennung im Abspann). Nützlich für Lückenfüller: [Modular Space
  Kit](https://opengameart.org/content/lowpoly-modular-sci-fi-environments),
  [CC0 3D-Waffen](https://opengameart.org/content/cc0-3d-weapons),
  [CC0 3D-Gebäude](https://opengameart.org/content/cc0-3d-buildings).
- **[itch.io – Tag „low-poly" + „science fiction"](https://itch.io/game-assets/tag-low-poly/tag-science-fiction)**
  – viele kostenlose und Pay-what-you-want-Packs; Lizenz ist von Autor
  zu Autor unterschiedlich, immer die Store-Seite genau lesen (manche
  Packs sind nur für nicht-kommerzielle Projekte freigegeben – bei
  Steam-Ziel relevant).
- **Sketchfab** – nach „Downloadable" + CC0/CC-Lizenz filtern; riesige
  Auswahl, aber Qualität und Poly-Stil schwanken stark. Eher für
  einzelne Hero-Props als für ganze Kits.

**Kostenpflichtig, aber einen Blick wert (konsistenter „AAA-Indie"-
Low-Poly-Stil, gerade wichtig bei Steam-Ambitionen):**

- **[Synty Studios – POLYGON-Reihe](https://syntystore.com/)**, u. a.
  [Sci-Fi Space Pack](https://syntystore.com/products/polygon-sci-fi-space-pack),
  [Sci-Fi Worlds](https://syntystore.com/products/polygon-sci-fi-worlds),
  [Sci-Fi Horror](https://syntystore.com/products/polygon-sci-fi-horror),
  [Sci-Fi City](https://syntystore.com/products/polygon-sci-fi-city).
  Industriestandard für konsistenten Low-Poly-Look, ca. 10–500 $ pro
  Pack je nach Umfang. **Update (2026-08-30):** Synty hat mittlerweile
  eine **eigene [Godot-Kollektion mit 22 Packs](https://syntystore.com/collections/godot-asset-packs)**
  – der alte Hinweis „kein natives Godot-Paket" ist damit überholt,
  FBX-Import bleibt aber ohnehin als Fallback zuverlässig.
  **Ergänzung (2026-08-30) – Unity/Unreal-only-Packs in Godot nutzen?**
  Ja, technisch möglich, auch bei Packs, die nur als „Unity" oder
  „Unreal" markiert sind – Synty bestätigt das selbst in ihrer
  [FAQ](https://syntystore.com/community/faq): „it is technically
  possible to use some of our assets within other engines, such as
  Godot", offizieller Support gilt aber nur für Unity/Unreal. Die
  Packs enthalten FBX-Dateien (plus MaterialList-Textdokumente, die
  Meshes den Texturen zuordnen), die sich grundsätzlich in Godot 4
  importieren lassen – die eigentliche Arbeit ist der Material-/
  Shader-Nachbau, da Synty eigene (teils Triplanar-)Shader nutzt, die
  Godot nicht automatisch versteht. Zwei Community-Tools nehmen einem
  das ab: [synty-in-godot](https://github.com/tctimmeh/synty-in-godot)
  (Export-Workflow über Unity + Godot-Importskripte, getestet mit
  Godot 4.2) und [synty-godot-converter](https://github.com/DeniedWorks/synty-godot-converter)
  (wandelt `.unitypackage`-Dateien direkt inkl. sieben nachgebauter
  Synty-Shader für Godot 4.6 um). Fazit: machbar, aber mit
  Einrichtungsaufwand – für den ersten Prototyp lohnt sich das eher
  nicht, für später ausgewählte Hero-Assets aus Unity/Unreal-only-Packs
  schon.

**Wichtig fürs Steam-Ziel:** Lizenzbedingungen jedes verwendeten Assets
dokumentieren (z. B. eine `docs/asset-lizenzen.md` anlegen, sobald die
ersten Assets eingebaut werden) – ein Store-Release erfordert saubere
Nachweise, dass alle verwendeten Inhalte kommerziell nutzbar sind.

### Animierte Charaktere – Antwort auf Kamils Frage (2026-08-30): „echte Figuren statt schwebende Pillen"

**Ja, es gibt fertige Bibliotheken mit richtigen, animierten Figuren –
kein eigenes 3D-Modelling nötig, wie in den Produktions-Leitplanken
ohnehin schon festgelegt.** Drei Bausteine, die zusammenspielen:

1. **Charaktere (die Meshes selbst):**
   - [Kenney Character Assets](https://kenney.itch.io/kenney-character-assets)
     – CC0, modulare Basis-Humanoide (eher generischer Toon-Stil als
     hart Sci-Fi, aber kostenlos und rigged).
   - Quaternius' Charakterpacks (u. a. Military/Sci-Fi-Themen,
     [quaternius.com](https://quaternius.com/)) – CC0, passt zum bereits
     genutzten Quaternius-Stil aus dem Umgebungs-Kit.
   - Synty POLYGON-Charaktere (z. B. „Sidekick"-Modularcharaktere,
     Military/Sci-Fi-Packs) – kostenpflichtig, dafür deutlich
     konsistenterer, professionellerer Look über alle 5 Klassen hinweg.
2. **Animationen (Laufen, Schießen, Nahkampf, Treffer, Tod etc.):**
   - **Empfehlung: [Quaternius' „Universal Animation Library"](https://store.godotengine.org/asset/quaternius/universal-animation-library/)**
     – CC0, **120+ Animationen** (Laufen in 8 Richtungen, Nahkampf,
     Emotes, Kriechen, Schwimmen, Sterben), explizit für Godot gebaut
     (kompatibel Godot 3.0–4.8, direkt mit `AnimationTree` nutzbar) und
     über Godots Bone-Mapping auf **beliebige** humanoide Meshes
     retargetbar – deckt praktisch den kompletten Animationsbedarf für
     den Prototyp ab (Bewegung, Sturmangriff-Lunge, Guarded-Hockstellung
     lässt sich aus vorhandenen Crouch/Cover-Clips ableiten, Pinned aus
     einer Death/Knockdown-Pose zweckentfremden).
   - **Mixamo** (Adobes Auto-Rigging/Animations-Tool) ist weiterhin
     kostenlos nutzbar, aber laut aktueller Recherche mit
     **Lizenz-Unsicherheit behaftet** – Adobe hat die Anbindung an
     Creative-Cloud-Abos seit 2024 verschärft und keinen offiziellen
     Fortbestandsplan kommuniziert. Als schnelle Ergänzung/Notlösung
     okay, aber NICHT als alleinige Abhängigkeit fürs finale Spiel
     empfohlen – Quaternius' CC0-Bibliothek ist die robustere Wahl.
3. **Zusammenbau:** Ein Kenney-/Quaternius-Charakter-Mesh + die
   Universal Animation Library, in Godot über `AnimationTree` und
   Skeleton-Retargeting verbunden – Standard-Workflow, den Claude Code
   morgen direkt beim Aufsetzen mit umsetzen kann.

**Alternative/Ergänzung – KI-generierte 3D-Modelle:** Tools wie
[Meshy.ai](https://www.meshy.ai/) erzeugen aus Text-/Bildvorgaben
komplette, **automatisch geriggte** 3D-Charaktere inkl. 500+
Preset-Animationen und Export direkt als FBX/GLB für Godot (~20 $/Monat
Pro-Tier, kostenlose Stufe vorhanden) – interessant, falls die 5
Klassen später eine eigene, unverwechselbare Silhouette statt
generischer Kit-Charaktere bekommen sollen. Für den ersten Prototyp
aber vermutlich nicht nötig; die fertigen Bibliotheken oben reichen.

**Kann Claude (Code) selbst 3D-Modelle erstellen? Ehrliche Antwort:
nein, nicht im Sinne von gesculpteten, detaillierten Charaktermodellen.**
Was Claude Code stattdessen leisten kann:
- **Prozedurale/geometrische Meshes per Code** (Godots `CSGShape3D`
  oder ein Blender-Python-Skript) – funktioniert gut für einfache
  Blockout-Formen, Kisten, simple Waffenformen, Platzhalter-Geometrie,
  aber nicht für organische, animierte Figuren.
- **Import- und Verdrahtungs-Code**: FBX/GLB-Import, Skeleton-Retargeting,
  `AnimationTree`-Setup, Shader, Materialien – das eigentliche
  Godot-seitige Handwerk, und genau das, was morgen beim Aufsetzen
  gebraucht wird.
- **Einfache 2D-Inhalte direkt**: SVG-Icons, UI-Layouts, Shader-Code
  (bereits in den Produktions-Leitplanken aus `gdd.md` als
  Claude-Zuständigkeit festgehalten).
- **Integrations-Code für externe KI-Tools** (z. B. Meshy-API), falls
  gewünscht – die eigentliche 3D-Generierung übernimmt dann der externe
  Dienst, nicht Claude selbst.

### Asset-Kategorien für den Prototyp – Übersicht (2026-08-30)

| Kategorie | Beispiele | Quelle |
|---|---|---|
| **Charaktere + Animationen** | 5 Klassen (Platzhalter-Look reicht fürs Erste), 1–2 Swarm-Gegnertypen | Kenney/Quaternius-Mesh + Quaternius Universal Animation Library |
| **Waffen (Props)** | Schrotflinte, Scharfschützengewehr, Sturmgewehr, Nahkampfklinge, Granate | Kenney Weapon Pack, Synty-Waffenpacks, oder simple Platzhaltergeometrie |
| **Umgebung/Tilesets** | Korridore, Schleusen, Deckungsobjekte (Kisten, Konsolen) | Kenney Space/Space-Station/Modular-Space-Kit (bereits identifiziert) |
| **UI/Menüs** | HUD (HP/Schild/Panzerung/AP-Anzeige), Skill-Icons, Hauptmenü, Font | Claude schreibt UI/SVG-Icons direkt; Font z. B. über Google Fonts |
| **VFX** | Mündungsfeuer, Explosionen, Schild-Treffer-Schimmer, Trefferfunken | Godot-eigene `GPUParticles3D`, per Code von Claude aufsetzbar; Texturen ggf. Kenney/OpenGameArt |
| **Sound/Musik** | Schüsse, Explosionen, Schritte, UI-Klicks, Ambient, Musik | Kenney Audio-Pack, freesound.org (Lizenz prüfen), OpenGameArt – **Claude kann keine Audiodateien selbst erzeugen**, nur Code zum Abspielen/Einbinden |

---

## Reihenfolge im Überblick

```
Phase 0  Fundament                         ✅ erledigt
Phase 1  Werkzeug-Umzug                    ← läuft gerade
Phase 2  Kampfsystem-Neuausrichtung (Würfelpool)
Phase 3  Taktik-Ebene fertigstellen
Phase 4  Strategische Ebene (Schiff/Crew)
Phase 5  Kampagnenstruktur (System-Kapitel)
Phase 6  Story & Dialogsystem
Phase 7  Content-Fülle
Phase 8  Politur & Zugänglichkeit
Phase 9  Steam-Release-Vorbereitung
```

Phasen 4–6 könnten teilweise parallel/verschränkt ausgearbeitet werden
(z. B. Dialogsystem aus Phase 6 wird auch für Reise-Ereignisse in
Phase 4 gebraucht) – das wird beim Ausarbeiten der jeweiligen Phase neu
bewertet, diese Liste ist die grobe, nicht zwingend strikt serielle
Reihenfolge.

## Nächster Schritt

Werkzeug-Umzug (Phase 1) und Würfelpool-Design (Phase 2) sind
abgeschlossen. Nächster Schritt: **Phase 2 implementieren** – der
Meilenstein-/Schrittplan dafür inkl. fertiger Claude-Code-Prompts steht
in `prototype-plan.md`.
