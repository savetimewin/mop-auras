-- luacheck: no max line length
-- MoP Classic arena cooldown data.
--
-- This file intentionally keeps data separate from the combat-log engine:
--   * CD definitions may be numbers or tables with default/spec/arena values.
--   * aliases merge alternate combat-log spell IDs into one displayed cooldown.
--   * reset/reduction/shared-CD tables describe observable cooldown modifiers.

local _, addonTable = ...;

addonTable.HUNTER_FEIGN_DEATH = 5384;
addonTable.SPELL_PVPTRINKET = 42292;
addonTable.HUNTER_SURVIVAL_SPEC_SPELL = 53301; -- Explosive Shot

addonTable.CDs = {};
addonTable.CooldownByID = {};
addonTable.CooldownMeta = {};

local function AddCooldowns(class, rows)
	local classCooldowns = {};
	addonTable.CDs[class] = classCooldowns;

	for i = 1, #rows do
		local row = rows[i];
		local spellID, duration, kind = row[1], row[2], row[3];
		local meta = row[4] or {};

		classCooldowns[spellID] = duration;
		addonTable.CooldownByID[spellID] = duration;
		meta.class = class;
		meta.kind = kind;
		meta.duration = duration;
		addonTable.CooldownMeta[spellID] = meta;
	end
end
function addonTable.ResolveBaseCooldown(definition, instanceType, specID)
	if (type(definition) == "number") then
		return definition;
	end
	if (type(definition) ~= "table") then
		return nil;
	end

	if (specID and definition[specID]) then
		return definition[specID];
	end
	if ((instanceType == "arena" or instanceType == "pvp") and definition[instanceType]) then
		return definition[instanceType];
	end
	return definition.default;
end

-- Universal PvP cooldowns and racials.
AddCooldowns(addonTable.UNKNOWN_CLASS, {
	{ 42292, 120, "pvpTrinket" }, -- PvP Trinket
	{ 59752, 120, "pvpTrinket" }, -- Every Man for Himself
	{ 7744, 120, "pvpTrinket" }, -- Will of the Forsaken
	{ 20589, 90, "freedom" }, -- Escape Artist
	{ 58984, 120, "defensive" }, -- Shadowmeld
	{ 20594, 120, "defensive" }, -- Stoneform
	{ 20549, 120, "cc" }, -- War Stomp
	{ 107079, 120, "cc" }, -- Quaking Palm
	{ 28730, 120, "offensive" }, -- Arcane Torrent (mana)
	{ 20572, 120, "offensive" }, -- Blood Fury
	{ 26297, 180, "offensive" }, -- Berserking
	{ 68992, 120, "movement" }, -- Darkflight
	{ 28880, 180, "heal" }, -- Gift of the Naaru
});

AddCooldowns("DEATHKNIGHT", {
	{ 47528, 15, "interrupt" }, -- Mind Freeze
	{ 108194, 30, "cc" }, -- Asphyxiate
	{ 108200, 60, "cc" }, -- Remorseless Winter
	{ 108199, 60, "cc" }, -- Gorefiend's Grasp
	{ 47476, 60, "cc" }, -- Strangulate
	{ 49576, 25, "movement" }, -- Death Grip
	{ 48707, 45, "defensive" }, -- Anti-Magic Shell
	{ 48792, 180, "defensive" }, -- Icebound Fortitude
	{ 114556, 180, "defensive" }, -- Purgatory
	{ 51052, 120, "defensive" }, -- Anti-Magic Zone
	{ 48743, 120, "heal" }, -- Death Pact
	{ 49028, 90, "defensive" }, -- Dancing Rune Weapon
	{ 51271, 60, "offensive" }, -- Pillar of Frost
	{ 49206, 180, "offensive" }, -- Summon Gargoyle
	{ 49016, 180, "offensive" }, -- Unholy Frenzy
	{ 47568, 300, "offensive" }, -- Empower Rune Weapon
	{ 108201, 120, "counterCC" }, -- Desecrated Ground
	{ 49039, 120, "counterCC" }, -- Lichborne
	{ 96268, 30, "movement" }, -- Death's Advance
	{ 77606, { default = 60, [250] = 30 }, "other" }, -- Dark Simulacrum
});

