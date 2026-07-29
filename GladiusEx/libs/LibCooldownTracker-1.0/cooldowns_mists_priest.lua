-- PRIEST arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Silence (interrupt)
LCT_SpellData[15487] = {
	class = "PRIEST",
	specID = { 258 },
	interrupt = true,
	silence = true,
	cooldown = 45,
}

-- Mass Dispel (dispel)
LCT_SpellData[32375] = {
	class = "PRIEST",
	dispel = true,
	mass_dispel = true,
	cooldown = 15,
}

-- Purify (dispel)
LCT_SpellData[527] = {
	class = "PRIEST",
	specID = { 256, 257 },
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 15,
}

-- Holy Word: Chastise (cc)
LCT_SpellData[88625] = {
	class = "PRIEST",
	specID = { 257 },
	cc = true,
	cooldown = 30,
}

-- Psychic Horror (cc)
LCT_SpellData[64044] = {
	class = "PRIEST",
	specID = { 258 },
	cc = true,
	cooldown = 45,
	cooldown_variants = { 35 },
}

-- Psyfiend (cc)
LCT_SpellData[108921] = {
	class = "PRIEST",
	talent = true,
	cc = true,
	cooldown = 45,
}

-- Psychic Scream (aoeCC)
LCT_SpellData[8122] = {
	class = "PRIEST",
	cc = true,
	cooldown = 30,
	cooldown_variants = { 27 },
}

-- Desperate Prayer (defensive)
LCT_SpellData[19236] = {
	class = "PRIEST",
	talent = true,
	defensive = true,
	cooldown = 120,
}

-- Dispersion (defensive)
LCT_SpellData[47585] = {
	class = "PRIEST",
	specID = { 258 },
	defensive = true,
	duration = 6,
	cooldown = 120,
	cooldown_variants = { 105 },
}

-- Void Shift (defensive)
LCT_SpellData[108968] = {
	class = "PRIEST",
	specID = { 256, 257 },
	defensive = true,
	cooldown = 300,
}

-- Guardian Spirit (externalDefensive)
LCT_SpellData[47788] = {
	class = "PRIEST",
	specID = { 257 },
	defensive = true,
	duration = 10,
	cooldown = 180,
}

-- Pain Suppression (externalDefensive)
LCT_SpellData[33206] = {
	class = "PRIEST",
	specID = { 256 },
	defensive = true,
	duration = 8,
	cooldown = 180,
}

-- Divine Hymn (raidDefensive)
LCT_SpellData[64843] = {
	class = "PRIEST",
	specID = { 257 },
	defensive = true,
	duration = 8,
	cooldown = 180,
}

-- Spell 126135 (raidDefensive)
LCT_SpellData[126135] = {
	class = "PRIEST",
	specID = { 257 },
	defensive = true,
	cooldown = 180,
}

-- Power Word: Barrier (raidDefensive)
LCT_SpellData[62618] = {
	class = "PRIEST",
	specID = { 256 },
	defensive = true,
	duration = 10,
	cooldown = 180,
}

-- Spell 15286 (raidDefensive)
LCT_SpellData[15286] = {
	class = "PRIEST",
	specID = { 258 },
	defensive = true,
	cooldown = 180,
}

-- Power Infusion (offensive)
LCT_SpellData[10060] = {
	class = "PRIEST",
	talent = true,
	offensive = true,
	duration = 20,
	cooldown = 120,
}

-- Shadowfiend (offensive)
LCT_SpellData[34433] = {
	class = "PRIEST",
	offensive = true,
	duration = 12,
	cooldown = 180,
}

-- Fear Ward (counterCC)
LCT_SpellData[6346] = {
	class = "PRIEST",
	defensive = true,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Inner Focus (counterCC)
LCT_SpellData[89485] = {
	class = "PRIEST",
	specID = { 256 },
	defensive = true,
	cooldown_starts_on_aura_fade = true,
	cooldown = 45,
}

-- Spell 32379 (counterCC)
LCT_SpellData[32379] = {
	class = "PRIEST",
	specID = { 256, 257 },
	defensive = true,
	cooldown = 8,
}

-- Spell 129176 (counterCC)
LCT_SpellData[129176] = {
	class = "PRIEST",
	specID = { 258 },
	defensive = true,
	cooldown = 8,
}

-- Leap of Faith (movement)
LCT_SpellData[73325] = {
	class = "PRIEST",
	defensive = true,
	cooldown = 90,
}

-- Spell 64901 (other)
LCT_SpellData[64901] = {
	class = "PRIEST",
	none = true,
	cooldown = 360,
}

-- Spell 113277 (raidDefensive)
LCT_SpellData[113277] = {
	class = "PRIEST",
	talent = true,
	defensive = true,
	cooldown = 480,
}

-- Alternate combat-log IDs.
LCT_SpellData[724] = 126135
LCT_SpellData[32747] = 15487
