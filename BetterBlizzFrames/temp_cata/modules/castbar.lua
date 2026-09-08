local L = BBF.L
local spellBars = {}
local castBarsCreated = false
local petCastbarCreated = false

local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local classicCastbarTexture = 137012
function BBF.UpdateClassicCastbarTexture(texture)
    classicCastbarTexture = BetterBlizzFramesDB.changeUnitFrameCastbarTexture and texture or 137012
    for _, spellbar in pairs(spellBars) do
        spellbar:SetStatusBarTexture(classicCastbarTexture)
    end
end

local CastingBarFrame = _G.PlayerCastingBarFrame or _G.CastingBarFrame

local function adjustCastBarBorder(castBar, border, adjust, shield, player, party, playerCb)
    -- Default values for width
    local defaultCastBarWidth = player or 150
    local defaultBorderWidth = 200
    local widthAdjustmentFactor = adjust / 50  -- Adjustment per unit width change

    -- Default values for height
    local defaultCastBarHeight = playerCb or 10
    local defaultBorderHeight = party and 55 or 56
    local heightAdjustmentFactor = 5.00  -- Average adjustment per unit height change

    -- Get current dimensions of the cast bar
    local currentCastBarWidth = castBar:GetWidth()
    local currentCastBarHeight = castBar:GetHeight()

    -- Calculate the new border width based on the current cast bar width
    local widthDifference = currentCastBarWidth - defaultCastBarWidth
    local borderWidth = defaultBorderWidth + widthDifference + (widthDifference * widthAdjustmentFactor)

    -- Calculate the new border height based on the current cast bar height
    local heightDifference = currentCastBarHeight - defaultCastBarHeight
    local borderHeight = defaultBorderHeight + (heightDifference * heightAdjustmentFactor)

    -- Apply the new border size
    border:ClearAllPoints()
    border:SetPoint("CENTER", castBar, "CENTER", shield and -4 or 0, 0)
    border:SetSize(borderWidth, shield and borderHeight-1 or borderHeight)
end

local function GetPartyMemberFrame(unitId, isPlayer)
    local frame = nil
    local isPartyMemberFrame = false

    -- Check CompactPartyFrameMember or CompactRaidFrame
    for i = 1, 5 do
        local compactFrame = _G["CompactPartyFrameMember"..i] or _G["CompactRaidFrame"..i] or _G["PartyMemberFrame"..i]
        if compactFrame and compactFrame:IsShown() and UnitExists(unitId) then
            if UnitIsUnit(compactFrame.displayedUnit, unitId) then
                frame = compactFrame
            elseif isPlayer and UnitIsUnit(compactFrame.displayedUnit, "player") then
                frame = compactFrame
            end
        end
    end

    -- Check traditional PartyFrame
    for i = 1, 5 do
        local partyFrame = PartyFrame and PartyFrame["MemberFrame"..i]
        if partyFrame and partyFrame:IsShown() and UnitExists(unitId) and UnitIsUnit(partyFrame.unit, unitId) then
            frame = partyFrame
            isPartyMemberFrame = true
        end
    end

    return frame, isPartyMemberFrame
end



local function UpdateCastTimer(self)
    local remainingTime
    if self.casting or self.reverseChanneling then
        -- For a cast, we calculate how much time is left until the cast completes
        remainingTime = self.maxValue - self.value
    elseif self.channeling then
        -- For a channel, the remaining time is directly related to the current value
        remainingTime = self.value
    end

    -- If the remaining time is zero or somehow negative, clear the timer
    if remainingTime then
        if remainingTime <= 0 then
            self.Timer:SetText("")
            return
        end
        self.Timer:SetFormattedText("%.1f", remainingTime)
    else
        self.Timer:SetText("")
    end
end

local hiddenFrame = CreateFrame("Frame")
hiddenFrame:Hide()

local function PositionCastTimer(timer, bar, settingPrefix, baseX, baseY, playerTimer)
    if not timer or not bar or not settingPrefix then return end

    local db = BetterBlizzFramesDB
    local xOffset = db[settingPrefix .. "TimerXPos"] or 0
    local yOffset = db[settingPrefix .. "TimerYPos"] or 0

    timer:ClearAllPoints()
    if playerTimer and db.playerCastBarTimerCentered then
        timer:SetPoint("BOTTOM", bar, "TOP", xOffset, 6 + yOffset)
    else
        timer:SetPoint("LEFT", bar, "RIGHT", baseX + xOffset, baseY + yOffset)
    end
end

local function PositionPartyCastTimer(timer, bar)
    PositionCastTimer(timer, bar, "partyCastBar", 5, 0)
end

local function PositionPetCastTimer(timer, bar)
    PositionCastTimer(timer, bar, "petCastBar", 3, 0)
end

local function CastBarSetUnit(spellbar, unitId, showTradeSkill, showShield)
    if CastingBarFrame_SetUnit then
        CastingBarFrame_SetUnit(spellbar, unitId, showTradeSkill, showShield)
    else
        spellbar:SetUnit(unitId, showTradeSkill, showShield)
    end
end

function BBF.UpdateCastbars()
    local numGroupMembers = GetNumGroupMembers()
    local firstPartyFrame, defaultPartyFrame = BBF.FindPartyFrame(1)

    if BetterBlizzFramesDB.showPartyCastbar or BetterBlizzFramesDB.partyCastBarTestMode then
        for i = 1, 5 do
            local spellbar = spellBars[i]
            if spellbar then
                CastBarSetUnit(spellbar, nil)
                spellbar:SetStatusBarTexture(classicCastbarTexture)
            end
        end
        if firstPartyFrame and firstPartyFrame:IsShown() and numGroupMembers <= 5 then
            if defaultPartyFrame then
                numGroupMembers = numGroupMembers - 1
            end
            for i = 1, 5 do
                local spellbar = spellBars[i]
                if spellbar then
                    if not BetterBlizzFramesDB.partyCastBarTestMode then
                        CastBarSetUnit(spellbar, nil)
                    end
                    spellbar:SetStatusBarTexture(classicCastbarTexture)
                    --spellbar:SetParent(UIParent)
                    spellbar:SetIgnoreParentAlpha(true)
                    spellbar:SetScale(BetterBlizzFramesDB.partyCastBarScale)
                    spellbar:SetWidth(BetterBlizzFramesDB.partyCastBarWidth)
                    spellbar:SetHeight(BetterBlizzFramesDB.partyCastBarHeight)
                    spellbar.Icon:SetDrawLayer("OVERLAY")
                    spellbar.Text:ClearAllPoints()
                    spellbar.Text:SetPoint("CENTER", spellbar, "CENTER", 0, 0)
                    adjustCastBarBorder(spellbar, spellbar.Border, 15, nil, nil, true)
                    adjustCastBarBorder(spellbar, spellbar.Flash, 15, nil, nil, true)
                    adjustCastBarBorder(spellbar, spellbar.BorderShield, 12, true, nil, true)

                    spellbar.Border:SetDrawLayer("OVERLAY", 6)
                    spellbar.BorderShield:SetDrawLayer("OVERLAY", 7)

                    spellbar.Text:SetAlpha(BetterBlizzFramesDB.partyCastbarShowText and 1 or 0)
                    spellbar.Border:SetAlpha(BetterBlizzFramesDB.partyCastbarShowBorder and 1 or 0)
                    spellbar.BorderShield:SetAlpha(BetterBlizzFramesDB.partyCastbarShowBorder and 1 or 0)
                    spellbar.Flash:SetParent(BetterBlizzFramesDB.partyCastbarShowBorder and spellbar or hiddenFrame)

                    if not BetterBlizzFramesDB.showPartyCastBarIcon then
                        spellbar.Icon:SetAlpha(0)
                    else
                        spellbar.Icon:ClearAllPoints()
                        spellbar.Icon:SetPoint("RIGHT", spellbar, "LEFT", -4 + BetterBlizzFramesDB.partyCastbarIconXPos, BetterBlizzFramesDB.partyCastbarIconYPos - 1)
                        spellbar.Icon:SetScale(BetterBlizzFramesDB.partyCastBarIconScale)
                        spellbar.Icon:SetAlpha(1)
                    end

                    local partyFrame = BBF.FindPartyFrame(i)

                    if partyFrame and partyFrame:IsShown() and partyFrame:IsVisible() then
                        local xPos = BetterBlizzFramesDB.partyCastBarXPos + 10
                        local yPos = BetterBlizzFramesDB.partyCastBarYPos
                        if defaultPartyFrame then
                            xPos = xPos + 15
                            yPos = yPos - 20
                        end

                        local unitId = partyFrame.displayedUnit or partyFrame.unit

                        if (unitId and unitId:match("^partypet%d$")) then
                            CastBarSetUnit(spellbar, nil)
                        elseif UnitIsUnit(unitId, "player") and (not BetterBlizzFramesDB.partyCastbarSelf and not BetterBlizzFramesDB.partyCastBarTestMode) then
                            CastBarSetUnit(spellbar, nil)
                        else
                            CastBarSetUnit(spellbar, unitId, true, true)
                        end

                        spellbar:ClearAllPoints()
                        spellbar:SetPoint("CENTER", partyFrame, "CENTER", xPos, yPos + 3)
                    else
                        CastBarSetUnit(spellbar, nil)
                    end
                else
                    BBF.CreateCastbars()
                end
            end
        else
            for i = 1, 5 do
                local spellbar = spellBars[i]
                if spellbar then
                    CastBarSetUnit(spellbar, nil)
                end
            end
        end
    else
        for i = 1, 5 do
            local spellbar = spellBars[i]
            if spellbar then
                CastBarSetUnit(spellbar, nil)
            end
        end
    end
    BBF.DarkModeCastbars()
end


function BBF.UpdatePetCastbar()
    local petSpellBar = spellBars["pet"]
    if petSpellBar then
        local xPos = BetterBlizzFramesDB.petCastBarXPos
        local yPos = BetterBlizzFramesDB.petCastBarYPos
        local castbarScale = BetterBlizzFramesDB.petCastBarScale
        local iconScale = BetterBlizzFramesDB.petCastBarIconScale
        local width = BetterBlizzFramesDB.petCastBarWidth
        local height = BetterBlizzFramesDB.petCastBarHeight

        --petSpellBar:SetParent(UIParent)
        petSpellBar:SetIgnoreParentAlpha(true)
        petSpellBar:SetStatusBarTexture(classicCastbarTexture)
        if not BetterBlizzFramesDB.showPetCastBarIcon then
            petSpellBar.Icon:SetAlpha(0)
            petSpellBar.BorderShield:SetAlpha(0)
        else
            petSpellBar.Icon:ClearAllPoints()
            petSpellBar.Icon:SetPoint("RIGHT", petSpellBar, "LEFT", -4, 0)
            petSpellBar.Icon:SetScale(iconScale)
            petSpellBar.Icon:SetAlpha(1)
            -- petSpellBar.BorderShield:ClearAllPoints()
            -- petSpellBar.BorderShield:SetPoint("RIGHT", petSpellBar, "LEFT", -1 + 0, -7 + 0)
            -- petSpellBar.BorderShield:SetScale(iconScale)
            -- petSpellBar.BorderShield:SetAlpha(1)
        end
        BBF.DarkModeCastbars()
        petSpellBar:SetScale(castbarScale)
        petSpellBar:SetWidth(width)
        petSpellBar:SetHeight(height)
        petSpellBar.Text:SetAlpha(BetterBlizzFramesDB.petCastBarShowText and 1 or 0)
        petSpellBar.Border:SetAlpha(BetterBlizzFramesDB.petCastBarShowBorder and 1 or 0)
        petSpellBar.BorderShield:SetAlpha(BetterBlizzFramesDB.petCastBarShowBorder and 1 or 0)
        petSpellBar.Flash:SetParent(BetterBlizzFramesDB.petCastBarShowBorder and petSpellBar or hiddenFrame)

        adjustCastBarBorder(petSpellBar, petSpellBar.Border, 15, nil, nil, true)
        adjustCastBarBorder(petSpellBar, petSpellBar.Flash, 15, nil, nil, true)
        adjustCastBarBorder(petSpellBar, petSpellBar.BorderShield, 12, true, nil, true)

        petSpellBar.Border:SetDrawLayer("OVERLAY", 6)
        petSpellBar.BorderShield:SetDrawLayer("OVERLAY", 7)

        local petFrame = PetFrame -- Assuming PetFrame is the frame you want to attach to
        if petFrame then
            local petDetachCastbar = BetterBlizzFramesDB.petDetachCastbar
            petSpellBar:ClearAllPoints()
            if petDetachCastbar then
                petSpellBar:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
            else
                petSpellBar:SetPoint("CENTER", petFrame, "CENTER", xPos + 4, yPos - 27)
            end
            CastBarSetUnit(petSpellBar, "pet", true, true)
        else
            CastBarSetUnit(petSpellBar, nil)
        end
    else
        BBF.CreateCastbars()
    end
