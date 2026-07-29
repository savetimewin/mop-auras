-- SHAMAN arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Wind Shear (interrupt)
LCT_SpellData[57994] = {
	class = "SHAMAN",
	interrupt = true,
	cooldown = 12,
}

-- Cleanse Spirit (dispel)
LCT_SpellData[51886] = {
	class = "SHAMAN",
	specID = { 262, 263 },
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 8,
}

-- Purify Spirit (dispel)
LCT_SpellData[77130] = {
	class = "SHAMAN",
	specID = { 264 },
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 8,
}

-- Hex (cc)
LCT_SpellData[51514] = {
	class = "SHAMAN",
	cc = true,
	cooldown = 45,
	cooldown_variants = { 35 },
}

-- Call of the Elements (aoeCC)
LCT_SpellData[108269] = {
	class = "SHAMAN",
	cc = true,
	stun = true,
	duration = 5,
	cooldown = 45,
}

-- Thunderstorm (aoeCC)
LCT_SpellData[51490] = {
	class = "SHAMAN",
	specID = { 262 },
	cc = true,
	knockback = true,
	cooldown = 45,
	cooldown_variants = { 35, 22.5, 17.5 },
}

-- Astral Shift (defensive)
LCT_SpellData[108271] = {
	class = "SHAMAN",
	talent = true,
	defensive = true,
	duration = 6,
	cooldown = 90,
}

-- Call of the Elements (defensive)
LCT_SpellData[108285] = {
	class = "SHAMAN",
	talent = true,
	defensive = true,
	resets = { 108269, 8177, 108270, 8143 },
	cooldown = 180,
}

-- Earth Elemental Totem (defensive)
LCT_SpellData[2062] = {
	class = "SHAMAN",
	defensive = true,
	duration = 60,
	sets_cooldowns = {
		{ spellid = 2894, cooldown = 60 },
	},
	cooldown = 300,
}

-- Nature's Guardian (defensive)
LCT_SpellData[30884] = {
	class = "SHAMAN",
	talent = true,
	defensive = true,
	cooldown = 30,
}

-- Shamanistic Rage (defensive)
LCT_SpellData[30823] = {
	class = "SHAMAN",
	specID = { 262, 263 },
	defensive = true,
	duration = 15,
	cooldown = 60,
}

-- Stone Bulwark Totem (defensive)
LCT_SpellData[108270] = {
	class = "SHAMAN",
	talent = true,
	defensive = true,
	duration = 30,
	cooldown = 60,
}

-- Ancestral Guidance (raidDefensive)
LCT_SpellData[108281] = {
	class = "SHAMAN",
	talent = true,
	defensive = true,
	duration = 10,
	cooldown = 120,
}

-- Healing Tide Totem (raidDefensive)
LCT_SpellData[108280] = {
	class = "SHAMAN",
	defensive = true,
	duration = 10,
	cooldown = 180,
}

-- Spirit Link Totem (raidDefensive)
LCT_SpellData[98008] = {
	class = "SHAMAN",
	specID = { 264 },
	defensive = true,
	duration = 6,
	cooldown = 180,
}

-- Ascendance (offensive)
LCT_SpellData[114049] = {
	class = "SHAMAN",
	offensive = true,
	duration = 15,
	cooldown = 180,
}

-- Elemental Mastery (offensive)
LCT_SpellData[16166] = {
	class = "SHAMAN",
	talent = true,
	offensive = true,
	duration = 20,
	cooldown = 90,
}

-- Feral Spirit (offensive)
LCT_SpellData[51533] = {
	class = "SHAMAN",
	talent = true,
	offensive = true,
	duration = 30,
	cooldown = 120,
}

-- Fire Elemental Totem (offensive)
LCT_SpellData[2894] = {
	class = "SHAMAN",
	offensive = true,
	duration = 60,
	sets_cooldowns = {
		{ spellid = 2062, cooldown = 60 },
	},
	cooldown = 300,
	cooldown_variants = { 150 },
}

-- Spell 120668 (offensive)
LCT_SpellData[120668] = {
	class = "SHAMAN",
	offensive = true,
	cooldown = 300,
}

-- Grounding Totem (counterCC)
LCT_SpellData[8177] = {
	class = "SHAMAN",
	defensive = true,
	duration = 15,
	cooldown = 25,
	cooldown_variants = { 22 },
}

-- Tremor Totem (counterCC)
LCT_SpellData[8143] = {
	class = "SHAMAN",
	defensive = true,
	duration = 10,
	cooldown = 60,
}

-- Spirit Walk (freedom)
LCT_SpellData[58875] = {
	class = "SHAMAN",
	specID = { 263 },
	defensive = true,
	duration = 15,
	cooldown = 60,
	cooldown_variants = { 45 },
}

-- Ancestral Swiftness (other)
LCT_SpellData[16188] = {
	class = "SHAMAN",
	talent = true,
	none = true,
	cooldown_starts_on_aura_fade = true,
	cooldown = 90,
}

-- Mana Tide Totem (other)
LCT_SpellData[16190] = {
	class = "SHAMAN",
	specID = { 264 },
	none = true,
	cooldown = 180,
}

-- Spell 113286 (interrupt)
LCT_SpellData[113286] = {
	class = "SHAMAN",
	talent = true,
	interrupt = true,
	cooldown = 60,
}

-- Alternate combat-log IDs.
LCT_SpellData[31616] = 30884
LCT_SpellData[113288] = 113286
