-- BetterBlizzFrames MoP
-- Safe uninterruptible castbar shield-art fix.
--
-- castbarTest.lua is intentionally NOT modified.
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
        borderCopy:Hide()
        bar.BBFShieldBorderCopy = borderCopy
    end

    if not bar.BBFShieldArtCopy then
        -- ARTWORK keeps the decorative shield below the spell icon.
        local shieldCopy = bar:CreateTexture(nil, "ARTWORK")
        shieldCopy:SetTexture(ICON_SHIELD_TEXTURE)
        shieldCopy:Hide()
        bar.BBFShieldArtCopy = shieldCopy
    end

    -- Explicitly keep the icon above the decorative shield.
    if bar.Icon.SetDrawLayer then
        bar.Icon:SetDrawLayer("OVERLAY")
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
    shieldCopy:SetPoint("LEFT", icon, "LEFT", -0.44 * displayedIconSize, 0)
    shieldCopy:SetSize(displayedIconSize * 3, displayedIconSize * 3)
    shieldCopy:SetTexCoord(0, 1, 0, 1)
    CopyVertexColor(original, shieldCopy)
    shieldCopy:SetAlpha(1)
    shieldCopy:Show()

    -- Icon must stay in front of shield art.
    icon:SetDrawLayer("OVERLAY")
end

local function UpdateAllBars()
    UpdateOneBar(CastingBarFrame)
    UpdateOneBar(_G.TargetFrameSpellBar)
    UpdateOneBar(_G.FocusFrameSpellBar)
    UpdateOneBar(_G.PetSpellBar)

    for i = 1, 5 do
        UpdateOneBar(_G["Party" .. i .. "SpellBar"])
    end

    -- The individual-test bars are created lazily by the unchanged test module.
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
-- of BorderShield size/anchors.  This avoids fighting the existing test module.
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