end


function BBF.CreateCastbars()
    if not castBarsCreated and (BetterBlizzFramesDB.showPartyCastbar or BetterBlizzFramesDB.partyCastBarTestMode) then
        for i = 1, 5 do
            local spellbar = CreateFrame("StatusBar", "Party"..i.."SpellBar", UIParent, "SmallCastingBarFrameTemplate")
            spellbar:SetScale(1)
            spellbar:SetFrameStrata("MEDIUM")
            spellbar:SetFrameLevel(9900)

            CastBarSetUnit(spellbar, "party"..i, true, true)
            spellbar:SetStatusBarTexture(classicCastbarTexture)
            spellbar.Text:SetFontObject("SystemFont_Shadow_Med1_Outline")
            spellbar.Icon:ClearAllPoints()
            spellbar.Icon:SetPoint("RIGHT", spellbar, "LEFT", -4, -1)
            spellbar.Icon:SetSize(22, 22)
            spellbar.Icon:SetScale(BetterBlizzFramesDB.partyCastBarIconScale)
            spellbar:SetScale(BetterBlizzFramesDB.partyCastBarScale)
            spellbar:SetWidth(BetterBlizzFramesDB.partyCastBarWidth)
            spellbar:SetHeight(BetterBlizzFramesDB.partyCastBarHeight)

            spellbar.Text:SetAlpha(BetterBlizzFramesDB.partyCastbarShowText and 1 or 0)
            spellbar.Border:SetAlpha(BetterBlizzFramesDB.partyCastbarShowBorder and 1 or 0)
            spellbar.BorderShield:SetAlpha(BetterBlizzFramesDB.partyCastbarShowBorder and 1 or 0)
            spellbar.Flash:SetParent(BetterBlizzFramesDB.partyCastbarShowBorder and spellbar or hiddenFrame)

            spellbar.Timer = spellbar:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Med1_Outline")
            PositionPartyCastTimer(spellbar.Timer, spellbar)
            spellbar.Timer:SetTextColor(1, 1, 1, 1)

            spellbar.FakeTimer = spellbar:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Med1_Outline")
            PositionPartyCastTimer(spellbar.FakeTimer, spellbar)
            spellbar.FakeTimer:SetTextColor(1, 1, 1, 1)
            spellbar.FakeTimer:SetText("1.8")
            spellbar.FakeTimer:Hide()

            if BetterBlizzFramesDB.partyCastBarTimer then
                spellbar:HookScript("OnUpdate", function(self, elapsed)
                    UpdateCastTimer(self, elapsed)
                end)
            end

            spellbar:HookScript("OnEvent", function(self)
                self:SetStatusBarTexture(classicCastbarTexture)
            end)

            spellBars[i] = spellbar
        end
        BBF.UpdateCastbars()
        BBF.DarkModeCastbars()
        castBarsCreated = true
    end
    if not petCastbarCreated and (BetterBlizzFramesDB.petCastbar or BetterBlizzFramesDB.petCastBarTestMode) then
        local petSpellBar = CreateFrame("StatusBar", "PetSpellBar", UIParent, "SmallCastingBarFrameTemplate")
        petSpellBar:SetScale(1)
        petSpellBar:SetFrameStrata("MEDIUM")
        petSpellBar:SetFrameLevel(9900)

        CastBarSetUnit(petSpellBar, "pet", true, true)
        petSpellBar:SetStatusBarTexture(classicCastbarTexture)
        petSpellBar.Text:SetFontObject("SystemFont_Shadow_Med1_Outline")
        petSpellBar.Icon:ClearAllPoints()
        petSpellBar.Icon:SetPoint("RIGHT", petSpellBar, "LEFT", -4, 0)
        petSpellBar.Icon:SetSize(22, 22)
        petSpellBar.Icon:SetScale(BetterBlizzFramesDB.petCastBarIconScale)
        petSpellBar.Icon:SetDrawLayer("OVERLAY", 7)
        petSpellBar:SetScale(BetterBlizzFramesDB.petCastBarScale)
        petSpellBar:SetWidth(BetterBlizzFramesDB.petCastBarWidth)
        petSpellBar:SetHeight(BetterBlizzFramesDB.petCastBarHeight)
        Mixin(petSpellBar, SmoothStatusBarMixin)
        petSpellBar:SetMinMaxSmoothedValue(0, 100)

        petSpellBar.Timer = petSpellBar:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Med1_Outline")
        PositionPetCastTimer(petSpellBar.Timer, petSpellBar)
        petSpellBar.Timer:SetTextColor(1, 1, 1, 1)

        petSpellBar.FakeTimer = petSpellBar:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Med1_Outline")
        PositionPetCastTimer(petSpellBar.FakeTimer, petSpellBar)
        petSpellBar.FakeTimer:SetTextColor(1, 1, 1, 1)
        petSpellBar.FakeTimer:SetText("1.8")
        petSpellBar.FakeTimer:Hide()

        if BetterBlizzFramesDB.petCastBarTimer then
            petSpellBar:HookScript("OnUpdate", function(self, elapsed)
                UpdateCastTimer(self, elapsed)
            end)
        end

        petSpellBar:HookScript("OnEvent", function()
            petSpellBar:SetStatusBarTexture(classicCastbarTexture)
        end)

        petSpellBar:Hide()

        spellBars["pet"] = petSpellBar
        petCastbarCreated = true
        BBF.UpdatePetCastbar()
        BBF.DarkModeCastbars()
    end
end

function BBF.partyCastBarTestMode()
    BBF.CreateCastbars()
    BBF.UpdateCastbars()

    for i = 1, 5 do
        local spellbar = spellBars[i]
        if spellbar and BetterBlizzFramesDB.partyCastBarTestMode then
            --spellbar:SetParent(UIParent)
            spellbar:SetIgnoreParentAlpha(true)
            spellbar:Show()
            spellbar:SetAlpha(1)

            local minValue, maxValue = 0, 100
            local duration = 2 -- in seconds
            local stepsPerSecond = 50 -- adjust for smoothness
            local totalSteps = duration * stepsPerSecond
            local stepValue = (maxValue - minValue) / totalSteps
            local currentValue = minValue

            spellbar:SetMinMaxValues(minValue, maxValue)
            spellbar:SetValue(currentValue)
            spellbar.Text:SetText(L["Label_Frostbolt"])

            -- Cancel any existing timer before creating a new one
            if spellbar.tickTimer then
                spellbar.tickTimer:Cancel()
            end

            -- Create a timer for smooth cast progress
            spellbar.tickTimer = C_Timer.NewTicker(1 / stepsPerSecond, function()
                currentValue = currentValue + stepValue
                if currentValue >= maxValue then
                    currentValue = minValue
                end
                spellbar:SetValue(currentValue)
            end)

            if not BetterBlizzFramesDB.showPartyCastBarIcon then
                spellbar.Icon:Hide()
            else
                spellbar.Icon:Show()
                spellbar.Icon:SetTexture(GetSpellTexture(116))
            end
            if BetterBlizzFramesDB.partyCastBarTimer then
                if not spellbar.FakeTimer then
                    spellbar.FakeTimer = spellbar:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Med1_Outline")
                    PositionPartyCastTimer(spellbar.FakeTimer, spellbar)
                    spellbar.FakeTimer:SetTextColor(1, 1, 1, 1)
                end
                spellbar.FakeTimer:Show()
            else
                if spellbar.FakeTimer then
                    spellbar.FakeTimer:Hide()
                end
            end
            spellbar.Flash:SetAlpha(0)
        elseif spellbar then
            -- Stop the timer when exiting test mode
            if spellbar.tickTimer then
                spellbar.tickTimer:Cancel()
                spellbar.tickTimer = nil
            end
            spellbar.Flash:SetAlpha(1)
            spellbar:SetAlpha(0)
            if spellbar.FakeTimer then
                spellbar.FakeTimer:Hide()
            end
        end
        --spellbar:StopFinishAnims()
    end
end


function BBF.petCastBarTestMode()
    BBF.CreateCastbars()
    BBF.UpdatePetCastbar()
    if BetterBlizzFramesDB.petCastBarTestMode then
        spellBars["pet"]:Show()
        spellBars["pet"]:SetAlpha(1)
        spellBars["pet"]:SetSmoothedValue(math.random(100))

        -- Create a timer for random ticks
        if not spellBars["pet"].tickTimer then
            spellBars["pet"].tickTimer = C_Timer.NewTicker(0.7, function()
                spellBars["pet"]:SetSmoothedValue(math.random(100))
            end)
        end
        if not BetterBlizzFramesDB.showPetCastBarIcon then
            spellBars["pet"].Icon:Hide()
        else
            spellBars["pet"].Icon:Show()
            spellBars["pet"].Icon:SetTexture(GetSpellTexture(6358));
        end
        spellBars["pet"].Text:SetText(L["Label_Seduction"])
        if BetterBlizzFramesDB.petCastBarTimer then
            spellBars["pet"].FakeTimer:Show()
        else
            spellBars["pet"].FakeTimer:Hide()
        end
    else
        -- Stop the timer when exiting test mode
        if spellBars and spellBars["pet"] then
            if spellBars["pet"].tickTimer then
                spellBars["pet"].tickTimer:Cancel()
                spellBars["pet"].tickTimer = nil
            end
            spellBars["pet"]:SetAlpha(0)
            spellBars["pet"].FakeTimer:Hide()
        end
    end
end




local CastBarFrame = CreateFrame("Frame")
CastBarFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
CastBarFrame:SetScript("OnEvent", function(self, event, ...)
    if BetterBlizzFramesDB.showPartyCastbar then
        BBF.UpdateCastbars()
        BBF.CreateCastbars()
    end
end)



local petUpdate = CreateFrame("Frame")
petUpdate:RegisterEvent("UNIT_PET")
petUpdate:SetScript("OnEvent", function(self, event, ...)
    if BetterBlizzFramesDB.petCastbar then
        BBF.UpdatePetCastbar()
    end
end)


-- Hook into the OnUpdate, OnShow, and OnHide scripts for the spell bar
local function CastBarTimer(bar)
    local castBarSetting = nil
    local settingPrefix
    local baseX, baseY
    local playerTimer
    if bar == CastingBarFrame then
        castBarSetting = BetterBlizzFramesDB.playerCastBarTimer
        settingPrefix = "playerCastBar"
        baseX, baseY = 3, 2
        playerTimer = true
    elseif bar == TargetFrameSpellBar then
        castBarSetting = BetterBlizzFramesDB.targetCastBarTimer
        settingPrefix = "targetCastBar"
        baseX, baseY = 3, -1
    elseif bar == FocusFrameSpellBar then
        castBarSetting = BetterBlizzFramesDB.focusCastBarTimer
        settingPrefix = "focusCastBar"
        baseX, baseY = 3, -1
    end
    if castBarSetting and not bar.Timer then
        bar.Timer = bar:CreateFontString(nil, "OVERLAY")
        bar.Timer:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    end
    if not bar.Timer then return end
    PositionCastTimer(bar.Timer, bar, settingPrefix, baseX, baseY, playerTimer)
    if not castBarSetting then
        bar.Timer:Hide()
    else
        bar.Timer:Show()
    end
    if bar.isHooked then return end
    bar:HookScript("OnUpdate", function(self, elapsed)
        UpdateCastTimer(self, elapsed)
    end)
    bar.isHooked = true
end

function BBF.CastBarTimerCaller()
    CastBarTimer(CastingBarFrame)
    CastBarTimer(TargetFrameSpellBar)
    if FocusFrameSpellBar then
        CastBarTimer(FocusFrameSpellBar)
    end
end

function BBF.UpdateCastBarTimerPositions()
    BBF.CastBarTimerCaller()

    for i = 1, 5 do
        local spellbar = spellBars[i]
        if spellbar then
            PositionPartyCastTimer(spellbar.Timer, spellbar)
            PositionPartyCastTimer(spellbar.FakeTimer, spellbar)
        end
    end

    local petSpellBar = spellBars["pet"]
    if petSpellBar then
        PositionPetCastTimer(petSpellBar.Timer, petSpellBar)
        PositionPetCastTimer(petSpellBar.FakeTimer, petSpellBar)
    end
end


local targetSpellBarTexture = TargetFrameSpellBar:GetStatusBarTexture()
local focusSpellBarTexture = FocusFrameSpellBar and FocusFrameSpellBar:GetStatusBarTexture()
local targetCastbarEdgeHooked
local focusCastbarEdgeHooked

