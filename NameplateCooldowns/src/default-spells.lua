-- luacheck: no max line length
-- MoP Classic arena cooldown data aligned with OmniCD's spellDefaults.
-- Class/spec/talent spells are curated here; existing racial/PvP-trinket data is left separate.

local _, addonTable = ...;

addonTable.HUNTER_FEIGN_DEATH = 5384;
addonTable.SPELL_PVPTRINKET = 42292;
addonTable.HUNTER_SURVIVAL_SPEC_SPELL = 53301;

addonTable.CDs = {};
addonTable.CooldownByID = {};
addonTable.CooldownMeta = {};

addonTable.CooldownCategories = {
	PVP_TRINKET = "pvpTrinket",
	REMOVE_CC = "removeCC",
	CONTROL = "control",
	DEFENSIVE = "defensive",
	OFFENSIVE = "offensive",
	UTILITY = "utility",
};

local Categories = addonTable.CooldownCategories;
addonTable.CooldownCategoryPriority = {
	[Categories.PVP_TRINKET] = 1,
	[Categories.REMOVE_CC] = 2,
	[Categories.CONTROL] = 3,
	[Categories.DEFENSIVE] = 4,
	[Categories.OFFENSIVE] = 5,
	[Categories.UTILITY] = 6,
};

local KindToCategory = {
	pvpTrinket = Categories.PVP_TRINKET,
	dispel = Categories.REMOVE_CC,
	freedom = Categories.REMOVE_CC,
	counterCC = Categories.REMOVE_CC,
	interrupt = Categories.CONTROL,
	cc = Categories.CONTROL,
	aoeCC = Categories.CONTROL,
	disarm = Categories.CONTROL,
	defensive = Categories.DEFENSIVE,
	externalDefensive = Categories.DEFENSIVE,
	raidDefensive = Categories.DEFENSIVE,
	immunity = Categories.DEFENSIVE,
	heal = Categories.DEFENSIVE,
	offensive = Categories.OFFENSIVE,
	movement = Categories.UTILITY,
	other = Categories.UTILITY,
};

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
		meta.category = meta.category or KindToCategory[kind] or Categories.UTILITY;
		meta.duration = duration;
		addonTable.CooldownMeta[spellID] = meta;
	end
end

function addonTable.ResolveBaseCooldown(definition, instanceType, specID)
	if (type(definition) == "number") then return definition; end
	if (type(definition) ~= "table") then return nil; end
	if (specID and definition[specID]) then return definition[specID]; end
	if ((instanceType == "arena" or instanceType == "pvp") and definition[instanceType]) then
		return definition[instanceType];
	end
	return definition.default;
end

-- Existing universal PvP cooldowns and racials (unchanged).
AddCooldowns(addonTable.UNKNOWN_CLASS, {
	{ 42292, 120, "pvpTrinket" },
	{ 59752, 120, "pvpTrinket" },
	{ 7744, 120, "counterCC" },
	{ 20589, 90, "freedom" },
	{ 58984, 120, "defensive" },
	{ 20594, 120, "defensive" },
	{ 20549, 120, "cc" },
	{ 107079, 120, "cc" },
	{ 28730, 120, "offensive", { category = Categories.CONTROL } },
	{ 20572, 120, "offensive" },
	{ 26297, 180, "offensive" },
	{ 68992, 120, "movement" },
	{ 28880, 180, "heal" },
	{ 113942, 60, "movement", { universal = true, detectedOnly = true, trackOnDestination = true, defaultDisabled = true } }, -- Demonic Gateway reuse debuff
});

AddCooldowns("DEATHKNIGHT", {
	{ 47528, 15, "interrupt" }, -- Mind Freeze
	{ 108194, 30, "cc", { talent = true } }, -- Asphyxiate
	{ 108200, 60, "cc", { talent = true } }, -- Remorseless Winter
	{ 108199, 60, "aoeCC", { talent = true } }, -- Gorefiend's Grasp
	{ 49576, 25, "disarm" }, -- Death Grip
	{ 47476, 60, "disarm" }, -- Strangulate
	{ 48707, 45, "defensive" }, -- Anti-Magic Shell
	{ 49028, 90, "defensive", { specs = { 250 } } }, -- Dancing Rune Weapon
	{ 48792, 180, "defensive" }, -- Icebound Fortitude
	{ 114556, 180, "defensive", { talent = true } }, -- Purgatory
	{ 51052, 120, "raidDefensive", { talent = true } }, -- Anti-Magic Zone
	{ 48743, 120, "heal", { talent = true } }, -- Death Pact
	{ 47568, 300, "offensive" }, -- Empower Rune Weapon
	{ 51271, 60, "offensive", { specs = { 251 } } }, -- Pillar of Frost
	{ 49206, 180, "offensive", { specs = { 252 } } }, -- Summon Gargoyle
	{ 49016, 180, "offensive", { specs = { 252 } } }, -- Unholy Frenzy
	{ 108201, 120, "counterCC", { talent = true } }, -- Desecrated Ground
	{ 49039, 120, "counterCC", { talent = true } }, -- Lichborne
	{ 96268, 30, "movement", { talent = true, defaultDisabled = true } }, -- Death's Advance
	{ 113072, 180, "defensive", { talent = true } }, -- Spell 113072
});

