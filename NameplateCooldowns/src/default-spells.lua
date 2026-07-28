-- luacheck: no max line length
-- luacheck: globals GetBuildInfo LibStub GetSpellInfo

local _, addonTable = ...;

addonTable.HUNTER_FEIGN_DEATH = 5384;
addonTable.SPELL_PVPTRINKET = 42292;
addonTable.HUNTER_SURVIVAL_SPEC_SPELL = 53301; -- Explosive Shot
addonTable.HUNTER_TRAP_SPELLS = {
	[13813] = true,
	[82939] = true,
	[13809] = true,
	[82941] = true,
	[13795] = true,
	[82945] = true,
	[34600] = true,
	[82948] = true,
	[1499] = true,
	[60192] = true,
};

addonTable.CDs = {
	[addonTable.UNKNOWN_CLASS] = {
		-- // reviewed 2021/02/08
		[42292] = 120,		-- // PvP-аксессуар https://www.wowhead.com/cata/ru/spell=42292
		[28730] = 120,		-- // Arcane Torrent https://www.wowhead.com/cata/ru/spell=28730
		[50613] = 120,		-- // Arcane Torrent https://www.wowhead.com/cata/ru/spell=50613
		[25046] = 120,		-- // Arcane Torrent https://www.wowhead.com/cata/ru/spell=25046
		[20572] = 120,		-- // Blood Fury https://www.wowhead.com/cata/ru/spell=20572
		[33702] = 120,		-- // Blood Fury https://www.wowhead.com/cata/ru/spell=33702
		[33697] = 120,		-- // Blood Fury https://www.wowhead.com/cata/ru/spell=33697
		[59543] = 180,		-- // Gift of the Naaru https://www.wowhead.com/cata/ru/spell=59543
		[26297] = 180,		-- // Berserking https://www.wowhead.com/cata/ru/spell=26297
		[20594] = 120,		-- // Stoneform https://www.wowhead.com/cata/ru/spell=20594
		[58984] = 120,		-- // Shadowmeld https://www.wowhead.com/cata/ru/spell=58984
		[20589] = 105,		-- // Escape Artist https://www.wowhead.com/cata/ru/spell=20589
		[59752] = 120,		-- // Every Man for Himself https://www.wowhead.com/cata/ru/spell=59752
		[7744] = 120,		-- // Will of the Forsaken https://www.wowhead.com/cata/ru/spell=7744
	},
	["HUNTER"] = {
		-- // reviewed 2026/07/27
		[53271] = 45,   -- https://www.wowhead.com/mop-classic/spell=53271/masters-call
		[3045] = 180,   -- https://www.wowhead.com/mop-classic/spell=3045/rapid-fire
		[1543] = 20,    -- https://www.wowhead.com/mop-classic/spell=1543/flare
		[13813] = 30,   -- https://www.wowhead.com/mop-classic/spell=13813/explosive-trap
		[82939] = 30,   -- https://www.wowhead.com/mop-classic/spell=82939/explosive-trap
		[13809] = 30,   -- https://www.wowhead.com/mop-classic/spell=13809/ice-trap
		[82941] = 30,   -- https://www.wowhead.com/mop-classic/spell=82941/ice-trap
		[13795] = 30,   -- https://www.wowhead.com/mop-classic/spell=13795/immolation-trap
		[82945] = 30,   -- https://www.wowhead.com/mop-classic/spell=82945/immolation-trap
	
		[1499] = 30,    -- https://www.wowhead.com/mop-classic/spell=1499/freezing-trap
		[60192] = 30,   -- https://www.wowhead.com/mop-classic/spell=60192/freezing-trap
		[19263] = 180,  -- https://www.wowhead.com/mop-classic/spell=19263/deterrence
		[781] = 20,     -- https://www.wowhead.com/mop-classic/spell=781/disengage
		[5384] = 30,    -- https://www.wowhead.com/mop-classic/spell=5384/feign-death
		[19574] = 60,   -- https://www.wowhead.com/mop-classic/spell=19574/bestial-wrath
		[82726] = 30,   -- https://www.wowhead.com/mop-classic/spell=82726/fervor
		[34490] = 24,   -- https://www.wowhead.com/mop-classic/spell=34490/silencing-shot
		[19386] = 45,   -- https://www.wowhead.com/mop-classic/spell=19386/wyvern-sting
		[19577] = 60,   -- https://www.wowhead.com/mop-classic/spell=19577/intimidation
		[53480] = 60,   -- https://www.wowhead.com/mop-classic/spell=53480/roar-of-sacrifice
		[19503] = 30,   -- https://www.wowhead.com/mop-classic/spell=19503/scatter-shot
		[131894] = 120, -- https://www.wowhead.com/mop-classic/spell=131894/a-murder-of-crows
	},
	["WARLOCK"] = {
		-- // reviewed 2026/07/27
		[6789] = 45,     -- https://www.wowhead.com/mop-classic/spell=6789/mortal-coil
		[5484] = 35,     -- https://www.wowhead.com/mop-classic/spell=5484/howl-of-terror 
		-- base cooldown is 40 seconds, but every damaging attack received reduces the remaining cooldown by 1 second. 
		-- Its effective cooldown can therefore be lower than 40 seconds. Ima just set it 35.
		[113858] = 20,   -- https://www.wowhead.com/mop-classic/spell=113858/dark-soul-instability?spellModifier=108505
		[113861] = 20,   -- https://www.wowhead.com/mop-classic/spell=113861/dark-soul-knowledge?spellModifier=108505
		[113860] = 20,   -- https://www.wowhead.com/mop-classic/spell=113860/dark-soul-misery?spellModifier=108505
		[6229] = 30,     -- https://www.wowhead.com/mop-classic/spell=6229/twilight-ward
		[48020] = 25,    -- https://www.wowhead.com/mop-classic/spell=48020/demonic-circle-teleport
		--[[
		Demonic Circle: Teleport — ID 48020

		Base cooldown is 30 seconds.

		Demonic Circle Cooldown Reduction, spell 33063: reduces it by 5 seconds, producing 25 seconds. AKA PVP GEAR SET BONUS!!!
		Glyph of Demonic Circle, spell 63309: reduces it by 4 seconds, producing 21 seconds.

		The two pages do not establish whether those reductions stack together, so I would not treat 21 seconds as confirmed without an in-game test.
		]]
		[88448] = 120,   -- https://www.wowhead.com/mop-classic/spell=88448/demonic-rebirth
		[109151] = 10,    -- https://www.wowhead.com/mop-classic/spell=54786/demonic-leap
		[91711] = 30,    -- https://www.wowhead.com/mop-classic/spell=91711/nether-ward
		[30283] = 30,    -- https://www.wowhead.com/mop-classic/spell=30283/shadowfury
		[19647] = 24,    -- https://www.wowhead.com/mop-classic/spell=19647/spell-lock
		[104773] = 180,  -- https://www.wowhead.com/mop-classic/spell=104773/unending-resolve
		--[[
			Unending Resolve — ID 104773

			Base cooldown is 180 seconds. 
			Glyph of Unending Resolve reduces it by 60 seconds, 
			producing a 120-second cooldown, but also reduces the ability’s damage reduction by 20 percentage points.

			If they use wall less than 180 seconds, then the cooldown will be 120 seconds. 
			If they use wall after 180 seconds, then the cooldown will be 180 seconds.
		]]
		[108359] = 120,  -- https://www.wowhead.com/mop-classic/spell=108359/dark-regeneration
		[110913] = 180,  -- https://www.wowhead.com/mop-classic/spell=110913/dark-bargain
		[111397] = 30,   -- https://www.wowhead.com/mop-classic/spell=111397/blood-horror
		[89766] = 30,    -- https://www.wowhead.com/mop-classic/spell=89766/axe-toss
		[80240] = 25,    -- https://www.wowhead.com/mop-classic/spell=80240/havoc
		--[[
			Havoc — ID 80240

			Base cooldown is 25 seconds. Glyph of Havoc adds three charges but increases the cooldown by 35 seconds, producing a 60-second cooldown.
			Glypth can only be used by destro warlocks so for this, we needed to detect if player is destro so check combat log for conflag/destro specific spells
			but then complex implementation to check 3 stacks or 6 stacks if the destro is running the glyph is implemented.
		]]
		[89751] = 45,    -- https://www.wowhead.com/mop-classic/spell=89751/felstorm
		[115781] = 24,   -- https://www.wowhead.com/mop-classic/spell=115781/optical-blast
		[115770] = 25,   -- https://www.wowhead.com/mop-classic/spell=115770/fellash
	},
	["MAGE"] = {
		-- // reviewed 2026/07/27
		[80353] = 300,  -- https://www.wowhead.com/mop-classic/spell=80353/time-warp
		[1463] = 25,    -- https://www.wowhead.com/mop-classic/spell=1463/incanters-ward
		[55342] = 180,  -- https://www.wowhead.com/mop-classic/spell=55342/mirror-image
		[2139] = 24,    -- https://www.wowhead.com/mop-classic/spell=2139/counterspell
		--[[
		Counterspell — 2139

		The base cooldown is 24 seconds.

		Glyph of Counterspell, spell 115703, allows Counterspell to be cast while casting or channeling, 
		but increases its cooldown by 4 seconds, resulting in 28 seconds.

		The Mage PvP two-piece bonus reduces Counterspell’s remaining cooldown by 4 seconds after a successful interrupt. 
		This is conditional and does not permanently change the base cooldown.
		]]
		[12051] = 120,  -- https://www.wowhead.com/mop-classic/spell=12051/evocation
		[1953] = 15,    -- https://www.wowhead.com/mop-classic/spell=1953/blink
		[66] = 300,     -- https://www.wowhead.com/mop-classic/spell=66/invisibility
		[45438] = 300,  -- https://www.wowhead.com/mop-classic/spell=45438/ice-block
		[122] = 25,     -- https://www.wowhead.com/mop-classic/spell=122/frost-nova
		[120] = 10,     -- https://www.wowhead.com/mop-classic/spell=120/cone-of-cold
		[33395] = 25,   -- https://www.wowhead.com/mop-classic/spell=33395/freeze
		[12042] = 90,   -- https://www.wowhead.com/mop-classic/spell=12042/arcane-power
		[12043] = 90,   -- https://www.wowhead.com/mop-classic/spell=12043/presence-of-mind
		[11129] = 45,   -- https://www.wowhead.com/mop-classic/spell=11129/combustion
		[31661] = 20,   -- https://www.wowhead.com/mop-classic/spell=31661/dragons-breath
		[12472] = 180,  -- https://www.wowhead.com/mop-classic/spell=12472/icy-veins
		[44572] = 30,   -- https://www.wowhead.com/mop-classic/spell=44572/deep-freeze
		[11958] = 180,  -- https://www.wowhead.com/mop-classic/spell=11958/cold-snap
		[11426] = 25,   -- https://www.wowhead.com/mop-classic/spell=11426/ice-barrier
		[108978] = 90, -- https://www.wowhead.com/mop-classic/spell=108978/alter-time
		--[[
			Alter Time — 108978
			The base cooldown is 180 seconds.
			The Mage PvP four-piece bonus reduces Alter Time’s cooldown by 90 seconds.
		--]]
		[84714] = 60,   -- https://www.wowhead.com/mop-classic/spell=84714/frozen-orb
		[113724] = 45,  -- https://www.wowhead.com/mop-classic/spell=113724/ring-of-frost
	},
	["DEATHKNIGHT"] = {
		-- // reviewed 2027/07/27
		[77606] = 60,   -- https://www.wowhead.com/mop-classic/spell=77606/dark-simulacrum
		[48743] = 120,  -- https://www.wowhead.com/mop-classic/spell=48743/death-pact
		[47476] = 60,   -- https://www.wowhead.com/mop-classic/spell=47476/strangulate
		[48792] = 180,  -- https://www.wowhead.com/mop-classic/spell=48792/icebound-fortitude
		[47528] = 15,   -- https://www.wowhead.com/mop-classic/spell=47528/mind-freeze
		[48707] = 45,   -- https://www.wowhead.com/mop-classic/spell=48707/anti-magic-shell
		[49576] = 25,   -- https://www.wowhead.com/mop-classic/spell=49576/death-grip
		[42650] = 600,  -- https://www.wowhead.com/mop-classic/spell=42650/army-of-the-dead
		[46584] = 120,  -- https://www.wowhead.com/mop-classic/spell=46584/raise-dead
		[49222] = 60,   -- https://www.wowhead.com/mop-classic/spell=49222/bone-shield
		[49028] = 90,   -- https://www.wowhead.com/mop-classic/spell=49028/dancing-rune-weapon
		[55233] = 60,   -- https://www.wowhead.com/mop-classic/spell=55233/vampiric-blood
		[49039] = 120,  -- https://www.wowhead.com/mop-classic/spell=49039/lichborne
		[51271] = 60,   -- https://www.wowhead.com/mop-classic/spell=51271/pillar-of-frost
		[49016] = 180,  -- https://www.wowhead.com/mop-classic/spell=49016/unholy-frenzy
		[49206] = 180,  -- https://www.wowhead.com/mop-classic/spell=49206/summon-gargoyle
		[51052] = 120,  -- https://www.wowhead.com/mop-classic/spell=51052/anti-magic-zone
		[47568] = 300,  -- https://www.wowhead.com/mop-classic/spell=47568/empower-rune-weapon
		[61999] = 600,  -- https://www.wowhead.com/mop-classic/spell=61999/raise-ally
		[48982] = 30,   -- https://www.wowhead.com/mop-classic/spell=48982/rune-tap
		[47481] = 60,   -- https://www.wowhead.com/mop-classic/spell=47481/gnaw
	},
	["DRUID"] = {
		-- // reviewed 2024/05/23
		[29166]	= 132,	-- https://www.wowhead.com/cata/ru/spell=29166
		[22812]	= 45,		-- barkskin baseline 1 min cd but Malfurion's Gift 45
		[16689]	= 60,		-- https://www.wowhead.com/cata/ru/spell=16689
		[77764]	= 120,	-- https://www.wowhead.com/cata/ru/spell=77764
		[16979]	= 14,		-- https://www.wowhead.com/cata/ru/spell=16979
		[80965]	= 10,		-- https://www.wowhead.com/cata/ru/spell=80965
		[5217]	= 27,		-- https://www.wowhead.com/cata/ru/spell=5217
		[49376]	= 28,		-- https://www.wowhead.com/cata/ru/spell=49376
		[80964]	= 10,		-- https://www.wowhead.com/cata/ru/spell=80964
		[22842]	= 180,	-- https://www.wowhead.com/cata/ru/spell=22842
		[1850]	= 144,	-- https://www.wowhead.com/cata/ru/spell=1850
		[77761]	= 120,	-- https://www.wowhead.com/cata/ru/spell=77761
		[5211]	= 50,		-- https://www.wowhead.com/cata/ru/spell=5211
		[5229]	= 60,		-- https://www.wowhead.com/cata/ru/spell=5229
		[20484]	= 300,	-- https://www.wowhead.com/cata/ru/spell=20484
		[740]	= 180,		-- https://www.wowhead.com/cata/ru/spell=740
		[48505]	= 60,		-- https://www.wowhead.com/cata/ru/spell=48505
		[50516]	= 17,		-- https://www.wowhead.com/cata/ru/spell=50516
		[78675]	= 60,		-- https://www.wowhead.com/cata/ru/spell=78675
		[33831]	= 180,	-- https://www.wowhead.com/cata/ru/spell=33831
		[50334]	= 180,	-- https://www.wowhead.com/cata/ru/spell=50334
		[61336]	= 180,	-- https://www.wowhead.com/cata/ru/spell=61336
		[33891]	= 180,	-- https://www.wowhead.com/cata/ru/spell=33891
		[17116]	= 156,	-- https://www.wowhead.com/cata/ru/spell=17116
		[22570] = 10,		-- https://www.wowhead.com/cata/ru/spell=22570
		[102342] = 30, -- https://www.wowhead.com/mop-classic/spell=102342/ironbark
		[108294] = 360, -- https://www.wowhead.com/mop/ru/spell=108294
		[132158] = 60, -- https://www.wowhead.com/mop-classic/spell=132158/natures-swiftness
		[99] = 30, -- disor roar
		[113004] = 90, -- intimi roar
	},
	["PALADIN"] = {
		-- // reviewed 2024/05/25
		[85673] = 15, -- https://www.wowhead.com/cata/ru/spell=85673
		[2812] = 15, -- https://www.wowhead.com/cata/ru/spell=2812
		[54428] = 120, -- https://www.wowhead.com/cata/ru/spell=54428
		[26573] = 30, -- https://www.wowhead.com/cata/ru/spell=26573
		[633] = 180, -- https://www.wowhead.com/cata/ru/spell=633
		[86150] = 180, -- https://www.wowhead.com/cata/ru/spell=86150
		[498] = 30, -- https://www.wowhead.com/mop-classic/spell=498/divine-protection?spellModifier=114154
		[6940] = 66, -- https://www.wowhead.com/cata/ru/spell=6940
		[642] = 300, -- https://www.wowhead.com/cata/ru/spell=642
		[1022] = 180, -- https://www.wowhead.com/cata/ru/spell=1022
		[1044] = 20, -- https://www.wowhead.com/cata/ru/spell=1044
		[853] = 45, -- https://www.wowhead.com/cata/ru/spell=853
		[96231] = 10, -- https://www.wowhead.com/cata/ru/spell=96231
		[31884] = 120, -- https://www.wowhead.com/cata/ru/spell=31884
		[31842] = 165, -- https://www.wowhead.com/cata/ru/spell=31842
		[31821] = 120, -- https://www.wowhead.com/cata/ru/spell=31821
		[70940] = 180, -- https://www.wowhead.com/cata/ru/spell=70940
		[31850] = 180, -- https://www.wowhead.com/cata/ru/spell=31850
		[20925] = 30, -- https://www.wowhead.com/cata/ru/spell=20925
		[85696] = 120, -- https://www.wowhead.com/cata/ru/spell=85696
		[20066] = 60, -- https://www.wowhead.com/cata/ru/spell=20066
		[64205] = 120, -- https://www.wowhead.com/cata/ru/spell=64205
		[20473] = 5, -- https://www.wowhead.com/cata/ru/spell=20473
		[115750] = 120, -- https://www.wowhead.com/mop/ru/spell=115750
		[10326] = 15, -- https://www.wowhead.com/mop/ru/spell=10326
	},
	["PRIEST"] = {
		-- // reviewed 2024/05/25
		[6346] = 120, -- https://www.wowhead.com/cata/ru/spell=6346
		[73325] = 90, -- https://www.wowhead.com/cata/ru/spell=73325
		[64901] = 360, -- https://www.wowhead.com/cata/ru/spell=64901
		[88625] = 20, -- https://www.wowhead.com/cata/ru/spell=88625
		[64843] = 180, -- https://www.wowhead.com/cata/ru/spell=64843
		[32379] = 10, -- https://www.wowhead.com/cata/ru/spell=32379
		[34433] = 240, -- https://www.wowhead.com/cata/ru/spell=34433
		[586] = 15, -- https://www.wowhead.com/cata/ru/spell=586
		[8122] = 25, -- https://www.wowhead.com/cata/ru/spell=8122
		[10060] = 120, -- https://www.wowhead.com/cata/ru/spell=10060
		[62618] = 180, -- https://www.wowhead.com/cata/ru/spell=62618
		[89485] = 45, -- https://www.wowhead.com/cata/ru/spell=89485
		[33206] = 180, -- https://www.wowhead.com/cata/ru/spell=33206
		[14751] = 30, -- https://www.wowhead.com/cata/ru/spell=14751
		[19236] = 120, -- https://www.wowhead.com/cata/ru/spell=19236
		[47788] = 150, -- https://www.wowhead.com/cata/ru/spell=47788
		[47585] = 75, -- https://www.wowhead.com/cata/ru/spell=47585
		[15487] = 45, -- https://www.wowhead.com/cata/ru/spell=15487
		[64044] = 90, -- https://www.wowhead.com/cata/ru/spell=64044
		[724] = 180, -- https://www.wowhead.com/cata/ru/spell=724
		[108968] = 300, --  https://www.wowhead.com/mop/ru/spell=108968
		[108921] = 45, -- https://www.wowhead.com/mop/ru/spell=108921
	},
	["ROGUE"] = {
		-- // reviewed 2024/05/27
		[408] = 20, -- https://www.wowhead.com/cata/ru/spell=408
		[51722] = 60, -- https://www.wowhead.com/cata/ru/spell=51722
		[74001] = 90, -- https://www.wowhead.com/cata/ru/spell=74001
		[1776] = 9, -- https://www.wowhead.com/cata/ru/spell=1776
		[1766] = 8, -- https://www.wowhead.com/cata/ru/spell=1766
		[2983] = 60, -- https://www.wowhead.com/cata/ru/spell=2983
		[5277] = 180, -- https://www.wowhead.com/cata/ru/spell=5277
		[76577] = 180, -- https://www.wowhead.com/cata/ru/spell=76577
		[31224] = 90, -- https://www.wowhead.com/cata/ru/spell=31224
		[1856] = 90, -- https://www.wowhead.com/cata/ru/spell=1856
		[2094] = 120, -- https://www.wowhead.com/cata/ru/spell=2094
		[73981] = 60, -- https://www.wowhead.com/cata/ru/spell=73981
		[1725] = 20, -- https://www.wowhead.com/cata/ru/spell=1725
		[79140] = 120, -- https://www.wowhead.com/cata/ru/spell=79140
		[14177] = 120, -- https://www.wowhead.com/cata/ru/spell=14177
		[51690] = 120, -- https://www.wowhead.com/cata/ru/spell=51690
		[13750] = 180, -- https://www.wowhead.com/cata/ru/spell=13750
		[51713] = 60, -- https://www.wowhead.com/cata/ru/spell=51713
		[14185] = 120, -- https://www.wowhead.com/cata/ru/spell=14185
		[36554] = 14, -- https://www.wowhead.com/cata/ru/spell=36554
		[31231] = 60, -- https://www.wowhead.com/cata/ru/spell=31231
		[13877] = 10, -- https://www.wowhead.com/cata/ru/spell=13877
		[14183] = 20, -- https://www.wowhead.com/cata/ru/spell=14183
	},
	["SHAMAN"] = {
		-- // reviewed 2024/05/27
		[79206] = 120, -- https://www.wowhead.com/cata/ru/spell=79206
		[2894] = 300, -- https://www.wowhead.com/cata/ru/spell=2894
		[57994] = 5, -- https://www.wowhead.com/cata/ru/spell=57994
		[5730] = 20, -- https://www.wowhead.com/cata/ru/spell=5730
		[51514] = 35, -- https://www.wowhead.com/cata/ru/spell=51514
		[2484] = 15, -- https://www.wowhead.com/cata/ru/spell=2484
		[2825] = 300, -- https://www.wowhead.com/cata/ru/spell=2825
		[32182] = 300, -- https://www.wowhead.com/cata/ru/spell=32182
		[8177] = 22, -- https://www.wowhead.com/cata/ru/spell=8177
		[2062] = 600, -- https://www.wowhead.com/cata/ru/spell=2062
		[8143] = 60, -- https://www.wowhead.com/cata/ru/spell=8143
		[16166] = 180, -- https://www.wowhead.com/cata/ru/spell=16166
		[30823] = 60, -- https://www.wowhead.com/cata/ru/spell=30823
		[51533] = 120, -- https://www.wowhead.com/cata/ru/spell=51533
		[98008] = 180, -- https://www.wowhead.com/cata/ru/spell=98008
		[16190] = 180, -- https://www.wowhead.com/cata/ru/spell=16190
		[16188] = 90, -- https://www.wowhead.com/mop-classic/spell=16188/ancestral-swiftness
	},
	["WARRIOR"] = {
		-- // reviewed 2024/05/29
		[86346] = 20, -- https://www.wowhead.com/cata/ru/spell=86346
		[64382] = 300, -- https://www.wowhead.com/cata/ru/spell=64382
		[20230] = 300, -- https://www.wowhead.com/cata/ru/spell=20230
		[100] = 12, -- https://www.wowhead.com/cata/ru/spell=100
		[97462] = 180, -- https://www.wowhead.com/cata/ru/spell=97462
		[6544] = 50, -- https://www.wowhead.com/cata/ru/spell=6544
		[1719] = 240, -- https://www.wowhead.com/cata/ru/spell=1719
		[6552] = 10, -- https://www.wowhead.com/cata/ru/spell=6552
		[55694] = 180, -- https://www.wowhead.com/cata/ru/spell=55694
		[18499] = 24, -- https://www.wowhead.com/cata/ru/spell=18499
		[20252] = 20, -- https://www.wowhead.com/cata/ru/spell=20252
		[5246] = 105, -- https://www.wowhead.com/cata/ru/spell=5246
		[2565] = 30, -- https://www.wowhead.com/cata/ru/spell=2565
		[23920] = 20, -- https://www.wowhead.com/cata/ru/spell=23920
		[3411] = 30, -- https://www.wowhead.com/cata/ru/spell=3411
		[871] = 120, -- https://www.wowhead.com/cata/ru/spell=871
		[676] = 60, -- https://www.wowhead.com/cata/ru/spell=676
		[85730] = 120, -- https://www.wowhead.com/cata/ru/spell=85730
		[46924] = 75, -- https://www.wowhead.com/cata/ru/spell=46924
		[85388] = 45, -- https://www.wowhead.com/cata/ru/spell=85388
		[12292] = 144, -- https://www.wowhead.com/cata/ru/spell=12292
		[60970] = 30, -- https://www.wowhead.com/cata/ru/spell=60970
		[46968] = 17, -- https://www.wowhead.com/cata/ru/spell=46968
		[12975] = 180, -- https://www.wowhead.com/cata/ru/spell=12975
		[12809] = 30, -- https://www.wowhead.com/cata/ru/spell=12809
		[57755] = 30, -- https://www.wowhead.com/cata/ru/spell=57755
		[1161] = 180, -- https://www.wowhead.com/cata/ru/spell=1161
		[107570] = 30, -- 
		[114028] = 60, --
		[71] = 1.5, -- Defensive Stance
	},
	["SHAMAN"] = {
		-- // reviewed 2024/05/27
		[79206] = 120, -- https://www.wowhead.com/cata/ru/spell=79206
		[2894] = 300, -- https://www.wowhead.com/cata/ru/spell=2894
		[57994] = 5, -- https://www.wowhead.com/cata/ru/spell=57994
		[5730] = 20, -- https://www.wowhead.com/cata/ru/spell=5730
		[51514] = 35, -- https://www.wowhead.com/cata/ru/spell=51514
		[2484] = 15, -- https://www.wowhead.com/cata/ru/spell=2484
		[2825] = 300, -- https://www.wowhead.com/cata/ru/spell=2825
		[32182] = 300, -- https://www.wowhead.com/cata/ru/spell=32182
		[8177] = 22, -- https://www.wowhead.com/cata/ru/spell=8177
		[2062] = 600, -- https://www.wowhead.com/cata/ru/spell=2062
		[8143] = 60, -- https://www.wowhead.com/cata/ru/spell=8143
		[16166] = 180, -- https://www.wowhead.com/cata/ru/spell=16166
		[30823] = 60, -- https://www.wowhead.com/cata/ru/spell=30823
		[51533] = 120, -- https://www.wowhead.com/cata/ru/spell=51533
		[98008] = 180, -- https://www.wowhead.com/cata/ru/spell=98008
		[16190] = 180, -- https://www.wowhead.com/cata/ru/spell=16190
		[16188] = 96, -- https://www.wowhead.com/cata/ru/spell=16188
		[16166] = 90, -- https://www.wowhead.com/mop/ru/spell=16166
		[114049] = 180, -- https://www.wowhead.com/mop/ru/spell=114049
		[5394] = 30, -- 
	},
	["MONK"] = {
		-- // reviewed 2025/08/07
		[115310] = 180, -- https://www.wowhead.com/mop/ru/spell=115310
		[115080] = 90, -- https://www.wowhead.com/mop/ru/spell=115080
		[115230] = 180, -- https://www.wowhead.com/mop/ru/spell=115230
		[123904] = 180, -- https://www.wowhead.com/mop/ru/spell=123904
		[116849] = 120, -- https://www.wowhead.com/mop/ru/spell=116849
		[101643] = 45, -- https://www.wowhead.com/mop/ru/spell=101643
		[115078] = 15, -- https://www.wowhead.com/mop/ru/spell=115078
		[119381] = 45, -- https://www.wowhead.com/mop/ru/spell=119381
		[115176] = 180, -- https://www.wowhead.com/mop/ru/spell=115176
		[122470] = 90, -- https://www.wowhead.com/mop/ru/spell=122470
		[122783] = 90, -- https://www.wowhead.com/mop/ru/spell=122783
		[116844] = 45, -- https://www.wowhead.com/mop/ru/spell=116844
		[137562] = 120, -- https://www.wowhead.com/mop/ru/spell=137562
		[115288] = 60, -- https://www.wowhead.com/mop/ru/spell=115288
		[113656] = 25, -- https://www.wowhead.com/mop/ru/spell=113656
		[117368] = 60, -- https://www.wowhead.com/mop/ru/spell=117368
		[115203] = 180, -- https://www.wowhead.com/mop/ru/spell=115203
		[116841] = 30, -- https://www.wowhead.com/mop/ru/spell=116841
		[116705] = 15, -- https://www.wowhead.com/mop/ru/spell=116705
		[122278] = 90, -- https://www.wowhead.com/mop/ru/spell=122278
		[123986] = 30, -- https://www.wowhead.com/mop/ru/spell=1233986
		[116680] = 30, -- https://www.wowhead.com/mop/ru/spell=116660
		[101545] = 25, -- https://www.wowhead.com/mop/ru/spell=101545
		[122464] = 10, -- https://www.wowhead.com/mop/ru/spell=122464
	},
};