local targetLastUpdate = 0
local focusLastUpdate = 0
local updateInterval = 0.05

local highlightStartTime = BetterBlizzFramesDB.castBarInterruptHighlighterStartTime
local highlightEndTime = BetterBlizzFramesDB.castBarInterruptHighlighterEndTime
local edgeColor = BetterBlizzFramesDB.castBarInterruptHighlighterInterruptRGB
local middleColor = BetterBlizzFramesDB.castBarInterruptHighlighterDontInterruptRGB
local colorMiddle = BetterBlizzFramesDB.castBarInterruptHighlighterColorDontInterrupt
local castBarNoInterruptColor = BetterBlizzFramesDB.castBarNoInterruptColor
local castBarDelayedInterruptColor = BetterBlizzFramesDB.castBarDelayedInterruptColor
local castBarRecolorInterrupt = BetterBlizzFramesDB.castBarRecolorInterrupt
local castBarInterruptHighlighter = BetterBlizzFramesDB.castBarInterruptHighlighter
local targetCastbarEdgeHighlight = BetterBlizzFramesDB.targetCastbarEdgeHighlight
local focusCastbarEdgeHighlight = BetterBlizzFramesDB.focusCastbarEdgeHighlight

local interruptList = {
    [1766] = true,  -- Kick (Rogue)
    [2139] = true,  -- Counterspell (Mage)
    [6552] = true,  -- Pummel (Warrior)
    [19647] = true, -- Spell Lock (Warlock)
    [47528] = true, -- Mind Freeze (Death Knight)
    [57994] = true, -- Wind Shear (Shaman)
    [91802] = true, -- Shambling Rush (Death Knight)
    [96231] = true, -- Rebuke (Paladin)
    [106839] = true,-- Skull Bash (Feral)
    [115781] = true,-- Optical Blast (Warlock)
    [116705] = true,-- Spear Hand Strike (Monk)
    [132409] = true,-- Spell Lock (Warlock)
    [119910] = true,-- Spell Lock (Warlock Pet)
    [147362] = true,-- Countershot (Hunter)
    [34490] = true,-- Silencing Shot (Hunter)
    [171138] = true,-- Shadow Lock (Warlock)
    [183752] = true,-- Consume Magic (Demon Hunter)
    [187707] = true,-- Muzzle (Hunter)
    [212619] = true,-- Call Felhunter (Warlock)
    [231665] = true,-- Avengers Shield (Paladin)
    [351338] = true,-- Quell (Evoker)
    [97547]  = true,-- Solar Beam
}

local interruptSpellIDs = {}
function BBF.InitializeInterruptSpellID()
    interruptSpellIDs = {}
    for spellID in pairs(interruptList) do
        if IsSpellKnownOrOverridesKnown(spellID) then
            table.insert(interruptSpellIDs, spellID)
        end
    end
end

local recheckInterruptListener = CreateFrame("Frame")
local function OnEvent(self, event, unit, _, spellID)
    if spellID == 691 or spellID == 108503 then
        BBF.InitializeInterruptSpellID()
    end
end
recheckInterruptListener:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
recheckInterruptListener:SetScript("OnEvent", OnEvent)

local function resetCastbarColor(castbar, channeling)
    if not channeling then
        castbar:SetStatusBarColor(1, 0.702, 0)
    else
        castbar:SetStatusBarColor(1, 0.702, 0)
    end
end

function BBF.CastbarRecolorWidgets()
    if BetterBlizzFramesDB.castBarInterruptHighlighter or BetterBlizzFramesDB.castBarDelayedInterruptColor then
        highlightStartTime = BetterBlizzFramesDB.castBarInterruptHighlighterStartTime
        highlightEndTime = BetterBlizzFramesDB.castBarInterruptHighlighterEndTime
        edgeColor = BetterBlizzFramesDB.castBarInterruptHighlighterInterruptRGB
        middleColor = BetterBlizzFramesDB.castBarInterruptHighlighterDontInterruptRGB
        colorMiddle = BetterBlizzFramesDB.castBarInterruptHighlighterColorDontInterrupt
        castBarNoInterruptColor = BetterBlizzFramesDB.castBarNoInterruptColor
        castBarDelayedInterruptColor = BetterBlizzFramesDB.castBarDelayedInterruptColor
        castBarRecolorInterrupt = BetterBlizzFramesDB.castBarRecolorInterrupt
        castBarInterruptHighlighter = BetterBlizzFramesDB.castBarInterruptHighlighter
        targetCastbarEdgeHighlight = BetterBlizzFramesDB.targetCastbarEdgeHighlight and castBarInterruptHighlighter
        focusCastbarEdgeHighlight = BetterBlizzFramesDB.focusCastbarEdgeHighlight and castBarInterruptHighlighter

        if (targetCastbarEdgeHighlight or castBarRecolorInterrupt) and not targetCastbarEdgeHooked then
            BBF.InitializeInterruptSpellID()

            TargetFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                -- targetLastUpdate = targetLastUpdate + elapsed
                -- if targetLastUpdate < updateInterval then
                --     return
                -- end
                -- targetLastUpdate = 0

                if UnitCanAttack(TargetFrame.unit, "player") then
                    local channeling
                    local name, _, _, startTime, endTime, _, _, notInterruptible, spellId = UnitCastingInfo("target")
                    if not name then
                        name, _, _, startTime, endTime, _, notInterruptible, spellId = UnitChannelInfo("target")
                        channeling = true
                    end

                    if name and not notInterruptible then
                        if castBarRecolorInterrupt then
                            for _, interruptSpellID in ipairs(interruptSpellIDs) do
                                local start, duration = GetSpellCooldown(interruptSpellID)
                                local cooldownRemaining = start + duration - GetTime()
                                local castRemaining = (endTime/1000) - GetTime()

                                if cooldownRemaining > 0 and cooldownRemaining > castRemaining then
                                    targetSpellBarTexture:SetDesaturated(true)
                                    self:SetStatusBarColor(unpack(castBarNoInterruptColor))
                                    self.Spark:SetVertexColor(unpack(castBarNoInterruptColor))
                                elseif cooldownRemaining > 0 and cooldownRemaining <= castRemaining then
                                    targetSpellBarTexture:SetDesaturated(true)
                                    self:SetStatusBarColor(unpack(castBarDelayedInterruptColor))
                                    self.Spark:SetVertexColor(unpack(castBarDelayedInterruptColor))
                                else
                                    if targetCastbarEdgeHighlight then
                                        local currentTime = GetTime()  -- Current time in seconds
                                        local startTimeSeconds = startTime / 1000  -- Convert start time to seconds
                                        local endTimeSeconds = endTime / 1000
                                        local elapsed = currentTime - startTimeSeconds  -- Time elapsed since the start of the cast in seconds
                                        local timeRemaining = endTimeSeconds - currentTime  -- Time remaining until the cast ends in seconds

                                        if (elapsed <= highlightStartTime) or (timeRemaining <= highlightEndTime) then
                                            targetSpellBarTexture:SetDesaturated(true)
                                            self:SetStatusBarColor(unpack(edgeColor))
                                            self.Spark:SetVertexColor(unpack(edgeColor))
                                        else
                                            if colorMiddle then
                                                targetSpellBarTexture:SetDesaturated(true)
                                                self:SetStatusBarColor(unpack(middleColor))
                                            else
                                                targetSpellBarTexture:SetDesaturated(false)
                                                resetCastbarColor(self, channeling)
                                            end
                                            self.Spark:SetVertexColor(1,1,1)
                                        end
                                    else
                                        targetSpellBarTexture:SetDesaturated(false)
                                        resetCastbarColor(self, channeling)
                                        self.Spark:SetVertexColor(1,1,1)
                                    end
                                end
                            end
                        elseif targetCastbarEdgeHighlight then
                            local currentTime = GetTime()  -- Current time in seconds
                            local startTimeSeconds = startTime / 1000  -- Convert start time to seconds
                            local endTimeSeconds = endTime / 1000
                            local elapsed = currentTime - startTimeSeconds  -- Time elapsed since the start of the cast in seconds
                            local timeRemaining = endTimeSeconds - currentTime  -- Time remaining until the cast ends in seconds

                            if (elapsed <= highlightStartTime) or (timeRemaining <= highlightEndTime) then
                                targetSpellBarTexture:SetDesaturated(true)
                                self:SetStatusBarColor(unpack(edgeColor))
                                self.Spark:SetVertexColor(unpack(edgeColor))
                            else
                                if colorMiddle then
                                    targetSpellBarTexture:SetDesaturated(true)
                                    self:SetStatusBarColor(unpack(middleColor))
                                else
                                    targetSpellBarTexture:SetDesaturated(false)
                                    resetCastbarColor(self, channeling)
                                end
                                self.Spark:SetVertexColor(1,1,1)
                            end
                        else
                            targetSpellBarTexture:SetDesaturated(false)
                            resetCastbarColor(self, channeling)
                            self.Spark:SetVertexColor(1,1,1)
                        end
                    else
                        targetSpellBarTexture:SetDesaturated(false)
                        resetCastbarColor(self, channeling)
                        self.Spark:SetVertexColor(1,1,1)
                    end
                else
                    targetSpellBarTexture:SetDesaturated(false)
                    local channeling = UnitChannelInfo("target")
                    resetCastbarColor(self, channeling)
                    self.Spark:SetVertexColor(1,1,1)
                end
            end)
            targetCastbarEdgeHooked = true
        end

        if (focusCastbarEdgeHighlight or castBarRecolorInterrupt) and not focusCastbarEdgeHooked and FocusFrameSpellBar then
            FocusFrameSpellBar:HookScript("OnUpdate", function(self, elapsed)
                -- focusLastUpdate = focusLastUpdate + elapsed
                -- if focusLastUpdate < updateInterval then
                --     return
                -- end
                -- focusLastUpdate = 0
                if UnitCanAttack(FocusFrame.unit, "player") then
                    local channeling
                    local name, _, _, startTime, endTime, _, _, notInterruptible, spellId = UnitCastingInfo("focus")
                    if not name then
                        name, _, _, startTime, endTime, _, notInterruptible, spellId = UnitChannelInfo("focus")
                        channeling = true
                    end

                    if name then--and not notInterruptible then
                        if castBarRecolorInterrupt then
                            for _, interruptSpellID in ipairs(interruptSpellIDs) do
                                local start, duration = GetSpellCooldown(interruptSpellID)
                                local cooldownRemaining = start + duration - GetTime()
                                local castRemaining = (endTime/1000) - GetTime()

                                if cooldownRemaining > 0 and cooldownRemaining > castRemaining then
                                    focusSpellBarTexture:SetDesaturated(true)
                                    self:SetStatusBarColor(unpack(castBarNoInterruptColor))
                                    self.Spark:SetVertexColor(unpack(castBarNoInterruptColor))
                                elseif cooldownRemaining > 0 and cooldownRemaining <= castRemaining then
                                    focusSpellBarTexture:SetDesaturated(true)
                                    self:SetStatusBarColor(unpack(castBarDelayedInterruptColor))
                                    self.Spark:SetVertexColor(unpack(castBarDelayedInterruptColor))
                                else
                                    if focusCastbarEdgeHighlight then
                                        local currentTime = GetTime()  -- Current time in seconds
                                        local startTimeSeconds = startTime / 1000  -- Convert start time to seconds
                                        local endTimeSeconds = endTime / 1000
                                        local elapsed = currentTime - startTimeSeconds  -- Time elapsed since the start of the cast in seconds
                                        local timeRemaining = endTimeSeconds - currentTime  -- Time remaining until the cast ends in seconds

                                        if (elapsed <= highlightStartTime) or (timeRemaining <= highlightEndTime) then
                                            focusSpellBarTexture:SetDesaturated(true)
                                            self:SetStatusBarColor(unpack(edgeColor))
                                            self.Spark:SetVertexColor(unpack(edgeColor))
                                        else
                                            if colorMiddle then
                                                focusSpellBarTexture:SetDesaturated(true)
                                                self:SetStatusBarColor(unpack(middleColor))
                                            else
                                                focusSpellBarTexture:SetDesaturated(false)
                                                if not channeling then
                                                    resetCastbarColor(self, channeling)
                                                else
                                                    resetCastbarColor(self, channeling)
                                                end
                                            end
                                            self.Spark:SetVertexColor(1,1,1)
                                        end
                                    else
                                        focusSpellBarTexture:SetDesaturated(false)
                                        resetCastbarColor(self, channeling)
                                        self.Spark:SetVertexColor(1,1,1)
                                    end
                                end
                            end
                        elseif focusCastbarEdgeHighlight then
                            local currentTime = GetTime()  -- Current time in seconds
                            local startTimeSeconds = startTime / 1000  -- Convert start time to seconds
                            local endTimeSeconds = endTime / 1000
                            local elapsed = currentTime - startTimeSeconds  -- Time elapsed since the start of the cast in seconds
                            local timeRemaining = endTimeSeconds - currentTime  -- Time remaining until the cast ends in seconds

                            if (elapsed <= highlightStartTime) or (timeRemaining <= highlightEndTime) then
                                focusSpellBarTexture:SetDesaturated(true)
                                self:SetStatusBarColor(unpack(edgeColor))
                                self.Spark:SetVertexColor(unpack(edgeColor))
                            else
                                if colorMiddle then
                                    focusSpellBarTexture:SetDesaturated(true)
                                    self:SetStatusBarColor(unpack(middleColor))
                                else
                                    focusSpellBarTexture:SetDesaturated(false)
                                    resetCastbarColor(self, channeling)
                                end
                                self.Spark:SetVertexColor(1,1,1)
                            end
                        else
                            focusSpellBarTexture:SetDesaturated(false)
                            resetCastbarColor(self, channeling)
                            self.Spark:SetVertexColor(1,1,1)
                        end
                    else
                        focusSpellBarTexture:SetDesaturated(false)
                        resetCastbarColor(self, channeling)
                        self.Spark:SetVertexColor(1,1,1)
                    end
                else
                    local channeling = UnitChannelInfo("target")
                    focusSpellBarTexture:SetDesaturated(false)
                    resetCastbarColor(self, channeling)
                    self.Spark:SetVertexColor(1,1,1)
                end
            end)
            focusCastbarEdgeHooked = true
        end
    end
