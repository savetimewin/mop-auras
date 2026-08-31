local E, L, C = select(2, ...):unpack()
local P = E.Party

local GetNumSpecializationsForClassID = C_SpecializationInfo and C_SpecializationInfo.GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpecialization = C_SpecializationInfo and C_SpecializationInfo.GetSpecialization or GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo or GetSpecializationInfo

local testClassValues = {}
local testSpecValues = {}
local defaultTestSpec = {}
local testRaceValues = {}
local defaultTestRace = {}

-- MoP race IDs used by OmniCD's RACIAL spell entries. Pandaren uses
-- faction-specific IDs 25/26 rather than the neutral character-creation ID.
local mopRaceInfo = {
	[1]  = { "Human", "Human" },
	[2]  = { "Orc", "Orc" },
	[3]  = { "Dwarf", "Dwarf" },
	[4]  = { "NightElf", "Night Elf" },
	[5]  = { "Scourge", "Undead" },
	[6]  = { "Tauren", "Tauren" },
	[7]  = { "Gnome", "Gnome" },
	[8]  = { "Troll", "Troll" },
	[9]  = { "Goblin", "Goblin" },
	[10] = { "BloodElf", "Blood Elf" },
	[11] = { "Draenei", "Draenei" },
	[22] = { "Worgen", "Worgen" },
	[25] = { "Pandaren", "Pandaren" },
	[26] = { "Pandaren", "Pandaren" },
}

local mopClassRaceIDs = {
	DEATHKNIGHT = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 22 },
	DRUID       = { 4, 6, 8, 22 },
	HUNTER      = { 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 22, 25, 26 },
	MAGE        = { 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 22, 25, 26 },
	MONK        = { 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 25, 26 },
	PALADIN     = { 1, 3, 6, 10, 11 },
	PRIEST      = { 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 22, 25, 26 },
	ROGUE       = { 1, 2, 3, 4, 5, 7, 8, 9, 10, 22, 25, 26 },
	SHAMAN      = { 2, 3, 6, 8, 9, 11, 25, 26 },
	WARLOCK     = { 1, 2, 3, 5, 7, 8, 9, 10, 22 },
	WARRIOR     = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 22, 25, 26 },
}

local function GetMoPRaceName(raceID)
	local raceInfo = mopRaceInfo[raceID]
	if not raceInfo then
		return tostring(raceID)
	end

	local name = LOCALIZED_RACE_NAMES_MALE and LOCALIZED_RACE_NAMES_MALE[raceInfo[1]] or raceInfo[2]
	if raceID == 25 then
		return format("%s (%s)", name, FACTION_ALLIANCE or "Alliance")
	elseif raceID == 26 then
		return format("%s (%s)", name, FACTION_HORDE or "Horde")
	end
	return name
end

if E.isMoP then
	for class, raceIDs in pairs(mopClassRaceIDs) do
		local races = {}
		testRaceValues[class] = races
		for _, raceID in ipairs(raceIDs) do
			races[raceID] = GetMoPRaceName(raceID)
		end
		defaultTestRace[class] = raceIDs[1]
	end
end

if GetNumSpecializationsForClassID and GetSpecializationInfoForClassID and GetSpecializationInfoByID then
	for classID = 1, MAX_CLASSES do
		local numSpecs = GetNumSpecializationsForClassID(classID) or 0
		for specIndex = 1, numSpecs do
			local specID, specName, _, icon = GetSpecializationInfoForClassID(classID, specIndex)
			if specID then
				local class = select(6, GetSpecializationInfoByID(specID))
				if class then
					testClassValues[class] = format(
						"|T%s:18|t %s",
						"Interface\\Icons\\ClassIcon_" .. class,
						LOCALIZED_CLASS_NAMES_MALE[class] or class
					)

					local specs = testSpecValues[class]
					if not specs then
						specs = {}
						testSpecValues[class] = specs
					end
					specs[specID] = format("|T%s:18|t %s", icon or 134400, specName or specID)
					defaultTestSpec[class] = defaultTestSpec[class] or specID
				end
			end
		end
	end
end

local function GetPlayerSpecID()
	if E.preCata then
		return P.userInfo and P.userInfo.raceID
	end
	local specIndex = GetSpecialization and GetSpecialization()
	return specIndex and GetSpecializationInfo and GetSpecializationInfo(specIndex)
end

local function EnsureTestSelection()
	local class = P.testClass
	if not class or not testSpecValues[class] then
		class = E.userClass
		P.testClass = class
	end

	local specs = testSpecValues[class]
	if not specs then
		return
	end

	if not P.testSpec or not specs[P.testSpec] then
		local playerSpec = class == E.userClass and GetPlayerSpecID()
		P.testSpec = playerSpec and specs[playerSpec] and playerSpec or defaultTestSpec[class]
	end

	local races = testRaceValues[class]
	if races and (not P.testRace or not races[P.testRace]) then
		local playerRace = class == E.userClass and E.userRaceID
		P.testRace = playerRace and races[playerRace] and playerRace or defaultTestRace[class]
	end
end

local getTestClass = function()
	EnsureTestSelection()
	return P.testClass
end
local setTestClass = function(_, value)
	P.testClass = value
	local specs = testSpecValues[value]
	local playerSpec = value == E.userClass and GetPlayerSpecID()
	P.testSpec = playerSpec and specs and specs[playerSpec] and playerSpec or defaultTestSpec[value]

	local races = testRaceValues[value]
	local playerRace = value == E.userClass and E.userRaceID
	P.testRace = playerRace and races and races[playerRace] and playerRace or defaultTestRace[value]
	P:RefreshTestPlayer()