AddCooldowns("DRUID", {
	{ 80964, 15, "interrupt" }, -- Skull Bash
	{ 78675, 60, "interrupt" }, -- Solar Beam
	{ 88423, 8, "dispel", { startOnDispel = true } }, -- Nature's Cure
	{ 2782, 8, "dispel", { startOnDispel = true } }, -- Remove Corruption
	{ 99, 30, "cc" }, -- Disorienting Roar
	{ 5211, 50, "cc" }, -- Mighty Bash
	{ 132469, 30, "cc" }, -- Typhoon
	{ 102359, 30, "cc" }, -- Mass Entanglement
	{ 16689, 60, "cc" }, -- Nature's Grasp
	{ 22812, { default = 60, [104] = 30, [105] = 45 }, "defensive" }, -- Barkskin
	{ 106922, 180, "defensive" }, -- Might of Ursoc
	{ 108238, 120, "heal" }, -- Renewal
	{ 61336, 180, "defensive" }, -- Survival Instincts
	{ 102342, { default = 60, arena = 30, pvp = 30 }, "defensive" }, -- Ironbark (PvP set: 30s)
	{ 124974, 90, "defensive" }, -- Nature's Vigil
	{ 740, { default = 480, [105] = 180 }, "defensive" }, -- Tranquility
	{ 50334, 180, "offensive" }, -- Berserk (Guardian)
	{ 106951, 180, "offensive" }, -- Berserk (Feral)
	{ 112071, 180, "offensive" }, -- Celestial Alignment
	{ 102558, 180, "offensive" }, -- Incarnation
	{ 132158, 60, "other", { startOnAuraRemoved = true } }, -- Nature's Swiftness
	{ 29166, 180, "other" }, -- Innervate
});

AddCooldowns("HUNTER", {
	{ 147362, 24, "interrupt" }, -- Counter Shot
	{ 34490, 24, "interrupt" }, -- Silencing Shot
	{ 109248, 45, "cc" }, -- Binding Shot
	{ 1499, { default = 30, [255] = 24 }, "cc" }, -- Freezing Trap
	{ 19577, 60, "cc" }, -- Intimidation
	{ 19503, 30, "cc" }, -- Scatter Shot
	{ 19386, 45, "cc" }, -- Wyvern Sting
	{ 19263, 180, "defensive", { charges = 2 } }, -- Deterrence
	{ 53480, 60, "defensive" }, -- Roar of Sacrifice
	{ 51753, 60, "defensive" }, -- Camouflage
	{ 109304, 120, "heal" }, -- Exhilaration
	{ 19574, 60, "offensive" }, -- Bestial Wrath
	{ 131894, 120, "offensive" }, -- A Murder of Crows
	{ 121818, 300, "offensive" }, -- Stampede
	{ 3045, 180, "offensive" }, -- Rapid Fire
	{ 53271, 45, "freedom" }, -- Master's Call
	{ 781, 20, "movement" }, -- Disengage
	{ 5384, 30, "other", { startOnAuraRemoved = true } }, -- Feign Death
});

