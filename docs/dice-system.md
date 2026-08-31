# COLD COMFORT – Würfelsystem (d10, Halo-Flashpoint- & Kill-Team-inspiriert)

> Aktuelle, finale Kampfmechanik – ersetzt das alte Prozent-System aus
> der ersten Prototyp-Version. Noch nicht implementiert (nächster
> Meilenstein, siehe `prototype-plan.md`), noch nicht final ausbalanciert
> (Zahlen sind Diskussionsgrundlage für Phase-2/3-Playtesting, sofern
> nicht ausdrücklich als fix markiert). Waffenprofile/Traits: `traits.md`.
> Klassen/Skills, die auf diesen Mechanismen aufbauen: `classes.md`,
> `skills.md`.

## 1. Grundprinzipien

- **Würfel:** d10. **Erfolgsprinzip: unterboten** – ein Kämpfer-Wert von
  8 bedeutet „Erfolg bei 8 oder niedriger gewürfelt".
- **Drei getrennte Stat-Werte** pro Kämpfer (1–10): Fernkampf, Nahkampf,
  Verteidigung. Basiswerte pro Klasse: `classes.md` Abschnitt 8.
- **Bewegung:** einheitlich 6 Felder für alle Klassen. Varianz kommt über
  Skills/Ausrüstung, nicht über einen Basiswert.
- **Sprint/Dash:** zweite Aktion kann als Dash (+3 Felder) genutzt werden
  – bis zu 9 Felder Gesamtbewegung, wenn beide Aktionspunkte investiert
  werden.
- **Aktionsökonomie:** 2 Aktionen pro Aktivierung. Dieselbe Aktion nicht
  zweimal in derselben Aktivierung (kein Doppel-Bewegen, kein
  Doppel-Schießen) – außer eine Fähigkeit erlaubt das explizit.
- **Natürliche 10 = automatischer Fehlschlag**, pro Würfel (nicht pro
  ganzer Probe) – die übrigen Würfel im Pool werten normal weiter.

## 2. Basis-Pool & Deckung (Fernkampf)

Fernkampf und Nahkampf laufen über denselben **Basis-Angriffspool von 3
Würfeln**, auf den situativ Bonuswürfel dazukommen.

| Deckung des Ziels | Bonuswürfel | Gesamtpool |
|---|---:|---:|
| Keine (flankiert) | +2 | 5 |
| Leichte Deckung | +1 | 4 |
| Volle Deckung | +0 | 3 |

Geometrische Erkennung von Deckung/Sichtlinie: `combat.md`.

## 3. Nahkampf: Charge, Zone of Control, Flanking

- **Zone of Control (ZoC):** Jeder Kämpfer kontrolliert seine direkt
  angrenzenden Felder. Ein Kämpfer ist **„Locked In"**, solange er sich
  im ZoC mindestens eines Gegners befindet – rein räumlicher Zustand,
  jede Runde neu aus der Position abgelesen.
- **ZoC-Gegenangriff:** Verlässt eine Einheit freiwillig ein Feld in
  gegnerischer ZoC, kassiert sie dafür einen **kostenlosen
  Nahkampfangriff** dieses Gegners mit dessen normalem
  **3-Würfel-Basispool** (kein Charge-Bonus), unabhängig davon, ob der
  Gegner schon aktiviert wurde. Steht das Ziel gleichzeitig in mehreren
  gegnerischen ZoCs, führt nur EIN Gegner den Angriff aus (höchster
  Nahkampf-Wert, bei Gleichstand Zufall), mit **maximal +1 Bonuswürfel**
  (fester Deckel, unabhängig von der Zahl der verlassenen ZoCs).
- **Charge:** Der erste Nahkampfangriff unmittelbar nachdem sich ein
  Kämpfer aktiv in gegnerische ZoC hineinbewegt hat, bekommt **+2
  Bonuswürfel** (5 insgesamt) und kostet keinen zusätzlichen
  Aktionspunkt. Löst bei jedem erneuten Hineinbewegen erneut aus, auch
  gegen denselben Gegner (z. B. nach Rückzug und erneutem Vorstoß).
  Jede weitere Nahkampfaktion gegen einen Gegner, mit dem man bereits
  Locked In ist, läuft nur mit dem 3-Würfel-Basispool (+ ggf. Flanking).
  **Deckel:** Charge-Boni sind pro Aktivierung hart auf die zwei
  eingebauten Fälle begrenzt (reguläre Bewegung + Dash) – Skills dürfen
  zusätzliche Bewegung gewähren, aber nie einen dritten Charge-Bonus
  auslösen.
