-- MoP Symbiosis cooldowns.
--
-- Symbiosis is neither a talent nor a baseline class ability. The recipient's
-- spell depends on their specialization, while the Druid's spell depends on
-- both the Druid specialization and the recipient's class. The library uses
-- these maps to reveal exactly one active Symbiosis spell per linked unit.

LCT_SymbiosisData = {
	baseAuraID = 110309,
	recipientByAura = {
		[110478] = {
			class = "DEATHKNIGHT",
			bySpec = { [250] = 113072, [251] = 113516, [252] = 113516 },
		},
		[110479] = {
			class = "HUNTER",
			bySpec = { [253] = 113073, [254] = 113073, [255] = 113073 },
		},
		[110482] = {
			class = "MAGE",
			bySpec = { [62] = 113074, [63] = 113074, [64] = 113074 },
		},
		[110483] = {
			class = "MONK",
			bySpec = { [268] = 113306, [269] = 127361, [270] = 113275 },
		},
		[110484] = {
			class = "PALADIN",
			bySpec = { [65] = 113269, [66] = 113075, [70] = 122287 },
		},
		[110485] = {
			class = "PRIEST",
			bySpec = { [256] = 113506, [257] = 113506, [258] = 113277 },
		},
		[110486] = {
			class = "ROGUE",
			bySpec = { [259] = 113613, [260] = 113613, [261] = 113613 },
		},
		[110488] = {
			class = "SHAMAN",
			bySpec = { [262] = 113286, [263] = 113286, [264] = 113289 },
		},
		[110490] = {
			class = "WARLOCK",
			bySpec = { [265] = 113295, [266] = 113295, [267] = 113295 },
		},
		[110491] = {
			class = "WARRIOR",
			bySpec = { [71] = 122294, [72] = 122294, [73] = 122286 },
		},
	},
	druidByTargetClass = {
		DEATHKNIGHT = { [102] = 110570, [103] = 122282, [104] = 122285, [105] = 110575 },
		HUNTER = { [102] = 110588, [103] = 110597, [104] = 110600, [105] = 110617 },
		MAGE = { [102] = 110621, [103] = 110693, [104] = 110694, [105] = 110696 },
		MONK = { [102] = 126458, [103] = 126449, [104] = 126453, [105] = 126456 },
		PALADIN = { [102] = 110698, [103] = 110700, [104] = 110701, [105] = 122288 },
		PRIEST = { [102] = 110707, [103] = 110715, [104] = 110717, [105] = 110718 },
		ROGUE = { [102] = 110788, [103] = 110730, [104] = 122289, [105] = 110791 },
		SHAMAN = { [102] = 110802, [103] = 110807, [104] = 110803, [105] = 110806 },
		WARLOCK = { [102] = 122291, [103] = 110810, [104] = 122290, [105] = 112970 },
		WARRIOR = { [102] = 122292, [103] = 112997, [104] = 113002, [105] = 113004 },
	},
}

local function AddSymbiosisSpell(spellID, data)
	data.symbiosis = true
	LCT_SpellData[spellID] = data
end

