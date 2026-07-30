-- ROGUE arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Kick (interrupt)
LCT_SpellData[1766] = {
	class = "ROGUE",
	interrupt = true,
	cooldown = 15,
}

-- Blind (cc)
LCT_SpellData[2094] = {
	class = "ROGUE",
	cc = true,
	cooldown = 120,
}

-- Kidney Shot (cc)
LCT_SpellData[408] = {
	class = "ROGUE",
	cc = true,
	stun = true,
	cooldown = 20,
}

-- Smoke Bomb (cc)
LCT_SpellData[76577] = {
	class = "ROGUE",
	cc = true,
	duration = 5,
	cooldown = 180,
}

-- Dismantle (disarm)
LCT_SpellData[51722] = {
	class = "ROGUE",
	cc = true,
	cooldown = 60,
}

-- Cheat Death (defensive)
LCT_SpellData[31230] = {
	class = "ROGUE",
	talent = true,
	defensive = true,
	duration = 3,
	cooldown = 90,
}

-- Cloak of Shadows (defensive)
LCT_SpellData[31224] = {
	class = "ROGUE",
	defensive = true,
	duration = 5,
	cooldown = 60,
}

-- Combat Readiness (defensive)
LCT_SpellData[74001] = {
	class = "ROGUE",
	talent = true,
	defensive = true,
	duration = 20,
	cooldown = 120,
}

-- Evasion (defensive)
LCT_SpellData[5277] = {
	class = "ROGUE",
	defensive = true,
	duration = 10,
	cooldown = 120,
}

-- Preparation (defensive)
LCT_SpellData[14185] = {
	class = "ROGUE",
	defensive = true,
	resets = { 1856, 5277, 51722, 2983 },
	cooldown = 300,
}

-- Vanish (defensive)
LCT_SpellData[1856] = {
	class = "ROGUE",
	defensive = true,
	duration = 3,
	cooldown = 120,
}

-- Adrenaline Rush (offensive)
LCT_SpellData[13750] = {
	class = "ROGUE",
	specID = { 260 },
	offensive = true,
	duration = 15,
	cooldown = 180,
}

-- Killing Spree (offensive)
LCT_SpellData[51690] = {
	class = "ROGUE",
	specID = { 260 },
	offensive = true,
	duration = 3,
	cooldown = 120,
}

-- Shadow Blades (offensive)
LCT_SpellData[121471] = {
	class = "ROGUE",
	offensive = true,
	cooldown = 180,
}

-- Shadow Dance (offensive)
LCT_SpellData[51713] = {
	class = "ROGUE",
	specID = { 261 },
	offensive = true,
	duration = 8,
	cooldown = 60,
}

-- Vendetta (offensive)
LCT_SpellData[79140] = {
	class = "ROGUE",
	specID = { 259 },
	offensive = true,
	duration = 20,
	cooldown = 120,
}

-- Shadowstep (movement)
LCT_SpellData[36554] = {
	class = "ROGUE",
	talent = true,
	mobility = true,
	duration = 2,
	cooldown = 20,
}

-- Sprint (movement)
LCT_SpellData[2983] = {
	class = "ROGUE",
	mobility = true,
	duration = 8,
	cooldown = 60,
}

-- Combat-log-only Restless Blades triggers.
LCT_SpellData[2098] = {
	class = "ROGUE",
	hidden = true,
	ignore_cooldown_event = true,
	reduce = { specID = 260, duration = 10, spellids = { 13750, 51690, 121471 } },
}
LCT_SpellData[1943] = {
	class = "ROGUE",
	hidden = true,
	ignore_cooldown_event = true,
	reduce = { specID = 260, duration = 10, spellids = { 13750, 51690, 121471 } },
}
LCT_SpellData[121411] = {
	class = "ROGUE",
	hidden = true,
	ignore_cooldown_event = true,
	reduce = { specID = 260, duration = 10, spellids = { 13750, 51690, 121471 } },
}
LCT_SpellData[26679] = {
	class = "ROGUE",
	hidden = true,
	ignore_cooldown_event = true,
	reduce = { specID = 260, duration = 10, spellids = { 13750, 51690, 121471 } },
}

-- Alternate combat-log IDs.
LCT_SpellData[45182] = 31230