- **Flanking:** Ein Nahkampfangriff (Charge oder Locked-In) bekommt **+1
  Bonuswürfel (fest gedeckelt)**, wenn mindestens ein eigener
  Verbündeter bereits im ZoC desselben Ziels steht. Skaliert NICHT mit
  der Zahl der Verbündeten. Stapelt additiv mit dem Charge-Bonus (max.
  3+2+1 = 6 Würfel bei einem flankierten Charge).
- **Nahkampf ist einseitig:** kein Standard-Gegenschlag (das Ziel würfelt
  nur seine Verteidigung). Ein echter Gegenschlag bleibt als möglicher
  zukünftiger Skill denkbar.

## 4. Kritische Treffer & Explosion

- Eine gewürfelte **1** ist ein kritischer Erfolg und löst einen
  **Bonuswürfel** aus (explodierender Würfel) – gilt für Angriffs- UND
  Verteidigungswürfe.
- **Explosions-Kaskade: unbegrenzt.** Ein Bonuswürfel kann selbst wieder
  eine 1 würfeln und erneut einen Bonuswürfel auslösen.
- **Krit-Verrechnung: einfache Stornierung.** Ein normaler
  Rettungswurf-Erfolg storniert einen Treffer, unabhängig davon, ob er
  kritisch war.
- **Erweiterte Krit-Schwelle** (1–2 statt nur 1) ist eine Upgrade-/
  Skill-Stellschraube, keine Basisregel – siehe `traits.md`.

## 5. Verteidigung/Rettungswurf

- Fester Pool von **3 Würfeln**, ohne Bonuswürfel-Mechanik (Ausnahmen
  nur über explizit genannte Skills/Traits).
- **Netto-Erfolge = max(0, Treffer − Rettungen).**

## 6. Schadensmodell

Kein Zufalls-Schadenswurf. **Ein Netto-Erfolg = 1 Schadenspunkt.**
Schild und Panzerung sind Zähler, die Netto-Erfolge der Reihe nach
aufsaugen:

```
1. Effektives Schild   = max(0, Schild − SD)
2. Nach Schild         = max(0, Netto-Erfolge − effektives Schild)
3. Effektive Panzerung = max(0, Panzerung − AP)
4. Schaden             = max(0, Nach-Schild − effektive Panzerung)
5. Ist Schaden ≥ 1: Gesamtschaden = Schaden + Lethal
```

- **AP** (Panzerungsdurchdringung) und **SD** (Schild-Abbau) senken die
  jeweilige effektive Schicht vor der Verrechnung; ist der Wert ≥ der
  Schicht, entsteht dadurch kein Bonusschaden – die Schicht fällt nur
  als Hindernis weg.
- **Lethal** ist ein flacher Bonus, **einmal pro Angriff** (nicht pro
  Netto-Erfolg), sobald mindestens 1 Netto-Erfolg nach Schild UND
  Panzerung übrig bleibt.
- AP/SD/Lethal sind **festes Waffenprofil**, keine Traits – volle
  Waffenprofil-Vorlage und Beispiele: `traits.md` Abschnitt 0.
- **Pool-Größe bleibt fest** (5/4/3 nach Deckung, 5/3 nach Charge-Status)
  für alle Waffen – Differenzierung läuft über Zielwert, AP/SD/Lethal
  und Upgrades/Skills (zusätzliche Würfel, erweiterte Krit-Schwelle),
  nicht über eine variable Basis-Pool-Größe der Waffe selbst.

## 7. Verticality / Höhe

- **Höhe** wird in Feldgrößen-Einheiten gemessen (z. B. eine 2 Felder
  hohe Wand). **Klettern kostet Bewegungspunkte 1:1 zur Höhe.**
- **Höhenbonus:** +1 Angreifer-Bonuswürfel je 2 Felder Höhenunterschied
  (kein Extra-Malus fürs Ziel). Erhöhte Position zählt zusätzlich selbst
  als Deckung für den, der oben steht, wenn er von unten beschossen
  wird (2 Felder = wie leichte Deckung, 4 Felder = wie volle Deckung).