-- Spells granted to the non-Druid recipient.
AddSymbiosisSpell(113072, { class = "DEATHKNIGHT", specID = { 250 }, defensive = true, duration = 20, cooldown = 180 })
AddSymbiosisSpell(113516, { class = "DEATHKNIGHT", specID = { 251, 252 }, offensive = true, duration = 30, cooldown = 180 })
AddSymbiosisSpell(113073, { class = "HUNTER", specID = { 253, 254, 255 }, defensive = true, mobility = true, duration = 15, cooldown = 180 })
AddSymbiosisSpell(113074, { class = "MAGE", specID = { 62, 63, 64 }, heal = true, cooldown = 10 })
AddSymbiosisSpell(113306, { class = "MONK", specID = { 268 }, defensive = true, duration = 6, cooldown = 180 })
AddSymbiosisSpell(127361, { class = "MONK", specID = { 269 }, cc = true, stun = true, duration = 3, cooldown = 60 })
AddSymbiosisSpell(113275, { class = "MONK", specID = { 270 }, cc = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(113269, { class = "PALADIN", specID = { 65 }, heal = true, arena_disabled = true, hidden = true, cooldown = 600 })
AddSymbiosisSpell(113075, { class = "PALADIN", specID = { 66 }, defensive = true, duration = 6, cooldown = 60 })
AddSymbiosisSpell(122287, { class = "PALADIN", specID = { 70 }, offensive = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(113506, { class = "PRIEST", specID = { 256, 257 }, cc = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(113277, { class = "PRIEST", specID = { 258 }, defensive = true, duration = 8, cooldown = 480 })
AddSymbiosisSpell(113613, { class = "ROGUE", specID = { 259, 260, 261 }, defensive = true, duration = 30, cooldown = 180 })
AddSymbiosisSpell(113286, { class = "SHAMAN", specID = { 262, 263 }, interrupt = true, silence = true, duration = 4, cooldown = 60 })
AddSymbiosisSpell(113289, { class = "SHAMAN", specID = { 264 }, defensive = true, cooldown_starts_on_aura_fade = true, cooldown = 10 })
AddSymbiosisSpell(113295, { class = "WARLOCK", specID = { 265, 266, 267 }, heal = true, duration = 12, cooldown = 10 })
AddSymbiosisSpell(122294, { class = "WARRIOR", specID = { 71, 72 }, defensive = true, mobility = true, duration = 8, cooldown = 300 })
AddSymbiosisSpell(122286, { class = "WARRIOR", specID = { 73 }, defensive = true, duration = 6, cooldown = 60 })

-- Spells granted to the Druid, keyed in LCT_SymbiosisData by target class.
AddSymbiosisSpell(110570, { class = "DRUID", specID = { 102 }, defensive = true, immune = true, duration = 5, cooldown = 45 })
AddSymbiosisSpell(122282, { class = "DRUID", specID = { 103 }, offensive = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(122285, { class = "DRUID", specID = { 104 }, defensive = true, duration = 300, cooldown = 60 })
AddSymbiosisSpell(110575, { class = "DRUID", specID = { 105 }, defensive = true, duration = 12, cooldown = 180 })

AddSymbiosisSpell(110588, { class = "DRUID", specID = { 102 }, none = true, misc = true, duration = 20, cooldown_starts_on_aura_fade = true, cooldown = 30 })
AddSymbiosisSpell(110597, { class = "DRUID", specID = { 103 }, defensive = true, cooldown_starts_on_aura_fade = true, cooldown = 30 })
AddSymbiosisSpell(110600, { class = "DRUID", specID = { 104 }, cc = true, cooldown = 30 })
AddSymbiosisSpell(110617, { class = "DRUID", specID = { 105 }, immune = true, duration = 5, cooldown = 120 })

AddSymbiosisSpell(110621, { class = "DRUID", specID = { 102 }, offensive = true, cooldown = 180 })
AddSymbiosisSpell(110693, { class = "DRUID", specID = { 103 }, cc = true, duration = 8, cooldown = 25 })
AddSymbiosisSpell(110694, { class = "DRUID", specID = { 104 }, defensive = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(110696, { class = "DRUID", specID = { 105 }, immune = true, duration = 10, cooldown = 300 })

AddSymbiosisSpell(126458, { class = "DRUID", specID = { 102 }, cc = true, duration = 8, cooldown = 60 })
AddSymbiosisSpell(126449, { class = "DRUID", specID = { 103 }, cc = true, mobility = true, cooldown = 35 })
AddSymbiosisSpell(126453, { class = "DRUID", specID = { 104 }, defensive = true, duration = 8, cooldown = 60 })
AddSymbiosisSpell(126456, { class = "DRUID", specID = { 105 }, defensive = true, duration = 20, cooldown = 180 })

AddSymbiosisSpell(110698, { class = "DRUID", specID = { 102 }, cc = true, stun = true, duration = 6, cooldown = 60 })
AddSymbiosisSpell(110700, { class = "DRUID", specID = { 103 }, immune = true, duration = 8, cooldown = 300 })
AddSymbiosisSpell(110701, { class = "DRUID", specID = { 104 }, offensive = true, duration = 10, cooldown = 30 })
AddSymbiosisSpell(122288, { class = "DRUID", specID = { 105 }, dispel = true, cooldown_starts_on_dispel = true, cooldown = 8 })

AddSymbiosisSpell(110707, { class = "DRUID", specID = { 102 }, dispel = true, mass_dispel = true, cooldown = 60 })
AddSymbiosisSpell(110715, { class = "DRUID", specID = { 103 }, defensive = true, duration = 6, cooldown = 180 })
AddSymbiosisSpell(110717, { class = "DRUID", specID = { 104 }, defensive = true, cooldown = 180 })
AddSymbiosisSpell(110718, { class = "DRUID", specID = { 105 }, defensive = true, mobility = true, cooldown = 90 })

AddSymbiosisSpell(110788, { class = "DRUID", specID = { 102 }, defensive = true, immune = true, duration = 5, cooldown = 120 })
AddSymbiosisSpell(110730, { class = "DRUID", specID = { 103 }, offensive = true, cooldown = 60 })
AddSymbiosisSpell(122289, { class = "DRUID", specID = { 104 }, defensive = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(110791, { class = "DRUID", specID = { 105 }, defensive = true, duration = 15, cooldown = 180 })

AddSymbiosisSpell(110802, { class = "DRUID", specID = { 102 }, dispel = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(110807, { class = "DRUID", specID = { 103 }, offensive = true, duration = 30, cooldown = 120 })
AddSymbiosisSpell(110803, { class = "DRUID", specID = { 104 }, defensive = true, hidden = true, cooldown = 0 })
AddSymbiosisSpell(110806, { class = "DRUID", specID = { 105 }, defensive = true, duration = 15, cooldown = 120 })

AddSymbiosisSpell(122291, { class = "DRUID", specID = { 102 }, defensive = true, duration = 12, cooldown = 180 })
AddSymbiosisSpell(110810, { class = "DRUID", specID = { 103 }, offensive = true, cooldown = 30 })
AddSymbiosisSpell(122290, { class = "DRUID", specID = { 104 }, none = true, misc = true, cooldown = 15 })
AddSymbiosisSpell(112970, { class = "DRUID", specID = { 105 }, defensive = true, mobility = true, cooldown = 30 })

AddSymbiosisSpell(122292, { class = "DRUID", specID = { 102 }, defensive = true, mobility = true, duration = 10, cooldown = 30 })
AddSymbiosisSpell(112997, { class = "DRUID", specID = { 103 }, offensive = true, mass_dispel = true, duration = 10, cooldown = 300 })
AddSymbiosisSpell(113002, { class = "DRUID", specID = { 104 }, defensive = true, duration = 5, cooldown = 120 })
AddSymbiosisSpell(113004, { class = "DRUID", specID = { 105 }, cc = true, duration = 8, cooldown = 90 })

-- Solar Beam's interrupt event uses a second combat-log spell ID.
LCT_SpellData[113288] = 113286
