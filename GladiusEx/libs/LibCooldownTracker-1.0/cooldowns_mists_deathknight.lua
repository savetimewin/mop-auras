-- DEATHKNIGHT arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Mind Freeze (interrupt)
LCT_SpellData[47528] = {
	class = "DEATHKNIGHT",
	interrupt = true,
	cooldown = 15,
}

-- Asphyxiate (cc)
LCT_SpellData[108194] = {
	class = "DEATHKNIGHT",
	talent = true,
	cc = true,
	stun = true,
	silence = true,
	replaces = 47476,
	cooldown = 30,
}

-- Remorseless Winter (cc)
LCT_SpellData[108200] = {
	class = "DEATHKNIGHT",
	talent = true,
	cc = true,
	stun = true,
	duration = 8,
	cooldown = 60,
}

-- Gorefiend's Grasp (aoeCC)
LCT_SpellData[108199] = {
	class = "DEATHKNIGHT",
	talent = true,
	cc = true,
	cooldown = 60,
}

-- Death Grip (disarm)
LCT_SpellData[49576] = {
	class = "DEATHKNIGHT",
	cc = true,
	cooldown = 25,
}

-- Strangulate (disarm)
LCT_SpellData[47476] = {
	class = "DEATHKNIGHT",
	cc = true,
	silence = true,
	cooldown = 60,
}

-- Anti-Magic Shell (defensive)
LCT_SpellData[48707] = {
	class = "DEATHKNIGHT",
	defensive = true,
	duration = 5,
	cooldown = 45,
}

-- Bone Shield
LCT_SpellData[49222] = {
	class = "DEATHKNIGHT",
	specID = { 250 },
	defensive = true,
	cooldown = 60,
}

-- Dancing Rune Weapon (defensive)
LCT_SpellData[49028] = {
	class = "DEATHKNIGHT",
	specID = { 250 },
	defensive = true,
	duration = 8,
	cooldown = 90,
}

-- Icebound Fortitude (defensive)
LCT_SpellData[48792] = {
	class = "DEATHKNIGHT",
	defensive = true,
	duration = 8,
	cooldown = 180,
}

-- Purgatory (defensive)
LCT_SpellData[114556] = {
	class = "DEATHKNIGHT",
	talent = true,
	defensive = true,
	cooldown = 180,
}

-- Rune Tap
LCT_SpellData[48982] = {
	class = "DEATHKNIGHT",
	specID = { 250 },
	defensive = true,
	cooldown = 30,
}

-- Vampiric Blood
LCT_SpellData[55233] = {
	class = "DEATHKNIGHT",
	specID = { 250 },
	defensive = true,
	duration = 10,
	cooldown = 60,
}

-- Anti-Magic Zone (raidDefensive)
LCT_SpellData[51052] = {
	class = "DEATHKNIGHT",
	talent = true,
	defensive = true,
	duration = 3,
	cooldown = 120,
}

-- Death Pact (heal)
LCT_SpellData[48743] = {
	class = "DEATHKNIGHT",
	talent = true,
	heal = true,
	cooldown = 120,
}

-- Empower Rune Weapon (offensive)
LCT_SpellData[47568] = {
	class = "DEATHKNIGHT",
	offensive = true,
	cooldown = 300,
}

-- Pillar of Frost (offensive)
LCT_SpellData[51271] = {
	class = "DEATHKNIGHT",
	specID = { 251 },
	offensive = true,
	duration = 20,
	cooldown = 60,
}

-- Summon Gargoyle (offensive)
LCT_SpellData[49206] = {
	class = "DEATHKNIGHT",
	specID = { 252 },
	offensive = true,
	duration = 30,
	cooldown = 180,
}

-- Unholy Blight
LCT_SpellData[115989] = {
	class = "DEATHKNIGHT",
	talent = true,
	offensive = true,
	cooldown = 90,
}

-- Unholy Frenzy (offensive)
LCT_SpellData[49016] = {
	class = "DEATHKNIGHT",
	specID = { 252 },
	offensive = true,
	cooldown = 180,
}

-- Desecrated Ground (counterCC)
LCT_SpellData[108201] = {
	class = "DEATHKNIGHT",
	talent = true,
	defensive = true,
	duration = 10,
	cooldown = 120,
}

-- Lichborne (counterCC)
LCT_SpellData[49039] = {
	class = "DEATHKNIGHT",
	talent = true,
	defensive = true,
	cc_break = true,
	duration = 10,
	cooldown = 120,
}

-- Death's Advance (movement)
LCT_SpellData[96268] = {
	class = "DEATHKNIGHT",
	talent = true,
	mobility = true,
	duration = 6,
	cooldown = 30,
}

-- Dark Simulacrum
LCT_SpellData[77606] = {
	class = "DEATHKNIGHT",
	misc = true,
	cooldown = 60,
	cooldown_overload = { [250] = 30 },
}

-- Leap (Unholy ghoul)
LCT_SpellData[47482] = {
	class = "DEATHKNIGHT",
	pet = true,
	interrupt = true,
	cc = true,
	cooldown = 30,
}

-- Monstrous Blow (Dark Transformation ghoul)
LCT_SpellData[91797] = {
	class = "DEATHKNIGHT",
	pet = true,
	offensive = true,
	cc = true,
	stun = true,
	cooldown = 60,
}

-- Alternate combat-log IDs.
LCT_SpellData[123981] = 114556
