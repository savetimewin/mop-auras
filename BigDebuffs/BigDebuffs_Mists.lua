local addonName, addon = ...

local BUFF_DEFENSIVE = "buffs_defensive"
local BUFF_OFFENSIVE = "buffs_offensive"
local DEBUFF_OFFENSIVE = "debuffs_offensive"
local BUFF_OTHER = "buffs_other"
local INTERRUPT = "interrupts"
local CROWD_CONTROL = "cc"
local ROOT = "roots"
local IMMUNITY = "immunities"
local IMMUNITY_SPELL = "immunities_spells"

addon.Units = {
    "player",
    "pet",
    "target",
    "focus",
    "party1",
    "party2",
    "party3",
    "party4",
    "arena1",
    "arena2",
    "arena3",
    "arena4",
    "arena5",
}

-- Show one of these when a big debuff is displayed
addon.WarningDebuffs = {
    --30108, -- Unstable Affliction
    --34914, -- Vampiric Touch
}

-- Make sure we always see these debuffs, but don't make them bigger
addon.PriorityDebuffs = {
    770, -- Faerie Fire
    16857, -- Faerie Fire (Feral)
    12294, -- Mortal Strike
    21551, -- Mortal Strike
    21552, -- Mortal Strike
    21553, -- Mortal Strike
    9035, -- Hex of Weakness
    19281, -- Hex of Weakness
    19282, -- Hex of Weakness
    19283, -- Hex of Weakness
    19284, -- Hex of Weakness
    19285, -- Hex of Weakness
    23230, -- Blood Fury Debuff
    23605, -- Nightfall, Spell Vulnerability
}

