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

-- Incarnation: Chosen of Elune (Balance) (offensive)
LCT_SpellData[102560] = {
	class = "DRUID",
	specID = { 102 },
	talent = true,
	offensive = true,
	duration = 30,
	cooldown = 180,
}

-- Incarnation: King of the Jungle (Feral) (offensive)
LCT_SpellData[102543] = {
	class = "DRUID",
	specID = { 103 },
	talent = true,
	offensive = true,
	duration = 30,
	cooldown = 180,
}

-- Incarnation: Son of Ursoc (Guardian) (offensive)
LCT_SpellData[102558] = {
	class = "DRUID",
	specID = { 104 },
	talent = true,
	offensive = true,
	duration = 30,
	cooldown = 180,
}

-- Incarnation: Tree of Life (Restoration) (defensive)
LCT_SpellData[33891] = {
	class = "DRUID",
	specID = { 105 },
	talent = true,
	defensive = true,
	duration = 30,
	cooldown = 180,
}

-- Innervate (mana)
LCT_SpellData[29166] = {
	class = "DRUID",
	mana = true,
	duration = 10,
	cooldown = 180,
}

-- Nature's Swiftness (misc)
LCT_SpellData[132158] = {
	class = "DRUID",
	specID = { 102, 103, 105 },
	none = true,
	misc = true,
	cooldown_starts_on_aura_fade = true,
	cooldown = 60,
}

-- Dash (movement)
LCT_SpellData[1850] = {
	class = "DRUID",
	mobility = true,
	duration = 15,
	cooldown = 180,
}

-- Displacer Beast (movement)
LCT_SpellData[102280] = {
	class = "DRUID",
	talent = true,
	mobility = true,
	duration = 4,
	cooldown = 30,
}

-- Wild Charge (movement)
LCT_SpellData[102417] = {
	class = "DRUID",
	talent = true,
	mobility = true,
	cooldown = 15,
}

-- Stampeding Roar (movement)
LCT_SpellData[106898] = {
	class = "DRUID",
	mobility = true,
	duration = 8,
	cooldown = 120,
}

-- Alternate combat-log IDs.
LCT_SpellData[80965] = 80964
LCT_SpellData[93985] = 80964
LCT_SpellData[97547] = 78675
LCT_SpellData[16979] = 102417
LCT_SpellData[49376] = 102417
LCT_SpellData[102383] = 102417
LCT_SpellData[102401] = 102417
LCT_SpellData[102416] = 102417

