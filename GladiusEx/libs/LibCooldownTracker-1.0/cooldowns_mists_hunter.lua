-- HUNTER arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Counter Shot (interrupt)
LCT_SpellData[147362] = {
	class = "HUNTER",
	specID = { 253, 255 },
	interrupt = true,
	cooldown = 24,
}

-- Silencing Shot (interrupt)
LCT_SpellData[34490] = {
	class = "HUNTER",
	specID = { 254 },
	interrupt = true,
	cooldown = 24,
}

-- Freezing Trap (cc)
LCT_SpellData[1499] = {
	class = "HUNTER",
	cc = true,
	cooldown = 30,
	cooldown_overload = { [255] = 24 },
	cooldown_variants = { 28, 22 },
}

-- Intimidation (cc)
LCT_SpellData[19577] = {
	class = "HUNTER",
	talent = true,
	cc = true,
	stun = true,
	cooldown = 60,
}

-- Scatter Shot (cc)
LCT_SpellData[19503] = {
	class = "HUNTER",
	cc = true,
	cooldown = 30,
}

-- Wyvern Sting (cc)
LCT_SpellData[19386] = {
	class = "HUNTER",
	talent = true,
	cc = true,
	cooldown = 45,
}

-- Binding Shot (aoeCC)
LCT_SpellData[109248] = {
	class = "HUNTER",
	talent = true,
	cc = true,
	cooldown = 45,
}

-- Deterrence (immunity)
LCT_SpellData[19263] = {
	class = "HUNTER",
	immune = true,
	duration = 5,
	charges = 2,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Camouflage (defensive)
LCT_SpellData[51753] = {
	class = "HUNTER",
	defensive = true,
	duration = 6,
	cooldown = 60,
}

-- Roar of Sacrifice (externalDefensive)
LCT_SpellData[53480] = {
	class = "HUNTER",
	pet = true,
	defensive = true,
	duration = 12,
	cooldown = 60,
}

-- Exhilaration (heal)
LCT_SpellData[109304] = {
	class = "HUNTER",
	talent = true,
	heal = true,
	cooldown = 120,
}

-- A Murder of Crows (offensive)
LCT_SpellData[131894] = {
	class = "HUNTER",
	talent = true,
	offensive = true,
	duration = 15,
	cooldown = 120,
}

-- Bestial Wrath (offensive)
LCT_SpellData[19574] = {
	class = "HUNTER",
	specID = { 253 },
	offensive = true,
	duration = 10,
	cooldown = 60,
}

-- Rapid Fire (offensive)
LCT_SpellData[3045] = {
	class = "HUNTER",
	offensive = true,
	duration = 15,
	cooldown = 180,
}

-- Stampede (offensive)
LCT_SpellData[121818] = {
	class = "HUNTER",
	offensive = true,
	duration = 20,
	cooldown = 300,
}

-- Master's Call (freedom)
LCT_SpellData[53271] = {
	class = "HUNTER",
	pet = true,
	defensive = true,
	mobility = true,
	duration = 4,
	cooldown = 45,
}

-- Disengage (movement)
LCT_SpellData[781] = {
	class = "HUNTER",
	mobility = true,
	cooldown = 20,
	cooldown_variants = { 10 },
}

-- Alternate combat-log IDs.
LCT_SpellData[13809] = 1499
LCT_SpellData[60192] = 1499
LCT_SpellData[82941] = 1499
LCT_SpellData[148467] = 19263
