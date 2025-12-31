local _, fPB = ...

local defaultLargeSpells = { --Important spells, add them with huge icons.

}

local defaultMediumSpells = { --semi-important spells, add them with mid size icons.

}

local defaultHiddenSpells = {
  
}

-- here comes my default spell lists

-- size 1.1
local snares50 = {
	-- 50 % slows
	147531, -- Bloodbath -- 50%
	110300, -- Burden of Guilt -- 50%
	12486, -- Chilled -- 50%
	50435, -- Chilblains -- 50%
	132747, -- Crippling Poison -- 50%
	26679, -- Deadly Throw -- 50%
	119696, -- Debilitation -- 50%
	116095, -- Disable -- 50%
	123727, -- Dizzying Haze -- 50%
	8034, -- Frostbrand Attack -- 50%
	116, -- Frostbolt -- 50%
	8056, -- Frost Shock -- 50%
	102355, -- Faerie Swarm -- 50%
	5116, -- Concussive Shot -- 50%
	20170, -- Seal of Justice -- 50%
	129923, -- Sluggish (Glyph of Hindering Strikes) -- 50%
	1715, -- Hamstring -- 50%
	58180, -- Infected Wounds -- 50%
	3600, -- Earthbind (Earthbind Totem) -- 50%
	116947, -- Earthbind (Earthgrab Totem) -- 50%
	15407, -- Mind Flay -- 50%
	137637, -- Warbringer -- 50%
	73682, -- Unleash Frost -- 50%
	12323, -- Piercing Howl -- 50%
	63529, -- Dazed - Avenger's Shield -- 50%
	61391, -- Typhoon -- 50%
	50259, -- Dazed (Wild Charge - Cat) -- 50%
	1604, -- Dazed -- 50%
	35101, -- Concussive Barrage -- 50%
	31589, -- Slow -- 50%
	50433, -- Ankle Crack (Crocolisk) -- 50%
	3409, -- Crippling Poison -- 50%
	54644, -- Frost Breath (Chimaera) -- 50%
	135299, -- Ice Trap -- 50%
	17962, -- Conflagrate -- 50%
}

-- size 1.2
local snares60 = {
	45524, -- Chains of Ice -- 60%
	120, -- Cone of Cold -- 60%
}

-- size 1.3
local snares70 = {
	123586, -- Flying Serpent Kick -- 70%
	113092, -- Frost Bomb -- 70%
	15571, -- Dazed -- 70%
	61394, -- Frozen Wake (Glyph of Freezing Trap) -- 70%
}