end

local CastingBarFrameHooked = false
function BBF.ShowPlayerCastBarIcon()
    if CastingBarFrame then
        if BetterBlizzFramesDB.playerCastBarShowIcon then
            CastingBarFrame.Icon:Show()
            --CastingBarFrame.showShield = true
        else
            CastingBarFrame.Icon:Hide()
            --CastingBarFrame.showShield = false
        end
        BBF.DarkModeCastbars()
    else
        C_Timer.After(1, BBF.ShowPlayerCastBarIcon)
    end
end

local function UpdateSparkPosition(castBar)
    local val = castBar:GetValue()
    local minVal, maxVal = castBar:GetMinMaxValues()
    --local progressPercent = castBar.value / castBar.maxValue
    local progressPercent = val / maxVal
    local newX = castBar:GetWidth() * progressPercent
    castBar.Spark:ClearAllPoints()
    castBar.Spark:SetPoint("CENTER", castBar, "LEFT", newX, -1.5)
end

local function CastingBarFrameMiscAdjustments()
    -- InterruptGlow
    -- local baseWidthRatio = 444 / 208
    -- local baseHeightRatio = 50 / 11
    -- local newInterruptGlowWidth = baseWidthRatio * BetterBlizzFramesDB.playerCastBarWidth
    -- local newInterruptGlowHeight
    -- if BetterBlizzFramesDB.playerCastBarHeight > 14 and BetterBlizzFramesDB.playerCastBarHeight < 30 then
    --     newInterruptGlowHeight = baseHeightRatio * BetterBlizzFramesDB.playerCastBarHeight * 0.78
    -- else
    --     newInterruptGlowHeight = baseHeightRatio * BetterBlizzFramesDB.playerCastBarHeight
    -- end
    --CastingBarFrame.InterruptGlow:SetSize(newInterruptGlowWidth, newInterruptGlowHeight)

    local playerSparkHeight = BetterBlizzFramesDB.playerCastBarHeight + 15
    local targetSparkHeight = BetterBlizzFramesDB.targetCastBarHeight + 15
    local focusSparkHeight = BetterBlizzFramesDB.focusCastBarHeight + 15

    if not CastingBarFrame.sparkHooked then
        CastingBarFrame:HookScript("OnUpdate", function(self)
            --self.Spark:SetTexture(130877)
            self.Spark:SetSize(30, playerSparkHeight)
            UpdateSparkPosition(self)
        end)
        TargetFrameSpellBar:HookScript("OnUpdate", function(self)
            --self.Spark:SetTexture(130877)
            self.Spark:SetSize(30, targetSparkHeight)
            UpdateSparkPosition(self)
        end)
        if FocusFrameSpellBar then
            FocusFrameSpellBar:HookScript("OnUpdate", function(self)
                --self.Spark:SetTexture(130877)
                self.Spark:SetSize(30, focusSparkHeight)
                UpdateSparkPosition(self)
            end)
        end
        CastingBarFrame.sparkHooked = true
    end
    CastingBarFrame:SetStatusBarTexture(classicCastbarTexture)
    --CastingBarFrame.StandardGlow:SetSize(37, BetterBlizzFramesDB.playerCastBarHeight + 1)
end

local hookedPlayerCastbar = false
local bugNotify
function BBF.ChangeCastbarSizes()
    BBF.UpdateUserAuraSettings()
    --Player
    if not BetterBlizzFramesDB.playerCastBarScale then
        BetterBlizzFramesDB.playerCastBarScale = CastingBarFrame:GetScale()
    end
    CastingBarFrame:SetScale(BetterBlizzFramesDB.playerCastBarScale)
    CastingBarFrame:SetWidth(BetterBlizzFramesDB.playerCastBarWidth)
    CastingBarFrame:SetHeight(BetterBlizzFramesDB.playerCastBarHeight)
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetWidth(BetterBlizzFramesDB.playerCastBarWidth)
    CastingBarFrame.Icon:SetSize(22,22)
    CastingBarFrame.Icon:ClearAllPoints()
    CastingBarFrame.Icon:SetPoint("RIGHT", CastingBarFrame, "LEFT", -5 + BetterBlizzFramesDB.playerCastbarIconXPos, BetterBlizzFramesDB.playerCastbarIconYPos)
    CastingBarFrame.Icon:SetScale(BetterBlizzFramesDB.playerCastBarIconScale)
    -- CastingBarFrame.BorderShield:SetSize(30,36)
    -- CastingBarFrame.BorderShield:ClearAllPoints()
    -- CastingBarFrame.BorderShield:SetPoint("RIGHT", CastingBarFrame, "LEFT", -1.5 + BetterBlizzFramesDB.playerCastbarIconXPos, -7 + BetterBlizzFramesDB.playerCastbarIconYPos)
    -- CastingBarFrame.BorderShield:SetScale(BetterBlizzFramesDB.playerCastBarIconScale)
    -- CastingBarFrame.BorderShield:SetDrawLayer("BORDER")
    CastingBarFrame.Icon:SetDrawLayer("ARTWORK")
    CastingBarFrame.Text:SetAlpha(BetterBlizzFramesDB.playerCastBarShowText and 1 or 0)
    CastingBarFrame.Border:SetAlpha(BetterBlizzFramesDB.playerCastBarShowBorder and 1 or 0)

    adjustCastBarBorder(CastingBarFrame, CastingBarFrame.Border, 15, nil, nil, nil, 11)
    adjustCastBarBorder(CastingBarFrame, CastingBarFrame.Flash, 15, nil, nil, nil, 11)
    adjustCastBarBorder(CastingBarFrame, CastingBarFrame.BorderShield, 12, true)

    --
    CastingBarFrameMiscAdjustments()





    --Target & Focus XY in auras.lua
    --Target
    TargetFrameSpellBar:SetScale(BetterBlizzFramesDB.targetCastBarScale)
    TargetFrameSpellBar:SetWidth(BetterBlizzFramesDB.targetCastBarWidth)
    TargetFrameSpellBar:SetHeight(BetterBlizzFramesDB.targetCastBarHeight)
    adjustCastBarBorder(TargetFrameSpellBar, TargetFrameSpellBar.Border, 15)
    adjustCastBarBorder(TargetFrameSpellBar, TargetFrameSpellBar.BorderShield, 12, true)
    TargetFrameSpellBar.Icon:SetDrawLayer("OVERLAY", 7)
    TargetFrameSpellBar.Text:SetAlpha(BetterBlizzFramesDB.targetCastBarShowText and 1 or 0)
    TargetFrameSpellBar.Border:SetAlpha(BetterBlizzFramesDB.targetCastBarShowBorder and 1 or 0)
    TargetFrameSpellBar.Flash:SetParent(BetterBlizzFramesDB.targetCastBarShowBorder and TargetFrameSpellBar or hiddenFrame)

    -- 227, 56

    TargetFrameSpellBar.Icon:SetScale(BetterBlizzFramesDB.targetCastBarIconScale)
    local a,b,c,d,e = TargetFrameSpellBar.Icon:GetPoint()
    TargetFrameSpellBar.Icon:ClearAllPoints()
    TargetFrameSpellBar.Icon:SetPoint(a, b, c, -5 + BetterBlizzFramesDB.targetCastbarIconXPos, 1 + BetterBlizzFramesDB.targetCastbarIconYPos)
    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("CENTER", TargetFrameSpellBar, "CENTER", 0, 0)
    TargetFrameSpellBar.Text:SetWidth(BetterBlizzFramesDB.targetCastBarWidth)
    --TargetFrameSpellBar.Icon:SetPoint("RIGHT", b, "LEFT", 0 + BetterBlizzFramesDB.targetCastbarIconXPos, 0 + BetterBlizzFramesDB.targetCastbarIconYPos)

    -- TargetFrameSpellBar.BorderShield:ClearAllPoints()
    -- TargetFrameSpellBar.BorderShield:SetPoint("CENTER", TargetFrameSpellBar.Icon, "CENTER", 0, 0)
    -- TargetFrameSpellBar.BorderShield:SetScale(BetterBlizzFramesDB.targetCastBarIconScale)
    -- TargetFrameSpellBar.Text:ClearAllPoints()
    -- TargetFrameSpellBar.Text:SetPoint("BOTTOM", TargetFrameSpellBar, "BOTTOM", 0, -14)

    --Focus
    if FocusFrameSpellBar then
        FocusFrameSpellBar:SetScale(BetterBlizzFramesDB.focusCastBarScale)
        FocusFrameSpellBar:SetWidth(BetterBlizzFramesDB.focusCastBarWidth)
        FocusFrameSpellBar:SetHeight(BetterBlizzFramesDB.focusCastBarHeight)
        adjustCastBarBorder(FocusFrameSpellBar, FocusFrameSpellBar.Border, 15)
        adjustCastBarBorder(FocusFrameSpellBar, FocusFrameSpellBar.BorderShield, 12, true)
        FocusFrameSpellBar.Icon:SetDrawLayer("OVERLAY", 7)
        FocusFrameSpellBar.Text:SetAlpha(BetterBlizzFramesDB.focusCastBarShowText and 1 or 0)
        FocusFrameSpellBar.Border:SetAlpha(BetterBlizzFramesDB.focusCastBarShowBorder and 1 or 0)
        FocusFrameSpellBar.Flash:SetParent(BetterBlizzFramesDB.focusCastBarShowBorder and FocusFrameSpellBar or hiddenFrame)

        -- 227, 56

        FocusFrameSpellBar.Icon:SetScale(BetterBlizzFramesDB.focusCastBarIconScale)
        local a,b,c,d,e = FocusFrameSpellBar.Icon:GetPoint()
        FocusFrameSpellBar.Icon:ClearAllPoints()
        FocusFrameSpellBar.Icon:SetPoint(a, b, c, -5 + BetterBlizzFramesDB.focusCastbarIconXPos, 1 + BetterBlizzFramesDB.focusCastbarIconYPos)
        FocusFrameSpellBar.Text:ClearAllPoints()
        FocusFrameSpellBar.Text:SetPoint("CENTER", FocusFrameSpellBar, "CENTER", 0, 0)
        FocusFrameSpellBar.Text:SetWidth(BetterBlizzFramesDB.focusCastBarWidth)
    end

    if not CastingBarFrame.textureHooked then
        CastingBarFrame.textureHooked = true
        CastingBarFrame:HookScript("OnEvent", function()
            CastingBarFrame:SetStatusBarTexture(classicCastbarTexture)
        end)
        CastingBarFrame.Border:SetDrawLayer("OVERLAY", 5)
        CastingBarFrame.BorderShield:SetDrawLayer("OVERLAY", 6)
        CastingBarFrame.Text:SetDrawLayer("OVERLAY", 7)

        TargetFrameSpellBar:HookScript("OnEvent", function()
            TargetFrameSpellBar:SetStatusBarTexture(classicCastbarTexture)
        end)
        TargetFrameSpellBar.Border:SetDrawLayer("OVERLAY", 6)
        TargetFrameSpellBar.BorderShield:SetDrawLayer("OVERLAY", 7)

        if FocusFrameSpellBar then
            FocusFrameSpellBar:HookScript("OnEvent", function()
                FocusFrameSpellBar:SetStatusBarTexture(classicCastbarTexture)
            end)
            FocusFrameSpellBar.Border:SetDrawLayer("OVERLAY", 6)
            FocusFrameSpellBar.BorderShield:SetDrawLayer("OVERLAY", 7)
        end
    end

    if BetterBlizzFramesDB.changeUnitFrameFont then
        local fontName = BetterBlizzFramesDB.unitFrameFont
        local fontPath = BBF.LSM:Fetch(BBF.LSM.MediaType.FONT, fontName)
        local outline = BetterBlizzFramesDB.unitFrameFontOutline or "OUTLINE"
        local _, size, _ = TargetFrameSpellBar.Text:GetFont()
        TargetFrameSpellBar.Text:SetFont(fontPath, size, outline)
        if FocusFrameSpellBar then
            FocusFrameSpellBar.Text:SetFont(fontPath, size, outline)
        end
        local _, size, _ = CastingBarFrame.Text:GetFont()
        CastingBarFrame.Text:SetFont(fontPath, size, outline)
    end