AddCooldowns("DRUID", {
	{ 80964, 15, "interrupt", { specs = { 103, 104 } } }, -- Skull Bash
	{ 78675, 60, "interrupt", { specs = { 102 } } }, -- Solar Beam
	{ 88423, 8, "dispel", { specs = { 105 }, startOnDispel = true } }, -- Nature's Cure
	{ 2782, 8, "dispel", { specs = { 102, 103, 104 }, startOnDispel = true } }, -- Remove Corruption
	{ 99, 30, "aoeCC", { talent = true } }, -- Disorienting Roar
	{ 5211, 50, "cc", { talent = true } }, -- Mighty Bash
	{ 132469, 30, "aoeCC", { talent = true } }, -- Typhoon
	{ 22812, { [104] = 30, [105] = 45, default = 60 }, "defensive" }, -- Barkskin
	{ 106922, 180, "defensive" }, -- Might of Ursoc
	{ 108238, 120, "defensive", { talent = true } }, -- Renewal
	{ 61336, 180, "defensive", { specs = { 103, 104 } } }, -- Survival Instincts
	{ 102342, 60, "externalDefensive", { specs = { 105 } } }, -- Ironbark (PvP set: 30s)
	{ 124974, 90, "raidDefensive", { talent = true } }, -- Nature's Vigil
	{ 740, { [105] = 180, default = 480 }, "raidDefensive" }, -- Tranquility
	{ 50334, 180, "offensive", { specs = { 104 } } }, -- Berserk (Guardian)
	{ 106951, 180, "offensive", { specs = { 103 } } }, -- Berserk (Feral)
	{ 112071, 180, "offensive", { specs = { 102 } } }, -- Celestial Alignment
	{ 102560, 180, "offensive", { specs = { 102 }, talent = true, defaultDisabled = true } }, -- Incarnation: Chosen of Elune
	{ 102543, 180, "offensive", { specs = { 103 }, talent = true, defaultDisabled = true } }, -- Incarnation: King of the Jungle
	{ 102558, 180, "offensive", { specs = { 104 }, talent = true } }, -- Incarnation: Son of Ursoc
	{ 33891, 180, "defensive", { specs = { 105 }, talent = true, defaultDisabled = true } }, -- Incarnation: Tree of Life
	{ 29166, 180, "other" }, -- Innervate
	{ 132158, 60, "other", { specs = { 102, 103, 105 }, startOnAuraRemoved = true, category = Categories.CONTROL } }, -- Nature's Swiftness
	{ 1850, 180, "movement", { defaultDisabled = true } }, -- Dash
	{ 102280, 30, "movement", { talent = true, defaultDisabled = true } }, -- Displacer Beast
	{ 102417, 15, "movement", { talent = true, defaultDisabled = true } }, -- Wild Charge
	{ 106898, 120, "movement", { defaultDisabled = true } }, -- Stampeding Roar
	{ 110570, 45, "defensive", { talent = true } }, -- Spell 110570
	{ 110575, 180, "defensive", { talent = true } }, -- Spell 110575
	{ 110617, 120, "immunity", { talent = true } }, -- Spell 110617
	{ 110696, 300, "immunity", { talent = true } }, -- Spell 110696
	{ 126458, 60, "disarm", { talent = true } }, -- Spell 126458
	{ 126449, 35, "cc", { talent = true } }, -- Spell 126449
	{ 126456, 180, "defensive", { talent = true } }, -- Spell 126456
	{ 110698, 60, "cc", { talent = true } }, -- Spell 110698
	{ 110700, 300, "immunity", { talent = true } }, -- Spell 110700
	{ 122288, 8, "dispel", { talent = true, startOnDispel = true } }, -- Spell 122288
	{ 110707, 60, "dispel", { talent = true } }, -- Spell 110707
	{ 110715, 180, "defensive", { talent = true } }, -- Spell 110715
	{ 110718, 90, "movement", { talent = true } }, -- Spell 110718
	{ 110788, 120, "defensive", { talent = true } }, -- Spell 110788
	{ 110791, 180, "defensive", { talent = true } }, -- Spell 110791
	{ 122291, 180, "defensive", { talent = true } }, -- Spell 122291
	{ 112970, 30, "movement", { talent = true } }, -- Spell 112970
	{ 113004, 90, "cc", { talent = true } }, -- Spell 113004
});

