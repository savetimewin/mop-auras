-- DRUID arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Skull Bash (interrupt)
LCT_SpellData[80964] = {
	class = "DRUID",
	specID = { 103, 104 },
	interrupt = true,
	cooldown = 15,
}

-- Solar Beam (interrupt)
LCT_SpellData[78675] = {
	class = "DRUID",
	specID = { 102 },
	interrupt = true,
	silence = true,
	duration = 10,
	cooldown = 60,
}

-- Nature's Cure (dispel)
LCT_SpellData[88423] = {
	class = "DRUID",
	specID = { 105 },
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 8,
}

-- Remove Corruption (dispel)
LCT_SpellData[2782] = {
	class = "DRUID",
	specID = { 102, 103, 104 },
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 8,
}

-- Disorienting Roar (aoeCC)
LCT_SpellData[99] = {
	class = "DRUID",
	talent = true,
	cc = true,
	cooldown = 30,
}

-- Mighty Bash (cc)
LCT_SpellData[5211] = {
	class = "DRUID",
	talent = true,
	cc = true,
	stun = true,
	cooldown = 50,
}

-- Typhoon (aoeCC)
LCT_SpellData[132469] = {
	class = "DRUID",
	talent = true,
	cc = true,
	knockback = true,
	cooldown = 30,
}

-- Barkskin (defensive)
LCT_SpellData[22812] = {
	class = "DRUID",
	defensive = true,
	duration = 12,
	cooldown = 60,
	cooldown_overload = { [104] = 30, [105] = 45 },
}

-- Might of Ursoc (defensive)
LCT_SpellData[106922] = {
	class = "DRUID",
	defensive = true,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Renewal (defensive)
LCT_SpellData[108238] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 120,
}

-- Survival Instincts (defensive)
LCT_SpellData[61336] = {
	class = "DRUID",
	specID = { 103, 104 },
	defensive = true,
	duration = 12,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Ironbark (PvP set: 30s) (externalDefensive)
LCT_SpellData[102342] = {
	class = "DRUID",
	specID = { 105 },
	defensive = true,
	duration = 12,
	cooldown = 60,
	cooldown_variants = { 30 },
}

-- Nature's Vigil (raidDefensive)
LCT_SpellData[124974] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	duration = 30,
	cooldown = 90,
}

-- Tranquility (raidDefensive)
LCT_SpellData[740] = {
	class = "DRUID",
	defensive = true,
	duration = 8,
	cooldown = 480,
	cooldown_overload = { [105] = 180 },
}

-- Berserk (Guardian) (offensive)
LCT_SpellData[50334] = {
	class = "DRUID",
	specID = { 104 },
	offensive = true,
	duration = 10,
	cooldown = 180,
}

-- Berserk (Feral) (offensive)
LCT_SpellData[106951] = {
	class = "DRUID",
	specID = { 103 },
	offensive = true,
	duration = 15,
	cooldown = 180,
}

-- Celestial Alignment (offensive)
LCT_SpellData[112071] = {
	class = "DRUID",
	specID = { 102 },
	offensive = true,
	duration = 15,
	cooldown = 180,
}

-- Incarnation (offensive)
LCT_SpellData[102558] = {
	class = "DRUID",
	talent = true,
	offensive = true,
	duration = 30,
	cooldown = 180,
}

-- Innervate (other)
LCT_SpellData[29166] = {
	class = "DRUID",
	none = true,
	cooldown = 180,
}

-- Nature's Swiftness (other)
LCT_SpellData[132158] = {
	class = "DRUID",
	specID = { 102, 103, 105 },
	none = true,
	cooldown_starts_on_aura_fade = true,
	cooldown = 60,
}

-- Spell 110570 (defensive)
LCT_SpellData[110570] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 45,
}

-- Spell 110575 (defensive)
LCT_SpellData[110575] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 180,
}

-- Spell 110617 (immunity)
LCT_SpellData[110617] = {
	class = "DRUID",
	talent = true,
	immune = true,
	cooldown = 120,
}

-- Spell 110696 (immunity)
LCT_SpellData[110696] = {
	class = "DRUID",
	talent = true,
	immune = true,
	cooldown = 300,
}

-- Spell 126458 (disarm)
LCT_SpellData[126458] = {
	class = "DRUID",
	talent = true,
	cc = true,
	cooldown = 60,
}

-- Spell 126449 (cc)
LCT_SpellData[126449] = {
	class = "DRUID",
	talent = true,
	cc = true,
	cooldown = 35,
}

-- Spell 126456 (defensive)
LCT_SpellData[126456] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 180,
}

-- Spell 110698 (cc)
LCT_SpellData[110698] = {
	class = "DRUID",
	talent = true,
	cc = true,
	cooldown = 60,
}

-- Spell 110700 (immunity)
LCT_SpellData[110700] = {
	class = "DRUID",
	talent = true,
	immune = true,
	cooldown = 300,
}

-- Spell 122288 (dispel)
LCT_SpellData[122288] = {
	class = "DRUID",
	talent = true,
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 8,
}

-- Spell 110707 (dispel)
LCT_SpellData[110707] = {
	class = "DRUID",
	talent = true,
	dispel = true,
	cooldown = 60,
}

-- Spell 110715 (defensive)
LCT_SpellData[110715] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 180,
}

-- Spell 110718 (movement)
LCT_SpellData[110718] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 90,
}

-- Spell 110788 (defensive)
LCT_SpellData[110788] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 120,
}

-- Spell 110791 (defensive)
LCT_SpellData[110791] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 180,
}

-- Spell 122291 (defensive)
LCT_SpellData[122291] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 180,
}

-- Spell 112970 (movement)
LCT_SpellData[112970] = {
	class = "DRUID",
	talent = true,
	defensive = true,
	cooldown = 30,
}

-- Spell 113004 (cc)
LCT_SpellData[113004] = {
	class = "DRUID",
	talent = true,
	cc = true,
	cooldown = 90,
}

-- Alternate combat-log IDs.
LCT_SpellData[80965] = 80964
LCT_SpellData[93985] = 80964
LCT_SpellData[97547] = 78675
LCT_SpellData[102543] = 102558
LCT_SpellData[102560] = 102558