end

CastingBarFrame:HookScript("OnShow", function()
    local showIcon = BetterBlizzFramesDB.playerCastBarShowIcon
    if showIcon then
        local playerCastBarIconScale = BetterBlizzFramesDB.playerCastBarIconScale
        CastingBarFrame.Icon:Show()
        --CastingBarFrame.showShield = true --taint concern TODO: add non-taint method
        -- CastingBarFrame.BorderShield:SetSize(30,36)
        -- CastingBarFrame.BorderShield:ClearAllPoints()
        -- CastingBarFrame.BorderShield:SetPoint("CENTER", CastingBarFrame.Icon, "CENTER", 0, 0)
        -- CastingBarFrame.BorderShield:SetScale(playerCastBarIconScale)
        -- CastingBarFrame.BorderShield:SetDrawLayer("BORDER")
    end
end)

hooksecurefunc(CastingBarFrame, "SetScale", function()
    if not BetterBlizzFramesDB.wasOnLoadingScreen then
        BetterBlizzFramesDB.playerCastBarScale = CastingBarFrame:GetScale()
    end
end)

-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("PLAYER_LOGIN")
-- frame:SetScript("OnEvent", function(self, event, ...)
--     if IsAddOnLoaded("ClassicFrames") then
--         return
--     end
--     -- Put your original conditional logic here since it's now safe to check.
--     if TargetFrameSpellBar and FocusFrameSpellBar then
--         -- Adjust frame strata as originally intended.
--         TargetFrame:SetFrameStrata("MEDIUM")
--         TargetFrameSpellBar:SetFrameStrata("HIGH")
--         FocusFrameSpellBar:SetFrameStrata("HIGH")
--     end
-- end)

local evokerCastbarsHooked
function BBF.HookCastbarsForEvoker()
    -- if (not evokerCastbarsHooked and BetterBlizzFramesDB.normalCastbarForEmpoweredCasts) then
    --     hooksecurefunc(CastingBarMixin, "OnEvent", function(self, event, ...)
    --         if self.unit and self.unit:find("target") or self.unit:find("focus") then
    --             if ( event == "UNIT_SPELLCAST_EMPOWER_START" ) then
    --                 if not self:IsForbidden() then
    --                     if self.barType == "empowered" or self.barType == "standard" then
    --                         self:SetStatusBarTexture("ui-castingbar-filling-standard")
    --                     end
    --                     self.ChargeTier1:Hide()
    --                     self.ChargeTier2:Hide()
    --                     self.ChargeTier3:Hide()
    --                     if self.ChargeTier4 then
    --                         self.ChargeTier4:Hide()
    --                     end
    --                 end
    --             end
    --         end
    --     end)
    --     evokerCastbarsHooked = true
    -- end
end

local CastStartEvents = {
    UNIT_SPELLCAST_START            = true,
    UNIT_SPELLCAST_CHANNEL_START    = true,
    PLAYER_TARGET_CHANGED           = true,
    PLAYER_FOCUS_CHANGED            = true,
}

local function GetCastbarTargetName(unit)
    local name = UnitSpellTargetName(unit)
    if not name then return end

    local class = UnitSpellTargetClass(unit)
    if not class then
        _, class = UnitClass(unit .. "target")
    end
    return name, class
end

local function GetColoredTargetString(name, class)
    if not name then return end
    if class then
        local color = C_ClassColor and C_ClassColor.GetClassColor(class) or RAID_CLASS_COLORS[class]
        if color then
            if color.WrapTextInColorCode then
                return color:WrapTextInColorCode(name)
            elseif color.colorStr then
                return "|c" .. color.colorStr .. name .. "|r"
            end
        end
    end
    return name
end

local TARGET_TEXT_ANCHORS = {
    BOTTOM = { "TOP", "BOTTOM" },
    TOP    = { "BOTTOM", "TOP" },
    LEFT   = { "RIGHT", "LEFT" },
    RIGHT  = { "LEFT", "RIGHT" },
    CENTER = { "CENTER", "CENTER" },
}

local function ApplyTargetTextSettings(castBar)
    local text = castBar and castBar.bbfTargetText
    if not text then return end

    local db = BetterBlizzFramesDB
    local placement = TARGET_TEXT_ANCHORS[db.castBarTargetTextOutsideAnchor or "BOTTOM"]
        or TARGET_TEXT_ANCHORS.BOTTOM

    text:ClearAllPoints()
    text:SetPoint(placement[1], castBar, placement[2],
        db.castBarTargetTextOutsideXPos or 0, db.castBarTargetTextOutsideYPos or 0)

    local font, _, flags = text:GetFont()
    if font then
        text:SetFont(font, db.castBarTargetTextOutsideSize or 10, flags)
    end
end

local function GetOutsideTargetText(castBar)
    if not castBar.bbfTargetText then
        castBar.bbfTargetText = castBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        ApplyTargetTextSettings(castBar)
    end
    return castBar.bbfTargetText
end

local function TargetTextHiddenForUnit(unit)
    return BetterBlizzFramesDB.castBarTargetTextHideOnNpcs and unit and not UnitIsPlayer(unit)
end

function BBF.CastbarTargetTextCaller()
    local db = BetterBlizzFramesDB

    for _, castBar in ipairs({ TargetFrameSpellBar, FocusFrameSpellBar }) do
        if db.castBarTargetText and db.castBarTargetTextOutside then
            GetOutsideTargetText(castBar)
            ApplyTargetTextSettings(castBar)
            if TargetTextHiddenForUnit(castBar.unit) then
                castBar.bbfTargetText:SetText("")
            end
        elseif castBar.bbfTargetText then
            castBar.bbfTargetText:SetText("")
        end
    end
end

function BBF.CastbarTargetText(castBar)
    if BetterBlizzFramesDB.castBarTargetTextOutside then
        GetOutsideTargetText(castBar)
    end

    castBar:HookScript("OnEvent", function(self, event)
        if not CastStartEvents[event] then return end

        local outside = BetterBlizzFramesDB.castBarTargetTextOutside
        local spell = UnitCastingInfo(self.unit) or UnitChannelInfo(self.unit)
        if not spell then
            if outside and self.bbfTargetText then
                self.bbfTargetText:SetText("")
            end
            return
        end

        local name, class = GetCastbarTargetName(self.unit)
        local coloredName = GetColoredTargetString(name, class)
        if TargetTextHiddenForUnit(self.unit) then
            coloredName = nil
        end

        if outside then
            GetOutsideTargetText(self):SetText(coloredName or "")
        elseif coloredName then
            self.Text:SetText(spell .. ": " .. coloredName)
        end
    end)
end

function BBF.CastbarTargetHighlight(castBar)
    castBar.castOnMeHighlight = castBar:CreateTexture(nil, "OVERLAY", nil, 7)
    castBar.castOnMeHighlight:SetAtlas("ui-hud-nameplates-targetedbyenemy")
    castBar.castOnMeHighlight:SetPoint("TOPLEFT", -2.5, 2)
    castBar.castOnMeHighlight:SetPoint("BOTTOMRIGHT", 2.5, -2)
    castBar.castOnMeHighlight:SetAlpha(0)

    castBar:HookScript("OnEvent", function(self)
        self.castOnMeHighlight:SetAlpha(PlayerIsSpellTarget(self.unit) and 1 or 0)
    end)
end

function BBF.HookCastbars()
    if BetterBlizzFramesDB.castBarTargetText then
        BBF.CastbarTargetText(TargetFrameSpellBar)
        if FocusFrameSpellBar then
            BBF.CastbarTargetText(FocusFrameSpellBar)
        end
    end

    if BetterBlizzFramesDB.castBarTargetHighlight then
        BBF.CastbarTargetHighlight(TargetFrameSpellBar)
        if FocusFrameSpellBar then
            BBF.CastbarTargetHighlight(FocusFrameSpellBar)
        end
    end
end

