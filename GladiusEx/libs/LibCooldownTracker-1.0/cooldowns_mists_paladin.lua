-- PALADIN arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Rebuke (interrupt)
LCT_SpellData[96231] = {
	class = "PALADIN",
	interrupt = true,
	cooldown = 15,
}

-- Cleanse (dispel)
LCT_SpellData[4987] = {
	class = "PALADIN",
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 8,
}

-- Fist of Justice (cc)
LCT_SpellData[105593] = {
	class = "PALADIN",
	talent = true,
	cc = true,
	stun = true,
	replaces = 853,
	cooldown = 30,
}

-- Hammer of Justice (cc)
LCT_SpellData[853] = {
	class = "PALADIN",
	cc = true,
	stun = true,
	cooldown = 60,
}

-- Repentance (cc)
LCT_SpellData[20066] = {
	class = "PALADIN",
	talent = true,
	cc = true,
	cooldown = 15,
}

-- Blinding Light (aoeCC)
LCT_SpellData[115750] = {
	class = "PALADIN",
	cc = true,
	cooldown = 120,
}

-- Divine Shield (immunity)
LCT_SpellData[642] = {
	class = "PALADIN",
	immune = true,
	duration = 8,
	cooldown = 300,
	cooldown_variants = { 150 },
}

-- Ardent Defender (defensive)
LCT_SpellData[31850] = {
	class = "PALADIN",
	specID = { 66 },
	defensive = true,
	duration = 10,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Divine Protection (defensive)
LCT_SpellData[498] = {
	class = "PALADIN",
	defensive = true,
	duration = 8,
	cooldown = 60,
	cooldown_variants = { 30 },
}

-- Guardian of Ancient Kings (defensive)
LCT_SpellData[86659] = {
	class = "PALADIN",
	specID = { 66 },
	defensive = true,
	duration = 12,
	cooldown = 180,
}

-- Hand of Protection (externalDefensive)
LCT_SpellData[1022] = {
	class = "PALADIN",
	defensive = true,
	duration = 10,
	opt_charges = 2,
	cooldown = 300,
}

-- Hand of Purity (externalDefensive)
LCT_SpellData[114039] = {
	class = "PALADIN",
	talent = true,
	defensive = true,
	duration = 6,
	cooldown = 30,
}

-- Hand of Sacrifice (externalDefensive)
LCT_SpellData[6940] = {
	class = "PALADIN",
	defensive = true,
	duration = 12,
	opt_charges = 2,
	cooldown = 120,
}

-- Devotion Aura (raidDefensive)
LCT_SpellData[31821] = {
	class = "PALADIN",
	defensive = true,
	duration = 6,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Guardian of Ancient Kings (Holy) (heal)
LCT_SpellData[86669] = {
	class = "PALADIN",
	specID = { 65 },
	heal = true,
	duration = 15,
	cooldown = 180,
}

-- Avenging Wrath (offensive)
LCT_SpellData[31884] = {
	class = "PALADIN",
	offensive = true,
	duration = 20,
	cooldown = 180,
}

-- Divine Favor (offensive)
LCT_SpellData[31842] = {
	class = "PALADIN",
	specID = { 65 },
	offensive = true,
	duration = 20,
	cooldown = 180,
}

-- Execution Sentence (offensive)
LCT_SpellData[114157] = {
	class = "PALADIN",
	talent = true,
	offensive = true,
	duration = 10,
	cooldown = 60,
}

-- Guardian of Ancient Kings (Ret) (offensive)
LCT_SpellData[86698] = {
	class = "PALADIN",
	specID = { 70 },
	offensive = true,
	duration = 30,
	cooldown = 180,
}

-- Hand of Freedom (freedom)
LCT_SpellData[1044] = {
	class = "PALADIN",
	defensive = true,
	duration = 6,
	opt_charges = 2,
	cooldown = 25,
}

-- Spell 113075 (defensive)
LCT_SpellData[113075] = {
	class = "PALADIN",
	talent = true,
	defensive = true,
	cooldown = 60,
}