AddCooldowns("MAGE", {
	{ 2139, 24, "interrupt" }, -- Counterspell
	{ 475, 8, "dispel", { startOnDispel = true } }, -- Remove Curse
	{ 44572, 30, "cc" }, -- Deep Freeze
	{ 31661, 20, "cc" }, -- Dragon's Breath
	{ 113724, 45, "cc" }, -- Ring of Frost
	{ 45438, 300, "defensive" }, -- Ice Block
	{ 108978, { default = 180, arena = 90, pvp = 90 }, "defensive", { startOnAuraRemoved = true } }, -- Alter Time
	{ 11958, 180, "defensive" }, -- Cold Snap
	{ 86949, 120, "defensive" }, -- Cauterize
	{ 110959, 90, "defensive" }, -- Greater Invisibility
	{ 115610, 25, "defensive" }, -- Temporal Shield
	{ 11426, 25, "defensive" }, -- Ice Barrier
	{ 12042, 90, "offensive" }, -- Arcane Power
	{ 11129, 45, "offensive" }, -- Combustion
	{ 12472, 180, "offensive" }, -- Icy Veins
	{ 55342, 180, "offensive" }, -- Mirror Image
	{ 12043, 90, "other", { startOnAuraRemoved = true } }, -- Presence of Mind
	{ 1953, 15, "movement" }, -- Blink
});

AddCooldowns("MONK", {
	{ 137562, 120, "pvpTrinket" }, -- Nimble Brew
	{ 116705, 15, "interrupt" }, -- Spear Hand Strike
	{ 115450, 8, "dispel", { startOnDispel = true } }, -- Detox
	{ 119381, 45, "cc" }, -- Leg Sweep
	{ 116844, 45, "cc" }, -- Ring of Peace
	{ 115078, 15, "cc" }, -- Paralysis
	{ 117368, 60, "cc" }, -- Grapple Weapon
	{ 115213, 180, "defensive" }, -- Avert Harm
	{ 116849, 120, "defensive" }, -- Life Cocoon
	{ 122278, 90, "defensive" }, -- Dampen Harm
	{ 122783, 90, "defensive" }, -- Diffuse Magic
	{ 115203, 180, "defensive" }, -- Fortifying Brew
	{ 122470, 90, "defensive" }, -- Touch of Karma
	{ 115176, 180, "defensive" }, -- Zen Meditation
	{ 115310, 180, "defensive" }, -- Revival
	{ 123904, 180, "offensive" }, -- Invoke Xuen
	{ 113656, 25, "offensive" }, -- Fists of Fury
	{ 116841, 30, "freedom" }, -- Tiger's Lust
	{ 109132, 20, "movement", { charges = 2 } }, -- Roll
	{ 119996, 25, "movement" }, -- Transcendence: Transfer
});

AddCooldowns("PALADIN", {
	{ 96231, 15, "interrupt" }, -- Rebuke
	{ 31935, 15, "interrupt" }, -- Avenger's Shield
	{ 4987, 8, "dispel", { startOnDispel = true } }, -- Cleanse
	{ 115750, 120, "cc" }, -- Blinding Light
	{ 853, 60, "cc" }, -- Hammer of Justice
	{ 105593, 30, "cc" }, -- Fist of Justice
	{ 20066, 15, "cc" }, -- Repentance
	{ 642, 300, "defensive" }, -- Divine Shield
	{ 1022, 300, "defensive" }, -- Hand of Protection
	{ 114039, 30, "defensive" }, -- Hand of Purity
	{ 6940, 120, "defensive" }, -- Hand of Sacrifice
	{ 31850, 180, "defensive" }, -- Ardent Defender
	{ 498, 60, "defensive" }, -- Divine Protection
	{ 86659, 180, "defensive" }, -- Guardian of Ancient Kings
	{ 31821, 180, "defensive" }, -- Devotion Aura
	{ 86669, 180, "heal" }, -- Guardian of Ancient Kings (Holy)
	{ 31884, 180, "offensive" }, -- Avenging Wrath
	{ 31842, 180, "offensive" }, -- Divine Favor
	{ 114157, 60, "offensive" }, -- Execution Sentence
	{ 86698, 180, "offensive" }, -- Guardian of Ancient Kings (Ret)
	{ 1044, 25, "freedom" }, -- Hand of Freedom
});

