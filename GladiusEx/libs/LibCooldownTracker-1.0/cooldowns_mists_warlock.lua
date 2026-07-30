-- WARLOCK arena cooldowns.
-- Generated from OmniCD's MoP spellDefaults; items and racials are intentionally excluded.

-- Unbound Will (pvptrinket)
LCT_SpellData[108482] = {
	class = "WARLOCK",
	talent = true,
	defensive = true,
	mobility = true,
	cooldown = 60,
}

-- Grimoire of Service (interrupt)
LCT_SpellData[108501] = {
	class = "WARLOCK",
	talent = true,
	interrupt = true,
	cooldown = 120,
}

-- Spell Lock (interrupt)
LCT_SpellData[19647] = {
	class = "WARLOCK",
	pet = true,
	interrupt = true,
	silence = true,
	cooldown = 24,
}

-- Devour Magic (dispel)
LCT_SpellData[19505] = {
	class = "WARLOCK",
	pet = true,
	dispel = true,
	purge = true,
	cooldown = 15,
}

-- Axe Toss (Felguard/Wrathguard stun)
LCT_SpellData[89766] = {
	class = "WARLOCK",
	specID = { 266 },
	pet = true,
	cc = true,
	stun = true,
	duration = 4,
	cooldown = 30,
}

-- Mortal Coil (cc)
LCT_SpellData[6789] = {
	class = "WARLOCK",
	talent = true,
	cc = true,
	cooldown = 45,
}

-- Howl of Terror (aoeCC)
LCT_SpellData[5484] = {
	class = "WARLOCK",
	cc = true,
	reduce_on_damage_taken = 1,
	cooldown = 40,
}

-- Shadowfury (aoeCC)
LCT_SpellData[30283] = {
	class = "WARLOCK",
	talent = true,
	cc = true,
	stun = true,
	cooldown = 30,
}

-- Dark Bargain (defensive)
LCT_SpellData[110913] = {
	class = "WARLOCK",
	talent = true,
	defensive = true,
	duration = 8,
	cooldown = 180,
}

-- Sacrificial Pact (defensive)
LCT_SpellData[108416] = {
	class = "WARLOCK",
	talent = true,
	defensive = true,
	duration = 20,
	cooldown = 60,
}

-- Unending Resolve (defensive)
LCT_SpellData[104773] = {
	class = "WARLOCK",
	defensive = true,
	duration = 8,
	cooldown = 180,
	cooldown_variants = { 120 },
}

-- Dark Regeneration (heal)
LCT_SpellData[108359] = {
	class = "WARLOCK",
	talent = true,
	heal = true,
	duration = 12,
	cooldown = 120,
}

-- Dark Soul: Instability (offensive)
LCT_SpellData[113858] = {
	class = "WARLOCK",
	specID = { 267 },
	offensive = true,
	duration = 20,
	opt_charges = 2,
	cooldown = 120,
}

-- Dark Soul: Knowledge (offensive)
LCT_SpellData[113861] = {
	class = "WARLOCK",
	specID = { 266 },
	offensive = true,
	duration = 20,
	opt_charges = 2,
	cooldown = 120,
}

-- Dark Soul: Misery (offensive)
LCT_SpellData[113860] = {
	class = "WARLOCK",
	specID = { 265 },
	offensive = true,
	duration = 20,
	opt_charges = 2,
	cooldown = 120,
}

-- Demonic Circle: Teleport (movement)
LCT_SpellData[48020] = {
	class = "WARLOCK",
	defensive = true,
	mobility = true,
	cooldown = 30,
	cooldown_variants = { 26, 25, 21 },
}

-- Demonic Gateway reuse debuff. This applies to the player who used a
-- gateway, regardless of class, and is intentionally hidden until observed.
LCT_SpellData[113942] = {
	universal = true,
	detected_only = true,
	track_on_destination = true,
	mobility = true,
	duration = 60,
	cooldown = 60,
}