AddCooldowns("HUNTER", {
	{ 147362, 24, "interrupt", { specs = { 253, 255 } } }, -- Counter Shot
	{ 34490, 24, "interrupt", { specs = { 254 } } }, -- Silencing Shot
	{ 1499, { [255] = 24, default = 30 }, "cc" }, -- Freezing Trap
	{ 19577, 60, "cc", { talent = true } }, -- Intimidation
	{ 19503, 30, "cc" }, -- Scatter Shot
	{ 19386, 45, "cc", { talent = true } }, -- Wyvern Sting
	{ 109248, 45, "aoeCC", { talent = true } }, -- Binding Shot
	{ 19263, 180, "immunity", { charges = 2 } }, -- Deterrence
	{ 51753, 60, "defensive" }, -- Camouflage
	{ 53480, 60, "externalDefensive", { pet = true } }, -- Roar of Sacrifice
	{ 109304, 120, "heal", { talent = true } }, -- Exhilaration
	{ 131894, 120, "offensive", { talent = true } }, -- A Murder of Crows
	{ 19574, 60, "offensive", { specs = { 253 } } }, -- Bestial Wrath
	{ 3045, 180, "offensive" }, -- Rapid Fire
	{ 121818, 300, "offensive" }, -- Stampede
	{ 53271, 45, "freedom", { pet = true } }, -- Master's Call
	{ 781, 20, "movement", { defaultDisabled = true } }, -- Disengage
});

AddCooldowns("MAGE", {
	{ 2139, 24, "interrupt" }, -- Counterspell
	{ 475, 8, "dispel", { startOnDispel = true } }, -- Remove Curse
	{ 44572, 30, "cc" }, -- Deep Freeze
	{ 31661, 20, "aoeCC", { specs = { 63 } } }, -- Dragon's Breath
	{ 113724, 45, "aoeCC", { talent = true } }, -- Ring of Frost
	{ 45438, 300, "immunity" }, -- Cold Snap
	-- Start on the initial cast. Aura 110909 is absent from the combat log and
	-- the manual return uses 127140, which must not restart the cooldown.
	{ 108978, 180, "defensive" }, -- Alter Time
	{ 86949, 120, "defensive", { talent = true } }, -- Cauterize
	{ 11958, 180, "defensive", { talent = true } }, -- Cold Snap
	{ 110959, 90, "defensive", { talent = true } }, -- Greater Invisibility
	{ 115610, 25, "defensive", { talent = true } }, -- Temporal Shield
	{ 12042, 90, "offensive", { specs = { 62 } } }, -- Arcane Power
	{ 11129, 45, "offensive", { specs = { 63 } } }, -- Combustion
	{ 12472, 180, "offensive", { specs = { 64 } } }, -- Icy Veins
	{ 55342, 180, "offensive" }, -- Mirror Image
	{ 12043, 90, "other", { talent = true, startOnAuraRemoved = true, category = Categories.CONTROL } }, -- Presence of Mind
	{ 12051, 120, "other", { defaultDisabled = true } }, -- Evocation
	{ 31687, 60, "offensive", { specs = { 64 }, defaultDisabled = true } }, -- Summon Water Elemental
	{ 108843, 25, "movement", { talent = true, defaultDisabled = true } }, -- Blazing Speed
	{ 1953, 15, "movement", { optionalCharges = 2, defaultDisabled = true } }, -- Blink
});