-- ============================================================================
-- MoP individual castbar previews
-- Integrated here so BetterBlizzFrames_Mists.toc needs no custom module files.
-- ============================================================================
do
    local function InitializeBBFCastbarPreviews()
        local L = BBF.L

        -- Integrated BetterBlizzFrames MoP: independent normal / uninterruptible castbar previews.
        --
        -- Test state is session-only and never saved to BetterBlizzFramesDB.
        -- Each castbar type can be previewed independently:
        --   Player, Party, Target, Focus, Pet
        -- Each preview has two mutually-exclusive modes:
        --   Normal, Uninterruptible
        --
        -- All previews stop automatically when Settings closes or combat starts.

        local MODES = {
            NORMAL = "normal",
            UNINTERRUPTIBLE = "uninterruptible",
        }

        local state = {
            player = nil,
            party = nil,
            target = nil,
            focus = nil,
            pet = nil,
            startedAt = GetTime(),
            duration = 2.5,
        }

        local bars = {
            party = {},
        }

        local controls = {}
        local updater = CreateFrame("Frame")
        local combatWatcher = CreateFrame("Frame")
        local settingsHooked = false
        local guiHooked = false
        local updateAccumulator = 0
        local styleAccumulator = 0

        local CastingBarFrame = _G.CastingBarFrame or _G.PlayerCastingBarFrame

        local function RegionSetShown(region, shown)
            if not region then return end
            if shown then
                region:Show()
            else
                region:Hide()
            end
        end

        local function GetSpellTextureSafe(spellID)
            if GetSpellTexture then
                local texture = GetSpellTexture(spellID)
                if texture then return texture end
            end
            if GetSpellInfo then
                local _, _, texture = GetSpellInfo(spellID)
                if texture then return texture end
            end
            return 136197
        end

        local function GetSpellNameSafe(spellID, fallback)
            if GetSpellInfo then
                local name = GetSpellInfo(spellID)
                if name then return name end
            end
            return fallback
        end

        local function CopyVertexColor(target, source)
            if not target or not source or not source.GetVertexColor or not target.SetVertexColor then
                return
            end

            local r, g, b, a = source:GetVertexColor()
            if r then
                target:SetVertexColor(r, g, b, a or 1)
            end
        end

        local function CopyStatusBarTexture(target, source)
            local texture = 137012

            if source and source.GetStatusBarTexture then
                local sourceTexture = source:GetStatusBarTexture()
                if sourceTexture and sourceTexture.GetTexture then
                    texture = sourceTexture:GetTexture() or texture
                end
            end

            target:SetStatusBarTexture(texture)
        end

        local function AdjustCastBarBorder(castBar, border, adjust, shield, player, party, playerCb)
            if not castBar or not border then return end

            local defaultCastBarWidth = player or 150
            local defaultBorderWidth = 200
            local widthAdjustmentFactor = adjust / 50

            local defaultCastBarHeight = playerCb or 10
            local defaultBorderHeight = party and 55 or 56
            local heightAdjustmentFactor = 5.00

            local currentCastBarWidth = castBar:GetWidth()
            local currentCastBarHeight = castBar:GetHeight()

            local widthDifference = currentCastBarWidth - defaultCastBarWidth
            local borderWidth = defaultBorderWidth + widthDifference + (widthDifference * widthAdjustmentFactor)

            local heightDifference = currentCastBarHeight - defaultCastBarHeight
            local borderHeight = defaultBorderHeight + (heightDifference * heightAdjustmentFactor)

            border:ClearAllPoints()
            border:SetPoint("CENTER", castBar, "CENTER", shield and -4 or 0, 0)
            border:SetSize(borderWidth, shield and borderHeight - 1 or borderHeight)
        end

        local function ApplyInterruptibility(bar, mode, showBorder, source)
            if not bar then return end

            local uninterruptible = mode == MODES.UNINTERRUPTIBLE
            bar.showShield = uninterruptible
            bar.notInterruptible = uninterruptible

            if bar.Border then
                bar.Border:SetAlpha(showBorder and not uninterruptible and 1 or 0)
                RegionSetShown(bar.Border, showBorder and not uninterruptible)
                if source and source.Border then
                    CopyVertexColor(bar.Border, source.Border)
                end
            end

            if bar.BorderShield then
                bar.BorderShield:SetAlpha(showBorder and uninterruptible and 1 or 0)
                RegionSetShown(bar.BorderShield, showBorder and uninterruptible)
                if source and source.BorderShield then
                    CopyVertexColor(bar.BorderShield, source.BorderShield)
                end
            end
        end

        local function CreatePreviewBar(name, spellID, fallbackName)
            local bar = CreateFrame("StatusBar", name, UIParent, "SmallCastingBarFrameTemplate")

            -- This is a pure visual preview. It must never react to unit spellcast events.
            bar:UnregisterAllEvents()
            bar:SetScript("OnEvent", nil)
            bar:SetScript("OnUpdate", nil)
            bar:SetFrameStrata("HIGH")
            bar:SetFrameLevel(9900)

            if bar.SetIgnoreParentAlpha then
                bar:SetIgnoreParentAlpha(true)
            end

            bar:EnableMouse(false)
            bar:SetMinMaxValues(0, 100)
            bar:SetValue(0)
            bar:SetStatusBarColor(1, 0.702, 0)

            if bar.Text then
                bar.Text:SetFontObject("SystemFont_Shadow_Med1_Outline")
                bar.Text:SetText(GetSpellNameSafe(spellID, fallbackName))
            end

            if bar.Icon then
                bar.Icon:SetSize(22, 22)
                bar.Icon:SetTexture(GetSpellTextureSafe(spellID))
            end

            if bar.Spark then
                bar.Spark:Show()
            end

            if bar.Flash then
                bar.Flash:Hide()
            end

            if bar.Border then
                bar.Border:SetDrawLayer("OVERLAY", 6)
            end

            if bar.BorderShield then
                bar.BorderShield:SetDrawLayer("OVERLAY", 7)
            end

            bar.TestTimer = bar:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Med1_Outline")
            bar.TestTimer:SetTextColor(1, 1, 1, 1)

            bar:Hide()
            return bar
        end

        local function EnsureBars()
            if not bars.player then
                bars.player = CreatePreviewBar("BBFPlayerCastbarPreview", 116, "Frostbolt")
            end

            if not bars.target then
                bars.target = CreatePreviewBar("BBFTargetCastbarPreview", 116, "Frostbolt")
            end

            if not bars.focus then
                bars.focus = CreatePreviewBar("BBFFocusCastbarPreview", 116, "Frostbolt")
            end

            if not bars.pet then
                bars.pet = CreatePreviewBar("BBFPetCastbarPreview", 6358, "Seduction")
            end

            for i = 1, 5 do
                if not bars.party[i] then
                    bars.party[i] = CreatePreviewBar("BBFPartyCastbarPreview" .. i, 116, "Frostbolt")
                end
            end
        end

        local function ApplyCommonStyle(bar, source, width, height, scale, showText, showBorder, mode)
            if not bar then return end

            bar:SetScale(scale or 1)
            bar:SetWidth(width)
            bar:SetHeight(height)
            CopyStatusBarTexture(bar, source)
            bar:SetStatusBarColor(1, 0.702, 0)

            if bar.Text then
                bar.Text:ClearAllPoints()
                bar.Text:SetPoint("CENTER", bar, "CENTER", 0, 0)
                bar.Text:SetWidth(width)
                bar.Text:SetAlpha(showText and 1 or 0)
            end

            if bar.Flash then
                bar.Flash:Hide()
            end

            ApplyInterruptibility(bar, mode, showBorder, source)
        end

        local function ApplyPreviewCastTargetText(bar)
            if not bar or not bar.Text then return end

            local db = BetterBlizzFramesDB
            local spellName = GetSpellNameSafe(116, "Frostbolt")

            -- The real Cast Target Text feature only has live unit data during an
            -- actual cast.  Preview bars simulate a cast targeting the player so
            -- the setting can be configured without entering combat.
            if not db.castBarTargetText then
                bar.Text:SetText(spellName)
                if bar.bbfTargetText then
                    bar.bbfTargetText:SetText("")
                end
                return
            end

            local targetName = UnitName("player") or "Player"
            local _, targetClass = UnitClass("player")
            local coloredTarget = GetColoredTargetString(targetName, targetClass) or targetName

            if db.castBarTargetTextOutside then
                bar.Text:SetText(spellName)
                local outsideText = GetOutsideTargetText(bar)
                ApplyTargetTextSettings(bar)
                outsideText:SetText(coloredTarget)
                outsideText:Show()
            else
                if bar.bbfTargetText then
                    bar.bbfTargetText:SetText("")
                end
                bar.Text:SetText(spellName .. ": " .. coloredTarget)
            end
        end

        local function ApplyPlayerStyle()
            local mode = state.player
            local bar = bars.player

            if not mode then
                if bar then bar:Hide() end
                return
            end

            local db = BetterBlizzFramesDB
            local source = CastingBarFrame

            ApplyCommonStyle(
                bar,
                source,
                db.playerCastBarWidth or 195,
                db.playerCastBarHeight or 13,
                db.playerCastBarScale or 1,
                db.playerCastBarShowText ~= false,
                db.playerCastBarShowBorder ~= false,
                mode
            )

            bar:ClearAllPoints()
            if source then
                bar:SetPoint("CENTER", source, "CENTER", 0, 0)
            else
                bar:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
            end

            if bar.Icon then
                bar.Icon:ClearAllPoints()
                bar.Icon:SetPoint(
                    "RIGHT",
                    bar,
                    "LEFT",
                    -5 + (db.playerCastbarIconXPos or 0),
                    db.playerCastbarIconYPos or 0
                )
                bar.Icon:SetScale(db.playerCastBarIconScale or 1)
                bar.Icon:SetDrawLayer("OVERLAY", 7)
                RegionSetShown(bar.Icon, db.playerCastBarShowIcon and true or false)
            end

            AdjustCastBarBorder(bar, bar.Border, 15, nil, nil, nil, 11)
            AdjustCastBarBorder(bar, bar.BorderShield, 12, true)

            PositionCastTimer(bar.TestTimer, bar, "playerCastBar", 3, 2, true)
            RegionSetShown(bar.TestTimer, db.playerCastBarTimer and true or false)

            bar:Show()
        end

        local function ApplyTargetFocusStyle(kind)
            local mode = state[kind]
            local bar = bars[kind]

            if not mode then
                if bar then bar:Hide() end
                return
            end

            local db = BetterBlizzFramesDB
            local isTarget = kind == "target"
            local prefix = isTarget and "target" or "focus"
            local source = isTarget and _G.TargetFrameSpellBar or _G.FocusFrameSpellBar

            ApplyCommonStyle(
                bar,
                source,
                db[prefix .. "CastBarWidth"] or 150,
                db[prefix .. "CastBarHeight"] or 11,
                db[prefix .. "CastBarScale"] or 1,
                db[prefix .. "CastBarShowText"] ~= false,
                db[prefix .. "CastBarShowBorder"] ~= false,
                mode
            )

            bar:ClearAllPoints()
            if source then
                bar:SetPoint("CENTER", source, "CENTER", 0, 0)
            elseif isTarget then
                bar:SetPoint("CENTER", UIParent, "CENTER", 250, 50)
            else
                bar:SetPoint("CENTER", UIParent, "CENTER", 250, -20)
            end

            if bar.Icon then
                bar.Icon:ClearAllPoints()
                bar.Icon:SetPoint(
                    "RIGHT",
                    bar,
                    "LEFT",
                    -5 + (db[prefix .. "CastbarIconXPos"] or 0),
                    1 + (db[prefix .. "CastbarIconYPos"] or 0)
                )
                bar.Icon:SetScale(db[prefix .. "CastBarIconScale"] or 1)
                bar.Icon:SetDrawLayer("OVERLAY", 7)
                bar.Icon:Show()
            end

            AdjustCastBarBorder(bar, bar.Border, 15)
            AdjustCastBarBorder(bar, bar.BorderShield, 12, true)

            PositionCastTimer(bar.TestTimer, bar, prefix .. "CastBar", 3, -1)
            RegionSetShown(bar.TestTimer, db[prefix .. "CastBarTimer"] and true or false)

            ApplyPreviewCastTargetText(bar)
            bar:Show()
        end

        local function GetPartyFrame(index)
            if BBF.FindPartyFrame then
                local frame, isDefault = BBF.FindPartyFrame(index)
                if frame then
                    return frame, isDefault
                end
            end

            local frame = _G["CompactPartyFrameMember" .. index]
                or _G["CompactRaidFrame" .. index]
                or _G["PartyMemberFrame" .. index]

            if not frame and _G.PartyFrame then
                frame = _G.PartyFrame["MemberFrame" .. index]
            end

            return frame, false
        end

        local function ApplyPartyStyle()
            local mode = state.party

            if not mode then
                for i = 1, 5 do
                    if bars.party[i] then
                        bars.party[i]:Hide()
                    end
                end
                return
            end

            local db = BetterBlizzFramesDB
            local source = _G.TargetFrameSpellBar or CastingBarFrame
            local shown = 0

            for i = 1, 5 do
                local bar = bars.party[i]
                local partyFrame, defaultPartyFrame = GetPartyFrame(i)

                if partyFrame and partyFrame:IsShown() then
                    ApplyCommonStyle(
                        bar,
                        source,
                        db.partyCastBarWidth or 137,
                        db.partyCastBarHeight or 10,
                        db.partyCastBarScale or 0.9,
                        db.partyCastbarShowText ~= false,
                        db.partyCastbarShowBorder ~= false,
                        mode
                    )

                    local xPos = (db.partyCastBarXPos or 0) + 10
                    local yPos = db.partyCastBarYPos or 0

                    if defaultPartyFrame then
                        xPos = xPos + 15
                        yPos = yPos - 20
                    end

                    bar:ClearAllPoints()
                    bar:SetPoint("CENTER", partyFrame, "CENTER", xPos, yPos + 3)

                    if bar.Icon then
                        bar.Icon:ClearAllPoints()
                        bar.Icon:SetPoint(
                            "RIGHT",
                            bar,
                            "LEFT",
                            -4 + (db.partyCastbarIconXPos or 0),
                            (db.partyCastbarIconYPos or 0) - 1
                        )
                        bar.Icon:SetScale(db.partyCastBarIconScale or 0.9)
                        bar.Icon:SetDrawLayer("OVERLAY", 7)
                        RegionSetShown(bar.Icon, db.showPartyCastBarIcon ~= false)
                    end

                    AdjustCastBarBorder(bar, bar.Border, 15, nil, nil, true)
                    AdjustCastBarBorder(bar, bar.BorderShield, 12, true, nil, true)

                    PositionPartyCastTimer(bar.TestTimer, bar)
                    RegionSetShown(bar.TestTimer, db.partyCastBarTimer and true or false)

                    bar:Show()
                    shown = shown + 1
                else
                    bar:Hide()
                end
            end

            -- Party preview remains usable even when the player is not currently grouped.
            if shown == 0 then
                local bar = bars.party[1]

                ApplyCommonStyle(
                    bar,
                    source,
                    db.partyCastBarWidth or 137,
                    db.partyCastBarHeight or 10,
                    db.partyCastBarScale or 0.9,
                    db.partyCastbarShowText ~= false,
                    db.partyCastbarShowBorder ~= false,
                    mode
                )

                bar:ClearAllPoints()
                bar:SetPoint("CENTER", UIParent, "CENTER", -330, 120)

                if bar.Icon then
                    bar.Icon:ClearAllPoints()
                    bar.Icon:SetPoint(
                        "RIGHT",
                        bar,
                        "LEFT",
                        -4 + (db.partyCastbarIconXPos or 0),
                        (db.partyCastbarIconYPos or 0) - 1
                    )
                    bar.Icon:SetScale(db.partyCastBarIconScale or 0.9)
                    RegionSetShown(bar.Icon, db.showPartyCastBarIcon ~= false)
                end

                AdjustCastBarBorder(bar, bar.Border, 15, nil, nil, true)
                AdjustCastBarBorder(bar, bar.BorderShield, 12, true, nil, true)

                PositionPartyCastTimer(bar.TestTimer, bar)
                RegionSetShown(bar.TestTimer, db.partyCastBarTimer and true or false)

                bar:Show()
            end
        end

        local function ApplyPetStyle()
            local mode = state.pet
            local bar = bars.pet

            if not mode then
                if bar then bar:Hide() end
                return
            end

            local db = BetterBlizzFramesDB
            local source = _G.TargetFrameSpellBar or CastingBarFrame

            ApplyCommonStyle(
                bar,
                source,
                db.petCastBarWidth or 137,
                db.petCastBarHeight or 10,
                db.petCastBarScale or 0.92,
                db.petCastBarShowText ~= false,
                db.petCastBarShowBorder ~= false,
                mode
            )

            local xPos = db.petCastBarXPos or 0
            local yPos = db.petCastBarYPos or 0

            bar:ClearAllPoints()
            if db.petDetachCastbar then
                bar:SetPoint("CENTER", UIParent, "CENTER", xPos, yPos)
            elseif _G.PetFrame then
                bar:SetPoint("CENTER", _G.PetFrame, "CENTER", xPos + 4, yPos - 27)
            else
                bar:SetPoint("CENTER", UIParent, "CENTER", -330, -80)
            end

            if bar.Icon then
                bar.Icon:ClearAllPoints()
                bar.Icon:SetPoint("RIGHT", bar, "LEFT", -4, 0)
                bar.Icon:SetScale(db.petCastBarIconScale or 1)
                bar.Icon:SetDrawLayer("OVERLAY", 7)
                RegionSetShown(bar.Icon, db.showPetCastBarIcon ~= false)
            end

            AdjustCastBarBorder(bar, bar.Border, 15, nil, nil, true)
            AdjustCastBarBorder(bar, bar.BorderShield, 12, true, nil, true)

            PositionPetCastTimer(bar.TestTimer, bar)
            RegionSetShown(bar.TestTimer, db.petCastBarTimer and true or false)

            bar:Show()
        end

        local function ApplyStyles()
            EnsureBars()
            ApplyPlayerStyle()
            ApplyPartyStyle()
            ApplyTargetFocusStyle("target")
            ApplyTargetFocusStyle("focus")
            ApplyPetStyle()
        end

        local function AnyTestActive()
            return state.player
                or state.party
                or state.target
                or state.focus
                or state.pet
        end

        local function UpdateProgress(bar, progress, remaining)
            if not bar or not bar:IsShown() then return end

            bar:SetValue(progress * 100)

            if bar.Spark then
                local x = bar:GetWidth() * progress
                bar.Spark:ClearAllPoints()
                bar.Spark:SetPoint("CENTER", bar, "LEFT", x, -1.5)
            end

            if bar.TestTimer and bar.TestTimer:IsShown() then
                bar.TestTimer:SetFormattedText("%.1f", remaining)
            end
        end

        local function HideAllBars()
            if bars.player then bars.player:Hide() end
            if bars.target then bars.target:Hide() end
            if bars.focus then bars.focus:Hide() end
            if bars.pet then bars.pet:Hide() end

            for i = 1, 5 do
                if bars.party[i] then
                    bars.party[i]:Hide()
                end
            end
        end

        local function SetCheckState(kind, mode)
            local pair = controls[kind]
            if not pair then return end

            if pair.normal then
                pair.normal:SetChecked(mode == MODES.NORMAL)
            end

            if pair.uninterruptible then
                pair.uninterruptible:SetChecked(mode == MODES.UNINTERRUPTIBLE)
            end
        end

        local function SetMode(kind, mode)
            if InCombatLockdown and InCombatLockdown() then
                return
            end

            state[kind] = mode
            SetCheckState(kind, mode)

            if mode then
                state.startedAt = GetTime()
                ApplyStyles()
                updater:Show()
            else
                ApplyStyles()

                if not AnyTestActive() then
                    updater:Hide()
                end
            end
        end

        local function StopAllTests()
            state.player = nil
            state.party = nil
            state.target = nil
            state.focus = nil
            state.pet = nil

            SetCheckState("player", nil)
            SetCheckState("party", nil)
            SetCheckState("target", nil)
            SetCheckState("focus", nil)
            SetCheckState("pet", nil)

            updater:Hide()
            HideAllBars()
        end

        updater:Hide()
        updater:SetScript("OnUpdate", function(_, elapsed)
            if not AnyTestActive() then
                updater:Hide()
                return
            end

            updateAccumulator = updateAccumulator + elapsed
            styleAccumulator = styleAccumulator + elapsed

            -- Keep the preview in sync while sliders/check boxes are changed.
            if styleAccumulator >= 0.10 then
                styleAccumulator = 0
                ApplyStyles()
            end

            if updateAccumulator < 0.02 then
                return
            end
            updateAccumulator = 0

            local elapsedCast = (GetTime() - state.startedAt) % state.duration
            local progress = elapsedCast / state.duration
            local remaining = state.duration - elapsedCast

            UpdateProgress(bars.player, progress, remaining)
            UpdateProgress(bars.target, progress, remaining)
            UpdateProgress(bars.focus, progress, remaining)
            UpdateProgress(bars.pet, progress, remaining)

            for i = 1, 5 do
                UpdateProgress(bars.party[i], progress, remaining)
            end
        end)

        combatWatcher:RegisterEvent("PLAYER_REGEN_DISABLED")
        combatWatcher:SetScript("OnEvent", StopAllTests)

        local function AddTooltip(frame, title, body)
            frame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(title, 1, 0.82, 0)
                GameTooltip:AddLine(body, 1, 1, 1, true)
                GameTooltip:Show()
            end)

            frame:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end

        local function CreateModeCheck(parent, label)
            local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
            check:SetSize(24, 24)

            local text = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("LEFT", check, "RIGHT", -1, 1)
            text:SetText(label)

            check.Label = text
            return check
        end

        local function FindCastbarContentFrame()
            if not EnumerateFrames then return end

            local castbarName = (L and L["Castbars"]) or "Castbars"
            local frame = EnumerateFrames()

            while frame do
                if frame.name == castbarName then
                    local parent = frame:GetParent()
                    if parent and parent.GetScrollChild and parent:GetScrollChild() == frame then
                        return frame
                    end
                end
                frame = EnumerateFrames(frame)
            end
        end

        local function GetResetButtons(contentFrame)
            local resetText = (L and L["Reset"]) or "Reset"
            local buttons = {}

            for _, child in ipairs({ contentFrame:GetChildren() }) do
                if child and child.GetObjectType and child:GetObjectType() == "Button" and child.GetText then
                    local text = child:GetText()
                    if text == resetText or text == "Reset" then
                        local x, y = child:GetCenter()
                        if x and y then
                            buttons[#buttons + 1] = { frame = child, x = x, y = y }
                        end
                    end
                end
            end

            if #buttons < 5 then
                return nil
            end

            table.sort(buttons, function(a, b)
                if math.abs(a.y - b.y) > 18 then
                    return a.y > b.y
                end
                return a.x < b.x
            end)

            -- The Castbars page has four reset buttons on the top row
            -- (Player, Party, Target, Focus) and Pet below Player.
            local topY = buttons[1].y
            local top = {}
            local lower = {}
            for _, info in ipairs(buttons) do
                if math.abs(info.y - topY) <= 18 then
                    top[#top + 1] = info
                else
                    lower[#lower + 1] = info
                end
            end

            if #top < 4 or #lower < 1 then
                return nil
            end

            table.sort(top, function(a, b) return a.x < b.x end)
            table.sort(lower, function(a, b)
                if math.abs(a.y - b.y) > 18 then
                    return a.y > b.y
                end
                return a.x < b.x
            end)

            return {
                player = top[1].frame,
                party  = top[2].frame,
                target = top[3].frame,
                focus  = top[4].frame,
                pet    = lower[1].frame,
            }
        end

        local function HideLegacyTestCheckboxes(contentFrame)
            -- Author Party/Pet "Test" options are saved-variable based and only
            -- render the regular style.  The integrated previews below replace them.
            if BetterBlizzFramesDB then
                BetterBlizzFramesDB.partyCastBarTestMode = false
                BetterBlizzFramesDB.petCastBarTestMode = false
            end

            local testText = (L and L["Test"]) or "Test"
            for _, child in ipairs({ contentFrame:GetChildren() }) do
                if child and child.GetObjectType and child:GetObjectType() == "CheckButton" then
                    local textRegion = child.Text or child.text
                    local text = textRegion and textRegion.GetText and textRegion:GetText()
                    if text == testText or text == "Test" then
                        child:SetChecked(false)
                        child:Disable()
                        child:SetAlpha(0)
                        child:Hide()
                        if textRegion then
                            textRegion:SetAlpha(0)
                            textRegion:Hide()
                        end
                    end
                end
            end

            -- If a stale saved Test flag was active when the GUI was created,
            -- make the author test bars immediately honor the forced-off value.
            if BBF.partyCastBarTestMode then
                BBF.partyCastBarTestMode()
            end
            if BBF.petCastBarTestMode then
                BBF.petCastBarTestMode()
            end
        end

        local TEST_PANEL_EXTRA = 48

        local function MoveRegionY(region, deltaY)
            if not region or region.bbfCastbarTestMoved then return end
            local point, relativeTo, relativePoint, x, y = region:GetPoint(1)
            if not point then return end

            region:ClearAllPoints()
            region:SetPoint(point, relativeTo, relativePoint, x or 0, (y or 0) + deltaY)
            region.bbfCastbarTestMoved = true
        end

        local function ExpandPanelAboveReset(resetButton, extraHeight)
            if not resetButton then return end

            local _, border = resetButton:GetPoint(1)
            if not border or not border.GetHeight or border.bbfCastbarTestExpanded then return end

            local oldHeight = border:GetHeight() or 0
            local point, relativeTo, relativePoint, x, y = border:GetPoint(1)
            if not point then return end

            border:SetHeight(oldHeight + extraHeight)

            -- These castbar panels are CENTER anchored.  Moving the center down by
            -- half the added height keeps the top edge exactly where the author put it
            -- and creates new empty space only at the bottom.
            local yShift = 0
            if not point:find("TOP") then
                if point:find("BOTTOM") then
                    yShift = -extraHeight
                else
                    yShift = -(extraHeight / 2)
                end
            end

            border:ClearAllPoints()
            border:SetPoint(point, relativeTo, relativePoint, x or 0, (y or 0) + yShift)
            border.bbfCastbarTestExpanded = true
        end

        local function MakeRoomForInlineTests(contentFrame, resets)
            if contentFrame.bbfCastbarTestRoomMade then return end

            -- The four upper panels grow downward. Their reset buttons are anchored
            -- to the panel borders, so they move down automatically.
            ExpandPanelAboveReset(resets.player, TEST_PANEL_EXTRA)
            ExpandPanelAboveReset(resets.party, TEST_PANEL_EXTRA)
            ExpandPanelAboveReset(resets.target, TEST_PANEL_EXTRA)
            ExpandPanelAboveReset(resets.focus, TEST_PANEL_EXTRA)

            -- Shift the entire Pet section down by the same amount. Everything in
            -- that section is chained to its title anchor, so this is one safe move.
            local petTitle = (L and L["Pet_Castbar"]) or "Pet Castbar"
            for i = 1, contentFrame:GetNumRegions() do
                local region = select(i, contentFrame:GetRegions())
                if region and region.GetObjectType and region:GetObjectType() == "FontString"
                    and region.GetText and region:GetText() == petTitle then
                    MoveRegionY(region, -TEST_PANEL_EXTRA)
                    break
                end
            end

            -- Lower castbar settings are rooted directly on the scroll child. Move
            -- only those roots; controls anchored to them follow automatically.
            local function ShiftDirectRoot(region)
                if not region or region.bbfCastbarTestMoved then return end
                local _, relativeTo, _, _, y = region:GetPoint(1)
                if relativeTo == contentFrame and y and y <= -430 then
                    MoveRegionY(region, -TEST_PANEL_EXTRA)
                end
            end

            for _, child in ipairs({ contentFrame:GetChildren() }) do
                ShiftDirectRoot(child)
            end
            for i = 1, contentFrame:GetNumRegions() do
                ShiftDirectRoot(select(i, contentFrame:GetRegions()))
            end

            -- Pet also needs its own two-line test area at the bottom.
            ExpandPanelAboveReset(resets.pet, TEST_PANEL_EXTRA)

            -- One gap for moving the lower half, one gap for extending Pet.
            contentFrame:SetHeight((contentFrame:GetHeight() or 520) + (TEST_PANEL_EXTRA * 2) + 8)
            contentFrame.bbfCastbarTestRoomMade = true
        end

        local function CreateInlineTestPair(contentFrame, resetButton, kind, title)
            local holder = CreateFrame("Frame", nil, contentFrame)
            holder:SetSize(152, 42)
            holder:SetPoint("BOTTOM", resetButton, "TOP", 0, 1)

            local normal = CreateModeCheck(holder, "Test Regular Castbar")
            normal:SetSize(18, 18)
            normal:ClearAllPoints()
            normal:SetPoint("TOPLEFT", holder, "TOPLEFT", 2, -1)
            if normal.Label and normal.Label.SetFontObject then
                normal.Label:SetFontObject("GameFontNormalSmall")
            end

            local uninterruptible = CreateModeCheck(holder, "Test Unterruptable Castbar")
            uninterruptible:SetSize(18, 18)
            uninterruptible:ClearAllPoints()
            uninterruptible:SetPoint("TOPLEFT", normal, "BOTTOMLEFT", 0, 1)
            if uninterruptible.Label and uninterruptible.Label.SetFontObject then
                uninterruptible.Label:SetFontObject("GameFontNormalSmall")
            end

            controls[kind] = {
                holder = holder,
                normal = normal,
                uninterruptible = uninterruptible,
            }

            normal:SetScript("OnClick", function(self)
                if self:GetChecked() then
                    SetMode(kind, MODES.NORMAL)
                else
                    SetMode(kind, nil)
                end
            end)

            uninterruptible:SetScript("OnClick", function(self)
                if self:GetChecked() then
                    SetMode(kind, MODES.UNINTERRUPTIBLE)
                else
                    SetMode(kind, nil)
                end
            end)

            AddTooltip(
                normal,
                title .. " regular castbar test",
                "Preview this castbar using the regular interruptible appearance."
            )
            AddTooltip(
                uninterruptible,
                title .. " unterruptable castbar test",
                "Preview this castbar using the shielded uninterruptible appearance."
            )
        end

        local function AttachInlineControls()
            if controls.inlineAttached then return end
            if not BetterBlizzFrames or not BetterBlizzFrames.guiLoaded then return end

            local contentFrame = FindCastbarContentFrame()
            if not contentFrame then
                C_Timer.After(0.10, AttachInlineControls)
                return
            end

            local resets = GetResetButtons(contentFrame)
            if not resets then
                -- Hidden Settings categories can take a frame before their geometry is
                -- available. Retry instead of guessing coordinates.
                C_Timer.After(0.10, AttachInlineControls)
                return
            end

            HideLegacyTestCheckboxes(contentFrame)
            MakeRoomForInlineTests(contentFrame, resets)

            CreateInlineTestPair(contentFrame, resets.player, "player", "Player")
            CreateInlineTestPair(contentFrame, resets.party,  "party",  "Party")
            CreateInlineTestPair(contentFrame, resets.target, "target", "Target")
            CreateInlineTestPair(contentFrame, resets.focus,  "focus",  "Focus")
            CreateInlineTestPair(contentFrame, resets.pet,    "pet",    "Pet")

            controls.inlineAttached = true

            if SettingsPanel and not settingsHooked then
                SettingsPanel:HookScript("OnHide", function()
                    StopAllTests()
                end)
                settingsHooked = true
            end
        end

        local function HookInlineControls()
            if BBF.LoadGUI and hooksecurefunc and not guiHooked then
                hooksecurefunc(BBF, "LoadGUI", function()
                    C_Timer.After(0, AttachInlineControls)
                end)
                guiHooked = true
            end

            if BetterBlizzFrames and BetterBlizzFrames.guiLoaded then
                C_Timer.After(0, AttachInlineControls)
            end
        end

        local inlineInit = CreateFrame("Frame")
        inlineInit:RegisterEvent("PLAYER_LOGIN")
        inlineInit:SetScript("OnEvent", function(self)
            self:UnregisterAllEvents()
            HookInlineControls()
        end)

        -- castbar.lua loads before GUI/core files in the MoP TOC. This deferred call
        -- catches the common case; PLAYER_LOGIN above is the safe fallback.
        C_Timer.After(0, HookInlineControls)

        BBF.StopIndividualCastbarTests = StopAllTests
    end

    InitializeBBFCastbarPreviews()
end


-- ============================================================================
-- MoP uninterruptible castbar shield alignment
-- Integrated here so BetterBlizzFrames_Mists.toc needs no custom module files.
-- ============================================================================
do
    local function InitializeBBFShieldAlignment()
        -- BetterBlizzFrames MoP
        -- Safe uninterruptible castbar shield-art fix.
        --
        -- Integrated with the individual castbar previews below in this module.
        --
        -- Why this exists:
        -- Blizzard's legacy BorderShield texture contains BOTH:
        --   1) the decorative shield on the left
        --   2) the gray uninterruptible border around the castbar
        --
        -- BBF correctly resizes BorderShield with the castbar, but that also stretches
        -- the decorative shield.  This file leaves BorderShield's geometry completely
        -- alone and renders two visual copies instead:
        --
        --   * borderCopy: gray border only, using BBF's current BorderShield geometry
        --   * shieldCopy: Blizzard Arena-Shield art, anchored/scaled to the spell icon
        --
        -- The original BorderShield region is only made transparent; its size, points,
        -- show/hide state, and test behavior remain untouched.

        local CastingBarFrame = _G.CastingBarFrame or _G.PlayerCastingBarFrame

        local SHIELD_SOURCE_WIDTH = 256
        local SHIELD_SOURCE_ART_WIDTH = 36
        local SHIELD_U = SHIELD_SOURCE_ART_WIDTH / SHIELD_SOURCE_WIDTH

        -- ClassicCastbars uses Blizzard's dedicated arena shield art for the icon.
        -- Keep that separate from BorderShield so castbar width/height never distort it.
        local ICON_SHIELD_TEXTURE = "Interface\\CastingBar\\UI-CastingBar-Arena-Shield"

        local updateFrame = CreateFrame("Frame")
        local elapsedSinceUpdate = 0
        local failed = false

        local function GetBarName(bar)
            if bar and bar.GetName then
                return bar:GetName()
            end
        end

        local function IsPartyBarName(name)
            return name
                and (
                    name:match("^Party%d+SpellBar$")
                    or name:match("^BBFPartyCastbarPreview%d+$")
                )
        end

        local function GetShowBorderSetting(bar)
            local db = BetterBlizzFramesDB
            if not db then return true end

            local name = GetBarName(bar)

            if bar == CastingBarFrame or name == "BBFPlayerCastbarPreview" then
                return db.playerCastBarShowBorder ~= false
            end

            if bar == _G.TargetFrameSpellBar or name == "BBFTargetCastbarPreview" then
                return db.targetCastBarShowBorder ~= false
            end

            if bar == _G.FocusFrameSpellBar or name == "BBFFocusCastbarPreview" then
                return db.focusCastBarShowBorder ~= false
            end

            if bar == _G.PetSpellBar or name == "BBFPetCastbarPreview" then
                return db.petCastBarShowBorder ~= false
            end

            if IsPartyBarName(name) then
                return db.partyCastbarShowBorder ~= false
            end

            return true
        end

        local function CopyVertexColor(fromTexture, toTexture)
            if not fromTexture or not toTexture then return end
            if not fromTexture.GetVertexColor or not toTexture.SetVertexColor then return end

            local r, g, b, a = fromTexture:GetVertexColor()
            if r then
                toTexture:SetVertexColor(r, g, b, a or 1)
            end
        end

        local function EnsureCopies(bar)
            if not bar or not bar.BorderShield or not bar.Icon then
                return false
            end

            if not bar.BBFShieldBorderCopy then
                local borderCopy = bar:CreateTexture(nil, "OVERLAY")
                borderCopy:SetDrawLayer("OVERLAY", 5)
                borderCopy:Hide()
                bar.BBFShieldBorderCopy = borderCopy
            end

            if not bar.BBFShieldArtCopy then
                local shieldCopy = bar:CreateTexture(nil, "OVERLAY")
                shieldCopy:SetDrawLayer("OVERLAY", 6)
                shieldCopy:SetTexture(ICON_SHIELD_TEXTURE)
                shieldCopy:Hide()
                bar.BBFShieldArtCopy = shieldCopy
            end

            -- Valid WoW draw sublevels only: gray border < shield < spell icon.
            if bar.Icon.SetDrawLayer then
                bar.Icon:SetDrawLayer("OVERLAY", 7)
            end

            return true
        end

        local function UpdateOneBar(bar)
            if not EnsureCopies(bar) then return end

            local original = bar.BorderShield
            local borderCopy = bar.BBFShieldBorderCopy
            local shieldCopy = bar.BBFShieldArtCopy
            local icon = bar.Icon

            -- Reuse exactly the texture Blizzard/BBF currently has on BorderShield.
            local texture = original.GetTexture and original:GetTexture()
            if not texture then
                borderCopy:Hide()
                shieldCopy:Hide()
                return
            end

            borderCopy:SetTexture(texture)
            shieldCopy:SetTexture(ICON_SHIELD_TEXTURE)

            -- The original continues to own all sizing/show/hide behavior.
            -- We only make its combined artwork invisible.
            original:SetAlpha(0)

            local show = original:IsShown() and GetShowBorderSetting(bar)
            if not show then
                borderCopy:Hide()
                shieldCopy:Hide()
                return
            end

            -- Mirror BBF's current BorderShield geometry without modifying it.
            local width = original:GetWidth()
            local height = original:GetHeight()
            local point, relativeTo, relativePoint, xOffset, yOffset = original:GetPoint(1)

            if not width or width <= 0 or not height or height <= 0 or not point then
                borderCopy:Hide()
                shieldCopy:Hide()
                return
            end

            -- Remove the source texture's left 36px shield section from the gray-border
            -- copy while preserving the remaining source pixels at the same screen scale.
            local removedScreenWidth = width * SHIELD_U
            local borderWidth = width - removedScreenWidth

            borderCopy:ClearAllPoints()
            borderCopy:SetPoint(
                point,
                relativeTo,
                relativePoint,
                (xOffset or 0) + (removedScreenWidth / 2),
                yOffset or 0
            )
            borderCopy:SetSize(borderWidth, height)
            borderCopy:SetTexCoord(SHIELD_U, 1, 0, 1)
            CopyVertexColor(original, borderCopy)
            borderCopy:SetAlpha(1)
            borderCopy:Show()

            -- Decorative shield is independent from castbar width/height.
            -- Match ClassicCastbars' proven Blizzard Arena-Shield geometry:
            --   size = 3x the displayed icon size
            --   left edge = 0.44 icon widths left of the icon's left edge
            -- This makes the visible shield slightly larger and visually centered
            -- around the spell icon while still following Icon Size and icon X/Y.
            local iconScale = icon:GetScale() or 1
            local iconWidth = icon:GetWidth() or 22
            local displayedIconSize = iconWidth * iconScale

            shieldCopy:ClearAllPoints()
            shieldCopy:SetPoint("LEFT", icon, "LEFT", -0.44 * displayedIconSize, -0.5)
            shieldCopy:SetSize(displayedIconSize * 3, displayedIconSize * 3)
            shieldCopy:SetTexCoord(0, 1, 0, 1)
            CopyVertexColor(original, shieldCopy)
            shieldCopy:SetAlpha(1)
            shieldCopy:Show()

            -- Keep the icon above the shield; 7 is the highest valid overlay sublevel.
            icon:SetDrawLayer("OVERLAY", 7)
        end

        local function UpdateAllBars()
            UpdateOneBar(CastingBarFrame)
            UpdateOneBar(_G.TargetFrameSpellBar)
            UpdateOneBar(_G.FocusFrameSpellBar)
            UpdateOneBar(_G.PetSpellBar)

            for i = 1, 5 do
                UpdateOneBar(_G["Party" .. i .. "SpellBar"])
            end

            -- The individual-test bars are created lazily by the integrated test code.
            UpdateOneBar(_G.BBFPlayerCastbarPreview)
            UpdateOneBar(_G.BBFTargetCastbarPreview)
            UpdateOneBar(_G.BBFFocusCastbarPreview)
            UpdateOneBar(_G.BBFPetCastbarPreview)

            for i = 1, 5 do
                UpdateOneBar(_G["BBFPartyCastbarPreview" .. i])
            end
        end

        -- One centralized, throttled updater.
        -- No hooksecurefunc(CreateFrame), no per-castbar OnUpdate hooks, and no mutation
        -- of BorderShield size/anchors.  This avoids fighting the integrated test code.
        updateFrame:SetScript("OnUpdate", function(_, elapsed)
            if failed then return end

            elapsedSinceUpdate = elapsedSinceUpdate + elapsed
            if elapsedSinceUpdate < 0.10 then
                return
            end
            elapsedSinceUpdate = 0

            -- Fail closed: if Blizzard changes an API unexpectedly, disable only this
            -- cosmetic fix instead of generating an error every frame.
            local ok = pcall(UpdateAllBars)
            if not ok then
                failed = true
                updateFrame:SetScript("OnUpdate", nil)
            end
        end)

        -- Apply immediately to bars that already exist.
        pcall(UpdateAllBars)
    end

    InitializeBBFShieldAlignment()
end