end
local getTestSpec = function()
	EnsureTestSelection()
	return P.testSpec
end
local setTestSpec = function(_, value)
	P.testSpec = value
	P:RefreshTestPlayer()
end
local getTestRace = function()
	EnsureTestSelection()
	return P.testRace
end
local setTestRace = function(_, value)
	P.testRace = value
	P:RefreshTestPlayer()
end

P.options = {
	disabled = function(info)
		return info[2] and not E:GetModuleEnabled("Party")
	end,
	name = FRIENDLY,
	order = 20,
	type = "group",
	get = function(info) return E.profile.Party[ info[#info] ] end,
	set = function(info, value) E.profile.Party[ info[#info] ] = value end,
	args = {},
}

local getEnabled = function(info) return E.profile.Party.visibility[ info[2] ] end
local setEnabled = function(info, value)
	local key = info[2]
	E.profile.Party.visibility[key] = value
	if P.isInTestMode and P.testZone == key then
		P:Test()
	end
	P:Refresh()
end
local getTestMode = function(info) return P.testZone == info[2] and P.isInTestMode end
local setTestMode = function(info, state)
	EnsureTestSelection()
	P:Test(state and info[2])
end
local disableZone = function(info) return info[3] and not E.profile.Party.visibility[ info[2] ] or not E:GetModuleEnabled("Party") end
local getZoneName = function(info) return E.L_ALL_ZONE[ info[2] ] end

local testClassOption = {
	hidden = function() return next(testClassValues) == nil end,
	name = format("%s %s", L["Test"], CLASS),
	order = 3,
	type = "select",
	values = testClassValues,
	get = getTestClass,
	set = setTestClass,
}

local testSpecOption = {
	hidden = function() return next(testClassValues) == nil end,
	name = format("%s %s", L["Test"], SPECIALIZATION or "Specialization"),
	order = 4,
	type = "select",
	values = function()
		EnsureTestSelection()
		return testSpecValues[P.testClass] or {}
	end,
	get = getTestSpec,
	set = setTestSpec,
}

local testRaceOption = {
	hidden = function()
		EnsureTestSelection()
		return not E.isMoP or not testRaceValues[P.testClass]
	end,
	name = format("%s %s", L["Test"], RACE or "Race"),
	order = 5,
	type = "select",
	values = function()
		EnsureTestSelection()
		return testRaceValues[P.testClass] or {}
	end,
	get = getTestRace,
	set = setTestRace,
}

local configZone = {
	disabled = disableZone,
	name = getZoneName,
	type = "group",
	childGroups = "tab",
	args = {
		enabled = {
			disabled = false,
			name = ENABLE,
			desc = L["Enable CD tracking in the current zone"],
			order = 1,
			type = "toggle",
			get = getEnabled,
			set = setEnabled,
		},
		test = {
			name = L["Test"],
			desc = L["Toggle raid-style party frame and player spell bar for testing"],
			order = 2,
			type = "toggle",
			get = getTestMode,
			set = setTestMode,
		},
		testClass = testClassOption,
		testSpec = testSpecOption,
		testRace = testRaceOption,
	}
}

local noCfgZone = {
	disabled = disableZone,
	name = getZoneName,
	type = "group",
	childGroups = "tab",
	args = {
		enabled = {
			disabled = false,
			name = ENABLE,
			desc = L["Enable CD tracking in the current zone"],
			order = 1,
			type = "toggle",
			get = getEnabled,
			set = setEnabled,
		},
		test = {
			name = L["Test"],
			desc = L["Toggle raid-style party frame and player spell bar for testing"],
			order = 2,
			type = "toggle",
			get = getTestMode,
			set = setTestMode,
		},
		testClass = testClassOption,
		testSpec = testSpecOption,
		testRace = testRaceOption,
		lb1 = {
			name = "\n", order = 6, type = "description",
		},
		zoneSetting = {
			name = L["Use Zone Settings From:"],
			desc = L["Select the zone setting to use for this zone."],
			order = 7,
			type = "select",
			values = E.L_CFG_ZONE,
			get = function(info) return E.profile.Party[info[2] == "none" and "noneZoneSetting" or "scenarioZoneSetting"] end,
			set = function(info, value) E.profile.Party[info[2] == "none" and "noneZoneSetting" or "scenarioZoneSetting"] = value
				P:Refresh()
			end,
		},
	}
}

for key in pairs(E.L_CFG_ZONE) do
	P.options.args[key] = configZone
end
P.options.args.none = noCfgZone
P.options.args.scenario = noCfgZone

P.getIcons = function(info) return E.profile.Party[ info[2] ].icons[ info[#info] ] end
P.setIcons = function(info, value) E.profile.Party[ info[2] ].icons[ info[#info] ] = value P:Refresh() end

function P:IsCurrentZone(key)
	return E.db == E.profile.Party[key]
end

function P:ResetOption(key, tab, subtab)
	if subtab then
		E.profile.Party[key][tab][subtab] = E:DeepCopy(C.Party[key][tab][subtab])
	elseif tab then
		E.profile.Party[key][tab] = E:DeepCopy(C.Party[key][tab])
	elseif key then
		E.profile.Party[key] = E:DeepCopy(C.Party[key])
	else
		E.profile.Party = E:DeepCopy(C.Party)
	end
end

function P:RegisterSubcategory(optionName, optionTable)
	configZone.args[optionName] = optionTable
end