AddCooldowns("MONK", {
	{ 137562, 120, "counterCC" }, -- Nimble Brew
	{ 116705, 15, "interrupt" }, -- Spear Hand Strike
	{ 115450, 8, "dispel", { startOnDispel = true } }, -- Detox
	{ 115078, 15, "cc" }, -- Paralysis
	{ 119381, 45, "aoeCC", { talent = true } }, -- Leg Sweep
	{ 116844, 45, "aoeCC", { talent = true } }, -- Ring of Peace
	{ 117368, 60, "disarm" }, -- Grapple Weapon
	{ 122278, 90, "defensive", { talent = true } }, -- Dampen Harm
	{ 122783, 90, "defensive", { talent = true } }, -- Diffuse Magic
	{ 115203, 180, "defensive" }, -- Fortifying Brew
	{ 122465, 10, "immunity", { specs = { 270 }, trackOnDestination = true, defaultDisabled = true } }, -- Dematerialize
	{ 122470, 90, "defensive", { specs = { 269 } } }, -- Touch of Karma
	{ 115176, 180, "defensive", { category = Categories.OFFENSIVE } }, -- Zen Meditation
	{ 115213, 180, "externalDefensive", { specs = { 268 } } }, -- Avert Harm
	{ 116849, 120, "externalDefensive", { specs = { 270 } } }, -- Life Cocoon
	{ 115310, 180, "raidDefensive", { specs = { 270 }, category = Categories.REMOVE_CC } }, -- Revival
	{ 113656, 25, "offensive", { specs = { 269 }, defaultDisabled = true } }, -- Fists of Fury
	{ 115288, 60, "offensive", { specs = { 269 }, defaultDisabled = true } }, -- Energizing Brew
	{ 123904, 180, "offensive", { talent = true, defaultDisabled = true } }, -- Invoke Xuen, the White Tiger
	{ 116841, 30, "freedom", { talent = true } }, -- Tiger's Lust
	{ 115008, 20, "movement", { talent = true, charges = 2, defaultDisabled = true } }, -- Chi Torpedo
	{ 101545, 25, "movement", { specs = { 269 }, defaultDisabled = true } }, -- Flying Serpent Kick
	{ 109132, 20, "movement", { charges = 2, defaultDisabled = true } }, -- Roll
	{ 122057, 35, "cc", { specs = { 268 }, defaultDisabled = true } }, -- Clash
	{ 119996, 25, "movement" }, -- Transcendence: Transfer
	{ 113306, 180, "defensive", { talent = true } }, -- Spell 113306
	{ 127361, 60, "cc", { talent = true } }, -- Spell 127361
});

AddCooldowns("PALADIN", {
	{ 96231, 15, "interrupt" }, -- Rebuke
	{ 4987, 8, "dispel", { startOnDispel = true } }, -- Cleanse
	{ 105593, 30, "cc", { talent = true } }, -- Fist of Justice
	{ 853, 60, "cc" }, -- Hammer of Justice
	{ 20066, 15, "cc", { talent = true } }, -- Repentance
	{ 115750, 120, "aoeCC" }, -- Blinding Light
	{ 642, 300, "immunity" }, -- Divine Shield
	{ 31850, 180, "defensive", { specs = { 66 } } }, -- Ardent Defender
	{ 498, 60, "defensive" }, -- Divine Protection
	{ 86659, 180, "defensive", { specs = { 66 } } }, -- Guardian of Ancient Kings
	{ 1022, 300, "externalDefensive", { optionalCharges = 2 } }, -- Hand of Protection
	{ 114039, 30, "externalDefensive", { talent = true } }, -- Hand of Purity
	{ 6940, 120, "externalDefensive", { optionalCharges = 2 } }, -- Hand of Sacrifice
	{ 31821, 180, "raidDefensive", { category = Categories.UTILITY } }, -- Devotion Aura
	{ 86669, 180, "heal", { specs = { 65 } } }, -- Guardian of Ancient Kings (Holy)
	{ 31884, 180, "offensive" }, -- Avenging Wrath
	{ 31842, 180, "offensive", { specs = { 65 } } }, -- Divine Favor
	{ 114157, 60, "offensive", { talent = true } }, -- Execution Sentence
	{ 86698, 180, "offensive", { specs = { 70 } } }, -- Guardian of Ancient Kings (Ret)
	{ 1044, 25, "freedom", { optionalCharges = 2 } }, -- Hand of Freedom
	{ 54428, 120, "other", { specs = { 65 }, defaultDisabled = true } }, -- Divine Plea
	{ 85499, 45, "movement", { talent = true, defaultDisabled = true } }, -- Speed of Light
	{ 113075, 60, "defensive", { talent = true } }, -- Spell 113075
});

