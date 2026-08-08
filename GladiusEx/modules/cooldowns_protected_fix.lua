local GladiusEx = _G.GladiusEx
if not GladiusEx then
    return
end

local Cooldowns = GladiusEx:GetModule("Cooldowns", true)
if not Cooldowns or Cooldowns.__ProtectedVisibilityFix then
    return
end

local CT = LibStub("LibCooldownTracker-1.0")
local InCombatLockdown = InCombatLockdown

-- Keep this state local to the replacement Show/Reset implementations.
-- This mirrors cooldowns.lua without relying on its private local table.
local ct_registered = {}

local function QueueDeferredUpdate()
    if GladiusEx.QueueUpdate then
        GladiusEx:QueueUpdate()
    end
end

local function SetFrameShownSafely(frame, shown)
    if not frame or frame:IsShown() == shown then
        return
    end

    -- Cooldown groups are children of GladiusEx unit frames. Those unit frames
    -- own a SecureActionButtonTemplate, so Blizzard can protect the hierarchy
    -- during combat. Never attempt a forbidden visibility transition.
    if InCombatLockdown and InCombatLockdown() then
        local canChange = frame.CanChangeProtectedState and frame:CanChangeProtectedState()
        if not canChange then
            QueueDeferredUpdate()
            return
        end
    end

    if shown then
        frame:Show()
    else
        frame:Hide()
    end
end

-- Replacement for modules/cooldowns.lua:Show().
-- Registration behavior is preserved; only the protected Show() transition is
-- guarded/deferred.
function Cooldowns:Show(unit)
    for group = 1, self:GetNumGroups(unit) do
        local gs = self:GetGroupState(unit, group)
        local db = self:GetGroupDB(unit, group)

        if not ct_registered[unit] then
            CT:RegisterUnit(unit)
            ct_registered[unit] = true
        end

        if gs.frame and (not db.cooldownsDetached or unit == "player" or unit == "arena1") then
            SetFrameShownSafely(gs.frame, true)
        end
    end
end

-- Replacement for modules/cooldowns.lua:Reset().
-- Tracking cleanup is preserved; only the protected Hide() transition is
-- guarded/deferred.
function Cooldowns:Reset(unit)
    for group = 1, self:GetNumGroups(unit) do
        local gs = self:GetGroupState(unit, group)
        local db = self:GetGroupDB(unit, group)

        if ct_registered[unit] then
            CT:UnregisterUnit(unit)
            ct_registered[unit] = false
        end

        if db.cooldownsDetached then
            local headerUnit = GladiusEx:IsPartyUnit(unit) and "player" or "arena1"
            local header_gs = self:GetGroupState(headerUnit, group)
            if header_gs.unit_spells then
                local index = GladiusEx:GetUnitIndex(unit)
                header_gs.unit_spells[index] = nil
            end
        end

        if gs.frame then
            SetFrameShownSafely(gs.frame, false)
        end
    end
end

Cooldowns.__ProtectedVisibilityFix = true
