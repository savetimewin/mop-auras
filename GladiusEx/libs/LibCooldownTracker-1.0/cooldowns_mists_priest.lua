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

-- Void Tendrils
LCT_SpellData[108920] = {
	class = "PRIEST",
	talent = true,
	cc = true,
	cooldown = 30,
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

-- Angelic Bulwark (passive absorb / 90-second internal cooldown)
LCT_SpellData[108945] = {
	class = "PRIEST",
	talent = true,
	defensive = true,
	track_on_destination = true,
	duration = 20,
	cooldown = 90,
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
	mana = true,
	duration = 12,
	cooldown = 180,
}

-- Mindbender (talent replacement for Shadowfiend)
LCT_SpellData[123040] = {
	class = "PRIEST",
	talent = true,
	offensive = true,
	mana = true,
	duration = 15,
	replaces = 34433,
	cooldown = 60,
}

-- Fear Ward (counterCC)
LCT_SpellData[6346] = {
	class = "PRIEST",
	defensive = true,
	cc_break = true,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Inner Focus (counterCC)
LCT_SpellData[89485] = {
	class = "PRIEST",
	specID = { 256 },
	defensive = true,
	casting = true,
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

-- Angelic Feather (movement)
LCT_SpellData[121536] = {
	class = "PRIEST",
	talent = true,
	mobility = true,
	charges = 3,
	cooldown = 10,
}

-- Phantasm (Fade root/snare break)
LCT_SpellData[114239] = {
	class = "PRIEST",
	talent = true,
	mobility = true,
	cc_break = true,
	duration = 5,
	cooldown = 30,
}

-- Leap of Faith (movement)
LCT_SpellData[73325] = {
	class = "PRIEST",
	defensive = true,
	mobility = true,
	cooldown = 90,
}

-- Hymn of Hope (mana)
LCT_SpellData[64901] = {
	class = "PRIEST",
	mana = true,
	duration = 8,
	cooldown = 360,
}

-- Spectral Guise (misc)
LCT_SpellData[112833] = {
	class = "PRIEST",
	talent = true,
	misc = true,
	duration = 6,
	cooldown = 30,
}

-- Alternate combat-log IDs.
LCT_SpellData[724] = 126135
LCT_SpellData[32747] = 15487
