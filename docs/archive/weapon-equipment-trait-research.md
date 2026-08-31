# Weapon & Equipment Trait Research — Tabletop Skirmish Games
*Research pass for Cold Comfort's weapon-traits / equipment-traits system. Compiled 2026-08-29.*

Context for future reference: Cold Comfort's combat uses a 5-die attack pool / 3-die defense pool of d10s, success = roll ≤ stat, natural 1 explodes as a critical, natural 10 always fails, cover removes dice from the attacker's pool.

---

## 1. Kill Team (current/3rd-edition "Kill Team 2024" rules, aka the post-Octarius refresh)

Source: [Wahapedia Kill Team 3 Appendix](https://wahapedia.ru/kill-team3/the-rules/appendix/) (mirrors GW's official core rules PDF verbatim), cross-checked against [ktcalc.com Weapon Rules Reference](https://ktcalc.com/rules/weapon/) and [Age of Miniatures — Kill Team Weapon Special Rules](https://ageofminiatures.com/kill-team-weapon-special-rules/). All 22 entries below are confirmed against at least two of these sources.

| Keyword | Effect (plain English) | Real-world archetype | Translation |
|---|---|---|---|
| **Accurate X** | Retain up to X of your attack dice as automatic normal successes without rolling them. | Precision optics, marksman rifle, laser sight | **Weapon** — classic fixed gun property |
| **Balanced** | Reroll one attack die. | Well-machined, reliable weapon (quality autopistol) | **Weapon** |
| **Blast X** | Pick a primary target, then also hit any other valid targets within X of it. | Grenade launcher, template/area weapon | **Weapon** (could double as a grenade *item*) |
| **Brutal** | Defender can only block (spend a success on defense) using critical successes — normal successes don't count. | Overwhelming heavy melee weapon that shrugs off weak parries (power weapon, chainfist) | **Weapon** |
| **Ceaseless** | Reroll any number of dice that all show the *same* result (e.g. all your 2s). | Sustained/rapid-fire weapon walking rounds onto target | **Weapon** |
| **Devastating X** | Each retained critical success inflicts X damage *immediately*, outside normal damage allocation. | High-caliber round, sniper headshot, anti-materiel rifle | **Weapon** |
| **Heavy** | Can't move and shoot in the same activation (moving disables it that turn, or firing prevents moving). | Tripod/support weapon requiring bracing | **Weapon** (interacts well with an equipment "bipod/mount" trait that removes the penalty) |
| **Hot** | After firing, roll a d6; if it's less than the weapon's Hit stat, the firer takes damage equal to that roll ×2 (overheat). | Plasma weapon, unstable energy weapon | **Weapon** — great risk/reward archetype |
| **Lethal X+** | Successes of X or higher count as critical successes (lowers the crit threshold). | Armor-piercing/high-penetration ammo, sniper round | **Weapon** |
| **Limited X** | Weapon can only be used X times in the entire battle. | Rare ordnance, one-shot rocket, single grenade | **Equipment** fits just as well as weapon — good base for a "consumable" trait |
| **Piercing X** | Defender rolls X fewer defense dice. | AP round, penetrator ammunition | **Weapon** |
| **Punishing** | If you retain any critical success, you may also retain one *fail* as a normal success. | A weapon that "keeps connecting" once it starts revving (chain weapon) | **Weapon** |
| **Range X** | Only targets within X are valid (short effective range restriction). | Pistol, shotgun, thrown weapon | **Weapon** |
| **Relentless** | Reroll *any* number of attack dice (no restriction to matching results). | Extremely high rate-of-fire weapon (minigun/autocannon) | **Weapon** |
| **Rending** | If you retain any critical success, you may also upgrade one normal success to a critical success. | Monofilament edge, serrated/chain blade | **Weapon** |
| **Saturate** | Defender cannot retain cover-save dice (ignores cover). | Saturation/area fire, flamer that fills the space regardless of terrain | **Weapon** |
| **Seek** | Target selection ignores terrain for cover/visibility purposes (can hit things you can't technically see). | Indirect fire, smart-targeting munition, mortar | **Weapon** |
| **Severe** | If you retain no critical successes, you may upgrade one normal success to a critical success. | Consistently damaging weapon, guaranteed wound | **Weapon** |
| **Shock** | The first time you score a critical success in a sequence, also discard one of the opponent's unresolved normal successes (defense dice). | Stun weapon/shock maul that disrupts the target's ability to parry | **Weapon**, could be **Equipment** if reframed as a "shock" ammo mod |
| **Silent** | Can perform a Shoot action with this weapon while still in a Conceal/stealth order (without breaking stealth). | Suppressed/silenced firearm | **Weapon** — but also a natural fit for an **Equipment** "suppressor" attachment |
| **Stun** | On a retained critical success, the target loses 1 action point until the end of its next activation. | Stun gun, EMP, shock weapon | **Weapon** |
| **Torrent X** | Pick a primary target, then hit any number of secondary targets within X of it (more flexible than Blast — no "not in melee" restriction concerns). | Flamer, wide-cone spray weapon | **Weapon** |

**Note on things I could *not* verify precisely:** I could not find current-edition wording for a keyword literally named "Punishing X" with a numeric value, or a separate "Indirect" keyword distinct from Seek — if your source material used different names, flag them and I'll re-check. Everything listed above matched wording between the Wahapedia mirror and ktcalc.com, so confidence is high.

---

## 2. Halo: Flashpoint (Mantic Games, 2024, incl. Oct 2025 balance update)

Source: [Halo Flashpoint Reference — Keywords page](https://majors8908.github.io/flashpoint_reference/keywords.html) (fan-built reference site transcribing the app/rulebook), cross-checked against the [Mantic Games Wiki Keyword Reference Guide](https://manticgameswiki.com/index.php/Keyword_Reference_Guide) and individual keyword pages (Blast, Sticky, Lunge, EMP, Guarded, Imposing, Stealthy, Stoic, Fire, Acrobatic). Note: Mantic did an **Oct 2025 balance-update rename pass** — several keywords have two names in circulation: **Steady → Stoic**, **Subtle → Stealthy**, **Inspiring → Imposing**, **Long Reach → Lunge**. I've used current (post-update) names and flagged the old ones.

This game splits cleanly into *weapon-level* keywords and *model/unit-level* keywords — useful since you asked about both weapon traits and equipment/armor traits.

### Weapon-level keywords

| Keyword | Effect | Real-world archetype | Translation |
|---|---|---|---|
| **Optics** | +1 die to Shoot actions; Headshots (bonus effect) trigger on rolls of 7 *and* 8 instead of just 8. | Scope/red-dot optic | **Equipment** (attachment) or **Weapon** |
| **Sniper Scope** | Choose: short-range shot (no bonus) or long-range shot (+2 dice, headshots on 7-8). | Sniper rifle scope — trade-off between snap shots and set-up shots | **Weapon** |
| **Rapid Fire** | May fire normally, or use "Blaze Away": attacker rolls 4 dice, target rolls 3 to survive; a success also depletes a shield and Pins the target. | Automatic weapon's burst-fire mode | **Weapon** |
| **Weight of Fire (n)** | Reroll n dice on Ranged tests; stacks from multiple sources. | High-volume/machine-gun fire | **Weapon** |
| **Continuous Fire** | Grants Weight of Fire (2); after firing, the shooter must pass a 3-dice Survive test or take a wound. | Sustained-fire weapon with overheat/heavy recoil risk | **Weapon** |
| **Firing Platform (n)** | +n dice to Shoot actions with this weapon. | Bipod/tripod-mounted weapon | **Equipment** (the mount) fits at least as well as weapon |
| **Frag (n)** | Roll n dice at 4+; models roll 3-dice Survive tests against the difference; survivors scatter and are Pinned. | Fragmentation grenade | **Equipment** (thrown item) |
| **Explosive** | Target's cube is hit via a 3-dice Ranged(1) test; on a failure the shot scatters to determine actual impact point. | Rocket/grenade launcher indirect blast | **Weapon** |
| **Implosion (n)** | Like Frag, but victims are *not* thrown away from the blast (implosive/vortex effect). | Sci-fi implosion charge/singularity grenade | **Weapon**/**Equipment** |
| **Sticky** | On 3+ successes, depletes *all* energy shields of one model in the target cube. | Sticky/limpet grenade, EMP charge | **Equipment** |
| **Lethal (n)** | Adds n flat bonus wounds after shields and armor are resolved (once per attack, not per wound). | High-caliber/AP ammunition | **Weapon** |
| **Energy Shield Depleter (n)** | Directly depletes n of the target's shields before normal hit resolution. | Ion weapon, shield-disruptor round | **Weapon** |
| **EMP** | Depletes *all* energy shields on every model sharing the target's cube (area shield-pop). | EMP grenade/pulse weapon | **Equipment** (grenade-type item) |
| **Knockback** | On excess successes, pushes the target one cube directly away. | Shotgun blast, concussive/gauss weapon | **Weapon** |
| **Smash (n)** | +n dice on a Fight (melee) test. | Heavy melee weapon (power hammer, energy blade) | **Weapon** |
| **One-Use / Two-Use** | Item/weapon can only be used once (or twice) per game. | Single-shot rocket, limited grenade | **Equipment** — direct analogue to Kill Team's *Limited* |
| **Long Action** | The Shoot action with this weapon takes a full/long action instead of a short one. | Slow-cycling heavy or charge-up weapon | **Weapon** |
| **Support Weapon** | Can't Sprint, throw grenades, or Assault while carrying it; movement capped. | Heavy tripod support gun | **Weapon** — near-identical to Kill Team's *Heavy* |
| **Lunge** *(was Long Reach)* | This weapon's "shot" uses the Fight stat instead of Ranged, and only benefits from Clear Shot/High Ground modifiers. | Reach weapon, spear, thrown melee weapon | **Weapon** |
| **Fire (token)** | On being hit, apply a Fire token; unless removed with an action, the model takes 1 wound at end of activation. | Incendiary rounds, flamethrower burn | **Weapon**-applied status |

### Model/unit-level keywords (strong candidates for your **equipment/armor** trait catalogue)

| Keyword | Effect | Real-world archetype | Translation |
|---|---|---|---|
| **Energy Shield (n)** | Model starts with n shield points that deplete (fully) before armor/wounds apply. | Personal energy shield generator | **Equipment** |
| **Energy Shield Barrier (n)** | A stationary shield that protects every model in its cube from ranged attacks only. | Deployable bubble-shield / cover generator | **Equipment** |
| **Active Camouflage** | Loses the benefit versus opponents' Clear Shot/High Ground/Crouch bonuses only while shields are fully charged. | Active-camo cloak | **Equipment** — excellent, thematically strong |
| **Stealthy** *(was Subtle)* | Opponents only get the base +1 die for Clear Shot against this model (denies the rest of the normal stacking bonus). | Low-signature stealth armor | **Equipment** |
| **Guarded** | Immune to the Headshot bonus-effect when shot at. | Heavy helmet/full-face plate | **Equipment** |
| **Stoic** *(was Steady)* | Can never be Pinned; cannot Crouch. | Combat-drilled discipline/nerve-suppressant implant | **Equipment** (implant) or trait |
| **Fearless** | Can never be Pinned, even by effects that would normally force it (secondary effects still apply). | Fear-immune conditioning | **Equipment**/trait |
| **Life Support** | One-use: if wounded but not killed, the model is restored to full/undamaged. | Personal auto-doc / trauma plate | **Equipment** — very strong fit |
| **Medic** | Action: remove 1 wound marker from a friendly model in the same cube. | Field medic + medkit | **Equipment** (the kit) + trained-user skill |
| **Jump Pack / Flight** | Ignore fall damage/Pinning from falling; move over gaps or between levels. | Jetpack / grav-harness | **Equipment** |
| **Unstoppable** | +3 dice to the Fight test when the model triggers an Assault by charging. | Berserker charge, combat stimulant/adrenal implant | **Equipment** (a "combat drug" item) |
| **Pack Mule** | Can carry extra items/weapons/objectives. | Load-bearing gear, backpack rig | **Equipment** — pure inventory-capacity trait |
| **Suppressive Fire / Suppression** | Forces every model in the target cube to take cover / become Pinned. | Suppressing fire (belt-fed weapon) | **Weapon** — a genuinely good addition your list of "verified" games doesn't otherwise give you; consider adding a Suppress trait |
| **Horde** | +1 die per friendly model sharing the same cube during melee. | Mob/swarm tactics | **Doesn't translate** well to a single weapon/gear item — this is a squad-composition rule |
| **Imposing** *(was Inspiring)*, **Tactician (n)**, **Scout**, **Fast Transition**, **Grenade Specialist** | Leadership bonuses, command-dice economy, deployment tricks, dual-wielding, grenade specialization | Officer presence, elite training, recon insertion | **Doesn't translate** cleanly to weapon/equipment — these are character-build/skill-tree material, not item traits |
| **Acrobatic, Demoralising** | Scenario scoring modifiers (bonus VP for kills) | — | **Doesn't translate** — pure scenario/meta mechanic |

---

## 3. Bonus: Necromunda weapon traits (brief — lower-confidence sourcing)

I could not get a clean fetch of GW's official Necromunda core rulebook PDF or the well-known community "Complete Weapon Trait List" PDF (both blocked/JS-gated). The table below is drawn from a fan-translated rules wiki ([namu.wiki Necromunda status/traits page](https://en.namu.wiki/w/%EB%84%A4%ED%81%AC%EB%A1%9C%EB%AC%B8%EB%8B%A4/%EC%8A%A4%ED%85%8C%EC%9D%B4%ED%84%B0%EC%8A%A4)) and should be treated as **directionally correct but not word-for-word verified** — recommend a spot-check against GW's rulebook before treating exact numbers as gospel. It's included because several traits fill gaps the other two games don't cover well, especially around **ammo economy** and **melee/ranged crossover**.

| Trait | Effect | Archetype | Translation |
|---|---|---|---|
| **Plentiful** | Ammo is common — no ammo test required on reload. | Standard-issue, easy-to-resupply weapon | **Weapon** — good inverse-pairing with Limited/One-Use |
| **Scarce** | Once you run dry, you cannot reload at all this battle. | Rare ordnance | **Weapon** |
| **Unstable** | Failing the ammo roll risks harming the *user* (weapon can injure its own wielder). | Volatile/jury-rigged weapon | **Weapon** — great risk/reward, pairs with Kill Team's *Hot* |
| **Master-Crafted** | Once per battle, reroll one failed hit roll. | Quality/masterwork gear | **Weapon** — a nice "rare, better version of a common gun" trait |
| **Unwieldy** | Firing this weapon costs a full/double action instead of a normal one. | Heavy, slow-to-operate weapon | **Weapon** — same idea as Halo's *Long Action* |
| **Versatile** | Can make melee-range attacks at range (up to its stated range) without needing base contact. | Reach/spear-like weapon, bayonet-lunge | **Weapon** |
| **Sidearm** | Usable in melee as a single attack even though it's a ranged weapon; accuracy bonuses only apply to its ranged use. | Pistol used as a backup melee option | **Weapon** |
| **Shield Breaker** | Ignores energy-shield-type defenses outright; forces two saves (keep lowest) against field armor. | Anti-shield round | **Weapon** |
| **Gas / Toxin** | Rolls against Toughness instead of a normal wound roll; often bypasses armor saves entirely. | Chemical/gas weapon | **Weapon** |
| **Web** | A successful hit against a downed target inflicts a "Webbed" status instead of further wounds (crowd control, not damage). | Net gun, tangle weapon | **Weapon** |
| **Silent (Necromunda)** | No detection test triggered by firing it — can shoot without giving away a hidden position. | Suppressed weapon | **Weapon**/**Equipment** — same idea as Kill Team's *Silent* |
| **Combi** | A single item is really two weapon profiles (e.g. lasgun + plasma gun) sharing the same body, tracked separately. | Combi-weapon | **Weapon** — an interesting "hybrid loadout" idea |
| **Disarm** | A natural maximum result on the hit roll denies the target's ability to make reaction/parry attacks that round. | Disarming strike, called shot | **Weapon** |

---

## Cross-game synthesis notes for Cold Comfort

A few patterns worth carrying into your own system:

1. **All three games converge on the same handful of "core verbs"** for weapon traits: (a) *reroll dice* (Balanced/Ceaseless/Relentless, Weight of Fire), (b) *upgrade a success to critical* (Rending/Severe/Lethal, Master-Crafted), (c) *reduce the defender's dice or ignore their mitigation* (Piercing/Saturate/Seek, Shield Breaker, Guarded's inverse), (d) *hit extra targets* (Blast/Torrent, Frag/Explosive), and (e) *cost/downside for extra power* (Heavy/Hot, Unwieldy/Unstable, Continuous Fire). That five-bucket structure maps cleanly onto a d10 pool system and is a good skeleton for your own naming pass.
2. **The Equipment-vs-Weapon split in Halo: Flashpoint is the most useful reference for your ask specifically**, because Mantic explicitly separates *weapon* keywords from *model* keywords, and several of their model keywords (Energy Shield, Active Camouflage, Life Support, Jump Pack, Stoic/Fearless) are exactly the shape of "gear you wear, not a gun you carry" that you're after for an equipment-traits catalogue. Kill Team, by contrast, keeps almost everything on the weapon card — it has comparatively little to offer for equipment-side inspiration.
3. **Good candidates specifically for your EQUIPMENT list** (not weapon-bound): Active Camouflage, personal Energy Shield, Life Support/medkit, Jump Pack, a suppressor item that grants Silent, a scope item that grants Optics/Accurate, a combat-drug item granting Unstoppable-style charge bonus, Pack Mule-style carry capacity, Master-Crafted as a rare weapon *upgrade module* rather than an innate property.
4. **Good candidates specifically for a WEAPON list**: Piercing/Lethal/Rending/Devastating (AP & crit-fishing cluster), Blast/Torrent/Frag (area cluster), Heavy/Hot/Unstable/Long Action/Unwieldy (drawback cluster), Ceaseless/Relentless/Weight of Fire (volume-of-fire cluster), Silent/Seek/Saturate (fire-control cluster).
5. **Traits that don't translate well to either bucket** are almost all Halo Flashpoint's scenario/leadership keywords (Tactician, Imposing, Scout, Horde, Acrobatic/Demoralising) — those are army-building/skill-tree material, not item-level traits, and are probably out of scope for a "weapon/equipment traits" catalogue.

---

## Sources

- [Wahapedia — Kill Team 3rd Ed. Appendix (weapon rules)](https://wahapedia.ru/kill-team3/the-rules/appendix/)
- [Wahapedia — Kill Team 3rd Ed. Core Rules](https://wahapedia.ru/kill-team3/the-rules/core-rules/)
- [ktcalc.com — Kill Team 2024 Weapon Rules Reference](https://ktcalc.com/rules/weapon/)
- [Age of Miniatures — Kill Team Special Rules & Abilities for Weapons & Operatives](https://ageofminiatures.com/kill-team-weapon-special-rules/)
- [Halo Flashpoint Reference — Keywords page (majors8908, fan-built)](https://majors8908.github.io/flashpoint_reference/keywords.html)
- [Mantic Games Wiki — Keyword Reference Guide](https://manticgameswiki.com/index.php/Keyword_Reference_Guide)
- [Mantic Games Wiki — Blast](https://manticgameswiki.com/index.php/Blast), [Sticky](https://manticgameswiki.com/index.php/Sticky), [Lunge](https://manticgameswiki.com/index.php/Lunge), [EMP](https://manticgameswiki.com/index.php/EMP), [Guarded](https://manticgameswiki.com/index.php/Guarded), [Imposing](https://manticgameswiki.com/index.php/Imposing), [Stealthy](https://manticgameswiki.com/index.php/Stealthy), [Stoic](https://manticgameswiki.com/index.php/Stoic), [Fire](https://manticgameswiki.com/index.php/Fire), [Acrobatic](https://manticgameswiki.com/index.php/Acrobatic)
- [Mantic Games — Halo Flashpoint official rules hub](https://haloflashpoint.manticgames.com/the-app/halo-flashpoint-rules/) (primary/official; keyword page above transcribes this)
- [en.namu.wiki — Necromunda weapon traits (fan-translated, lower confidence)](https://en.namu.wiki/w/%EB%84%A4%ED%81%AC%EB%A1%9C%EB%AC%B8%EB%8B%A4/%EC%8A%A4%ED%85%8C%EC%9D%B4%ED%84%B0%EC%8A%A4)

**Flagged as unverified / needs a second check if precision matters:** exact numeric values on several Necromunda traits (Blaze, Pulverise, Rad-Phage, Seismic) — the underlying mechanic is very likely correct but I did not cross-reference a second source for the precise die-roll thresholds.