-- Alternate combat-log IDs.
LCT_SpellData[6358] = 19505
LCT_SpellData[6360] = 19647
LCT_SpellData[17767] = 19505
LCT_SpellData[89751] = 19647
LCT_SpellData[89808] = 19505
LCT_SpellData[111859] = 108501
LCT_SpellData[111895] = 108501
LCT_SpellData[111896] = 108501
LCT_SpellData[111897] = 108501
LCT_SpellData[111898] = 108501
LCT_SpellData[115268] = 19505
LCT_SpellData[115276] = 19505
LCT_SpellData[115284] = 19505
LCT_SpellData[115770] = 19647
LCT_SpellData[115781] = 19647
LCT_SpellData[115831] = 19647
LCT_SpellData[118093] = 19647
LCT_SpellData[119899] = 19647
LCT_SpellData[119905] = 19647
LCT_SpellData[119907] = 19647
LCT_SpellData[119909] = 19647
LCT_SpellData[119910] = 19647
LCT_SpellData[119911] = 19647
LCT_SpellData[119913] = 19647
LCT_SpellData[119914] = 19647
LCT_SpellData[119915] = 19647
LCT_SpellData[132409] = 19647
LCT_SpellData[132410] = 19647
LCT_SpellData[132411] = 19647
LCT_SpellData[132413] = 19647
LCT_SpellData[137706] = 19647

-- Cast-specific cooldown/icon overrides for merged abilities.
LCT_SpellAliases[6358] = { spellid = 19505, cooldown = 1, icon = 136175 }
LCT_SpellAliases[6360] = { spellid = 19647, cooldown = 25, icon = 460858 }
LCT_SpellAliases[17767] = { spellid = 19505, cooldown = 120, icon = 136121 }
LCT_SpellAliases[19505] = { spellid = 19505, cooldown = 15, icon = 136075 }
LCT_SpellAliases[19647] = { spellid = 19647, cooldown = 24, icon = 136174 }
LCT_SpellAliases[89751] = { spellid = 19647, cooldown = 45, icon = 236303 }
LCT_SpellAliases[89808] = { spellid = 19505, cooldown = 10, icon = 135791 }
LCT_SpellAliases[111859] = { spellid = 108501, cooldown = 120, icon = 136218 }
LCT_SpellAliases[111895] = { spellid = 108501, cooldown = 120, icon = 136221 }
LCT_SpellAliases[111896] = { spellid = 108501, cooldown = 120, icon = 136220 }
LCT_SpellAliases[111897] = { spellid = 108501, cooldown = 120, icon = 136217 }
LCT_SpellAliases[111898] = { spellid = 108501, cooldown = 120, icon = 136216 }
LCT_SpellAliases[115268] = { spellid = 19505, cooldown = 1, icon = 237185 }
LCT_SpellAliases[115276] = { spellid = 19505, cooldown = 20, icon = 135791 }
LCT_SpellAliases[115284] = { spellid = 19505, cooldown = 15, icon = 236407 }
LCT_SpellAliases[115770] = { spellid = 19647, cooldown = 25, icon = 468265 }
LCT_SpellAliases[115781] = { spellid = 19647, cooldown = 24, icon = 136028 }
LCT_SpellAliases[115831] = { spellid = 19647, cooldown = 45, icon = 236303 }
LCT_SpellAliases[118093] = { spellid = 19647, cooldown = 60, icon = 132343 }
LCT_SpellAliases[119899] = { spellid = 19647, cooldown = 30, icon = 463567 }
LCT_SpellAliases[119905] = { spellid = 19647, cooldown = 30, icon = 463567 }
LCT_SpellAliases[119907] = { spellid = 19647, cooldown = 60, icon = 132343 }
LCT_SpellAliases[119909] = { spellid = 19647, cooldown = 25, icon = 460858 }
LCT_SpellAliases[119910] = { spellid = 19647, cooldown = 24, icon = 136174 }
LCT_SpellAliases[119911] = { spellid = 19647, cooldown = 24, icon = 136028 }
LCT_SpellAliases[119913] = { spellid = 19647, cooldown = 25, icon = 468265 }
LCT_SpellAliases[119914] = { spellid = 19647, cooldown = 45, icon = 236303 }
LCT_SpellAliases[119915] = { spellid = 19647, cooldown = 45, icon = 236303 }
LCT_SpellAliases[132409] = { spellid = 19647, cooldown = 24, icon = 136174 }
LCT_SpellAliases[132410] = { spellid = 19647, cooldown = 15, icon = 236303 }
LCT_SpellAliases[132411] = { spellid = 19647, cooldown = 10, icon = 135791 }
LCT_SpellAliases[132413] = { spellid = 19647, cooldown = 120, icon = 136121 }
LCT_SpellAliases[137706] = { spellid = 19647, cooldown = 25, icon = 460858 }
