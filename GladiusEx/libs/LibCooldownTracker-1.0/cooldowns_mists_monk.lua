-- MONK arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Nimble Brew (pvptrinket)
LCT_SpellData[137562] = {
	class = "MONK",
	defensive = true,
	mobility = true,
	duration = 6,
	cooldown = 120,
}

-- Spear Hand Strike (interrupt)
LCT_SpellData[116705] = {
	class = "MONK",
	interrupt = true,
	silence = true,
	cooldown = 15,
}

-- Detox (dispel)
LCT_SpellData[115450] = {
	class = "MONK",
	dispel = true,
	cooldown_starts_on_dispel = true,
	cooldown = 8,
}

-- Paralysis (cc)
LCT_SpellData[115078] = {
	class = "MONK",
	cc = true,
	cooldown = 15,
}

-- Leg Sweep (aoeCC)
LCT_SpellData[119381] = {
	class = "MONK",
	talent = true,
	cc = true,
	stun = true,
	cooldown = 45,
}

-- Ring of Peace (aoeCC)
LCT_SpellData[116844] = {
	class = "MONK",
	talent = true,
	cc = true,
	duration = 8,
	cooldown = 45,
}

-- Grapple Weapon (disarm)
LCT_SpellData[117368] = {
	class = "MONK",
	cc = true,
	cooldown = 60,
}

-- Dampen Harm (defensive)
LCT_SpellData[122278] = {
	class = "MONK",
	talent = true,
	defensive = true,
	duration = 45,
	cooldown = 90,
}

-- Diffuse Magic (defensive)
LCT_SpellData[122783] = {
	class = "MONK",
	talent = true,
	defensive = true,
	duration = 6,
	cooldown = 90,
}

-- Fortifying Brew (defensive)
LCT_SpellData[115203] = {
	class = "MONK",
	defensive = true,
	duration = 20,
	cooldown = 180,
}

-- Dematerialize (Mistweaver passive immunity / 10-second internal cooldown)
LCT_SpellData[122465] = {
	class = "MONK",
	specID = { 270 },
	immune = true,
	track_on_destination = true,
	duration = 2.5,
	cooldown = 10,
}

-- Touch of Karma (defensive)
LCT_SpellData[122470] = {
	class = "MONK",
	specID = { 269 },
	defensive = true,
	duration = 10,
	cooldown = 90,
}

-- Zen Meditation (defensive)
LCT_SpellData[115176] = {
	class = "MONK",
	defensive = true,
	duration = 8,
	cooldown = 180,
}

-- Avert Harm (externalDefensive)
LCT_SpellData[115213] = {
	class = "MONK",
	specID = { 268 },
	defensive = true,
	cooldown = 180,
}

-- Life Cocoon (externalDefensive)
LCT_SpellData[116849] = {
	class = "MONK",
	specID = { 270 },
	defensive = true,
	duration = 12,
	cooldown = 120,
}

-- Revival (raidDefensive)
LCT_SpellData[115310] = {
	class = "MONK",
	specID = { 270 },
	defensive = true,
	mass_dispel = true,
	cooldown = 180,
}

-- Fists of Fury (offensive)
LCT_SpellData[113656] = {
	class = "MONK",
	specID = { 269 },
	offensive = true,
	duration = 4,
	cooldown = 25,
}

-- Energizing Brew (offensive)
LCT_SpellData[115288] = {
	class = "MONK",
	specID = { 269 },
	offensive = true,
	duration = 6,
	cooldown = 60,
}

-- Invoke Xuen, the White Tiger (offensive)
LCT_SpellData[132578] = {
	class = "MONK",
	talent = true,
	offensive = true,
	cooldown = 180,
}

-- Hidden threat aura used by older data sources.
LCT_SpellData[123995] = 132578

-- Tiger's Lust (freedom)
LCT_SpellData[116841] = {
	class = "MONK",
	talent = true,
	defensive = true,
	mobility = true,
	duration = 6,
	cooldown = 30,
}

-- Chi Torpedo (movement)
LCT_SpellData[115008] = {
	class = "MONK",
	talent = true,
	mobility = true,
	charges = 2,
	replaces = 109132,
	cooldown = 20,
	cooldown_variants = { 15 },
}

-- Flying Serpent Kick (movement)
LCT_SpellData[101545] = {
	class = "MONK",
	specID = { 269 },
	mobility = true,
	duration = 2,
	cooldown = 25,
}

-- Roll (movement)
LCT_SpellData[109132] = {
	class = "MONK",
	mobility = true,
	charges = 2,
	cooldown = 20,
	cooldown_variants = { 15 },
}

-- Clash (gap closer / stun)
LCT_SpellData[122057] = {
	class = "MONK",
	specID = { 268 },
	cc = true,
	stun = true,
	mobility = true,
	duration = 4,
	cooldown = 35,
}

-- Transcendence: Transfer (movement)
LCT_SpellData[119996] = {
	class = "MONK",
	defensive = true,
	mobility = true,
	cooldown = 25,
	cooldown_variants = { 20 },
}