addonTable.Interrupts = {
	[47528] = true,		-- // Mind Freeze
	[2139] = true,		-- // Counterspell
	[15487] = true,		-- // Silence https://www.wowhead.com/cata/spell=15487
	[1766] = true,		-- // Kick
	[57994] = true,		-- // Wind Shear
	[6552] = true,		-- // Pummel
	[72] = true,		-- Shield Bash https://www.wowhead.com/cata/ru/spell=72
	[19647] = true,		-- // Spell Lock https://www.wowhead.com/cata/ru/spell=19647
	[34490] = true,		-- Silencing Shot https://www.wowhead.com/cata/spell=34490
	[47476] = true,		-- Strangulate
	[16979] = true,		-- Feral Charge - Bear
	[96231] = true,		-- Rebuke
};

addonTable.Trinkets = {
	[59752] = true,
	[7744] = true,
	[42292] = true,
};

-- // spells that reduce cooldown of other spells
do

	local BIG_REDUCTION = 4*1000*1000;

	local allHunterSpells = {};
	for spellId in pairs(addonTable.CDs["HUNTER"]) do
		table.insert(allHunterSpells, spellId);
	end

	local allMageSpells = {};
	for spellId in pairs(addonTable.CDs["MAGE"]) do
		table.insert(allMageSpells, spellId);
	end

	addonTable.Reductions = {
		[23989] = { -- Readiness https://www.wowhead.com/cata/spell=23989
			["reduction"] = BIG_REDUCTION,
			["spells"] = allHunterSpells,
		},
		[2139] = { -- Mage PvP two-piece bonus: reduce Counterspell's remaining cooldown by 4s after a successful interrupt
			["reduction"] = 4,
			["spells"] = { 2139 },
		},
		-- [45438] = { -- Ice Block https://www.wowhead.com/cata/ru/spell=45438
		-- 	["reduction"] = BIG_REDUCTION,
		-- 	["spells"] = {
		-- 		122,
		-- 		865,
		-- 		6131,
		-- 		10230,
		-- 		27088,
		-- 		42917,
		-- 	},
		-- },
		[11958] = { -- Cold Snap https://www.wowhead.com/cata/ru/spell=11958
			["reduction"] = BIG_REDUCTION,
			["spells"] = {
				45438,
				122,
				120,
			},
		},
		[14185] = { -- Preparation https://www.wowhead.com/cata/ru/spell=14185
			["reduction"] = BIG_REDUCTION,
			["spells"] = {
				51722,
				1766,
				2983,
				76577,
				1856,
				36554
			},
		},
	};

end