AddCooldowns("PRIEST", {
	{ 15487, 45, "interrupt" }, -- Silence
	{ 527, 15, "dispel", { startOnDispel = true } }, -- Purify
	{ 32375, 15, "dispel" }, -- Mass Dispel
	{ 88625, 30, "cc" }, -- Holy Word: Chastise
	{ 64044, 45, "cc" }, -- Psychic Horror
	{ 108921, 45, "cc" }, -- Psyfiend
	{ 8122, 30, "cc" }, -- Psychic Scream
	{ 108920, 30, "cc" }, -- Void Tendrils
	{ 19236, 120, "defensive" }, -- Desperate Prayer
	{ 47585, 120, "defensive" }, -- Dispersion
	{ 108968, 300, "defensive" }, -- Void Shift
	{ 47788, 180, "defensive" }, -- Guardian Spirit
	{ 33206, 180, "defensive" }, -- Pain Suppression
	{ 64843, 180, "defensive" }, -- Divine Hymn
	{ 62618, 180, "defensive" }, -- Power Word: Barrier
	{ 10060, 120, "offensive" }, -- Power Infusion
	{ 34433, 180, "offensive" }, -- Shadowfiend
	{ 6346, 180, "counterCC" }, -- Fear Ward
	{ 89485, 45, "counterCC", { startOnAuraRemoved = true } }, -- Inner Focus
	{ 73325, 90, "movement" }, -- Leap of Faith
});

AddCooldowns("ROGUE", {
	{ 1766, 15, "interrupt" }, -- Kick
	{ 2094, 120, "cc" }, -- Blind
	{ 408, 20, "cc" }, -- Kidney Shot
	{ 76577, 180, "cc" }, -- Smoke Bomb
	{ 51722, 60, "cc" }, -- Dismantle
	{ 31230, 90, "defensive" }, -- Cheat Death
	{ 31224, 60, "defensive" }, -- Cloak of Shadows
	{ 74001, 120, "defensive" }, -- Combat Readiness
	{ 5277, 120, "defensive" }, -- Evasion
	{ 14185, 300, "defensive" }, -- Preparation
	{ 1856, 120, "defensive" }, -- Vanish
	{ 13750, 180, "offensive" }, -- Adrenaline Rush
	{ 51690, 120, "offensive" }, -- Killing Spree
	{ 121471, 180, "offensive" }, -- Shadow Blades
	{ 51713, 60, "offensive" }, -- Shadow Dance
	{ 79140, 120, "offensive" }, -- Vendetta
	{ 36554, 20, "movement" }, -- Shadowstep
	{ 2983, 60, "movement" }, -- Sprint
});

AddCooldowns("SHAMAN", {
	{ 57994, 12, "interrupt" }, -- Wind Shear
	{ 77130, 8, "dispel", { startOnDispel = true } }, -- Purify Spirit
	{ 51886, 8, "dispel", { startOnDispel = true } }, -- Cleanse Spirit
	{ 108269, 45, "cc" }, -- Capacitor Totem
	{ 51514, 45, "cc" }, -- Hex
	{ 51490, 45, "cc" }, -- Thunderstorm
	{ 51485, 30, "cc" }, -- Earthgrab Totem
	{ 108271, 90, "defensive" }, -- Astral Shift
	{ 108285, 180, "defensive" }, -- Call of the Elements
	{ 2062, 300, "defensive" }, -- Earth Elemental Totem
	{ 30884, 30, "defensive" }, -- Nature's Guardian
	{ 30823, 60, "defensive" }, -- Shamanistic Rage
	{ 108270, 60, "defensive" }, -- Stone Bulwark Totem
	{ 108281, 120, "defensive" }, -- Ancestral Guidance
	{ 108280, 180, "defensive" }, -- Healing Tide Totem
	{ 98008, 180, "defensive" }, -- Spirit Link Totem
	{ 114049, 180, "offensive" }, -- Ascendance
	{ 16166, 90, "offensive" }, -- Elemental Mastery
	{ 51533, 120, "offensive" }, -- Feral Spirit
	{ 2894, 300, "offensive" }, -- Fire Elemental Totem
	{ 8177, 25, "counterCC" }, -- Grounding Totem
	{ 8143, 60, "counterCC" }, -- Tremor Totem
	{ 16188, 90, "other", { startOnAuraRemoved = true } }, -- Ancestral Swiftness
	{ 16190, 180, "other" }, -- Mana Tide Totem
	{ 58875, 60, "freedom" }, -- Spirit Walk
});

