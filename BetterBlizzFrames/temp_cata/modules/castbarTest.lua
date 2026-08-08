local L = BBF.L

-- BetterBlizzFrames MoP: independent normal / uninterruptible castbar previews.
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

    bar.TestTimer:ClearAllPoints()
    if db.playerCastBarTimerCentered then
        bar.TestTimer:SetPoint("BOTTOM", bar, "TOP", 0, 6)
    else
        bar.TestTimer:SetPoint("LEFT", bar, "RIGHT", 3, 2)
    end
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

    bar.TestTimer:ClearAllPoints()
    bar.TestTimer:SetPoint("LEFT", bar, "RIGHT", 3, -1)
    RegionSetShown(bar.TestTimer, db[prefix .. "CastBarTimer"] and true or false)

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

            bar.TestTimer:ClearAllPoints()
            bar.TestTimer:SetPoint("LEFT", bar, "RIGHT", 5, 0)
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

        bar.TestTimer:ClearAllPoints()
        bar.TestTimer:SetPoint("LEFT", bar, "RIGHT", 5, 0)
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

    bar.TestTimer:ClearAllPoints()
    bar.TestTimer:SetPoint("LEFT", bar, "RIGHT", 3, 0)
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

local function CreateTestRow(parent, kind, label, y)
    local rowLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rowLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, y)
    rowLabel:SetWidth(58)
    rowLabel:SetJustifyH("LEFT")
    rowLabel:SetText(label)

    local normal = CreateModeCheck(parent, "Normal")
    normal:SetPoint("LEFT", rowLabel, "RIGHT", 2, 0)

    local uninterruptible = CreateModeCheck(parent, "Uninterruptible")
    uninterruptible:SetPoint("LEFT", normal.Label, "RIGHT", 12, 0)

    controls[kind] = {
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
        label .. " castbar test",
        "Shows only this castbar type with the normal interruptible appearance."
    )

    AddTooltip(
        uninterruptible,
        label .. " uninterruptible test",
        "Shows only this castbar type with the shielded non-interruptible appearance."
    )
end

local function CreateTestWindow()
    if controls.window then
        return controls.window
    end

    local frame = CreateFrame(
        "Frame",
        "BBFIndividualCastbarTestWindow",
        UIParent,
        BackdropTemplateMixin and "BackdropTemplate" or nil
    )
    frame:SetSize(330, 195)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    if frame.SetBackdrop then
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 24,
            insets = { left = 7, right = 7, top = 7, bottom = 7 },
        })
    end

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -13)
    title:SetText("Castbar Tests")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    close:SetScript("OnClick", function()
        StopAllTests()
        frame:Hide()
    end)

    CreateTestRow(frame, "player", "Player", -48)
    CreateTestRow(frame, "party", "Party", -75)
    CreateTestRow(frame, "target", "Target", -102)
    CreateTestRow(frame, "focus", "Focus", -129)
    CreateTestRow(frame, "pet", "Pet", -156)

    frame:Hide()
    controls.window = frame
    return frame
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

local function AttachLauncher()
    if controls.launcher then return end
    if not BetterBlizzFrames or not BetterBlizzFrames.guiLoaded then return end

    local contentFrame = FindCastbarContentFrame()
    if not contentFrame then
        C_Timer.After(0.10, AttachLauncher)
        return
    end

    local button = CreateFrame("Button", nil, contentFrame, "UIPanelButtonTemplate")
    button:SetSize(118, 22)
    button:SetText("Castbar Tests")

    -- The four top castbar boxes end around here; this sits in the gap before
    -- the lower pet/interrupt settings instead of covering any existing option.
    button:SetPoint("TOP", contentFrame, "TOP", 0, -414)

    button:SetScript("OnClick", function()
        local window = CreateTestWindow()
        if window:IsShown() then
            StopAllTests()
            window:Hide()
        else
            window:Show()
        end
    end)

    AddTooltip(
        button,
        "Individual castbar tests",
        "Test Player, Party, Target, Focus, or Pet independently. "
        .. "Each has separate Normal and Uninterruptible preview modes."
    )

    controls.launcher = button

    if SettingsPanel and not settingsHooked then
        SettingsPanel:HookScript("OnHide", function()
            StopAllTests()
            if controls.window then
                controls.window:Hide()
            end
        end)
        settingsHooked = true
    end
end

if BBF.LoadGUI and hooksecurefunc and not guiHooked then
    hooksecurefunc(BBF, "LoadGUI", function()
        C_Timer.After(0, AttachLauncher)
    end)
    guiHooked = true
end

-- If the GUI was already created before this module attached, add the launcher now.
C_Timer.After(0, AttachLauncher)

BBF.StopIndividualCastbarTests = StopAllTests
