-- WARRIOR arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Disrupting Shout (interrupt)
LCT_SpellData[102060] = {
	class = "WARRIOR",
	talent = true,
	interrupt = true,
	sets_cooldowns = {
		{ spellid = 6552, cooldown = 15 },
	},
	cooldown = 40,
}

-- Pummel (interrupt)
LCT_SpellData[6552] = {
	class = "WARRIOR",
	interrupt = true,
	sets_cooldowns = {
		{ spellid = 102060, cooldown = 15 },
	},
	cooldown = 15,
}

-- Intimidating Shout (cc)
LCT_SpellData[5246] = {
	class = "WARRIOR",
	cc = true,
	cooldown = 90,
}

-- Shockwave (cc)
LCT_SpellData[46968] = {
	class = "WARRIOR",
	talent = true,
	cc = true,
	stun = true,
	cooldown = 40,
}

-- Storm Bolt (cc)
LCT_SpellData[107570] = {
	class = "WARRIOR",
	talent = true,
	cc = true,
	stun = true,
	cooldown = 30,
}

-- Dragon Roar (aoeCC)
LCT_SpellData[118000] = {
	class = "WARRIOR",
	talent = true,
	cc = true,
	knockback = true,
	duration = 0.5,
	cooldown = 60,
}

-- Disarm (disarm)
LCT_SpellData[676] = {
	class = "WARRIOR",
	cc = true,
	cooldown = 60,
}

-- Demoralizing Banner (defensive)
LCT_SpellData[114203] = {
	class = "WARRIOR",
	defensive = true,
	cooldown = 180,
}

-- Die by the Sword (defensive)
LCT_SpellData[118038] = {
	class = "WARRIOR",
	specID = { 71, 72 },
	defensive = true,
	duration = 8,
	cooldown = 120,
}

-- Last Stand (defensive)
LCT_SpellData[12975] = {
	class = "WARRIOR",
	specID = { 73 },
	defensive = true,
	duration = 20,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Shield Wall (defensive)
LCT_SpellData[871] = {
	class = "WARRIOR",
	defensive = true,
	duration = 12,
	cooldown = 180,
}

-- Vigilance (externalDefensive)
LCT_SpellData[114030] = {
	class = "WARRIOR",
	talent = true,
	defensive = true,
	duration = 12,
	cooldown = 120,
}

-- Rallying Cry (raidDefensive)
LCT_SpellData[97462] = {
	class = "WARRIOR",
	defensive = true,
	duration = 10,
	cooldown = 180,
}

-- Enraged Regeneration (heal)
LCT_SpellData[55694] = {
	class = "WARRIOR",
	talent = true,
	heal = true,
	duration = 5,
	cooldown = 60,
}

-- Avatar (offensive)
LCT_SpellData[107574] = {
	class = "WARRIOR",
	talent = true,
	offensive = true,
	duration = 24,
	cooldown = 180,
}

-- Colossus Smash (offensive)
LCT_SpellData[86346] = {
	class = "WARRIOR",
	specID = { 71, 72 },
	offensive = true,
	duration = 6,
	cooldown = 20,
}

-- Recklessness (offensive)
LCT_SpellData[1719] = {
	class = "WARRIOR",
	offensive = true,
	duration = 12,
	cooldown = 180,
}

-- Skull Banner (offensive)
LCT_SpellData[114207] = {
	class = "WARRIOR",
	offensive = true,
	cooldown = 180,
}

-- Berserker Rage (counterCC)
LCT_SpellData[18499] = {
	class = "WARRIOR",
	defensive = true,
	duration = 6,
	cooldown = 30,
}

-- Intervene (counterCC)
LCT_SpellData[3411] = {
	class = "WARRIOR",
	defensive = true,
	cooldown = 30,
}

-- Mass Spell Reflection (counterCC)
LCT_SpellData[114028] = {
	class = "WARRIOR",
	talent = true,
	defensive = true,
	duration = 5,
	cooldown = 60,
}

-- Safeguard (counterCC)
LCT_SpellData[114029] = {
	class = "WARRIOR",
	talent = true,
	defensive = true,
	duration = 6,
	replaces = 3411,
	cooldown = 30,
}

-- Spell Reflection (counterCC)
LCT_SpellData[23920] = {
	class = "WARRIOR",
	defensive = true,
	duration = 5,
	cooldown = 25,
	cooldown_variants = { 20 },
}

-- Shattering Throw (other)
LCT_SpellData[64382] = {
	class = "WARRIOR",
	none = true,
	mass_dispel = true,
	cooldown = 300,
}

-- Spell 122286 (defensive)
LCT_SpellData[122286] = {
	class = "WARRIOR",
	talent = true,
	defensive = true,
	cooldown = 60,
}