AddCooldowns("PRIEST", {
	{ 15487, 45, "interrupt", { specs = { 258 } } }, -- Silence
	{ 32375, 15, "dispel" }, -- Mass Dispel
	{ 527, 15, "dispel", { specs = { 256, 257 }, startOnDispel = true } }, -- Purify
	{ 88625, 30, "cc", { specs = { 257 } } }, -- Holy Word: Chastise
	{ 64044, 45, "cc", { specs = { 258 } } }, -- Psychic Horror
	{ 108921, 45, "cc", { talent = true } }, -- Psyfiend
	{ 8122, 30, "aoeCC" }, -- Psychic Scream
	{ 19236, 120, "defensive", { talent = true } }, -- Desperate Prayer
	{ 47585, 120, "defensive", { specs = { 258 } } }, -- Dispersion
	{ 108968, 300, "defensive", { specs = { 256, 257 } } }, -- Void Shift
	{ 47788, 180, "externalDefensive", { specs = { 257 } } }, -- Guardian Spirit
	{ 33206, 180, "externalDefensive", { specs = { 256 } } }, -- Pain Suppression
	{ 64843, 180, "raidDefensive", { specs = { 257 } } }, -- Divine Hymn
	{ 126135, 180, "raidDefensive", { specs = { 257 } } }, -- Spell 126135
	{ 62618, 180, "raidDefensive", { specs = { 256 } } }, -- Power Word: Barrier
	{ 15286, 180, "raidDefensive", { specs = { 258 } } }, -- Spell 15286
	{ 10060, 120, "offensive", { talent = true } }, -- Power Infusion
	{ 34433, 180, "offensive", { category = Categories.UTILITY } }, -- Shadowfiend
	{ 123040, 60, "offensive", { talent = true, defaultDisabled = true, category = Categories.UTILITY } }, -- Mindbender
	{ 6346, 180, "counterCC", { category = Categories.CONTROL } }, -- Fear Ward
	{ 89485, 45, "counterCC", { specs = { 256 }, startOnAuraRemoved = true, category = Categories.DEFENSIVE } }, -- Inner Focus
	{ 32379, 8, "counterCC", { specs = { 256, 257 } } }, -- Spell 32379
	{ 129176, 8, "counterCC", { specs = { 258 } } }, -- Spell 129176
	{ 121536, 10, "movement", { talent = true, charges = 3, defaultDisabled = true } }, -- Angelic Feather
	{ 114239, 30, "movement", { talent = true, defaultDisabled = true } }, -- Phantasm
	{ 73325, 90, "movement" }, -- Leap of Faith
	{ 112833, 30, "other", { talent = true, defaultDisabled = true, category = Categories.OFFENSIVE } }, -- Spectral Guise
	{ 64901, 360, "other" }, -- Spell 64901
	{ 113277, 480, "raidDefensive", { talent = true } }, -- Spell 113277
});

AddCooldowns("ROGUE", {
	{ 1766, 15, "interrupt" }, -- Kick
	{ 2094, 120, "cc" }, -- Blind
	{ 408, 20, "cc" }, -- Kidney Shot
	{ 76577, 180, "cc" }, -- Smoke Bomb
	{ 51722, 60, "disarm" }, -- Dismantle
	{ 31230, 90, "defensive", { talent = true } }, -- Cheat Death
	{ 31224, 60, "defensive" }, -- Cloak of Shadows
	{ 74001, 120, "defensive", { talent = true } }, -- Combat Readiness
	{ 5277, 120, "defensive" }, -- Evasion
	{ 14185, 300, "defensive" }, -- Preparation
	{ 1856, 120, "defensive" }, -- Vanish
	{ 13750, 180, "offensive", { specs = { 260 } } }, -- Adrenaline Rush
	{ 51690, 120, "offensive", { specs = { 260 } } }, -- Killing Spree
	{ 121471, 180, "offensive" }, -- Shadow Blades
	{ 51713, 60, "offensive", { specs = { 261 } } }, -- Shadow Dance
	{ 79140, 120, "offensive", { specs = { 259 } } }, -- Vendetta
	{ 36554, 20, "movement", { talent = true, defaultDisabled = true } }, -- Shadowstep
	{ 2983, 60, "movement", { defaultDisabled = true } }, -- Sprint
});