AddCooldowns("WARLOCK", {
	{ 108482, 60, "pvpTrinket" }, -- Unbound Will
	{ 108501, 120, "interrupt" }, -- Grimoire of Service
	{ 19647, 24, "interrupt" }, -- Spell Lock
	{ 19505, 15, "dispel" }, -- Devour Magic
	{ 6789, 45, "cc" }, -- Mortal Coil
	{ 5484, 40, "cc" }, -- Howl of Terror
	{ 30283, 30, "cc" }, -- Shadowfury
	{ 111397, 30, "defensive" }, -- Blood Horror
	{ 110913, 180, "defensive" }, -- Dark Bargain
	{ 108416, 60, "defensive" }, -- Sacrificial Pact
	{ 104773, 180, "defensive" }, -- Unending Resolve
	{ 108359, 120, "heal" }, -- Dark Regeneration
	{ 113860, 120, "offensive" }, -- Dark Soul: Misery
	{ 113861, 120, "offensive" }, -- Dark Soul: Knowledge
	{ 113858, 120, "offensive" }, -- Dark Soul: Instability
	{ 48020, { default = 30, arena = 25, pvp = 25 }, "movement" }, -- Demonic Circle: Teleport
	{ 80240, 25, "other" }, -- Havoc
});

AddCooldowns("WARRIOR", {
	{ 6552, 15, "interrupt" }, -- Pummel
	{ 102060, 40, "interrupt" }, -- Disrupting Shout
	{ 5246, 90, "cc" }, -- Intimidating Shout
	{ 46968, 40, "cc" }, -- Shockwave
	{ 107570, 30, "cc" }, -- Storm Bolt
	{ 118000, 60, "cc" }, -- Dragon Roar
	{ 676, 60, "cc" }, -- Disarm
	{ 114030, 120, "defensive" }, -- Vigilance
	{ 114203, 180, "defensive" }, -- Demoralizing Banner
	{ 118038, 120, "defensive" }, -- Die by the Sword
	{ 55694, 60, "heal" }, -- Enraged Regeneration
	{ 12975, 180, "defensive" }, -- Last Stand
	{ 871, 180, "defensive" }, -- Shield Wall
	{ 97462, 180, "defensive" }, -- Rallying Cry
	{ 107574, 180, "offensive" }, -- Avatar
	{ 46924, 60, "offensive" }, -- Bladestorm
	{ 86346, 20, "offensive" }, -- Colossus Smash
	{ 1719, 180, "offensive" }, -- Recklessness
	{ 114207, 180, "offensive" }, -- Skull Banner
	{ 18499, 30, "counterCC" }, -- Berserker Rage
	{ 3411, 30, "counterCC" }, -- Intervene
	{ 114029, 30, "counterCC" }, -- Safeguard
	{ 114028, 60, "counterCC" }, -- Mass Spell Reflection
	{ 23920, 25, "counterCC" }, -- Spell Reflection
	{ 64382, 300, "other" }, -- Shattering Throw
});

-- Alternate combat-log IDs that should update one canonical icon.
addonTable.CooldownAliases = {
	-- Druid
	[80965] = 80964,
	-- Hunter trap and aura variants
	[60192] = 1499,
	[82941] = 1499,
	[13809] = 1499,
	[148467] = 19263,
	-- Mage
	[110909] = 108978,
	-- Monk
	[121827] = 109132,
	[115008] = 109132,
	-- Priest
	[45182] = 31230,
	-- Proc auras that reveal passive cooldowns
	[123981] = 114556,
	[87024] = 86949,
	[31616] = 30884,
	-- Shaman
	[32182] = 2894,
	-- Warlock pet variants
	[119899] = 19647,
	[119905] = 19647,
	[132411] = 19647,
	[118093] = 19647,
	[119907] = 19647,
	[132413] = 19647,
	[119910] = 19647,
	[132409] = 19647,
	[115781] = 19647,
	[119911] = 19647,
	[89808] = 19505,
	[17767] = 19505,
	-- Racial variants
	[33697] = 20572,
	[33702] = 20572,
	[25046] = 28730,
	[50613] = 28730,
	[129597] = 28730,
	[69179] = 28730,
	[80483] = 28730,
	[59542] = 28880,
	[59543] = 28880,
	[59544] = 28880,
	[59545] = 28880,
	[59547] = 28880,
	[59548] = 28880,
	[121093] = 28880,
};