-- we're going to make this into MOP ARENA ONLY
addon.Spells = {

    -- CROWD CONTROLS

    -- *** Incapacitate Effects ***
    [2637]   = { type = CROWD_CONTROL }, -- Hibernate
    [3355]   = { type = CROWD_CONTROL }, -- Freezing Trap Effect
    [19386]  = { type = CROWD_CONTROL }, -- Wyvern Sting
    [118]    = { type = CROWD_CONTROL }, -- Polymorph
    [28271]  = { type = CROWD_CONTROL }, -- Polymorph: Turtle
    [28272]  = { type = CROWD_CONTROL }, -- Polymorph: Pig
    [61025]  = { type = CROWD_CONTROL }, -- Polymorph: Serpent
    [61721]  = { type = CROWD_CONTROL }, -- Polymorph: Rabbit
    [61780]  = { type = CROWD_CONTROL }, -- Polymorph: Turkey
    [61305]  = { type = CROWD_CONTROL }, -- Polymorph: Black Cat
    [82691]  = { type = CROWD_CONTROL }, -- Ring of Frost
    [115078] = { type = CROWD_CONTROL }, -- Paralysis
    [20066]  = { type = CROWD_CONTROL }, -- Repentance
    [9484]   = { type = CROWD_CONTROL }, -- Shackle Undead
    [1776]   = { type = CROWD_CONTROL }, -- Gouge
    [6770]   = { type = CROWD_CONTROL }, -- Sap
    [76780]  = { type = CROWD_CONTROL }, -- Bind Elemental
    [51514]  = { type = CROWD_CONTROL }, -- Hex
    [710]    = { type = CROWD_CONTROL }, -- Banish
    [107079] = { type = CROWD_CONTROL }, -- Quaking Palm (Racial)

    -- *** Disorient Effects ***
    [99]     = { type = CROWD_CONTROL }, -- Disorienting Roar
    [19503]  = { type = CROWD_CONTROL }, -- Scatter Shot
    [31661]  = { type = CROWD_CONTROL }, -- Dragon's Breath
    [123393] = { type = CROWD_CONTROL }, -- Glyph of Breath of Fire
    [105421] = { type = CROWD_CONTROL }, -- Blinding Light
    [88625]  = { type = CROWD_CONTROL }, -- Holy Word: Chastise

    -- *** Controlled Stun Effects ***
    [108194] = { type = CROWD_CONTROL }, -- Asphyxiate
    [91800]  = { type = CROWD_CONTROL }, -- Gnaw (Ghoul)
    [91797]  = { type = CROWD_CONTROL }, -- Monstrous Blow (Dark Transformation Ghoul)
    [115001] = { type = CROWD_CONTROL }, -- Remorseless Winter
    [102795] = { type = CROWD_CONTROL }, -- Bear Hug
    [5211]   = { type = CROWD_CONTROL }, -- Mighty Bash
    [9005]   = { type = CROWD_CONTROL }, -- Pounce
    [22570]  = { type = CROWD_CONTROL }, -- Maim
    [113801] = { type = CROWD_CONTROL }, -- Bash (Treants)
    [117526] = { type = CROWD_CONTROL }, -- Binding Shot
    [24394]  = { type = CROWD_CONTROL }, -- Intimidation
    [126246] = { type = CROWD_CONTROL }, -- Lullaby (Crane pet) -- TODO: verify category
    [126423] = { type = CROWD_CONTROL }, -- Petrifying Gaze (Basilisk pet) -- TODO: verify category
    [126355] = { type = CROWD_CONTROL }, -- Quill (Porcupine pet) -- TODO: verify category
    [90337]  = { type = CROWD_CONTROL }, -- Bad Manner (Monkey)
    [56626]  = { type = CROWD_CONTROL }, -- Sting (Wasp)
    [50519]  = { type = CROWD_CONTROL }, -- Sonic Blast
    [118271] = { type = CROWD_CONTROL }, -- Combustion
    [44572]  = { type = CROWD_CONTROL }, -- Deep Freeze
    [119392] = { type = CROWD_CONTROL }, -- Charging Ox Wave
    [122242] = { type = CROWD_CONTROL }, -- Clash
    [120086] = { type = CROWD_CONTROL }, -- Fists of Fury
    [119381] = { type = CROWD_CONTROL }, -- Leg Sweep
    [115752] = { type = CROWD_CONTROL }, -- Blinding Light (Glyphed)
    [853]    = { type = CROWD_CONTROL }, -- Hammer of Justice
    [110698] = { type = CROWD_CONTROL }, -- Hammer of Justice (Symbiosis)
    [119072] = { type = CROWD_CONTROL }, -- Holy Wrath
    [105593] = { type = CROWD_CONTROL }, -- Fist of Justice
    [408]    = { type = CROWD_CONTROL }, -- Kidney Shot
    [1833]   = { type = CROWD_CONTROL }, -- Cheap Shot
    [118345] = { type = CROWD_CONTROL }, -- Pulverize (Primal Earth Elemental)
    [118905] = { type = CROWD_CONTROL }, -- Static Charge (Capacitor Totem)
    [89766]  = { type = CROWD_CONTROL }, -- Axe Toss (Felguard)
    [22703]  = { type = CROWD_CONTROL }, -- Inferno Effect
    [30283]  = { type = CROWD_CONTROL }, -- Shadowfury
    [132168] = { type = CROWD_CONTROL }, -- Shockwave
    [107570] = { type = CROWD_CONTROL }, -- Storm Bolt
    [132169] = { type = CROWD_CONTROL }, -- Storm Bolt 2
    [20549]  = { type = CROWD_CONTROL }, -- War Stomp (Racial)
    -- *** Non-controlled Stun Effects *** -- was "random_stun". 
    -- I get that the original author wants to separate it but having another category of dr is confusing for me or rather of an eye sore
    [113953] = { type = CROWD_CONTROL }, -- Paralysis
    [118895] = { type = CROWD_CONTROL }, -- Dragon Roar
    [77505]  = { type = CROWD_CONTROL }, -- Earthquake
    [100]    = { type = CROWD_CONTROL }, -- Charge
    [118000] = { type = CROWD_CONTROL }, -- Dragon Roar

    -- *** Fear Effects ***
    [113004] = { type = CROWD_CONTROL }, -- Intimidating Roar (Symbiosis)
    [113056] = { type = CROWD_CONTROL }, -- Intimidating Roar (Symbiosis 2)
    [1513]   = { type = CROWD_CONTROL }, -- Scare Beast
    [10326]  = { type = CROWD_CONTROL }, -- Turn Evil
    [145067] = { type = CROWD_CONTROL }, -- Turn Evil (Evil is a Point of View)
    [8122]   = { type = CROWD_CONTROL }, -- Psychic Scream
    [113792] = { type = CROWD_CONTROL }, -- Psychic Terror (Psyfiend)
    [2094]   = { type = CROWD_CONTROL }, -- Blind
    [5782]   = { type = CROWD_CONTROL }, -- Fear
    [118699] = { type = CROWD_CONTROL }, -- Fear 2
    [5484]   = { type = CROWD_CONTROL }, -- Howl of Terror
    [115268] = { type = CROWD_CONTROL }, -- Mesmerize (Shivarra)
    [6358]   = { type = CROWD_CONTROL }, -- Seduction (Succubus)
    [104045] = { type = CROWD_CONTROL }, -- Sleep (Metamorphosis) -- TODO: verify this is the correct category
    [5246]   = { type = CROWD_CONTROL }, -- Intimidating Shout
    [20511]  = { type = CROWD_CONTROL }, -- Intimidating Shout (secondary targets)
    
    -- *** Horror Effects ***
    [64044]  = { type = CROWD_CONTROL }, -- Psychic Horror
    [137143] = { type = CROWD_CONTROL }, -- Blood Horror
    [6789]   = { type = CROWD_CONTROL }, -- Death Coil

    -- *** Spells that DRs with itself only ***
    [33786]  = { type = CROWD_CONTROL }, -- Cyclone
    [113506] = { type = CROWD_CONTROL }, -- Cyclone (Symbiosis)

    -- *** Mind Control Effects *** 
    [605]   = { type = CROWD_CONTROL }, -- Dominate Mind
    [13181] = { type = CROWD_CONTROL }, -- Gnomish Mind Control Cap (Item) -- I know this is arena but just keep it incase u see it in bgs
    [67799] = { type = CROWD_CONTROL }, -- Mind Amplification Dish (Item) -- I know this is arena but just keep it incase u see it in bgs

    -- *** Disarm Weapon Effects ***
    [50541]  = { type = CROWD_CONTROL }, -- Clench (Scorpid)
    [91644]  = { type = CROWD_CONTROL }, -- Snatch (Bird of Prey)
    [117368] = { type = CROWD_CONTROL }, -- Grapple Weapon
    [126458] = { type = CROWD_CONTROL }, -- Grapple Weapon (Symbiosis)
    [137461] = { type = CROWD_CONTROL }, -- Ring of Peace (Disarm effect)
    [64058]  = { type = CROWD_CONTROL }, -- Psychic Horror (Disarm Effect)
    [51722]  = { type = CROWD_CONTROL }, -- Dismantle
    [118093] = { type = CROWD_CONTROL }, -- Disarm (Voidwalker/Voidlord)
    [676]    = { type = CROWD_CONTROL }, -- Disarm

    -- *** Silence Effects ***
    [47476]  = { type = CROWD_CONTROL }, -- Strangulate
    [114238] = { type = CROWD_CONTROL }, -- Glyph of Fae Silence
    [34490]  = { type = CROWD_CONTROL }, -- Silencing Shot
    [102051] = { type = CROWD_CONTROL }, -- Frostjaw
    [55021]  = { type = CROWD_CONTROL }, -- Counterspell
    [137460] = { type = CROWD_CONTROL }, -- Ring of Peace (Silence effect)
    [116709] = { type = CROWD_CONTROL }, -- Spear Hand Strike
    [31935]  = { type = CROWD_CONTROL }, -- Avenger's Shield
    [15487]  = { type = CROWD_CONTROL }, -- Silence
    [1330]   = { type = CROWD_CONTROL }, -- Garrote
    [24259]  = { type = CROWD_CONTROL }, -- Spell Lock
    [115782] = { type = CROWD_CONTROL }, -- Optical Blast (Observer)
    [18498]  = { type = CROWD_CONTROL }, -- Silenced - Gag Order
    [50613]  = { type = CROWD_CONTROL }, -- Arcane Torrent (Racial, Runic Power)
    [28730]  = { type = CROWD_CONTROL }, -- Arcane Torrent (Racial, Mana)
    [25046]  = { type = CROWD_CONTROL }, -- Arcane Torrent (Racial, Energy)
    [69179]  = { type = CROWD_CONTROL }, -- Arcane Torrent (Racial, Rage)
    [80483]  = { type = CROWD_CONTROL }, -- Arcane Torrent (Racial, Focus)
    [31117]  = { type = CROWD_CONTROL }, -- Unstable Affliction (Silence)
    [43523]  = { type = CROWD_CONTROL }, -- Unstable Affliction (Silence)
    
    -- INTERRUPTS
    [19647] = { type = INTERRUPT, duration = 6 }, -- Spell Lock - Rank 1 (Warlock)
    [13491] = { type = INTERRUPT, duration = 5 }, -- Iron Knuckles
    [16979] = { type = INTERRUPT, duration = 4 }, -- Feral Charge (Druid)
    [2139] = { type = INTERRUPT, duration = 8 }, -- Counterspell (Mage)
    [147362] = { type = INTERRUPT, duration = 3}, -- Counter Shot (Hunter)
    [1766] = { type = INTERRUPT, duration = 5 }, -- Kick (Rogue)
    [26679] = { type = INTERRUPT, duration = 3 }, -- Deadly Throw
    [6552] = { type = INTERRUPT, duration = 4 }, -- Pummel
    [29443] = { type = INTERRUPT, duration = 10 }, -- Clutch of Foresight
    [80965] = { type = INTERRUPT, duration = 4 }, -- Skull Bash (Cat)
    [80964] = { type = INTERRUPT, duration = 4 }, -- Skull Bash (Bear)
    [47528] = { type = INTERRUPT, duration = 4, },  -- Mind Freeze
    [91802] = { type = INTERRUPT, duration = 2 },  -- Shambling Rush (pet dk kick)
    [115781] = { type = INTERRUPT, duration = 6 }, -- Optical Blast (Interrupt)
    [119911] = { type = INTERRUPT, duration = 6 }, -- Optical Blast (Interrupt)
    [57994] = { type = INTERRUPT, duration = 2, },  -- Wind Shear
    [96231] = { type = INTERRUPT, duration = 4 }, -- Rebuke
    [26090] = { type = INTERRUPT, duration = 2, }, -- Pummel (Pet)
    [50479] = { type = INTERRUPT, duration = 2},  -- Nether Shock (nether ray pet kick)
    [78675] = { type = INTERRUPT, duration = 5 }, -- Solar Beam interrupt
    

    -- ROOTS
    [96294]  = { type = ROOT }, -- Chains of Ice (Chilblains)
    [91807]  = { type = ROOT }, -- Shambling Rush (Dark Transformation)
    [339]    = { type = ROOT }, -- Entangling Roots
    [113770] = { type = ROOT }, -- Entangling Roots (Force of Nature - Balance Treants)
    [19975]  = { type = ROOT }, -- Entangling Roots (Nature's Grasp)
    [45334]  = { type = ROOT }, -- Immobilized (Wild Charge - Bear)
    [102359] = { type = ROOT }, -- Mass Entanglement
    [110693] = { type = ROOT }, -- Frost Nova (Mage) [Symbiosis]
    [19185]  = { type = ROOT }, -- Entrapment
    [64803]  = { type = ROOT }, -- Entrapment
    [136634] = { type = ROOT }, -- Narrow Escape
    [90327]  = { type = ROOT }, -- Lock Jaw (Dog)
    [50245]  = { type = ROOT }, -- Pin (Crab)
    [54706]  = { type = ROOT }, -- Venom Web Spray (Silithid)
    [4167]   = { type = ROOT }, -- Web (Spider)
    [96201]  = { type = ROOT }, -- Web Wrap (Shale Spider)
    [122]    = { type = ROOT }, -- Frost Nova
    [111340] = { type = ROOT }, -- Ice Ward
    [33395]  = { type = ROOT }, -- Freeze (Water Elemental)
    [116706] = { type = ROOT }, -- Disable (Root)
    [113275] = { type = ROOT }, -- Entangling Roots (Symbiosis) [Monk]
    [123407] = { type = ROOT }, -- Spinning Fire Blossom
    [115197] = { type = ROOT }, -- Partial Paralysis
    [64695]  = { type = ROOT }, -- Earthgrab (Earthgrab Totem)
    [63685]  = { type = ROOT }, -- Freeze (Frozen Power)
    [87194]  = { type = ROOT }, -- Glyph of Mind Blast
    [114404] = { type = ROOT }, -- Void Tendril's Grasp
    [39965]  = { type = ROOT }, -- Frost Grenade
    [55536]  = { type = ROOT }, -- Frostweave Net
    [107566] = { type = ROOT }, -- Staggering Shout
    [105771] = { type = ROOT }, -- Warbringer
    [115000] = { type = ROOT }, -- Remorseless Winter
    [25999]  = { type = ROOT }, -- Charge
    [115757] = { type = ROOT }, -- Frost Nova (Glyph of Ice Block)

    -- IMMUNITIES (COMPLETE IMMUNITY)
    [642]    = { type = IMMUNITY }, -- Divine Shield
    [58984]  = { type = IMMUNITY }, -- Shadowmeld
    [47585]  = { type = IMMUNITY }, -- Dispersion
    [27827]  = { type = IMMUNITY }, -- Spirit of Redemption
    [19263]  = { type = IMMUNITY }, -- Deterrence
    [110618] = { type = IMMUNITY }, -- Deterrence
    [65871]  = { type = IMMUNITY }, -- Deterrence
    [148467] = { type = IMMUNITY }, -- Deterrence
    [67801]  = { type = IMMUNITY }, -- Deterrence
    [110617] = { type = IMMUNITY }, -- Deterrence (Hunter)
    [110715] = { type = IMMUNITY }, -- Dispersion (Priest)
    [110700] = { type = IMMUNITY }, -- Divine Shield (Paladin)
    [110696] = { type = IMMUNITY }, -- Ice Block (Mage)
    [45438]  = { type = IMMUNITY }, -- Ice Block
    [122465] = { type = IMMUNITY }, -- Dematerialize
    
    -- DRINKS
    [22734] = { type = BUFF_OTHER }, -- Drink
        [46755] = { parent = 22734 }, -- Drink
        [27089] = { parent = 22734 }, -- Drink
        [43183] = { parent = 22734 }, -- Drink
        [57073] = { parent = 22734 }, -- Drink

    -- DEBUFF_OFFENSIVE -- for raid frames to see who they going what big damage is incoming
    [46392]  = { type = DEBUFF_OFFENSIVE }, -- Focused Assault
    [46393]  = { type = DEBUFF_OFFENSIVE }, -- Brutal Assault
    [49206]  = { type = DEBUFF_OFFENSIVE }, -- Summon Gargoyle
    [108200] = { type = DEBUFF_OFFENSIVE }, -- Remorseless Winter (Indicator to see the stacks)
    [130735] = { type = DEBUFF_OFFENSIVE }, -- Soul Reaper (Frost)
        [130736] = { parent = 130735 }, -- Soul Reaper (Unholy)
        [114866] = { parent = 130735 }, -- Soul Reaper (Blood)
    [34914]  = { type = DEBUFF_OFFENSIVE }, -- VT
    [80240]  = { type = DEBUFF_OFFENSIVE }, -- Havoc
    [30108]  = { type = DEBUFF_OFFENSIVE }, -- UA
    [117405] = { type = DEBUFF_OFFENSIVE }, -- debuff about to be stunned by Binding Shot
    [137619] = { type = DEBUFF_OFFENSIVE }, -- Marked for Death
    [79140]  = { type = DEBUFF_OFFENSIVE }, -- Vendetta
    [12292]  = { type = DEBUFF_OFFENSIVE }, -- Bloodbath Melee special attacks cause an additional 30% bleed damage.
    [124280] = { type = DEBUFF_OFFENSIVE }, -- Touch of Karma debuff that goes on enemy of the monk


    [20594] = { type = BUFF_DEFENSIVE }, -- Stoneform
    [20572] = { type = BUFF_OFFENSIVE }, -- Blood Fury

    
    
    [126679] = { type = BUFF_OFFENSIVE }, -- Call of Victory
    [126690] = { type = BUFF_OFFENSIVE }, -- Call of Conquest
    [126683] = { type = BUFF_OFFENSIVE }, -- Call of Dominance


    [48792] = { type = BUFF_DEFENSIVE },  -- Icebound Fortitude
    [49028] = { type = BUFF_DEFENSIVE },  -- Dancing Rune Weapon // might not work - spell id vs aura
    
    [50461] = { type = BUFF_DEFENSIVE },  -- Anti-Magic Zone
    [49016] = { type = BUFF_OFFENSIVE },  -- Unholy Frenzy
    
    
    [51271] = { type = BUFF_OFFENSIVE },  -- Pillar of Frost
	
 
    [20711] = { type = BUFF_DEFENSIVE, },  -- Spirit of Redemption
    [47788] = { type = BUFF_DEFENSIVE },  -- Guardian Spirit
    
    
    [64843] = { type = BUFF_DEFENSIVE },  -- Divine Hymn
    [64901] = { type = BUFF_DEFENSIVE }, -- Hymn of Hope
    
    
    [10060] = { type = BUFF_OFFENSIVE }, -- Power Infusion
    
    [14892] = { type = BUFF_DEFENSIVE }, -- Inspiration
        [15362] = { parent = 14892 },
    [6346] = { type = BUFF_DEFENSIVE }, -- Fear Ward
    
    [33206] = { type = BUFF_DEFENSIVE }, -- Pain Suppression
    [14751] = { type = BUFF_DEFENSIVE }, -- Inner Focus
    
    [96267] = { type = BUFF_DEFENSIVE }, -- Strength of Soul

    [47241] = { type = BUFF_OFFENSIVE }, -- Metamorphosis
    
    
    [6229] = { type = BUFF_DEFENSIVE }, -- Shadow Ward
    
    
    [79462] = { type = BUFF_OFFENSIVE }, -- Demon Soul: Felguard
    [79460] = { type = BUFF_OFFENSIVE }, -- Demon Soul: Felhunter
    [79459] = { type = BUFF_OFFENSIVE }, -- Demon Soul: Imp
    [79463] = { type = BUFF_OFFENSIVE }, -- Demon Soul: Succubus
    [79464] = { type = BUFF_OFFENSIVE }, -- Demon Soul: Voidwalker
    [137143] = { type = BUFF_DEFENSIVE }, -- Blood Horror
    [111397] = { type = BUFF_DEFENSIVE }, -- Blood Horror

    [110913] = { type = BUFF_DEFENSIVE }, -- Dark Bargain
    [104773] = { type = BUFF_DEFENSIVE }, -- Unending Resolve

	[113860] = { type = BUFF_OFFENSIVE }, -- Dark Soul: Misery
	[113858] = { type = BUFF_OFFENSIVE }, -- Dark Soul: Instability
	[113861] = { type = BUFF_OFFENSIVE }, -- Dark Soul: Knowledge

    [2825] = { type = BUFF_OFFENSIVE },  -- Bloodlust
    [16191] = { type = BUFF_OFFENSIVE }, -- Mana Tide Totem
    [32182] = { type = BUFF_OFFENSIVE },  -- Heroism
    
    [58875] = { type = BUFF_OTHER, }, -- Spirit Walk (Spirit Wolf)
    [16166] = { type = BUFF_OFFENSIVE }, -- Elemental Mastery
    [30823] = { type = BUFF_DEFENSIVE }, -- Shamanistic Rage
    
    [110806] = { type = BUFF_OTHER },  -- Spiritwalker's Grace
    [114049] = { type = BUFF_OFFENSIVE }, -- Ascendance
        [114052] = { parent = 114049 }, -- Ascendance
        [114051] = { parent = 114049 }, -- Ascendance
        [114050] = { parent = 114049 }, -- Ascendance
	[108271] = { type = BUFF_DEFENSIVE }, -- Astral Shift
	[98007] = { type = BUFF_DEFENSIVE }, -- Spirit Link Totem Effect Buff
	[16188] = { type = BUFF_OTHER }, -- Ancestral Swiftness 
	

    [25771] = { type = BUFF_OTHER, }, -- Forbearance
    [54428] = { type = BUFF_OTHER, }, -- Divine Plea
    

    [498] = { type = BUFF_DEFENSIVE }, -- Divine Protection

    [1044] = { type = BUFF_DEFENSIVE }, -- Blessing of Freedom
    
    [6940] = { type = BUFF_DEFENSIVE }, -- Blessing of Sacrifice
    
    [31884] = { type = BUFF_OFFENSIVE }, -- Avenging Wrath
	[105809] = { type = BUFF_OFFENSIVE }, -- Holy Avenger
	[31821] = { type = BUFF_DEFENSIVE }, -- Devotion Aura
	[31842] = { type = BUFF_DEFENSIVE }, -- Divine Favor
	[31850] = { type = BUFF_DEFENSIVE }, -- Ardent Defender
	[86659] = { type = BUFF_DEFENSIVE }, -- Guardian of Ancient Kings
    
    [85696] = { type = BUFF_OFFENSIVE }, -- Zealotry
    [1742] = { type = BUFF_DEFENSIVE, }, -- Cower (Pet)
    [53476] = { type = BUFF_DEFENSIVE, }, -- Intervene (Pet)
    [53480] = { type = BUFF_DEFENSIVE, },  -- Roar of Sacrifice (Hunter Pet Skill)

    [13159] = { type = BUFF_OFFENSIVE }, -- Aspect of the Pack
        [5118] = { parent = 13159 }, -- Aspect of the Cheetah
    
    [3045] = { type = BUFF_OFFENSIVE }, -- Rapid Fire
    [19574] = { type = BUFF_OFFENSIVE }, -- Bestial Wrath
    
    [5384] = { type = BUFF_DEFENSIVE }, -- Feign Death
    
    [19577] = { type = BUFF_OFFENSIVE, parent = 24394 }, -- Intimidation (Buff)
    

    [3674] = { type = BUFF_OFFENSIVE }, -- Black Arrow


    [768] = { type = BUFF_OTHER, }, -- Cat Form
    [783] = { type = BUFF_OTHER, }, -- Travel Form
    
    [22842] = { type = BUFF_DEFENSIVE, },  -- Frenzied Regeneration
    [24858] = { type = BUFF_OTHER, }, -- Moonkin Form
    [33891] = { type = BUFF_OTHER, }, -- Tree of Life
    [50334] = { type = BUFF_OFFENSIVE, },  -- Berserk
    [61336] = { type = BUFF_DEFENSIVE, },  -- Survival Instincts
    [69369] = { type = BUFF_OFFENSIVE, }, -- Predator's Swiftness

    [22812] = { type = BUFF_DEFENSIVE }, -- Barkskin
    [19975] = { parent = 339 }, -- Nature's Grasp Rank 1
    
    [29166] = { type = BUFF_OFFENSIVE }, -- Innervate
    
    [1850] = { type = BUFF_OFFENSIVE }, -- Dash
    [16689] = { type = BUFF_OFFENSIVE }, -- Nature's Grasp Buff
    [770] = { type = BUFF_OTHER }, -- Faerie Fire
    [16857] = { parent = 770 }, -- Faerie Fire (Feral)
    
    [132158] = { type = BUFF_OTHER }, -- Nature's Swiftness
    
    [102342] = { type = BUFF_DEFENSIVE }, -- Ironbark
    
    [110791] = { type = BUFF_DEFENSIVE }, -- Evasion (Rogue)
    [110575] = { type = BUFF_DEFENSIVE }, -- Icebound Fortitude (Death Knight)
    [122291] = { type = BUFF_DEFENSIVE }, -- Unending Resolve (Warlock)

    [41425] = { type = BUFF_OTHER, }, -- Hypothermia
    [66] = { type = BUFF_OFFENSIVE, },  -- Invisibility
    [44544] = { type = BUFF_OFFENSIVE, }, -- Fingers of Frost

    [11426] = { type = BUFF_DEFENSIVE }, -- Ice Barrier
    [543] = { type = BUFF_DEFENSIVE }, -- Fire Ward
    
    [12042] = { type = BUFF_OFFENSIVE }, -- Arcane Power
    [12051] = { type = BUFF_OFFENSIVE }, -- Evocation
    [1463] = { type = BUFF_DEFENSIVE }, -- Mana Shield
    
    [12043] = { type = BUFF_OTHER }, -- Presence of Mind
    [12472] = { type = BUFF_OFFENSIVE }, -- Icy Veins
    [87023] = { type = BUFF_OTHER, }, -- Cauterize
    
    [110909] = { type = BUFF_DEFENSIVE }, -- Alter Time
    [115610] = { type = BUFF_DEFENSIVE }, -- Temporal Shield

    [51690] = { type = BUFF_OFFENSIVE, },  -- Killing Spree
    [51713] = { type = BUFF_OFFENSIVE, }, -- Shadow Dance
    
    
    [13750] = { type = BUFF_OFFENSIVE}, -- Adrenaline Rush
    [13877] = { type = BUFF_OFFENSIVE}, -- Blade Flurry
    
    [2983] = { type = BUFF_OFFENSIVE }, -- Sprint
    [5277] = { type = BUFF_DEFENSIVE }, -- Evasion
    

    [45182] = { type = BUFF_DEFENSIVE }, -- Cheating Death
    [14177] = { type = BUFF_OFFENSIVE }, -- Cold Blood
    
    [74001] = { type = BUFF_DEFENSIVE }, -- Combat Readiness
    
    [114018] = { type = BUFF_OTHER }, -- Shroud of Concealment
    

    [3411] = { type = BUFF_DEFENSIVE },  -- Intervene
    [12975] = { type = BUFF_DEFENSIVE },  -- Last Stand
    
    [55694] = { type = BUFF_DEFENSIVE },  -- Enraged Regeneration
    [60503] = { type = BUFF_OFFENSIVE, }, -- Taste for Blood
    [65925] = { type = BUFF_OFFENSIVE, }, -- Unrelenting Assault (2/2)
    
    [1719] = { type = BUFF_OFFENSIVE }, -- Recklessness
    [871] = { type = BUFF_DEFENSIVE }, -- Shield Wall
    [18499] = { type = BUFF_OFFENSIVE }, -- Berserker Rage
    
    [12976] = { type = BUFF_DEFENSIVE }, -- Last Stand
    [12294] = { type = BUFF_OTHER }, -- Mortal Strike

    
    [118038] = { type = BUFF_DEFENSIVE }, -- Die by the Sword
    [114203] = { type = BUFF_OFFENSIVE }, -- Demoralizing Banner


    [126456] = { type = BUFF_DEFENSIVE }, -- Fortifying Brew
	[116849] = { type = BUFF_DEFENSIVE }, -- Life Cocoon
	
	[122278] = { type = BUFF_DEFENSIVE }, -- Dampen Harm
	[116844] = { type = BUFF_OTHER }, -- ROP
	[125174] = { type = BUFF_DEFENSIVE }, -- Touch of Karma buff that monks get on activation
	[115288] = { type = BUFF_OFFENSIVE }, -- Energizing Brew
}