-- size 1.9
local roots = {
	96294, -- Chains of Ice (Chilblains)
	91807, -- Shambling Rush (Dark Transformation)
	339, -- Entangling Roots
	113770, -- Entangling Roots (Force of Nature - Balance Treants)
	19975, -- Entangling Roots (Nature's Grasp)
	45334, -- Immobilized (Wild Charge - Bear)
	102359, -- Mass Entanglement
	110693, -- Frost Nova (Mage) [Symbiosis]
	19185, -- Entrapment
	64803, -- Entrapment
	136634, -- Narrow Escape
	90327, -- Lock Jaw (Dog)
	50245, -- Pin (Crab)
	54706, -- Venom Web Spray (Silithid)
	4167, -- Web (Spider)
	96201, -- Web Wrap (Shale Spider)
	122, -- Frost Nova
	111340, -- Ice Ward
	33395, -- Freeze (Water Elemental)
	116706, -- Disable (Root)
	113275, -- Entangling Roots (Symbiosis) [Monk]
	123407, -- Spinning Fire Blossom
	115197, -- Partial Paralysis
	64695, -- Earthgrab (Earthgrab Totem)
	63685, -- Freeze (Frozen Power)
	87194, -- Glyph of Mind Blast
	114404, -- Void Tendril's Grasp
	39965, -- Frost Grenade
	55536, -- Frostweave Net
	13099, -- Net-o-Matic
	107566, -- Staggering Shout
	105771, -- Warbringer
	115000, -- Remorseless Winter
	25999, -- Charge
}

local silences = {

}

local disarms = {

}

-- size 2.0 -- hard dispellable and undispellable cc
local cc = {
	
}

-- show mine only on enemies because stacks with others' debuffs
local war_personal_nostack_debuffs = {
	115767, -- Deep Wounds 1.3
	86346, -- Colossus Smash 1.5
}

-- show on enemy only because it does not stack
local war_personal_stackable_debuffs = {
	8680, -- Wound Poison Healing Debuff
	115804, -- Mortal Wounds 1.4
	81326, -- Physical Invulnerability 1.2 -- 4% dmg increase to the target with this debuff
	64382, -- Shattering Throw 1.2 -- target with this debuff has 20% less armor
	114205, -- Demoralizing Banner 1.2 -- target with this debuff does 10% less damage
	115798, -- Weakened Blows 1.1 -- target with this debuff does 10% less physical damage
}

-- 1.8
local major_defensive_buffs = {
	114214, -- Angelic bulwark
	110909, -- Alter Time 
	50461, -- Anti-Magic Zone
	22812, -- Barkskin 
	6940, -- Blessing of Sacrifice
	111397, -- Blood Horror
	45182, -- Cheating Death
	74001, -- Combat Readiness 
	1742, -- Cower (Pet) 
	110913, -- Dark Bargain 
	118038, -- Die by the Sword 
	64843, -- Divine Hymn 
	498, -- Divine Protection 
	55694, -- Enraged Regeneration 
	5277, -- Evasion 
	110791, -- Evasion (Druid) (Symbiosis)
	5384, -- Feign Death 
	18708, -- Fel Domination
	126456, -- Fortifying Brew
	22842, -- Frenzied Regeneration 
	47788, -- Guardian Spirit 
	11426, -- Ice Barrier 
	48792, -- Icebound Fortitude 
	110575, -- Icebound Fortitude (Druid) (Symbiosis)
	102342, -- Ironbark 
	12975, -- Last Stand 
	12976, -- Last Stand 
	1463, -- Mana Shield 
	132158, -- Nature's Swiftness, can either be defensive or offensive but want size to be big so added here
	30299, -- Nether Protection 
	33206, -- Pain Suppression 
	53480, -- Roar of Sacrifice (Hunter Pet Skill)
	6229, -- Shadow Ward
	30823, -- Shamanistic Rage 
	871, -- Shield Wall 
	20711, -- Spirit of Redemption
	98007, -- Spirit Link Totem
	61336, -- Survival Instincts 
	115610, -- Temporal Shield 
	104773, -- Unending Resolve 
	122291, -- Unending Resolve (Druid) (Symbiosis)
	81256, -- Dancing Rune Weapon -- 20% Parry
	116849, -- Life Cocoon
	122278, -- Dampen Harm
	116844, -- Ring of Peace
	122470, -- Touch of Karma
	31821, -- Devotion Aura
	31842, -- Divine Favor
	31850, -- Ardent Defender
	86659, -- Guardian of Ancient Kings
	81782, -- Power Word: Barrier
	45242, -- Focused Will
	122465, -- Dematerialize
	114030, -- Vigilance
	16188,-- Ancestral Swiftness, can either be defensive or offensive but want size to be big so added here
	12043, -- Presence of Mind, No Check Spell ID, just the buff name, can either be defensive or offensive but want size to be big so added here
}

-- size 1.7
-- only shown on nameplates & not on bigdebuffs addon 
local minor_defensive_buffs = {
	1966, -- Feint
	17, -- Power Word: Shield
	47753, -- Divine Aegis
	20594, -- Stoneform
	7812, -- Sacrifice warlock 10k shield from pet sac
	102351, -- Cenarion Ward, rdruid healing hot
	108281, -- Ancestral Guidance
	116680, -- tHUNDER fOCUS tEA
	108359, -- Dark Regeneration
	31567, -- tbc deterrence? Does it still exist in MoP?
	108416, -- Sacrificial Pact
	119899, -- Cauterize Master
	147833, -- Intervene
	122506, -- Intervene w/ Blitz?
	122292, -- Intervene (Druid) (Symbiosis)
	3411, -- Intervene 
	53476, -- Intervene (Pet)
	46947, -- Safeguard
	122973, -- Safeguard
	97463, -- Rallying Cry
	102351, -- Cenarion Ward
	2565, -- Shield Block
	96267, -- Inner Focus
	23493, -- Restoration (BG Leaf Healing Buff)
	77613, -- Grace -- Increase all healing received from the priest by 30%


}

-- 1.6
local major_offensive_buffs = {
	13750, -- Adrenaline Rush 
	12042, -- Arcane Power 
	114049, -- Ascendance 
	31884, -- Avenging Wrath 
	23505, -- Battleground Damage buff 
	23451, -- Battleground Speed buff 
	50334, -- Berserk
	13877, -- Blade Flurry 
	20572, -- Blood Fury 
	2825, -- Bloodlust 
	126690, -- Call of Conquest 
	126683, -- Call of Dominance 
	126679, -- Call of Victory 
	14177, -- Cold Blood 
	79462, -- Demon Soul: Felguard 
	79460, -- Demon Soul: Felhunter
	79459, -- Demon Soul: Imp 
	79463, -- Demon Soul: Succubus 
	79464, -- Demon Soul: Voidwalker 
	16166, -- Elemental Mastery
	44544, -- Fingers of Frost
	32182, -- Heroism 
	12472, -- Icy Veins -- no check spell id
	29166, -- Innervate 
	19577, -- Intimidation (Buff)
	51690, -- Killing Spree  
	16191, -- Mana Tide Totem 
	47241, -- Metamorphosis 
	23723, -- Mind Quickening Gem 
	16689, -- Nature's Grasp Buff
	51271, -- Pillar of Frost 
	10060, -- Power Infusion 
	69369, -- Predator's Swiftness 
	3045, -- Rapid Fire 
	1719, -- Recklessness
	51713, -- Shadow Dance 
	23132, -- Shadow Reflector 
	5024, -- Skull of Impending Doom
	2379, -- Swiftness Potion 
	34471, -- The Beast Within 
	49016, -- Unholy Frenzy 
	7744, -- Will of the Forsaken 
	85696, -- Zealotry 
	114206, -- Skull Banner -- 20% Crit Damage
	5217, -- Tiger's Fury
	115288, -- Energizing Brew
	105809, -- Holy Avenger
	113860, -- Dark Soul: Misery
	113858, -- Dark Soul: Instability
	113861, -- Dark Soul: Knowledge
	107574, -- Avatar
	120679, -- Dire Beast
	82726, -- Fervor
	121818, -- Stampede
}

-- 1.5
local  minor_offensive_buffs = {
	93435, -- Roar of Courage
	126700, -- Surge of Victory
	104423, -- Windsong
	12880, -- Enrage
	-- 142530, -- Bloody Dancing Steel
	120032, -- Dancing Steel
	104993, -- Jade Spirit
	126734, -- Synapse Springs
	115989, -- Unholy Blight
	12051, -- Evocation
	128432, -- Cackling Howl
	108508, -- Mannoroth's Fury
	57934, -- Tricks of the Trade
}

-- 1.8
local spell_immunities = {
	48707, -- Anti-Magic Shell (Death Knight)
	110570, -- Anti-Magic Shell (Druid) (symbiosis)
	31224, -- Cloak of Shadows (Rogue)
	110788, -- Cloak of Shadows (Druid) (symbiosis)
	122465, -- Dematerilaize
	115760, -- Glyph of Ice Block
	8178, -- Grounding Totem Effect
	49039, -- Lichborne
	114028, -- Mass Spell Reflection
	33961, -- Spell Reflection
	23920, -- Spell Reflection (Warrior)
	113002, -- Spell Reflection (Druid) (symbiosis)
	131523, -- Zen Meditation
	137562, -- Nimble Brew
	122783, -- Diffuse Magic
	6346, -- Fear Ward
	114039, -- Hand of Purity
}

-- 1.5
local mobility_buffs = {
	110806, -- spiritwalker's grace
	114239, -- Phantasm
	58875, -- Spirit Walk
	1044, -- Hand of Freedom
	53271, -- Master's Call
	116841, -- Tiger's Lust
	109215, -- Posthaste
	108843, -- Blazing Speed
	85499, -- Speed of Light
	73325, -- Leap of Faith
	133278,  -- warrior heroic leap PVP set bonus speed buff
	121557, -- Angelic Feather
	36554, -- Shadowstep
	77761, -- Stampeding Roar
	96268, -- Death's Advance
	137573, -- Burst of Speed
	108212, -- Burst of Speed
}

-- 1.5
local speed_buffs = {
	2983, -- Sprint
	1850, -- Dash
	54861, -- Nitro Boosts
	65081, -- Body and Soul
}

-- 1.5
local mana_buffs = {
	29166, -- Innervate
	54428, -- Divine Plea
}

-- 2.0 -- added both since they are both same size
local drinkflags = {
	23333, -- Warsong Flag (horde WSG flag)
	23335, -- Silverwing Flag (alliance WSG flag)
	22734, -- Drink
	46755, -- Drink
	27089, -- Drink
	43183, -- Drink
	57073, -- Drink
	34976, -- Nether Flag (Eye of the Storm flag)
	141210, -- Horde Mine (Silvershard Mines flag)
	140876, -- Alliance Mine (Silvershard Mines flag)
}

-- 1.4
local stances_forms = {
	5487, -- Bear Form
	768, -- Cat Form
	783, -- Travel Form
	24858, -- Moonkin Form
	33891, -- Incarnation: Tree of Life
	115191, -- Stealth
	115834, -- Shroud of Concealment
	80325, -- Camouflage
	51755, -- Camouflage
	90954, -- Camouflage
	119450, -- Camouflage
	119030, -- Spectral Guise -- No Check Spell ID, just the buff name
	66, -- Invisibility
	2645, -- Ghost Wolf
}

local constraint_debuffs = {
	41425, -- Hypothermia
	87023, -- Cauterize
	25771, -- Forbearance
	113942, -- Demonic Gateway Cooldown
	770, -- Faerie Fire, No Check Spell ID, just the debuff name
	31615, -- Hunter's Mark, No Check Spell ID, just the debuff name
}



fPB.defaultLargeSpells = defaultLargeSpells
fPB.defaultMediumSpells = defaultMediumSpells
fPB.defaultHiddenSpells = defaultHiddenSpells

fPB.snares50 = snares50
fPB.snares60 = snares60			
fPB.snares70 = snares70

fPB.roots = roots
fPB.silences = silences
fPB.disarms = disarms

fPB.cc = cc

fPB.war_personal_nostack_debuffs = war_personal_nostack_debuffs
fPB.war_personal_stackable_debuffs = war_personal_stackable_debuffs

fPB.major_defensive_buffs = major_defensive_buffs
fPB.minor_defensive_buffs = minor_defensive_buffs

fPB.major_offensive_buffs = major_offensive_buffs
fPB.minor_offensive_buffs = minor_offensive_buffs

fPB.spell_immunities = spell_immunities

fPB.mobility_buffs = mobility_buffs
fPB.speed_buffs = speed_buffs

fPB.mana_buffs = mana_buffs
fPB.drinkflags = drinkflags
fPB.stances_forms = stances_forms
fPB.constraint_debuffs = constraint_debuffs