- **Höhe vs. Objekt-Deckung:** Höhe überwindet Deckung NICHT – der
  Deckungsbonus des Ziels gilt immer, unabhängig von der Position des
  Schützen (kein Sichtlinien-Sonderfall). Beide Boni wirken unabhängig
  und gleichen sich rechnerisch aus (Schütze 2 Felder erhöht gegen Ziel
  in leichter Deckung: 3 Basis + 1 Höhe + 1 Deckung = 5, identisch zu
  einem ebenerdigen Schuss auf ein ungedecktes Ziel). Das bestehende
  2D-3-Strahlen-Sichtlinienmodell (`combat.md`) bleibt unverändert.

## 8. Haltungswahl pro Aktivierung: Guarded vs. Engaged

Jede Aktivierung kann statt normaler Aktionen die Haltung **Guarded**
wählen:

- **Fester Abzug von 2 Bonuswürfeln beim Angreifer**, additiv mit dem
  Deckungsbonus verrechnet (keine eigene Schwelle):

  | Situation des Ziels | Pool ohne Guarded | Pool mit Guarded |
  |---|---:|---:|
  | Offenes Feld | 5 | 3 |
  | Leichte Deckung | 4 | 2 |
  | Volle Deckung | 3 | 1 |

  Ein Guarded-Kämpfer in voller Deckung bleibt also theoretisch
  treffbar (bewusst schwächer als Kill Teams „Concealed", das volle
  Unangreifbarkeit gewährt), ist aber sehr gut geschützt. Kein
  Sonderfall für deckungs-ignorierende Traits/Skills nötig – sie wirken
  automatisch, da Guarded rein additiv verrechnet wird.
- **Gilt ausschließlich für Fernkampf.** Nahkampf ist davon nie
  betroffen.
- **Guarded verbietet:** Schießen, aktives Vorrücken in gegnerische ZoC.
  **Erlaubt weiterhin:** den reaktiven ZoC-Gegenangriff (Abschnitt 3),
  ohne dass die Haltung dafür gewechselt werden muss.
- **Schließt sich mit Overwatch gegenseitig aus** (Skills können das
  gezielt aufheben).

## 9. Statuseffekte

Kurzreferenz – volle Mechanik und Quellen: `traits.md`.

- **Pinned (Niedergehalten):** +1 Bonuswürfel für Nahkampfangriffe gegen
  das Ziel; erzwingt zu Beginn der nächsten Aktivierung eine
  „Aufstehen"-Aktion (verbraucht 1 von 2 Aktionspunkten), keine
  Unangreifbarkeit währenddessen.
- **Shaken (Reiver-Skill „Harrow"):** eigener Status, getrennt von
  Pinned – Ziel würfelt bei seiner nächsten Aktion mit 1 Würfel weniger.
  Beide Status können gleichzeitig auf einem Ziel liegen.

## 10. Kommando-Manöver-System

Der Kommandant (nie im Feld) und Ship-Upgrades wirken über ein
gemeinsames Manöver-System, inspiriert von Kill Teams Strategic/Firefight
Ploys (deterministisch, kein zusätzlicher Würfelwurf wie bei Halo
Flashpoints Command Dice – das System hat mit dem Angriffswürfelpool
bereits genug Zufall):

- **Kommando-Punkte (KP):** kleiner, persistenter Pool, regeneriert pro
  Runde um einen Basiswert (genauer Wert: Phase 2/3).
- **Strategie-Manöver:** genau **eines pro Runde** (bewusst exklusiv,
  nicht mehrere gleichzeitig wie im Kill-Team-Original), wirkt für die
  gesamte Runde auf die gesamte Crew, gewählt beim Rundenwechsel. Kostet KP.
- **Taktische Manöver:** jederzeit während einer beliebigen Aktivierung
  einsetzbar, wirken gezielt auf einen Kämpfer/eine Aktion (z. B. Extra-
  Aktionspunkt, Gratis-Würfel). Kosten KP, keine Nutzungsobergrenze
  außer dem KP-Vorrat.
- **Festes, bekanntes Manöver-Set** (kein Zufallselement) – wächst über
  die Kampagne. Sowohl der Kommandant-Führungsbaum als auch künftige
  Ship-Upgrades speisen sich in dasselbe Set ein.
- **Offen für Phase 2/3:** genaue KP-Regenerationsrate, Startgröße des
  Manöver-Sets, konkrete erste Manöver über bereits genannte Beispiele
  hinaus (Move It!/Move Out!, Focus Fire).