AddCooldowns("SHAMAN", {
	{ 57994, 12, "interrupt" }, -- Wind Shear
	{ 51886, 8, "dispel", { specs = { 262, 263 }, startOnDispel = true } }, -- Cleanse Spirit
	{ 77130, 8, "dispel", { specs = { 264 }, startOnDispel = true } }, -- Purify Spirit
	{ 51514, 45, "cc" }, -- Hex
	{ 108269, 45, "aoeCC" }, -- Capacitor Totem
	{ 51490, 45, "aoeCC", { specs = { 262 } } }, -- Thunderstorm
	{ 108271, 90, "defensive", { talent = true } }, -- Astral Shift
	{ 108285, 180, "defensive", { talent = true, category = Categories.UTILITY } }, -- Call of the Elements
	{ 2062, 300, "defensive" }, -- Earth Elemental Totem
	{ 30884, 30, "defensive", { talent = true } }, -- Nature's Guardian
	{ 30823, 60, "defensive", { specs = { 262, 263 } } }, -- Shamanistic Rage
	{ 108270, 60, "defensive", { talent = true } }, -- Stone Bulwark Totem
	{ 108281, 120, "raidDefensive", { talent = true } }, -- Ancestral Guidance
	{ 108280, 180, "raidDefensive" }, -- Healing Tide Totem
	{ 98008, 180, "raidDefensive", { specs = { 264 } } }, -- Spirit Link Totem
	{ 114049, 180, "offensive" }, -- Ascendance
	{ 16166, 90, "offensive", { talent = true } }, -- Elemental Mastery
	{ 51533, 120, "offensive", { talent = true } }, -- Feral Spirit
	{ 2894, 300, "offensive" }, -- Fire Elemental Totem
	{ 120668, 300, "offensive" }, -- Spell 120668
	{ 8177, 25, "counterCC", { category = Categories.CONTROL } }, -- Grounding Totem
	{ 8143, 60, "counterCC" }, -- Tremor Totem
	{ 58875, 60, "freedom", { specs = { 263 } } }, -- Spirit Walk
	{ 108273, 60, "movement", { talent = true, defaultDisabled = true } }, -- Windwalk Totem
	{ 79206, 120, "movement", { defaultDisabled = true } }, -- Spiritwalker's Grace
	{ 16188, 90, "other", { talent = true, startOnAuraRemoved = true, category = Categories.CONTROL } }, -- Ancestral Swiftness
	{ 16190, 180, "other", { specs = { 264 } } }, -- Mana Tide Totem
	{ 113286, 60, "interrupt", { talent = true } }, -- Spell 113286
});

AddCooldowns("WARLOCK", {
	{ 108482, 60, "counterCC", { talent = true } }, -- Unbound Will
	{ 108501, 120, "interrupt", { talent = true } }, -- Grimoire of Service
	{ 19647, 24, "interrupt", { pet = true } }, -- Spell Lock
	{ 19505, 15, "dispel", { pet = true } }, -- Devour Magic
	{ 89766, 30, "cc", { specs = { 266 }, pet = true, defaultDisabled = true } }, -- Axe Toss
	{ 6789, 45, "cc", { talent = true } }, -- Mortal Coil
	{ 5484, 40, "aoeCC" }, -- Howl of Terror
	{ 30283, 30, "aoeCC", { talent = true } }, -- Shadowfury
	{ 110913, 180, "defensive", { talent = true } }, -- Dark Bargain
	{ 108416, 60, "defensive", { talent = true } }, -- Sacrificial Pact
	{ 104773, 180, "defensive" }, -- Unending Resolve
	{ 108359, 120, "heal", { talent = true } }, -- Dark Regeneration
	{ 113858, 120, "offensive", { specs = { 267 }, optionalCharges = 2 } }, -- Dark Soul: Instability
	{ 113861, 120, "offensive", { specs = { 266 }, optionalCharges = 2 } }, -- Dark Soul: Knowledge
	{ 113860, 120, "offensive", { specs = { 265 }, optionalCharges = 2 } }, -- Dark Soul: Misery
	{ 48020, 30, "movement" }, -- Demonic Circle: Teleport
});

AddCooldowns("WARRIOR", {
	{ 102060, 40, "interrupt", { talent = true } }, -- Disrupting Shout
	{ 6552, 15, "interrupt" }, -- Pummel
	{ 5246, 90, "cc" }, -- Intimidating Shout
	{ 46968, 40, "cc", { talent = true } }, -- Shockwave
	{ 107570, 30, "cc", { talent = true } }, -- Storm Bolt
	{ 118000, 60, "aoeCC", { talent = true } }, -- Dragon Roar
	{ 676, 60, "disarm" }, -- Disarm
	{ 114203, 180, "defensive" }, -- Demoralizing Banner
	{ 118038, 120, "defensive", { specs = { 71, 72 } } }, -- Die by the Sword
	{ 12975, 180, "defensive", { specs = { 73 } } }, -- Last Stand
	{ 871, 180, "defensive" }, -- Shield Wall
	{ 114030, 120, "externalDefensive", { talent = true } }, -- Vigilance
	{ 97462, 180, "raidDefensive" }, -- Rallying Cry
	{ 55694, 60, "heal", { talent = true } }, -- Enraged Regeneration
	{ 107574, 180, "offensive", { talent = true } }, -- Avatar
	{ 86346, 20, "offensive", { specs = { 71, 72 } } }, -- Colossus Smash
	{ 1719, 180, "offensive" }, -- Recklessness
	{ 114207, 180, "offensive" }, -- Skull Banner
	{ 18499, 30, "counterCC" }, -- Berserker Rage
	{ 3411, 30, "counterCC", { category = Categories.UTILITY } }, -- Intervene
	{ 114028, 60, "counterCC", { talent = true, category = Categories.CONTROL } }, -- Mass Spell Reflection
	{ 114029, 30, "counterCC", { talent = true } }, -- Safeguard
	{ 23920, 25, "counterCC", { category = Categories.CONTROL } }, -- Spell Reflection
	{ 1250619, 20, "movement", { optionalCharges = 2, defaultDisabled = true } }, -- Charge
	{ 6544, 45, "movement", { defaultDisabled = true } }, -- Heroic Leap
	{ 64382, 300, "other" }, -- Shattering Throw
	{ 122286, 60, "defensive", { talent = true } }, -- Spell 122286
});