addonTable.HUNTER_TRAP_SPELLS = {
	[1499] = true,
	[60192] = true,
	[13809] = true,
	[82941] = true,
};

-- Spec hints are learned only from unambiguous combat-log spells.
addonTable.SpecHints = {
	[49028] = 250, [55233] = 250, [48982] = 250,
	[51271] = 251,
	[49206] = 252, [49016] = 252,
	[78675] = 102, [112071] = 102,
	[106951] = 103, [5217] = 103,
	[50334] = 104, [62606] = 104,
	[102342] = 105, [88423] = 105,
	[19574] = 253,
	[34490] = 254,
	[53301] = 255, [3674] = 255,
	[12042] = 62,
	[11129] = 63, [31661] = 63,
	[12472] = 64, [84714] = 64,
	[115203] = 268,
	[122470] = 269, [113656] = 269,
	[116849] = 270, [115310] = 270,
	[31842] = 65, [86669] = 65,
	[31850] = 66, [86659] = 66,
	[86698] = 70,
	[33206] = 256, [62618] = 256,
	[47788] = 257, [64843] = 257, [88625] = 257,
	[15487] = 258, [47585] = 258, [64044] = 258,
	[79140] = 259,
	[13750] = 260, [51690] = 260,
	[51713] = 261,
	[51490] = 262, [16166] = 262,
	[30823] = 263, [51533] = 263,
	[98008] = 264, [16190] = 264,
	[113860] = 265,
	[113861] = 266,
	[113858] = 267,
	[12975] = 73,
};

addonTable.CooldownResets = {
	[11958] = { 45438, 120, 122 }, -- Cold Snap
	[14185] = { 2983, 1856, 5277, 51722 }, -- Preparation
	[108285] = { 108269, 51485, 8177, 5394, 108270, 8143, 108273 }, -- Call of the Elements
};

addonTable.CooldownReductions = {
	-- Mage PvP 2-piece: successful Counterspell interrupts reduce its remaining CD by 4s.
	[2139] = { event = "SPELL_INTERRUPT", amount = 4, spells = { 2139 } },
};

-- Restless Blades: the combat log does not expose combo points, so the arena
-- estimate uses the five-point (10 second) reduction used by OmniCD.
addonTable.CastReductions = {
	[2098] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471, 2983 } },
	[1943] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471, 2983 } },
	[121411] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471, 2983 } },
	[26679] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471, 2983 } },
};

addonTable.DamageTakenReductions = {
	[5484] = 1, -- Howl of Terror: incoming damage reduces the remaining CD.
};

addonTable.SharedCooldowns = {
	[42292] = { { 59752, 120, true }, { 7744, 30, true } },
	[59752] = { { 42292, 120 } },
	[7744] = { { 42292, 30 } },
	[2894] = { { 2062, 60, true } },
	[2062] = { { 2894, 60, true } },
	[6552] = { { 102060, 15, true } },
	[102060] = { { 6552, 15, true } },
};

addonTable.Interrupts = {};
addonTable.Trinkets = {};
for spellID, meta in pairs(addonTable.CooldownMeta) do
	if (meta.kind == "interrupt") then
		addonTable.Interrupts[spellID] = true;
	elseif (meta.kind == "pvpTrinket") then
		addonTable.Trinkets[spellID] = true;
	end
end