addonTable.CooldownAliases = {
	[100] = 1250619,
	[724] = 126135,
	[6358] = 19505,
	[6360] = 19647,
	[13809] = 1499,
	[16979] = 102417,
	[17767] = 19505,
	[31616] = 30884,
	[32747] = 15487,
	[45182] = 31230,
	[49376] = 102417,
	[60192] = 1499,
	[80965] = 80964,
	[82941] = 1499,
	[87024] = 86949,
	[89751] = 19647,
	[89808] = 19505,
	[93985] = 80964,
	[97547] = 78675,
	[102383] = 102417,
	[102401] = 102417,
	[102416] = 102417,
	[111859] = 108501,
	[111895] = 108501,
	[111896] = 108501,
	[111897] = 108501,
	[111898] = 108501,
	[113288] = 113286,
	[115268] = 19505,
	[115276] = 19505,
	[115284] = 19505,
	[115770] = 19647,
	[115781] = 19647,
	[115831] = 19647,
	[118093] = 19647,
	[119899] = 19647,
	[119905] = 19647,
	[119907] = 19647,
	[119909] = 19647,
	[119910] = 19647,
	[119911] = 19647,
	[119913] = 19647,
	[119914] = 19647,
	[119915] = 19647,
	[123995] = 123904,
	[123981] = 114556,
	[132578] = 123904,
	[132409] = 19647,
	[132410] = 19647,
	[132411] = 19647,
	[132413] = 19647,
	[137706] = 19647,
	[148467] = 19263,
	-- Existing racial variants (unchanged).
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

addonTable.CooldownAliasMeta = {
	[6358] = { spellID = 19505, cooldown = 1, texture = 136175 },
	[6360] = { spellID = 19647, cooldown = 25, texture = 460858 },
	[17767] = { spellID = 19505, cooldown = 120, texture = 136121 },
	[19505] = { spellID = 19505, cooldown = 15, texture = 136075 },
	[19647] = { spellID = 19647, cooldown = 24, texture = 136174 },
	[89751] = { spellID = 19647, cooldown = 45, texture = 236303 },
	[89808] = { spellID = 19505, cooldown = 10, texture = 135791 },
	[111859] = { spellID = 108501, cooldown = 120, texture = 136218 },
	[111895] = { spellID = 108501, cooldown = 120, texture = 136221 },
	[111896] = { spellID = 108501, cooldown = 120, texture = 136220 },
	[111897] = { spellID = 108501, cooldown = 120, texture = 136217 },
	[111898] = { spellID = 108501, cooldown = 120, texture = 136216 },
	[115268] = { spellID = 19505, cooldown = 1, texture = 237185 },
	[115276] = { spellID = 19505, cooldown = 20, texture = 135791 },
	[115284] = { spellID = 19505, cooldown = 15, texture = 236407 },
	[115770] = { spellID = 19647, cooldown = 25, texture = 468265 },
	[115781] = { spellID = 19647, cooldown = 24, texture = 136028 },
	[115831] = { spellID = 19647, cooldown = 45, texture = 236303 },
	[118093] = { spellID = 19647, cooldown = 60, texture = 132343 },
	[119899] = { spellID = 19647, cooldown = 30, texture = 463567 },
	[119905] = { spellID = 19647, cooldown = 30, texture = 463567 },
	[119907] = { spellID = 19647, cooldown = 60, texture = 132343 },
	[119909] = { spellID = 19647, cooldown = 25, texture = 460858 },
	[119910] = { spellID = 19647, cooldown = 24, texture = 136174 },
	[119911] = { spellID = 19647, cooldown = 24, texture = 136028 },
	[119913] = { spellID = 19647, cooldown = 25, texture = 468265 },
	[119914] = { spellID = 19647, cooldown = 45, texture = 236303 },
	[119915] = { spellID = 19647, cooldown = 45, texture = 236303 },
	[132409] = { spellID = 19647, cooldown = 24, texture = 136174 },
	[132410] = { spellID = 19647, cooldown = 15, texture = 236303 },
	[132411] = { spellID = 19647, cooldown = 10, texture = 135791 },
	[132413] = { spellID = 19647, cooldown = 120, texture = 136121 },
	[137706] = { spellID = 19647, cooldown = 25, texture = 460858 },
};

addonTable.CooldownVariants = {
	[498] = { 30 },
	[642] = { 150 },
	[781] = { 10 },
	[1499] = { 28, 22 },
	[2894] = { 150 },
	[6346] = { 120 },
	[8122] = { 27 },
	[8177] = { 22 },
	[11129] = { 36 },
	[12472] = { 90 },
	[12975] = { 120 },
	[19263] = { 120 },
	[23920] = { 20 },
	[31821] = { 120 },
	[31850] = { 120 },
	[47585] = { 105 },
	[48020] = { 26, 25, 21 },
	[51490] = { 35, 22.5, 17.5 },
	[51514] = { 35 },
	[58875] = { 45 },
	[61336] = { 120 },
	[64044] = { 35 },
	[102342] = { 30 },
	[104773] = { 120 },
	[106922] = { 120 },
	[108978] = { 90 },
	[109132] = { 15 },
	[115008] = { 15 },
	[119996] = { 20 },
	[1250619] = { 12 },
};

addonTable.HUNTER_TRAP_SPELLS = { [1499] = true, [60192] = true, [82941] = true };

-- Spec hints are learned only from unambiguous class/spec casts.
addonTable.SpecHints = {
	[11129] = 63,
	[12042] = 62,
	[12472] = 64,
	[12975] = 73,
	[13750] = 260,
	[15286] = 258,
	[15487] = 258,
	[16190] = 264,
	[19574] = 253,
	[31661] = 63,
	[31687] = 64,
	[31842] = 65,
	[31850] = 66,
	[33206] = 256,
	[34490] = 254,
	[47585] = 258,
	[47788] = 257,
	[49016] = 252,
	[49028] = 250,
	[49206] = 252,
	[50334] = 104,
	[51271] = 251,
	[51490] = 262,
	[51690] = 260,
	[51713] = 261,
	[58875] = 263,
	[62618] = 256,
	[64044] = 258,
	[64843] = 257,
	[77130] = 264,
	[78675] = 102,
	[79140] = 259,
	[86659] = 66,
	[86669] = 65,
	[86698] = 70,
	[88423] = 105,
	[88625] = 257,
	[89485] = 256,
	[98008] = 264,
	[102342] = 105,
	[102543] = 103,
	[102560] = 102,
	[106951] = 103,
	[112071] = 102,
	[113656] = 269,
	[113858] = 267,
	[113860] = 265,
	[113861] = 266,
	[115213] = 268,
	[115288] = 269,
	[115310] = 270,
	[116849] = 270,
	[122470] = 269,
	[122057] = 268,
	[122465] = 270,
	[126135] = 257,
	[129176] = 258,
	[724] = 257,
	[32747] = 258,
	[97547] = 102,
	[33891] = 105,
	[54428] = 65,
	[89766] = 266,
	[101545] = 269,
};

addonTable.CooldownResets = {
	[11958] = { 45438 },
	[14185] = { 1856, 5277, 51722, 2983 },
	[108285] = { 108269, 2484, 51485, 8177, 5394, 108270, 8143, 108273 },
};

-- No cast-event reduction is used for Glyph of Counterspell: that glyph increases the base CD.
addonTable.CooldownReductions = {};

addonTable.CastReductions = {
	[2098] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471 } },
	[1943] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471 } },
	[121411] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471 } },
	[26679] = { spec = 260, amount = 10, spells = { 13750, 51690, 121471 } },
};

addonTable.DamageTakenReductions = { [5484] = 1 };

addonTable.SharedCooldowns = {
	-- Universal PvP shared lockouts.
	[42292] = { { 7744, 30, true } },
	[7744] = { { 42292, 30 } },
	[2062] = { { 2894, 60 } },
	[2894] = { { 2062, 60 } },
	[6552] = { { 102060, 15, true } },
	[102060] = { { 6552, 15 } },
};

-- These are alternative CC breaks. Keep only the one actually observed for each player.
addonTable.ExclusiveCooldowns = {
	[42292] = 59752, -- PvP Trinket replaces Will to Survive
	[59752] = 42292, -- Will to Survive replaces PvP Trinket
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
